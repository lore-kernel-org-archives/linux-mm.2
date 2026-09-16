Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9D7C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 04:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462E86B0088; Wed, 16 Sep 2026 00:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B5E6B008C; Wed, 16 Sep 2026 00:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CED6B0092; Wed, 16 Sep 2026 00:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C62A6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:27:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9AA4E1C2A5F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:26:59 +0000 (UTC)
X-FDA: 85218340158.06.A983FA0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf19.hostedemail.com (Postfix) with ESMTP id 192291A0003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:26:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lVobnHU/";
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789532817;
	b=SMtzDD9bpz/TlSVRi797c9Jj3+vqA/o77nMIpOiM2fHKohVum4q25GHCTO4cVfCQ0gTFGW
	BZ5wdFG6KT1stMRenSs7To58+n67lsPPr9eYetScNRhTIYqRuLLOA2LeeXKUDzbSqg05nl
	M8xeiHJlOj3lGfTHBcb5V8Mh1fZNoAU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lVobnHU/";
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789532817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=S8yQdWROPFbZrtkwHc1+P64nzM13/IMmJDol6ypIqoU=;
	b=8Lmpb07na3PjM5X4kqfmeYHBrBaOtAX/dTVOQAQ1x5kCh2A3S70mqB3LX+DqSWwQfNWLY+
	nhEzu+68z8DKztiMylwXNFGlHUi7A2ExhtO9rf51EwZJMRLq/JujXYv+pAwpVpoHIfsOQd
	1acRZebfP406r73OqoH13IRTiW4nub0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789532817; x=1821068817;
  h=date:from:to:cc:subject:message-id;
  bh=H1F7OYseeUqDrYPk0vo1Gp/5wZAda03MTZ9fwO7JlAo=;
  b=lVobnHU/oVAqtQrUo1oCAfa5eJEB2dT+Mwqv9OYwNvAOnATT0iwnmhxY
   2bbUtpkXIl0pD1kytN26ICNVYUT1gvTiiQX1DJ2ShFrC+aHESInBcjWoH
   5xg5uPbagq6dRcB/Zo25AO2egwx2R7Gnx71c+TabDkEZCms5mqGvKgzbA
   x3IuQadX/V6xmArIkwNa2wfObz/qm7attxuW5qDmRp4OG2dzL4o1lzjtZ
   NOPwxz6ujd3o9O1RfJu9Yj0cgSzwg99fHULEEObg4LF2YF3DgC0LaNl3f
   elHmF6tSMaT32Aj0UAcxkHHxPZYCohwhb4X4GtJJLqoce7MYRMZWoerIl
   g==;
X-CSE-ConnectionGUID: GLhrKSVPSZCW0jkrVERgwg==
X-CSE-MsgGUID: kS8VFsU2SWai9F3drq4mFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="101249885"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="101249885"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 21:26:56 -0700
X-CSE-ConnectionGUID: LNCGauBNR9S+hS7GeXMMCg==
X-CSE-MsgGUID: YJhXFVtgQnWYZE0MRk8gLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="269532247"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 15 Sep 2026 21:26:54 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6hER-000000005VN-3MrG;
	Wed, 16 Sep 2026 04:26:51 +0000
Date: Wed, 16 Sep 2026 12:26:22 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 b08a65b93426d86e3f354d655d6225397b591877
Message-ID: <202609161219.C8Ab4FMv-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 192291A0003
X-Stat-Signature: pdun3zfkaxbe8exyqe943gnaw63x4kmr
X-Rspam-User: 
X-HE-Tag: 1789532816-780804
X-HE-Meta: U2FsdGVkX18q7CE+3UiOASC0U6NDDqoZU2qOBJNPJw+yYNt31PkT/8efqamH+la6KMQmDyvL96QAbEnfufOCH39zWjMIA8f0eqqShNH5OP1fncGxZ2JGL74eG+QeSvMt7Mv9pT16uXvJEwjE92kQL/8uj8vtIGmvAk7PS1n1YCTBoPBE8v9SWXnQaztF1nDS/bqOEpNj+cDef2WFe7V5xOZqgvQwYr4KrWT6irmDmwm4VJC/6dZUKccqKfBOk150NKbwFx9rnMa3Q651OtNDZNQtkDVcbbAS0OXXTtcI9br9I27ekZMjMRopfDcZuH3ZBRs9UQlImeGT2x59Mh/513EX9A/neDjvP8eB3Hn48D2omudGuCfKpZ0I+9eo61t9U5oURfiaMuq1nuEKV5pwhwBy+SwTAvrh6ybHR2ZWIZZtARSK87IHJzpr6LpCMjLvX3IzshIBiglCMwzl37HwPpvr2BrYA/HscV/geFGhIUS1fevrKRzieSDr29ht2E5Vp03Ug6C1f6Z44pzrZnA6derk8Q1dHCsBHhGIqLAj224Pgqi15y07+EvyOkJTMbfUIAU7WF88zxHkDoX1DzRaldvD+bQdxFcAIIlGyaaR4EcArd7n+F/fp+LS6r2dV8vZyj+5EkK3e+ajz/dkIaGKnz0vjpYHo1wa9KKT7ufsutTzefSzNwSrLrEUQXU7F/iYoqAK6crJPcZed8l7Tltpvw6LwRzYM/VTcTnvpjW//nYYpiffBwDWC2+vwmibUC676LvnJVZOnlWgr1RjLs25Fz3r2oOy/dxkry5O0F7PP/Jhx6bglTtxBAcU0Hs5PHRAZkdHjswmQlSq8/aqF9lw1BsXpYjGxX/+K7RGppX9Fa2S1sqRsgtA5hOUN4/p+1IZVmRhdXTV5UXq2IwFPbOdxKIZ55Ow1bjcrxBzkj6L5MtIL2jG/GfXRrzoc+l9URFt0qiSNBd8sYIusyel1E+
 vObWe5T4
 /Yj67+L/vUtxzn7umiY1cEixXFrj5IV5njUsuNFDrri92P29CNv2za3/BC/rw18jbVbdrlCEXbiCKIIA3rRgQ3SJ5JYbvpCXgf24BrIPtAmqrK1vLnwnwipN/i/f2WeokPlz88YOF50Q/7IC6Kb9y5Vi3y+Hut8WEXospOo7dLtysXjmLEHAJudRQXgDqM9jgbXMROgoW7AZSnd1Y0lZj4eCQN2Vw0Ft1Cw1T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: b08a65b93426d86e3f354d655d6225397b591877  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609160337.WJiD9BqX-lkp@intel.com

    fs/proc/task_mmu.c:3448:3: error: implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'? [-Werror=implicit-function-declaration]
    fs/proc/task_mmu.c:3450:3: error: implicit declaration of function 'reacquire_rcu'; did you mean 'get_file_rcu'? [-Werror=implicit-function-declaration]

Error/Warning ids grouped by kconfigs:

recent_errors
`-- riscv-randconfig-002-20260915
    |-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-drop_rcu
    `-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-reacquire_rcu

elapsed time: 1007m

configs tested: 164
configs skipped: 8

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260915    gcc-8.5.0
arc                   randconfig-002-20260915    gcc-10.5.0
arm                               allnoconfig    clang-17
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                   randconfig-001-20260915    clang-24
arm                   randconfig-002-20260915    clang-24
arm                   randconfig-003-20260915    gcc-10.5.0
arm                   randconfig-004-20260915    clang-24
arm                  randconfig-r113-20260915    gcc-15.2.0 sparse
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260916    gcc-8.5.0
arm64                 randconfig-002-20260916    clang-24
arm64                 randconfig-003-20260916    gcc-8.5.0
arm64                 randconfig-004-20260916    gcc-9.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260916    gcc-9.5.0
csky                  randconfig-002-20260916    gcc-16.1.0
hexagon                          allmodconfig    clang-24
hexagon                           allnoconfig    clang-24
hexagon                             defconfig    clang-24
hexagon               randconfig-001-20260915    clang-17
hexagon               randconfig-002-20260915    clang-24
i386                             alldefconfig    gcc-14
i386                              allnoconfig    gcc-14
i386        buildonly-randconfig-001-20260915    clang-22
i386        buildonly-randconfig-002-20260915    clang-22
i386        buildonly-randconfig-003-20260915    gcc-13
i386        buildonly-randconfig-004-20260915    gcc-14
i386        buildonly-randconfig-005-20260915    clang-22
i386        buildonly-randconfig-006-20260915    clang-22
i386                                defconfig    clang-22
i386                  randconfig-002-20260915    gcc-14
i386                  randconfig-003-20260915    gcc-14
i386                  randconfig-004-20260915    clang-22
i386                  randconfig-005-20260915    clang-22
i386                  randconfig-006-20260915    gcc-13
i386                  randconfig-007-20260915    clang-22
i386                  randconfig-061-20260915    clang-22 sparse
i386                  randconfig-062-20260915    gcc-14 sparse
i386                  randconfig-063-20260915    clang-22 sparse
i386                 randconfig-r134-20260915    gcc-14 sparse
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-20
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260915    clang-24
loongarch             randconfig-002-20260915    clang-21
loongarch            randconfig-r132-20260915    clang-24 sparse
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
m68k                       m5235evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
microblaze           randconfig-r122-20260915    gcc-8.5.0 sparse
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                           gcw0_defconfig    clang-24
mips                      maltasmvp_defconfig    gcc-16.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260915    gcc-8.5.0
nios2                 randconfig-002-20260915    gcc-8.5.0
nios2                randconfig-r133-20260915    gcc-8.5.0 sparse
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260915    gcc-13.4.0
parisc                randconfig-002-20260915    gcc-15.2.0
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    gcc-16.1.0
powerpc                       eiger_defconfig    clang-24
powerpc               randconfig-001-20260915    gcc-10.5.0
powerpc               randconfig-002-20260915    clang-24
powerpc64             randconfig-001-20260915    gcc-8.5.0
powerpc64             randconfig-002-20260915    clang-24
powerpc64            randconfig-r121-20260915    clang-24 sparse
powerpc64            randconfig-r131-20260915    clang-24 sparse
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
riscv                 randconfig-002-20260915    gcc-8.5.0
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260915    gcc-9.5.0
s390                  randconfig-002-20260915    clang-17
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260915    gcc-10.5.0
sh                    randconfig-002-20260915    gcc-16.1.0
sh                           se7712_defconfig    gcc-16.1.0
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260915    gcc-8.5.0
sparc                 randconfig-002-20260915    gcc-13.4.0
sparc                randconfig-r111-20260915    gcc-8.5.0 sparse
sparc                       sparc32_defconfig    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64               randconfig-001-20260915    gcc-15.2.0
sparc64               randconfig-002-20260915    gcc-9.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                               allyesconfig    gcc-14
um                                  defconfig    clang-24
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260915    clang-24
um                    randconfig-002-20260915    clang-24
um                   randconfig-r112-20260915    gcc-12 sparse
um                           x86_64_defconfig    clang-24
x86_64                            allnoconfig    clang-22
x86_64      buildonly-randconfig-001-20260915    clang-22
x86_64      buildonly-randconfig-002-20260915    clang-22
x86_64      buildonly-randconfig-003-20260915    gcc-14
x86_64      buildonly-randconfig-004-20260915    clang-22
x86_64      buildonly-randconfig-005-20260915    gcc-14
x86_64      buildonly-randconfig-006-20260915    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-011-20260915    gcc-14
x86_64                randconfig-012-20260915    clang-22
x86_64                randconfig-013-20260915    clang-22
x86_64                randconfig-014-20260915    clang-22
x86_64                randconfig-015-20260915    gcc-14
x86_64                randconfig-016-20260915    clang-22
x86_64                randconfig-071-20260915    clang-22
x86_64                randconfig-072-20260915    clang-22
x86_64                randconfig-073-20260915    clang-22
x86_64                randconfig-074-20260915    gcc-13
x86_64                randconfig-075-20260915    clang-22
x86_64                randconfig-076-20260915    gcc-14
x86_64                randconfig-121-20260915    clang-22 sparse
x86_64                randconfig-122-20260915    clang-22 sparse
x86_64                randconfig-123-20260915    gcc-14 sparse
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    gcc-16.1.0
xtensa                  audio_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-001-20260915    gcc-15.2.0
xtensa                randconfig-002-20260915    gcc-8.5.0
xtensa               randconfig-r123-20260915    gcc-11.5.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

