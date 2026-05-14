Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B942DCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F826B0088; Thu, 14 May 2026 03:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC02E6B008A; Thu, 14 May 2026 03:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD9D6B008C; Thu, 14 May 2026 03:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B32656B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:38:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BB9D14053D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:38:55 +0000 (UTC)
X-FDA: 84765223830.24.F50CD8E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf09.hostedemail.com (Postfix) with ESMTP id 68EAA14000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:38:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fUx2wR1M;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778744333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=WyNm0LlMAJV7LLGYH+0vjR81KgYBhSYNm0p0zT6HgOE=;
	b=2N7kjr97giDeakAk+I1Wv5FOu0oKF1gxNSCQ/siACrPH+bn7ncrVhrcxQQrWjn0+UVS/Ur
	AKs5U1NF90zB4s72jX/6opM78QmHEfCd+KzMtTCROMyhe3B+pQNdd6TxEibMiV5zQRUKsn
	OAKtTci0eXY43xj8LVwLgQbYh9+seh4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778744333; a=rsa-sha256;
	cv=none;
	b=hZ0QFE7M96fXsWMeGtBoGWFgX4TvYNBy8lqh+xprwJHCJ8zupWoUbqPpSxEo5lPIWcCppJ
	ih8elHWm6ofaBAkBJikjektBnoxFeLwblf/7YbmKG1wnd9LoaWxb4tg8NpjM/RbQTZFJTw
	8bI2w87YGnm74euzShdmDCQqq5D5bGs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fUx2wR1M;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778744332; x=1810280332;
  h=date:from:to:cc:subject:message-id;
  bh=R4Js+n1EQ/mB82/+/S/RU5XfUgPwcTpzBJd77m8P/g0=;
  b=fUx2wR1Mrq5rPfRTxlG49b2ZNbYO8wyWFPJBdMV9XM07G5yiqC76riUW
   cVz0D2uNn26XUDvT12GjfZmWp8qRtOIXG1lwgsZOVjBpo3gif3Q1+RMsd
   eolWcoHFG2o5qQPR9DDK7WTBmFg46iin2FKIVpg3T1wJ90P7wB2F8ln5d
   00K7UCSOMRTAhYevoTb41wUvNZMV4RuXydkbqRc2EgUVcXpyEEIMSESHT
   tl1VW5lDO9gqvGHHfUaVpL4vTm2IUPpFE7EpvRQWKM3mH1tZqAXK8vXim
   q0fTFLjmm41bLhLuVF5OTTmWb4D/BGSlY7tPa5p15sHQZT+FzBC5a75LK
   g==;
X-CSE-ConnectionGUID: 2LjS2UioTDa0+Kpkse7LPQ==
X-CSE-MsgGUID: cvq+BxlYScikkj0T1P19nA==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="79799738"
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="79799738"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 00:38:51 -0700
X-CSE-ConnectionGUID: ue4xl7auRw2PjQSAdoJOoA==
X-CSE-MsgGUID: /AYWcPrlQuKGyYNKpkpzkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="268667385"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 14 May 2026 00:38:49 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wNQed-0000000062v-00Bc;
	Thu, 14 May 2026 07:38:47 +0000
Date: Thu, 14 May 2026 15:38:10 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 34d885baf7cc7b47dc6ce35fc3540d93c54a1c55
Message-ID: <202605141502.Ogzxn3KI-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 68EAA14000A
X-Stat-Signature: ystxeqzywdmafe15sj1rgzrhyh75b13g
X-Rspam-User: 
X-HE-Tag: 1778744332-224671
X-HE-Meta: U2FsdGVkX1/XdsiNq3O/rLqQqdQB0HWlsLByi8t6UBHrzc4HN6j5h4z3XmP4hpFct8iZBaxel1g2hLazLHh6ApB9KOjjm5/vILx9KeEL2NKPUH+ESHUoS4a5J3SfuiI23CT2SOC8YDx4Q8wg7F+bGQpUq3ZaAKrcNpeV2gHff0LjwXxF6dynBJW2k22u6ACItP26zCZs06utriZ51DpDL4brr2qLilneoeji/eRZfxwWBde5CQxM2Z64Fo/I2p1hlzryJSxWF4VVpPon9QdGQXIruUVzqzNaAwmHpmGhkHxFEMCT1Zzny6CVqZ4+p0a0jRAkt2/fTD7yKQIAcvJhNfn8uk/P70cjmQA+RHKYdK08R6j8XTiYqRXbLI1v2XY17ngQh5ce37rN+zFUsPhG5gQ9ck9ztNY/VukWDXrnJfUw4xgz807Y+cgbGsENt4UMzvLIl+lhq1M+QsecKkeGIMSpwYTu2aiTOpMeykvSdMAuSNrmKlQ0Rir1d8A1p2OcpJhCXsgz8Av7SZpkMYuLHTOvyl43N520Qaydb2Mo5WNcMSxleAQvBcf6ICExXkX1XpxaDxVoVy/kziR8sE04QPgXnC0LZlbaUjO8b2R/c8+iJnJ+o04nfjBhBXMc0afE2xFoE+eAhmV0KhfxWXG8F7jviF5mhPohCKsDOL6nPQWI81vnGKm73rNa9kFYet+lDq5fjUwVPNjRFEf2yC+JDCd/zPeegidtHT60jlo3wch3YIEQF2kifeXzXGtRcANfpMKfg7fMt+2kBZqbZrXwlDv9nFjdc3vDp9UIdEWc0RoyWTr/kfk+yWzyAThWjgEaf0Xs3qLnX5Sh0aJX24Kp7H+pDrM1oBAangVNy05bACKTm9HhC915r3sU0Q/O+k1kc/8plBpFZW5KiP1ImlIb1IJQd/UKr4psPsanKY28yG6XllY9AXZXqTSyyfkDffaa+rpM65H7iOkiP4PaP/h
 x8KAEupv
 PBM5xWUId4oPWVVCukZUvevjsJHkmDoFmyv2eIQm+J5fkU0cRfIlFszU/AjW0tbQpDKXhwOtAEbzACiQARy7tN2PiGM50iwr36MqmO68gjlL0L+pYk9nZ/mAO6Kz1Y4YQbfuUVHKo1uHOmtdShOxWYnJ6BLCp2nGWcps8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: 34d885baf7cc7b47dc6ce35fc3540d93c54a1c55  tools/testing/memblock: fix stale NUMA reservation tests

elapsed time: 826m

configs tested: 224
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-15.2.0
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260514    clang-23
arc                   randconfig-001-20260514    gcc-8.5.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260514    clang-23
arc                   randconfig-002-20260514    gcc-8.5.0
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                                 defconfig    gcc-15.2.0
arm                            randconfig-001    gcc-8.5.0
arm                   randconfig-001-20260514    clang-23
arm                   randconfig-001-20260514    gcc-8.5.0
arm                            randconfig-002    gcc-8.5.0
arm                   randconfig-002-20260514    clang-23
arm                   randconfig-002-20260514    gcc-8.5.0
arm                            randconfig-003    gcc-8.5.0
arm                   randconfig-003-20260514    clang-23
arm                   randconfig-003-20260514    gcc-8.5.0
arm                            randconfig-004    gcc-8.5.0
arm                   randconfig-004-20260514    clang-23
arm                   randconfig-004-20260514    gcc-8.5.0
arm                         vf610m4_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260514    clang-23
arm64                 randconfig-002-20260514    clang-23
arm64                 randconfig-003-20260514    clang-23
arm64                 randconfig-004-20260514    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260514    clang-23
csky                  randconfig-002-20260514    clang-23
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260514    gcc-10.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260514    gcc-10.5.0
i386                             allmodconfig    clang-20
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260514    gcc-14
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260514    gcc-14
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260514    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260514    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260514    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260514    gcc-14
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260514    clang-20
i386                  randconfig-002-20260514    clang-20
i386                  randconfig-003-20260514    clang-20
i386                  randconfig-004-20260514    clang-20
i386                  randconfig-005-20260514    clang-20
i386                  randconfig-006-20260514    clang-20
i386                  randconfig-007-20260514    clang-20
i386                  randconfig-011-20260514    clang-20
i386                  randconfig-012-20260514    clang-20
i386                  randconfig-013-20260514    clang-20
i386                  randconfig-014-20260514    clang-20
i386                  randconfig-015-20260514    clang-20
i386                  randconfig-016-20260514    clang-20
i386                  randconfig-017-20260514    clang-20
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260514    gcc-10.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260514    gcc-10.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                                defconfig    clang-19
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                      maltasmvp_defconfig    gcc-15.2.0
mips                        qi_lb60_defconfig    clang-23
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-19
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260514    gcc-10.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260514    gcc-10.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-19
parisc                              defconfig    gcc-15.2.0
parisc                         randconfig-001    gcc-13.4.0
parisc                randconfig-001-20260514    gcc-13.4.0
parisc                         randconfig-002    gcc-13.4.0
parisc                randconfig-002-20260514    gcc-13.4.0
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                        randconfig-001    gcc-13.4.0
powerpc               randconfig-001-20260514    gcc-13.4.0
powerpc                        randconfig-002    gcc-13.4.0
powerpc               randconfig-002-20260514    gcc-13.4.0
powerpc                     tqm8541_defconfig    clang-23
powerpc64                      randconfig-001    gcc-13.4.0
powerpc64             randconfig-001-20260514    gcc-13.4.0
powerpc64                      randconfig-002    gcc-13.4.0
powerpc64             randconfig-002-20260514    gcc-13.4.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260514    gcc-14.3.0
riscv                 randconfig-002-20260514    gcc-14.3.0
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260514    gcc-14.3.0
s390                  randconfig-002-20260514    gcc-14.3.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-19
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260514    gcc-14.3.0
sh                    randconfig-002-20260514    gcc-14.3.0
sparc                             allnoconfig    clang-23
sparc                               defconfig    gcc-15.2.0
sparc                          randconfig-001    gcc-15.2.0
sparc                 randconfig-001-20260514    gcc-15.2.0
sparc                          randconfig-002    gcc-15.2.0
sparc                 randconfig-002-20260514    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-15.2.0
sparc64               randconfig-001-20260514    gcc-15.2.0
sparc64                        randconfig-002    gcc-15.2.0
sparc64               randconfig-002-20260514    gcc-15.2.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-15.2.0
um                    randconfig-001-20260514    gcc-15.2.0
um                             randconfig-002    gcc-15.2.0
um                    randconfig-002-20260514    gcc-15.2.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64               buildonly-randconfig-001    clang-20
x86_64      buildonly-randconfig-001-20260514    clang-20
x86_64               buildonly-randconfig-002    clang-20
x86_64      buildonly-randconfig-002-20260514    clang-20
x86_64               buildonly-randconfig-003    clang-20
x86_64      buildonly-randconfig-003-20260514    clang-20
x86_64               buildonly-randconfig-004    clang-20
x86_64      buildonly-randconfig-004-20260514    clang-20
x86_64               buildonly-randconfig-005    clang-20
x86_64      buildonly-randconfig-005-20260514    clang-20
x86_64               buildonly-randconfig-006    clang-20
x86_64      buildonly-randconfig-006-20260514    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260514    gcc-14
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260514    gcc-14
x86_64                         randconfig-003    gcc-14
x86_64                randconfig-003-20260514    gcc-14
x86_64                         randconfig-004    gcc-14
x86_64                randconfig-004-20260514    gcc-14
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260514    gcc-14
x86_64                         randconfig-006    gcc-14
x86_64                randconfig-006-20260514    gcc-14
x86_64                randconfig-011-20260514    clang-20
x86_64                randconfig-012-20260514    clang-20
x86_64                randconfig-013-20260514    clang-20
x86_64                randconfig-014-20260514    clang-20
x86_64                randconfig-015-20260514    clang-20
x86_64                randconfig-016-20260514    clang-20
x86_64                randconfig-071-20260514    clang-20
x86_64                randconfig-072-20260514    clang-20
x86_64                randconfig-073-20260514    clang-20
x86_64                randconfig-074-20260514    clang-20
x86_64                randconfig-075-20260514    clang-20
x86_64                randconfig-076-20260514    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-23
xtensa                         randconfig-001    gcc-15.2.0
xtensa                randconfig-001-20260514    gcc-15.2.0
xtensa                         randconfig-002    gcc-15.2.0
xtensa                randconfig-002-20260514    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

