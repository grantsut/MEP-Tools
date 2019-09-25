clear
fn = '20190308_1451-emg.cnt';
info = eepv4_read_info(fn);
dat = read_eep_cnt(fn,1,info.sample_count);
fn2 = '20190308_1451-emg.trg';
trg = read_eep_trg(fn2);
plot(dat.time,dat.data)
%%
clear
fn = '20190308_1451-emgfhp.cnt';
info = eepv4_read_info(fn);
dat = read_eep_cnt(fn,1,info.sample_count);
fn2 = '20190308_1451-emgfhp.trg';
trg = read_eep_trg(fn2);
plot(dat.time,dat.data)
%%
% Extract MEPs
extractlen = round(0.1*dat.rate);
extracts = zeros(length(dat.triggers),extractlen);
for i = 1:length(dat.triggers)
    offsettmp = dat.triggers(i).offset;
    extracts(i,:) = dat.data(offsettmp+1:(offsettmp+extractlen));
end
% plot(extracts(2,:))