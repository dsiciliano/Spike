package ui.screens
{
	import flash.display.StageOrientation;
	import flash.system.System;
	
	import feathers.controls.DragGesture;
	import feathers.controls.Label;
	import feathers.themes.BaseMaterialDeepGreyAmberMobileTheme;
	import feathers.themes.MaterialDeepGreyAmberMobileThemeIcons;
	
	import model.ModelLocator;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	
	import ui.AppInterface;
	import ui.screens.display.LayoutFactory;
	import ui.screens.display.settings.general.UpdateSettingsList;
	import ui.screens.display.settings.maintenance.DatabaseMaintenanceSettingsList;
	import ui.screens.display.settings.maintenance.SettingsMaintenanceSettingsList;
	
	import utils.Constants;
	import utils.DeviceInfo;
	
	[ResourceBundle("maintenancesettingsscreen")]
	[ResourceBundle("generalsettingsscreen")]

	public class MaintenanceScreen extends BaseSubScreen
	{
		/* Display Objects */
		private var settingsMaintenanceLabel:Label;
		private var settingsMaintenanceSettings:SettingsMaintenanceSettingsList;
		private var databaseMaintenanceLabel:Label;
		private var databaseMaintenanceSettings:DatabaseMaintenanceSettingsList;
		private var updatesSettingsList:UpdateSettingsList;
		private var updateLabel:Label;
		
		public function MaintenanceScreen() 
		{
			super();
			
			setupHeader();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			setupContent();
			adjustMainMenu();
		}
		
		/**
		 * Functionality
		 */
		private function setupHeader():void
		{
			/* Set Header Title */
			title = ModelLocator.resourceManagerInstance.getString('maintenancesettingsscreen','screen_title');
			
			/* Set Header Icon */
			icon = getScreenIcon(MaterialDeepGreyAmberMobileThemeIcons.maintenanceTexture);
			iconContainer = new <DisplayObject>[icon];
			headerProperties.rightItems = iconContainer;
		}
		
		private function setupContent():void
		{
			//Deactivate menu drag gesture 
			AppInterface.instance.drawers.openGesture = DragGesture.NONE;
			
			if (ModelLocator.APPCENTER_MODE)
			{
				//Update Section Label
				updateLabel = LayoutFactory.createSectionLabel(ModelLocator.resourceManagerInstance.getString('generalsettingsscreen','check_for_updates'), true);
				screenRenderer.addChild(updateLabel);
				
				//Update Settings
				updatesSettingsList = new UpdateSettingsList();
				screenRenderer.addChild(updatesSettingsList);
			}
			
			//Settings Section Label
			settingsMaintenanceLabel = LayoutFactory.createSectionLabel(ModelLocator.resourceManagerInstance.getString('maintenancesettingsscreen','settings_section_label'));
			screenRenderer.addChild(settingsMaintenanceLabel);
			
			//Settings Settings
			settingsMaintenanceSettings = new SettingsMaintenanceSettingsList();
			screenRenderer.addChild(settingsMaintenanceSettings);
			
			//Database Section Label
			databaseMaintenanceLabel = LayoutFactory.createSectionLabel(ModelLocator.resourceManagerInstance.getString('maintenancesettingsscreen','database_section_label'));
			screenRenderer.addChild(databaseMaintenanceLabel);
			
			//Database Settings
			databaseMaintenanceSettings = new DatabaseMaintenanceSettingsList();
			screenRenderer.addChild(databaseMaintenanceSettings);
		}
		
		private function adjustMainMenu():void
		{
			AppInterface.instance.menu.selectedIndex = Constants.isPortrait ? 4 : 3;
		}
		
		/**
		 * Event Handlers
		 */
		override protected function onBackButtonTriggered(event:Event):void
		{
			//Activate menu drag gesture
			AppInterface.instance.drawers.openGesture = DragGesture.EDGE;
			
			dispatchEventWith(Event.COMPLETE);
		}

		override protected function onTransitionInComplete(e:Event):void
		{
			//Swipe to pop functionality
			AppInterface.instance.navigator.isSwipeToPopEnabled = true;
		}
		
		override protected function onStarlingBaseResize(e:ResizeEvent):void 
		{
			if (Constants.deviceModel == DeviceInfo.IPHONE_X && !Constants.isPortrait && Constants.currentOrientation == StageOrientation.ROTATED_RIGHT)
			{
				if (settingsMaintenanceLabel != null) settingsMaintenanceLabel.paddingLeft = 30;
				if (databaseMaintenanceLabel != null) databaseMaintenanceLabel.paddingLeft = 30;
				if (updateLabel != null) updateLabel.paddingLeft = 30;
			}
			else
			{
				if (settingsMaintenanceLabel != null) settingsMaintenanceLabel.paddingLeft = 0;
				if (databaseMaintenanceLabel != null) databaseMaintenanceLabel.paddingLeft = 0;
				if (updateLabel != null) updateLabel.paddingLeft = 0;
			}
			
			setupHeaderSize();
		}
		
		/**
		 * Utility
		 */
		override public function dispose():void
		{
			if (settingsMaintenanceSettings != null)
			{
				settingsMaintenanceSettings.removeFromParent();
				settingsMaintenanceSettings.dispose();
				settingsMaintenanceSettings = null;
			}
			
			if (settingsMaintenanceLabel != null)
			{
				settingsMaintenanceLabel.removeFromParent();
				settingsMaintenanceLabel.dispose();
				settingsMaintenanceLabel = null;
			}
			
			if (databaseMaintenanceSettings != null)
			{
				databaseMaintenanceSettings.removeFromParent();
				databaseMaintenanceSettings.dispose();
				databaseMaintenanceSettings = null;
			}
			
			if (databaseMaintenanceLabel != null)
			{
				databaseMaintenanceLabel.removeFromParent();
				databaseMaintenanceLabel.dispose();
				databaseMaintenanceLabel = null;
			}
			
			if (updatesSettingsList != null)
			{
				updatesSettingsList.removeFromParent();
				updatesSettingsList.dispose();
				updatesSettingsList = null;
			}
			
			if (updateLabel != null)
			{
				updateLabel.removeFromParent();
				updateLabel.dispose();
				updateLabel = null;
			}
			
			super.dispose();
			
			System.pauseForGCIfCollectionImminent(0);
		}
		
		override protected function draw():void 
		{
			super.draw();
			icon.x = Constants.stageWidth - icon.width - BaseMaterialDeepGreyAmberMobileTheme.defaultPanelPadding;
		}
	}
}