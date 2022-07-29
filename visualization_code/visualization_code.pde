final int N = 128;
final int iter = 16;
final int SCALE = 4;

Fluid fluid;

void settings(){
  size(N * SCALE, N*SCALE);
  
}

void setup(){
  fluid = new Fluid(0.5, 0, 0);
}

void mouseDragged(){
  fluid.addDensity (mouseX/SCALE, mouseY/SCALE, 100);
  float amtX = mouseX - pmouseX;
  float amtY = mouseY - pmouseY;
  fluid.addVelocity (mouseX/SCALE, mouseY/SCALE, atmX, atmY);
}
  
  
void draw(){
  background(0);
  //int cx = int(0.5 * width/SCALE);
  //int cy = int(0.5 * height/SCLAE);
  //fluid.addDensity (cx, cy, random(100, 500));
  //float amtX = map(noise(t), 0, 1, -1, 1);
  //float amtY = map(noise(t+100), 0, 1, -1, 1);
  //t += 
  //fluid.addVelocity (mouseX/SCALE, mouseY/SCALE, atmX, atmY);
  fluid.step();
  fluid.renderD();
  fluid.fadeD();
}
