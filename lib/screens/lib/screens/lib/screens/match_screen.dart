import 'package:flutter/material.dart';
import 'chat_screen.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final PageController _controller = PageController();

  final List<Map<String, String>> students = [
    {'name': 'BlueSky', 'college': 'هندسة - سنة 2', 'bio': 'بحب الكود والقهوة ☕'},
    {'name': 'NightOwl', 'college': 'طب - سنة 3', 'bio': 'بذاكر بالليل بس 😴'},
    {'name': 'Sunny', 'college': 'تجارة - سنة 1', 'bio': 'دايماً مبسوطة ✨'},
    {'name': 'CoderX', 'college': 'حاسبات - سنة 4', 'bio': 'Flutter & Python 💻'},
  ];

  void _like(String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('🎉 It\'s a Match!',
            style: TextStyle(color: Color(0xFF03DAC5))),
        content: Text('انت و $name عملتوا إعجاب لبعض!',
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatScreen(name: name)),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBB86FC)),
            child:
                const Text('ابدأ الشات', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
    if (_controller.hasClients) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('تعارف', style: TextStyle(color: Colors.white)),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: students.length,
        itemBuilder: (context, i) {
          final s = students[i];
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A2A5A), Color(0xFF1E1E1E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: const Color(0xFFBB86FC),
                    child: Text(s['name']![0],
                        style: const TextStyle(
                            fontSize: 60, color: Colors.black)),
                  ),
                  const SizedBox(height: 24),
                  Text(s['name']!,
                      style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(s['college']!,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Text(s['bio']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _btn(Icons.close, Colors.red, () => _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut)),
                      _btn(Icons.favorite, const Color(0xFF03DAC5),
                          () => _like(s['name']!)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _btn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }
}
