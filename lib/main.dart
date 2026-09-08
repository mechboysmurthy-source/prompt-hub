import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PromptApp());
}

class PromptApp extends StatelessWidget {
  const PromptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Prompt Hub',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F14),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> allPrompts = const [
    {
      'title': 'Cyberpunk Warrior',
      'category': 'Cinematic',
      'icon': Icons.smart_toy_rounded,
      'gradient': [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
      'prompt': 'A hyper-realistic cinematic 8k portrait of a cyberpunk warrior in neon-lit Tokyo rain, shallow depth of field, 85mm lens.'
    },
    {
      'title': '1/7 Scale PVC Figurine',
      'category': 'Collectibles',
      'icon': Icons.view_in_ar_rounded,
      'gradient': [Color(0xFF11998e), Color(0xFF38ef7d)],
      'prompt': 'A high-detail 1/7 scale PVC anime figure on a collector desk, studio softbox lighting, ultra-realistic plastic textures.'
    },
    {
      'title': 'Fantasy Sky Islands',
      'category': 'Landscape',
      'icon': Icons.landscape_rounded,
      'gradient': [Color(0xFF2b5876), Color(0xFF4e4376)],
      'prompt': 'Mythical floating islands with waterfalls falling into clouds, golden hour sunset, Unreal Engine 5 render style.'
    },
  ];

  List<Map<String, dynamic>> displayedPrompts = [];

  @override
  void initState() {
    super.initState();
    displayedPrompts = allPrompts;
  }

  void filterSearch(String query) {
    setState(() {
      displayedPrompts = allPrompts
          .where((p) =>
              p['title']!.toString().toLowerCase().contains(query.toLowerCase()) ||
              p['category']!.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Prompt Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF181824),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: filterSearch,
              decoration: InputDecoration(
                hintText: 'Search styles or prompts...',
                prefixIcon: const Icon(Icons.search, color: Colors.white60),
                filled: true,
                fillColor: const Color(0xFF1E1E2C),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: displayedPrompts.length,
              itemBuilder: (context, index) {
                final item = displayedPrompts[index];
                return Card(
                  color: const Color(0xFF181824),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: item['gradient'],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            item['icon'],
                            size: 64,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['title']!,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(item['category']!, style: const TextStyle(fontSize: 11, color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['prompt']!,
                              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: item['prompt']!));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Prompt Copied!')),
                                  );
                                },
                                icon: const Icon(Icons.copy, size: 16, color: Colors.white),
                                label: const Text('Copy Prompt', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
