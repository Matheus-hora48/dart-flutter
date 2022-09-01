import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_contatos/pages/contact_page.dart';
import 'package:lista_contatos/pages/home_page.dart';

void main() {
  runApp(
    const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    )
  );
}