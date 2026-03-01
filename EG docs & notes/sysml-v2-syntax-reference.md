# SysML v2 Syntax Reference — Syside Modeler
## Verified Patterns from CoffeeShop Exercise (March 2026)

> **Purpose:** Capture working SysML v2 syntax as verified against Syside Modeler 0.8.4.
> This file should travel with the project repo and be consulted before writing new `.sysml` files.
> Update as new patterns are verified or corrected.

---

## Environment

- **Syside Modeler** 0.8.4 (VS Code extension)
- **SysML v2.0** (OMG ratified July 2025)
- **Standard library import:** `private import ScalarValues::*;` required at top of each package

---

## Phase 1: Structural Foundations ✅

### Working constructs

```sysml
package CoffeeShop {
    private import ScalarValues::*;

    doc /* Package-level documentation is valid here */

    // Enumerations
    enum def DrinkSize { small; medium; large; }

    // Part definitions (structural "nouns")
    part def MenuItem {
        attribute name : String;
        attribute price : Real;
    }

    // Specialisation (inheritance)
    part def Drink :> MenuItem {
        attribute size : DrinkSize;
    }

    // References vs composition
    part def Order {
        ref customer : Customer;          // reference (independent existence)
        part orderLines : OrderLine[1..*]; // composition (contained)
    }
}
```

### Key points
- `doc /* ... */` is valid inside `package`, `part def`, `action def`, `state def` bodies
- `:>` is specialisation (like inheritance)
- `ref` = reference to independent element; `part` = composition/containment
- `[1..*]` = multiplicity constraints
- Diagrams show `«variation»` for enum defs, `«part def»` for parts

---

## Phase 2: State Machines ✅

### Working constructs

```sysml
package OrderLifeCycle {
    private import ScalarValues::*;

    // Events as attribute definitions
    attribute def PreparationStarted;
    attribute def PreparationComplete;
    attribute def OrderCollected;
    attribute def CancellationRequested;

    state def OrderLifecycle {

        initial;          // ← standalone pseudostate (the black dot)
        state placed;     // ← first real state (separate declaration)

        state inPreparation;
        state ready;
        state collected;
        state cancelled;

        // Named transitions
        transition placed_to_inPreparation
            first placed
            accept PreparationStarted
            then inPreparation;

        transition inPreparation_to_ready
            first inPreparation
            accept PreparationComplete
            then ready;
    }
}
```

### Connecting to structural model

```sysml
// In the Order part def (coffeeshop.sysml):
private import OrderLifeCycle::*;

part def Order {
    // ... attributes ...
    exhibit state orderLifecycle : OrderLifecycle;
}
```

### ⚠️ Syntax traps

| What you might write | What Syside actually wants | Error |
|---|---|---|
| `entry state placed;` | `initial;` then `state placed;` | Parse error |
| `initial state placed;` | `initial;` then `state placed;` | Parse error |
| `entry; state placed;` | `initial;` then `state placed;` | Parse error |

**Rule:** `initial;` must be a standalone declaration. It is the pseudostate (entry arrow), not a modifier on a state.

---

## Phase 3: Action Flows ✅

### Working constructs

```sysml
package DrinkFulfilment {
    private import ScalarValues::*;
    private import CoffeeShop::*;

    action def FulfilDrink {
        in item orderLine : OrderLine;     // input parameter

        action receiveOrder;
        then checkDrinkType;               // chained from preceding action

        action checkDrinkType;
        then prepareHotBase;               // branch 1
        then prepareColdBase;              // branch 2

        action prepareHotBase;
        then assembleDrink;                // converge

        action prepareColdBase;
        then checkMilk;

        action checkMilk;
        then addMilk;
        then assembleDrink;

        action addMilk;
        then assembleDrink;

        action assembleDrink;
        then markReady;

        action markReady;
    }
}
```

### ⚠️ Syntax traps

| What you might write | What Syside actually wants | Error |
|---|---|---|
| `decide hotOrCold;` then reference in `succession` | Use `action` nodes for decisions | "No Feature named 'X' found" (reference-error) |
| `merge afterBasePrep;` then reference in `succession` | Use `then` chaining to converge | "No Feature named 'X' found" (reference-error) |
| `succession X then Y;` (standalone) | `then Y;` chained after action declaration | Reference error on source node |
| `X then Y;` (standalone, bare) | `then Y;` chained after action declaration | Reference error on source node |
| `then X if true then Y;` | Not supported; drop guards for now | Parse error |

**Rules:**
1. `then` must be **chained immediately after an action declaration** — it cannot be used as a standalone `source then target` statement
2. `decide` and `merge` control nodes are **not referenceable features** in successions — use regular `action` nodes as decision points instead
3. Multiple `then` lines after a single action create **branching** (multiple outgoing paths)
4. Multiple actions with `then` pointing to the same target create **convergence** (merge)
5. Guard conditions (`if`) on action flow branches: syntax TBD — not yet verified in Syside

---

## General Patterns

### Package structure
```sysml
package MyPackage {
    private import ScalarValues::*;
    private import OtherPackage::*;

    doc /* Package documentation */

    // declarations...
}
```

### Documentation
- `doc /* ... */` is valid inside any definition body (`package`, `part def`, `action def`, `state def`)
- It attaches to the enclosing element
- It is NOT an orphaned comment — ignore AI assistants that claim otherwise

### Diagram limitations (Syside 0.8.4)
- **Definition view** (structural/class-style) renders for all element types
- **State machine diagram** (rounded rectangles + arrows) not yet available
- **Action flow diagram** (activity diagram) not yet verified
- Tom Sawyer SysML v2 Viewer or Syside Cloud may offer better behavioural diagrams

---

## File / Repo Conventions

```
coffeeshop-exercise/
├── model/
│   └── domain/
│       ├── coffeeshop.sysml          # Phase 1: structural
│       ├── order-lifecycle.sysml      # Phase 2: state machine
│       └── drink-fulfilment.sysml     # Phase 3: action flow
├── generators/                        # Phase 5+: Python generation scripts
├── generated/                         # Output (consider gitignoring)
├── src/                               # Hand-written implementation
├── tests/
└── scripts/
```

### Git practices for model-driven development
- `.sysml` files are plain text — clean diffs, merge, blame all work
- **Atomic commits:** model change + regenerated scaffolding + implementation updates together
- **Generated code:** either gitignore (regenerate in CI) or commit with sync verification
- **Tagging:** semver tags where model + generators + implementation are known-good

---

## TODO: Patterns Not Yet Verified

- [ ] `decide` / `merge` control nodes — proper syntax for Syside
- [ ] Guard conditions on action flow transitions
- [ ] `fork` / `join` for parallel actions
- [ ] `requirement def` and `constraint def` (Phase 4)
- [ ] `satisfy` / `verify` relationships
- [ ] Port definitions and connections
- [ ] Syside Automator programmatic model access
