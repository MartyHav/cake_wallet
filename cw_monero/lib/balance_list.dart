import 'dart:ffi';
import 'package:cw_monero/signatures.dart';
import 'package:cw_monero/types.dart';
import 'package:cw_monero/monero_api.dart';
import 'package:cw_monero/structs/haven_balance_row.dart';
import 'asset_types.dart';

List<HavenBalanceRow> getHavenFullBalance({int accountIndex = 0}) {
  final size = assetTypesSizeNative();
  final balanceAddressesPointer = getHavenFullBalanceNative(accountIndex);
  final balanceAddresses = balanceAddressesPointer.asTypedList(size);

  return balanceAddresses
      .map((addr) => Pointer<HavenBalanceRow>.fromAddress(addr).ref)
      .toList();
}

List<HavenBalanceRow> getHavenUnlockedBalance({int accountIndex = 0}) {
  final size = assetTypesSizeNative();
  final balanceAddressesPointer = getHavenUnlockedBalanceNative(accountIndex);
  final balanceAddresses = balanceAddressesPointer.asTypedList(size);

  return balanceAddresses
      .map((addr) => Pointer<HavenBalanceRow>.fromAddress(addr).ref)
      .toList();
}

final getHavenFullBalanceNative = moneroApi
    .lookup<NativeFunction<get_full_balance>>('get_full_balance')
    .asFunction<GetHavenFullBalance>();

final getHavenUnlockedBalanceNative = moneroApi
    .lookup<NativeFunction<get_unlocked_balance>>('get_unlocked_balance')
    .asFunction<GetHavenUnlockedBalance>();
