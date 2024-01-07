import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:task_harbor/adapter/hive_init.dart';

import '../model/todo_model.dart';

class TodoController extends GetxController {
  Box<TodoModel>? todoBox;
  RxList<TodoModel> todos = <TodoModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    try {
      todoBox = await HiveInit.openBox<TodoModel>('todoBox');
      todos.bindStream(todoBox!.watch().map(
            (event) => (event).value,
      ));
    } catch (e) {
      // Handle the exception, e.g., log an error or show a message to the user
      print('Error initializing Hive box: $e');
    }
  }

  void addTodo(String title) {
    final todo = TodoModel(title, false);
    todoBox?.add(todo);
    todos.add(todo);
  }

  void editTodoTitle(int index, String newTitle) {
    final todo = todoBox?.getAt(index);
    if (todo != null) {
      todo.title = newTitle;
      todo.save();
      todos[index] = todo; // Update the existing todo in the list
    }
  }


  void updateTodoStatus(int index, bool isDone) {
    final todo = todoBox?.getAt(index);
    if (todo != null) {
      todo.isDone = isDone;
      todo.save();
      todos[index] = todo;
    }
  }

  void deleteTodo(int index) {
    todoBox?.deleteAt(index);
    todos.removeAt(index);
  }

  List<TodoModel> getTodos() => todoBox?.values.toList() ?? [];
}