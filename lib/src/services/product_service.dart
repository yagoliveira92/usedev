import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:usedev/src/models/products_model.dart';

class ProductService {
  final dio = Dio();

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await dio.get('https://fakestoreapi.com/products');
      final products = (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return products;
      // if (response.statusCode! < 300) {
      //
      // } else {
      //   throw Exception("Deu muito ruim, tente de novo depois");
      // }
    } on Exception {
      throw Exception("Deu muito ruim, tente de novo depois");
    }
  }
}
