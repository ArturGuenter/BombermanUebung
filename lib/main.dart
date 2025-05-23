import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Bomb.dart';


void main() {
  runApp(GameWidget(game: BomberGame()));
}

class BomberGame extends FlameGame with KeyboardEvents {
  late Player player;

  // Spielfeld: 0 = leer, 1 = Wand
  final List<List<int>> map = [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  ];

  final double tileSize = 32;

  @override
  Future<void> onLoad() async {
    player = Player(tileSize);
    add(player);
  }

  @override
  void render(Canvas canvas) {
    // 1. Erst das Spielfeld zeichnen
    for (int y = 0; y < map.length; y++) {
      for (int x = 0; x < map[y].length; x++) {
        Rect tileRect = Rect.fromLTWH(x * tileSize, y * tileSize, tileSize, tileSize);

        final paint = Paint()
          ..color = (map[y][x] == 1) ? Colors.grey : Colors.white
          ..style = PaintingStyle.fill;

        canvas.drawRect(tileRect, paint);

        // Gitterlinien
        final border = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke;
        canvas.drawRect(tileRect, border);
      }
    }

    // 2. Dann den Spieler und andere Komponenten rendern
    super.render(canvas);
  }


  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    player.handleKeyboard(keysPressed, map);
    return KeyEventResult.handled;
  }
}

class Player extends PositionComponent with HasGameReference<BomberGame> {

  final double tileSize;
  static const double speed = 100;

  Player(this.tileSize) {
    size = Vector2(tileSize, tileSize);
    position = Vector2(tileSize, tileSize); // Start: (1,1)
    anchor = Anchor.topLeft;
    debugMode = true; // <<< zeigt Umriss und Position
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.blue;
    canvas.drawRect(size.toRect(), paint);
  }

  void placeBomb() {
    final pos = Vector2(
      (position.x / tileSize).floor() * tileSize,
      (position.y / tileSize).floor() * tileSize,
    );

    final bomb = Bomb(pos, tileSize);
    game.add(bomb);
  }



  @override
  void update(double dt) {
    super.update(dt);
    // Debug-Ausgabe:
    print('Spieler-Position: $position');
  }

  void handleKeyboard(Set<LogicalKeyboardKey> keysPressed, List<List<int>> map) {
    Vector2 direction = Vector2.zero();

    // Nur eine Richtung verarbeiten – in fester Reihenfolge
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      direction = Vector2(0, -1);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      direction = Vector2(0, 1);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      direction = Vector2(-1, 0);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      direction = Vector2(1, 0);
    }
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      placeBomb();
    }

    if (direction == Vector2.zero()) return;

    // Zielposition berechnen
    Vector2 nextPos = position + direction * tileSize;

    int targetX = (nextPos.x / tileSize).floor();
    int targetY = (nextPos.y / tileSize).floor();

    // Prüfen ob innerhalb der Map
    if (targetY >= 0 &&
        targetY < map.length &&
        targetX >= 0 &&
        targetX < map[0].length &&
        map[targetY][targetX] == 0) {
      // Bewegung ist erlaubt
      position += direction * tileSize;
    } else {
      print('BLOCKIERT durch Wand oder außerhalb');
    }
  }




}




