import 'package:flutter/services.dart';

class NetworkStats {
  static const _channel = MethodChannel('com.muxable.muxer.modem');

  Future<int> get mobileTxBytes async {
    final bytes = await _channel.invokeMethod<int>('getMobileTxBytes');
    return bytes ?? 0;
  }
}
