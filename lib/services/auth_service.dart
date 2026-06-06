import 'package:bank_account/models/user.dart';

class AuthService {
  List<User> users = [
    User(
      id: 1,
      username: 'Bun_sengtri',
      password: 'password123',
      pin: '1234',
      address: '123 Main St',
      dob: '01/01/1990',
    ),
    User(
      id: 2,
      username: 'jane_doe',
      password: 'password456',
      pin: '5678',
      address: '456 Elm St',
      dob: '02/02/1992',
    ),
  ];

  User? login({required String username, required String password}) {
    try {
      return users.firstWhere(
        (user) => user.username == username && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  bool verifyPin(User user, String pin) {
    return user.pin == pin;
  }
}
