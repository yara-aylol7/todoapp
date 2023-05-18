abstract class AppStates {}

class AppInitialState extends AppStates {}

// cubit with bottomnav
class AppChangeBottomNavBarState extends AppStates {}

// cubit with database
// three states
class AppCreateDatabaseState extends AppStates {}

class AppGetDatabaseState extends AppStates {}

class AppGetDatabaseLoadingState extends AppStates {}

class AppInsertDatabaseState extends AppStates {}

class AppUpdateDatabaseState extends AppStates {}

class AppDeleteDatabaseState extends AppStates {}

// icon bottomsheet :
class AppChangeBottomSheetState extends AppStates {}
