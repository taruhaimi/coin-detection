This is a README.txt-file of the practical assignment in the course Digital Imaging and Image Preprocessing.

The directory contains two functions estim_coins.m and find_coins.m, and report DIIP_PA.pdf.

Function find_coins compares the found radii of the circles to the theoretical radii (transformed to pixels) of the euro coins, and calculates which of the theoretical radii is the closest.
Function estim_coins does the intensity and geometrical calibration process, applies grayscaling, binary dilatation, filling, binary erosion and edge detection, and then detects the circles in the image.

DIIP_PA.pdf contains documentation of the assignment on how the measurement system is applied, the methods on finding the coins in the images, and the results of coin detection system.