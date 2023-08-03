import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// ignore: depend_on_referenced_packages
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


import 'helpers/api.dart';
import 'helpers/end_points.dart';
import 'service/offline/databse/db.dart';
import 'service/offline/favorite_posts.dart';
import 'service/posts.dart';

Future<void> inject() async{
  WidgetsFlutterBinding.ensureInitialized();
  final locator = GetIt.instance;
  final dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl,
      validateStatus: (_) => true,
      followRedirects: true,
      contentType: 'application/json',
      headers: {'accept': 'application/json'},
      listFormat: ListFormat.csv,
    ),
  )..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90));
  locator.registerLazySingleton(() => DioWrapper(dio),);


  /// * Offline Database
  final db = await DatabaseServices.boot();


  /// services
  locator.registerLazySingleton(() => PostService(dio));
  locator.registerLazySingleton(() => FavoritePostsService(db));
}