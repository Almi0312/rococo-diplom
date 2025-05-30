package minaev.qa.rococo.model;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import minaev.qa.rococo.service.EqualPasswordsValidator;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = {EqualPasswordsValidator.class})
public @interface EqualPasswords {
    String message() default "Passwords should be equal";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
