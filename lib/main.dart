import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final _suggestions = <WordPair>[];
final _saved = <WordPair>{};
final _biggerFont = const TextStyle(fontSize: 18);
String view = 'lista';

class ArgumentosHome {
  final WordPair nome;
  final int id;

  ArgumentosHome({
    required this.nome,
    required this.id,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const RandomWords(),
        TelaEditar.routeName: (context) => const TelaEditar(),
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Favoritos'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  corpo() {
    if (view == 'lista') {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 40,
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final alreadySaved = _saved.contains(_suggestions[index]);

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/editar',
                arguments: ArgumentosHome(
                  nome: _suggestions[index],
                  id: index,
                ),
              );
            },
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(_suggestions[index]);
                  } else {
                    _saved.add(_suggestions[index]);
                  }
                });
              },
              icon: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              ),
            ),
          );
        },
      );
    } else {
      return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: const EdgeInsets.all(16.0),
        itemCount: 20,
        itemBuilder: (context, i) {
          if (i >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          final alreadySaved = _saved.contains(_suggestions[i]);
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/editar',
                arguments: ArgumentosHome(
                  nome: _suggestions[i],
                  id: i,
                ),
              );
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _suggestions[i].asPascalCase,
                    style: _biggerFont,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (alreadySaved) {
                          _saved.remove(_suggestions[i]);
                        } else {
                          _saved.add(_suggestions[i]);
                        }
                      });
                    },
                    icon: Icon(
                      alreadySaved ? Icons.favorite : Icons.favorite_border,
                      color: alreadySaved ? Colors.red : null,
                      semanticLabel:
                          alreadySaved ? 'Remove from saved' : 'Save',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  view = 'lista';
                  setState(() {});
                },
                icon: const Icon(Icons.list_alt_outlined),
              ),
              IconButton(
                onPressed: () {
                  view = 'bloco';
                  setState(() {});
                },
                icon: const Icon(Icons.dataset_outlined),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.push_pin),
            onPressed: _pushSaved,
            tooltip: 'Favoritos',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/editar',
                arguments: ArgumentosHome(
                  nome: WordPair('.', '.'),
                  id: -1,
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: corpo(),
    );
  }
}

class TelaEditar extends StatefulWidget {
  const TelaEditar({super.key});

  static const routeName = '/editar';

  @override
  State<TelaEditar> createState() => _TelaEditarState();
}

class _TelaEditarState extends State<TelaEditar> {
  final firstController = TextEditingController();
  final secondController = TextEditingController();

  onSubmit() {
    final argumentos =
        ModalRoute.of(context)?.settings.arguments as ArgumentosHome;

    final first = firstController.text;
    final second = secondController.text;

    if (first.isEmpty || second.isEmpty) {
      return;
    }

    _suggestions[argumentos.id] = WordPair(first, second);
    Navigator.pushNamed(context, '/');
  }

  addToList() {
    final first = firstController.text;
    final second = secondController.text;

    if (first.isEmpty || second.isEmpty) {
      return;
    }

    _suggestions.add(WordPair(first, second));
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final argumentos =
        ModalRoute.of(context)?.settings.arguments as ArgumentosHome;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar palavra'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Digite sua alteração: ',
            style: TextStyle(
              fontSize: 40,
              color: Colors.deepPurple,
            ),
          ),
          Center(
            child: Text(
              argumentos.nome.asPascalCase,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(
            width: 500,
            child: TextField(
              controller: firstController,
              decoration: const InputDecoration(
                  labelText: 'Primeira palavra do novo nome'),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 500,
            child: TextField(
              controller: secondController,
              decoration: const InputDecoration(
                  labelText: 'Segunda palavra do novo nome'),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed:
                    argumentos.nome.asPascalCase == '..' ? null : onSubmit,
                child: const Text('Alterar'),
              ),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                onPressed:
                    argumentos.nome.asPascalCase == '..' ? addToList : null,
                child: const Text('Adicionar'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
