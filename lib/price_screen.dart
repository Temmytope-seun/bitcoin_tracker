import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'AUD';

  DropdownButton<String> andriodDropdown(){
    List<DropdownMenuItem<String>> dropdownItems = [];
    for(String currency in currenciesList){
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value){
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },);
  }

  CupertinoTheme iOSPicker() {

    List<Text> pickerItems = [];
    for(String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoTheme(
      data:  CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          pickerTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      child: CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex){
          print(selectedIndex);
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        },
        children: pickerItems,
      ),

    );

  }
  Map<String, String> bitcoinValue = {};

  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        bitcoinValue = data;
      });
    } catch(e){
      print(e);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              cryptoCard(coinName: 'BTC', bitcoinValue: isWaiting ? '?' : bitcoinValue['BTC'], selectedCurrency: selectedCurrency),
              cryptoCard(coinName: 'ETH', bitcoinValue: isWaiting ? '?' : bitcoinValue['ETH'], selectedCurrency: selectedCurrency),
              cryptoCard(coinName: 'LTC', bitcoinValue: isWaiting ? '?' : bitcoinValue['LTC'], selectedCurrency: selectedCurrency),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:Platform.isIOS ? iOSPicker() : andriodDropdown(),

          ),
        ],
      ),
    );
  }
}

class cryptoCard extends StatelessWidget {
  const cryptoCard({
    Key key,
    @required this.bitcoinValue,
    @required this.selectedCurrency,
    @required this.coinName,
  }) : super(key: key);

  final String bitcoinValue;
  final String selectedCurrency;
  final String coinName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coinName = $bitcoinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


//CupertinoTheme(
//data:  CupertinoThemeData(
//textTheme: CupertinoTextThemeData(
//pickerTextStyle: TextStyle(color: Colors.white),
//),
//),
//child: CupertinoPicker(
//backgroundColor: Colors.lightBlue,
//itemExtent: 32.0,
//onSelectedItemChanged: (selectedIndex){
//print(selectedIndex);
//},
//children: getPickerItem(),
//),
//
//)
