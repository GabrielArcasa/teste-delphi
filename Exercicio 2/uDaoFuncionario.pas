unit uDaoFuncionario;

interface

uses UFuncionario, FireDAC.Comp.Client, uFuncionarioController, System.SysUtils,
  uConexao;

type
  TFuncionarioDao = class
  private
    FConexao: TConexao;
  public
    Constructor Create;
    function IncluirFuncionario(Funcionario: TFuncionario): Boolean;
    Function Carregar: TFDQuery;

    Function IncluirDependentes(Dependentes:TDependente):Boolean;
    Function CarregarDependentes(Codigo: Integer): TFDQuery;
  end;

  { TFuncionarioDao }
implementation

Function TFuncionarioDao.Carregar: TFDQuery;
var
  VQuery: TFDQuery;
begin
  VQuery := FConexao.CriarQuery();
  VQuery.Open('Select Codigo,Nome,CPF,Salario from Funcionarios  ');
  Result := VQuery;

end;

function TFuncionarioDao.CarregarDependentes(Codigo: Integer): TFDQuery;
var
  VQuery: TFDQuery;
begin
  VQuery := FConexao.CriarQuery();
  VQuery.Open
    ('Select Codigo,Nome,IsCalculaIR,IsCalculaINSS,CodigoFuncionario from Dependente Where CodigoFuncionario = :codigo  ',
    [Codigo]);
  Result := VQuery;
end;

constructor TFuncionarioDao.Create;
begin
  FConexao := TFuncionarioControl.GetInstance().Conexao;
end;

function TFuncionarioDao.IncluirDependentes(Dependentes: TDependente): Boolean;
var
  VQuery: TFDQuery;
begin

  VQuery := FConexao.CriarQuery();
  try
    VQuery.ExecSQL('Insert into DEPENDENTE(Nome,IsCalculaIR,IsCalculaINSS,CODIGOFUNCIONARIO) Values (:nome,:CalcularIR,:CalcularINSS,:CODIGOFUNCIONARIO)',[Dependentes.Nome,Dependentes.IsCalculaIR,Dependentes.IsCalculaINSS,Dependentes.CodigoFuncionario]);

    Result := True;
  finally
    VQuery.Free;
  end;

end;
function TFuncionarioDao.IncluirFuncionario(Funcionario: TFuncionario): Boolean;
var
  VQuery: TFDQuery;
begin
  VQuery := FConexao.CriarQuery();
  try
    VQuery.ExecSQL('Insert into Funcionarios(Nome,CPF,Salario) Values (:nome,:cpf,:salario)',[Funcionario.Nome,Funcionario.CPF,Funcionario.Salario]);

    Result := True;
  finally
    VQuery.Free;
  end;

end;

end.
