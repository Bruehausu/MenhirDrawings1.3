//The Menhirs. Ignore the Aztec look.

ArrayList<Menhir> menhirs;

//seperately handles a menhir drawing
void drawMenhir(int x,int y,int dw,int dh){
  noStroke();
  int ang = dw/4;
  fill(255);
  beginShape();
  vertex(x+dw, y+dh-ang);
  vertex(x+dw/2, y+dh);
  vertex(x, y+dh-ang);
  vertex(x, y+ang);
  vertex(x+dw/2,y);
  vertex(x+dw,y+ang);
  endShape();
  stroke(0);
  strokeWeight(3);
  beginShape();
  vertex(x+dw,y+ang + 20);
  vertex(x+dw, y+dh-ang);
  vertex(x+dw/2, y+dh);
  vertex(x+dw/2,y+2*ang);
  vertex(x+dw,y+ang);
  vertex(x+dw/2,y);
  vertex(x, y+ang);
  vertex(x, y+dh-ang);
  endShape();
  noFill();

}

//seperately draws the shadow of a menhir
void drawShadow(int x,int y,int dw,int dh){
  int ang = dw/4;
  stroke(0);
  noFill();
  beginShape();
  vertex(x, y+dh-ang);
  vertex(x-dh,y+dh-ang+(dh/2));  //here be logial derails
  vertex(x-dh+dw/10,y+dh-ang+(dh/2)+ang/5);
  vertex(x + dw/10, y+dh-ang + ang/5);
  vertex(x+ (2*dw/10), y+dh-ang +(2*ang/5));
  vertex(x-dh+ (2*dw/10),y+dh-ang+(dh/2)+(2*ang/5));
  vertex(x-dh+ (3*dw/10),y+dh-ang+(dh/2)+(3*ang/5));  
  vertex(x+ (3*dw/10), y+dh-ang +(3*ang/5));
  vertex(x+ (4*dw/10), y+dh-ang +(4*ang/5));
  vertex(x-dh+ (4*dw/10),y+dh-ang+(dh/2)+(4*ang/5));
  vertex(x-dh+ (5*dw/10),y+dh-ang+(dh/2)+(5*ang/5)); 
  vertex(x+ (dw/2) - ang , y+dh-ang + 3*ang/2);
  endShape();
  
}

// class that handles the standing stones
class Menhir{
  int x;
  int y;
  int trueY;
  int h;
  int w;
  float radius;
  
  Menhir(){
    x = 0;
    y = 0;
    trueY = 0;
    h = int(random(90,height/4));
    w = int(random(30,width/8));
    radius = map (noise(millis()), 0.0,1.0 , 0.0,0.6);
  }
  
  //given an angle relative to the baseline (y = width/2), 
  //places the menhir on that angle. 
  void update(float ang){
    x = width/2 + int(width*radius * cos(ang));
    y = height/2 + int(height*radius * sin(ang));
    trueY = y;
    if(mouseX < width/2) { 
      x = width - x;
      y = height - y;
    }
  }
  
  //I'm bad at code.
  void displayShadow(){
    drawShadow(x,y,w,h);
  }
  
  void display(){
    drawMenhir(x,y,w,h);
  }
  
}

//creates the environment and the first menhir
void setup(){
  size(700,700);
  menhirs = new ArrayList<Menhir>();
  menhirs.add(new Menhir());
}

//function that sorts the menhirs based on y position, so that
//they can later drawn from front to back.
//Zach Rispoli helped write this. 
ArrayList<Menhir> zjrispolsort(ArrayList<Menhir> menhirs){
  ArrayList<Menhir> sorted = new ArrayList<Menhir>();
  ArrayList<Menhir> temp = new ArrayList<Menhir>();
  for(int i = 0; i < menhirs.size(); i++){
    temp.add(menhirs.get(i));
  }
  while(temp.size() > 0) {
    int minIndex = 0;
    for(int i = 0; i < temp.size(); i++) {
      if(temp.get(i).y < temp.get(minIndex).y) {
        minIndex = i;
      }
    }
    sorted.add(temp.get(minIndex));
    temp.remove(minIndex);
  }
  
  return sorted;
}

//finds the relative angle of the mouse, and uses that to find
//the angle that each menhir should hold, then draws them in place
void draw(){
  background(255);
  float dx = float(mouseX -(width/2));
  float dy = float(mouseY -(height/2));
  float mrads = atan(dy/dx);
  float diff = TWO_PI/float(menhirs.size()+1);

  for (int i = 0; i< menhirs.size(); i++) {
    Menhir menhir = menhirs.get(i);
    float ang = mrads + diff*(i+1);
    menhir.update(ang);
  }
  
  
  ArrayList<Menhir> tempMenhirs = zjrispolsort(menhirs);
  
  //shadows rendered seperately so that all menhirs appear in front
  //of the other menhirs' shadows
  for (int i = 0; i< tempMenhirs.size(); i++) {
    Menhir menhir = tempMenhirs.get(i);
    menhir.displayShadow();
  }
  
  for (int i = 0; i< tempMenhirs.size(); i++) {
    Menhir menhir = tempMenhirs.get(i);
    menhir.display();
  }
}

// left click adds a menhir up to 10, right click removes a menhir
// down to 1
void mousePressed() {
  if (mouseButton == LEFT && menhirs.size() < 10){
    println("menhir added");
    menhirs.add(new Menhir());
  } else if (mouseButton == RIGHT && menhirs.size() > 1){
    menhirs.remove(0);
  }
}
