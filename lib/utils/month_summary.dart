import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import '../datetime/datetime.dart';


class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const MonthlySummary({
    super.key,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: HeatMap(
        startDate: createDateTimeObject(startDate),
        endDate: DateTime.now().add(const Duration(days: 40)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[100],
        textColor: Colors.purple[300],
        scrollable: true,
        size: 35,
        colorsets: const {
          1: Color.fromARGB(20, 174, 65, 190),
          2: Color.fromARGB(40, 174, 65, 190),
          3: Color.fromARGB(60, 174, 65, 190),
          4: Color.fromARGB(80,174, 65, 190),
          5: Color.fromARGB(100, 174, 65, 190),
          6: Color.fromARGB(120, 174, 65, 190),
          7: Color.fromARGB(150, 174, 65, 190),
          8: Color.fromARGB(180, 174, 65, 190),
          9: Color.fromARGB(220,174, 65, 190),
          10: Color.fromARGB(255, 174, 65, 190),
        },
      ),
    );
  }
}