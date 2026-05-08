Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B510CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 00:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECF6F6B00D1; Thu,  7 May 2026 20:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7FBE6B00D4; Thu,  7 May 2026 20:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE296B00D6; Thu,  7 May 2026 20:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C6D986B00D1
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:48:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5CFCCA03E7
	for <linux-mm@kvack.org>; Fri,  8 May 2026 00:48:08 +0000 (UTC)
X-FDA: 84742415856.12.BD53B41
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9FCF2A000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 00:48:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IGiuNonA;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778201286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=3oqe06NDx4GoRWXOvCbb7kVi99i8T0HJ5TpOZNiswbE=;
	b=Lm9qFgGTKfN1JO1PEbvsnOBJ8kDQFyM3g2tfGZIqmqaxi5v/qTNMRCJJ8odkFaKCuLNRPK
	I5K82rxL+Di5+O+AZuQMeY9xOPNzhFopqloiS7zAUfdbT9Zv0Fm7zGJDYCs9xMiVgfjmed
	D+kCOpQRnLyMrU9DPByysWzBKRFcfKs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IGiuNonA;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778201286; a=rsa-sha256;
	cv=none;
	b=pCSjlLgF3BMglXg3Gah6+UA2qkyVLbdCf5ObDAWTTuSXGTMDpK8d/S1pDMkJKc/twnds2v
	RdvGQFMQ2a1Hd0sAWIfcoRGsTeh9drtbhxCjKYU429KXlS4tcBO8dk6VJLbi6irk/uPvX1
	B1G7jmcW9KBiFhyL67vocukRSmR+BZQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778201286; x=1809737286;
  h=date:from:to:cc:subject:message-id;
  bh=X+bUJGv3Xea7s2yqhHvZe4+TFNYvgDYlECEfQKnII6M=;
  b=IGiuNonA/vT94akTcJ86bKWBtyFulBjJJtRD+LpBCIBA28hUiqVvaB40
   TYD465fzquhBVROnMG/DOODLpOYT9PHJKcJ51kST7NuaKYvPY8xGl66lH
   F4LAeLZGguQaHUO/QD9dgpwU7ZFxqThyl+m1GXu8CKyUOd7aGFSb4R8Kc
   N66X8wTTTN7PWTtNX4JLTZ7S7OXhI2dyd8N8mK1Cij4Lni0FpXKhRkVct
   QnrNuEgIE/PeHHmfd8AOmHajqweiH/raWiulZ39mmphQRZNwMbIz76bxr
   FgRhRcrlwQyej3FFx18PLyc7NL3AsdCEddDO6L1CdZAE+G5Mm5K4o0YiR
   A==;
X-CSE-ConnectionGUID: EF9O+AN5RvWx7ffK6cpwvQ==
X-CSE-MsgGUID: aLoKEA9sQgW2w9GS7PEM3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="83013309"
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="83013309"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 17:48:04 -0700
X-CSE-ConnectionGUID: N+tz7d/WR/qQ6+3O8eNu+g==
X-CSE-MsgGUID: Leoo5Y56QnWF8IaqpxjBIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="236553957"
Received: from lkp-server01.sh.intel.com (HELO d6e19f2f5857) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 07 May 2026 17:48:00 -0700
Received: from kbuild by d6e19f2f5857 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wL9Nk-000000000f7-0yz9;
	Fri, 08 May 2026 00:47:56 +0000
Date: Fri, 08 May 2026 08:46:57 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 dm-devel@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 Thierry Reding <treding@nvidia.com>
Subject: [linux-next:master] BUILD REGRESSION
 17c7841d09ee7d33557fd075562d9289b6018c90
Message-ID: <202605080845.lfBckbvQ-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 1jz9hegbazzeqrz78w8jk1h7y5uz9h3c
X-Rspamd-Queue-Id: 9FCF2A000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778201285-833360
X-HE-Meta: U2FsdGVkX1+ktse5I+I466O5de2SUNJmTxn7DU0HemP1TifaS88qA9KSkaf93gRHODRBe5SSgP1c4qdFG66BcMOKBJUdAvzQAvIIrQQtUf9q7jqImN7mNpHJ4HGJBotLTLJ0LN/5UlfEYRhCctpBPr42ysvdpxDEGmzaTE8tRNCLG0gtHWcVpKZ3/clDYC0X/dUMYtpyp9gz+fd8v+6VTL61DhqCP3b9ACDHR0qiRKjIP9YPrWY5D7ELKVb0zqUWRtI8HSAc+7LEpTazkRz30qoPHs/lZE6mxDmdIpvHk5L19+ya+zZQ8iHagmvejgBQ37OB8kmpwNxXzTtj5uZJ/Ea6VQaSi3QDMVCeQ2suDID8a8lFgLOga2SJhV+lZKx2kTKUzdpIWb5urIQYX0Hs6ls0JDFF4+h9JXwperMQ+KqU7NtKYnmCJ+Qume4PJ+2WXEDulmmfM8BwBNbb/DRdkzpSAh+pDBkDtdYdcPg3b7oKc/8QgsoaNG9NXz3zUvKahQcnd+e+Ux+4bxpgeBEy1hgvk0GpZDuxzBicrV4VrwMQIKo9YqY4LnsEa9wzmL79rpsEVlwf1xll3HT2XZ9Lplar2+dGibVBt84qKLT3UZm1FOPxfgYGH+r1t+CNR4zWj5UH3hcr8T485lklTJt61q3htky8DIL7RyZ7f4xOmEpKOejIj7bUhj6jW6jHW9ICX9NQmHsKFC9z2o9PkU7Qsje3z/7EJ1xkcvfPq3300GVDzHxBH4vGjgo0uOpBYlXplkp92Txytqilsq1m8ej/kBJJhiNhOzwQyyCT3Oaeab9eLP+6GoriuRs4fPTkffqwy2xc4KrDBgPpyWpbNjDXGHctQyZOGPkrmP/uHskl+/Ci1BFUpDkc7K8mpFm1B/73WptxomLXlQkSAeEPjig9DBzodVh1qcwiY+9A6joDO5MR++qUzreyYlufJyFCd1SuQcO/rNO7l1AXbRrczNk
 yBRDmLLT
 PgfU9kLsbhRdHIWJJvl5CH18P5bUFNVgDyW31NZVJ1Nb8GZy3GpL1QUKwQJRoFHq2sHbfQr2C5KChLMSA3oAd22IksS3k507Tv59GT3cABXkSnqLcM+zEghfG1Shoa+CCFCNrHTLdFCkUpWbHm8ZYP1ZMMcyBPDR3bwejKdE96CgsDWcRKoLYyQNphw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 17c7841d09ee7d33557fd075562d9289b6018c90  Add linux-next specific files for 20260507

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202605072335.vIeZwrl0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202605080638.NXLkvBwM-lkp@intel.com

    ERROR: modpost: "__aeabi_ldivmod" [sound/soc/tegra/snd-soc-tegra210-mixer.ko] undefined!
    ERROR: modpost: "__aeabi_uldivmod" [sound/soc/tegra/snd-soc-tegra210-mixer.ko] undefined!
    drivers/md/dm-inlinecrypt.c:329 inlinecrypt_ctr() warn: error code type promoted to positive: 'ctx->key_size'
    ld.lld: error: call to __compiletime_assert_343 marked "dontcall-error": BUILD_BUG failed
    ld.lld: error: undefined symbol: crypto_register_rng

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202605080719.1aBMAYBS-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202605080740.0iDqLAUR-lkp@intel.com

    Warning: arch/mips/cavium-octeon/executive/cvmx-boot-vector.c:155 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    drivers/platform/x86/hp/hp-wmi.c:391 rpm_to_pwm() warn: signedness bug returning '(-65025)'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-001
|   |-- ERROR:__aeabi_ldivmod-sound-soc-tegra-snd-soc-tegra210-mixer.ko-undefined
|   `-- ERROR:__aeabi_uldivmod-sound-soc-tegra-snd-soc-tegra210-mixer.ko-undefined
|-- hexagon-randconfig-r073-20260508
|   |-- drivers-md-dm-inlinecrypt.c-inlinecrypt_ctr()-warn:error-code-type-promoted-to-positive:ctx-key_size
|   `-- drivers-md-dm-inlinecrypt.c-inlinecrypt_ctr()-warn:unsigned-ctx-key_size-is-never-less-than-zero.
|-- i386-randconfig-r061-20260508
|   `-- ld.lld:error:call-to-__compiletime_assert_NNN-marked-dontcall-error:BUILD_BUG-failed
|-- loongarch-randconfig-002-20260507
|   `-- ld.lld:error:undefined-symbol:crypto_register_rng
|-- mips-randconfig-r131-20260507
|   `-- Warning:arch-mips-cavium-octeon-executive-cvmx-boot-vector.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
`-- x86_64-randconfig-161-20260507
    `-- drivers-platform-x86-hp-hp-wmi.c-rpm_to_pwm()-warn:signedness-bug-returning

elapsed time: 754m

configs tested: 192
configs skipped: 8

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260508    gcc-13.4.0
arc                   randconfig-002-20260508    gcc-12.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260508    gcc-8.5.0
arm                   randconfig-002-20260508    gcc-10.5.0
arm                   randconfig-003-20260508    gcc-14.3.0
arm                   randconfig-004-20260508    gcc-13.4.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260507    clang-23
arm64                 randconfig-002-20260507    gcc-13.4.0
arm64                 randconfig-003-20260507    clang-23
arm64                 randconfig-004-20260507    gcc-8.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260507    gcc-15.2.0
csky                  randconfig-002-20260507    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260507    clang-23
hexagon               randconfig-002-20260507    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260507    gcc-14
i386        buildonly-randconfig-001-20260508    gcc-14
i386                 buildonly-randconfig-002    clang-20
i386        buildonly-randconfig-002-20260507    gcc-14
i386        buildonly-randconfig-002-20260508    gcc-14
i386                 buildonly-randconfig-003    clang-20
i386        buildonly-randconfig-003-20260507    gcc-14
i386        buildonly-randconfig-003-20260508    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260507    gcc-14
i386        buildonly-randconfig-004-20260508    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260507    clang-20
i386        buildonly-randconfig-005-20260508    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260507    gcc-14
i386        buildonly-randconfig-006-20260508    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260508    clang-20
i386                  randconfig-002-20260508    gcc-14
i386                  randconfig-003-20260508    clang-20
i386                  randconfig-004-20260508    gcc-14
i386                  randconfig-005-20260508    gcc-12
i386                  randconfig-006-20260508    gcc-14
i386                  randconfig-007-20260508    clang-20
i386                  randconfig-011-20260508    clang-20
i386                  randconfig-012-20260508    gcc-13
i386                  randconfig-013-20260508    clang-20
i386                  randconfig-014-20260508    gcc-14
i386                  randconfig-015-20260508    clang-20
i386                  randconfig-016-20260508    clang-20
i386                  randconfig-017-20260508    gcc-13
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260507    clang-23
loongarch             randconfig-002-20260507    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
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
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260507    gcc-9.5.0
nios2                 randconfig-002-20260507    gcc-10.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260507    gcc-8.5.0
parisc                randconfig-002-20260507    gcc-11.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260507    clang-16
powerpc               randconfig-002-20260507    clang-23
powerpc64             randconfig-001-20260507    clang-23
powerpc64             randconfig-002-20260507    gcc-15.2.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260507    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260507    gcc-13.4.0
s390                  randconfig-002-20260507    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                 kfr2r09-romimage_defconfig    gcc-15.2.0
sh                    randconfig-001-20260507    gcc-10.5.0
sh                    randconfig-002-20260507    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260507    gcc-8.5.0
sparc                 randconfig-002-20260507    gcc-12.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260507    clang-23
sparc64               randconfig-002-20260507    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260507    gcc-13
um                    randconfig-002-20260507    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260507    clang-20
x86_64      buildonly-randconfig-001-20260508    gcc-14
x86_64      buildonly-randconfig-002-20260507    clang-20
x86_64      buildonly-randconfig-002-20260507    gcc-13
x86_64      buildonly-randconfig-002-20260508    clang-20
x86_64      buildonly-randconfig-003-20260507    clang-20
x86_64      buildonly-randconfig-003-20260507    gcc-14
x86_64      buildonly-randconfig-003-20260508    gcc-14
x86_64      buildonly-randconfig-004-20260507    clang-20
x86_64      buildonly-randconfig-004-20260508    clang-20
x86_64      buildonly-randconfig-005-20260507    clang-20
x86_64      buildonly-randconfig-005-20260508    gcc-14
x86_64      buildonly-randconfig-006-20260507    clang-20
x86_64      buildonly-randconfig-006-20260507    gcc-14
x86_64      buildonly-randconfig-006-20260508    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260507    gcc-14
x86_64                randconfig-002-20260507    clang-20
x86_64                randconfig-003-20260507    gcc-14
x86_64                randconfig-004-20260507    gcc-14
x86_64                randconfig-005-20260507    clang-20
x86_64                randconfig-006-20260507    clang-20
x86_64                randconfig-072-20260508    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260507    gcc-15.2.0
xtensa                randconfig-002-20260507    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

