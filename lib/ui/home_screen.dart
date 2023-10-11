import 'package:flutter/material.dart';

import 'package:todo_bloc_firestore/bloc/home_screen_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_firestore/model/task.dart';

import 'package:todo_bloc_firestore/ui/task_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HomeScreenBloc>().add(LoadTasksEvent());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          elevation: 0,
          shape: Border.all(color: Colors.black),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            _navigateToAddTaskScreen(context);
          }),
      appBar: AppBar(
        title: const Text(
          'Todo List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 4,
                      );
                    },
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];

                      return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: GestureDetector(
                            onTap: () {
                              _navigateToTaskDetails(context, task);
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                            value: task.isCompleted,
                                            onChanged: (isChecked) {
                                              _completeTask(context, task);
                                            }),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(task.title),
                                            Text(task.id),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _deleteTaskClickEvent(context, task);
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    }),
              ),
              const Text(
                'Completed Tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 4,
                    );
                  },
                  itemCount: state.completedTasks?.length ?? 0,
                  itemBuilder: (context, index) {
                    final completedTask = state.completedTasks![index];

                    return Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: GestureDetector(
                          onTap: () {
                            _navigateToTaskDetails(context, completedTask);
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: completedTask.isCompleted,
                                          onChanged: (isChecked) {
                                            _incompleteTask(
                                                context, completedTask);
                                          }),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(completedTask.title),
                                          Text(completedTask.id),
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _deleteTaskClickEvent(
                                            context, completedTask);
                                      },
                                      icon: const Icon(Icons.delete)),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToAddTaskScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TaskFormScreen.create(),
        ));
  }

  void _deleteTaskClickEvent(BuildContext context, Task task) {
    context.read<HomeScreenBloc>().add(RemoveTaskEvent(id: task.id));
  }

  void _navigateToTaskDetails(BuildContext context, Task task) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskFormScreen.update(
            task: task,
          ),
        ));
  }

  void _completeTask(BuildContext context, Task task) {
    context.read<HomeScreenBloc>().add(TaskCompleteEvent(task: task));
  }

  void _incompleteTask(BuildContext context, Task task) {
    context.read<HomeScreenBloc>().add(TaskIncompleteEvent(task: task));
  }
}
