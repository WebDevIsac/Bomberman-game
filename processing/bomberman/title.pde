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
    fill(0);
    ellipse( (pos.i + 0.5) * l, (pos.j + 0.5) * l, l, l );
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
    fill(0);
    ellipse( (pos.i + 0.5) * l, (pos.j + 0.5) * l, l, l );
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
     case 0: fill(#1CFF88); break;
     case 1: fill(#FF831C); break;
     case 2: fill(#5A5A5A); break;
   }
   rect(0,0,l,l);
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
