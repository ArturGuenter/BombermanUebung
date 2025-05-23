import 'package:flame/components.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';


class Bomb extends PositionComponent with HasGameReference<BomberGame> {
  final double tileSize;
  double _timer = 2.0; // Sekunden bis zur Explosion

  Bomb(Vector2 position, this.tileSize) {
    this.position = position;
    size = Vector2(tileSize, tileSize);
    anchor = Anchor.topLeft;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }

  @override
  void update(double dt) {
    _timer -= dt;
    if (_timer <= 0) {
      explode();
    }
  }

  void explode() {
    game.add(Explosion(position.clone(), tileSize));
    removeFromParent();
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
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4;

    canvas.drawLine(Offset(0, 0), Offset(size.x, size.y), paint);
    canvas.drawLine(Offset(size.x, 0), Offset(0, size.y), paint);
  }

}
