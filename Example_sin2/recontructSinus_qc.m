%% Rekonstrukcia orezanej sinusoidy - algoritmus s kvadratickymi podmienkami
% vhodne pre zasumene signaly

clear all;
clc;

path(path, './Optimization');

load sinus.mat

n = length(sinus);

%% Matica merania
% Nahodne vzorkovanie
% pocet vzoriek
k = 60;

% velkost sumu
sigma = 0.005;

% Nahrada randsample
ii = zeros(1,k);
for i=1:k
    while 1
        pom = floor(1+n*rand);
        if (~ismember(pom, ii))
            ii(i) = pom;
            break
        end
    end
end

I = sort(ii);

% Bazou je inverzna DFT (n x n)
DFTbasis = conj(dftmtx(n))/n;

% Vyber riadkov matice prisluchajucich nahodnemu vzorkovaniu    (k x n)
global A;
for i=1:k
    A(i,:) = DFTbasis(I(i),:);
end

%% l1 minimalizacia

% Pomocne funkcie
% vypocet Ax a A'x

Afun = @(x) func(1,x);
Atfun = @(x) func(2,x);

% sum
e = sigma*randn(1,k);

% Vyber nahodnych vzoriek zo signalu (observations)
yy = sinus(I) + e;

% initial guess = min energy
x0 = Atfun(yy);

% take epsilon a little bigger than sigma*sqrt(k)
epsilon =  sigma*sqrt(k)*sqrt(1 + 2*sqrt(2)/sqrt(k));
                                                                                                                           
% solve the LP
tic
xp = l1qc_logbarrier(x0, Afun, Atfun, yy(:), epsilon, 1e-3, 50, 1e-8, 500);
toc

n = length(xp);

figure;
subplot(2,3,1); 
plot(sinus);
axis([0 n/2 -1 1]);
title('Originalny signal');

%prerobenie realneho vektora na komplexny
re = xp(1:n/2);
im = xp(n/2+1:n);
z = re + sqrt(-1)*im;

%vykreslenie
subplot(2,3,2); 
plot(real(ifft(z)));
axis([0 n/2 -1 1]);
title('Rekonstruovany signal');

subplot(2,3,3); 
plot(sinus(:) - real(ifft(z)));
title('Rozdiel signalov');

subplot(2,3,4); 
pom = abs(fft(sinus)); 
plot(pom(1:n/4));
title('Originalna DFT');

subplot(2,3,5); 
plot(abs(z(1:n/4)));
title('Rekonstruovana DFT');

subplot(2,3,6); 
pom = abs(fft(sinus(:))) - abs(z);
plot(pom(1:n/4));
title('Rozdiel DFT');
