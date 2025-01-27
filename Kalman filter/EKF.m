clear all;clc;close all;
%%Preparation of the ambinet test data.IO is the detrended&truncated acceleration signal, NS is the velocity and deformation integrated from the IO,FS is EKFed from the NS
% % Read data by UI
% [FileName,PathName] = uigetfile('*.mat','Select the MATLAB code file');
% ImDataFile=[PathName,FileName];
% [fpath,fname,fsuffix]=fileparts(ImDataFile);
% prompt = {'Enter the state:','Enter the channel no.:'};
% dlg_title = 'Input';
% num_lines = 1;
% answer = inputdlg(prompt,dlg_title,num_lines);
% DRepos=importdata(ImDataFile);
% Fst=1;Lnth=8191;Lst=Fst+Lnth;SclFtr=0.01;
% IOA=[DRepos.A_input1T(Fst:Lst),DRepos.A_output1T(Fst:Lst),DRepos.A_output2T(Fst:Lst),DRepos.A_output3T(Fst:Lst),DRepos.A_output4T(Fst:Lst),DRepos.A_output5T(Fst:Lst),DRepos.A_output6T(Fst:Lst),DRepos.A_output7T(Fst:Lst)];
% IOB=[DRepos.B_input1T(Fst:Lst),DRepos.B_output1T(Fst:Lst),DRepos.B_output2T(Fst:Lst),DRepos.B_output3T(Fst:Lst),DRepos.B_output4T(Fst:Lst),DRepos.B_output5T(Fst:Lst),DRepos.B_output6T(Fst:Lst),DRepos.B_output7T(Fst:Lst)];
% IO1=[DRepos.C_input1T(Fst:Lst),DRepos.C_output1T(Fst:Lst),DRepos.C_output2T(Fst:Lst),DRepos.C_output3T(Fst:Lst),DRepos.C_output4T(Fst:Lst),DRepos.C_output5T(Fst:Lst),DRepos.C_output6T(Fst:Lst),DRepos.C_output7T(Fst:Lst)];
% IO2=[DRepos.D_input1T(Fst:Lst),DRepos.D_output1T(Fst:Lst),DRepos.D_output2T(Fst:Lst),DRepos.D_output3T(Fst:Lst),DRepos.D_output4T(Fst:Lst),DRepos.D_output5T(Fst:Lst),DRepos.D_output6T(Fst:Lst),DRepos.D_output7T(Fst:Lst)];
% IO3=[DRepos.E_input1T(Fst:Lst),DRepos.E_output1T(Fst:Lst),DRepos.E_output2T(Fst:Lst),DRepos.E_output3T(Fst:Lst),DRepos.E_output4T(Fst:Lst),DRepos.E_output5T(Fst:Lst),DRepos.E_output6T(Fst:Lst),DRepos.E_output7T(Fst:Lst)];
% switch answer{1,1}
%     case 'A'
%         WState=IOA;State=SName(IOA);
%     case 'B'
%         WState=IOB;State=SName(IOB);
%     case '1'
%         WState=IO1;State=SName(IO1);
%     case '2'
%         WState=IO2;State=SName(IO2); 
%     case '3'
%         WState=IO3;State=SName(IO3);
% end
% ChnlNo=str2num(answer{2,1});
% IO=WState*SclFtr;

% Read data directly
ImDataFile='C:\Users\Bin Peng\OneDrive - usst.edu.cn\桌面\Publication\振动与冲击\试验数据\动测\动测结果\W1_data.mat';
[fpath,fname,fsuffix]=fileparts(ImDataFile);
DRepos=importdata(ImDataFile);
% Fst=1;Lnth=8191;Lst=Fst+Lnth;SclFtr=0.01;
% IOA=[DRepos.A_input1T(Fst:Lst),DRepos.A_output1T(Fst:Lst),DRepos.A_output2T(Fst:Lst),DRepos.A_output3T(Fst:Lst),DRepos.A_output4T(Fst:Lst),DRepos.A_output5T(Fst:Lst),DRepos.A_output6T(Fst:Lst),DRepos.A_output7T(Fst:Lst)];
% IOB=[DRepos.B_input1T(Fst:Lst),DRepos.B_output1T(Fst:Lst),DRepos.B_output2T(Fst:Lst),DRepos.B_output3T(Fst:Lst),DRepos.B_output4T(Fst:Lst),DRepos.B_output5T(Fst:Lst),DRepos.B_output6T(Fst:Lst),DRepos.B_output7T(Fst:Lst)];
% IO1=[DRepos.C_input1T(Fst:Lst),DRepos.C_output1T(Fst:Lst),DRepos.C_output2T(Fst:Lst),DRepos.C_output3T(Fst:Lst),DRepos.C_output4T(Fst:Lst),DRepos.C_output5T(Fst:Lst),DRepos.C_output6T(Fst:Lst),DRepos.C_output7T(Fst:Lst)];
% IO2=[DRepos.D_input1T(Fst:Lst),DRepos.D_output1T(Fst:Lst),DRepos.D_output2T(Fst:Lst),DRepos.D_output3T(Fst:Lst),DRepos.D_output4T(Fst:Lst),DRepos.D_output5T(Fst:Lst),DRepos.D_output6T(Fst:Lst),DRepos.D_output7T(Fst:Lst)];
% IO3=[DRepos.E_input1T(Fst:Lst),DRepos.E_output1T(Fst:Lst),DRepos.E_output2T(Fst:Lst),DRepos.E_output3T(Fst:Lst),DRepos.E_output4T(Fst:Lst),DRepos.E_output5T(Fst:Lst),DRepos.E_output6T(Fst:Lst),DRepos.E_output7T(Fst:Lst)];
Fst=1;Lnth=size(DRepos.A_input,1)-1;Lst=Fst+Lnth;SclFtr=0.01;
IOA=[DRepos.A_input(Fst:Lst),DRepos.A_output1(Fst:Lst),DRepos.A_output2(Fst:Lst),DRepos.A_output3(Fst:Lst),DRepos.A_output4(Fst:Lst),DRepos.A_output5(Fst:Lst),DRepos.A_output6(Fst:Lst),DRepos.A_output7(Fst:Lst)];
Fst=1;Lnth=size(DRepos.B_input,1)-1;Lst=Fst+Lnth;SclFtr=0.01;
IOB=[DRepos.B_input(Fst:Lst),DRepos.B_output1(Fst:Lst),DRepos.B_output2(Fst:Lst),DRepos.B_output3(Fst:Lst),DRepos.B_output4(Fst:Lst),DRepos.B_output5(Fst:Lst),DRepos.B_output6(Fst:Lst),DRepos.B_output7(Fst:Lst)];
Fst=1;Lnth=size(DRepos.C_input,1)-1;Lst=Fst+Lnth;SclFtr=0.01;
IO1=[DRepos.C_input(Fst:Lst),DRepos.C_output1(Fst:Lst),DRepos.C_output2(Fst:Lst),DRepos.C_output3(Fst:Lst),DRepos.C_output4(Fst:Lst),DRepos.C_output5(Fst:Lst),DRepos.C_output6(Fst:Lst),DRepos.C_output7(Fst:Lst)]; 
Fst=1;Lnth=size(DRepos.D_input,1)-1;Lst=Fst+Lnth;SclFtr=0.01;
IO2=[DRepos.D_input(Fst:Lst),DRepos.D_output1(Fst:Lst),DRepos.D_output2(Fst:Lst),DRepos.D_output3(Fst:Lst),DRepos.D_output4(Fst:Lst),DRepos.D_output5(Fst:Lst),DRepos.D_output6(Fst:Lst),DRepos.D_output7(Fst:Lst)];
Fst=1;Lnth=size(DRepos.E_input,1)-1;Lst=Fst+Lnth;SclFtr=0.01;
IO3=[DRepos.E_input(Fst:Lst),DRepos.E_output1(Fst:Lst),DRepos.E_output2(Fst:Lst),DRepos.E_output3(Fst:Lst),DRepos.E_output4(Fst:Lst),DRepos.E_output5(Fst:Lst),DRepos.E_output6(Fst:Lst),DRepos.E_output7(Fst:Lst)];

WState=IOA;State=SName(IOA);
ChnlNo=1;
IO=WState*SclFtr;
% Specify ambient test parameters
SplFreqcy=200;
DeltaT=1/SplFreqcy;
t=[0:1/SplFreqcy:(size(IO,1)-1)/SplFreqcy]';
% SenseOfAcc=32.8 ;%Gal/v
% SenseOfInstru=34.2; %Gal/v
% GainOfInstru=1;
% R=1/((SenseOfInstru/SenseOfAcc)*GainOfInstru);

%% Detrend
DtrdOdr=1;
for i=1:size(IO,2)
    IO(:,i)=detrend(IO(:,i)-polyval(polyfit(t,IO(:,i),DtrdOdr),t));
%   IO(:,i)=IO(:,i)-mean(IO(:,i));
end

%% Delete small voltage turbulents
% for i=1:size(IO,2)
%     for j=1:size(IO(:,i))
%       if abs(IO(j,i))>1e-3
%         IO(j,i)=IO(j,i);
%         else
%          IO(j,i)=0;
%         end
%     end
% end

%% Integrating the acceleration to get velocity and dislacement
for i=1:size(IO,2)
%%%%%%%%频域法    
%    iD_th=fft(IO(:,i));
%    for k=1:size(iD_th,1)/2
%      iV_th(k,1)=iD_th(k,1)/(k*2*pi*(SplFreqcy/size(IO(:,i),1))*j);
%    end
%    for k=size(iD_th,1)/2+1:size(iD_th,1)
%      iV_th(k,1)= iV_th(size(iD_th,1)-k+1,1);
%    end
%    V_th(:,i)=ifft(iV_th,'symmetric');
%%%%%%%%%%直接积分法
  V_th(:,i)=cumtrapz(IO(:,i))*(1/SplFreqcy);
end

for j=1:size(V_th,2)
D_th(:,j)=cumtrapz(t,V_th(:,j));
end

%% Form the measurement matrix
NS=[D_th(:,2:8),V_th(:,2:8)];
% [U1,e1,V1] = svd(D_th(:,2:8),0);
% NS1=D_th(:,2:8)*V1(:,1);
% 
% [U2,e2,V2] = svd(V_th(:,2:8),0);
% NS2=V_th(:,2:8)*V2(:,1);
% NS=[NS1,NS2];


%% Preparation of structural matricies
M=DRepos.M1; 
K=DRepos.K1; 
C=DRepos.C1;% 或C1=0.053*2*sqrtm(M1'*K1); 
D=blkdiag(DRepos.D1,DRepos.D1); 
% M=DRepos.M2; 
% K=DRepos.K2; 
% C=DRepos.C2;% 或C2=0.053*2*sqrtm(M2'*K2); 
% D=[DRepos.D2;DRepos.D2]; 

%% EKF construction
Phi=[zeros(size(M)),eye(size(M));(-1)*(M^-1)*K,(-1)*(M^-1)*C];
Psi=[zeros(size(M));(-1)*eye(size(M))];

A=expm(Phi*DeltaT);
B=(Phi^-1)*(eye(size(Phi))-expm((-1)*Phi*DeltaT))*Psi;

StateFcn=@(X,U)(A*X+B*U);
MeasurementFcn=@(Y) D*Y;
obj = extendedKalmanFilter(StateFcn,MeasurementFcn,zeros(size(A,2),1),'StateCovariance',2*(mean(std(IO)')/size(IO,2))^2);
obj.MeasurementNoise=(mean(std(IO)')/size(IO,2))^2;
obj.ProcessNoise=0.1*(mean(std(IO)')/size(IO,2))^2;

h=waitbar(0,'Working');
tic;
for k = 1:size(NS,1)
  [CorrectedState,CorrectedStateCovariance] = correct(obj,NS(k,:)'); 
  [PredictedState,PredictedStateCovariance] = predict(obj,IO(k,1)*ones(size(B,2),1));
  FS(k,1:14)=(D*CorrectedState)';
  time=toc;hrs=floor(time/3600);mnts=floor((time-hrs*3600)/60);secs=mod(time,60);
  waitbar(k/size(NS,1),h,num2str(k*100/size(NS,1),'%.1f')+"%Completed"+"    "+"Time used: "+num2str(hrs,'%02.0f')+":"+num2str(mnts,'%02.0f')+":"+num2str(secs,'%.1f'));
end
h.delete;
% FS=PC(FS);

%% PSD of the filtered signal
[PsdN,f0]=pwelch(NS(:,ChnlNo),[],[],[],SplFreqcy);%Hamming窗，默认窗长度、重叠长度和DFT点数
% [PsdN,f1]=pwelch(NS(:,CNo),[],[],[],SplFreqcy);%Hamming窗，默认窗长度、重叠长度和DFT点数
[PsdF,f2]=pwelch(FS(:,ChnlNo),[],[],[],SplFreqcy);%Hamming窗，默认窗长度、重叠长度和DFT点数

%% Output
figure(1)
set(gcf,'Units','centimeters','Position',[0 0 30 16],'Resize','off','name',['墙体',fname,'状态',State]);
subplot(2,3,1);
plot(t,IO(:,ChnlNo+1));
legend('\fontname{宋体}预处理后原纪录\fontname{Times new Roman}(IO)','Location','best');
xlabel(['\fontname{宋体}通道',(num2str(ChnlNo)),'\fontname{宋体}时间\fontname{Times new Roman}(s)'],'FontSize',10);
ylabel('\fontname{宋体}加速度\fontname{Times new Roman}(m/s^2)','FontSize',10);

subplot(2,3,2);
plot(t,NS(:,ChnlNo+7)); hold on;
% plot(t,NS(:,CNo+7)); 
plot(t,FS(:,ChnlNo+7)); 
legend('\fontname{宋体}预处理后原纪录\fontname{Times new Roman}(V-th)','EKF\fontname{宋体}滤波后\fontname{Times new Roman}(FS)','Location','best');
xlabel(['\fontname{宋体}通道',(num2str(ChnlNo)),'\fontname{宋体}时间\fontname{Times new Roman}(s)'],'FontSize',10);
ylabel('\fontname{宋体}速度\fontname{Times new Roman}(m/s)','FontSize',10);

subplot(2,3,3);
plot(t,NS(:,ChnlNo)); hold on;
% plot(t,NS(:,CNo)); 
plot(t,FS(:,ChnlNo)); 
legend('\fontname{宋体}预处理后原纪录\fontname{Times new Roman}(D-th)','EKF\fontname{宋体}滤波后\fontname{Times new Roman}(FS)','Location','best');
xlabel(['\fontname{宋体}通道',(num2str(ChnlNo)),'\fontname{宋体}时间\fontname{Times new Roman}(s)'],'FontSize',10);
ylabel('\fontname{宋体}变形\fontname{Times new Roman}(m)','FontSize',10);
% set(gca,'FontName','Times new Roman','FontSize',11);m
% set(gcf,'Units','centimeters','Position',[0 0 16 16],'Resize','off');
% RFile='C:\Users\pengbin\Desktop\T';
% print('-f1',RFile,'-painters','-dmeta','-r600');

subplot(2,3,4);
[pks0,loc0]=max(PsdN(2:end));BscFreq0=f0(loc0+1);
% [pks1,loc1]=max(PsdN(2:end));BscFreq1=f1(loc1+1);
[pks2,loc2]=max(PsdF(2:end));BscFreq2=f2(loc2+1);
plot(f0,PsdN);hold on;
% plot(f1,PsdN);hold on;
plot(f2,PsdF);hold on;
legend(['PSD of D-th (Hz)',' ',num2str(BscFreq0,'%.1f')],['PSD of FS (Hz)',' ',num2str(BscFreq2,'%.1f')],'Location','best');
xlabel(['\fontname{宋体}通道',(num2str(ChnlNo)),'\fontname{宋体}频率\fontname{Times new Roman}(s)'],'FontSize',10);

subplot(2,3,[5,6]);
for i=1:8
    plot3(t,(i-1)*ones(size(t,1),1),D_th(:,i));hold on;
    xlabel('\fontname{宋体}时间\fontname{Times new Roman}(s)','FontSize',10);
    ylabel('\fontname{宋体}通道','FontSize',10);
    zlabel('\fontname{宋体}变形\fontname{Times new Roman}(m)','FontSize',10);
end
%% functions
function Q=PC(P)
[U1,e1,V1] = svd(P(:,1:7),0);
NS1=P(:,1:7)*V1(:,1);

[U2,e2,V2] = svd(P(:,8:14),0);
NS2=P(:,8:14)*V2(:,1);
Q=[NS1,NS2];
end

function StateName=SName(a)
StateName = inputname(1);
end
