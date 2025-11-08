import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ 新增：支援開啟網址

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '我的自傳',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final AudioPlayer _player;
  late final List<Widget> _tabs;

  final _tracks = const ['1.mp3', '2.mp3', '3.mp3', '4.mp3'];

  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer()..setReleaseMode(ReleaseMode.loop);
    _tabs = [
      Screen1(onJump: _jumpTo),
      const Screen2(),
      const Screen3(),
      const Screen4(),
    ];
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  Future<void> _playForIndex(int index) async {
    await _player.stop();
    await _player.play(AssetSource(_tracks[index]));
    setState(() {
      _hasLoaded = true;
      _isPlaying = true;
    });
  }

  Future<void> _jumpTo(int index) async {
    if (index == _currentIndex) {
      if (_isPlaying) {
        await _player.pause();
        setState(() => _isPlaying = false);
      } else {
        if (!_hasLoaded) {
          await _playForIndex(index);
        } else {
          await _player.resume();
          setState(() => _isPlaying = true);
        }
      }
      return;
    }

    setState(() {
      _currentIndex = index;
      _hasLoaded = false;
    });
    await _playForIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2FA),
      appBar: AppBar(
        title: const Text("我的自傳"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        iconSize: 30,
        currentIndex: _currentIndex,
        onTap: _jumpTo,
        items: [
          BottomNavigationBarItem(
            icon: _currentIndex == 0
                ? Image.asset('assets/a1.png', width: 40, height: 40)
                : Image.asset('assets/a11.png', width: 30, height: 30),
            label: '自我介紹',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? Image.asset('assets/a2.png', width: 40, height: 40)
                : Image.asset('assets/a21.png', width: 30, height: 30),
            label: '學習歷程',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 2
                ? Image.asset('assets/a3.jpg', width: 40, height: 40)
                : Image.asset('assets/a31.jpg', width: 30, height: 30),
            label: '學習計畫',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 3
                ? Image.asset('assets/a4.png', width: 40, height: 40)
                : Image.asset('assets/a41.png', width: 30, height: 30),
            label: '專業方向',
          ),
        ],
      ),
    );
  }
}

/* ========================== Screen 1 ========================== */
class Screen1 extends StatelessWidget {
  final void Function(int index) onJump;
  const Screen1({super.key, required this.onJump});

  static const String s1 =
      "我叫李承育，目前就讀國立高雄科技大學資訊工程系三年甲班，學號 C112110244。我出生於屏東的一個教育家庭，父母都是國小老師，從小在充滿學習氛圍的環境中長大。"
      "在父母的影響下，我養成了主動學習與獨立思考的習慣，也對各種新知保持高度的好奇心。"
      "小學時期，我對電腦特別感興趣。當看到父母使用電腦備課或處理文件時，我常在旁邊觀察、模仿，並開始嘗試自己操作。那時雖然只是單純的好奇，但也種下了我日後選擇資訊領域的種子。"
      "升上國中後，我會利用課餘時間上網學習電腦相關知識，也幫家人維修、設定電腦。隨著興趣越來越濃厚，高中我選擇就讀高雄高工資訊科，希望能更系統地學習程式設計與電腦架構。"
      "在高雄高工的三年裡，我不僅學會了程式語言、資料庫與網路基礎，更確定自己要以資訊工程為未來的方向。"
      "畢業後，我決定留在南部繼續深造，進入高雄科技大學資訊工程系。大學階段，我持續培養邏輯思考與實作能力，並積極參與專題製作與系上活動，從實際應用中累積經驗。"
      "我相信，學習資訊不只是為了寫程式，更是為了運用科技解決問題。未來，我希望能在軟體開發或人工智慧領域中貢獻所學，讓科技成為改善生活與社會的重要力量。";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 38,
            backgroundImage: AssetImage('assets/a1.png'),
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black87, width: 2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.amberAccent, offset: Offset(6, 6))],
            ),
            child: const Column(
              children: [
                Text("Who am I", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text(s1, style: TextStyle(fontSize: 16, height: 1.6)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _IconJump(label: '學習歷程', icon: Icons.menu_book_rounded, onTap: () => onJump(1), big: true),
              _IconJump(label: '學習計畫', icon: Icons.school_rounded, onTap: () => onJump(2), big: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconJump extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool big;
  const _IconJump({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.big = false,
  });

  @override
  Widget build(BuildContext context) {
    final double padV = big ? 18 : 10;
    final double padH = big ? 22 : 14;
    final double iconSize = big ? 28 : 22;
    final double fontSize = big ? 16 : 14;
    final double radius = big ? 20 : 18;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.deepPurple.shade200, width: 2),
          boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 6, offset: Offset(2, 2))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: fontSize)),
          ],
        ),
      ),
    );
  }
}

/* ========================== Screen 2 ========================== */
class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _TimelineItem('大一', '1.打好基礎：微積分、程式設計、英文強化。'
                    '\n2.取得第一張證照。'),

      _TimelineItem('大二', '1.研讀資料結構、演算法、資料庫。'
                    '\n2.參與社團/競賽，累積作品。'),

      _TimelineItem('大三', '1.AI/資料科學專題和資料探勘'
                    '\n2.並且積極參與競賽與發表。'),

      _TimelineItem('大四', '1.將畢業專題整合'
                    '\n2.準備研究所與作品集展示。'),

    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, i) => _TimelineCard(
        item: items[i],
        isFirst: i == 0,
        isLast: i == items.length - 1,
      ),
    );
  }
}

class _TimelineItem {
  final String title;
  final String desc;
  _TimelineItem(this.title, this.desc);
}

class _TimelineCard extends StatelessWidget {
  final _TimelineItem item;
  final bool isFirst;
  final bool isLast;
  const _TimelineCard({super.key, required this.item, required this.isFirst, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Column(
            children: [
              if (!isFirst) Container(width: 2, height: 12, color: Colors.grey.shade400),
              Container(width: 18, height: 18, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
              if (!isLast) Container(width: 2, height: 40, color: Colors.grey.shade400),
            ],
          ),
        ),
        Expanded(
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(item.desc),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}

/* ========================== Screen 3 ========================== */
class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    final goals = [
      ('語言力', ['多益 700+', '每週英文輸入 3hr']),
      ('技術力', ['演算法題庫 50 題', '完成 1 個 Flutter 小作品']),
      ('研究力', ['讀 3 篇論文筆記', '完成一份小型實驗報告']),
      ('競賽/證照', ['程式競賽參賽 1 次', '考 1 張證照']),
      ('研討會', ['TANET發表海報論文 1 次']),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('年度學習計畫', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...goals.map((g) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(g.$1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...g.$2.map((t) => Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(t)),
                ],
              )),
            ]),
          ),
        )),
        const SizedBox(height: 12),
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const ListTile(
            leading: Icon(Icons.flag),
            title: Text('里程碑：期中前完成一個能展示的 App（本專案）'),
            subtitle: Text('把自傳內容、圖片與音效整合，發佈到 Web/Windows。'),
          ),
        ),
      ],
    );
  }
}

/* ========================== Screen 4 ========================== */
class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = [
      ('Flutter', 0.7),
      ('Dart', 0.75),
      ('資料結構/演算法', 0.6),
      ('資料科學/AI/資料探勘', 0.8),
      ('版本控制 Git', 0.7),
      ('英文能力',0.5),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('專業方向與技能樹', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...skills.map((s) => _SkillBar(name: s.$1, value: s.$2)),
        const SizedBox(height: 16),
        const Text('作品集與計畫', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _ProjectCard(
          title: '自傳 APP',
          desc: 'Flutter + audioplayers，整合個人自傳、圖片、音效，支援 Web/Windows/Android。',
          url: 'https://www.google.com/',
        ),
        _ProjectCard(
          title: '資料探勘分析-LinZhaiPlus',
          desc: '基於嵌入式機器學習與數據分析的租屋智慧推薦與評估。',
          url: 'https://github.com/Yutou0601/LinZhaiPLUS',
        ),
        _ProjectCard(
          title: 'Rust應用-Chat_On_Server',
          desc: '利用Rust寫出架設前端後端，只要連到伺服器就能互相對話，也有房間功能，也能跟GPT聊天。',
          url: 'https://github.com/Yutou0601/Chat_On_Server',
        ),
      ],
    );
  }
}

class _SkillBar extends StatelessWidget {
  final String name;
  final double value;
  const _SkillBar({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(minHeight: 10, value: value),
        ),
      ]),
    );
  }
}

/* ✅ 可開網址的 Project Card */
class _ProjectCard extends StatelessWidget {
  final String title;
  final String desc;
  final String url;

  const _ProjectCard({
    super.key,
    required this.title,
    required this.desc,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
        trailing: const Icon(Icons.open_in_new),
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }
}
