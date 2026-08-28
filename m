Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA948C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 11:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85AF6B0088; Fri, 28 Aug 2026 07:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EBC6B008A; Fri, 28 Aug 2026 07:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73A26B008C; Fri, 28 Aug 2026 07:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8896B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:51:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 096B480335
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:51:16 +0000 (UTC)
X-FDA: 85150512552.11.77E3A4F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3D45FC0002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:51:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cTWujGRo;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787917874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=XWtTqbY46GMmkK9GYQjTvSUpMNr4TSaaXDkdCzfazD4=;
	b=bsoxZC+kwFB0yeM3Uz8t4dnocfj2fPgUvHMjlOuQNqqTqVV6JiKi+Nc41eYQ82lh6Pfnl4
	224pz5hpo9NgFcnx9/U2jDCc1g+eQT3dz6aHGhvpPeBxiNQSSLlwW/ZWjn1My4VD1CU05j
	SMeJC/8NLpMwlWwm1JoD57h+XyTS92Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787917874;
	b=42sjNetTw3qzRZoRo3FVnlxzwq/j7PPlOkOtt95WufSuGRT/kIPDkrfR0MrYNwhAevVPJ+
	PBOLMrbqELGbsH77mqQKz7/CtN/CnYPxNuNLCuUp/Xzjo4mZOsM3aKF8ef5AziEg7PrsDr
	NC5r9gHbr3z886JEyurzRp7g7ofV1y4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cTWujGRo;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787917874; x=1819453874;
  h=date:from:to:cc:subject:message-id;
  bh=XNx9+dFujD5edMjpBTYsyZXqqE4kmavHmMsu+iY+Eo4=;
  b=cTWujGRoL0lQeKexbGLd516Ggz6F07dOt0LHvUYyhxBJukH9RZ3FuUch
   N9Z7DI7DD0WlXWFEzhkpbnWxE0DwudB21pxWHY6eDtXUx6kX6LTIULT0U
   bI5koKa/Ur3uzCV6mbXq/E6N3uYtrXBaaatzeqksuyuWYoBC0y3frHkyV
   HMti9HCI0uUPDjxtZmOk8Ry9pN5AZqDjxp+nZh4jbCTAb3hFf9L1AFwXJ
   Dq/dNfzhqabf17ZOIwTZXMsTpXwlESo/91UXy5h+yqR8m2ZwYpUwbUYhv
   OPmjr8j9gpWssnhC9uLq02P04k56vBCQh5Q38M2fCaxiS8x443aKUXtnM
   A==;
X-CSE-ConnectionGUID: t21J2GP4Q/y23fKRv2SqEQ==
X-CSE-MsgGUID: qxPT+M3sSNC2j4/Fx+FdOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="88630411"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="88630411"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 04:51:12 -0700
X-CSE-ConnectionGUID: HibPXRyPTWqzJ4Znle0WoQ==
X-CSE-MsgGUID: BaLLlXDsSO2O+s1WNHRuug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="291625018"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 28 Aug 2026 04:51:10 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wzv6x-00000000B0r-2LB8;
	Fri, 28 Aug 2026 11:51:07 +0000
Date: Fri, 28 Aug 2026 19:50:44 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 dde94c26af59f5020adafafa08ece21ccd32590b
Message-ID: <202608281932.pzdpjrt8-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: y8wk3idds459h44hhpf9q1jterxj6jf7
X-Rspamd-Queue-Id: 3D45FC0002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787917873-878390
X-HE-Meta: U2FsdGVkX1+Xg5az1GsUHS82ifwatPYzi1isL3aLJGm8ETOJ4ivOiTtiqUM9kHam2lOqmU/yR5y0j8Uw/q1LaNCG32sbXT/ahQB+jOK6IIak+5zMD63URpRIiBcgndRhiXTvnQptpgB1Hc9F5JHTAZLypu118Wmv9Ib1+85sV/QaOcqtxSjMyATbZWexMNbSxkxUZ/1k1N0SGWpKW3D3pAd0CzIzGJWYf3uYMuxtWUbz8kM+3mh76vFqOIIIq3CsgBM492zQkGKFf4qe48F1ZvPoo99QCbMjXLyLMrs5ltijH8XbZlUjPuNVI2glVhJNNwcHqkEiZUWYDMfm58Er4DsFaN6kfKKYyOZdFEufXoQZC7XMhW8kburdMelilxDxCC1kRZmDbpnOR9kDcxxL1xmbyCW85ShAlpl2rG9zVvVdW5FHCxHlYrNxpG4FSgP5ReUGcXAeQFBdigs3FVQUyIV4T86M6NhkHGLQea4YLDOHxk/jSyyb46mDWfrWcwRnGAJFW8tB5jeGDtGFK0tKZ37OrTXM0FREbIU2gLQsJwLtOSwkX0XEY+9S4TvDyU3LzAJhQ6G0kics8OOfGyKKFPXq12Y3WHx3lxXgTHIBAiG1r3g96LyNPgwDzkpQK7vSPb1z8VrkjoSYk+sLdIgqbxGVDj7d+RZaOypjhhrHp9JgANWPd8/quUKyvP/vQFFn0+iCSeQq4BjFRl4w1LGclJouh3y6MqmK3UAhNNo6ekdalFx/IfeoVng0t8X7bOLkxt/Ute972RgVdh9JHctpzYHHi+jS82O9wWdL7drxcqd8ezuvJU6okNc5yFUINkc6lM1/t6dbaSU3YgY/oAB6qWInaQTY5xMU+g4UkmFjpA7yKi2EebzEXxln+tdEv5yYxV9EoR3BqoPiWr4YUynIG5X02w5ZdGvOojEyNKXcpZiTfdeCCH+6d7FcdWTfBVJHoHIohETe+9afEGqrNjN
 1/pQm/rn
 y1WRL/bcFu3lsh6y5/5SX7glhPpsfR4EK06yLHJ8RAopjqfImpX2w/HvYQPWzL+SoVlbsNejyfx+FzHFEyo4GAJI3Z0XkGnSXRCtvrtV02IXxA7h49Amz8z7Fp+tI4Adx1zbparGRiNx65YoA++/vApuCPcbRduUpPx2NFv/iF+Vvk4AAHgTcAzyadTrzW61ngOfq5j0LleTU7Hk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: dde94c26af59f5020adafafa08ece21ccd32590b  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 1439m

configs tested: 407
configs skipped: 22

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-14
arc                              allmodconfig    clang-24
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-14
arc                              allyesconfig    clang-24
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                        nsim_700_defconfig    gcc-16.1.0
arc                     nsimosci_hs_defconfig    gcc-16.1.0
arc                            randconfig-001    gcc-16.1.0
arc                   randconfig-001-20260827    gcc-11.5.0
arc                   randconfig-001-20260828    clang-17
arc                   randconfig-001-20260828    gcc-16.1.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260827    gcc-13.4.0
arc                   randconfig-002-20260828    clang-17
arc                   randconfig-002-20260828    gcc-16.1.0
arc                        vdk_hs38_defconfig    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-14
arm                              allyesconfig    clang-24
arm                              allyesconfig    gcc-16.1.0
arm                       aspeed_g5_defconfig    gcc-16.1.0
arm                         at91_dt_defconfig    gcc-16.1.0
arm                         axm55xx_defconfig    gcc-16.1.0
arm                          collie_defconfig    gcc-16.1.0
arm                                 defconfig    clang-14
arm                                 defconfig    gcc-16.1.0
arm                          ixp4xx_defconfig    gcc-16.1.0
arm                            mmp2_defconfig    gcc-16.1.0
arm                       multi_v4t_defconfig    gcc-16.1.0
arm                        mvebu_v5_defconfig    gcc-16.1.0
arm                        neponset_defconfig    gcc-16.1.0
arm                             pxa_defconfig    gcc-16.1.0
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260827    clang-14
arm                   randconfig-001-20260828    clang-17
arm                   randconfig-001-20260828    gcc-16.1.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260827    gcc-15.2.0
arm                   randconfig-002-20260828    clang-17
arm                   randconfig-002-20260828    gcc-16.1.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260827    gcc-8.5.0
arm                   randconfig-003-20260828    clang-17
arm                   randconfig-003-20260828    gcc-16.1.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260827    gcc-8.5.0
arm                   randconfig-004-20260828    clang-17
arm                   randconfig-004-20260828    gcc-16.1.0
arm                       spear13xx_defconfig    gcc-16.1.0
arm                       versatile_defconfig    gcc-16.1.0
arm                         vf610m4_defconfig    gcc-16.1.0
arm64                            allmodconfig    clang-14
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    clang-24
arm64                 randconfig-001-20260827    gcc-8.5.0
arm64                 randconfig-001-20260828    clang-14
arm64                 randconfig-001-20260828    clang-24
arm64                          randconfig-002    clang-24
arm64                 randconfig-002-20260827    gcc-9.5.0
arm64                 randconfig-002-20260828    clang-14
arm64                 randconfig-002-20260828    clang-24
arm64                          randconfig-003    clang-24
arm64                 randconfig-003-20260828    clang-14
arm64                 randconfig-003-20260828    clang-24
arm64                          randconfig-004    clang-24
arm64                 randconfig-004-20260827    gcc-8.5.0
arm64                 randconfig-004-20260828    clang-14
arm64                 randconfig-004-20260828    clang-24
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    clang-24
csky                  randconfig-001-20260827    gcc-9.5.0
csky                  randconfig-001-20260828    clang-14
csky                  randconfig-001-20260828    clang-24
csky                           randconfig-002    clang-24
csky                  randconfig-002-20260827    gcc-15.2.0
csky                  randconfig-002-20260828    clang-14
csky                  randconfig-002-20260828    clang-24
hexagon                          allmodconfig    clang-14
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-14
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-14
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260827    clang-14
hexagon               randconfig-001-20260828    clang-18
hexagon                        randconfig-002    clang-14
hexagon               randconfig-002-20260827    clang-14
hexagon               randconfig-002-20260828    clang-18
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260827    clang-22
i386        buildonly-randconfig-001-20260828    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260827    clang-22
i386        buildonly-randconfig-002-20260828    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260827    clang-22
i386        buildonly-randconfig-003-20260828    clang-22
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260827    clang-22
i386        buildonly-randconfig-004-20260828    clang-22
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260827    clang-22
i386        buildonly-randconfig-005-20260828    clang-22
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260827    clang-22
i386        buildonly-randconfig-006-20260828    clang-22
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260828    gcc-14
i386                  randconfig-002-20260828    gcc-14
i386                  randconfig-003-20260828    gcc-14
i386                  randconfig-004-20260828    gcc-14
i386                  randconfig-005-20260828    gcc-14
i386                  randconfig-006-20260828    gcc-14
i386                  randconfig-007-20260828    gcc-14
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260827    clang-22
i386                  randconfig-011-20260828    gcc-14
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260827    clang-22
i386                  randconfig-012-20260828    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260827    gcc-14
i386                  randconfig-013-20260828    gcc-14
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260827    gcc-13
i386                  randconfig-014-20260828    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260827    gcc-14
i386                  randconfig-015-20260828    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260827    clang-22
i386                  randconfig-016-20260828    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260827    clang-22
i386                  randconfig-017-20260828    gcc-14
loongarch                        allmodconfig    clang-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-14
loongarch                           defconfig    clang-24
loongarch                loongson32_defconfig    gcc-16.1.0
loongarch                      randconfig-001    clang-14
loongarch             randconfig-001-20260827    clang-22
loongarch             randconfig-001-20260828    clang-18
loongarch                      randconfig-002    gcc-16.1.0
loongarch             randconfig-002-20260827    gcc-16.1.0
loongarch             randconfig-002-20260828    clang-18
m68k                             alldefconfig    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-14
m68k                             allyesconfig    clang-24
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-14
m68k                                defconfig    clang-24
m68k                       m5329evb_defconfig    gcc-16.1.0
m68k                          multi_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-14
microblaze                          defconfig    clang-24
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                     decstation_defconfig    gcc-16.1.0
mips                     loongson2k_defconfig    gcc-16.1.0
mips                   sb1250_swarm_defconfig    gcc-16.1.0
nios2                         10m50_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-14
nios2                             allnoconfig    clang-24
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-14
nios2                               defconfig    clang-24
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260827    gcc-11.5.0
nios2                 randconfig-001-20260828    clang-18
nios2                          randconfig-002    gcc-8.5.0
nios2                 randconfig-002-20260827    gcc-11.5.0
nios2                 randconfig-002-20260828    clang-18
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-14
openrisc                          allnoconfig    clang-24
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-14
parisc                            allnoconfig    clang-24
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260827    gcc-14.3.0
parisc                randconfig-001-20260828    gcc-9.5.0
parisc                randconfig-002-20260827    gcc-16.1.0
parisc                randconfig-002-20260828    gcc-9.5.0
parisc64                            defconfig    clang-14
parisc64                            defconfig    clang-24
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-14
powerpc                           allnoconfig    clang-24
powerpc                           allnoconfig    gcc-16.1.0
powerpc                  iss476-smp_defconfig    gcc-16.1.0
powerpc                   lite5200b_defconfig    gcc-16.1.0
powerpc               randconfig-001-20260827    gcc-13.4.0
powerpc               randconfig-001-20260828    gcc-9.5.0
powerpc               randconfig-002-20260827    clang-17
powerpc               randconfig-002-20260828    gcc-9.5.0
powerpc                        warp_defconfig    gcc-16.1.0
powerpc                         wii_defconfig    gcc-16.1.0
powerpc64             randconfig-001-20260827    gcc-15.2.0
powerpc64             randconfig-001-20260828    gcc-9.5.0
powerpc64             randconfig-002-20260827    gcc-13.4.0
powerpc64             randconfig-002-20260828    gcc-9.5.0
riscv                            allmodconfig    clang-14
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-14
riscv                             allnoconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-14
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-14
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260827    gcc-8.5.0
riscv                 randconfig-001-20260828    clang-17
riscv                 randconfig-002-20260827    clang-14
riscv                 randconfig-002-20260828    clang-17
s390                             allmodconfig    clang-14
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-14
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260827    gcc-10.5.0
s390                  randconfig-001-20260828    clang-17
s390                  randconfig-002-20260827    clang-14
s390                  randconfig-002-20260828    clang-17
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-14
sh                                allnoconfig    clang-24
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260827    gcc-13.4.0
sh                    randconfig-001-20260828    clang-17
sh                    randconfig-002-20260827    gcc-11.5.0
sh                    randconfig-002-20260828    clang-17
sh                           se7724_defconfig    gcc-16.1.0
sh                        sh7757lcr_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-14
sparc                             allnoconfig    clang-24
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260827    gcc-12.5.0
sparc                 randconfig-001-20260828    gcc-9.5.0
sparc                          randconfig-002    gcc-11.5.0
sparc                 randconfig-002-20260827    gcc-8.5.0
sparc                 randconfig-002-20260828    gcc-9.5.0
sparc                       sparc64_defconfig    gcc-16.1.0
sparc64                          alldefconfig    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-14
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-12.5.0
sparc64               randconfig-001-20260827    clang-20
sparc64               randconfig-001-20260828    gcc-9.5.0
sparc64                        randconfig-002    clang-20
sparc64               randconfig-002-20260827    gcc-8.5.0
sparc64               randconfig-002-20260828    gcc-9.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-14
um                                allnoconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-14
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-14
um                    randconfig-001-20260827    clang-14
um                    randconfig-001-20260828    gcc-9.5.0
um                             randconfig-002    clang-14
um                    randconfig-002-20260827    clang-17
um                    randconfig-002-20260828    gcc-9.5.0
um                           x86_64_defconfig    clang-14
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-14
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-12
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260827    gcc-14
x86_64      buildonly-randconfig-001-20260828    gcc-14
x86_64               buildonly-randconfig-002    clang-22
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260827    clang-22
x86_64      buildonly-randconfig-002-20260828    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260827    clang-22
x86_64      buildonly-randconfig-003-20260828    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260827    clang-22
x86_64      buildonly-randconfig-004-20260828    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260827    clang-22
x86_64      buildonly-randconfig-005-20260828    gcc-14
x86_64               buildonly-randconfig-006    clang-22
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260827    gcc-14
x86_64      buildonly-randconfig-006-20260828    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260827    clang-22
x86_64                randconfig-001-20260828    gcc-14
x86_64                randconfig-002-20260827    gcc-14
x86_64                randconfig-002-20260828    gcc-14
x86_64                randconfig-003-20260827    gcc-14
x86_64                randconfig-003-20260828    gcc-14
x86_64                randconfig-004-20260827    gcc-14
x86_64                randconfig-004-20260828    gcc-14
x86_64                randconfig-005-20260827    clang-22
x86_64                randconfig-005-20260828    gcc-14
x86_64                randconfig-006-20260827    clang-22
x86_64                randconfig-006-20260828    gcc-14
x86_64                randconfig-011-20260827    gcc-14
x86_64                randconfig-011-20260828    clang-22
x86_64                randconfig-012-20260827    clang-22
x86_64                randconfig-012-20260828    clang-22
x86_64                randconfig-013-20260827    gcc-14
x86_64                randconfig-013-20260828    clang-22
x86_64                randconfig-014-20260827    clang-22
x86_64                randconfig-014-20260828    clang-22
x86_64                randconfig-015-20260827    clang-22
x86_64                randconfig-015-20260828    clang-22
x86_64                randconfig-016-20260827    gcc-12
x86_64                randconfig-016-20260828    clang-22
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260827    gcc-14
x86_64                randconfig-071-20260828    clang-22
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260827    gcc-14
x86_64                randconfig-072-20260828    clang-22
x86_64                         randconfig-073    clang-22
x86_64                randconfig-073-20260827    clang-22
x86_64                randconfig-073-20260828    clang-22
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260827    clang-22
x86_64                randconfig-074-20260828    clang-22
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260827    gcc-14
x86_64                randconfig-075-20260828    clang-22
x86_64                         randconfig-076    clang-22
x86_64                randconfig-076-20260827    gcc-14
x86_64                randconfig-076-20260828    clang-22
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-14
xtensa                            allnoconfig    clang-24
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                  audio_kc705_defconfig    gcc-16.1.0
xtensa                  cadence_csp_defconfig    gcc-16.1.0
xtensa                          iss_defconfig    gcc-16.1.0
xtensa                  nommu_kc705_defconfig    gcc-16.1.0
xtensa                         randconfig-001    gcc-8.5.0
xtensa                randconfig-001-20260827    gcc-16.1.0
xtensa                randconfig-001-20260828    gcc-9.5.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                randconfig-002-20260827    gcc-10.5.0
xtensa                randconfig-002-20260828    gcc-9.5.0
xtensa                    smp_lx200_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

