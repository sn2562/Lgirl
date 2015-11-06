var today;
var mode;//0...通常 1...寝てる 2...ご飯
var diaryTextArray,nameArray,nomaldoArray,specialdoArray;
var itemArray;
/*--onload-------------------------------------------------------------------------------------------------------------------------------*/
onload = function() {
	console.log("onload");
	var date=new Date();
	var h = date.getHours();
	mode=0;
	console.log("h "+h);
	if(0<=h&&h<=5){//寝てる
		mode=2;
	}else if(h==10||h==7||h==19){//ご飯
		mode=1;
	}
	today = new Date();
	load();


	nomaldoArray=[
		'とあそんだ。','とあそんだ。','とあそんだ。','とあそんだ。',
		'のところへいった。','のところへいった。','のところへいった。','のところへいった。','のところへいった。','のところへいった。','のところへいった。','のところへいった。','のところへいった。','のところへいった。',
		'はいなかった。',
		'とまいごになった',
		'とおやつを食べた'

	];
};

/*--load data-------------------------------------------------------------------------------------------------------------------------------*/
var load = function(){
	$.ajax({
		url:'contents/chat.txt',
		success: function(data){
			diaryTextArray = data.split(/\r\n|\r|\n/);  // 改行コードで分割
			//			var len = diaryTextArray.length;
			//			for (var i = 0; i < len; i++){
			//				console.log(diaryTextArray[i]);
			//			}
		}
	});
	$.ajax({
		url:'contents/name.txt',
		success: function(data){
			nameArray = data.split(/\r\n|\r|\n/);  // 改行コードで分割
			//			var len = nameArray.length;
			//			for (var i = 0; i < len; i++){
			//				console.log(diaryTextArray[i]);
			//			}
		}
	});
	$.ajax({
		url:'contents/do.txt',
		success: function(data){
			specialdoArray = data.split(/\r\n|\r|\n/);  // 改行コードで分割
			//			var len = nameArray.length;
			//			for (var i = 0; i < len; i++){
			//				console.log(diaryTextArray[i]);
			//			}
		}
	});
	$.ajax({
		url:'contents/item.txt',
		success: function(data){
			itemArray = data.split(/\r\n|\r|\n/);  // 改行コードで分割
			//			var len = nameArray.length;
			//			for (var i = 0; i < len; i++){
			//				console.log(diaryTextArray[i]);
			//			}
		}
	});
	//	document.getElementById("diary").innerHTML = text_array[0];

}
/*--アニメーション-------------------------------------------------------------------------------------------------------------------------------*/
var itemFadeOutAnimation = function(){
	$('.getitem').animate({
		opacity: 0.0,    // 透明度1へ
	}, 1000, function() {
		// アニメーション完了後に実行する処理
	});
}
var detailFadeInAnimation = function(){
	$('#fadeInBox').animate({
		opacity: 1.0,    // 透明度1へ
	}, 500, function() {
		$('button').css('pointer-events',"auto");
	});
}
var detailFadeOutAnimation = function(){
	$('#fadeInBox').animate({
		opacity: 0.0,    // 透明度1へ
	}, 500, function() {
	});
}
var nomalMode = function(){
	runProcessingCode();
	var itemOrDiary = Math.floor(Math.random()*5);
//	itemOrDiary=0;
	var randnum,balloonHtml,detailImageSrc,detailNameHtml,detailHtml;
	if(itemOrDiary!=0){
		//itemの表示
		var textId = Math.floor(Math.random()*13);
		randnum = Math.floor(Math.random()*128);
		detailImageSrc = 'item/'+randnum+'.gif';
		balloonHtml = '<img src="'+detailImageSrc+'"><p>item get!</p>';
		detailNameHtml =  set2fig(randnum)+' '+itemArray[randnum];
		//		detailHtml = 'detail,detail,detail,detail,detail,detail,detail,detail,detail,detail,detail,detail,detail,detail,';
		detailHtml='';
	}else{
		//日記の表示
		//		var y = today.getFullYear();
		var date = (today.getMonth()+1)+'がつ'+today.getDate()+'にち';
		var nameNumber = Math.floor(Math.random()*nameArray.length);
		var length = nomaldoArray.length+specialdoArray.length;
		var doNumber = Math.floor(Math.random()*length);
		var name;
		if(doNumber<nomaldoArray.length){
			name = nameArray[nameNumber]+nomaldoArray[doNumber];	
		}else{
			name = nameArray[nameNumber]+'と'+specialdoArray[doNumber-nomaldoArray.length]+'した。';
		}

		var diaryNumber = Math.floor(Math.random()*diaryTextArray.length);

		randnum=-1;
		detailImageSrc = 'item/book.gif';
		balloonHtml = '<img src="item/book.gif"><p>ひみつ日記</p>';
		detailNameHtml = '';
		detailHtml = date+'<br>';
		console.log(nameArray.length+' '+nameNumber);
		detailHtml = detailHtml + name+'<br>';
		//		diaryNumber=256;
		detailHtml = detailHtml + diaryTextArray[diaryNumber];
	}
	document.getElementById("balloon-1-bottom").innerHTML = balloonHtml;
	document.getElementById("itemDetailImage").src = detailImageSrc;
	document.getElementById("itemDetailName").innerHTML = detailNameHtml;
	document.getElementById("itemDetail").innerHTML = detailHtml;
	var html2 = '';
}
var lunchMode = function(){
	document.getElementById("balloon-1-bottom").innerHTML = 'yummy!';
	document.getElementById("fadeInBox").innerHTML = '...';

}
var sleepMode = function(){
	document.getElementById("balloon-1-bottom").innerHTML = 'zzz...';
	document.getElementById("fadeInBox").innerHTML = '...';
}
/*--イベントリスナとクリックイベント-------------------------------------------------------------------------------------------------------------------------------*/

$(function() {
	//	$(document).on('click', 'button', function(){
	//		console.log("ボタンのクリック");
	//		//		$( "canvas" ).trigger( "click" );
	//
	//	});
	//	$('canvas').click( function(event){
	//	});
});

var newItem = function(){
	//リセット
	$('.getitem').css('top',"-400px");
	$('.getitem').css('opacity',"0.0");
	$('button').css('pointer-events',"none");

	$('.getitem').animate({
		opacity: 1.0,    // 透明度1へ
		top: '-=50',     // 現在位置から50px移動
	}, 1000, function() {
		// アニメーション完了後に実行する処理
		
		itemFadeOutAnimation();
		detailFadeInAnimation();
	});
//	console.log("mode "+mode);
	//説明書き
	$('#fadeInBox').css('opacity',"0.0");
	switch(mode) {
		case 0:
			nomalMode();
			break;
		case 1:
			lunchMode();
			break;
		case 2:
			sleepMode();
			break;
		default:
	}
}
/*--processing-------------------------------------------------------------------------------------------------------------------------------*/
function runProcessingCode() {
	// run Processing code
	var pjs = Processing.getInstanceById('proceCanvas');
	pjs.jsMouseReleased();
}

/*--便利機能-------------------------------------------------------------------------------------------------------------------------------*/

function set2fig(num) {	// 桁数が3桁未満なら先頭に0を加えて調整する
	var ret;
	if( num < 100 ){
		ret = "0" + num;
		if(num < 10)
			ret = "0" + ret;
	}
	else
		ret = num;
	return ret;
}
