import 'package:flutter/material.dart';

void main() {
runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
const TaskManagerApp({super.key});

@override
Widget build(BuildContext context) {
    return MaterialApp(
    title: 'Task Manager',
    theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const TaskListScreen(),
    debugShowCheckedModeBanner: false,
    );
}
}

class TaskListScreen extends StatefulWidget {ds
const TaskListScreen({super.key});

@override
State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
final List<Task> _tasks = [];
final TextEditingController _taskController = TextEditingController();

void _addTask() {
    if (_taskController.text.isNotEmpty) {
    setState(() {
        _tasks.add(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _taskController.text,
        isCompleted: false,
        ));
        _taskController.clear();
    });
    }
}

void _deleteTask(String taskId) {
    setState(() {
    _tasks.removeWhere((task) => task.id == taskId);
    });
}

void _toggleTaskCompletion(String taskId) {
    setState(() {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
        _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
    }
    });
}

@override
void dispose() {
    _taskController.dispose();
    super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
    title: const Text('Task Manager'),
    centerTitle: true,
),
body: Column(
    children: [
    Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
        children: [
            Expanded(
            child: TextField(
                controller: _taskController,
                decoration: const InputDecoration(
                labelText: 'Add a new task',
                border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _addTask(),
            ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
            onPressed: _addTask,
            child: const Text('Add'),
            ),
        ],
        ),
    ),
    Expanded(
        child: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
            final task = _tasks[index];
            return Dismissible(
            key: Key(task.id),
            background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) => _deleteTask(task.id),
            child: Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                child: ListTile(
                leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => _toggleTaskCompletion(task.id),
                ),
                title: Text(
                    task.title,
                    style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    ),
                ),
                trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTask(task.id),
                ),
                ),
            ),
            );
        },
        ),
    ),
    Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
        'Total tasks: ${_tasks.length} | Completed: ${_tasks.where((task) => task.isCompleted).length}',
        style: const TextStyle(fontSize: 16),
        ),
    ),
    ],
),
);
}
}

class Task {
final String id;
final String title;
bool isCompleted;

Task({
required this.id,
required this.title,
this.isCompleted = false,
});
}