class Particle {
  float xPos;
  float yPos;
  float speed = 1;
  float pa = random(100);
  float pb = random(100);
  int connect = 30;
  int hue = 0;
  Particle(){

  }
  
  void update(){
    
    xPos = map(noise(pa), 0, 1, 0, width);
    yPos = map(noise(pb), 0, 1, 0, height);
    
    pa += 0.0005;
    pb += 0.0005; 
    
    hue = (hue + 1)%360;
  }
  
  void display(){
    circle(xPos, yPos, 3);
  }
  
  void fillShape(){
    for (int i = 0; i < p.length; i ++){
      for (int j = i; j < p.length; j ++){
        if (p[i] != p[j]){
          float dist1 = dist(p[i].xPos, p[i].yPos, p[j].xPos, p[j].yPos);
          float dist2 = dist(xPos, yPos, p[i].xPos, p[i].yPos);
          float dist3 = dist(xPos, yPos, p[j].xPos, p[j].yPos);
          if (dist1 < connect && dist2 < connect && dist3 < connect){
            stroke(hue, 50, 100, 50);
            fill(hue, 35, 100, 50);
            beginShape();
            vertex(xPos, yPos);
            vertex(p[i].xPos, p[i].yPos);
            vertex(p[j].xPos, p[j].yPos);
            endShape();
          }
        }
      }
  
}
  }
}
