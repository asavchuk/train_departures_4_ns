import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../models/train.dart';
import '../services/septa_service.dart';

class SeptaBloc {
  final _trains = BehaviorSubject<List<Train>>();
  final _station = BehaviorSubject<String>();
  final _count = BehaviorSubject<int>();
  final _directions = BehaviorSubject<List<String>>();
  final _stations = BehaviorSubject<List<String>>();
  final _septaService = SeptaService();

  SeptaBloc() {
    station.listen((station) async {
      await refreshDepartures();
    });
    loadSettings();
    loadStations();

    refreshDepartures(value: true);
  }

  //Getters
  Stream<List<Train>> get trains => _trains.stream.map(
        (trainList) => trainList
            .where(
              (train) => _directions.value.contains(train.direction),
            )
            .take(
              _count.value,
            )
            .toList(),
      );

  Stream<int> get count => _count.stream;
  Stream<String> get station => _station.stream;
  Stream<List<String>> get directions => _directions.stream;
  Stream<List<String>> get stations => _stations.stream;

  //Setters
  Function(List<Train>) get changeTrains => _trains.sink.add;
  Function(String) get changeStation => _station.sink.add;
  Function(int) get changeCount => _count.sink.add;
  Function(List<String>) get changeDirections => _directions.sink.add;
  Function(List<String>) get changeStations => _stations.sink.add;

  void loadSettings() {
    changeCount(10);
    changeDirections(['N', 'S']);
    changeStation('Rosemont');
  }

  Future<void> refreshDepartures({bool value = false}) async {
    debugPrint('--------refreshDepartures---------');
    changeTrains(await _septaService.loadStationData(_station.value));
    if (value == false) return;

    //Set Timer to Run Again when true
    TimerStream(DateTime.now(), const Duration(seconds: 60))
        .listen((timestamp) async {
      debugPrint('Refreshing at $timestamp');
      await refreshDepartures(value: true);
    });
  }

  // // on true will not set up timer again
  // Future<void> refreshDeparturesOnce() async {
  //   changeTrains(await _septaService.loadStationData(_station.value));
  // }

  Future<void> loadStations() async {
    changeStations(await _septaService.getStations());
  }

  //Dispose
  dispose() {
    _trains.close();
    _station.close();
    _count.close();
    _directions.close();
    _stations.close();
  }
}
