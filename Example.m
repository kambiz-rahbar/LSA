clc
clear
close all

%% original_img
org_img = imread('cameraman.tif');
patch_size = 8;
img_index = 0:patch_size:256;

number_of_org_img_patch = 0;
for x = 1:length(img_index)-1
    for y = 1:length(img_index)-1
        number_of_org_img_patch = number_of_org_img_patch+1;
        img_patch(number_of_org_img_patch,:,:) = org_img(img_index(x)+1:img_index(x+1),img_index(y)+1:img_index(y+1));
        img_patch_1d(number_of_org_img_patch,:) = reshape(img_patch(number_of_org_img_patch,:,:),1,[]);
    end
end

%% ds_patch
%ds_patch = uint8(rand(num_of_reg,8,8)*255);

patch_img = im2gray(imread('peppers.png'));
patch_img = imresize(patch_img,size(org_img));
number_of_org_img_patch = 0;
for x = 1:length(img_index)-1
    for y = 1:length(img_index)-1
        number_of_org_img_patch = number_of_org_img_patch+1;
        ds_patch(number_of_org_img_patch,:,:) = patch_img(img_index(x)+1:img_index(x+1),img_index(y)+1:img_index(y+1));
        ds_patch_1d(number_of_org_img_patch,:) = reshape(img_patch(number_of_org_img_patch,:,:),1,[]);
    end
end

num_of_reg = 25;
patch_index = randperm(number_of_org_img_patch,num_of_reg);
ds_patch = ds_patch(patch_index,:,:);
ds_patch_1d = ds_patch_1d(patch_index,:);
R = double(reshape(ds_patch,num_of_reg,[]))';
%Z = double(img_patch_1d(1,:))';
%W = pinv(R'*R)*R'*Z;
%Zhat = R*W;
%sse(Z-Zhat)

%%
W = cell(number_of_org_img_patch,1);
for n = 1:number_of_org_img_patch
    %[val(m,:),pos(m,:)] = sort(sum((double(img_patch_1d(m,:))-double(p_1d)).^2,2));

    Z = double(img_patch_1d(n,:))';
    W{n} = pinv(R'*R)*R'*Z;
end

%% send patch_index & W
number_of_data_to_send = numel(patch_index) + numel(W)*numel(W{1});
send_data_ratio = number_of_data_to_send / numel(org_img) * 100;

%% ihat
img_hat = uint8(zeros(size(org_img)));
n = 0;
for x = 1:length(img_index)-1
    for y = 1:length(img_index)-1
        n = n+1;
        %ihat(ii(x)+1:ii(x+1),ii(y)+1:ii(y+1)) = pi(n,:,:);
        %ihat(img_index(x)+1:img_index(x+1),img_index(y)+1:img_index(y+1)) = ds_patch(pos(number_of_org_img_patch,1),:,:);
        Zhat = R*W{n};
        img_hat(img_index(x)+1:img_index(x+1),img_index(y)+1:img_index(y+1)) = reshape(Zhat,8,8);
    end
end
subplot(1,3,1);imshow(patch_img)
subplot(1,3,2);imshow(org_img)
subplot(1,3,3);imshow(img_hat)

disp(table(send_data_ratio, sse(org_img(:)-img_hat(:)), mse(org_img(:)-img_hat(:))));