import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:task_list/data/data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readData().then((data) {
      setState(() {
        toDoList = json.decode(data);
      });
    });
  }

  _onAlertButtonsPressed(context) {
    Alert(
        context: context,
        title: "Adicionar Tarefa",
        content: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                icon: Icon(Icons.title),
                labelText: 'Titulo',
              ),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                icon: Icon(Icons.description),
                labelText: 'Descrição',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              _addTask();
              Navigator.pop(context);
            },
            child: Text(
              "Salvar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          DialogButton(
            color: Colors.red,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancelar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )
        ]).show();
  }

  void _addTask() {
    setState(() {
      Map<String, dynamic> newTask = Map();

      newTask["title"] = titleController.text;
      newTask["description"] = descController.text;
      titleController.text = "";
      descController.text = "";
      newTask['OK'] = false;
      toDoList.add(newTask);
      saveData();
    });
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(index.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-.9, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: CheckboxListTile(
            onChanged: (c) {
              setState(() {
                toDoList[index]["OK"] = c;
                saveData();
              });
              print(c);
            },
            value: toDoList[index]["OK"],
            secondary: CircleAvatar(
              child: Icon(
                toDoList[index]["OK"] ? Icons.check : Icons.error,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toDoList[index]["title"],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    toDoList[index]["description"],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          lastRemoved = Map.from(toDoList[index]);
          lastRemovedPos = index;
          toDoList.removeAt(index);
          saveData();

          final snack = SnackBar(
            content: Text(
              'Tarefa $lastRemoved["title"] removida',
            ),
            action: SnackBarAction(
                label: 'Desfazer',
                onPressed: () {
                  setState(() {
                    toDoList.insert(lastRemovedPos, lastRemoved);
                    saveData();
                  });
                }),
            duration: Duration(
              seconds: 5,
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snack);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Tarefas',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff192a56),
      ),
      backgroundColor: Color(0xff273c75),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        child: ListView.builder(
          itemCount: toDoList.length,
          itemBuilder: buildItem,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: Color(0xffff1744),
        onPressed: () {
          _onAlertButtonsPressed(context);
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
