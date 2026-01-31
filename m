Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16EB8D79764
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 09:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBDE66B0005; Sat, 31 Jan 2026 04:25:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C986B0088; Sat, 31 Jan 2026 04:25:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6AC36B008A; Sat, 31 Jan 2026 04:25:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 928C06B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 04:25:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25CBE58FA9
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 09:25:07 +0000 (UTC)
X-FDA: 84391725054.17.3BDF627
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6987520011
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 09:25:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SwaItoIT;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769851505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=vjGQZQo2vzZeEXKLbsRMK88oDfG2o/ZV7isLNrpSTuY=;
	b=gXRibb8sIEuLyJ/D9JrM845I+FFazctBbQDR5kT0upg+z8tvZrZGwe8cq7DkPWn/UfTgzx
	qXhhe3abzRUgRE1EJ7CtmAh00APL4LXKMooTXiP3D95bjShqXXqopYRGX/8WUAhW15VIaz
	eYKDu3fofo9GZlrJC4AmlPyILjSotI4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SwaItoIT;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769851505; a=rsa-sha256;
	cv=none;
	b=JtLLOmvNQQ5q2NWIdYM1fpd+hJUtUwuuZ/EDAryIUQwxMyddCPc/8pBNLZtGwnsvXpS45u
	vma0/a2Phj5okflNED1oPkTXhoV8iuxLQEmjKk7yE6nVqTYcVw3j8tYZ2xkhkoNzlJd1W6
	fbsbgrZX8M7DAj/yPgiwhbheBpw/NU8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769851505; x=1801387505;
  h=date:from:to:cc:subject:message-id;
  bh=KJz22cea5trhmdF8F+Y/XbKNEJQUXQRWWg756DeeXAo=;
  b=SwaItoITmIqceri9PIrecN4qs0VpJ+1VVzw73WSyBIu/PnbisTpg8010
   ShEIenS1RF+2I3QwIje/hmiOZQ4veXQgJUWUeF6ZxD8fp4wlJgAEbWtQ+
   GTETptrrEIpp5EKB9gF6yUS6Dyb3f/S7Z3WNw3vsf7aetZvmUAUh4inLc
   dp+dv4iAHi+4QzgzwTUckkWS1kXbeEBgfgsiv1RbGtkwcKOMxBnEjy5pJ
   uHcs4rlaDV0vOAheCAQ/BR1whTrniShdqe7+zXKSFsHFo/H7Vf+YoMeEp
   CZZqp6b6IzOZ1r7QREER68XU/5/SkgZnxMIJZ1+GXsp1dshufh/CZ6YWB
   g==;
X-CSE-ConnectionGUID: PFeOaQfFT9KnvvKLusdlKg==
X-CSE-MsgGUID: 69jZGAHWSReHipy60o6MEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="71128522"
X-IronPort-AV: E=Sophos;i="6.21,264,1763452800"; 
   d="scan'208";a="71128522"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 01:25:03 -0800
X-CSE-ConnectionGUID: diyTap1wTAaudJv11vf2fw==
X-CSE-MsgGUID: PPZOZsB3TGCiAC1qFVTDnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,264,1763452800"; 
   d="scan'208";a="209451771"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 31 Jan 2026 01:25:01 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vm7Du-00000000dsS-3QDM;
	Sat, 31 Jan 2026 09:24:58 +0000
Date: Sat, 31 Jan 2026 17:24:48 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 4c87cdd0328495759f6e9f9f4e1e53ef8032a76f
Message-ID: <202601311741.LhQ96ILG-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6987520011
X-Stat-Signature: fkwy4yixfagmopo58mgm8wyi9rk8mamm
X-Rspam-User: 
X-HE-Tag: 1769851504-438364
X-HE-Meta: U2FsdGVkX1+MwiSS6WTkJxNLB4DG4Fr6NYahXnuu2h1rTlqyKKtG2nn5iABA0vO17UoSpwHOjlEVAJUUQpERcZjD2zQiLrXM6JcVWM8X3HLemE9koSTHLMnVt2Gy1JGcEcEO1HCxhXFJavbOkExFekxvUxV2juKS4O4bhhboo9hHXPjn9KtA9seWIBD6tWSy7IdceRLCNStxH9R9pMBbQyssrlwiX+WlYZQJtQkmb2XV442VEYF6QV91lnWLWPTMRkxFyoFQ+/MmfLfUE7/Iz2zZd0pxkr1bTXdSMf79Jef/esP4Fsp+j+xt31Dt7fGnU1dPkZgSN4F6dSeJHFw2DXs3RtSdMuq6iXagFq8Sy4kdqkVR1ok8vguqLjKrNzxdycTVnKFZ4UGskZinvlVI7ccxwWsl59niSGx99CCE0J8PRLloGdGaMjFYHU2+8MOcugXe3zqoHg52n3UgPtYtXUa72rPUNRg1xmoynlaWNgkR3K92zCpvO6jsHGNr5Dup09VGuA4fCslOh/Yk5k3SLRooJDt2tJVY3VCffMDJpft0t6/sAqVuUulDQyejsN+OsDV/4ixutICyEf/oFw4wM/kjuCpuw2Y51qU87MCS0RF7WaG2HdyZLNAG7K+u7VJij1fmyFgsMrbZErpuw/ImpCB4bgWVGRlOCQoJbPAld8yhZD6cWAdlCY1BUerZCVMZ2Tm7eZ78gGDbQu5uyeXi/gvuZTN6OGtNyeF3EYUfU77nXqul4cxIdOf64deJS2tTMSVVpt2e9xqhtus+MieQVXuF4iley5WX7WcI6XpRcpuH71v7XWavgYhkdeHP3Kd1GdGRf7CwecgHKSh5I7UW1kWnTv+MKMN4e7dl6WSjT+aUalgTharSaBGTfVSlJ7ecsbdxqJs+qQRTOwrBYLKWwDh3VeXXgNs8f+qQ8mhlO1xo5BZT1nGd6U6jYf+GAAuudHmSkmAC4VyWykv1Q0d
 9Q3NljWd
 +9Q13fGVpeqM4iUPQF51q72JERpdIN6v9OWMjwU8fUC0x5lIzo/QRM9jVJ8OW+M+JVZfr9/2gdgFozJqsu6HJmfcsVQuo12ZBWJYwofspfaHcvr9EmexUjs/Qxd47rb4tE0bhtJt66mwyWc4dCfpB86mv+AirTXm1ixx160+y1nSCMwsvWfB95gbYbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 4c87cdd0328495759f6e9f9f4e1e53ef8032a76f  Add linux-next specific files for 20260130

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202601310904.DueZdiuY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202601311021.JXedL0Pm-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202601311515.8OLhEuaV-lkp@intel.com

    hinic3_irq.c:(.text+0x3ec): undefined reference to `net_dim'
    hinic3_irq.c:(.text+0x54): undefined reference to `net_dim_get_rx_moderation'
    ld.lld: error: undefined symbol: __devm_regmap_init_i3c
    ld.lld: error: undefined symbol: i3c_driver_register_with_owner
    ld.lld: error: undefined symbol: i3c_driver_unregister
    ld.lld: error: undefined symbol: i3cdev_to_dev

Unverified Error/Warning (likely false positive, kindly check if interested):

    include/linux/platform_data/cros_ec_commands.h:2036:2: warning: field  within 'struct ec_params_lightbar' is less aligned than 'union ec_params_lightbar::(anonymous at include/linux/platform_data/cros_ec_commands.h:2036:2)' and is usually due to 'struct ec_params_lightbar' being packed, which can lead to unaligned accesses [-Wunaligned-access]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-001-20260131
|   `-- include-linux-platform_data-cros_ec_commands.h:warning:field-within-struct-ec_params_lightbar-is-less-aligned-than-union-ec_params_lightbar::(anonymous-at-include-linux-platform_data-cros_ec_commands.
|-- arm-randconfig-r064-20260131
|   `-- include-linux-platform_data-cros_ec_commands.h:warning:field-within-struct-ec_params_lightbar-is-less-aligned-than-union-ec_params_lightbar::(anonymous-at-include-linux-platform_data-cros_ec_commands.
|-- arm64-randconfig-002-20260131
|   |-- ld.lld:error:undefined-symbol:__devm_regmap_init_i3c
|   |-- ld.lld:error:undefined-symbol:i3c_driver_register_with_owner
|   |-- ld.lld:error:undefined-symbol:i3c_driver_unregister
|   `-- ld.lld:error:undefined-symbol:i3cdev_to_dev
`-- powerpc64-randconfig-002-20260131
    |-- hinic3_irq.c:(.text):undefined-reference-to-net_dim
    `-- hinic3_irq.c:(.text):undefined-reference-to-net_dim_get_rx_moderation

elapsed time: 844m

configs tested: 271
configs skipped: 3

tested configs:
alpha                            alldefconfig    gcc-15.2.0
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                     nsimosci_hs_defconfig    gcc-15.2.0
arc                   randconfig-001-20260131    gcc-10.5.0
arc                   randconfig-001-20260131    gcc-8.5.0
arc                   randconfig-002-20260131    gcc-14.3.0
arc                   randconfig-002-20260131    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                       aspeed_g4_defconfig    gcc-15.2.0
arm                         bcm2835_defconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                            dove_defconfig    gcc-15.2.0
arm                        mvebu_v5_defconfig    gcc-15.2.0
arm                   randconfig-001-20260131    clang-22
arm                   randconfig-001-20260131    gcc-8.5.0
arm                   randconfig-002-20260131    gcc-8.5.0
arm                   randconfig-003-20260131    gcc-8.5.0
arm                   randconfig-004-20260131    gcc-8.5.0
arm                       versatile_defconfig    gcc-15.2.0
arm                         vf610m4_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260131    clang-22
arm64                 randconfig-001-20260131    gcc-12.5.0
arm64                 randconfig-002-20260131    clang-22
arm64                 randconfig-003-20260131    clang-22
arm64                 randconfig-004-20260131    clang-22
arm64                 randconfig-004-20260131    gcc-11.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260131    clang-22
csky                  randconfig-001-20260131    gcc-14.3.0
csky                  randconfig-002-20260131    clang-22
csky                  randconfig-002-20260131    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260131    clang-22
hexagon               randconfig-002-20260131    clang-22
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260131    clang-20
i386        buildonly-randconfig-001-20260131    gcc-14
i386        buildonly-randconfig-002-20260131    clang-20
i386        buildonly-randconfig-002-20260131    gcc-14
i386        buildonly-randconfig-003-20260131    clang-20
i386        buildonly-randconfig-003-20260131    gcc-14
i386        buildonly-randconfig-004-20260131    clang-20
i386        buildonly-randconfig-004-20260131    gcc-14
i386        buildonly-randconfig-005-20260131    clang-20
i386        buildonly-randconfig-006-20260131    clang-20
i386        buildonly-randconfig-006-20260131    gcc-12
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260131    gcc-14
i386                  randconfig-002-20260131    gcc-14
i386                  randconfig-003-20260131    gcc-12
i386                  randconfig-003-20260131    gcc-14
i386                  randconfig-004-20260131    clang-20
i386                  randconfig-004-20260131    gcc-14
i386                  randconfig-005-20260131    gcc-14
i386                  randconfig-006-20260131    gcc-14
i386                  randconfig-007-20260131    gcc-14
i386                  randconfig-011-20260131    gcc-14
i386                  randconfig-012-20260131    clang-20
i386                  randconfig-012-20260131    gcc-14
i386                  randconfig-013-20260131    gcc-14
i386                  randconfig-014-20260131    gcc-14
i386                  randconfig-015-20260131    gcc-14
i386                  randconfig-016-20260131    gcc-14
i386                  randconfig-017-20260131    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260131    clang-22
loongarch             randconfig-002-20260131    clang-22
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                       m5275evb_defconfig    gcc-15.2.0
m68k                          sun3x_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                          ath25_defconfig    clang-22
mips                     cu1830-neo_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260131    gcc-10.5.0
nios2                 randconfig-002-20260131    gcc-11.5.0
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260131    gcc-8.5.0
parisc                randconfig-002-20260131    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                    amigaone_defconfig    gcc-15.2.0
powerpc                 mpc8313_rdb_defconfig    gcc-15.2.0
powerpc                     mpc83xx_defconfig    gcc-15.2.0
powerpc                      pmac32_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260131    gcc-8.5.0
powerpc               randconfig-001-20260131    gcc-9.5.0
powerpc               randconfig-002-20260131    gcc-8.5.0
powerpc                     tqm5200_defconfig    gcc-15.2.0
powerpc                      tqm8xx_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260131    gcc-8.5.0
powerpc64             randconfig-002-20260131    gcc-13.4.0
powerpc64             randconfig-002-20260131    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                    nommu_k210_defconfig    clang-22
riscv                 randconfig-001-20260131    gcc-8.5.0
riscv                 randconfig-002-20260131    gcc-12.5.0
riscv                 randconfig-002-20260131    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260131    gcc-8.5.0
s390                  randconfig-002-20260131    clang-22
s390                  randconfig-002-20260131    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                          landisk_defconfig    gcc-15.2.0
sh                          lboxre2_defconfig    gcc-15.2.0
sh                     magicpanelr2_defconfig    gcc-15.2.0
sh                    randconfig-001-20260131    gcc-8.5.0
sh                    randconfig-001-20260131    gcc-9.5.0
sh                    randconfig-002-20260131    gcc-15.2.0
sh                    randconfig-002-20260131    gcc-8.5.0
sh                     sh7710voipgw_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260131    gcc-14
sparc                 randconfig-001-20260131    gcc-15.2.0
sparc                 randconfig-002-20260131    gcc-13.4.0
sparc                 randconfig-002-20260131    gcc-14
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260131    clang-22
sparc64               randconfig-001-20260131    gcc-14
sparc64               randconfig-002-20260131    gcc-12.5.0
sparc64               randconfig-002-20260131    gcc-14
um                               alldefconfig    gcc-15.2.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260131    gcc-14
um                    randconfig-002-20260131    gcc-14
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260131    gcc-14
x86_64      buildonly-randconfig-002-20260131    gcc-14
x86_64      buildonly-randconfig-003-20260131    gcc-14
x86_64      buildonly-randconfig-004-20260131    gcc-14
x86_64      buildonly-randconfig-005-20260131    gcc-14
x86_64      buildonly-randconfig-006-20260131    clang-20
x86_64      buildonly-randconfig-006-20260131    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260131    clang-20
x86_64                randconfig-002-20260131    clang-20
x86_64                randconfig-003-20260131    clang-20
x86_64                randconfig-004-20260131    clang-20
x86_64                randconfig-004-20260131    gcc-13
x86_64                randconfig-005-20260131    clang-20
x86_64                randconfig-006-20260131    clang-20
x86_64                randconfig-011-20260131    clang-20
x86_64                randconfig-011-20260131    gcc-12
x86_64                randconfig-012-20260131    clang-20
x86_64                randconfig-013-20260131    clang-20
x86_64                randconfig-013-20260131    gcc-14
x86_64                randconfig-014-20260131    clang-20
x86_64                randconfig-014-20260131    gcc-14
x86_64                randconfig-015-20260131    clang-20
x86_64                randconfig-015-20260131    gcc-14
x86_64                randconfig-016-20260131    clang-20
x86_64                randconfig-071-20260131    gcc-14
x86_64                randconfig-072-20260131    clang-20
x86_64                randconfig-072-20260131    gcc-14
x86_64                randconfig-073-20260131    gcc-14
x86_64                randconfig-074-20260131    clang-20
x86_64                randconfig-074-20260131    gcc-14
x86_64                randconfig-075-20260131    gcc-14
x86_64                randconfig-076-20260131    gcc-14
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
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260131    gcc-14
xtensa                randconfig-001-20260131    gcc-14.3.0
xtensa                randconfig-002-20260131    gcc-10.5.0
xtensa                randconfig-002-20260131    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

