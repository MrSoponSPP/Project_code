function patients = Amplitude_freq(filename,n0,nf,fs,f0)
%
% filename = capture signal file (e.g. : .dat .txt etc.)
% n0 = first sample
% nf = block size for transform (signal duration = nf/fs)
% e.g. signal duration = 0.02 sec and fs is 1.8E6 times/sec
% then nf = 0.02 sec * 1.8E6 times / sec = 0.02*1.8E6
% fs = sampling frequency [MHz]
% f0 = center frequency [MHz]

%Open and change data type
fid=fopen(filename,'rb');
y=fread(fid,'uint8=>double');
y=y-127.5;
y=y(1:2:end)+i*y(2:2:end);
%
%
%
%
%FFT
n0=round(n0); %round towards nearest integer
nf=round(nf); %round towards nearest integer
%x=y; %let x equal y 
x=y;
x_segment=x(n0:(n0+(nf)-1)); %extracts a small segment of data from signal
p=fftshift(fft(x_segment)); %find FFT
%

% Normalized
z = 20*log10(abs(p))-135;
Amplitude = z;
%

% set x_label [frequency term]
Low_freq=(f0-(fs)/2); %lowest frequency to plot
High_freq=(f0+(fs)/2); %highest frequency to plot
N=length(Amplitude);

freq=[0:1:N-1]*(fs)/N+Low_freq;
freq_transpose = freq.';
frequency=freq_transpose;
patients = table(Amplitude,frequency);
patients2 = table;
patients2.Amplitude = Amplitude;
patients2.Frequency = frequency;

%
%

plot(freq,Amplitude)
axis tight
xlabel('Freqency [MHz]','FontSize', 14)
ylabel('Relative amplitude [dB down from max]','FontSize', 14)
grid on
set(gcf,'color','white');

if nargin==6
    title(title_of_plot,'FontSize', 14)
else
    title({'Spectrum',['Center frequency = ' num2str(f0) ' MHz'] },'FontSize', 14)
end


%Add vertical line
y1=get(gca,'ylim');
hold on;
plot([f0 f0],y1,'r-','linewidth',2);
hold off;
end

