import 'dart:convert';
import 'package:http/http.dart' as http;


const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
//  'NRN',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '5B6EDA5B-D533-4338-96EB-B5864D229EB5';

class CoinData {
  String selectedCurrency;
  Future  getCoinData(selectedCurrency) async{
    Map<String, String> cryptoPrices ={};

    for(String crypto in cryptoList) {
      String altURL = '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(altURL);
      if(response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        print(lastPrice);
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
//        print(base);
//        print(quote);
//        return lastPrice;
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;

  }
}
