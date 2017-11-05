{$apptype windows}

program spectrum_analyzer;

uses graphAbc;

const
  screen_width = 1000; {������ ������������ ����}
  screen_height = 500; {������ ������������ ����}

  margin_x = 30;
  margin_y = 30;

  zero_x = margin_x; {��������� �������� �� �}
  zero_y = screen_height - margin_y; {��������� �������� �� �}

  length_x = screen_width - 2 * margin_x; {����� ��� �}
  length_y = screen_height - 2 * margin_y; {����� ��� �}
  
  max_data = 4096;
  
  data_size = 100;
  max_level = 1000;

type
  input_array = array[1..max_data] of word;
  output_array = array[1..max_data] of real;

var
  input_data:input_array;
  
{��������� ������������ ����}
procedure DrawAxis;
begin
  line(zero_x, zero_y, zero_x + length_x, zero_y); 
  line(zero_x, zero_y, zero_x, zero_y - length_y); 
end;

{��������� ����� ������ �������}
procedure DrawSpectrumBar (index, width:integer; value:real);
begin
  FillRect(zero_x + (index - 1) * width, zero_y, zero_x + width * index - 1, zero_y - round(length_y * value));
end;

{��������� �������������� ������� � ������������� ������ � ������ � ��������� ������}
procedure PrepareData(var src_data:input_array; var dst_data:output_array; count:integer; max_level:word);
var i:integer;
begin
  for i := 1 to count do
  begin
    dst_data[i] := src_data[i] / max_level;
  end;
end;

procedure fill_data(var data:input_array; size:integer; max_value:word);
var
  i:integer;
begin
  for i:= 1 to size do
    data[i] := random(max_value);
end;



{��������� ��������� ����� �������}
procedure DrawArray (var data:input_array; count:integer; max_level:word; c:color);
var 
  column_width, i:integer;
  out_data:output_array;
begin
  Window.Clear;
  DrawAxis;        
  
  {TODO ���������� ������, ����� ��������� ������� ������, ��� ��������� �����}
  PrepareData(data, out_data, count, max_level);
  
  column_width := length_x div count;
  SetBrushColor(c);
  SetPenWidth(0);
  
  for i := 1 to count do
  begin
     DrawSpectrumBar(i, column_width, out_data[i]);
  end;
  
  Redraw;
end;

function CheckData(data: input_array; data_size: integer):boolean;
var
  fl:boolean;
  i:integer;
begin
  fl := true;
  i := 1;
  while (i < data_size) and fl do
  begin
    if data[i] > data[i + 1] then
      fl := false;
      
    inc(i);
  end;
  
  CheckData := fl;
end;

procedure BubleSort(var data: input_array; data_size: integer);
var
  i, j:integer;
begin  
  for i := 1 to data_size - 1 do    
    for j := data_size downto i + 1 do
    begin
      if data[j - 1] > data[j] then
      begin
        swap(data[j - 1], data[j]);
      end;
      
      DrawArray(data, data_size, max_level, clBlack);      
    end;    
end;

{��������� �������������}
procedure Setup;
begin
  SetWindowCaption('���������� ��������� (' + IntToStr(data_size) + ' ���������)');
  SetWindowSize(screen_width, screen_height);
  CenterWindow;
  LockDrawing;
end;

begin
  Setup;
  
  fill_data(input_data, data_size, max_level);
  BubleSort(input_data, data_size);  
  
  if CheckData(input_data, data_size) then
    DrawArray(input_data, data_size, max_level, clGreen)
  else
    Drawarray(input_data, data_size, max_level, clRed);
end.



