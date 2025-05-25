!/bin/bash
#before create volume rococo_pgdata
#after enter script for run:
# chmod +x dockerLocalStart.sh
# ./dockerLocalStart.sh

#Also need add on edit configuration for spring services in VM option:
# -Dspring.profiles.active=local

POSTGRES_IMAGE="postgres:15.1"

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Create databases
docker pull $POSTGRES_IMAGE
docker run --name rococo-all -p 5432:5432 -e POSTGRES_PASSWORD=rocSecret -e CREATE_DATABASES="rococo-auth,rococo-museum,rococo-painting,rococo-artist" -e TZ=GMT+3 -e PGTZ=GMT+3 -v rococo_pgdata:/var/lib/postgresql/data -v "/$(pwd -W)/postgres/script:/docker-entrypoint-initdb.d" -d $POSTGRES_IMAGE --max_prepared_transactions=100
# script check create database in docker container -> Exec:
# psql -U postgres -c "\l"
sleep 10s

docker run --name=zookeeper -e ZOOKEEPER_CLIENT_PORT=2181 -p 2181:2181 -d confluentinc/cp-zookeeper:7.3.2

docker run --name=kafka -e KAFKA_BROKER_ID=1 \
-e KAFKA_ZOOKEEPER_CONNECT=$(docker inspect zookeeper --format='{{ .NetworkSettings.IPAddress }}'):2181 \
-e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 \
-e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
-e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
-e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
-p 9092:9092 -d confluentinc/cp-kafka:7.3.2