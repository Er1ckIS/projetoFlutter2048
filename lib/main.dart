import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo 2048',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jogo 2048')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Escolha a dificuldade:', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const Jogo2048Page(nivel: 'Fácil'),
                ));
              },
              child: const Text('Nível Fácil'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const Jogo2048Page(nivel: 'Médio'),
                ));
              },
              child: const Text('Nível Médio'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const Jogo2048Page(nivel: 'Difícil'),
                ));
              },
              child: const Text('Nível Difícil'),
            ),
          ],
        ),
      ),
    );
  }
}

class Jogo2048Page extends StatefulWidget {
  final String nivel;
  const Jogo2048Page({super.key, required this.nivel});

  @override
  State<Jogo2048Page> createState() => _Jogo2048PageState();
}

class _Jogo2048PageState extends State<Jogo2048Page> {
  int movimentos = 0;
  int tamanho = 5;
  List<List<int>> grade = [];

  @override
  void initState() {
    super.initState();
    definirTamanhoGrade();
    inicializarGrade();
  }

  void definirTamanhoGrade() {
    if (widget.nivel == 'Fácil') {
      tamanho = 4;
    } else if (widget.nivel == 'Médio') {
      tamanho = 5;
    } else {
      tamanho = 6;
    }
  }

  void inicializarGrade() {
    grade = List.generate(tamanho, (_) => List.filled(tamanho, 0));
    grade[0][0] = 1;
    grade[tamanho - 1][tamanho - 1] = 1;
  }

  void mover(String direcao) {
    setState(() {
      movimentos++;
      // Aqui você pode implementar a lógica de mover as peças
      print('Movimentou para $direcao');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nível: ${widget.nivel}')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Movimentos: $movimentos', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),

          // Grade
          Expanded(
            child: GridView.builder(
              itemCount: tamanho * tamanho,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: tamanho,
              ),
              itemBuilder: (context, index) {
                int x = index ~/ tamanho;
                int y = index % tamanho;
                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: grade[x][y] != 0 ? Colors.amber : Colors.grey[300],
                  ),
                  child: Center(
                    child: Text(
                      grade[x][y] != 0 ? '${grade[x][y]}' : '',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Botões de movimento
          Column(
            children: [
              ElevatedButton(
                onPressed: () => mover('Cima'),
                child: const Icon(Icons.arrow_upward),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => mover('Esquerda'),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => mover('Direita'),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => mover('Baixo'),
                child: const Icon(Icons.arrow_downward),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
