
## Documentation

[Board documentation](https://www.sifive.com/boards/hifive-premier-p550)
[Miralis repository](https://github.com/CharlyCst/miralis)

## Step 1: Build an image for the premier P550 board

To build the original image of the board, you need to execute the script ```install.sh``` that will build the image (according to the [software maual](https://www.sifive.com/document-file/hifive-premier-p550-software-reference-manual))

```bash
./install.sh
```

## (alternative) Step 1: Download the image directly

This is as simple as a this: 

```bash
TODO: Add the command
```

## Step 2: Flashing the image on the board with USB

- Place the boot pins at the position ```0011```
- Connect the board with the ATX power supply and the usb-C and usb-A cables (according to the figure) to your computer
- Start minicom with a baudrate of ```11250``` and ```/dev/ttyUSB2```
- Power on the board, a usb device should be enumerated on your computer.
- Copy the bootchain image and wait the output on the UART.

<center>
<h3>Switches position</h3>
<img src="./switches.png" height="150">

<h3>Cables to connect</h3>
<img src="./cables.png" height="150">
</center>






## Troubleshooting

#### I receive the message USB bulk complete with a negative number

This is completely normal and is part of the copy procedure. If it doesn't work as expected this is probably not the issue.

#### When I copy the image, the DDR firmware starts but then there is no boot 

Your boot image might be broken, try with the original one you can download here: A carefule user will note that the start uart is also not the typical one such as in qemu.

