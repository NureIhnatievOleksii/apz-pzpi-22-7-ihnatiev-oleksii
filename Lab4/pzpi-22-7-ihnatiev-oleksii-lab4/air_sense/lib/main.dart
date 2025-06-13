import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login/Register Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text("Вхід"), backgroundColor: Colors.teal),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: Colors.teal.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Увійти до облікового запису",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Пароль",
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        final email = emailController.text;
                        final password = passwordController.text;

                        final uri = Uri.parse(
                          'http://localhost:6419/api/auth/login',
                        );
                        final response = await http.post(
                          uri,
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            'email': email,
                            'password': password,
                          }),
                        );

                        if (response.statusCode == 200) {
                          final data = jsonDecode(response.body);
                          final token = data['token'];

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(token: token),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Помилка входу: ${response.body}"),
                            ),
                          );
                        }
                      },
                      child: const Text("Увійти"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Немає облікового запису? Зареєструватись",
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// REGISTER PAGE
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Регистрация"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: Colors.teal.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Создать аккаунт",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      labelText: "Ім'я користувача",
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Пароль",
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        final userName = userNameController.text;
                        final email = emailController.text;
                        final password = passwordController.text;

                        final uri = Uri.parse(
                          'http://localhost:6419/api/auth/register',
                        );
                        final response = await http.post(
                          uri,
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            'userName': userName,
                            'email': email,
                            'password': password,
                          }),
                        );

                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Реєстрація успішна")),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Помилка: ${response.body}"),
                            ),
                          );
                        }
                      },
                      child: const Text("Зареєструватись"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchAirPollutionData();
  }

  Future<Map<String, dynamic>> fetchAirPollutionData() async {
    final url = Uri.parse('http://localhost:6419/api/air-pollution/IoT');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load air pollution data');
    }
  }

  Widget buildDataRow(String label, dynamic value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.blueGrey),
            const SizedBox(width: 8),
          ],
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _refreshData() {
    setState(() {
      _futureData = fetchAirPollutionData();
    });
  }

  int evaluateAirQuality(Map<String, dynamic> data) {
    double co = (data["co"] ?? 0).toDouble();
    double no2 = (data["no2"] ?? 0).toDouble();
    double pm25 = (data["pm2_5"] ?? 0).toDouble();

    double coNorm = (co / 10).clamp(0, 1);
    double no2Norm = (no2 / 200).clamp(0, 1);
    double pm25Norm = (pm25 / 35).clamp(0, 1);

    double scoreRaw = 1 - (coNorm * 0.4 + no2Norm * 0.3 + pm25Norm * 0.3);
    int score = (scoreRaw * 10).round();

    if (score < 1) score = 1;
    if (score > 10) score = 10;

    return score;
  }

  void _showAirQualityScore(Map<String, dynamic> data) {
    final score = evaluateAirQuality(data);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Оцінка якості повітря'),
        content: Text('Якість повітря оцінюється в $score з 10 балів.'),
        actions: [
          TextButton(
            child: const Text('Закрити'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Головна сторінка"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Синхронізувати',
            onPressed: _refreshData,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Немає даних'));
          }

          final data = snapshot.data!;
          DateTime dt = DateTime.parse(data["measuredAt"]);
          String formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(dt);

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              shadowColor: Colors.teal.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Дані щодо забруднення повітря',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const Divider(height: 32, thickness: 2),
                    buildDataRow('CO', data["co"], icon: Icons.cloud),
                    buildDataRow('NO', data["no"], icon: Icons.warning),
                    buildDataRow(
                      'NO2',
                      data["no2"],
                      icon: Icons.warning_amber_rounded,
                    ),
                    buildDataRow('O3', data["o3"], icon: Icons.cloud_queue),
                    buildDataRow('SO2', data["so2"], icon: Icons.smoking_rooms),
                    buildDataRow('PM2.5', data["pm2_5"], icon: Icons.blur_on),
                    buildDataRow(
                      'PM10',
                      data["pm10"],
                      icon: Icons.blur_circular,
                    ),
                    buildDataRow('NH3', data["nh3"], icon: Icons.science),
                    const SizedBox(height: 16),
                    const Divider(),
                    buildDataRow(
                      'Виміряно в',
                      formattedDate,
                      icon: Icons.access_time,
                    ),
                    buildDataRow(
                      'ID пристрою',
                      data["deviceId"],
                      icon: Icons.memory,
                    ),
                    buildDataRow(
                      'Синхронізовано',
                      data["isSynced"] ? "Так" : "Ні",
                      icon: Icons.sync,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.assessment),
                        label: const Text('Оцінити якість повітря'),
                        onPressed: () => _showAirQualityScore(data),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
