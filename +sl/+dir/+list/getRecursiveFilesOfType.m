function output = getRecursiveFilesOfType(start_path,file_extension,varargin)
%
%   output = sl.dir.list.getRecursiveFilesOfType(start_path,file_extension,varargin)
%
%   Inputs
%   ------
%   start_path :
%   file_extension : 
%
%   Optional Inputs
%   ---------------
%   output_type : {'object','names','paths','dir'} (default 'paths')
%       - object : return sl.dir.list_result
%       - names  : return only the names
%       - paths   : return only the paths
%       - dir    : return only the dir structures

in.waitbar_string = '';
in.output_type = 'paths';
in = sl.in.processVarargin(in,varargin);

output = sl.dir.getList(start_path,'output_type',in.output_type,...
    'recursive',true,'extension',file_extension,...
    'waitbar_string',in.waitbar_string);

end