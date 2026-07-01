Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B95BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9726B00B0; Wed,  1 Jul 2026 05:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0CD6B00B2; Wed,  1 Jul 2026 05:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D925B6B00B4; Wed,  1 Jul 2026 05:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A44236B00B0
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:43:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 268BD8CF58
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:43:21 +0000 (UTC)
X-FDA: 84939719802.04.8B8041D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9954A14000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:43:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z33QQmDA;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782898999;
	b=KM2p5M3RBvsKcT+R8YJ48k6iUh86MmO5X4nYYJ17WgMa4uX3+mwMKrpRT7i56MXGpfYyhV
	mmFvGuGwQeRuDm2e0n6uO4TIzydmYpqPG4+4hCxguQ7IHa0ctiLIBpRrnG0M+Iyi7UgT1Y
	hFdIikUvQ0UwME2iZsLvJ31ZqPyfMz4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782898999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=H714y9nHuB700A4kd1SnVaoMt3+FYt4SOw1gWryN2sY=;
	b=0N6Y/o9vtAbktkc7awgJz1zYyYL6w+65ygfh5DQlJMT+X2t13SSdTnYn9D3GtaIYxozBY0
	sq2956AE10MWXliMo6n4WisceH0cxBHGCJP9TyalblrA4YYcTSsYqVfVAyo2dDMbLf8S7C
	T56t3qxI6DYFeTmFNnAVmJRFnJ5kW28=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z33QQmDA;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782898999; x=1814434999;
  h=date:from:to:cc:subject:message-id;
  bh=5oDS87gEer02LJqJfUDEXbTY0qpSmJ9OcHxVfs7vycs=;
  b=Z33QQmDA7t/VOC8gJGlnJaJ9y30tCYY/jdLlk80fw/t8tOGm6G9e/4Y0
   4J35oel2+LBReCWrhGDIYrdw+NkD+alVvNhiBPaHhV15r1nsfMQUnb7G4
   1zxJVo0Op4ksl+LnmXye7fYjLpI394kxkzjTvze7g5LY1zGFfNJkWHi5W
   sOXPx8CQcTMOU1Q9XxoGnX33VKQnH3jPg+TO7Dp+XzFHnZ/2MKCU2osP2
   OSQqYPLTZCnezI8afioxS4yBAd2PCe5cCAswW8gJen6/B2vpopPUpJmLA
   k7ub73kqvBSRljTJZxL/gusgpj7SLvQ3Q+ASTshafoPxDhEaWoNzb2u3F
   w==;
X-CSE-ConnectionGUID: WOuwvAMoRtuE33paahS9ew==
X-CSE-MsgGUID: XahtpQ5ARuO3cbGIKkc/IQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="101053241"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="101053241"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 02:43:18 -0700
X-CSE-ConnectionGUID: vxiUHA8VTry/GBE/z6j5Ow==
X-CSE-MsgGUID: udtzBHUJQI+51mGbc/zFvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="246162215"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 01 Jul 2026 02:43:15 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1werTD-000000009A9-2fg8;
	Wed, 01 Jul 2026 09:43:06 +0000
Date: Wed, 01 Jul 2026 17:42:13 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:misc] BUILD SUCCESS
 a5d67c54d414ee707333ce179d4492e99122e5b6
Message-ID: <202607011703.mO6LJs4J-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 5msqmfn31xgkkksywed7ppsbcmkknr3w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9954A14000B
X-HE-Tag: 1782898998-250500
X-HE-Meta: U2FsdGVkX18FC4FOBd5GcH5SzcqjBfljjV+8FtMjSlDBoIBaocXn1+luM5/lsNVoWGIsF1iZRz0KsKjy6LjI4EwjNBWsSjJ/5g0YsNSjWae7m5WPe4IY0q2HIDlRJ1Jyl6OprIFzQe8gYJrt6yEfMWsWglRIQ9+rigyeAYhCCE9cpHrRAJJj11wISzEWmGVV6DzVmKCEXiL+nlblTAcERmSKifJm0Vu3Gnyt9Pn9fxEZtK2frkPhEA1vquzNZGuyje9BGK2HHqL+HcUUzu3g7/FJ4tFoJxTyFyBP+mi3+Pq/RLeZgjoGePnfCvsvSSI0hFP3j++gV+9MMZpZkt7ipT7oCSxOvglt98nsZUKIf7cPCHpglO7NNYxOTfQbe6ZmBp99e1NJ1zyrBtJEEKJ4XM26+6OgS+u+TvOoOGccfMbMY3rYWP8y0ITkoE0epJLXgSa8xlWXMRcYL3h7X2p9soZfc4S9QNpNIeIab2RIBa8zL+ns2t328EIs8eeduE7pM3XZCRHmeuBgu8E3rIaMpzYhbcbsIPWPazpsaM98WF6bkBcv7WSdBIOvNkpJWB5KmUy9BcOfOWyRnqq++pTKumHgRT+TjrxU+hmhflVvosv2AIJuvTWWd4T5WpBrOh+Gl4evb0gcXJ64JQtkeRAT4t3Deoc6hP1/PGCP43c2HSXpAS2jMtdAYswIDQfwxH8aKhl+mBkSncTmEHfc5ss1O8ivmf1vlBE40SCYPTJ0wCavlMz4CaCyOans5+i3O/mWQ9RTi9XZFfFlRBDVLmXkT1Pw3D++HPkZmaYYrwqmzIYQQ9jhmnpDrDRx3qoLhtmO74WgKN6LiD91siPJj7P+CGBWq2TYMNPeGjOJ01At3BS5dl+aIaWkcGeGkDjifmIt1DSCtOzgfpwntnav9wILqhWlzY1tw+EHPuvB4oCO8xC2hioz54ljuhBDiHuddpJjgho+TEF/82DRciOGoPv
 5H0fYdCU
 Zy2UUNOLC8K4fmYz2F+h0uRwlbPCZW8tEY9PRTM2BV91utKmZ97pf3C1DFllhdIuS9Wukn0+2kybOLFxSDAzhaJ/zlnGttWZ8mwfSkaLH+n1+Vebs/RPufcpBzmVoQxg9x0Nj8zj9ioLaH111nSNsWQcew0S3PAMGDi48CpNAPm9UGrUIBNflkpeTwyccFm4O2ektiv/iFqssk84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git misc
branch HEAD: a5d67c54d414ee707333ce179d4492e99122e5b6  mm/memblock: Remove redundant pageblock_align() in free_unused_memmap()

elapsed time: 778m

configs tested: 236
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260701    gcc-12.5.0
arc                   randconfig-002-20260701    gcc-12.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
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
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260701    clang-23
hexagon               randconfig-001-20260701    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260701    clang-23
hexagon               randconfig-002-20260701    gcc-11.5.0
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-14
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
loongarch                         allnoconfig    clang-20
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
m68k                             allyesconfig    gcc-16.1.0
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
um                               allyesconfig    gcc-14
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

