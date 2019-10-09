import processing.serial.*;

Tile[][] mapa;
float l;
boolean[] p1c, p2c;
ArrayList<Bomb> bombs;
Serial myPort;
String arduinoString;
String valString;
int val;
int player1score = 0;
int player2score = 0;

Index p1, p2;
void setup() {
  //String portName = Serial.list()[0];
  //myPort = new Serial(this, portName, 115200);
  
  size(800, 600); 
  frameRate(30);
  mapa = new Tile[20][20];
  l = width / float(mapa.length);
  
  p1 = new Index( 1, 1 );
  p2 = new Index( 13, 11 );
  p1c = new boolean[5];
  p2c = new boolean[5];
  
  bombs = new ArrayList();
  
  makeMapa();
  
}

void makeMapa() {
  PImage file = loadImage("mapa.png");
  for (int x=0; x<mapa.length ; x++){
   for (int y=0; y<mapa[0].length ; y++){
     int t = 0;
     color c = file.get(x,y);
     if( c == color(0) ) t = 2;
     else if( c == color(127) ) t = 1;
     //else if( c == color(195) ) 
     else if( c == color( 255 ) ){
       if( abs((9-dist( x, y, 7, 6 )) * randomGaussian()) > 1.2 ) t = 1;
     }
     
     mapa[x][y] = new Tile(t);
   }
  }
}

void draw() {
  
  // if (myPort.available() > 0) { 
  //    valString = myPort.readString();
  //    moveChar(valString);
  //    println(valString);
  // }
  
  for (int x=0; x<mapa.length ; x++){
    for (int y=0; y<mapa[0].length ; y++){
      pushMatrix();
      translate(x*l,y*l);
      mapa[x][y].plot();
      popMatrix();
    }
  }
  
  //P1
  if( p1.i >= 0 ){
    if (p1c[0]) {
      if (mapa[p1.i][p1.j-1].atravessavel()) p1.j--; 
    }
    if (p1c[1]) {
      if (mapa[p1.i][p1.j+1].atravessavel()) p1.j++; 
    }
    if (p1c[2]) {
      if (mapa[p1.i-1][p1.j].atravessavel()) p1.i--; 
    }
    if (p1c[3]) {
      if (mapa[p1.i+1][p1.j].atravessavel()) p1.i++; 
    }
    if( p1c[4] ) {
      bombs.add( new Bomb( p1 ) );
      print(bombs);
    }
  }
    
  
  //P2
  if( p2.i >= 0 ){
    if (p2c[0]) {
      if (mapa[p2.i][p2.j-1].atravessavel()) p2.j--; 
    }
    if (p2c[1]) {
      if (mapa[p2.i][p2.j+1].atravessavel()) p2.j++; 
    }
    if (p2c[2]) {
      if (mapa[p2.i-1][p2.j].atravessavel()) p2.i--; 
    }
    if (p2c[3]) {
      if (mapa[p2.i+1][p2.j].atravessavel()) p2.i++; 
    }
    if( p2c[4] ){
      bombs.add( new Bomb( p2 ) );
      print(bombs);
    }
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
            player2score++;
            println("p1:" + player1score + "-" + "p2:" + player2score);
            // bombs.remove(0);
            p1 = new Index( 1, 1 );
            makeMapa();
      }
      if( p2.i == bombs.get(i).pos.i &&
          abs( p2.j - bombs.get(i).pos.j ) <= 2 ){
            p2 = new Index( -1, -1 );
            player1score++;
            println("p1:" + player1score + "-" + "p2:" + player2score);
            // bombs.remove(0);
            p2 = new Index( 13, 11 );
            makeMapa();
      }
      if( p1.j == bombs.get(i).pos.j &&
          abs( p1.i - bombs.get(i).pos.i ) <= 2 ){
            p1 = new Index( -1, -1 );
            player2score++;
            println("p1:" + player1score + "-" + "p2:" + player2score);
            // bombs.remove(0);
            p1 = new Index( 1, 1 );
            makeMapa();
      }
      if( p2.j == bombs.get(i).pos.j &&
          abs( p2.i - bombs.get(i).pos.i ) <= 2 ){
            p2 = new Index( -1, -1 );
            player1score++;
            println("p1:" + player1score + "-" + "p2:" + player2score);
            // bombs.remove(0);
            p2 = new Index( 13, 11 );
            makeMapa();
      }
      
      for(int x=-2; x <= 2; x++){
        if( x == 0 ) continue;
        int I = bombs.get(i).pos.i + x;
        if( I < 0 || I > mapa.length-1 ) continue;
        if( mapa[I][bombs.get(i).pos.j].tipo == 1 ){
          mapa[I][bombs.get(i).pos.j].tipo = 0;
        }
      }
      for(int y=-2; y <= 2; y++){
        if( y == 0 ) continue;
        int J = bombs.get(i).pos.j + y;
        if( J < 0 || J > mapa[0].length-1 ) continue;
        if( mapa[bombs.get(i).pos.i][J].tipo == 1 ){
          mapa[bombs.get(i).pos.i][J].tipo = 0;
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
