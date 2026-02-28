Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D105FEE4C4
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 04:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B777C6B0005; Fri, 27 Feb 2026 23:11:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24CA6B0088; Fri, 27 Feb 2026 23:11:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30736B0089; Fri, 27 Feb 2026 23:11:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6566B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 23:11:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38493140841
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 04:11:46 +0000 (UTC)
X-FDA: 84492541812.15.122B2DA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf13.hostedemail.com (Postfix) with ESMTP id EBCD420005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 04:11:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N1cX40c5;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772251904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=bKKMdJBFPknimFdxG9tTKT0l40JCeal6nNi0eISQ8g4=;
	b=BD4PW6TwY4prepMiwaiEc72d9XxrTtMvHeyt7aMxoRAuA4gqdpFpl3V9JbDjq5jiEofYLC
	5/vbkyGQm6gn0YfVEdNUY93BDlv4iXRBG9ouyO17o3h1UVciH4B8EnovWQWKahlC+S2u0g
	yusOLAuu5ujul/Q7kCTtYg+qurmRDxM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N1cX40c5;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772251904; a=rsa-sha256;
	cv=none;
	b=ZvDKK1H73aViGw8M7xWZc1l/lE8+owZqxfyvWcXbZZw6R0/6YzRsMUt8xGQqPdsBEcozdR
	mhAzKkROS1GRB+pqL16qMOzMyQdGKTcw0+j/iJeJv5AhyZ9ANokB3tudLNDf59IIfk0R//
	xDYq1MRTJXGlvc7gdwvOgtCOeosiL+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772251900; x=1803787900;
  h=date:from:to:cc:subject:message-id;
  bh=JyNFL2ifbpQnwBSyRDI5n4hMDOnCx+exodMy/eXX/qk=;
  b=N1cX40c5ts7NmtdsrSZIBPNwrqpAnDCgB+jLW1akoMA8FR3+NZgDrpXC
   nouwrO1xuFxnO/OCjZFZ/Qxrg9Muavrkh64sIeWR6sSZnkCZASl4o89P8
   4XILgwHPoPYX/YW4T5ZPQISssPFa8TS8yEwrUGUFq8qxBXei+rF8u7YtA
   MqFHdYrP9T5e0Wi1w1nkbyR7dv2Ye4+f+zNP2sjocc+jBvZhWnrRySFiJ
   DvwZvZB6Yqhh0jIhHdWzcCVbOS5vcE6bi04KNGpyzDRtYu50wI8A6wuOG
   RqDd6N7fTfMp++x8ACDDQoIe9tnfHCApxkbMVgcqlZhoiSnerndXuHD6+
   g==;
X-CSE-ConnectionGUID: sQY8Tvb1TXOjdGnN5YOitQ==
X-CSE-MsgGUID: xzSfG4ncRiSeQ6G1w9XPsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11714"; a="73040654"
X-IronPort-AV: E=Sophos;i="6.21,315,1763452800"; 
   d="scan'208";a="73040654"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 20:11:38 -0800
X-CSE-ConnectionGUID: jjxDA4wqSp69c2jOP80r1A==
X-CSE-MsgGUID: yQEIiH1GQgmIsJutvKlQAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,315,1763452800"; 
   d="scan'208";a="214440945"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 27 Feb 2026 20:11:36 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vwBfx-00000000BJ5-1Prf;
	Sat, 28 Feb 2026 04:11:33 +0000
Date: Sat, 28 Feb 2026 12:11:07 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 3fa5e5702a82d259897bd7e209469bc06368bf31
Message-ID: <202602281259.iMfUOHnc-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: EBCD420005
X-Stat-Signature: o69wximbnbfba9aucx9gzok973t9s1gr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772251898-30679
X-HE-Meta: U2FsdGVkX18uWb0AYXKc9Pz3XVQnLzjYXQH+NpiSft/UCAlSs7W1raljuI6eE1zu94YzTGD5HnQVBrdm1yW6kvjygGpP9U2xeru/o6J2H8z+jOU5mrDCudbEy9d/To3fT/poe0Scsfak1uP8nd9nur1P41f/UPSkoyyw/FddqcVUiMXDkwBeEF7efxIHcU4c1TIqho62Xi+qwxIoy28VJoiKl84A4qea9nIrX43oclQezQdIOs/M0QMUJ2V5UL8jWz5ZJJmcIIUIvbNwZ/AkXjw7XKs3499TPJE+k3Ii2NJ4M650LT4G1VwSGGlUlnJe1LfmnUtZwyyM+t0ZJU6dqxKeknv2jh5FuKDn6GNaYwHDgxIXty2wWtFyK1fLD3yFARBkx9+mlM/iSpBEUj9jqNcwmx5iws4lQzaIly9elaa+i8HthHL84U+l5EuA6QyoRIpqb+VZT0Yjc6in/J/q3WiowrwHhC/odwqaD3KdyhAD7EV1kdi5LneQtGMH9wSeABmi/8EYdoGs7yNVD58D4uoM+hULPpIS591eDVnFx/cJ5pSXTeOb1Kic+3aOph+R1Qs20Jt7uEHRE/sRKU3JJ5EICy+J4MDgG2Si/qMUdOQS/McTvCKFewVrsEUJ7G9cRY++GBZ56jOEaHZ7+njbKzGLBCh9azkbFp1lYBmGBGDvFclLvymc7QsaQAcPHICzCB77a/HNON+ipxarBubI+6PWsqRYc9Ow7f0iefKNkRIdJKuinbC6QDoVPkJ+H5UX7dC0e9x6K7lym5Zk+Nd5OM3ZgwvdR0GN+1IFk42rdkQFWNeo+Mza2Ej97RdJ136Myw4lH0ZZVZ6xV0Mwd6ABAi3wPqSvp8YPhoNiNznA2jNP3Uesr7yxFhJYSVsb46B5x7D5lyIri4S25AzwRVCvBKMh4kd5bbp5BO7MPG+NgR4lq6dNSonVYvWXnCB83QfOH9D3XzDxvnB/VRObrUk
 Nh4OGXsZ
 mbEjyftR9TJ7NsvWD8bua9FcazqGLJBQA1ljykJC1zqY05f2cJdtGy2MUoRyMmYO6H+x1uekPhe8tVF4U15+SX/cyg6pfF/rj0SNW79PC1cnmSCSDDYFbq7S2lk0xNAGK40OpcqAwhWQFgMIQYhL9AR76pPpXwBp6tLmA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 3fa5e5702a82d259897bd7e209469bc06368bf31  Add linux-next specific files for 20260227

elapsed time: 764m

configs tested: 296
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-15.2.0
arc                          axs101_defconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                         haps_hs_defconfig    gcc-15.2.0
arc                        nsimosci_defconfig    clang-23
arc                        nsimosci_defconfig    gcc-15.2.0
arc                   randconfig-001-20260227    gcc-8.5.0
arc                   randconfig-001-20260228    gcc-14.3.0
arc                   randconfig-002-20260227    gcc-8.5.0
arc                   randconfig-002-20260228    gcc-14.3.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                       imx_v6_v7_defconfig    gcc-15.2.0
arm                            mps2_defconfig    clang-23
arm                        mvebu_v5_defconfig    clang-23
arm                             mxs_defconfig    clang-23
arm                   randconfig-001-20260227    gcc-14.3.0
arm                   randconfig-001-20260228    gcc-14.3.0
arm                   randconfig-002-20260227    clang-23
arm                   randconfig-002-20260228    gcc-14.3.0
arm                   randconfig-003-20260227    gcc-15.2.0
arm                   randconfig-003-20260228    gcc-14.3.0
arm                   randconfig-004-20260227    clang-23
arm                   randconfig-004-20260228    gcc-14.3.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260228    clang-23
arm64                 randconfig-002-20260228    clang-23
arm64                 randconfig-002-20260228    gcc-8.5.0
arm64                 randconfig-003-20260228    clang-23
arm64                 randconfig-004-20260228    clang-23
arm64                 randconfig-004-20260228    gcc-12.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260228    clang-23
csky                  randconfig-001-20260228    gcc-15.2.0
csky                  randconfig-002-20260228    clang-23
csky                  randconfig-002-20260228    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260227    clang-23
hexagon               randconfig-001-20260228    clang-23
hexagon               randconfig-002-20260227    clang-23
hexagon               randconfig-002-20260228    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260227    clang-20
i386        buildonly-randconfig-001-20260228    clang-20
i386        buildonly-randconfig-002-20260227    clang-20
i386        buildonly-randconfig-002-20260228    clang-20
i386        buildonly-randconfig-003-20260227    gcc-14
i386        buildonly-randconfig-003-20260228    clang-20
i386        buildonly-randconfig-004-20260227    gcc-14
i386        buildonly-randconfig-004-20260228    clang-20
i386        buildonly-randconfig-005-20260227    clang-20
i386        buildonly-randconfig-005-20260228    clang-20
i386        buildonly-randconfig-006-20260227    clang-20
i386        buildonly-randconfig-006-20260228    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260227    clang-20
i386                  randconfig-002-20260227    clang-20
i386                  randconfig-003-20260227    gcc-14
i386                  randconfig-004-20260227    gcc-14
i386                  randconfig-005-20260227    gcc-12
i386                  randconfig-006-20260227    gcc-14
i386                  randconfig-007-20260227    clang-20
i386                  randconfig-011-20260228    gcc-14
i386                  randconfig-012-20260228    gcc-14
i386                  randconfig-013-20260228    clang-20
i386                  randconfig-013-20260228    gcc-14
i386                  randconfig-014-20260228    clang-20
i386                  randconfig-014-20260228    gcc-14
i386                  randconfig-015-20260228    clang-20
i386                  randconfig-015-20260228    gcc-14
i386                  randconfig-016-20260228    clang-20
i386                  randconfig-016-20260228    gcc-14
i386                  randconfig-017-20260228    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260227    gcc-15.2.0
loongarch             randconfig-001-20260228    clang-23
loongarch             randconfig-002-20260227    clang-20
loongarch             randconfig-002-20260228    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                          amiga_defconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                            q40_defconfig    clang-23
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                           ci20_defconfig    gcc-15.2.0
mips                     decstation_defconfig    gcc-15.2.0
mips                      loongson1_defconfig    gcc-15.2.0
mips                          rm200_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260227    gcc-11.5.0
nios2                 randconfig-001-20260228    clang-23
nios2                 randconfig-002-20260227    gcc-11.5.0
nios2                 randconfig-002-20260228    clang-23
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260227    gcc-8.5.0
parisc                randconfig-001-20260228    gcc-8.5.0
parisc                randconfig-002-20260227    gcc-8.5.0
parisc                randconfig-002-20260228    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                   bluestone_defconfig    gcc-15.2.0
powerpc                   motionpro_defconfig    clang-23
powerpc                     mpc83xx_defconfig    gcc-15.2.0
powerpc                  mpc866_ads_defconfig    clang-23
powerpc                     powernv_defconfig    clang-23
powerpc               randconfig-001-20260227    gcc-11.5.0
powerpc               randconfig-001-20260228    gcc-8.5.0
powerpc               randconfig-002-20260227    clang-17
powerpc               randconfig-002-20260228    gcc-8.5.0
powerpc                    sam440ep_defconfig    gcc-15.2.0
powerpc                     sequoia_defconfig    clang-23
powerpc                     skiroot_defconfig    clang-23
powerpc                     taishan_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260227    gcc-10.5.0
powerpc64             randconfig-001-20260228    gcc-8.5.0
powerpc64             randconfig-002-20260227    gcc-14.3.0
powerpc64             randconfig-002-20260228    gcc-8.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260228    gcc-11.5.0
riscv                 randconfig-001-20260228    gcc-15.2.0
riscv                 randconfig-002-20260228    gcc-15.2.0
riscv                 randconfig-002-20260228    gcc-9.5.0
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260228    gcc-15.2.0
s390                  randconfig-001-20260228    gcc-8.5.0
s390                  randconfig-002-20260228    gcc-15.2.0
s390                  randconfig-002-20260228    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                         apsh4a3a_defconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260228    gcc-15.2.0
sh                    randconfig-002-20260228    gcc-15.2.0
sh                          sdk7780_defconfig    gcc-15.2.0
sh                           se7724_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260228    gcc-12.5.0
sparc                 randconfig-001-20260228    gcc-9.5.0
sparc                 randconfig-002-20260228    gcc-15.2.0
sparc                 randconfig-002-20260228    gcc-9.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260228    gcc-15.2.0
sparc64               randconfig-001-20260228    gcc-9.5.0
sparc64               randconfig-002-20260228    gcc-9.5.0
um                               alldefconfig    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260228    clang-20
um                    randconfig-001-20260228    gcc-9.5.0
um                    randconfig-002-20260228    gcc-14
um                    randconfig-002-20260228    gcc-9.5.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260227    gcc-14
x86_64      buildonly-randconfig-001-20260228    gcc-14
x86_64      buildonly-randconfig-002-20260227    gcc-14
x86_64      buildonly-randconfig-002-20260228    gcc-14
x86_64      buildonly-randconfig-003-20260227    clang-20
x86_64      buildonly-randconfig-003-20260228    gcc-14
x86_64      buildonly-randconfig-004-20260227    gcc-14
x86_64      buildonly-randconfig-004-20260228    gcc-14
x86_64      buildonly-randconfig-005-20260227    gcc-14
x86_64      buildonly-randconfig-005-20260228    gcc-14
x86_64      buildonly-randconfig-006-20260227    gcc-14
x86_64      buildonly-randconfig-006-20260228    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260227    clang-20
x86_64                randconfig-001-20260228    gcc-14
x86_64                randconfig-002-20260227    clang-20
x86_64                randconfig-002-20260228    gcc-14
x86_64                randconfig-003-20260227    gcc-14
x86_64                randconfig-003-20260228    gcc-14
x86_64                randconfig-004-20260227    gcc-13
x86_64                randconfig-004-20260228    gcc-14
x86_64                randconfig-005-20260227    gcc-14
x86_64                randconfig-005-20260228    gcc-14
x86_64                randconfig-006-20260227    gcc-14
x86_64                randconfig-006-20260228    gcc-14
x86_64                randconfig-011-20260227    gcc-14
x86_64                randconfig-011-20260228    gcc-14
x86_64                randconfig-012-20260227    gcc-14
x86_64                randconfig-012-20260228    gcc-14
x86_64                randconfig-013-20260227    clang-20
x86_64                randconfig-013-20260228    gcc-14
x86_64                randconfig-014-20260227    clang-20
x86_64                randconfig-014-20260228    gcc-14
x86_64                randconfig-015-20260227    clang-20
x86_64                randconfig-015-20260228    gcc-14
x86_64                randconfig-016-20260227    gcc-14
x86_64                randconfig-016-20260228    gcc-14
x86_64                randconfig-071-20260227    gcc-12
x86_64                randconfig-071-20260228    gcc-14
x86_64                randconfig-072-20260227    clang-20
x86_64                randconfig-072-20260228    gcc-14
x86_64                randconfig-073-20260227    gcc-14
x86_64                randconfig-073-20260228    gcc-14
x86_64                randconfig-074-20260227    clang-20
x86_64                randconfig-074-20260228    gcc-14
x86_64                randconfig-075-20260227    clang-20
x86_64                randconfig-075-20260228    gcc-14
x86_64                randconfig-076-20260227    clang-20
x86_64                randconfig-076-20260228    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                           allyesconfig    gcc-15.2.0
xtensa                  cadence_csp_defconfig    gcc-15.2.0
xtensa                randconfig-001-20260228    gcc-8.5.0
xtensa                randconfig-001-20260228    gcc-9.5.0
xtensa                randconfig-002-20260228    gcc-12.5.0
xtensa                randconfig-002-20260228    gcc-9.5.0
xtensa                    smp_lx200_defconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

