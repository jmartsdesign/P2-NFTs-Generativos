float angleC = 0; // Cria uma variável para armazenar o ângulo de rotação do grupo de cubos

void Qubos() {
  //corAmbiente();
  translate(width/2, height/2); // Move a origem para o centro da janela
  rotateX(angleC); // Rotaciona o grupo de cubos em torno do eixo X
  for (int i = 0; i < 8; i++) { // Para cada um dos 8 cubos
    pushMatrix(); // Salva a matriz de transformação atual
    rotateY(TWO_PI * i / 8); // Rotaciona o cubo em torno do eixo Y
    translate(random(100, 250), 0); // Move o cubo para fora do centro
    fill(map(brightness(get(width/2, height/2)), 200, 100, 0, 255)); // Define a cor do cubo com base no valor de brilho do pixel central do vídeo
    box(60,random(10,200),60); // Desenha um cubo com tamanho 50
    popMatrix(); // Restaura a matriz de transformação anterior
  }
  angleC += 0.05; // Incrementa o ângulo de rotação
}
