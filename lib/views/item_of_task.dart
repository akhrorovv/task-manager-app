import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_manager/controller/home_controller.dart';

import '../models/task_model.dart';

Widget itemOfTask(BuildContext context, Task task, int index, HomeController homeController) {
  return Container(
    margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
    child: Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            padding: const EdgeInsets.all(5),
            autoClose: true,
            onPressed: (BuildContext context) {
              homeController.deleteTask(index);
            },
            foregroundColor: Colors.red,
            borderRadius: BorderRadius.circular(10),
            icon: Icons.delete,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          homeController.showAddBottomSheet(context, task: task, index: index);
        },
        child: Container(
          // height: 60,
          width: double.infinity,
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
                onChanged: (value) => homeController.onChanged(value, index),
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
      ),
    ),
  );
}