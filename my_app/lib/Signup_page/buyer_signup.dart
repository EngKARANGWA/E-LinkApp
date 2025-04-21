import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class BuyerRegistrationScreen extends StatefulWidget {
  const BuyerRegistrationScreen({super.key});

  @override
  State<BuyerRegistrationScreen> createState() =>
      _BuyerRegistrationScreenState();
}

class _BuyerRegistrationScreenState extends State<BuyerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isLandscape = screenSize.width > screenSize.height;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1200;
    final isDesktop = screenSize.width >= 1200;
    final padding = isSmallScreen ? 16.0 : 24.0;
    final maxWidth = isDesktop ? 800.0 : (isTablet ? 600.0 : double.infinity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Registration'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: EdgeInsets.all(padding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create Buyer Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktop ? 32 : (isTablet ? 28 : 24),
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(
                      height: isLandscape ? 16 : (isSmallScreen ? 20 : 30)),
                  if (isLandscape)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _nameController,
                                label: 'Full Name',
                                icon: Icons.person,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                isLandscape: isLandscape,
                                isSmallScreen: isSmallScreen,
                              ),
                              SizedBox(height: isSmallScreen ? 16 : 20),
                              _buildTextField(
                                controller: _emailController,
                                label: 'Email',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                isLandscape: isLandscape,
                                isSmallScreen: isSmallScreen,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 16 : 24),
                        Expanded(
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _passwordController,
                                label: 'Password',
                                icon: Icons.lock,
                                suffixIcon: Icons.visibility_off,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                                isLandscape: isLandscape,
                                isSmallScreen: isSmallScreen,
                              ),
                              SizedBox(height: isSmallScreen ? 16 : 20),
                              _buildTextField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                                isLandscape: isLandscape,
                                isSmallScreen: isSmallScreen,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          isLandscape: isLandscape,
                          isSmallScreen: isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 20),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          isLandscape: isLandscape,
                          isSmallScreen: isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 20),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock,
                          suffixIcon: Icons.visibility_off,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          isLandscape: isLandscape,
                          isSmallScreen: isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 20),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          isLandscape: isLandscape,
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),
                  SizedBox(
                      height: isLandscape ? 16 : (isSmallScreen ? 24 : 32)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                        vertical: isLandscape ? 12 : (isSmallScreen ? 16 : 20),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle registration logic here
                        if (kDebugMode) {
                          print('Buyer Registration Form Submitted');
                        }
                      }
                    },
                    child: Text(
                      'Register as Buyer',
                      style: TextStyle(
                        fontSize: isLandscape ? 16 : (isSmallScreen ? 16 : 18),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    IconData? suffixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    required String? Function(String?)? validator,
    required bool isLandscape,
    required bool isSmallScreen,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        contentPadding: EdgeInsets.symmetric(
          vertical: isLandscape ? 12 : (isSmallScreen ? 12 : 16),
          horizontal: 16,
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
