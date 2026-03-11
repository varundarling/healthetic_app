import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/branded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isFormValid = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // fade-in animation on screen load
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    _emailController.addListener(_updateFormValidity);
    _passwordController.addListener(_updateFormValidity);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // enables/disables login button in real-time as user types
  void _updateFormValidity() {
    final emailValid = _isValidEmail(_emailController.text);
    final passwordValid = _passwordController.text.length >= 6;
    final newIsFormValid = emailValid && passwordValid;

    if (newIsFormValid != _isFormValid) {
      setState(() {
        _isFormValid = newIsFormValid;
      });
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isLoading) return; // prevent double-tap

    setState(() {
      _isLoading = true;
    });

    // simulate network delay (no real backend yet)
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text;
    debugPrint('Login successful for $email!');

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful for $email!'),
          backgroundColor: primaryGreen,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [secondaryGreen, neutralWhite],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  const Text(
                    'Healthetic Lifestyle',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Welcome back!',
                    style: TextStyle(fontSize: 16, color: neutralGrey),
                  ),

                  const SizedBox(height: 40),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Email',
                          placeholder: 'Enter your email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!_isValidEmail(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        CustomTextField(
                          label: 'Password',
                          placeholder: 'Enter your password',
                          controller: _passwordController,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              debugPrint('Forgot Password tapped');
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 14,
                                color: neutralGrey,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        BrandedButton(
                          label: 'Login',
                          isLoading: _isLoading,
                          isEnabled: _isFormValid,
                          onPressed: _handleLogin,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 14, color: neutralGrey),
                      ),
                      GestureDetector(
                        onTap: () {
                          debugPrint('Navigating to Sign Up...');
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
