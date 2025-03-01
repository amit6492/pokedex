import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/pokemon_info.dart';
import '../database/database_helper.dart';

class PokemonApi {
  final String baseUrl = "https://pokeapi.co/api/v2/pokemon/";

  Future<Pokemon?> fetchPokemon(String name) async {
    // ✅ **Check Local Database First**
    Pokemon? cachedPokemon = await DatabaseHelper.instance.getPokemon(name);
    if (cachedPokemon != null) {
      print("✅ Loaded from Database");
      return cachedPokemon;
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl$name'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        Pokemon pokemon = Pokemon.fromJson(jsonData);

        // **Save Pokémon to Local Database**
        await DatabaseHelper.instance.savePokemon(pokemon);
        return pokemon;
      } else {
        return null; // Pokémon Not Found
      }
    } catch (e) {
      print("No Internet - Trying to Load from Database");
      return null;
    }
  }
}
