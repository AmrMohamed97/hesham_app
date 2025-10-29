import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const double buttonSize = 70.0;

class SeveralCallButton extends StatefulWidget {
  const SeveralCallButton({
    super.key,
    required this.phoneNumber1,
    required this.whatsApp,
  });
  final String phoneNumber1, whatsApp;
  @override
  State<SeveralCallButton> createState() => _SeveralCallButtonState();
}

class _SeveralCallButtonState extends State<SeveralCallButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(controller: controller),
      children: [
        FloatingActionButton(
          backgroundColor: Colors.amber.withValues(alpha: .8),
          heroTag: 'call',
          onPressed: () {
            if (controller.status == AnimationStatus.completed) {
              controller.reverse();
            } else {
              controller.forward();
            }
          },
          child: const Text(
            'اتصال',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FloatingActionButton(
          backgroundColor: Colors.white,
          heroTag: 'phone',
          onPressed: () async {
            Uri uri = Uri.parse('tel:${widget.phoneNumber1}');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
            controller.reverse();
          },
          child: const Icon(Icons.phone, color: Colors.blueAccent, size: 30),
        ),
        FloatingActionButton(
          backgroundColor: Colors.green,
          heroTag: 'whatsapp',
          onPressed: () async {
            Uri uri = Uri.parse('https://wa.me/${widget.whatsApp}?text= ');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
            controller.reverse();
          },
          child: const Icon(
            FontAwesomeIcons.whatsapp,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;
  FlowMenuDelegate({required this.controller}) : super(repaint: controller);
  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xStart = size.width - buttonSize;
    final yStart = size.height - buttonSize;
    for (int i = context.childCount - 1; i >= 0; i--) {
      const margin = 10;
      final childSize = context.getChildSize(i)!.width;
      final dx = (childSize + margin) * i;
      final x = xStart;
      final y = yStart - dx * controller.value;
      context.paintChild(i, transform: Matrix4.translationValues(x, y, 0));
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}
