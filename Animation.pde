//以下の行を追加することで、画像の読み込みを可能にする
// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  int round;//くりかえした数
  int imageH, imageW;
  Animation(String imagePrefix, int count) {
    //println("class Animation");
    imageCount = count;
    images = new PImage[imageCount];
    round=0;
    imageH=imageW=0;

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 4) + ".png";
      images[i] = loadImage(filename);
    }
  }
  //表示の振り分け
  //void show(String mode, float posx, float posy, int framelate, int delay, int setFrame, int start, int end) {
  void show(CharaSet c) {

    //println("c.mode="+c.mode);

    if (c.mode.equals("display")) {
      display(c.xpos, c.ypos, c.framelate, c.delay); //流しで表示する
      imageH=images[0].height;
      imageW=images[0].width;
    } else if (c.mode.equals("displayFrame")) {
      round=-1;//roundなし
      displayFrame(c.xpos, c.ypos, c.setFrame);//フレーム固定で表示
      imageH=images[c.setFrame].height;
      imageW=images[c.setFrame].width;
    } else if (c.mode.equals("displayRange")) {
      displayRange(c.xpos, c.ypos, c.framelate, c.delay, c.start, c.end);//連番で指定してstartからendまで表示する
      imageH=images[c.start].height;
      imageW=images[c.start].width;
    } else if (c.mode.equals("nodisplay")) {
      //println("nodisplay");
      imageH=0;
      imageW=0;
      round=-1;//roundなし
    } else {
      println("oh");
      round=1;
      imageH=0;
      imageW=0;
    }

    //println("animation show end");
    //println("no such a mode "+c.mode);
  }

  void display(float xpos, float ypos, int count, int delay) {//流しで表示する
    //countおきにフレームを更新する
    //最後のフレームまで行ったらdelay分だけフレームをポーズする

    frame = frame+1;//
    int frameset;//

    if (count!=0) frameset=(frame-1)/count;//フレームレートの設定.countで1ずつ増えるようにする.
    else frameset=0;

    frameset=int(frameset);//整数になおす
   // println("frameset"+int(frameset));

    frameset=(frameset) % (imageCount+int(delay/count));
    if (frameset<images.length) image(images[frameset], xpos, ypos);//イメージの範囲で繰り返す
    else image(images[images.length-1], xpos, ypos); //ディレイ分のフレームは一番最後の画像で埋める

    int roundframe=int(count*1*images.length+int(delay/count));
    if (frame%roundframe==0) round++;
  }

  void displayFrame( float xpos, float ypos, int frameNum) {//1フレームだけ表示する
    frame = frame+1;//
    if (frameNum<images.length)
      image(images[frameNum], xpos, ypos);
    //if (frame%60==0) round++;//60回表示したら一週したとして、roundを+1する
  }

  void displayRange( float xpos, float ypos, int count, int delay, int start, int end) {//連番で指定してstartからendまで表示する
    //countおきにフレームを更新する
    //最後のフレームまで行ったらdelay分だけフレームをポーズする
    frame = frame+1;//
    int frameset;//

    if (count!=0) frameset=(frame-1)/count;//フレームレートの設定.countで1ずつ増えるようにする.
    else frameset=0;

    frameset=(frameset) % ((end-start+1)+int(delay/count));
    // println("rangeframeset"+frameset);
    if (frameset+start<end) image(images[int(frameset)+start], xpos, ypos);//イメージの範囲を超えたら最初のフレームで留めておく
    else image(images[end], xpos, ypos); //ディレイ分のフレームは一番最後の画像で埋める

    int roundframe=int(count*1*(end-start+1)+int(delay/count));
    if (frame%roundframe==0) round++;
  }

  int getHeight() {
    return imageH;
  }
  int getWidth() {
    return imageW;
  }

  int getHeight0() {
    return images[0].height;
  }
  int getWidth0() {
    return images[0].width;
  }

  void resetFrame() {
    //ポーズ変更などを行う時はまずこれをやる
    frame=0;
    round=0;
  }

  String nowRound() {
    return str(round);
  }
}

