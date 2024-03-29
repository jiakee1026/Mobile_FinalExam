class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? regdate;
  String? otp;
  String? credit;
  String? cart;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.regdate,
      required this.otp,
      required this.credit
      required this.cart});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    regdate = json['regdate'];
    otp = json['otp'];
    credit = json['credit'];
    cart = json['cart'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['regdate'] = regdate;
    data['otp'] = otp;
    data['credit'] = credit;
    data['cart'] = cart.toString();
    return data;
  }
}
