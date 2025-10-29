import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hesham_app/several_call_button.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const TailorShopApp());
}

class TailorShopApp extends StatelessWidget {
  const TailorShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الأسطى هشام الزرقانى',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFFFD700),
        scaffoldBackgroundColor: const Color(0xFFFDFCFB),
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD700),
          brightness: Brightness.light,
        ),
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
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _rotateController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16.0),
        child: SeveralCallButton(
          phoneNumber1: '+201015283663',
          whatsApp: '+201015283663',
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFDF5), Color(0xFFF8F5E7)],
          ),
        ),
        child: Stack(
          children: [
            ...List.generate(15, (index) => _buildParticle(index)),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  child: FadeTransition(
                    opacity: _mainController,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _mainController,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: Column(
                        children: [
                          _buildProfileCard(),
                          const SizedBox(height: 25),
                          _buildContactSection(),
                          const SizedBox(height: 25),
                          _buildDescriptionSection(),
                          const SizedBox(height: 25),
                          _buildServicesSection(),
                          const SizedBox(height: 25),
                          _buildStatsSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticle(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 4 + 2;
    final delay = random.nextInt(5);

    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        final progress = (_rotateController.value + (delay * 0.1)) % 1.0;
        return Positioned(
          left: random.nextDouble() * 400,
          top: progress * MediaQuery.of(context).size.height,
          child: Opacity(
            opacity: (math.sin(progress * math.pi) * 0.5).clamp(0.0, 1.0),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFC300).withOpacity(0.8),
                    const Color(0xFFFFD700).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFFFF8E1)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: const Color(0xFFFFD700), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildProfileImage(),
            const SizedBox(height: 20),
            _buildNameSection(),
            const SizedBox(height: 15),
            _buildSpecialtyTags(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_floatingController.value * math.pi) * 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Colors.amber.withOpacity(0.4), blurRadius: 25),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/hesham.jpg',
                width: 150,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameSection() {
    return Column(
      children: [
        Text(
          'الأسطى/ هشام الزرقانى',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: const Text(
            '⭐⭐⭐⭐⭐ - تقييم العملاء',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtyTags() {
    final specialties = ['عبايات', 'سودانى', 'إفرنجي', 'بلدي'];
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        spacing: 6,
        // runSpacing: 0,
        // alignment: WrapAlignment.center,
        children: specialties.map((specialty) {
          return Chip(
            backgroundColor: Colors.amber.shade50,
            label: Text(
              specialty,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            side: BorderSide(color: Colors.amber.shade200),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactSection() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: () async {
        Uri uri = Uri.parse('tel:+201015283663');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: _buildPhoneCard('📱', '01015283663'),
    );
  }

  Widget _buildPhoneCard(String icon, String number) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.amber.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text('📱', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 15),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return _infoCard(
      "الأسطى هشام الزرقاني، ترزي بلدي بخبرة واسعة، قاد إدارة محل الحاج محمد عبده لمدة ست سنوات متواصلة، وامتازت أعماله بالجودة والدقة والذوق العصري، الأمر الذي جعل منتجاته تحظى بإعجاب العملاء وثقتهم.",
    );
  }

  Widget _buildServicesSection() {
    return _infoCard(
      null,
      title: 'خدماتنا المتميزة',
      children: [
        _buildServiceItem('✂️', 'تفصيل عبايات رجالية فاخرة'),
        _buildServiceItem('📏', 'قياسات دقيقة ومحترفة'),
        _buildServiceItem('assets/design.jpeg', 'تصاميم عصرية وتقليدية'),
        _buildServiceItem('assets/komash.jpeg', 'أقمشة مستوردة عالية الجودة'),
      ],
    );
  }

  Widget _infoCard(String? text, {String? title, List<Widget>? children}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.amber.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          if (text != null)
            Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          if (children != null) ...[const SizedBox(height: 15), ...children],
        ],
      ),
    );
  }

  Widget _buildServiceItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: icon.contains('jpeg')
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        icon,
                        width: 23,
                        height: 23,
                        fit: BoxFit.fill,
                      ),
                    )
                  : Text(icon, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('5⭐', 'تقييم العملاء')),
          const SizedBox(width: 15),
          Expanded(child: _buildStatCard('1000+', 'عميل راضي')),
          const SizedBox(width: 15),
          Expanded(child: _buildStatCard('100%', 'جودة عالية')),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
