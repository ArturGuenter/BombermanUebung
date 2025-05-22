import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    super.render(canvas);

    // Spielfeld zeichnen
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
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    player.handleKeyboard(keysPressed);
    return KeyEventResult.handled;
  }
}

class Player extends PositionComponent {
  final double tileSize;
  static const double speed = 100;

  Player(this.tileSize) {
    size = Vector2(tileSize, tileSize);
    position = Vector2(tileSize, tileSize); // Start im Feld (1,1)
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawRect(size.toRect(), paint);
  }

  void handleKeyboard(Set<LogicalKeyboardKey> keysPressed) {
    Vector2 direction = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      direction.y = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      direction.y = 1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      direction.x = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      direction.x = 1;
    }

    direction.normalize();
    position += direction * speed * (1 / 60);
  }
}
