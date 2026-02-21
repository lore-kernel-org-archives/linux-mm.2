Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC7BE9A049
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 03:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 567536B0005; Fri, 20 Feb 2026 22:36:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514EB6B0089; Fri, 20 Feb 2026 22:36:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420FC6B008A; Fri, 20 Feb 2026 22:36:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2788D6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:36:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C588AB8724
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 03:35:59 +0000 (UTC)
X-FDA: 84467050038.23.64BE5C4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf09.hostedemail.com (Postfix) with ESMTP id AC4E7140009
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 03:35:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bv4qf8g0;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771644957; a=rsa-sha256;
	cv=none;
	b=pQIExkNnbmqRI+Q4SOqjL27CHPLwV6E2K+b33ZWL3csDzYh2Fp4MXEqdWswI0tzxBrXtJs
	q0fra4+D3CcWx/otC/hczBwsJAk9ewU2jhaLjmPRIAQ4BYzqbDq0oI3lW8cOC1OisBb9MQ
	BlOodm1JWU3+1a60YkhphRbpU86K2f8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bv4qf8g0;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771644957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ACbB7AGTRgKSj/pxQZSPGl6f1Zp9OKR6p+QWfalATsA=;
	b=Z/NfajDRT/AKYZ4GLUWRWpSDiIJb/gKNB1q7JlYPaH8/tQ+MQf1zJXnIv8oqgspk5SMGea
	pLrPRiNJID24bYp1GKRj3hf+qYQ2jzF/32UlDsUuCit5mMpTb8W+dzgRJT0J36B7+0u+iM
	nnAJhhGK7vx7kR+HtdXj/M/mGW0ePN4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771644956; x=1803180956;
  h=date:from:to:cc:subject:message-id;
  bh=/dEXj+gQT+9Ulqd0gg/q6/Act2w1ZsQm17xLNiA5meQ=;
  b=Bv4qf8g0wsK1gq/b2iN4PQkfxIomYi1jqt0LEdxuO9BTKbGg25TaTxIr
   iI6Vtjo+I5tW7c9XRwpoxvTJeQNMyr2zSzbd2EsR/eENZ8eGfk3LkOl1z
   SUUx9Lo5ygJbb21kroSKaLiad07DCCZy+yW2+00+GV0H4BNvB6MVx7Vop
   f0c6+dCw2X/vXcjxsxBhXoPdLluO2T1eoIIHqa21GARl3YIBcsCG8g8hA
   zrZTBB1Kd352MPp4OvQ+izjQcuux+bpXtfmgFRYeACGsi36xH/OUvupD0
   w4agoRkaCijxlh4F4ayVbMm+FODCxsdlo5JfYSBnJZ/98ahQ96WmWvXWo
   w==;
X-CSE-ConnectionGUID: XeopTItkSNmSASqhdB3YTQ==
X-CSE-MsgGUID: W9PBy3GNQEuu9y64EybuRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11707"; a="72797768"
X-IronPort-AV: E=Sophos;i="6.21,302,1763452800"; 
   d="scan'208";a="72797768"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2026 19:35:54 -0800
X-CSE-ConnectionGUID: Jv1HzZR0Swa0cA8p6BuneQ==
X-CSE-MsgGUID: fCqxkqwORs2pNKkkUVbDvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,302,1763452800"; 
   d="scan'208";a="215034818"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 20 Feb 2026 19:35:52 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vtdmY-000000014gA-0FCY;
	Sat, 21 Feb 2026 03:35:50 +0000
Date: Sat, 21 Feb 2026 11:34:51 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 d4906ae14a5f136ceb671bb14cedbf13fa560da6
Message-ID: <202602211143.lI4Fm07G-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: AC4E7140009
X-Stat-Signature: us8aknmsn1jatmrr35bq6ubj6x6cjcyd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771644955-514056
X-HE-Meta: U2FsdGVkX1/JMDMqtQ8GNn1CB85d0kEmCYsFVDV1HqAt0vWW7aI7QLvP6Z/RHzq8SoY+fKAFk3xU3cy+brWaDSkotl1S1gk2NH+msYeQzvXpwU//Rqb42zoLwdNF+oAF7Mvh1AMxxHusQTUllEaMNiBwSQUlEUGSzFVUzJ9W7QthzMOuInA5NMlaJcXGMwH8rY0boS55eZk65d+btWnOXYD2vRi8sI3mhcEPngVrgdedbOCnEpMdBfst+6wVW8T+JpUsmQPIPhw0r77PNGpLn6EyPXw2KugrQfpe7LnDyghyjkJ32o1kYmSIiKGlT2wdDtujY4PxZxnAMTVqUqnO1UoN076C3dyu1q6NXYMPGuBmhHqAOPCKxeVtNu+nKvqwCjwHPmKckkfiiPlaK1pJJTF3NMJJZgai52BjRLr5K/BqPWoe8PJ8NxRwk3r9xWaibgCeOZEnY4t7icDc2VMUx1mcYaTjsvXX7Ul2x6akZAhHPgkP5ndruuHp1oyNiUSWLAdBwrGgi+qnKqTHWMGrWW3PaZAKvqH3QGBd1D8mkJhd8XDnuhQwfTP3PQThRDJ5RJ63U4xoJxXBzF+azFSftg8pZ7SNOqVCGIolnCiPxVShhtI7o+DM4gTUA0qhQS3dkMtOro8LvOy7kFNJ2yIYUyt2uaYAEQBJYdnRJ+vbNFMGwjRo/AFdcvoOoJRnLtnzd1Vz9r+9iKAWkSBiO7GU1P5vZmdw24wDOpw/mDBnT4UNA01XX6tQg8ZBWCU56U5iHG3DFqadXaJ1wq59EylKgfBjP1cWCdCdvHM3kW35CCH4PTwNdDbxzO6tw5N72V/9RhkPwA+Oi2LBl0wxIZS89fHJyAykXuNh3J5Apk0gFqukWJvk652eoz7DfRsekae4AoUchHcY/ufyZE5LlMxi5Gp1YwT872vVydhg8jFD7RNxtw4tSQXldLm6keKJ4JvMUBnNJu+geTQMRn1dunO
 GiytI16x
 rWz4Hol5mkoQzVKCx4L+VZLJltjsD3WhMMW2bdhGF/DhyvjBlNJWVu/BnCPCBRoJsks9UlhzvPUfIWgqGV7xKq6MlrNwS8FBBUu8x+04aF2+SyZDYv+MGDQgCfqstzXGIno3UOGHekvJEJ1yIaKgBGswREPLHWI7SnyQX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: d4906ae14a5f136ceb671bb14cedbf13fa560da6  Add linux-next specific files for 20260220

elapsed time: 733m

configs tested: 257
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260220    gcc-8.5.0
arc                   randconfig-001-20260221    gcc-14.3.0
arc                   randconfig-002-20260220    gcc-8.5.0
arc                   randconfig-002-20260221    gcc-14.3.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                       aspeed_g4_defconfig    clang-23
arm                       aspeed_g5_defconfig    clang-23
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                             mxs_defconfig    clang-23
arm                         nhk8815_defconfig    clang-23
arm                          pxa910_defconfig    clang-23
arm                   randconfig-001-20260220    gcc-10.5.0
arm                   randconfig-001-20260221    gcc-14.3.0
arm                   randconfig-002-20260220    clang-23
arm                   randconfig-002-20260221    gcc-14.3.0
arm                   randconfig-003-20260220    clang-23
arm                   randconfig-003-20260221    gcc-14.3.0
arm                   randconfig-004-20260220    gcc-10.5.0
arm                   randconfig-004-20260221    gcc-14.3.0
arm                         s3c6400_defconfig    clang-23
arm                         s3c6400_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260221    clang-23
arm64                 randconfig-002-20260221    clang-23
arm64                 randconfig-003-20260221    clang-23
arm64                 randconfig-003-20260221    gcc-8.5.0
arm64                 randconfig-004-20260221    clang-23
arm64                 randconfig-004-20260221    gcc-10.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260221    clang-23
csky                  randconfig-001-20260221    gcc-11.5.0
csky                  randconfig-002-20260221    clang-23
csky                  randconfig-002-20260221    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260221    clang-23
hexagon               randconfig-002-20260221    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260221    clang-20
i386        buildonly-randconfig-001-20260221    gcc-14
i386        buildonly-randconfig-002-20260221    clang-20
i386        buildonly-randconfig-003-20260221    clang-20
i386        buildonly-randconfig-004-20260221    clang-20
i386        buildonly-randconfig-005-20260221    clang-20
i386        buildonly-randconfig-005-20260221    gcc-14
i386        buildonly-randconfig-006-20260221    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260221    gcc-14
i386                  randconfig-002-20260221    clang-20
i386                  randconfig-002-20260221    gcc-14
i386                  randconfig-003-20260221    gcc-12
i386                  randconfig-003-20260221    gcc-14
i386                  randconfig-004-20260221    clang-20
i386                  randconfig-004-20260221    gcc-14
i386                  randconfig-005-20260221    clang-20
i386                  randconfig-005-20260221    gcc-14
i386                  randconfig-006-20260221    gcc-14
i386                  randconfig-007-20260221    gcc-14
i386                  randconfig-011-20260221    clang-20
i386                  randconfig-011-20260221    gcc-14
i386                  randconfig-012-20260221    clang-20
i386                  randconfig-012-20260221    gcc-14
i386                  randconfig-013-20260221    gcc-14
i386                  randconfig-014-20260221    clang-20
i386                  randconfig-014-20260221    gcc-14
i386                  randconfig-015-20260221    gcc-14
i386                  randconfig-016-20260221    gcc-14
i386                  randconfig-017-20260221    gcc-14
loongarch                        alldefconfig    clang-23
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260221    clang-23
loongarch             randconfig-001-20260221    gcc-15.2.0
loongarch             randconfig-002-20260221    clang-18
loongarch             randconfig-002-20260221    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                          hp300_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                    maltaup_xpa_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260221    clang-23
nios2                 randconfig-001-20260221    gcc-11.5.0
nios2                 randconfig-002-20260221    clang-23
nios2                 randconfig-002-20260221    gcc-10.5.0
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
parisc                randconfig-001-20260221    gcc-8.5.0
parisc                randconfig-001-20260221    gcc-9.5.0
parisc                randconfig-002-20260221    gcc-8.5.0
parisc                randconfig-002-20260221    gcc-9.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                     akebono_defconfig    clang-23
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                      chrp32_defconfig    clang-19
powerpc                          g5_defconfig    clang-23
powerpc               randconfig-001-20260221    gcc-12.5.0
powerpc               randconfig-001-20260221    gcc-9.5.0
powerpc               randconfig-002-20260221    gcc-9.5.0
powerpc64             randconfig-001-20260221    gcc-11.5.0
powerpc64             randconfig-001-20260221    gcc-9.5.0
powerpc64             randconfig-002-20260221    gcc-8.5.0
powerpc64             randconfig-002-20260221    gcc-9.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260221    gcc-10.5.0
riscv                 randconfig-001-20260221    gcc-8.5.0
riscv                 randconfig-002-20260221    gcc-10.5.0
riscv                 randconfig-002-20260221    gcc-12.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260221    clang-23
s390                  randconfig-001-20260221    gcc-10.5.0
s390                  randconfig-002-20260221    gcc-10.5.0
s390                  randconfig-002-20260221    gcc-14.3.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260221    gcc-10.5.0
sh                    randconfig-002-20260221    gcc-10.5.0
sh                    randconfig-002-20260221    gcc-15.2.0
sh                           se7705_defconfig    gcc-15.2.0
sh                           se7724_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260221    gcc-15.2.0
sparc                 randconfig-002-20260221    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260221    gcc-8.5.0
sparc64               randconfig-002-20260221    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260221    gcc-14
um                    randconfig-002-20260221    clang-23
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260221    clang-20
x86_64      buildonly-randconfig-002-20260221    clang-20
x86_64      buildonly-randconfig-003-20260221    clang-20
x86_64      buildonly-randconfig-004-20260221    clang-20
x86_64      buildonly-randconfig-005-20260221    clang-20
x86_64      buildonly-randconfig-006-20260221    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260221    clang-20
x86_64                randconfig-001-20260221    gcc-14
x86_64                randconfig-002-20260221    gcc-14
x86_64                randconfig-003-20260221    gcc-14
x86_64                randconfig-004-20260221    clang-20
x86_64                randconfig-004-20260221    gcc-14
x86_64                randconfig-005-20260221    clang-20
x86_64                randconfig-005-20260221    gcc-14
x86_64                randconfig-006-20260221    gcc-14
x86_64                randconfig-011-20260221    gcc-14
x86_64                randconfig-012-20260221    gcc-14
x86_64                randconfig-013-20260221    clang-20
x86_64                randconfig-014-20260221    gcc-14
x86_64                randconfig-015-20260221    gcc-14
x86_64                randconfig-016-20260221    gcc-14
x86_64                randconfig-071-20260221    clang-20
x86_64                randconfig-071-20260221    gcc-14
x86_64                randconfig-072-20260221    clang-20
x86_64                randconfig-073-20260221    clang-20
x86_64                randconfig-074-20260221    clang-20
x86_64                randconfig-074-20260221    gcc-14
x86_64                randconfig-075-20260221    clang-20
x86_64                randconfig-076-20260221    clang-20
x86_64                randconfig-076-20260221    gcc-12
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
xtensa                randconfig-001-20260221    gcc-8.5.0
xtensa                randconfig-002-20260221    gcc-12.5.0
xtensa                         virt_defconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

