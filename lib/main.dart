import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '２人のお金'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _HomePage();
}

enum RadioValue {Haruki,Mayu}

class _HomePage extends State<MyHomePage> {
  List<Map<String, dynamic>> _items_value = [];
  RadioValue _groupValue = RadioValue.Haruki;
  final _editedController_value = TextEditingController();
  final int value=0;
  final String radioValue='';
  late String _name = 'Haruki'; // name をクラスのメンバーとして宣言
  late int _sum = 0; // sum をクラスのメンバーとして宣言

  _onRadioSelected(value) {
    setState(() {
      _groupValue = value;
    });
  }

  _controllerTextToInt() {
    setState(() {
      if (_editedController_value.text.isNotEmpty) {
        int value = int.parse(_editedController_value.text);
        String selectedRadioValue = _radioValueToString();
        Map<String, dynamic> newItem = {
          'value': value,
          'radioValue': selectedRadioValue,
        };
        _items_value.add(newItem); // Map を追加する
        _editedController_value.text = '';
      }
    });
    Summarise_value();
  }

  Summarise_value_Haruki() {
    num sum_Haruki = 0; // num 型で sum を宣言
    for (int i = 0; i < _items_value.length; i++) {
      if (_items_value[i]['radioValue'] == 'Haruki') {
        sum_Haruki += _items_value[i]['value'] as num; // num 型に変換
      }
    }
    return sum_Haruki.toInt(); // int 型に変換して返す
  }

  Summarise_value_Mayu() {
    num sum_Mayu = 0; // num 型で sum を宣言
    for (int i = 0; i < _items_value.length; i++) {
      if (_items_value[i]['radioValue'] == 'Mayu') {
        sum_Mayu += _items_value[i]['value'] as num; // num 型に変換
      }
    }
    return sum_Mayu.toInt(); // int 型に変換して返す
  }

  Summarise_value() {
    int sum_Haruki = Summarise_value_Haruki();
    int sum_Mayu = Summarise_value_Mayu();
    if (sum_Haruki > sum_Mayu) {
      _sum = sum_Haruki - sum_Mayu;
      _name = 'Haruki';
    } else {
      _sum = sum_Mayu - sum_Haruki;
      _name = 'Mayu';
    }
    return _sum; // int 型に変換して返す
  }


  String _radioValueToString() {

    if (_groupValue == RadioValue.Haruki) {
      return 'Haruki';
    } else {
      return 'Mayu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100),
              TextFormField(
                controller: _editedController_value,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '借りた金額',
                ),
              ),
              SizedBox(height: 20),
              Text(
                '誰から借りた？',
                style: TextStyle(fontSize: 17),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 180,
                      height: 50,
                      child: RadioListTile(
                        value: RadioValue.Haruki,
                        title: Text('Haruki'),
                        groupValue: _groupValue,
                        onChanged: (value) => _onRadioSelected(value),
                      ),
                    ),
                    Container(
                      width: 180,
                      height: 50,
                      child: RadioListTile(
                        value: RadioValue.Mayu,
                        title: Text('Mayu'),
                        groupValue: _groupValue,
                        onChanged: (value) => _onRadioSelected(value),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 200,
                child: FloatingActionButton.extended(
                  label: Text(
                    '登録',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: _controllerTextToInt,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  '$_name に $_sum 円返す',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    int value = _items_value[index]['value'];
                    String radioValue = _items_value[index]['radioValue'];
                    return ListTile(
                      title: Text('$value 円 - $radioValue'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('削除しますか？'),
                                actions: [
                                  TextButton(
                                    child: Text('はい'),
                                    onPressed: () {
                                      setState(() {
                                        _items_value.removeAt(index);
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('いいえ'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                  itemCount: _items_value.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

