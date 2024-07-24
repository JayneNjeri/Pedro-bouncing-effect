import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();

    audioPlayer.play(AssetSource('pedrosong.mp3'), volume: 0.0);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Pedro Spinner'),
            backgroundColor: Colors.blue,
            centerTitle: true,
          ),
          body: const Center(
            child: PedroSpinner(),
          ),
        ));
  }
}

class PedroSpinner extends StatefulWidget {
  const PedroSpinner({super.key});

  @override
  State<PedroSpinner> createState() => _PedroSpinnerState();
}

class _PedroSpinnerState extends State<PedroSpinner>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();
    _bounceAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _bounceController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _bounceController.forward();
        }
      });
    _bounceController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bounceController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: GestureDetector(
        onTap: () {
          if (_audioPlayer.state == PlayerState.playing) {
            _audioPlayer.pause();
          } else {
            _audioPlayer.play(AssetSource('pedrosong.mp3'), volume: 0.1);
          }
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller, _bounceAnimation]),
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * pi, // Rotate
              child: Transform.scale(
                scale: _bounceAnimation.value, // Apply bounce effect
                child: child,
              ),
            );
          },
          child: Image.asset('assets/pedro.jpg'), // Your Pedro image
        ),
      ),
    ));
  }
}
