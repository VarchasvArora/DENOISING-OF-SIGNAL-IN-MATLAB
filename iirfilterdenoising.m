%% clear stuff
clc
clear all
close all

%% simulate signal
[y,Fs]=audioread('C:\Users\varch\Downloads\Record.wav');
sound(y, Fs);              % sound(y, fs); % Play back the speech signal
T=1/Fs;
n=length(y);               %Calculates the length of the audio signal
t=(0:n-1)*T;               %calculating time for signal
figure(1)
subplot(2,1,1)
plot(t,y);
xlabel('Time')
ylabel('Amplitude')
title("Initial speech signal in time domain")
Y=fft(y,n);                 %Fourier transform, transform to the frequency domain
F=(0:(n-1))*Fs/n;           %Calculating frequency for frequency domain
Y_0=fftshift(Y);            %Shifting the fourier transform of the signal
F_0=(-n/2:n/2-1)*Fs/n;
subplot(2,1,2);
plot(F_0,abs(Y_0),'g');
xlabel('Frequency Time')
ylabel('Frequency Amplitude')
title("Initial speech signal in Frequency domain")

%% simulate noisy signal
figure(2)
noise =0.05*randn(n,2);      %using random noise
z=y(:,1)+noise(:,1);         %superimposing noise to our signal
subplot(2,1,1);
plot(t,z);
xlabel('Time')
ylabel('Amplitude')
title("Noisy speech signal in time domain")
Z=fft(z,n);                   % Fourier transform, transform to the frequency domain
subplot(2,1,2);
Z_0=fftshift(Z);              %Shifting the fourier transform of the signal
plot(F_0,abs(Z_0),'g');
xlabel('Frequency Time')
ylabel('Frequency Amplitude')
title("Noisy speech signal in Frequency domain")
sound(z,Fs);                  %The noisy sound

%% Design Filter 
figure(3)
o = 40;
f=1900;
wn = 2*pi*f/Fs
[b,a] = butter(o,wn,'low');
% see frequency response of the filter
[h,w] = freqz(b,a,1024,Fs);
subplot(2,1,1);
plot(w,20*log10(abs(h)));
title('Magnitude Response of the Filter');
xlabel('Frequency (Hz)');
ylabel('Magnitude');grid on;

%% Filter the signal
% h_P = [h, zeros(1,length(z )-length(h))];   %padding zeros
output=filter(b,a,z);
output_fft= fft(output,n);     % Fourier transform, transform to the frequency domain
fout=fftshift(output_fft);  %Shifting the fourier transform of the signal
figure(4)
subplot (2,1,1);
plot(t,output(1:length(t),1));
xlabel('Time')
ylabel('Amplitude')
title("Filtered speech signal in time domain")
subplot(2,1,2)
plot(F_0,abs(fout),'g')
xlabel('Frequency Time')
ylabel('Frequency Amplitude')
title("Filtered speech signal in Frequency domain")
sound(output,Fs);              %Testing then filtered sound