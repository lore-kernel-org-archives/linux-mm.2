Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E39BACA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 05:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F309000EF; Thu, 14 Aug 2025 01:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EEF900088; Thu, 14 Aug 2025 01:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C619000EF; Thu, 14 Aug 2025 01:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63D20900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 01:11:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D9C7BA138
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:11:51 +0000 (UTC)
X-FDA: 83774190822.07.EE6EE77
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf20.hostedemail.com (Postfix) with ESMTP id 80E451C0007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:11:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=myKgaBMj;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755148309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=rr5jPD+fE9/tNTE+beomB+4nEdYLQYvGTMbeywa/Ajg=;
	b=IldpmXWuZ5PxiQWgYFYBhN3pHUEWubWHmbCrXL41KhKNrqwA65gjjSc5l4dsokXa8sSt6Q
	IFTZNt8CeQYQiXNmhctahpWeQmA6yRunl1ebKucZUBLRHKClI0+PclFRheSOL6DlUCIfhP
	7Fa7MRPPpgUBUoFUMdWBkrKgN13lbrE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=myKgaBMj;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755148309; a=rsa-sha256;
	cv=none;
	b=BYUKJeNpZK10juROaJrxyDtRD7x3Vv2mcRABHQWS3ZvKJM7r3F+dOrZUvYpaPlS+WcxVf2
	+yJSPuTls5RsoHFwy/dDFTT9V880AQVaGAWLHO2IQznd/Qxbx7kqsRdbVz1q9nEtuumviq
	tOCOJNz3JDRqiNpQPpgLmdb4O/hyjww=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755148309; x=1786684309;
  h=date:from:to:cc:subject:message-id;
  bh=SzMs3cND0DkZNh4D/VFjVYC/yAx95ueUOWSxYp8Zt1k=;
  b=myKgaBMjiCx+bYzkjBgZRfFXRdyrRmt3mdu8wG+YoUHGTFTRiDbfeD4A
   eoH6fMioRPI6edsbZPweTpK5jWVfxdYqEv70dvNXRDI9IyGvibx2ulZAQ
   njYZDOGNXTbBXe9udWw1d1nShui6m1tOPKoXsLwpuzs4Y0kKFZcnmCobd
   mWIdt+muPq0KqyiERoqEumH+AR7VUGqmU7uuOXrH2F8B2oYhH4UJMpD4D
   sFDhYalEXKJoAWIdPS1fGB1qIko80WlUfkYl9nPw4VzntO69tuCLIcjZz
   kQE9vru9/+8GYty0Rs+yt0zcAeQ17M4Ny6btO1wJUmFcatd4VDIGmqwEU
   A==;
X-CSE-ConnectionGUID: SIQHzew7TOyYBoHkG/QFjQ==
X-CSE-MsgGUID: Bi5WkNRTTZyiVSoDrFu3oQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="80032781"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="80032781"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 22:11:47 -0700
X-CSE-ConnectionGUID: YmusblsCRJ2PDvUATBF/pg==
X-CSE-MsgGUID: ArmBztMoRF6GJOJ9cC/xjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166156352"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 13 Aug 2025 22:11:46 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umQFc-000AbM-01;
	Thu, 14 Aug 2025 05:11:44 +0000
Date: Thu, 14 Aug 2025 13:11:13 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 d045c3154080a04beb07726fa311b89d21608981
Message-ID: <202508141304.0TcgZEMG-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Stat-Signature: o5e7nx1q9dsjajz59qeu5hp6ggsuwn9f
X-Rspam-User: 
X-Rspamd-Queue-Id: 80E451C0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755148308-611804
X-HE-Meta: U2FsdGVkX1/k6ZTI93eMoaZKmkQ2271GqwYWzkx8dh4VTIBir3raVbDRdXSIHGqULv1GWd43oCmWgd4b5Nwf3JDe1w5ry6NNMlNgS5eLaKl0WazI36oRD6wCYZroBJ7WP/FSNI/BPbLrSBoghXCHQR/W4LiYZpOTZ2lbPTj6TapGV6nhv2O7rLerJDId5FPyNuJVFL4CPGko7J0mV6ImOerX7wI6gTJ2cjU70+hu3eWvWoLhuYdqv/xxD/jRmWmv7UNbgPdJGpAH6m4rUkz7Hor4SCcvsIe1UZ6Db2WqSkptySsm7KOXzNn1o1y3duSmDmYrRRZr3D0BTpWY3uytgRzZt3/sXjm+OnoGzPhDikqMDGWjMJbWJNEgnXzXwhPaNKK4/pj+9tdjEQoDBDpt6OyAbyUP4PTBsv3+5RUSr2DRarO2k7gXpxquLAg6GS+ZkTlkBTqr7cS32y6jsdQDz7fmuWXjDWiKriLvIkM+VopEljXYI+nVesqo78qxZu/OcV23yQTxN4kfooZgrbrrsjnD8Qd58GCKV7J72A1LsFONzGLAaMwRMQzlZ+3s8Em+rdSllVfi3vg8r4kNx/w1121XrxdFhH6ZolqHbwgl3db7yX+KEgrMAhxopv+N1ceV43CVkpsDmoo3+W0qE/wwTj5cC+vKzyHhh84J48lWmbyCw17T+Eg3w5ArT6iPYdkP7mcSTCS1R2U73rySFy4dAcTuoJc4kONgOwhy+MmqQ9zhCiiBMLXPKEIh7r1KBMyDTRYxCYW028fbOBy1DvRbBPLW63A5wLgX13AzAVTVbw7X4Zpv4WAfYOBBt2olHBxl9B/nHGosC5wOBuh6V6Q20/gx981iQ1Aht9tflU6VJFXMHNL3wX57A6mGdqvBVJ7NYvctew7bLcAOYbb1oUHc4zOCcurmLk/6Djstp5z3ErBMqSZtoN5ig4rfbFYNhBSZvB8COQt1i5vXZB22Mkw
 dLF2msgA
 AVSAOHTH97jXrDdZtbzvETH4AWlhJbVNTBeiwKPoFhjeQQeat2cPUHejWbwBYgvgDDYGojPCsok5Q3aRxS2EsnVnXrOfzhdR6z7lEMIk7wxz4e4xlGF3mqN0eF3W8ZIjRrH6v7hre8dbjBMIOtsDW7Wf1EmfjIPd1qmgt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: d045c3154080a04beb07726fa311b89d21608981  mm/numa_memblks: Use pr_debug instead of printk(KERN_DEBUG)

elapsed time: 1222m

configs tested: 253
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    clang-22
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    clang-19
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    clang-19
arc                              alldefconfig    clang-22
arc                              allmodconfig    clang-19
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    clang-22
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-19
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    clang-19
arc                        nsimosci_defconfig    clang-22
arc                   randconfig-001-20250813    gcc-11.5.0
arc                   randconfig-001-20250814    gcc-10.5.0
arc                   randconfig-002-20250813    gcc-8.5.0
arc                   randconfig-002-20250814    gcc-10.5.0
arc                           tb10x_defconfig    clang-22
arm                              allmodconfig    clang-19
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    clang-19
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-19
arm                       multi_v4t_defconfig    clang-22
arm                        mvebu_v7_defconfig    clang-22
arm                   randconfig-001-20250813    clang-22
arm                   randconfig-001-20250814    gcc-10.5.0
arm                   randconfig-002-20250813    gcc-8.5.0
arm                   randconfig-002-20250814    gcc-10.5.0
arm                   randconfig-003-20250813    clang-22
arm                   randconfig-003-20250814    gcc-10.5.0
arm                   randconfig-004-20250813    gcc-8.5.0
arm                   randconfig-004-20250814    gcc-10.5.0
arm                         s3c6400_defconfig    clang-22
arm                        spear3xx_defconfig    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    clang-22
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    clang-19
arm64                 randconfig-001-20250813    clang-22
arm64                 randconfig-001-20250814    gcc-10.5.0
arm64                 randconfig-002-20250813    gcc-12.5.0
arm64                 randconfig-002-20250814    gcc-10.5.0
arm64                 randconfig-003-20250813    clang-22
arm64                 randconfig-003-20250814    gcc-10.5.0
arm64                 randconfig-004-20250813    clang-22
arm64                 randconfig-004-20250814    gcc-10.5.0
csky                              allnoconfig    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    clang-19
csky                  randconfig-001-20250813    gcc-14.3.0
csky                  randconfig-001-20250814    gcc-10.5.0
csky                  randconfig-002-20250813    gcc-13.4.0
csky                  randconfig-002-20250814    gcc-10.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    clang-19
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-19
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-19
hexagon               randconfig-001-20250813    clang-22
hexagon               randconfig-001-20250814    gcc-10.5.0
hexagon               randconfig-002-20250813    clang-22
hexagon               randconfig-002-20250814    gcc-10.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-12
i386                              allnoconfig    clang-20
i386                              allnoconfig    gcc-12
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250813    gcc-11
i386        buildonly-randconfig-001-20250814    clang-20
i386        buildonly-randconfig-002-20250813    clang-20
i386        buildonly-randconfig-002-20250814    clang-20
i386        buildonly-randconfig-003-20250813    gcc-11
i386        buildonly-randconfig-003-20250814    clang-20
i386        buildonly-randconfig-004-20250813    clang-20
i386        buildonly-randconfig-004-20250814    clang-20
i386        buildonly-randconfig-005-20250813    gcc-12
i386        buildonly-randconfig-005-20250814    clang-20
i386        buildonly-randconfig-006-20250813    gcc-12
i386        buildonly-randconfig-006-20250814    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20250814    clang-20
i386                  randconfig-002-20250814    clang-20
i386                  randconfig-003-20250814    clang-20
i386                  randconfig-004-20250814    clang-20
i386                  randconfig-005-20250814    clang-20
i386                  randconfig-006-20250814    clang-20
i386                  randconfig-007-20250814    clang-20
i386                  randconfig-011-20250814    gcc-12
i386                  randconfig-012-20250814    gcc-12
i386                  randconfig-013-20250814    gcc-12
i386                  randconfig-014-20250814    gcc-12
i386                  randconfig-015-20250814    gcc-12
i386                  randconfig-016-20250814    gcc-12
i386                  randconfig-017-20250814    gcc-12
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250813    clang-19
loongarch             randconfig-001-20250814    gcc-10.5.0
loongarch             randconfig-002-20250813    gcc-15.1.0
loongarch             randconfig-002-20250814    gcc-10.5.0
m68k                             allmodconfig    clang-19
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-19
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    clang-19
microblaze                       allmodconfig    clang-19
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    clang-19
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-15.1.0
nios2                               defconfig    gcc-15.1.0
nios2                 randconfig-001-20250813    gcc-11.5.0
nios2                 randconfig-001-20250814    gcc-10.5.0
nios2                 randconfig-002-20250813    gcc-8.5.0
nios2                 randconfig-002-20250814    gcc-10.5.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-12
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250813    gcc-14.3.0
parisc                randconfig-001-20250814    gcc-10.5.0
parisc                randconfig-002-20250813    gcc-8.5.0
parisc                randconfig-002-20250814    gcc-10.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                          allyesconfig    gcc-15.1.0
powerpc                      ppc44x_defconfig    clang-22
powerpc               randconfig-001-20250813    clang-18
powerpc               randconfig-001-20250814    gcc-10.5.0
powerpc               randconfig-002-20250813    clang-22
powerpc               randconfig-002-20250814    gcc-10.5.0
powerpc               randconfig-003-20250813    clang-20
powerpc               randconfig-003-20250814    gcc-10.5.0
powerpc64             randconfig-001-20250813    clang-22
powerpc64             randconfig-001-20250814    gcc-10.5.0
powerpc64             randconfig-002-20250813    gcc-8.5.0
powerpc64             randconfig-002-20250814    gcc-10.5.0
powerpc64             randconfig-003-20250813    clang-17
powerpc64             randconfig-003-20250814    gcc-10.5.0
riscv                            allmodconfig    clang-22
riscv                            allmodconfig    gcc-15.1.0
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                            allyesconfig    gcc-15.1.0
riscv                               defconfig    gcc-12
riscv                 randconfig-001-20250813    clang-22
riscv                 randconfig-001-20250814    clang-22
riscv                 randconfig-002-20250813    gcc-14.3.0
riscv                 randconfig-002-20250814    clang-22
s390                             allmodconfig    clang-18
s390                             allmodconfig    gcc-15.1.0
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    gcc-12
s390                  randconfig-001-20250813    clang-22
s390                  randconfig-001-20250814    clang-22
s390                  randconfig-002-20250813    clang-18
s390                  randconfig-002-20250814    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-12
sh                    randconfig-001-20250813    gcc-9.5.0
sh                    randconfig-001-20250814    clang-22
sh                    randconfig-002-20250813    gcc-9.5.0
sh                    randconfig-002-20250814    clang-22
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250813    gcc-8.5.0
sparc                 randconfig-001-20250814    clang-22
sparc                 randconfig-002-20250813    gcc-15.1.0
sparc                 randconfig-002-20250814    clang-22
sparc64                             defconfig    gcc-12
sparc64               randconfig-001-20250813    gcc-8.5.0
sparc64               randconfig-001-20250814    clang-22
sparc64               randconfig-002-20250813    clang-20
sparc64               randconfig-002-20250814    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    clang-19
um                               allyesconfig    gcc-12
um                                  defconfig    gcc-12
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250813    gcc-12
um                    randconfig-001-20250814    clang-22
um                    randconfig-002-20250813    gcc-11
um                    randconfig-002-20250814    clang-22
um                           x86_64_defconfig    gcc-12
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250813    gcc-12
x86_64      buildonly-randconfig-001-20250814    clang-20
x86_64      buildonly-randconfig-002-20250813    clang-20
x86_64      buildonly-randconfig-002-20250814    clang-20
x86_64      buildonly-randconfig-003-20250813    gcc-12
x86_64      buildonly-randconfig-003-20250814    clang-20
x86_64      buildonly-randconfig-004-20250813    clang-20
x86_64      buildonly-randconfig-004-20250814    clang-20
x86_64      buildonly-randconfig-005-20250813    clang-20
x86_64      buildonly-randconfig-005-20250814    clang-20
x86_64      buildonly-randconfig-006-20250813    gcc-12
x86_64      buildonly-randconfig-006-20250814    clang-20
x86_64                              defconfig    clang-20
x86_64                              defconfig    gcc-11
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20250814    clang-20
x86_64                randconfig-002-20250814    clang-20
x86_64                randconfig-003-20250814    clang-20
x86_64                randconfig-004-20250814    clang-20
x86_64                randconfig-005-20250814    clang-20
x86_64                randconfig-006-20250814    clang-20
x86_64                randconfig-007-20250814    clang-20
x86_64                randconfig-008-20250814    clang-20
x86_64                randconfig-071-20250814    gcc-12
x86_64                randconfig-072-20250814    gcc-12
x86_64                randconfig-073-20250814    gcc-12
x86_64                randconfig-074-20250814    gcc-12
x86_64                randconfig-075-20250814    gcc-12
x86_64                randconfig-076-20250814    gcc-12
x86_64                randconfig-077-20250814    gcc-12
x86_64                randconfig-078-20250814    gcc-12
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-12
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-12
x86_64                           rhel-9.4-ltp    gcc-12
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250813    gcc-10.5.0
xtensa                randconfig-001-20250814    clang-22
xtensa                randconfig-002-20250813    gcc-12.5.0
xtensa                randconfig-002-20250814    clang-22

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

