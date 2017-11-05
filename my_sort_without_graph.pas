const
  n = 10000;{размер массива}
  iterations = 50;

type
  input_array = array[1..30000] of word;

var
  a: input_array;
  count, sum, time0, time1: integer;
  check: boolean;

procedure print_data(var data: input_array; size: integer);
var
  i: longint;
begin
  for i := 1 to size do
    writeln('data[', i, '] = ', data[i]);
  
  writeln;
end;

procedure fill_data(var data: input_array; size: integer; max_value: word);
var
  i: longint;
begin
  for i := 1 to size do
    data[i] := random(max_value);
end;

function CheckData(data: input_array; data_size: integer): boolean;
var
  fl: boolean;
  i: integer;
begin
  fl := true;
  i := 1;
  while (i < data_size) and fl do
  begin
    if data[i] > data[i + 1] then
      fl := false
    else      
      inc(i);
  end;
  
  CheckData := fl;
end;

procedure Sort(var data: input_array; data_size: integer);
var
  max_v, min_v, max_i, min_i, i, j: integer;
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


begin
  sum := 0;

  for count := 1 to iterations do begin
    fill_data(a, n, 100);
    
    time0 := milliseconds();
    
    Sort(a, n);
    
    time1 := milliseconds();
    
    write('Двунаправленная выборка, A[', n, ']; ', 'Упорядоченнсть: ');
    
    if checkdata(a, n) then
      write('OK; ')
    else
      write('FAIL; ');
      
    writeln('Время: ', time1 - time0, ' ms;');
    
    sum := sum + (time1 - time0);
  end;
  
  writeln('Среднее время: ', sum / iterations:5:2, ' ms');
end.