Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E176D46C1C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 06:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983F96B0005; Fri, 30 Jan 2026 01:46:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E896B0089; Fri, 30 Jan 2026 01:46:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830AE6B008A; Fri, 30 Jan 2026 01:46:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 728956B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:46:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E77731A052F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:46:40 +0000 (UTC)
X-FDA: 84387696960.11.CFB0555
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf16.hostedemail.com (Postfix) with ESMTP id D27F0180008
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:46:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hYzUD7Vq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769755599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/yBLdFpbzVhBgV0n5sFT7tEbcsgsjOEPHPXluU4tjQE=;
	b=Js0FPRp8WI4Oy09Ld4PFGoT+stevWVNueYYAVXoVp0NV/0x3KIVnbHQ8c5DlAnDXqL49uN
	e/zBoUnCWSmviPbg1WV1BfD5fPEF2TeJLYxOBiu8979gWVRU4CQhqPt1c4Vwosvc+ecuWe
	A6pAvFR7XRoFZlb0AlIV15YMDhE3WiY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769755599; a=rsa-sha256;
	cv=none;
	b=CN6Jduo5Izb39u2J3oWLcotWpUj/6iFDDLQnWDDLomVD8g8NA8GyhBwLayFTn25mOtCaFd
	U00QDRg6upl8k3rKVTkgOUewlNg/kcoZifInj8+THR3ieykLEfHc9byTeYpk21X2TiEpa4
	ozsj/hwTmVWpjTMzycy+05maxbwB4io=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hYzUD7Vq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769755599; x=1801291599;
  h=date:from:to:cc:subject:message-id;
  bh=9VOYBZ0gY+t/ULb4fsbgd71lQKZaav89hhce4uuRIAg=;
  b=hYzUD7Vq4TW+1ETSmrBgZCcW4yYg0H30wnHrHGZoaToB1kBnPeyY7NGq
   xD/q8lLDt0wvVqioJKapK2w1VV2MmhVcg6QIMAlPfVcINSPz1vH8MkVZA
   hXYPxEG1NsY6nnI29hVxj0GNmHL4ElLq47MsiDOPoBACePHq+SIe+UxjR
   K56bGt5ZmZgVGBdkxEzIyMJv2+B78EbpsIOoBXnRwOb4UgF3RItE6iUA7
   RXtXjfQjF8c2cQSuFp16hfBuXPABKv1n8muA/knBePodB4RR+JXW0AClP
   WV+6j2ZWLG3BB8DVE6al1f7KxQyTCeaeO5C/ZNHzmgTGZQwcANr8aBAp6
   w==;
X-CSE-ConnectionGUID: FZVvvfofRT+2Tt8Msk4tow==
X-CSE-MsgGUID: 2d/bxySVRzWA9MApRyTfzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70909817"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="70909817"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 22:46:37 -0800
X-CSE-ConnectionGUID: fI+FobsCRn2DLQHOecCIDg==
X-CSE-MsgGUID: 2zqXT0S2Qc6aawaNMr0iNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="208378861"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 29 Jan 2026 22:46:36 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vliH3-00000000cHS-3Ada;
	Fri, 30 Jan 2026 06:46:33 +0000
Date: Fri, 30 Jan 2026 14:46:03 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 33a647c659ffa5bdb94abc345c8c86768ff96215
Message-ID: <202601301455.c6SKDgpV-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: D27F0180008
X-Stat-Signature: r7kq1buwn13k3irp5otbimyw95ae7cfp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769755598-148
X-HE-Meta: U2FsdGVkX1+BKCfqgVdVpXhM3Y4//FIWwsAvUSupuFLPL2RqALvjwvjOtz7ZmATKt7c4mvFJ0w3kWOUS+hpulhw1bFwuJw2yos/A2pleFF9HPXHm25uuFUL0CI6D9afbVyNXO36DR0gdTUGW2rNX+GwSmh6wQL4vIolLLrFvEPbn5WNvBsLoBrAGJJGprjgFmwnmJM2M5efyhjuhFh/gXF+zPTqqoGxglbPnUtRAW714/yidZgx9ILbsA/jTx1VgQzIudSWaHaIjLm00xxxkB+G+DQTicvJu7KJ3VmpDaWgw2lwwbv/PAYiDSNOMxjBpfbc7rv1ElLQzuYoPoDSfLEaQnf7GsvC5QG1gTBt7R8ujPmlIg4YU8B7Ruxfxe4rmOsBkUlrgTH8/C9TnwhK6ZPJ82esE815EgvdcXHpdUHnMaIvXAfK3O3z0qsag/wKF4jJU4HQNWLCOUcZTJB2gn5Urh++u/aEOXQdBdugRIix+1o9Sf+oZ4NqCFi+JcKauNRjNMvKmjPeBQqP8avluzXn8PpGYh/K2wtD8X+MxVRLERNBUUzw2N1wQ/op7n9+bazQzzuCeEbf0x8uoCRWnyY6H0RlX49h03cz411UI/a3Pawbf26MfPZPMWlM9ipBNMYhLLTXwT+cTh+403NPleMLELBaGB4LSo9EJ+GgivkP3jzkC0LeC1pIQlRybqqtQ5yqhpHOkLHKO1YvJzMcrUez6XGdW+kWp7bpFoy69/to51wYLqyb9iI6Dehue3LtjliYVkjd6xvv4G6/xtoYOLvoOq6pDZ6B9hjLAtK5zvXPhvkEqZM96QQ7Su64F6iAaVK2X1df3SVUkHBrBk/oln3Sok3p29e9ZjFCh0K+NCNeJVvVDl06vRtBNngcpsGU9Q2TZUGcLD0ORusdxCXCfzLpRTRWCWvKpNmxHew32uRISQ9rGK5JSePrpU+kpvmYJB2a5MFME7wHSD9iLedX
 LnFx3mTa
 Had38ZgNBwM2mxjVgU5QJDk4FLw5OpuTGsPrAq0BoB+SFDa8EyIvNwM+f0Uiv1txcHECnZGxPmSi2hwmHA8Zk4YWNTWwcj+Rp1Qpig8t3eEp6UtsaZj4p/DhNoEfJp9ZA3rGIicAu3jY3O30DEY28TNTlWZMrf91SsgVDLR83jESY+JDjv6+BLyHyhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 33a647c659ffa5bdb94abc345c8c86768ff96215  Add linux-next specific files for 20260129

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild/202601300419.4aPdW3N6-lkp@intel.com

    (.text+0x10c): undefined reference to `typec_switch_unregister'
    (.text+0x148): undefined reference to `typec_switch_get_drvdata'
    (.text+0x864): undefined reference to `typec_switch_register'
    alpha-linux-ld: (.text+0x11c): undefined reference to `typec_switch_unregister'
    alpha-linux-ld: (.text+0x164): undefined reference to `typec_switch_get_drvdata'
    alpha-linux-ld: (.text+0x870): undefined reference to `typec_switch_register'
    include/linux/compiler_types.h:630:45: error: call to '__compiletime_assert_619' declared with attribute error: min(((pos + len - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error

Unverified Error/Warning (likely false positive, kindly check if interested):

    arch/parisc/kernel/drivers.c:928 qemu_header() error: strcpy() 'boot_cpu_data.pdc.sys_model_name' too large for 'name_mpe' (81 vs 64)
    mm/vmscan.c:7402:1: internal compiler error: in arc_ccfsm_record_condition, at config/arc/arc.cc:5522

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r071-20260130
|   |-- (.text):undefined-reference-to-typec_switch_get_drvdata
|   |-- (.text):undefined-reference-to-typec_switch_register
|   |-- (.text):undefined-reference-to-typec_switch_unregister
|   |-- alpha-linux-ld:(.text):undefined-reference-to-typec_switch_get_drvdata
|   |-- alpha-linux-ld:(.text):undefined-reference-to-typec_switch_register
|   `-- alpha-linux-ld:(.text):undefined-reference-to-typec_switch_unregister
|-- arc-randconfig-001-20260130
|   `-- mm-vmscan.c:internal-compiler-error:in-arc_ccfsm_record_condition-at-config-arc-arc.cc
|-- i386-randconfig-051-20260130
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(((pos-len-)-)-(pos-)-max_pages)-signedness-error
`-- parisc-randconfig-r071-20260130
    `-- arch-parisc-kernel-drivers.c-qemu_header()-error:strcpy()-boot_cpu_data.pdc.sys_model_name-too-large-for-name_mpe-(-vs-)

elapsed time: 813m

configs tested: 173
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260130    gcc-13.4.0
arc                   randconfig-002-20260130    gcc-15.2.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20260130    clang-22
arm                   randconfig-002-20260130    clang-17
arm                   randconfig-003-20260130    clang-22
arm                   randconfig-004-20260130    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260130    gcc-8.5.0
arm64                 randconfig-002-20260130    gcc-8.5.0
arm64                 randconfig-003-20260130    gcc-8.5.0
arm64                 randconfig-004-20260130    clang-22
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260130    gcc-15.2.0
csky                  randconfig-002-20260130    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20260130    clang-19
hexagon               randconfig-002-20260130    clang-18
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260130    clang-20
i386        buildonly-randconfig-002-20260130    clang-20
i386        buildonly-randconfig-003-20260130    clang-20
i386        buildonly-randconfig-004-20260130    gcc-14
i386        buildonly-randconfig-005-20260130    clang-20
i386        buildonly-randconfig-006-20260130    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260130    clang-20
i386                  randconfig-002-20260130    clang-20
i386                  randconfig-003-20260130    clang-20
i386                  randconfig-004-20260130    clang-20
i386                  randconfig-005-20260130    gcc-14
i386                  randconfig-006-20260130    clang-20
i386                  randconfig-007-20260130    gcc-14
i386                  randconfig-011-20260130    gcc-14
i386                  randconfig-012-20260130    gcc-14
i386                  randconfig-013-20260130    gcc-14
i386                  randconfig-014-20260130    clang-20
i386                  randconfig-015-20260130    gcc-14
i386                  randconfig-016-20260130    gcc-14
i386                  randconfig-017-20260130    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260130    clang-22
loongarch             randconfig-002-20260130    clang-18
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                          amiga_defconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
m68k                       m5208evb_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                           jazz_defconfig    clang-17
mips                       rbtx49xx_defconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260130    gcc-8.5.0
nios2                 randconfig-002-20260130    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
openrisc                    or1ksim_defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260130    gcc-14.3.0
parisc                randconfig-002-20260130    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                     akebono_defconfig    clang-22
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260130    gcc-14.3.0
powerpc               randconfig-002-20260130    gcc-10.5.0
powerpc64             randconfig-001-20260130    clang-22
powerpc64             randconfig-002-20260130    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20260130    gcc-14.3.0
riscv                 randconfig-002-20260130    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                  randconfig-001-20260130    clang-22
s390                  randconfig-002-20260130    clang-22
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260130    gcc-9.5.0
sh                    randconfig-002-20260130    gcc-13.4.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260130    gcc-8.5.0
sparc                 randconfig-002-20260130    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260130    clang-22
sparc64               randconfig-002-20260130    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260130    clang-22
um                    randconfig-002-20260130    gcc-13
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260130    clang-20
x86_64      buildonly-randconfig-002-20260130    gcc-14
x86_64      buildonly-randconfig-003-20260130    clang-20
x86_64      buildonly-randconfig-004-20260130    clang-20
x86_64      buildonly-randconfig-005-20260130    clang-20
x86_64      buildonly-randconfig-006-20260130    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260130    clang-20
x86_64                randconfig-002-20260130    gcc-14
x86_64                randconfig-003-20260130    gcc-14
x86_64                randconfig-004-20260130    gcc-14
x86_64                randconfig-005-20260130    gcc-14
x86_64                randconfig-006-20260130    clang-20
x86_64                randconfig-011-20260130    clang-20
x86_64                randconfig-012-20260130    clang-20
x86_64                randconfig-013-20260130    clang-20
x86_64                randconfig-014-20260130    gcc-14
x86_64                randconfig-015-20260130    clang-20
x86_64                randconfig-016-20260130    gcc-14
x86_64                randconfig-071-20260130    clang-20
x86_64                randconfig-072-20260130    clang-20
x86_64                randconfig-073-20260130    clang-20
x86_64                randconfig-074-20260130    clang-20
x86_64                randconfig-075-20260130    clang-20
x86_64                randconfig-076-20260130    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260130    gcc-12.5.0
xtensa                randconfig-002-20260130    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

