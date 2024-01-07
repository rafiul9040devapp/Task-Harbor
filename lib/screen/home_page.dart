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
        title: const Text('Task Harbor'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              onSubmitted: (value) {
                todoController.addTodo(value);
                textEditingController.clear();
              },
              decoration: const InputDecoration(
                hintText: 'Add a new task...',
              ),
            ),
            20.verticalSpace,
            Expanded(
              child: Obx(
                () {
                  final todos = todoController.todos;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              title: Text(
                                todo.title,
                                style: TextStyle(
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
                                activeColor: Colors.greenAccent,
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
        title: const Text('Edit Task',textAlign: TextAlign.center,),
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
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      );
    },
  );
}
