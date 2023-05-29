
float angleY = 0; // Cria uma variável para armazenar o ângulo de rotação do grupo de pirâmides em torno do eixo Y
float angleZ = 0; // Cria uma variável para armazenar o ângulo de rotação do grupo de pirâmides em torno do eixo Z

void Piramides() {

  //corAmbiente();
  translate(width/2, height/2); // Move a origem para o centro da janela
  rotateY(angleY); // Rotaciona o grupo de pirâmides em torno do eixo Y
  rotateZ(angleZ); // Rotaciona o grupo de pirâmides em torno do eixo Z
  for (int i = 0; i < 8; i++) { // Para cada uma das 8 pirâmides
    pushMatrix(); // Salva a matriz de transformação atual
    rotateY(TWO_PI * i / 8); // Rotaciona a pirâmide em torno do eixo Y
    translate(250, 0); // Move a pirâmide para fora do centro
    fill(map(brightness(get(width/2, height/2)), 200, 100, 0, 255)); // Define a cor da pirâmide com base no valor de brilho do pixel central do vídeo
    pyramid(random(50, 150)); // Desenha uma pirâmide com tamanho base 50
    popMatrix(); // Restaura a matriz de transformação anterior
  }
  angleY += 0.05; // Incrementa o ângulo de rotação em torno do eixo Y
  angleZ += 0.03; // Incrementa o ângulo de rotação em torno do eixo Z
}

void pyramid(float s) {
  beginShape(TRIANGLES);

  vertex(-s/2, s/2, -s/2);
  vertex(s/2, s/2, -s/2);
  vertex(0, -s/2, 0);

  vertex(s/2, s/2, -s/2);
  vertex(s/2, s/2, s/2);
  vertex(0, -s/2, 0);

  vertex(s/2, s/2, s/2);
  vertex(-s/2, s/2, s/2);
  vertex(0, -s/2, 0);

  vertex(-s/2, s/2, s/2);
  vertex(-s/2, s/2, -s/2);
  vertex(0, -s/2, 0);

  endShape();
}
