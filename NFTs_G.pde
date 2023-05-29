// Programa generativo de NFTs - 05/2023
// Böhm in Space Pilgrimage - Böhm em Peregrinação do Espaço
// 2023136 Jorge Antunes

import processing.video.*; // Importa a biblioteca de vídeo do Processing
import processing.sound.*; // Importa a biblioteca de som do Processing
import ddf.minim.*;
import ddf.minim.ugens.*;

// Escolher video e imagens de fundo para o programa
String EscolheVideo = "NFTs-v2.mp4";
String EscolherImagem = "NFTs-v3.jpg";
String EscolherGravaSom = "NFTs-v3.wav";
boolean ambiente = false; // cria variável ligar e desligar cor ambiente
boolean maskara = false; // cria variável ligar e desligar máscara
// --------------------------------------------------------------------------------
PImage imgOne;
PImage imgMask;
Movie video; // Cria uma variável para armazenar o vídeo de fundo

boolean saveFrames = false; // Cria uma variável para armazenar se os frames devem ser salvos ou não
int frameCount = 0;
int capturedFrames = 0;
int shapeType = 1; // Cria uma variável para armazenar o tipo de forma (1 = cubos, 2 = pirâmides, 3 = esferas)
int lastChangeTime = 0; // Armazena o tempo da última mudança
int interval = 5000; // Intervalo entre mudanças (em milissegundos)
int numParticles = 100;
Particle[] particles = new Particle[numParticles];

Minim minim;
AudioOutput out;
Oscil sine;
AudioRecorder recorder;
boolean recording = false;
float[] waveform = new float[200]; // Array to store the waveform
float angle = 0; // Angle for generating the waveform

void setup() {
  // randomSeed(millis());
  // rest of setup code
  frameRate(30);  // Definindo a taxa de quadros por segundo para 30
  size(1280, 720, P3D); // Define o tamanho da janela e o modo de renderização 3D
  video = new Movie(this, EscolheVideo); // Carrega o vídeo de fundo
  video.loop(); // Define o vídeo para reproduzir em loop

  // carrega as imagens de mascra
  imgOne = loadImage(EscolherImagem);
  imgMask = loadImage(EscolherImagem);
  imgOne.mask(imgMask);
  imageMode(CENTER);
  imgOne.resize(width*2, height*2);

  // Inicia ferquencia do som
  minim = new Minim(this);
  out = minim.getLineOut();
  sine = new Oscil(random(440, 400), random(300, 250), Waves.SINE);
  sine.patch(out);
  recorder = minim.createRecorder(out, EscolherGravaSom); // grava o som em ficheiro

  for (int i = 0; i < numParticles; i++) {
    particles[i] = new Particle();
  }
  // perspective(PI/3.0, (float)width/height, ((height/2.0) / tan(PI*60.0/360.0))/10, ((height/2.0) / tan(PI*60.0/360.0))*10); // Re-creates the default perspective
}

void draw() {

  if (video.available()) { // Se há um novo frame do vídeo disponível
    video.read(); // Lê o novo frame do vídeo
  }

  background(video); // Define o plano de fundo como o frame atual do vídeo
  if (maskara == true) {
    translate(0, 0, -300);
    pushMatrix(); // Salva a matriz de transformação atual
    image(imgOne, width/2, height/2);
    popMatrix(); // Restaura a matriz de transformação anterior
  }

  //camera(mouseX, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0); //Sets the position of the camera com o rato
  camera(mouseX, height/2, (height/2) / tan(PI/6) + mouseY, width/2, height/2, 0, 0, 1, 0);  //  controla a posição da câmera ao longo do eixo Z com o rato

  //ambientLight(random(0, 255), random(0, 255), random(0, 255));  // muda a cor ambiente
  if (ambiente == true) { // Se a variável saveFrames for verdadeira
    corAmbiente();
  }

  // Get the brightness value of the pixel at the center of the video
  float pixelBrightness = brightness(get(width/2, height/2));
  // Map the brightness value to a frequency range
  float freq = map(pixelBrightness, 255, 0, 255, 0);
  // Set the frequency of the sine oscillator
  sine.setFrequency(freq);
  // Shift the values in the waveform array to the right
  for (int i = waveform.length-1; i > 0; i--) {
    waveform[i] = waveform[i-1];
  }
  // Add a new value to the waveform array based on the frequency of the sine oscillator
  waveform[0] = sin(angle);
  // Increment the angle based on the frequency of the sine oscillator and frame rate
  angle += freq * TWO_PI / frameRate;
  // Draw the waveform on the screen
  strokeWeight(random(1, 5));
  stroke(255);
  for (int i = 0; i < waveform.length-1; i++) {
    line(i*6, height/2 + waveform[i]*200, (i+1)*6, height/2 + waveform[i+1]*200);
  }

  strokeWeight(1);
  for (int i = 0; i < numParticles; i++) { // desenha as particulas
    particles[i].update();
    particles[i].display();
  }

  if (millis() - lastChangeTime > interval) { // Se o intervalo tiver passado
    shapeType = int(random(1, 4)); // Muda shapeType para um valor aleatório entre 1 e 3
    //corAmbiente();
    lastChangeTime = millis(); // Atualiza o tempo da última mudança
    interval = int(random(5000, 10000)); // Atualiza o intervalo para um valor aleatório entre 2000 e 5000 milissegundos
  }

  if (shapeType == 1) { // Se shapeType for igual a 1 (cubos)
    Qubos();
  } else if (shapeType == 2) { // Se shapeType for igual a 2 (pirâmides)
    Piramides();
  } else if (shapeType == 3) { // Se shapeType for igual a 3 (esferas)
    Esferas();
  }

  // Verificando se a tecla "f" foi pressionada para iniciar a captura de quadros
  if (saveFrames && capturedFrames < 450) { // Se a variável saveFrames for verdadeira
    saveFrame("frames/frame-####.png"); // Salva o frame atual como uma imagem PNG
    capturedFrames++;
  }
  // Verificando se atingiu o limite de quadros capturados
  if (capturedFrames >= 450) {
    println("450 quadros salvos como imagens.");
    exit();
  }
}

void keyPressed() {
  if (key == 'f' || key == 'F') { // Se a tecla pressionada for 'f' ou 'F'
    if (!recording) {
      // Start recording
      recorder.beginRecord();
      recording = true;
      saveFrames = !saveFrames; // Inverte o valor da variável saveFrames
    } else {
      // Stop recording
      recorder.endRecord();
      recorder.save();
      recording = false;
    }
  } else if (key == '1') { // Se a tecla pressionada for '1'
    shapeType = 1; // Define shapeType como 1 (cubos)
  } else if (key == '2') { // Se a tecla pressionada for '2'
    shapeType = 2; // Define shapeType como 2 (pirâmides)
  } else if (key == '3') { // Se a tecla pressionada for '3'
    shapeType = 3; // Define shapeType como 3 (esferas)
  } else if (key == 'l' || key == 'L') { // tecla muda cor do ambiente
    if (!ambiente) {
      ambiente = true;
    } else ambiente = false;
  } else if (key == 'm' || key == 'M') {
    if (!maskara) {
      maskara = true;
    } else maskara = false;
  }
}
void corAmbiente() {
  ambientLight(random(0, 255), random(0, 255), random(0, 255));  // muda a cor ambiente
}
