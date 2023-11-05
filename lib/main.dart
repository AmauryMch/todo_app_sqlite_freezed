import 'package:flutter/material.dart';
import 'models/todo_model.dart';
import 'models/database_helper.dart';
import 'pages/addTask.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/addtask': (context) => AddTask(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Todo>> _todos;

  void _addTodo(String newTask) {
    Todo newTodo = Todo(task: newTask, isCompleted: false);
    DatabaseHelper.instance.insert(newTodo);
    setState(
      () {
        _todos = DatabaseHelper.instance.getAllTodos();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _todos = DatabaseHelper.instance.getAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Todo>>(
        future: _todos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          }

          List<Todo>? todos = snapshot.data;
          if (todos != null && todos.isNotEmpty) {
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index];
                return Dismissible(
                  key: Key(todo.id.toString()),
                  onDismissed: (direction) {
                    DatabaseHelper.instance.delete(todo.id!);
                    setState(() {
                      _todos = DatabaseHelper.instance.getAllTodos();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${todo.task} supprimée'),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(right: 16.0),
                  ),
                  child: ListTile(
                    title: Text(todo.task),
                    trailing: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (bool? value) {
                        final updateTodo =
                            todo.copyWith(isCompleted: !todo.isCompleted);
                        DatabaseHelper.instance.update(updateTodo);
                        setState(() {
                          _todos = DatabaseHelper.instance.getAllTodos();
                        });
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Aucune tâche trouvée.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addtask').then((newTask) {
            if (newTask != null && newTask is String) {
              _addTodo(newTask);
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
