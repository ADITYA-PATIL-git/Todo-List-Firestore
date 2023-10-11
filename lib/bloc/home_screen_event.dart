part of 'home_screen_bloc.dart';

@immutable
abstract class HomeScreenEvent {}

class LoadTasksEvent extends HomeScreenEvent {}

class AddTaskEvent extends HomeScreenEvent {}

class RemoveTaskEvent extends HomeScreenEvent {
  final String id;

  RemoveTaskEvent({required this.id});
}

class UpdateTaskEvent extends HomeScreenEvent {
  final String id;
  final String newTitle;

  UpdateTaskEvent({
    required this.id,
    required this.newTitle,
  });
}

class TitleChangeEvent extends HomeScreenEvent {
  final String title;

  TitleChangeEvent({required this.title});
}

class DueDateChangeEvent extends HomeScreenEvent {
  final DateTime dueDate;

  DueDateChangeEvent({required this.dueDate});
}

class TaskCompleteEvent extends HomeScreenEvent {
  final Task task;

  TaskCompleteEvent({required this.task});
}

class TaskIncompleteEvent extends HomeScreenEvent {
  final Task task;

  TaskIncompleteEvent({required this.task});
}
