require 'csv'

module FilterCsv
  def self.filter(file_name_input, file_name_output)
    CSV.open(file_name_output, "w") do |csv_output|
      # insere a primeira linha dos 'headers' do novo csv
      csv_output << [
                      "Q001",
                      "Q002",
                      "Q006",
                      "Q025",
                      "Q027",
                      "NU_NOTA_MT"
                    ]
      CSV.foreach(file_name_input, col_sep: ';', row_sep: :auto, headers: true) do |line|
        # Primeiro verifica as variaveis de eliminação para saber se inclui ou não
        if line["NO_MUNICIPIO_RESIDENCIA"] and              # Verifica se há valor da variavel (não é NA)
        line["NO_MUNICIPIO_RESIDENCIA"] == 'São Paulo' and  # Verifica se nasceu em São Paulo
        line["NU_IDADE"] and                                # Verifica se há valor da variavel (não é NA)
        line["NU_IDADE"].to_i < 20 and                      # Verifica se tem até 19 anos
        line["NU_ANO"] == '2018' and                        # Verifica se é o ENEM de 2018
        line["NU_NOTA_CN"] and                              # Verifica se há valor da variavel (não é NA)
        line["NU_NOTA_CH"] and                              # Verifica se há valor da variavel (não é NA)
        line["NU_NOTA_LC"] and                              # Verifica se há valor da variavel (não é NA)
        line["NU_NOTA_MT"] and                              # Verifica se há valor da variavel (não é NA)
        line["TP_STATUS_REDACAO"] and                       # Verifica se há valor da variavel (não é NA)
        line["TP_STATUS_REDACAO"] == '1' and                # Verifica se não teve problemas com a redação
        line["TP_NACIONALIDADE"] and                        # Verifica se há valor da variavel (não é NA)
        line["TP_NACIONALIDADE"] == '1' and                 # Verifica se é brasileiro
        line["TP_ST_CONCLUSAO"] and                         # Verifica se há valor da variavel (não é NA)
        ['1','2'].include? line["TP_ST_CONCLUSAO"] and      # Verifica se ja concluiu ou vai concluir o ensino médio em 2018
        line["IN_TREINEIRO"] and                            # Verifica se há valor da variavel (não é NA)
        line["IN_TREINEIRO"] == '0' and                     # Verifica se não é treineiro
        line["TP_PRESENCA_CN"] and                          # Verifica se há valor da variavel (não é NA)
        line["TP_PRESENCA_CN"] == '1' and                   # Verifica se foi a prova
        line["TP_PRESENCA_CH"] and                          # Verifica se há valor da variavel (não é NA)
        line["TP_PRESENCA_CH"] == '1' and                   # Verifica se foi a prova
        line["TP_PRESENCA_LC"] and                          # Verifica se há valor da variavel (não é NA)
        line["TP_PRESENCA_LC"] == '1' and                   # Verifica se foi a prova
        line["TP_PRESENCA_MT"] and                          # Verifica se há valor da variavel (não é NA)
        line["TP_PRESENCA_MT"] == '1' and                   # Verifica se foi a prova
        line["Q001"] and                                    # Verifica se há valor da variavel (não é NA)
        line["Q001"] != 'H' and                             # Verifica se não escolheu opção inconclusiva
        line["Q002"] and                                    # Verifica se há valor da variavel (não é NA)
        line["Q002"] != 'H' and                             # Verifica se não escolheu opção inconclusiva 
        line["Q006"] and                                    # Verifica se há valor da variavel (não é NA)
        line["Q006"] != 'A' and                             # Verifica se não escolheu opção inconclusiva
        line["Q027"] and                                    # Verifica se há valor da variavel (não é NA)
        line["Q027"] != 'F'                                 # Verifica se não escolheu opção inconclusiva
          # Se entende os condicionais então pega a observação
          csv_output << [
                        line["Q001"],
                        line["Q002"],
                        line["Q006"],
                        line["Q025"],
                        line["Q027"],
                        line["NU_NOTA_MT"]
                        ]
        end
      end
    end
  end
end
