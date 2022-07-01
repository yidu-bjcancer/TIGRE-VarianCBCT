function headerInfo = write_nrrd(filename, img3D, geo)
% write_nrrd(filename, img3D, geo) 
% write 3D image matrix as .nrrd file 
% Input:
%       filename    :  nrrd filename, default with .nrrd ext
%       img3D       :  3d image matrix
%       geo            :  geometry structure
% Date: 2021-04-11
% Author: Yi Du, yi.du@hotmail.com

flip_tag = true;

if(flip_tag)
    img3D = flip(img3D, 3);
%    img3D = flip(img3D, 2);
end    

% discard file extension
[filepath,name,~]  = fileparts(filename);
if(isempty(filepath))
    headerInfo.content = name;
else
    headerInfo.content = [filepath filesep name];
end

% 
headerInfo.data = img3D;
headerInfo.dimension = 3;
headerInfo.space = 'left-posterior-superior';
% headerInfo.space = 'RAS';
headerInfo.sizes = size(img3D);
% Towards Left
headerInfo.spacedirections{1} = ['(0,' num2str(geo.dVoxel(2)) ',0)'];
% Towards Posterior
headerInfo.spacedirections{2} = ['(' num2str(geo.dVoxel(1)) ',0,0)'];
% Towards superior
headerInfo.spacedirections{3} = ['(0,0,' num2str(geo.dVoxel(3)) ')'];

% headerInfo.spacedirections_matrix = zeros(3,3);
% headerInfo.spacedirections_matrix(1,1) = geo.dVoxel(1);
% headerInfo.spacedirections_matrix(2,2) = geo.dVoxel(2);
% headerInfo.spacedirections_matrix(3,3) = geo.dVoxel(3);
headerInfo.kinds = {'domain'  'domain'  'domain'};
% headerInfo.endian = 'little';
% headerInfo.encoding = 'gzip';
% [LAT: -L, +R ;  VRT: +P,-A;  LNG: +S, -I]
headerInfo.spaceorigin =  [-150; -330; -250];

% spaceorigin - [x; y; z] (ITK-SNAP)
headerInfo.spaceorigin =  headerInfo.spaceorigin - [-16; 28; -30];
% headerInfo.spaceorigin =  [-137; -375; -289];

nrrdFileName = [headerInfo.content '.nrrd'];
    
bWriteData = 'true';
headerInfo = nhdr_nrrd_write(nrrdFileName, headerInfo, bWriteData);

end

