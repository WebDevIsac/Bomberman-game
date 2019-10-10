
// Moving for player 1 with gyrometer
void movePlayer1(String p1ValString){
  if (p1ValString.contains("P1UP")) {
    p1c[0] = true;
    // delay(50);
  }
  else if (p1ValString.contains("P1DOWN")) {
    p1c[1] = true;
    // delay(50);
  }
  else if (p1ValString.contains("P1LEFT")) {
    p1c[2] = true;
    // delay(50);
  }
  else if (p1ValString.contains("P1RIGHT")) {
    p1c[3] = true;
    // delay(50);
  }
  
  if (p1ValString.contains("P1BOMB")) {
    p1c[4] = true;
    // delay(50);
  }
}

// Moving for player 2 with gyrometer
void movePlayer2(String p2ValString){
  if (p2ValString.contains("P2UP")) {
    p2c[0] = true;
    // delay(50);
  }
  else if (p2ValString.contains("P2DOWN")) {
    p2c[1] = true;
    // delay(50);
  }
  else if (p2ValString.contains("P2LEFT")) {
    p2c[2] = true;
    // delay(50);
  }
  else if (p2ValString.contains("P2RIGHT")) {
    p2c[3] = true;
    // delay(50);
  }
  
  if (p2ValString.contains("P2BOMB")) {
    p2c[4] = true;
    // delay(50);
  }
}

// Testing with keyboard
// void keyPressed(){
//   switch( key ){
//     case 'w':
//       p1c[0] = true;
//       break;
//     case 's':
//       p1c[1] = true;
//       break;
//     case 'a':
//       p1c[2] = true;
//       break;
//     case 'd':
//       p1c[3] = true;
//       break;
//     case 'c':
//       p1c[4] = true;
//       break;
//     case '.':
//      p2c[4] = true;
//      break;
//   } 

//   if (keyCode == UP) p2c[0] = true;
//   if (keyCode == DOWN) p2c[1] = true;
//   if (keyCode == LEFT) p2c[2] = true;
//   if (keyCode == RIGHT) p2c[3] = true;
// }

// void keyReleased(){
//   switch( key ){
//     case 'w':
//       p1c[0] = false;
//       break;
//     case 's':
//       p1c[1] = false;
//       break;
//     case 'a':
//       p1c[2] = false;
//       break;
//     case 'd':
//       p1c[3] = false;
//       break;
//     case 'c':
//       p1c[4] = false;
//       break;
//     case '.':
//       p2c[4] = false;
//       break;
//   }
  
//     if (keyCode == UP) p2c[0] = false;
//     if (keyCode == DOWN) p2c[1] = false;
//     if (keyCode == LEFT) p2c[2] = false;
//     if (keyCode == RIGHT) p2c[3] = false;
  
// }
 
