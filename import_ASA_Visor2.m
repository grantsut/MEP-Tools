%%
clear
filedir = 'D:\MATLAB\MEPcompare\20190308_1451 ASA 2hz filter';
filename1 = '20190308_1451-emgfhp.cnt';
filestring = fullfile(filedir,filename1);
info = eepv4_read_info(filestring);
dat = read_eep_cnt(filestring,1,info.sample_count);
filename2 = '20190308_1451-emgfhp.trg';
filestring = fullfile(filedir,filename2);
trg = read_eep_trg(filestring);
% plot(dat.time,dat.data)
%% Extract MEPs
extractlen = round(0.1*dat.rate);
extracts = zeros(length(dat.triggers),extractlen);
for i = 1:length(dat.triggers)
    offsettmp = dat.triggers(i).offset;
    extracts(i,:) = dat.data(offsettmp+1:(offsettmp+extractlen));
end
extracts = -extracts;
% plot(extracts(2,:))
plot(extracts(2:end,:)','DisplayName','extracts(2:end,:)')
%% Plot one MEP
idx = 39;
sl = 1/dat.rate;
% t = sl:sl:0.1+sl;
t = sl:sl:0.1+sl;
plot(t,extracts(idx,:))
offset = 10;
[M,I] = max(extracts(idx,offset+1:end));
hold on
scatter(t(I+offset),extracts(idx,I+offset),'*')
hold off
%% Extract MEP peaks and times from a range
idx = 38:47; % 48% intensity (threshold)
% idx = 28:37; % 49% intensity (maybe also 48%)
% idx = 18:27; % 50% intensity
[M,I] = max(extracts(idx,offset+1:end),[],2);
peaktimes = zeros(length(I),1);
for i = 1:length(I)
    peaktimes(i) = t(I(i)+offset);
end
%% Plot range of MEPs
plot(t,extracts(idx,:))
hold on
scatter(peaktimes,M,'*')
hold off
ylim([-300,300])
xlim([0,0.1])
title('Visor MEPs')
%% Peak times with threshold
threshold = 50;
mnlatency = mean(peaktimes(M>threshold));
stdlatency = std(peaktimes(M>threshold));
fprintf('Mean latency to peak = %.5f (+/-%.5f) \n',mnlatency,stdlatency);
%% Quick t test for latency times at threshold
vislats = [0.0283203125000000;0.0288085937500000;0.0297851562500000;0.0292968750000000;0.0292968750000000];
% vislats = vislats - sl;
keylats = [0.0278333333333333;0.0288125000000000;0.0279583333333333;0.0283541666666667;0.0281041666666667;0.0287083333333333;0.0281458333333333;0.0279791666666667];
keylats = keylats + 1/48000; % Adjustment in case recording starts after the trigger rather than with it
[h,p] = ttest2(vislats,keylats);
groups = ones(length([vislats;keylats]),1);
groups(1:length(vislats))=0;
figure(3)
boxplot([vislats;keylats],groups)
ylabel('latencies (s)')
ax = gca;
ax.XTickLabel= {'Visor2','Keypoint'};

%% Quick t test for amplitudes with threshold
vislats = [152.289996596319;282.819993678973;72.3999983818600;90.2299979833595;175.809996070647];
keylats = [183;132.600000000000;66.4100000000000;146.900000000000;90.9100000000000;118.300000000000;250.200000000000;84.5000000000000];
[h,p] = ttest2(vislats,keylats);
groups = ones(length([vislats;keylats]),1);
groups(1:length(vislats))=0;
figure(3)
boxplot([vislats;keylats],groups)
ylabel('amplitudes (uV)')
ax = gca;
ax.XTickLabel= {'Visor2','Keypoint'};
