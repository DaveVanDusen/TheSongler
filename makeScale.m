%% make scale
% create a scale of freqs in hz with the start freq and an array of steps 
function theScale = makeScale(startFreq,array,silenceFactor)
   
    theScale = zeros(1,length(array));
    for i = 1:length(array)
        theScale(i) = startFreq * 2^(array(i)/12);
    end
   if nargin == 3
   theScale = horzcat(theScale,zeros(1,silenceFactor));
   end

   end
   