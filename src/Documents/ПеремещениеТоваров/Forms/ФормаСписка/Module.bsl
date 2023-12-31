#Область ОписаниеПеременных
 
&НаКлиенте
Перем Компонент;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Компонент = РаботаСКомпонентомСканераШтрихкодов.ПодключитьКомпонент();
	Если Компонент <> Неопределено Тогда 
		
		Компонент.StartGetScan();           
	КонецЕсли;
	
	//Элементы.КартинкаЧО01ВвестиШтрихкод.Видимость = (Компонент = Неопределено);
КонецПроцедуры


&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)                 
	
	Если Событие = "BarcodeDecodeData" И ВводДоступен() тогда 
		
		ОбработатьВводШтрихкодаНаКлиенте(Данные);			
		Закрыть();		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Компонент = Неопределено;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КартинкаЧО01ВвестиШтрихкодНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВводаШтрихкода", ЭтотОбъект);
	Подсказка = "Введите штрихкод";	
	
	ПоказатьВводСтроки(ОписаниеОповещения, "", Подсказка, 32);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПеремещениеТоваровПоШтрихкоду(Знач Штрихкод)
		
		
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПеремещенияТоваров.Ссылка
		|ИЗ
		|	Документ.ПеремещениеТоваров КАК ПеремещенияТоваров
		|ГДЕ
		|	ПеремещенияТоваров.Штрихкод = &Штрихкод";
	
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;		
	Возврат Неопределено;
КонецФункции


&НаСервере
Функция СоздатьПеремещениеТоваровНаСервере(Знач Штрихкод)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеПеремещенияТоваров = ОбменДанными.ПолучитьДанныеПеремещенияТоваров(Штрихкод);
	
	Если ДанныеПеремещенияТоваров.Свойство("number") Тогда 
				
		ПеремещениеТоваров = Документы.ПеремещениеТоваров.СоздатьДокумент();		
		ПеремещениеТоваров.ПеремещениеТоваров = ДанныеПеремещенияТоваров.id;
		ПеремещениеТоваров.Номер = ДанныеПеремещенияТоваров.number;
		ПеремещениеТоваров.Дата = XMLЗначение(Тип("Дата"), ДанныеПеремещенияТоваров.date);
		ПеремещениеТоваров.Штрихкод = ДанныеПеремещенияТоваров.barcode;
		
		Для Каждого item Из ДанныеПеремещенияТоваров.items Цикл 
			
			НоваяСтрока = ПеремещениеТоваров.Товары.Добавить();
			НоваяСтрока.Штрихкод1 = item.barcode1;
			НоваяСтрока.Штрихкод2 = item.barcode2;
			НоваяСтрока.Код = item.code;
			НоваяСтрока.Артикул = item.art;
			НоваяСтрока.Наименование = item.name;
			НоваяСтрока.Идентификатор = item.id;
			НоваяСтрока.Коэффициент = item.k;
			НоваяСтрока.ЕдиницаИзмерения = item.unit1;
			НоваяСтрока.ЕдиницаИзмеренияМест = item.unit2;
			//НоваяСтрока.Количество = item.qnt;
		КонецЦикла;

		ПеремещениеТоваров.Записать();		                                 
		Возврат ПеремещениеТоваров.Ссылка;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуНовогоДокумента(Штрихкод)
	
	Попытка
		ПеремещениеТоваров = СоздатьПеремещениеТоваровНаСервере(Штрихкод);
	Исключение
		
		ПеремещениеТоваров = Неопределено;
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ПеремещениеТоваров) Тогда
		
		ОткрытьФорму("Документ.ПеремещениеТоваров.Форма.ФормаДокумента", Новый Структура("Ключ", ПеремещениеТоваров));
	Иначе
		
		ПоказатьПредупреждение(, "Ошибка создания перемещения товаров", 5, "Внимание");
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВводШтрихкодаНаКлиенте(Штрихкод)
	
	ПеремещениеТоваров = ПолучитьПеремещениеТоваровПоШтрихкоду(Штрихкод);
	Если ЗначениеЗаполнено(ПеремещениеТоваров) Тогда 
		
		ОткрытьФорму("Документ.ПеремещениеТоваров.Форма.ФормаДокумента", Новый Структура("Ключ", ПеремещениеТоваров));
	Иначе                                     
		
		ОткрытьФормуНовогоДокумента(Штрихкод);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаШтрихкода(Штрихкод, Параметры) Экспорт
    Если НЕ Штрихкод = Неопределено Тогда
        
		ОбработатьВводШтрихкодаНаКлиенте(Штрихкод)
    КонецЕсли;
КонецПроцедуры

#КонецОбласти
