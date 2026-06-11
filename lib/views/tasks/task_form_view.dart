// lib/views/tasks/task_form_view.dart
import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../models/task_model.dart';

class TaskFormView extends StatefulWidget {
  final Task? task; // Si null alors Create, sinon Update
  const TaskFormView({Key? key, this.task}) : super(key: key);

  @override
  _TaskFormViewState createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final TaskController _taskController = TaskController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (widget.task == null) {
        // Mode Création
        await _taskController.createTask(
          Task(
            title: _titleController.text,
            description: _descriptionController.text,
          ),
        );
      } else {
        // Mode Mise à jour
        widget.task!.title = _titleController.text;
        widget.task!.description = _descriptionController.text;
        await _taskController.updateTask(widget.task!);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? "Ajouter une tâche" : "Modifier la tâche",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Entrez un titre' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty
                    ? 'Entrez une description'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
