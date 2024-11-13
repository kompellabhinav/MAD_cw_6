import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  // TaskScreenList
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _taskController = TextEditingController();
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref("tasks");

  List<String> tasks = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.down,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  tasks[index],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    deleteTask(tasks[index]);
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    labelText: 'Enter task name',
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                  onSubmitted: (taskName) {
                    if (taskName.isNotEmpty) {
                      addTask(taskName);
                      setState(() {
                        taskName = '';
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_taskController.text.isNotEmpty) {
                    addTask(_taskController.text);
                    setState(() {
                      _taskController.text = '';
                    });
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    retriveData();
    setState(() {});
    super.initState();
  }

  void addTask(String taskName) {
    debugPrint("Add");
    DatabaseReference database = FirebaseDatabase.instance.ref("tasks");
    String data = taskName;
    database.push().set(data);
    retriveData();
    setState(() {});
  }

  Future<void> retriveData() async {
    tasks = [];
    DatabaseEvent data = await databaseReference.once();
    Object? strData = data.snapshot.value;
    if (strData != null) {
      String jsonEn = jsonEncode(strData);

      Map<String, dynamic> jsonDe = jsonDecode(jsonEn);
      Iterable<dynamic> vals = jsonDe.values;
      for (String val in vals) {
        tasks.add(val);
      }
    }
    setState(() {});
  }

  void toogleCompletion(int index) {
    setState(() {});
  }

  Future<void> deleteTask(String taskName) async {
    String deleteKey = '';
    DatabaseEvent data = await databaseReference.once();
    Object? strData = data.snapshot.value;
    String jsonEn = jsonEncode(strData);
    Map<String, dynamic> jsonDe = jsonDecode(jsonEn);
    for (final String key in jsonDe.keys) {
      if (jsonDe[key] == taskName) {
        deleteKey = key;
      }
    }
    if (deleteKey != '') {
      await databaseReference.child(deleteKey).remove();
      retriveData();
    }
  }
}
