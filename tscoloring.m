function sol = tscoloring(instance, minK, maxIt, fixLong, propLong)

prblm = [];

% load instance
[ prblm.adj, prblm.N, prblm.E ] = loadDimacs(instance);

% utiliser DSATUR pour trouver uppper bound for K
sol = dsatur(prblm.N, prblm.adj);
K = max(sol);

disp([ 'DSATUR a trouv� ' int2str(K) ' couleurs'])

% �liminer l'une des couleurs de dsol
% dsol(dsol == K) = K-1; % = randi(K-1, size(dsol, 1), size(dsol, 2));

K = K-1;
prblm.K = K;

improvingK = 1;
while improvingK
    % commencer par une solution al�atoire
    sol = randi(prblm.K, 1, prblm.N);

    disp(['Chercher une ' int2str(prblm.K) ' coloration']);
    improvingK = 0;
    pause(2)
    
    [sol, fit] = ts(prblm, sol, maxIt, fixLong, propLong);
    if (fit == 0) % a trouv� une coloration
        disp(['found ' int2str(prblm.K) '-coloration']);
        
        if prblm.K > minK
            % eliminer l'une des couleurs al�atoirement
            % sol(sol == prblm.K) = prblm.K - 1;
        
            prblm.K = prblm.K - 1; % voir si on peut trouver une (K-1)-coloration
            improvingK = 1;
        end
    end
end

end