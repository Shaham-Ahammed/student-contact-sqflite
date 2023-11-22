import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
         
    await database.execute(
        """CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     name TEXT,
     age TEXT,
     phone TEXT,
     gender TEXT,
     images TEXT
     
    )""");
  }

  static Future<sql.Database> db() async {

    return sql.openDatabase(
      "data.db",
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createData(String name, String age,String phone,String images,String gender) async {
    final db = await SQLHelper.db();
    final data = {"name":name , "age": age,"phone":phone,"images":images,"gender":gender};
    final id = await db.insert("data", data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLHelper.db();
    return db.query("data", orderBy: "id");
  }

  static Future<int> updateData(int id, String name, String age,String phone,String images,String gender) async {
    final db = await SQLHelper.db();
    final data = {
     "name":name , "age": age,"phone":phone,"images":images,"gender":gender
    };
    final result =
        await db.update("data", data, where: "id=?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db =await SQLHelper.db();
      db.delete("data",where: "id=?",whereArgs: [id]);
  }
}
