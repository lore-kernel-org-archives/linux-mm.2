Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E025FC88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 02:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89746B0088; Fri, 11 Sep 2026 22:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39B06B008C; Fri, 11 Sep 2026 22:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928FE6B0092; Fri, 11 Sep 2026 22:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA976B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 22:19:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9E721203D9
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 02:19:44 +0000 (UTC)
X-FDA: 85203504288.06.A287024
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3929C100006
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 02:19:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OBd8l2FB;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789179583;
	b=okV5N5QGptJwsjmawDnaublBEk1lYIaAQuIW4ue8zAqUcK+7mZbKQglyDMKEeADrLX7aqv
	XuA63AnKvZ2pvace2o4197TYps5oH2O1kMTEUc+Hj2DSYBueeIJXRufF915k9EX/fa2f5R
	ym7bNJMj6Zj27jCnv6gY0swL4soOZAI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OBd8l2FB;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789179583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=lvQfbnA0U+HgOE16eBb+QEpnhuneh8U3+CmUL0X/rGU=;
	b=dzmViGc1NRybTC5ZbauHFYiLRl5NDp7uVirfQ2cNvRdzYxjTE26qSpcXmFS+Tn3pFRurov
	4U+9tNFVWBpwY5XerDq4Umqd15fN/uXj4co5x9eWi0Ieklv+5sAfb8ipFjlmh+f/AcrjlB
	0yvBoM/K66loHF2Xe6mugtPECwq66po=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789179583; x=1820715583;
  h=date:from:to:cc:subject:message-id;
  bh=LiJken9/pwZZa51p+cltrvgUrPEgP3WHempRNDm1zMM=;
  b=OBd8l2FBg+ohw68etA0hgkTv+tMEFFfGVHhmurGlxd4cVk+WBq5024Js
   E/j0u1ut3D3ror0QVNiNB9pZim+wQr2Wf7JrTl/qIcDGW+hR+2zE4GVZo
   891eWw4076rPySRMlrEIKpFsVkgfOTjiKQ36PZOzRUt6q8uzuXxlcjPcx
   X9PiOkMdKgwFFOeHvcjlIH0QSO+0mHgch6DRWKD2yjqbEQqHkC2Qaw3Uh
   rtKTG5b5/hi7ZYkM6oui7vLf0KH829zjAawOFph4X84+XUvgI/jIApt2+
   +0yzfKtE46PXcdQLdTjUcFuXKPQXyTwmK2NTfRXN4q5sVO0WhtAAg2G/n
   A==;
X-CSE-ConnectionGUID: ljKPx1E5SDeezTgH/QZz+Q==
X-CSE-MsgGUID: z0Vr82llRCykWu00z0m7Tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="89669559"
X-IronPort-AV: E=Sophos;i="6.27,98,1787036400"; 
   d="scan'208";a="89669559"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 19:19:41 -0700
X-CSE-ConnectionGUID: jTCI2VWbSDyEukFfNzrKNQ==
X-CSE-MsgGUID: QQ3ZQvTXSu+LPDSSqOPVMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,98,1787036400"; 
   d="scan'208";a="267793787"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 11 Sep 2026 19:19:39 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x5DL1-000000002Xb-31uN;
	Sat, 12 Sep 2026 02:19:32 +0000
Date: Sat, 12 Sep 2026 10:18:44 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 9958290885035431e2494159f555e332c3c14906
Message-ID: <202609121040.A6J2UgCw-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3929C100006
X-Stat-Signature: wy71dnndyrpuhmg7np7in1d98df48nok
X-Rspam-User: 
X-HE-Tag: 1789179582-840036
X-HE-Meta: U2FsdGVkX19y3X9iKYy94k5/64mNCKhvUhkyH477XAa3GmEbXJlovCH3uVix8HLVtXJTi6ydxGOsdIqpJEObMVuKll8a4HIBTF2D6yN0Vf2HjqpDB+KpnOZ19WA6mzT7Rp6tmyIxjMbVUx+idJSQHnx+WW8q20IT474ho8Jz+NfgP/0xEfjjknnIXY+woUQJU2F9ZBJRS31lt0CHv34FQWnTAUuotTNrzuZbT79IAWugWbF4nXO9rZMZkWMDXFWFY2R+lzo7utEemhwbGMMDgo4vOVFOVHDbO5+3Yz3932YR3t3trT9baG8hPQPY7o4Ow6aRh4o0ucZLhq2aesgvAJhHr9nIDJCQJChICPGA++IY99+NFFRnmwJnD+QwppA6Yh65Iv72NlLblBsTo5bcC2dN1UoPmTtC4SbbwUEuh86KTN+5V/H1yPuKfNyTiDL53NjjOMggAj99BT3uOWVo25+Vp3TnXxF4lJpb8nU1JReNRdqMR0eB9nnq45bLcT1etSFZ+LegTGYzyVxbH7ro+pZsCKHgxVjHii5Zkd/OASuJBB254wzavXeC7PMYqX7jPa8YUMGqMWiMTQSldBAb6PTbd9DaDbP18rGZCZxFieaCNNePLZKucc00TJf/6GuGyz+VHy3QClH6dQReMEElE0wEQr7XSSMFbUqnwpW0oN7nk91MlNZUUYqlTUZpTNhj7r0SgjI3A+Q60qhpo15VsgBPpMiWtbp2H83QGeUamMyBlUexOfHoN6bqaDDt2VVwicVewEp/Lj+0OdjnivrzH9KtIoYkVNTTDT5LAKPuLXWi6kBoUNJ5qHC8RpNslhsEK9WzCWLZ9xLLSWte8LG3UXJPwhz2LXS9XorfgxbkLQ/0gTBJDAzziFcAWmdsBYL8k9uvIXBFUX9d6RfrS9v21QndxZP3tXH5eW4qE8lQ0s9Fbs9ZUanS55YCLRftkIO931Vk1oZEZy2JdG0ua8e
 pW00c8E2
 /fXvSFs32ZpJo6lVmTyLCb7hC7y/+XPZ38IlUomOwDcVNoBmoej1PIllh1jyZcVjIBDn+QMLDCI76n3PP3LOVif7IV2mygE7o16n5SBmr6UMCtkRTHUV3IXEYD5RC917S3pKZNmYF3irpmti9PAzl/aiC6676V9QtPucnucbiG7my8FS9jydm8d/EAMGObQIasdNi5PTv8QtHk5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 9958290885035431e2494159f555e332c3c14906  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 1340m

configs tested: 329
configs skipped: 10

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-24
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-24
arc                              allyesconfig    gcc-16.1.0
arc                          axs101_defconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260911    gcc-12.5.0
arc                   randconfig-001-20260912    clang-17
arc                   randconfig-002-20260911    gcc-8.5.0
arc                   randconfig-002-20260912    clang-17
arc                    vdk_hs38_smp_defconfig    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-24
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260911    clang-24
arm                   randconfig-001-20260912    clang-17
arm                   randconfig-002-20260911    gcc-12.5.0
arm                   randconfig-002-20260912    clang-17
arm                   randconfig-003-20260911    gcc-10.5.0
arm                   randconfig-003-20260912    clang-17
arm                   randconfig-004-20260911    clang-24
arm                   randconfig-004-20260912    clang-17
arm                        vexpress_defconfig    gcc-16.1.0
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260911    clang-24
arm64                 randconfig-001-20260911    gcc-16.1.0
arm64                 randconfig-001-20260912    gcc-15.2.0
arm64                 randconfig-002-20260911    clang-24
arm64                 randconfig-002-20260911    gcc-16.1.0
arm64                 randconfig-002-20260912    gcc-15.2.0
arm64                 randconfig-003-20260911    clang-24
arm64                 randconfig-003-20260911    gcc-16.1.0
arm64                 randconfig-003-20260912    gcc-15.2.0
arm64                 randconfig-004-20260911    clang-24
arm64                 randconfig-004-20260911    gcc-16.1.0
arm64                 randconfig-004-20260912    gcc-15.2.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260911    gcc-16.1.0
csky                  randconfig-001-20260912    gcc-15.2.0
csky                  randconfig-002-20260911    gcc-16.1.0
csky                  randconfig-002-20260912    gcc-15.2.0
hexagon                          allmodconfig    clang-24
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-24
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-24
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260911    clang-17
hexagon               randconfig-001-20260912    clang-24
hexagon               randconfig-002-20260911    clang-20
hexagon               randconfig-002-20260912    clang-24
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260911    clang-22
i386        buildonly-randconfig-001-20260912    gcc-14
i386        buildonly-randconfig-002-20260911    gcc-14
i386        buildonly-randconfig-002-20260912    gcc-14
i386        buildonly-randconfig-003-20260911    gcc-14
i386        buildonly-randconfig-003-20260912    gcc-14
i386        buildonly-randconfig-004-20260911    clang-22
i386        buildonly-randconfig-004-20260912    gcc-14
i386        buildonly-randconfig-005-20260911    clang-22
i386        buildonly-randconfig-005-20260912    gcc-14
i386        buildonly-randconfig-006-20260911    gcc-14
i386        buildonly-randconfig-006-20260912    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260911    gcc-13
i386                  randconfig-001-20260912    gcc-14
i386                  randconfig-002-20260911    clang-22
i386                  randconfig-002-20260912    gcc-14
i386                  randconfig-003-20260911    gcc-14
i386                  randconfig-003-20260912    gcc-14
i386                  randconfig-004-20260911    clang-22
i386                  randconfig-004-20260912    gcc-14
i386                  randconfig-005-20260911    clang-22
i386                  randconfig-005-20260912    gcc-14
i386                  randconfig-006-20260911    clang-22
i386                  randconfig-006-20260912    gcc-14
i386                  randconfig-007-20260911    clang-22
i386                  randconfig-007-20260912    gcc-14
i386                  randconfig-011-20260911    clang-22
i386                  randconfig-011-20260911    gcc-14
i386                  randconfig-011-20260912    gcc-14
i386                  randconfig-012-20260911    clang-22
i386                  randconfig-012-20260911    gcc-14
i386                  randconfig-012-20260912    gcc-14
i386                  randconfig-013-20260911    clang-22
i386                  randconfig-013-20260912    gcc-14
i386                  randconfig-014-20260911    clang-22
i386                  randconfig-014-20260911    gcc-14
i386                  randconfig-014-20260912    gcc-14
i386                  randconfig-015-20260911    clang-22
i386                  randconfig-015-20260911    gcc-14
i386                  randconfig-015-20260912    gcc-14
i386                  randconfig-016-20260911    clang-22
i386                  randconfig-016-20260911    gcc-14
i386                  randconfig-016-20260912    gcc-14
i386                  randconfig-017-20260911    clang-22
i386                  randconfig-017-20260911    gcc-14
i386                  randconfig-017-20260912    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260911    gcc-12.5.0
loongarch             randconfig-001-20260912    clang-24
loongarch             randconfig-002-20260911    clang-22
loongarch             randconfig-002-20260912    clang-24
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-24
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-24
m68k                                defconfig    gcc-16.1.0
m68k                       m5235evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-24
microblaze                          defconfig    gcc-16.1.0
microblaze                      mmu_defconfig    clang-24
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                     decstation_defconfig    clang-24
mips                     decstation_defconfig    gcc-16.1.0
mips                          eyeq6_defconfig    clang-24
mips                      fuloong2e_defconfig    gcc-16.1.0
mips                           gcw0_defconfig    clang-24
mips                           jazz_defconfig    clang-24
mips                           mtx1_defconfig    clang-19
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-24
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-24
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260911    gcc-11.5.0
nios2                 randconfig-001-20260912    clang-24
nios2                 randconfig-002-20260911    gcc-11.5.0
nios2                 randconfig-002-20260912    clang-24
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-24
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-24
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260911    gcc-13.4.0
parisc                randconfig-001-20260912    clang-24
parisc                randconfig-002-20260911    gcc-11.5.0
parisc                randconfig-002-20260912    clang-24
parisc64                         alldefconfig    gcc-16.1.0
parisc64                            defconfig    clang-24
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-24
powerpc                           allnoconfig    gcc-16.1.0
powerpc                    amigaone_defconfig    gcc-16.1.0
powerpc                       ebony_defconfig    clang-24
powerpc                        icon_defconfig    clang-24
powerpc                   lite5200b_defconfig    gcc-16.1.0
powerpc                     mpc5200_defconfig    clang-24
powerpc                     rainier_defconfig    clang-24
powerpc               randconfig-001-20260911    clang-21
powerpc               randconfig-001-20260912    clang-24
powerpc               randconfig-002-20260911    clang-24
powerpc               randconfig-002-20260912    clang-24
powerpc                  storcenter_defconfig    gcc-16.1.0
powerpc                      tqm8xx_defconfig    clang-20
powerpc64             randconfig-001-20260911    gcc-8.5.0
powerpc64             randconfig-001-20260912    clang-24
powerpc64             randconfig-002-20260911    clang-24
powerpc64             randconfig-002-20260912    clang-24
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260911    clang-24
riscv                 randconfig-001-20260912    gcc-11.5.0
riscv                 randconfig-002-20260911    clang-24
riscv                 randconfig-002-20260912    gcc-11.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260911    gcc-13.4.0
s390                  randconfig-001-20260912    gcc-11.5.0
s390                  randconfig-002-20260911    gcc-15.2.0
s390                  randconfig-002-20260912    gcc-11.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-24
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260911    gcc-14.3.0
sh                    randconfig-001-20260912    gcc-11.5.0
sh                    randconfig-002-20260911    gcc-16.1.0
sh                    randconfig-002-20260912    gcc-11.5.0
sh                           se7206_defconfig    gcc-16.1.0
sh                           se7705_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-24
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260911    gcc-13.4.0
sparc                 randconfig-001-20260911    gcc-8.5.0
sparc                 randconfig-001-20260912    gcc-14.3.0
sparc                 randconfig-002-20260911    gcc-13.4.0
sparc                 randconfig-002-20260912    gcc-14.3.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260911    clang-21
sparc64               randconfig-001-20260911    gcc-13.4.0
sparc64               randconfig-001-20260912    gcc-14.3.0
sparc64               randconfig-002-20260911    gcc-13.4.0
sparc64               randconfig-002-20260911    gcc-9.5.0
sparc64               randconfig-002-20260912    gcc-14.3.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-24
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260911    gcc-13.4.0
um                    randconfig-001-20260911    gcc-14
um                    randconfig-001-20260912    gcc-14.3.0
um                    randconfig-002-20260911    clang-24
um                    randconfig-002-20260911    gcc-13.4.0
um                    randconfig-002-20260912    gcc-14.3.0
um                           x86_64_defconfig    clang-24
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260911    clang-22
x86_64      buildonly-randconfig-001-20260911    gcc-14
x86_64      buildonly-randconfig-001-20260912    gcc-14
x86_64      buildonly-randconfig-002-20260911    gcc-14
x86_64      buildonly-randconfig-002-20260912    gcc-14
x86_64      buildonly-randconfig-003-20260911    clang-22
x86_64      buildonly-randconfig-003-20260911    gcc-14
x86_64      buildonly-randconfig-003-20260912    gcc-14
x86_64      buildonly-randconfig-004-20260911    gcc-14
x86_64      buildonly-randconfig-004-20260912    gcc-14
x86_64      buildonly-randconfig-005-20260911    clang-22
x86_64      buildonly-randconfig-005-20260911    gcc-14
x86_64      buildonly-randconfig-005-20260912    gcc-14
x86_64      buildonly-randconfig-006-20260911    gcc-14
x86_64      buildonly-randconfig-006-20260912    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260911    clang-22
x86_64                randconfig-002-20260911    clang-22
x86_64                randconfig-002-20260911    gcc-12
x86_64                randconfig-003-20260911    clang-22
x86_64                randconfig-004-20260911    clang-22
x86_64                randconfig-005-20260911    clang-22
x86_64                randconfig-005-20260911    gcc-14
x86_64                randconfig-006-20260911    clang-22
x86_64                randconfig-006-20260911    gcc-14
x86_64                randconfig-011-20260911    gcc-14
x86_64                randconfig-012-20260911    gcc-14
x86_64                randconfig-013-20260911    clang-22
x86_64                randconfig-013-20260911    gcc-14
x86_64                randconfig-014-20260911    clang-22
x86_64                randconfig-014-20260911    gcc-14
x86_64                randconfig-015-20260911    clang-22
x86_64                randconfig-015-20260911    gcc-14
x86_64                randconfig-016-20260911    clang-22
x86_64                randconfig-016-20260911    gcc-14
x86_64                randconfig-071-20260911    clang-22
x86_64                randconfig-071-20260912    gcc-14
x86_64                randconfig-072-20260911    gcc-14
x86_64                randconfig-072-20260912    gcc-14
x86_64                randconfig-073-20260911    gcc-14
x86_64                randconfig-073-20260912    gcc-14
x86_64                randconfig-074-20260911    clang-22
x86_64                randconfig-074-20260912    gcc-14
x86_64                randconfig-075-20260911    clang-22
x86_64                randconfig-075-20260912    gcc-14
x86_64                randconfig-076-20260911    clang-22
x86_64                randconfig-076-20260912    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-24
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260911    gcc-13.4.0
xtensa                randconfig-001-20260911    gcc-8.5.0
xtensa                randconfig-001-20260912    gcc-14.3.0
xtensa                randconfig-002-20260911    gcc-13.4.0
xtensa                randconfig-002-20260911    gcc-9.5.0
xtensa                randconfig-002-20260912    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

