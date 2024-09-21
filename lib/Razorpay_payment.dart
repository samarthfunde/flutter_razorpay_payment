import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  runApp(MyApp()); // Corrected 'myApp()' to 'MyApp()'
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Razorpay",
      home: RazorpayPayment(title: 'Flutter Demo'),
    );
  }
}

class RazorpayPayment extends StatefulWidget {
  const RazorpayPayment({super.key, required this.title});

  final String title;

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  late Razorpay _razorpay;
  TextEditingController amtController =
      TextEditingController(); // Corrected here

  void openCheckout(int amount) async {
    amount = amount * 100;
    var options = {
      'key':
          'rzp_test_1DP5mm0lF5Gag', // Replace with your actual Razorpay API key
      'amount': amount,
      'name': 'Geeks for Geeks',
      'prefill': {'contact': '1234567890', 'email': 'test@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Successful: " + response.paymentId!,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Failed: " + response.message!,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet: " + response.walletName!,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            Image.network(
                'https://your-image-url.com'), // You can provide an image URL here
            SizedBox(height: 10),
            Text(
              "Welcome to Razorpay Payment Gateway Integration",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.white,
                autofocus: false,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Enter Amount to be paid',
                  labelStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                ),
                controller: amtController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Amount to be paid';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (amtController.text.isNotEmpty) {
                  setState(() {
                    int amount = int.parse(amtController.text);
                    openCheckout(amount);
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Make Payment'),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
