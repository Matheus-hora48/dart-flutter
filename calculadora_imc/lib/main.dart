import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String infoText = "Informe seus dados";

  void _resetFields() {
    weightController.text = '';
    heightController.text = '';
    setState(() {
      infoText = "Informe seus dados";
      formkey = GlobalKey<FormState>();
    });
  }

  void calculate() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text) / 100;
    double imc = weight / (height * height);
    setState(() {
      if (imc < 18.6) {
        infoText = "Abaixo do Peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        infoText = "Peso Ideal (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        infoText = "Levemente Acima do Peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        infoText = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        infoText = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 40) {
        infoText = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_outline,
                size: 120,
                color: Colors.lightBlueAccent,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: weightController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Insira seu peso";
                  }
                },
                decoration: const InputDecoration(
                  label: Text("Peso (KG)"),
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.lightBlueAccent, fontSize: 25.0),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: heightController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Insira sua altura";
                  }
                },
                decoration: const InputDecoration(
                  label: Text("Altura (CM)"),
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.lightBlueAccent, fontSize: 25.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        calculate();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>((states) {
                        return Colors.lightBlueAccent;
                      }),
                    ),
                    child: const Text(
                      'calcular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                infoText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 25,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
