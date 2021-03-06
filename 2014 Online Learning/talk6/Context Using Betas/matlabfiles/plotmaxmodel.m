function aposprob = plotmaxmodel
% Initializes the context-tree. Parameters are datacardinality, 
% contextcardinality and treedepth. 
% Call: initctwprobestim(datacard,contcard,treedepth).

global datac contc depth
global SymCnts TotCnts Beta
global firstatlevelp

numberofnodes=(contc^(depth+1)-1)/(contc-1);
maxaposprob=ones(numberofnodes,1);
leaf=ones(numberofnodes,1);

for d=depth-1:-1:0 %  pass top down
    nodesatleveld=contc^d;
    firstatleveld=firstatlevelp(d+1);
    firstatleveldplus1=firstatlevelp(d+2);
    for i=1:nodesatleveld
        betaatnode=Beta(firstatleveld+i-1);
        apospr=1/(betaatnode+1);
        for c=1:contc
            apospr=apospr*maxaposprob(firstatleveldplus1+(i-1)*contc+c-1);
        end
        if apospr>betaatnode/(betaatnode+1)
            maxaposprob(firstatleveld+i-1)=apospr; 
            leaf(firstatleveld+i-1)=0;
        else
            maxaposprob(firstatleveld+i-1)=betaatnode/(betaatnode+1);
        end
    end
end
aposprob=maxaposprob(1);

for i=0:contc^depth-1;
    deeltal=i;
    for d=depth:-1:1
        rest=mod(deeltal,contc);
        contarr(d)=rest+1;
        deeltal=(deeltal-rest)/contc;
    end
    % compute path
    indexatlevelp(1)=0;
    nodeatlevelp(1)=1;
    for d=1:depth
        indexatlevelp(d+1)=indexatlevelp(d)*contc+contarr(d)-1;
        nodeatlevelp(d+1)=firstatlevelp(d+1)+indexatlevelp(d+1);
    end
    % compute array-row weight
    left=1;
    for d=0:depth-1
        betaatd=Beta(nodeatlevelp(d+1));
        weightarray(i+1,d+1)=left*betaatd/(betaatd+1);
        left=left/(betaatd+1);
    end
    weightarray(i+1,depth+1)=left;
    % compute array-row  
    leaffound=0;
    for d=0:depth
        if leaffound==1
            leafarray(i+1,d+1)=0;
        else
            if (leaf(nodeatlevelp(d+1))==1)
                leaffound=1;
                leafarray(i+1,d+1)=1;
            else
                leafarray(i+1,d+1)=0;
            end
        end
    end
    % compute array-row
    for d=0:depth 
        probarray(i+1,d+1)=TotCnts(nodeatlevelp(d+1))-1;
    end
end
%subplot(1,3,1); 
bar3(weightarray,1); view([50 20]); axis([0.5 5.5 0.5 16.5 0 1]);
%subplot(1,3,2); imagesc(leafarray);
%subplot(1,3,3); imagesc(probarray);

    
    
       
        

 
