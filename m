Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D37C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B2F6B00A9; Wed,  1 Jul 2026 05:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36C46B00AB; Wed,  1 Jul 2026 05:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23F96B00AC; Wed,  1 Jul 2026 05:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE55F6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:23:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28E521202C9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:23:19 +0000 (UTC)
X-FDA: 84939669318.23.8B19216
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4896710000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:23:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P1geX5Of;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782897797;
	b=pCL1TEjmhosf1Aa8a5eLXOzBRKz8mK0J6uBTZCkO6hQCdWQPw/epHEXKLaej0dMpRIrrMm
	35+cmf9x733RR2HEijhjMUrbZJ6q8zYaACSns+8wF8wIICcSPYwwags2PHudeYybxvt0cM
	ms+IwDypGrLXMKxj/M3NThS5cE2C/so=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782897797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=wxVixNk/eJnUC1I664Ozq9fEMqPstg81om+qwsjeSFU=;
	b=VuCZz9NYLn2qMIempAHJ8VQvFMNYF4YXCDWvtSMHGq1CwNUF9TkzoJKA5pwXMzM34ajTOM
	5D+M+Ul0HSCjjNgr9SxaIWPMDatXhOZAs3CejMuOwsJj1Tsel7VE05nDOOuy+mBGkpmfqy
	JqvfSb6fBlCjoIObYh2KOtHInvsd6vk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P1geX5Of;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782897796; x=1814433796;
  h=date:from:to:cc:subject:message-id;
  bh=pb+vUI5kbFUGBX9gwp5hKFcBGP5sI56LcnD9LD4e3XE=;
  b=P1geX5Ofe+OLu5uZCZVos4oODsd6j75vBJ9AgwiM9+eUROdkwg4GONid
   NC7Riu66+wKd9QvTIfKI0wT1lBba+bHWol0BXBTr31ej1Se05zH5N2WR+
   IDH2SfxIiwD+gGBi8RQMkMLgjGZ5knrOR7mCsmvv9V09sPSHG+CF6XumE
   UPoUAeKY+xo6b70qDeSjzYYW6hY2Qk/5rlq7t7ZeWHao70qb4RokiZj7M
   I9ZAQScwwO1MKLHJtlr2L0hhEkeaINnNKpbZWsNf8AV5JpTO+iBARioMK
   q2v54yrskhUhebYkXpLGkiCrBRoZRpLOaiTltEDSbarl4bcXVIfbkZIT+
   g==;
X-CSE-ConnectionGUID: jKVwDqxhQ2i0PA4b7D8AFA==
X-CSE-MsgGUID: n1CvcKwWShK9JuBmhvUD9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="83711592"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="83711592"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 02:23:15 -0700
X-CSE-ConnectionGUID: v95+kjoPS2WBxyM4E1Qq/w==
X-CSE-MsgGUID: 0xXumfFmQp+/yfzMu+wNMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="256096657"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 01 Jul 2026 02:23:14 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wer9x-0000000098G-3SBG;
	Wed, 01 Jul 2026 09:23:10 +0000
Date: Wed, 01 Jul 2026 17:13:35 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 27dbdbed235dcc9fc1e869a2a3ad97d628635dd8
Message-ID: <202607011724.jeRKV6bR-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: rfz748bfccxzzpoaeenn4we5igaauncx
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4896710000B
X-HE-Tag: 1782897796-434390
X-HE-Meta: U2FsdGVkX19WDt00rAOIcdHaRL2rdBf3skxCDIHOlPGvyjbEGhWeLDSdSWz9XO9s4JdDAcA/5NJ7ACDe8JcIHXodhPzU87IM7hSNkCf92pGYaAyVC6YNRVtiKjogsldnZbZftg4ZXCjLy0EnjdXzPHhC5eJihIzR8fIwtf2IEFq/RUNi2G/HzXi5QtqzviW+GsseSJIYxl2iPvSTuIi0A5fnmhYvBSIui1lV7ii17lFdjOOnQLOkuI0UoFLDvmROP5x/MIl0UKOGcNBBn2C5grPBOROdF/y1wXt4Ra4iRZOHBgHt89QuexYafsZ+kwVAxN9go39fWjkdsnRpuF5Ee9hdGIt2L6DafouQA9XyqKq8Jb2MwAsfX10MXERF5EDrayvRmMKn4QGnAfyOjEFJN3ZQPIO7jb9gCT7S2udP+xwiESWgsikRI61aB1BOY1MRy5JkLqJ592MRFieYQEi/JrCQ7ghVMmtb/fbSCLW2lqKcIeogSC/7i4T8tzHP7NZr8T6C5W26scUiEiZgWiUIVYxiIHho32VPG92aVuM7h8L/JArwjMAyfCH4c9YaPKCIR22QjR2Ncf3Imh6dJWVGrUlKOsF7YPHBR5SPsFU+HYaJotF0E9IIQilMLRtCPlioVv5IG9CAaQqUx/h9TOxzQhqfTdKXWIoYKLdP42B8xsioYNF92KeWAOT3N3Z4VRR19gcSUwub1sAiJZfUHvCv23CkExcWC4rMbXWL7uS9WpgSm4oXbDxGwHy2owZpuZlTLkZseZPcjJdFR09c3uKiYikL2uZZFEjra1EV0n/On4goFwd8VYHsNntxBAyDOQMIiDNPd/gR0hIpoUHQK7gdIsW5xBzlfHkTIKVnyXuI5AqkZOm3IzBxQjz4JLz4Fta/VNpWi/4v74electb/EmrF2AU/6PD95gcX75fRnP6CP6PTSuDyWIl7vvb2s/gQcr1ULnyLuLc8RFM1vtT6Ql
 hJ8zlJ86
 CBEF0cAfZg+318OerA4VHhNYuwBZV6fLOUVb/2Kp9TNWhwpMNhO99XvPvJTcXjQ1y82xeY3WWFtQj8S26FITazqNR3qdtsEHans5FQmH0GhO3rinQqx7YACp1UGuACt/UltZvMFp4L1ZWf4wDgXAqcHv8ff7j+GlSmYp/zwF2GOSV0flxeHVIPXun62Y9ioKzqiqyNQeDUMJyakw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 27dbdbed235dcc9fc1e869a2a3ad97d628635dd8  Merge branch 'kernelcore-mirror' into for-next

elapsed time: 750m

configs tested: 229
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260701    gcc-12.5.0
arc                   randconfig-002-20260701    gcc-12.5.0
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260701    gcc-12.5.0
arm                   randconfig-002-20260701    gcc-12.5.0
arm                   randconfig-003-20260701    gcc-12.5.0
arm                   randconfig-004-20260701    gcc-12.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260701    gcc-12.5.0
arm64                 randconfig-002-20260701    gcc-12.5.0
arm64                 randconfig-003-20260701    gcc-12.5.0
arm64                 randconfig-004-20260701    gcc-12.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260701    gcc-12.5.0
csky                  randconfig-002-20260701    gcc-12.5.0
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260701    clang-23
hexagon               randconfig-001-20260701    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260701    clang-23
hexagon               randconfig-002-20260701    gcc-11.5.0
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386        buildonly-randconfig-001-20260701    clang-22
i386        buildonly-randconfig-002-20260701    clang-22
i386        buildonly-randconfig-003-20260701    clang-22
i386        buildonly-randconfig-004-20260701    clang-22
i386        buildonly-randconfig-005-20260701    clang-22
i386        buildonly-randconfig-006-20260701    clang-22
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260701    clang-22
i386                           randconfig-002    clang-22
i386                  randconfig-002-20260701    clang-22
i386                           randconfig-003    clang-22
i386                  randconfig-003-20260701    clang-22
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260701    clang-22
i386                           randconfig-005    clang-22
i386                  randconfig-005-20260701    clang-22
i386                           randconfig-006    clang-22
i386                  randconfig-006-20260701    clang-22
i386                           randconfig-007    clang-22
i386                  randconfig-007-20260701    clang-22
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260701    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260701    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260701    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260701    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260701    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260701    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260701    gcc-14
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                loongson32_defconfig    clang-18
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260701    clang-23
loongarch             randconfig-001-20260701    gcc-11.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260701    clang-23
loongarch             randconfig-002-20260701    gcc-11.5.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                                defconfig    clang-23
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                         db1xxx_defconfig    clang-23
mips                            gpr_defconfig    clang-23
mips                          rb532_defconfig    clang-23
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-23
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260701    clang-23
nios2                 randconfig-001-20260701    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260701    clang-23
nios2                 randconfig-002-20260701    gcc-11.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260701    clang-17
parisc                randconfig-002-20260701    clang-17
parisc64                            defconfig    clang-23
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                     asp8347_defconfig    clang-23
powerpc               randconfig-001-20260701    clang-17
powerpc               randconfig-002-20260701    clang-17
powerpc64             randconfig-001-20260701    clang-17
powerpc64             randconfig-002-20260701    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-23
riscv                 randconfig-001-20260701    clang-23
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260701    clang-23
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-23
s390                  randconfig-001-20260701    clang-23
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260701    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-17
sh                                  defconfig    gcc-14
sh                             randconfig-001    clang-23
sh                    randconfig-001-20260701    clang-23
sh                             randconfig-002    clang-23
sh                    randconfig-002-20260701    clang-23
sh                           se7206_defconfig    gcc-16.1.0
sh                   secureedge5410_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-13.4.0
sparc                 randconfig-001-20260701    gcc-13.4.0
sparc                          randconfig-002    gcc-13.4.0
sparc                 randconfig-002-20260701    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-13.4.0
sparc64               randconfig-001-20260701    gcc-13.4.0
sparc64                        randconfig-002    gcc-13.4.0
sparc64               randconfig-002-20260701    gcc-13.4.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-13.4.0
um                    randconfig-001-20260701    gcc-13.4.0
um                             randconfig-002    gcc-13.4.0
um                    randconfig-002-20260701    gcc-13.4.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    clang-22
x86_64      buildonly-randconfig-001-20260701    clang-22
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260701    clang-22
x86_64               buildonly-randconfig-003    clang-22
x86_64      buildonly-randconfig-003-20260701    clang-22
x86_64               buildonly-randconfig-004    clang-22
x86_64      buildonly-randconfig-004-20260701    clang-22
x86_64               buildonly-randconfig-005    clang-22
x86_64      buildonly-randconfig-005-20260701    clang-22
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260701    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260701    gcc-14
x86_64                randconfig-002-20260701    gcc-14
x86_64                randconfig-003-20260701    gcc-14
x86_64                randconfig-004-20260701    gcc-14
x86_64                randconfig-005-20260701    gcc-14
x86_64                randconfig-006-20260701    gcc-14
x86_64                randconfig-011-20260701    gcc-14
x86_64                randconfig-012-20260701    gcc-14
x86_64                randconfig-013-20260701    gcc-14
x86_64                randconfig-014-20260701    gcc-14
x86_64                randconfig-015-20260701    gcc-14
x86_64                randconfig-016-20260701    gcc-14
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260701    gcc-14
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260701    gcc-14
x86_64                         randconfig-073    gcc-14
x86_64                randconfig-073-20260701    gcc-14
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260701    gcc-14
x86_64                         randconfig-075    gcc-14
x86_64                randconfig-075-20260701    gcc-14
x86_64                         randconfig-076    gcc-14
x86_64                randconfig-076-20260701    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                         randconfig-001    gcc-13.4.0
xtensa                randconfig-001-20260701    gcc-13.4.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                randconfig-002-20260701    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

