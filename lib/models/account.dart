import 'package:bank_account/models/transaction.dart';

class Account {
  int id;
  String accountNumber;
  int useId;
  double _balance = 0.0;
  Account({required this.id, required this.accountNumber, required this.useId});
  double get balance => _balance;
  List<Transaction> histories = [];
  set balance(double value) {
    if (value < 0) {
      // force error
      throw Exception('Balance cannot be negative');
    } else {
      _balance = value;
    }
  }

  void deposit(double amount) {
    if (amount <= 0) {
      throw ArgumentError("Deposit amount must be greater than zero.");
    }
    _balance += amount;
    histories.add(
      Transaction(
        id: histories.length + 1,
        accountNumber: accountNumber,
        amount: amount,
        type: 'Deposit',
        date: DateTime.now(),
      ),
    );
  }

  void withdraw(double amount) {
    if (amount <= 0) {
      throw ArgumentError("Withdrawal amount must be greater than zero.");
    }
    if (amount > _balance) {
      throw Exception("Insufficient funds for withdrawal.");
    }
    _balance -= amount;
    histories.add(
      Transaction(
        id: histories.length + 1,
        accountNumber: accountNumber,
        amount: amount,
        type: 'Withdrawal',
        date: DateTime.now(),
      ),
    );
  }

  // transfern
  void transfer(double amount, Account recipient) {
    if (amount <= 0) {
      throw ArgumentError("Transfer amount must be greater than zero.");
    }
    if (amount > _balance) {
      throw Exception("Insufficient funds for transfer.");
    }

    _balance -= amount;
    histories.add(
      Transaction(
        id: histories.length + 1,
        accountNumber: accountNumber,
        amount: amount,
        type: '\x1B[31mTransfer Out\x1B[0m',
        date: DateTime.now(),
      ),
    );

    recipient._balance += amount;
    recipient.histories.add(
      Transaction(
        id: recipient.histories.length + 1,
        accountNumber: recipient.accountNumber,
        amount: amount,
        type: '\x1B[32mTransfer In\x1B[0m',
        date: DateTime.now(),
      ),
    );
  }

  // transfer out
  void transferOut(double amount, Account recipient) {
    transfer(amount, recipient);
  }
}
