package DrinkFulfilment {
    private import ScalarValues::*;
    private import CoffeeShop::*;

    doc /* Action flow modelling the process of fulfilling a drink order */

    // -- The fulfilment process -------------------------------------

    action def FulfilDrink {
        doc /* The end-to-end process a barista follows to make a drink. */

        in item orderLine : OrderLine;

        action receiveOrder;
        then checkDrinkType;

        action checkDrinkType;
        then prepareHotBase;
        then prepareColdBase;

        action prepareHotBase {
            doc /* Pull espresso shot or brew tea. */
        }
        then assembleDrink;

        action prepareColdBase {
            doc /* Blend or mix iced drink base. */
        }
        then checkMilk;

        action checkMilk;
        then addMilk;
        then assembleDrink;

        action addMilk {
            doc /* Steam or pour milk according to milkChoice. */
        }
        then assembleDrink;

        action assembleDrink {
            doc /* Combine the base and milk (if needed), add any extras
                  (lid, sleeve, straw etc.), and finish the drink */
        }
        then markReady;

        action markReady;
    }
    
}