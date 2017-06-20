%% Rekonstrukcia orezanej sinusoidy - algoritmus s podmienkami rovnosti
% najlepsie pre nezasumene signaly

clear all;
clc;

path(path, 'e:\[PHD]\studijny plan\CS priklady\Example_sin2\Optimization\');

load sinus2.mat

n = length(sinus);

%% Matica merania
% Nahodne vzorkovanie
% pocet vzoriek
k = 20;

% velkost sumu
sigma = 0;

% randsample vyzaduje statistics toolbook
%ii = sort(randsample(1:n,k));

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

% solve the LP
tic
xp = l1eq_pd(x0, Afun, Atfun, yy(:), 1e-3, 30, 1e-8, 200);
toc

n = length(xp);
x_os = 1:1:200;%linspace(0,400);
figure;
subplot(2,3,1); 
plot(sinus);
axis([0 n/2 -2 2]);
title('Originalny signal');

%prerobenie realneho vektora na komplexny
re = xp(1:n/2);
im = xp(n/2+1:n);
z = re + sqrt(-1)*im;

% Vykreslenie
subplot(2,3,2); 
plot(x_os,sinus,x_os,real(ifft(z)));
axis([0 n/2 -2 2]);
title('Rekonstruovany signal');

subplot(2,3,3); 
plot(sinus(:) - real(ifft(z)));
title('Rozdiel signalov');

err = mean(abs(sinus(:) - real(ifft(z))))

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
