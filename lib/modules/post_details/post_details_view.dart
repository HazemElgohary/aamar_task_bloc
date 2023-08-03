import 'package:aamar_task_bloc/models/post.dart';
import 'package:aamar_task_bloc/shared/component/post_details.dart';
import 'package:flutter/material.dart';

class PostDetailsView extends StatelessWidget {
  final PostModel post;

  const PostDetailsView({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PostDetailsItem(
            post: post,
          ),
        ],
      ),
    );
  }
}
