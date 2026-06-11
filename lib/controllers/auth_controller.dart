// lib/controllers/auth_controller.dart
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import 'task_controller.dart';

class AuthController {
  final TaskController _dbController = TaskController();

  // Inscription d'un nouvel utilisateur
  Future<bool> registerUser(User user) async {
    try {
      final db = await _dbController.database;
      await db.insert('users', user.toMap());
      return true;
    } catch (e) {
      return false; // Échoue si l'email existe déjà (contrainte UNIQUE)
    }
  }

  // Vérification de la connexion
  Future<bool> loginUser(String email, String password) async {
    final db = await _dbController.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return maps.isNotEmpty;
  }
}
