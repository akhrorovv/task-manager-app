import 'package:flutter/material.dart';
import 'package:task_manager/services/hive_service.dart';

import '../models/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];

  TextEditingController controller = TextEditingController();

  loadTasks() async {
    var tasksList = HiveService.loadTasks();
    setState(() {
      tasks = tasksList;
    });
  }

  deleteTask(int index) async {
    setState(() {
      tasks.removeAt(index);
      HiveService.deleteTask(index);
    });
  }

  addTask() {
    setState(() {
      String taskBody = controller.text;
      Task task = Task(false, taskBody);

      HiveService.storeTask(task);
      controller.clear();
      backToFinish();
      loadTasks();
    });
  }

  backToFinish() {
    Navigator.of(context).pop();
  }

  openDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: const Text("Delete card"),
          content: const Text("Are you sure you want to delete card?"),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  deleteTask(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Add Task',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: controller,
                  maxLines: null,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your task',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () {
                        // Handle the add task action
                        addTask();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onChanged(bool? value, int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone!;
      HiveService.updateTask(index, tasks[index]);
    });
  }

  @override
  void initState() {
    super.initState();

    Task task = Task(false, 'Make ToDo app projects');
    // HiveService.storeTask(task);
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text(
          'TODO',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // actions: const [Icon(Icons.settings)],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return itemOfTask(tasks[index], index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBottomSheet(context);
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget itemOfTask(Task task, int index) {
    return GestureDetector(
      onLongPress: () {
        openDialog(index);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              activeColor: Colors.grey,
              value: task.isDone,
              onChanged: (value) => onChanged(value, index),
            ),
            Flexible(
              child: Text(
                task.taskBody!,
                style: TextStyle(
                  decoration: task.isDone!
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: task.isDone! ? Colors.grey : Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
