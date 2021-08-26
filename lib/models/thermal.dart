import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:thermal/thermal.dart';

class ThermalModel extends ChangeNotifier {
  late final StreamSubscription<void> _thermalStatusSubscription;
  late final StreamSubscription<void> _temperatureSubscription;
  late final StreamSubscription<void> _timer;

  var _thermalStatus = ThermalStatus.none;
  final _temperatureHistory = [0.0];
  var _temperature = 0.0;

  ThermalModel() {
    final thermal = Thermal();
    _thermalStatusSubscription =
        thermal.onThermalStatusChanged.listen((status) {
      _thermalStatus = status;
      notifyListeners();
    });
    _temperatureSubscription =
        thermal.onBatteryTemperatureChanged.listen((temperature) {
      _temperature = temperature;
    });
    _timer = Stream.periodic(const Duration(seconds: 1)).listen((i) {
      _temperatureHistory.add(_temperature);
      notifyListeners();
    });
  }

  ThermalStatus get thermalStatus => _thermalStatus;

  List<double> get temperatureHistory => _temperatureHistory;

  @override
  void dispose() {
    _timer.cancel();
    _temperatureSubscription.cancel();
    _thermalStatusSubscription.cancel();
    super.dispose();
  }
}
