import 'dart:collection';

import 'package:flutter/material.dart';

import 'reflect_action.dart';
import 'reflect_reducer.dart';

class Reflect with ChangeNotifier {
  List<dynamic> reducers;
  ListQueue<Map<String, dynamic>> _stateHistory;
  Map<String, dynamic> _state;

  Reflect.createState({this.reducers}) {
    _state = Map();
    _stateHistory = ListQueue();
    reducers.forEach((dynamic reducer) => _state[reducer.name] = reducer.builder());
  }

  void dispatchAction({ReflectAction action}) {
    _stateHistory.add(Map.from(_state));
    reducers.forEach((dynamic reducer) => _state[reducer.name] = reducer.builder(_state[reducer.name], action));
    notifyListeners();
  }

  void addReducer(ReflectReducer reducer) => reducers.add(reducer);

  void rollback() {
    if (_stateHistory.length > 0) {
      _state = _stateHistory.removeLast();
    } else {
      reducers.forEach((dynamic reducer) => _state[reducer.name] = reducer.builder());
    }

    notifyListeners();
  }

  Map<String, dynamic> get state => Map.from(_state);
  ListQueue<Map<String, dynamic>> get stateHistory => _stateHistory;
}