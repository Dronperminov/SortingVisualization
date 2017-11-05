{$apptype windows}

program spectrum_analyzer;

uses graphAbc;

const
  screen_width = 1000; {ширина графического окна}
  screen_height = 500; {высота графического окна}

  margin_x = 50;
  margin_y = 50;

  zero_x = margin_x; {начальная координа по х}
  zero_y = screen_height - margin_y; {начальная координа по у}

  length_x = screen_width - 2 * margin_x; {длина оси х}
  length_y = screen_height - 2 * margin_y; {длина оси у}
  
  max_data = 4096;
  
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

procedure sort(L,R: integer; var a:input_array; n:integer); 
var 
  i,j: integer; 
  w,x: integer; 
begin 
  i:=L; 
  j:=R; 
  x:=a[(L+R) div 2]; 
  
  REPEAT 
   while a[i]<x do
     i:=i+1; 
     
   while x<a[j] do 
     j:=j-1; 
       
   if i<=j then 
   begin
     drawSpectrum(a, n, max_level, clBlack);
     sleep(10);
     w:=a[i]; 
     a[i]:=a[j]; 
     a[j]:=w; 
     i:=i+1; 
     j:=j-1; 
   end; 
  UNTIL i>j; 
 
  if L<j then 
    sort(L,j, a, n); 
    if i<R then 
      sort(i,R, a, n); 
end; 

procedure QuickSort(var a:input_array; n:integer); 
begin 
 sort(1,N, a, n); 
end; 


{Процедура инициализации}
procedure Setup;
begin
  SetWindowCaption('Быстрая сортировка (' + IntToStr(data_size) + ' элементов)');
  SetWindowSize(screen_width, screen_height);
  CenterWindow;
  LockDrawing;
end;

begin
  Setup;
  
  fill_data(input_data, data_size, max_level);
  DrawSpectrum(input_data, data_size, max_level, clBlack);
  
  QuickSort(input_data, data_size);  
  
  if CheckData(input_data, data_size) then
    DrawSpectrum(input_data, data_size, max_level, clGreen)
  else
    DrawSpectrum(input_data, data_size, max_level, clRed);
end.