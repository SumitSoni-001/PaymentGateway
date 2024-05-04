import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'Secret.dart';

class PaymentGateway extends StatefulWidget {
  const PaymentGateway({super.key});

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  final Razorpay _razorpay = Razorpay();
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Razorpay'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _amountController,
                decoration:InputDecoration(
                  hintText: 'Amount',
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                  // ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {
                openCheckout(int.parse(_amountController.text));
              }, child: Text('Pay'))
            ],
          ),
        ),
      ),
    );
  }

  void initiateRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Success, ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error, ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet, ${response.walletName}');
  }

  void openCheckout(amount) async{
    amount = amount * 100;
    var options = {
      'key': Secret.RAZORPAY_API_KEY,
      'amount': amount,
      'name': 'Sumit Corp.',
      'description': 'Testing App',
      'prefill': {
        'contact': '7234567890',
        'email': 'test@razorpay.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch(e) {
      print('Error : $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

}
