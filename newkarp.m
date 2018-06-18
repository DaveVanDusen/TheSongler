


%% Karplus Strong with User Determined LPF Cutoff!
% Here are some pretty cool ways to use this!
% x = newkarp(440, 2, 44100, 7); soundsc(x,44100);
% x = newkarp(100, 5, 44100, 10); soundsc(x,44100);
% x = newkarp([100 200 400 800], 5, 44100, 10); soundsc(x,44100);
%Duration is in seconds, frequency in hz and the pick location is the harmonic
%multiple of the fundamental you'd like to be attenuated

 function output =  newkarp(frequency, duration,fs, filterCutoff)

animation = 0; 
%Change this to true if you wanna see an animation of the DFT              
% as it's creating the sounds!              
if animation
figure;
end
%% Set up the dang thing!
t=(0:1:fs*duration-1)/fs;
t = t';
attackLen = 200; %varying the attackLen defines the character of the pluck
attack = 2*rand(attackLen,1)-1;
randomAmp = 0.6 + (rand()*0.4);
attack = attack * randomAmp; 
x = zeros(length(t),1);
x(1:length(attack)) = attack';
y = zeros(length(t),length(frequency));


for h = 1:1:length(frequency)
 
    
ratio = floor(fs/frequency(h));

        for i= 1:1:length(t)
        if i <= ratio
           y(i,h) = x(i); 
        else
        y(i,h) = x(i) + ((y(i-ratio,h) + y(i-ratio+1,h))*0.5); 
        %Karplus Strong right here!
        end
        
        %% This will only fire if you make animation truuuuue
        if animation && 1 == mod(i,200)
        pause(0.001);
        plot(20*log10(abs(fft(y))));
        title(i);
        xlabel('Frequency');
        ylabel('Amplitude');
        xlim([1 fs/2]);
        ylim([-40 80]);
        end
        end
    
        

end
y = sum(y,2);
if filterCutoff < 1
[b,a] = butter(5,filterCutoff*frequency(1)/(fs/2),'low');
y = filter(b,a,y);
end
 y = y - mean(y);
 


%% Create the String Envelope
% 
envelope = zeros(length(t),1);
attackLen = 30;
attack = 0:(1/attackLen):1;
envelope(1:attackLen+1) = attack';
release = logspace(0, -2,(length(t)-length(attack)));
envelope(length(attack)+1:end) = release;
% figure; plot(envelope);

output = y .* envelope;
output = output/max(abs(output));


 end

