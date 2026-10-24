import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'match_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final feedBox = Hive.box('feedBox');
  final userBox = Hive.box('userBox');

  @override
  void initState() {
    super.initState();
    if (feedBox.isEmpty) _seedData();
  }

  void _seedData() {
    final seed = [
      {
        'author': 'مجهول',
        'college': 'هندسة - سنة 2',
        'text': 'مين الدكاترة اللي محاضراتهم صعبة؟ 😅',
        'likes': 12,
      },
      {
        'author': 'BlueSky',
        'college': 'تجارة - سنة 1',
        'text': 'سؤال صراحة: أكتر حاجة بتضايقك في الكلية؟',
        'likes': 8,
      },
      {
        'author': 'NightOwl',
        'college': 'طب - سنة 3',
        'text': 'أفضل مكان للمذاكرة في الكلية فين؟ ☕',
        'likes': 20,
      },
    ];
    for (final s in seed) {
      feedBox.add(s);
    }
  }

  void _addPost() {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('بوست جديد',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'اكتب حاجة خفيفة...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: const Color(0xFF121212),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (ctrl.text.trim().isNotEmpty) {
                    feedBox.add({
                      'author': userBox.get('nickname', defaultValue: 'مجهول'),
                      'college': userBox.get('college', defaultValue: ''),
                      'text': ctrl.text.trim(),
                      'likes': 0,
                    });
                    Navigator.pop(context);
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBB86FC),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('نشر'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nick = userBox.get('nickname', defaultValue: 'طالب');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text('أهلاً $nick 👋',
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Color(0xFF03DAC5)),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MatchScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPost,
        backgroundColor: const Color(0xFFBB86FC),
        child: const Icon(Icons.edit, color: Colors.black),
      ),
      body: ValueListenableBuilder(
        valueListenable: feedBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(
                child: Text('لا يوجد بوستات بعد',
                    style: TextStyle(color: Colors.grey)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: box.length,
            itemBuilder: (context, i) {
              final post = Map.from(box.getAt(i));
              return _PostCard(
                post: post,
                onLike: () {
                  post['likes'] = (post['likes'] ?? 0) + 1;
                  box.putAt(i, post);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Map post;
  final VoidCallback onLike;
  const _PostCard({required this.post, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFBB86FC),
                child: Text(
                  (post['author'] ?? '?')[0].toUpperCase(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post['author'] ?? 'مجهول',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(post['college'] ?? '',
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(post['text'] ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: onLike,
                child: Row(
                  children: [
                    const Icon(Icons.favorite_border,
                        color: Color(0xFF03DAC5), size: 20),
                    const SizedBox(width: 4),
                    Text('${post['likes'] ?? 0}',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.chat_bubble_outline,
                  color: Colors.grey, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
