import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyStatefulClass extends StatefulWidget {
  @override
  _MyStatefulClassState createState() => _MyStatefulClassState();
}

class _MyStatefulClassState extends State<MyStatefulClass> {
  late DealerData? dealerData; // Nullable

  @override
  void initState() {
    super.initState();
    getDataFromApi();
  }

  Future<void> getDataFromApi() async {
    var client = http.Client();
    var url = Uri.parse("http://172.19.13.194/v1/api/v360/GetDealer");
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "AuthToken": "AE8C5F69-3AD3-41F0-88D3-0ED82762CF8E",
      "Username": "NAMPOSTAPI",
      "Password": "j8FWLC\$g#@2023",
      "OriginID": "NamPost",
      "Action": "GetDealer",
      "MSISDN": "0811582158",
      "Branch": "NAMPOST",
    });

    try {
      var res = await client.post(url, body: body, headers: headers);

      if (res.statusCode == 200) {
        debugPrint("Success with api");
        debugPrint(res.body);
        setState(() {
          dealerData = DealerData.fromJson(json.decode(res.body));
        });
      } else {
        debugPrint('Not Successful');
        // Handle error scenario - set dealerData to null or show an error message
        setState(() {
          dealerData = null;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      // Handle error scenario - set dealerData to null or show an error message
      setState(() {
        dealerData = null;
      });
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Response"),
      ),
      body: Center(
        child: dealerData != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("API Token: ${dealerData!.apiToken}"),
                  Text("API Status: ${dealerData!.apiStatus}"),
                  Text("Dealer MSISDN: ${dealerData!.apiData.dealer.msisdn}"),
                  // Display other properties as needed
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

class DealerData {
  String apiToken;
  String apiStatus;
  ApiData apiData;
  String apiMessage;

  DealerData({required this.apiToken, required this.apiStatus, required this.apiData, required this.apiMessage});

  factory DealerData.fromJson(Map<String, dynamic> json) {
    return DealerData(
      apiToken: json['ApiToken'],
      apiStatus: json['ApiStatus'],
      apiData: ApiData.fromJson(json['ApiData']),
      apiMessage: json['ApiMessage'],
    );
  }
}

class ApiData {
  Dealer dealer;
  String status;
  String message;

  ApiData({required this.dealer, required this.status, required this.message});

  factory ApiData.fromJson(Map<String, dynamic> json) {
    return ApiData(
      dealer: Dealer.fromJson(json['Dealer']),
      status: json['Status'],
      message: json['message'],
    );
  }
}

class Dealer {
  String msisdn;
  String firstName;
  String lastName;
  String idNumber;
  String contactNumber;
  String emailAddress;
  String balance;
  String status;

  Dealer({
    required this.msisdn,
    required this.firstName,
    required this.lastName,
    required this.idNumber,
    required this.contactNumber,
    required this.emailAddress,
    required this.balance,
    required this.status,
  });

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(
      msisdn: json['MSISDN'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      idNumber: json['IDNumber'],
      contactNumber: json['ContactNumber'],
      emailAddress: json['EmailAddress'],
      balance: json['Balance'],
      status: json['Status'],
    );
  }
}
