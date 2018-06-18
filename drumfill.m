function fill = drumfill(drum, dur,fs)
len = ceil(dur*fs);
division = randi(4);
subdiv = (floor(dur*fs)/fs)*(1/division);
snareHit = drums(drum,subdiv,fs); 
fill = repmat(snareHit',division,1);
if length(fill) < len
    fill(end+1:len) = 0;
elseif length(fill) > len
    fill = fill(1:len);
end
fill = fill';
end