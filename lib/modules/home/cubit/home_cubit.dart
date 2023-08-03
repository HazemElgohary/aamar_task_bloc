import 'dart:developer';

import 'package:aamar_task_bloc/models/post.dart';
import 'package:aamar_task_bloc/service/offline/favorite_posts.dart';
import 'package:aamar_task_bloc/service/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    getAll();
    getFavoritePosts();

    /// Listen to any change in search and update ui
    searchController.addListener(
      () {
        viewedPosts.clear();
        viewedPosts.addAll(allPosts
            .where((p0) => p0.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList());
      },
    );
  }

  /// controller for search
  final searchController = TextEditingController();

  /// online service get posts from Api
  final service = GetIt.instance<PostService>();
  final allPosts = <PostModel>[];
  final viewedPosts = <PostModel>[];

  Future<void> getAll() async {
    try {
      emit(HomeLoading());
      allPosts.clear();
      allPosts.addAll(
        await service.getPosts(),
      );
      viewedPosts.clear();
      viewedPosts.addAll(allPosts);
      emit(HomeSuccess());
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      emit(HomeError(error: e.toString()));
    }
  }

  /// offline service get favorite posts
  final offlineService = GetIt.instance<FavoritePostsService>();
  final favoritePosts = <PostModel>[];

  Future<void> getFavoritePosts() async {
    try {
      favoritePosts.clear();
      favoritePosts.addAll(
        await offlineService.findManyFromDb(),
      );
      // emit(HomeSuccess());
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      emit(HomeError(error: e.toString()));
    }
  }

  Future<void> toggleFavorite(PostModel post) async {
    await toggleFavoriteLocal(post);
    if (favoritePosts.contains(post)) {
      favoritePosts.remove(post);
    } else {
      favoritePosts.add(post);
    }
    emit(HomeToggleFavorite());
  }

  Future<void> toggleFavoriteLocal(PostModel post) async {
    if (favoritePosts.contains(post)) {
      await offlineService.deleteOneById(post.id);
    } else {
      await offlineService.addPost(post: post);
    }
  }
}
