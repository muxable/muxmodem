import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modem/models/network.dart';
import 'package:modem/models/thermal.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final temperatureChart =
        Consumer<ThermalModel>(builder: (context, thermalModel, child) {
      final temperatureData = thermalModel.temperatureHistory;
      final renderedTemperatureData = temperatureData.sublist(
          max(0, temperatureData.length - 15), temperatureData.length);
      final colors = [
        Theme.of(context).primaryColor,
        Colors.white,
      ];
      final temperature = LineChartBarData(
        spots: renderedTemperatureData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value);
        }).toList(),
        isCurved: true,
        colors: colors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          colors: colors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      );
      return LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(enabled: false),
          minX: 0,
          maxX: renderedTemperatureData.length.toDouble(),
          minY: 10,
          maxY: 100,
          lineBarsData: [temperature],
          showingTooltipIndicators: [
            ShowingTooltipIndicators([
              LineBarSpot(
                  temperature,
                  renderedTemperatureData.length - 1,
                  FlSpot(renderedTemperatureData.length - 1,
                      renderedTemperatureData.last))
            ]),
          ],
        ),
      );
    });
    final networkChart =
        Consumer<NetworkModel>(builder: (context, networkModel, child) {
      final data = networkModel.txBytesPerSecondHistory.toList();
      final rendered = data.sublist(max(0, data.length - 15), data.length);
      final colors = [
        Theme.of(context).primaryColor,
        Colors.white,
      ];
      final barData = LineChartBarData(
        spots: rendered.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.toDouble() / 1024);
        }).toList(),
        isCurved: true,
        colors: colors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          colors: colors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      );
      return LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(enabled: false),
          minX: 0,
          maxX: rendered.length.toDouble(),
          minY: -500,
          maxY: 10000,
          lineBarsData: [barData],
        ),
      );
    });
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Column(children: [
            const Spacer(),
            Consumer<ThermalModel>(builder: (context, thermalModel, child) {
              return Text("${thermalModel.temperatureHistory.last}°C",
                  style: Theme.of(context).textTheme.headline2!);
            }),
            Consumer<NetworkModel>(builder: (context, networkModel, child) {
              final kbps = NumberFormat()
                  .format((8 * networkModel.txBytesPerSecond) ~/ 1024);
              return Text("$kbps kb/s",
                  style: Theme.of(context).textTheme.headline4!);
            }),
            const Spacer(),
            SizedBox(
                height: 500,
                child: Stack(children: [temperatureChart, networkChart])),
          ]),
        ),
      ),
    );
  }
}
