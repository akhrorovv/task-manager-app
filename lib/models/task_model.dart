import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late bool? isDone;

  @HiveField(1)
  late String? taskBody;

  Task(this.isDone, this.taskBody);
}
