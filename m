Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DCECCCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 04:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8956B0088; Sat, 17 Oct 2026 00:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9AE6B008A; Sat, 17 Oct 2026 00:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE706B008C; Sat, 17 Oct 2026 00:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E26F26B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:48:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B577C01F0
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:48:58 +0000 (UTC)
X-FDA: 85330888356.17.DCF75C3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf31.hostedemail.com (Postfix) with ESMTP id 720E620002
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:48:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fkz0cG8I;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792212536;
	b=2oo9u0BRqkjAcmVxvHNk5aeLCbS1AoRXsdP1fzItmmsyHCg9XPYanj9h6qz9fwDd7h6Bf5
	buCZr8A4p19C+N6xQuWHAt+mQ9GvRcMBtIy5W9ZUbru8oHizv5t8FY6z3ThnAxMt0OZz8X
	yUEkowGk9uRivXJQUo36hsub0gIHxpM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fkz0cG8I;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792212536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=JVqBcQEWrR3PWF3eLKOjVv1wuEn5WkmhjwTmnoh9YVg=;
	b=ATgOQGNzlnyHICHP0OTHlFlcI2seKXyVH+ZnjFUOc9JFTtkFFPopaZZujwhUhphj4virY1
	E3VCimsYWDSi4UIduRHdEtbkQx6+eNWhDj9oxlXza9RP36r++1H4UOo/yakyZCUExVtzBf
	IzR6682zh3nT/L99I4N+T7tl8U1gexM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792212535; x=1823748535;
  h=date:from:to:cc:subject:message-id;
  bh=HVd8tdMh5dhzSM/X5GKlsuTzCDoCoiY75TaGCL9NKtg=;
  b=Fkz0cG8I8rgunxJLgP3jnfSHqwB1X/9Y3Ozb/H9Q6Dp8Nc9exPsO0zzU
   Q5B6UX10QAV5MwUUt/ERTEMkIuNL0zfE4fKloaiFxcwEomvAV8kaWThs3
   PkTi2IXgtLF/XrCDN6WfKAgz2XBTqqSSsTFaQidu9apLWVy4/Yqw1Lp7x
   wco/0pTol0YpXw8GgNZgc9irbJERiYJcG6Ps2NHUNKBisWch/1wiW/Xbg
   B8AqeuUGtx8da4N2p/fm+bb0C67uaIs529iTIQxvhje+vReFzUe5xuvyM
   +0XarKDFSp9xKuaB19t/CwNAR6T+mxNpmXkVnrdDUDdKrtnoWVJGNnrgu
   w==;
X-CSE-ConnectionGUID: Qhek90ThTSqE2WpexhZVqg==
X-CSE-MsgGUID: 3lgQcHsARXOXALntfbeuHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11937"; a="1093011"
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="1093011"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 21:48:54 -0700
X-CSE-ConnectionGUID: eHPr95KsQMqtELS29EAPgQ==
X-CSE-MsgGUID: LRAbWGcnR6eXxRujQ9x8rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="2087867"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 16 Oct 2026 21:48:53 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHwLi-00000000J5K-0FDD;
	Sat, 17 Oct 2026 04:48:50 +0000
Date: Sat, 17 Oct 2026 12:48:12 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 2efb7a11f1aa4d2dc285fe2680cca22cb9f72f64
Message-ID: <202610171209.XxIxXdsn-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 720E620002
X-Stat-Signature: 4erqjisqnt1fte4rt1f6q4ab36wycb1n
X-HE-Tag: 1792212535-54715
X-HE-Meta: U2FsdGVkX1+Wbi/hzXoQc75I8PpnD92bc9F7Lq3VyLwtDzax1htozhBjfwUBFz0MbDin7OxGggg4Vf/CLWrHPi3x5IHJwV43CF/ehuO2esTG7wQm/IlnJ2nbtYdmMGdDWXPe0cfZgFz2TdZY4R9cA0uLIyjxPfFsmnZbleSjIsoZhyuAFr5FR13uDYnRn3JOO2AbuI9VDDv0WyqdnFPND5Atyn6eh8Cmt/FVNPnuf+Agb3V+M5qA/ETeDgI7j/v4mCSnseXea6coWON9SZuwR19Xi1SphAW0MVYBbBl0ZHdozOcrPMh0KYbBNEoKKCxoeTDrSd4rQjcPzq7gunus0QLWMTSmqc/FqM5bZHYqZbJFLnzO4104ckgIIXAi0wMYHr/jvRhgXdgyhYAST97pCOjpvI9gfI747ZXjXN+T91f7QBZm1WaZkAYLPgPsUhHApRtIgksF35rGzQbqrhlx4DmLM5SQ8kFskyc0jgqzwKCygbmwh7PT5V6ELkOsCbIVNt7b9C6m85lrhQqu1OwfFeCdFKcx0YVv2ldVYf3AbvYZ7Iqyuj6WU5mnVBUwZEwI12Ze3cQdIRsz55NhCrOVE1PMgnMiuPwOpLA4VSKWd4GBYdj3prj+GBvAU3i51fgJOUkv6Df441TPUzBtGugrmXjNhP9vtn3VxczqLFcsYWJ2RHi8z9XRPPtb7OHEUGBPYcjOo7ZMWzEACgr4xY/ucMGaSJ7Ooju855Km7o2tXyCXIKSDAu3SKqx1pKxaO6S+tWdTQ1e3js/W7MNyLMZuUlfbLe2l3i6QsdVd1ecqkBtfsnl8XaW0DcQVdchEz4EiQsrrx7ohPQ31S+6GuFiCZHsmNVIX0wqtIWFyA6j1/cjpcWUrBOXclawDsX1E6sptaQQ8hB5x48t4UJFsWn9J0GXYx3Fl7pTJ5dfV8820156jcZKuRVyU/Jeo5/wnPropZAOrh6AFArjUKZFBtR5
 7XN4GSe1
 /TN/JRKiGWx0Qz5ilOYBXdK0mB3VlNq4PYzD6558WVVfllOgqmmxvx0pf9Y/+uQ0T7PON3i8hK1x/2dSgx4uzVngZJjrv+QUnf3bx+V6bfw2M9LRAOzYgY5XKL8GFhIovxXhYibo0h/2vVxPenDZpmMboQm2ePPTNxlJU/1I0c8OAYOoeSJf1Fbj4QaRN4XAaoOvRB3wvPh6gijM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 2efb7a11f1aa4d2dc285fe2680cca22cb9f72f64  Add linux-next specific files for 20261016

Error/Warning (recently discovered and may have been fixed):

    arch/openrisc/include/asm/page.h:50:29: error: request for member 'pgd' in something not a structure or union
    arch/openrisc/include/asm/page.h:54:25: error: incompatible types when initializing type 'int' using type 'pgd_t'
    include/asm-generic/pgtable-nop4d.h:9:18: error: unknown type name 'pgd_t'; did you mean 'pid_t'?
    include/linux/mm.h:3639:22: error: pointer/integer type mismatch in conditional expression [-Wint-conversion]
    include/linux/pgtable.h:1544:13: error: implicit declaration of function 'pgd_none'; did you mean 'pud_none'? [-Wimplicit-function-declaration]
    include/linux/pgtable.h:1546:22: error: implicit declaration of function 'pgd_bad'; did you mean 'pud_bad'? [-Wimplicit-function-declaration]
    include/linux/pgtable.h:167:38: error: implicit declaration of function 'p4d_offset'; did you mean 'pmd_offset'? [-Wimplicit-function-declaration]
    include/linux/pgtable.h:167:38: error: passing argument 1 of 'pud_offset' makes pointer from integer without a cast [-Wint-conversion]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- csky-allmodconfig
|   `-- fs-nfs-flexfilelayout-flexfilelayout.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
`-- openrisc-allmodconfig
    |-- arch-openrisc-include-asm-page.h:error:incompatible-types-when-initializing-type-int-using-type-pgd_t
    |-- arch-openrisc-include-asm-page.h:error:request-for-member-pgd-in-something-not-a-structure-or-union
    |-- include-asm-generic-pgtable-nop4d.h:error:unknown-type-name-pgd_t
    |-- include-linux-mm.h:error:pointer-integer-type-mismatch-in-conditional-expression
    |-- include-linux-pgtable.h:error:implicit-declaration-of-function-p4d_offset
    |-- include-linux-pgtable.h:error:implicit-declaration-of-function-pgd_bad
    |-- include-linux-pgtable.h:error:implicit-declaration-of-function-pgd_none
    `-- include-linux-pgtable.h:error:passing-argument-of-pud_offset-makes-pointer-from-integer-without-a-cast

elapsed time: 844m

configs tested: 142
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261017    gcc-12.5.0
arc                   randconfig-1001-20261017    gcc-10.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261017    gcc-8.5.0
arm                   randconfig-1001-20261017    clang-20
arm                   randconfig-1002-20261017    gcc-10.5.0
arm                   randconfig-1003-20261017    clang-22
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261017    gcc-11.5.0
arm64                 randconfig-1001-20261017    gcc-13.4.0
arm64                 randconfig-1002-20261017    clang-24
arm64                 randconfig-1003-20261017    gcc-8.5.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261017    gcc-16.1.0
csky                  randconfig-1001-20261017    gcc-14.3.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261017    clang-21
hexagon               randconfig-1001-20261017    clang-21
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261017    clang-22
i386        buildonly-randconfig-1001-20261017    gcc-14
i386        buildonly-randconfig-1002-20261017    clang-22
i386        buildonly-randconfig-1003-20261017    gcc-14
i386        buildonly-randconfig-1004-20261017    clang-22
i386        buildonly-randconfig-1005-20261017    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1007-20261017    gcc-14
i386                  randconfig-1008-20261017    gcc-14
i386                  randconfig-1009-20261017    gcc-14
i386                  randconfig-1010-20261017    clang-22
i386                  randconfig-1011-20261017    clang-22
i386                  randconfig-1012-20261017    gcc-14
i386                  randconfig-1013-20261017    gcc-14
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261017    gcc-15.2.0
loongarch             randconfig-1001-20261017    gcc-16.1.0
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261017    gcc-11.5.0
nios2                 randconfig-1001-20261017    gcc-10.5.0
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261017    gcc-10.5.0
parisc                randconfig-1001-20261017    gcc-8.5.0
parisc64                             defconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc               randconfig-1000-20261017    clang-17
powerpc               randconfig-1001-20261017    gcc-15.2.0
powerpc64             randconfig-1000-20261017    clang-20
powerpc64             randconfig-1001-20261017    gcc-8.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261017    clang-19
riscv                 randconfig-1001-20261017    clang-24
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261017    clang-24
s390                  randconfig-1001-20261017    clang-24
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20261017    gcc-16.1.0
sh                    randconfig-1001-20261017    gcc-10.5.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261017    gcc-16.1.0
sparc                 randconfig-1001-20261017    gcc-14.3.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261017    gcc-8.5.0
sparc64               randconfig-1001-20261017    gcc-15.2.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261017    clang-17
um                    randconfig-1001-20261017    gcc-14
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261017    gcc-14
x86_64      buildonly-randconfig-1001-20261017    clang-22
x86_64      buildonly-randconfig-1002-20261017    gcc-14
x86_64      buildonly-randconfig-1003-20261017    gcc-12
x86_64      buildonly-randconfig-1004-20261017    clang-22
x86_64      buildonly-randconfig-1005-20261017    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261017    gcc-14
x86_64                randconfig-1001-20261017    clang-22
x86_64                randconfig-1002-20261017    clang-22
x86_64                randconfig-1003-20261017    gcc-12
x86_64                randconfig-1004-20261017    gcc-14
x86_64                randconfig-1005-20261017    gcc-12
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20261017    gcc-14.3.0
xtensa                randconfig-1001-20261017    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

