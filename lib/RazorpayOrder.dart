import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paymentgateway/Secret.dart';

class ApiServices {
  final razorPayKey = Secret.RAZORPAY_API_KEY;
  final razorPaySecret = Secret.RAZORPAY_SECRET;

  razorPayApi(num amount, String receiptId) async {
    var auth = 'Basic ' + base64Encode(utf8.encode('$razorPayKey:$razorPaySecret'));
    var headers = {'content-type': 'application/json', 'Authorization': auth};
    var request =
    http.Request('POST', Uri.parse('https://api.razorpay.com/v1/orders'));
    request.body = json.encode({
      // Amount in smallest unit
      // like in paise for INR
      "amount": amount * 100,
      // Currency
      "currency": "INR",
      // Receipt Id
      "receipt": receiptId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      return {
        "status": "success",
        "body": jsonDecode(await response.stream.bytesToString())
      };
    } else {
      return {"status": "fail", "message": (response.reasonPhrase)};
    }
  }
}
