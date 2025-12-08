import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static Future<bool> register(String email, String pwd) async {
    final p = await SharedPreferences.getInstance();
    if (p.getString('email') != null) return false;
    await p.setString('email', email);
    await p.setString('pwd', pwd);
    await p.setBool('logged', true);
    return true;
  }

  static Future<bool> login(String email, String pwd) async {
    final p = await SharedPreferences.getInstance();
    if (p.getString('email') == email && p.getString('pwd') == pwd) {
      await p.setBool('logged', true);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('logged', false);
  }

  static Future<bool> isLogged() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool('logged') ?? false;
  }

  static Future<String?> getEmail() async {
    final p = await SharedPreferences.getInstance();
    return p.getString('email');
  }
}
