Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7432FC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654CA6B0149; Thu,  2 Jul 2026 20:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605126B014B; Thu,  2 Jul 2026 20:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542496B014D; Thu,  2 Jul 2026 20:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1680F6B0149
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:52:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96B581681AE
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:27:03 +0000 (UTC)
X-FDA: 84945273126.11.F085F0F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf02.hostedemail.com (Postfix) with ESMTP id CF1AE80004
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:27:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MlLfc3vG;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783031221;
	b=zClEWBkfpfJMahJzl8d3Oj3c7iGifo2ybqB6KDCrNbAseWwPwSdoN/JGEC32N2qwejWQM3
	oP/o7tSNdVOXOnP5JWcj9JQEUvimdd/WH1Epn/kJwfAecapYcuHl8SHJtTQrZZn8TiTcRK
	b1dBq5rji66RIPB/KF3HcjFN1D3n/Aw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783031221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=rlwwiHqlqS+qCsedpdNeZv/PYYM+pLwd1QkiKL+Zdls=;
	b=QObuHvdS8Gi3kUFlFo2BWrXngkiocMgqXoSRt/9K1Ir8whxvzyork1OS0fWK5LI9GCpAXO
	t89PEkB6DY+fAuqeT8b7dyfYbC/wu6F2wzIDVdUiL+kb8Y8+Kw5thZShW80+WrzuzCEVKq
	PqnyV0R9W5gu0CY0f8J0on1iTEx1uPw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MlLfc3vG;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783031221; x=1814567221;
  h=date:from:to:cc:subject:message-id;
  bh=ldokdXKOX1+t80VvmQZx//kZUf44w/Cteyv5DGsVT50=;
  b=MlLfc3vGNgh7kHy8WlQQUVzj6RGPpf53HBegq4mgJ5jlymWO753Ahvxf
   zKW0RNC2RIRfvG0RiYUkaducTn3cqXYDdy2PoMBuSrcttJcGgpl/4ehjy
   pItj4eNA7Ic1ZIhKz8gfmagcT22zSlbtSLVEacTxI6Ag8gQLGJhC1pWOZ
   kP+zwfOHRCaJeR54p6psDTsAivTe8aAaEl/2evLN/4Apgc5PiK7iu3TXf
   +kKdpblNs4gpL0BNaMLqTi8a7APl3TT7YD2vuZODxUFLi1GFtQY230ffd
   bI/eygZJH9K190y11HqW9OR8RvYgB31FjMbeMKJ2COZxJywOFRTDQnsmR
   w==;
X-CSE-ConnectionGUID: binrLdXgT6GIrwgj/943iQ==
X-CSE-MsgGUID: Exicor/gSg2vsto3dGGe3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="83656426"
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="83656426"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 15:26:53 -0700
X-CSE-ConnectionGUID: 7tt9Cc8ISgGJary0x1uarA==
X-CSE-MsgGUID: YXIBcuKsRtCyyZP103nhqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="246592721"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 02 Jul 2026 15:26:52 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfPrX-00000000BKU-2fE0;
	Thu, 02 Jul 2026 22:26:34 +0000
Date: Fri, 03 Jul 2026 06:25:43 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 2ebce860bdd7ae5e13002811bc9bbbf33fcfc221
Message-ID: <202607030633.Y250Ba7b-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF1AE80004
X-Stat-Signature: e4xn37w6qukwqmfcexsbtu9566tz81or
X-Rspam-User: 
X-HE-Tag: 1783031220-256974
X-HE-Meta: U2FsdGVkX1/qQYKEOcuSV/a2hlLmXOonZjUJxWmM6USSNdgFzTpBoDTDDGpUBikzna1eBnQs+Q6khTBj9PyO79ks8tMhbooM+OZxdEha5vkSQxb6FyshE5h6hqJWxOGmPxMwDr8HUkx2yNapXmYL0N/xjZgxs31KlwC9lnf8mIt6gIsq0KD3gqaBmaUnjHDF9HgrtgtaCJ07Ms1Hf2M0Ygv7ekJbN3jDz6FpuGsbgkLa+MQx+R7T17EM8P4if4bNW4GxIXIUmP8vcE9F4bTS1Q2wsrjLj5oZi3CxXvUyI+2wipaE7yY3rkz8lcChDSdojCQqbktZ4ooERD0L1TH5zXFOScyoqUE9PrIGiIRSvOz37eI5OAp+kO/ge482YmK91TUMBVzmHg+RGXIRpCE5YOGSHkMzy0O1OGjFlzmARS17JgJe9+DWLznsloK6q30wXUQoQyYVqNkGeF4CWs7rko9b7yj4oNV+9WQ+uqhh2Ihd8dqcwDNsVZ/tJdno3Rt0DTvtN1FsNCV3c423Z8vS1pOv7flDDoYlqMPLfRbqC8ugzWX3WJGVgSR7l0oQEnin8WgWfa9rASZJtGdGKoCCIcDrn36C78zicEyYuCtOmsLzc8TVdNFqCAutuBfiYwtiRR1xhFABV1SlZdwwEDDUWI4eQauQ1s1718OdfzvUCZebKXZx2l39gK9umcuBbLv0mqKN0gdk5brenE86UTka00Y1Cjfdla/LPU2SHq2qKoIZGDc64lTuSLNEeXduR0TBgNodlC0F614hwLKtqrQs0HJUq63QYZEiZH+db7OawAlEmFomuCkD88tg2yeiEHa7HgzCQqERW4niKZ7mhExKZJi4gyP4Um0/9ScbhuhS5mVonNI5d8pViFTShfs3yTjmSbBcSfccplWvZ3Fq/4GwPp59jxBQgZXJPl/sEjDhTEOVTcV/gWK/IfZ1+jMeBUzRrUYnU9wuIm6iILViKzd
 f7ke6FFs
 xnvR/W/aW/UXk+bKktXmTGaGckyAZm1d2uWBDJW78KGLpHzipJ8+kIq8l9dWxdMX9xGkNC/5mltSCv9VDxTrxLx1gsExY3jnKEE5hEFG4SiqtThj7NkIf530EnGtGgD7LT+WTIQ/o8XzJ7TIuquGj5SGGpxeQ16CIav24MNvXS5CmbJ+ZYBAo/eu3/pIf9SN2mBVd5gvucRfHkNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: 2ebce860bdd7ae5e13002811bc9bbbf33fcfc221  mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug

elapsed time: 799m

configs tested: 321
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-16.1.0
arc                            randconfig-001    gcc-16.1.0
arc                   randconfig-001-20260702    gcc-16.1.0
arc                   randconfig-001-20260702    gcc-8.5.0
arc                   randconfig-001-20260703    gcc-8.5.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260702    gcc-16.1.0
arc                   randconfig-002-20260702    gcc-8.5.0
arc                   randconfig-002-20260703    gcc-8.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    gcc-16.1.0
arm                         mv78xx0_defconfig    clang-23
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260702    gcc-16.1.0
arm                   randconfig-001-20260702    gcc-8.5.0
arm                   randconfig-001-20260703    gcc-8.5.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260702    gcc-16.1.0
arm                   randconfig-002-20260702    gcc-8.5.0
arm                   randconfig-002-20260703    gcc-8.5.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260702    gcc-16.1.0
arm                   randconfig-003-20260702    gcc-8.5.0
arm                   randconfig-003-20260703    gcc-8.5.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260702    gcc-16.1.0
arm                   randconfig-004-20260702    gcc-8.5.0
arm                   randconfig-004-20260703    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    gcc-15.2.0
arm64                 randconfig-001-20260702    gcc-15.2.0
arm64                          randconfig-002    gcc-15.2.0
arm64                 randconfig-002-20260702    gcc-15.2.0
arm64                          randconfig-003    gcc-15.2.0
arm64                 randconfig-003-20260702    gcc-15.2.0
arm64                          randconfig-004    gcc-15.2.0
arm64                 randconfig-004-20260702    gcc-15.2.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    gcc-15.2.0
csky                  randconfig-001-20260702    gcc-15.2.0
csky                           randconfig-002    gcc-15.2.0
csky                  randconfig-002-20260702    gcc-15.2.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260702    clang-23
hexagon               randconfig-001-20260702    gcc-11.5.0
hexagon               randconfig-001-20260703    gcc-16.1.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260702    clang-23
hexagon               randconfig-002-20260702    gcc-11.5.0
hexagon               randconfig-002-20260703    gcc-16.1.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    clang-22
i386        buildonly-randconfig-001-20260702    clang-22
i386        buildonly-randconfig-001-20260703    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260702    clang-22
i386        buildonly-randconfig-002-20260703    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260702    clang-22
i386        buildonly-randconfig-003-20260703    clang-22
i386                 buildonly-randconfig-004    clang-22
i386        buildonly-randconfig-004-20260702    clang-22
i386        buildonly-randconfig-004-20260703    clang-22
i386                 buildonly-randconfig-005    clang-22
i386        buildonly-randconfig-005-20260702    clang-22
i386        buildonly-randconfig-005-20260703    clang-22
i386                 buildonly-randconfig-006    clang-22
i386        buildonly-randconfig-006-20260702    clang-22
i386        buildonly-randconfig-006-20260703    clang-22
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    gcc-14
i386                  randconfig-001-20260702    gcc-14
i386                           randconfig-002    gcc-14
i386                  randconfig-002-20260702    gcc-14
i386                           randconfig-003    gcc-14
i386                  randconfig-003-20260702    gcc-14
i386                           randconfig-004    gcc-14
i386                  randconfig-004-20260702    gcc-14
i386                           randconfig-005    gcc-14
i386                  randconfig-005-20260702    gcc-14
i386                           randconfig-006    gcc-14
i386                  randconfig-006-20260702    gcc-14
i386                           randconfig-007    gcc-14
i386                  randconfig-007-20260702    gcc-14
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260702    clang-22
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260702    clang-22
i386                           randconfig-013    clang-22
i386                  randconfig-013-20260702    clang-22
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260702    clang-22
i386                           randconfig-015    clang-22
i386                  randconfig-015-20260702    clang-22
i386                           randconfig-016    clang-22
i386                  randconfig-016-20260702    clang-22
i386                           randconfig-017    clang-22
i386                  randconfig-017-20260702    clang-22
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260702    clang-23
loongarch             randconfig-001-20260702    gcc-11.5.0
loongarch             randconfig-001-20260703    gcc-16.1.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260702    clang-23
loongarch             randconfig-002-20260702    gcc-11.5.0
loongarch             randconfig-002-20260703    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        omega2p_defconfig    clang-17
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260702    clang-23
nios2                 randconfig-001-20260702    gcc-11.5.0
nios2                 randconfig-001-20260703    gcc-16.1.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260702    clang-23
nios2                 randconfig-002-20260702    gcc-11.5.0
nios2                 randconfig-002-20260703    gcc-16.1.0
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
parisc                         randconfig-001    clang-17
parisc                randconfig-001-20260702    clang-17
parisc                randconfig-001-20260703    clang-23
parisc                         randconfig-002    clang-17
parisc                randconfig-002-20260702    clang-17
parisc                randconfig-002-20260703    clang-23
parisc64                            defconfig    clang-23
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    clang-17
powerpc               randconfig-001-20260702    clang-17
powerpc               randconfig-001-20260703    clang-23
powerpc                        randconfig-002    clang-17
powerpc               randconfig-002-20260702    clang-17
powerpc               randconfig-002-20260703    clang-23
powerpc                         wii_defconfig    gcc-16.1.0
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260702    clang-17
powerpc64             randconfig-001-20260703    clang-23
powerpc64                      randconfig-002    clang-17
powerpc64             randconfig-002-20260702    clang-17
powerpc64             randconfig-002-20260703    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    gcc-12.5.0
riscv                 randconfig-001-20260702    gcc-12.5.0
riscv                 randconfig-001-20260703    gcc-9.5.0
riscv                          randconfig-002    gcc-12.5.0
riscv                 randconfig-002-20260702    gcc-12.5.0
riscv                 randconfig-002-20260703    gcc-9.5.0
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    gcc-12.5.0
s390                  randconfig-001-20260702    gcc-12.5.0
s390                  randconfig-001-20260703    gcc-9.5.0
s390                           randconfig-002    gcc-12.5.0
s390                  randconfig-002-20260702    gcc-12.5.0
s390                  randconfig-002-20260703    gcc-9.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                 kfr2r09-romimage_defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-12.5.0
sh                    randconfig-001-20260702    gcc-12.5.0
sh                    randconfig-001-20260703    gcc-9.5.0
sh                             randconfig-002    gcc-12.5.0
sh                    randconfig-002-20260702    gcc-12.5.0
sh                    randconfig-002-20260703    gcc-9.5.0
sh                           se7343_defconfig    gcc-16.1.0
sh                           se7619_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260702    gcc-16.1.0
sparc                 randconfig-001-20260703    gcc-11.5.0
sparc                 randconfig-002-20260702    gcc-16.1.0
sparc                 randconfig-002-20260703    gcc-11.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260702    gcc-16.1.0
sparc64               randconfig-001-20260703    gcc-11.5.0
sparc64               randconfig-002-20260702    gcc-16.1.0
sparc64               randconfig-002-20260703    gcc-11.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260702    gcc-16.1.0
um                    randconfig-001-20260703    gcc-11.5.0
um                    randconfig-002-20260702    gcc-16.1.0
um                    randconfig-002-20260703    gcc-11.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260702    clang-22
x86_64      buildonly-randconfig-002-20260702    clang-22
x86_64      buildonly-randconfig-003-20260702    clang-22
x86_64      buildonly-randconfig-004-20260702    clang-22
x86_64      buildonly-randconfig-005-20260702    clang-22
x86_64      buildonly-randconfig-006-20260702    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                randconfig-001-20260702    clang-22
x86_64                         randconfig-002    clang-22
x86_64                randconfig-002-20260702    clang-22
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260702    clang-22
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260702    clang-22
x86_64                         randconfig-005    clang-22
x86_64                randconfig-005-20260702    clang-22
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260702    clang-22
x86_64                         randconfig-011    clang-22
x86_64                randconfig-011-20260702    clang-22
x86_64                         randconfig-012    clang-22
x86_64                randconfig-012-20260702    clang-22
x86_64                         randconfig-013    clang-22
x86_64                randconfig-013-20260702    clang-22
x86_64                         randconfig-014    clang-22
x86_64                randconfig-014-20260702    clang-22
x86_64                         randconfig-015    clang-22
x86_64                randconfig-015-20260702    clang-22
x86_64                         randconfig-016    clang-22
x86_64                randconfig-016-20260702    clang-22
x86_64                randconfig-071-20260702    clang-22
x86_64                randconfig-071-20260703    clang-22
x86_64                randconfig-072-20260702    clang-22
x86_64                randconfig-072-20260703    clang-22
x86_64                randconfig-073-20260702    clang-22
x86_64                randconfig-073-20260703    clang-22
x86_64                randconfig-074-20260702    clang-22
x86_64                randconfig-074-20260703    clang-22
x86_64                randconfig-075-20260702    clang-22
x86_64                randconfig-075-20260703    clang-22
x86_64                randconfig-076-20260702    clang-22
x86_64                randconfig-076-20260703    clang-22
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
xtensa                randconfig-001-20260702    gcc-16.1.0
xtensa                randconfig-001-20260703    gcc-11.5.0
xtensa                randconfig-002-20260702    gcc-16.1.0
xtensa                randconfig-002-20260703    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

