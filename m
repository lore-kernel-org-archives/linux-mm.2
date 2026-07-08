Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3B53C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70F596B0088; Tue,  7 Jul 2026 21:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BFF46B0092; Tue,  7 Jul 2026 21:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5E16B0093; Tue,  7 Jul 2026 21:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 272716B0088
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:53:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95FE48D2F2
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:53:04 +0000 (UTC)
X-FDA: 84963936288.09.5852BF0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1634840002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:53:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XW3koN6T;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783475582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=nvGIarY06CPdGwbl3eG90G2v9Kl0Gh7VDgz6QWYTZKY=;
	b=v6z35HQHP0PvNuY3/DB7gE06BImtmuBK3JGOGam0LOWqyViEomFnVUJyKnVR45VKcU2aoh
	Z4u4VEoEGGz65HjvaOWyAZJ0Q1JTSZ8X/XcByQ+wmxmIhT+dNvYogKAlpvZmonjAvs8f2x
	zFW4BYzbpD3VadBHYhRu3wvHxIMfizo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XW3koN6T;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783475582;
	b=uhitVY64ZQLcCk4lZWwORll5vhEmftYpi3Jji8Zz2Y25FLeGSN8SskBu77T+Csz6HPjbSd
	2LDj43DEBT/a/4Wo/93/SkAYZzBHpPtjkxCZJL06ey9nmhVPLTih+szcSc+NCyMarSgXso
	C02sLq4r/hhJF3bGYOSAfl+hTrATkUM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783475582; x=1815011582;
  h=date:from:to:cc:subject:message-id;
  bh=swkmBcA/vlpg2LoQPpVjWmEVZxRFBZpAvJtJOAFB7cg=;
  b=XW3koN6TpGLweT1Ey7CeFLh77r/Vw8vTHi4Na6qNCWEImLH+7GqP2Nv5
   IDbeKby66E2vQc9me6N8aaNBP4I3GVMSdHZa7M/HF1W8SD3htVzzN6sfC
   0TNFq1rOuW5+UUR5V5f+J73Ip3tT1GkdXx4gPXEmP5mVzdV1toKDZv8rc
   As+0vi37d/XG6E0HlTiKc8lQlbMjRbVOfGVuZ7pE2McSGtjnR4nJQM6mE
   UMpOWgI5zGrRwUzDY+KjHTl9iNCwnAD1umAj3K4Ldqit1TTY24LuWRzCA
   xwsQyAS5ni5GpI4SY0QjB+RKHhj7GmshNfbghb0wlZSaOeav7g1p1gass
   w==;
X-CSE-ConnectionGUID: XzBnc0nxSRapbbJNb3GJQQ==
X-CSE-MsgGUID: WhVJ/NQ1TYOzunFF4Ro6Bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11840"; a="84190025"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="84190025"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2026 18:53:00 -0700
X-CSE-ConnectionGUID: /JeXpta9SF2HQalxBWRsYQ==
X-CSE-MsgGUID: VuQwhgVJQtaRMRf9b49bcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="258462221"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 07 Jul 2026 18:52:58 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whHT4-00000000Ftb-1v0U;
	Wed, 08 Jul 2026 01:52:54 +0000
Date: Wed, 08 Jul 2026 09:52:07 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 bpf@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 5c73cd9f0819c1c44e373e3dabb68318b1de1a12
Message-ID: <202607080951.rMUtVX8X-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1634840002
X-Stat-Signature: w81rzfnmxjysmbdfsqxb9nzfzfsjzm61
X-HE-Tag: 1783475581-826116
X-HE-Meta: U2FsdGVkX1+fuB/PcWK7FEyizdglrQFpJOpHu3e6cXdj9V2aCKurvF4Clwdxt7EAxH1P9OODw4YL1dWYI1q3c8GprlTLCq9JcHtm4ViisCCZId0ycUHf4nni0A+/Q6RwHxZWMT3Fh2fqm6qJtI1wo0Z8iB7b/0s1BcJaNTPG007+aMnqEIs3zTJcw92rrDeDSRX4xFUVesEV0HrZsrxKX1vNKyVQkOBI9aBFtglIckg0kTEGD4SUOe/QbXyNPX11ocjbIpFXip1OyoBFo1qg+CtB3MBX2TT0l7NZNUDTwh/iSHUfpV8gIHaSqBLuq8nlsjBnmFo046ZPlfnMu6IGqTKKXhPGKf+H3nH0BvqI+Y1nPQoeekxJD6wE88G9gequb1i2xfdl+4D80Nl9V0VAeeUFQCamZarMQTv7TgW/XBdqsmXy50DapvdicnnG7wb5NHzMvZY04E0bcvDebUregeHazMekDSnuda03xSoPq4Vv5QqCbZZSU9+N7CvnovIQuwirQ36fLog15K5z3INJTVsTxcTV3bi6Y2FaTqYkiIAY629Sp9VbGvxo+wo0kxwyeWUjx+xZHI6kkCEljuVvtdF9TZO0eodojRSvVhsi01uxr8uwwq8a5bU8g7PuBzUWYxRESCHvzOJVB5bq3rMWQ20YJ9ZuCQfj9XChnaGDsoqp9IEQpEsBKiZWyb4iaO36gxYKHNni9YFZslEPrZBJGZMiQrvy8etUiEyHjIUBT6FckWJZAwWFvPzWZSbaTrC6+CyNYFXABUSeRtXvk4z0ellF2i1IoSzarmS/+Qon8BR8J7B8xvnti7zhgUnxlxRDTRY4vsLeNtGEa+t1HfmwRso09tYrrdFDWegHbMNj7QW6mNYweZ/L5onwLu4aTGbuleb/1+ui2za/1MuGEhIeOsiifoVlThBnz/7Fl2jYE4Nss50QhkFQM8ub9cXDqwj7ew+fC5dKl3nFDSaF554
 CV7QoT7O
 HG7nn7PomRWiZqsBxktS2U5wNQ/vy6Q3nrdwkNBh/HMPfhMxvgfMbFat2+AHAmZyDtGlLVCrkPBecsdyB1viZlF8455583oi5ykPQ9RJs+KwohWGQVwFBz1du6dpn/h9ZT5oFhcKHy7KahCRNnHqC8jQ/gUAWFayc9/fyoWsQcReNilwmXz2EXfeXq+1Tp+FVWfNWj3ZwR1RGlvEXV25nY/E+UiB57tKglMEQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 5c73cd9f0819c1c44e373e3dabb68318b1de1a12  Add linux-next specific files for 20260707

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202607080254.6qrH5NrH-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202607080650.sMl0aR2a-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202607080709.kE9W2GbI-lkp@intel.com

    arch/arm64/kvm/hyp/pgtable.c:1359:13: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 2147483647 to -1 [-Wconstant-conversion]
    include/vdso/limits.h:8:25: warning: overflow in conversion from 'int' to 's8' {aka 'signed char'} changes value from '2147483647' to '-1' [-Woverflow]
    kernel/bpf/task_iter.c:759:14: warning: variable 'mmput_needed' set but not used [-Wunused-but-set-variable=]
    kernel/bpf/task_iter.c:759:14: warning: variable 'mmput_needed' set but not used [-Wunused-but-set-variable]

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/mtd/parsers/redboot.c:311:1: internal compiler error: in final_scan_insn_1, at final.c:3073

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-allmodconfig
|   `-- arch-arm64-kvm-hyp-pgtable.c:warning:implicit-conversion-from-int-to-s8-(aka-signed-char-)-changes-value-from-to
|-- arm64-defconfig
|   `-- include-vdso-limits.h:warning:overflow-in-conversion-from-int-to-s8-aka-signed-char-changes-value-from-to
|-- csky-randconfig-r072-20260707
|   `-- drivers-mtd-parsers-redboot.c:internal-compiler-error:in-final_scan_insn_1-at-final.c
|-- m68k-randconfig-r132-20260708
|   `-- kernel-bpf-task_iter.c:warning:variable-mmput_needed-set-but-not-used
|-- sh-allmodconfig
|   `-- kernel-bpf-task_iter.c:warning:variable-mmput_needed-set-but-not-used
`-- sh-allyesconfig
    `-- kernel-bpf-task_iter.c:warning:variable-mmput_needed-set-but-not-used

elapsed time: 734m

configs tested: 279
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              alldefconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260708    gcc-13.4.0
arc                   randconfig-002-20260708    gcc-13.4.0
arc                   randconfig-002-20260708    gcc-15.2.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260708    gcc-11.5.0
arm                   randconfig-001-20260708    gcc-13.4.0
arm                   randconfig-002-20260708    gcc-10.5.0
arm                   randconfig-002-20260708    gcc-13.4.0
arm                   randconfig-003-20260708    gcc-13.4.0
arm                   randconfig-003-20260708    gcc-8.5.0
arm                   randconfig-004-20260708    gcc-13.4.0
arm                   randconfig-004-20260708    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260708    clang-23
arm64                 randconfig-001-20260708    gcc-9.5.0
arm64                 randconfig-002-20260708    clang-23
arm64                 randconfig-002-20260708    gcc-9.5.0
arm64                 randconfig-003-20260708    gcc-9.5.0
arm64                 randconfig-004-20260708    gcc-15.2.0
arm64                 randconfig-004-20260708    gcc-9.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260708    gcc-11.5.0
csky                  randconfig-001-20260708    gcc-9.5.0
csky                  randconfig-002-20260708    gcc-9.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260707    clang-23
hexagon               randconfig-002-20260707    clang-18
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260707    clang-22
i386        buildonly-randconfig-001-20260708    clang-22
i386        buildonly-randconfig-002-20260707    clang-22
i386        buildonly-randconfig-002-20260708    clang-22
i386        buildonly-randconfig-003-20260707    clang-22
i386        buildonly-randconfig-003-20260708    clang-22
i386        buildonly-randconfig-004-20260707    gcc-14
i386        buildonly-randconfig-004-20260708    clang-22
i386        buildonly-randconfig-005-20260707    clang-22
i386        buildonly-randconfig-005-20260708    clang-22
i386        buildonly-randconfig-006-20260707    clang-22
i386        buildonly-randconfig-006-20260708    clang-22
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260708    clang-22
i386                  randconfig-001-20260708    gcc-14
i386                  randconfig-002-20260708    clang-22
i386                  randconfig-002-20260708    gcc-14
i386                  randconfig-003-20260708    clang-22
i386                  randconfig-004-20260708    clang-22
i386                  randconfig-004-20260708    gcc-14
i386                  randconfig-005-20260708    clang-22
i386                  randconfig-006-20260708    clang-22
i386                  randconfig-007-20260708    clang-22
i386                  randconfig-007-20260708    gcc-12
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260707    gcc-14
i386                  randconfig-011-20260708    gcc-14
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260707    gcc-14
i386                  randconfig-012-20260708    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260707    clang-22
i386                  randconfig-013-20260708    gcc-14
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260707    gcc-14
i386                  randconfig-014-20260708    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260707    gcc-14
i386                  randconfig-015-20260708    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260707    gcc-14
i386                  randconfig-016-20260708    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260707    gcc-14
i386                  randconfig-017-20260708    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260707    clang-18
loongarch             randconfig-002-20260707    clang-19
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260707    gcc-11.5.0
nios2                 randconfig-002-20260707    gcc-11.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260707    gcc-15.2.0
parisc                randconfig-001-20260708    clang-22
parisc                randconfig-002-20260707    gcc-9.5.0
parisc                randconfig-002-20260708    clang-22
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc               randconfig-001-20260707    clang-23
powerpc               randconfig-001-20260708    clang-22
powerpc               randconfig-002-20260707    gcc-14.3.0
powerpc               randconfig-002-20260708    clang-22
powerpc64             randconfig-001-20260707    gcc-8.5.0
powerpc64             randconfig-001-20260708    clang-22
powerpc64             randconfig-002-20260707    clang-22
powerpc64             randconfig-002-20260708    clang-22
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260708    clang-23
riscv                 randconfig-001-20260708    gcc-8.5.0
riscv                 randconfig-002-20260708    clang-23
riscv                 randconfig-002-20260708    gcc-8.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260708    clang-20
s390                  randconfig-001-20260708    clang-23
s390                  randconfig-002-20260708    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260708    clang-23
sh                    randconfig-001-20260708    gcc-16.1.0
sh                    randconfig-002-20260708    clang-23
sh                    randconfig-002-20260708    gcc-9.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260708    gcc-16.1.0
sparc                 randconfig-001-20260708    gcc-8.5.0
sparc                 randconfig-002-20260708    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260708    clang-22
sparc64               randconfig-001-20260708    gcc-8.5.0
sparc64               randconfig-002-20260708    clang-20
sparc64               randconfig-002-20260708    gcc-8.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260708    gcc-14
um                    randconfig-001-20260708    gcc-8.5.0
um                    randconfig-002-20260708    clang-23
um                    randconfig-002-20260708    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260708    clang-22
x86_64      buildonly-randconfig-001-20260708    gcc-12
x86_64      buildonly-randconfig-002-20260708    gcc-12
x86_64      buildonly-randconfig-002-20260708    gcc-14
x86_64      buildonly-randconfig-003-20260708    gcc-12
x86_64      buildonly-randconfig-004-20260708    clang-22
x86_64      buildonly-randconfig-004-20260708    gcc-12
x86_64      buildonly-randconfig-005-20260708    gcc-12
x86_64      buildonly-randconfig-005-20260708    gcc-14
x86_64      buildonly-randconfig-006-20260708    clang-22
x86_64      buildonly-randconfig-006-20260708    gcc-12
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260708    gcc-14
x86_64                randconfig-002-20260708    clang-22
x86_64                randconfig-002-20260708    gcc-14
x86_64                randconfig-003-20260708    clang-22
x86_64                randconfig-003-20260708    gcc-14
x86_64                randconfig-004-20260708    clang-22
x86_64                randconfig-004-20260708    gcc-14
x86_64                randconfig-005-20260708    clang-22
x86_64                randconfig-005-20260708    gcc-14
x86_64                randconfig-006-20260708    gcc-14
x86_64                randconfig-011-20260707    clang-22
x86_64                randconfig-011-20260708    clang-22
x86_64                randconfig-012-20260707    gcc-14
x86_64                randconfig-012-20260708    clang-22
x86_64                randconfig-013-20260707    clang-22
x86_64                randconfig-013-20260708    clang-22
x86_64                randconfig-014-20260707    gcc-14
x86_64                randconfig-014-20260708    clang-22
x86_64                randconfig-015-20260707    gcc-14
x86_64                randconfig-015-20260708    clang-22
x86_64                randconfig-016-20260707    clang-22
x86_64                randconfig-016-20260708    clang-22
x86_64                randconfig-071-20260708    clang-22
x86_64                randconfig-072-20260708    clang-22
x86_64                randconfig-073-20260708    clang-22
x86_64                randconfig-074-20260708    clang-22
x86_64                randconfig-074-20260708    gcc-14
x86_64                randconfig-075-20260708    clang-22
x86_64                randconfig-076-20260708    clang-22
x86_64                randconfig-076-20260708    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                          iss_defconfig    gcc-16.1.0
xtensa                randconfig-001-20260708    gcc-14.3.0
xtensa                randconfig-001-20260708    gcc-8.5.0
xtensa                randconfig-002-20260708    gcc-16.1.0
xtensa                randconfig-002-20260708    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

