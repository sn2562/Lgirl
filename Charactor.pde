/* @pjs preload="c_arm_0000.png,c_arm_0001.png,c_arm_0002.png,c_arm_0003.png,c_arm_0004.png,c_arm_0000.png,c_body_0000.png,c_body_0001.png,c_body_0002.png,c_body_0000.png,c_eye_0001.png,c_eye_0002.png,c_eye_0003.png,c_eye_0004.png,c_eye_0005.png,c_eye_0006.png,c_eye_0007.png,c_eye_0000.png,c_face_0000.png,c_face_0001.png,c_face_0002.png,c_hair_0000.png,c_mark_0000.png,c_mark_0001.png,c_mark_0002.png,c_mark_0003.png,c_mark_0004.png,c_mark_0005.png,c_mark_0006.png,c_ribon_0000.png,c_ribon_0001.png"; */
class Charactor {
  PVector pos_man;
  int dir_x;

  boolean changeMotion=true;//他の動作を許さない時はtrue

    //キャラクターポーズ
  Poses poses[];
  int POSE_NUM=6;//読み込むポーズ数
  int LAYER_NUM=7;//レイヤーの数
  //int LAYER_PARAMETER=10;//レイヤーに指定されるパラメータの数
  int posesNum;//現在のポーズの番号
  int[] POSE_SEQUENCE = {
    0, 2, 3
  };
  //posesNum
  /*
  3..sleep
   4...happy
   5...gohan
   */
  //キー入力
  char keyInput='あ';

  //ジャンプ用
  float gravity = 1.5;//重力
  float Yspeed;//上下方向へのスピード
  int jumpCount=2;
  // boolean b_jump;// b_drag;

  boolean harfSize=false;

  float angle;//上下にゆっくり動かすときに使う

  CharaImage charaImage;

  //  //しゃべる用
  //  String[] lines;
  //  Record[] records;
  //  int recordCount;
  //  int num = 1; // Display this many entries on each screen.
  //  int startingEntry = 0;  // Display from this entry number
  //  //ステータス用
  //  float friendly;

  Charactor(String[] lines) {
    //キャラクタの位置
    pos_man = new PVector(0, 0); //キャラクタ原点
    charaTop=new PVector(0, 0); //キャラクタのてっぺん座標
    dir_x = 1; //
    Yspeed = 0;//縦方向の移動速度

    posesNum=0;//デフォルトポーズ

    //キー入力の動き
    //keycode='377';//これはダメ

    //10個のポーズ(7イメージ*9パラメータ)
    poses = new Poses[POSE_NUM];//ひとまず10個posesを生成
    int posesCount=0;

    //ポーズセットを読み込む
    //多分、タブを読み込めないので書き換えが必要
    while (posesCount < poses.length) {//posesCount=読み込んだポーズ数
      poses[posesCount] = new Poses();//ポーズをnewする
      for (int i=0; i<LAYER_NUM; i++) {//7回繰り返す
        String[] pieces = split(lines[LAYER_NUM*posesCount+i+1], ','); //6*posesCount+i行目を読み込む(1行目だけ飛ばすので+1する)
        poses[posesCount].set(i, pieces);//値をセットする
      }
      //poses[posesCount].printData();//読み込んだものの確認
      posesCount++;//poseCountを1増やす
      //読み込んだ行の数(全体)はLAYER_NUM*posesCountで計算できる
    }

    if (posesCount != poses.length) {
      poses = (Poses[]) subset(poses, 0, posesCount);
    }
    charaImage=new CharaImage();
  }


  void run() {
    update(); 
    display();
  }

  void update() {

    float temp;

    temp = pos_man.x + dir_x; 
    if ( temp < 0 || temp > width ) {
      dir_x = - dir_x; 
      temp += 2 * dir_x;
    }

    //通常動作
    charaImage.checRound();//round情報を更新する
    //println("round "+charaImage.round);//roundの表示


    //上下にゆっくり動かす
    //    angle += 0.02;
    //    pos_man.y = sin(angle) * 25;

    pos_man.y+=Yspeed; 

    //時間ごとのモーション

    if (hour()==12||hour()==7||hour()==19) {//ご飯
      changeMotion=true;//
      posesNum=5;
    } else if (0<=hour()&&hour()<=5) {//1時~5時は寝てる
      changeMotion=true;//
      posesNum=3;
    } else {
      changeMotion=false;
    }


    if (!changeMotion) {
      if ((keyInput=='j')||(keyInput==' ')) {//jumpCount回ジャンプする
        posesNum=1;//ポーズをジャンプポーズに設定
        if (jumpCount==0) {//ジャンプ終了後
          pos_man.y=0;//位置を地面の上に戻す
          Yspeed=0;//スピードを0にする
          //if (charaImage.round==3) {//ジャンプ後に表示を3週したら
          changeMotion=false;//他の動きができるように開放
          reset();//リセットする
          //}
        } else if (pos_man.y<0) {//ジャンプ中
          Yspeed+=gravity;
        } else if (pos_man.y>0) {//キャラクターの足が地面についたら
          Yspeed=-9;//スピードを-9にして上にジャンプを開始する
          jumpCount--;//のこりのジャンプ回数をリセットする
        }
      }
    }
  }

  void dragged(String s) {//ドラッグ入力 
    //println(changeMotion);//ここ
    if (!changeMotion) {
      println("判定開始");
      if (s.equals("other")) {
        println("なでこなでこ");
        posesNum=4;//にこにこ
      } else if (s.equals("up")) {
        println("うえにひっぱる");
      }else{
      println("判定できなかった");
      }
    } //else println("ちょっとまってね！");
  }

  void keytap(char c) {//キー入力
    if (!changeMotion) {
      reset();//change前にリセットする
      keyInput=c;
      switch(c) {
      case 'j'://ジャンプ
      case ' '://スペースキーもジャンプ
        Yspeed=-9; //スピード
        jumpCount=2; //ジャンプ回数
        changeMotion=false;//キー入力のモーションを行っている間は他のモーションに変更できない
        break;
      default:
        break;
      }
    } //else println("ちょっとまってね！");
  }

  void reset() {
    //charaImage.round=0;
    charaImage.reset();
    posesNum=0;

    keyInput='あ';
  }


  void display() {
    pushMatrix(); //1/2
    //if (AnimatedSprite.charaScale) { //1/2スケールの設定
    // scale(0.5); 
    // charaTop.set(width-(charaImage.c_body.getWidth0()/2), height*2-charaImage.c_body.getHeight0()); //中央揃え
    //} else {
    //   charaTop.set(width/2-charaImage.c_body.getWidth0()/2, height-charaImage.c_body.getHeight0());
    //}
    //  translate(charaTop.x, charaTop.y); //中央揃え

    translate(width/2-0-charaImage.c_body.getWidth0()/2,height-charaImage.c_body.getHeight0());
    translate(pos_man.x, pos_man.y);//キャラクターの上下左右移動
    //AnimatedSprite.charaTop.set(charaTop.x, height-charaImage.c_body.getHeight());

    
    //キャラクターの表示
    //ribon
    charaImage.c_ribon.show(poses[posesNum].ribon);

    //hair
    charaImage.c_hair.show(poses[posesNum].hair);

    //body
    charaImage.c_body.show(poses[posesNum].body);

    //face
    charaImage.c_face.show(poses[posesNum].face);

    //eye
    charaImage.c_eye.show(poses[posesNum].eye);

    //arm
    charaImage.c_arm.show(poses[posesNum].arm);

    //mark
    charaImage.c_mark.show(poses[posesNum].mark);

    popMatrix(); //1/2scale
  }
}


class CharaImage {
  Animation c_eye, c_face, c_arm, c_body, c_hair, c_ribon, c_mark; 
  int charaCenter; 
  int round;//ポーズの繰り返し回数
  boolean changeRound;//roundが切り替わったかどうか

  public CharaImage() {
    round=0;

    //フレーム数の指定
    int EYE=8; 
    int FACE=3; 
    int ARM=5; 
    int BODY=3; 
    int HAIR=1; 
    int RIBON=2; 
    int MARK=7; 

    //charaCenter=200; 

    //読み込む画像名とフレーム数
    c_eye = new Animation("c_eye_", EYE); 
    c_face = new Animation("c_face_", FACE); //画像名,フレーム数
    c_arm = new Animation("c_arm_", ARM); //画像名,フレーム数
    c_body = new Animation("c_body_", BODY); //画像名,フレーム数
    c_hair = new Animation("c_hair_", HAIR); //画像名,フレーム数
    c_ribon = new Animation("c_ribon_", RIBON); //画像名,フレーム数
    c_mark = new Animation("c_mark_", MARK); //画像名,フレーム数
  }

  void reset() {
    round=0;
    changeRound=false;

    //ポーズを更新する時に最初に呼ぶ
    //println("リセット");
    c_eye.resetFrame();
    c_face.resetFrame();
    c_arm.resetFrame();
    c_face.resetFrame();
    c_body.resetFrame();
    c_hair.resetFrame();
    c_ribon.resetFrame();
    c_mark.resetFrame();
  }

  void checRound() {//アニメーションが何週しているかをチェックする
    changeRound=false;
    int[] check= 
    {
      c_eye.round, 
      c_face.round, 
      c_arm.round, 
      c_face.round, 
      c_body.round, 
      c_hair.round, 
      c_ribon.round, 
      c_mark.round,
    };

    //round=0;//現在のラウンド数
    int j=0;
    for (int i=0; i<check.length; i++) {
      if (check[i]==-1)  j++;//roundが-1のものはroundなしなので考慮しない
      else if (check[i]==round) break;//まだroundに変化のないアニメーションがあるときは検証を中止
      else if (check[i]>round) j++;//すべてのroundが現在保持しているroundよりも大きかった時は、最終的にcheck.lengthになるはず
      else break;
      if (j==check.length) {
        round++;
        changeRound=true;
        j=0;
      }
    }
  }
}

