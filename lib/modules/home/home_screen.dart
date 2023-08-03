import 'package:aamar_task_bloc/modules/home/cubit/home_cubit.dart';
import 'package:aamar_task_bloc/modules/post_details/post_details_view.dart';
import 'package:aamar_task_bloc/shared/component/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:skeletons/skeletons.dart';

import '../../shared/component/search_bar_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => HomeCubit(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = BlocProvider.of<HomeCubit>(context);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomSearchBar(
                    controller: cubit.searchController,
                  ),
                ),
                Expanded(
                  child: BlocConsumer<HomeCubit, HomeState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return SkeletonListView(
                          itemCount: 10,
                        );
                      }
                      if (state is HomeError) {
                        return const Center(
                          child: Text(
                            // cubit.error.value,
                            'some thing went wrong',
                          ),
                        );
                      } else {
                        if (cubit.viewedPosts.isEmpty) {
                          return const Center(
                            child: Text(
                              'there are no posts',
                            ),
                          );
                        } else {
                          return RefreshIndicator(
                            onRefresh: cubit.getAll,
                            child: ListView.builder(
                              itemCount: cubit.viewedPosts.length,
                              itemBuilder: (context, index) => PostItem(
                                post: cubit.viewedPosts[index],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostDetailsView(
                                      post: cubit.viewedPosts[index],
                                    ),
                                  ),
                                ),
                                onFavorite: cubit.toggleFavorite,
                                favorite: cubit.favoritePosts.contains(
                                  cubit.viewedPosts[index],
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
