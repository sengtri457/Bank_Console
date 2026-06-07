## 2.0.0

- Added PIN field to User model for transaction authorization
- Added PIN verification before all banking operations (3 attempts per operation)
- Added login attempt counter: max 3 failed attempts with 5-second cooldown
- Added color-coded console output (green/red/yellow)
- Allowed transfers between own accounts (previously blocked)
- Blocked self-transfers (same source and destination account)
- Fixed recursive `main()` call on logout — now uses proper loop
- Fixed switch case fall-through bugs in menu
- Fixed UI typos (Similation → Simulation, Desposit → Deposit, CheckHistory → Transaction History)
- Refactored functions to use explicit parameters instead of closure variables

## 1.0.0

- Initial version with login, balance check, deposit, withdraw, transfer, and transaction history
