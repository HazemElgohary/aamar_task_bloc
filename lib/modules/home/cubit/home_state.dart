part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeSuccess extends HomeState {}
class HomeToggleFavorite extends HomeState {}
class HomeError extends HomeState {
  final String error;

  HomeError({required this.error});
}
