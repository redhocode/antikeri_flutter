import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/presensi.dart';
import '../services/api_service.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> users;
  User? selectedUser;
  int? selectedSensorId;
  String? selectedSN;
  final TextEditingController checkTimeController = TextEditingController();

  final ApiService apiService = ApiService('http://192.168.0.14:8022');

  final Map<int, String> sensorMap = {
    1: 'A5NS190560046',
    2: 'B7NS290560047',
    3: 'C9NS390560048',
  };

  @override
  void initState() {
    super.initState();
    users = apiService.fetchUsers();
  }

  void postPresensi() {
    if (selectedUser != null &&
        selectedSensorId != null &&
        selectedSN != null) {
      final presensi = Presensi(
        userId: selectedUser!.userId,
        checkTime: checkTimeController.text,
        sensorId: selectedSensorId!,
        sn: selectedSN!,
      );

      apiService.postPresensi(presensi).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presensi berhasil dikirim!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan lengkapi semua field!')),
      );
    }
  }

  void _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        checkTimeController.text = finalDateTime.toIso8601String();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userList = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButton<User>(
                    hint: const Text('Pilih User'),
                    value: selectedUser,
                    onChanged: (User? newValue) {
                      setState(() {
                        selectedUser = newValue;
                      });
                    },
                    items: userList.map((User user) {
                      return DropdownMenuItem<User>(
                        value: user,
                        child: Text(user.name),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: checkTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Check Time',
                      hintText: 'Pilih Tanggal dan Waktu',
                    ),
                    readOnly: true,
                    onTap: () => _selectDateTime(context),
                  ),
                  DropdownButton<int>(
                    hint: const Text('Pilih Sensor ID'),
                    value: selectedSensorId,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedSensorId = newValue;
                        selectedSN = sensorMap[newValue]; // Otomatis pilih SN
                      });
                    },
                    items: sensorMap.keys.map((int id) {
                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text(id.toString()),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    hint: const Text('Pilih SN'),
                    value: selectedSN,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSN = newValue;
                      });
                    },
                    items: sensorMap.values.map((String sn) {
                      return DropdownMenuItem<String>(
                        value: sn,
                        child: Text(sn),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: postPresensi,
                    child: const Text('Kirim Presensi'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
