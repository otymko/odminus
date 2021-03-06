
Функция РазобратьПараметрыЗапроса(Знач Параметры) Экспорт

	Результат = Новый Соответствие;

	Пары = СтрРазделить(Сред(Параметры,2), "&");
	Для Каждого Пара Из Пары Цикл
		Поз = СтрНайти(Пара, "=");
		Если Поз <> 0 Тогда
			Ключ = Лев(Пара, Поз-1);
			Значение = Сред(Пара, Поз+1);
			Результат.Вставить(Ключ, Значение);
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;
КонецФункции

Функция ПоляФормыВСтруктуру(ДанныеФормы) Экспорт
	
	Поля = Новый Структура;
	Для Каждого КлючИЗначение Из ДанныеФормы Цикл
		Поля.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;

	Возврат Поля;

КонецФункции

Функция ОбъектКластераВСтруктуру(ПараметрыОбъекта, ОбъектКластера) Экспорт
	
	ПоляОбъекта = Новый Структура;
	Для Каждого Описание Из ПараметрыОбъекта Цикл
		ПоляОбъекта.Вставить(Описание.Ключ, ОбъектКластера[Описание.Значение.ИмяПоляРак]); 
	КонецЦикла;

	Возврат ПоляОбъекта;

КонецФункции

Функция УстановитьЗаголовок(Знач Контроллер, Знач Заголовок = "") Экспорт
	
	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = "Odminus";
	КонецЕсли;

	Контроллер.ДанныеПредставления["Title"] = Заголовок;

КонецФункции

Функция ПолучитьАдминистрированиеКластера(Знач СетевоеИмя, Знач Порт, Знач Версия1С = "8.3") Экспорт

	Администрирование = Новый АдминистрированиеКластера(
			СетевоеИмя,
			Порт,
			Версия1С
		);
	Администрирование.УстановитьОбработчикОшибокКоманд(Новый ОбработчикОшибокRAC());
	Возврат Администрирование;

КонецФункции

Функция ИдентификаторКластера(Знач ЗапросHttp) Экспорт
	Параметры = ЗапросHttp.ПараметрыЗапроса();
	Возврат Параметры["cluster"];
КонецФункции

Функция ИдентификаторАгента(Знач Маршрутизатор) Экспорт

	Идентификатор = Маршрутизатор.ЗначенияМаршрута["agent"];
	Возврат Идентификатор;

КонецФункции

Функция ПолучитьКластерПоИд(Знач Маршрутизатор) Экспорт
	ИдКластера = ИдентификаторКластера(Маршрутизатор.ЗапросHttp);
	Если ИдКластера = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	Авторизация = Новый Авторизация(Маршрутизатор, "/");
	Авторизация.ВключитьАдминистрирование();
	Администрирование = Авторизация.АдминистрированиеКластера();

	Отбор = Новый Соответствие;
	Отбор.Вставить("Ид",ИдКластера);
	Кластеры = Администрирование.Кластеры().Список(Отбор);
	Если Кластеры.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат Кластеры[0];
КонецФункции