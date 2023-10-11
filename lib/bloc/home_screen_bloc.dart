import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_bloc_firestore/model/task.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc()
      : super(const HomeScreenState(
          tasks: [],
          title: '',
        )) {
    on<LoadTasksEvent>((event, emit) async {
      final tasks = FirebaseFirestore.instance
          .collection('tasks')
          .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
                Task.fromMap(snapshot.data() as Map<String, dynamic>),
            toFirestore: (value, options) => value.toMap(),
          )
          .snapshots()
          .map((event) => event.docs.map((doc) => doc.data()).toList());

      await emit.onEach(
        tasks,
        onData: (data) => emit(HomeScreenState(
          tasks: data.where((element) => element.isCompleted == false).toList(),
          completedTasks:
              data.where((element) => element.isCompleted == true).toList(),
          title: '',
        )),
      );
    });

    on<TitleChangeEvent>(
      (event, emit) {
        emit(state.copyWith(title: event.title));
      },
    );

    on<DueDateChangeEvent>(
      (event, emit) {
        emit(state.copyWith(dueDate: event.dueDate));
      },
    );

    on<AddTaskEvent>((event, emit) async {
      final ref = FirebaseFirestore.instance.collection('tasks').doc();
      final task = Task(
        id: ref.id,
        title: state.title,
        dueDate: state.dueDate,
      );
      await ref.set(task.toMap());

      emit(state.copyWith(isSuccess: true));
    });

    on<RemoveTaskEvent>(
      (event, emit) async {
        final ref =
            FirebaseFirestore.instance.collection('tasks').doc(event.id);

        await ref.delete();
      },
    );

    on<TaskCompleteEvent>((event, emit) async {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('tasks').doc(event.task.id).update({
        'isCompleted': true,
      });
    });

    on<TaskIncompleteEvent>(
      (event, emit) async {
        final firestore = FirebaseFirestore.instance;
        await firestore
            .collection('tasks')
            .doc(event.task.id)
            .update(event.task.toUpdateIsCompletedMap(false));
      },
    );

    on<UpdateTaskEvent>((event, emit) async {
      final ref = FirebaseFirestore.instance.collection('tasks').doc(event.id);

      await ref.update({
        'title': event.newTitle,
      });

      emit(state.copyWith(isSuccess: true));
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }
}
