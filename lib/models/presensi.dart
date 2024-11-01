class Presensi {
  final int userId;
  final String checkTime;
  final int sensorId;
  final String sn;

  Presensi({
    required this.userId,
    required this.checkTime,
    required this.sensorId,
    required this.sn,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'checktime': checkTime,
      'sensorId': sensorId,
      'sn': sn,
    };
  }
}
