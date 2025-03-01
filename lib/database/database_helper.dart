import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/pokemon_info.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pokedex.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pokemon (
            id INTEGER PRIMARY KEY,
            name TEXT,
            height INTEGER,
            weight INTEGER,
            types TEXT,
            frontImage TEXT
          )
        ''');
      },
    );
  }

  // ✅ **Save Pokémon to Local Database**
  Future<void> savePokemon(Pokemon pokemon) async {
    final db = await instance.database;
    await db.insert(
      'pokemon',
      pokemon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ **Retrieve Pokémon from Local Database**
  Future<Pokemon?> getPokemon(String name) async {
    final db = await instance.database;
    final maps = await db.query(
      'pokemon',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return Pokemon.fromMap(maps.first);
    }
    return null;
  }

  // ✅ **Clear Old Pokémon Data (Optional)**
  Future<void> clearDatabase() async {
    final db = await instance.database;
    await db.delete('pokemon');
  }
}
