import 'package:flutter/material.dart';
import 'package:todo_bloc_firestore/model/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_firestore/bloc/home_screen_bloc.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen.update({Key? key, required this.task}) : super(key: key);
  const TaskFormScreen.create({
    Key? key,
  })  : task = null,
        super(key: key);

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late final TextEditingController textEditingController;
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.task?.title);
    dateController =
        TextEditingController(text: widget.task?.dueDate.toString());
    super.initState();
    dateController.text = widget.task!.dueDate.toString();
  }

  String? temp = 'f';

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: SizedBox(
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        context
                            .read<HomeScreenBloc>()
                            .add(TitleChangeEvent(title: value));
                      },
                    ),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(200),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          dateController.text = pickedDate.toString();
                          context
                              .read<HomeScreenBloc>()
                              .add(DueDateChangeEvent(dueDate: pickedDate));
                        } else {
                          const Text('temp');
                        }
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          final newTitle = textEditingController.text;
                          _onSaveClick(context, newTitle);
                        },
                        child: Text(_getTitle))
                  ])),
        ),
      ),
    );
  }

  void _onSaveClick(BuildContext context, String newTitle) {
    FocusScope.of(context).unfocus();
    if (widget.task == null) {
      context.read<HomeScreenBloc>().add(AddTaskEvent());
    } else {
      context
          .read<HomeScreenBloc>()
          .add(UpdateTaskEvent(id: widget.task!.id, newTitle: newTitle));
    }
  }

  String get _getTitle {
    if (widget.task == null) {
      return 'Create Task';
    } else {
      return 'Update Task';
    }
  }
}
