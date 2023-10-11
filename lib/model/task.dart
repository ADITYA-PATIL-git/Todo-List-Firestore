import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String title;
  String id;
  DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "dueDate": dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      "isCompleted": isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    final Timestamp? timestamp = map['dueDate'] as Timestamp?;
    return Task(
      id: map['id'],
      title: map['title'],
      dueDate: timestamp?.toDate(),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toUpdateIsCompletedMap(bool value) {
    return {
      "isCompleted": value,
    };
  }

  void markComplete() {
    isCompleted = true;
  }

  void markIncomplete() {
    isCompleted = false;
  }
}
