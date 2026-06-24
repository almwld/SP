import 'package:flutter/material.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/auth/splash_screen.dart';
import 'presentation/screens/home/main_navigation.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const MainNavigation());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('الصفحة غير موجودة')),
          ),
        );
    }
  }
}
