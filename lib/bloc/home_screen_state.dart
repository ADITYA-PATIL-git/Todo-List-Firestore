part of 'home_screen_bloc.dart';

@immutable
class HomeScreenState {
  final List<Task> tasks;
  final List<Task>? completedTasks;
  final String title;
  final DateTime? dueDate;
  final bool isSuccess;

  HomeScreenState copyWith({
    List<Task>? tasks,
    List<Task>? completedTasks,
    String? title,
    DateTime? dueDate,
    bool? isSuccess,
  }) {
    return HomeScreenState(
      tasks: tasks ?? this.tasks,
      completedTasks: completedTasks ?? this.completedTasks,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  const HomeScreenState({
    required this.tasks,
    this.completedTasks,
    required this.title,
    this.dueDate,
    this.isSuccess = false,
  });
}
