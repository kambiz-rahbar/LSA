clc
clear
close all

t = [-2*pi:0.01:2*pi];
[XX, YY] = meshgrid(t,t);

X = XX.^2;
Y = YY.^2;
Z = X+Y;

mesh(XX,YY,Z)

R1 = XX(:).^2;
R2 = YY(:).^3;
R3 = sin(XX(:));
R4 = -YY(:).^4;
R = [R1 R2 R3 R4];

theta = pinv(R'*R)*R'*Z(:);
Z_hat = R*theta;

Z_hat = reshape(Z_hat,size(Z));
figure();
mesh(XX,YY,Z_hat);


Z2 = 1.16*XX.^2;
figure()
mesh(XX,YY,Z-Z2)



