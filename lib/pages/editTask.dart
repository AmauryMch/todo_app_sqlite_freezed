import 'package:flutter/material.dart';
import 'package:todo_app_sqlite_freezed/models/database_helper.dart';
import 'package:todo_app_sqlite_freezed/models/todo_model.dart';

class EditTask extends StatefulWidget {
  final Todo todo;

  EditTask({required this.todo});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.todo.task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier la tâche'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Tâche'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String updatedTask = _taskController.text;
                Todo updatedTodo = widget.todo.copyWith(task: updatedTask);
                DatabaseHelper.instance.update(updatedTodo);
                Navigator.pop(context, updatedTask);
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
