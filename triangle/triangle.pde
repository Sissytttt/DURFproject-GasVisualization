Particle[] p = new Particle[30];

void setup(){
  size(400, 400);
  for(int i = 0; i < p.length; i ++){
    p[i] = new Particle();
  }
  colorMode(HSB, 360, 100, 100);
}

void draw(){
  background(255, 0, 100);
  for (int i = 0; i < p.length; i ++){
    p[i].update();
    p[i].display();
    p[i].fillShape();
  }
}
