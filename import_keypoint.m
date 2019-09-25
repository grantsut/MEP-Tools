%% Import Keypoint
fn = 'M1--APB__';
extracts = zeros(17,4800);
for i = 1:17
    extracts(i,:) = importdata(sprintf([fn '%03u.txt'],i));
end
%% Plot one MEP
idx = 10;
sl = 1/48000;
t = sl:sl:0.1;
plot(t,extracts(idx,:))
offset = 100;
[M,I] = max(extracts(idx,offset+1:end));
hold on
scatter(t(I+offset),extracts(idx,I+offset),'*')
hold off
%% Extract MEP peaks and times from a range
idx = 8:17; % 50% intensity (threshold)
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
title('Keypoint MEPs')
%% Peak times with threshold
threshold = 50;
mnlatency = mean(peaktimes(M>threshold));
stdlatency = std(peaktimes(M>threshold));
fprintf('Mean latency to peak = %.5f (+/-%.5f) \n',mnlatency,stdlatency);