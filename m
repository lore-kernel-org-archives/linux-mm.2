Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389B0E8384F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 04:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B7A6B0005; Mon, 16 Feb 2026 23:35:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC96C6B0089; Mon, 16 Feb 2026 23:35:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA8A6B008A; Mon, 16 Feb 2026 23:35:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B59446B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 23:35:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CFAC1B55FF
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:35:22 +0000 (UTC)
X-FDA: 84452684484.13.9C81F3C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0708FC0002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:35:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=icm2Dait;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771302920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=QAcXYAanzqz3FVVlOMiEldC/kuqYb+gMrbHbvlexbec=;
	b=0RtGG9j7Dih50sfni3Mge+cQ4qXV76ZX7RBIPjJbd5zZMjVuCw0X8Tz8EiRQtCNn4cM7Vr
	MXFysS1SRBc3emcJ/nQDE4va0pqPxVpRMrfvx4QN2fivtvIsaL6VgfRxHFi9k63x3psU3t
	SDK2SrnM6RVeRBfq78Mge3YFfT2kq7Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=icm2Dait;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771302920; a=rsa-sha256;
	cv=none;
	b=3XUpilTLFI5SEotPizvc70rKBMFrE9u1k/ajl9Kns5EHn+HsV1uEX5FcljZW3K3k3TmpZF
	4aLNtBC0qemnJfTZl/hZXrIXL/9LBM5emhg3C8oL93yalS+134y//qrLX3eu0XiDR78m0P
	zx8hcVUE2+rdIZPwO3LtBjU1/ReAZjc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771302918; x=1802838918;
  h=date:from:to:cc:subject:message-id;
  bh=pn9dP/BSSN/O+owRXPjph83FUd+ksRdwhqHbuBpJwqM=;
  b=icm2DaitIVycVVXZak+Dk39FbaXtCtaHlyUHeSN0zf+RDRv9p3vjiKZF
   YQvZdDtbozo8eJkbRMxBBf6TWKe8F+j5TRu96+ro7mPSlZJ30Y+R9Gfxg
   SxpG7B4RFvif21GTngqEwqSoL13DaI+rbZKNFqQTxfLF1KKkbBQ7S2m8T
   80YLTcDzxQj1hWiyCfbSB6DTR0AQZKexobYUIqpoNjASRz3nWJa5uXg7C
   ixf1PKTbFUVwvXJ0otgm0SAl/wc1BVof49aT+wWWPlfmi5ImsJQJ9w9ip
   tRhLLsySELXiB3sEfdHs5oEmAPbfCggzTQgP2AWuPjEtQeMjih56mx8qy
   A==;
X-CSE-ConnectionGUID: v22v3LCfRjSJKT/DozSp8w==
X-CSE-MsgGUID: 0/yiCBiJT7Kzs9MOW+bEtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="72081019"
X-IronPort-AV: E=Sophos;i="6.21,295,1763452800"; 
   d="scan'208";a="72081019"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 20:35:15 -0800
X-CSE-ConnectionGUID: 7RkCoZpSRh+8Hki4Xzdjnw==
X-CSE-MsgGUID: tKHu1MB3S8e+ZLBavSDz0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,295,1763452800"; 
   d="scan'208";a="213604063"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 16 Feb 2026 20:35:13 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vsCnn-000000010cC-0m6n;
	Tue, 17 Feb 2026 04:35:11 +0000
Date: Tue, 17 Feb 2026 12:34:19 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 350adaf7fde9fdbd9aeed6d442a9ae90c6a3ab97
Message-ID: <202602171209.bqDT9Fsz-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Stat-Signature: opwsdnwfkjk7p63hjzqjd7qnyrx84imf
X-Rspam-User: 
X-Rspamd-Queue-Id: 0708FC0002
X-HE-Tag: 1771302917-722043
X-HE-Meta: U2FsdGVkX18eJ9Yxef9twdXSRDJK1Y7Fc9Q0MlvRKa+JvlZh/3Fadx9AWcvgtRsPgLSaSXES0KsY/IGRP4gUy265Sj+t/7s6U0djhxHvCTmlelJxT2YTFx68B8yC1kEyXHJfhe0WDII0YTVLCGAmHo7BLbK7Me3KzKD5aAV+EEvIVuIhCC8Hm79JppkDk65LFwrFErxTUX1f9hbc/tmbl+laLpC758Kvl+NO9/Y/xitk6u9bXUAI6W4NuccAgo/XRK2m60oxrBfvs4azI/80EqWhAReVZNHwdqW9VLZ+GKRifP/DZ3pjY9lY45DUG6GSQPDAVKih/6n462S7kSueY9q+cnc0vT2r55ODuBcIfBBDgt2hwGdT62RDIB43dhDebpdFdaZHPyH8PdLqZYFa1noYswEkpcLStsp6oWgl7S+huW4cwX2zkp15T8jTWViHtl3s19tZx0XlqefP7Vm3zWtebweDueYtN75vP9Cd1lFVzdb5Ezu2lZOlGDlzjiKN1/j4TI/XP6pRsG2z3sYNiYUfrYN8i6kUi7OiLAgQPgEoBOLlgpPh+mSD35bKERG7ddQopo1UOFLr3nxiaFsWvH610jjaPFiJgVpOOGSoQOZf+BlqMTJRBcv+lfRyMTQS5zTPuo4k47/ubnsSlROaiVcpIogmUDjpBkvhq0a8QxV4ODLsl2EFamdPKmiCGfV6iT25mGqiMMtOZMw0mOJ7hv/4j2tYBNpPOFd5x3TzMQZAdxBLckmZVSuQK64p3hLd15TLBP139f4h76AePlW+LzdIi0M/KYNDOoadG+UUVF/86XMB2KLwxKR+g6JKpjCJfGlLwXbdi5XGOXho1n+vQRWiOxWFeWqyWCzZIiaOzNqLFqKAQJV/kE/uhNl/VT5YmXT+OMsRQkz5x2vjQWFQ208kRvss6pv/oeHtp0nW4aEqXrCXEQM9QQ/PJbFOcbXqs3ughRnyl8FjuM/YW3g
 Xp0azG9t
 wEO1y3p5r6nu/xQeRqwh8h/Bktaw3fG3n4oJK9fcC4YRlkHrI6daSdH3N5FWkAQ5YHl8FonTLinT1yii2rKG/+8+HAk4/D7yFQvMWYw2jWOgCw91EzKm6TPZjo0OQpPq4OyCAa9vlmFNrDTIpBG57UwHCVnqbApqFh4Rt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 350adaf7fde9fdbd9aeed6d442a9ae90c6a3ab97  Add linux-next specific files for 20260216

elapsed time: 731m

configs tested: 276
configs skipped: 7

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
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260217    gcc-11.5.0
arc                   randconfig-001-20260217    gcc-8.5.0
arc                   randconfig-002-20260217    gcc-11.5.0
arc                   randconfig-002-20260217    gcc-9.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                         bcm2835_defconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                          exynos_defconfig    clang-23
arm                           h3600_defconfig    gcc-14
arm                        keystone_defconfig    gcc-14
arm                   randconfig-001-20260217    gcc-11.5.0
arm                   randconfig-001-20260217    gcc-14.3.0
arm                   randconfig-002-20260217    gcc-11.5.0
arm                   randconfig-003-20260217    gcc-11.5.0
arm                   randconfig-003-20260217    gcc-8.5.0
arm                   randconfig-004-20260217    gcc-11.5.0
arm                   randconfig-004-20260217    gcc-13.4.0
arm                           sama5_defconfig    gcc-15.2.0
arm                           u8500_defconfig    clang-23
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260217    clang-23
arm64                 randconfig-001-20260217    gcc-9.5.0
arm64                 randconfig-002-20260217    clang-23
arm64                 randconfig-003-20260217    clang-23
arm64                 randconfig-003-20260217    gcc-8.5.0
arm64                 randconfig-004-20260217    clang-23
arm64                 randconfig-004-20260217    gcc-13.4.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260217    clang-23
csky                  randconfig-001-20260217    gcc-15.2.0
csky                  randconfig-002-20260217    clang-23
csky                  randconfig-002-20260217    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260217    clang-23
hexagon               randconfig-002-20260217    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260217    clang-20
i386        buildonly-randconfig-002-20260217    clang-20
i386        buildonly-randconfig-003-20260217    clang-20
i386        buildonly-randconfig-004-20260217    clang-20
i386        buildonly-randconfig-004-20260217    gcc-14
i386        buildonly-randconfig-005-20260217    clang-20
i386        buildonly-randconfig-006-20260217    clang-20
i386        buildonly-randconfig-006-20260217    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260217    gcc-14
i386                  randconfig-002-20260217    gcc-14
i386                  randconfig-003-20260217    clang-20
i386                  randconfig-003-20260217    gcc-14
i386                  randconfig-004-20260217    gcc-14
i386                  randconfig-005-20260217    gcc-14
i386                  randconfig-006-20260217    gcc-14
i386                  randconfig-007-20260217    clang-20
i386                  randconfig-007-20260217    gcc-14
i386                  randconfig-011-20260217    clang-20
i386                  randconfig-011-20260217    gcc-13
i386                  randconfig-012-20260217    clang-20
i386                  randconfig-013-20260217    clang-20
i386                  randconfig-014-20260217    clang-20
i386                  randconfig-015-20260217    clang-20
i386                  randconfig-016-20260217    clang-20
i386                  randconfig-016-20260217    gcc-14
i386                  randconfig-017-20260217    clang-20
i386                  randconfig-017-20260217    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260217    clang-23
loongarch             randconfig-002-20260217    clang-23
loongarch             randconfig-002-20260217    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                        mvme16x_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                          ath79_defconfig    gcc-14
mips                 decstation_r4k_defconfig    clang-23
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                 randconfig-001-20260217    clang-23
nios2                 randconfig-001-20260217    gcc-11.5.0
nios2                 randconfig-002-20260217    clang-23
nios2                 randconfig-002-20260217    gcc-8.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260217    clang-19
parisc                randconfig-001-20260217    gcc-15.2.0
parisc                randconfig-002-20260217    clang-19
parisc                randconfig-002-20260217    gcc-14.3.0
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                      arches_defconfig    gcc-15.2.0
powerpc                   currituck_defconfig    gcc-15.2.0
powerpc                      pasemi_defconfig    clang-23
powerpc               randconfig-001-20260217    clang-19
powerpc               randconfig-001-20260217    gcc-8.5.0
powerpc               randconfig-002-20260217    clang-19
powerpc                     stx_gp3_defconfig    clang-23
powerpc                         wii_defconfig    clang-23
powerpc                 xes_mpc85xx_defconfig    clang-23
powerpc                 xes_mpc85xx_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260217    clang-19
powerpc64             randconfig-001-20260217    gcc-8.5.0
powerpc64             randconfig-002-20260217    clang-19
powerpc64             randconfig-002-20260217    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                    nommu_virt_defconfig    gcc-14
riscv                 randconfig-001-20260217    gcc-10.5.0
riscv                 randconfig-002-20260217    gcc-10.5.0
riscv                 randconfig-002-20260217    gcc-14.3.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260217    clang-23
s390                  randconfig-001-20260217    gcc-10.5.0
s390                  randconfig-002-20260217    clang-23
s390                  randconfig-002-20260217    gcc-10.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                        edosk7705_defconfig    gcc-15.2.0
sh                            hp6xx_defconfig    gcc-14
sh                    randconfig-001-20260217    gcc-10.5.0
sh                    randconfig-001-20260217    gcc-15.2.0
sh                    randconfig-002-20260217    gcc-10.5.0
sh                          rsk7264_defconfig    gcc-14
sh                        sh7763rdp_defconfig    clang-23
sparc                            alldefconfig    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260217    gcc-12.5.0
sparc                 randconfig-001-20260217    gcc-8.5.0
sparc                 randconfig-002-20260217    gcc-12.5.0
sparc                 randconfig-002-20260217    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260217    clang-23
sparc64               randconfig-001-20260217    gcc-12.5.0
sparc64               randconfig-002-20260217    clang-20
sparc64               randconfig-002-20260217    gcc-12.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260217    gcc-12.5.0
um                    randconfig-001-20260217    gcc-14
um                    randconfig-002-20260217    gcc-12.5.0
um                    randconfig-002-20260217    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           alldefconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260217    clang-20
x86_64      buildonly-randconfig-001-20260217    gcc-14
x86_64      buildonly-randconfig-002-20260217    gcc-14
x86_64      buildonly-randconfig-003-20260217    clang-20
x86_64      buildonly-randconfig-003-20260217    gcc-14
x86_64      buildonly-randconfig-004-20260217    gcc-14
x86_64      buildonly-randconfig-005-20260217    gcc-14
x86_64      buildonly-randconfig-006-20260217    clang-20
x86_64      buildonly-randconfig-006-20260217    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260217    clang-20
x86_64                randconfig-002-20260217    clang-20
x86_64                randconfig-003-20260217    clang-20
x86_64                randconfig-003-20260217    gcc-14
x86_64                randconfig-004-20260217    clang-20
x86_64                randconfig-005-20260217    clang-20
x86_64                randconfig-006-20260217    clang-20
x86_64                randconfig-006-20260217    gcc-14
x86_64                randconfig-011-20260217    gcc-14
x86_64                randconfig-012-20260217    clang-20
x86_64                randconfig-012-20260217    gcc-14
x86_64                randconfig-013-20260217    clang-20
x86_64                randconfig-013-20260217    gcc-14
x86_64                randconfig-014-20260217    gcc-14
x86_64                randconfig-015-20260217    gcc-14
x86_64                randconfig-016-20260217    gcc-14
x86_64                randconfig-071-20260217    clang-20
x86_64                randconfig-071-20260217    gcc-14
x86_64                randconfig-072-20260217    clang-20
x86_64                randconfig-072-20260217    gcc-14
x86_64                randconfig-073-20260217    clang-20
x86_64                randconfig-073-20260217    gcc-14
x86_64                randconfig-074-20260217    gcc-14
x86_64                randconfig-075-20260217    clang-20
x86_64                randconfig-075-20260217    gcc-14
x86_64                randconfig-076-20260217    clang-20
x86_64                randconfig-076-20260217    gcc-14
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
xtensa                randconfig-001-20260217    gcc-12.5.0
xtensa                randconfig-001-20260217    gcc-8.5.0
xtensa                randconfig-002-20260217    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

