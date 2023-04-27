class Train {
  final String direction;
  final String destination;
  final String status;
  final DateTime departTime;
  final String track;

  Train(
      {required this.departTime,
      required this.destination,
      required this.direction,
      required this.status,
      required this.track});

  Train.fromJson(Map<dynamic, dynamic> json)
      : direction = json['direction'],
        destination = json['destination'],
        status = json['status'],
        departTime = DateTime.parse(json['depart_time']),
        track = json['track'];
}
