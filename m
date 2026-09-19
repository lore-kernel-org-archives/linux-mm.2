Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50DF9C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 14:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301DE6B0088; Sat, 19 Sep 2026 10:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1956B008A; Sat, 19 Sep 2026 10:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9116B008C; Sat, 19 Sep 2026 10:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7F356B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:46:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40D6380298
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:46:53 +0000 (UTC)
X-FDA: 85230788706.02.D158F0D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf24.hostedemail.com (Postfix) with ESMTP id 238B0180002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:46:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ELI+K1i+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789829211;
	b=3vMgvziLGBMed0skE2pEQ6XmbzuB+BRXhw6N5WUJg+EiMYy4Texg8ueVJE9YlqObvdPjzr
	iBn36PzipoRiNtxTOHraIODZdCDFrGdyohch4tuvxaF7eRP6HAyMALOgXgwHz7vMZ0YTiK
	v+avj10I1gLN9+PmDv0g6gUKgSRIvkw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ELI+K1i+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789829211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=I6MQvcfm0kCZaoT0WB+co0KwEKPXs2HeH+16u2DMETA=;
	b=0FId3azt/c+yac2/shQNicpyVbuz0mLYyAa/tJVdWX5uGUI7AAKBgiR2VoDzoCgnFLOFu7
	EpWUq7YHlfXeZb+BqqzQLSJiPAmY0xloOLGcA11eIYZrQMbIcHBPxPyTQqQPBI3VZuz0Ax
	sHkFEV/B9uIRYJ56UAmOSQHGFTjMxdY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789829210; x=1821365210;
  h=date:from:to:cc:subject:message-id;
  bh=bdviDNSc62StKYmd5Gp+BM2n8hRFMr7+Dls4R3Y11Gw=;
  b=ELI+K1i+Abti/M9CdwC+CnVuIEtr2dWbmmBjPti0xuO6fTTmlSNXb0xo
   xIpLaxDS2hM/kQ/fZq3ybGfy8UWDnMhS4GwkRfXPj7CAj+Bg++2YGJlvd
   0cQy9NQlKN/A0ilMI5SO5X/1sAjENYLSxCTm+ml1MZM5oP7QM6PJpRAIL
   xF+mCMHvP0EVuCqQ4l+EOemPfr+wh2tqnBzDc+SvB4kbUI1Y5+duh86yp
   UaftETF/dyrPSE4RaKQKCWSsyR5ltSPMlIvxRPJpMBNWpX9xxAuxamx/N
   SQu41lQxsZ7iKiXzwH9nnkoGp/NOe2VA002UJlrzBx1nN9kYz+oTqALvn
   g==;
X-CSE-ConnectionGUID: +LXqbki9TduF/umb15Uz8g==
X-CSE-MsgGUID: 87TGZmRTR/Kj8iY1jEPzHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11910"; a="77922691"
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="77922691"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 07:46:49 -0700
X-CSE-ConnectionGUID: jKcht4byQRm6lTBeCDPFcQ==
X-CSE-MsgGUID: HY9w1F77Q6m6pyHwZcPbVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="272163073"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 19 Sep 2026 07:46:47 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x7wKy-00000000B09-3XBI;
	Sat, 19 Sep 2026 14:46:44 +0000
Date: Sat, 19 Sep 2026 22:46:28 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 854157fc9d011b8dd5a1a86a237447e28d681eb9
Message-ID: <202609192223.y5jKCkQi-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 238B0180002
X-Stat-Signature: 4asny1gyx7z3c7ckwyj7qxz341det34a
X-HE-Tag: 1789829209-535026
X-HE-Meta: U2FsdGVkX19YaRaBzfv+0OYN5uH84wKJmvxco1BXp82wSJGJhCrGY5tnQ/rG/GHAynwSPNFNcgJeVHovDGTayzUm3BOu+8MvaN5MBbD/2nklsUSXz+8j1313JRnnK0Dznt4x3NSmVt6P815Q8AR8XXZD19cbeU8YwOtkHUUk3qC3lRAK6/ioriQeaRP2YKtIlM4ey8cwOtjIl4ba92BGysABkOrlWDtPWR87qXrsyudlyu/Mr4YHPQdNmEJ3Fm4VhTgt0pB5nuWo/02+k/KO1/063x3dHUi5q48oFUhILy3P2Cejn8cfNmnCUnaPmqTNJh8w75Prwr1GUeE5oEKJbU5eALLi7/oURM9AJbKzbvFP2RoZ7jGq9dwnnHKf4lZ7b+PvWkF0TA2wvwLpSlQhYtiF3Y2kxDzcWafgRAF5NdKbOUGsvcvoF3ReNC5Gf3mfpGvEpXDKJc3Hb7Ycs59MNAsxquWIyQfQWhoW6GQkI+lfmzaGjfT2ylX/S/D53fM20mK68am+HRmc8K7eZtMcz3CcyB7cLwzcwXz6viP9UpHl5RtAmH6FParzKugPDfbPEWYNQqZc2evRH9iRPqy6YBj5h3PZRwxc3uOWCMf3M8Fq5iWX4l3XULzNOszWN7H0JFOViQ3S6xI9qdQC+as4ifO/2vE+t3LEIgMFkutooSqXNUf++u8MPxwBsGq8C6VpygHlQHap8QYVifC0+h6oLRwUOfVoHmDYkO+cwFWzgKSzo3Mlged/q8CGEuN/qAYdtTwgoVcgQRFgEKiVn/oRNdBoVvVPKRjioHmg0qF/jkvRjnKnhzZ9R/XtjIOiYx9K/sExSKNZkA6aGkc7dEwYxDOljZpckxptwVQm9MavecVw9sHIaCHX2ws+T3wbTAr+UBVT38Zt8mrfFmBzxNSDQKBxQ0p94l8Z2jcV4wHqBnKgc8WBm0iUmHgNvOFvMeSOE/OZ1fq9FKGzNp+ml6Z
 tiWuRtAQ
 qvNXyAPPVECEHTOMsY7mjvXOYemUWn6IX/51IR4ttXXl72b4UFzbWfDw69vCtULpL++jWYaZ0JkycBaIbLZTW3GFUPRgiEtaY7LKKAuF9roD2GSpURZady2vglBaBdheTqtMAsCUkVKDFr0Y0rVTiO6goAt5XEtdYzp5CAnhduWE2J7Vd04dlTryg8lbQnVt7D6J1HLO4wfqXxZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 854157fc9d011b8dd5a1a86a237447e28d681eb9  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: m

configs tested: 171
configs skipped: 7

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260919    gcc-15.2.0
arc                   randconfig-1001-20260919    gcc-13.4.0
arc                  randconfig-r1302-20260919    gcc-10.5.0 sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                   randconfig-1000-20260919    gcc-10.5.0
arm                   randconfig-1001-20260919    gcc-11.5.0
arm                   randconfig-1002-20260919    gcc-13.4.0
arm                   randconfig-1003-20260919    gcc-15.2.0
arm                           sp7021_defconfig    gcc-16.1.0
arm                        versatile_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260919    gcc-16.1.0
arm64                 randconfig-1001-20260919    gcc-10.5.0
arm64                 randconfig-1002-20260919    gcc-8.5.0
arm64                 randconfig-1003-20260919    clang-24
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260919    gcc-11.5.0
csky                  randconfig-1001-20260919    gcc-16.1.0
csky                 randconfig-r1301-20260919    gcc-10.5.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260919    clang-17
hexagon               randconfig-1001-20260919    clang-18
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20260919    clang-22
i386        buildonly-randconfig-1001-20260919    clang-22
i386        buildonly-randconfig-1002-20260919    clang-22
i386        buildonly-randconfig-1003-20260919    clang-22
i386        buildonly-randconfig-1004-20260919    gcc-14
i386        buildonly-randconfig-1005-20260919    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260919    clang-22
i386                  randconfig-1001-20260919    clang-22
i386                  randconfig-1002-20260919    clang-22
i386                  randconfig-1003-20260919    clang-22
i386                  randconfig-1004-20260919    clang-22
i386                  randconfig-1005-20260919    gcc-14
i386                  randconfig-1006-20260919    gcc-14
i386                  randconfig-1007-20260919    clang-22
i386                  randconfig-1008-20260919    clang-22
i386                  randconfig-1009-20260919    gcc-14
i386                  randconfig-1010-20260919    clang-22
i386                  randconfig-1011-20260919    gcc-14
i386                  randconfig-1012-20260919    gcc-14
i386                  randconfig-1013-20260919    gcc-14
i386                 randconfig-r1303-20260919    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260919    clang-24
loongarch             randconfig-1001-20260919    clang-18
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                       loongson3_defconfig    gcc-16.1.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260919    gcc-8.5.0
nios2                 randconfig-1001-20260919    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r1308-20260919    gcc-14.3.0 sparse
parisc                            alldefconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260919    gcc-8.5.0
parisc                randconfig-1001-20260919    gcc-11.5.0
parisc               randconfig-r1306-20260919    gcc-12.5.0 sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                       katmai_defconfig    clang-24
powerpc                  mpc8315_rdb_defconfig    clang-24
powerpc                  mpc834x_itx_defconfig    clang-24
powerpc               randconfig-1000-20260919    clang-21
powerpc               randconfig-1001-20260919    gcc-16.1.0
powerpc              randconfig-r1305-20260919    clang-24   sparse
powerpc                      tqm8541_defconfig    clang-24
powerpc64             randconfig-1000-20260919    clang-17
powerpc64             randconfig-1001-20260919    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260919    clang-24
riscv                 randconfig-1001-20260919    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260919    clang-24
s390                  randconfig-1001-20260919    clang-19
s390                 randconfig-r1307-20260919    clang-24   sparse
s390                 randconfig-r1309-20260919    clang-24   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                                j2_defconfig    gcc-16.1.0
sh                    randconfig-1000-20260919    gcc-15.2.0
sh                    randconfig-1001-20260919    gcc-9.5.0
sh                    secureedge5410_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260919    gcc-11.5.0
sparc                 randconfig-1001-20260919    gcc-16.1.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260919    clang-20
sparc64               randconfig-1001-20260919    clang-22
sparc64              randconfig-r1304-20260919    clang-24   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260919    clang-24
um                    randconfig-1001-20260919    gcc-12
um                            x86_64_defconfig    clang-24
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260919    clang-22
x86_64      buildonly-randconfig-1001-20260919    gcc-14
x86_64      buildonly-randconfig-1002-20260919    clang-22
x86_64      buildonly-randconfig-1003-20260919    clang-22
x86_64      buildonly-randconfig-1004-20260919    gcc-13
x86_64      buildonly-randconfig-1005-20260919    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20260919    clang-22
x86_64                randconfig-1001-20260919    clang-22
x86_64                randconfig-1002-20260919    clang-22
x86_64                randconfig-1003-20260919    clang-22
x86_64                randconfig-1004-20260919    gcc-14
x86_64                randconfig-1005-20260919    clang-22
x86_64                randconfig-1012-20260919    gcc-14
x86_64                randconfig-1013-20260919    gcc-14
x86_64                randconfig-1014-20260919    clang-22
x86_64                randconfig-1015-20260919    gcc-14
x86_64                randconfig-1016-20260919    gcc-14
x86_64                randconfig-1017-20260919    clang-22
x86_64               randconfig-r1300-20260919    clang-22   sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20260919    gcc-13.4.0
xtensa                randconfig-1001-20260919    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

