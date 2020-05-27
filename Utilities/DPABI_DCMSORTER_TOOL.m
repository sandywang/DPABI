function varargout = DPABI_DCMSORTER_TOOL(varargin)
% DPABI_DCMSORTER_TOOL MATLAB code for DPABI_DCMSORTER_TOOL.fig
%      DPABI_DCMSORTER_TOOL, by itself, creates a new DPABI_DCMSORTER_TOOL or raises the existing
%      singleton*.
%
%      H = DPABI_DCMSORTER_TOOL returns the handle to a new DPABI_DCMSORTER_TOOL or the handle to
%      the existing singleton*.
%
%      DPABI_DCMSORTER_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DPABI_DCMSORTER_TOOL.M with the given input arguments.
%
%      DPABI_DCMSORTER_TOOL('Property','Value',...) creates a new DPABI_DCMSORTER_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DPABI_DCMSORTER_TOOL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DPABI_DCMSORTER_TOOL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DPABI_DCMSORTER_TOOL

% Last Modified by GUIDE v2.5 31-Oct-2014 15:51:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DPABI_DCMSORTER_TOOL_OpeningFcn, ...
                   'gui_OutputFcn',  @DPABI_DCMSORTER_TOOL_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DPABI_DCMSORTER_TOOL is made visible.
function DPABI_DCMSORTER_TOOL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DPABI_DCMSORTER_TOOL (see VARARGIN)

handles.DICOMCells={};
handles.CurDir=pwd;

set(handles.OutputDirEntry, 'String', pwd);
% Choose default command line output for DPABI_DCMSORTER_TOOL
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DPABI_DCMSORTER_TOOL wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DPABI_DCMSORTER_TOOL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in DICOMListbox.
function DICOMListbox_Callback(hObject, eventdata, handles)
% hObject    handle to DICOMListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DICOMListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DICOMListbox


% --- Executes during object creation, after setting all properties.
function DICOMListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DICOMListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AddAll.
function AddButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Path=uigetdir(handles.CurDir, 'Pick DICOM Directory');
if isnumeric(Path)
    return
end
[handles.CurDir, Name]=fileparts(Path);

Suffix=get(handles.SuffixEntry, 'String');
if strcmpi(Suffix, 'None')
    Suffix='';
end

if ~isempty(Suffix)
    D=dir(fullfile(Path, ['*.', Suffix]));
else
    D=dir(fullfile(Path, '*'));
    Index=cellfun(...
        @(IsDir, NotDot) ~IsDir && (~strcmpi(NotDot, '.') && ~strcmpi(NotDot, '..') && ~strcmpi(NotDot, '.DS_Store')),...
        {D.isdir}, {D.name});
    D=D(Index);    
end

NameCell={D.name}';
Num=numel(NameCell);
DICOMCell=cellfun(@(Name) fullfile(Path, Name), NameCell,...
    'UniformOutput', false);
handles.DICOMCells{numel(handles.DICOMCells)+1}=DICOMCell;
StringOne={sprintf('[%d] (%s) %s', Num, Name, Path)};
AddString(handles.DICOMListbox, StringOne);
guidata(hObject, handles);

% --- Executes on button press in RemoveButton.
function RemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value=get(handles.DICOMListbox, 'Value');
if Value==0
    return
end
handles.DICOMCells(Value)=[];
RemoveString(handles.DICOMListbox, Value);
guidata(hObject, handles);

function SuffixEntry_Callback(hObject, eventdata, handles)
% hObject    handle to SuffixEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SuffixEntry as text
%        str2double(get(hObject,'String')) returns contents of SuffixEntry as a double


% --- Executes during object creation, after setting all properties.
function SuffixEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SuffixEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OutputDirEntry_Callback(hObject, eventdata, handles)
% hObject    handle to OutputDirEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputDirEntry as text
%        str2double(get(hObject,'String')) returns contents of OutputDirEntry as a double


% --- Executes during object creation, after setting all properties.
function OutputDirEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputDirEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OutputDirButton.
function OutputDirButton_Callback(hObject, eventdata, handles)
% hObject    handle to OutputDirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Path=uigetdir(handles.CurDir, 'Pick Output Directory');
if isnumeric(Path)
    return
end
handles.CurDir=fileparts(Path);
set(handles.OutputDirEntry, 'String', Path);
guidata(hObject, handles);

% --- Executes on button press in ComputeButton.
function ComputeButton_Callback(hObject, eventdata, handles)
% hObject    handle to ComputeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.DICOMCells)
    return
end

DICOMCells=handles.DICOMCells;
OutputDir=get(handles.OutputDirEntry, 'String');
if isempty(OutputDir)
    OutputDir=handles.CurDir;
end

HierarchyValue=get(handles.HierarchyPopup, 'Value');
AnonyFlag=get(handles.AnonyButton, 'Value');

w_DCMSort(DICOMCells, HierarchyValue, AnonyFlag, OutputDir);

fprintf('\n\tDICOM files sorting finished!\n');

% --- Executes on selection change in HierarchyPopup.
function HierarchyPopup_Callback(hObject, eventdata, handles)
% hObject    handle to HierarchyPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns HierarchyPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from HierarchyPopup


% --- Executes during object creation, after setting all properties.
function HierarchyPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HierarchyPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AnonyButton.
function AnonyButton_Callback(hObject, eventdata, handles)
% hObject    handle to AnonyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnonyButton


% --------------------------------------------------------------------
function AddTable_Callback(hObject, eventdata, handles)
% hObject    handle to AddTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Path=uigetdir(handles.CurDir, 'Pick DICOM Directory');
if isnumeric(Path)
    return
end
[handles.CurDir, Name]=fileparts(Path);

Suffix=get(handles.SuffixEntry, 'String');
if strcmpi(Suffix, 'None')
    Suffix='';
end

if ~isempty(Suffix)
    D=dir(fullfile(Path, ['*.', Suffix]));
else
    D=dir(fullfile(Path, '*'));
    Index=cellfun(...
        @(IsDir, NotDot) ~IsDir && (~strcmpi(NotDot, '.') && ~strcmpi(NotDot, '..') && ~strcmpi(NotDot, '.DS_Store')),...
        {D.isdir}, {D.name});
    D=D(Index);    
end

NameCell={D.name}';
Num=numel(NameCell);
DICOMCell=cellfun(@(Name) fullfile(Path, Name), NameCell,...
    'UniformOutput', false);
handles.DICOMCells{numel(handles.DICOMCells)+1}=DICOMCell;
StringOne={sprintf('[%d] (%s) %s', Num, Name, Path)};
AddString(handles.DICOMListbox, StringOne);
guidata(hObject, handles);

% --------------------------------------------------------------------
function RemoveTable_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value=get(handles.DICOMListbox, 'Value');
if Value==0
    return
end
handles.DICOMCells(Value)=[];
RemoveString(handles.DICOMListbox, Value);
guidata(hObject, handles);

% --------------------------------------------------------------------
function AddAll_Callback(hObject, eventdata, handles)
% hObject    handle to AddAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Path=uigetdir(handles.CurDir, 'Pick DICOM Parent Directory');
if isnumeric(Path)
    return
end
handles.CurDir=Path;
Suffix=get(handles.SuffixEntry, 'String');



%YAN Chao-Gan, 150518. Recursively add Path
SubjPath = y_GetRecursivePath(Path,[]);
%PathList = y_GetRecursivePath(InPath,PathList)

% SubjStruct=dir(Path);
% Index=cellfun(...
%     @(IsDir, NotDot) IsDir && (~strcmpi(NotDot, '.') && ~strcmpi(NotDot, '..') && ~strcmpi(NotDot, '.DS_Store')),...
%     {SubjStruct.isdir}, {SubjStruct.name});
% SubjStruct=SubjStruct(Index);
% SubjName={SubjStruct.name}';
% SubjPath=cellfun(@(Name) fullfile(Path, Name), SubjName,...
%     'UniformOutput', false);


set(handles.DICOMListbox, 'BackgroundColor', 'Green');
drawnow;
for i=1:numel(SubjPath);
    if strcmpi(Suffix, 'None')
        Suffix='';
    end
    
    if ~isempty(Suffix)
        D=dir(fullfile(SubjPath{i}, ['*.', Suffix]));
    else
        D=dir(fullfile(SubjPath{i}, '*'));
        Index=cellfun(...
            @(IsDir, NotDot) ~IsDir && (~strcmpi(NotDot, '.') && ~strcmpi(NotDot, '..') && ~strcmpi(NotDot, '.DS_Store')),...
            {D.isdir}, {D.name});
        D=D(Index);    
    end

    if ~isempty(D)
        NameCell={D.name}';
        Num=numel(NameCell);
        DICOMCell=cellfun(@(Name) fullfile(SubjPath{i}, Name), NameCell,...
            'UniformOutput', false);
        handles.DICOMCells{numel(handles.DICOMCells)+1}=DICOMCell;
        StringOne={sprintf('[%d] %s', Num, SubjPath{i})};  %StringOne={sprintf('[%d] (%s) %s', Num, SubjName{i}, SubjPath{i})};
        AddString(handles.DICOMListbox, StringOne);
        drawnow;
    end
end
set(handles.DICOMListbox, 'BackgroundColor', 'White');
guidata(hObject, handles);

% --------------------------------------------------------------------
function RemoveAll_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DICOMListbox, 'String', '');
handles.DICOMCells={};

guidata(hObject, handles);

% --------------------------------------------------------------------
function ListContext_Callback(hObject, eventdata, handles)
% hObject    handle to ListContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function AddString(ListboxHandle, NewCell)
StringCell=get(ListboxHandle, 'String');
StringCell=[StringCell; NewCell];
set(ListboxHandle, 'String', StringCell, 'Value', numel(StringCell));

function RemoveString(ListboxHandle, Value)
StringCell=get(ListboxHandle, 'String');
StringCell(Value)=[];
if isempty(StringCell)
    Value=0;
end
if Value > numel(StringCell)
    Value=Value-1;
end
set(ListboxHandle, 'String', StringCell, 'Value', Value);
