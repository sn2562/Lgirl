class Poses {
  int posesSet;//ポーズの数
  CharaSet mark, eye, face, arm, body, hair, ribon;

  public Poses() {//文字列を受け取る

    mark=new CharaSet();
    eye=new CharaSet();
    face=new CharaSet();
    arm=new CharaSet();
    body=new CharaSet();
    hair=new CharaSet();
    ribon=new CharaSet();
  }

  public void set(int i, String[] line) {
    switch(i) {
    case 0:
      ribon.set(line);
      break;
    case 5:
      eye.set(line);
      break;
    case 4:
      face.set(line);
      break;
    case 3:
      arm.set(line);
      break;
    case 2:
      body.set(line);
      break;
    case 1:
      hair.set(line);
      break;
    case 6:
      mark.set(line);
      break;
    default:
      println("oh");
      break;
    }
  }
  void printData() {
    println("ribon");
    ribon.printData();
    println("eye");
    eye.printData();
    println("face");
    face.printData();
    println("arm");
    arm.printData();
    println("body");
    body.printData();
    println("hair");
    hair.printData();
    println("mark");
    mark.printData();
  }
}


class CharaSet {
  //String Posename;//ポーズ名
  String pose, name, mode;//ポーズ名,アニメーションモード
  float xpos, ypos;//x,y座標
  int framelate;//フレームレート
  int delay;//次のアニメーション開始までの待ち時間
  int setFrame;//指定された一枚のフレーム
  int start;//開始フレーム
  int end;//終了フレーム

  public CharaSet() {
    pose=name=mode="NoMode";
    xpos=ypos=framelate=delay=setFrame=start=end=0;
    //しょきか
  }

  public void set(String[] pieces) {
    pose = pieces[0];
    name = pieces[1];
    mode = pieces[2];
    xpos = int(pieces[3]);
    ypos = int(pieces[4]);
    framelate = int(pieces[5]);
    delay = int(pieces[6]);
    setFrame = int(pieces[7]);
    start = int(pieces[8]);
    end = int(pieces[9]);
  }

  void printData() {
    print(" pose: "+pose);
    print(" name: "+name);
    print(" mode: "+mode);
    print(" xpos: "+xpos);
    print(" ypos: "+ypos);
    print(" framelate: "+framelate);
    print(" delay: "+delay);
    println(" end: "+end);
  }
}

