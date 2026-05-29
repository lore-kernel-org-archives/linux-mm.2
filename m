Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C072CCD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 06:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83D76B0005; Fri, 29 May 2026 02:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35B46B0088; Fri, 29 May 2026 02:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23AD6B008A; Fri, 29 May 2026 02:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB8206B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:48:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BFF1140FC8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:48:54 +0000 (UTC)
X-FDA: 84819529788.19.11AFF6A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5BEB320007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:48:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=La1pc6j7;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780037332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=gygP29OgPJVFAqvv+VuheVl1koHP1+b70A2olM+LHsA=;
	b=nHbXhlbouAzOy9hvYGmYi5uIk4US/o2GrmV+WK0OMVBNxaDZFdbjZ1ef3oKoC3AcibqW4y
	GHC8sCu7QVHfwO5DfLlhvKP5HRsePdqYECXqTKHmT1Y6c82mXF3fOyH/2YfiWvejSHqegf
	tIymxtFFwgXGsSDgcJoYKql97oy9Vuk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=La1pc6j7;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780037332; a=rsa-sha256;
	cv=none;
	b=49AFwvohKSYAMqjMh8tIfGR5JqiSq9zKmMMiTwnvh3JljuH0DMSJD66CwzIRl+1Pd2NZ38
	6+LdV2RgDw/0Da70td19TIYxMnqJTdj+J0ojVlqEWV5milDow47wjQmCgtktDzFbxe/VqQ
	hh+CCuQESh4YS9EK9qRG+S5JcwH7gYw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780037332; x=1811573332;
  h=date:from:to:cc:subject:message-id;
  bh=QCcYSlDs2edHMkTkgzHoNlccYhjpsFhCqp7gDvxMZAw=;
  b=La1pc6j7mlL8mwGNhmG/TwjTtiylDBqkTtj6x890NyG/kV2BX0dBKMuh
   TrUlNkmSSFRis6mWy9HyJRV48iJTb6iKgix1VkDNY73wizIIlmWnCTLsP
   BeqA8n3RgpF/9FVvYRoanYBnclZtRRW3tbHcWomjlVu2X487T1P7HDMMF
   Tz0K0DvGJUopBuIjH2Zi0kXSqcptrgVfRRL8vBj0cp4awDZuPRAUSl49e
   SQR+bV+NI7pMCqdDhcUKI11q04FlpxmcKjJ5BGqCQH1P+CU9vAqVfiGkY
   1zjwxVTQSHNYE5eLTbJ9tZx+vdKrMsQLk3KUMNN3+6CIls0LL/dCUQgZ8
   A==;
X-CSE-ConnectionGUID: u/23kaPUT1WGFFAuifv0ZQ==
X-CSE-MsgGUID: LMsbdFPVTjCveU/JIp9ViQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="84511728"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="84511728"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 23:48:50 -0700
X-CSE-ConnectionGUID: l+MX/Lq1QZ2yKqNjfMTvfQ==
X-CSE-MsgGUID: utlMrY4/QJyJJQH7e33U1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="236415580"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2026 23:48:47 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSr1Q-000000006rO-1JFF;
	Fri, 29 May 2026 06:48:44 +0000
Date: Fri, 29 May 2026 14:48:19 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 cgroups@vger.kernel.org, netdev@vger.kernel.org,
 rust-for-linux@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 f7af91adc230aa99e23330ecf85bc9badd9780ad
Message-ID: <202605291459.sRvqvCtT-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5BEB320007
X-Stat-Signature: 3bcy31mna7gcmqijacn499jzpa1orumw
X-HE-Tag: 1780037331-328020
X-HE-Meta: U2FsdGVkX19w083euRXU3WwtdrLDkuwH/OTC9dabD+t7v6v8tux4HaREUKsnal+HL2kE/IbQOJjoCPzxg07hXYcR/GXdN8u8CySgXjAu/7Dathen4uxHHCJR2aie61l21r2/EoBeHiO8bFGvZYRYQYENh2Cdjgof2/4i2dwzh8ohkz4kOhGLiDBfgl9cGx62wDowEo8nu/1pHLbOhqAKGklohPc+n4LIrGCmnB9nnCv5LuIt20UXhJAK6dCOpPmycHzj2sQK/IXz8Z0f0RIa6KwtSmeOqlxcWxA8F6rCgYtbiM2cDErYBUXS9b/eqa3pJEu4kue6DSmbRpuVYXKcXkBPZVznzqeKIXR5qcOdiV9VAiaM/MizUbbyBfWj0QTsoHld3jgROlB1e3/hZ/xd86NeTkvsjL93NBzMwn2NBTceMcIHlUVjZQ0XSA3VB4sgmdFP3PPgdVKjjbCCZAoiz9/+JDoQCQBuF0iD9cT1dyquHzPmDvXYPPXvyuIdmlrnJ5AvZIzwGgTJNbPK+0++fPqQozA7YKGnDk6b0MYv77A3PmmPc7kd3y1yctVWnkl4z8vjaqBfEkstrXB3YA9+rHqOJBKgXNqjuhp19n86uXVLCcEt5tyzWRff9ByhDcrG/XimD0dVqqAGlus7Kg0k1ynDUBurjgEURvLrrA0E6WoQxww/fYI6yhkrMommp14PWx8ICao/nFJBG+xtnqDmlXYYNsdDcHWovnNv08SqdqAqbZnjaYH45+fij/tSGdI9MJvSsOI+vDBykk2o0R7sZAWDCwVz5CdpVJ9VEP+4euvE/gw+lGbHGnGnh7IBiSO2PnYZN5JFZknSy2gRPxdr/k+qnXnxPNC7VYnXXDCYr1N0q4LTLjuX1l3/porqkVoXhshC9nkw7TiWbCrS9uqTvnyQPn2hMQm9s3k88Z2mFeIVVXABYW9qX9O8SUgtdfH7fI4l9+7bmuaE1Z1FEIj
 5wDRgiG+
 XNxRCpTsFFLAOxr+piWgBgZO2BG0bjO6PPSz2fuyxSpKxP1er/fR9XTT3xfmqVC+pHbtCBQB/Gj7ezAHfeSsN9IXhBh3ENERDXTiKHMPLyILPQnClUIchbiDu56lIN8SHcHco1WX18I+wAFHGTRFv4gwx72btKoQNZXqM5vJiAwQnleRiXgheDfZoHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: f7af91adc230aa99e23330ecf85bc9badd9780ad  Add linux-next specific files for 20260528

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202605290432.Pyzd4kuW-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202605291041.seNEWvLQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202605291334.abNeADbG-lkp@intel.com

    drivers/net/arcnet/com20020-pci.c:225:52: warning: 'snprintf' output may be truncated before the last format character [-Wformat-truncation=]
    mm/memcontrol-v1.c:651:31: error: implicit declaration of function 'swp_cluster_offset' [-Wimplicit-function-declaration]
    samples/rust/rust_driver_auxiliary.o: warning: objtool: _RINvXs5_NtNtCshc5sK6KjdJJ_6kernel5alloc4kboxINtB6_3BoxINtNtNtCsbsbRiabPlh9_4core3mem12maybe_uninit11MaybeUninitINtNtBa_9auxiliary16RegistrationDataNtCseULRbgTYaTO_21rust_driver_auxiliary4DataEENtNtB8_9allocator7KmallocEINtCs57PXBekmiam_8pin_init12InPlaceWriteB1L_E14write_pin_initNtNtBa_5error5ErrorINtNtB3y_10___internal11InitClosureNCINvYIBH_B1L_B35_EINtNtBa_4init11InPlaceInitB1L_E8pin_initB4u_IB4O_NCINvMsc_B1O_INtB1O_12RegistrationB2l_E3newNtNtBX_7convert10InfallibleB2l_Es_0B1L_B4u_EE0B1L_B4u_EEB2n_: symbol name too long, can't create __pfx_ symbol

Unverified Error/Warning (likely false positive, kindly check if interested):

    block/partitions/ldm.c:1487:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/base/bus.c:801:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/dpll/dpll_core.c:238:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/hwtracing/intel_th/msu.c:1277:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/infiniband/hw/mthca/mthca_memfree.c:220:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/media/common/siano/smscoreapi.c:744:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/misc/eeprom/at25.c:466:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/pinctrl/core.c:2168:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/regulator/core.c:6262:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/staging/greybus/uart.c:917:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/usb/core/../misc/onboard_usb_dev_pdevs.c:124:1: internal compiler error: in final_scan_insn_1, at final.c:3073
    drivers/usb/dwc3/gadget.c:3474:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    fs/jfs/jfs_logmgr.c:1417:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    fs/notify/fanotify/fanotify_user.c:1746:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    fs/ntfs/super.c:2537:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    net/rxrpc/sendmsg.c:497:1: internal compiler error: in final_scan_insn_1, at final.cc:2813

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r072-20260529
|   `-- drivers-net-arcnet-com20020-pci.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|-- csky-randconfig-001-20260529
|   |-- drivers-base-bus.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-misc-eeprom-at25.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-pinctrl-core.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-regulator-core.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-staging-greybus-uart.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-usb-dwc3-gadget.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- fs-jfs-jfs_logmgr.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   `-- fs-notify-fanotify-fanotify_user.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|-- csky-randconfig-002
|   `-- drivers-usb-core-..-misc-onboard_usb_dev_pdevs.c:internal-compiler-error:in-final_scan_insn_1-at-final.c
|-- csky-randconfig-r112-20260528
|   |-- block-partitions-ldm.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-dpll-dpll_core.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-media-common-siano-smscoreapi.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   `-- fs-ntfs-super.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|-- csky-randconfig-r122-20260528
|   |-- drivers-hwtracing-intel_th-msu.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-infiniband-hw-mthca-mthca_memfree.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   `-- net-rxrpc-sendmsg.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|-- sh-allyesconfig
|   `-- mm-memcontrol-v1.c:error:implicit-declaration-of-function-swp_cluster_offset
`-- x86_64-randconfig-004-20260529
    `-- samples-rust-rust_driver_auxiliary.o:warning:objtool:_RINvXs5_NtNtCshc5sK6KjdJJ_6kernel5alloc4kboxINtB6_3BoxINtNtNtCsbsbRiabPlh9_4core3mem12maybe_uninit11MaybeUninitINtNtBa_9auxiliary16RegistrationDat

elapsed time: 753m

configs tested: 178
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260529    gcc-14.3.0
arc                   randconfig-002-20260529    gcc-10.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260529    gcc-14.3.0
arm                   randconfig-002-20260529    gcc-8.5.0
arm                   randconfig-003-20260529    gcc-13.4.0
arm                   randconfig-004-20260529    clang-23
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260529    gcc-8.5.0
arm64                 randconfig-002-20260529    clang-23
arm64                 randconfig-003-20260529    clang-23
arm64                 randconfig-004-20260529    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260529    gcc-15.2.0
csky                  randconfig-002-20260529    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260529    clang-23
hexagon               randconfig-002-20260529    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260529    gcc-12
i386        buildonly-randconfig-002-20260529    clang-20
i386        buildonly-randconfig-003-20260529    gcc-12
i386        buildonly-randconfig-004-20260529    gcc-14
i386        buildonly-randconfig-005-20260529    gcc-14
i386        buildonly-randconfig-006-20260529    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260529    gcc-14
i386                  randconfig-002-20260529    gcc-12
i386                  randconfig-003-20260529    clang-20
i386                  randconfig-004-20260529    clang-20
i386                  randconfig-005-20260529    gcc-14
i386                  randconfig-006-20260529    clang-20
i386                  randconfig-007-20260529    gcc-12
i386                  randconfig-011-20260529    clang-20
i386                  randconfig-012-20260529    clang-20
i386                  randconfig-013-20260529    clang-20
i386                  randconfig-014-20260529    clang-20
i386                  randconfig-015-20260529    gcc-14
i386                  randconfig-016-20260529    clang-20
i386                  randconfig-017-20260529    gcc-13
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260529    gcc-15.2.0
loongarch             randconfig-002-20260529    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260529    gcc-8.5.0
nios2                 randconfig-002-20260529    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
openrisc                  or1klitex_defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260529    gcc-8.5.0
parisc                randconfig-002-20260529    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260529    gcc-12.5.0
powerpc               randconfig-002-20260529    clang-19
powerpc64             randconfig-001-20260529    gcc-15.2.0
powerpc64             randconfig-002-20260529    clang-19
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260529    gcc-8.5.0
riscv                 randconfig-002-20260529    gcc-9.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260529    gcc-8.5.0
s390                  randconfig-002-20260529    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260529    gcc-15.2.0
sh                    randconfig-002-20260529    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260529    gcc-8.5.0
sparc                 randconfig-002-20260529    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260529    gcc-11.5.0
sparc64               randconfig-002-20260529    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260529    gcc-14
um                    randconfig-002-20260529    gcc-14
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260529    gcc-14
x86_64      buildonly-randconfig-002-20260529    gcc-14
x86_64      buildonly-randconfig-003-20260529    gcc-14
x86_64      buildonly-randconfig-004-20260529    clang-20
x86_64      buildonly-randconfig-004-20260529    gcc-14
x86_64      buildonly-randconfig-005-20260529    clang-20
x86_64      buildonly-randconfig-005-20260529    gcc-14
x86_64      buildonly-randconfig-006-20260529    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260529    gcc-14
x86_64                randconfig-002-20260529    clang-20
x86_64                randconfig-003-20260529    gcc-14
x86_64                randconfig-004-20260529    clang-20
x86_64                randconfig-005-20260529    clang-20
x86_64                randconfig-006-20260529    clang-20
x86_64                randconfig-011-20260529    gcc-14
x86_64                randconfig-012-20260529    gcc-14
x86_64                randconfig-013-20260529    clang-20
x86_64                randconfig-014-20260529    clang-20
x86_64                randconfig-015-20260529    gcc-14
x86_64                randconfig-016-20260529    clang-20
x86_64                randconfig-071-20260529    gcc-14
x86_64                randconfig-072-20260529    clang-20
x86_64                randconfig-073-20260529    clang-20
x86_64                randconfig-074-20260529    gcc-14
x86_64                randconfig-075-20260529    gcc-14
x86_64                randconfig-076-20260529    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260529    gcc-11.5.0
xtensa                randconfig-002-20260529    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

