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
        fontFamily: 'Cairo',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Cairo'),
          bodyMedium: TextStyle(fontFamily: 'Cairo'),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) => _buildParticle(index)),

            // Main content
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
    final duration = random.nextInt(10) + 10;
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
                    Color(0xFFFFD700).withOpacity(0.8),
                    Color(0xFFFFD700).withOpacity(0),
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
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E293B).withOpacity(0.9),
            Color(0xFF334155).withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: -5,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Color(0xFFFFD700).withOpacity(0.3),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  _buildProfileImage(),
                  const SizedBox(height: 25),
                  _buildNameSection(),
                  const SizedBox(height: 20),
                  _buildSpecialtyTags(),
                ],
              ),
            ),
          ),
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width:
                        180 +
                        (math.sin(_pulseController.value * math.pi * 2) * 20),
                    height:
                        260 +
                        (math.sin(_pulseController.value * math.pi * 2) * 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFFFD700).withOpacity(0.3),
                          Color(0xFFFFD700).withOpacity(0),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Image container
              Container(
                width: 140,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFD700).withOpacity(0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Image.asset('assets/design.jpeg', fit: BoxFit.fill),
                // Stack(
                //   children: [
                //     // Inner content
                //     Center(
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text('👔', style: TextStyle(fontSize: 60)),
                //           const SizedBox(height: 10),
                //           Container(
                //             padding: const EdgeInsets.symmetric(
                //               horizontal: 12,
                //               vertical: 4,
                //             ),
                //             decoration: BoxDecoration(
                //               color: Colors.white.withOpacity(0.3),
                //               borderRadius: BorderRadius.circular(12),
                //             ),
                //             child: Text(
                //               'PRO',
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.bold,
                //                 letterSpacing: 2,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     // Shine effect
                //     AnimatedBuilder(
                //       animation: _pulseController,
                //       builder: (context, child) {
                //         return Positioned(
                //           top: -100 + (_pulseController.value * 320),
                //           left: 0,
                //           right: 0,
                //           child: Container(
                //             height: 100,
                //             decoration: BoxDecoration(
                //               gradient: LinearGradient(
                //                 begin: Alignment.topCenter,
                //                 end: Alignment.bottomCenter,
                //                 colors: [
                //                   Colors.white.withOpacity(0),
                //                   Colors.white.withOpacity(0.4),
                //                   Colors.white.withOpacity(0),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         );
                //       },
                //     ),
                //   ],
                // ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNameSection() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFFAF0), Color(0xFFFFD700)],
          ).createShader(bounds),
          child: Text(
            'الأسطى/ هشام الزرقانى',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.4,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFD700).withOpacity(0.2),
                Color(0xFFFFA500).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFFFFD700).withOpacity(0.5)),
          ),
          child: Text(
            '⭐⭐⭐⭐⭐ - تقييم العملاء',
            style: TextStyle(
              color: Color(0xFFFFD700),
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
    return Wrap(
      spacing: 9.5,
      runSpacing: 5,
      alignment: WrapAlignment.center,
      children: specialties.map((specialty) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Text(
            specialty,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContactSection() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size(0, 0),
      onPressed: () async {
        Uri uri = Uri.parse('tel:+20 101 528 3663');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Column(
          children: [
            _buildPhoneCard('📱', '01015283663', 0),
            // const SizedBox(height: 15),
            // _buildPhoneCard('☎️', '+20 111 234 5678', 100),
            const SizedBox(height: 20),
            // Row(
            //   children: [
            //     Expanded(
            //       child: _buildActionButton(
            //         '💬',
            //         'واتساب',
            //         Color(0xFF25D366),
            //         () => _launchWhatsApp('+20100123456'),
            //       ),
            //     ),
            //     const SizedBox(width: 15),
            //     Expanded(
            //       child: _buildActionButton(
            //         '📞',
            //         'اتصال',
            //         Color(0xFFFFD700),
            //         () => _makePhoneCall('+20100123456'),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneCard(String icon, String number, int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E293B).withOpacity(0.9),
              Color(0xFF334155).withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFFD700).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFD700).withOpacity(0.4),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 15),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String icon,
    String text,
    Color color,
    VoidCallback onPressed,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E293B).withOpacity(0.9),
            Color(0xFF334155).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.star, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'خدماتنا المتميزة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildServiceItem('✂️', 'تفصيل عبايات رجالية فاخرة'),
          _buildServiceItem('📏', 'قياسات دقيقة ومحترفة'),
          _buildServiceItem('assets/design.jpeg', 'تصاميم عصرية وتقليدية'),
          _buildServiceItem('assets/komash.jpeg', 'أقمشة مستوردة عالية الجودة'),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
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
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E293B).withOpacity(0.9),
            Color(0xFF334155).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ).createShader(bounds),
            child: Text(
              number,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchWhatsApp(String phone) async {
    final Uri url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makePhoneCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
