package DrinkFulfilment {
    private import ScalarValues::*;
    private import CoffeeShop::*;

    doc /* Action flow modelling the process of fulfilling a drink order */

    // -- The fulfilment process -------------------------------------

    action def FulfilDrink {
        doc /* The end-to-end process a barista follows to make a drink. */

        in item orderLine : OrderLine; // This is a parameter declaration - the action takes an OrderLine as input, which contains details of the drink to be made. The `in` keyword indicates that this is an input parameter and it flows into the action from outside. (You can also have `out` parameters that flow out of the action, and `inout` parameters that flow both in and out.) The `item` specifically indicates this is a discrete thing being passed in - a physical or logical item - as opposed to a continuous flow or stream of data - items and streams are handled differently in SysML.

        action receiveOrder; // Each `action receiveOrder;` or `action checkDrinkType;` etc. is a step in the process (usage inside the action defnition, just like `part` inside `part def`), and the `then` keyword indicates the sequence of steps. The names of the actions should be descriptive of what happens in that step.
        then checkDrinkType;

        action checkDrinkType;
        then prepareHotBase;
        then prepareColdBase; // This is a branch (divergence) point - using multiple `then` statements from the same action indicates that there are multiple paths through the process. In a more detailed model, we'd have guards on these paths to indicate which conditions lead to which path being taken - e.g. `then prepareHotBase if orderLine.drinkType == hotDrink` - but for this exercise we've kept it simple.

        action prepareHotBase {
            doc /* Pull espresso shot or brew tea. */
        } // Some of our actions have doc blocks (like prepareHotBase and assembleDrink) and some don't (like receiveOrder and markReady). In a more detailed model, each of these could themselves be full action def definitions with their own sub-steps — actions nest just like parts do. For this exercise, we've kept them as simple leaf actions.
        then assembleDrink; // `then` - implicit succession between steps. The default is that all steps are sequential, but you can also have parallel steps (using `and` instead of `then`) or alternative paths (using `or` and guards). `Then` is like an arrow on a flowchart. A critical thing we learned from debugging: `then` attaches to the action immediately above it in the text. It's not a standalone statement — you can't put it somewhere else in the file and have it reference back. The chaining is positional.

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

        // Multiple actions with `then` pointing to the same target create convergence — the equivalent of a merge node. Both prepareHotBase and addMilk (and checkMilk via its second branch) can lead to assembleDrink. The model is saying "assembleDrink happens once any of its incoming paths completes."

        action assembleDrink {
            doc /* Combine the base and milk (if needed), add any extras
                  (lid, sleeve, straw etc.), and finish the drink */
        }
        then markReady;

        action markReady;
    }
    
}

// The state machine in Phase 2 is reactive — it sits and waits for events (accept PreparationStarted) and responds by transitioning. The action flow in Phase 3 (this file) is procedural — it describes a sequence of steps that execute in order, with branching and convergence. In the real system, these two interact: the action flow for fulfilling a drink would trigger the events that cause the order's state machine to transition. When the barista starts prepareHotBase, that action would emit a PreparationStarted event, causing the Order lifecycle to transition from placed to inPreparation. 
