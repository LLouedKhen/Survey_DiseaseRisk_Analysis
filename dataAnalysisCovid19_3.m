clear; clc;
close all

datapath = '/Users/loued/Documents/CovidResults'

cd(datapath)

prelimRes = readtable('results-survey499135.xlsx');
me = {};
loved = {};
other = {};

for i=1:size(prelimRes,2)
if strfind(char(prelimRes.Properties.VariableNames(i)),'YouHaveA')
me{i} = prelimRes(:,i);
elseif strfind(char(prelimRes.Properties.VariableNames(i)),'SomeoneY')
other{i} = prelimRes(:,i);    
elseif strfind(char(prelimRes.Properties.VariableNames(i)),'YourLovedOneHas')
loved{i} = prelimRes(:,i);    
end
end



me = me(~cellfun('isempty',me));
for i = 1:size(me,2)
   x = me(i);
   x{1,1}(1:2,:) = [];
   me(i) = x;
end
me = me(1,2:end)


meTrial = struct();

Gamble = 0;
Sure = 0;
Nothing =  0;

for i=1:size(me,2)
    
if strfind(char(me{i}.Properties.VariableNames),'25_Chance')
meTrial(i).risk = 0.25;
elseif strfind(char(me{i}.Properties.VariableNames),'10_Chance')
meTrial(i).risk = 0.10;
elseif strfind(char(me{i}.Properties.VariableNames),'5_Chance')
meTrial(i).risk = 0.05;
elseif strfind(char(me{i}.Properties.VariableNames),'50_Chance')
meTrial(i).risk = 0.50;
end

if strfind(char(me{i}.Properties.VariableNames),'Falling')
meTrial(i).pain = 2;
elseif strfind(char(me{i}.Properties.VariableNames),'Dying')
meTrial(i).pain = 3;
end


for j = 1:height(me{1,i})
    if cell2mat(strfind(table2cell(me{1,i}(j,1)),'experimental')) 
        gcount = 1;
        Gamble = Gamble + gcount;
        meTrial(i).choice(j) = 3;
    end
    if cell2mat(strfind(table2cell(me{1,i}(j,1)),'but'))
        scount = 1;
        Sure = Sure + scount;
        meTrial(i).choice(j) = 2;
    end
    if cell2mat(strfind(table2cell(me{1,i}(j,1)),'nothing'))
        ncount = 1;
        Nothing = Nothing + ncount;
        meTrial(i).choice(j) = 1;
    end
    
    if cell2mat(strfind(table2cell(me{1,i}(j,1)),'halve'))
            meTrial(i).txRisk(j) = 0.5;
    elseif cell2mat(strfind(table2cell(me{1,i}(j,1)),'75%'))
            meTrial(i).txRisk(j) = 0.25;
    else  meTrial(i).txRisk(j) = 1;
    end
    

    
    if cell2mat(strfind(table2cell(me{1,i}(j,1)),'tenth'))
        meTrial(i).wager(j) = 0.1;
    elseif cell2mat(strfind(table2cell(me{1,i}(j,1)),'half'))
        meTrial(i).wager(j) = 0.5;
    elseif cell2mat(strfind(table2cell(me{1,i}(j,1)),'1 month'))
        meTrial(i).wager(j) = 1;
    elseif cell2mat(strfind(table2cell(me{1,i}(j,1)),'nothing'))
        meTrial(i).wager(j) = -1;

    end
    
end
end

for i =1:length(meTrial)
    if meTrial(i).risk == 0.5 & meTrial(i).pain == 3
    meTrial(i).ExRisk = 0.5;
    elseif meTrial(i).risk == 0.25 & meTrial(i).pain == 2
    meTrial(i).ExRisk = 0.5;
    else meTrial(i).ExRisk = 0.25;
    end
end




% loved

loved= loved(~cellfun('isempty',loved));
for i = 1:size(loved,2)
   x = loved(i);
   x{1,1}(1:2,:) = [];
   loved(i) = x;
end



lovedTrial = struct();

GambleL = 0;
SureL =  0;
NothingL =  0;

for i=1:size(loved,2)
    
if strfind(char(loved{i}.Properties.VariableNames),'25_Chance')
lovedTrial(i).risk = 0.25;
elseif strfind(char(loved{i}.Properties.VariableNames),'10_Chance')
lovedTrial(i).risk = 0.10;
elseif strfind(char(loved{i}.Properties.VariableNames),'5_Chance')
lovedTrial(i).risk = 0.05;
elseif strfind(char(loved{i}.Properties.VariableNames),'50_Chance')
lovedTrial(i).risk = 0.50;
end

if strfind(char(loved{i}.Properties.VariableNames),'Falling')
lovedTrial(i).pain = 2;
elseif strfind(char(loved{i}.Properties.VariableNames),'Dying')
lovedTrial(i).pain = 3;
end

for j = 1:height(loved{1,i})
    if cell2mat(strfind(table2cell(loved{1,i}(j,1)),'experimental'))
        gcount = 1;
        GambleL = GambleL + gcount;
        lovedTrial(i).choice(j) = 3;
    end
    if cell2mat(strfind(table2cell(loved{1,i}(j,1)),'but'))
        scount = 1;
        SureL = SureL + scount;
        lovedTrial(i).choice(j) = 2;
    end
    if cell2mat(strfind(table2cell(loved{1,i}(j,1)),'nothing'))
        ncount = 1;
        NothingL = NothingL + ncount;
        lovedTrial(i).choice(j) = 1;
    end
    
    if cell2mat(strfind(table2cell(loved{1,i}(j,1)),'halve'))
            lovedTrial(i).txRisk(j) = 0.5;
    elseif cell2mat(strfind(table2cell(loved{1,i}(j,1)),'75%'))
            lovedTrial(i).txRisk(j) = 0.25;
    else lovedTrial(i).txRisk(j) = 1;
    end
    

    
    if cell2mat(strfind(table2cell(loved{1,i}(j,1)),'tenth'))
        lovedTrial(i).wager(j) = 0.1;
    elseif cell2mat(strfind(table2cell(loved{1,i}(j,1)),'half'))
        lovedTrial(i).wager(j) = 0.5;
    elseif cell2mat(strfind(table2cell(loved{1,i}(j,1)),'1 month'))
        lovedTrial(i).wager(j) = 1;
    elseif cell2mat(strfind(table2cell(loved{1,i}(j,1)),'nothing'))
        lovedTrial(i).wager(j) = -1;

    end
    
end
end

for i =1:length(lovedTrial)
    if lovedTrial(i).risk == 0.5 & lovedTrial(i).pain == 3
    lovedTrial(i).ExRisk = 0.5;
    elseif lovedTrial(i).risk == 0.25 & lovedTrial(i).pain == 2
    lovedTrial(i).ExRisk = 0.5;
    else lovedTrial(i).ExRisk = 0.25;
    end
end
%other



other= other(~cellfun('isempty',other));
for i = 1:size(other,2)
   x = other(i);
   x{1,1}(1:2,:) = [];
   other(i) = x;
end

otherTrial = struct();

GambleO = 0;
SureO = 0;
NothingO=  0;

for i=1:size(other,2)
    
if strfind(char(other{i}.Properties.VariableNames),'25_Chance')
otherTrial(i).risk = 0.25;
elseif strfind(char(other{i}.Properties.VariableNames),'10_Chance')
otherTrial(i).risk = 0.10;
elseif strfind(char(other{i}.Properties.VariableNames),'5_Chance')
otherTrial(i).risk = 0.05;
elseif strfind(char(other{i}.Properties.VariableNames),'50_Chance')
otherTrial(i).risk = 0.50;
end

if strfind(char(other{i}.Properties.VariableNames),'Falling')
otherTrial(i).pain = 2;
elseif strfind(char(other{i}.Properties.VariableNames),'Dying')
otherTrial(i).pain = 3;
end

for j = 1:height(other{1,i})
    if cell2mat(strfind(table2cell(other{1,i}(j,1)),'experimental'))
        gcount = 1;
        GambleO = GambleO + gcount;
        otherTrial(i).choice(j) = 3;
    end
    if cell2mat(strfind(table2cell(other{1,i}(j,1)),'but'))
        scount = 1;
        SureO = SureO + scount;
        otherTrial(i).choice(j) = 2;
    end
    if cell2mat(strfind(table2cell(other{1,i}(j,1)),'nothing'))
        ncount = 1;
        NothingO = NothingO + ncount;
        otherTrial(i).choice(j) = 1;
    end
    
    if cell2mat(strfind(table2cell(other{1,i}(j,1)),'halve'))
            otherTrial(i).txRisk(j) = 0.5;
    elseif cell2mat(strfind(table2cell(other{1,i}(j,1)),'75%'))
            otherTrial(i).txRisk(j) = 0.25;
    else otherTrial(i).txRisk(j) = 1;
    end
    

    
    if cell2mat(strfind(table2cell(other{1,i}(j,1)),'tenth'))
        otherTrial(i).wager(j) = 0.1;
    elseif cell2mat(strfind(table2cell(other{1,i}(j,1)),'half'))
        otherTrial(i).wager(j) = 0.5;
    elseif cell2mat(strfind(table2cell(other{1,i}(j,1)),'1 month'))
        otherTrial(i).wager(j) = 1;
    elseif cell2mat(strfind(table2cell(other{1,i}(j,1)),'nothing'))
        otherTrial(i).wager(j) = -1;

    end
    
end
end

for i =1:length(otherTrial)
    if otherTrial(i).risk == 0.5 & otherTrial(i).pain == 3
    otherTrial(i).ExRisk = 0.5;
    elseif otherTrial(i).risk == 0.25 & otherTrial(i).pain == 2
    otherTrial(i).ExRisk = 0.5;
    else otherTrial(i).ExRisk = 0.25;
    end
end


decisions = [Nothing NothingL NothingO; Sure SureL SureO; Gamble GambleL GambleO];
figure
bar(decisions)
% ylim([0 12])
ax = gca;
ax.XTickLabel= ({'No Action', 'Sure choice', 'Gamble'});
legend('self','Close Other', 'Stranger')


for i = 1:length(otherTrial)
        o = otherTrial(i).wager;
        o = nonzeros(o);
        otherTrial(i).wager = o;
end

for i = 1:length(otherTrial)
        o = otherTrial(i).wager;
        o(o ==-1) = 0;
        otherTrial(i).wager = o;
end


for i = 1:length(lovedTrial)
        l = lovedTrial(i).wager;
        l = nonzeros(l);
        lovedTrial(i).wager = l;
end

for i = 1:length(lovedTrial)
        l = lovedTrial(i).wager;
        l(l ==-1) = 0;
        lovedTrial(i).wager = l;
end

for i = 1:length(meTrial)
        m = meTrial(i).wager;
        m = nonzeros(m);
        meTrial(i).wager = m;
end

for i = 1:length(meTrial)
        m = meTrial(i).wager;
        m(m ==-1) = 0;
        meTrial(i).wager = m;
end


for i = 1:length(meTrial)
    selfSpend(i) = sum(meTrial(i).wager);
end

for i = 1:length(lovedTrial)
    lovedSpend(i) = sum(lovedTrial(i).wager);
end

for i = 1:length(otherTrial)
    otherSpend(i) = sum(otherTrial(i).wager);
end

figure
bar([sum(selfSpend) sum(lovedSpend) sum(otherSpend)])
ax = gca;
ax.XTickLabel= ({'Self Costs', 'Close Other Costs', 'Stranger Costs'});

% otherTrial = otherTrial(1:4);

for i = 1:length(meTrial)
    
    meTrial(i).EV = meTrial(i).risk .* meTrial(i).pain;
    meTrial(i).EVS = meTrial(i).risk .* (meTrial(i).pain -1);
    meTrial(i).EVG =  (meTrial(i).risk .* meTrial(i).ExRisk) .* (meTrial(i).pain);
    meTrial(i).EV2 = [];
    meTrial(i).EV3 = [];   
    if ~isempty(meTrial(i).risk)
    for j = 1:length(meTrial(i).choice)
        if meTrial(i).choice(j) == 2
        meTrial(i).EV2(j) = meTrial(i).EVS;
        elseif meTrial(i).choice(j) == 3
        meTrial(i).EV2(j) = meTrial(i).EVG;
        elseif meTrial(i).choice(j) == 1
        meTrial(i).EV2(j) = meTrial(i).EV;
        end
        if meTrial(i).choice(j) == 2 
        meTrial(i).EV3(j) = meTrial(i).EVS + meTrial(i).wager(j);
        elseif meTrial(i).choice(j) == 3 
        meTrial(i).EV3(j) = meTrial(i).EVG + meTrial(i).wager(j);
        else
        meTrial(i).EV3(j) = meTrial(i).EV;
        end
        
    end  
    meTrial(i).EV2Mean = mean(meTrial(i).EV2);
    meTrial(i).EV3Mean = nanmean(meTrial(i).EV3);
    meEV(i) = meTrial(i).EV;
    meEV2(i) = meTrial(i).EV2Mean;
    meEV3(i) = meTrial(i).EV3Mean;
    end
end

meEVAll = sort([meEV' meEV2' meEV3']);
    

for i = 1:length(lovedTrial)
    lovedTrial(i).EV = lovedTrial(i).risk * lovedTrial(i).pain;
    lovedTrial(i).EVS = lovedTrial(i).risk * (lovedTrial(i).pain -1);
    lovedTrial(i).EVG =  (lovedTrial(i).risk * lovedTrial(i).ExRisk) * (lovedTrial(i).pain);
    lovedTrial(i).EV2 = [];
    lovedTrial(i).EV3 = [];  
    if ~isempty(lovedTrial(i).risk)
    for j = 1:length(lovedTrial(i).choice) 
        if lovedTrial(i).choice(j) == 2
        lovedTrial(i).EV2(j) = lovedTrial(i).EVS;
        elseif lovedTrial(i).choice(j) == 3 
        lovedTrial(i).EV2(j) = lovedTrial(i).EVG;
        elseif lovedTrial(i).choice(j) == 1
        lovedTrial(i).EV2(j) = lovedTrial(i).EV;
        end
        if lovedTrial(i).choice(j) == 2  
        lovedTrial(i).EV3(j) = lovedTrial(i).EVS + lovedTrial(i).wager(j);
        elseif lovedTrial(i).choice(j) == 3 
        lovedTrial(i).EV3(j) = lovedTrial(i).EVG + lovedTrial(i).wager(j);
        elseif lovedTrial(i).choice(j) == 1
        lovedTrial(i).EV3(j) = lovedTrial(i).EV;
        end
    end   
    lovedTrial(i).EV2Mean = nanmean(lovedTrial(i).EV2);
    lovedTrial(i).EV3Mean = nanmean(lovedTrial(i).EV3);
    lovedEV(i) = lovedTrial(i).EV;
    lovedEV2(i) = lovedTrial(i).EV2Mean;
    lovedEV3(i) = lovedTrial(i).EV3Mean;
    end   
end

lovedEVAll = sort([lovedEV' lovedEV2' lovedEV3']);


for i = 1:length(otherTrial)
    otherTrial(i).EV = otherTrial(i).risk * otherTrial(i).pain;
    otherTrial(i).EVS = otherTrial(i).risk * (otherTrial(i).pain -1);
    otherTrial(i).EVG =  (otherTrial(i).risk * otherTrial(i).ExRisk) * (otherTrial(i).pain);
    otherTrial(i).EV2 = []; 
    otherTrial(i).EV3 = [];
    if ~isempty(otherTrial(i).risk)
    for j = 1:length(otherTrial(i).choice)
        if otherTrial(i).choice(j) == 2
        otherTrial(i).EV2(j) = otherTrial(i).EVS;
        elseif otherTrial(i).choice(j) == 3
        otherTrial(i).EV2(j) = otherTrial(i).EVG ;
        elseif otherTrial(i).choice(j) == 1
        otherTrial(i).EV2(j) = otherTrial(i).EV;
        end
        if otherTrial(i).choice(j) == 2 
        otherTrial(i).EV3(j) = otherTrial(i).EVS + otherTrial(i).wager(j);
        elseif otherTrial(i).choice(j) == 3 
        otherTrial(i).EV3(j) = otherTrial(i).EVG + otherTrial(i).wager(j);
        elseif otherTrial(i).choice(j) == 1
        otherTrial(i).EV3(j) = otherTrial(i).EV;
        end
    end   
    otherTrial(i).EV2Mean = mean(otherTrial(i).EV2);
    otherTrial(i).EV3Mean = nanmean(otherTrial(i).EV3);
    otherEV(i) = otherTrial(i).EV;
    otherEV2(i) = otherTrial(i).EV2Mean;
    otherEV3(i) = otherTrial(i).EV3Mean;
    end
end


otherEVAll = sort([otherEV' otherEV2' otherEV3']);

meEVs = [meEV; meEV2]';
otherEVs = [otherEV; otherEV2]';
lovedEVs = [lovedEV; lovedEV2]';

uniqueEVs = unique(meEV);

for i = 1:length(meTrial)
meEV(i) = meTrial(i).EV;
meEV2(i) = mean(meTrial(i).EV2);
meEV3(i) = mean(meTrial(i).EV3);
end

for i = 1:length(lovedTrial)
lovedEV(i) = lovedTrial(i).EV;
lovedEV2(i) = mean(lovedTrial(i).EV2);
lovedEV3(i) = mean(lovedTrial(i).EV3);
end

for i = 1:length(otherTrial)
otherEV(i) = otherTrial(i).EV;
otherEV2(i) = mean(otherTrial(i).EV2);
otherEV3(i) = mean(otherTrial(i).EV3);
end

for i = 1:length(uniqueEVs)
meanMeEV2(i) = mean(meEV2(meEV ==uniqueEVs(i)));
meanlovedEV2(i) = mean(lovedEV2(lovedEV ==uniqueEVs(i)));
meanotherEV2(i) = mean(otherEV2(otherEV ==uniqueEVs(i)));
end

for i = 1:length(uniqueEVs)
meanMeEV3(i) = mean(meEV3(meEV ==uniqueEVs(i)));
meanlovedEV3(i) = mean(lovedEV3(lovedEV ==uniqueEVs(i)));
meanotherEV3(i) = mean(otherEV3(otherEV ==uniqueEVs(i)));
end

figure
plot(meEVAll(:,3))
hold on
plot(lovedEVAll(:,3))
hold on
plot (otherEVAll(:,3))
legend('me EV3', 'loved EV3', 'other EV3')

canonicalEV_Gamble = [0.05 * 0.25 * 3; 0.1 * 0.25 * 2; 0.25 * 0.5 * 2; 0.25 * 0.25 * 3; 0.5 * 0.25 * 2; 0.5 * 0.5 * 3];
canonicalEV_Sure = [0.05 *  2; 0.1 *  1;  0.25 * 1;  0.25 * 2; 0.5 * 1; 0.5 * 2];


figure
plot(uniqueEVs,canonicalEV_Sure)
hold on
plot(uniqueEVs,canonicalEV_Gamble)
hold on
plot(uniqueEVs,meanMeEV2)
hold on
plot(uniqueEVs,meanlovedEV2)
hold on
plot (uniqueEVs,meanotherEV2)
legend('EV Sure', 'EV Gamble', 'Self', 'Loved One', 'Stranger')

% meanMeAUC = trapz(1:4,meanMeEV2);
% meanLovedAUC = trapz(1:4,meanlovedEV2);
% meanOtherAUC = trapz(1:4,meanotherEV2);
% meanEVAUC = trapz(1:4,uniqueEVs);

EVs = sort(unique(meEV));

RSGamble = zeros(length(EVs),1);
RSSure= zeros(length(EVs),1);

for i = 1:length(meTrial)
    act(i) = length(meTrial(i).choice(meTrial(i).choice ==3 | meTrial(i).choice ==2))
    if meTrial(i).EV == EVs(1)
        RSGamble(1) = length(meTrial(i).choice(meTrial(i).choice ==3))/act(i);
        RSSure(1) = length(meTrial(i).choice(meTrial(i).choice ==2))/act(i);
    elseif meTrial(i).EV == EVs(2)
        RSGamble(2) = length(meTrial(i).choice(meTrial(i).choice ==3))/act(i);
        RSSure(2) = length(meTrial(i).choice(meTrial(i).choice ==2))/act(i);
    elseif meTrial(i).EV == EVs(3)
        RSGamble(3) = length(meTrial(i).choice(meTrial(i).choice ==3))/act(i);
        RSSure(3) = length(meTrial(i).choice(meTrial(i).choice ==2))/act(i);
    elseif meTrial(i).EV == EVs(4)
        RSGamble(4) = length(meTrial(i).choice(meTrial(i).choice ==3))/act(i);
        RSSure(4) = length(meTrial(i).choice(meTrial(i).choice ==2))/act(i);
     elseif meTrial(i).EV == EVs(5)
        RSGamble(5) = length(meTrial(i).choice(meTrial(i).choice ==3))/act(i);
        RSSure(5) = length(meTrial(i).choice(meTrial(i).choice ==2))/act(i);
      elseif meTrial(i).EV == EVs(6)
        RSGamble(6) = length(meTrial(i).choice(meTrial(i).choice ==3))/act(i);
        RSSure(6) = length(meTrial(i).choice(meTrial(i).choice ==2))/act(i);
    end
end
        


RLGamble = zeros(length(EVs),1);
RLSure = zeros(length(EVs),1);
for i = 1:length(lovedTrial)
    act(i) = length(lovedTrial(i).choice(lovedTrial(i).choice ==3 | lovedTrial(i).choice ==2))
    if lovedTrial(i).EV == EVs(1)
        RLGamble(1) = length(lovedTrial(i).choice(lovedTrial(i).choice ==3))/act(i);
        RLSure(1) = length(lovedTrial(i).choice(lovedTrial(i).choice ==2))/act(i);
    elseif lovedTrial(i).EV == EVs(2)
        RLGamble(2) = length(lovedTrial(i).choice(lovedTrial(i).choice ==3))/act(i);
        RLSure(2) = length(lovedTrial(i).choice(lovedTrial(i).choice ==2))/act(i);
    elseif lovedTrial(i).EV == EVs(3)
        RLGamble(3) = length(lovedTrial(i).choice(lovedTrial(i).choice ==3))/act(i);
        RLSure(3) = length(lovedTrial(i).choice(lovedTrial(i).choice ==2))/act(i);
    elseif lovedTrial(i).EV == EVs(4)
        RLGamble(4) = length(lovedTrial(i).choice(lovedTrial(i).choice ==3))/act(i);
        RLSure(4) = length(lovedTrial(i).choice(lovedTrial(i).choice ==2))/act(i);
    elseif lovedTrial(i).EV == EVs(5)
        RLGamble(5) = length(lovedTrial(i).choice(lovedTrial(i).choice ==3))/act(i);
        RLSure(5) = length(lovedTrial(i).choice(lovedTrial(i).choice ==2))/act(i);
    elseif lovedTrial(i).EV == EVs(6)
        RLGamble(6) = length(lovedTrial(i).choice(lovedTrial(i).choice ==3))/act(i);
        RLSure(6) = length(lovedTrial(i).choice(lovedTrial(i).choice ==2))/act(i);
    end
end
       

ROGamble = zeros(length(EVs),1);
ROSure = zeros(length(EVs),1);

for i = 1:length(otherTrial)
    act(i) = length(otherTrial(i).choice(otherTrial(i).choice ==3 | otherTrial(i).choice ==2))
    if otherTrial(i).EV == EVs(1)
        ROGamble(1) = length(otherTrial(i).choice(otherTrial(i).choice ==3))/act(i);
        ROSure(1) = length(otherTrial(i).choice(otherTrial(i).choice ==2))/act(i);
    elseif otherTrial(i).EV == EVs(2)
        ROGamble(2) = length(otherTrial(i).choice(otherTrial(i).choice ==3))/act(i);
        ROSure(2) = length(otherTrial(i).choice(otherTrial(i).choice ==2))/act(i);
    elseif otherTrial(i).EV == EVs(3)
        ROGamble(3) = length(otherTrial(i).choice(otherTrial(i).choice ==3))/act(i);
        ROSure(3) = length(otherTrial(i).choice(otherTrial(i).choice ==2))/act(i);
    elseif otherTrial(i).EV == EVs(4)
        ROGamble(4) = length(otherTrial(i).choice(otherTrial(i).choice ==3))/act(i);
        ROSure(4) = length(otherTrial(i).choice(otherTrial(i).choice ==2))/act(i);
     elseif otherTrial(i).EV == EVs(5)
        ROGamble(5) = length(otherTrial(i).choice(otherTrial(i).choice ==3))/act(i);
        ROSure(5) = length(otherTrial(i).choice(otherTrial(i).choice ==2))/act(i);
     elseif otherTrial(i).EV == EVs(6)
        ROGamble(6) = length(otherTrial(i).choice(otherTrial(i).choice ==3))/act(i);
        ROSure(6) = length(otherTrial(i).choice(otherTrial(i).choice ==2))/act(i);
    end
end
     

figure
stacks = [RSGamble RSSure RLGamble RLSure ROGamble ROSure];
bar(stacks)
legend('Self Gamble','Self Sure',  'Loved One Gamble','Loved One Sure', 'Stranger Gamble', 'Stranger Sure','location', 'northeastoutside')
ax.XTickLabel= ({'5% dead', '10% sick', '25% sick', '25% dead', '50% sick',  '50% dead'});
% % ylim([0 1.2])





figure
subplot(3,1,1)
plot(canonicalEV_Gamble)
hold on
plot(canonicalEV_Sure)
hold on 
plot(uniqueEVs)
hold on
plot(meanMeEV2)

subplot(3,1,2)
plot(canonicalEV_Gamble)
hold on
plot(canonicalEV_Sure)
hold on 
plot(uniqueEVs)
hold on
plot(meanlovedEV2)

subplot(3,1,3)
plot(canonicalEV_Gamble)
hold on
plot(canonicalEV_Sure)
hold on 
plot(uniqueEVs)
hold on
plot(meanotherEV2)
