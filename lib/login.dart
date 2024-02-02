import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        key: _scaffoldKey,
        // appBar: AppBar(
        //   title: Text('LogIn'),
        // ),
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: MediaQuery.of(context).size.width * 0.45,
                          ),
                        ),
                        // SizedBox(height: 30),
                        // Email Field
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16.0),

                        // Password Field
                        TextField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.lock),
                          ),
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                        const SizedBox(height: 24.0),

                        // Login Button
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                              email = "";
                              password = "";
                              if (user != null) {
                                Navigator.pushReplacementNamed(
                                    context, 'dashboard');
                              }
                            } catch (e) {
                              setState(() {
                                showSpinner = false;
                              });
                              showDialog(
                                context: _scaffoldKey.currentContext!,
                                builder: (context) {
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return const AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                      'Invalid Login Credentials!',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 16),
                                    ),
                                  );
                                },
                              );
                              // print(e);
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          },
                          child: const Text('Login',
                              style: TextStyle(color: Colors.white)),
                        ),

                        // Divider
                        const SizedBox(height: 16.0),
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                                thickness: 1.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('OR'),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                                thickness: 1.0,
                              ),
                            ),
                          ],
                        ),

                        // Register Button
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'register');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Register',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
