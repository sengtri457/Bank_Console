import 'dart:io';
import 'package:bank_account/helpers/tables_view.dart';
import 'package:bank_account/models/account.dart';
import 'package:bank_account/models/user.dart';
import 'package:bank_account/services/account_service.dart';
import 'package:bank_account/services/auth_service.dart';
import 'package:intl/intl.dart';

String _red(String text) => '\x1B[31m$text\x1B[0m';
String _green(String text) => '\x1B[32m$text\x1B[0m';
String _yellow(String text) => '\x1B[33m$text\x1B[0m';

void main(List<String> arguments) {
  final AuthService authService = AuthService();
  final AccountService accountService = AccountService();
  final TableView tableView = TableView();

  while (true) {
    print('');
    print(
      '=============================== Bank Simulation ===============================',
    );
    print('1. Login');
    print('2. Exit');
    stdout.write('Enter your choice: ');
    final String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        _handleLogin(authService, accountService, tableView);
      case '2':
        print(_yellow('Goodbye!'));
        exit(0);
      default:
        print(_red('Invalid choice. Please enter 1 or 2.'));
    }
  }
}

void _handleLogin(
  AuthService authService,
  AccountService accountService,
  TableView tableView,
) {
  const int maxAttempts = 3;
  int attempts = 0;

  while (attempts < maxAttempts) {
    attempts++;
    print('');
    print('Login to your account');
    print('===============================');
    stdout.write('Enter username: ');
    final String? username = stdin.readLineSync();
    if (username == null || username.isEmpty) {
      print(_red('Username cannot be empty.'));
      attempts--;
      continue;
    }

    stdout.write('Enter password: ');
    final String? password = stdin.readLineSync();
    if (password == null || password.isEmpty) {
      print(_red('Password cannot be empty.'));
      attempts--;
      continue;
    }

    final User? user = authService.login(
      username: username,
      password: password,
    );

    if (user != null) {
      print(_green('Login successful! Welcome, ${user.username}.'));
      _showMenu(user, accountService, tableView, authService);
      return;
    } else {
      final remaining = maxAttempts - attempts;
      if (remaining > 0) {
        print(
          _red(
            'Invalid credentials! You have $remaining attempt(s) remaining.',
          ),
        );
      } else {
        print(
          _yellow(
            'Too many failed attempts. Please wait 5 seconds to try again.',
          ),
        );
        sleep(const Duration(seconds: 5));
      }
    }
  }
}

bool _verifyPin(User user, AuthService authService) {
  for (int i = 0; i < 3; i++) {
    stdout.write('Enter your PIN: ');
    final String? pin = stdin.readLineSync();
    if (pin == null || pin.isEmpty) {
      print(_red('PIN cannot be empty.'));
      continue;
    }
    if (authService.verifyPin(user, pin)) {
      return true;
    } else {
      final remaining = 2 - i;
      if (remaining > 0) {
        print(_red('Incorrect PIN. You have $remaining attempt(s) remaining.'));
      } else {
        print(_red('Incorrect PIN. Access denied.'));
      }
    }
  }
  return false;
}

void _showMenu(
  User user,
  AccountService accountService,
  TableView tableView,
  AuthService authService,
) {
  while (true) {
    final List<Account> accounts = accountService.getUserAccountsById(user.id);
    print('');
    print(
      '=============================== Bank Simulation ===============================',
    );
    print('1. Check Balance');
    print('2. Deposit');
    print('3. Withdraw');
    print('4. Transfer');
    print('5. Transaction History');
    print('6. Logout');
    stdout.write('Enter your choice: ');
    final String? choice = stdin.readLineSync();

    if (choice == null) {
      print(_red('Invalid choice.'));
      continue;
    }

    switch (choice) {
      case '1':
        if (_verifyPin(user, authService)) {
          _checkBalance(user.id, accounts, accountService, tableView);
        }
        break;
      case '2':
        if (_verifyPin(user, authService)) {
          _depositAccount(user.id, accounts, accountService, tableView);
        }
        break;
      case '3':
        if (_verifyPin(user, authService)) {
          _withdrawAccount(user.id, accounts, accountService, tableView);
        }
        break;
      case '4':
        if (_verifyPin(user, authService)) {
          _transferAccount(user.id, accounts, accountService, tableView);
        }
        break;
      case '5':
        if (_verifyPin(user, authService)) {
          _checkHistory(user.id, accounts, accountService, tableView);
        }
        break;
      case '6':
        print(_green('Logout successful!'));
        return;
      default:
        print(_red('Invalid choice. Please enter a number between 1 and 6.'));
    }
  }
}

void _displayAccounts(List<Account> accounts, TableView tableView) {
  final headers = ['#', 'Account Number'];
  final List<List<String>> rows = [];
  for (var i = 0; i < accounts.length; i++) {
    rows.add(['${i + 1}', accounts[i].accountNumber]);
  }
  tableView.displayTable(headers, rows, numericColumns: [true, false]);
}

int _selectAccount(List<Account> accounts) {
  while (true) {
    stdout.write('Enter account number: ');
    final int? accountNumber = int.tryParse(stdin.readLineSync() ?? '');
    if (accountNumber == null ||
        accountNumber <= 0 ||
        accountNumber > accounts.length) {
      print(_red('Invalid account number. Please enter a valid number.'));
      continue;
    }
    return accountNumber;
  }
}

void _checkBalance(
  int userId,
  List<Account> accounts,
  AccountService accountService,
  TableView tableView,
) {
  _displayAccounts(accounts, tableView);
  final int accountNumber = _selectAccount(accounts);
  final Account account = accountService.getAccountByIndex(
    accountNumber - 1,
    userId,
  );
  final headers = ['#', 'Account Number', 'Balance'];
  final List<List<String>> rows = [];
  rows.add([
    accountNumber.toString(),
    account.accountNumber,
    '\$${account.balance.toStringAsFixed(2)}',
  ]);
  tableView.displayTable(headers, rows, numericColumns: [true, false, true]);
}

void _depositAccount(
  int userId,
  List<Account> accounts,
  AccountService accountService,
  TableView tableView,
) {
  _displayAccounts(accounts, tableView);
  while (true) {
    final int accountNumber = _selectAccount(accounts);
    stdout.write('Enter amount to deposit: \$');
    final double? amount = double.tryParse(stdin.readLineSync() ?? '');
    if (amount == null || amount <= 0) {
      print(_red('Invalid amount. Please enter a positive number.'));
      continue;
    }
    try {
      final Account account = accountService.getAccountByIndex(
        accountNumber - 1,
        userId,
      );
      account.deposit(amount);
      print(
        _green(
          'Deposit successful! New balance: \$${account.balance.toStringAsFixed(2)}',
        ),
      );
    } catch (e) {
      print(_red('Error: $e'));
    }
    break;
  }
}

void _withdrawAccount(
  int userId,
  List<Account> accounts,
  AccountService accountService,
  TableView tableView,
) {
  _displayAccounts(accounts, tableView);
  while (true) {
    final int accountNumber = _selectAccount(accounts);
    stdout.write('Enter amount to withdraw: \$');
    final double? amount = double.tryParse(stdin.readLineSync() ?? '');
    if (amount == null || amount <= 0) {
      print(_red('Invalid amount. Please enter a positive number.'));
      continue;
    }
    try {
      final Account account = accountService.getAccountByIndex(
        accountNumber - 1,
        userId,
      );
      account.withdraw(amount);
      print(
        _green(
          'Withdrawal successful! New balance: \$${account.balance.toStringAsFixed(2)}',
        ),
      );
    } catch (e) {
      print(_red('Error: $e'));
    }
    break;
  }
}

void _transferAccount(
  int userId,
  List<Account> accounts,
  AccountService accountService,
  TableView tableView,
) {
  _displayAccounts(accounts, tableView);
  final int accountNumber = _selectAccount(accounts);
  final Account account = accountService.getAccountByIndex(
    accountNumber - 1,
    userId,
  );

  while (true) {
    stdout.write('Enter recipient account number: ');
    final String? recipientAccNumber = stdin.readLineSync();
    if (recipientAccNumber == null || recipientAccNumber.isEmpty) {
      print(_red('Recipient account number cannot be empty.'));
      continue;
    }

    Account recipientAccount;
    try {
      recipientAccount = accountService.transferAccount(
        userId,
        account.accountNumber,
        recipientAccNumber,
      );
    } catch (e) {
      print(_red(e.toString()));
      continue;
    }

    stdout.write('Enter amount to transfer: \$');
    final double? amount = double.tryParse(stdin.readLineSync() ?? '');
    if (amount == null || amount <= 0) {
      print(_red('Invalid amount. Please enter a positive number.'));
      continue;
    }
    try {
      account.transfer(amount, recipientAccount);
      print(
        _green(
          'Transfer successful! New balance: \$${account.balance.toStringAsFixed(2)}, Recipient\'s new balance: \$${recipientAccount.balance.toStringAsFixed(2)}',
        ),
      );
    } catch (e) {
      print(_red('Error: $e'));
    }
    break;
  }
}

void _checkHistory(
  int userId,
  List<Account> accounts,
  AccountService accountService,
  TableView tableView,
) {
  _displayAccounts(accounts, tableView);
  final int accountNumber = _selectAccount(accounts);
  final Account account = accountService.getAccountByIndex(
    accountNumber - 1,
    userId,
  );
  final headers = ['#', 'Account Number', 'Amount', 'Type', 'Date'];
  final List<List<String>> rows = [];
  for (var i = 0; i < account.histories.length; i++) {
    rows.add([
      '${i + 1}',
      account.accountNumber,
      '\$${account.histories[i].amount.toStringAsFixed(2)}',
      account.histories[i].type,
      DateFormat('yyyy-MM-dd hh:mm:ss').format(account.histories[i].date),
    ]);
  }
  tableView.displayTable(
    headers,
    rows,
    numericColumns: [true, false, true, false, false],
  );
}
