import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/database.dart';
import '../utils/dialog_box.dart';
import '../utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  final _box = Hive.box('box');
  late TodoDatabase db;

  @override
  void initState() {
    super.initState();
    db = TodoDatabase();
    if (_box.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple[50],
        appBar: AppBar(
          title: const Text('To Do'),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          child: const Icon(Icons.add),
        ),
        body: ReorderableListView.builder(
          itemCount: db.todoList.length,
          itemBuilder: (BuildContext context, int index) {
            return TodoTile(
              key: ValueKey('$index'),
              taskName: db.todoList[index][0],
              isCompleted: db.todoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },
          onReorder: (oldIndex, newIndex) {
          updateMyTiles(oldIndex, newIndex);
        } ,
        ));
  }
  void updateMyTiles(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final List<dynamic> movedItem = db.todoList.removeAt(oldIndex);
      db.todoList.insert(newIndex, movedItem);
    });
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: controller,
            onCancel: () => Navigator.of(context).pop(),
            onSave: saveNewTask,
          );
        });
  }

  void saveNewTask() {
    if (controller.text.isNotEmpty) {
      setState(() {
        db.todoList.add([controller.text, false]);
        controller.clear();
      });
      Navigator.of(context).pop();
      db.updateDatabase();
    } else {
      Navigator.of(context).pop();
    }
  }

  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);});
    db.updateDatabase();
  }
}
