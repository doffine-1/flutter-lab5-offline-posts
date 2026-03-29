import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/post.dart';
import 'post_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper dbHelper = DBHelper();

  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  void loadPosts() {
    posts = dbHelper.getPosts();
  }

  void refresh() {
    setState(() {
      loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offline Posts Manager")),

      body: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final post = data[index];

              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PostFormScreen(post: post, isEditing: true),
                    ),
                  ).then((_) => refresh());
                },

                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await dbHelper.deletePost(post.id!);
                    refresh();
                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PostFormScreen(isEditing: false),
            ),
          ).then((_) => refresh());
        },
      ),
    );
  }
}
