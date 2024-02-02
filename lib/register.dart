import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rewritePasswordController =
      TextEditingController();
  final _databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REGISTER'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email Field
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16.0),

                      // Password Field
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          icon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Rewrite Password Field
                      TextField(
                        controller: _rewritePasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Re-write Password',
                          icon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // Register Button
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            if (_passwordController.text.length < 6) {
                              // Password length is less than 6 characters
                              showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return const AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                      'Password must be at least 6 characters long.',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                },
                              );
                              return;
                            }

                            if (_passwordController.text ==
                                _rewritePasswordController.text) {
                              final UserCredential userCredential =
                                  await _auth.createUserWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );

                              // Create a new node with the user's email
                              await _databaseReference
                                  .child(_emailController.text
                                      .trim()
                                      .replaceAll('.', '_'))
                                  .set({
                                'temp': '...',
                                'humidity': '...',
                                'voltage': '...',
                                'current': '...',
                                'power': '...',
                                'kwh': '...',
                                'light1': false,
                                'ac1': false,
                                'heater1': false,
                                'fan1': false,
                                'light2': false,
                                'ac2': false,
                                'heater2': false,
                                'fan2': false,
                                'light3': false,
                                'ac3': false,
                                'heater3': false,
                                'fan3': false,
                                'light4': false,
                                'ac4': false,
                                'heater4': false,
                                'fan4': false,
                                'waterpump': false,
                                // 'section1': false,
                                // 'section2': false,
                              });

                              await showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return const AlertDialog(
                                    title: Text('Done'),
                                    content: Text(
                                      'User created successfully!',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  );
                                },
                              );

                              Navigator.pushNamed(context, 'login');

                              // Successfully registered
                              // print('User registered: ${userCredential.user?.email}');
                            } else {
                              // Passwords do not match
                              showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return const AlertDialog(
                                    title: Text('ERROR'),
                                    content: Text(
                                      'Passwords Unmatched!',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 16.5),
                                    ),
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            // Registration failed
                            // print('Registration error: $e');
                            showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.of(context).pop(true);
                                });
                                return const AlertDialog(
                                  title: Text('ERROR'),
                                  content: Text(
                                    'Registration Error!',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 17),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Register',
                            style: TextStyle(color: Colors.white)),
                      ),

                      // Already have an account? Login link
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Already have an account? Login here!',
                              style: TextStyle(
                                color: Colors.green,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
