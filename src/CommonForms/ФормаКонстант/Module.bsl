
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КартинкаЧО01ПроверитьСвязьНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если ПроверитьСвязь() Тогда 
		
		ПоказатьПредупреждение(, "Проверка связи прошла успешно", 5, "Внимение");
	Иначе 
		
		ПоказатьПредупреждение(, "Нет связи, проверь настройки или обратись к администратору системы", 5, "Внимение");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПроверитьСвязь()
	
	Инструмент = ОбменДанными.ПолучитьИнструмент();
	Возврат Инструмент.ПроверитьСвязь();
КонецФункции

#КонецОбласти
