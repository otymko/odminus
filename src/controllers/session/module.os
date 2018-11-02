#Использовать irac
#Использовать json

Функция Index() Экспорт
	
	Кластер = ОбщегоНазначения.ПолучитьКластерПоИД(ЭтотОбъект);
	ИнформационнаяБаза_Идентификатор = ОбщегоНазначения.ПолучитьИдентификаторИнформационнойБазыИзПараметровЗапроса(ЭтотОбъект);

	ПараметрыМодели = Новый Структура;
	ПараметрыМодели.Вставить("Кластер_Идентификатор", ?(Кластер = Неопределено, "", Кластер.Ид()));
	ПараметрыМодели.Вставить("ИнформационнаяБаза_Идентификатор", ?(ИнформационнаяБаза_Идентификатор = Неопределено, "", ИнформационнаяБаза_Идентификатор));
	ПараметрыМодели.Вставить("СписокИнформационныхБаз", ОбщегоНазначения.ПолучитьСписокИнформационныхБазПоКластеру(ЭтотОбъект, Кластер));
	ПараметрыМодели.Вставить("МодельДанных", ПолучитьМодельСпискаСессий());
	
	Возврат Представление("index", ПараметрыМодели);
	
КонецФункции

Функция GetSessionData() Экспорт
	ПолучитьТолькоСтруктуру = ОбщегоНазначения.ПолучитьЗначениеПараметраЗапроса(ЭтотОбъект, "empty") <> Неопределено;
	Возврат Содержимое(ПолучитьДанныеДляСписка(ЭтотОбъект, ПолучитьТолькоСтруктуру));
КонецФункции

Функция ПолучитьДанныеДляСписка(Роутер, ТолькоСтруктура)
	
	МодельДанных = ПолучитьМодельСпискаСессий();
	Если ТолькоСтруктура Тогда
		СписокСеансов = Новый Массив;
	Иначе
		БазаИД = ОбщегоНазначения.ПолучитьЗначениеПараметраЗапроса(ЭтотОбъект, "db");
		Кластер = ОбщегоНазначения.ПолучитьКластерПоИД(Роутер);
		ИнформационнаяБаза = ОбщегоНазначения.ПолучитьИнформационнуюБазуПоИд(Роутер, БазаИД, Кластер);
		АвторизацияБазы = Новый АвторизацияИБ(ЭтотОбъект, Кластер, ИнформационнаяБаза);
		СписокСеансов = ОбщегоНазначения.ПолучитьСписокСеансовИБ(ИнформационнаяБаза);
	КонецЕсли;
	
	Структура = Новый Структура;
	Структура.Вставить("header", Новый Массив);
	Если Не ТолькоСтруктура Тогда
		Структура.Вставить("data", Новый Массив);
	КонецЕсли;
	
	Для Каждого Колонка Из МодельДанных.Колонки Цикл
		Колонка = Новый Структура("name, title, sortable", Колонка , Колонка, true);
		Структура.header.Добавить(Колонка);
	КонецЦикла;
	
	Если Не ТолькоСтруктура Тогда
		Для Каждого Сеанс Из СписокСеансов Цикл
			СтрокаДанных = Новый Массив;
			Для Каждого Колонка Из МодельДанных.Колонки Цикл
				СтрокаДанных.Добавить(Сеанс.Получить(Колонка));
			КонецЦикла;
			Структура.data.Добавить(СтрокаДанных);
		КонецЦикла;
	КонецЕсли;
	
	ПарсерJSON = Новый ПарсерJSON;
	ТелоЗапроса = ПарсерJSON.ЗаписатьJSON(Структура);
	
	Возврат ТелоЗапроса;
	
КонецФункции

Функция ПолучитьМодельСпискаСессий()
	МодельСписка = Новый ПредставлениеСписка;
	МодельСписка.Колонки.Добавить("НомерСеанса");
	//МодельСписка.Колонки.Добавить("Соединение_Ид");
	//МодельСписка.Колонки.Добавить("Процесс_Ид");
	МодельСписка.Колонки.Добавить("Пользователь");
	МодельСписка.Колонки.Добавить("Компьютер");
	МодельСписка.Колонки.Добавить("Приложение");
	//МодельСписка.Колонки.Добавить("Язык");
	МодельСписка.Колонки.Добавить("ВремяНачала");
	МодельСписка.Колонки.Добавить("ПоследняяАктивность");
	//МодельСписка.Колонки.Добавить("Спящий");
	// МодельСписка.Колонки.Добавить("ЗаснутьЧерез");
	// МодельСписка.Колонки.Добавить("ЗавершитьЧерез");
	// МодельСписка.Колонки.Добавить("ЗаблокированоСУБД");
	// МодельСписка.Колонки.Добавить("ЗаблокированоУпр");
	// МодельСписка.Колонки.Добавить("ДанныхВсего");
	// МодельСписка.Колонки.Добавить("Данных5мин");
	// МодельСписка.Колонки.Добавить("КоличествоВызововВсего");
	// МодельСписка.Колонки.Добавить("КоличествоВызовов5мин");
	// МодельСписка.Колонки.Добавить("ДанныхСУБДВсего");
	// МодельСписка.Колонки.Добавить("ДанныхСУБД5мин");
	// МодельСписка.Колонки.Добавить("СоединениеССУБД");
	// МодельСписка.Колонки.Добавить("ЗахваченоСУБД");
	// МодельСписка.Колонки.Добавить("ВремяЗахватаСУБД");
	// МодельСписка.Колонки.Добавить("ВремяВызововВсего");
	// МодельСписка.Колонки.Добавить("ВремяВызововСУБДВсего");
	// МодельСписка.Колонки.Добавить("ВремяВызововТекущее");
	// МодельСписка.Колонки.Добавить("ВремяВызововСУБДТекущее");
	// МодельСписка.Колонки.Добавить("ВремяВызовов5мин");
	// МодельСписка.Колонки.Добавить("ВремяВызововСУБД5мин");
	Возврат МодельСписка;
КонецФункции
