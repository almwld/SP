import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // ✅ runApp فوري — لا انتظار لأي شيء
  runApp(const RootApp());

  // 🔥 Firebase يتصل في الخلفية بعد 10 ثواني
  Future.delayed(const Duration(seconds: 10), _initFirebaseInBackground);
}

Future<void> _initFirebaseInBackground() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 15));
      debugPrint('[Firebase] ✅ متصل');
    }
  } catch (e) {
    debugPrint('[Firebase] ⚠️ $e — سيعيد المحاولة');
    Future.delayed(const Duration(seconds: 30), _initFirebaseInBackground);
  }
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'صحتك',
      debugShowCheckedModeBanner: false,
      builder: (_, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      home: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.6)),
    );

    _scale = Tween(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );

    _ctrl.forward();
    Future.delayed(const Duration(seconds: 2), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRouter.login);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D9488),
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Opacity(
          opacity: _fade.value,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.health_and_safety,
                      size: 58,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'صحتك',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'تطبيقك الطبي المتكامل',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
