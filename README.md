# Bank Simulation Console Application

A Dart console application that simulates a simple banking system with user authentication, account management, and transaction capabilities.

## Features

* **User Login** — Secure login with username and password (max 3 attempts)
* **PIN Verification** — PIN required before every banking operation (3 attempts per operation)
* **Check Balance** — View account balances in a formatted table
* **Deposit** — Add funds to any of your accounts
* **Withdraw** — Withdraw funds with insufficient funds protection
* **Transfer** — Transfer money between accounts (own accounts or other users)
* **Transaction History** — View deposit, withdrawal, and transfer history with timestamps
* **Logout** — Return to login screen securely

## Validation Rules

| Operation         | Rule                                                                                      |
| ----------------- | ----------------------------------------------------------------------------------------- |
| Login             | Max 3 failed attempts, then 5-second cooldown                                             |
| PIN               | Max 3 failed attempts per operation                                                       |
| Deposit           | Amount must be > 0                                                                        |
| Withdraw          | Amount must be > 0 and ≤ current balance                                                  |
| Transfer          | Amount must be > 0 and ≤ balance; destination must exist; cannot transfer to same account |
| Account selection | Must select a valid account number from the list                                          |

## Getting Started

### Prerequisites

* [Dart SDK](https://dart.dev/get-dart) ^3.11.4

### Run the Application

```Shell
dart run
```

Or directly:

```Shell
dart run bin/bank_account.dart
```

### Run Tests

```Shell
dart test
```

### Analyze Code

```Shell
dart analyze
```

## Usage Guide

### Login Credentials

| Username      | Password      | PIN    |
| ------------- | ------------- | ------ |
| `Bun_sengtri` | `password123` | `1234` |
| `jane_doe`    | `password456` | `5678` |

### Menu Options

1. **Check Balance** — Enter PIN, select account, view current balance
2. **Deposit** — Enter PIN, select account, enter deposit amount
3. **Withdraw** — Enter PIN, select account, enter withdrawal amount
4. **Transfer** — Enter PIN, select source account, enter recipient account number, enter amount
5. **Transaction History** — Enter PIN, select account, view all transactions
6. **Logout** — Return to login screen

## Project Structure

```
bank_account/
├── bin/
│   └── bank_account.dart       # Entry point — console UI and user interaction
├── lib/
│   ├── bank_account.dart        # Library entry (utility)
│   ├── helpers/
│   │   └── tables_view.dart     # Table formatting utility
│   ├── models/
│   │   ├── account.dart         # Account model with deposit/withdraw/transfer logic
│   │   ├── transaction.dart     # Transaction model
│   │   └── user.dart            # User model
│   └── services/
│       ├── account_service.dart # Account data and lookup operations
│       └── auth_service.dart    # Authentication and PIN verification
├── test/
│   └── bank_account_test.dart   # Unit tests
├── pubspec.yaml                 # Dependencies and configuration
└── README.md                    # This file
```

## Console Color Guide

| Color  | Meaning                                                 |
| ------ | ------------------------------------------------------- |
| Green  | Success messages (login, deposit, transfer, logout)     |
| Red    | Error messages (invalid input, failed auth, exceptions) |
| Yellow | Warning / informational messages                        |

## Dependencies

* [intl](https://pub.dev/packages/intl) ^0.20.2 — Date formatting for transaction history
* [path](https://pub.dev/packages/path) ^1.9.0 — Path manipulation
* [test](https://pub.dev/packages/test) ^1.25.6 (dev) — Unit testing

