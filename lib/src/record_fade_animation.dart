import 'package:flutter/material.dart';

class RecordFadeAnimation extends StatefulWidget {
  const RecordFadeAnimation({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  RecordFadeAnimationState createState() => RecordFadeAnimationState();
}

class RecordFadeAnimationState extends State<RecordFadeAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() async {
      if (_controller.isCompleted) {
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          _controller.reverse();
        });
      }
    });
  }

  @override
  void didUpdateWidget(RecordFadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}
