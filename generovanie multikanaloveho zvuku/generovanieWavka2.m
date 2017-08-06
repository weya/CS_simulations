varName = 'sinus';
% dataObj = matfile('sinus2_100hz.mat');
% sinus1ch = dataObj.(varName);
dataObj = matfile('sinus2_1kz.mat');
sinus1ch = dataObj.(varName);
dataObj = matfile('sinus2_300hz.mat');
sinus2ch = dataObj.(varName);
dataObj = matfile('sinus2_500hz.mat');
sinus5ch = dataObj.(varName);
dataObj = matfile('sinus2_700hz.mat');
sinus6ch = dataObj.(varName);

clear varNameame dataObj;

prestavka = length(sinus1ch);
sinus1Complete = [sinus1ch zeros(1,prestavka*11)];
sinus2Complete = [zeros(1,prestavka*3) sinus2ch zeros(1,prestavka*8)];
sinus3Complete = [zeros(1,prestavka*12)];
sinus4Complete = [zeros(1,prestavka*12)];
sinus5Complete = [zeros(1,prestavka*6) sinus5ch zeros(1,prestavka*5)];
sinus6Complete = [zeros(1,prestavka*9) sinus6ch zeros(1,prestavka*2)];

MatrixSinus3 = zeros(6,length(sinus1ch)*12);
MatrixSinus3(1,:) = sinus1Complete;
MatrixSinus3(2,:) = sinus2Complete;
MatrixSinus3(3,:) = sinus3Complete;
MatrixSinus3(4,:) = sinus4Complete;
MatrixSinus3(5,:) = sinus5Complete;
MatrixSinus3(6,:) = sinus6Complete;

MatrixSinus3trans = MatrixSinus3';
filename= 'multiChannel.wav';
audiowrite(filename,MatrixSinus3trans,44100);