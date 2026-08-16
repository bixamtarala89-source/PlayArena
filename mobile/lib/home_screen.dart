import 'package:flutter/material.dart';
import 'cricket_screen.dart';
import 'teen_patti_screen.dart';
import 'game_history_screen.dart';
import 'profile_settings_screen.dart';
import 'notifications_screen.dart';
import 'admin_screen.dart';
import 'live_prediction_screen.dart';

const _bg=Color(0xFF06131F),_surface=Color(0xFF0B2030),_surface2=Color(0xFF102B3D),_teal=Color(0xFF18D6B0),_amber=Color(0xFFFFB547);
class HomeScreen extends StatefulWidget{const HomeScreen({super.key});@override State<HomeScreen> createState()=>_HomeScreenState();}
class _HomeScreenState extends State<HomeScreen>{
 int navIndex=0;void open(Widget page)=>Navigator.push(context,MaterialPageRoute(builder:(_)=>page));
 void showAddChips(){showModalBottomSheet(context:context,backgroundColor:_surface2,showDragHandle:true,builder:(context)=>SafeArea(child:Padding(padding:const EdgeInsets.fromLTRB(20,8,20,24),chil[...]
 void nav(int i){setState(()=>navIndex=i);if(i==1){return;}if(i==2){open(const GameHistoryScreen());}if(i==3){showAddChips();}if(i==4){open(const ProfileSettingsScreen());}Future.delayed(const Dur[...]
 @override Widget build(BuildContext context)=>Scaffold(backgroundColor:_bg,drawer:_GameDrawer(addChips:showAddChips),bottomNavigationBar:NavigationBar(selectedIndex:navIndex,onDestinationSelected[...]
 SliverToBoxAdapter(child:Builder(builder:(context)=>Padding(padding:const EdgeInsets.fromLTRB(14,10,14,8),child:Row(children:[IconButton(onPressed:()=>Scaffold.of(context).openDrawer(),icon:const[...]
 SliverPadding(padding:const EdgeInsets.symmetric(horizontal:14),sliver:SliverList(delegate:SliverChildListDelegate([
 Container(padding:const EdgeInsets.all(15),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF073A3C),_surface]),borderRadius:BorderRadius.circular(14),border:Border.all(col[...]
 InkWell(onTap:()=>open(LivePredictionScreen()),borderRadius:BorderRadius.circular(16),child:Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(gradient:const LinearGradient[...]
 const SizedBox(height:14),const Text('QUICK PLAY',style:TextStyle(fontSize:12,fontWeight:FontWeight.w800,color:Colors.white60,letterSpacing:1.1)),const SizedBox(height:8),
 Row(children:[Expanded(child:_HeroTile(icon:Icons.sports_cricket,title:'Cricket',subtitle:'2-over challenge',accent:_teal,onTap:()=>open(const CricketScreen()))),const SizedBox(width:10),Expanded[...]
 Row(children:[Expanded(child:_ModeTile(icon:Icons.flash_on,title:'Quick\nPlay',active:true)),const SizedBox(width:8),Expanded(child:_ModeTile(icon:Icons.history,title:'Game\nHistory',onTap:()=>op[...]
 const _SectionHeader(title:'CRICKET ARENA',icon:Icons.sports_cricket),const SizedBox(height:8),_ActivityCard(live:true,title:'Live T20 Predictions',subtitle:'8 prediction challenges • Demo matc[...]
 InkWell(onTap:showAddChips,borderRadius:BorderRadius.circular(16),child:Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF073A3C)[...]
 ]))) ])));
}
class _HeroTile extends StatelessWidget{final IconData icon;final String title,subtitle;final Color accent;final VoidCallback onTap;const _HeroTile({required this.icon,required this.title,required[...]
class _ModeTile extends StatelessWidget{final IconData icon;final String title;final bool active;final VoidCallback? onTap;const _ModeTile({required this.icon,required this.title,this.active=false[...]
class _SectionHeader extends StatelessWidget{final String title;final IconData icon;const _SectionHeader({required this.title,required this.icon});@override Widget build(BuildContext context)=>Row[...]
class _ActivityCard extends StatelessWidget{final bool live;final String title,subtitle,button;final IconData icon;final VoidCallback? onTap;const _ActivityCard({required this.live,required this.t[...]
class _GameDrawer extends StatelessWidget{final VoidCallback addChips;const _GameDrawer({required this.addChips});void go(BuildContext c,Widget p){Navigator.pop(c);Navigator.push(c,MaterialPageRou[...]
