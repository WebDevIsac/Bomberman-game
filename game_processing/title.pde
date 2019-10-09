class P1Bomb{
  Index pos;
  int fusivel;
  P1Bomb( Index p ){
    pos = p.get();
    fusivel = millis() + 3000;
  }
  boolean explodiu(){
    if( millis() > fusivel ) return true;
    else return false;
  }
  void plot(){
    image(bombImg, ((pos.i + 0.5) * l) - 16, ((pos.j + 0.5) * l) - 24, l, l);
  }
}
class P2Bomb{
  Index pos;
  int fusivel;
  P2Bomb( Index p ){
    pos = p.get();
    fusivel = millis() + 3000;
  }
  boolean explodiu(){
    if( millis() > fusivel ) return true;
    else return false;
  }
  void plot(){
    image(bombImg, ((pos.i + 0.5) * l) - 16, ((pos.j + 0.5) * l) - 24, l, l);
  }
}


class Tile{
  int tipo;
  //0: nada, 1: pedra(des) 2:pedra(ind)
  Tile( int t ){
    tipo = t;
  }
  boolean atravessavel(){
    return tipo == 0;
  }
  
  void plot() {
   switch (tipo) {
     case 0: 
      image(pathImg, 0, 0, 45, 45);
      break;
     case 1: 
      image(barrelImg, 0, 0, 45, 42);
      break;
     case 2: 
      image(wallImg, 0, 0, 45, 45);
      break;
   }
  }
}

class Index{
  int i, j;
  Index( int I, int J ){
    i = I;
    j = J;
  }
  Index get(){
    return new Index( i, j );
  }
}
