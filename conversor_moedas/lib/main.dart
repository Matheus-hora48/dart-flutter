import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const request = "https://api.hgbrasil.com/finance";

void main() {
  runApp(MaterialApp(
    home: const Home(),
    theme: ThemeData(
        hintColor: Colors.indigoAccent,
        primaryColor: Colors.indigoAccent,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.indigoAccent)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.indigoAccent)),
          hintStyle: TextStyle(color: Colors.indigoAccent),
        )),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  late double dolar;
  late double euro;


  void _realChanged(String text){
    if(text.isEmpty){
      dolarController.text = '';
      euroController.text = '';
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if(text.isEmpty){
      realController.text = '';
      euroController.text = '';
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    if(text.isEmpty){
      realController.text = '';
      euroController.text = '';
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Conversor de \$'),
          backgroundColor: Colors.indigoAccent,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                      child: Text(
                    "Carregando Dados...",
                    style:
                        TextStyle(color: Colors.indigoAccent, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.redAccent, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data!["results"]["currencies"]["USD"]["buy"];
                    euro =
                        snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children:  [
                            const Icon(
                              Icons.monetization_on,
                              size: 150,
                              color: Colors.indigoAccent,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            buildTextField("Reais", "R\$", realController, _realChanged),
                            const SizedBox(
                              height: 16,
                            ),
                            buildTextField("Dolar", "\$", dolarController, _dolarChanged),
                            const SizedBox(
                              height: 16,
                            ),
                            buildTextField("Euros", "€", euroController, _euroChanged),
                          ],
                        ),
                      ),
                    );
                  }
              }
            }));
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return jsonDecode(response.body);
}

Widget buildTextField(String label, String prefix, TextEditingController controllerTextFields, Function functionState) {
  return TextField(
    controller: controllerTextFields,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.indigoAccent),
      border: const OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: const TextStyle(
      color: Colors.indigoAccent,
      fontSize: 20,
    ),
    onChanged: functionState as void Function(String)?,
    keyboardType: TextInputType.number,
  );
}
