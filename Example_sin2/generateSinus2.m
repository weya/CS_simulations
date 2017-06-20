%% Generovanie signalu - sinus s orezanymi vrcholmi

clear all;

% pocet period
pocet_period = 10;
% frekvencia vzorkovania
FVZ = 44100;
% frekvencia sinusu
frekv = 1000;
frekv2 = 300;
% nuly pred
nuly_pred =0;
nuly_za = 200;

% velkost sumu
% zadava sa amplituda sumu s normalnym rozdelenim (0,1)
Asum = 0.0;

dlzka = pocet_period*FVZ/frekv;
sinus = zeros(1,dlzka+nuly_pred+nuly_za);
sinus_novy = zeros(1,dlzka+nuly_pred+nuly_za);

% hlavny cylkus
for i=1:dlzka
    pom = sin(2*pi*frekv*i/FVZ);
    pom2 = sin(2*pi*frekv2*i/FVZ);
    sum = Asum * randn;
    sinus(nuly_pred+i)=pom+pom2+sum;
%   sinus(nuly_pred+i)=sinus+sum;
end

% %toto je sign�l bez �umu len kv�li snr
% for i=1:dlzka
%     pom_sum = sin(2*pi*frekv*i/FVZ);
% %     pom2 = sin(2*pi*(frekv*3.7)*i/FVZ);
%     sum = Asum * randn;
%     sinus_novy(nuly_pred+i)=pom_sum;
% %     sinus(nuly_pred+i)=pom+pom2;
% end
% 
% r=snr(sinus,sinus_novy-sinus)


% okno
okno = [zeros(1,nuly_pred) (chebwin(length(sinus)-nuly_pred-nuly_za)') zeros(1,nuly_za)];
sinus = sinus.*okno;

% ulozenie matice
save sinus2.mat sinus FVZ frekv;

% vykreslenie
figure;
subplot(1,2,1); 
plot(sinus);
xlabel('n','FontSize',12);
ylabel('amplit�da','FontSize',12); 

subplot(1,2,2); 
plot(abs(fft(sinus)));
xlabel('n','FontSize',12);
ylabel('|DFT(y(n))|','FontSize',12); 
