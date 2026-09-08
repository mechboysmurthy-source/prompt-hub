import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

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
  final List<Map<String, String>> allPrompts = const [
    {
      'title': 'Cyberpunk Warrior',
      'category': 'Cinematic',
      'image': 'https://images.pexels.com/photos/2599244/pexels-photo-2599244.jpeg?auto=compress&cs=tinysrgb&w=600',
      'prompt': 'A hyper-realistic cinematic 8k portrait of a cyberpunk warrior in neon-lit Tokyo rain, shallow depth of field, 85mm lens.'
    },
    {
      'title': '1/7 Scale PVC Figurine',
      'category': 'Collectibles',
      'image': 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600&auto=format&fit=crop',
      'prompt': 'A high-detail 1/7 scale PVC anime figure on a collector desk, studio softbox lighting, ultra-realistic plastic textures.'
    },
    {
      'title': 'Fantasy Sky Islands',
      'category': 'Landscape',
      'image': 'https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?auto=compress&cs=tinysrgb&w=600',
      'prompt': 'Mythical floating islands with waterfalls falling into clouds, golden hour sunset, Unreal Engine 5 render style.'
    },
    {
      'title': 'Minimalist Logo Icon',
      'category': 'Design',
      'image': 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600&auto=format&fit=crop',
      'prompt': 'Modern minimalist geometric logo of a fox, vector flat design, gradient colors, dark background, behance trending.'
    },
    {
      'title': 'Isometric Cozy Room',
      'category': '3D Art',
      'image': 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop',
      'prompt': 'Isometric cute 3D miniature bedroom with soft pastel lighting, tiny houseplants, mechanical keyboard, Blender 3D render.'
    },
  ];

  List<Map<String, String>> displayedPrompts = [];

  @override
  void initState() {
    super.initState();
    displayedPrompts = allPrompts;
  }

  void filterSearch(String query) {
    setState(() {
      displayedPrompts = allPrompts
          .where((p) =>
              p['title']!.toLowerCase().contains(query.toLowerCase()) ||
              p['category']!.toLowerCase().contains(query.toLowerCase()))
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
                      Image.network(
                        item['image']!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            height: 180,
                            color: const Color(0xFF1E1E2C),
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: const Color(0xFF1E1E2C),
                          child: const Center(
                            child: Icon(Icons.broken_image_rounded, color: Colors.white38, size: 40),
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
                            Row(
                              children: [
                                Expanded(
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
                                    label: const Text('Copy', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2A2A3C),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () {
                                    Share.share(
                                      '${item['title']} AI Prompt:\n\n${item['prompt']}\n\nShared from AI Prompt Hub',
                                    );
                                  },
                                  icon: const Icon(Icons.share, size: 16, color: Colors.white),
                                  label: const Text('Share', style: TextStyle(color: Colors.white)),
                                ),
                              ],
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
