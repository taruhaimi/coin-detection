function [foundCoins] = find_coins(calcRadii, pixelLength)
% function [foundCoins] = find_coins(calcRadii, pixelLength)
%
% The function FIND_COINS makes comparison to which known coin radii the
% calculated radii matches best, and based on that it decides which coins
% and how many each of them are found in the image.
%
% INPUT     calcRadii       the radii of found coins in the image     
%           pixelLength     how wide one pixel is in mm. 
% OUTPUT    [foundCoins]    numbers of coins in the image [5ct, 10ct, 20ct, 50ct, 1e, 2e]

% Known radii of coins [5ct, 10ct, 20ct, 50ct, 1e, 2e]:
coinRadii = [21.25 19.75 22.25 24.25 23.25 25.75]./2; % mm
coinradiipx = coinRadii./pixelLength; % px
foundCoins = zeros(1,6);

for i = 1:length(calcRadii)
    % Finding how close the calculated radius is to the known coin radii,
    % and selecting the coin with smallest difference:
    coin = calcRadii(i);
    dists = abs(coin-coinradiipx);
    minDistCoinInd = find(dists==min(dists));

    % Updating the number of found coins:
    foundCoins(minDistCoinInd) = foundCoins(minDistCoinInd) + 1;

end