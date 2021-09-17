import 'package:flutter/material.dart';
import 'package:dsc/ui/razorpay.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "MYAPP",debugShowCheckedModeBanner: false,
     home: razorPay(),
    );
  }
}
