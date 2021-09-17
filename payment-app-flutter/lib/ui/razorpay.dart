import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
class razorPay extends StatefulWidget {
  @override
  _razorPayState createState() => _razorPayState();
}

class _razorPayState extends State<razorPay> {
  int totalAmount=0;
  Razorpay _razorpay;
  @override
  void initState(){
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,_handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,_handleExternalWallet);

  }
  @override
  void dispose(){
    super.dispose();
    _razorpay.clear();
  }
  void openCheckout() async {
    var OPTIONS = {
      'key': 'rzp_test_HTesLF04gaqzSd',//enter your secret key from razor pay dash board.
      'amount': totalAmount * 100,
      'name': 'bera ', //as per your company name.
      'description': 'Test Payment',
      'prefill': {'contact': '', 'email': ''}, //what do you want form user mine was email and contact.
      'external': {'wallets': ['paytm']},
    };
    try
    {
      _razorpay.open(OPTIONS);
    }
    catch(e){
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(msg: "success"+response.paymentId);
  }
  void _handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: "error"+response.code.toString()+"."+response.message);
  }
  void _handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: "External Wallet"+response.walletName);
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: 150.0,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Pay amount',
                ),
                onChanged: (value){
                  setState(() {
                    totalAmount = num.parse(value);
                  });
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
                child:Text("Pay Now",style:TextStyle(color:Colors.teal,fontSize: 22.0,fontWeight: FontWeight.bold),),
            onPressed: (){
              openCheckout();
            },)
          ],
        ),
      ),
    );
  }
}

