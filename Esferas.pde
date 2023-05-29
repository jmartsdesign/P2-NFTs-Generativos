float angleEx = 0; // Cria uma variável para armazenar o ângulo de rotação do grupo de esferas
float angleEy = 0; // Cria uma variável para armazenar o ângulo de rotação do grupo de esferas

void Esferas() {
  //corAmbiente();
  translate(width/2, height/2); // Move a origem para o centro da janela
  rotateX(angleEx); // Rotaciona o grupo de esferas em torno do eixo X
  rotateX(angleEy); // Rotaciona o grupo de esferas em torno do eixo X
  translate(0, 0, 100); // Move a esfera para fora do centro
  for (int i = 0; i < 8; i++) { // Para cada uma das 8 esferas
    pushMatrix(); // Salva a matriz de transformação atual
    rotateY(TWO_PI * i / 8); // Rotaciona a esfera em torno do eixo Y
    translate(200, 0); // Move a esfera para fora do centro
    fill(map(brightness(get(width/2, height/2)), 200, 100, 0, 255)); // Define a cor da esfera com base no valor de brilho do pixel central do vídeo
    sphere(random(25, 100)); // Desenha uma esfera com raio 25
    popMatrix(); // Restaura a matriz de transformação anterior
  }
  angleEx += 0.05; // Incrementa o ângulo de rotação
  angleEx += 0.05; // Incrementa o ângulo de rotação
}
