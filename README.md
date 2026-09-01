# day8_api

A Flutter app that fetches Disney characters from a public API and displays them in a grid.

## App Screen

<img width="500" height="832" alt="image" src="https://github.com/user-attachments/assets/3def1dbe-f970-4225-9e14-26cb2b265b3e" />


## `Api` class (`lib/service/api.dart`)



Handles all communication with the API — fetching and parsing the character data.

```dart
class Api {
  // The endpoint URL we're going to send the request to.
  // This API returns Disney character data in JSON format.
  String link = "https://api.disneyapi.dev/character";

  // "Future" means this function is Asynchronous.
  // It won't return a result immediately — it waits for a response over the network.
  // Once the data arrives, it resolves to a List<DisneyCharacterModel>.
  Future<List<DisneyCharacterModel>> getCharacters() async {
    // Convert the plain String URL into a Uri object.
    // The http package requires a Uri, not a raw String, to send requests.
    var uri = Uri.parse(link);

    // Send a GET request to the server (meaning: "give me the data").
    // "await" means: pause here and wait for the response before continuing.
    var response = await http.get(uri);

    // response.body contains the raw response from the server as a String.
    // In most APIs, this text is formatted as JSON.
    var body = response.body;

    // jsonDecode converts the JSON text into a Dart Map/List we can work with.
    // This step is called "Parsing" or "Decoding".
    var bodyResponse = jsonDecode(body);

    // Empty list that will hold the characters after converting them into Models.
    List<DisneyCharacterModel> listData = [];

    // The actual character data is nested inside the "data" key of the response.
    // So we loop through each item inside bodyResponse["data"].
    for (var item in bodyResponse["data"]) {
      // Each "item" here is a Map (a JSON object).
      // formJson() is a method inside the model that converts that Map into a real Dart object.
      // This step is called "Deserialization" or "Mapping".
      DisneyCharacterModel model = DisneyCharacterModel.formJson(item);
      listData.add(model);
    }

    // Once all items are converted, return the final list to be used in the UI.
    return listData;
  }
}
```

**Key concepts:**
- **Separation of concerns** — API logic lives in its own class, away from the UI.
- **`Future` / `async` / `await`** — network calls take time; `Future` represents a value that arrives later, and `await` pauses execution until it's ready.
- **JSON decoding** — `jsonDecode` turns the raw response text into Dart `Map`/`List` objects.
- **Deserialization** — converting a raw `Map` into a typed Dart object (`DisneyCharacterModel`) so the rest of the app works with safe, structured data instead of raw JSON.

## `CharactersScreen` class (`lib/screens/characters_screen.dart`)

Displays the list of characters fetched by `Api` in a grid, handling loading and loaded states.

```dart
class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.cyanAccent),

      // FutureBuilder is a special widget that rebuilds the UI based on
      // the state of a Future (our API call) — whether it's still loading,
      // finished successfully, or failed with an error.
      body: FutureBuilder(
        // We pass in the Future (the API request) itself.
        // FutureBuilder will watch it and rebuild the UI whenever its state changes.
        future: Api().getCharacters(),

        // The builder function runs automatically every time the Future's state changes.
        // "snapshot" holds the latest state and info about the Future (data, error, connection state...).
        builder: (context, snapshot) {

          // First state: connectionState == waiting
          // This means the request has been sent but the server hasn't responded yet.
          // We show a loading animation until the data arrives.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: Colors.pink,
                rightDotColor: Colors.cyan,
                size: 100,
              ),
            );
          }

          // Second state: connectionState == done
          // This means the Future has finished (whether it succeeded or failed).
          if (snapshot.connectionState == ConnectionState.done) {
            // snapshot.data holds the value returned by getCharacters(),
            // which is our List<DisneyCharacterModel>.
            var allCharacters = snapshot.data;

            // GridView.builder builds grid items lazily —
            // it only builds the items currently visible on screen,
            // which is great for performance with large lists.
            return GridView.builder(
              // Total number of items in the grid.
              // The "!" here means "I'm sure allCharacters is not null".
              itemCount: allCharacters!.length,

              // gridDelegate controls how items are laid out.
              // crossAxisCount: 2 means 2 columns per row.
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),

              // itemBuilder builds one item at a time based on its index.
              itemBuilder: (context, index) {
                // Get the current character from the list using its index.
                var character = allCharacters[index];

                return Card(
                  child: Column(
                    children: [
                      // Image.network loads the image directly from a URL on the internet
                      // (as opposed to Image.asset, which loads from inside your project).
                      Image.network(
                        character.imageUrl!,
                        width: 200,
                        height: 200,
                      ),
                      Text(character.name!),
                    ],
                  ),
                );
              },
            );
          }

          // Fallback case (rarely reached) — e.g. if something went wrong
          // and the connection state isn't waiting/active/done as expected.
          return Text("NO DATA");
        },
      ),
    );
  }
}
```

**Key concepts:**
- **`FutureBuilder`** — rebuilds its UI automatically based on a `Future`'s status (`waiting` → `done`).
- **`ConnectionState`** — tells us where the `Future` currently is: `waiting` (in progress) or `done` (finished).
- **`GridView.builder`** — builds grid items lazily (only what's visible), which is efficient for long lists.
- **`Image.network`** — loads an image from a URL, as opposed to `Image.asset` which loads a bundled local file.
