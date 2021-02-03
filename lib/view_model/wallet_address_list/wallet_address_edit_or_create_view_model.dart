import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/core/wallet_base.dart';
import 'package:cake_wallet/bitcoin/bitcoin_wallet.dart';
import 'package:cake_wallet/monero/monero_wallet.dart';
import 'package:cake_wallet/entities/generate_name.dart';

part 'wallet_address_edit_or_create_view_model.g.dart';

class WalletAddressEditOrCreateViewModel = WalletAddressEditOrCreateViewModelBase
    with _$WalletAddressEditOrCreateViewModel;

abstract class AddressEditOrCreateState {}

class AddressEditOrCreateStateInitial extends AddressEditOrCreateState {}

class AddressIsSaving extends AddressEditOrCreateState {}

class AddressSavedSuccessfully extends AddressEditOrCreateState {}

class AddressEditOrCreateStateFailure extends AddressEditOrCreateState {
  AddressEditOrCreateStateFailure({this.error});

  String error;
}

abstract class WalletAddressEditOrCreateViewModelBase with Store {
  WalletAddressEditOrCreateViewModelBase(
      {@required WalletBase wallet, dynamic item})
      : isEdit = item != null,
        state = AddressEditOrCreateStateInitial(),
        label = item?.name as String,
        _item = item,
        _wallet = wallet;

  @observable
  AddressEditOrCreateState state;

  @observable
  String label;

  bool isEdit;

  final dynamic _item;
  final WalletBase _wallet;

  Future<void> save() async {
    try {
      state = AddressIsSaving();

      if (isEdit) {
        await _update();
      } else {
        await _createNew();
      }

      state = AddressSavedSuccessfully();
    } catch (e) {
      state = AddressEditOrCreateStateFailure(error: e.toString());
    }
  }

  Future<void> _createNew() async {
    final wallet = _wallet;

    if (wallet is BitcoinWallet) {
      await wallet.generateNewAddress();
    }

    if (wallet is MoneroWallet) {
      await wallet.subaddressList.addSubaddress(
          accountIndex: wallet.account.id, label: await generateName());
      await wallet.save();
    }
  }

  Future<void> _update() async {
    final wallet = _wallet;

    if (wallet is BitcoinWallet) {
      await wallet.updateAddress(_item.address as String);
    }

    if (wallet is MoneroWallet) {
      await wallet.subaddressList.setLabelSubaddress(
          accountIndex: wallet.account.id,
          addressIndex: _item.id as int,
          label: label);
      await wallet.save();
    }
  }
}
