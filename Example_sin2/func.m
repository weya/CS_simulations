% Pomocne funkcie 
%   mode = 1: A*x 
%   mode = 2: A'*x
% A je komplexna matica k x n
% x je riadkovy vektor
% y je stlpcovy vektor

function y = func(mode, x)
global A;

% vypocet A*x
% x je realny vektor 1 x 2n (komplexny vektor rozdeleny na dve casti)
if mode == 1
    n = length(x);
    % vytvorenie komplexneho vektora
    re = x(1:n/2);
    im = x(n/2+1:n);
    z = re + sqrt(-1)*im;
    % vypocet A*x
    y = real(A*z(:));
    y = y(:);
    
% vypocet A'*x
% x je realny vektor 1 x k
elseif mode == 2
    % A'*x
    z = A'*x(:);
    % prerobenie na realny vektor
    re = real(z);
    im = imag(z);
    y = [re; im];
    y = y(:);

end
end
