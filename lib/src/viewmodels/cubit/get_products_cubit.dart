import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:usedev/src/models/products_model.dart';
import 'package:usedev/src/services/product_service.dart';

part 'get_products_state.dart';

class GetProductsCubit extends Cubit<GetProductsState> {
  GetProductsCubit({required this.productService})
    : super(GetProductsInitial());

  final ProductService productService;

  void getAllProducts() async {
    emit(GetProductsLoading());
    final products = await productService.getAllProducts();
    emit(GetProductsSuccess(products: products));
  }
}
