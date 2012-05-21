/*gcrll.net
 LUTs: look up tables.
 3DLUT cube maker.
 CPU based.
 theory: http://http.developer.nvidia.com/GPUGems2/gpugems2_chapter24.html
 interpolation from: https://github.com/openframeworks/openFrameworks/tree/develop/examples/graphics/lutFilterExample
 */
 
PImage img;
color[][][] lut=new color[32][32][32] ;
String name;
String[] colorLines=new String[32*32*32];
int ind=0;
void setup() {

  size(800, 300);
  img=loadImage("patitos.jpg");
  
  name="vintage2";  
  for (int i=0;i<32;i++) {
    for (int j=0;j<32;j++) {
      for (int k=0;k<32;k++) {
        //lut[i][j][k]=color(i*8, j*8, k*8);//NoFX.
        //lut[i][j][k]=color(i*10+noise(i/10.0f)*200,(1-cos(j/12.0f))*200,(1-sin(k/8.0f))*200);//odd
        //lut[i][j][k]=color(i*10+noise(i/5.0f)*200,(1-cos(j/6.0f))*200,(1-sin(k/4.0f))*200);//odd
        //lut[i][j][k]=color(i*8+sin(i/10.0f)*80,j*8+sin(j/10.0f)*80,k*8+sin(k/10.0f)*80);//odd
        //lut[i][j][k]=color(i*(1-cos(i/5.0f))*8,j*(1-cos(j/5.0f))*8,k*(1-cos(k/5.0f))*8);//odd1
        //lut[i][j][k]=color(i*15,j*15,k*15);//+bright
        //lut[i][j][k]=color(i*5,j*5,k*5);//-bright
        //lut[i][j][k]=color((i*i),(j*j),(k*k));//burn
        //lut[i][j][k]=color((i*i*i)/12,(j*j*j)/12,(k*k*k)/12);//+burn
        //lut[i][j][k]=color((i+j)*4,(j+k)*4,(k+i)*4);//rotated(?)
        //lut[i][j][k]=color((i+j+k)*2,(i+j+k)*2,(i+j+k)*2);//~desaturation like...
        //lut[i][j][k]=color(i*(cos(i))*8,j*(cos(j))*8,k*(cos(k))*8);//armonic
        //lut[i][j][k]=color((i*.5+k*.5)*8,(j*.5+i*.5)*8,(k*.5+j*.5)*8);//rotation
        //lut[i][j][k]=color(sqrt((i+j)*10)*15,sqrt(j*8)*15,sqrt(k+i)*15);//vintage1(?)
        lut[i][j][k]=color(sqrt((i)*10)*12, sqrt(j*10)*12, sqrt(k)*15);//vintage(?);
        
        float rcN=red(lut[i][j][k])/255.0f;
        float gcN=green(lut[i][j][k])/255.0f;
        float bcN=blue(lut[i][j][k])/255.0f;
        
        
        colorLines[ind]=str(rcN)+' '+str(gcN)+' '+str(bcN); 
        //should be using nf() but i get commas instead of points!
                
        if(ind==1){
          println(colorLines[ind]);
          println(rcN);
        }
        ind++;
        
        
      }
    }
  }
  saveStrings(name+".cube",colorLines);        

  background(0);
  noStroke();
  noLoop();
}

void draw() {
  background(0); 

  image(img, 0, 0); 
  img.loadPixels();   

  for (int i=0;i<img.pixels.length;i++) {
    color c=img.pixels[i];

    int rc=(int)red(c);
    int gc=(int)green(c);
    int bc=(int)blue(c);     

    int ri=rc/8;
    int gi=gc/8;
    int bi=bc/8;

    int rf=ri+1;
    int gf=gi+1;
    int bf=bi+1;

    float amountR = (rc % 8) / 8.0f;
    float amountG = (gc % 8) / 8.0f;
    float amountB = (bc % 8) / 8.0f;

    c=color(red(lut[ri][gi][bi])+amountR*(red(lut[rf][gf][bf])-red(lut[ri][gi][bi])), 
    green(lut[ri][gi][bi])+amountG*(green(lut[rf][gf][bf])-green(lut[ri][gi][bi])), 
    blue(lut[ri][gi][bi])+amountR*(blue(lut[rf][gf][bf])-blue(lut[ri][gi][bi]))
      );

    img.pixels[i]=c;
  }  


  img.updatePixels(); 
  image(img, width/2, 0);
}




void keyPressed() {
  if (key==' ') {
    saveFrame();
  }
}

