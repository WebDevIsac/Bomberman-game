import processing.serial.*;

Tile[][] myMap;
float l;
boolean[] p1c, p2c;
ArrayList<Bomb> bombs;

Serial myPort;
String arduinoString;
String valString;
int val;

Index p1, p2;

PImage bombImg;

void setup() {
  //String portName = Serial.list()[0];
  //myPort = new Serial(this, portName, 115200);
  
  size(800, 800); 
  frameRate(30);
  myMap = new Tile[19][19];
  l = width / float(myMap.length);
  
  p1 = new Index( 1, 1 );
  p2 = new Index( myMap.length - 2, myMap[0].length - 2 );
  p1c = new boolean[5];
  p2c = new boolean[5];
  
  bombs = new ArrayList();

  bombImg = loadImage("bomb.png");
  
  makeMap();
}

void makeMap() {
  println(myMap.length);
  for (int x = 0; x < myMap.length; x++){
    int t = 0;
   for (int y = 0; y < myMap[0].length; y++){
     if (y == 0 || y == myMap[0].length - 1 || x == 0 || x == myMap.length - 1) {
       t = 2;
     }
     else if ((y + 1) % 2 != 0 && y < myMap[0].length - 1 && (x + 1) % 2 != 0)  {
       t = 2;
     }
     else if ((y != 1 || x != 1) && (y != 2 || x != 1) && (y != 1 || x != 2) && (y != myMap[0].length - 2 || x != myMap.length - 2) && (y != myMap[0].length - 3 || x != myMap.length - 2) && (y != myMap[0].length - 2 || x != myMap.length - 3)) {
       if (abs((9-dist( x, y, 7, 6 )) * randomGaussian()) > 0.4 ) {
         t = 1;
       }
       else {
         t = 0;
       }
     }
     else {
       t = 0;
     }
    //  image(bombImg, 16, 16, 32, 32);
     myMap[x][y] = new Tile(t);
   }
  }
}

void draw() {
  
  //if (myPort.available() > 0) {
  //   valString = myPort.readString();
  //   moveChar(valString);
  //   println(valString);
  //}
  
  for (int x = 0; x < myMap.length; x++){
    for (int y = 0; y < myMap[0].length; y++){
      pushMatrix();
      translate(x*l,y*l);
      myMap[x][y].plot();
      popMatrix();
    }
  }
  
  //P1
  if( p1.i >= 0 ){
    if (p1c[0]) {
      if (myMap[p1.i][p1.j-1].atravessavel()) p1.j--; 
    }
    if (p1c[1]) {
      if (myMap[p1.i][p1.j+1].atravessavel()) p1.j++; 
    }
    if (p1c[2]) {
      if (myMap[p1.i-1][p1.j].atravessavel()) p1.i--; 
    }
    if (p1c[3]) {
      if (myMap[p1.i+1][p1.j].atravessavel()) p1.i++; 
    }
    if( p1c[4] ) bombs.add( new Bomb( p1 ) );
  }
    
  
  //P2
  if( p2.i >= 0 ){
    if (p2c[0]) {
      if (myMap[p2.i][p2.j-1].atravessavel()) p2.j--; 
    }
    if (p2c[1]) {
      if (myMap[p2.i][p2.j+1].atravessavel()) p2.j++; 
    }
    if (p2c[2]) {
      if (myMap[p2.i-1][p2.j].atravessavel()) p2.i--; 
    }
    if (p2c[3]) {
      if (myMap[p2.i+1][p2.j].atravessavel()) p2.i++; 
    }
    if( p2c[4] ) bombs.add( new Bomb( p2 ) );
  }
  
  fill( 0, 0, 255);
  ellipse( (p1.i + 0.5) * l, (p1.j + 0.5) * l, l, l);
  fill(255, 0, 0);
  ellipse( (p2.i + 0.5) * l, (p2.j + 0.5) * l, l, l);
  
  for(int i = bombs.size()-1; i >= 0; --i ){
    bombs.get(i).plot();
    if( bombs.get(i).explodiu() ){
      
      if( p1.i == bombs.get(i).pos.i &&
          abs( p1.j - bombs.get(i).pos.j ) <= 2 ){
        p1 = new Index( -1, -1 );
      }
      if( p2.i == bombs.get(i).pos.i &&
          abs( p2.j - bombs.get(i).pos.j ) <= 2 ){
        p2 = new Index( -1, -1 );
      }
      if( p1.j == bombs.get(i).pos.j &&
          abs( p1.i - bombs.get(i).pos.i ) <= 2 ){
        p1 = new Index( -1, -1 );
      }
      if( p2.j == bombs.get(i).pos.j &&
          abs( p2.i - bombs.get(i).pos.i ) <= 2 ){
        p2 = new Index( -1, -1 );
      }
      
      for(int x=-2; x <= 2; x++){
        if( x == 0 ) continue;
        int I = bombs.get(i).pos.i + x;
        if( I < 0 || I > myMap.length-1 ) continue;
        if( myMap[I][bombs.get(i).pos.j].tipo == 1 ){
          myMap[I][bombs.get(i).pos.j].tipo = 0;
        }
      }
      for(int y=-2; y <= 2; y++){
        if( y == 0 ) continue;
        int J = bombs.get(i).pos.j + y;
        if( J < 0 || J > myMap[0].length-1 ) continue;
        if( myMap[bombs.get(i).pos.i][J].tipo == 1 ){
          myMap[bombs.get(i).pos.i][J].tipo = 0;
        }
      }
      bombs.remove(i);
    }
  }
  
  p1c[0] = false;
  p1c[1] = false;
  p1c[2] = false;
  p1c[3] = false;
  p1c[4] = false;
  
}
