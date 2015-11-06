Charactor chara1;
//UiBar uibar;
//PFont body;
/* @pjs preload="bg.jpg"; */

static boolean charaScale=false;// 1/2設定
PImage img;//背景画像

//マウスジェスチャ判定用
ArrayList<PVector> mousesVector;//マウスの方向ベクトルたち

//しゃべる用
String[] lines;

static PVector charaTop;//キャラクターのてっぺん座標

void setup() {
  //画面サイズ
  size(300, 500);
  //ジェスチャ判定
  mousesVector=new ArrayList<PVector>();//マウスの方向ベクトル

  //背景,フレームレート
  //background(255, 204, 0);
  frameRate(24);
  img = loadImage("bg.jpg");//背景画像
  //フォント読み込み
  //body = loadFont("TheSans-Plain-12.vlw");
  //body = loadFont("AppleGothic-12.vlw");
  //textFont(body);

  //キャラクタのてっぺん座標
  charaTop=new PVector(0, 0);

  //設定の読み込み
  //uibar=new UiBar(loadStrings("charactor.tsv"));//キャラクター設定の読み込み
  chara1 = new Charactor(loadStrings("pose_set.tsv"));//ポーズ設定の読み込み
  //表示サイズ
  //uibar.tc2.harfmode=charaScale;
}


void draw() { 

  // Display the sprite at the position xpos, ypos
  if (mousePressed) {
    //background(153, 153, 0);
    background(204, 204, 204);
  } else {
    //background(204, 204, 204);
    //background(255);

    image(img, 0, 0);
  }
  background(255);
  chara1.run();
  //uibar.run();
}



void keyPressed() {
  chara1.keytap(char(key));
  //prntln(key);
  if ( key == ' ' ) {
  } else if ( key == 's' ) {
    //chara1.style();
  } else if ( key == 't' ) {
    //chara1.keytap(char(key));
  } else if (key==ESC) {//終了
    //終了
    //uibar.saveRecord();
    exit();
  }
}

void jsMouseReleased() {
  chara1.keytap('j');
}

void mousePressed() {
}

void mouseDragged() {

  //ジェスチャ判定用
  if (mousesVector.size()<50) {//保存するマウスのベクトル数
    PVector v=new PVector(mouseX-pmouseX, mouseY-pmouseY);
    mousesVector.add(v.normalize(v));//マウスの方向ベクトル
  }

  if (mousesVector.size()>5) {//ドラッグを続けていたら判定する
    //println("ジェスチャ名"+gesture(mousesVector));
    //chara1.dragged(gesture(mousesVector));
  } else {//最初はスタンバイ状態にしておく
    //chara1.dragged("standby");
  }
}

void mouseReleased() {
  if (mousesVector.size()>0 && !chara1.changeMotion) {//ドラッグ中だったなら
    mousesVector.clear();//ジェスチャ判定の初期化
    chara1.reset();//マウスジェスチャが終わったらキャラクターの初期化をする
  }
  jsMouseReleased();
}



//進んでいる方向(直線判定)を行う
String gesture(ArrayList<PVector> mouses) {
  println("判定");
  PVector vAverage=new PVector(0, 0);//平均
  PVector vVariance=new PVector(0, 0);//分散
  int gudgeNum=mouses.size();//判定に使用する範囲

  println("test1");
  //もし,ドラッグ数が充分(15以上)の時は,最初に直線運動の判定があった時に固定してotherには変更しないようにする
  //if (mouses.size()>100) gudgeNum=100;

  println("gudgeNum "+gudgeNum);
  //平均

  int i=0;
  while (i<gudgeNum) {
    println("i "+i);
    println("マウス値 "+str(mouses.get(0).x));
    i++;
  }

  int j=0;
  while (j<gudgeNum) {//mouses内のすべての要素を足して平均を出す

    vAverage.x=vAverage.x + mouses.get(j).x;
    vAverage.y=vAverage.y + mouses.get(j).y;
    println("j "+j);
    j++;
  }

  println("test2");

  vAverage.x=vAverage.x/gudgeNum;//平均
  vAverage.y=vAverage.y/gudgeNum;//平均
  println("平均 "+vAverage);

  //分散
  int k=0;
  while (k<gudgeNum) {
    vVariance.x=vVariance.x+sq(mouses.get(k).x-vAverage.x);//分散
    vVariance.y=vVariance.y+sq(mouses.get(k).y-vAverage.y);//分散
    println("k "+k);
    k++;
  }

  //直線運動(傾きが一致している)であるほど小さくなる 0.1か0.05より小さい
  //円運動などの場合はx,yの値がどちらもm+-0.1くらいに収まる
  vVariance.x=vVariance.x/gudgeNum;
  vVariance.y=vVariance.y/gudgeNum;
  println("分散 "+vVariance);


  if (vVariance.x<0.05 && vVariance.y<0.05) {//直線運動
    float x=vAverage.x;
    float y=vAverage.y;

    float allowMisAngle=20;//容認誤差(角度)
    //下
    if (abs(x)<=cos(radians(90-allowMisAngle)) && y>=sin(radians(90-allowMisAngle))) return "down";
    //上
    else if (abs(x)<=cos(radians(90-allowMisAngle)) && y<=sin(radians(90-allowMisAngle))) return "up";
    //右
    else if (x>=cos(radians(allowMisAngle)) && abs(y)<=sin(radians(allowMisAngle))) return "right";
    //左
    else if (x<=cos(radians(allowMisAngle)) && abs(y)<=sin(radians(allowMisAngle))) return "left";

    //左上
    if (x<=0 && y<=0) return "upper left";
    //2 右上
    else if (x>=0 && y<=0) return "upper right";
    //3 左下
    else if (x<=0 && y>=0) return "lower left";
    //4　右下
    else if (x>=0 && y>=0) return "lower right";
  } else if (vVariance.x<0.5 || vVariance.y<0.5) {//直線運動以外
    return "other";
  }
  return "no gesture";//念のため
}

