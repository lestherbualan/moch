import 'dart:async';
import 'package:moch/models/loadModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper database = DatabaseHelper._();
  static Database _db;
  static const String DB_NAME = 'mochDatabase.db';

  Future<Database> get db async {
    if (_db != null) return _db;

    _db = await initDb();
    return _db;
  }

  initDb() async {
    //await deleteDatabase(join(await getDatabasesPath(), DB_NAME));
    return await openDatabase(join(await getDatabasesPath(), DB_NAME),
        onCreate: (db, version) async {
      await db.execute(''' CREATE TABLE load(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            recipient TEXT,
            body TEXT,
            isPaid NUMBER,
            value NUMBER,
            createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          ) ''');
    }, version: 1);
  }

  Future saveLoad(recipient, body, isPaid, value) async {
    final _db = await db;
    var resp = await _db.rawInsert('''
      INSERT INTO load(
        recipient,
        body,
        isPaid,
        value
      )VALUES(?,?,?,?)
    ''', [recipient, body, isPaid, value]);
    return resp;
  }

  getLoadInfo() async {
    final _db = await db;
    var resp = await _db.query('load');
    //print(resp);
    if (resp.length == 0) {
      return null;
    } else {
      return resp;
    }
  }

  Future getValueForGraph() async {
    final _db = await db;
    var resp = _db.rawQuery('''
      SELECT value, createdAt FROM load
    ''');
    if (resp != null) {
      return resp;
    }
    return null;
  }
}
