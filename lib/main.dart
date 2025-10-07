import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usedev/src/home_screen.dart';
import 'package:usedev/src/services/notification_service.dart';
import 'package:usedev/src/services/product_service.dart';
import 'package:usedev/src/viewmodels/cubit/get_products_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetProductsCubit(productService: ProductService())..getAllProducts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UseDev',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
