import 'package:flutter/material.dart';
import 'package:healthetic_app/screens/login_screen.dart';
import '../constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // auto-navigate to login after 2s
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: neutralWhite,
      body: Center(
        child: Text(
          'Healthetic',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
      ),
    );
  }
}
