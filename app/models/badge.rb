require "csv"

class Badge < ActiveRecord::Base
  fields = %w(company email first_name last_name country title).map(&:to_sym)

  attr_accessible *fields

  fields.each do |field|
    validates field, :presence => { :message => "est un champ obligatoire" }
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << ["Timestamp", "SOCIETE EXPOSANTE QUI A FAIT LA DEMANDE*", "Votre SOCIETE*", "CIVILITE*", "PRENOM*", "NOM*", "PAYS*", "EMAIL*"]
      all.each do |b|
        csv << [b.created_at, "LinuxFr", b.company, b.title, b.first_name, b.last_name, b.country, b.email]
      end
    end
  end
end
