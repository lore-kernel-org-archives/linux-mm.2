Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 882E1EF99FF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 06:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0866B0005; Sat, 14 Feb 2026 01:24:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E7D6B0088; Sat, 14 Feb 2026 01:24:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90F16B008A; Sat, 14 Feb 2026 01:24:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6266B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 01:24:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4AA64160764
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 06:24:19 +0000 (UTC)
X-FDA: 84442072638.17.75EFB56
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id 40FBB140003
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 06:24:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gxUmf5Mg;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771050257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=hVF4RYqWz+kMklf9ti7KcPaTzh4DHXiJpjM5uadGZYw=;
	b=MIBkw6cI3UnFnG0roBn2r2OjGF8xW5ZIXBWfXOcQcklNhdVX84XlAz6pSGd0rlCy310XEY
	gD3wYzltQnzIL+/yCyTnRs3Zk+y26xZt7ZDufDHjXRHcA++cZztk/YvG5PXk/Ti70nbUti
	B0szAl4v+qzGql6JGMoetygTYjtcoZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771050257; a=rsa-sha256;
	cv=none;
	b=Xh/6sAPjnBXgt8hPJSP1R1mj0KDHFXoWYA0ia3PbeYVIOYGL5UbRpvHUMJUqNXSFMkZJvI
	4kdj1jtGH8H0CZnleYhnXDgBzNu8QHpd1/DYgye55qOqDHaHjQoiodbAdF0Qlj93wOSdI/
	J8DmZuAeipIczHIXKBDOSpheSThslZ4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gxUmf5Mg;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771050256; x=1802586256;
  h=date:from:to:cc:subject:message-id;
  bh=JCt8GuVYlWpczNFXT6avh+4x6Fp2k+pdDqBaj7GVX2s=;
  b=gxUmf5Mg6nyY0T6BLakzk4wuUH6i19/zrrgnSR4BrnIeUMozlr6rdOan
   Paampd9dJFsgCYD85VW31fETeDWuZ2M0mrwe2Qje2wWL2KkJ8C6KuOTIa
   KNm+IKy/xRKeGjkz2hcjZqSF7LdEZzPUWQATXAgmudaZit7ewsAracj6q
   hn7HoMw3o8ByxVgr+BEZs/3hHzMHbmCYODLWrosXm4ej4fypQdMPhoBxG
   e7+yD3ktk2oxq14PEeB9OrFbpyx51DY62sc9VC2CgYotFNeq5zU2AjCnV
   x7tBVbgbQmo07MdKjTjPktxRROv/f4EoxMI2heuAbqm8MjMOFxySluX4k
   w==;
X-CSE-ConnectionGUID: 5T1iWkDfSjODb9eL/ua8BQ==
X-CSE-MsgGUID: 8WI7tWtuQuyhgB/CZCmUCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="71424342"
X-IronPort-AV: E=Sophos;i="6.21,290,1763452800"; 
   d="scan'208";a="71424342"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 22:24:15 -0800
X-CSE-ConnectionGUID: SuSGXp1ISlSxyIf1H6yTpg==
X-CSE-MsgGUID: RvEkuWXOTZG/Z1A1ikacvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,290,1763452800"; 
   d="scan'208";a="212372031"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 13 Feb 2026 22:24:13 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vr94c-00000000wHC-438Q;
	Sat, 14 Feb 2026 06:24:10 +0000
Date: Sat, 14 Feb 2026 14:24:00 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 635c467cc14ebdffab3f77610217c1dacaf88e8c
Message-ID: <202602141451.n97rX76I-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 40FBB140003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8fb1dpi7euf7wmu4hro89o1cicug3j5m
X-HE-Tag: 1771050256-981832
X-HE-Meta: U2FsdGVkX1/hUn6tp6NpZjZFkbwQSDJcbkFOxfxibg/E8jk+bmmH1WrALeJ6I8iYEg9yc/5+nvxMjbmfsOIK6KaIyd8Lffn/xEdROl5B5pM7rhYbiFUchDKplP2U2go6lHEEVkZbR3FEu0PsQ1UKF0mnhytSlkoL+uQQB/zDQwK9R7WOxun2sLvEpcV8+SZGntI+yLKSHl4e1vq48steNhj9AVftig3hlgHHv+hSRlCPr9Dm5vMH7mAp2GOh2WLyco51NRezb+Sd01+5SU7HP6OAS3npKzzSw9LLby93wBK0W5fF73Y3D7ny8BxSziqK1xXiKwMRCi8045LhUW0z0frMSfBY2UzWUwoqyfuOgbudEfKgWtCW2dTfmBAi3BTppZuNas1zSpY1cSDbAANCt8m3VQHQ1qJNYBlkH+piTiUdIeWcUQqkRCEJ4IbDTJZFvyy0hydyoMZ/YYMYx+IcUJZUZm9j0quUVfOlBWA3bkaSokadLMwRmjBL7bctYKnQV48N7JsZ75VIXLxO1QJa3pWIwN8xX6yvtwStcjp5+Ai5Fy1sKqFTChHw+yGFA+eVpPd5z1X8RIaAKwLxS58kO/V6ceklm8Ppc+VyTnWhfRtjwJdAg0Japz3pBVEgtD94tFA2kvq+wDUiWnxWbbXYU7I9Wfgh8moqjE0O1jJlCKag62VhOwIRhWH7Pikyk5Wd1ybk0ArdBaqtRMsyDVIoAlUEWYZ1H6NWoUfyzwU0n2AOBVJ1GZs1VKRCcWbGRGEKGhP4jlC2McfEDzF/jIhdIjTAjE+1pCVbTdWRcdEIi+4khj/XRo8kcLQ5KD+Nc/nZVp+L77VhFJ+G2ZPQUTmflUHnzhXivAlPaaLEb9BoNMesTdRG85uu/Pr+N13bwS438b40tXEj1L8KAYAM7HbS/0+BiFzHozxIKzTH5b8GFppR8twQnZKgmeOl0CyqntKLZbN5n3NaR+65wOEWTzU
 XpNtyCSo
 lA1chsTLNn9snJw40WAGpoLlsNjqzKMHdQ+ZnrR4LXwmYyZYnfqtLdmEw7SgxQUmourrh8LILFpZarn3FKn5GeKFNJ0R51W552iXSFBQM4pmO34OHYLq8nwY6pzfgb9KAxK7D8BZU4A2e0IlxKViWrJzNYjAV3fc31XeO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 635c467cc14ebdffab3f77610217c1dacaf88e8c  Add linux-next specific files for 20260213

elapsed time: 730m

configs tested: 171
configs skipped: 2

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
arc                   randconfig-001-20260214    gcc-13.4.0
arc                   randconfig-002-20260214    gcc-9.5.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20260214    gcc-13.4.0
arm                   randconfig-002-20260214    clang-22
arm                   randconfig-003-20260214    clang-22
arm                   randconfig-004-20260214    gcc-8.5.0
arm                         s5pv210_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260214    clang-22
arm64                 randconfig-002-20260214    gcc-8.5.0
arm64                 randconfig-003-20260214    gcc-14.3.0
arm64                 randconfig-004-20260214    gcc-14.3.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260214    gcc-12.5.0
csky                  randconfig-002-20260214    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20260214    clang-22
hexagon               randconfig-002-20260214    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260214    clang-20
i386        buildonly-randconfig-002-20260214    clang-20
i386        buildonly-randconfig-003-20260214    clang-20
i386        buildonly-randconfig-004-20260214    clang-20
i386        buildonly-randconfig-005-20260214    clang-20
i386        buildonly-randconfig-006-20260214    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20260214    clang-20
i386                  randconfig-002-20260214    clang-20
i386                  randconfig-003-20260214    clang-20
i386                  randconfig-004-20260214    gcc-14
i386                  randconfig-005-20260214    clang-20
i386                  randconfig-006-20260214    gcc-14
i386                  randconfig-007-20260214    gcc-14
i386                  randconfig-011-20260214    gcc-14
i386                  randconfig-012-20260214    gcc-14
i386                  randconfig-013-20260214    gcc-14
i386                  randconfig-014-20260214    gcc-14
i386                  randconfig-015-20260214    clang-20
i386                  randconfig-016-20260214    clang-20
i386                  randconfig-017-20260214    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260214    gcc-14.3.0
loongarch             randconfig-002-20260214    clang-22
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                       bvme6000_defconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
m68k                        m5407c3_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                  decstation_64_defconfig    gcc-15.2.0
mips                      loongson1_defconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260214    gcc-10.5.0
nios2                 randconfig-002-20260214    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260214    gcc-9.5.0
parisc                randconfig-002-20260214    gcc-15.2.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc                    ge_imp3a_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260214    clang-18
powerpc               randconfig-002-20260214    clang-22
powerpc64             randconfig-001-20260214    clang-22
powerpc64             randconfig-002-20260214    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20260214    gcc-8.5.0
riscv                 randconfig-002-20260214    gcc-14.3.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                  randconfig-001-20260214    clang-20
s390                  randconfig-002-20260214    gcc-9.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                     magicpanelr2_defconfig    gcc-15.2.0
sh                    randconfig-001-20260214    gcc-10.5.0
sh                    randconfig-002-20260214    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260214    gcc-8.5.0
sparc                 randconfig-002-20260214    gcc-14.3.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260214    gcc-9.5.0
sparc64               randconfig-002-20260214    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260214    gcc-14
um                    randconfig-002-20260214    clang-22
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260214    gcc-13
x86_64      buildonly-randconfig-002-20260214    gcc-14
x86_64      buildonly-randconfig-003-20260214    clang-20
x86_64      buildonly-randconfig-004-20260214    clang-20
x86_64      buildonly-randconfig-005-20260214    clang-20
x86_64      buildonly-randconfig-006-20260214    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260214    clang-20
x86_64                randconfig-002-20260214    gcc-14
x86_64                randconfig-003-20260214    gcc-14
x86_64                randconfig-004-20260214    gcc-14
x86_64                randconfig-005-20260214    clang-20
x86_64                randconfig-006-20260214    gcc-14
x86_64                randconfig-011-20260214    clang-20
x86_64                randconfig-012-20260214    gcc-14
x86_64                randconfig-013-20260214    gcc-14
x86_64                randconfig-014-20260214    clang-20
x86_64                randconfig-015-20260214    gcc-14
x86_64                randconfig-016-20260214    gcc-14
x86_64                randconfig-071-20260214    clang-20
x86_64                randconfig-072-20260214    clang-20
x86_64                randconfig-073-20260214    clang-20
x86_64                randconfig-074-20260214    clang-20
x86_64                randconfig-075-20260214    gcc-14
x86_64                randconfig-076-20260214    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260214    gcc-15.2.0
xtensa                randconfig-002-20260214    gcc-14.3.0
xtensa                    xip_kc705_defconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

