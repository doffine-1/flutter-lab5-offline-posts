import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/post.dart';

class PostFormScreen extends StatefulWidget {
  final Post? post;
  final bool isEditing;

  const PostFormScreen({super.key, this.post, required this.isEditing});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final DBHelper dbHelper = DBHelper();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.post != null) {
      titleController.text = widget.post!.title;
      bodyController.text = widget.post!.body;
    }
  }

  void savePost() async {
    if (widget.isEditing) {
      await dbHelper.updatePost(
        Post(
          id: widget.post!.id,
          title: titleController.text,
          body: bodyController.text,
        ),
      );
    } else {
      await dbHelper.insertPost(
        Post(title: titleController.text, body: bodyController.text),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? "Edit Post" : "Add Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: "Body"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: savePost, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
