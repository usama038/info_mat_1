import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String temp = '...';
  String humidity = '...';
  String voltage = '...';
  String current = '...';
  String power = '...';
  String kwh = '...';
  // bool section1 = false;
  // bool section2 = false;
  late StreamController<int> _timeController = StreamController<int>();
  late StreamSubscription<int> _timeSubscription;
  late Stream<int> _timeStream;
  final _auth = FirebaseAuth.instance;
  late User? _currentUser;
  final _databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    _timeStream = Stream.periodic(const Duration(seconds: 1), (value) => value);
    _timeSubscription = _timeStream.listen((event) {
      _timeController.add(event);
    });

    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      // Listen for changes in the database
      _databaseReference
          .child(_currentUser!.email!.replaceAll('.', '_'))
          .onValue
          .listen((event) {
        // Update UI with the received data
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> values =
              (event.snapshot.value! as Map<dynamic, dynamic>);
          setState(() {
            temp = values['temp'];
            humidity = values['humidity'];
            voltage = values['voltage'];
            current = values['current'];
            power = values['power'];
            kwh = values['kwh'];
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timeSubscription.cancel();
    _timeController.close();
    super.dispose();
  }

  // // Function to update toggle switch values in the database
  // Future<void> _updateDatabaseValues() async {
  //   if (_currentUser != null) {
  //     await _databaseReference
  //         .child(_currentUser!.email!.replaceAll('.', '_'))
  //         .update({
  //       'section1': section1 ? 1 : 0,
  //       'section2': section2 ? 1 : 0,
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Dashboard'),
      // ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    // Current Time Display
                    StreamBuilder<int>(
                      stream: _timeController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final now = DateTime.now();
                          final formattedTime =
                              DateFormat('HH:mm:ss').format(now);

                          return Center(
                            child: Text(
                              'Time: $formattedTime',
                              style: const TextStyle(
                                  fontSize: 21.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text('Loading...'),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 45.0),

                    // Field Values
                    _buildField('Temperature', temp, '°C'),
                    _buildField('Humidity', humidity, '%'),
                    _buildField('Voltage', voltage, 'V'),
                    _buildField('Current', current, 'A'),
                    _buildField('Power', power, 'W'),
                    _buildField('KWH', kwh, 'units/kwh'),

                    const SizedBox(height: 25),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'rooms');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Room Controls',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                          )),
                    ),

                    // Logout Button
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: const Text('LOGOUT',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(String label, String value, String unit) {
    TextEditingController _valueController =
        TextEditingController(text: value + unit);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _valueController,
            enabled: false,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 13),
              labelText: label,
              labelStyle: const TextStyle(
                color: Colors.blue,
                fontSize: 23.0,
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 5.0,
                ),
              ),
            ),
            style: const TextStyle(
                fontSize: 25.0,
                color: Colors.green,
                fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 5.0),
        ],
      ),
    );
  }

  // Widget _buildToggleSwitch(String label, bool value, String databaseKey) {
  //   return Row(
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
  //       ),
  //       CupertinoSwitch(
  //         activeColor: Colors.green[400],
  //         value: value,
  //         onChanged: (newValue) async {
  //           setState(() {
  //             if (label == 'Section 1') {
  //               section1 = newValue;
  //             } else if (label == 'Section 2') {
  //               section2 = newValue;
  //             }
  //           });
  //
  //           // Update the database values when the switch is changed
  //           await _updateDatabaseValues();
  //         },
  //       ),
  //     ],
  //   );
  // }
}
