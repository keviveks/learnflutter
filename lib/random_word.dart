import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWord extends StatefulWidget {
  @override
  RandomWordState createState() => RandomWordState();
}

class RandomWordState extends State<RandomWord> {
  final _randomWordPairs = <WordPair> [];
  final _savedWordPairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        if (index.isOdd) return Divider();
        final itemIndex = index ~/ 2;
        if (itemIndex >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_randomWordPairs[itemIndex]);
      }
    );
  }

  Widget _buildRow(WordPair word) {
    final alreadySaved = _savedWordPairs.contains(word);

    return ListTile(
      title: Text(word.asPascalCase, 
        style: TextStyle(fontSize: 12),
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPairs.remove(word);
          } else {
            _savedWordPairs.add(word);
          }
        });
      },
    );

  }

  void _showSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair word) {
            return ListTile(
              title: Text(word.asPascalCase,
                style: TextStyle(fontSize: 12),
              )
            );
          });

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Words')
            ),
            body: ListView(children: divided),
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Words Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _showSaved,
          )
        ],
      ),
      body: _buildList(),
    );
  } 
}