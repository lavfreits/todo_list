import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/datetime/datetime.dart';

final Box<dynamic> _box = Hive.box('box');

class TodoDatabase {
  List todoList = [];
  Map<DateTime, int> heatMapDataSet = {};

  void createInitialData() {
    todoList = [
      ["Fazer compras", false],
      ["Estudar para o exame", true],
      ["Ir à academia", false]
    ];
    _box.put('START_DATE', todaysDateFormatted());
    _box.put('TODOLIST', todoList);
  }

  // void loadData()  {
  //   if (_box.containsKey('TODOLIST')) {
  //     todoList = _box.get('TODOLIST');
  //   } else {
  //      createInitialData();
  //   }
  // }
  // load data if it already exists
  void loadData() {
    // if it's a new day, get habit list from database
    if (_box.get(todaysDateFormatted()) == null) {
      todoList = _box.get('TODOLIST');
      // set all habit completed to false since it's a new day
      for (int i = 0; i < todoList.length; i++) {
        todoList[i][1] = false;
      }
    }
    // if it's not a new day, load todays list
    else {
      todoList = _box.get(todaysDateFormatted());
    }
  }

  void updateDatabase() {
    _box.put(todaysDateFormatted(), todoList);
    _box.put('TODOLIST', todoList);

    calculateHabitPercentages();
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todoList.length; i++) {
      if (todoList[i][1] == true) {
        countCompleted++;
      }
    }
    String percent = todoList.isEmpty
        ? '0.0'
        : (countCompleted / todoList.length).toStringAsFixed(2);
    _box.put('PERCENTAGE_SUMMARY${todaysDateFormatted()}', percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_box.get('START_DATE'));
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _box.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}