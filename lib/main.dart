import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

const String appName = "VAT Calculator";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      title: appName,
      home: const MyHomePage(title: appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum ConvertMethod { removeVAT, addVAT }

class _MyHomePageState extends State<MyHomePage> {
  double _amountToConvert = 0;
  double _vatAmount = 7.7;
  double _difference = 0.00;
  String _differenceFormatted = "0.00";
  double _finalResult = 0;
  String _finalResultFormatted = "0.00";
  ConvertMethod? _convertMethod = ConvertMethod.removeVAT;
  final TextEditingController _vatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vatController.text = _vatAmount.toString();
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  String getDecimalPriceValueFormatted(double value) {
    final _format = NumberFormat("#,##0.00", "de_CH");
    return _format.format(value);
  }

  double getDecimalPriceValue(double value) {
    final _format = NumberFormat("##0.00", "de_CH");
    return double.parse(_format.format(value));
  }

  void _updateText() {
    setState(() {
      if (_convertMethod == ConvertMethod.removeVAT) {
        _finalResultFormatted =
            getDecimalPriceValueFormatted(_removeVAT(_amountToConvert))
                .toString();
        _finalResult = getDecimalPriceValue(_removeVAT(_amountToConvert));
      } else if (_convertMethod == ConvertMethod.addVAT) {
        _finalResultFormatted =
            getDecimalPriceValueFormatted(_addVAT(_amountToConvert)).toString();
        _finalResult = getDecimalPriceValue(_addVAT(_amountToConvert));
      }

      _difference = getDecimalPriceValue(_amountToConvert - _finalResult).abs();
      _differenceFormatted = getDecimalPriceValueFormatted(_difference);
    });
  }

  double _getVATAmount() {
    return _vatAmount / 100;
  }

  double _addVAT(double _netto) {
    return _netto + (_netto * _getVATAmount());
  }

  double _removeVAT(double _brutto) {
    return _brutto / (_getVATAmount() + 1);
  }

  Future<void> _copyToClipboard(String textToCopy) async {
    await Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$textToCopy copied to clipboard'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 5, 0, 5),
          child: Image.asset(
            'assets/vat_calculator_logo.png',
          ),
        ),
        title: Text(widget.title),
        /*actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Go to the next page',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Settings'),
                      ),
                      body: Center(
                          child: IconButton(
                              icon: const Icon(Icons.lightbulb),
                              onPressed: () {})),
                    );
                  },
                ));
              },
            ),
          ),
        ],*/
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(minWidth: 400, maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    SizedBox(
                      width: 190,
                      child: ListTile(
                        title: const Text('Remove VAT'),
                        leading: Radio<ConvertMethod>(
                          activeColor: Colors.green,
                          value: ConvertMethod.removeVAT,
                          groupValue: _convertMethod,
                          onChanged: (ConvertMethod? value) {
                            setState(() {
                              _convertMethod = value;
                            });
                            _updateText();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 190,
                      child: ListTile(
                        title: const Text('Add VAT'),
                        leading: Radio<ConvertMethod>(
                          activeColor: Colors.green,
                          value: ConvertMethod.addVAT,
                          groupValue: _convertMethod,
                          onChanged: (ConvertMethod? value) {
                            setState(() {
                              _convertMethod = value;
                            });
                            _updateText();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _vatController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  decoration: const InputDecoration(
                    label: Text("VAT"),
                    border: OutlineInputBorder(),
                    hintText: 'Enter vat value',
                    prefixIcon: Icon(Icons.account_balance_rounded),
                    suffixText: "%",
                  ),
                  // onSubmitted: _updateText,
                  onChanged: (String input) {
                    _vatAmount = double.parse(input);
                    _updateText();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    decoration: const InputDecoration(
                      label: Text("Price"),
                      border: OutlineInputBorder(),
                      hintText: 'Enter price to convert',
                      prefixIcon: Icon(Icons.price_change),
                      suffixText: "CHF",
                    ),
                    autofocus: true,
                    // onSubmitted: _updateText,
                    onChanged: (String input) {
                      _amountToConvert = double.parse(input);
                      _updateText();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableText.rich(
                        TextSpan(
                          text: "Difference: CHF " + _differenceFormatted,
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey2,
                          ),
                        ),
                        // style: const TextStyle(
                        //     fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                      const Padding(padding: EdgeInsets.fromLTRB(3, 0, 0, 0)),
                      SizedBox(
                        height: 18.0,
                        width: 18.0,
                        child: IconButton(
                          padding: const EdgeInsets.all(0.0),
                          onPressed: () {
                            _copyToClipboard(_difference.toString());
                          },
                          icon: const Icon(Icons.copy),
                          iconSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableText("CHF " + _finalResultFormatted,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () {
                          _copyToClipboard(_finalResult.toString());
                        },
                        icon: const Icon(Icons.copy),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/redgreenbird_Bird_Original.png',
                ),
              ),
              const Text("by redgreenbird"),
            ],
          ),
        ),
      ),
    );
  }
}
