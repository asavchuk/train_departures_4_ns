import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:train_departures_4_ns/screens/settings.dart';

import '../models/train.dart';
import '../providers/septa_provider.dart';

class Departures extends StatelessWidget {
  const Departures({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SeptaProvider>(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
            stream: bloc.station,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return Text('${snapshot.data} Station',
                  style: Theme.of(context).textTheme.titleLarge);
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              child: Text('Change',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  )),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Train>>(
          stream: bloc.trains,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return RefreshIndicator(
              onRefresh: () => bloc.refreshDepartures(),
              child: ListView.builder(
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildHeader(context);
                    } else {
                      return _buildDeparture(
                          context, snapshot.data![index - 1]);
                    }
                  }),
            );
          }),
    );
  }

  _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 15.0),
            Text('Departures', style: Theme.of(context).textTheme.titleLarge)
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            const SizedBox(width: 15.0),
            Expanded(
              flex: 1,
              child:
                  Text('Time', style: Theme.of(context).textTheme.bodyMedium),
            ),
            Expanded(
                flex: 3,
                child: Text('Destination',
                    style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
                flex: 1,
                child: Text('Track',
                    style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
                flex: 1,
                child: Text('Status',
                    style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
        const SizedBox(height: 4.0),
      ],
    );
  }

  _buildDeparture(BuildContext context, Train train) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 15.0),
            Expanded(
              flex: 1,
              child: Text(formatDate(train.departTime, [h, ':', nn]),
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Expanded(
                flex: 3,
                child: Text(train.destination,
                    style: Theme.of(context).textTheme.bodyLarge)),
            Expanded(
                flex: 1,
                child: Text(train.track,
                    style: Theme.of(context).textTheme.bodyLarge)),
            Expanded(
                flex: 1,
                child: Text(train.status,
                    style: Theme.of(context).textTheme.bodyLarge)),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
