

int IX(int x, int y) {
  x = constrain(x, 0, N-1);
  y = constrain(y, 0, N-1);
  return x + y * N;
}


class Fluid {
  int size;
  float dt; // timestep
  float diff;  // diffuse amount
  float visc;  // viscosity

  float[] s;  // previous density
  float[] density;

  float[] Vx;
  float[] Vy;

  float[] Vx0;  // previous velocity
  float[] Vy0;


  Fluid(float dt, float diffusion, float viscosity) {
    this.size = N;
    this.dt = dt;
    this.diff = diffusion;
    this.visc = viscosity;

    this.s = new float[N*N];
    this.density = new float[N*N];

    this.Vx = new float[N*N];
    this.Vy = new float[N*N];

    this.Vx0 = new float[N*N];
    this.Vy0 = new float[N*N];
  }

  void addDensity(int x, int y, float amount) {
    int index = IX(x, y);
    this.density[index] += amount;
  }

  void addVelocity(int x, int y, float amountX, float amountY) {
    int index = IX(x, y);
    this.Vx[index] += amountX;
    this.Vy[index] += amountY;
  }
  
  void renderD(){
    for (int i = 0; i < N; i ++){
      for (int j= 0; j < N; j ++){
        float x = i * SCALE;
        float y = j * SCALE;
        float d = this.density[IX(i,j)];
        fill(d);
        noStroke();
        rect(x, y, SCALE);
      }
    }
  }
  
  void fadeD(){
    for (int i = 0; i < this.density.length; i ++){
      float d = density[i];
      density[i] = constrain(d-0.1, 0, 255);
    }
  }
}

// --------------------------------------------------------------------------------------------

void diffuse(int b, float[] x, float[] x0, float diff, float dt) {
  float a = dt * diff * (N-2) * (N-2);
  lin_solve(b, x, x0, a, 1+6*a);  // linear solve
}

// one particular cell is based on the function of itself and all its neighbours
void lin_solve(int b, float []x, float []x0, float a, float c) {
  float cRecip = 1.0 / c;
  for (int k = 0; k < iter; k++) {   // I think k loop might need to be deleted
    for (int j = 1; j < N - 1; j++) {
      for (int i = 1; i < N - 1; i++) {
        x[IX(i, j)] =
          (x0[IX(i, j)]  // old value plus combination of the curent values
          + a*(x[IX(i+1, j)]
          +x[IX(i-1, j)]
          +x[IX(i, j+1)]
          +x[IX(i, j-1)]
          )) * cRecip;
      }
    }
    set_bnd(b, x);
  }
}

// --------------------------------------------------------------------------------------------
void project(float[] velocX, float[] velocY, float[] p, float[] div) {
  for (int j = 1; j < N - 1; j++) {
    for (int i = 1; i < N - 1; i++) {
      div[IX(i, j)] = -0.5f*(
        velocX[IX(i+1, j )]
        -velocX[IX(i-1, j )]
        +velocY[IX(i, j+1)]
        -velocY[IX(i, j-1)]
        )/N;
      p[IX(i, j)] = 0;
    }
  }

  set_bnd(0, div);
  set_bnd(0, p);
  lin_solve(0, p, div, 1, 6);

  for (int j = 1; j < N - 1; j++) {
    for (int i = 1; i < N - 1; i++) {
      velocX[IX(i, j)] -= 0.5f * (  p[IX(i+1, j)]
        -p[IX(i-1, j)]) * N;
      velocY[IX(i, j)] -= 0.5f * (  p[IX(i, j+1)]
        -p[IX(i, j-1)]) * N;
    }
  }

  set_bnd(1, velocX);
  set_bnd(2, velocY);
}

// --------------------------------------------------------------------------------------------
static void advect(int b, float[] d, float[] d0,  float[] velocX, float[] velocY, float dt, int N)
{
    float i0, i1, j0, j1;
    
    float dtx = dt * (N - 2);
    float dty = dt * (N - 2);
    float dtz = dt * (N - 2);
    
    float s0, s1, t0, t1;
    float tmp1, tmp2, x, y;
    
    float Nfloat = N;
    float ifloat, jfloat;
    int i, j;
        for(j = 1, jfloat = 1; j < N - 1; j++, jfloat++) { 
            for(i = 1, ifloat = 1; i < N - 1; i++, ifloat++) {
                tmp1 = dtx * velocX[IX(i, j)];
                tmp2 = dty * velocY[IX(i, j)];

                x    = ifloat - tmp1; 
                y    = jfloat - tmp2;

                
                if(x < 0.5f) x = 0.5f; 
                if(x > Nfloat + 0.5f) x = Nfloat + 0.5f; 
                i0 = floorf(x); 
                i1 = i0 + 1.0f;
                if(y < 0.5f) y = 0.5f; 
                if(y > Nfloat + 0.5f) y = Nfloat + 0.5f; 
                j0 = floorf(y);
                j1 = j0 + 1.0f; 

                s1 = x - i0; 
                s0 = 1.0f - s1; 
                t1 = y - j0; 
                t0 = 1.0f - t1;
                
                int i0i = int(i0);
                int i1i = int(i1);
                int j0i = int(j0);
                int j1i = int(j1);
                
                d[IX(i, j)] = 
                    s0 * ( t0 * d0[IX(i0i, j0i)]
                        + t1 * d0[IX(i0i, j1i)])
                   +s1 * ( t0 * d0[IX(i1i, j0i)]
                        + t1 * d0[IX(i1i, j1i)]);

            }
        }
    }
    set_bnd(b, d);
}

// --------------------------------------------------------------------------------------------
void set_bnd(int b, float[] x){

        for(int i = 1; i < N - 1; i++) {
            x[IX(i, 0  )] = b == 2 ? -x[IX(i, 1  )] : x[IX(i, 1  )];
            x[IX(i, N-1)] = b == 2 ? -x[IX(i, N-2)] : x[IX(i, N-2)];
        }

        for(int j = 1; j < N - 1; j++) {
            x[IX(0  , j)] = b == 1 ? -x[IX(1  , j)] : x[IX(1  , j)];
            x[IX(N-1, j)] = b == 1 ? -x[IX(N-2, j)] : x[IX(N-2, j)];
        }
    
    x[IX(0, 0)]       = 0.5f * (x[IX(1, 0)]
                                  + x[IX(0, 1)]
    x[IX(0, N-1)]     = 0.5f * (x[IX(1, N-1)]
                                  + x[IX(0, N-2)]
    x[IX(N-1, 0)]     = 0.5f * (x[IX(N-2, 0)]
                                  + x[IX(N-1, 1)]
    x[IX(N-1, N-1)]   = 0.5f * (x[IX(N-2, N-1)]
                                  + x[IX(N-1, N-2)]
}
