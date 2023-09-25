abstract class Flugobjekt {
	public int posX;
	public int posY;
	public int rot;
	public int speed;
	boolean isVisible = true;

    PShape symbol;

	abstract void bewegen (int amount);
}

abstract class UFO extends Flugobjekt {

}

public class Star extends UFO {
	public Star (int x, int y, int spd) {
    	posX = x;
    	posY = y;
    	rot = int(random(0, 360));
    	speed = spd;  
    symbol = loadShape("rock.obj");
    symbol.setTexture(rockTexture); //<>//
    symbol.scale(0.2);
    /*
		fill(255);
		stroke(255);
		strokeWeight(2);
		symbol = createShape();
		symbol.beginShape();
		symbol.vertex(0, -5);
		symbol.vertex(1.4, -2);
		symbol.vertex(4.7, -1.5);
		symbol.vertex(2.3, 0.7);
		symbol.vertex(2.9, 4.0);
		symbol.vertex(0, 2.5);
		symbol.vertex(-2.9, 4);
		symbol.vertex(-2.3, 0.7);
		symbol.vertex(-4.7, -1.5);
		symbol.vertex(-1.4, -2);
		symbol.endShape(CLOSE);
*/
	}

	public void zeichnen (){ 
		if (isVisible) {
			pushMatrix();
			translate(posX, posY);
			rotate(rot);
			shape(symbol);
			popMatrix();
		}
	}

	public void bewegen (int amount) {
		posY = posY + amount;
	}

  public void drehen (float xAmount, float yAmount, float zAmount) {
    symbol.rotateX(xAmount);
    symbol.rotateY(yAmount);
    symbol.rotateZ(zAmount);
  }
}

public class Kryptonit extends UFO {
	public Kryptonit (int x, int y) {
		posX = x;
    	posY = y;
    	rot = int(random(0, 360));
		fill(0);
		stroke(255, 0, 0);
		strokeWeight(2);
		symbol = createShape();
		symbol.beginShape();
		symbol.vertex(0, -5);
		symbol.vertex(1.4, -2);
		symbol.vertex(4.7, -1.5);
		symbol.vertex(2.3, 0.7);
		symbol.vertex(2.9, 4.0);
		symbol.vertex(0, 2.5);
		symbol.vertex(-2.9, 4);
		symbol.vertex(-2.3, 0.7);
		symbol.vertex(-4.7, -1.5);
		symbol.vertex(-1.4, -2);
		symbol.endShape(CLOSE);
	}

	public void zeichnen (){ 
		if (isVisible) {
			pushMatrix();
			translate(posX, posY);
			rotate(rot);
			shape(symbol);
			popMatrix();
		}
	}

	public void bewegen (int amount) {
		posY = posY + amount;
	}
}

public class Raumschiff extends Flugobjekt {
	public Raumschiff (int x, int y) {
    	posX = x;
    	posY = y;
		fill(100);
		noStroke();
		symbol = loadShape("cirno_low.obj");//createShape(ELLIPSE, 0, 0, 50, 50);
    symbol.setTexture(cirnoTexture); //<>//
    symbol.rotateY(HALF_PI);
    symbol.rotateZ(HALF_PI * -1);
    //symbol.rotateX(0.5);
    symbol.scale(5);
		/*			(Raumschiff)
		symbol.beginShape();
		symbol.vertex(25, 0);
		symbol.vertex(30, 5);
		symbol.vertex(30, 5);
		symbol.vertex(32, 12);
		symbol.vertex(28, 20);
		symbol.vertex(31, 28);
		symbol.vertex(27, 25);
		symbol.vertex(25, 29);
		symbol.vertex(23, 25);
		symbol.vertex(19, 28);
		symbol.vertex(22, 20);
		symbol.vertex(18, 12);
		symbol.vertex(20, 5);
		symbol.endShape(CLOSE);
		*/
	}

	public void zeichnen (color farbe){ 
		if (isVisible) {
			pushMatrix();
			push();
			symbol.setFill(farbe);
			translate(posX, posY);
			rotate(rot);
			shape(symbol);
			pop();
			popMatrix();
		}
	}

	public void bewegen (int amount) {
		posX+=amount;
		if (posX < 50) posX = 50;
		if (posX > width-150) posX = width-150;
	}
}
