import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hesham_app/several_call_button.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const TailorShopApp());
}

class TailorShopApp extends StatelessWidget {
  const TailorShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الأسطى هشام الزرقانى',
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          primary: const Color(0xFFFFD700),
          secondary: const Color(0xFFFFC107),
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0B0D),
        textTheme: base.textTheme.apply(fontFamily: 'Cairo'),
      ),
      home: const TailorProfilePage(),
    );
  }
}

class TailorProfilePage extends StatefulWidget {
  const TailorProfilePage({super.key});

  @override
  State<TailorProfilePage> createState() => _TailorProfilePageState();
}

class _TailorProfilePageState extends State<TailorProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _bgController;
  late AnimationController _menuController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _bgController.dispose();
    _menuController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      floatingActionButton: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16.0),
        child: SeveralCallButton(
          phoneNumber1: '+201015283663',
          whatsApp: '+201015283663',
        ),
      ),
      body: Stack(
        children: [
          // خلفية متحركة ناعمة
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              final t = _bgController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(
                      -0.8 + 0.4 * math.sin(t * math.pi * 2),
                      -1,
                    ),
                    end: Alignment(0.8 - 0.4 * math.cos(t * math.pi * 2), 1),
                    colors: const [Color(0xFF070606), Color(0xFF1A1A1C)],
                  ),
                ),
              );
            },
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 32),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _entranceController,
                    curve: Curves.easeOut,
                  ),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.06),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _entranceController,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Column(
                        children: [
                          _buildTopCard(mq.width)
                              .animate()
                              .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 20),
                          _buildInfoRow()
                              .animate()
                              .fadeIn(duration: 900.ms)
                              .slideX(begin: 0.3, end: 0),
                          const SizedBox(height: 18),
                          _buildServicesGrid()
                              .animate()
                              .fadeIn(duration: 1000.ms)
                              .slideY(begin: 0.3, end: 0),
                          const SizedBox(height: 18),
                          _buildStatsRow()
                              .animate()
                              .fadeIn(duration: 1100.ms)
                              .slideX(begin: -0.3, end: 0),
                          const SizedBox(height: 26),
                          _buildFooter()
                              .animate()
                              .fadeIn(duration: 1200.ms)
                              .scale(
                                  begin: const Offset(0.9, 0.9),
                                  end: const Offset(1, 1)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTopCard(double fullWidth) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8).copyWith(top: 15),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.04),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _buildProfileInfo()),
                  const SizedBox(width: 8),
                  _buildProfileImageWithParallax(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 1,
          right: 6,
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFB300)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.15),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Text(
                  'ترزي بلدي',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الأسطى/ هشام الزرقاني',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ترزي رجالي محترف يتميز بدقة الخياطة، جودة الخامات، وتصميمات عصرية تناسب جميع الأذواق، يجمع بين الأناقة والاحترافية العالية.',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w200,
                color: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                spacing: 3,
                children: ['بلدي', 'إفرنجي', 'سودانى', 'عبايات'].map((t) {
                  return Chip(
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.black.withOpacity(0.3),
                    side: BorderSide(color: Colors.white.withOpacity(0.04)),
                    label: Text(t, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    onPressed: () async {
                      final uri = Uri.parse('tel:+201015283663');
                      if (await canLaunchUrl(uri)) await launchUrl(uri);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.call, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'اتصل الآن',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    onPressed: () async {
                      final uri =
                          Uri.parse('https://wa.me/+201015283663?text=مرحبا');
                      if (await canLaunchUrl(uri)) await launchUrl(uri);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.whatsapp, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'واتساب',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageWithParallax() {
    return Hero(
      tag: 'hesham-image',
      child: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          final rot = math.sin(_bgController.value * math.pi * 2) * 0.04;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(rot),
            child: Container(
              width: 143,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.08),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.06)),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.02),
                    Colors.white.withOpacity(0.01),
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/hesham.jpg', fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _infoCard(
            'نبذة',
            'الأسطى هشام الزرقاني، ترزي بلدي بخبرة واسعة، قاد إدارة محل الحاج محمد عبده لمدة ست سنوات متواصلة، وامتازت أعماله بالجودة والدقة والذوق العصري.',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _infoCard(
            'ماذا نقدم',
            null,
            children: [
              _serviceTile('✂️', 'تفصيل عبايات رجالية فاخرة'),
              _serviceTile('📏', 'قياسات دقيقة ومحترفة'),
              _serviceTile(
                'assets/design.jpeg',
                'تصاميم عصرية وتقليدية',
                isImage: true,
              ),
              _serviceTile(
                'assets/komash.jpeg',
                'أقمشة مستوردة عالية الجودة',
                isImage: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildServicesGrid() {
    final services = [
      {'icon': '✂️', 'title': 'تفصيل حسب المقاس', 'desc': 'تفصيل دقيق يلائم ذوقك'},
      {'icon': '📦', 'title': 'تجهيز سريع', 'desc': 'تسليم بالموعــد'},
      {'icon': 'assets/komash.jpeg', 'title': 'أقمشة راقية', 'desc': 'منتقاة بعناية'},
      {'icon': '⭐', 'title': 'خدمة ما بعد البيع', 'desc': 'دعم وضمان جودة'},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 92,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: services.length,
      itemBuilder: (context, i) {
        final s = services[i];
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: _entranceController,
            curve: Interval(0.1 * i, 0.6 + 0.1 * i, curve: Curves.easeOut),
          ),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _entranceController.value)),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.04)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFB300)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.06),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: s['icon']!.contains('jpeg')
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                s['icon']!,
                                fit: BoxFit.cover,
                                height: 25,
                                width: 25,
                              ),
                            )
                          : Text(s['icon']!, style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            s['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            s['desc']!,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _statCard('5⭐', 'تقييم العملاء', 1)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('1000+', 'عميل راضي', 2)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('100%', 'جودة عالية', 3)),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text('اتصل على: 01015283663', style: TextStyle(color: Colors.grey.shade500)),
        const SizedBox(height: 6),
        Text(
          '© ${2025} الأسطى هشام الزرقانى',
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
        ),
      ],
    );
  }

  Widget _infoCard(String title, String? text, {List<Widget>? children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFB300)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.info_outline, size: 18, color: Colors.black87),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          if (text != null) ...[
            const SizedBox(height: 8),
            Text(text, style: TextStyle(color: Colors.grey.shade300, height: 1.5)),
          ],
          if (children != null) ...[const SizedBox(height: 8), ...children],
        ],
      ),
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
  }

  Widget _serviceTile(String icon, String text, {bool isImage = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.03)),
            ),
            child: Center(
              child: isImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(icon, width: 26, height: 26, fit: BoxFit.cover),
                    )
                  : Text(icon, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey.shade300))),
        ],
      ),
    );
  }

  Widget _statCard(String number, String label, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 600 + index * 200),
            builder: (context, value, child) {
              return Opacity(opacity: value, child: child);
            },
            child: Text(
              number,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        ],
      ),
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
  }
}
