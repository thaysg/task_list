import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<File> getFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File("${directory.path}/data.json");
}

Future<File> saveData() async {
  String data = json.encode(toDoList);
  final file = await getFile();
  return file.writeAsString(data);
}

Future<String> readData() async {
  try {
    final file = await getFile();
    return file.readAsString();
  } catch (e) {
    return null;
  }
}

List toDoList = [];

Map<String, dynamic> lastRemoved;
int lastRemovedPos;
