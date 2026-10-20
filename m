Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C50606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SQUYcaAc
Received: by kanga.kvack.org (Postfix)
	id 23A0B6B057D; Tue, 20 Oct 2026 18:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EAB56B057E; Tue, 20 Oct 2026 18:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101E66B057F; Tue, 20 Oct 2026 18:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DABE46B057D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:39:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D76D1A0311
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:39:10 +0000 (UTC)
X-FDA: 85344471660.11.13C4BB9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id AE6ECA0009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:39:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SQUYcaAc;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792535948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=XsbHZIJT6JLpYcKxANzaAa5ypM0E/zE/fkdyTQ9Ue7A=;
	b=bMvhC1LPxC9JiM53OUdiyVVMawNYGCkbgir/vswTcSyl8rKveyyOSiSz8tXAVfkgGjbIPW
	1G7wtwOMMWetfHQMv7coNNqrZg8SndL+zaWHCuXEgZ+yvUR6jxiG7S0uL0jtwyKWPG5qia
	sxSEJaYsKy34ZLGFTSUXA00s4KZPoiQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SQUYcaAc;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792535948;
	b=4aFMZDMvU+V7OtQerOlwrod5T/2pXkGzZVEPt6g0Nx0deUSyMVHwfffPvCycS6t0jD6i34
	7vc9I8Im9AaJB2ky1vIdRHuDrsQkNLWpSyeJ9bk25DuJJM3eTBUuOpOPeorHSt3zmv0xCc
	zYlApNaAAAG7IO6PKuaBeXPuuqHl/ws=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792535947; x=1824071947;
  h=date:from:to:cc:subject:message-id;
  bh=ltHcpc7JjYvXvXu5OLMIT5CZsD+euIovM/tZV3bfbpw=;
  b=SQUYcaAc5Yr6qAV57dGpTvc+xSauhTKceQhpKgeOUXiThro4zpH4gDnd
   SJMKHLhjMoKHzjw0cJpkkqlhXFAEdfp6tdQxeJoASbDdxR88Z2KvuYGMO
   VM5zn5g0jYgf+5XRBCUMNXyTtkAVBDi4ORqeJ7h4z23P9JUwIItHBIU9b
   cWnqi/bN5UWY5oZBBiqqKR3KmJoCS+of3I+nk9EUnd+NBNzc9mPhTsE9R
   c8x1KwDSfD3joenrVzYEIqQ/T85UOUBDOxEbaB2sxZqvrCfiT9SSaz3lH
   dw8CEy2w9DZnyqgrkPWi0DrbtXxVnwpu6oN4pZfYGJk5f+txQgaCq7AlT
   Q==;
X-CSE-ConnectionGUID: 40rPhqOkRkuy2dhe/bjIlQ==
X-CSE-MsgGUID: ONzknkneTN+IK42AnDpZlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1266253"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1266253"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 15:39:06 -0700
X-CSE-ConnectionGUID: Xhb3WcFpSeiGUCEx2UU4vA==
X-CSE-MsgGUID: o02NvLgzST6HOb0JHkfubw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3271281"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 20 Oct 2026 15:39:05 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xJIU2-00000000Ob4-1Xfn;
	Tue, 20 Oct 2026 22:39:02 +0000
Date: Wed, 21 Oct 2026 06:38:27 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 3d229ce89862b8e82d71a9e11d6f840ca272a6d6
Message-ID: <202610210624.L8z54cjt-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE6ECA0009
X-Stat-Signature: mywg19gu87up8i6fwin15sg6e5b857m4
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792535947-307722
X-HE-Meta: U2FsdGVkX18hFks/fEYQoSAW/+Q2WfBmAwyJuF9GVr8rPcpbyGxuqdjQNmv/HHlNzJZY1JlLP7kk8hEnRJG8sIy3YQ/D38pwkxP4cOHwuocqKxXIHLBelKlxxyui2O/jMQWK0aiir38cBhTmldn4X5R9g2x7q/EpUkepHX1wZb2EFxP+KvSWSIUaNRk61x8BmVb7QWQRddLGmDr5ovL96fzrowu7moeA7nu+4LOrJ/0+L8QBFL3FuzWDj1frkZpsokcJ8Fi+Gg9Tnhg+Ayh8kOODdSrmzYgl+CxNRkmqdyC/UhlLYgpaj9wxbUHAWRwRNCtcEkEsc2nKJmG/H0THjLkd4vtd9KrhVBR9sJ3s6GJy+mhUN7tXiaORXuyAhmrnaWi+O9G1elOA8OxDk4NqJK4lB8zNeG/4LiYFam3HjLUEpWtNrp61VFGhNVpvd7AnyhcK2usdNCzsSpjDdpVQTdZNbmcq0GpHtMVh5S/j2Iq82YcvX+ltqEK6qfmgDU6LIFSbQ8hIK70PY84ePIiCdmgeKFkmJRNNOTFJMqdyAYYeN0DRpWW6oZpoXE+WZB4foM+UtEF8fT9F3LUxpeKcJiuytDtRPyljovdzgww+xD6RPHrMpwUUbeCLWc0g1eWcUk+SlL8EGmHmmD3z+Q+ql2BLl5lMd+gTN4rBvW9CPr47v+PftnjnoJsXcFaNaTysxCFtGRvFXD/MetpprSrcD121XTOOqoZJT3FIVH7GyqexsQdIxuLcuzC5e+Xsr26Q9rXF4tnpdDwxB4N05g32u8BH7l1K5U0GO7fNipF+0SHheWnMmQ6SKTPmjzCJrIb0QUD5lOaoui9xQuqH1ZW6MsEABOL/z27VhbmMqN7204Lq44CZGXF8V8VJ2U6A5E3/QEtAB3XxT8RbLSiJy9CcEbEsOusQGye/5LboESZjAgeEpFuxhbMfdPn0qw0vYmivBvRxLidVakDfK+UvAN6
 EDtJPmSP
 eKvfOqkkLZJT5io52gJZgeLzldRH/r0sv+T1eLp/yhb1l07PAtSEuRmQVqHMwjzApfbQsVY3C9aeFpTXclVv+QifsDvQb9fEIrTi0M61YBOCV87vTzmmPpCGK0BPNTpK2sLUB942Hk0/5/jIi7mQX7myn8tnVj1rOfGNsAsOZUUznbBekBulO0JIkD9Upkv955xBKxlxR6TdZMBsiecprGZVc/IQ4RiYzXp0H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 3d229ce89862b8e82d71a9e11d6f840ca272a6d6  Add linux-next specific files for 20261019

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202610210232.uzFGXnjw-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202610210332.DDqYQv5K-lkp@intel.com

    arch/arm64/kvm/vgic/vgic-irs-v5.c:1016:15: warning: variable 'addr' set but not used [-Wunused-but-set-variable=]
    kernel/sched/ext/ext.c:5178:17: error: implicit declaration of function 'scx_reenq_wait_dispatching'; did you mean 'scx_wait_dispatching'? [-Wimplicit-function-declaration]

Unverified Error/Warning (likely false positive, kindly check if interested):

    fs/ext2/super.c:1040:7: warning: writing variable 's_mount_state' requires holding spinlock '_res->s_lock' exclusively [-Wthread-safety-precise]
    fs/ext2/super.c:1138:8: warning: writing variable 's_rsv_window_root' requires holding spinlock '_res->s_rsv_window_lock' exclusively [-Wthread-safety-precise]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-defconfig
|   `-- arch-arm64-kvm-vgic-vgic-irs-v5.c:warning:variable-addr-set-but-not-used
|-- sparc64-defconfig
|   |-- fs-ext2-super.c:warning:writing-variable-s_mount_state-requires-holding-spinlock-_res-s_lock-exclusively
|   `-- fs-ext2-super.c:warning:writing-variable-s_rsv_window_root-requires-holding-spinlock-_res-s_rsv_window_lock-exclusively
`-- x86_64-rhel-9.4-bpf
    `-- kernel-sched-ext-ext.c:error:implicit-declaration-of-function-scx_reenq_wait_dispatching

elapsed time: 1127m

configs tested: 246
configs skipped: 10

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261021    clang-17
arc                   randconfig-1000-20261021    gcc-16.2.0
arc                   randconfig-1001-20261021    clang-17
arc                   randconfig-1001-20261021    gcc-14.4.0
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                      am200epdkit_defconfig    clang-24
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                       footbridge_defconfig    clang-24
arm                         neponset_defconfig    gcc-16.2.0
arm                        netwinder_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261021    clang-17
arm                   randconfig-1000-20261021    clang-24
arm                   randconfig-1001-20261021    clang-17
arm                   randconfig-1002-20261021    clang-17
arm                   randconfig-1002-20261021    gcc-14.4.0
arm                   randconfig-1003-20261021    clang-17
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261021    clang-21
arm64                 randconfig-1000-20261021    clang-24
arm64                 randconfig-1001-20261021    clang-24
arm64                 randconfig-1001-20261021    gcc-13.5.0
arm64                 randconfig-1002-20261021    clang-24
arm64                 randconfig-1003-20261021    clang-24
arm64                 randconfig-1003-20261021    gcc-8.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261021    clang-24
csky                  randconfig-1000-20261021    gcc-16.2.0
csky                  randconfig-1001-20261021    clang-24
csky                  randconfig-1001-20261021    gcc-10.5.0
hexagon                           alldefconfig    clang-19
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    clang-24
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261021    clang-24
hexagon               randconfig-1001-20261021    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261020    clang-22
i386        buildonly-randconfig-1001-20261020    gcc-14
i386        buildonly-randconfig-1002-20261020    clang-22
i386        buildonly-randconfig-1003-20261020    clang-22
i386        buildonly-randconfig-1004-20261020    clang-22
i386        buildonly-randconfig-1005-20261020    clang-22
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261020    clang-22
i386                  randconfig-1001-20261020    clang-22
i386                  randconfig-1002-20261020    gcc-14
i386                  randconfig-1003-20261020    clang-22
i386                  randconfig-1004-20261020    clang-22
i386                  randconfig-1005-20261020    gcc-14
i386                  randconfig-1006-20261020    clang-22
i386                  randconfig-1007-20261020    gcc-14
i386                  randconfig-1008-20261020    gcc-14
i386                  randconfig-1009-20261020    clang-22
i386                  randconfig-1010-20261020    gcc-14
i386                  randconfig-1011-20261020    gcc-14
i386                  randconfig-1012-20261020    clang-22
i386                  randconfig-1013-20261020    gcc-12
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261021    clang-24
loongarch             randconfig-1000-20261021    gcc-15.3.0
loongarch             randconfig-1001-20261021    clang-21
loongarch             randconfig-1001-20261021    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.2.0
m68k                         m5272c3_defconfig    gcc-16.2.0
m68k                        m5275evb_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.2.0
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                            ip30_defconfig    gcc-16.2.0
mips                       loongson3_defconfig    clang-24
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261021    clang-24
nios2                 randconfig-1000-20261021    gcc-11.5.0
nios2                 randconfig-1001-20261021    clang-24
nios2                 randconfig-1001-20261021    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                 generic-64bit_defconfig    clang-24
parisc                randconfig-1000-20261020    gcc-15.3.0
parisc                randconfig-1000-20261021    gcc-10.5.0
parisc                randconfig-1001-20261020    gcc-13.5.0
parisc                randconfig-1001-20261021    gcc-10.5.0
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc                        holly_defconfig    clang-24
powerpc                       pmac32_defconfig    clang-24
powerpc               randconfig-1000-20261020    gcc-16.2.0
powerpc               randconfig-1000-20261021    gcc-10.5.0
powerpc               randconfig-1001-20261020    clang-24
powerpc               randconfig-1001-20261021    gcc-10.5.0
powerpc                      tqm8540_defconfig    clang-24
powerpc64             randconfig-1000-20261020    gcc-8.5.0
powerpc64             randconfig-1000-20261021    gcc-10.5.0
powerpc64             randconfig-1001-20261020    clang-17
powerpc64             randconfig-1001-20261021    gcc-10.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261020    gcc-11.5.0
riscv                 randconfig-1000-20261020    gcc-12.5.0
riscv                 randconfig-1001-20261020    gcc-11.5.0
riscv                 randconfig-1001-20261020    gcc-8.5.0
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261020    clang-24
s390                  randconfig-1000-20261020    gcc-11.5.0
s390                  randconfig-1001-20261020    gcc-10.5.0
s390                  randconfig-1001-20261020    gcc-11.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.2.0
sh                             migor_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261020    gcc-11.5.0
sh                    randconfig-1000-20261020    gcc-16.2.0
sh                    randconfig-1001-20261020    gcc-11.5.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261020    gcc-16.2.0
sparc                 randconfig-1000-20261021    clang-24
sparc                 randconfig-1001-20261020    gcc-8.5.0
sparc                 randconfig-1001-20261021    clang-24
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261020    clang-20
sparc64               randconfig-1000-20261021    clang-24
sparc64               randconfig-1001-20261020    clang-24
sparc64               randconfig-1001-20261021    clang-24
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261020    clang-17
um                    randconfig-1000-20261021    clang-24
um                    randconfig-1001-20261020    clang-20
um                    randconfig-1001-20261021    clang-24
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261021    gcc-14
x86_64      buildonly-randconfig-1001-20261021    gcc-12
x86_64      buildonly-randconfig-1002-20261021    gcc-14
x86_64      buildonly-randconfig-1003-20261021    gcc-14
x86_64      buildonly-randconfig-1004-20261021    clang-22
x86_64      buildonly-randconfig-1005-20261021    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261020    clang-22
x86_64                randconfig-1001-20261020    clang-22
x86_64                randconfig-1002-20261020    clang-22
x86_64                randconfig-1003-20261020    gcc-14
x86_64                randconfig-1004-20261020    clang-22
x86_64                randconfig-1005-20261020    clang-22
x86_64                randconfig-1006-20261020    gcc-14
x86_64                randconfig-1007-20261020    gcc-14
x86_64                randconfig-1008-20261020    clang-22
x86_64                randconfig-1009-20261020    clang-22
x86_64                randconfig-1010-20261020    gcc-14
x86_64                randconfig-1011-20261020    clang-22
x86_64                randconfig-1012-20261020    clang-22
x86_64                randconfig-1012-20261021    gcc-14
x86_64                randconfig-1013-20261020    clang-22
x86_64                randconfig-1013-20261021    gcc-13
x86_64                randconfig-1014-20261020    clang-22
x86_64                randconfig-1014-20261021    clang-22
x86_64                randconfig-1015-20261020    clang-22
x86_64                randconfig-1015-20261021    gcc-14
x86_64                randconfig-1016-20261020    clang-22
x86_64                randconfig-1016-20261021    clang-22
x86_64                randconfig-1017-20261020    clang-22
x86_64                randconfig-1017-20261021    clang-22
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.2.0
xtensa                randconfig-1000-20261020    gcc-15.3.0
xtensa                randconfig-1000-20261021    clang-24
xtensa                randconfig-1001-20261020    gcc-9.5.0
xtensa                randconfig-1001-20261021    clang-24

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

