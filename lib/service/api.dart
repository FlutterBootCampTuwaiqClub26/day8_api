import 'dart:convert';

import 'package:day8_api/models/disney_character_model.dart';
import 'package:http/http.dart' as http;

class Api {
  String link = "https://api.disneyapi.dev/character";

  Future<List<DisneyCharacterModel>> getCharacters() async {
    var uri = Uri.parse(link);

    var response = await http.get(uri);
    var body = response.body;
    var bodyResponse = jsonDecode(body);

    List<DisneyCharacterModel> listData = [];

    for (var item in bodyResponse["data"]) {
      DisneyCharacterModel model = DisneyCharacterModel.formJson(item);
      listData.add(model);
    }
    return listData;
  }
}
