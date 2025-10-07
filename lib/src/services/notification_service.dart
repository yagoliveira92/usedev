// Arquivo: lib/src/services/notification_service.dart
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ----------------------------------------------------------------------
// 1. Handler para mensagens com o APP FECHADO (Terminated/Background)
// Deve ser uma função de nível superior (top-level) para funcionar corretamente.
// ----------------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Nota: Em produção, você deve chamar o Firebase.initializeApp() aqui,
  // mas vamos assumir que o FlutterFire gerencia isso.
  print("Handling a background message: ${message.messageId}");

  // Opcional: Se a notificação não foi exibida automaticamente, force a exibição
  if (message.notification != null) {
    NotificationService().showLocalNotification(message);
  }
  // Você pode disparar eventos do Bloc/Cubit aqui para atualizar o estado.
}

class NotificationService {
  // Singleton Pattern
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // 1. Configurar o handler de background (para app em segundo plano/terminado)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 2. Solicitar permissões (específico para iOS/macOS)
    await _requestPermission();

    // 3. Configurar Local Notifications para exibir alertas no Foreground
    await _setupLocalNotifications();

    // 4. Configurar os Listeners (app em primeiro plano e interação)
    _setupMessageHandlers();

    // 5. Opcional: Obter e imprimir o Token FCM
    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  Future<void> _requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> _setupLocalNotifications() async {
    const androidInitializationSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosInitializationSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // Inicializa o plugin de notificação local para lidar com o clique na notificação.
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Lógica de navegação após o clique na notificação.
        // O payload pode ser usado para direcionar o usuário para a tela correta.
        print('Notification tapped with payload: ${response.payload}');
        // Exemplo de como usar Bloc/Cubit para navegação:
        // if (response.payload == 'products_update') {
        //   // Navegar para a tela de produtos
        // }
      },
    );
  }

  void _setupMessageHandlers() {
    // ----------------------------------------------------------------------
    // 2. Handler para mensagens com o APP ABERTO (Foreground)
    // ----------------------------------------------------------------------
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');

      // Exibir uma notificação local, pois o FCM não exibe automaticamente no Foreground.
      if (message.notification != null) {
        showLocalNotification(message);
      }
      // Você pode disparar um evento para o Cubit/Bloc para mostrar um modal, etc.
    });

    // ----------------------------------------------------------------------
    // 3. Handler para mensagens com o APP EM SEGUNDO PLANO (Background/Terminated)
    // Usado quando o usuário clica na notificação.
    // ----------------------------------------------------------------------

    // Quando o app estava em SEGUNDO PLANO e foi aberto pelo clique.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published! Navigating...');
      // A lógica de navegação deve ser implementada no handler do local notification (_setupLocalNotifications)
      // ou chamando um método de navegação aqui.
    });

    // Quando o app estava TERMINADO (FECHADO) e foi aberto pelo clique.
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print(
          'App launched from terminated state via notification! Navigating...',
        );
        // O mesmo vale para o getInitialMessage - a lógica de navegação é a mesma.
      }
    });
  }

  // Função auxiliar para exibir a notificação no Foreground/Background (com Data Messages)
  void showLocalNotification(RemoteMessage message) {
    if (message.notification == null) return;

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'Notificações Importantes',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const iosPlatformChannelSpecifics = DarwinNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    // Exibe a notificação local
    _flutterLocalNotificationsPlugin.show(
      message.hashCode, // ID único
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      payload: message.data
          .toString(), // Passa o payload de dados para o handler de clique
    );
  }
}
