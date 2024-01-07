import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:task_harbor/adapter/hive_init.dart';

import '../model/todo_model.dart';

class TodoController extends GetxController {
  Box<TodoModel>? todoBox;
  late List<TodoModel> todos; // Use regular List for persistence

  RxList<TodoModel> _rxTodos = <TodoModel>[].obs;
  RxList<TodoModel> get rxTodos => _rxTodos;

  @override
  void onInit() async {
    super.onInit();
    await openBox();
  }

  Future<void> openBox() async {
    try {
      todoBox = await HiveInit.openBox<TodoModel>('todoBox');
      todos = todoBox?.values.toList() ?? []; // Initialize todos with values from the box
      _rxTodos.assignAll(todos); // Update the reactive list
      _rxTodos.bindStream(
        todoBox!.watch().map(
              (event) => (event).value,
        ),
      );
    } catch (e) {
      print('Error initializing Hive box: $e');
    }
  }

  void addTodo(String title) {
    final todo = TodoModel(title, false);
    todoBox?.add(todo);
    todos.add(todo);
    _rxTodos.add(todo); // Update the reactive list
  }

  void editTodoTitle(int index, String newTitle) {
    final todo = todoBox?.getAt(index);
    if (todo != null) {
      todo.title = newTitle;
      todo.save();
      todos[index] = todo;
      _rxTodos.assignAll(todos); // Update the reactive list
    }
  }

  void updateTodoStatus(int index, bool isDone) {
    final todo = todoBox?.getAt(index);
    if (todo != null) {
      todo.isDone = isDone;
      todo.save();
      todos[index] = todo;
      _rxTodos.assignAll(todos); // Update the reactive list
    }
  }

  void deleteTodo(int index) {
    todoBox?.deleteAt(index);
    todos.removeAt(index);
    _rxTodos.assignAll(todos); // Update the reactive list
  }

  List<TodoModel> getTodos() => todos;
}
