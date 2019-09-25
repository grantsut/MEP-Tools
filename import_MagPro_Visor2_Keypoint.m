%% Import MagPro data
clear
filedir = 'D:\MATLAB\MEP-Tools\GrantMagProMeps';
filename = 'MEP Data (3-6).csv';
% Number of MEPs in the file. MagProImport will crash if too many are specified

filestring = fullfile(filedir,filename);

[traw,meps] = MagProImport(filestring);

% meps = meps';
t  = traw / 1000; % Convert time to milleseconds
% t = t';
%% Import Visor2 data
clear
filedir = 'D:\MATLAB\MEP-Tools\GrantVisorMEPs';
filename = '20190806_1124-emgfbpfbs.cnt';
filestring = fullfile(filedir,filename);
info = eepv4_read_info(filestring);
dat = read_eep_cnt(filestring,1,info.sample_count);
fn2 = '20190806_1124-emgfbpfbs.trg';
trg = read_eep_trg(fn2);
sl = 1/dat.rate;
% t = sl:sl:0.1+sl;
traw = sl:sl:0.1+sl;
t = traw * 1000;
% Extract MEPs
extractlen = round(0.1*dat.rate);
extracts = zeros(length(dat.triggers),extractlen);
for i = 1:length(dat.triggers)
    offsettmp = dat.triggers(i).offset;
    extracts(i,:) = dat.data(offsettmp+1:(offsettmp+extractlen));
end
meps = extracts;

%% Import Keypoint
clear
filedir = 'D:\MATLAB\MEP-Tools\test_001_x_No_Name\MEP_Cortical_Spinal\Medianus\Right';
filename = 'M1--APB__';
samplerate = 48000;

fntmp = fullfile(filedir,filename);
fn = strrep(fntmp, '\', '\\'); % This removes any accidental excape characters from the file name string.

extracts = zeros(17,samplerate/10);
for i = 1:17
    extracts(i,:) = importdata(sprintf([fn '%03u.txt'],i));
end
meps = extracts;
sl = 1/samplerate;
t = sl:sl:0.1;

%% Plot single MEP from imported MagPro or Visor2 data. Optionally save trace to a directory
savedir = 'D:\MATLAB\MEPcompare\GrantVisorMEPs\extracted'; % Name of directory in file directory for saved files
% savedir = 'D:\MATLAB\MEPcompare\GrantMagProMeps\extracted'; % Name of directory in file directory for saved files
savefile = false;
filenameprefix = 'GrantVisorMEP_';
idx = 2; % Index of the MEP to be displayed
pkdelay = 3; % (ms) Find peak this long after the start of the trace (for ignoring TMS artifacts)

pkoffset = find(t>pkdelay, 1 ); % (ms) Only look for peaks this long after the trigger

mep = meps(idx,:);

[pkval,pkidx] = max(mep(pkoffset+1:end));

plot(t,mep)
hold on
scatter(t(pkidx+pkoffset),mep(pkidx+pkoffset),'*')
hold off

% Save current MEP
if savefile
    if ~exist(savedir,'dir')
        mkdir(savedir)
    end
    save(fullfile(savedir,[filenameprefix num2str(idx)]),'mep','t')
end

%% Load all the saved MEPs from a directory and place them in a single variable
% Loads all files without checking, so be careful
% basedir = 'D:\MATLAB\MEPcompare\GrantVisorMEPs\extracted';
basedir = 'D:\MATLAB\MEPcompare\GrantMagProMEPs\extracted';
dirstruct = dir(basedir);
mepstore = [];
tstore = [];
for i = 1:length(dirstruct)
    if ~dirstruct(i).isdir
        load(fullfile(basedir,dirstruct(i).name));
        mepstore = vertcat(mepstore,mep);
        tstore = vertcat(tstore,t);
    end
end
mepstore = mepstore;
t = tstore(1,:);
%% Extract MEP peaks and times
% This takes input from the cell above
pkdelay = 3; % (ms) Find peak this long after the start of the trace (for ignoring TMS artifacts)
pkoffset = find(t>pkdelay, 1 ); % (ms) Only look for peaks this long after the trigger
[M,I] = max(mepstore(:,pkoffset+1:end),[],2);
peaktimes = zeros(length(I),1);
for i = 1:length(I)
    peaktimes(i) = t(I(i)+pkoffset);
end
% Plot MEPs and peaks
plot(t,mepstore(:,:))
hold on
scatter(peaktimes,M,'*')
hold off
ylim([-400,400])
xlim([0,50])
title('MagPro MEPs')

%% Load and plot mean or median signals from two sets
% Loads all files without checking, so be careful
basedir = 'D:\MATLAB\MEPcompare\GrantVisorMEPs\extracted';
dirstruct = dir(basedir);
mepstore = [];
tstore = [];
for i = 1:length(dirstruct)
    if ~dirstruct(i).isdir
        load(fullfile(basedir,dirstruct(i).name));
        mepstore = vertcat(mepstore,mep);
        tstore = vertcat(tstore,t);
    end
end
mepstoreVisor2 = mepstore;
tVisor2 = tstore(1,:);

basedir = 'D:\MATLAB\MEPcompare\GrantMagProMEPs\extracted';
dirstruct = dir(basedir);
mepstore = [];
tstore = [];
for i = 1:length(dirstruct)
    if ~dirstruct(i).isdir
        load(fullfile(basedir,dirstruct(i).name));
        mepstore = vertcat(mepstore,mep);
        tstore = vertcat(tstore,t);
    end
end
mepstoreMagPro = mepstore;
tMagPro = tstore(1,:);

% Plot MEPs and peaks
clf
hold on
plot(tVisor2,mean(mepstoreVisor2(:,:),1),'DisplayName','Visor2')
plot(tMagPro,mean(mepstoreMagPro(:,:),1),'DisplayName','MagPro')
hold off
ylim([-400,400])
xlim([0,50])
title('Mean MEPs, comparison')
legend('show')