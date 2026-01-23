Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10019D6CFAD
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 05:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715E06B03C4; Fri, 23 Jan 2026 00:50:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3226B03C6; Fri, 23 Jan 2026 00:50:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE8A6B03C7; Fri, 23 Jan 2026 00:50:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A15A6B03C4
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:50:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 014D8C175F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:50:40 +0000 (UTC)
X-FDA: 84362154282.14.75D6B6F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5FC8E40011
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:50:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SV97tMS2;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769147439; a=rsa-sha256;
	cv=none;
	b=KDtSHIeNa75v4NUnoaM1wqSWmqQkE+PBVupbYGr5bd21Isz4fFe7jRfDhoTLvpGDtcnKLE
	M0XOD1h47NI6kHu16rij8aZFr85Ia9T3yVQJRmn54kcJsusl8XATWVJUrR0Oup+rXyQ3DG
	i0k/6cxQv6S+EYVJ+YZOFNV9xQPI9tM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SV97tMS2;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769147439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=5zdU8neo0oNF6OgDfLPXeOJTOND+XOZAF3VjMg008Xk=;
	b=cnVmd3NWfAB395QeDX76y832goVl/WVJwBPvAqnUcwQR5O2CH5VYTINyRMKWFCZAhzdGPH
	wvEShKqROoyND2IFvur4bDqimZeDCx0pSBQgsO33QzLvXkqF+WCTmNRdWse3mPfBpTIWaM
	3I7lUBte5IctNow67Z7lVwmF8juOxpc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769147439; x=1800683439;
  h=date:from:to:cc:subject:message-id;
  bh=n4TzlSep9it5sWikdL7feELXYF8eqldxxI7hHQ7EPlY=;
  b=SV97tMS2oDLTZcsZLRnoFQCmVFJizcBe+5qfruxE2vBHPJs/RPxa/Q/y
   m9mjBErZ3LRP4+GjVgaYP5mtQmPcnPBVXG2DyDfnVQICVBQT819cNjito
   sr01cjmZ5meYSsvh+tpFUUsYNL5aguUNrhas93lLIgkihF9TZRM6Cr5Ff
   SSSJgXPga4fhmtnuUjJYzpMmlYsA3v437cEcR9SNCOXj3j9TzpiZqegxV
   rqeQEqRF/03IihM0jCTTHLCyYUldfT8rbohOvyYiID4Ha9mEHWmCHAoyg
   HjXsk447yOZdy/0mGWg2EoOhcZ2jLNXxrjlHkDtChntlETvw30suuu+Tx
   w==;
X-CSE-ConnectionGUID: /GjXw/zVQfi6FUMX3ngmQA==
X-CSE-MsgGUID: rS2waDO1SiaZ7jPHyN69RQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="70315032"
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="70315032"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 21:50:37 -0800
X-CSE-ConnectionGUID: x8bsiXubS5SC3c0dPzlp6A==
X-CSE-MsgGUID: 13nLd8vyTbGY996zhIJ8+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="206549136"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 22 Jan 2026 21:50:35 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vjA40-00000000TZe-3hhj;
	Fri, 23 Jan 2026 05:50:32 +0000
Date: Fri, 23 Jan 2026 13:49:38 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 a0c666c25aeefd16f4b088c6549a6fb6b65a8a1d
Message-ID: <202601231331.Q5WjVOHZ-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5FC8E40011
X-Stat-Signature: 5fybozpyotoz8j7nnzznnc9onqa4z63n
X-HE-Tag: 1769147438-449325
X-HE-Meta: U2FsdGVkX1/LJTJ0rSXMZI1M96dbnE9fyASK7Ie+Q02Zbba7VgNJyVnHHNG1GLUHOyQ8FjVQWosAvpvSy2RHbvybfnZjJCD2eIDb7cFA17zXqLpaSmUrJy8zLJ1k9eXHjIgAz1A/kM8DQ2vZwWoLNQV2yy2adjJ45iByDduJLy8hW0Hjs+91HfmPHXkZiGxAm+o25APyOp2pGbfRs064tgzn5STBydsvR+1WGE+fET0elKiht8JsgVzPAQgHLfg3olb1JYY35VASxKrQaFKU2gkSM0y4PIt2g/ph806NbaGn5zi2E9LXCDJS2tZbnsWwHqNQ5Gt+EspRtQdCX0geMBDv8ihnNoLUg1ZZpG6BhwKMtldVe5rR6+pcZs9ZvpC0UiAXecmj6/riTwpAGoeNiI3laO5rKq8DKtt0COwoL28vqMGDS7v87O/gVeMtR0ostwNYRZaLIpfGgGVg8UDW/uPlmTzg+fbO0hpt5OOkXtBt8+BXXl9R2vQCESEXh5/5DqB66LCBRH6BVfguK4RkDvm2CtKUYp4a4HRwr0PAHKNtQlm3vkhyYHrV458m/+0/WgSHpg+6C/eIrIFii2xNZHx2KGyfE4LI9n4bObAhFBDPpXKK/22Pblh16plJGHU6jxb38rhzu4xLNyxsrHFtTlq5AUrVSGo/OsKxHL4ItQPfS5baVPEcuDPg3hQEumH0DU3PxIZCBoeSXMUcVoiFBOUdnfRqHTAGn3u1cyYcCo4pdoHV9laGDz4lWQLFKplUmg/HamLEm6K5R5DXDF1r5G99+6CS/PKPWGK4rGA1xP/8WTqdber1TNr2CT8iZsCa989ZOT2O7V73u9SKTHgZ9wVYoUVCKfS5tdTJsONyRoNV2TWLCXS99NLlqzBcwJOFXHv1liB3AbewaTmlPRRTEWBEgyZRgb3ZrFwTNNXipSsGamwuOH0xxQiHEGEu5CDVGOxqcFmAebIrzb0yyjP
 p3q8qz5N
 yNuSxwKIfm1H87Cd9JhvuJoDjYBNis1P4iDX2k5g5otclyD1CNXgLaXN/ZB2WkSDzhpWCKasCU9DAIhw3rFY6yX9dPBo6G7eReAbdJzjXqvhsUtfqeEfSNcnJtN2Tto009i4enVfDYWXbcTxQClsbBEIggUVp8L6/qUIbd7QdGnMUzWuzRrOygmgcAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: a0c666c25aeefd16f4b088c6549a6fb6b65a8a1d  Add linux-next specific files for 20260122

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202601230916.VpgbAIF5-lkp@intel.com

    drivers/staging/fbtft/fbtft-core.c:368:16: error: no member named 'dev' in 'struct fb_info'
    include/linux/compiler_types.h:630:45: error: call to '__compiletime_assert_436' declared with attribute error: min(((pos + len - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error

Error/Warning ids grouped by kconfigs:

recent_errors
|-- m68k-allmodconfig
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(((pos-len-)-)-(pos-)-max_pages)-signedness-error
`-- powerpc64-randconfig-r053-20260123
    `-- drivers-staging-fbtft-fbtft-core.c:error:no-member-named-dev-in-struct-fb_info

elapsed time: 734m

configs tested: 211
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                          axs103_defconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260123    gcc-8.5.0
arc                   randconfig-002-20260123    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.2.0
arm                         bcm2835_defconfig    clang-22
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                          ep93xx_defconfig    clang-22
arm                           h3600_defconfig    gcc-15.2.0
arm                   randconfig-001-20260123    clang-18
arm                   randconfig-002-20260123    clang-22
arm                   randconfig-003-20260123    gcc-10.5.0
arm                   randconfig-004-20260123    gcc-15.2.0
arm                        spear6xx_defconfig    clang-22
arm                           u8500_defconfig    gcc-15.2.0
arm                         wpcm450_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260123    gcc-15.2.0
arm64                 randconfig-002-20260123    gcc-13.4.0
arm64                 randconfig-003-20260123    gcc-10.5.0
arm64                 randconfig-004-20260123    gcc-13.4.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260123    gcc-15.2.0
csky                  randconfig-002-20260123    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260123    clang-22
hexagon               randconfig-002-20260123    clang-18
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260123    clang-20
i386        buildonly-randconfig-002-20260123    clang-20
i386        buildonly-randconfig-002-20260123    gcc-14
i386        buildonly-randconfig-003-20260123    clang-20
i386        buildonly-randconfig-003-20260123    gcc-14
i386        buildonly-randconfig-004-20260123    clang-20
i386        buildonly-randconfig-004-20260123    gcc-14
i386        buildonly-randconfig-005-20260123    clang-20
i386        buildonly-randconfig-006-20260123    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260123    clang-20
i386                  randconfig-002-20260123    clang-20
i386                  randconfig-003-20260123    gcc-14
i386                  randconfig-004-20260123    gcc-14
i386                  randconfig-005-20260123    clang-20
i386                  randconfig-006-20260123    gcc-14
i386                  randconfig-007-20260123    gcc-13
i386                  randconfig-011-20260123    clang-20
i386                  randconfig-012-20260123    gcc-14
i386                  randconfig-013-20260123    gcc-14
i386                  randconfig-014-20260123    clang-20
i386                  randconfig-015-20260123    gcc-14
i386                  randconfig-016-20260123    clang-20
i386                  randconfig-017-20260123    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260123    gcc-12.5.0
loongarch             randconfig-002-20260123    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                          sun3x_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                           ip30_defconfig    gcc-15.2.0
mips                           rs90_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260123    gcc-10.5.0
nios2                 randconfig-002-20260123    gcc-11.5.0
openrisc                         alldefconfig    gcc-15.2.0
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
parisc                randconfig-001-20260123    gcc-12.5.0
parisc                randconfig-002-20260123    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                     ppa8548_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260123    clang-22
powerpc               randconfig-002-20260123    clang-22
powerpc                     taishan_defconfig    clang-17
powerpc                     tqm5200_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260123    gcc-8.5.0
powerpc64             randconfig-002-20260123    gcc-13.4.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260123    clang-22
riscv                 randconfig-002-20260123    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260123    gcc-8.5.0
s390                  randconfig-002-20260123    gcc-14.3.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260123    gcc-13.4.0
sh                    randconfig-002-20260123    gcc-15.2.0
sh                          rsk7203_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260123    gcc-15.2.0
sparc                 randconfig-002-20260123    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260123    gcc-13.4.0
sparc64               randconfig-002-20260123    gcc-12.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260123    gcc-14
um                    randconfig-002-20260123    clang-22
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260123    clang-20
x86_64      buildonly-randconfig-002-20260123    clang-20
x86_64      buildonly-randconfig-003-20260123    clang-20
x86_64      buildonly-randconfig-004-20260123    clang-20
x86_64      buildonly-randconfig-005-20260123    clang-20
x86_64      buildonly-randconfig-006-20260123    clang-20
x86_64      buildonly-randconfig-006-20260123    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260123    clang-20
x86_64                randconfig-002-20260123    gcc-14
x86_64                randconfig-003-20260123    gcc-14
x86_64                randconfig-004-20260123    gcc-14
x86_64                randconfig-005-20260123    gcc-14
x86_64                randconfig-006-20260123    gcc-14
x86_64                randconfig-011-20260123    gcc-13
x86_64                randconfig-012-20260123    gcc-14
x86_64                randconfig-013-20260123    clang-20
x86_64                randconfig-014-20260123    gcc-14
x86_64                randconfig-015-20260123    gcc-14
x86_64                randconfig-016-20260123    gcc-13
x86_64                randconfig-071-20260123    clang-20
x86_64                randconfig-072-20260123    clang-20
x86_64                randconfig-073-20260123    gcc-14
x86_64                randconfig-074-20260123    gcc-13
x86_64                randconfig-075-20260123    clang-20
x86_64                randconfig-076-20260123    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260123    gcc-11.5.0
xtensa                randconfig-002-20260123    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

