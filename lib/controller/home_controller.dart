import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/task_model.dart';
import '../services/hive_service.dart';

class HomeController extends GetxController {
  List<Task> tasks = [];
  TextEditingController controller = TextEditingController();

  loadTasks() async {
    var tasksList = HiveService.loadTasks();

    tasks = tasksList;
    update();
  }

  deleteTask(int index) async {
    tasks.removeAt(index);
    HiveService.deleteTask(index);
    update();
  }

  addTask(BuildContext context) {
    String taskBody = controller.text;
    if (taskBody.isEmpty) {
      return;
    }

    Task task = Task(false, taskBody);

    HiveService.storeTask(task);
    controller.clear();
    backToFinish(context);
    loadTasks();
    update();
  }

  updateTask(BuildContext context, int index) {
    tasks[index].taskBody = controller.text;
    HiveService.updateTask(index, tasks[index]);
    controller.clear();
    backToFinish(context);
    loadTasks();
    update();
  }

  backToFinish(BuildContext context) {
    Navigator.of(context).pop();
  }

  onChanged(bool? value, int index) {
    tasks[index].isDone = !tasks[index].isDone!;
    HiveService.updateTask(index, tasks[index]);
    loadTasks();
    update();
  }

  void showAddBottomSheet(BuildContext context, {Task? task, int? index}) {
    if (task != null) {
      controller.text = task.taskBody!;
    }
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
                Text(
                  task == null ? 'Add Task' : 'Update Task',
                  style: const TextStyle(fontSize: 20),
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
                        if (task == null) {
                          addTask(context);
                        } else {
                          updateTask(context, index!);
                        }
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
}
