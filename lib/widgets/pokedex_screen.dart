import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/api/pokemon_api.dart';
import 'package:myapp/model/pokemon_info.dart';

class Pokedex extends StatefulWidget {
  const Pokedex({super.key});

  @override
  PokedexScreenState createState() => PokedexScreenState();
}

class PokedexScreenState extends State<Pokedex> {
  final apiService = PokemonApi();
  Pokemon? pokemon;
  bool isLoading = false;
  String errorMessage = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  void fetchPokemon() async {
    String name = searchController.text.trim().toLowerCase();
    if (name.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      pokemon = null;
      errorMessage = "";
    });

    try {
      Pokemon? fetchedPokemon = await apiService.fetchPokemon(name);

      setState(() {
        if (fetchedPokemon != null) {
          pokemon = fetchedPokemon;
        } else {
          errorMessage = "Pokémon not found! 😢";
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to fetch Pokémon! ⚠️";
        isLoading = false;
      });
    }
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      pokemon = null;
      errorMessage = "";
      isLoading = false;
    });
  }

  Widget _infoRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: "PixelFont",
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isHighlighted ? Colors.orangeAccent : Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontFamily: "PixelFont",
                fontSize: 14,
                color: isHighlighted ? Colors.black : Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[700]!, Colors.red[900]!], // 🔥 Pokédex Gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10), // ✅ Creates the red border effect
            child: Column(
              children: [
                // 🔍 SEARCH BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Enter Pokémon name...",
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: clearSearch,
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: fetchPokemon,
                        icon: Image.asset(
                          'assets/pokeball.png',  // 🎾 Poké Ball icon
                          width: 50,
                          height: 50,
                          ),
                      ),
                    ],
                  ),
                ),

                // ✅ Main Content (Pokédex UI)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // ✅ Light background
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 3), // ✅ Black outer border
                    ),
                    child: Column(
                      children: [
                        // 🔹 HEADER (Pokédex Title)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          color: Colors.red[900], // ✅ Dark red header
                          child: Center(
                            child: Text(
                              "Gotta Catche'em all!",
                              style: TextStyle(
                                fontFamily: "PixelFont",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // 🔹 DIVIDER LINE (Black Line in Center)
                        Container(
                          height: 4,
                          color: Colors.black,
                        ),

                        // ✅ Pokémon Image or Content
                        Expanded(
                          child: Center(
                            child: isLoading
                                ? Lottie.asset(
                                    'assets/poke_loader_2.json',
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : errorMessage.isNotEmpty
                                    ? Text(
                                        errorMessage,
                                        style: TextStyle(
                                            fontFamily: "PixelFont",
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        textAlign: TextAlign.center,
                                      )
                                    : pokemon == null
                                        ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [Lottie.asset(
                                            'assets/balbasur_lottie.json',
                                            fit: BoxFit.cover,
                                            width:120,
                                            height: 120
                                          ),
                                          SizedBox(height: 10), // 🛑 Space between image and text
                                            Text(
                                              "Welocme to your pokedex! Search for your pokemon or if you want to be surprised type a no. b/w 1 to 1025.",
                                              style: TextStyle(
                                                fontFamily: "PixelFont", // 🎮 Retro Font
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                        ]
                                        )
                                        : Column(
                                            children: [
                                              Image.network(
                                                pokemon!.imageUrl,
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.contain,
                                              ),
                                              SizedBox(height: 10),

                                              // 🔹 MODERNIZED DETAILS PANEL
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(vertical: 30),
                                                color: Colors.blueGrey[900], // ✅ New dark theme
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    _infoRow("ID", "#${pokemon!.id}"),
                                                    _infoRow("Name", pokemon!.name),
                                                    _infoRow("Type", pokemon!.types.join(', '), isHighlighted: true),
                                                    _infoRow("Height", "${pokemon!.height} ft"),
                                                    _infoRow("Weight", "${pokemon!.weight} kg"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
