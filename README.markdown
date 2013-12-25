# Vim :Shell

This allows shell commands to be executed and any output written to a vim
buffer.

    :Shell ls

This will create a new vim buffer for each command executed. This will reuse
buffers if the same command is executed multiple times. The buffer will be the
size of the output or one third of the screen, whichever is smaller.
