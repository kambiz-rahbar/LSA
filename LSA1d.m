clc
clear
close all

x = [-10:0.1:10]';
x2 = x.^2;
X = [x x2];

n = randn(size(x));
n = n/max(abs(n));
Xn = X + 0.1*max(abs(X(:)))*n;

Y = x2 + 2*x;
n = randn(size(x));
n = n/max(abs(n));
Yn = Y + 0.1*max(abs(Y(:)))*n;

theta = pinv(Xn'*Xn)*Xn'*Yn;

disp(theta)

Y_hat = Xn*theta;

e = Y-Y_hat;
disp(rms(e))

figure()
plot(Y,'g'); hold on;
plot(Yn,'r'); hold on;
plot(Y_hat,'b');