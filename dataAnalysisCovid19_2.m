clear; clc;
close all


% % 
% fid = fopen('results-survey191459-28.csv', 'r');
% % fid = fopen('results-survey596661-5.csv', 'r');
% str = fgetl(fid);
% fclose(fid);
% vars = regexp(str, '",', 'split');
% if isempty(vars(end))
%   vars = vars(1:end-1);
% end
% x = vars{1};
% vars{1} = x(4:end);
% chars = ['?',')',''''];
% 
% for i =1:length(vars)
%     x = vars{i};
%     x = [x '"'];
%     x = strrep(x, '(', '_');
%     x = strrep(x, ',', '_');
%     vars{i} = x;
% end
% 
% prelimRes = readtable('results-survey191459-28.csv','delimiter', ',', 'headerlines', 1, 'readvariablenames', false);
% prelimRes = prelimRes(:,1:end-4);
% %prelimRes.Properties.VariableNames = vars;
% prelimRes = [vars; prelimRes];
prelimRes = readtable('results-survey834531-3_22062020.xlsx');
prelimRes = prelimRes(prelimRes.lastpage_LastPage > 18,:);

dates = datetime(prelimRes.submitdate_DateSubmitted, 'ConvertFrom', 'datenum');
dates.Year = 2020;
dates.Format = 'yyyy-MM-dd'
curr = prelimRes.Curr_WhatCurrencyDoYouUse_;

for i = 2:length(dates)
    if isnat(dates(i))
        dates(i) = dates(i-1)
    end
end



% rates = exchangerateLK(dates, curr);
load 'Forex20200620.mat'


me = {};
loved = {};
other = {};
cost = {};

% for i=1:size(prelimRes,2)
% if strfind(char(prelimRes.Properties.VariableNames(i)),'YouHave')
% me{i} = prelimRes(:,i);
% elseif strfind(char(prelimRes.Properties.VariableNames(i)),'Someone')
% other{i} = prelimRes(:,i);    
% elseif strfind(char(prelimRes.Properties.VariableNames(i)),'Loved')
% loved{i} = prelimRes(:,i);    
% end
% end
 
for i=20:55
expression = 'YouHaveA';
if regexp(char(prelimRes.Properties.VariableNames(i)),expression) 
me{i} = prelimRes(1:end,i);
end
end

for i=20:55
expression = 'YourLovedOne';
if strfind(char(prelimRes.Properties.VariableNames(i)), expression)
other{i} = prelimRes(1:end,i);  
end
end

for i=20:55
expression = 'SomeoneYouDon';
if strfind(char(prelimRes.Properties.VariableNames(i)), expression)
loved{i} = prelimRes(1:end,i);    
end
end

for i=20:55
expression = 'HowMuchWouldYouPay';
if strfind(char(prelimRes.Properties.VariableNames(i)), expression)
cost{i} = prelimRes(1:end,i);    
end
end


cost = cost(~cellfun('isempty',cost));

for j=1:length(cost)
    cost{j}.Variables = cost{j}.Variables .*rates';
end

%If using only those 4...
% for i = 1:length(cost)
%     for j = 1:4
%     y = cost{1,i};
%     if ~isnan(cell2mat(table2cell(y(j,1)))) & j == 3
%         x = cell2mat(table2cell(cost{1,i}(j,1)))/100
%         cost{1,i}(j,1) = {x};
%     end
%     end
% end

cost2 = table();
for i = 1:size(cost,2)
    cost2 = [cost2 cost{1,i}];
end

costMe = {};
costOther = {};
costLoved = {};

for i=1:width(cost2)
expression = 'L*';
if regexp(char(cost2(1,i).Properties.VariableNames), expression)
costMe{i} = cost2(1:end,i);    
end
end

costMe = costMe(~cellfun('isempty',costMe));
costMe2 = table();
for i = 1:size(costMe,2)
    costMe2 = [costMe2 costMe{1,i}];
end

costMe2All = nansum(nansum(table2array(costMe2)));
sRisk = table2array(costMe2);
sSure = table2array(costMe2);
costMe2Sure = nansum(nansum(sSure(1:2:end-1)));
costMe2Risk = nansum(nansum(sRisk(2:2:end)));

for i=1:width(cost2)
expression = 'D*';
if regexp(char(cost2(1,i).Properties.VariableNames), expression)
costOther{i} = cost2(1:end,i);    
end
end

costOther = costOther(~cellfun('isempty',costOther));

costOther2 = table();
for i = 1:size(costOther,2)
    costOther2 = [costOther2 costOther{1,i}];
end

costOther2All = nansum(nansum(table2array(costOther2)));
oRisk = table2array(costOther2);
oSure = table2array(costOther2);
costOther2Sure = nansum(nansum(oSure(1:2:end-1)));
costOther2Risk = nansum(nansum(oRisk(2:2:end)));

for i=1:width(cost2)
expression = 'C*';
if regexp(char(cost2(1,i).Properties.VariableNames), expression)
costLoved{i} = cost2(1:end,i);    
end
end

costLoved = costLoved(~cellfun('isempty',costLoved));

costLoved2 = table();
for i = 1:size(costLoved,2)
    costLoved2 = [costLoved2 costLoved{1,i}];
end

costLoved2All = nansum(nansum(table2array(costLoved2)));
lRisk = table2array(costLoved2);
lSure = table2array(costLoved2);
costLoved2Sure = nansum(nansum(lSure(1:2:end-1)));
costLoved2Risk = nansum(nansum(lRisk(2:2:end)));


figure
bar([costMe2Risk costLoved2Risk costOther2Risk; costMe2Sure costLoved2Sure costOther2Sure])
ax = gca;
ax.XTickLabel= ({'Risky Costs', 'Sure Costs'});
legend('self','Close Other', 'Stranger')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
me = me(~cellfun('isempty',me));
loved = loved(~cellfun('isempty',loved));
other = other(~cellfun('isempty',other));




% for i = 1:size(me,2)
%    x = me(i);
%    x{1,1}(1:2,:) = [];
%    me(i) = x;
% end

meTrial = struct();


Gamble = 0;
Sure = 0;
Nothing =  0;

me2 = table();
for i = 1:size(me,2)
    me2 = [me2 me{1,i}];
end

    
for i = 1:size(me2,2)    
    
    if ~isempty(strfind(me2.Properties.VariableNames{i},'25_Chance'))
    meTrial(i).risk = 0.25;
    elseif ~isempty(strfind(me2.Properties.VariableNames{i},'10_Chance'))
    meTrial(i).risk = 0.10;
    elseif ~isempty(strfind(me2.Properties.VariableNames{i},'5_Chance'))
    meTrial(i).risk = 0.05;
    elseif ~isempty(strfind(me2.Properties.VariableNames{i},'50_Chance'))
    meTrial(i).risk = 0.5;
    end

    if ~isempty(strfind(me2.Properties.VariableNames{i},'Falling'))
    meTrial(i).pain = 2;
    elseif ~isempty(strfind(me2.Properties.VariableNames{i},'Dying'))
    meTrial(i).pain = 3;
    end

    for j = 1:height(me{1,i})
    if cell2mat(strfind(table2cell(me{1,i}(j,1)),'halve'))
            meTrial(i).txRisk(j) = 0.5;
    elseif cell2mat(strfind(table2cell(me{1,i}(j,1)),'75%'))
            meTrial(i).txRisk(j) = 0.25;
    else 
        meTrial(i).txRisk(j) = 1;
    end
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
    end  
end



% loved


% for i = 1:size(loved,2)
%    x = loved(i);
%    x{1,1}(1:2,:) = [];
%    loved(i) = x;
% end

lovedTrial = struct();


GambleL = 0;
SureL = 0;
NothingL =  0;

loved2 = table();
for i = 1:size(loved,2)
    loved2 = [loved2 loved{1,i}];
end

    
for i = 1:size(loved2,2)    
if ~isempty(strfind(loved2.Properties.VariableNames{i},'25_Chance'))
lovedTrial(i).risk = 0.25;
elseif ~isempty(strfind(loved2.Properties.VariableNames{i},'10_Chance'))
lovedTrial(i).risk = 0.10;
elseif ~isempty(strfind(loved2.Properties.VariableNames{i},'5_Chance'))
lovedTrial(i).risk = 0.05;
elseif ~isempty(strfind(loved2.Properties.VariableNames{i},'50_Chance'))
lovedTrial(i).risk = 0.5;
end

if ~isempty(strfind(loved2.Properties.VariableNames{i},'Falling'))
lovedTrial(i).pain = 2;
elseif ~isempty(strfind(loved2.Properties.VariableNames{i},'Dying'))
lovedTrial(i).pain = 3;
end

    for j = 1:height(loved{1,i})
    if cell2mat(strfind(table2cell(loved{1,i}(j,1)),'halve'))
            lovedTrial(i).txRisk(j) = 0.5;
    elseif cell2mat(strfind(table2cell(me{1,i}(j,1)),'75%'))
            lovedTrial(i).txRisk(j) = 0.25;
    else lovedTrial(i).txRisk(j) = 1;
    end
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

end
end


%other

other = other(~cellfun('isempty',other));
% for i = 1:size(other,2)
%    x = other(i);
%    x{1,1}(1:2,:) = [];
%    other(i) = x;
% end

otherTrial = struct();


GambleO = 0;
SureO = 0;
NothingO =  0;

other2 = table();
for i = 1:size(other,2)
    other2 = [other2 other{1,i}];
end

    
for i = 1:size(other,2)    
if ~isempty(strfind(other2.Properties.VariableNames{i},'25_Chance'))
otherTrial(i).risk = 0.25;
elseif ~isempty(strfind(other2.Properties.VariableNames{i},'10_Chance'))
otherTrial(i).risk = 0.10;
elseif ~isempty(strfind(other2.Properties.VariableNames{i},'5_Chance'))
otherTrial(i).risk = 0.05;
elseif ~isempty(strfind(other2.Properties.VariableNames{i},'50_Chance'))
otherTrial(i).risk = 0.5;
end

if ~isempty(strfind(other2.Properties.VariableNames{i},'Falling'))
otherTrial(i).pain = 2;
elseif ~isempty(strfind(other2.Properties.VariableNames{i},'Dying'))
otherTrial(i).pain = 3;
end

    for j = 1:height(other{1,i})
    if cell2mat(strfind(table2cell(other{1,i}(j,1)),'halve'))
            otherTrial(i).txRisk(j) = 0.5;
    elseif cell2mat(strfind(table2cell(other{1,i}(j,1)),'75%'))
            otherTrial(i).txRisk(j) = 0.25;
    else 
        otherTrial(i).txRisk(j) = 1;
    end
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

end
end


% other


decisions = [Sure SureL SureO; Gamble GambleL GambleO];
figure
bar(decisions)
ax = gca;
% ylim ([0 15])
ax.XTickLabel= ({'Sure choice', 'Gamble'});
legend('self','Close Other', 'Stranger')


% meTrial = meTrial(1:4);
% lovedTrial = lovedTrial(1:4);
% otherTrial = otherTrial(1:4);

for i = 1:length(meTrial)
    
    meTrial(i).EV = meTrial(i).risk .* meTrial(i).pain;
    meTrial(i).EV2 = [];
    meTrial(i).EV3 = [];   
    if ~isempty(meTrial(i).risk)
    for j = 1:length(meTrial(i).choice)
        if meTrial(i).choice(j) == 2
        meTrial(i).EV2(j) = meTrial(i).risk .* (meTrial(i).pain -1);
        elseif meTrial(i).choice(j) == 3
        meTrial(i).EV2(j) = (meTrial(i).risk * meTrial(i).txRisk(j)) .* (meTrial(i).pain);
%         elseif meTrial(i).choice(j) == 1
%         meTrial(i).EV2(j) = meTrial(i).EV;
        end
        if meTrial(i).choice(j) == 2 & ~isempty(sSure(j,i))
        meTrial(i).EV3(j) = (meTrial(i).risk .* (meTrial(i).pain -1)) + sSure(j,i)
        elseif meTrial(i).choice(j) == 3 & ~isempty(sRisk(j,i))
        meTrial(i).EV3(j) = ((meTrial(i).risk * meTrial(i).txRisk(j)) .* (meTrial(i).pain)) + (sSure(j,i));
        elseif meTrial(i).choice(j) == 3 & isempty(sRisk(j,i)) 
        meTrial(i).EV3(j) = meTrial(i).EV;
        elseif meTrial(i).choice(j) == 3 & isempty(sSure(j,i)) 
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
    lovedTrial(i).EV = lovedTrial(i).risk .* lovedTrial(i).pain;
    lovedTrial(i).EV2 = [];
    lovedTrial(i).EV3 = [];  
    if ~isempty(lovedTrial(i).risk)
    for j = 1:length(lovedTrial(i).choice) 
        if lovedTrial(i).choice(j) == 2
        lovedTrial(i).EV2(j) = lovedTrial(i).risk .* (lovedTrial(i).pain -1);
        elseif lovedTrial(i).choice(j) == 3 &   ~isempty(lovedTrial(i).txRisk)
        lovedTrial(i).EV2(j) = (lovedTrial(i).risk * lovedTrial(i).txRisk(j)) .* (lovedTrial(i).pain);
        elseif lovedTrial(i).choice(j) == 1
        lovedTrial(i).EV2(j) = lovedTrial(i).EV;
        end
        if lovedTrial(i).choice(j) == 2  & ~isempty(lSure(j,i))
        lovedTrial(i).EV3(j) = (lovedTrial(i).risk .* (lovedTrial(i).pain -1)) + lSure(j,i)
        elseif lovedTrial(i).choice(j) == 3 & ~isempty(lRisk(j,i)) & ~isempty(lovedTrial(i).txRisk)
        lovedTrial(i).EV3(j) = ((lovedTrial(i).risk * lovedTrial(i).txRisk(j)) .* (lovedTrial(i).pain)) + lRisk(j,i);
        elseif lovedTrial(i).choice(j) == 1
        lovedTrial(i).EV3(j) = lovedTrial(i).EV;
        end
    end   
    lovedTrial(i).EV2Mean = mean(lovedTrial(i).EV2);
    lovedTrial(i).EV3Mean = nanmean(lovedTrial(i).EV3);
    lovedEV(i) = lovedTrial(i).EV;
    lovedEV2(i) = lovedTrial(i).EV2Mean;
    lovedEV3(i) = lovedTrial(i).EV3Mean;
    end   
end

lovedEVAll = sort([lovedEV' lovedEV2' lovedEV3']);


for i = 1:length(otherTrial)
    otherTrial(i).EV = otherTrial(i).risk .* otherTrial(i).pain;
    otherTrial(i).EV2 = []; 
    otherTrial(i).EV3 = [];
    if ~isempty(otherTrial(i).risk)
    for j = 1:length(otherTrial(i).choice)
        if otherTrial(i).choice(j) == 2
        otherTrial(i).EV2(j) = otherTrial(i).risk .* (otherTrial(i).pain -1);
        elseif otherTrial(i).choice(j) == 3
        otherTrial(i).EV2(j) = (otherTrial(i).risk * otherTrial(i).txRisk(j)) .* (otherTrial(i).pain);
        elseif otherTrial(i).choice(j) == 1
        otherTrial(i).EV2(j) = otherTrial(i).EV;
        end
        if otherTrial(i).choice(j) == 2 & ~isempty(oSure(j,i))
        otherTrial(i).EV3(j) = (otherTrial(i).risk .* (otherTrial(i).pain -1)) + oSure(j,i);
        elseif otherTrial(i).choice(j) == 3  & ~isempty(oRisk(j,i))
        otherTrial(i).EV3(j) = ((otherTrial(i).risk * otherTrial(i).txRisk(j)) .* (otherTrial(i).pain)) + oRisk(j,i);
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

for i = 1:length(uniqueEVs)
meanMeEV2(i) = mean(meEVAll(meEVAll(:,1) == uniqueEVs(i),2));
meanlovedEV2(i) = mean(lovedEVAll(lovedEVAll(:,1) == uniqueEVs(i),2));
meanotherEV2(i) = mean(otherEVAll(otherEVAll(:,1) == uniqueEVs(i),2));
end

for i = 1:length(uniqueEVs)
meanMeEV3(i) = mean(meEVAll(meEVAll(:,1) == uniqueEVs(i),3));
meanlovedEV3(i) = mean(lovedEVAll(lovedEVAll(:,1) == uniqueEVs(i),3));
meanotherEV3(i) = mean(otherEVAll(otherEVAll(:,1) == uniqueEVs(i),3));
end

figure
plot(meEVAll(:,3))
hold on
plot(lovedEVAll(:,3))
hold on
plot (otherEVAll(:,3))
legend('me EV3', 'loved EV3', 'other EV3')

figure
plot(uniqueEVs)
hold on
plot(meanMeEV2)
hold on
plot(meanlovedEV2)
hold on
plot (meanotherEV2)
legend('EV', 'Self', 'Loved One', 'Stranger')

meanMeAUC = trapz(1:4,meanMeEV2);
meanLovedAUC = trapz(1:4,meanlovedEV2);
meanOtherAUC = trapz(1:4,meanotherEV2);
meanEVAUC = trapz(1:4,uniqueEVs);

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
    
    end
end
     
     

figure
stacks = [RSGamble RSSure RLGamble RLSure ROGamble ROSure];
bar(stacks)
legend('Self Gamble','Self Sure',  'Loved One Gamble','Loved One Sure', 'Stranger Gamble', 'Stranger Sure','location', 'northeastoutside')
ax = gca;
ax.XTickLabel= ({'5% dead', '10% sick', '25% dead', '50% sick'});
% ylim([0 1.2])

