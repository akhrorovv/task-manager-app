import 'package:hive/hive.dart';
import '../models/task_model.dart';

class HiveService{
  static var box = Hive.box('box');

  static storeTask(Task task) async {
    box.add(task);
  }

  static List<Task> loadTasks(){
    List<Task> tasks = [];
    for(int i = 0; i < box.length; i++){
      var task = box.getAt(i);
      tasks.add(task);
    }
    return tasks;
  }

  static deleteTask(int index) async{
    box.deleteAt(index);
  }

  static updateTask(int index,Task task) async {
    box.putAt(index, task);
  }
}