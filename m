Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B35CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 08:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58746B008A; Fri,  9 Oct 2026 04:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09B36B0093; Fri,  9 Oct 2026 04:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F396B0095; Fri,  9 Oct 2026 04:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA676B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:49:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0F511202C4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:49:00 +0000 (UTC)
X-FDA: 85302462840.05.F01F65A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id 107BC12000E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:48:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GDZlnhOt;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791535738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Xef4p6DhSkIwo9votdeIWwA+iyUC1Je0fPWGzpQo4QY=;
	b=IyO3dFuMjIF7XpTdfUFSm4sDs2j1MI3NmtInhTDJi13rNisMaFWuWFABrE+gwsalDOtq08
	WDVOGhlzjImHLdt2asLlVO3v4RBjJyKS6RDOPLY+0jO6mGlLyWpCTgfh4As7yNt9guktBf
	68Qs4bIpplzXIvqWy4AZzR4SmZ8lcX8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791535738;
	b=EwUCcuZRdtOitGCEaMp1R0tPhHM2olqKYwEdMJSpSN7WgEEDr035deYbHlrluGINDXEdi+
	vSwuRmHkoAfdgA6kYNmQ8Blo2J/EAwG+541Tdfg9/hq+3f46Zhw1LhnlWU1YtbYRIRCgCb
	M3BEM2UOxO+zu2kLHUe5ec+CdBhkZto=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GDZlnhOt;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791535738; x=1823071738;
  h=date:from:to:cc:subject:message-id;
  bh=d1gpiod3KIaluTXWDX7N4RUKFKhQHKSrWKZKDbjyPzE=;
  b=GDZlnhOtFZM5hSCmCHTNm24kBiidiHTltk2IZuisBZ2oW/EgPKYg83tY
   +GOSNpJoTMmRiyTt7Ao4SA9a06ZDoW2wAiJjEu/m6iW9Kax9jZCHYToX/
   M4FldkEe3sSLNTqMAvf2H/x4bwk+ypGbvTHfolQbeXTf965Mj9EhDBDbY
   tvhiP/mt9rWUSuuX4sohUosZTCEzvnRvm7eZ1Del6KGIOK3/cBWBwPqz5
   jZFvCnI7AVixuux57gPNjviYSnBzzU+9K9SvwhSkyJjXwuhm07HCwBn2n
   yaxCqpO3ov7XNPQ74Vgk3+W7rseGROZlR7qh5zIvMGhtiJ7ULDV++3Q/2
   w==;
X-CSE-ConnectionGUID: rV291P/cTjqQzTnOaVkCDA==
X-CSE-MsgGUID: xyuuELO/Q4+ynZgFjsrUCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="345440"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="345440"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 01:48:57 -0700
X-CSE-ConnectionGUID: AJj3P4LgShOyN2NdiiXn+w==
X-CSE-MsgGUID: Vl4Q8eXaR3aJXjatX8mXMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="720762"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 09 Oct 2026 01:48:55 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xF6Hb-000000005WC-418N;
	Fri, 09 Oct 2026 08:48:51 +0000
Date: Fri, 09 Oct 2026 16:48:28 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH UNVERIFIED WARNING
 aac26bee2287c88af5be5a5ff96d783b19a28790
Message-ID: <202610091624.Ly71I9oq-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 107BC12000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: yz1mzntc8qagmd5wxy5kkrmazm89smxk
X-HE-Tag: 1791535737-434273
X-HE-Meta: U2FsdGVkX1+SRLeKYieWaGGQ9zmRH3/+qZCdsWbH0Cg9xoD1m5Mk5RtslIi2uaxXpkRTh4Y+JJA6zOT5lxsQnQKcToUW10AOgvyQvD7HtCJF9eTQuYYC3UDnDS3uUzp89fNz3v/tqMCGnU0Eh6AZGtaVMh1geEl4XKclA6wBWu5kQBZktZA1riWS8pMZUziUSZehAcHfh49lZeTjJ2Bp2d7/TIo0IU85ORTNktx+tK0V9914WJmq52Lbm82bgJuRAahoVFm6cfoMFA742aeINc2C+lvYeYiRCGD1q54nI4Sbpy3ocTVOnlHjyPR44RTOWb6lhCEr5XPffI3pO48gX8V9imcdIkwt15CKG8wcpVWKCQQxr2J1r5uZ6hvbqegWB+RuXWXRYfBbdtvekhWfCfJQOGTt9YUTsh/iYWjSUfdcwWf9dYBnrXKe/LKinEXzo1gfAh8oU+Ho7mkJOMLxNvjmlt++RPmuTw2mNYWUGsezWph5rOjif5qFUP+1Pf6X7H4SDUgUgOc/3aV1bI2Il9EvoO+jLCPj8aQ6dyVzUcVrFyfKoJ+Rdu/GvIVKfnXMUvDjcGKe5OxqdGMzv6IDTaj5FPFAlTxnYKt+GVmNIRzoNj0kFVqlz0K5QYx5dlcwhXzo7AceQlC5Lwn3agA5k7S2ecMTFu6QktQcvFWlCyExDgetKikYjRQd4I4VX7pvU7uw87GH8HI5e/7fxzgwhdQeryYEWBH7YGr754dLVxZE6P6DXbjYMPO3OksfmXRWygsmcn5wcEkOLYtIlaLFXKh8KqB/PAGgtyi+hregkm3iCTlpfBnsy3ZrzmtVgIFvyXqYTQCOiiQE5CjZdPBmelqKnvEdX+HgIPfXLX2NyAXwCreQlmtaHPjQm9VDAw13VMOcqwhcHpYiX8bkJCc5Q4vwQ8LCIUHWc/W6emfOmE1bhb3dYBnMbR8kzEvyLR42EiYxEZFrtLRt5MzaOra
 K6Zmri3U
 ribAr7oq+d47nRGZX2fek0kMcb2+c4lKKtwp4/623HANzsMHYzprpmUr9ydr47zpVotKv/URoelSoLU57oZ6Ase+lwuUtw66tMTgwkcVsO/OihDx4pG+6H6+0TzdIdAAYedlKusxbERui1ta0BGgZp1Ti6o4U9nDqORadIVYonZXe14/JGCgfuqYmoFLOUwBcm2RYCh1/B72lafSEfC8oarwwUfy/G8yu/6U5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: aac26bee2287c88af5be5a5ff96d783b19a28790  Add linux-next specific files for 20261008

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202610081540.BPLUol7s-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202610081904.S2BQWEmZ-lkp@intel.com

    drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c:1931:32-50: opportunity for str_on_off(mes -> dbgext_active)
    drivers/gpu/drm/amd/ras/core/ras_psp.c:137:15-16: WARNING opportunity for kfree_sensitive/kvfree_sensitive (memset at line 136)

Warning ids grouped by kconfigs:

recent_errors
|-- x86_64-allnoconfig
`-- x86_64-randconfig-2100-20261008
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mes.c:opportunity-for-str_on_off(mes-dbgext_active)
    |-- drivers-gpu-drm-amd-ras-core-ras_psp.c:WARNING-opportunity-for-kfree_sensitive-kvfree_sensitive-(memset-at-line-)
    `-- drivers-gpu-drm-amd-ras-core-ras_umc.c:WARNING-opportunity-for-kmemdup

elapsed time: 1166m

configs tested: 262
configs skipped: 13

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2104-20261008    gcc-8.5.0  cocci
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261009    gcc-8.5.0
arc                   randconfig-1001-20261009    gcc-8.5.0
arc                  randconfig-r2105-20261008    gcc-16.1.0 cocci
arc                  randconfig-r2307-20261008    gcc-13.4.0 sparse
arm                                allnoconfig    clang-17
arm                                  defconfig    clang-24
arm                             mmp2_defconfig    gcc-16.1.0
arm                   randconfig-1000-20261009    gcc-10.5.0
arm                   randconfig-1001-20261009    gcc-8.5.0
arm                   randconfig-1002-20261009    clang-24
arm                   randconfig-1003-20261009    gcc-15.2.0
arm                  randconfig-r2101-20261008    gcc-8.5.0  cocci
arm                  randconfig-r2107-20261008    clang-24   cocci
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261009    gcc-12.5.0
arm64                 randconfig-1001-20261009    clang-22
arm64                 randconfig-1002-20261009    clang-24
arm64                 randconfig-1003-20261009    clang-19
arm64                randconfig-r2306-20261008    gcc-13.4.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261009    gcc-15.2.0
csky                  randconfig-1001-20261009    gcc-9.5.0
csky                 randconfig-r2104-20261008    gcc-16.1.0 cocci
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261008    clang-24
hexagon               randconfig-1001-20261008    clang-18
hexagon              randconfig-r2103-20261008    gcc-8.5.0  cocci
hexagon              randconfig-r2201-20261008    clang-24   smatch
hexagon              randconfig-r2305-20261008    clang-24   sparse
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261009    clang-22
i386        buildonly-randconfig-1001-20261009    clang-22
i386        buildonly-randconfig-1002-20261009    gcc-14
i386        buildonly-randconfig-1003-20261009    clang-22
i386        buildonly-randconfig-1004-20261009    clang-22
i386        buildonly-randconfig-1005-20261009    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261008    clang-22
i386                  randconfig-1001-20261008    clang-22
i386                  randconfig-1002-20261008    gcc-14
i386                  randconfig-1003-20261008    gcc-14
i386                  randconfig-1004-20261008    gcc-14
i386                  randconfig-1005-20261008    clang-22
i386                  randconfig-1006-20261008    gcc-14
i386                  randconfig-1007-20261008    gcc-14
i386                  randconfig-1008-20261008    gcc-12
i386                  randconfig-1009-20261008    clang-22
i386                  randconfig-1010-20261008    gcc-13
i386                  randconfig-1011-20261008    gcc-14
i386                  randconfig-1012-20261008    gcc-14
i386                  randconfig-1013-20261008    gcc-14
i386                  randconfig-2100-20261008    clang-22   cocci
i386                  randconfig-2101-20261008    clang-22   cocci
i386                  randconfig-2101-20261008    gcc-12     cocci
i386                  randconfig-2102-20261008    clang-22   cocci
i386                  randconfig-2103-20261008    clang-22   cocci
i386                  randconfig-2200-20261008    clang-22   smatch
i386                  randconfig-2300-20261008    clang-22   sparse
i386                  randconfig-2300-20261008    gcc-14     sparse
i386                  randconfig-2301-20261008    clang-22   sparse
i386                  randconfig-2301-20261008    gcc-14     sparse
i386                  randconfig-2302-20261008    clang-22   sparse
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261008    gcc-16.1.0
loongarch             randconfig-1001-20261008    gcc-16.1.0
loongarch            randconfig-r2106-20261008    clang-24   cocci
loongarch            randconfig-r2107-20261008    clang-22   cocci
loongarch            randconfig-r2200-20261008    gcc-13.4.0 smatch
loongarch            randconfig-r2202-20261008    gcc-13.4.0 smatch
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2106-20261008    gcc-13.4.0 cocci
m68k                 randconfig-r2301-20261008    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2309-20261008    gcc-13.4.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                       maltasmvp_defconfig    gcc-16.1.0
mips                 randconfig-r2300-20261008    gcc-16.1.0 sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261008    gcc-10.5.0
nios2                 randconfig-1001-20261008    gcc-8.5.0
nios2                randconfig-r2100-20261008    gcc-11.5.0 cocci
nios2                randconfig-r2100-20261008    gcc-8.5.0  cocci
nios2                randconfig-r2202-20261008    gcc-8.5.0  smatch
nios2                randconfig-r2308-20261008    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc                   or1klitex_defconfig    gcc-16.1.0
openrisc             randconfig-r2106-20261008    gcc-16.1.0 cocci
openrisc             randconfig-r2201-20261008    gcc-13.4.0 smatch
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261009    gcc-8.5.0
parisc                randconfig-1001-20261009    gcc-11.5.0
parisc               randconfig-r2104-20261008    gcc-16.1.0 cocci
parisc64                          alldefconfig    gcc-16.1.0
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                        ppc64_defconfig    clang-17
powerpc               randconfig-1000-20261009    gcc-10.5.0
powerpc               randconfig-1001-20261009    gcc-8.5.0
powerpc              randconfig-r2105-20261008    clang-24   cocci
powerpc              randconfig-r2201-20261008    clang-17   smatch
powerpc              randconfig-r2304-20261008    clang-22   sparse
powerpc64             randconfig-1000-20261009    clang-17
powerpc64             randconfig-1001-20261009    clang-17
powerpc64            randconfig-r2107-20261008    gcc-16.1.0 cocci
riscv                              allnoconfig    gcc-16.1.0
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261009    gcc-8.5.0
riscv                 randconfig-1001-20261009    gcc-16.1.0
riscv                 randconfig-2000-20261008    clang-24
riscv                 randconfig-2000-20261008    gcc-11.5.0
riscv                 randconfig-2001-20261008    clang-24
riscv                 randconfig-2001-20261008    gcc-11.5.0
riscv                randconfig-r2101-20261008    clang-24   cocci
riscv                randconfig-r2300-20261008    clang-22   sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261009    clang-20
s390                  randconfig-1001-20261009    gcc-8.5.0
s390                  randconfig-2000-20261008    gcc-11.5.0
s390                  randconfig-2000-20261008    gcc-8.5.0
s390                  randconfig-2001-20261008    gcc-11.5.0
s390                  randconfig-2001-20261008    gcc-8.5.0
s390                 randconfig-r2304-20261008    gcc-10.5.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                      magicpanelr2_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261009    gcc-16.1.0
sh                    randconfig-1001-20261009    gcc-16.1.0
sh                    randconfig-2000-20261008    gcc-11.5.0
sh                    randconfig-2000-20261008    gcc-9.5.0
sh                    randconfig-2001-20261008    gcc-11.5.0
sh                   randconfig-r2200-20261008    gcc-16.1.0 smatch
sh                   randconfig-r2301-20261008    clang-22   sparse
sh                   randconfig-r2302-20261008    clang-22   sparse
sh                   randconfig-r2303-20261008    clang-22   sparse
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261009    gcc-11.5.0
sparc                 randconfig-1001-20261009    gcc-8.5.0
sparc                 randconfig-2000-20261008    gcc-14
sparc                 randconfig-2000-20261008    gcc-8.5.0
sparc                 randconfig-2001-20261008    gcc-11.5.0
sparc                 randconfig-2001-20261008    gcc-14
sparc                randconfig-r2102-20261008    gcc-8.5.0  cocci
sparc                randconfig-r2103-20261008    gcc-11.5.0 cocci
sparc                randconfig-r2303-20261008    gcc-13.4.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261009    clang-20
sparc64               randconfig-1001-20261009    clang-21
sparc64               randconfig-2000-20261008    gcc-14
sparc64               randconfig-2000-20261008    gcc-16.1.0
sparc64               randconfig-2001-20261008    clang-20
sparc64               randconfig-2001-20261008    gcc-14
sparc64              randconfig-r2202-20261008    gcc-13.4.0 smatch
sparc64              randconfig-r2302-20261008    clang-20   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261009    clang-18
um                    randconfig-1001-20261009    clang-24
um                    randconfig-2000-20261008    gcc-14
um                    randconfig-2001-20261008    gcc-14
um                   randconfig-r2105-20261008    gcc-14     cocci
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261009    clang-22
x86_64      buildonly-randconfig-1001-20261009    clang-22
x86_64      buildonly-randconfig-1002-20261009    clang-22
x86_64      buildonly-randconfig-1003-20261009    clang-22
x86_64      buildonly-randconfig-1004-20261009    gcc-14
x86_64      buildonly-randconfig-1005-20261009    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261008    gcc-14
x86_64                randconfig-1001-20261008    clang-22
x86_64                randconfig-1002-20261008    gcc-14
x86_64                randconfig-1003-20261008    gcc-14
x86_64                randconfig-1004-20261008    gcc-14
x86_64                randconfig-1005-20261008    clang-22
x86_64                randconfig-1006-20261008    gcc-14
x86_64                randconfig-1007-20261008    gcc-14
x86_64                randconfig-1008-20261008    clang-22
x86_64                randconfig-1009-20261008    clang-22
x86_64                randconfig-1010-20261008    clang-22
x86_64                randconfig-1011-20261008    clang-22
x86_64                randconfig-1012-20261008    clang-22
x86_64                randconfig-1013-20261008    gcc-14
x86_64                randconfig-1014-20261008    gcc-14
x86_64                randconfig-1015-20261008    clang-22
x86_64                randconfig-1016-20261008    clang-22
x86_64                randconfig-1017-20261008    gcc-14
x86_64                randconfig-2100-20261008    clang-22   cocci
x86_64                randconfig-2101-20261008    gcc-14     cocci
x86_64                randconfig-2102-20261008    gcc-14     cocci
x86_64                randconfig-2103-20261008    clang-22   cocci
x86_64                randconfig-2200-20261008    gcc-14     smatch
x86_64                randconfig-2300-20261008    clang-22   sparse
x86_64                randconfig-2300-20261008    gcc-14     sparse
x86_64                randconfig-2301-20261008    clang-22   sparse
x86_64                randconfig-2302-20261008    clang-22   sparse
x86_64               randconfig-r2305-20261008    clang-22   sparse
x86_64               randconfig-r2308-20261008    gcc-13.4.0 sparse
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                   audio_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-1000-20261009    gcc-9.5.0
xtensa                randconfig-1001-20261009    gcc-8.5.0
xtensa                randconfig-2000-20261008    gcc-14
xtensa                randconfig-2000-20261008    gcc-8.5.0
xtensa                randconfig-2001-20261008    gcc-14
xtensa                randconfig-2001-20261008    gcc-8.5.0
xtensa               randconfig-r2102-20261008    gcc-8.5.0  cocci
xtensa               randconfig-r2200-20261008    gcc-8.5.0  smatch

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

