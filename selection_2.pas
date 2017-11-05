{$apptype windows}

program spectrum_analyzer;

uses graphAbc;

const
  screen_width = 1000; {ширина графического окна}
  screen_height = 500; {высота графического окна}

  margin_x = 30;
  margin_y = 30;

  zero_x = margin_x; {начальная координа по х}
  zero_y = screen_height - margin_y; {начальная координа по у}

  length_x = screen_width - 2 * margin_x; {длина оси х}
  length_y = screen_height - 2 * margin_y; {длина оси у}
  
  max_data = 450;
  
  data_size = 100;
  max_level = 1000;

type
  input_array = array[1..max_data] of word;
  output_array = array[1..max_data] of real;

var
  input_data:input_array;
  
{Рисование координатных осей}
procedure DrawAxis;
begin
  line(zero_x, zero_y, zero_x + length_x, zero_y); 
  line(zero_x, zero_y, zero_x, zero_y - length_y); 
end;

{Рисование одной полосы спектра}
procedure DrawSpectrumBar (index, width:integer; value:real);
begin
  FillRect(zero_x + (index - 1) * width, zero_y, zero_x + width * index - 1, zero_y - round(length_y * value));
end;

{Процедура преобразования сигнала с фиксированной точкой в сигнал с плавующей точкой}
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



{Процедура рисования полос спектра}
procedure DrawSpectrum (var data:input_array; count:integer; max_level:word; c:color);
var 
  column_width, i:integer;
  out_data:output_array;
begin
  Window.Clear;
  DrawAxis;        
  
  {TODO обработать случай, когда элементов массива больше, чем доступных точек}
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

procedure Sort(var data: input_array; data_size: integer);
var
  max_v, min_v, max_i, min_i, i, j:integer;
begin  
  i := 1;
  
  while (i <= (data_size div 2) + 1) do
  begin
    max_v := data[data_size - i + 1];
    min_v := data[i];
    max_i := data_size - i + 1;
    min_i := i;
    
    for j := i to data_size + 1 - i do
    begin    
      if max_v < data[j] then
      begin
        max_v := data[j];
        max_i := j;
      end;
      
      if min_v > data[j] then
      begin
        min_v := data[j];
        min_i := j;     
      end;
    end;
    
    DrawSpectrum(data, data_size, max_level, clBlack);
    sleep(30);
    
    if max_i = i then begin    
      swap(data[i], data[data_size - i + 1]);
      
      if data[min_i] <> data[data_size - i + 1] then
        swap(data[min_i], data[i]);
    end;
    
    if min_i = (data_size - i + 1) then begin
      swap(data[data_size - i + 1], data[i]); 
      
      if max_i <> data_size - i + 1 then
        swap(data[max_i], data[data_size - i + 1]);
    end;
    
    if (min_i <> (data_size - i + 1)) and (max_i <> i) then begin
      swap(data[min_i], data[i]);
      swap(data[max_i], data[data_size - i + 1]);
    end;
    
    inc(i);    
  end;        
end;

{Процедура инициализации}
procedure Setup;
begin
  SetWindowCaption('Сортировка тестовая (' + IntToStr(data_size) + ' элементов)');
  SetWindowSize(screen_width, screen_height);
  CenterWindow;
  LockDrawing;
end;

begin
  Setup;
  
  fill_data(input_data, data_size, max_level);
  Sort(input_data, data_size);  
  
  if CheckData(input_data, data_size) then
    DrawSpectrum(input_data, data_size, max_level, clGreen)
  else
    DrawSpectrum(input_data, data_size, max_level, clRed);
end.