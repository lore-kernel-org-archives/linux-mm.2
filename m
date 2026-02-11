Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F5EE9E301
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 12:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4156B0005; Wed, 11 Feb 2026 07:58:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A21C6B0089; Wed, 11 Feb 2026 07:58:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CEAB6B008C; Wed, 11 Feb 2026 07:58:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6549C6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:58:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00AAD140391
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:58:36 +0000 (UTC)
X-FDA: 84432179874.11.558EB35
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf22.hostedemail.com (Postfix) with ESMTP id 67178C0003
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:58:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fU2XmaJr;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770814715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=p4Sr6EYVbeBNXr5ejnnwJhGUVisN/Uj/RoOsnFWKF4o=;
	b=J3VlOC38g6beKfWcqUNOsy3eEUY3qSOG9p2qCTfiIItAYXe9LvnfUsAxNgoTUE9jCKo3vp
	NVWs4HxES2pvFtMnbl02X5AaKFu01UUtE8RouTmi/2mFa/LShn9U1whVYLUR4wjjR9ghr6
	uCeDJowbBCbi2saNgMtQSLuLbXoseOU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fU2XmaJr;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770814715; a=rsa-sha256;
	cv=none;
	b=fkPsxlPjcGQGdWBnZCsmIhwDLkPqEiYhhGwDGqEX+jPOH+bku85/OS2fkaUUgkQkDPWahI
	rOIe4xFYwJv0q5HxY5ajLdTTe047HTtLT9+sw2LT4/YW8J3+BXPXRxX9+l/Ni8qk1V5qcj
	496PpzQh+6YZBWAztwNJ4xnT7bRFQsA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770814714; x=1802350714;
  h=date:from:to:cc:subject:message-id;
  bh=IPtQztSig5OhgKFqbll66Wrp6PQo8olKGno34Hp6ExA=;
  b=fU2XmaJr2tJUT1FwQQESomVTUn/Y+e3ao9gNfBEhehq/WEq732vT21CM
   YKKBZeAWmy0FZV/Tz8oPGqnfQ8vUBWIh6NX9kOBsgxyXeLSrrVyzNZUsC
   jVertFRCLCxo991M3ebxhwj3PseOadm0DdTJdpYsxgj8kNrAXLr6cZj0Z
   BAOWnNYEd/0ERB0fgA15jVekmqtxVJE5zHPE58TmPDSiqiubeIItbKDNT
   4mUh0AppBtTBDXruGhn5F4cDjyvhlxydqIqUPDF5lmBBp2t6uPTGTwnYd
   /iNdF2xEhwry1gyKDD87JCKvz1I2H5GqMfsRAHDJuQodNNnchbsQYtPYT
   w==;
X-CSE-ConnectionGUID: a/cs8ZZtSHqexKJeXMvOYw==
X-CSE-MsgGUID: MV9lXKpGStSyJJN+E9F8Qw==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="89369297"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="89369297"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 04:58:33 -0800
X-CSE-ConnectionGUID: 4aiRs4slQJ6th+ZiMS7glQ==
X-CSE-MsgGUID: 7l6TudoXStqACFligGjgWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211345621"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 11 Feb 2026 04:58:31 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vq9nZ-00000000q0A-0Lb0;
	Wed, 11 Feb 2026 12:58:29 +0000
Date: Wed, 11 Feb 2026 20:58:17 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 fd9678829d6dd0c10fde080b536abf4b1121c346
Message-ID: <202602112007.qfK0Io8g-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: fsd6ssqnrcjwu7ce5znhe9k8saf7hx1i
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 67178C0003
X-HE-Tag: 1770814714-301163
X-HE-Meta: U2FsdGVkX1/t12Qm2mNdVJbTDX/0Qtc2atYyvNaqPFVnt0MbElTa5+QOyQzjaAz4yJpYzwYihHCaYTmlc0udbBzFbqscukmm4da1WGuJ227Gu1pgUwm+Laa5Iy6dS42qNFlgAtkObUR7QB6m72DQYhmPNIhXMytv74drGbfBFuHHoagbBoMqiwVU1ORdf6rzpSaE9XFggtWFQCDcWP79MAB9mxgrooGyvJA/y1hKwGZIgoPHvD/4EMknpdoMq7HVk19j+MeebkCxT75IvVIZd0FoKnfsEjf0+FuRjro5ivC609zd1CQXxkoYYkfL26p5ErQCxWrmU0LVcXZ0ADqgDvCS6koaaop1GPVg4eWThCWKKhkVozA8zX8epJs3N+ZuFJCRu312v32ESuiYfRBuHNCUTlakphmKVMdM72hiPApsUCDugsovGwhrPjPfNvBBC7qq3ZseXNdYtDtaArrphTZUgHla658pxrvigrDHO5kZ37R/WIwD7MJkrcWUAtUkBMUd7KJ13wkzuIA2K74NljDj/ZoqntGAcgIFum94jdqDGJvT9O0/AXi+hZCFbr1wqgwcOwM/wKJa98GQuNjEJYNeT6yF/hg+UD9ooPZP7GbiTz5dykzemQBMRTN2l3EttlNA/3aAkXcRYgSeSoYdBuH0mFl5+BEUqFAyx6lMCuLdR53A8rRW8nH+1Twoun+1adEQ6as3iZ7RFR/Ao3Mb+n4CJboreBaB5Hxliv8Yji7/rL8FG9GA3IU7jDc8S4zNgvntiSmoRr9up6QH1S0DANXXyQAfcw/7OtOXhNBLfFuw97KttvqmvinwMd3ibKiQ6jdBCIS9OUD3KwUsiuebfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: fd9678829d6dd0c10fde080b536abf4b1121c346  Add linux-next specific files for 20260210

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202602110708.x7AYvCN7-lkp@intel.com

    include/linux/compiler_types.h:617:38: error: call to '__compiletime_assert_304' declared with attribute error: BUILD_BUG_ON failed: IS_ERR(PTR)

Error/Warning ids grouped by kconfigs:

recent_errors
`-- parisc-randconfig-r122-20260211
    `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:BUILD_BUG_ON-failed:IS_ERR(PTR)

elapsed time: 829m

configs tested: 257
configs skipped: 5

tested configs:
alpha                            alldefconfig    gcc-15.2.0
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                     haps_hs_smp_defconfig    gcc-15.2.0
arc                   randconfig-001-20260211    gcc-8.5.0
arc                   randconfig-001-20260211    gcc-9.5.0
arc                   randconfig-002-20260211    gcc-8.5.0
arc                   randconfig-002-20260211    gcc-9.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                            hisi_defconfig    gcc-15.2.0
arm                       multi_v4t_defconfig    gcc-15.2.0
arm                   randconfig-001-20260211    gcc-10.5.0
arm                   randconfig-001-20260211    gcc-8.5.0
arm                   randconfig-002-20260211    gcc-8.5.0
arm                   randconfig-003-20260211    clang-22
arm                   randconfig-003-20260211    gcc-8.5.0
arm                   randconfig-004-20260211    gcc-8.5.0
arm                           sunxi_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260211    gcc-8.5.0
arm64                 randconfig-002-20260211    gcc-15.2.0
arm64                 randconfig-003-20260211    gcc-15.2.0
arm64                 randconfig-004-20260211    gcc-14.3.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260211    gcc-15.2.0
csky                  randconfig-002-20260211    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260211    clang-22
hexagon               randconfig-002-20260211    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260211    clang-20
i386        buildonly-randconfig-002-20260211    gcc-12
i386        buildonly-randconfig-003-20260211    clang-20
i386        buildonly-randconfig-004-20260211    clang-20
i386        buildonly-randconfig-005-20260211    gcc-14
i386        buildonly-randconfig-006-20260211    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260211    gcc-14
i386                  randconfig-002-20260211    gcc-14
i386                  randconfig-003-20260211    gcc-14
i386                  randconfig-004-20260211    clang-20
i386                  randconfig-004-20260211    gcc-14
i386                  randconfig-005-20260211    gcc-14
i386                  randconfig-006-20260211    clang-20
i386                  randconfig-006-20260211    gcc-14
i386                  randconfig-007-20260211    gcc-14
i386                  randconfig-011-20260211    clang-20
i386                  randconfig-012-20260211    clang-20
i386                  randconfig-013-20260211    clang-20
i386                  randconfig-014-20260211    clang-20
i386                  randconfig-015-20260211    clang-20
i386                  randconfig-016-20260211    clang-20
i386                  randconfig-017-20260211    clang-20
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                loongson32_defconfig    clang-22
loongarch             randconfig-001-20260211    clang-22
loongarch             randconfig-002-20260211    clang-22
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                        m5307c3_defconfig    gcc-15.2.0
m68k                            mac_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                  cavium_octeon_defconfig    gcc-15.2.0
mips                        maltaup_defconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260211    clang-22
nios2                 randconfig-001-20260211    gcc-11.5.0
nios2                 randconfig-002-20260211    clang-22
nios2                 randconfig-002-20260211    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                generic-64bit_defconfig    gcc-15.2.0
parisc                randconfig-001-20260211    clang-22
parisc                randconfig-001-20260211    gcc-14.3.0
parisc                randconfig-002-20260211    clang-22
parisc                randconfig-002-20260211    gcc-15.2.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                 canyonlands_defconfig    clang-22
powerpc               randconfig-001-20260211    clang-16
powerpc               randconfig-001-20260211    clang-22
powerpc               randconfig-002-20260211    clang-22
powerpc64             randconfig-001-20260211    clang-17
powerpc64             randconfig-001-20260211    clang-22
powerpc64             randconfig-002-20260211    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260211    gcc-13.4.0
riscv                 randconfig-001-20260211    gcc-8.5.0
riscv                 randconfig-002-20260211    clang-22
riscv                 randconfig-002-20260211    gcc-13.4.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260211    gcc-13.4.0
s390                  randconfig-002-20260211    clang-22
s390                  randconfig-002-20260211    gcc-13.4.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                     magicpanelr2_defconfig    gcc-15.2.0
sh                    randconfig-001-20260211    gcc-13.4.0
sh                    randconfig-001-20260211    gcc-9.5.0
sh                    randconfig-002-20260211    gcc-13.4.0
sh                          rsk7264_defconfig    gcc-15.2.0
sh                             shx3_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260211    gcc-13.4.0
sparc                 randconfig-001-20260211    gcc-8.5.0
sparc                 randconfig-002-20260211    gcc-13.4.0
sparc                 randconfig-002-20260211    gcc-15.2.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260211    gcc-13.4.0
sparc64               randconfig-001-20260211    gcc-15.2.0
sparc64               randconfig-002-20260211    gcc-13.4.0
sparc64               randconfig-002-20260211    gcc-14.3.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260211    clang-17
um                    randconfig-001-20260211    gcc-13.4.0
um                    randconfig-002-20260211    gcc-13.4.0
um                    randconfig-002-20260211    gcc-14
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260211    clang-20
x86_64      buildonly-randconfig-001-20260211    gcc-12
x86_64      buildonly-randconfig-002-20260211    gcc-12
x86_64      buildonly-randconfig-002-20260211    gcc-14
x86_64      buildonly-randconfig-003-20260211    gcc-12
x86_64      buildonly-randconfig-003-20260211    gcc-14
x86_64      buildonly-randconfig-004-20260211    gcc-12
x86_64      buildonly-randconfig-005-20260211    clang-20
x86_64      buildonly-randconfig-005-20260211    gcc-12
x86_64      buildonly-randconfig-006-20260211    clang-20
x86_64      buildonly-randconfig-006-20260211    gcc-12
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260211    clang-20
x86_64                randconfig-002-20260211    clang-20
x86_64                randconfig-003-20260211    clang-20
x86_64                randconfig-004-20260211    clang-20
x86_64                randconfig-005-20260211    clang-20
x86_64                randconfig-006-20260211    clang-20
x86_64                randconfig-011-20260211    gcc-14
x86_64                randconfig-012-20260211    gcc-14
x86_64                randconfig-013-20260211    gcc-12
x86_64                randconfig-013-20260211    gcc-14
x86_64                randconfig-014-20260211    clang-20
x86_64                randconfig-014-20260211    gcc-14
x86_64                randconfig-015-20260211    gcc-14
x86_64                randconfig-016-20260211    gcc-14
x86_64                randconfig-071-20260211    clang-20
x86_64                randconfig-071-20260211    gcc-14
x86_64                randconfig-072-20260211    clang-20
x86_64                randconfig-073-20260211    clang-20
x86_64                randconfig-073-20260211    gcc-14
x86_64                randconfig-074-20260211    clang-20
x86_64                randconfig-075-20260211    clang-20
x86_64                randconfig-075-20260211    gcc-14
x86_64                randconfig-076-20260211    clang-20
x86_64                randconfig-076-20260211    gcc-12
x86_64                               rhel-9.4    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260211    gcc-13.4.0
xtensa                randconfig-001-20260211    gcc-8.5.0
xtensa                randconfig-002-20260211    gcc-13.4.0
xtensa                    smp_lx200_defconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

