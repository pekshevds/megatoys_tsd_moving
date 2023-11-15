#Область ОписаниеПеременных

Перем Логин;
Перем Пароль;  
Перем ИмяСервера;
Перем ИмяБазы;
Перем Порт;
Перем ЗащищенноеСоединение;

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция ПолучитьДанныеПеремщениеТоваров(Штрихкод)Экспорт 
				
	Структура = Новый Структура;
			
	HTTPСоединение = Новый HTTPСоединение(ИмяСервера, Порт, Логин, Пароль, , , ЗащищенноеСоединение);
	
	Заголовки = Новый Соответствие;
   	HTTPЗапрос = Новый HTTPЗапрос(СтрШаблон("/%1/hs/data-exchange-tsd/api/v1/get-goods-moving?id=%2", ИмяБазы, Штрихкод), Заголовки);
	
	Попытка
		Результат = HTTPСоединение.Получить(HTTPЗапрос);
	Исключение   
		
		Возврат Структура;
	КонецПопытки;
	
	ТелоКакСтрока = Результат.ПолучитьТелоКакСтроку();
		
	Если Результат.КодСостояния >= 200 И Результат.КодСостояния < 300 Тогда 
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ТелоКакСтрока);
		Структура = ПрочитатьJSON(ЧтениеJSON);        
   	 	ЧтениеJSON.Закрыть();
	Иначе
		
		Возврат Структура;
	КонецЕсли;
	
	Возврат Структура;
КонецФункции

Функция ОтправитьДанныеПеремещенияТоваров(ОтгрузочныйЛист)Экспорт 
	
	HTTPСоединение = Новый HTTPСоединение(ИмяСервера, Порт, Логин, Пароль, , , ЗащищенноеСоединение);
	
	Заголовки = Новый Соответствие;
   	HTTPЗапрос = Новый HTTPЗапрос(СтрШаблон("/%1/hs/data-exchange-tsd/api/v1/post-goods-taking", ИмяБазы), Заголовки);
	
	HTTPЗапрос.УстановитьТелоИзСтроки(ПолучитьОписаниеПеремещенияТоваров(ОтгрузочныйЛист), КодировкаТекста.UTF8);
	
	Попытка
		Результат = HTTPСоединение.ВызватьHTTPМетод("POST", HTTPЗапрос);
	Исключение
		
		Возврат Ложь;
	КонецПопытки;
		
	Если Результат.КодСостояния >= 200 И Результат.КодСостояния < 300 Тогда 
		
		Возврат Истина;
	Иначе
		
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Функция ПроверитьСвязь()Экспорт
	
	HTTPСоединение = Новый HTTPСоединение(ИмяСервера, Порт, Логин, Пароль, , , ЗащищенноеСоединение);
	
	Заголовки = Новый Соответствие;
   	HTTPЗапрос = Новый HTTPЗапрос(СтрШаблон("/%1/hs/data-exchange-tsd/api/v1/test", ИмяБазы), Заголовки);
	
	Попытка
		Результат = HTTPСоединение.Получить(HTTPЗапрос);
	Исключение
		
		Возврат Ложь;
	КонецПопытки;
	
	//ТелоКакСтрока = Результат.ПолучитьТелоКакСтроку();
		
	//Структура = Новый Структура;
	Если Результат.КодСостояния >= 200 И Результат.КодСостояния < 300 Тогда 
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ФункцияПреобразованияЗаписи(Свойство, Значение, ДополнительныеПараметры, Отказ) Экспорт
    Если ТипЗнч(Значение) = Тип("УникальныйИдентификатор") Тогда
        Возврат Строка(Значение);
    КонецЕсли;
    Отказ = Истина;
КонецФункции

Функция КонтрольныйСимволEAN13ТО(Штрихкод)

	Результат   = "";
	Сумма       = 0;
	Коэффициент = 1;

	Индекс = Неопределено;
	Для Индекс = 1 По 12 Цикл
		КодСимв     = КодСимвола(Штрихкод, Индекс);
		Сумма       = Сумма + Коэффициент * (КодСимв - 48);
		Коэффициент = 4 - Коэффициент;
	КонецЦикла;
	Сумма     = (10 - Сумма % 10) % 10;
	Результат = Символ(Сумма + 48);

	Возврат Результат;

КонецФункции // КонтрольныйСимволEAN13ТО()

Функция СфомироватьШтрихкодПоНомеру(Номер, Префикс = "3") 
	
	Штрикод = Префикс + Формат(Число(Номер), "ЧЦ=11; ЧВН=; ЧГ=0");
	//Возврат Штрикод + РаботаСТорговымОборудованием.КонтрольныйСимволEAN13ТО(Штрикод);
	Возврат Штрикод + КонтрольныйСимволEAN13ТО(Штрикод);
КонецФункции

Функция ДанныеВJSON(Данные)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();	
    ЗаписатьJSON(ЗаписьJSON, Данные, Новый НастройкиСериализацииJSON, "ФункцияПреобразованияЗаписи");
	Возврат ЗаписьJSON.Закрыть();
КонецФункции

Функция ПолучитьОписаниеПеремещенияТоваров(ПеремещениеТоваров)
	
	СтруктураВозрата = Новый Структура;
	СтруктураВозрата.Вставить("number", ПеремещениеТоваров.Номер);	
	СтруктураВозрата.Вставить("date", XMLСтрока(ПеремещениеТоваров.Дата));
	СтруктураВозрата.Вставить("id", Строка(ПеремещениеТоваров.ПеремещениеТоваров));
	СтруктураВозрата.Вставить("ending", XMLСтрока(ПеремещениеТоваров.ДатаЗакрытия));
	
	
	СборочныеЛисты = Новый Массив;
	Для Каждого ТекСтрока Из ПеремещениеТоваров.Товары Цикл 
		
		Структура = Новый Структура();
		Структура.Вставить("id", ТекСтрока.Идентификатор);
		Структура.Вставить("qnt", ТекСтрока.Количество);
		
		СборочныеЛисты.Добавить(Структура);
	КонецЦикла;	
	
	СтруктураВозрата.Вставить("items", СборочныеЛисты);
	
	Возврат ДанныеВJSON(СтруктураВозрата);
КонецФункции

#КонецОбласти

#Область Инициализация

Логин = Константы.Логин.Получить();//"Admin";
Пароль = Константы.Пароль.Получить();//"1qazXSW@";
ИмяСервера = Константы.ИмяСервера.Получить();//"146.120.176.6";
ИмяБазы = Константы.ИмяБазы.Получить();
Порт = Константы.Порт.Получить();
Порт = ?(Порт = 0, 80, Порт);
ЗащищенноеСоединение = ?(Константы.ЗащищенноеСоединение.Получить(), Новый ЗащищенноеСоединениеOpenSSL(), Неопределено);

#КонецОбласти