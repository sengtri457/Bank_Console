import 'package:bank_account/models/account.dart';

class AccountService {
  static final AccountService _instance = AccountService._internal();
  factory AccountService() => _instance;
  AccountService._internal();
  List<Account> accounts = [
    Account(id: 1, accountNumber: '123456789', useId: 1),
    Account(id: 2, accountNumber: '987654321', useId: 1),
    Account(id: 3, accountNumber: '555555555', useId: 2),
    Account(id: 4, accountNumber: '111111111', useId: 1),
    Account(id: 5, accountNumber: '222222222', useId: 2),
  ];

  List<Account> getUserAccountsById(int userId) {
    return accounts.where((acc) => acc.useId == userId).toList();
  }

  Account getAccountByIndex(int index, int userId) {
    return getUserAccountsById(userId)[index];
  }

  Account transferAccount(
    int userId,
    String sourceAccountNumber,
    String recipientAccNumber,
  ) {
    if (sourceAccountNumber == recipientAccNumber) {
      throw Exception("Cannot transfer to the same account.");
    }

    final senderAccounts = getUserAccountsById(userId);
    if (senderAccounts.isEmpty) {
      throw Exception("Sender account not found.");
    }

    final recipient = accounts.firstWhere(
      (acc) => acc.accountNumber == recipientAccNumber,
      orElse: () => throw Exception("Recipient account not found."),
    );

    return recipient;
  }
}
