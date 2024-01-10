import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/todo_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.put(TodoController());
    final TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Harbor',
          style: TextStyle(fontSize: 25.sp, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textEditingController,
                style: TextStyle(fontSize: 20.sp, color: Colors.black),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    todoController.addTodo(value);
                  }
                  textEditingController.clear();
                },
                decoration: InputDecoration(
                    hintText: 'Add a new task...',
                    hintStyle: TextStyle(fontSize: 18.sp, color: Colors.black),
                    prefixIcon: Icon(
                      Icons.work_history_outlined,
                      size: 20.sp,
                      color: Colors.black,
                    ),
                  focusColor: Colors.white
                ),
              ),
            ),
            20.verticalSpace,
            Expanded(
              child: Obx(
                () {
                  final todos = todoController.rxTodos;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white10,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color:
                                      todo.isDone ? Colors.red : Colors.black,
                                  decoration: todo.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              leading: Checkbox(
                                value: todo.isDone,
                                onChanged: (value) {
                                  todoController.updateTodoStatus(
                                      index, value!);
                                },
                                activeColor: Colors.green,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.lightBlue,
                                    ),
                                    onPressed: () {
                                      _showEditDialog(
                                          context, index, todo.title);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      todoController.deleteTodo(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showEditDialog(BuildContext context, int index, String currentTitle) {
  TextEditingController editingController =
      TextEditingController(text: currentTitle);
  final TodoController todoController = Get.find<TodoController>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Edit Task',
          textAlign: TextAlign.center,
        ),
        content: TextField(
          controller: editingController,
          decoration: const InputDecoration(
            labelText: 'New Task',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Call the editTodo function when the user taps "Save"
              todoController.editTodoTitle(index, editingController.text);
              Navigator.of(context).pop();
            },
            child:  Text(
              'Save',
              style: TextStyle(color: Colors.green,fontSize: 18.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child:  Text(
              'Cancel',
              style: TextStyle(color: Colors.redAccent,fontSize: 18.sp),
            ),
          ),
        ],
      );
    },
  );
}
