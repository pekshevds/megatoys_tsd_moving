#Область ПрограммныйИнтерфейс
	
Функция ПолучитьИнструмент()Экспорт 
	
	Инструмент = Обработки.ОбменДанными.Создать();
	Возврат Инструмент;
КонецФункции

Функция ПолучитьДанныеПеремещенияТоваров(Штрихкод)Экспорт 
	
	Инструмент = ПолучитьИнструмент();
	Возврат Инструмент.ПолучитьДанныеПеремщениеТоваров(Штрихкод);	
КонецФункции

Функция ОтправитьПеремещениеТоваров(ПеремещениеТоваров)Экспорт 
	
	Инструмент = ПолучитьИнструмент();
	Возврат Инструмент.ОтправитьДанныеПеремещенияТоваров(ПеремещениеТоваров);	
КонецФункции

//Функция ОтправитьДанныеОтгрузочногоЛиста(СборочныйЛист)Экспорт 
//	
//	Инструмент = ПолучитьИнструмент();
//	Возврат Инструмент.ОтправитьДанныеОтгрузочногоЛиста(СборочныйЛист);	
//КонецФункции

#КонецОбласти