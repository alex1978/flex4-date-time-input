//------------------------------------------------------------------------------
//
//Copyright (c) 2012 Michael Heier 
// 
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
//to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 
// 
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. 
// 
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
//CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
//OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
//
//------------------------------------------------------------------------------

package com.hs.components
{
	import com.hs.skins.DateTimeInputSkin;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flashx.textLayout.operations.InsertTextOperation;
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.FlexEvent;
	import spark.components.ComboBox;
	import spark.components.NumericStepper;
	import spark.components.Spinner;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.core.IDisplayText;
	import spark.events.TextOperationEvent;
	
	[SkinState( "standard" )]
	[SkinState( "militaryTime" )]
	public class DateTimeInput extends SkinnableComponent
	{
		
		//======================================
		// public properties 
		//======================================
		
		protected var _allowValueWrap:Boolean = true;
		
		[Bindable( "allowValueWrapChanged" )]
		public function get allowValueWrap():Boolean
		{
			return _allowValueWrap;
		}
		
		public function set allowValueWrap( value:Boolean ):void
		{
			_allowValueWrap = value;
			allowValueWrapChanged = true;
			invalidateProperties();
			dispatchEvent( new Event( "allowValueWrapChanged" ) );
		}
		
		[SkinPart( required = "true" )]
		public var amPm:ComboBox;
		
		[Bindable]
		public var amValue:String = "AM";
		
		protected var _chainInputs:Boolean = true;
		
		[Bindable( "chainInputsChanged" )]
		public function get chainInputs():Boolean
		{
			return _chainInputs;
		}
		
		public function set chainInputs( value:Boolean ):void
		{
			_chainInputs = value;
			dispatchEvent( new Event( "chainInputsChanged" ) );
		}
		
		[SkinPart( required = "true" )]
		public var dateInput:DateField;
		
		protected var _display2DigitHours:Boolean;
		
		[Bindable( "display2DigitHoursChanged" )]
		public function get display2DigitHours():Boolean
		{
			return _display2DigitHours;
		}
		
		public function set display2DigitHours( value:Boolean ):void
		{
			_display2DigitHours = value;
			display2DigitHoursChanged = true;
			invalidateProperties();
			dispatchEvent( new Event( "display2DigitHoursChanged" ) );
		}
		
		protected var _errorString:String;
		
		override public function set errorString( value:String ):void
		{
			_errorString = value;
			errorStringChanged = true;
			invalidateProperties();
		}
		
		[SkinPart( required = "true" )]
		public var hourInput:TextInput;
		
		[SkinPart( required = "true" )]
		public var hourSpinner:Spinner;
		
		protected var _militaryTime:Boolean = false;
		
		[Bindable( "militaryTimeChanged" )]
		public function get militaryTime():Boolean
		{
			return _militaryTime;
		}
		
		public function set militaryTime( value:Boolean ):void
		{
			_militaryTime = value;
			militaryTimeChanged = true;
			invalidateSkinState();
			invalidateProperties();
			dispatchEvent( new Event( "militaryTimeChanged" ) );
		}
		
		[SkinPart( required = "true" )]
		public var minuteInput:TextInput;
		
		[SkinPart( required = "true" )]
		public var minuteSpinner:Spinner;
		
		protected var _minuteStepSize:Number = 1;
		
		[Bindable( "minuteStepSizeChanged" )]
		public function get minuteStepSize():Number
		{
			return _minuteStepSize;
		}
		
		public function set minuteStepSize( value:Number ):void
		{
			_minuteStepSize = value;
			minuteStepSizeChanged = true;
			invalidateProperties();
			dispatchEvent( new Event( "minuteStepSizeChanged" ) );
		}
		
		[Bindable]
		public var pmValue:String = "PM";
		
		protected var _selectedDate:Date;
		
		[Bindable( "change" )]
		public function get selectedDate():Date
		{
			return _selectedDate;
		}
		
		public function set selectedDate( value:Date ):void
		{
			_selectedDate = value;
			selectedDateChanged = true;
			invalidateProperties();
			dispatchEvent( new CalendarLayoutChangeEvent( CalendarLayoutChangeEvent.CHANGE, false, false, selectedDate ) );
		}
		
		[SkinPart( required = "true" )]
		public var separater:IDisplayText;
		
		//======================================
		// protected properties 
		//======================================
		
		protected var allowValueWrapChanged:Boolean;
		
		protected var display2DigitHoursChanged:Boolean;
		
		protected var errorStringChanged:Boolean;
		
		protected var hourSpinnerDirection:String;
		
		protected var militaryTimeChanged:Boolean;
		
		protected var minuteSpinnerDirection:String;
		
		protected var minuteStepSizeChanged:Boolean;
		
		protected var previousHourSpinnerValue:Number;
		
		protected var previousMinuteSpinnerValue:Number;
		
		protected var selectedDateChanged:Boolean
		
		//======================================
		// constructor 
		//======================================
		
		public function DateTimeInput()
		{
			super();
			setStyle( "skinClass", DateTimeInputSkin );
		
		}
		
		
		//======================================
		// protected methods 
		//======================================
		
		protected function amPmChange_handler( event:Event ):void
		{
			setSelectedDate( dateInput.selectedDate, get24Hours( hourSpinner.value, militaryTime ), minuteSpinner.value );
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if ( allowValueWrapChanged )
			{
				allowValueWrapChanged = false;
				hourSpinner.allowValueWrap = minuteSpinner.allowValueWrap = allowValueWrap;
			}
			
			if ( minuteStepSizeChanged )
			{
				minuteStepSizeChanged = false;
				minuteSpinner.stepSize = minuteStepSize;
			}
			
			if ( errorStringChanged )
			{
				errorStringChanged = false;
				dateInput.errorString = _errorString;
			}
			
			if ( display2DigitHoursChanged )
			{
				display2DigitHoursChanged = false;
				selectedDateChanged = true;
			}
			
			if ( militaryTimeChanged )
			{
				militaryTimeChanged = false;
				selectedDateChanged = true;
				hourSpinner.minimum = militaryTime ? 0 : 1;
				hourSpinner.maximum = militaryTime ? 23 : 12;
			}
			
			if ( selectedDateChanged )
			{
				selectedDateChanged = false;
				
				dateInput.selectedDate = _selectedDate;
				
				if ( militaryTime )
				{
					hourSpinner.value = _selectedDate.hours;
				}
				else
				{
					hourSpinner.value = _selectedDate.hours > 12 ? _selectedDate.hours - 12 : ( _selectedDate.hours == 0 ? 12 : _selectedDate.hours );
					amPm.selectedIndex = _selectedDate.hours >= 12 ? 1 : 0;
				}
				
				setHoursText( hourSpinner.value );
				
				minuteSpinner.value = _selectedDate.minutes;
				setMinutesText( minuteSpinner.value );
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if ( !_selectedDate )
				selectedDate = new Date();
		}
		
		protected function dateInputChange_handler( event:CalendarLayoutChangeEvent ):void
		{
			setSelectedDate( event.newDate, get24Hours( hourSpinner.value, militaryTime ), minuteSpinner.value );
		}
		
		protected function decrementDate():void
		{
			var newDate:Date = new Date( dateInput.selectedDate.time );
			newDate.date--;
			dateInput.selectedDate = newDate;
		}
		
		protected function decrementHour():void
		{
			if ( militaryTime && hourSpinner.value == 0 )
			{
				hourSpinner.value = 23;
				decrementDate();
			}
			else if ( !militaryTime && amPm.selectedIndex == 0 && hourSpinner.value == 12 )
			{
				hourSpinner.value--;
				amPm.selectedIndex = 1;
				decrementDate();
			}
			else if ( !militaryTime && amPm.selectedIndex == 0 && hourSpinner.value == 1 )
			{
				hourSpinner.value = 12;
			}
			else if ( !militaryTime && amPm.selectedIndex == 1 && hourSpinner.value == 12 )
			{
				hourSpinner.value--;
				amPm.selectedIndex = 0;
			}
			else if ( !militaryTime && amPm.selectedIndex == 1 && hourSpinner.value == 1 )
			{
				hourSpinner.value = 12;
			}
			else
				hourSpinner.value--;
			
			setHoursText( hourSpinner.value );
		}
		
		protected function get24Hours( value:Number, militaryTime:Boolean ):Number
		{
			if ( militaryTime )
				return value;
			else
			{
				if ( amPm.selectedIndex == 0 )
					return value == 12 ? 0 : value;
				else
					return value == 12 ? 12 : value + 12;
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			return militaryTime ? "militaryTime" : "standard";
		}
		
		protected function hourInputChange_handler( event:TextOperationEvent ):void
		{
			hourSpinner.value = int( hourInput.text );
			setSelectedDate( dateInput.selectedDate, get24Hours( hourSpinner.value, militaryTime ), minuteSpinner.value );
		}
		
		protected function hourInputChanging_handler( event:TextOperationEvent ):void
		{
			var operation:InsertTextOperation = event.operation as InsertTextOperation;
			
			if ( operation )
			{
				var text:String;
				
				if ( !operation.deleteSelectionState )
					text = hourInput.text;
				else if ( operation.deleteSelectionState.absoluteEnd == 2 && operation.deleteSelectionState.absoluteStart == 0 )
					text = "";
				else
					text = hourInput.text.charAt( operation.deleteSelectionState.absoluteEnd == 2 ? 0 : 1 );
				
				var hours:Number = operation.absoluteStart == 1 ? Number( text + operation.text ) : Number( operation.text + text );
				
				if ( militaryTime && hours > 23 || !militaryTime && ( hours > 12 || hours < 1 ) )
				{
					event.preventDefault();
					event.stopImmediatePropagation();
				}
			}
		}
		
		protected function hourInputFocusOut_handler( event:FocusEvent ):void
		{
			setHoursText( hourSpinner.value );
		}
		
		protected function hourSpinnerChange_handler( event:Event = null ):void
		{
			setHoursText( hourSpinner.value );
			
			if ( allowValueWrap && chainInputs )
			{
				switch ( hourSpinnerDirection )
				{
					case "up":
						
						if ( militaryTime && previousHourSpinnerValue == 23 )
							incrementDate();
						else if ( !militaryTime && amPm.selectedIndex == 1 && previousHourSpinnerValue == 11 )
						{
							amPm.selectedIndex = 0;
							incrementDate();
						}
						
						break;
					
					case "down":
						
						if ( militaryTime && previousHourSpinnerValue == 0 )
							decrementDate();
						else if ( !militaryTime && amPm.selectedIndex == 0 && previousHourSpinnerValue == 12 )
						{
							amPm.selectedIndex = 1;
							decrementDate();
						}
						
						break;
				}
				
				previousHourSpinnerValue = hourSpinner.value;
			}
			
			setSelectedDate( dateInput.selectedDate, get24Hours( hourSpinner.value, militaryTime ), minuteSpinner.value );
		}
		
		protected function incrementDate():void
		{
			var newDate:Date = new Date( dateInput.selectedDate.time );
			newDate.date++;
			dateInput.selectedDate = newDate;
		}
		
		protected function incrementHour():void
		{
			if ( militaryTime && hourSpinner.value == 23 )
			{
				hourSpinner.value = 0;
				incrementDate();
			}
			else if ( !militaryTime && amPm.selectedIndex == 1 && hourSpinner.value == 11 )
			{
				hourSpinner.value++;
				amPm.selectedIndex = 0;
				incrementDate();
			}
			else if ( !militaryTime && amPm.selectedIndex == 1 && hourSpinner.value == 12 )
			{
				hourSpinner.value = 1;
			}
			else if ( !militaryTime && amPm.selectedIndex == 0 && hourSpinner.value == 11 )
			{
				hourSpinner.value++;
				amPm.selectedIndex = 1;
			}
			else if ( !militaryTime && amPm.selectedIndex == 0 && hourSpinner.value == 12 )
			{
				hourSpinner.value = 1;
			}
			else
				hourSpinner.value++;
			
			setHoursText( hourSpinner.value );
		}
		
		protected function minuteInputChange_handler( event:TextOperationEvent ):void
		{
			minuteSpinner.value = int( minuteInput.text );
			setSelectedDate( dateInput.selectedDate, get24Hours( hourSpinner.value, militaryTime ), minuteSpinner.value );
		}
		
		protected function minuteInputChanging_handler( event:TextOperationEvent ):void
		{
			var operation:InsertTextOperation = event.operation as InsertTextOperation;
			
			if ( operation )
			{
				var text:String;
				
				if ( !operation.deleteSelectionState )
					text = minuteInput.text;
				else if ( operation.deleteSelectionState.absoluteEnd == 2 && operation.deleteSelectionState.absoluteStart == 0 )
					text = "";
				else
					text = minuteInput.text.charAt( operation.deleteSelectionState.absoluteEnd == 2 ? 0 : 1 );
				
				//there are only 2 positions
				var minutes:Number = operation.absoluteStart == 1 ? Number( text + operation.text ) : Number( operation.text + text );
				
				if ( minutes > 59 )
				{
					event.preventDefault();
					event.stopImmediatePropagation();
				}
			}
		}
		
		protected function minuteInputFocusOut_handler( event:FocusEvent ):void
		{
			setMinutesText( minuteSpinner.value );
		}
		
		protected function minuteSpinnerChange_handler( event:Event = null ):void
		{
			setMinutesText( minuteSpinner.value );
			
			if ( allowValueWrap && chainInputs )
			{
				switch ( minuteSpinnerDirection )
				{
					case "up":
						if ( previousMinuteSpinnerValue > minuteSpinner.value )
							incrementHour();
						break;
					
					case "down":
						if ( previousMinuteSpinnerValue < minuteSpinner.value )
							decrementHour();
						break;
				}
				
				previousMinuteSpinnerValue = minuteSpinner.value;
			}
			
			setSelectedDate( dateInput.selectedDate, get24Hours( hourSpinner.value, militaryTime ), minuteSpinner.value );
		}
		
		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
			
			var updateSelectedDate:Boolean;
			
			switch ( instance )
			{
				case separater:
					separater.text = ":";
					break;
				
				case hourInput:
					hourInput.maxChars = 2;
					hourInput.restrict = "0-9";
					hourInput.addEventListener( TextOperationEvent.CHANGING, hourInputChanging_handler );
					hourInput.addEventListener( TextOperationEvent.CHANGE, hourInputChange_handler );
					hourInput.addEventListener( FocusEvent.FOCUS_OUT, hourInputFocusOut_handler );
					break;
				
				case minuteInput:
					minuteInput.maxChars = 2;
					minuteInput.restrict = "0-9";
					minuteInput.addEventListener( TextOperationEvent.CHANGING, minuteInputChanging_handler );
					minuteInput.addEventListener( TextOperationEvent.CHANGE, minuteInputChange_handler );
					minuteInput.addEventListener( FocusEvent.FOCUS_OUT, minuteInputFocusOut_handler );
					break;
				
				case dateInput:
					dateInput.addEventListener( CalendarLayoutChangeEvent.CHANGE, dateInputChange_handler );
					break;
				
				case hourSpinner:
					hourSpinner.allowValueWrap = allowValueWrap;
					hourSpinner.stepSize = 1;
					hourSpinner.minimum = militaryTime ? 0 : 1;
					hourSpinner.maximum = militaryTime ? 23 : 12;
					hourSpinner.addEventListener( Event.CHANGE, hourSpinnerChange_handler );
					hourSpinner.addEventListener( MouseEvent.MOUSE_DOWN, spinnerMouseDown_handler );
					break;
				
				case minuteSpinner:
					minuteSpinner.allowValueWrap = allowValueWrap;
					minuteSpinner.stepSize = minuteStepSize;
					minuteSpinner.minimum = 0;
					minuteSpinner.maximum = 59;
					minuteSpinner.addEventListener( Event.CHANGE, minuteSpinnerChange_handler );
					minuteSpinner.addEventListener( MouseEvent.MOUSE_DOWN, spinnerMouseDown_handler );
					break;
				
				case amPm:
					amPm.dataProvider = new ArrayCollection( [ amValue, pmValue ] );
					amPm.invalidateSize();
					amPm.invalidateDisplayList();
					amPm.addEventListener( Event.CHANGE, amPmChange_handler );
					break;
			}
		
		}
		
		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );
			
			switch ( instance )
			{
				
				case hourInput:
					hourInput.removeEventListener( TextOperationEvent.CHANGING, hourInputChanging_handler );
					hourInput.removeEventListener( TextOperationEvent.CHANGE, hourInputChange_handler );
					hourInput.removeEventListener( FocusEvent.FOCUS_OUT, hourInputFocusOut_handler );
					break;
				
				case minuteInput:
					minuteInput.removeEventListener( TextOperationEvent.CHANGING, minuteInputChanging_handler );
					minuteInput.removeEventListener( TextOperationEvent.CHANGE, minuteInputChange_handler );
					minuteInput.removeEventListener( FocusEvent.FOCUS_OUT, minuteInputFocusOut_handler );
					break;
				
				case dateInput:
					dateInput.removeEventListener( CalendarLayoutChangeEvent.CHANGE, dateInputChange_handler );
					break;
				
				case hourSpinner:
					hourSpinner.removeEventListener( Event.CHANGE, hourSpinnerChange_handler );
					hourSpinner.removeEventListener( MouseEvent.MOUSE_DOWN, spinnerMouseDown_handler );
					break;
				
				case minuteSpinner:
					minuteSpinner.removeEventListener( Event.CHANGE, minuteSpinnerChange_handler );
					minuteSpinner.removeEventListener( MouseEvent.MOUSE_DOWN, spinnerMouseDown_handler );
					break;
				
				case amPm:
					amPm.removeEventListener( Event.CHANGE, amPmChange_handler );
					break;
				
			}
		}
		
		protected function setHoursText( value:int ):void
		{
			hourInput.text = display2DigitHours && value < 10 ? "0" + value : value.toString();
		}
		
		protected function setMinutesText( value:int ):void
		{
			minuteInput.text = value < 10 ? "0" + value : value.toString();
		}
		
		protected function setSelectedDate( date:Date, hours24:Number, minutes:Number ):void
		{
			_selectedDate = new Date( date.time );
			_selectedDate.hours = hours24;
			_selectedDate.minutes = minutes;
			
			dispatchEvent( new CalendarLayoutChangeEvent( CalendarLayoutChangeEvent.CHANGE, false, false, selectedDate ) );
		}
		
		protected function spinnerMouseDown_handler( event:MouseEvent ):void
		{
			switch ( event.currentTarget )
			{
				case hourSpinner:
					hourSpinnerDirection = event.target.id == "decrementButton" ? "down" : "up";
					previousMinuteSpinnerValue = hourSpinner.value;
					break;
				
				case minuteSpinner:
					minuteSpinnerDirection = event.target.id == "decrementButton" ? "down" : "up";
					previousMinuteSpinnerValue = minuteSpinner.value;
					break;
			}
		}
	}
}
