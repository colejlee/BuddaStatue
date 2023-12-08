import toxi.geom.Vec3D;
import java.util.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


Vec3D ht;
Vec3D v;
Vec3D fwd;
Minim minim;
AudioPlayer song;
FFT fft;

//change from 0 to 2 for different music
int mode = 0;


int maxSize = 50;
float dy, dx, mmL;
float theta = 0f;
float phi = ((1 + sqrt(5))/2);
float n;
float r;
float thta;
float Theta, Phi;
Vec3D XYZ;
Vec3D gear0;
color c;
int amount = 500;
int[] nx = new int[amount];
int[] ny = new int[amount];
int[] nz = new int[amount];

PShape bg, bgl, bgr, bgb, bgt, bgd, bglines, bgbox;
PShape head, hair, ear, lobe, nose,base;
PImage bgi, bgc, bgf;
PImage stone;




void setup() {
  //size of screen
  size(1000, 1000, P3D);

  //background
  bgi = loadImage("bg.jpeg");
  bgc = loadImage("roof.jpg");
  bgf = loadImage("floor.jpeg");
  stone = loadImage("stone.jpg");

  textureMode(NORMAL);
  bg = createShape(GROUP);


  bgb = createShape();
  bgb.beginShape();
  bgb.texture(bgi);
  bgb.vertex(0, 0, -500, 0, 0);
  bgb.vertex(1000, 0, -500, .75, 0);
  bgb.vertex(1000, 1000, -500, .75, 1);
  bgb.vertex(0, 1000, -500, 0, 1);
  bgb. endShape();


  bgl = createShape();
  bgl.beginShape();
  bgl.texture(bgi);
  bgl.vertex(0, 0, 500, 0, 0);
  bgl.vertex(0, 0, -500, .75, 0);
  bgl.vertex(0, 1000, -500, .75, 1);
  bgl.vertex(0, 1000, 500, 0, 1);
  bgl.endShape();
  bgl.setTexture(bgi);

  bgr = createShape();
  bgr.beginShape();
  bgr.texture(bgi);
  bgr.vertex(1000, 0, -500, 0, 0);
  bgr.vertex(1000, 1000, -500, 0, 1);
  bgr.vertex(1000, 1000, 500, 1, 1);
  bgr.vertex(1000, 0, 500, 1, 0);
  bgr.endShape();
  bgr.setTexture(bgi);

  bgt = createShape();
  bgt.beginShape();
  bgt.texture(bgc);
  bgt.vertex(0, 0, -500, .15, 0);
  bgt.vertex(1000, 0, -500, .15, 1);
  bgt.vertex(1000, 0, 500, 1, 1);
  bgt.vertex(0, 0, 500, 1, 0);
  bgt.endShape();
  bgt.setTexture(bgc);

  bgd = createShape();
  bgd.beginShape();
  bgd.texture(bgf);
  bgd.vertex(0, 1000, -500, 0, 0);
  bgd.vertex(1000, 1000, -500, 0, 1);
  bgd.vertex(1000, 1000, 500, 1, 1);
  bgd.vertex(0, 1000, 500, 1, 0);
  bgd.endShape();
  bgd.setTexture(bgf);

  bg.addChild(bgb);
  bg.addChild(bgl);
  bg.addChild(bgr);
  bg.addChild(bgt);
  bg.addChild(bgd);
  
  for (int i = 0; i<amount; i++) {
    nx[i] = int(random(-500, 500));
    ny[i] = int(random(-500, 500));
    nz[i] = int(random(-500, 500));
  }
  
  pushMatrix();

  //visual audio setup
  minim = new Minim(this);
  if (mode == 0) {
    song = minim.loadFile("meditation.mp3", 1024);
  } else if (mode == 1) {
    song = minim.loadFile("relax.mp3", 1024);
  } else if (mode == 2) {
    song = minim.loadFile("autumn.mp3", 1024);
  }
  
  song.play();
  fft = new FFT(song.bufferSize(), song.sampleRate());

  //center to middle
  translate(width/2, height/2, 0);
  ht = new Vec3D(1, 0, 0);
  v = new Vec3D(0, 1, 0);
  fwd = new Vec3D(0, 0, 1);
  gear0 = new Vec3D(100,100,100);
  XYZ = new Vec3D();
  pushMatrix();
}

void draw() {
  shape(bg);
  popMatrix();
  fft.forward(song.right);
  float freqRed = min(255, 25*fft.calcAvg(fft.indexToFreq(0), fft.indexToFreq(10)));
  float freqGreen = min(255, 25*fft.calcAvg(fft.indexToFreq(10), fft.indexToFreq(20)));
  float freqBlue = min(255, 25*fft.calcAvg(fft.indexToFreq(20), fft.indexToFreq(30)));  
  c = color(freqRed,freqGreen,freqBlue);

  //head
  pushMatrix();
  noStroke();
  head = createShape(SPHERE, 200);
  head.setTexture(stone);
  shape(head);
  translate(0, -200, 0);
  rotateZ(-PI/2);
  
  //hair
  hair = createShape(SPHERE, 10);
  hair.setTexture(stone);
  for (float i = 0; i < 337; i++) {
    r = sqrt(i);
    thta = TWO_PI*phi*i;
    shape(hair);
    translate(-.2, r*cos(thta)*17, r*sin(thta)*17);
  }
  popMatrix();
  pushMatrix();
  translate(0, 0, -200);
  rotateY(PI/2);
  for (float i = 0; i < 233; i++) {
    r = sqrt(i);
    thta = TWO_PI*phi*i;
    shape(hair);
    translate(-.2, r*cos(thta)*17, r*sin(thta)*17);
  }
  popMatrix();
  pushMatrix();
  translate(200, 0, -20);
  rotateY(PI/26);
  for (float i = 0; i < 233; i++) {
    r = sqrt(i);
    thta = TWO_PI*phi*i;
    shape(hair);
    translate(-.2, r*cos(thta)*17, r*sin(thta)*17);
  }
  popMatrix();
  pushMatrix();
  translate(-200, 0, -20);
  rotateY(-PI/26);
  for (float i = 0; i < 233; i++) {
    r = sqrt(i);
    thta = TWO_PI*phi*i;
    shape(hair);
    translate(.2, r*cos(thta)*17, r*sin(thta)*17);
  }
  popMatrix();
  pushMatrix();
  translate(-131, -89, -143);
  shape(hair);
  translate(29, -14, -3);
  shape(hair);
  translate(10,-17,0);
  shape(hair);
  translate(-39,2,27);
  shape(hair);
  translate(-9,-8,14);
  shape(hair);
  translate(-3,21,-9);
  shape(hair);
  translate(17,3,-9);
  shape(hair);
  translate(9,-17,-9);
  shape(hair);
  translate(15,0,-8);
  shape(hair);
  translate(-10,15,3);
  shape(hair);
  translate(-5,15,-6);
  shape(hair);
  translate(-6,14,-6);
  shape(hair);
  translate(-14,0,5);
  shape(hair);
  translate(6,10,0);
  shape(hair);
  popMatrix();
  pushMatrix();
  rotateY(-PI/2);
  translate(-142, -90, -127);
  shape(hair);
  translate(31, -13, -3);
  shape(hair);
  translate(2,-19,-8);
  shape(hair);
  translate(-40,2,31);
  shape(hair);
  translate(-5,5,16);
  shape(hair);
  translate(-2,7,-8);
  shape(hair);
  translate(17,3,-11);
  shape(hair);
  translate(9,-17,-4);
  shape(hair);
  translate(15,0,-8);
  shape(hair);
  translate(-10,15,3);
  shape(hair);
  translate(-5,15,-6);
  shape(hair);
  translate(-6,14,-6);
  shape(hair);
  translate(-14,0,5);
  shape(hair);
  translate(6,10,0);
  shape(hair);
  popMatrix();
  pushMatrix();
  rotateX(PI);
  rotateY(PI/2);
  translate(-136, -93, -110);
  shape(hair);
  translate(26, -13, -6);
  shape(hair);
  translate(10,-17,0);
  shape(hair);
  translate(-39,2,27);
  shape(hair);
  translate(-6,-8,8);
  shape(hair);
  translate(-3,21,-9);
  shape(hair);
  translate(17,3,-9);
  shape(hair);
  translate(9,-17,-9);
  shape(hair);
  translate(15,0,-8);
  shape(hair);
  translate(-10,15,3);
  shape(hair);
  translate(-5,15,-6);
  shape(hair);
  translate(-6,14,-6);
  shape(hair);
  translate(-14,0,5);
  shape(hair);
  translate(6,10,0);
  shape(hair);
  popMatrix();
  pushMatrix();
  rotateX(PI);
  rotateY(PI/-1);
  translate(-124, -93, -132);
  shape(hair);
  translate(26, -13, -6);
  shape(hair);
  translate(10,-17,0);
  shape(hair);
  translate(-39,2,27);
  shape(hair);
  translate(-6,-8,8);
  shape(hair);
  translate(-3,21,-9);
  shape(hair);
  translate(17,3,-9);
  shape(hair);
  translate(9,-17,-9);
  shape(hair);
  translate(15,0,-8);
  shape(hair);
  translate(-10,15,3);
  shape(hair);
  translate(-5,15,-6);
  shape(hair);
  translate(-6,14,-6);
  shape(hair);
  translate(-14,0,5);
  shape(hair);
  translate(6,10,0);
  shape(hair);
  popMatrix();
  
  //top knot
  pushMatrix();
  translate(0,-150,-50);
  rotateX(PI/2);
  
  for (float i2 = 0; i2 <= 100; i2+=4) {

    Theta = (TAU/100)*i2;

    for (float i = 0; i <= 100; i+=4) {

      float u = map (i, 0, 100, -1, 1);  

      XYZ.x =  gear0.x*cos(Theta)*sqrt(1-(u*u));
      XYZ.y =  gear0.y*sin(Theta)*sqrt(1-(u*u)); 
      XYZ.z =  gear0.z*u;

      pushMatrix();
      translate(XYZ.x, XYZ.y, XYZ.z);
      noStroke();
      shape(hair);
      popMatrix();
    }
  }
  popMatrix();
  
  //ears
  pushMatrix();
  translate(161,-21,129);
  ear = createShape(ELLIPSE, 0,0, 46, 93);
  ear.setTexture(stone);
  lobe = createShape(ELLIPSE, 0,0, 29, 104);
  lobe.setTexture(stone);
  shape(ear);
  translate(0,40,0);
  shape(lobe);
  popMatrix();
  pushMatrix();
  translate(-161, -21,129);
  shape(ear);
  translate(0,40,0);
  shape(lobe);
  popMatrix();
  
  //eyes
  pushMatrix();
  translate(-70,-37, 197);
  stroke(0);
  strokeWeight(3);
  line(0,0, 50, 10);
  translate(140, 0,0);
  line(-50, 10, 0,0);
  popMatrix();
  
  //eyebrows
  pushMatrix();
  translate(-38,-50, 193);
  noFill();
  strokeWeight(5);
  rotateZ(PI/20);
  arc(0,0, 74,-47, 0, PI);
  popMatrix();
  pushMatrix();
  translate(38,-50, 193);
  rotateZ(-PI/20);
  arc(0,0, 74, -47,0,PI);
  popMatrix();
  
  //nose
  pushMatrix();
  translate(0,0,193);
  rotateX(PI/5);
  rotateZ(PI/2);
  strokeWeight(0);
  nose = createShape(BOX, 56, 25, 37);
  nose.setTexture(stone);
  shape(nose);
  popMatrix();
  
  //mouth
  pushMatrix();
  translate(0,53,190);
  strokeWeight(4);
  arc(0,0,86,17,0,PI);
  popMatrix();
  
  //base
  pushMatrix();
  translate(0,200,0);
  strokeWeight(0);
  base = createShape(BOX, 320, 81, 320);
  base.setTexture(stone);
  shape(base);
  popMatrix();
  
  //color dots
  pushMatrix();
  noFill();
  box(1000);

  for (int i = 0; i<amount; i++) {
    stroke(color(c));
    strokeWeight(5);
    point(nx[i], ny[i], nz[i]);
  }
  noStroke();
  
  popMatrix();
  pushMatrix();
}


void mouseDragged() {
  popMatrix();
  float dx = (pmouseX-mouseX);
  float dy = (pmouseY-mouseY);
  Vec3D mm = ht.scale(dx).add(v.scale(dy));
  Vec3D rotAxis = mm.cross(fwd).normalize();

  float mmL = mm.magnitude()/width;
  if (mouseButton == LEFT) {
    rotateAroundAxisBasisChange(rotAxis, mmL);
    //mm = mm.rotateAroundAxis(rotAxis, mmL);
    ht = ht.rotateAroundAxis(rotAxis, -mmL).normalize();
    v = v.rotateAroundAxis(rotAxis, -mmL).normalize();
    fwd = fwd.rotateAroundAxis(rotAxis, -mmL).normalize();
  } else if (mouseButton == RIGHT) {
    rotateAroundAxisBasisChange(fwd, dx/200);

    ht = ht.rotateAroundAxis(fwd, -dx/200);
    v = v.rotateAroundAxis(fwd, -dx/200);
    //fwd = fwd.rotateAroundAxis(fwd, -dx/200);
  }
  pushMatrix();
}

void rotateAroundAxisBasisChange(Vec3D axis, float theta) {
  Vec3D w = new Vec3D(axis.x, axis.y, axis.z);
  w = w.normalize();
  Vec3D t = new Vec3D(w.x, w.y, w.z);
  if (abs(w.x) - min(abs(w.x), abs(w.y), abs(w.z)) < 0.001) {
    t.x = 1;
  } else if (abs(w.y) - min(abs(w.x), abs(w.y), abs(w.z)) < 0.001) {
    t.y = 1;
  } else if (abs(w.z) - min(abs(w.x), abs(w.y), abs(w.z)) < 0.001) {
    t.z = 1;
  }
  Vec3D u = w.cross(t);
  u = u.normalize();
  Vec3D v = w.cross(u);
  applyMatrix(u.x, v.x, w.x, 0,
    u.y, v.y, w.y, 0,
    u.z, v.z, w.z, 0,
    0.0, 0.0, 0.0, 1);
  rotateZ(theta);
  applyMatrix(u.x, u.y, u.z, 0,
    v.x, v.y, v.z, 0,
    w.x, w.y, w.z, 0,
    0.0, 0.0, 0.0, 1);
}
