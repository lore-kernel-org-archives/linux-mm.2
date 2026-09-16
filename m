Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02EBCC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 05:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12846B0088; Wed, 16 Sep 2026 01:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C41E6B008C; Wed, 16 Sep 2026 01:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900F56B0092; Wed, 16 Sep 2026 01:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC296B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:57:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09941160574
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:57:12 +0000 (UTC)
X-FDA: 85218567504.10.A40AF2D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id DFE7140003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:57:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="S5/dTq6W";
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789538229;
	b=f2BXJ61S5X2LSXlWob29okUjAOJ6JTNg2J5OLfgRPp+jy80t84UDrkid4d2zTH0DgCchI7
	NXKlXw0Uahovhe8i2Otr8Auf1CMna2CoYiwRW3yB51U4J+sAsV7w99s9PaF05DH+fjatvD
	WpRwt4hzjdtOVomGxeBl6oj94TzBYig=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="S5/dTq6W";
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789538229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=LXdiZ3cXwklDLOJlmEzT0A/4L64gNrjrGHdjYgjW3io=;
	b=3LR/dcdXFfwhfSaQioPe3U+Ftv5j6HsnqJb4CrF0QP6F23X1RWJtsMjeO/pgPD5gjujsaC
	Gg4x1lJk5evwGOw49SoooXbaS8Ysamc9J9gx1jMFJqbQ09iWSv/GhEXLdscPGLI/0XaDGs
	moKbsC20L6bQ1HlMysmtjVwm9VC3Y4U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789538230; x=1821074230;
  h=date:from:to:cc:subject:message-id;
  bh=KndwzOh4auXiHYff5Hm4KFOpy3MaYwr6MIWA3QqLC24=;
  b=S5/dTq6WoLQXv1TdSRw1c63NHOgm4U+iKopFTXUfxHaIxCfXlvdhjDxs
   Kj2apvoK+PS8j1aXLDI/uQPUG/+7X0B73hruyv4NHv0SJZK8ym/qOaokc
   eWZRVy2sqJP5lkRs60lylhJKB+nhv7ltFojHP73wC+9iH+UpBEtWLRIne
   pwVEvvkdyfE6rL0yXLdxPGzohME75Tu+dJYzr2JIzEyAZsNs2HogmWrU3
   l4TkXu5R4sYg9BSY9ajHz8JgquIiBiF5vrA8BkKma5Zy3L+2rWMHmOIbN
   YM5H64ofPs15D/adZdvbbGUW8QFD0pZsVc8hTxpdQDMQL1PwypP429rnc
   g==;
X-CSE-ConnectionGUID: yuuZTrpeRHaZU+XdpnvPhw==
X-CSE-MsgGUID: Vy6WONQ8RzmmwoqXzgowZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="100232670"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="100232670"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 22:57:03 -0700
X-CSE-ConnectionGUID: a6tgeKRFTamxR61p3Y3Zrg==
X-CSE-MsgGUID: noe59t3FTluZmTnQILaw+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="273202638"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 15 Sep 2026 22:56:59 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6idc-000000005Zh-2FMZ;
	Wed, 16 Sep 2026 05:56:56 +0000
Date: Wed, 16 Sep 2026 13:56:40 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 1a1de54f7369cd2b5bac0f265910e60ad3a6b4c3
Message-ID: <202609161336.wIG4bOv1-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DFE7140003
X-Stat-Signature: 5tuekku41t574ewws3y3k4rsp6co1aq4
X-Rspam-User: 
X-HE-Tag: 1789538228-745088
X-HE-Meta: U2FsdGVkX18Wsmfrnh4vZNUH/canWM68mQTkWCLVol2V/1AiuoRKZBpRHMAB9DZWtwCbd0uJmP7ke05UQzYxqTpB89vqOGGE110UBZqTa1Mrf5ChdSH/YtnqX1gn3vb1y/cMLWszNLSWd93p3JCn6vDwbPiE0j+swQDebwM4sdml4o/ynj37sEsQ7MXfRf9aFejJExhuQyPskvS0YbkcVcCFKGVdVyDLqD49FIlhObbDyPDaIBVSbsUMNKzhRVNHAW2hmudkeRga0dd2o+3eiXOxqpW59lDq2FtLHUc17DjE++xPpRNA4UW2R7+LtZsLTM/lMRnz8KF5LycK/yg3pKw6g3FwBqXnwAPGPHo0e9iTqgVmdgr05bDeArBqVjJzwx3TI4Hget2ezf6fVfdnqE4QohHf4kanyKhghH5fEGTQnd2uSIG11+Uuk0H9jfKNcTEyh0JydWc3OkzC2ZvgiGr0E+66psWZ/BQsVS+YNfwPmR8vERmuFGu+ws3sH7nwmoyFQxDWEbenHJQQbG7K0bVzKUg5CslT74SCHBCbuIURtleUPyPG2X0Eeua0Ph7OpeszN6ykIKsGUmDg/D0+EOs/CmrlOlmi3NkqyiQl7J3s2vuO03s6OsuwqMz5kR0LAmjizG9oiNPN7gJF1ZFPvhmnkcayAiTyMhcf3zrD5+gLeKvrDfu4EFVXfY8vpQxBS70+CxrEVNuWWKzttxPJlxfcOM9AhpoaVyPnkS/Yeg0zw75rjB45i5SImE/C48RNCpPJJ/hqTCMvMqHgervWpICaQsZyla2iPwSqp4yky1hEnD3VKd0IQDlo+dLUBQwAKxMEqc+KYyZdLdq9qquzWzs5rOli/JwkKFSoyO80FZEk1cf2j8gDC/sNCMYYlHxpbqQrlGwJmnpiJYr04QU7orlg3qh6mT3XJ1UyWbo9mTw7oQSa91y+/vCXoo1T4IkKqUnyy5IqvZBmUZjFI4Y
 g0bijwjz
 Nm5O1kkj8ks538Sk/vqEHD5EdIFtr0TIT3BH5vCggXjEXcI/vso6eBoA81INj2moHXAPmN4Uz1l/s2eXMGfQrF08ENbkJnvNFiWMAjWE7vgRPLpBhXsAufbRKupYiVHT6RZmdAp5U+VlNscGCKp1IPjBqtNnoBIhH2c55QlJD0H+TiAExzqinWre/WEPPxUjBTRpqdUAq68gBsoKe07LZ8/j/JdMz80BYGOPR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 1a1de54f7369cd2b5bac0f265910e60ad3a6b4c3  Add linux-next specific files for 20260914

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609150228.Nh4nZzbQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609152007.ZrNbQ8XS-lkp@intel.com

    arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb: spi-ws-2ch-canfd (spi-gpio): $nodename:0: 'spi-ws-2ch-canfd' does not match '^spi(@.*|-([0-9]|[1-9][0-9]+))?$'
    arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb: spi-ws-2ch-canfd (spi-gpio): Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'can@0' were unexpected)

Unverified Error/Warning (likely false positive, kindly check if interested):

    kernel/rcu/hazptrtorture.c:443:1: internal compiler error: in final_scan_insn_1, at final.c:3073

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r121-20260915
|   |-- fs-kernfs-dir.c:sparse:sparse:cast-from-non-scalar
|   `-- fs-kernfs-dir.c:sparse:sparse:cast-to-non-scalar
|-- arm64-randconfig-2051-20260914
|   |-- arch-arm64-boot-dts-renesas-r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb:spi-ws-2ch-canfd-(spi-gpio):Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-can-were-unexpected)
|   `-- arch-arm64-boot-dts-renesas-r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb:spi-ws-2ch-canfd-(spi-gpio):nodename:spi-ws-2ch-canfd-does-not-match-spi(-.-(-))
|-- arm64-randconfig-2052-20260914
|   |-- arch-arm64-boot-dts-renesas-r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb:spi-ws-2ch-canfd-(spi-gpio):Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-can-were-unexpected)
|   `-- arch-arm64-boot-dts-renesas-r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb:spi-ws-2ch-canfd-(spi-gpio):nodename:spi-ws-2ch-canfd-does-not-match-spi(-.-(-))
|-- arm64-randconfig-2053-20260914
|   |-- arch-arm64-boot-dts-renesas-r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb:spi-ws-2ch-canfd-(spi-gpio):Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-can-were-unexpected)
|   `-- arch-arm64-boot-dts-renesas-r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb:spi-ws-2ch-canfd-(spi-gpio):nodename:spi-ws-2ch-canfd-does-not-match-spi(-.-(-))
|-- arm64-randconfig-2054-20260914
|   |-- arch-arm64-boot-dts-renesas-r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb:spi-ws-2ch-canfd-(spi-gpio):Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-can-were-unexpected)
|   `-- arch-arm64-boot-dts-renesas-r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb:spi-ws-2ch-canfd-(spi-gpio):nodename:spi-ws-2ch-canfd-does-not-match-spi(-.-(-))
|-- arm64-randconfig-2055-20260914
|   |-- arch-arm64-boot-dts-renesas-r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb:spi-ws-2ch-canfd-(spi-gpio):Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-can-were-unexpected)
|   `-- arch-arm64-boot-dts-renesas-r8a779g3-sparrow-hawk-ws-2ch-canfd.dtb:spi-ws-2ch-canfd-(spi-gpio):nodename:spi-ws-2ch-canfd-does-not-match-spi(-.-(-))
`-- csky-randconfig-r052-20260914
    `-- kernel-rcu-hazptrtorture.c:internal-compiler-error:in-final_scan_insn_1-at-final.c

elapsed time: 2206m

configs tested: 238
configs skipped: 6

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
alpha                randconfig-r063-20260915    gcc-8.5.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260916    gcc-8.5.0
arc                   randconfig-002-20260916    gcc-9.5.0
arc                  randconfig-r061-20260915    gcc-13.4.0
arc                  randconfig-r132-20260915    gcc-12.5.0 sparse
arm                               allnoconfig    clang-17
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                            mps2_defconfig    clang-24
arm                       multi_v4t_defconfig    clang-19
arm                         nhk8815_defconfig    clang-24
arm                   randconfig-001-20260916    gcc-8.5.0
arm                   randconfig-002-20260916    gcc-11.5.0
arm                   randconfig-003-20260916    clang-24
arm                   randconfig-004-20260916    clang-24
arm                  randconfig-r053-20260914    clang-17
arm                  randconfig-r111-20260916    clang-22 sparse
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260916    gcc-8.5.0
arm64                 randconfig-002-20260916    clang-24
arm64                 randconfig-003-20260916    gcc-8.5.0
arm64                 randconfig-004-20260916    gcc-9.5.0
arm64                randconfig-r054-20260915    gcc-12.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260916    gcc-9.5.0
csky                  randconfig-002-20260916    gcc-16.1.0
csky                 randconfig-r052-20260914    gcc-10.5.0
csky                 randconfig-r063-20260914    gcc-16.1.0
csky                 randconfig-r073-20260914    gcc-11.5.0
csky                 randconfig-r073-20260915    gcc-14.3.0
csky                 randconfig-r121-20260916    gcc-10.5.0 sparse
hexagon                          allmodconfig    clang-24
hexagon                           allnoconfig    clang-24
hexagon                             defconfig    clang-24
hexagon              randconfig-r061-20260914    clang-22
hexagon              randconfig-r071-20260914    clang-24
i386                              allnoconfig    gcc-14
i386        buildonly-randconfig-001-20260916    clang-22
i386        buildonly-randconfig-002-20260916    gcc-14
i386        buildonly-randconfig-003-20260916    gcc-14
i386        buildonly-randconfig-004-20260916    gcc-14
i386        buildonly-randconfig-005-20260916    clang-22
i386        buildonly-randconfig-006-20260916    gcc-14
i386                                defconfig    clang-22
i386                  randconfig-001-20260916    gcc-14
i386                  randconfig-002-20260916    gcc-14
i386                  randconfig-003-20260916    gcc-14
i386                  randconfig-004-20260916    gcc-14
i386                  randconfig-005-20260916    gcc-14
i386                  randconfig-006-20260916    gcc-14
i386                  randconfig-007-20260916    gcc-14
i386                  randconfig-012-20260916    clang-22
i386                  randconfig-013-20260916    clang-22
i386                  randconfig-015-20260916    gcc-14
i386                  randconfig-051-20260914    clang-22
i386                  randconfig-051-20260914    gcc-14
i386                  randconfig-051-20260915    clang-22
i386                  randconfig-052-20260914    clang-22
i386                  randconfig-052-20260915    clang-22
i386                  randconfig-053-20260914    clang-22
i386                  randconfig-053-20260914    gcc-14
i386                  randconfig-053-20260915    clang-22
i386                  randconfig-054-20260914    clang-22
i386                  randconfig-054-20260914    gcc-14
i386                  randconfig-054-20260915    gcc-14
i386                  randconfig-061-20260915    clang-22 sparse
i386                  randconfig-062-20260915    gcc-14 sparse
i386                  randconfig-063-20260915    clang-22 sparse
i386                  randconfig-141-20260914    gcc-14
i386                  randconfig-141-20260915    clang-22
i386                 randconfig-r062-20260915    gcc-13
i386                 randconfig-r072-20260914    clang-22
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-20
loongarch                           defconfig    clang-24
loongarch             randconfig-002-20260916    gcc-16.1.0
loongarch            randconfig-r051-20260914    gcc-15.2.0
loongarch            randconfig-r062-20260914    gcc-16.1.0
loongarch            randconfig-r071-20260914    clang-19
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
m68k                 randconfig-r072-20260914    gcc-8.5.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
microblaze           randconfig-r122-20260916    gcc-12.5.0 sparse
microblaze           randconfig-r134-20260915    gcc-16.1.0 sparse
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260916    gcc-11.5.0
nios2                 randconfig-002-20260916    gcc-8.5.0
nios2                randconfig-r053-20260914    gcc-15.2.0
openrisc                         alldefconfig    gcc-16.1.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
openrisc             randconfig-r133-20260915    gcc-16.1.0 sparse
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260915    gcc-13.4.0
parisc                randconfig-002-20260915    gcc-15.2.0
parisc               randconfig-r064-20260915    gcc-13.4.0
parisc               randconfig-r123-20260916    gcc-12.5.0 sparse
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    gcc-16.1.0
powerpc                 mpc836x_rdk_defconfig    clang-24
powerpc               randconfig-001-20260915    gcc-10.5.0
powerpc               randconfig-002-20260915    clang-24
powerpc              randconfig-r051-20260915    gcc-12.5.0
powerpc              randconfig-r054-20260914    gcc-15.2.0
powerpc              randconfig-r063-20260914    clang-22
powerpc64             randconfig-001-20260915    gcc-8.5.0
powerpc64             randconfig-002-20260915    clang-24
powerpc64            randconfig-r112-20260916    gcc-11.5.0 sparse
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
riscv             nommu_k210_sdcard_defconfig    gcc-16.1.0
riscv                 randconfig-001-20260916    gcc-8.5.0
riscv                 randconfig-002-20260916    clang-24
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260916    clang-24
s390                  randconfig-002-20260916    clang-24
s390                 randconfig-r072-20260915    gcc-9.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260916    gcc-16.1.0
sh                    randconfig-002-20260916    gcc-16.1.0
sh                   randconfig-r051-20260914    gcc-16.1.0
sh                   randconfig-r052-20260915    gcc-15.2.0
sh                   randconfig-r054-20260914    gcc-14.3.0
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260915    gcc-8.5.0
sparc                 randconfig-002-20260915    gcc-13.4.0
sparc                randconfig-r052-20260914    gcc-15.2.0
sparc                randconfig-r053-20260915    gcc-16.1.0
sparc                randconfig-r064-20260914    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64               randconfig-001-20260915    gcc-15.2.0
sparc64               randconfig-002-20260915    gcc-9.5.0
sparc64              randconfig-r064-20260914    clang-22
sparc64              randconfig-r073-20260914    clang-24
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                               allyesconfig    gcc-14
um                                  defconfig    clang-24
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260915    clang-24
um                    randconfig-002-20260915    clang-24
um                   randconfig-r071-20260915    gcc-14
um                   randconfig-r131-20260915    gcc-14 sparse
um                           x86_64_defconfig    clang-24
x86_64                            allnoconfig    clang-22
x86_64      buildonly-randconfig-001-20260915    clang-22
x86_64      buildonly-randconfig-002-20260915    clang-22
x86_64      buildonly-randconfig-003-20260915    gcc-14
x86_64      buildonly-randconfig-004-20260915    clang-22
x86_64      buildonly-randconfig-005-20260915    gcc-14
x86_64      buildonly-randconfig-006-20260915    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260915    clang-22
x86_64                randconfig-002-20260915    clang-22
x86_64                randconfig-003-20260915    gcc-14
x86_64                randconfig-004-20260915    clang-22
x86_64                randconfig-005-20260915    clang-22
x86_64                randconfig-006-20260915    clang-22
x86_64                randconfig-011-20260915    gcc-14
x86_64                randconfig-012-20260915    clang-22
x86_64                randconfig-013-20260915    clang-22
x86_64                randconfig-014-20260915    clang-22
x86_64                randconfig-015-20260915    gcc-14
x86_64                randconfig-016-20260915    clang-22
x86_64                randconfig-101-20260914    gcc-14
x86_64                randconfig-101-20260915    clang-22
x86_64                randconfig-102-20260914    clang-22
x86_64                randconfig-102-20260914    gcc-14
x86_64                randconfig-102-20260915    gcc-14
x86_64                randconfig-103-20260914    gcc-14
x86_64                randconfig-103-20260915    clang-22
x86_64                randconfig-104-20260914    gcc-14
x86_64                randconfig-104-20260915    gcc-14
x86_64                randconfig-121-20260915    clang-22 sparse
x86_64                randconfig-122-20260915    clang-22 sparse
x86_64                randconfig-123-20260915    gcc-14 sparse
x86_64                randconfig-161-20260914    clang-22
x86_64                randconfig-161-20260915    clang-22
x86_64               randconfig-r062-20260914    clang-22
x86_64               randconfig-r113-20260916    clang-22 sparse
x86_64                               rhel-9.4    clang-22
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    gcc-16.1.0
xtensa                          iss_defconfig    gcc-16.1.0
xtensa                randconfig-001-20260915    gcc-15.2.0
xtensa                randconfig-002-20260915    gcc-8.5.0
xtensa               randconfig-r061-20260914    gcc-10.5.0
xtensa                    smp_lx200_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

