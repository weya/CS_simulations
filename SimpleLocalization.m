%% nastavenie parametrov    
    
    N = 4;  % poèet vysielaèov
    M = 1;  % poèet prijmaèov (cie¾ov)
    
    % chyba merania (standardna odchýlka šumu od vzdialenosti)
    distMeasurementErrRatio = 0.04;  % 0.9 znamená, že meranie je presné na 90%

    networkSize = 30;  %ve¾kos plochy (uvazujeme štvorec)
    
    anchorLoc   = [0                     0; % nastavenie polohy vrcholov (vysielaèov)
                   networkSize           0;
                   0           networkSize
                   networkSize networkSize];
%                    networkSize networkSize];

    % vytvorenie nahodnej pozicie cie¾a
    mobileLoc  = networkSize*rand(M,2);
    
    % Vypcet Euklidovej vzdialenosti    
           % distance   = sqrt(sum( (anchorLoc - repmat(mobileLoc,N,1)).^2 , 2));
        
    %
    distance = zeros(N,M);
    for m = 1 : M
        for n = 1 : N
                distance(n,m) = sqrt( (anchorLoc(n,1)-mobileLoc(m,1)).^2 + ...
                                            (anchorLoc(n,2)-mobileLoc(m,2)).^2  );
        end
    end
    % vykreslenie scenara
    f1 = figure(1);
    clf
    plot(anchorLoc(:,1),anchorLoc(:,2),'ko','MarkerSize',8,'lineWidth',2,'MarkerFaceColor','k');
    grid on
    hold on
    plot(mobileLoc(:,1),mobileLoc(:,2),'b+','MarkerSize',8,'lineWidth',2);
    
    % zašuemené meranie
%    distanceNoisy = distance + distance.*distMeasurementErrRatio.*(rand(N,M)-1/2);
     distanceNoisy = distance + distance.*distMeasurementErrRatio; 
    %  gussian newton na riešenie problemu
    % (http://en.wikipedia.org/wiki/Gauss%E2%80%93Newton_algorithm)
    
    numOfIteration = 5;
    
    % uvodny odhad (nahodna pozicia)
%     mobileLocEst = networkSize*rand(M,2);
    mobileLocEst = networkSize;
    % opakovanie
    for m = 1 : M
        for i = 1 : numOfIteration
            % vypocet odhadovanych vzdialenosti
            distanceEst   = sqrt(sum( (anchorLoc - repmat(mobileLocEst(m,:),N,1)).^2 , 2));
            % vypocet derivacii
                % d0 = sqrt( (x-x0)^2 + (y-y0)^2 )
                % derivatives -> d(d0)/dx = (x-x0)/d0
                % derivatives -> d(d0)/dy = (y-y0)/d0
            distanceDrv   = [(mobileLocEst(m,1)-anchorLoc(:,1))./distanceEst ... % x-coordinate
                             (mobileLocEst(m,2)-anchorLoc(:,2))./distanceEst];   % y-coordinate
            % delta 
            delta = - (distanceDrv.'*distanceDrv)^-1*distanceDrv.' * (distanceEst - distanceNoisy(:,m));
            % obnovenie odhadu
            mobileLocEst(m,:) = mobileLocEst(m,:) + delta.';
        end
    end    
    plot(mobileLocEst(:,1),mobileLocEst(:,2),'ro','MarkerSize',8,'lineWidth',2);
    legend('Pozície vysielaèov','Generovaná pozícia','Vypoèítaná pozícia',...
           'Location','Best')
    
    % vypocet RMSe
    Err = mean(sqrt(sum((mobileLocEst-mobileLoc).^2)));
    title(['Absolútna odchýlka je ',num2str(Err),'m'])
    axis([-0.1 1.1 -0.1 1.1]*networkSize)