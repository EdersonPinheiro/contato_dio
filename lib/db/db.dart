import 'dart:convert';
import 'package:collection/equality.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../model/contato.dart';
import 'package:path/path.dart';

class DB {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "di");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await createTableProducts(db); // PRODUTOS
  }

  Future<void> createTableProducts(Database db) async {
    await db.execute('''
      CREATE TABLE contato (
        localId TEXT PRIMARY KEY,
        image TEXT,
        nome TEXT,
        sobrenome TEXT,
        numero TEXT,
        status TEXT
      )
    ''');
  }

  Future<void> addContato(Contato contato) async {
    final dbClient = await db;
    await dbClient.insert('contato', {
      'localId': contato.localId,
      'image': contato.img,
      'nome': contato.nome,
      'sobrenome': contato.sobrenome,
      'numero': contato.numero,
      'status': contato.status
    });
  }

  Future<List<Contato>> getContatosDB() async {
    print("DB LOCAL");
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('contato');
    List<Contato> contatos = [];
    maps.forEach((map) {
      if (map['status'] != "delete") {
        contatos.add(Contato(
            localId: map['localId'],
            img: map['image'],
            nome: map['nome'],
            sobrenome: map['sobrenome'],
            numero: map['numero'],
            status: map['status']));
      }
    });
    print(maps.length);
    return contatos;
  }

  Future<void> deleteContatoDB(Contato contato) async {
    final dbClient = await db;

    // Atualiza produto na base de dados
    await dbClient.update('contato', {"status": "delete"},
        where: 'localId = ?', whereArgs: [contato.localId]);
  }

  Future<int> updateContato(Contato contato) async {
    final dbClient = await db;
    return await dbClient.update(
      'contato',
      contato.toJson(),
      where: 'localId = ?',
      whereArgs: [contato.localId],
    );
  }
}
