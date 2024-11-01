import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/presensi.dart';
class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/api/users'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // Akses data sebagai daftar
      List<dynamic> usersJson = jsonResponse['data'];
      return usersJson.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
  Future<void> postPresensi(Presensi presensi) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/presensi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(presensi.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to post presensi: ${response.body}');
    }
  }

}
