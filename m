Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DABF1C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 20:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE9F6B00B5; Fri,  3 Jul 2026 16:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980566B00B6; Fri,  3 Jul 2026 16:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8958B6B00B7; Fri,  3 Jul 2026 16:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 592FE6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:57:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9DCE120277
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:57:50 +0000 (UTC)
X-FDA: 84948677100.17.7D31AF2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F215140007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:57:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RaC6G40a;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783112269;
	b=soCL9k91LWTDerFj5E2OAPBBUxi6c9MqmgQRcmGi4R5a6nPnnyhZoKMKKV+LVJFgeAUQ9z
	d5RBj6lf4gNtYVBEGFE9eKxRTeuo8y8Q4FbLukqTsgjSZNio6xseBdXquCrp5rET0brjo3
	qpqDh5TSdC/v+YwXRuyWQHvNDx3h2Kg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783112269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=PQBlC5vIU/OSDC6uhNSCg6nzR5YdTkNf9GexSDcXzaI=;
	b=j7zGK/r9IpHNf36KZQd5rhB7oFozcGTlUMRMegU7CxSO8XEWkLaJ1bJIkIWU6OU8CWvvJ0
	8vuAacH5WsD4G3tJXBIxiT3lG2Qkap2VQxLJeRJrRJXb3GebM0c3tQR4+Ft407lwtw4CP3
	Vtzkt2a/mdXWinDNWDYybwXe2/ycAZs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RaC6G40a;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783112269; x=1814648269;
  h=date:from:to:cc:subject:message-id;
  bh=8JwU6ERBOw6Hc/mWOmETI+HYkUIRjiGVblAgNtVvN+8=;
  b=RaC6G40aNIiwcvMHNups7zgIqWcJwC2YxEXYJ3qhlaTvzDoqrLVsvCDZ
   IlevJXy+RI8ThGTQp+73MA2rkH98lyMjDD7LCX9uhTaGYZdsfg3p1v3/1
   0NlCmdWzYBjQYfzPJB6ko2bfd1O0fmAqJAxCUKCoygv6QPnVhg78T+MeP
   i7GJ5WBtlOhdmvmuW4MC75RkXxGXMDm2OtdNn8tktqfNTLuTl60g05IPn
   G/gpp349Jr3sSGu/t82RRuk6xYn8gT2iMUXornmDIctS8cXOGdHl2NbtG
   cDr//o4B1Qq/vhYnaSwzWsKmFq9Y7p5rHvIgjASp/rkDjfxuhNgaWG7kF
   Q==;
X-CSE-ConnectionGUID: bdmY/O6VT7CCjBYU6awqHA==
X-CSE-MsgGUID: U52C3je9Q9KQlV75eeFh3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11836"; a="83894034"
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="83894034"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 13:57:48 -0700
X-CSE-ConnectionGUID: fYxSfZ/XT4S8zGLBDidKrA==
X-CSE-MsgGUID: RdRKksjpSJWhjY4c43tDkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="253327305"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 03 Jul 2026 13:57:46 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfkx8-00000000CW1-38ah;
	Fri, 03 Jul 2026 20:57:40 +0000
Date: Sat, 04 Jul 2026 04:56:52 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 717cd4552ae422269f844aa19ce0125462c9c0b0
Message-ID: <202607040442.Half59i4-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F215140007
X-Stat-Signature: t61tctd36zbaun88qjrrd35grb96fsk1
X-HE-Tag: 1783112268-416116
X-HE-Meta: U2FsdGVkX19f5lnQ+44PUVAZtQXrssSvhDvPzM06FDhIBTe5Di/R7ELyJWzNpPDvbk8TPzFb2lhKO58OFfO+B1B533NyDgay/0dl3ykcMO28KDAPeZKKJqA/JX/lgNYFTLkDHvqVDm9gtglodDTusRlMlo24WEmVXDSGozNb/fhAJF/AlJaz/bHqk+dJYua266FmL6XU4oezx+WeLFEUmReO6a6FqfO96Yvj6XQFvW/KNduSFLB4+nxK+xfASsiw631Bf2MnH3uNFiqHVAsbJWuG7hsSAWRWh2XOy5Smj1KtIgH6LlXLN3JMgHWMsP4Nf/3JetjmGr/+dgbVFHYv4kVsMMJNDKyK7YkrIKVjoXXhj8Rfi2cuS5Zx1T2Z1hjlNOW17GnBz4vJk4rfuai58HYkKBysakbuz2TTi20XrPPKw0tk/KHfLG+Vd0pMlkjqMU5s139SKaNxp4XwYyDdqXHMXUXkDrietUSKKVEzlMrAaZG4iarDsnkue3zN3gcxkPTN55kLM48KzqfPwZbiNkuiP9S4nF0qrjEJ5ETjed9Ax22zhkVfdXXBeareLLGUtk6gXh54dtHOpqQxWc0RN8pPS7uwnzSmvAXUzVwvURf2pErJdHhnDLME6NEjOD8qnDLDnnBkJm28+37vl43TvdC4qmaDEjGIl6lglDGMVJtWFfgsDhtid6/GEtGajikAiLxuWcQvHHxoQqUeEMb9fYwAnw+PpxHqQ1WAvGnz2rG167Ep/iHqdO/x8V/LhoHYN6Pc6txeOuOwa9HkqbGPHPaxPD5Uc29r6Zp25UcDoQ2UlopFdqgog8Qdg8Xq1S3BDHixKJWee7slw1e0dCym7yQuacurQV4vH/qMWagGddAp2IOO/2f8G/MayeKvX5D1+h/Y7EmiT9KqXv61p5y+NCaKG/wDmit92hG4kK0emiripP8dArB89rhQzBm5apkLjAyU504rQaUphCU06Cy
 4LRYPvyG
 bai+lH42uhuWL1H50XKGrzLxLxhsmpHoW1xWkKWmhuFomqq798OHfuhOZDpOw0RubfDFbu08Bme/QU4RMvcF87cc6+Oezh+1tqDNz16E1nZcwe5HFf1hCluT/cJhscFpJKSHtFN9GIx6XkPOgDtvGe5SXXnHaN0+9srIaqSS40ChV2FqwotVOIpSt+7svhIuGlOfD1MtBIAYXjO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 717cd4552ae422269f844aa19ce0125462c9c0b0  Merge branch 'numa_memblks-redundant-work' into for-next

elapsed time: 728m

configs tested: 312
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                          axs103_defconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                            randconfig-001    gcc-16.1.0
arc                   randconfig-001-20260703    gcc-16.1.0
arc                   randconfig-001-20260703    gcc-8.5.0
arc                   randconfig-001-20260704    gcc-8.5.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260703    gcc-16.1.0
arc                   randconfig-002-20260703    gcc-8.5.0
arc                   randconfig-002-20260704    gcc-8.5.0
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                        keystone_defconfig    gcc-16.1.0
arm                        mvebu_v7_defconfig    clang-23
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260703    gcc-16.1.0
arm                   randconfig-001-20260703    gcc-8.5.0
arm                   randconfig-001-20260704    gcc-8.5.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260703    gcc-16.1.0
arm                   randconfig-002-20260703    gcc-8.5.0
arm                   randconfig-002-20260704    gcc-8.5.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260703    gcc-16.1.0
arm                   randconfig-003-20260703    gcc-8.5.0
arm                   randconfig-003-20260704    gcc-8.5.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260703    gcc-16.1.0
arm                   randconfig-004-20260703    gcc-8.5.0
arm                   randconfig-004-20260704    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    gcc-10.5.0
arm64                 randconfig-001-20260703    gcc-10.5.0
arm64                 randconfig-001-20260704    gcc-16.1.0
arm64                          randconfig-002    gcc-10.5.0
arm64                 randconfig-002-20260703    gcc-10.5.0
arm64                 randconfig-002-20260704    gcc-16.1.0
arm64                          randconfig-003    gcc-10.5.0
arm64                 randconfig-003-20260703    gcc-10.5.0
arm64                 randconfig-003-20260704    gcc-16.1.0
arm64                          randconfig-004    gcc-10.5.0
arm64                 randconfig-004-20260703    gcc-10.5.0
arm64                 randconfig-004-20260704    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    gcc-10.5.0
csky                  randconfig-001-20260703    gcc-10.5.0
csky                  randconfig-001-20260704    gcc-16.1.0
csky                           randconfig-002    gcc-10.5.0
csky                  randconfig-002-20260703    gcc-10.5.0
csky                  randconfig-002-20260704    gcc-16.1.0
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260703    gcc-11.5.0
hexagon               randconfig-001-20260703    gcc-16.1.0
hexagon               randconfig-001-20260704    gcc-16.1.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260703    gcc-11.5.0
hexagon               randconfig-002-20260703    gcc-16.1.0
hexagon               randconfig-002-20260704    gcc-16.1.0
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386        buildonly-randconfig-001-20260703    clang-22
i386        buildonly-randconfig-001-20260704    gcc-14
i386        buildonly-randconfig-002-20260703    clang-22
i386        buildonly-randconfig-002-20260704    gcc-14
i386        buildonly-randconfig-003-20260703    clang-22
i386        buildonly-randconfig-003-20260704    gcc-14
i386        buildonly-randconfig-004-20260703    clang-22
i386        buildonly-randconfig-004-20260704    gcc-14
i386        buildonly-randconfig-005-20260703    clang-22
i386        buildonly-randconfig-005-20260704    gcc-14
i386        buildonly-randconfig-006-20260703    clang-22
i386        buildonly-randconfig-006-20260704    gcc-14
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260703    clang-22
i386                           randconfig-002    clang-22
i386                  randconfig-002-20260703    clang-22
i386                           randconfig-003    clang-22
i386                  randconfig-003-20260703    clang-22
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260703    clang-22
i386                           randconfig-005    clang-22
i386                  randconfig-005-20260703    clang-22
i386                           randconfig-006    clang-22
i386                  randconfig-006-20260703    clang-22
i386                           randconfig-007    clang-22
i386                  randconfig-007-20260703    clang-22
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260703    clang-22
i386                  randconfig-011-20260704    gcc-13
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260703    clang-22
i386                  randconfig-012-20260704    gcc-13
i386                           randconfig-013    clang-22
i386                  randconfig-013-20260703    clang-22
i386                  randconfig-013-20260704    gcc-13
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260703    clang-22
i386                  randconfig-014-20260704    gcc-13
i386                           randconfig-015    clang-22
i386                  randconfig-015-20260703    clang-22
i386                  randconfig-015-20260704    gcc-13
i386                           randconfig-016    clang-22
i386                  randconfig-016-20260703    clang-22
i386                  randconfig-016-20260704    gcc-13
i386                           randconfig-017    clang-22
i386                  randconfig-017-20260703    clang-22
i386                  randconfig-017-20260704    gcc-13
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260703    gcc-11.5.0
loongarch             randconfig-001-20260703    gcc-16.1.0
loongarch             randconfig-001-20260704    gcc-16.1.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260703    gcc-11.5.0
loongarch             randconfig-002-20260703    gcc-16.1.0
loongarch             randconfig-002-20260704    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                                defconfig    clang-23
m68k                          hp300_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                          eyeq5_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-23
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260703    gcc-11.5.0
nios2                 randconfig-001-20260703    gcc-16.1.0
nios2                 randconfig-001-20260704    gcc-16.1.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260703    gcc-11.5.0
nios2                 randconfig-002-20260703    gcc-16.1.0
nios2                 randconfig-002-20260704    gcc-16.1.0
openrisc                         allmodconfig    clang-20
openrisc                          allnoconfig    clang-23
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    clang-23
parisc                randconfig-001-20260703    clang-23
parisc                randconfig-001-20260704    clang-23
parisc                         randconfig-002    clang-23
parisc                randconfig-002-20260703    clang-23
parisc                randconfig-002-20260704    clang-23
parisc64                            defconfig    clang-23
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                      chrp32_defconfig    clang-23
powerpc                     ep8248e_defconfig    gcc-16.1.0
powerpc                        randconfig-001    clang-23
powerpc               randconfig-001-20260703    clang-23
powerpc               randconfig-001-20260704    clang-23
powerpc                        randconfig-002    clang-23
powerpc               randconfig-002-20260703    clang-23
powerpc               randconfig-002-20260704    clang-23
powerpc64                      randconfig-001    clang-23
powerpc64             randconfig-001-20260703    clang-23
powerpc64             randconfig-001-20260704    clang-23
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260703    clang-23
powerpc64             randconfig-002-20260704    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260703    gcc-9.5.0
riscv                 randconfig-001-20260704    gcc-10.5.0
riscv                 randconfig-002-20260703    gcc-9.5.0
riscv                 randconfig-002-20260704    gcc-10.5.0
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260703    gcc-9.5.0
s390                  randconfig-001-20260704    gcc-10.5.0
s390                  randconfig-002-20260703    gcc-9.5.0
s390                  randconfig-002-20260704    gcc-10.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-17
sh                                  defconfig    gcc-14
sh                            hp6xx_defconfig    gcc-16.1.0
sh                    randconfig-001-20260703    gcc-9.5.0
sh                    randconfig-001-20260704    gcc-10.5.0
sh                    randconfig-002-20260703    gcc-9.5.0
sh                    randconfig-002-20260704    gcc-10.5.0
sparc                             allnoconfig    clang-23
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260703    gcc-11.5.0
sparc                 randconfig-001-20260704    gcc-16.1.0
sparc                 randconfig-002-20260703    gcc-11.5.0
sparc                 randconfig-002-20260704    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260703    gcc-11.5.0
sparc64               randconfig-001-20260704    gcc-16.1.0
sparc64               randconfig-002-20260703    gcc-11.5.0
sparc64               randconfig-002-20260704    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260703    gcc-11.5.0
um                    randconfig-001-20260704    gcc-16.1.0
um                    randconfig-002-20260703    gcc-11.5.0
um                    randconfig-002-20260704    gcc-16.1.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260703    gcc-14
x86_64      buildonly-randconfig-001-20260704    gcc-14
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260703    gcc-14
x86_64      buildonly-randconfig-002-20260704    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260703    gcc-14
x86_64      buildonly-randconfig-003-20260704    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260703    gcc-14
x86_64      buildonly-randconfig-004-20260704    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260703    gcc-14
x86_64      buildonly-randconfig-005-20260704    gcc-14
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260703    gcc-14
x86_64      buildonly-randconfig-006-20260704    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                randconfig-001-20260703    clang-22
x86_64                randconfig-001-20260704    clang-22
x86_64                         randconfig-002    clang-22
x86_64                randconfig-002-20260703    clang-22
x86_64                randconfig-002-20260704    clang-22
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260703    clang-22
x86_64                randconfig-003-20260704    clang-22
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260703    clang-22
x86_64                randconfig-004-20260704    clang-22
x86_64                         randconfig-005    clang-22
x86_64                randconfig-005-20260703    clang-22
x86_64                randconfig-005-20260704    clang-22
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260703    clang-22
x86_64                randconfig-006-20260704    clang-22
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260703    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260703    gcc-14
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260703    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260703    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260703    gcc-14
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260703    gcc-14
x86_64                         randconfig-071    clang-22
x86_64                randconfig-071-20260703    clang-22
x86_64                         randconfig-072    clang-22
x86_64                randconfig-072-20260703    clang-22
x86_64                         randconfig-073    clang-22
x86_64                randconfig-073-20260703    clang-22
x86_64                         randconfig-074    clang-22
x86_64                randconfig-074-20260703    clang-22
x86_64                         randconfig-075    clang-22
x86_64                randconfig-075-20260703    clang-22
x86_64                         randconfig-076    clang-22
x86_64                randconfig-076-20260703    clang-22
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-20
xtensa                randconfig-001-20260703    gcc-11.5.0
xtensa                randconfig-001-20260704    gcc-16.1.0
xtensa                randconfig-002-20260703    gcc-11.5.0
xtensa                randconfig-002-20260704    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

