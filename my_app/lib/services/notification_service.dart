import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const String _notificationsKey = 'notifications';

  static Future<void> addNotification(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString(_notificationsKey);
    List<Map<String, dynamic>> notifications = [];

    if (notificationsJson != null) {
      notifications = (json.decode(notificationsJson) as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    notifications.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      'read': false,
    });

    await prefs.setString(_notificationsKey, json.encode(notifications));
  }

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString(_notificationsKey);

    if (notificationsJson == null) return [];

    return (json.decode(notificationsJson) as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  static Future<void> markAsRead(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString(_notificationsKey);

    if (notificationsJson == null) return;

    List<Map<String, dynamic>> notifications =
        (json.decode(notificationsJson) as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      notifications[index]['read'] = true;
      await prefs.setString(_notificationsKey, json.encode(notifications));
    }
  }
}
