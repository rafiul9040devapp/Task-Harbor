import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../model/todo_model.dart';

class HiveInit {
  static Future<void> init() async {
    final appDocumentDir =
    await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(TodoModelAdapter());
  }

  static Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }
}
