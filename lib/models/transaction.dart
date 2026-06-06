class Transaction {
  int id;
  String accountNumber;
  double amount;
  String type;
  DateTime date;
  Transaction({
    required this.id,
    required this.accountNumber,
    required this.amount,
    required this.type,
    required this.date,
  });
}
