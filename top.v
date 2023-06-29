module top(
    input start, op, reset, clock,
    input [31:0] data_a, data_b,
    output busy, ready,
    output [31:0] data_o
);

reg [1:0] EA;
reg [2:0] count;

reg [23:0] mantissa_a, mantissa_b;
reg [47:0] mantissa_soma;
reg [8:0] expoente_a, expoente_b;

reg sinal_o;
reg [8:0] expoente_o;
reg [22:0] mantissa_o;

wire [23:0] mantissa_b_inv;
wire[8:0] expoente_calculo;

wire complemento;
reg erro;
reg [6:0] virgula;
reg soma;
wire loop;
wire loop1;
wire loop2;
reg [4:0] loopcount;
reg A;

//--------------------------------------//
//         MÁQUINA DE ESTADOS           //
//--------------------------------------//

//LEGENDA:
//2'd0 : IDLE
//2'd1 : OPERAÇÃO
//2'd2 : READY

always @(posedge clock or posedge reset)
begin
    if(reset == 1'b1)
    begin
        EA <= 2'd0;
    end
    else
    begin
        case(EA)
            2'd0 : begin
                if(start == 1'b1)
                begin
                    EA <= 2'd1;
                end
            end
            2'd1 : begin
                if(count == 3'd7)
                begin
                    EA <= 2'd2;
                end
            end
            2'd2 : begin
                if(ready == 1'b1)
                begin
                    EA <= 2'd0;
                end
            end
        endcase   
    end
end

always @(posedge clock)
begin
    if((EA == 'd0 || EA == 2'd2 || start == 1'b1) && EA != 2'd1)
    begin
        count = 3'd0;
    end
    else
    begin
        if(loop == 1'b1)
        begin
            count <= count;
        end
        else
        begin
        count <= count + 1'd1;
        end
    end
end

always @(posedge clock)
begin
    if(loop == 1'b0)
    begin
        if(EA == 2'd1)
        begin
            loopcount <= loopcount;
        end
        else
        begin
        loopcount = 3'd0;
        end
    end
    else
    begin
        loopcount <= loopcount + 1'd1;
    end
end

always @(posedge clock or posedge reset)
begin
    if(reset == 1'b1)
    begin
        mantissa_a <= 23'd0;
        mantissa_b <= 23'd0;
        mantissa_o <= 23'd0;
        expoente_a <= 8'd0;
        expoente_b <= 8'd0;
        expoente_o <= 8'd0;
        A <= 1'b0;
        soma <= 1'b0;
    end
    else
    begin
        case(count)
        3'd0 : begin //COLOCANDO O VALOR NOS REGISTRADORES
            expoente_a <= data_a[30:23];
            expoente_b <= data_b[30:23];
            virgula <= 7'd22;
            erro <= 1'b0;
            mantissa_soma <= 48'd0;
            mantissa_a <= {1'b1, data_a[22:0]};
            mantissa_b <= {1'b1, data_b[22:0]};
            soma <= 1'b0;
            erro <= 1'b0;
        end
        3'd1 : begin //EXECUÇÃO DA PRÉ-SOMA
            if(expoente_calculo > 9'd23)
            begin
                if(expoente_a > expoente_b)
                begin
                    mantissa_soma <= {1'b0, mantissa_a, 23'd0};
                    expoente_o <= expoente_b;
                    A <= 1'b1;
                end
                else
                begin
                    mantissa_soma <= {1'b0, mantissa_b, 23'd0};
                    expoente_o <= expoente_a;
                end
            end
            else if(expoente_calculo <= 9'd23 && expoente_calculo != 9'd0)
            begin
                if(expoente_a > expoente_b)
                begin
                    mantissa_soma <= mantissa_a << expoente_calculo;
                    expoente_o <= expoente_b;
                    A <= 1'b1;
                    
                end
                else
                begin
                    mantissa_soma <= mantissa_b << expoente_calculo;
                    
                    expoente_o <= expoente_a;
                end
            end
            else
            begin
                expoente_o <= expoente_a;
                mantissa_soma <= mantissa_a;
                A <= 1'b1;
            end
        end
        3'd2 : begin //SOMA
            if(data_a[31] == 1'b1)
            begin
                if(A == 1'b1)
                begin
                    mantissa_soma <= ~mantissa_soma + 1'b1;
                end
                else
                begin
                    mantissa_a <= ~mantissa_a + 1'b1;
                end
            end
            if(data_b[31] == 1'b1)
            begin
                if(A == 1'b0)
                begin
                    mantissa_soma <= ~mantissa_soma + 1'b1;
                end
                else
                begin
                    mantissa_b <= ~mantissa_b + 1'b1;
                end
            end
        
        end
        3'd3 : begin //SOMA
        if(expoente_a > expoente_b && expoente_calculo < 8'd23)
        begin
            erro <= mantissa_b[expoente_calculo];
        end
        else if (expoente_calculo < 8'd23)
        begin
            erro <= mantissa_a[expoente_calculo];
        end
                if(op == 1'b0)
                begin
                    if(data_b == 1'b1)
                    begin
                        mantissa_soma[47:24] <= mantissa_soma[47:24] + 24'hFFFFFF;
                        mantissa_soma[23:0] <= mantissa_soma[23:0] + mantissa_b;
                    end
                    else
                    begin
                    mantissa_soma <= mantissa_soma + mantissa_b;
                    end
                end
                else
                begin
                if(data_b == 1'b1)
                    begin
                        mantissa_soma[47:24] <= mantissa_soma[47:24] - 24'hFFFFFF;
                        mantissa_soma[23:0] <= mantissa_soma[23:0] - mantissa_b;
                    end
                    else
                    begin
                    mantissa_soma <= mantissa_soma - mantissa_b;
                    end 
                end
        end
        3'd4 : begin //ACHAR O SINAL DO PONTO FLUTUANTE
        if(mantissa_soma[47] == 1'b1)
        begin
            sinal_o <= 1'b1;
            mantissa_soma <= ~mantissa_soma + 1'b1;
        end
        else
        begin
            sinal_o <= 1'b0;
        end
            
        end
        3'd5 : begin //ACHAR O EXPOENTE
        
        if(|mantissa_soma[46:24] == 1'b1)
            begin
                //loop <= 1'b1;
                soma <= 1'b1;
                mantissa_soma <= mantissa_soma >> 1'b1;
            end
        else
        begin
            if(|mantissa_soma[22:0] == 1'b1)
            begin
                //soma <= 1'b0;
                mantissa_soma <= mantissa_soma << 1'b1;
            end
        end
        end
        3'd6 : begin //CORRIGIR O EXPOENTE

        if(soma == 1'b1)
        begin
            expoente_o <= expoente_o + loopcount;
        end
        else
        begin
            expoente_o <= expoente_o - loopcount;
        end

        end
        3'd7 : begin //CORRIGIR O EXPOENTE
        mantissa_o <= mantissa_soma[22:0];
        end
        endcase
    end
end

assign expoente_calculo = (expoente_a > expoente_b) ? expoente_a - expoente_b : (expoente_b > expoente_a) ? expoente_b - expoente_a : 8'd0;
assign data_o[31] = (EA == 2'd2) ? sinal_o : 1'b0;
assign data_o[30:23] = (EA == 2'd2) ? expoente_o[7:0] : 8'd0;
assign data_o[22:0] = (EA == 2'd2 && complemento == 1'b1) ? mantissa_o - erro : (EA == 2'd2 && complemento == 1'b0) ? mantissa_o + erro : 8'd0;
assign busy = (EA == 2'd1) ? 1'b1 : 1'b0;
assign ready = (EA == 2'd2) ? 1'b1 : 1'b0;
assign complemento = ((op == 1'b1 && data_a[31] == data_b[31]) || (op == 1'b0 && data_a[31] != data_b[31])) ? 1'b1 : 1'b0;
assign mantissa_b_inv = ~mantissa_b + 1'b1;
assign loop1 = (count == 3'd5 && (|mantissa_soma[46:24] == 1'b1)) ? 1'b1 : 1'b0;
assign loop2 = (count == 3'd5 && (|mantissa_soma[22:0] == 1'b1) && loop1 == 1'b0 && mantissa_soma[23] != 1'b1) ? 1'b1 : 1'b0;
assign loop = (loop1 || loop2 == 1'b1) ? 1'b1 : 1'b0;
endmodule
