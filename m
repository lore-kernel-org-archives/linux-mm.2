Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B801CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 23:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803048E0008; Mon, 22 Sep 2025 19:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3CA8E0001; Mon, 22 Sep 2025 19:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1B18E0008; Mon, 22 Sep 2025 19:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD988E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:00:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA8851DDD53
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:00:50 +0000 (UTC)
X-FDA: 83918407860.10.1377985
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id 157D440013
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:00:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mxZnlcKB;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758582048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Zg81w/MgFhlYZWBVrLraUlD7nAVOZDdnUpBZJl3RlDQ=;
	b=sKEXDslxxB3MJzOSHjEQmMLIzW/iDJm0f567xS9rpdGXztR+GeGiG0CkAZCR6gu3hb8aL9
	RnRWVLtuA+JS0onAboobSCCfOVJqzJPFBPYTz/Wiwy3XpKY5EsSJdptgOLWT3Zts6UZI69
	l+Bh/dYxkssQLjjUYltc3SJwkvpoOsA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mxZnlcKB;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758582048; a=rsa-sha256;
	cv=none;
	b=k9pmRIwBYePL5bJYlPH2s8xde6T9HEHiCRmRi5NDxlL9MvWN1DgirRZ26rnulKtjJemHrz
	eWHucy76K7qpriIk+GZHgB1AJ8vmxWWEH4uhtrxMgLmxek3sT1fka5ipCDo8DkXBZos+0R
	S/GWA8ymS7ovdxn0/5LdmC+p6KqNIwE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758582048; x=1790118048;
  h=date:from:to:cc:subject:message-id;
  bh=MIkkWoX2M+qi2ZRWCVytFFNxdGBYn5CeVMMHrUTHtoQ=;
  b=mxZnlcKBFRXCKtQBQaXf+7L8FDahlmY6BvjufrJg8Sgpi4CGlPqqFHQH
   47iAIr11iDjFE6oq2tWk/3h7wUMwaCs0k/jgu7OUbLfEaO7DsACimmHTl
   5keDFKBkJOUI1avI7gVZ4P8JZpAZL2BlbTCIm/4SfGodCi8sJTxj/REr+
   OsMNXaHhq8B4iX6KV+hfjPhVxWsI8WM7Vuvjl5QaaUPBJflRPhbEQrNhY
   AXY/jx9IbBBmIiLbJO76lcUZDEcwwsR/+uBm4nJh23yGyw6dBLXgHb5GO
   1XpMn5iIrwKnz2AENn5yx/QVzMTeZOEYmuDSDKJ9bZ0nAWkpj0d7EuOV9
   Q==;
X-CSE-ConnectionGUID: B4MzqfiEQ8+XzR1otF5I9w==
X-CSE-MsgGUID: 8R3QDBSwTby2FAfSCfS5Lw==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="61022983"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="61022983"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 16:00:46 -0700
X-CSE-ConnectionGUID: krDbqR7iQZGs2YmJjO6O/A==
X-CSE-MsgGUID: UfvDqD7wTvexgSlz1goX4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="181758683"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 22 Sep 2025 16:00:45 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v0pWU-0002Xh-1H;
	Mon, 22 Sep 2025 23:00:42 +0000
Date: Tue, 23 Sep 2025 07:00:36 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 bf2602a3cb2381fb1a04bf1c39a290518d2538d1
Message-ID: <202509230608.tZUGBYUL-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Stat-Signature: 9sdnrrx7f3wi345cing87uc4b9f5hkag
X-Rspam-User: 
X-Rspamd-Queue-Id: 157D440013
X-Rspamd-Server: rspam04
X-HE-Tag: 1758582047-76748
X-HE-Meta: U2FsdGVkX181NPJyLWMBSKjOqtFp+k7edYYhV2m+7iuMmIg/lysV+8B52dTxxPNiIFzqq54ckEG4ogOMaxWi7rve86y7iSl9dp5fD5vNJUb3d/O1chOUls0yr8MHyWG851z3oUs5KOo5jS3Ov8U8P+qVATt39DISar4mF2O22iLLPvQdsEBOikQHJuJQlp1m4kOj3HMLPY1OS/3k76TYAzAo3ZTzE34TvO+RrA6YVaS1ZvbH5hWKBeifUeLzSWrMp3KoYEYMhoN2a602TeacNZAt+Gb5o5iHpAtepm//e4dxuuTW4gRWkuYVN1Bu1AeDhSObqYIu0abA/jNYywJn2tde3ALKNfjCtmR+YuYXPKstCBSBSy3zUWKprE9dhLzsF87TFX+bGl0yqVnGvgGcS1CrQY7WTIGpjfyrLovupLsxcU6zeOreBMYPJKC9jF6LotHvy54t707c2J+TIo4yRANr/3k87znnmoNsOfmDcH8wa2/rEkkXssCFNfYOTtvusGuC5x9vNqrQn/ELW3s6kuecX+Eru0jckZLDIOm4QTbaeD5bRR6saDe48PDgfbZ14OCgk/UxRr6enEkBw4F2NEtU4JHIfarAf80dpo1mXCkPnQ3n0W4wHtB6O2Mn198vrCZWqMJbPrKOM798kzF057oKCsUXXNTTpFi5XHawXgfehtNbA4v3vlEoLsTkEuQbv3HEmOfHZuilqi6Y+IrFdZ5hTStcGkgbs+PruVp6CUJps3FLV4Ecnv9FL7pT0qAivC/xRP81v94qCdM6bYzve9haj/qQc4JY3eKDVQgxZcKx18Fddh1MFw64hoMCZZyZ0wAMLXNmlknaiinyUF2Ew4UOCCz68TtNNwhMB757YDwPEzqty2ukj0wu0Z3GzdlYw+4hgzv50XTdWqg/rm92lFW0WDMpdlaRnLQYm8OFQJjFyeY+xA+Lzct/NFudMfwB6rP2PM+rwpA0Mw4zgGa
 RtoFFP/O
 FHEcw2+LvdlrFS4xjheiE/ECt2uMzqNO1OpkmVRbfQFhKcma/Ab0zZeZ/EEK5Y2qEZ8Gro4B+Dl+RU0UjwvhHXcJVwizZKE7fiakoJ6856GJQOB0qg/9bsy3bXBCbfslIyAR1LeGgSe2MCrue4ZEf/fD51ubA/QAOoD3PsfndzbtTp9/UhyWPFVkiiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: bf2602a3cb2381fb1a04bf1c39a290518d2538d1  Add linux-next specific files for 20250922

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202509101930.OsSQJxIP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509170136.b5ZHaNAV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509181807.I4frBSXx-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509190505.fKGvEJRa-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509190923.UgSxMzx5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509192041.tQwdE4DS-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509192136.CR5pSGKJ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509211250.mD8JS2nu-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509220320.gfFZjmyg-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509222120.gYT1wiPR-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509222153.rYXgFTKA-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509230547.orS14pYx-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509230549.L26lw7UZ-lkp@intel.com

    Documentation/.renames.txt: warning: ignored by one of the .gitignore files
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-aster.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-eval-v3.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-iris-v2.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-iris.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-eval-v1.2.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-eval.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-ixora-v1.1.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-ixora.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-nitrogen6_max.dtb: i2c-mux-2 (i2c-mux-gpio): Unevaluated properties are not allowed ('i2c2mux@1', 'i2c2mux@2' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-nitrogen6_max.dtb: i2c-mux-3 (i2c-mux-gpio): Unevaluated properties are not allowed ('i2c3mux@1' was unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-novena.dtb: stmpe811@44 (st,stmpe811): 'blocks', 'id', 'irq-gpio', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-novena.dtb: stmpe811@44 (st,stmpe811): touchscreen: Unevaluated properties are not allowed ('st,adc-freq', 'st,mod-12b', 'st,ref-sel', 'st,sample-time' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6qp-nitrogen6_max.dtb: i2c-mux-2 (i2c-mux-gpio): Unevaluated properties are not allowed ('i2c2mux@1', 'i2c2mux@2' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6qp-nitrogen6_max.dtb: i2c-mux-3 (i2c-mux-gpio): Unevaluated properties are not allowed ('i2c3mux@1' was unexpected)
    arch/arm/boot/dts/nxp/imx/imx7d-nitrogen7.dtb: touchscreen@48 (ti,tsc2004): 'wakeup-gpios' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx7ulp-com.dtb: clock-controller@40410000 (fsl,imx7ulp-smc1): '#clock-cells' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx7ulp-evk.dtb: clock-controller@40410000 (fsl,imx7ulp-smc1): '#clock-cells' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/x86/kvm/emulate.c:3993:21: error: field name not in record or union initializer
    arch/x86/kvm/emulate.c:3993:22: error: 'union <anonymous>' has no member named 'flags'
    arch/x86/kvm/emulate.c:3993:30: error: initialization of 'int (*)(struct x86_emulate_ctxt *)' from 'long long unsigned int' makes pointer from integer without a cast [-Wint-conversion]
    arch/x86/kvm/emulate.c:3993:30: warning: conversion from 'long long unsigned int' to 'unsigned char' changes value from '220676381741154496' to '192' [-Woverflow]
    arch/x86/kvm/emulate.c:3993:30: warning: initialization of 'int (*)(struct x86_emulate_ctxt *)' from 'long long unsigned int' makes pointer from integer without a cast [-Wint-conversion]
    arch/x86/kvm/emulate.c:3993:37: error: 'union <anonymous>' has no member named 'u'
    arch/x86/kvm/emulate.c:3993:49: error: initialization of 'unsigned char' from 'int (*)(struct x86_emulate_ctxt *)' makes integer from pointer without a cast [-Wint-conversion]
    arch/x86/kvm/emulate.c:3993:49: error: initializer element is not computable at load time
    arch/x86/kvm/emulate.c:3993:49: warning: excess elements in union initializer
    arch/x86/kvm/emulate.c:3993:49: warning: initialization of 'unsigned char' from 'int (*)(struct x86_emulate_ctxt *)' makes integer from pointer without a cast [-Wint-conversion]
    arch/x86/kvm/emulate.c:4090:39: warning: missing braces around initializer [-Wmissing-braces]
    arch/x86/kvm/emulate.c:4091:2: error: call to undeclared function 'F'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    arch/x86/kvm/emulate.c:4091:2: warning: suggest braces around initialization of subobject [-Wmissing-braces]
    arch/x86/kvm/emulate.c:4091:9: error: implicit declaration of function 'F' [-Werror=implicit-function-declaration]
    arch/x86/kvm/emulate.c:4091:9: error: implicit declaration of function 'F'; did you mean 'FS'? [-Wimplicit-function-declaration]
    arch/x86/kvm/emulate.c:4091:9: error: initializer element is not constant
    arch/x86/kvm/emulate.c:4093:2: error: field designator cannot initialize a non-struct, non-union type 'u8[7]' (aka 'unsigned char[7]')
    arch/x86/kvm/emulate.c:4094:2: error: field designator 'flags' does not refer to any field in type 'union (unnamed union at arch/x86/kvm/emulate.c:198:2)'
    arch/x86/kvm/emulate.c:4094:2: error: field designator 'u' does not refer to any field in type 'union (unnamed union at arch/x86/kvm/emulate.c:198:2)'
    arch/x86/kvm/emulate.c:4095:2: error: initialization of non-aggregate type 'int (*)(struct x86_emulate_ctxt *)' with a designated initializer list
    drivers/char/tpm/tpm_loongson.c:48:10: error: incompatible function pointer types initializing 'int (*)(struct tpm_chip *, u8 *, size_t, size_t)' (aka 'int (*)(struct tpm_chip *, unsigned char *, unsigned long, unsigned long)') with an expression of type 'int (struct tpm_chip *, u8 *, size_t)' (aka 'int (struct tpm_chip *, unsigned char *, unsigned long)') [-Wincompatible-function-pointer-types]
    drivers/firewire/core-card.c:561:32: warning: overflow in expression; result is -1'179'869'184 with type 'long' [-Winteger-overflow]
    drivers/firewire/core-card.c:561:32: warning: overflow in expression; result is -1179869184 with type 'long' [-Winteger-overflow]
    drivers/firewire/core.h:33:65: warning: integer overflow in expression of type 'long int' results in '-1179869184' [-Woverflow]
    drivers/gpu/drm/xe/tests/xe_pci.c:215:2: error: initializer element is not a compile-time constant
    drivers/gpu/drm/xe/xe_device_sysfs.c:296:9: error: use of undeclared label 'cleanup'
    drivers/gpu/drm/xe/xe_device_sysfs.c:300:25: error: label 'cleanup' used but not defined
    drivers/i3c/master/adi-i3c-master.c:134:18: warning: variable 'm' set but not used [-Wunused-but-set-variable]
    drivers/i3c/master/adi-i3c-master.c:134:25: warning: variable 'm' set but not used [-Wunused-but-set-variable]
    include/linux/pfn.h:12:43: error: passing argument 1 of 'kho_restore_page' makes pointer from integer without a cast [-Wint-conversion]
    ld.lld: error: undefined symbol: devm_pwrseq_get
    ld.lld: error: undefined symbol: drm_gem_shmem_dumb_create
    ld.lld: error: undefined symbol: drm_gem_shmem_prime_import_no_map
    ld.lld: error: undefined symbol: pwrseq_power_off
    ld.lld: error: undefined symbol: pwrseq_power_on

Unverified Error/Warning (likely false positive, kindly check if interested):

    (.text+0x2020): relocation truncated to fit: R_SPARC_WDISP19 against symbol `do_sys32_sigstack' defined in .text section in arch/sparc/kernel/signal32.o
    (.text+0x20a4): relocation truncated to fit: R_SPARC_WDISP19 against symbol `sparc_vfork' defined in .text section in arch/sparc/kernel/process.o
    (.text+0x20c4): relocation truncated to fit: R_SPARC_WDISP19 against symbol `sparc_fork' defined in .text section in arch/sparc/kernel/process.o
    (.text+0x20e4): relocation truncated to fit: R_SPARC_WDISP19 against symbol `sparc_clone' defined in .text section in arch/sparc/kernel/process.o
    (.text+0x8c): relocation truncated to fit: R_SPARC_WDISP19 against symbol `rtrap' defined in .text section in arch/sparc/kernel/head_64.o
    (.text+0xd34): relocation truncated to fit: R_SPARC_WDISP19 against symbol `user_rtt_fill_fixup_common' defined in .text section in arch/sparc/kernel/urtt_fill.o
    ionic_admin.c:(.text+0x1ec): undefined reference to `__xchg_called_with_bad_pointer'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- alpha-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- alpha-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-randconfig-002-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arm-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-footbridge_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|-- arm-randconfig-002-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-003-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- ld.lld:error:undefined-symbol:drm_gem_shmem_dumb_create
|   `-- ld.lld:error:undefined-symbol:drm_gem_shmem_prime_import_no_map
|-- arm-randconfig-004-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-051-20250922
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-052-20250922
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-053-20250922
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-054-20250922
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-055-20250922
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm64-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:use-of-undeclared-label-cleanup
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm64-randconfig-002-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-003-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-004-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- ld.lld:error:undefined-symbol:devm_pwrseq_get
|   |-- ld.lld:error:undefined-symbol:pwrseq_power_off
|   `-- ld.lld:error:undefined-symbol:pwrseq_power_on
|-- arm64-randconfig-051-20250922
|   `-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|-- arm64-randconfig-052-20250922
|   `-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|-- arm64-randconfig-053-20250922
|   `-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|-- arm64-randconfig-054-20250922
|   `-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|-- arm64-randconfig-055-20250922
|   `-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|-- arm64-randconfig-r122-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-r131-20250923
|   `-- drivers-rtc-rtc-optee.c:sparse:sparse:symbol-optee_rtc_pm_ops-was-not-declared.-Should-it-be-static
|-- csky-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- csky-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- csky-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- csky-randconfig-002-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- hexagon-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|-- hexagon-randconfig-002-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-x86-kvm-emulate.c:error:field-name-not-in-record-or-union-initializer
|   |-- arch-x86-kvm-emulate.c:error:implicit-declaration-of-function-F
|   |-- arch-x86-kvm-emulate.c:error:initialization-of-int-(-)(struct-x86_emulate_ctxt-)-from-long-long-unsigned-int-makes-pointer-from-integer-without-a-cast
|   |-- arch-x86-kvm-emulate.c:error:initialization-of-unsigned-char-from-int-(-)(struct-x86_emulate_ctxt-)-makes-integer-from-pointer-without-a-cast
|   |-- arch-x86-kvm-emulate.c:error:initializer-element-is-not-computable-at-load-time
|   |-- arch-x86-kvm-emulate.c:error:initializer-element-is-not-constant
|   |-- arch-x86-kvm-emulate.c:error:union-anonymous-has-no-member-named-flags
|   |-- arch-x86-kvm-emulate.c:error:union-anonymous-has-no-member-named-u
|   |-- arch-x86-kvm-emulate.c:warning:conversion-from-long-long-unsigned-int-to-unsigned-char-changes-value-from-to
|   |-- arch-x86-kvm-emulate.c:warning:excess-elements-in-union-initializer
|   |-- arch-x86-kvm-emulate.c:warning:missing-braces-around-initializer
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- i386-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-x86-kvm-emulate.c:error:field-name-not-in-record-or-union-initializer
|   |-- arch-x86-kvm-emulate.c:error:implicit-declaration-of-function-F
|   |-- arch-x86-kvm-emulate.c:error:initialization-of-int-(-)(struct-x86_emulate_ctxt-)-from-long-long-unsigned-int-makes-pointer-from-integer-without-a-cast
|   |-- arch-x86-kvm-emulate.c:error:initialization-of-unsigned-char-from-int-(-)(struct-x86_emulate_ctxt-)-makes-integer-from-pointer-without-a-cast
|   |-- arch-x86-kvm-emulate.c:error:initializer-element-is-not-computable-at-load-time
|   |-- arch-x86-kvm-emulate.c:error:initializer-element-is-not-constant
|   |-- arch-x86-kvm-emulate.c:error:union-anonymous-has-no-member-named-flags
|   |-- arch-x86-kvm-emulate.c:error:union-anonymous-has-no-member-named-u
|   |-- arch-x86-kvm-emulate.c:warning:conversion-from-long-long-unsigned-int-to-unsigned-char-changes-value-from-to
|   |-- arch-x86-kvm-emulate.c:warning:excess-elements-in-union-initializer
|   |-- arch-x86-kvm-emulate.c:warning:missing-braces-around-initializer
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- i386-buildonly-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|   `-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:use-of-undeclared-label-cleanup
|-- i386-buildonly-randconfig-002-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- i386-buildonly-randconfig-003-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-x86-kvm-emulate.c:error:initialization-of-int-(-)(struct-x86_emulate_ctxt-)-from-long-long-unsigned-int-makes-pointer-from-integer-without-a-cast
|   |-- arch-x86-kvm-emulate.c:error:initialization-of-unsigned-char-from-int-(-)(struct-x86_emulate_ctxt-)-makes-integer-from-pointer-without-a-cast
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- i386-buildonly-randconfig-004-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- i386-buildonly-randconfig-005-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-006-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-141-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- i386-randconfig-r121-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-x86-kvm-emulate.c:error:field-name-not-in-record-or-union-initializer
|   |-- arch-x86-kvm-emulate.c:error:implicit-declaration-of-function-F
|   |-- arch-x86-kvm-emulate.c:error:initialization-of-int-(-)(struct-x86_emulate_ctxt-)-from-long-long-unsigned-int-makes-pointer-from-integer-without-a-cast
|   |-- arch-x86-kvm-emulate.c:error:initialization-of-unsigned-char-from-int-(-)(struct-x86_emulate_ctxt-)-makes-integer-from-pointer-without-a-cast
|   |-- arch-x86-kvm-emulate.c:error:initializer-element-is-not-computable-at-load-time
|   |-- arch-x86-kvm-emulate.c:error:initializer-element-is-not-constant
|   |-- arch-x86-kvm-emulate.c:error:union-anonymous-has-no-member-named-flags
|   |-- arch-x86-kvm-emulate.c:error:union-anonymous-has-no-member-named-u
|   |-- arch-x86-kvm-emulate.c:warning:conversion-from-long-long-unsigned-int-to-unsigned-char-changes-value-from-to
|   |-- arch-x86-kvm-emulate.c:warning:excess-elements-in-union-initializer
|   `-- arch-x86-kvm-emulate.c:warning:missing-braces-around-initializer
|-- i386-randconfig-r131-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-x86-kvm-emulate.c:error:field-name-not-in-record-or-union-initializer
|   |-- arch-x86-kvm-emulate.c:error:implicit-declaration-of-function-F
|   |-- arch-x86-kvm-emulate.c:error:initialization-of-int-(-)(struct-x86_emulate_ctxt-)-from-long-long-unsigned-int-makes-pointer-from-integer-without-a-cast
|   |-- arch-x86-kvm-emulate.c:error:initialization-of-unsigned-char-from-int-(-)(struct-x86_emulate_ctxt-)-makes-integer-from-pointer-without-a-cast
|   |-- arch-x86-kvm-emulate.c:error:initializer-element-is-not-computable-at-load-time
|   |-- arch-x86-kvm-emulate.c:error:initializer-element-is-not-constant
|   |-- arch-x86-kvm-emulate.c:error:union-anonymous-has-no-member-named-flags
|   |-- arch-x86-kvm-emulate.c:error:union-anonymous-has-no-member-named-u
|   |-- arch-x86-kvm-emulate.c:warning:conversion-from-long-long-unsigned-int-to-unsigned-char-changes-value-from-to
|   |-- arch-x86-kvm-emulate.c:warning:excess-elements-in-union-initializer
|   |-- arch-x86-kvm-emulate.c:warning:missing-braces-around-initializer
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- loongarch-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-char-tpm-tpm_loongson.c:error:incompatible-function-pointer-types-initializing-int-(-)(struct-tpm_chip-u8-size_t-size_t)-(aka-int-(-)(struct-tpm_chip-unsigned-char-unsigned-long-unsigned-long)
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:use-of-undeclared-label-cleanup
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- loongarch-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-char-tpm-tpm_loongson.c:error:incompatible-function-pointer-types-initializing-int-(-)(struct-tpm_chip-u8-size_t-size_t)-(aka-int-(-)(struct-tpm_chip-unsigned-char-unsigned-long-unsigned-long)
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- loongarch-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-randconfig-001-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-randconfig-002-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- m68k-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- m68k-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-m5275evb_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-randconfig-r132-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- microblaze-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- microblaze-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- mips-rt305x_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-xway_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- nios2-randconfig-002-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- openrisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- openrisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- openrisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-001-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-r123-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-akebono_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- powerpc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:use-of-undeclared-label-cleanup
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- powerpc-randconfig-001-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-002-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-003-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|-- powerpc64-randconfig-002-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-003-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-r112-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:use-of-undeclared-label-cleanup
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- riscv-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-tests-xe_pci.c:error:initializer-element-is-not-a-compile-time-constant
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:use-of-undeclared-label-cleanup
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- riscv-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- riscv-randconfig-002-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:use-of-undeclared-label-cleanup
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- s390-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- s390-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-001-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-002-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-randconfig-002-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-randconfig-r133-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-se7780_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-secureedge5410_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-sh7785lcr_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-allyesconfig
|   |-- (.text):relocation-truncated-to-fit:R_SPARC_WDISP19-against-symbol-do_sys32_sigstack-defined-in-.text-section-in-arch-sparc-kernel-signal32.o
|   |-- (.text):relocation-truncated-to-fit:R_SPARC_WDISP19-against-symbol-rtrap-defined-in-.text-section-in-arch-sparc-kernel-head_64.o
|   |-- (.text):relocation-truncated-to-fit:R_SPARC_WDISP19-against-symbol-sparc_clone-defined-in-.text-section-in-arch-sparc-kernel-process.o
|   |-- (.text):relocation-truncated-to-fit:R_SPARC_WDISP19-against-symbol-sparc_fork-defined-in-.text-section-in-arch-sparc-kernel-process.o
|   |-- (.text):relocation-truncated-to-fit:R_SPARC_WDISP19-against-symbol-sparc_vfork-defined-in-.text-section-in-arch-sparc-kernel-process.o
|   |-- (.text):relocation-truncated-to-fit:R_SPARC_WDISP19-against-symbol-user_rtt_fill_fixup_common-defined-in-.text-section-in-arch-sparc-kernel-urtt_fill.o
|   `-- ionic_admin.c:(.text):undefined-reference-to-__xchg_called_with_bad_pointer
|-- sparc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc-randconfig-002-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc64-randconfig-002-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc64-randconfig-r113-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:use-of-undeclared-label-cleanup
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- um-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- um-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-i386_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-001-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-002-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|-- um-x86_64_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:use-of-undeclared-label-cleanup
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- x86_64-buildonly-randconfig-001-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-002-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-003-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-x86-kvm-emulate.c:error:field-name-not-in-record-or-union-initializer
|   |-- arch-x86-kvm-emulate.c:error:implicit-declaration-of-function-F
|   |-- arch-x86-kvm-emulate.c:error:initializer-element-is-not-computable-at-load-time
|   |-- arch-x86-kvm-emulate.c:error:initializer-element-is-not-constant
|   |-- arch-x86-kvm-emulate.c:error:union-anonymous-has-no-member-named-flags
|   |-- arch-x86-kvm-emulate.c:error:union-anonymous-has-no-member-named-u
|   |-- arch-x86-kvm-emulate.c:warning:conversion-from-long-long-unsigned-int-to-unsigned-char-changes-value-from-to
|   |-- arch-x86-kvm-emulate.c:warning:excess-elements-in-union-initializer
|   |-- arch-x86-kvm-emulate.c:warning:initialization-of-int-(-)(struct-x86_emulate_ctxt-)-from-long-long-unsigned-int-makes-pointer-from-integer-without-a-cast
|   |-- arch-x86-kvm-emulate.c:warning:initialization-of-unsigned-char-from-int-(-)(struct-x86_emulate_ctxt-)-makes-integer-from-pointer-without-a-cast
|   |-- arch-x86-kvm-emulate.c:warning:missing-braces-around-initializer
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- x86_64-buildonly-randconfig-004-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-005-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-006-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- x86_64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-004-20250922
|   `-- include-linux-pfn.h:error:passing-argument-of-kho_restore_page-makes-pointer-from-integer-without-a-cast
|-- x86_64-randconfig-161-20250922
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-rhel-9.4-rust
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-x86-kvm-emulate.c:error:call-to-undeclared-function-F-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- arch-x86-kvm-emulate.c:error:field-designator-cannot-initialize-a-non-struct-non-union-type-u8-(aka-unsigned-char-)
|   |-- arch-x86-kvm-emulate.c:error:field-designator-flags-does-not-refer-to-any-field-in-type-union-(unnamed-union-at-arch-x86-kvm-emulate.c)
|   |-- arch-x86-kvm-emulate.c:error:field-designator-u-does-not-refer-to-any-field-in-type-union-(unnamed-union-at-arch-x86-kvm-emulate.c)
|   |-- arch-x86-kvm-emulate.c:error:initialization-of-non-aggregate-type-int-(-)(struct-x86_emulate_ctxt-)-with-a-designated-initializer-list
|   `-- arch-x86-kvm-emulate.c:warning:suggest-braces-around-initialization-of-subobject
|-- xtensa-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-xe-xe_device_sysfs.c:error:label-cleanup-used-but-not-defined
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- xtensa-randconfig-001-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- xtensa-randconfig-002-20250922
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
`-- xtensa-randconfig-r111-20250922
    |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
    `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET

elapsed time: 731m

configs tested: 164
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    clang-19
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-19
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250922    gcc-8.5.0
arc                   randconfig-002-20250922    gcc-9.5.0
arm                              allmodconfig    clang-19
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    clang-19
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                      footbridge_defconfig    clang-17
arm                   randconfig-001-20250922    clang-22
arm                   randconfig-002-20250922    gcc-12.5.0
arm                   randconfig-003-20250922    clang-17
arm                   randconfig-004-20250922    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250922    gcc-8.5.0
arm64                 randconfig-002-20250922    gcc-15.1.0
arm64                 randconfig-003-20250922    clang-22
arm64                 randconfig-004-20250922    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250922    gcc-15.1.0
csky                  randconfig-002-20250922    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250922    clang-20
hexagon               randconfig-002-20250922    clang-19
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    clang-20
i386                              allnoconfig    gcc-14
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20250922    clang-20
i386        buildonly-randconfig-002-20250922    gcc-14
i386        buildonly-randconfig-003-20250922    gcc-14
i386        buildonly-randconfig-004-20250922    gcc-14
i386        buildonly-randconfig-005-20250922    clang-20
i386        buildonly-randconfig-006-20250922    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250922    clang-22
loongarch             randconfig-002-20250922    clang-18
m68k                             allmodconfig    clang-19
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-19
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                       m5275evb_defconfig    gcc-15.1.0
microblaze                       allmodconfig    clang-19
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    clang-19
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                         rt305x_defconfig    clang-22
mips                           xway_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-15.1.0
nios2                               defconfig    gcc-11.5.0
nios2                               defconfig    gcc-15.1.0
nios2                 randconfig-001-20250922    gcc-11.5.0
nios2                 randconfig-002-20250922    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-14
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250922    gcc-8.5.0
parisc                randconfig-002-20250922    gcc-9.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                     akebono_defconfig    clang-22
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                          allyesconfig    gcc-15.1.0
powerpc               randconfig-001-20250922    clang-22
powerpc               randconfig-002-20250922    gcc-12.5.0
powerpc               randconfig-003-20250922    clang-17
powerpc64             randconfig-002-20250922    clang-20
powerpc64             randconfig-003-20250922    clang-17
riscv                            allmodconfig    clang-22
riscv                            allmodconfig    gcc-15.1.0
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                            allyesconfig    gcc-15.1.0
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-14
riscv                 randconfig-001-20250922    clang-22
riscv                 randconfig-002-20250922    clang-22
s390                             allmodconfig    clang-18
s390                             allmodconfig    gcc-15.1.0
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-14
s390                  randconfig-001-20250922    gcc-8.5.0
s390                  randconfig-002-20250922    gcc-11.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250922    gcc-15.1.0
sh                    randconfig-002-20250922    gcc-11.5.0
sh                           se7780_defconfig    gcc-15.1.0
sh                   secureedge5410_defconfig    gcc-15.1.0
sh                        sh7785lcr_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250922    gcc-15.1.0
sparc                 randconfig-002-20250922    gcc-14.3.0
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20250922    gcc-12.5.0
sparc64               randconfig-002-20250922    gcc-14.3.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20250922    gcc-14
um                    randconfig-002-20250922    clang-22
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250922    clang-20
x86_64      buildonly-randconfig-002-20250922    gcc-13
x86_64      buildonly-randconfig-003-20250922    gcc-13
x86_64      buildonly-randconfig-004-20250922    clang-20
x86_64      buildonly-randconfig-005-20250922    clang-20
x86_64      buildonly-randconfig-006-20250922    clang-20
x86_64                              defconfig    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250922    gcc-9.5.0
xtensa                randconfig-002-20250922    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

