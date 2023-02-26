import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:taskly/models/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

late double _screenHeight;
late double _screenWidth;

String? _newTaskContent;
Box? _box; // variable for adding data

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    // print('New Task is ==> $_newTaskContent');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _screenHeight * 0.1,
        title: const Text('Taskly'),
      ),
      body: _buildTaskView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data; // adding data in _box variable
          return _buildTaskList();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildTaskList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        TaskModel taskData = TaskModel.fromMap(tasks[index]);
        return ListTile(
          title: Text(
            taskData.content,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(taskData.timeStamp.toString()),
          trailing: Icon(
            taskData.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank,
          ),
          onTap: () {
            taskData.done = !taskData.done;
            _box!.putAt(index, taskData.toMap());
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(index);
            setState(() {});
          },
        );
      },
    );
  }

  Future<dynamic> _addTask() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          onSubmitted: (_) {
            if (_newTaskContent != null) {
              var newTask = TaskModel(
                content: _newTaskContent!,
                timeStamp: DateTime.now(),
                done: false,
              );
              _box!.add(newTask.toMap());
              setState(() {
                _newTaskContent = null;
              });
              Navigator.pop(context);
            }
          },
          onChanged: (value) {
            setState(() {
              _newTaskContent = value;
            });
          },
        ),
      ),
    );
  }
}
