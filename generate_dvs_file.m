%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estimate signal 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define reference signal @ maximum b-value for SIX (6) directions 
%Grmax = [0.710799 0.00736519 0.703357; ... 
%    -0.710723 0.00728889 0.703434; ...
%    0.00706627 0.717789 0.696224; ...
%    0.00706627 -0.717789 0.696224; ...
%    -0.699933 -0.714069 0.0141358; ...
%    -0.699933 0.714069 0.0141358;]; 

Grmax = [1 0 0; ... 
    0 1 0; ...
    0 0 1;]; 


% define array of b-values 
bval = [50,400,800];


% Setup variables
N_bvalues = length(bval); 
N_directions= size(Grmax,1); 
bval_max = max(bval); 
%const = 0.8; 
const = 1; 

% init matrix with zeros
GrN(1:N_bvalues, 1:3) = repmat([0,0,0], N_bvalues, 1); 

% Fill matrix 
for jj=1:N_bvalues
    %GrN(17*(jj-1)+10:jj*17+9,1:3)=Gr800./sqrt(800/bval(jj))*sqrt(0.8);
    GrN(N_directions*(jj-1)+N_bvalues+1:jj*N_directions+N_bvalues,1:3)=Grmax./sqrt(bval_max/bval(jj))*sqrt(const);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get reference header 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder_ref='/fileserver/abd/silatestscan3T/NRRDS/Kurugol_Sila3/ep2d_diff_crl_22/';
fileName_ref='vol22_0_diffusion182703.nhdr'; 

fid2=fopen(strcat(folder_ref,fileName_ref), 'r');
i=1;
tline= fgets(fid2);
while ischar(tline)
    fullnameall{i}=tline;
    tline= fgets(fid2);
    i=i+1; 
end
fclose(fid2);
lengthlist=i-1;
reference_header = fullnameall; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Write to file 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder = '/fileserver/fastscratch/serge/dvs_files/';
fileName = 's20221110.dvs';
% open file 
fid3=fopen(strcat(folder,fileName),'w');

for lineno=1:20
    fprintf(fid3,'%s',fullnameall{lineno});
end
ss=0;
fprintf(fid3,'DWMRI_gradient_%04d:= %f %f %f\n',ss,GrN(1,1),GrN(1,2),GrN(1,3));
for ss=1:length(GrN)
    fprintf(fid3,'DWMRI_gradient_%04d:= %f %f %f\n',ss,GrN(ss,1),GrN(ss,2),GrN(ss,3));
end


for lineno=21+163:length(fullnameall)
    fprintf(fid3,'%s',fullnameall{lineno});
end
fclose(fid3);
