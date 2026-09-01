import 'package:day8_api/service/api.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.cyanAccent),
      body: FutureBuilder(
        future: Api().getCharacters(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: Colors.pink,
                rightDotColor: Colors.cyan,
                size: 100,
              ),
            );
          }
          if(snapshot.connectionState == ConnectionState.done){
            var allCharacters = snapshot.data;
            return GridView.builder(
              itemCount: allCharacters!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                var character = allCharacters[index];
                return Card(
                  child: Column(
                    children: [
                      Image.network(character.imageUrl!, width: 200,height: 200,), 
                      Text(character.name!)
                    ],
                  ),
                );
              },
            );
          }
          return Text("NO DATA");
        },
      ),
    );
  }
}
