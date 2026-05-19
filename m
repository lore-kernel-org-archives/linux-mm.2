Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D67DCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 05:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC89E6B0005; Tue, 19 May 2026 01:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78E06B0088; Tue, 19 May 2026 01:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967E46B008C; Tue, 19 May 2026 01:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3EA6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:18:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE3791C0820
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:17:59 +0000 (UTC)
X-FDA: 84783012678.18.576CF96
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4EF2320005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:17:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="h/Go63uI";
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779167877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=riE1vXPERlj3/f+oxwVtJApRXHWqSPs0qUNfWn6I6sM=;
	b=gpqh1iWLMWhJFsWV0mUSCf0q5xSUAwElDq0uYyLiJ9cdd5asIqJtwchvCeLM+jahFQtK1z
	H5WE/XEmqdZahQac0RWBK8cwGPru+pH1UUEYXlGxfOEQ3TwPHDVUXRX/6tPnaidOMgvqKD
	YxS7l+3ARdb1r2eiur8jmiLLOLLRoWQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="h/Go63uI";
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779167877; a=rsa-sha256;
	cv=none;
	b=lqJBNCZw2bs+Id0kMRfJTtsAmwL0d0kA2zrsh/+UqnVJq4/WJsE5zXeT0QTU8YFiXag7CP
	bT8hby8rPufDiQkxjBfbebRVclbdsgH3Hm2uRIXP+IRTJtRUkAPcsmByH9Y4Y/KeK0Fena
	Ic0QEwHpXud5PeevXM0J/KhRuaw/f1Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779167877; x=1810703877;
  h=date:from:to:cc:subject:message-id;
  bh=V5r+lRh0VHhw5B82RiRIASmQ3EGoV8OdxHVWCEt29zM=;
  b=h/Go63uIanDWDt5PFrjv0WOBoAU01o/xNsJZ98i9N8bWWovcGADEcqUs
   XijyuhKGblQqUUVIkNvwchqAwVAAVypSPfLTbEl72HYb+TLq2bb7Cv/Eb
   T0sAY23BOr0Csl1dvwjL4C+Ty6v4RhDMWQ3efM0mv4FqCXvIN8TSxPCBp
   YwFlPLHjAiinXxi3NgCR7X+cQTA+oE7WbRskWGAlLxe3CqrWb7lPtG5wS
   Ia3/N8dUJ5SGr3RmgVDoIK+ymHzDu84TalNgA3ZmMIsuDoK+N2U4nLC1R
   vTmSvmMbsWenQKW8xaEq6HgxCJQgkzA98VPNBgZBbOudanfWMPGLR2ex1
   w==;
X-CSE-ConnectionGUID: ouR8IN12QfKcvFqFr2IYFg==
X-CSE-MsgGUID: ugbq6DAoQseZmwaMR8eTTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11790"; a="90342200"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="90342200"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2026 22:17:56 -0700
X-CSE-ConnectionGUID: BapM14N3TzOx+eNFS9AjAQ==
X-CSE-MsgGUID: yhxbqsjCT7G56I4TngHaYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="239527656"
Received: from lkp-server02.sh.intel.com (HELO 30e86e9c1927) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 18 May 2026 22:17:55 -0700
Received: from kbuild by 30e86e9c1927 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wPCq0-000000000Vj-1GfH;
	Tue, 19 May 2026 05:17:52 +0000
Date: Tue, 19 May 2026 13:16:31 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 80dd246accce631c328ea43294e53b2b2dd2aa32
Message-ID: <202605191322.oh2eJvRl-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: w837fp4uiqnutuakqngd6x6usjesyk6x
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4EF2320005
X-Rspam-User: 
X-HE-Tag: 1779167877-714923
X-HE-Meta: U2FsdGVkX19Bc2woqsBYX8wWGJpa/9GNiKMmLe770FuuGkc90+gAQKcTPEr1QcOCxymHRV7MIJnOsKMbZjiycYOY2Woen4Gol9QKgTpPHI4gy09V+UuBKwZrFwgIc1+NIznIb5li1bfoc5KH8L+Lu3bK7eobo4Psq/2vtMOjydwHldKn8jR26UrPuqIwDbmMzg9tCFgTgNb1+j9Kw0Q32dxDAoal7kbxwbueFURSI6XSVla7eALCAfbMxgTxEHHB8M1vj/Kr5EMlR34HhaP3Tfm/OFaM5ePKuDCaXR4WR8AD1TYf2N71sYpUywQtGtl1H2j7/7Ug3h7nGd6UPpegh7WFDGXFM3MHRIj84WMjN9ayM9Kv7uS9qEvbfU//+Z2UDYGl7kHMtNDlqlmdTtv5v3LbSn/2bjdSVdcA2DsfGcRT1yFuflewyke+KdPVevlHlARx7dVQEy/lFCWnAptZgmdskhZREGkWJeBR6sawNzDc7tE9wDmeU7q3zmZ9xgskMh6UMAtGzRo8MrC+yFl1ILRyfjFHOLigcNP56+xoAeIXM0ApP/Rjolbwf4ozw3PcZMgVftuDDsfGdhGOnhCGskNgpELP8Fx4L03ghSKdsnViFDOrx3bNDn+WAvPWHXDM3ow+Tod8SpZi/NIqFf/Iq8UJkL+OtV+zFACy8yLFTvrteTtEwpXAAG1F/X24JFddwypPDPWQpHrEwrp89NERf7kPagzHlw2p0kKgWvomAFLvc6HFIrJCM2yyLi8eHYDMKy37fxEYv7/o5G2Jse9/THbQyY3+vR6ZpAL4jlAuuLV2wQdnuYIU9vf4tJFfQZTwDTvakGSFvH8FebBiLW1pzNuqN8CHZxBWl6vkoP1d/UNPG10YYnq3RRCpwOau34/C2kD+lNRMBOs8KIg5mk+sqziQNF+VLw3abA8CX4sLupX9S278aPoQet9VPDrB2X6JaK7iGCWeB7389Hn77cf
 d6Ug2KSF
 thkV2mhVboS63ChL+jQ2STk+DMaoMjdm45/DLiAvQ6a6Q0IunrO6YpJAFktAgG/dhGcdYC9QwF2qx8heS4Y4Mvsk6DwyhF9SfAvhHKn6sPqJ3ia0LKkmaGWP7MmG+8kNkyfoK5jw9FEfUyR/jlA8WbYTpGSHqtzJ/251/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 80dd246accce631c328ea43294e53b2b2dd2aa32  Add linux-next specific files for 20260518

elapsed time: 751m

configs tested: 203
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260519    gcc-9.5.0
arc                   randconfig-002-20260519    gcc-10.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260519    clang-23
arm                   randconfig-002-20260519    clang-23
arm                   randconfig-003-20260519    clang-23
arm                   randconfig-004-20260519    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260519    clang-18
arm64                 randconfig-002-20260519    gcc-11.5.0
arm64                 randconfig-003-20260519    gcc-8.5.0
arm64                 randconfig-004-20260519    gcc-9.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260519    gcc-12.5.0
csky                  randconfig-002-20260519    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260519    clang-23
hexagon               randconfig-002-20260519    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260519    gcc-12
i386        buildonly-randconfig-002-20260519    gcc-12
i386        buildonly-randconfig-002-20260519    gcc-14
i386        buildonly-randconfig-003-20260519    clang-20
i386        buildonly-randconfig-003-20260519    gcc-12
i386        buildonly-randconfig-004-20260519    gcc-12
i386        buildonly-randconfig-004-20260519    gcc-14
i386        buildonly-randconfig-005-20260519    gcc-12
i386        buildonly-randconfig-005-20260519    gcc-14
i386        buildonly-randconfig-006-20260519    clang-20
i386        buildonly-randconfig-006-20260519    gcc-12
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260519    gcc-14
i386                  randconfig-002-20260519    gcc-14
i386                  randconfig-003-20260519    gcc-14
i386                  randconfig-004-20260519    gcc-14
i386                  randconfig-005-20260519    gcc-12
i386                  randconfig-006-20260519    clang-20
i386                  randconfig-007-20260519    clang-20
i386                  randconfig-011-20260519    clang-20
i386                  randconfig-012-20260519    clang-20
i386                  randconfig-013-20260519    gcc-14
i386                  randconfig-014-20260519    clang-20
i386                  randconfig-015-20260519    clang-20
i386                  randconfig-016-20260519    clang-20
i386                  randconfig-017-20260519    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260519    clang-18
loongarch             randconfig-002-20260519    gcc-15.2.0
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
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260519    gcc-11.5.0
nios2                 randconfig-002-20260519    gcc-10.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260519    gcc-12.5.0
parisc                randconfig-002-20260519    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                       holly_defconfig    clang-23
powerpc               randconfig-001-20260519    clang-23
powerpc               randconfig-002-20260519    gcc-8.5.0
powerpc64             randconfig-001-20260519    clang-23
powerpc64             randconfig-002-20260519    gcc-14.3.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260519    gcc-8.5.0
riscv                 randconfig-002-20260519    clang-17
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260519    clang-23
s390                  randconfig-002-20260519    clang-18
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260519    gcc-15.2.0
sh                    randconfig-002-20260519    gcc-13.4.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260519    gcc-14.3.0
sparc                 randconfig-002-20260519    gcc-11.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260519    gcc-8.5.0
sparc64               randconfig-002-20260519    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260519    clang-23
um                    randconfig-002-20260519    clang-23
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260519    gcc-14
x86_64      buildonly-randconfig-002-20260519    gcc-14
x86_64      buildonly-randconfig-003-20260519    clang-20
x86_64      buildonly-randconfig-003-20260519    gcc-14
x86_64      buildonly-randconfig-004-20260519    clang-20
x86_64      buildonly-randconfig-004-20260519    gcc-14
x86_64      buildonly-randconfig-005-20260519    gcc-14
x86_64      buildonly-randconfig-006-20260519    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260519    gcc-14
x86_64                randconfig-002-20260519    gcc-13
x86_64                randconfig-003-20260519    clang-20
x86_64                randconfig-004-20260519    clang-20
x86_64                randconfig-005-20260519    clang-20
x86_64                randconfig-006-20260519    clang-20
x86_64                randconfig-011-20260519    gcc-14
x86_64                randconfig-012-20260519    clang-20
x86_64                randconfig-013-20260519    clang-20
x86_64                randconfig-014-20260519    gcc-14
x86_64                randconfig-015-20260519    clang-20
x86_64                randconfig-016-20260519    clang-20
x86_64                randconfig-071-20260519    gcc-14
x86_64                randconfig-072-20260519    gcc-12
x86_64                randconfig-073-20260519    gcc-14
x86_64                randconfig-074-20260519    gcc-14
x86_64                randconfig-075-20260519    gcc-14
x86_64                randconfig-076-20260519    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260519    gcc-10.5.0
xtensa                randconfig-002-20260519    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

