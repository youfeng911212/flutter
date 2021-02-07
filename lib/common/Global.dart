//提供五套可选主题颜色
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_github/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'git_api.dart';
import 'net_cache.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red
];

class Global {
  static SharedPreferences _preferences;
  static Profile profile = Profile();

  //网络缓存对象
   static NetCache netCache = NetCache();
  //可选主题列表
  static List<MaterialColor> get themes => _themes;
  //是否为release版本
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  //初始化全局信息，会在app启动时执行
 static Future init() async{
   WidgetsFlutterBinding.ensureInitialized();
   _preferences = await SharedPreferences.getInstance();
   var _profile = _preferences.getString("profile");
   if(_profile!=null){
     try{
       profile = Profile.fromJson(jsonDecode(_profile));
     }catch (e){
       print(e);
     }

   }
   //如果没有缓存策略，设置默认缓存策略
   profile.cache = profile.cache??CacheConfig()
   ..enable =true
   ..maxAge =3600
   ..maxCount=100;
   //初始化网络请求相关配置
   Git.init();

 }
 //持久化profile信息
static saveProfile(){
   _preferences.setString("profile", jsonEncode(profile.toJson()));
}

}
