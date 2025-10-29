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
    // Dark Theme
    final darkBase = ThemeData.dark();
    final darkTheme = darkBase.copyWith(
      colorScheme: darkBase.colorScheme.copyWith(
        primary: const Color(0xFFFFD700),
        secondary: const Color(0xFFFFC107),
      ),
      scaffoldBackgroundColor: const Color(0xFF0B0B0D),
      textTheme: darkBase.textTheme.apply(fontFamily: 'Cairo'),
    );

    // Light Theme
    final lightBase = ThemeData.light();
    final lightTheme = lightBase.copyWith(
      colorScheme: lightBase.colorScheme.copyWith(
        primary: const Color(0xFFFFD700),
        secondary: const Color(0xFFFFC107),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      textTheme: lightBase.textTheme.apply(fontFamily: 'Cairo'),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الأسطى هشام الزرقانى',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // يتبع ثيم النظام تلقائياً
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
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {});
    });
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    colors: isDark
                        ? const [Color(0xFF070606), Color(0xFF1A1A1C)]
                        : const [Color(0xFFFFFFFF), Color(0xFFE8E8EA)],
                  ),
                ),
              );
            },
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 32,
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _entranceController,
                    curve: Curves.easeOut,
                  ),
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
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
                          _buildTopCard(mq.width, isDark)
                              .animate()
                              .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 20),
                          _buildInfoRow(isDark)
                              .animate()
                              .fadeIn(duration: 900.ms)
                              .slideX(begin: 0.3, end: 0),
                          const SizedBox(height: 18),
                          _buildServicesGrid(isDark)
                              .animate()
                              .fadeIn(duration: 1200.ms)
                              .slideY(begin: 0.3, end: 0),
                          const SizedBox(height: 18),
                          _buildStatsRow(isDark)
                              .animate()
                              .fadeIn(duration: 1100.ms)
                              .slideX(begin: -0.3, end: 0),
                          const SizedBox(height: 26),
                          _buildFooter(isDark)
                              .animate()
                              .fadeIn(duration: 1200.ms)
                              .scale(
                                begin: const Offset(0.9, 0.9),
                                end: const Offset(1, 1),
                              ),
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

  Widget _buildTopCard(double fullWidth, bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8).copyWith(top: 15),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: isDark
                ? Colors.white.withOpacity(0.04)
                : Colors.white.withOpacity(0.7),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.6)
                    : Colors.black.withOpacity(0.1),
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
                  Expanded(child: _buildProfileInfo(isDark)),
                  const SizedBox(width: 8),
                  _buildProfileImageWithParallax(isDark),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
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

  Widget _buildProfileInfo(bool isDark) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الأسطى/ هشام الزرقاني',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ترزي رجالي محترف يتميز بدقة الخياطة، جودة الخامات، وتصميمات عصرية تناسب جميع الأذواق، يجمع بين الأناقة والاحترافية العالية.',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w200,
                color: isDark ? Colors.grey.shade50 : Colors.grey.shade800,
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
                    backgroundColor: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.white.withOpacity(0.5),
                    side: BorderSide(
                      color: isDark
                          ? Colors.white.withOpacity(0.04)
                          : Colors.black.withOpacity(0.1),
                    ),
                    label: Text(
                      t,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
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
                      final uri = Uri.parse(
                        'https://wa.me/+201015283663?text=مرحبا',
                      );
                      if (await canLaunchUrl(uri)) await launchUrl(uri);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.4)
                              : Colors.black.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.whatsapp,
                            size: 18,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'واتساب',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
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

  Widget _buildProfileImageWithParallax(bool isDark) {
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
                // boxShadow: [
                //   BoxShadow(
                //     color: isDark
                //         ? Colors.black.withOpacity(0.6)
                //         : Colors.black.withOpacity(0.2),
                //     blurRadius: 20,
                //     offset: const Offset(0, 10),
                //   ),
                //   BoxShadow(
                //     color: Colors.amber.withOpacity(0.08),
                //     blurRadius: 30,
                //     spreadRadius: 4,
                //   ),
                // ],
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : Colors.black.withOpacity(0.1),
                ),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          Colors.white.withOpacity(0.02),
                          Colors.white.withOpacity(0.01),
                        ]
                      : [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.3),
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

  Widget _buildInfoRow(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _infoCard(
            'نبذة',
            'الأسطى هشام الزرقاني، ترزي بلدي بخبرة واسعة، قاد إدارة محل الحاج محمد عبده لمدة ست سنوات متواصلة، وامتازت أعماله بالجودة والدقة والذوق العصري.',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _infoCard(
            'ماذا نقدم',
            null,
            isDark: isDark,
            children: [
              _serviceTile('✂️', 'تفصيل عبايات رجالية فاخرة', isDark),
              _serviceTile('📏', 'قياسات دقيقة ومحترفة', isDark),
              _serviceTile(
                'assets/design.jpeg',
                'تصاميم عصرية وتقليدية',
                isDark,
                isImage: true,
              ),
              _serviceTile(
                'assets/komash.jpeg',
                'أقمشة مستوردة عالية الجودة',
                isDark,
                isImage: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServicesGrid(bool isDark) {
    final services = [
      {
        'icon': '✂️',
        'title': 'تفصيل حسب المقاس',
        'desc': 'تفصيل دقيق يلائم ذوقك',
      },
      {'icon': '📦', 'title': 'تجهيز سريع', 'desc': 'تسليم بالموعــد'},
      {
        'icon': 'assets/komash.jpeg',
        'title': 'أقمشة راقية',
        'desc': 'منتقاة بعناية',
      },
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
                color: isDark
                    ? Colors.white.withOpacity(0.03)
                    : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.04)
                      : Colors.black.withOpacity(0.08),
                ),
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
                          : Text(
                              s['icon']!,
                              style: const TextStyle(fontSize: 20),
                            ),
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            s['desc']!,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade700,
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

  Widget _buildStatsRow(bool isDark) {
    return Row(
      children: [
        Expanded(child: _statCard('5⭐', 'تقييم العملاء', 1, isDark)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('100%', 'عميل راضي', 2, isDark)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('100%', 'جودة عالية', 3, isDark)),
      ],
    );
  }

  Widget _buildFooter(bool isDark) {
    return Column(
      children: [
        Text(
          'اتصل على: 01015283663',
          style: TextStyle(
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '© ${2025} الأسطى هشام الزرقانى',
          style: TextStyle(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _infoCard(
    String title,
    String? text, {
    List<Widget>? children,
    required bool isDark,
  }) {
    return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.03)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.black.withOpacity(0.08),
            ),
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
                    child: const Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              if (text != null) ...[
                const SizedBox(height: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                    height: 1.5,
                  ),
                ),
              ],
              if (children != null) ...[const SizedBox(height: 8), ...children],
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 700.ms)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
  }

  Widget _serviceTile(
    String icon,
    String text,
    bool isDark, {
    bool isImage = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.03)
                  : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.03)
                    : Colors.black.withOpacity(0.05),
              ),
            ),
            child: Center(
              child: isImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        icon,
                        width: 26,
                        height: 26,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Text(icon, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String number, String label, int index, bool isDark) {
    return Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.02)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.03)
                  : Colors.black.withOpacity(0.08),
            ),
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 700.ms)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
  }
}
