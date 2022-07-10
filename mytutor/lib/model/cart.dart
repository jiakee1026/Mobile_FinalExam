class Cart {
  String? cartId;
  String? subjectId;
  String? subjectName;
  String? subjectPrice;
  String? cartQty;
  String? pricetotal;

  Cart(
      {this.cartId,
      this.subjectId,
      this.subjectName,
      this.subjectPrice,
      this.cartQty,
      this.pricetotal});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    subjectPrice = json['subject_price'];
    cartQty = json['cart_qty'];
    pricetotal = json['price_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['subject_price'] = subjectPrice;
    data['cart_qty'] = cartQty;
    data['price_total'] = pricetotal;
    return data;
  }
}
