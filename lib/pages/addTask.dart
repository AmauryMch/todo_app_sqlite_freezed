import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une tâche'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 500,
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(labelText: 'Nouvelle tâche'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: () {
                  String newTask = textEditingController.text;
                  if (newTask.isNotEmpty) {
                    Navigator.pop(context, newTask);
                  }
                },
                child: Text("Valider"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
