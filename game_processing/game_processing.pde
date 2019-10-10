import processing.serial.*;

Tile[][] map;
float l;
boolean[] p1c, p2c;
ArrayList<P1Bomb> p1bombs;
ArrayList<P2Bomb> p2bombs;
String arduinoString;
Serial p1Port;
Serial p2Port;
String p1ValString;
String p2ValString;
int val;
int player1score = 0;
int player2score = 0;
int p1bomb = 0;
int p2bomb = 0;
int player1life = 3;
int player2life = 3;

Index p1, p2;

PImage bombImg;
PImage barrelImg;
PImage wallImg;
PImage pathImg;
PImage explosionImg;

void setup() {
  // String p1PortName = Serial.list()[1];
  // p1Port = new Serial(this, p1PortName, 115200);
  // String p2PortName = Serial.list()[0];
  // p2Port = new Serial(this, p2PortName, 230400);
  
  size(800, 800); 
  frameRate(30);
  map = new Tile[19][19];
  l = width / float(map.length);
  
  p1 = new Index( 1, 1 );
  p2 = new Index( map.length - 2, map[0].length - 2 );
  p1c = new boolean[5];
  p2c = new boolean[5];

  p1bombs = new ArrayList();
  p2bombs = new ArrayList();
  
  bombImg = loadImage("bomb.png");
  barrelImg = loadImage("barrel.png");
  wallImg = loadImage("wall.png");
  pathImg = loadImage("path.jpg");
  explosionImg = loadImage("explosion.png");
  
  makeMap();
  
}

void makeMap() {
  for (int x = 0; x < map.length; x++){
    int t = 0;
   for (int y = 0; y < map[0].length; y++){
    // Setting up walls around map
     if (y == 0 || y == map[0].length - 1 || x == 0 || x == map.length - 1) {
       t = 2;
     }
    // Setting up pillars on map
     else if ((y + 1) % 2 != 0 && y < map[0].length - 1 && (x + 1) % 2 != 0)  {
       t = 2;
     }
    // Setting up barrels randomly on map
     else if ((y != 1 || x != 1) && (y != 2 || x != 1) && (y != 1 || x != 2) && (y != map[0].length - 2 || x != map.length - 2) && (y != map[0].length - 3 || x != map.length - 2) && (y != map[0].length - 2 || x != map.length - 3)) {
       if (abs((9-dist( x, y, 7, 6 )) * randomGaussian()) > 0.4 ) {
         t = 1;
       }
      // Setting up path for all empty tiles
       else {
         t = 0;
       }
     }
      //  Setting up path for all empty tiles
     else {
       t = 0;
     }
    //  image(bombImg, 16, 16, 32, 32);
     map[x][y] = new Tile(t);
   }
  }
}

void draw() {
  
  // if (p1Port.available() > 0 || p2Port.available() > 0) { 
  //    p1ValString = p1Port.readString();
  //    p2ValString = p2Port.readString();
  //    if (p1ValString != null) movePlayer1(p1ValString);
  //    if (p2ValString != null) movePlayer2(p2ValString);
  // }

  for (int x=0; x<map.length ; x++){
    for (int y=0; y<map[0].length ; y++){
      pushMatrix();
      translate(x*l,y*l);
      map[x][y].plot();
      popMatrix();
    }
  }
  
  //P1
  // Moving character
  if( p1.i >= 0 ){
    if (p1c[0]) {
      if (map[p1.i][p1.j-1].atravessavel()) p1.j--; 
    }
    if (p1c[1]) {
      if (map[p1.i][p1.j+1].atravessavel()) p1.j++; 
    }
    if (p1c[2]) {
      if (map[p1.i-1][p1.j].atravessavel()) p1.i--; 
    }
    if (p1c[3]) {
      if (map[p1.i+1][p1.j].atravessavel()) p1.i++; 
    }
    // Placing out bomb
    if( p1c[4] && p1bomb == 0 ) {
      p1bombs.add( new P1Bomb( p1 ) );
      p1bomb = 1;
    }
  }
  
  //P2
  // Moving character
  if( p2.i >= 0 ){
    if (p2c[0]) {
      if (map[p2.i][p2.j-1].atravessavel()) p2.j--; 
    }
    if (p2c[1]) {
      if (map[p2.i][p2.j+1].atravessavel()) p2.j++; 
    }
    if (p2c[2]) {
      if (map[p2.i-1][p2.j].atravessavel()) p2.i--; 
    }
    if (p2c[3]) {
      if (map[p2.i+1][p2.j].atravessavel()) p2.i++; 
    }

    // Placing out bomb
    if( p2c[4] && p2bomb == 0){
      p2bombs.add( new P2Bomb( p2 ) );
      p2bomb = 1;
    }
  }
  
  // Show players as ellipse at specific i and j positions. 
  fill( 0, 0, 255);
  ellipse( (p1.i + 0.5) * l, (p1.j + 0.5) * l, l, l);
  fill(255, 0, 0);
  ellipse( (p2.i + 0.5) * l, (p2.j + 0.5) * l, l, l);
  
  // Start for loop for player 1 bomb
  for(int i = p1bombs.size()-1; i >= 0; --i ){
    // Shows bomb on map
    p1bombs.get(i).plot();
    // If bomb explode
    if( p1bombs.get(i).explode() ){
      // If bomb hits player 1 in y position
      if( p1.i == p1bombs.get(i).pos.i &&
          abs( p1.j - p1bombs.get(i).pos.j ) <= 3 ){
            player1life--;
            if(player1life == 0) {
              player1life = 3;
              player2score++;
              p1 = new Index( 1, 1 );
              p2 = new Index( 17, 17 );
              if(p2bomb == 1) {
                p2bombs.remove(i);
                p2bomb = 0;
              }
              makeMap();
            }
            println("p1:" + player1score + "-" + "p2:" + player2score);
      }
      // If bomb hits player 1 in x position
      else if( p1.j == p1bombs.get(i).pos.j &&
          abs( p1.i - p1bombs.get(i).pos.i ) <= 3 ){
            player1life--;
            if(player1life == 0) {
              player1life = 3;
              player2score++;
              p1 = new Index( 1, 1 );
              p2 = new Index( 17, 17 );
              if(p2bomb == 1){
                p2bombs.remove(i);
                p2bomb = 0;
              } 
              makeMap();
            }
            println("p1:" + player1score + "-" + "p2:" + player2score);
      }
      // If bomb hits player 2 in y position
      if( p2.i == p1bombs.get(i).pos.i &&
          abs( p2.j - p1bombs.get(i).pos.j ) <= 3 ){
            player2life--;
            if(player2life == 0) {
              player2life = 3;
              player1score++;
              p1 = new Index( 1, 1 );
              p2 = new Index( 17, 17 );
              if(p2bomb == 1){
                p2bombs.remove(i);
                p2bomb = 0;
              } 
              makeMap();
            }
            println("p1:" + player1score + "-" + "p2:" + player2score);
      }
      // If bomb hits player 2 in x position
      else if( p2.j == p1bombs.get(i).pos.j &&
          abs( p2.i - p1bombs.get(i).pos.i ) <= 3 ){
            player2life--;
            if(player2life == 0) {
              player2life = 3;
              player1score++;
              p1 = new Index( 1, 1 );
              p2 = new Index( 17, 17 );
              if(p2bomb == 1){
                p2bombs.remove(i);
                p2bomb = 0;
              } 
              makeMap();
            }
            println("p1:" + player1score + "-" + "p2:" + player2score);
      }
      
      // Removing barrels and setting path instead in x position
      for (int index = -3; index < 4; index++) {

        // Setting I to bomb x position + index
        int I = p1bombs.get(i).pos.i + index;

        if (index == 0) {
          continue;
        }

        // Checking if x position is not outside the map
        if (I < 0 || I > map.length - 1) {
          continue;
        }

        // If x position is a path
        if (map[I][p1bombs.get(i).pos.j].tipo == 0) {
          // Checking to the right
          if (map[p1bombs.get(i).pos.i + 1][p1bombs.get(i).pos.j].tipo != 2) {
            image(explosionImg, 42 * I, 42 * p1bombs.get(i).pos.j, 42, 42);
          }
          // Checking to the left
          if (map[p1bombs.get(i).pos.i - 1][p1bombs.get(i).pos.j].tipo != 2) {
            image(explosionImg, 42 * I, 42 * p1bombs.get(i).pos.j, 42, 42);
          }
        }
        // If x position is a barrel
        if (map[I][p1bombs.get(i).pos.j].tipo == 1) {
          // If there is not a wall in the way, remove barrel and set path
          // Checking to the right
          if (map[p1bombs.get(i).pos.i + 1][p1bombs.get(i).pos.j].tipo != 2) {
            image(explosionImg, 42 * I, 42 * p1bombs.get(i).pos.j, 42, 42);
            map[I][p1bombs.get(i).pos.j].tipo = 0;
          }
          // Checking to the left
          if (map[p1bombs.get(i).pos.i - 1][p1bombs.get(i).pos.j].tipo != 2) {
            image(explosionImg, 42 * I, 42 * p1bombs.get(i).pos.j, 42, 42);
            map[I][p1bombs.get(i).pos.j].tipo = 0;
          }
        }
      }

      // Removing barrels and setting path instead in y position
      for (int index = -3; index < 4; index++) {
        // Setting I to bomb y position + index
        int J = p1bombs.get(i).pos.j + index;

        if (index == 0) {
          continue;
        }

        // Checking if x position is not outside the map
        if (J < 0 || J > map.length - 1) {
          continue;
        }
        
        // If y position is a path
        if (map[p1bombs.get(i).pos.i][J].tipo == 0) {
          // Checking below
          if (map[p1bombs.get(i).pos.i][p1bombs.get(i).pos.j + 1].tipo != 2) {
            image(explosionImg, 42 * p1bombs.get(i).pos.i, 42 * J, 42, 42);
          }
          // Checking above
          if (map[p1bombs.get(i).pos.i][p1bombs.get(i).pos.j - 1].tipo != 2) {
            image(explosionImg, 42 * p1bombs.get(i).pos.i, 42 * J, 42, 42);
          }
        }
        // If y position is a barrel
        if (map[p1bombs.get(i).pos.i][J].tipo == 1) {
          // If there is not a wall in the way, remove barrel and set path
          // Checking below
          if (map[p1bombs.get(i).pos.i][p1bombs.get(i).pos.j + 1].tipo != 2) {
            image(explosionImg, 42 * p1bombs.get(i).pos.i, 42 * J, 42, 42);
            map[p1bombs.get(i).pos.i][J].tipo = 0;
          }
          // Checking above
          if (map[p1bombs.get(i).pos.i][p1bombs.get(i).pos.j - 1].tipo != 2) {
            image(explosionImg, 42 * p1bombs.get(i).pos.i, 42 * J, 42, 42);
            map[p1bombs.get(i).pos.i][J].tipo = 0;
          }
        }
      }

      // Remove bomb
      if(p1bomb == 1){
        p1bombs.remove(i);
        p1bomb = 0;
      }
    }
  }

  // Starts for loop for player 2 bomb
  for(int i = p2bombs.size()-1; i >= 0; --i ){
    // Shows bomb on map
    p2bombs.get(i).plot();
    // If bomb explodes
    if( p2bombs.get(i).explode() ){
      // If bomb hits player 1 in y position
      if( p1.i == p2bombs.get(i).pos.i &&
          abs( p1.j - p2bombs.get(i).pos.j ) <= 3 ){
            player1life--;
            if (player1life == 0){
              player1life = 3;
              player2score++;
              p1 = new Index( 1, 1 );
              p2 = new Index( 17, 17 );
              if(p1bomb == 1){
                p1bombs.remove(i);
                p1bomb = 0;
              }
              makeMap(); 
            }
            println("p1:" + player1score + "-" + "p2:" + player2score);
      }
      // If bomb hits player 1 in x position
      else if( p1.j == p2bombs.get(i).pos.j &&
          abs( p1.i - p2bombs.get(i).pos.i ) <= 3 ){
            player1life--;
            if (player1life == 0) {
              player1life = 3;
              player2score++;
              p1 = new Index( 1, 1 );
              p2 = new Index( 17, 17 );
              makeMap();
              if(p1bomb == 1){
                p1bombs.remove(i);
                p1bomb = 0;
              }
            }
            println("p1:" + player1score + "-" + "p2:" + player2score);
      }
      // If bomb hits player 2 in y position
      if( p2.i == p2bombs.get(i).pos.i &&
          abs( p2.j - p2bombs.get(i).pos.j ) <= 3 ){
            player2life--;
            if (player2life == 0) {
              player2life = 3;
              player1score++;
              p1 = new Index( 1, 1 );
              p2 = new Index( 17, 17 );
              if(p1bomb == 1){
                p1bombs.remove(i);
                p1bomb = 0;
              }
              makeMap();
            }
            println("p1:" + player1score + "-" + "p2:" + player2score);
      }
      // If bomb hits player 2 in x position
      else if( p2.j == p2bombs.get(i).pos.j &&
          abs( p2.i - p2bombs.get(i).pos.i ) <= 3 ){
            player2life--;
            if (player2life == 0) {
              player2life = 3;
              player1score++;
              p1 = new Index( 1, 1 );
              p2 = new Index( 17, 17 );
              if(p1bomb == 1){
                p1bombs.remove(i);
                p1bomb = 0;
              }
              makeMap();
            }
            println("p1:" + player1score + "-" + "p2:" + player2score);
      }
      
      // Removing barrels and setting path instead in x position
      for (int index = -3; index < 4; index++) {

        // Setting I to bomb x position + index
        int I = p2bombs.get(i).pos.i + index;

        if (index == 0) {
          continue;
        }

        // Checking if x position is not outside the map
        if (I < 0 || I > map.length - 1) {
          continue;
        }

        // If x position is a path
        if (map[I][p2bombs.get(i).pos.j].tipo == 0) {
          // If there is not a wall in the way, explode
          // Checking to the right
          if (map[p2bombs.get(i).pos.i + 1][p2bombs.get(i).pos.j].tipo != 2) {
            image(explosionImg, 42 * I, 42 * p2bombs.get(i).pos.j, 42, 42);
          }
          // Checking to the left
          if (map[p2bombs.get(i).pos.i - 1][p2bombs.get(i).pos.j].tipo != 2) {
            image(explosionImg, 42 * I, 42 * p2bombs.get(i).pos.j, 42, 42);
          }
        }
        // If x position is a barrel
        if (map[I][p2bombs.get(i).pos.j].tipo == 1) {
          // If there is not a wall in the way, remove barrel and set path
          // Checking to the right
          if (map[p2bombs.get(i).pos.i + 1][p2bombs.get(i).pos.j].tipo != 2) {
            image(explosionImg, 42 * I, 42 * p2bombs.get(i).pos.j, 42, 42);
            map[I][p2bombs.get(i).pos.j].tipo = 0;
          }
          // Checking to the left
          if (map[p2bombs.get(i).pos.i - 1][p2bombs.get(i).pos.j].tipo != 2) {
            image(explosionImg, 42 * I, 42 * p2bombs.get(i).pos.j, 42, 42);
            map[I][p2bombs.get(i).pos.j].tipo = 0;
          }
        }
      }

      // Removing barrels and setting path instead in y position
      for (int index = -3; index < 4; index++) {
        // Setting I to bomb y position + index
        int J = p2bombs.get(i).pos.j + index;

        if (index == 0) {
          continue;
        }

        // Checking if x position is not outside the map
        if (J < 0 || J > map.length - 1) {
          continue;
        }
        
        // If y position is a path
        if (map[p2bombs.get(i).pos.i][J].tipo == 0) {
          // Checking below
          if (map[p2bombs.get(i).pos.i][p2bombs.get(i).pos.j + 1].tipo != 2) {
            image(explosionImg, 42 * p2bombs.get(i).pos.i, 42 * J, 42, 42);
          }
          // Checking above
          if (map[p2bombs.get(i).pos.i][p2bombs.get(i).pos.j - 1].tipo != 2) {
            image(explosionImg, 42 * p2bombs.get(i).pos.i, 42 * J, 42, 42);
          }
        }
        // If y position is a barrel
        if (map[p2bombs.get(i).pos.i][J].tipo == 1) {
          // If there is not a wall in the way, remove barrel and set path
          // Checking below
          if (map[p2bombs.get(i).pos.i][p2bombs.get(i).pos.j + 1].tipo != 2) {
            image(explosionImg, 42 * p2bombs.get(i).pos.i, 42 * J, 42, 42);
            map[p2bombs.get(i).pos.i][J].tipo = 0;
          }
          // Checking above
          if (map[p2bombs.get(i).pos.i][p2bombs.get(i).pos.j - 1].tipo != 2) {
            image(explosionImg, 42 * p2bombs.get(i).pos.i, 42 * J, 42, 42);
            map[p2bombs.get(i).pos.i][J].tipo = 0;
          }
        }
      }

      // Remove bomb
      if(p2bomb == 1){
        p2bombs.remove(i);
        p2bomb = 0;
      } 

    }
  }
  
  p1c[0] = false;
  p1c[1] = false;
  p1c[2] = false;
  p1c[3] = false;
  p1c[4] = false;

  p2c[0] = false;
  p2c[1] = false;
  p2c[2] = false;
  p2c[3] = false;
  p2c[4] = false;

  fill(255);
  textSize(15);
  text("Score: Player one: " + player1score + " Player two: " + player2score, 290,25);
  text("Player one life: " + player1life, 20,25);
  text("Player two life: " + player2life, 640,25);
  
}
