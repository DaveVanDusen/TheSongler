
% numPrimes is the length of each underlying repeating pattern
numPrimes = [2,3,4,5,7];
% lowest Frequency AKA the root note
lowestFrequency = 100;
% sa Sampling Rate
fs = 44100;
%The duration of each metronomic tick
dur = 0.2;


%% Creates the Total Len and Mallocs for the Matrix
    %This calculates the least common multiple of the numPrimes array
    theEnd = yah(numPrimes);
    %This stores the frequency for each note
    storageMatrix = zeros(theEnd, length(numPrimes));
    %This makes the decision about what the sound will be
    switchMatrix = zeros(theEnd, length(numPrimes));
    %% Create and select the scales
    
    %Here you select the scale, values are weighted when they are repeated
    %The second argument in this function
    noteChoices = makeScale(lowestFrequency,[0 0 0 3 3 5 5 6 7 7 10 10],2);
    
    for i = 1:1:length(numPrimes)
        %creates the individual sequences of notes as long as the provided
        %length
        freqLine = randi(length(noteChoices), numPrimes(i), 1);
        switchLine = randi(14, numPrimes(i), 1);
        %Converts indices to frequencies
        freqLine = noteChoices(freqLine(:));
        %each additional line goes up an octave
        freqLine = freqLine + (freqLine*(i-1));
        
        freqLine = freqLine';
        switchLine = switchLine';
        %repeats the pattern over and over...
        freqLine(end+1:theEnd) = repmat(freqLine, 1, (theEnd-numPrimes(i))/numPrimes(i));
        switchLine(end+1:theEnd) = repmat(switchLine, 1, (theEnd-numPrimes(i))/numPrimes(i));
        storageMatrix(:, i) =freqLine;
        switchMatrix(:,i) = switchLine;

    end
    x = storageMatrix;
    %malloc for the overall output
    song = zeros(theEnd * fs, 1);
    %malloc for individual notes
    wave = zeros(1,ceil(dur*fs));
    
    for n = 1:1:theEnd
        %This is the time vectorrrrrrr!
        t = (1:1:ceil(dur*fs))/fs;
        
        %This is where you can set the frequency modulation
        knob = (2*sin(2*pi*dur*t*15));
        
        %This is where you can set the amplitude modulation
        amp = (sin(2*pi*dur*t*10)+1)/2;
        wave(:) = 0;
        for k = 1:1:length(numPrimes)
            
            currFreq = x(n, k);
            if currFreq == 0
            else
                switch switchMatrix(n,k)
                    case 1 %sawtooth with FM
                    wave =  wave +(0.15 * sawtooth(2*pi*dur*t*currFreq + knob ));
                    case 2
                    wave =  wave +(0.3 * sin(2*pi*dur*t*currFreq + knob ));
                    case 3
                    wave =  wave +(0.15 * square(2*pi*dur*t*currFreq + knob ));
                    case {4, 5, 6}
                    pluck = newkarp(currFreq,dur,fs,800);
                    wave = wave + 1.3*pluck';
                    case 12
                    wave =  wave + ((0.15 * square(2*pi*dur*t*currFreq)) .* amp);
                    case 7
                    wave =  wave + ((0.3 * sin(2*pi*dur*t*currFreq)) .* amp);
                    case 8
                    wave =  wave + ((0.15 * sawtooth(2*pi*dur*t*currFreq)) .* amp);
                    case 9
                    wave = wave + drums('hat',dur,fs);
                    case 10
                    wave = wave + 2*drums('snare',dur,fs);
                    case 11
                    wave = wave + 2*drumfill('hat',dur,fs);
                    case 13
                    wave = wave + 2*drums('kick',dur,fs);   
                    case 14
                    wave = wave + 2*drumfill('snare',dur,fs);
                    
                    otherwise
                        disp('randi is broken');
                end
            end 
        end
        songIndexStart = 1 + (length(t)*(n-1));
        songIndexEnd = length(t)*n;
        %places audio in the output array
        song(songIndexStart:songIndexEnd) = song(songIndexStart:songIndexEnd) + wave';

    end
    
    %normalize
    song = song - mean(song);
    song = song/(max(abs(song)));
    song = 0.5 * song;
    song = song(1:ceil(theEnd*dur*fs));
    songSeconds = (length(song)/fs);


    y = song;
    soundsc(y,fs);
    