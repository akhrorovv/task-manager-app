import 'package:hive/hive.dart';

import '../models/task_model.dart';

class HiveService{
  static var box = Hive.box('box');

  static storeTask(Task task) async {
    box.put('task', task);
  }

  static List<Task> loadTasks(){
    List<Task> tasks = [];
    var task = box.get('task');
    tasks.add(task);
    return tasks;
  }

  static removeTask() async{
    box.delete('task');
  }
}