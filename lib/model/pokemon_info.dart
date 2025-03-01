class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> types;
  final String imageUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.imageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      types:
          (json['types'] as List)
              .map((type) => type['type']['name'].toString())
              .toList(),
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
    );
  }

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'height': height,
      'weight': weight,
      'types': types.join(', '),
      'frontImage': imageUrl,
    };
  }

  // Convert from Map (SQLite to Object)
  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'],
      name: map['name'],
      height: map['height'],
      weight: map['weight'],
      types: (map['types'] as String).split(', '),
      imageUrl: map['frontImage'],
    );
  }
}
