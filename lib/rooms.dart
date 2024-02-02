import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Rooms extends StatefulWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  Map<String, Map<String, bool>> roomControls = {
    'ROOM-1': {'Light': false, 'AC': false, 'Fan': false, 'Heater': false},
    'ROOM-2': {'Light': false, 'AC': false, 'Fan': false, 'Heater': false},
    'ROOM-3': {'Light': false, 'AC': false, 'Fan': false, 'Heater': false},
    'ROOM-4': {'Light': false, 'AC': false, 'Fan': false, 'Heater': false},
  };

  bool waterPump = false;
  final _auth = FirebaseAuth.instance;
  late User? _currentUser;
  final _databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
  }

  void _updateRoomControl(String controlName, String roomName, bool newValue) {
    final cleanControlName = controlName.toLowerCase().replaceAll(' ', '');
    final suffix = roomName.length >= 6 ? roomName.substring(6) : roomName;
    final ref = '$cleanControlName$suffix'.replaceAll(' ', '');
    _databaseReference.child(_currentUser!.email!.replaceAll('.', '_')).update({
      ref: newValue,
    });
  }

  void _updateWaterPump(bool newValue) {
    _databaseReference
        .child(_currentUser!.email!.replaceAll('.', '_'))
        .update({'waterpump': newValue});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildRoomControl('ROOM - 1', roomControls['ROOM-1']!),
                _buildRoomControl('ROOM - 2', roomControls['ROOM-2']!),
                _buildRoomControl('ROOM - 3', roomControls['ROOM-3']!),
                _buildRoomControl('ROOM - 4', roomControls['ROOM-4']!),
                const SizedBox(height: 25),
                _buildToggleSwitch(
                  'Water Pump',
                  waterPump,
                  'waterpump',
                  Icons.invert_colors,
                  '', // Add an empty string or any placeholder value
                  onChanged: (bool newValue) {
                    setState(() {
                      waterPump = newValue;
                    });
                    _updateWaterPump(newValue);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomControl(String roomName, Map<String, bool> controls) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              roomName,
              style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildToggleSwitch(
                  'Light',
                  controls['Light']!,
                  'light',
                  Icons.lightbulb_outline,
                  roomName,
                  onChanged: (bool newValue) {
                    setState(() {
                      controls['Light'] = newValue;
                    });
                    _updateRoomControl('light', roomName, newValue);
                  },
                ),
                _buildToggleSwitch(
                  'AC',
                  controls['AC']!,
                  'ac',
                  Icons.ac_unit,
                  roomName,
                  onChanged: (bool newValue) {
                    setState(() {
                      controls['AC'] = newValue;
                    });
                    _updateRoomControl('ac', roomName, newValue);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildToggleSwitch(
                  'Heater',
                  controls['Heater']!,
                  'heater',
                  Icons.whatshot,
                  roomName,
                  onChanged: (bool newValue) {
                    setState(() {
                      controls['Heater'] = newValue;
                    });
                    _updateRoomControl('heater', roomName, newValue);
                  },
                ),
                _buildToggleSwitch(
                  'Fan',
                  controls['Fan']!,
                  'fan',
                  Icons.air,
                  roomName,
                  onChanged: (bool newValue) {
                    setState(() {
                      controls['Fan'] = newValue;
                    });
                    _updateRoomControl('fan', roomName, newValue);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch(
    String label,
    bool value,
    String controlName,
    IconData iconData,
    String roomName, {
    required ValueChanged<bool> onChanged,
  }) {
    final cleanControlName = controlName.toLowerCase(); // Convert to lowercase

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [value ? Colors.green : Colors.grey[300]!, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  iconData,
                  color: value ? Colors.white : Colors.black,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: value ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                activeColor: Colors.green,
                value: value,
                onChanged: (newValue) {
                  setState(() {
                    onChanged(newValue);
                    _updateRoomControl(cleanControlName, roomName, newValue);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
