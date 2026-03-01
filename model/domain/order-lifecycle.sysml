package OrderLifeCycle {
    private import ScalarValues::*;

    doc /* State machine defining the lifecycle of a customer order,
         * from placement through to collection or cancellation.
         */

    // -- Events that drive transitions -------------------------

    attribute def OrderPlaced;
    attribute def PreparationStarted;
    attribute def PreparationComplete;
    attribute def OrderCollected;
    attribute def CancellationRequested;

    // -- The state machine -------------------------------------

    state def OrderLifecycle {
        doc /* Models the lifecycle of an Order through the shop. */
        
        initial;  // ← initial pseudostate
        
        state placed;
        state inPreparation;
        state ready;

        // -- Terminal states -----------
        state collected;
        state cancelled;

        // Transitions ------------------
        transition placed_to_inPreparation
            first placed
            accept PreparationStarted
            then inPreparation;

        transition inPreparation_to_ready
            first inPreparation
            accept PreparationComplete
            then ready;

        transition ready_to_collected
            first ready
            accept OrderCollected
            then collected;

        // -- Cancellation transitions ---

        transition placed_to_cancelled
            first placed
            accept CancellationRequested
            then cancelled;

        transition inPreparation_to_cancelled
            first inPreparation
            accept CancellationRequested
            then cancelled;

    }
}