package com.muxable.muxer.modem

import android.net.TrafficStats
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Handler
import android.os.Looper
import java.util.*

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.muxable.muxer.modem"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getMobileTxBytes" ->
                    result.success(TrafficStats.getMobileTxBytes())
                else -> result.notImplemented()
            }
        }
    }
}
