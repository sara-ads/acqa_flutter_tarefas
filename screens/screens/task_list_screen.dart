import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  final DateTime selectedDate;
  const TaskListScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  static List<Task> _allTasks = [];
  final _taskController = TextEditingController();

  List<Task> get _filteredAndSortedTasks {
    List<Task> dayTasks = _allTasks.where((task) {
      return task.date.year == widget.selectedDate.year &&
             task.date.month == widget.selectedDate.month &&
             task.date.day == widget.selectedDate.day;
    }).toList();

    List<Task> pending = dayTasks.where((t) => !t.isCompleted).toList();
    List<Task> completed = dayTasks.where((t) => t.isCompleted).toList();

    pending.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    completed.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

    return [...pending, ...completed];
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Tarefa'),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(hintText: 'Digite o nome da tarefa'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_taskController.text.isNotEmpty) {
                setState(() {
                  _allTasks.add(Task(
                    id: DateTime.now().toString(),
                    title: _taskController.text,
                    date: widget.selectedDate,
                  ));
                });
                _taskController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _filteredAndSortedTasks;
    final formattedDate = "${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas - $formattedDate'),
        backgroundColor: Colors.deepPurple[700],
        foregroundColor: Colors.white,
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('Nenhuma tarefa para este dia.', style: TextStyle(fontSize: 16)))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      activeColor: Colors.deepPurple,
                      onChanged: (value) {
                        setState(() {
                          task.isCompleted = value ?? false;
                        });
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? Colors.grey : Colors.black87,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          _allTasks.removeWhere((t) => t.id == task.id);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[700],
        foregroundColor: Colors.white,
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
