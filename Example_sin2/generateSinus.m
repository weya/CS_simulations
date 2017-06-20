%% Generovanie signalu - sinus s orezanymi vrcholmi

clear all;

% pocet period
pocet_period = 10;
% frekvencia vzorkovania
FVZ = 2000;
% frekvencia sinusu
frekv = 100;
% velkost sumu
% zadava sa amplituda sumu s normalnym rozdelenim (0,1)
Asum = 0.2;
% orezanie (0 - obidve, 1 - len neparne, 2 - len parne)
orezanie = 2;
% skreslenie - hodnota vystupu, od ktorej je signal orezavany
skreslenie_neparne = 0.9;
skreslenie_parne = 0.9;

dlzka = pocet_period*FVZ/frekv;
sinus = zeros(1,dlzka);

% hlavny cylkus
for i=1:dlzka
    pom = sin(2*pi*frekv*i/FVZ);
    sum = Asum * randn;
%    neparne polvlny
    if (pom > 0)
        if (orezanie < 2)
            if (pom >= skreslenie_neparne)
                sinus(i) = skreslenie_neparne + sum;
            end
        else
            sinus(i) = pom + sum;
        end
        if (pom <= skreslenie_neparne)
            sinus(i) = pom + sum;
        end
    end

%    parne polvlny
    if (pom < 0)
        if (orezanie ~= 1)
            if (pom <= -skreslenie_parne)
                sinus(i) = -skreslenie_parne + sum;
            end
        else
            sinus(i) = pom + sum;
        end
        if (pom >= -skreslenie_parne)
            sinus(i) = pom + sum;
        end
    end
end

% ulozenie matice
save sinus.mat sinus FVZ frekv;

% vykreslenie
figure;
subplot(1,2,1); 
plot(sinus);

subplot(1,2,2); 
plot(abs(fft(sinus)));
