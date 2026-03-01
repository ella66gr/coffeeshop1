private import ScalarValues::*;
private import 

package CoffeeShop {

    doc /* A small independent coffee shop - 
           toy exercise for learning SysML v2 */

    // -- Enumerations -------------------------

    enum def DrinkSize {
        small;
        medium;
        large;
    }

    enum def MilkOption {
        whole;
        semi;
        oat;
        soy;
        almond;
        none;
    }
    
    enum def ItemCategory {
        hotDrink;
        coldDrink;
        food;
    }

    // -- Core domain definitions ---------------

    part def MenuItem {
        doc /* Something the shop sells */

        attribute name : String;
        attribute price : Real;                // ScalarValue::Real
        attribute category : ItemCategory;
        attribute isVegan : Boolean;
    }

    part def Drink :> MenuItem {
        doc /* A drink, extending MenuItem with drink-specific attributes */

        attribute size : DrinkSize;
        attribute milkChoice : MilkOption;
    }

    part def FoodItem :> MenuItem {
        doc /* A food item, extending MenuItem */

        attribute isGlutenFree : Boolean;
        attribute servedWarm : Boolean;
    }

    // -- People --------------------------------

    enum def StaffRole {
        barista;
        manager;
        kitchenStaff;
    }

    part def Person {
        doc /* A person who interacts with the coffee shop */

        attribute firstName : String;
        attribute lastName : String;
    }

    part def Customer :> Person {
        doc /* Someone who buys from the shop */

        attribute loyaltyPoints : Integer;
        attribute isMember : Boolean;
    }

    part def StaffMember :> Person {
        doc /* Someone who works in the shop */

        attribute role : StaffRole;
        attribute hoursPerWeek : Real;
    }

    // -- Orders ----------------------------------

    enum def OrderStatus {
        placed;
        inPreparation;
        ready;
        collected;
        cancelled;
    }

    part def OrderLine {
        doc /* A single line on an order - one item with its quantity */
        
        attribute quantity : Integer;
        ref item : MenuItem;
    }

    part def Order {
        doc /* A customer order, containing one or more order lines */

        attribute orderNumber : Integer;
        attribute status : OrderStatus;
        attribute totalPrice : Real;            // ScalarValue::Real

        ref customer : Customer;
        part lines : OrderLine[1..*];  // An order must have at least one line
    }
}