# MATLAB Container

Run MATLAB in a container with its own set of libraries and quirks.

## Getting Started
1. Clone this repository.
2. Go to mathworks website and download `matlab_<VERSION>_glnxa64.zip` to this directory.
3. Execute `./build.sh` when you need to install MATLAB. Note that this is an interactive installer, so user
   intervention is requested when needed.
4. Execute `./run.sh` when you want to run MATLAB.

This entire procedure is rootless. It also supports hardware acceleration out of the box.

