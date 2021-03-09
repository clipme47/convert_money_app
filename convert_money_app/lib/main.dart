import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ExchabgeRate.dart';
import 'MoneyBox.dart';

void main() {
  runApp(MyApp());
}

//สร้างwidget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      home: MyHomepage(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}

class MyHomepage extends StatefulWidget {
  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  ExchangeRate _dataFromAPI;

  @override
  void initState() {
    super.initState();
    getexchangerate();
  }

  Future<ExchangeRate> getexchangerate() async {
    Uri url = Uri.parse("https://api.exchangeratesapi.io/latest?base=THB");
    var response = await http.get(url);
    _dataFromAPI = exchangeRateFromJson(response.body);
    return _dataFromAPI;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            " อัตราการแลกเปลี่ยนสกุลเงิน",
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder(
          future: getexchangerate(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //เช็ดการดึงข้อมูล
            if (snapshot.connectionState == ConnectionState.done) {
              var result = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    MoneyBox("สกุลเงิน (THB)", 1, Colors.orange, 100),
                    SizedBox(
                      height: 5,
                    ),
                    MoneyBox(
                        "สกุลเงิน EUR", result.rates["EUR"], Colors.blue, 100),
                    SizedBox(
                      height: 5,
                    ),
                    MoneyBox(
                        "สกุลเงิน USD", result.rates["USD"], Colors.red, 100),
                  ],
                ),
              );
            }
            return LinearProgressIndicator();
          },
        ));
  }
}
