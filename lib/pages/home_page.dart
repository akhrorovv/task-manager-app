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

  loadTasks() async {
    var tasksList = HiveService.loadTasks();
    setState(() {
      tasks = tasksList;
    });
  }

  @override
  void initState() {
    super.initState();

    Task task = Task(false, 'Make ToDo app project');
    HiveService.storeTask(task);
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        // actions: const [Icon(Icons.settings)],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return itemOfTask(tasks[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget itemOfTask(Task task) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 15, right: 15, left: 15),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            // color: Colors.blue,
            child: Checkbox(
              activeColor: Colors.grey,
              value: task.isDone,
              onChanged: (bool? value) {},
            ),
          ),
          Text(
            task.taskBody!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
