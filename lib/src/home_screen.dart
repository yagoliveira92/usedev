import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usedev/src/viewmodels/cubit/get_products_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        title: Image.asset('assets/logo.png', height: 40),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.person_2_outlined)),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<GetProductsCubit, GetProductsState>(
        builder: (context, state) {
          if (state is GetProductsLoading) {
            return CircularProgressIndicator();
          }
          if (state is GetProductsSuccess) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) =>
                  Text(state.products[index].title ?? ''),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
