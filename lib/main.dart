import 'package:flutter/material.dart';
import 'dart:math';

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
  int tamanho = 4;
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
    adicionarNovaPeca();
    adicionarNovaPeca();
  }

  void adicionarNovaPeca() {
    List<Point<int>> vazios = [];
    for (int i = 0; i < tamanho; i++) {
      for (int j = 0; j < tamanho; j++) {
        if (grade[i][j] == 0) {
          vazios.add(Point(i, j));
        }
      }
    }

    if (vazios.isNotEmpty) {
      final pos = vazios[Random().nextInt(vazios.length)];
      grade[pos.x][pos.y] = Random().nextBool() ? 2 : 4;
    }
  }

  List<int> compactar(List<int> linha) {
    linha = linha.where((val) => val != 0).toList();
    for (int i = 0; i < linha.length - 1; i++) {
      if (linha[i] == linha[i + 1]) {
        linha[i] *= 2;
        linha[i + 1] = 0;
      }
    }
    linha = linha.where((val) => val != 0).toList();
    while (linha.length < tamanho) {
      linha.add(0);
    }
    return linha;
  }

  void mover(String direcao) {
    setState(() {
      bool mudou = false;

      for (int i = 0; i < tamanho; i++) {
        List<int> linha = [];

        for (int j = 0; j < tamanho; j++) {
          switch (direcao) {
            case 'Cima':
              linha.add(grade[j][i]);
              break;
            case 'Baixo':
              linha.add(grade[tamanho - 1 - j][i]);
              break;
            case 'Esquerda':
              linha.add(grade[i][j]);
              break;
            case 'Direita':
              linha.add(grade[i][tamanho - 1 - j]);
              break;
          }
        }

        List<int> novaLinha = compactar(linha);

        for (int j = 0; j < tamanho; j++) {
          int valAntigo;
          switch (direcao) {
            case 'Cima':
              valAntigo = grade[j][i];
              grade[j][i] = novaLinha[j];
              if (valAntigo != grade[j][i]) mudou = true;
              break;
            case 'Baixo':
              valAntigo = grade[tamanho - 1 - j][i];
              grade[tamanho - 1 - j][i] = novaLinha[j];
              if (valAntigo != grade[tamanho - 1 - j][i]) mudou = true;
              break;
            case 'Esquerda':
              valAntigo = grade[i][j];
              grade[i][j] = novaLinha[j];
              if (valAntigo != grade[i][j]) mudou = true;
              break;
            case 'Direita':
              valAntigo = grade[i][tamanho - 1 - j];
              grade[i][tamanho - 1 - j] = novaLinha[j];
              if (valAntigo != grade[i][tamanho - 1 - j]) mudou = true;
              break;
          }
        }
      }

      if (mudou) {
        movimentos++;
        adicionarNovaPeca();
        checarVitoriaEDerrota();
      }
    });
  }

  void checarVitoriaEDerrota() {
    for (var linha in grade) {
      if (linha.contains(2048)) {
        mostrarMensagem('Você venceu! 🎉');
        return;
      }
    }

    if (!possuiMovimentos()) {
      mostrarMensagem('Você perdeu! 😢');
    }
  }

  bool possuiMovimentos() {
    for (int i = 0; i < tamanho; i++) {
      for (int j = 0; j < tamanho; j++) {
        if (grade[i][j] == 0) return true;
        if (j + 1 < tamanho && grade[i][j] == grade[i][j + 1]) return true;
        if (i + 1 < tamanho && grade[i][j] == grade[i + 1][j]) return true;
      }
    }
    return false;
  }

  void mostrarMensagem(String texto) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 400),
            scale: 1,
            child: AlertDialog(
              title: Text(texto),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      inicializarGrade();
                      movimentos = 0;
                    });
                  },
                  child: const Text('Jogar Novamente'),
                ),
              ],
            ),
          ),
        );
      },
    );
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

          Expanded(
            child: GridView.builder(
              itemCount: tamanho * tamanho,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: tamanho,
              ),
              itemBuilder: (context, index) {
                int x = index ~/ tamanho;
                int y = index % tamanho;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
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
