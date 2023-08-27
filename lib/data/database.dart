import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {
  List todoList = [];
  final Box<dynamic> _box = Hive.box('box');

  void createInitialData() {
    todoList = [
      ["Fazer compras", false],
      ["Estudar para o exame", true],
      ["Ir à academia", false]
    ];
  }

  void loadData() {
    todoList = _box.get('TODOLIST') ?? [];
  }

  void updateDatabase() {
    _box.put('TODOLIST', todoList);
  }
}
