
PGraphics pg;
void setup(){
  size(800,600);
  pg=createGraphics(800,600);
  background(20);
  noStroke();
  colorMode(RGB, 1.0);
  
}


void draw(){
  float t=frameCount*0.01;

  pushMatrix();
  translate(width/2,height/2);
  rotate(t*0.006*sin(t*5));
  scale(1.04);
  image(pg, -width / 2, -height / 2, width, height);
  popMatrix();

 
  for (int j = 0; j < 8; ++j) {
   pushMatrix();
  translate(width / 2 + width * 0.02 * sin(t), height / 2 + height * 0.02 * sin(t * 1.37));
   rotate((2.0 * PI * j) / 8.0);
   translate(width * 0.01, 0.0);
   fill(noise(t, 0, j), noise(t, 1, j), noise(t, 2, j), 0.1);
    beginShape();
    for (int i = 0; i < 100; ++i) {
     float x = width * 0.25 * (0.5 - noise(t, 1.5, i * 0.01));
     float y = height * 0.25 * (0.5 - noise(t, 2.5, i * 0.01));
     vertex(x, y);
    }
    endShape();
    popMatrix();
  }

  float range = width * 0.25 * (1.4 + sin(t * 0.1));
 pg.beginDraw();
 pg.pushMatrix();
   translate(width / 2, height / 2);
  for (int i = 0; i < 10; ++i) {
    fill(0.0, 0.0, 0.0, 0.55);
  float dx = range * (0.5 - noise(t, 0, i * 0.1));
  float dy = range * (0.5 - noise(t, 1, i * 0.1));
    circle(dx, dy, 4);
  }
   pg.popMatrix();
  
  pg.copy(get(), 0, 0, width, height, 0, 0, width, height);
  pg.endDraw();
}
