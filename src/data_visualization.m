clear all; close all; clc;

folder = "data_implementation";
filelist = dir(folder);

img_cnt = 1;
for ifile = 1:length(filelist)
    if filelist(ifile).name(1) == "M"
        filename = filelist(ifile).name;
        dcm = dicomread(fullfile(folder, filename));
        subplot(2, 4, img_cnt);
        imagesc(dcm); axis("square");
        colormap(gray(256));
        
        filename = replace(filename, "_", "\_");
        title(filename);
        img_cnt = img_cnt + 1;

    end
end