import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp()); // ==> notation- one line function/methods

class MyApp extends StatelessWidget{  //entire app is a stateless widget
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'company name generator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; //Set of random word pairs
  final _saved = Set<WordPair>(); //Set of saved words
  final _biggerFont = TextStyle(fontSize: 18.0);  //Style just to adjust font size

  @override
  Widget _buildSuggestions(){
    return ListView.builder(
      padding: EdgeInsets.all(8.0), //Edge padding
      itemBuilder: (context, i){      //itemBuilder called after each suggestion. Item builder creates new line in listview
        if (i.isOdd) return Divider(); //odd rows seprated with divider, even rows adds a list tile/new entry


        //i~/2 is short hand for dividing i by 2 and returning intiger result. aka flooring
        //this index is a calcualtion of the actual words in the list, aka minus the divider rows :) smarttt
        final index = i ~/ 2;  
        if(index >= _suggestions.length){
          _suggestions.addAll(generateWordPairs().take(10));  //If you reached end of word pairings generate 10 more
        }
        return _buildRow(_suggestions[index]);
  });
}

Widget _buildRow(WordPair pair){
  final alreadySaved = _saved.contains(pair);

  return ListTile(
    title: Text(
      pair.asPascalCase,
      style:_biggerFont,
    ),
    trailing: Icon( //trailing widget is for 
      alreadySaved ? Icons.favorite : Icons.favorite_border, //short hand boolean? if false left else right
      color: alreadySaved ? Colors.red : null,
    ),
    onTap: (){  //onTap widget, whgen u tap each listTile
      setState(() { //set state triggers a call to the build method resulting in an update to the UI
        if(alreadySaved) {  
          _saved.remove(pair); //If pair is saved and u press it, remove from saved set 
        } else{
          _saved.add(pair); //If pair is not saved and u press it, add it to saved list :)
        }
      });
    },

  );
}

_pushSaved(){

  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context){
        final tiles = _saved.map(
          (WordPair pair){
            return ListTile(
              title: Text(pair.asPascalCase, style: _biggerFont,),
              trailing: Icon ( Icons.favorite, color:Colors.red,),
              onTap: (){ 
                setState(() {
                  if(_saved.contains(pair)){
                  _saved.remove(pair);
                  Icon(Icons.favorite_border, color: null,);
                  }else
                  {
                    _saved.add(pair);
                  }
                
              });
              },
            );
          },
        );
        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();

        return Scaffold(appBar: AppBar(
                        title:Text('Saved Names'),), 
                        body:ListView(children: divided));
      }
    )
  );
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup company name Generator'),
        actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)], //add icon in top bar, if pressed call pushSaved
        ),
        body: _buildSuggestions(),
    );
  }
}