import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;
import controlP5.*;

int zeit;
int punkte;
int leben;
int schwierigkeit = 20;
int zustand = 1;
int boost = 0;
int highscore = 0;
int minuten = 0;

int changeLevel = 0;
boolean paused = true;
boolean gameOver;
JSONArray saves = new JSONArray();
		
PFont gameOverFont;
PFont gameOverFontSmall;

CountdownTimer timer1 = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 60000);
CountdownTimer kryptonitAnimationTimer1 = CountdownTimerService.getNewCountdownTimer(this).configure(10, 250);

boolean[] keysPressed = new boolean[65536];
ControlP5 cp5;

Star[] stars;
Kryptonit[] kryptonit;
Raumschiff raumschiff;

Player[] players;

String textValue = "";

PImage cirnoTexture;
PImage rockTexture;


void settings()
{
	//size(800, 400, P2D);
	fullScreen(P3D);
	smooth(8);
	System.setProperty("jogl.disable.openglcore", "true");
}

void setup() {
  surface.setResizable(true);
  
  println("loading textures");
  cirnoTexture = loadImage("project-cirno-fumo-3d-scan/textures/cirno_low_u1_v1.jpeg");
  rockTexture = loadImage("rockTexture.png");
  println("finished loading textures: " + cirnoTexture);
  
	stars = new Star[0];
	kryptonit = new Kryptonit[0];
	raumschiff = new Raumschiff(width/2, height/4*3);
	leben = 5;
	gameOverFont = createFont("Arial", 36, true);
	gameOverFontSmall = createFont("Arial", 16, true);
	for (int i = 0; i < schwierigkeit; i++) {
		stars = (Star[]) append(stars, new Star(int(random(50, width-150)), int(random(50, height-100)), int(random(5, 15))));
	}

	players = new Player[0];

	cp5 = new ControlP5(this);

	cp5.addTextfield("Name")
		.setPosition(width/2-100, height/3*2-20)
		.setSize(200, 40)
		.setFont(gameOverFontSmall)
		.setFocus(false)
		.setColor(color(255))
		.setAutoClear(false)
		.setText("Name")
		.setLabel("")
		.hide()
		.lock()
		;

  
   //<>//
}

void draw() {
	background(0);
  lights();
	switch (zustand) {
		case 0:
		break;
		case 1:
			fill(255);
			text("Zeit:\t" + minuten + ":" + zeit, width-100, 50);
			text("Punkte:\t" + punkte, width-100 , 100);
			text("Leben:\t" + leben, width-100, 150);
			text("Highscore:\t" + highscore, width-100, 200);
			text("schwierigkeit:\t" + schwierigkeit, width-100, 250);
			try {
				for (int i = 0; i < players.length; i++) {
					text(players[i].getName() + "   " + players[i].getScore(), width-100, 300+15*i);
				}
				for (int i = 0; i < stars.length; i++) {
					stars[i].zeichnen();
          stars[i].drehen(random(0, 0.05), random(0, 0.05), random(0, 0.05));
				}
				for (int i = 0; i < kryptonit.length; i++) {
					kryptonit[i].zeichnen();
				}
				if (kryptonitAnimationTimer1.getTimeLeftUntilFinish() != .0f) {
					raumschiff.zeichnen(color(350-kryptonitAnimationTimer1.getTimeLeftUntilFinish(), 100, 100));
				} else {
					raumschiff.zeichnen(color(100, 100, 100));
				}
			} catch (Exception e) { e.printStackTrace(); }
			noFill();
			stroke(100);
			rect(50, 50, width-200, height-150);
			fill(0);
			noStroke();
			rect(0, 0, width-150, 48);
			if (gameOver) {
				push();
				fill(255);
				textAlign(CENTER, CENTER);
				textFont(gameOverFont, 36);
				textSize(34);
				text("GAME OVER!", width/2, height/2);
				textFont(gameOverFontSmall, 16);
				textSize(16);
				text("Press ENTER to resume", width/2, height/2+30);
				cp5.get(Textfield.class, "Name").unlock();
				cp5.get(Textfield.class, "Name").show();
				pop();
			}
			else if (paused) {
				push();
				fill(255);
				textAlign(CENTER, CENTER);
				textFont(gameOverFont, 36);
				textSize(34);
				text("PAUSED!", width/2, height/2);
				textFont(gameOverFontSmall, 16);
				textSize(16);
				text("PRESS ANY KEY TO RESUME", width/2, height/2+30);
				pop();
			}
		break;
		default :
			background(0);
		break;	
	}


	for (int i = 0; i < stars.length; i++) {
		if (stars[i].isVisible && sqrt((stars[i].posX - raumschiff.posX) * (stars[i].posX - raumschiff.posX) + (stars[i].posY - raumschiff.posY) * (stars[i].posY - raumschiff.posY) ) < 25){
			stars[i].isVisible = false;
			punkte+=stars[i].speed;
			if (changeLevel > 0) {
				changeLevel--;
			}
		}
	}
	if (punkte > highscore) {
		highscore = punkte;
	}
	if (kryptonit.length < schwierigkeit / 5) {
		kryptonit = (Kryptonit[]) append(kryptonit, new Kryptonit(int(random(50, width-150)), int(random(-300, 0))));
	}
	if (stars.length < schwierigkeit) {
		stars = (Star[]) append(stars, new Star(int(random(50, width-150)), int(random(-300, 0)), int(random(5, 15))));
	}
	for (int i = 0; i < kryptonit.length; i++) {
		if (kryptonit[i].isVisible && sqrt((kryptonit[i].posX - raumschiff.posX) * (kryptonit[i].posX - raumschiff.posX) + (kryptonit[i].posY - raumschiff.posY) * (kryptonit[i].posY - raumschiff.posY) ) < 25){
			kryptonit[i].isVisible = false;
			leben-=1;
			kryptonitAnimationTimer1.start();
		}
	}
	if (leben < 1){
		gameOver = true;
	}

	if (punkte % 500 <= 20 && punkte % 500 >= 0 && changeLevel == 0 && zustand == 1) {
		schwierigkeit+=5;
		changeLevel = 5;
	}
	if (punkte % 500 > 20) {
		changeLevel = 0;
	}



	if (!paused) {
		try {
			if (!gameOver) {
				for (int i = 0; i < stars.length; i++) {
					stars[i].bewegen(schwierigkeit/stars[i].speed+boost);
					if (stars[i].posY > height-100){
						stars[i] = null;
						stars[i] = new Star(int(random(58, width-202)), int(random(-300, 0)), int(random(5, 15)));
					}
				}
				for (int i = 0; i < kryptonit.length; i++){
					kryptonit[i].bewegen(schwierigkeit/10+boost);
					if (kryptonit[i].posY > height-100){
						kryptonit[i] = null;
						kryptonit[i] = new Kryptonit(int(random(58, width-202)), int(random(-300, 0)));
					}
				}
			}
		} catch (Exception e) { e.printStackTrace(); }
	}

	if (keysPressed[56]){
		boost = 5;
	}
	else {
		boost = 0;
	}
	if (keysPressed[52] && !gameOver && !paused){
		try {
			raumschiff.bewegen(-7);
			if (keysPressed[32]) {
				raumschiff.bewegen(-10);
			}
		} catch (Exception e) { e.printStackTrace(); }
	}
	if (keysPressed[54] && !gameOver && !paused){
		try {
			raumschiff.bewegen(7);
			if (keysPressed[32]) {
				raumschiff.bewegen(10);
			}
		} catch (Exception e) { e.printStackTrace(); }
	}
}


void keyPressed() {
	if (gameOver && key == ENTER) {
		players = (Player[]) append(players, new Player(cp5.get(Textfield.class, "Name").getText(), punkte));
		cp5.get(Textfield.class, "Name").lock();
		cp5.get(Textfield.class, "Name").hide();
		for (int i = 0; i < saves.size(); i++) {
			JSONObject playerJSONObject = new JSONObject();
			playerJSONObject.setInt("id", i);
			playerJSONObject.setString(cp5.get("Name", cp5.get(Textfield.class, "Name").getText()).toString(), "");
			playerJSONObject.setInt("score", punkte);
		}
		saveJSONArray(saves, "data/highscores.json");

		schwierigkeit = 20;
		paused = true;
		gameOver = false;
		leben = 5;
		punkte = 0;
		timer1.reset(CountdownTimer.StopBehavior.STOP_IMMEDIATELY);
		timer1.start();
		zeit = 0;
		stars = null;
		stars = new Star[0];
		for (int i = 0; i < schwierigkeit; i++) {
			stars = (Star[]) append(stars, new Star(int(random(50, width-150)), int(random(50, height-100)), int(random(5, 15))));
		}
		kryptonit = null;
		kryptonit = new Kryptonit[0];
	}
	keysPressed[key] = true;
}

void keyReleased() {
	keysPressed[key] = false;
}

void keyTyped() {
	if (key == 'p' || key == 'P') {
		if (!gameOver) {
			paused = !paused;
			if (paused) {
				timer1.stop(CountdownTimer.StopBehavior.STOP_IMMEDIATELY);
			}
			else {
				timer1.start();
			}
		}
	}
	if (paused && !gameOver && key != 'p' && key != 'P') {
		paused = false;
		timer1.start();
	}
}

void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) {
	if (t == timer1) {
		zeit++;
	}
}

void onFinishEvent(CountdownTimer t) {
	if (t == timer1) {
		timer1.reset(CountdownTimer.StopBehavior.STOP_AFTER_INTERVAL);
		timer1.start();
		zeit = 0;
		minuten++;
	}
}
