%close all
clear
clc

cd output

s=what;
MatFiles = s.mat;
OutMatFiles = MatFiles(contains(MatFiles,'physicell'));
OutMatFiles(1) = [];
OutMatFiles(1) = [];

for i = 1:length(OutMatFiles)
    OutMatFiles{i}=OutMatFiles{i}(1:14);
end

xmin = -50;
xmax = 50;
ymin = -50;
ymax = 50;

Oxygen_Means = zeros(1,length(OutMatFiles));
Glucose_Means = zeros(1,length(OutMatFiles));
Glutamine_Means = zeros(1,length(OutMatFiles));
Lactate_Means = zeros(1,length(OutMatFiles));

prev_time_point = 0;
next_time_point = 0;
time_interval = 0;

time_points = 0:length(OutMatFiles)-1;

for i = 1:length(OutMatFiles)

    prev_time_point = next_time_point;
    xmlname=strcat(OutMatFiles{i},'.xml');
    MCDS = read_MultiCellDS_xml( xmlname);
    %MCDS = xmlread( xmlname);
    
    next_time_point = MCDS.metadata.current_time;

    positions = MCDS.discrete_cells.state.position;
	largeEnoughX = positions(:,1)>xmin;
    smallEnoughX = positions(:,1)<xmax;
    largeEnoughY = positions(:,2)>ymin;
    smallEnoughY = positions(:,2)<ymax;

    celllist = (largeEnoughX & smallEnoughX & largeEnoughY & smallEnoughY);
    

    Glucose_mean = mean(MCDS.discrete_cells.custom.intra_glu (celllist));
    Glutamine_mean = mean(MCDS.discrete_cells.custom.intra_gln (celllist));
    Lactate_mean = mean(MCDS.discrete_cells.custom.intra_lac (celllist));
    
    Glucose_Means(i) = Glucose_mean;
    Lactate_Means(i) = Lactate_mean;
    Glutamine_Means(i) = Glutamine_mean;
    
    time_interval = next_time_point - prev_time_point;
    
end 

time_points = time_points * time_interval;

figure(1)
plot(time_points,Glutamine_Means)
title('Mean Gln')


figure(2)
plot(time_points,Glucose_Means)
title('Mean Glucose')

figure(3)
plot(time_points,Lactate_Means)
title('Mean Lactate')



cd ..