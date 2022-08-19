import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;

  void decrement(){
    setState(() {
      count--;
    });
  }

  void increment(){
    setState(() {
      count++;
    });
  }

  bool get isEmpty => count == 0;
  bool get isFull => count == 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/fundo.jpeg'),
            fit: BoxFit.cover
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Text(
              isFull ? 'Lotado!': 'Pode entrar!', 
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: isFull? Colors.redAccent : Colors.white
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(count.toString(), 
            style: const TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.w800,
                color: Colors.white
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: isEmpty ? null : decrement,
                  style: TextButton.styleFrom(
                    backgroundColor: isEmpty ? Colors.white.withOpacity(0.2) : Colors.white,
                    fixedSize: const Size(100,100),
                    primary: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)
                    )
                  ),
                  child: Text('Saiu',
                    style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isEmpty ? Colors.purple.withOpacity(0.6) : Colors.purple,
                    
                    ),
                  ),
                ),
                const SizedBox(
                  width: 32,
                ),
                TextButton(
                  onPressed: isFull ? null : increment, 
                  style: TextButton.styleFrom(
                    backgroundColor: isFull ? Colors.white.withOpacity(0.2): Colors.white,
                    fixedSize: const Size(100,100),
                    primary: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)
                    )
                  ),
                  child: Text('Entrou',
                    style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isFull ? Colors.purple.withOpacity(0.6) : Colors.purple
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}