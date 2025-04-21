import 'package:flutter/material.dart';
import '../Signup_page/Seller_signup.dart';
import '../main.dart';
import '../Dashboard/seller_dashboard.dart';

class SellerLoginScreen extends StatefulWidget {
  const SellerLoginScreen({super.key});

  @override
  State<SellerLoginScreen> createState() => SellerLoginScreenState();
}

class SellerLoginScreenState extends State<SellerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    try {
      debugPrint('Form validation started');
      if (_formKey.currentState!.validate()) {
        debugPrint('Form validated successfully');
        if (_emailController.text == 'seller@gmail.com' &&
            _passwordController.text == 'seller123') {
          debugPrint('Credentials matched, attempting navigation');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SellerDashboard()),
          ).then((_) => debugPrint('Navigation completed'));
          debugPrint('Seller Login Form Submitted');
        } else {
          debugPrint('Invalid credentials');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error during navigation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Business Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your email')),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset link sent to your email'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Send Reset Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isLandscape = screenSize.width > screenSize.height;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1200;
    final isDesktop = screenSize.width >= 1200;
    final padding = isSmallScreen ? 16.0 : 24.0;
    final maxWidth = isDesktop ? 500.0 : (isTablet ? 400.0 : double.infinity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Login'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: EdgeInsets.all(padding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Welcome Back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktop ? 32 : (isTablet ? 28 : 24),
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(
                    height: isLandscape ? 12 : (isSmallScreen ? 16 : 24),
                  ),
                  Text(
                    "Sign in to your business account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : (isTablet ? 16 : 14),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                    height: isLandscape ? 16 : (isSmallScreen ? 20 : 30),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Business Email",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.business),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isLandscape ? 12 : (isSmallScreen ? 12 : 16),
                        horizontal: 16,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your business email";
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isLandscape ? 12 : (isSmallScreen ? 12 : 16),
                        horizontal: 16,
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showForgotPasswordDialog,
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isLandscape ? 16 : (isSmallScreen ? 20 : 30),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                        vertical: isLandscape ? 12 : (isSmallScreen ? 14 : 16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: isLandscape ? 16 : (isSmallScreen ? 16 : 18),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have a business account?",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SellerSignupPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
