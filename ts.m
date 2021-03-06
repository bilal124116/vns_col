function [ best, bestNc, bestAdj ] = ts(prblm, sol, maxIt, fixLong, propLong, verbose, adjcols)
%ts: applique Tabu Search to the individual
% numItem: nombre d'it�rations du tabu search

if nargin == 5
    verbose = false;
end

if nargin < 7
    adjcols = buildAdjacency(prblm, sol);
end

tabulist = zeros(prblm.N, prblm.K);


nIt = 0;
nC = nodesConflicting(sol, adjcols); % nombre de conflits
bestNc = nC;
best = sol;
bestAdj = adjcols;

endIt = maxIt;

msglen = 0;

while nC > 0 && nIt < endIt
    nIt = nIt + 1;
    
    % chercher le move qui a le plus grand profit et qui n'est pas tabou
    move = findBest1Move(prblm, sol, adjcols, tabulist, nIt, nC, bestNc);
    if isempty(move)
        continue;
    end
    
    % marquer le move comme tabou
    tabulist = setTabu(sol, adjcols, move(1), move(2), tabulist, nIt, fixLong, propLong);
    
    % appliquer le best 1move trouv�
    sol(move(1)) = move(3);

    adjcols = updateAdjacency(prblm, sol, adjcols, move);

    nC = nodesConflicting(sol, adjcols);
    
    if (nC < bestNc)
        bestNc = nC;
        endIt = nIt + maxIt;
        best = sol;
        bestAdj = adjcols;
    end
    
    if verbose
        if (nC == 0)
            msg = sprintf('it%10i/%10i\n', nIt, endIt);
            fprintf(repmat('\b',1,msglen));
            fprintf(msg);
        else%if (mod(nIt, 1000) == 0)
            msg = sprintf('it%10i/%10i conf: %4i, best: %4i\n', nIt, endIt, nC, bestNc);
            fprintf(repmat('\b',1,msglen));
            fprintf(msg);
            msglen=numel(msg);
        end
    end
end

end