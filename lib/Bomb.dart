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
    final tileX = (position.x / tileSize).floor();
    final tileY = (position.y / tileSize).floor();

    // Zentrum
    game.add(Explosion(position.clone(), tileSize));

    for (final dir in [
      Vector2(1, 0),
      Vector2(-1, 0),
      Vector2(0, 1),
      Vector2(0, -1),
    ]) {
      final nextX = tileX + dir.x.toInt();
      final nextY = tileY + dir.y.toInt();

      if (nextY >= 0 &&
          nextY < game.map.length &&
          nextX >= 0 &&
          nextX < game.map[0].length) {
        final tile = game.map[nextY][nextX];
        final explosionPos = Vector2(nextX * tileSize, nextY * tileSize);

        if (tile == 0) {
          game.add(Explosion(explosionPos, tileSize));
        } else if (tile == 2) {
          game.map[nextY][nextX] = 0; // Block zerstören
          game.add(Explosion(explosionPos, tileSize));
        }
      }
    }

    removeFromParent();
  }


}

class Explosion extends PositionComponent {
  final double tileSize;
  double _timer = 0.5; // 500ms sichtbar

  Explosion(Vector2 position, this.tileSize) {
    this.position = position;
    size = Vector2(tileSize, tileSize);
    anchor = Anchor.topLeft;
  }

  @override
  void update(double dt) {
    _timer -= dt;
    if (_timer <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.orange;
    canvas.drawRect(size.toRect(), paint);
  }
}
