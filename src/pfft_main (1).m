folder = "data_implementation";
filelist = dir(folder);
method_lst = ["ZP", "PCCS", "HOMO", "POCS"];
kspace_partial = [3/4, 5/8, 9/16, 17/32, 33/64];
noise_level = [0, 1, 2, 5, 10];

%% Different methods comparison
mse_lst = zeros([length(method_lst), 8]);
ssim_lst = zeros([length(method_lst), 8]);
psnr_lst = zeros([length(method_lst), 8]);
img_cnt = 1;
dcm_lst = zeros([8, 256, 256]);
rp_dcm_lst = zeros([length(method_lst), 8, 256, 256]);

for ifile = 1:length(filelist)
    if filelist(ifile).name(1) == "M"
        filename = filelist(ifile).name;
        dcm = dicomread(fullfile(folder, filename));
        dcm_lst(img_cnt, :, :) = dcm;
        for i = 1:4
            filename = filelist(ifile).name;
            [rp_dcm, mse_lst(i, img_cnt), ssim_lst(i, img_cnt), psnr_lst(i, img_cnt)] = pfft_func(dcm, kspace_partial(3), method_lst(i), noise_level(2), 20, false);
            rp_dcm_lst(i, img_cnt, :, :) = rp_dcm;
        end
        img_cnt = img_cnt + 1;
    end
end

% Quatitative Result Visualization
figure
subplot(3, 1, 1); plot(mse_lst); title("mse"); xticks(1:length(method_lst)); xticklabels(method_lst); 
subplot(3, 1, 2); plot(ssim_lst); title("ssim"); xticks(1:length(method_lst)); xticklabels(method_lst); 
subplot(3, 1, 3); plot(psnr_lst); title("psnr"); xticks(1:length(method_lst)); xticklabels(method_lst); 

% Overall Quantitative Result Visualization
figure
subplot(3, 1, 1); plot(mean(mse_lst, 2)); title("Overall MSE"); xticks(1:length(method_lst)); xticklabels(method_lst); grid minor;
subplot(3, 1, 2); plot(mean(ssim_lst, 2)); title("Overall SSIM"); xticks(1:length(method_lst)); xticklabels(method_lst); grid minor; 
subplot(3, 1, 3); plot(mean(psnr_lst, 2)); title("Overall PSNR"); xticks(1:length(method_lst)); xticklabels(method_lst); grid minor;

% Single Image Result Visualization
img_idx = 2;
figure
subplot(1, 4, 1); imagesc(squeeze(dcm_lst(img_idx, :, :))); title("Original MRI"); axis("square"); axis("off");
subplot(2, 4, 2); imagesc(squeeze(rp_dcm_lst(1, img_idx, :, :))); title("Recon - ZP"); axis("square"); axis("off");
subplot(2, 4, 3); imagesc(squeeze(rp_dcm_lst(2, img_idx, :, :))); title("Recon - PCCS"); axis("square"); axis("off");
subplot(2, 4, 6); imagesc(squeeze(rp_dcm_lst(3, img_idx, :, :))); title("Recon - HOMO"); axis("square"); axis("off");
subplot(2, 4, 7); imagesc(squeeze(rp_dcm_lst(4, img_idx, :, :))); title("Recon - POCS"); axis("square"); axis("off");
subplot(3, 4, 4); plot(mse_lst(:, img_idx)); title("MSE"); xticks([1 2 3 4]); xticklabels(method_lst); grid minor;
subplot(3, 4, 8); plot(ssim_lst(:, img_idx)); title("SSIM"); xticks([1 2 3 4]); xticklabels(method_lst); grid minor;
subplot(3, 4, 12); plot(psnr_lst(:, img_idx)); title("PSNR"); xticks([1 2 3 4]); xticklabels(method_lst); grid minor;

%% Different kspace partial
mse_lst = zeros([length(kspace_partial), 8]);
ssim_lst = zeros([length(kspace_partial), 8]);
psnr_lst = zeros([length(kspace_partial), 8]);
rp_dcm_lst = zeros([length(kspace_partial), 8, 256, 256]);
img_cnt = 1;
for ifile = 1:length(filelist)
    if filelist(ifile).name(1) == "M"
        filename = filelist(ifile).name;
        dcm = dicomread(fullfile(folder, filename));
        dcm_lst(img_cnt, :, :) = dcm;
        for i = 1:length(kspace_partial)
            [rp_dcm, mse_lst(i, img_cnt), ssim_lst(i, img_cnt), psnr_lst(i, img_cnt)] = pfft_func(dcm, kspace_partial(i), "POCS", noise_level(2), 20, false);
            rp_dcm_lst(i, img_cnt, :, :) = rp_dcm;
        end
        img_cnt = img_cnt + 1;
    end
end

%
figure
kspace_partial_str = ["3/4", "5/8", "9/16", "17/32", "33/64"];
subplot(3, 1, 1); plot(mean(mse_lst, 2)); title("MSE"); xticks(1:length(kspace_partial)); xticklabels(kspace_partial_str);  grid minor;
subplot(3, 1, 2); plot(mean(ssim_lst, 2)); title("SSIM"); xticks(1:length(kspace_partial)); xticklabels(kspace_partial_str);  grid minor;
subplot(3, 1, 3); plot(mean(psnr_lst, 2)); title("PSNR"); xticks(1:length(kspace_partial)); xticklabels(kspace_partial_str);  grid minor; xlabel("K Space Partial");

% Single Image Result Visualization
img_idx = 1;
figure
subplot(2, 4, 1); imagesc(squeeze(dcm_lst(img_idx, :, :))); title(kspace_partial_str(1)); axis("square"); axis("off");
subplot(2, 4, 2); imagesc(squeeze(rp_dcm_lst(1, img_idx, :, :))); title(kspace_partial_str(2)); axis("square"); axis("off");
subplot(2, 4, 3); imagesc(squeeze(rp_dcm_lst(2, img_idx, :, :))); title(kspace_partial_str(3)); axis("square"); axis("off");
subplot(2, 4, 5); imagesc(squeeze(rp_dcm_lst(3, img_idx, :, :))); title(kspace_partial_str(4)); axis("square"); axis("off");
subplot(2, 4, 6); imagesc(squeeze(rp_dcm_lst(4, img_idx, :, :))); title(kspace_partial_str(5)); axis("square"); axis("off");
subplot(3, 4, 4); plot(mse_lst(:, img_idx)); title("MSE");  xticks(1:length(kspace_partial)); xticklabels(kspace_partial_str); grid minor;
subplot(3, 4, 8); plot(ssim_lst(:, img_idx)); title("SSIM"); xticks(1:length(kspace_partial)); xticklabels(kspace_partial_str); grid minor;
subplot(3, 4, 12); plot(psnr_lst(:, img_idx)); title("PSNR"); xticks(1:length(kspace_partial)); xticklabels(kspace_partial_str); grid minor;

%% Different noise level
mse_lst = zeros([length(noise_level), 8]);
ssim_lst = zeros([length(noise_level), 8]);
psnr_lst = zeros([length(noise_level), 8]);
img_cnt = 1;
rp_dcm_lst = zeros([length(noise_level), 8, 256, 256]);

for ifile = 1:length(filelist)
    if filelist(ifile).name(1) == "M"
        filename = filelist(ifile).name;
        dcm = dicomread(fullfile(folder, filename));
        dcm_lst(img_cnt, :, :) = dcm;
        for i = 1:length(noise_level)
            filename = filelist(ifile).name;
            [rp_dcm, mse_lst(i, img_cnt), ssim_lst(i, img_cnt), psnr_lst(i, img_cnt)] = pfft_func(dcm, kspace_partial(3), "POCS", noise_level(i), 20, false);
            rp_dcm_lst(i, img_cnt, :, :) = rp_dcm;
        end
        img_cnt = img_cnt + 1;
    end
end

figure
subplot(3, 1, 1); plot(mean(mse_lst, 2)); title("MSE"); xticks(1:length(noise_level)); xticklabels(noise_level);  grid minor;
subplot(3, 1, 2); plot(mean(ssim_lst, 2)); title("SSIM"); xticks(1:length(noise_level)); xticklabels(noise_level);  grid minor;
subplot(3, 1, 3); plot(mean(psnr_lst, 2)); title("PSNR"); xticks(1:length(noise_level)); xticklabels(noise_level);  grid minor; xlabel("Noise Level");

% Single Image Result Visualization
img_idx = 1;
figure
subplot(2, 4, 1); imagesc(squeeze(dcm_lst(img_idx, :, :))); title("Noise Level = 0"); axis("square"); axis("off");
subplot(2, 4, 2); imagesc(squeeze(rp_dcm_lst(1, img_idx, :, :))); title("Noise Level = 1"); axis("square"); axis("off");
subplot(2, 4, 3); imagesc(squeeze(rp_dcm_lst(2, img_idx, :, :))); title("Noise Level = 2"); axis("square"); axis("off");
subplot(2, 4, 5); imagesc(squeeze(rp_dcm_lst(3, img_idx, :, :))); title("Noise Level = 5"); axis("square"); axis("off");
subplot(2, 4, 6); imagesc(squeeze(rp_dcm_lst(4, img_idx, :, :))); title("Noise Level = 10"); axis("square"); axis("off");
subplot(3, 4, 4); plot(mse_lst(:, img_idx)); title("MSE");  xticks(1:length(noise_level)); xticklabels(noise_level); grid minor;
subplot(3, 4, 8); plot(ssim_lst(:, img_idx)); title("SSIM"); xticks(1:length(noise_level)); xticklabels(noise_level); grid minor;
subplot(3, 4, 12); plot(psnr_lst(:, img_idx)); title("PSNR"); xticks(1:length(noise_level)); xticklabels(noise_level); grid minor;
