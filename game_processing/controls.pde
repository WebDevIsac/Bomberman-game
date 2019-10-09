
// Moving for player 1 with gyrometer
void moveChar(String valString){
  if (valString.contains("UP")) {
    p1c[0] = true;
    delay(50);
  }
  else if (valString.contains("DOWN")) {
    p1c[1] = true;
    delay(50);
  }
  else if (valString.contains("LEFT")) {
    p1c[2] = true;
    delay(50);
  }
  else if (valString.contains("RIGHT")) {
    p1c[3] = true;
    delay(50);
  }
  
  if (valString.contains("BOMB")) {
    p1c[4] = true;
    delay(50);
  }
}

// Testing with keyboard
void keyPressed(){
  switch( key ){
    case 'w':
      p1c[0] = true;
      break;
    case 's':
      p1c[1] = true;
      break;
    case 'a':
      p1c[2] = true;
      break;
    case 'd':
      p1c[3] = true;
      break;
    case 'c':
      p1c[4] = true;
      break;
    case '.':
     p2c[4] = true;
     break;
  } 

  if (keyCode == UP) p2c[0] = true;
  if (keyCode == DOWN) p2c[1] = true;
  if (keyCode == LEFT) p2c[2] = true;
  if (keyCode == RIGHT) p2c[3] = true;
}

void keyReleased(){
  switch( key ){
    case 'w':
      p1c[0] = false;
      break;
    case 's':
      p1c[1] = false;
      break;
    case 'a':
      p1c[2] = false;
      break;
    case 'd':
      p1c[3] = false;
      break;
    case 'c':
      p1c[4] = false;
      break;
    case '.':
      p2c[4] = false;
      break;
  }
  
    if (keyCode == UP) p2c[0] = false;
    if (keyCode == DOWN) p2c[1] = false;
    if (keyCode == LEFT) p2c[2] = false;
    if (keyCode == RIGHT) p2c[3] = false;
  
}
 
