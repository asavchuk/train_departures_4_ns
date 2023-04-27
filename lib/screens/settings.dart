import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/septa_provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SeptaProvider>(context).bloc;
    return Scaffold(
      appBar: AppBar(
          title: Text('Departure Settings',
              style: Theme.of(context).textTheme.titleLarge)),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 25.0,
          ),
          StreamBuilder<String>(
              stream: bloc.station,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: StreamBuilder<List<String>>(
                      stream: bloc.stations,
                      builder: (context, snapshotStations) {
                        if (!snapshotStations.hasData) {
                          return Row(
                            children: const <Widget>[],
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Station'),
                            DropdownButton<String>(
                              value: snapshot.data,
                              onChanged: (String? value) {
                                bloc.changeStation(value!);
                              },
                              items: snapshotStations.data
                                  ?.map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      }),
                );
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: StreamBuilder<int>(
              stream: bloc.count,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Departures'),
                    DropdownButton<int>(
                      value: snapshot.data,
                      onChanged: (int? value) {
                        bloc.changeCount(value!);
                      },
                      items: <int>[4, 8, 10, 14, 18].map<DropdownMenuItem<int>>(
                        (int value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.toString()),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: const [Text('Choose Direction')],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: StreamBuilder<List<String>>(
              stream: bloc.directions,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                var directions = snapshot.data;
                return Wrap(
                  spacing: 5.0,
                  runSpacing: 3.0,
                  children: <Widget>[
                    FilterChip(
                      label: Text('Northbound',
                          style: Theme.of(context).textTheme.bodyMedium),
                      selected: (directions!.contains('N')) ? true : false,
                      onSelected: (bool value) {
                        if (value == true) {
                          directions.add('N');
                          bloc.changeDirections(directions);
                        } else {
                          directions
                              .remove(directions.firstWhere((x) => x == 'N'));
                          bloc.changeDirections(directions);
                        }
                      },
                    ),
                    FilterChip(
                      label: Text('Southbound',
                          style: Theme.of(context).textTheme.bodyMedium),
                      selected: (directions.contains('S')) ? true : false,
                      onSelected: (bool value) {
                        if (value == true) {
                          directions.add('S');
                          bloc.changeDirections(directions);
                        } else {
                          directions
                              .remove(directions.firstWhere((x) => x == 'S'));
                          bloc.changeDirections(directions);
                        }
                      },
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
