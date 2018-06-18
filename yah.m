
function out = yah(list)
for n = 0:1:length(list)

   if n == 0
    currlcm = lcm(list(1),list(2));
    elseif n < length(list)
        currlcm = lcm(currlcm, list(n+1)) ;
 
   end
   
   out = currlcm;
   

end
