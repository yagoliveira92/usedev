import 'package:usedev/src/models/rating_model.dart';

class ProductModel {
  int? id;
  String? title;
  double? price;
  String? description;
  String? category;
  String? image;
  RatingModel? rating;

  ProductModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['price'] != null) {
      if (json['price'] is int) {
        price = (json['price'] as int).toDouble();
      } else if (json['price'] is double) {
        price = json['price'] as double;
      } else if (json['price'] is String) {
        price = double.tryParse(json['price'] as String);
      }
    } else {
      price = null;
    }
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating = json['rating'] != null
        ? RatingModel.fromJson(json['rating'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['category'] = category;
    data['image'] = image;
    if (rating != null) {
      data['rating'] = rating!.toJson();
    }
    return data;
  }
}
