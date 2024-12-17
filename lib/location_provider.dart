import 'package:flutter/foundation.dart';

class LocationProvider with ChangeNotifier {
  String _location = '';

  String get location => _location;

  void setLocation(String newLocation) {
    _location = newLocation;
    notifyListeners();
  }
}
