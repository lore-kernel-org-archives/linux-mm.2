Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FF74ECD9BF
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 02:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2F06B008A; Thu,  5 Feb 2026 21:53:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370CE6B0092; Thu,  5 Feb 2026 21:53:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26FBC6B0093; Thu,  5 Feb 2026 21:53:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 128226B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:53:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A45735A818
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:53:46 +0000 (UTC)
X-FDA: 84412511652.11.55859C8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4683040002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:53:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HqQlu0fl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770346424; a=rsa-sha256;
	cv=none;
	b=JqwvdhJKO+WOj90vPxr/6igmFnnNq0OLMF9upO3YechjMjcwXZ72PS10u9mxXMrlI8bJNS
	uLfk0fFrP0PgUTqkyHHN/7YAHFr9o5TCBo5T0FQB9HRaqHkSt9kAQMkNh+gv452pbzBsa5
	fqeNNF8LUPMJ/MGrkjAcb0zqQESd9mY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HqQlu0fl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770346424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=CE/aFihWLfv/9vuebWCtplFbVvQafyaSoSiugzEg66Y=;
	b=qTVlcIfbztlpeFiH2jk1OLqJ/NVgHjUhoY+Gm8DdLd2SktJtTeAi1T8yubZFsfOzKIzk8J
	pUe1qZ814i5t1IurGqdwBmAk3ow83XAeKpfjm1eaj8sH2Cyyfae9im7BgyWAr1bqCzw5V1
	ZZ4UgYzX8vXNmTt31TPEoZ2L0UKkYRI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770346424; x=1801882424;
  h=date:from:to:cc:subject:message-id;
  bh=CUKtE/i7N3hUC0jAULQpxD8lV2v1wz/nzweA4ZT7f6A=;
  b=HqQlu0flP0a8xMYKtgdksjXQKxm2kr4iB9WgN5H9bPMGYbv8tQMZ2N/r
   LPjJXbQm9w0ixyY63RS1WUCkWyUimCb0uWHCnG+3GUt8durlv8vOX9Z3u
   RvqM+uXP33lM61ezUbEg509J+uEAgg0zZXAD1CY6R3GSL8LuSRMqwTRiq
   1k2IhJA38ZQ4utZatcyTwqAjsjoT3IkDkGAj6R26urD5crvqWUsS3b5jK
   aq4nhWQsUW7Q+W5ZTejC661UcrX5O8AR9tkQD8uQDMk2iWBE211wo1lej
   JVvd38uP+k2mZQlf/lXbKu4XHPFWgLpcpkjoaZeBRlOUnLW6+J/xatoPy
   g==;
X-CSE-ConnectionGUID: HvPLbKBdQdeziGkf/PYz/w==
X-CSE-MsgGUID: 1DuhPZk3T0imPOHN718ZaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="82188139"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="82188139"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 18:53:43 -0800
X-CSE-ConnectionGUID: 3FGzg0dhShmLuBgNkeRr8g==
X-CSE-MsgGUID: 4YaaxdfHT2ONQyrdD7iwEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="210671254"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 05 Feb 2026 18:53:41 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1voByV-00000000kO8-0uqG;
	Fri, 06 Feb 2026 02:53:39 +0000
Date: Fri, 06 Feb 2026 10:53:08 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 9845cf73f7db6094c0d8419d6adb848028f4a921
Message-ID: <202602061059.24bOV0Ll-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4683040002
X-Stat-Signature: x8tkr98qh5jx9ce3z9eoktnqb3hdcxht
X-HE-Tag: 1770346424-773063
X-HE-Meta: U2FsdGVkX18v2Q5rfMKv4ubhwpFbx5/bNhzJoK+NAA06dM7rquN2OB7HRcoOaXPHsAhSAdSCpgLfG5ARbiwiT/Fzo8FUybkk+MYR3kroW1D8H+2zVJpShsfcLRjLamF+hN097o2ukkADGEsk6RAF0I7x8aW2LY67rDuIRUdQv4wi5stZ5h8tuL0ygh4lbnKlvPItmZ/5AHKLTlaDiLU24kIf83PPLYFqeMYWvOJJys2vxeAVyb8wkZGG1W2goUlwclZr4Ot09TIj/obx3MXq/79hdwKtTAoMfotjRQ5e2lWEa7Gin16fXhXx0VeIAXarvNXrA10qZYU6++uGymWSpTtz0/89qQO3ypnXmroOxiV7+MrQ+y5uw3p3qJVEvHC3juZORIIHLtoeVmWkkDm4By2fDS41wuqivte63hScQ3o8fVvwu2gDU1N+7RWdIrq8xD379TlZlIPzafxyPLlJQ0VxaSdSDBg+b3J4HewwKk7pMm/SPgEigLMqyyoU/dZmzzRi4GV3bscVlLCex6q5P00RklTtNawNYTpHcp6uiECU6tVyHbELSvv9AzMQv6TBNBmzhjZV3pCy1WrkHcWnA7oP+EaJLeYAAUBImBkxbjEmfNmZcS8w+JXnU9kf+WFifO9cDs9fd5oH+CaaqEIotq5YA1KcUvbpGpdzEqPB1xXjQjKy+Lo8hmfLXsBAGYGYDDc9Ia1gyDqk0+cFbymUcThuprDg2e3n/AUlau3BKV6HtsXxx7u3xPr8Iqak98VuoS4sqHCxi30spN3LU2qBF1u0J8p0A8uEFR/Yee7ysvu+DmZpsO3YyzBTD5jufh5pQe4XcFjCsdVSDn/ePUJ9DGQtblhmzYCmAObcEfrzX6GKy4mvy6oiYYBLQcSw8v/G+56/CuXdqS2iWeY4cpEnMnmMAf/1SInN7Zic6kLreY76mxymDF6Nmj8UpPScSV0XXaWYw1wctuyf9B7lIRp
 PNo4m76L
 T6iYwI9mN0/uOhqxw4fhQxTBh1PGhmddSLD+9FQymbE2iZF6Y2qxpvhtumxvfL7vCGcyxccVs3wWRsgIC/L2YSWZjsFHr0q72MuWZWy7fy3eobunZmGxB+r13UrKfmPE75yVNA7c0zgPrwIlBxSVTtJ/AuzqXTzyEx4Cv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9845cf73f7db6094c0d8419d6adb848028f4a921  Add linux-next specific files for 20260205

elapsed time: 721m

configs tested: 262
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260205    gcc-8.5.0
arc                   randconfig-002-20260205    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                          ep93xx_defconfig    clang-22
arm                   randconfig-001-20260205    clang-22
arm                   randconfig-002-20260205    gcc-8.5.0
arm                   randconfig-003-20260205    clang-22
arm                   randconfig-004-20260205    gcc-8.5.0
arm                           sunxi_defconfig    clang-22
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260205    clang-22
arm64                 randconfig-001-20260206    gcc-13.4.0
arm64                 randconfig-002-20260205    gcc-10.5.0
arm64                 randconfig-002-20260206    gcc-13.4.0
arm64                 randconfig-003-20260205    clang-22
arm64                 randconfig-003-20260206    gcc-13.4.0
arm64                 randconfig-004-20260205    clang-19
arm64                 randconfig-004-20260206    gcc-13.4.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260205    gcc-9.5.0
csky                  randconfig-001-20260206    gcc-13.4.0
csky                  randconfig-002-20260205    gcc-10.5.0
csky                  randconfig-002-20260206    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260206    clang-19
hexagon               randconfig-001-20260206    clang-22
hexagon               randconfig-002-20260206    clang-22
i386                             alldefconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260206    clang-20
i386        buildonly-randconfig-001-20260206    gcc-12
i386        buildonly-randconfig-002-20260206    clang-20
i386        buildonly-randconfig-002-20260206    gcc-12
i386        buildonly-randconfig-003-20260206    clang-20
i386        buildonly-randconfig-003-20260206    gcc-14
i386        buildonly-randconfig-004-20260206    clang-20
i386        buildonly-randconfig-004-20260206    gcc-14
i386        buildonly-randconfig-005-20260206    clang-20
i386        buildonly-randconfig-006-20260206    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260206    gcc-14
i386                  randconfig-002-20260206    gcc-12
i386                  randconfig-002-20260206    gcc-14
i386                  randconfig-003-20260206    gcc-14
i386                  randconfig-004-20260206    gcc-14
i386                  randconfig-005-20260206    gcc-14
i386                  randconfig-006-20260206    gcc-14
i386                  randconfig-007-20260206    gcc-14
i386                  randconfig-011-20260205    gcc-14
i386                  randconfig-012-20260205    clang-20
i386                  randconfig-013-20260205    gcc-14
i386                  randconfig-014-20260205    clang-20
i386                  randconfig-015-20260205    gcc-14
i386                  randconfig-016-20260205    clang-20
i386                  randconfig-017-20260205    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260206    clang-22
loongarch             randconfig-002-20260206    clang-22
m68k                             alldefconfig    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                  cavium_octeon_defconfig    clang-22
mips                  decstation_64_defconfig    gcc-15.2.0
mips                           ip22_defconfig    gcc-15.2.0
mips                      malta_kvm_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260206    clang-22
nios2                 randconfig-001-20260206    gcc-8.5.0
nios2                 randconfig-002-20260206    clang-22
nios2                 randconfig-002-20260206    gcc-8.5.0
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260206    gcc-8.5.0
parisc                randconfig-002-20260206    gcc-12.5.0
parisc                randconfig-002-20260206    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                 canyonlands_defconfig    clang-22
powerpc                       eiger_defconfig    clang-22
powerpc                  iss476-smp_defconfig    clang-22
powerpc                      mgcoge_defconfig    clang-22
powerpc                      pmac32_defconfig    clang-22
powerpc               randconfig-001-20260206    gcc-8.5.0
powerpc               randconfig-002-20260206    clang-20
powerpc               randconfig-002-20260206    gcc-8.5.0
powerpc                         wii_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260206    clang-22
powerpc64             randconfig-001-20260206    gcc-8.5.0
powerpc64             randconfig-002-20260206    gcc-10.5.0
powerpc64             randconfig-002-20260206    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260205    clang-19
riscv                 randconfig-001-20260206    clang-22
riscv                 randconfig-002-20260205    clang-22
riscv                 randconfig-002-20260206    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260205    clang-18
s390                  randconfig-001-20260206    clang-22
s390                  randconfig-002-20260205    clang-22
s390                  randconfig-002-20260206    clang-22
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260205    gcc-15.2.0
sh                    randconfig-001-20260206    clang-22
sh                    randconfig-002-20260205    gcc-10.5.0
sh                    randconfig-002-20260206    clang-22
sh                   secureedge5410_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260206    gcc-8.5.0
sparc                 randconfig-002-20260206    gcc-12.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260206    gcc-10.5.0
sparc64               randconfig-002-20260206    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260206    clang-22
um                    randconfig-002-20260206    gcc-14
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260206    gcc-14
x86_64      buildonly-randconfig-002-20260206    clang-20
x86_64      buildonly-randconfig-002-20260206    gcc-14
x86_64      buildonly-randconfig-003-20260206    gcc-14
x86_64      buildonly-randconfig-004-20260206    clang-20
x86_64      buildonly-randconfig-004-20260206    gcc-14
x86_64      buildonly-randconfig-005-20260206    gcc-12
x86_64      buildonly-randconfig-005-20260206    gcc-14
x86_64      buildonly-randconfig-006-20260206    clang-20
x86_64      buildonly-randconfig-006-20260206    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260206    clang-20
x86_64                randconfig-001-20260206    gcc-14
x86_64                randconfig-002-20260206    gcc-14
x86_64                randconfig-003-20260206    gcc-14
x86_64                randconfig-004-20260206    clang-20
x86_64                randconfig-004-20260206    gcc-14
x86_64                randconfig-005-20260206    gcc-14
x86_64                randconfig-006-20260206    clang-20
x86_64                randconfig-006-20260206    gcc-14
x86_64                randconfig-011-20260205    clang-20
x86_64                randconfig-011-20260206    gcc-14
x86_64                randconfig-012-20260205    gcc-14
x86_64                randconfig-012-20260206    gcc-14
x86_64                randconfig-013-20260205    gcc-14
x86_64                randconfig-013-20260206    gcc-14
x86_64                randconfig-014-20260205    clang-20
x86_64                randconfig-014-20260206    gcc-14
x86_64                randconfig-015-20260205    gcc-14
x86_64                randconfig-015-20260206    gcc-14
x86_64                randconfig-016-20260205    clang-20
x86_64                randconfig-016-20260206    gcc-14
x86_64                randconfig-071-20260206    gcc-14
x86_64                randconfig-072-20260206    clang-20
x86_64                randconfig-072-20260206    gcc-14
x86_64                randconfig-073-20260206    gcc-14
x86_64                randconfig-074-20260206    gcc-14
x86_64                randconfig-075-20260206    clang-20
x86_64                randconfig-075-20260206    gcc-14
x86_64                randconfig-076-20260206    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.2.0
xtensa                  cadence_csp_defconfig    clang-22
xtensa                randconfig-001-20260206    gcc-9.5.0
xtensa                randconfig-002-20260206    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

