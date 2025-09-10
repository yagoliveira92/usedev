class RatingModel {
  double? rate;
  int? count;

  RatingModel({this.rate, this.count});

  RatingModel.fromJson(Map<String, dynamic> json) {
    // CORREÇÃO AQUI:
    if (json['rate'] != null) {
      if (json['rate'] is int) {
        rate = (json['rate'] as int).toDouble();
      } else if (json['rate'] is double) {
        rate = json['rate'] as double;
      } else if (json['rate'] is String) {
        // Tentar fazer o parse se for uma String
        rate = double.tryParse(json['rate'] as String);
      }
    } else {
      rate = null;
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rate'] = rate;
    data['count'] = count;
    return data;
  }
}
