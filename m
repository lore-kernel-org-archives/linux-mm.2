Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90293C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 12:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7556B008C; Fri, 28 Aug 2026 08:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88FBF6B0092; Fri, 28 Aug 2026 08:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5C56B0095; Fri, 28 Aug 2026 08:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EFE66B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:02:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E05B940344
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:02:15 +0000 (UTC)
X-FDA: 85150540230.01.FADCD1F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf30.hostedemail.com (Postfix) with ESMTP id D1DDC80016
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:02:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CDbiSVs7;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787918534;
	b=YXAEJTVhL63fNNoVC5WkScS/+xAJBLn31rvdJ/S1Iotq3THaoEJ39lk7t9IDK4S5OSDDuq
	hGVqRFxe1jkjPJqXtURXM0voBylbdnCW59UusUd57RI6zSxwcVUwNw3QNtnoD3eE2oyAcx
	hUA7XS7xr6HSQPhtd/die2S+hMJ0+Vs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CDbiSVs7;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787918534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=PIcFRUnnDMo1nd7DQnmJevQhcVLofT7/6W5FtTgwIMw=;
	b=R5+ksaQazpmSNTwGH2n2x5NEmBFodY6vEPSQrkPhwv0QDzA66ipRn8RqDH0Ll4HLfairr+
	Ao3snR95h8GkQbRim0oVpghSgbKNUl/t0MXlqp7rjJHOgGv/YXrsuEN+C66SdQAHl6cE10
	gmw11EEGMK0kuhamPpPBZ0W0GI9ymiY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787918534; x=1819454534;
  h=date:from:to:cc:subject:message-id;
  bh=gozTZMGJRZAdLWORtgjnwouTRCcvjoyRT8xh0162psg=;
  b=CDbiSVs72WEd8NvuNt7oI1OgAM2wqrNLhRhbnOEZbwEvBUbQT5lc2hl9
   ku4y9qaeE0gYgLNixAOd/QtLQNxaXmuM9tONYYti0zB2sgSnxggRuM1f9
   hMqf4EZj9B2Oozdf7B4yULm8kO3/UsVSmTKfl86vs5YxwD5MrfonG/2bd
   nWgrrA96WxSbmxMAxeA60nKxotDvUJq3yh/AwYytI9v5zGCzHxWnqL1tZ
   sz0v6nKFG2jq8a7jv5wu2EqxmPUxzxjXWxjLqk8PC+IYhgHOBMELB9R/W
   T8C/IO0vDBca0gTl8RqLpxcNSSkMYutm4W9mZmouNG20FsndDzN26QVVr
   w==;
X-CSE-ConnectionGUID: DtG42+YJSGa1Snk15uwb2Q==
X-CSE-MsgGUID: cWhE8Q58QL+4lyWiiXenAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="88631323"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="88631323"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 05:02:13 -0700
X-CSE-ConnectionGUID: 2dWBJ93NRf6xwerNsGUZCg==
X-CSE-MsgGUID: QhyVubb+RbSE+ba0fi8+FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="264884879"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 28 Aug 2026 05:02:11 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wzvHc-00000000B2t-3izw;
	Fri, 28 Aug 2026 12:02:08 +0000
Date: Fri, 28 Aug 2026 20:01:43 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 f82a5da2f04960df9fb57489992d03dd5e64ec6f
Message-ID: <202608282023.M6WJyhiE-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: zir6xdgkgym6xykswtj1j5af1z9xrni8
X-Rspamd-Queue-Id: D1DDC80016
X-Rspamd-Server: rspam06
X-HE-Tag: 1787918533-162740
X-HE-Meta: U2FsdGVkX18Joz7StQWnMkplRQgrvWxqMS2UEnUBct2LRELYC9ZzIFEvIRKcxirveKny1YQnlxAXcTVGssLFQb0i6uCLfGm22J0YKhEWp/s+JgdTG2ggvSpAiqKD1LFyrnboomMbwaV9yuduBIS1E3JBP/CFOlNeDouZFYV/h8218/MqDOAR6QPeSStCnP7y2YvjrspCpAU64FUjmZOpHqX2DVrmboQFfPAJpoTsNTO4SbGlF/9iXncOLSSlMMJIfbiEUezsTbh2yFk8ryBby7s8pSuNfMfjsnXAoA+vZeQKyJXyPLVzepwuWW1lcScjgI0arZJBHtch2xX4Oz2cIlP2aynaxQfIcI15/RoK4zmnynDz4Qc2uERr2XE0CM0wXWX9jp+kTcnKluvPaMlmaWX+J0t08c4h3F+GMY/uUDKqYnSPx9ew9732cwBBn4wCXSVefCkAosTymGxbxqRxKC2pXuZXuxmSjEZE7AvKCTKuRwtSed8Vj1ZszJtLdmW2YUWCweXxyuo+huZL2/1xjmT2xjjT8VRADs8j6M+GhO7AWKUdwzLaFwJAAfiKfL1V+YVU1KkZJj63K5f5Q3NY5tRsKnCFAJeKjKlIV4EawFDjEnfyUTcrmXvoQCc8QumzHbnCWMaOtG73f+Uw3SstZ1ykFG96ggTpPnmfi5nJhczX/SV6rxoXyItPTbKjYHo4aOfWFC/egqQ/PqoNLNw8p/9Cf2DgsgHx7xcPlx2AxnHzoqpRYNtv9i2zXIdPzOVA/95tYTC/BO2TZmZcleqDFEYLBT2Ew1UsPW3bypgbMl55hgCGr0oTzN3GJUFjP7vOhquBYD69t2lgLizmiOhNe5aZpC/VnY3hFF23LGKylT+xsIUcGU6hXUHWO4dQNQXidcooCcOmp8h1HiRkHshGPMQ3gyHRXaS/ULHPgvAwUCBSbhHbM9WIq9DwaQ0nd122HU07I3A+Yicw3+7sYPH
 KHkYoTwJ
 dhpwJIVU/fFtFh27e/DVshLkDVDNBncI8nvzb+VBE8BwBqJOGXGW7rf1t+NsxQ4p/yuPHtOO1mGfOSgjRDecVbvdAOFbJ0qQXvG1vpGGsmrJhod5i2DJybmJpY1JzsdDO3TuHWBqCRgPGrCLagK2/Zucn5c96+NuuJp7JEmrd6ECOKnbqJj4DlW8BaANmRDjodlXNpjHLsGMiGsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: f82a5da2f04960df9fb57489992d03dd5e64ec6f  Add linux-next specific files for 20260826

Error/Warning (recently discovered and may have been fixed):

    (.head.text+0x0): relocation truncated to fit: R_MIPS_26 against `kernel_entry'
    (.ref.text+0xd8): relocation truncated to fit: R_MIPS_26 against `start_secondary'
    rv_monitors_test.c:(.text.rv_test_nomiss+0x284): undefined reference to `__udivdi3'

Error/Warning ids grouped by kconfigs:

recent_errors
`-- mips-allyesconfig
    |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
    |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
    `-- rv_monitors_test.c:(.text.rv_test_nomiss):undefined-reference-to-__udivdi3

elapsed time: 2625m

configs tested: 266
configs skipped: 5

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-14
arc                              allyesconfig    clang-24
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                         haps_hs_defconfig    gcc-16.1.0
arc                   randconfig-001-20260828    gcc-8.5.0
arc                   randconfig-002-20260828    gcc-10.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-14
arm                                 defconfig    gcc-16.1.0
arm                            mmp2_defconfig    gcc-16.1.0
arm                   randconfig-001-20260828    clang-14
arm                   randconfig-002-20260828    clang-17
arm                   randconfig-003-20260828    clang-14
arm                   randconfig-004-20260828    clang-14
arm64                            allmodconfig    clang-14
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260828    clang-14
arm64                 randconfig-002-20260828    clang-21
arm64                 randconfig-003-20260828    clang-14
arm64                 randconfig-004-20260828    clang-18
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260828    gcc-14.3.0
csky                  randconfig-002-20260828    gcc-12.5.0
hexagon                          allmodconfig    clang-14
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-14
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-14
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    clang-17
hexagon               randconfig-001-20260827    clang-14
hexagon                        randconfig-002    clang-14
hexagon               randconfig-002-20260827    clang-14
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    clang-22
i386        buildonly-randconfig-001-20260827    clang-22
i386        buildonly-randconfig-001-20260828    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260827    clang-22
i386        buildonly-randconfig-002-20260828    clang-22
i386        buildonly-randconfig-002-20260828    gcc-14
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260827    clang-22
i386        buildonly-randconfig-003-20260828    clang-22
i386                 buildonly-randconfig-004    clang-22
i386        buildonly-randconfig-004-20260827    clang-22
i386        buildonly-randconfig-004-20260828    clang-22
i386                 buildonly-randconfig-005    clang-22
i386        buildonly-randconfig-005-20260827    clang-22
i386        buildonly-randconfig-005-20260828    clang-22
i386                 buildonly-randconfig-006    clang-22
i386        buildonly-randconfig-006-20260827    clang-22
i386        buildonly-randconfig-006-20260828    clang-22
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260827    gcc-14
i386                  randconfig-002-20260827    gcc-14
i386                  randconfig-003-20260827    gcc-14
i386                  randconfig-004-20260827    gcc-14
i386                  randconfig-005-20260827    gcc-14
i386                  randconfig-006-20260827    gcc-14
i386                  randconfig-007-20260827    gcc-12
i386                  randconfig-011-20260828    clang-22
i386                  randconfig-012-20260828    clang-22
i386                  randconfig-013-20260828    clang-22
i386                  randconfig-014-20260828    gcc-14
i386                  randconfig-015-20260828    gcc-14
i386                  randconfig-016-20260828    gcc-14
i386                  randconfig-017-20260828    gcc-14
loongarch                        allmodconfig    clang-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-14
loongarch                           defconfig    clang-24
loongarch                      randconfig-001    clang-14
loongarch             randconfig-001-20260827    clang-22
loongarch                      randconfig-002    gcc-16.1.0
loongarch             randconfig-002-20260827    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-14
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-14
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        bcm63xx_defconfig    clang-14
mips                         cobalt_defconfig    gcc-16.1.0
mips                malta_qemu_32r6_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-14
nios2                             allnoconfig    clang-24
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-14
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260827    gcc-11.5.0
nios2                          randconfig-002    gcc-8.5.0
nios2                 randconfig-002-20260827    gcc-11.5.0
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
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260828    gcc-9.5.0
parisc                randconfig-002-20260828    gcc-8.5.0
parisc64                            defconfig    clang-14
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-14
powerpc                           allnoconfig    clang-24
powerpc                           allnoconfig    gcc-16.1.0
powerpc                     asp8347_defconfig    clang-14
powerpc                      pasemi_defconfig    clang-14
powerpc               randconfig-001-20260828    gcc-10.5.0
powerpc               randconfig-002-20260828    gcc-12.5.0
powerpc                     stx_gp3_defconfig    gcc-16.1.0
powerpc64             randconfig-001-20260828    clang-17
powerpc64             randconfig-002-20260828    clang-21
riscv                            allmodconfig    clang-14
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-14
riscv                             allnoconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-14
riscv                               defconfig    clang-14
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260827    gcc-8.5.0
riscv                 randconfig-002-20260827    clang-14
s390                             allmodconfig    clang-14
s390                              allnoconfig    clang-14
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260827    gcc-10.5.0
s390                  randconfig-002-20260827    clang-14
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-14
sh                                allnoconfig    clang-24
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260827    gcc-13.4.0
sh                    randconfig-002-20260827    gcc-11.5.0
sparc                             allnoconfig    clang-14
sparc                             allnoconfig    clang-24
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260827    gcc-12.5.0
sparc                 randconfig-002-20260827    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-14
sparc64                             defconfig    clang-24
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260827    clang-20
sparc64               randconfig-002-20260827    gcc-8.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-14
um                                allnoconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-14
um                                  defconfig    clang-24
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260827    clang-14
um                    randconfig-002-20260827    clang-17
um                           x86_64_defconfig    clang-14
um                           x86_64_defconfig    clang-24
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-14
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260827    clang-22
x86_64      buildonly-randconfig-001-20260827    gcc-14
x86_64      buildonly-randconfig-001-20260828    gcc-14
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
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260827    clang-22
x86_64      buildonly-randconfig-006-20260827    gcc-14
x86_64      buildonly-randconfig-006-20260828    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260827    clang-22
x86_64                randconfig-002-20260827    gcc-14
x86_64                randconfig-003-20260827    gcc-14
x86_64                randconfig-004-20260827    gcc-14
x86_64                randconfig-005-20260827    clang-22
x86_64                randconfig-006-20260827    clang-22
x86_64                randconfig-011-20260827    gcc-14
x86_64                randconfig-012-20260827    clang-22
x86_64                randconfig-013-20260827    gcc-14
x86_64                randconfig-014-20260827    clang-22
x86_64                randconfig-015-20260827    clang-22
x86_64                randconfig-016-20260827    gcc-12
x86_64                randconfig-071-20260828    clang-22
x86_64                randconfig-072-20260828    gcc-14
x86_64                randconfig-073-20260828    gcc-14
x86_64                randconfig-074-20260828    clang-22
x86_64                randconfig-075-20260828    gcc-13
x86_64                randconfig-076-20260828    clang-22
x86_64                               rhel-9.4    clang-22
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-14
xtensa                            allnoconfig    clang-24
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260827    gcc-16.1.0
xtensa                randconfig-002-20260827    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

