class TaskModel {
  String content;
  DateTime timeStamp;
  bool done;

  TaskModel({
    required this.content,
    required this.timeStamp,
    required this.done,
  });

  factory TaskModel.fromMap(Map task) {
    return TaskModel(
      content: task['content'],
      timeStamp: task['timeStamp'],
      done: task['done'],
    );
  }

  Map toMap() {
    return {
      'content': content,
      'timeStamp': timeStamp,
      'done': done,
    };
  }
}
