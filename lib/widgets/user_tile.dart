import 'package:flutter/material.dart';
import '../models/user.dart';

class UserTile extends StatelessWidget {
  final User user;

  UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name), // Menampilkan nama pengguna
      subtitle: Text('User ID: ${user.userId}'), // Menampilkan ID pengguna
      onTap: () {
        // Aksi saat tile diklik, jika perlu
      },
    );
  }
}
