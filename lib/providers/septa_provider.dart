import 'package:flutter/material.dart';

import '../blocs/septa_bloc.dart';

class SeptaProvider with ChangeNotifier {
  late SeptaBloc _bloc;

  SeptaProvider() {
    _bloc = SeptaBloc();
  }

  SeptaBloc get bloc => _bloc;
}
