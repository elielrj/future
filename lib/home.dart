import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Map<String, dynamic>> _precoFuture;

  @override
  void initState() {
    super.initState();
    _precoFuture = _recuperarPreco();
  }

  Future<Map<String, dynamic>> _recuperarPreco() async {
    try {
      final response = await http.get(_uriDeCriptoMoedas());
      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ao buscar dados: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  Uri _uriDeCriptoMoedas() => Uri.https('blockchain.info', 'ticker');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _recuperarPreco(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar valor.\n${snapshot.hasError}'));
        } else if (snapshot.hasData) {
          final preco = snapshot.data?["BRL"]?["buy"] ?? 0.00;
          return Center(
            child: Text("Preço do bitcoin: R\$ ${preco.toStringAsFixed(2)}"),
          );
        }
        return const Center(child: Text("Nenhum dado encontrado."));
      },
    );
  }
}
