%% Play sound to announce the end of running a set of analysis
function Announce_Finish()
    %Load Sound
    load handel.mat;
    %Play Sound
    sound(y, Fs);
end