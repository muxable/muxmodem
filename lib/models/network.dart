import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:modem/network_stats.dart';

class NetworkModel extends ChangeNotifier {
  late final StreamSubscription<void> _txBytesSubscription;

  final List<int> _historicalTxBytes = [];

  NetworkModel() {
    final networkStats = NetworkStats();
    _txBytesSubscription = Stream.periodic(const Duration(seconds: 1))
        .asyncMap((event) => networkStats.mobileTxBytes)
        .listen((txBytes) {
      _historicalTxBytes.add(txBytes);
      notifyListeners();
    });
  }

  int get txBytesPerSecond {
    if (_historicalTxBytes.length < 2) {
      return 0;
    }
    return _historicalTxBytes[_historicalTxBytes.length - 1] -
        _historicalTxBytes[_historicalTxBytes.length - 2];
  }

  Iterable<int> get txBytesPerSecondHistory sync* {
    for (var i = 0; i < _historicalTxBytes.length - 1; i++) {
      yield _historicalTxBytes[i + 1] - _historicalTxBytes[i];
    }
  }

  @override
  void dispose() {
    _txBytesSubscription.cancel();
    super.dispose();
  }
}
