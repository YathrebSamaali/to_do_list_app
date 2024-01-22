import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Task {
  String name;
  bool isCompleted;

  Task(this.name, this.isCompleted);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();
  TextEditingController editController = TextEditingController();

  int editingIndex =
      -1; // Indique l'index de la tâche en cours d'édition, -1 s'il n'y en a pas.

  void addTask(String taskName) {
    setState(() {
      tasks.add(Task(taskName, false));
    });
    taskController.clear();
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      editingIndex = -1; // Réinitialise l'index d'édition après la suppression
    });
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void startEditing(int index) {
    setState(() {
      editingIndex = index;
      editController.text = tasks[index].name;
    });
  }

  void finishEditing(int index) {
    setState(() {
      tasks[index].name = editController.text;
      editingIndex = -1; // Termine l'édition
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('To-Do List')),
        backgroundColor: const Color.fromARGB(255, 30, 124, 201),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: taskController,
              decoration: InputDecoration(
                hintText: 'Enter a new task',
                fillColor: const Color.fromARGB(255, 255, 255, 253),
                filled: true,
              ),
              onSubmitted: (value) => addTask(value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding:
                      EdgeInsets.zero, // Pour éliminer le padding par défaut
                  title: Row(
                    children: [
                      Checkbox(
                        value: tasks[index].isCompleted,
                        onChanged: (value) => toggleTaskCompletion(index),
                        activeColor: Colors.green,
                      ),
                      SizedBox(
                          width:
                              8), // Ajustement pour réduire l'espace entre l'icône d'édition et la checkbox
                      Expanded(
                        child: editingIndex == index
                            ? TextField(
                                controller: editController,
                              )
                            : Text(
                                tasks[index].name,
                                style: TextStyle(
                                  color: tasks[index].isCompleted
                                      ? Colors.grey
                                      : Colors.black,
                                  decoration: tasks[index].isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          if (editingIndex == -1) {
                            startEditing(index);
                          } else {
                            finishEditing(editingIndex);
                          }
                        },
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTask(index),
                    color: Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
