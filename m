Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D449AEFD23F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 05:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53F46B0088; Thu, 26 Feb 2026 00:32:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B019F6B0089; Thu, 26 Feb 2026 00:32:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0DA36B008A; Thu, 26 Feb 2026 00:32:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87D3A6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:32:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F6381CD00
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:32:53 +0000 (UTC)
X-FDA: 84485488626.16.D725064
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf28.hostedemail.com (Postfix) with ESMTP id 85A43C0009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:32:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JBPgsVTu;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772083971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=WfcdQPWUJPtGC7uaQIlCmi2znchnoQm4eiyqjxFkp28=;
	b=qqLqBEgoZDkRSAdTE5xlA7r0IUDEToklX3E/hIX4mugmYAiYErbZe6laQ+4aFLibOouo7I
	8n1gB7JJJkZHCDnzHxwf+uXHOG4OoPt7z13ivn4FJ7AV8Irptzt+NV8se5IUxuYmmCiM6u
	6OH8OMDfoXIglfYsHrVbVyi1iBhfobM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772083971; a=rsa-sha256;
	cv=none;
	b=ggEl7uu7B3697yarGyyFEzYpZefN5uPHAVqLyKLKYGh2COtM9a+C6OKnApf3TADyd6zopk
	Oom/QZusqXiGOPInmMJQku1u3woRZvXbPStoS2350R9smkjlbSBgaBvaWgpKkdDViva9Io
	Le7lePpzdIqCGSvSvAAX1AFm5Z3pTEQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JBPgsVTu;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772083970; x=1803619970;
  h=date:from:to:cc:subject:message-id;
  bh=HYCIbx6Z/g80VtD4UK17+ji1DxtMSxIfMmkef05vAmM=;
  b=JBPgsVTuB0+kOStBi1rnDfYFdnWAYBBH3KEQ0CNJWsAxFg4cnh8DGkfA
   aCBqnAYzTca+nAjTIlHFSzFlhcmV+KFAMucQ/ymYYNoV0H0RNrfmdlynG
   PbghDtRW5/qAk2qHhGC7gKuuP1MEEf1QsUvEYSlaJcPmtpai+1kcBIFc7
   RPbozVY8XwwrHThcH0tNlHJHsvysZR0DICj2R8pmrgHcvRrPU/RhTs3tx
   Ak+YanCrxzVdECROP7lRh5aIkSjf5jr8VLgUr5/Sxpg/bAU3q1vkiYunT
   J8jO/nCqquYJoMJMNhhuI2E6oeErb8iTOwYlMlKH5JE6EuYA0x1DfWVcW
   Q==;
X-CSE-ConnectionGUID: OBOXpkz7R32Yt1QH+RGwBQ==
X-CSE-MsgGUID: TgMeAOmaQpaeZfj3P201hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="83844641"
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="83844641"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 21:32:46 -0800
X-CSE-ConnectionGUID: qYp8v4nFSFe20q7CHIRNUA==
X-CSE-MsgGUID: vB4WdhxHTuGfrgVZyFk6PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="215561790"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 25 Feb 2026 21:32:45 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vvTz8-000000008DF-0W30;
	Thu, 26 Feb 2026 05:32:30 +0000
Date: Thu, 26 Feb 2026 13:32:17 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 877552aa875839314afad7154b5a561889e87ea9
Message-ID: <202602261307.jrNoCNug-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 85A43C0009
X-Stat-Signature: bz3o3x3nji5w88eyok17m9zqtuk4m5a3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772083969-308104
X-HE-Meta: U2FsdGVkX19IwjDTRMMfFHmFuI2V+SGm9UIgo3DrqNyRcfHtNh75DErni5fawjAxJVCxpuwVY3q+mroYD3zHs3j/DT4KlTx65cz4kgAQVGtslgh1lE55KEpMUgm8+AAZXc6m/+zLQXgH6piJ5JAJIDL8Sw1XeG3r43U0BzEbfzAItnP9noGLqzrE7HIRGWUUb1s44qRFzEvz0X8wiLAJ+4oN8cKDrR7E3fJlTOYNx/juzqNy69OjH+FDJQq5JSlZtGynrneLDN6cPeMpe4bT14VzdsoyeYoXsIcGu1aaI1T02ZQtES5lYv5D+xen5xHGCKOwiX1fyRElKVYA6d/4CHXgEQQfBycrn3aC+BWnNmwpTikbNRwDdLjjKJikT4Iwu5dtvVcBdpwfYbV22nPKJ4czOP9WQ5/IeV0tPq6m72MdcpTcTzBfU3lnFDh8lShJC/VkAbRNVSCFoPyEvEa70S9WaygsJP3wHWdUtQ35T2IOBoAyIFRT+d/xBGWZS84P/ihVTmWVJfuhuC9vNeq9sANe/F3+9O8YG0UpMQSsN5MrjcB5rtb2eavlmOz6hhreNzo1thr2HQcPqulBIwE7p7J+6jjkvgUV0XW49dJRHGSjhx82gPzJ7lzQEUmQn+RLGZm4KGem/MxNgiEr8B1ykmQWqIFg9FQISrByBFUY3k2lK0EgGLOnhQJt+fwpt+sPdB2NyoFYR8IIez5aovq3j6eAar1tIzgS8J7VYCz6lQ+EY8qEJugW012LIavWFWv46WAgiCsy+2YnIaAjlDU5UNffxiJrOOtt5eWrQCWpRZ20PVhghyOf24BDax95VsPZbj8Y1Dlnf6V1dsrqQ43W4LWdCaJzjxDzKRb2IeF2wVZEv6g5hb1eZf+UlJiY1uFWxb6cRRsm+HPIcnDrPMqSEvVfFfJJHZEKnj7x53eZRQNV1iod/dw6Lq5giaMjILtbq42gzeBG8rqN99PYCgA
 EfEHEgPY
 UQvbRFkOkI0nhP6Zwm9CMGyk/yOrv9VIplcGI9gO3ElhrfC0dmpjiOLpKexzQnVzazJGJhRWqjkEZwHVRGGy2htVxIQO90v4MtOnkgrhFBRsWgO0mC9rGseszfrLNHWnifxREPx5OnHXfyiI0ivvAkJuZ1yC5xh/6XCKRUTEZmrt5k1ckVviH9O2Xxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 877552aa875839314afad7154b5a561889e87ea9  Add linux-next specific files for 20260225

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202602261159.qUe6cVxU-lkp@intel.com

    ERROR: modpost: "__aeabi_ldivmod" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
    ERROR: modpost: "__aeabi_uldivmod" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
    ld.lld: error: undefined symbol: __udivdi3

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-001-20260226
|   |-- ERROR:__aeabi_ldivmod-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|   `-- ERROR:__aeabi_uldivmod-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- i386-randconfig-003-20260226
|   `-- ld.lld:error:undefined-symbol:__udivdi3
`-- x86_64-randconfig-121-20260224
    `-- drivers-gpu-drm-i915-i915_request.h:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):

elapsed time: 744m

configs tested: 260
configs skipped: 4

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
arc                         haps_hs_defconfig    gcc-15.2.0
arc                   randconfig-001-20260226    gcc-15.2.0
arc                   randconfig-002-20260226    gcc-15.2.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                       aspeed_g4_defconfig    gcc-15.2.0
arm                       aspeed_g5_defconfig    gcc-15.2.0
arm                         axm55xx_defconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                            dove_defconfig    gcc-15.2.0
arm                        multi_v5_defconfig    gcc-15.2.0
arm                          pxa3xx_defconfig    gcc-15.2.0
arm                   randconfig-001-20260226    gcc-15.2.0
arm                   randconfig-002-20260226    gcc-15.2.0
arm                   randconfig-003-20260226    gcc-15.2.0
arm                   randconfig-004-20260226    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260226    gcc-14.3.0
arm64                 randconfig-002-20260226    gcc-14.3.0
arm64                 randconfig-002-20260226    gcc-8.5.0
arm64                 randconfig-003-20260226    clang-16
arm64                 randconfig-003-20260226    gcc-14.3.0
arm64                 randconfig-004-20260226    clang-23
arm64                 randconfig-004-20260226    gcc-14.3.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260226    gcc-14.3.0
csky                  randconfig-001-20260226    gcc-9.5.0
csky                  randconfig-002-20260226    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260226    clang-23
hexagon               randconfig-002-20260226    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260226    clang-20
i386        buildonly-randconfig-001-20260226    gcc-14
i386        buildonly-randconfig-002-20260226    clang-20
i386        buildonly-randconfig-002-20260226    gcc-14
i386        buildonly-randconfig-003-20260226    clang-20
i386        buildonly-randconfig-003-20260226    gcc-14
i386        buildonly-randconfig-004-20260226    gcc-14
i386        buildonly-randconfig-005-20260226    gcc-14
i386        buildonly-randconfig-006-20260226    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260226    clang-20
i386                  randconfig-001-20260226    gcc-14
i386                  randconfig-002-20260226    clang-20
i386                  randconfig-003-20260226    clang-20
i386                  randconfig-004-20260226    clang-20
i386                  randconfig-005-20260226    clang-20
i386                  randconfig-005-20260226    gcc-13
i386                  randconfig-006-20260226    clang-20
i386                  randconfig-007-20260226    clang-20
i386                  randconfig-011-20260226    clang-20
i386                  randconfig-011-20260226    gcc-14
i386                  randconfig-012-20260226    clang-20
i386                  randconfig-012-20260226    gcc-14
i386                  randconfig-013-20260226    gcc-12
i386                  randconfig-013-20260226    gcc-14
i386                  randconfig-014-20260226    gcc-14
i386                  randconfig-015-20260226    gcc-14
i386                  randconfig-016-20260226    clang-20
i386                  randconfig-016-20260226    gcc-14
i386                  randconfig-017-20260226    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                loongson32_defconfig    clang-23
loongarch             randconfig-001-20260226    clang-23
loongarch             randconfig-001-20260226    gcc-15.2.0
loongarch             randconfig-002-20260226    clang-20
loongarch             randconfig-002-20260226    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                       m5249evb_defconfig    gcc-15.2.0
m68k                          multi_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                        bcm47xx_defconfig    gcc-15.2.0
mips                          eyeq6_defconfig    gcc-15.2.0
mips                      malta_kvm_defconfig    gcc-15.2.0
mips                        maltaup_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260226    clang-23
nios2                 randconfig-001-20260226    gcc-11.5.0
nios2                 randconfig-002-20260226    clang-23
nios2                 randconfig-002-20260226    gcc-11.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
openrisc                       virt_defconfig    gcc-15.2.0
parisc                           alldefconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260226    clang-16
parisc                randconfig-001-20260226    gcc-14.3.0
parisc                randconfig-002-20260226    clang-16
parisc                randconfig-002-20260226    gcc-12.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                        fsp2_defconfig    gcc-15.2.0
powerpc                        icon_defconfig    gcc-15.2.0
powerpc                      pcm030_defconfig    clang-23
powerpc               randconfig-001-20260226    clang-16
powerpc               randconfig-001-20260226    gcc-11.5.0
powerpc               randconfig-002-20260226    clang-16
powerpc64             randconfig-001-20260226    clang-16
powerpc64             randconfig-001-20260226    gcc-8.5.0
powerpc64             randconfig-002-20260226    clang-16
powerpc64             randconfig-002-20260226    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260226    clang-23
riscv                 randconfig-002-20260226    clang-23
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260226    clang-23
s390                  randconfig-002-20260226    gcc-8.5.0
s390                       zfcpdump_defconfig    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260226    gcc-15.2.0
sh                    randconfig-002-20260226    gcc-15.2.0
sh                        sh7785lcr_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260226    gcc-8.5.0
sparc                 randconfig-002-20260226    gcc-8.5.0
sparc                       sparc64_defconfig    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260226    clang-23
sparc64               randconfig-001-20260226    gcc-8.5.0
sparc64               randconfig-002-20260226    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260226    clang-23
um                    randconfig-001-20260226    gcc-8.5.0
um                    randconfig-002-20260226    gcc-13
um                    randconfig-002-20260226    gcc-8.5.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260226    gcc-14
x86_64      buildonly-randconfig-002-20260226    clang-20
x86_64      buildonly-randconfig-002-20260226    gcc-14
x86_64      buildonly-randconfig-003-20260226    gcc-14
x86_64      buildonly-randconfig-004-20260226    clang-20
x86_64      buildonly-randconfig-004-20260226    gcc-14
x86_64      buildonly-randconfig-005-20260226    gcc-14
x86_64      buildonly-randconfig-006-20260226    gcc-13
x86_64      buildonly-randconfig-006-20260226    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260226    gcc-14
x86_64                randconfig-002-20260226    gcc-14
x86_64                randconfig-003-20260226    gcc-14
x86_64                randconfig-004-20260226    gcc-14
x86_64                randconfig-005-20260226    gcc-14
x86_64                randconfig-006-20260226    gcc-14
x86_64                randconfig-011-20260226    gcc-14
x86_64                randconfig-012-20260226    gcc-14
x86_64                randconfig-013-20260226    gcc-14
x86_64                randconfig-014-20260226    gcc-14
x86_64                randconfig-015-20260226    gcc-14
x86_64                randconfig-016-20260226    gcc-14
x86_64                randconfig-071-20260226    clang-20
x86_64                randconfig-071-20260226    gcc-14
x86_64                randconfig-072-20260226    clang-20
x86_64                randconfig-072-20260226    gcc-14
x86_64                randconfig-073-20260226    gcc-14
x86_64                randconfig-074-20260226    clang-20
x86_64                randconfig-074-20260226    gcc-14
x86_64                randconfig-075-20260226    gcc-13
x86_64                randconfig-075-20260226    gcc-14
x86_64                randconfig-076-20260226    clang-20
x86_64                randconfig-076-20260226    gcc-14
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
xtensa                       common_defconfig    gcc-15.2.0
xtensa                randconfig-001-20260226    gcc-8.5.0
xtensa                randconfig-001-20260226    gcc-9.5.0
xtensa                randconfig-002-20260226    gcc-8.5.0
xtensa                    smp_lx200_defconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

