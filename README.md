# CRDT Last writer wins data structure

## Implemented

- Generic CRDT data structure with last writer wins implementation based on Swift Dictionary
- Tests for the data structure
  - commutativity of merge
  - associativity of merge
  - idempotancy of merge

Notes:

- Timestamp considered unique in this implementation, so two structures with the same timestamp and key would not be commutative 


## To run

Run a project with cmd+R. Playground-based test suite will run before the actual application for convenience
