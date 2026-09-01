class DisneyCharacterModel {
  int? id;
  String? name;
  String? imageUrl;

  DisneyCharacterModel({this.id, this.imageUrl, this.name});

  factory DisneyCharacterModel.formJson(Map<String,dynamic> json){
    return DisneyCharacterModel(
      id: json["_id"] ?? 0,
      name: json["name"] ?? "no Name",
      imageUrl: json["imageUrl"] ?? "https://media.discordapp.net/attachments/1540546350201053254/1544360827434569818/cartoon-boy-holding-red-sign-that-says-no_1023618-45225.jpg.avif?ex=6a98399a&is=6a96e81a&hm=20913e25729e97dec6c414704403354c0fbfe139813b483effb41f41723a7fae&=&format=webp&quality=lossless&width=1480&height=1480"
    );
  }
}