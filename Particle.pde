
class Particle {
  float x, y;
  float xSpeed, ySpeed;

  Particle() {
    x = random(width);
    y = random(height);
    xSpeed = random(-2, 2);
    ySpeed = random(-2, 2);
  }

  void update() {
    // Calcula a posição desejada ao longo do caminho da elipse
    float angle = frameCount * 0.01;
    float targetX = width/2 + cos(angle) * width/2;
    float targetY = height/2 + sin(angle) * height/2;

    // Atualiza a velocidade das partículas em direção à posição desejada
    xSpeed += (targetX - x) * 0.04;
    ySpeed += (targetY - y) * 0.01;

    // Atualiza a posição das partículas
    x += xSpeed;
    y += ySpeed;

    // Adiciona verificação de limite
    if (x < 0) {
      x = 0;
      xSpeed = -xSpeed;
    } else if (x > width) {
      x = width;
      xSpeed = -xSpeed;
    }

    if (y < 0) {
      y = 0;
      ySpeed = -ySpeed;
    } else if (y > height) {
      y = height;
      ySpeed = -ySpeed;
    }
  }

  void display() {
    //fill(map(brightness(get(width/2, height/2)), 200, 100, 0, 255)); // Define a cor da esfera com base no valor de brilho do pixel central do vídeo
    //ellipse(x, y, 10, 10);
    //float particleSize = random(10, 20); // Define o tamanho da partícula
    float particleSize = random(10,35); // Define o tamanho da partícula
    ellipse(x, y, particleSize, particleSize);
  }
}
