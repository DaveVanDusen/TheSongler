function sample = drums(type,dur,fs)

freqRange = fs/2; 
t=(0:1:ceil(dur*fs-1))/fs;
sig = rand( size(t))*2-1;
ampLoss = 1:-2/(dur*fs-1):0;
ampLoss(end:length(t)) = 0;


ampLoss = ampLoss.^3;


switch type
    case 'hat'
        [b,a] = cheby1(4, 0.7, 0.3, 'high');
        sample = filter(b,a, sig);
        sample = sample .* ampLoss;
        sample = sample/(max(abs(sample)));
    case 'snare'
        [b,a] = butter(1, [150/freqRange 500/freqRange]);
        sample = filter(b,a, sig);
        sample = sample .* ampLoss;
        sample = sample/(max(abs(sample)));
     case 'kick'
         [b,a] = cheby1(4, 0.7, 200/freqRange, 'low');
         sample = filter(b,a, sig);
        sample = sample .* ampLoss;
        sample = sample/(max(abs(sample)));
     
    otherwise 
        disp('You picked the wrong thing my guy');
end
end