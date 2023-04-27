import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/train.dart';

class SeptaService {
  Future<List<Train>> loadStationData(String station) async {
    //Send Get Request
    var response = await http.get(Uri.parse(
        "http://www3.septa.org/api/Arrivals/index.php?station=$station&results=10"));

    //Build a Train List
    var trains = <Train>[];

    try {
      //Replace Dynamic Key and Decode
      var json = convert.jsonDecode(
          '{ "Departures" : ${response.body.substring(response.body.indexOf('['))}');

      var north = json['Departures'][0]['Northbound'];
      var south = json['Departures'][1]['Southbound'];
      north.forEach((train) => trains.add(Train.fromJson(train)));
      south.forEach((train) => trains.add(Train.fromJson(train)));
    } catch (error) {
      debugPrint(error.toString());
    }

    //Sort
    trains.sort((a, b) => a.departTime.compareTo(b.departTime));

    return trains;
  }

  Future<List<String>> getStations() async {
    var request = await HttpClient().getUrl(Uri.parse(
        'http://www3.septa.org/hackathon/Arrivals/station_id_name.csv'));
    var response = await request.close();

    var output = <String>[];

    response.transform(const convert.Utf8Decoder()).listen((fileContents) {
      convert.LineSplitter ls = const convert.LineSplitter();
      List<String> lines = ls.convert(fileContents);
      for (var line in lines) {
        output.add(line.split(',')[1]);
      }
    });

    return output;
  }
}
