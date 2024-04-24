import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static String? userLogin;
  static const loginKey = "Login Key";

  static Future getUserDetails() async {
    userLogin = await getData(loginKey);
  }

  static Future setData(String key, dynamic value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (value is bool) {
      return sharedPreferences.setBool(key, value);
    } else if (value is int) {
      return sharedPreferences.setInt(key, value);
    } else if (value is String) {
      return sharedPreferences.setString(key, value);
    } else if (value is double) {
      return sharedPreferences.setDouble(key, value);
    }
    return null;
  }

  static Future<T?> getData<T>(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var value = sharedPreferences.get(key);
    if (value == null) {
      return null;
    }
    if (T == bool && value is bool ||
        T == int && value is int ||
        T == String && value is String ||
        T == double && value is double) {
      return value as T;
    }
    return null;
  }

  static Future clearUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    setData(loginKey, false);
    await getUserDetails();
  }
}
