import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'register.dart';
import 'dashboard.dart';
import 'rooms.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff0a0e21),
        ),
        // scaffoldBackgroundColor: Color(0xff0a0e21),
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: 'login',
      routes: {
        'login': (context) => const Login(),
        'register': (context) => Register(),
        'dashboard': (context) => Dashboard(),
        'rooms': (context) => Rooms(),
      },
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
