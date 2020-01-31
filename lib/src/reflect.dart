import 'reflect_action.dart';

class Reflect /* with ChangeNotifier */ {
  List<dynamic> reducers;
  Map<String, dynamic> _state;

  Reflect.createState({this.reducers}) {
    _state = Map();
    reducers.forEach((dynamic reducer) => _state[reducer.name] = reducer.builder());
  }

  void dispatchAction({ReflectAction action}) {
    reducers.forEach((dynamic reducer) => _state[reducer.name] = reducer.builder(_state[reducer.name], action));
    // notifyListeners();
  }

  Map<String, dynamic> get state => _state;
}