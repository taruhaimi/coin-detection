function [coins] = estim_coins(measurement, bias, dark, flat);
% function [coins] = estim_coins(measurement, bias, dark, flat)
% The function ESTIM_COINS performs image measurements to detect and
% recognize coins in the image. 
%
% INPUT     measurement     the raw image that have been measured
%           bias            mean bias image composed of all of the bias
%                           images
%           dark            mean dark image composed of all of the dark
%                           images
%           flat            mean flat image composed of all of the flat
%                           images
% OUTPUT    [coins]         numbers of coins in the image [5ct, 10ct, 20ct, 50ct, 1e, 2e]


%Show the original image:
    subplot(4,2,1)
    imshow(measurement); title("Original image")

    %Intensity calibration process:
    rawimg = uint8(measurement); % Raw image
    flatfield = uint8(flat); %Flatfield images summed together
    bmean = uint8(bias); %Mean bias images

    dmean = uint8(dark)-bmean; % Mean dark images
    flatfield = flatfield-bmean-dmean; % Calculate the flatfield image
    flatfieldnorm = uint8(double(flatfield)./(double(max(flatfield(:))))); % Normalise the flatfield image using the max value
    
    %Calibrated image:
    calibratedImg = (rawimg-bmean-dmean)./flatfieldnorm;
    %Show the calibrated image:
    subplot(4,2,2)
    imshow(uint8(calibratedImg)); title("Intensity calibrated image")
    
    %Geometric calibration:
    %Grayscale the image:
    subplot(4,2,3)
    grayImg = im2gray(calibratedImg);
    imshow(grayImg); title("Gray scale image")
    %Finding the checkerboard points from the rawimage.
    warning("off")
    [cbPoints, boardSize] = detectCheckerboardPoints(rawimg);

    %Using two consecutive checkerboard points, we can calculate what is
    %the distance in pixels
    cbDist = sqrt((cbPoints(1,1)-cbPoints(2,1))^2+(cbPoints(1,2)-cbPoints(2,2))^2);
    cbPixel = cbDist;
    %Then because we know that one square is 12.5 mm wide, we can calculate
    %the width of single pixel in millimeters.
    pixelL = 12.5/cbPixel;


    % Binarization of the grayscale image:
    % Edge command tries to find the edges of grayscale image
    BW = edge(grayImg);
    subplot(4,2,4)
    imshow(BW); title("Binarized image")

    %Dilatate the image to create more defined edges:
    %Help from: https://se.mathworks.com/help/images/ref/imdilate.html
    %We use disk shaped structuring element with radius of 15 for the
    %dilatation and erosion.
    morphParam = 15;
    se = strel('disk',morphParam);
    dilatedI = imdilate(BW,se);
    subplot(4,2,5)
    imshow(dilatedI); title("Dilated image (creating edges)")

    %Fill the circles using imfill function:
    filledI = imfill(dilatedI,'holes');
    subplot(4,2,6)
    imshow(filledI); title("Filling shapes")

    %Erode the squares using the structuring element defined before:
    erodedI = imerode(filledI,se);
    subplot(4,2,7)
    imshow(erodedI); title("Eroded image")

    %Find the circles in the image. We try to find all of the circles with
    %radiuses between 190 and 300, and we use the sensitivity of 0.965 to
    %guarantee that we find all of the circles.    
    [centers, radii] = imfindcircles(erodedI,[190 300],'ObjectPolarity','bright','Sensitivity',0.97);
    subplot(4,2,8)
    imshow(erodedI); title("Finding coins in the image")
    hold on
    coins = find_coins(radii,pixelL);
    viscircles(centers,radii);
    sgtitle('Image processing steps') ;

end
