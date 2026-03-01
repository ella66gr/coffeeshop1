package BusinessRules {
    private import ScalarValues::*;
    private import CoffeeShop::*;

    doc /* Requirements and constraints governing CoffeeShop operations. */

    // -- Requirements -------------------------------------

    // Requirements don't contain computable logic themselves; they're the formal anchor for traceability. The actual logic is in the constraints below, but these requirements are what we would write in natural language and share with stakeholders to get agreement on what the system needs to do. Each requirement has a `subject` which indicates what part of the model it applies to - e.g. an Order, a Drink, or a StaffMember.

    requirement def LoyaltyDiscountRequired {
        doc /* Members of the loyalty scheme must receive
             * a minimum 10% discount on every order. */

        subject order : Order;
    }

    requirement def MinimumOrderSize {
        doc /* Orders must contain at least one item. */

        subject order : Order;
    }

    requirement def MaximumOrderSize {
        doc /* Orders must contain no more than 10 items
             * to avoid barista overload. */

        subject order : Order;
    }

    requirement def veganMilkDrinkRule {
        doc /* Any drink marked as vegan must not use
             * dairy milk — only oat, soy, or almond. */

        subject drink : Drink;
    }

    requirement def BaristaMinimumHours {
        doc /* Staff members in the barista role must be
             * contracted for at least 12 hours per week. */

        subject staff : StaffMember;
    }

    // -- Constraints ------------------------------------

    constraint def LoyaltyDiscountConstraint {
        doc /* Formalises the loyalty discount rule:
             * if the customer is a member, discount >= 10%. */

        in isMember : Boolean;
        in discount : Real;

        isMember implies discount >= 10.0
    }

    // constraint def declares an evaluable boolean rule. The in parameters define what data flows in for evaluation. The body is a boolean expression that must evaluate to true for the constraint to pass. These are the things that eventually become validation logic in your generated code — Pydantic validators, TypeScript type guards, database check constraints.

    // implies is a logical operator: "A implies B" means "if A is true, then B must also be true." If A is false, the constraint passes regardless. This is perfect for conditional rules like "if the customer is a member, then discount must be at least 10%."

    // The `in` parameters on constraints are deliberately decoupled from the part definitions. The constraint doesn't reach into an Order object directly — it takes isMember and discount as inputs. This keeps constraints reusable and testable in isolation. The binding of "which Order attribute maps to which constraint parameter" happens when you apply the constraint to a specific context.

    constraint def OrderSizeConstraint {
        doc /* Formalises the order size rules:
             * quantity of items must be between 1 and 10. */

        in lineCount : Integer;

        lineCount >= 1 and lineCount <= 10
    }

    constraint def VeganMilkConstraint {
        doc /* Formalises the vegan milk rule:
             * if the drink is vegan, milk choice must not be dairy. */

        in isVegan : Boolean;
        in milkChoice : MilkOption;

        isVegan implies (
            milkChoice == MilkOption::oat or
            milkChoice == MilkOption::soy or
            milkChoice == MilkOption::almond or
            milkChoice == MilkOption::none
        )

    }

    constraint def BaristaHoursConstraint {
        doc /* Baristas must work at least 12 hours per week. */

        in role : StaffRole;
        in hoursPerWeek : Real;

        role == StaffRole::barista implies hoursPerWeek >= 12  

    }
}