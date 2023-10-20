import 'package:flutter/material.dart';
import 'package:unityspace/screens/home_screen.dart';
import 'package:unityspace/screens/loading_screen.dart';
import 'package:unityspace/screens/login_by_email_screen.dart';
import 'package:unityspace/screens/login_screen.dart';
import 'package:unityspace/store/auth_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthStore().loadUserTokens();

  runApp(
    MyApp(
      isAuthenticated: AuthStore().isAuthenticated,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({
    super.key,
    required this.isAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnitySpace',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: isAuthenticated ? '/loading' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/email': (context) => const LoginByEmailScreen(),
        '/home': (context) => const HomeScreen(),
        '/loading': (context) => const LoadingScreen(),
      },
    );
  }
}
