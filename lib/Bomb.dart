import 'package:flame/components.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';


class Bomb extends PositionComponent with HasGameReference<BomberGame> {
  final double tileSize;

  Bomb(Vector2 position, this.tileSize) {
    this.position = position;
    size = Vector2(tileSize, tileSize);
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    await Future.delayed(Duration(seconds: 2));
    explode();
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }

  void explode() {
    game.add(Explosion(position, tileSize));
    removeFromParent(); // Bombe entfernen
  }
}

class Explosion extends PositionComponent {
  final double tileSize;

  Explosion(Vector2 position, this.tileSize) {
    this.position = position;
    size = Vector2(tileSize, tileSize);
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    await Future.delayed(Duration(milliseconds: 500));
    removeFromParent(); // Explosion nur kurz sichtbar
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.red;
    final half = tileSize / 2;
    final offset = Offset(0, 0);

    canvas.drawLine(offset, Offset(tileSize, tileSize), paint);
    canvas.drawLine(Offset(tileSize, 0), Offset(0, tileSize), paint);
  }
}
