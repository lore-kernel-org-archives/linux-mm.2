Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1157FC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 20:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1606B0088; Thu,  9 Jul 2026 16:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791A76B008A; Thu,  9 Jul 2026 16:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7416B008C; Thu,  9 Jul 2026 16:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B92B6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:45:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D87BA02AC
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:45:32 +0000 (UTC)
X-FDA: 84970418904.25.9135A66
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf29.hostedemail.com (Postfix) with ESMTP id 37F35120006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:45:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ode67Sm4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783629930;
	b=8U8LDBVhxW1bImfVGBv/5/CppLlYHx76OcG0SCjufAY6ZjmZTd/zkvxbI98csmaxUy2Veg
	uSG2RxjML+nc6s2UlB+7SkjUJXQiYsxbkOBtU0ZdebI39f7N00BauUSM6FvEMCX10EpOIf
	jMnbCr+JOBR5y1JzdBY11IXapzQZKU0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ode67Sm4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783629930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=y5GmKRslmdmMjagM9CWpSLPMCH0z10ymZJX7WbAB1TE=;
	b=sqYQ0+h77tyObHGy581EFO8iA3ZOWaeHt5Sk8+pDm0/kfm9VQHL++cxaQsVHwQuM14np/5
	Y1VxOTdQcEstsh3bbhnwRl1TIc2rqV17rHcDZLEmXsHKYMsi/kCnpYhp1XSxCw70jVYSqr
	SHS6VtL4Cxs1AWb6+F9eq9S1BGlQhLk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783629929; x=1815165929;
  h=date:from:to:cc:subject:message-id;
  bh=oQ9TjgprYtk13zViy8r+xrtUeukujgN21HWLYsPHe14=;
  b=Ode67Sm456hCcqbpX+JUdYhvpfB2dwcJ4ztf2Wmnvd+7p6LtOn/RAYAI
   Qaem8QLr44ytqwLLhWGTru5KlmPwechas8CZRhDmrjIF1KZAUYut3+AZf
   5DoO1FG8d+qhNKJ4I96BIzN1N4pn6UAeguiw2Ov9dzkkS8pmUBAzoHCDv
   zv55KyJc+w5CqZguCxDbYDgn8DGCRrbx4vHi54aP98a1qTJuNDayGwUkM
   Hs8Em5Sho9dn3Z563CBTrZ1kJvCCDYAF8kXixzqEROvyP+aEzMJfTxNoo
   RgWQqfjZPzRwPV3W3Q3FODWqN22HkgxBEnkq9QwUK8ZRsclG5ZrFwEm89
   g==;
X-CSE-ConnectionGUID: u82k14juQsm5hIagrTC3PA==
X-CSE-MsgGUID: WtPhKjh/Qii7I+gf5b5Cpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84521234"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84521234"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 13:45:28 -0700
X-CSE-ConnectionGUID: Yw+lyQHYTPaG/hZDfA17wA==
X-CSE-MsgGUID: VGqdoxhSTOCrA6aY3AQgjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="258568821"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 09 Jul 2026 13:45:27 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whvca-00000000I6p-048W;
	Thu, 09 Jul 2026 20:45:24 +0000
Date: Fri, 10 Jul 2026 04:44:44 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 1a6e6a79b8df153f9ec702aa4d5407333eeff917
Message-ID: <202607100434.pOCtVDqS-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 37F35120006
X-Rspam-User: 
X-Stat-Signature: eygty7kqcdemama58q8t868icu4d85qj
X-Rspamd-Server: rspam03
X-HE-Tag: 1783629929-527253
X-HE-Meta: U2FsdGVkX18UKVIVqcKSqkH/xpJb0w7FN6ADkiD9SOiu9/fpWZ0kKULL/U36STJNvNT7JNX8pElehBefQjajxxljXpGHesT3Mxb5872R4LDCkKYuT/TLePzdzFBB3AaJiXQgbATuk5cU2dObDlVnp3bBr2UXEKFVdjY5vI63op5eYG4Tw7jqmVkSZeuVrC6eDhWQ5SlJJqy2bfO3+mGcj3PaeJ2ugWVVxE5xEVrz+Uc0uqnVDsHGqB7+mPwuABxep5PKAlNj47S8rIqrQWTPzesZS9+85dAMHFuLvd/6R8x+dklOxqBZyM79uRzRp5glA+njI96DFeGEcC7sU22bvoqVDX2Veh1N+lykC4zmNLYY8Va6pEYyss03lzFFbqWjrLTi521Pq0inPyOwpveJjC2lm2W3GaO/BBAHwBkwiDpgSD68QohW/F08tX7zLueecgaQLg6i3u3auO9s4KBq2+TplaKEz4BIwLttauaejbJbJTwDWrGsVRQN0fT9yHsV/z7jRReAvn3TsKUk2s8wPfdGuDBYD39vDfGxozkdYAyFwmlGXhsUQ9QYdmzgwdv15k4n0752nApBqtiMTr9gIHzqzJkqBl4KsGq3JBTX7NFP4JAncL9p0ypcZFmCLIbHqNgd0Q8BAFOVG5EVOkj1gTybZ8l4RqI8ExCVTrIbiU6ietlJk/YcJHe20CJZuMqbnkvr9ZLvqUqIOz7anMSne5aY9l2NJjggleyPuX3BXVhFFpegnZXiMVRHs4sJgMlM49b2T3bSJBza6f8c6WsCb6oU9tX0h7V/cLhmir3tOKSlffbT39k/fLO2lrvukI56D9ws2ciX6r2tAc3ZZu+UFMV7MY/bck/xA+2qbDkanBr2zFwE0raUEMEDMS3aLJtAuPgl9/oxNwo9uD3SPm7iRd4z5pjgnliSb1jJZPhAKtm8aLcwWOUlZQUlecnLNxWDyHX5u033MnqqUvMI1oq
 fkZcoUXF
 cjICJpOre/6AWtav7OMFIlORiaEEJyD6n98o7CPRoixay2e5w7W72UzaKo2bwXYXaFC7iJWuGuW+XrIm5ctIJDF5LuSP3FFsxj/hiPN7Yzfd8Gnp7N+OeMPMFzrayA/8uyk6VaMKpmqcFuriK03cgs+oN08CdGHVZ/IWZ7etcpiemzqqhcJRt6++Py5Ba61jOhW9Qbxs2Zsnfb4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 1a6e6a79b8df153f9ec702aa4d5407333eeff917  Merge branch 'misc' into for-next

elapsed time: 843m

configs tested: 312
configs skipped: 4

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
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260709    gcc-8.5.0
arc                   randconfig-001-20260710    clang-23
arc                   randconfig-002-20260709    gcc-8.5.0
arc                   randconfig-002-20260710    clang-23
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    gcc-16.1.0
arm                          ep93xx_defconfig    clang-23
arm                   randconfig-001-20260709    gcc-8.5.0
arm                   randconfig-001-20260710    clang-23
arm                   randconfig-002-20260709    gcc-8.5.0
arm                   randconfig-002-20260710    clang-23
arm                   randconfig-003-20260709    gcc-8.5.0
arm                   randconfig-003-20260710    clang-23
arm                   randconfig-004-20260709    gcc-8.5.0
arm                   randconfig-004-20260710    clang-23
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260709    gcc-16.1.0
arm64                 randconfig-001-20260710    gcc-10.5.0
arm64                 randconfig-002-20260709    gcc-16.1.0
arm64                 randconfig-002-20260710    gcc-10.5.0
arm64                 randconfig-003-20260709    gcc-16.1.0
arm64                 randconfig-003-20260710    gcc-10.5.0
arm64                 randconfig-004-20260709    gcc-16.1.0
arm64                 randconfig-004-20260710    gcc-10.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260709    gcc-16.1.0
csky                  randconfig-001-20260710    gcc-10.5.0
csky                  randconfig-002-20260709    gcc-16.1.0
csky                  randconfig-002-20260710    gcc-10.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260709    clang-18
hexagon               randconfig-001-20260709    gcc-11.5.0
hexagon               randconfig-001-20260710    gcc-12.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260709    clang-18
hexagon               randconfig-002-20260709    gcc-11.5.0
hexagon               randconfig-002-20260710    gcc-12.5.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260709    gcc-14
i386        buildonly-randconfig-001-20260710    clang-22
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260709    gcc-14
i386        buildonly-randconfig-002-20260710    clang-22
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260709    gcc-14
i386        buildonly-randconfig-003-20260710    clang-22
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260709    gcc-14
i386        buildonly-randconfig-004-20260710    clang-22
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260709    gcc-14
i386        buildonly-randconfig-005-20260710    clang-22
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260709    gcc-14
i386        buildonly-randconfig-006-20260710    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260709    gcc-14
i386                  randconfig-001-20260710    clang-22
i386                  randconfig-002-20260709    gcc-14
i386                  randconfig-002-20260710    clang-22
i386                  randconfig-003-20260709    gcc-14
i386                  randconfig-003-20260710    clang-22
i386                  randconfig-004-20260709    gcc-14
i386                  randconfig-004-20260710    clang-22
i386                  randconfig-005-20260709    gcc-14
i386                  randconfig-005-20260710    clang-22
i386                  randconfig-006-20260709    gcc-14
i386                  randconfig-006-20260710    clang-22
i386                  randconfig-007-20260709    gcc-14
i386                  randconfig-007-20260710    clang-22
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260709    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260709    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260709    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260709    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260709    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260709    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260709    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260709    clang-18
loongarch             randconfig-001-20260709    gcc-11.5.0
loongarch             randconfig-001-20260710    gcc-12.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260709    clang-18
loongarch             randconfig-002-20260709    gcc-11.5.0
loongarch             randconfig-002-20260710    gcc-12.5.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                      m54418evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                         10m50_defconfig    gcc-11.5.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260709    clang-18
nios2                 randconfig-001-20260709    gcc-11.5.0
nios2                 randconfig-001-20260710    gcc-12.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260709    clang-18
nios2                 randconfig-002-20260709    gcc-11.5.0
nios2                 randconfig-002-20260710    gcc-12.5.0
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
parisc                         randconfig-001    clang-23
parisc                randconfig-001-20260709    clang-23
parisc                randconfig-001-20260710    clang-17
parisc                         randconfig-002    clang-23
parisc                randconfig-002-20260709    clang-23
parisc                randconfig-002-20260710    clang-17
parisc64                            defconfig    clang-23
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                   microwatt_defconfig    gcc-16.1.0
powerpc                 mpc836x_rdk_defconfig    clang-23
powerpc                        randconfig-001    clang-23
powerpc               randconfig-001-20260709    clang-23
powerpc               randconfig-001-20260710    clang-17
powerpc                        randconfig-002    clang-23
powerpc               randconfig-002-20260709    clang-23
powerpc               randconfig-002-20260710    clang-17
powerpc64                      randconfig-001    clang-23
powerpc64             randconfig-001-20260709    clang-23
powerpc64             randconfig-001-20260710    clang-17
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260709    clang-23
powerpc64             randconfig-002-20260710    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-22
riscv                 randconfig-001-20260709    clang-22
riscv                 randconfig-001-20260710    clang-17
riscv                          randconfig-002    clang-22
riscv                 randconfig-002-20260709    clang-22
riscv                 randconfig-002-20260710    clang-17
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-22
s390                  randconfig-001-20260709    clang-22
s390                  randconfig-001-20260710    clang-17
s390                           randconfig-002    clang-22
s390                  randconfig-002-20260709    clang-22
s390                  randconfig-002-20260710    clang-17
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                             randconfig-001    clang-22
sh                    randconfig-001-20260709    clang-22
sh                    randconfig-001-20260710    clang-17
sh                             randconfig-002    clang-22
sh                    randconfig-002-20260709    clang-22
sh                    randconfig-002-20260710    clang-17
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260709    gcc-8.5.0
sparc                 randconfig-002-20260709    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260709    gcc-8.5.0
sparc64               randconfig-002-20260709    gcc-8.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260709    gcc-8.5.0
um                    randconfig-002-20260709    gcc-8.5.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    clang-22
x86_64      buildonly-randconfig-001-20260709    clang-22
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260709    clang-22
x86_64               buildonly-randconfig-003    clang-22
x86_64      buildonly-randconfig-003-20260709    clang-22
x86_64               buildonly-randconfig-004    clang-22
x86_64      buildonly-randconfig-004-20260709    clang-22
x86_64               buildonly-randconfig-005    clang-22
x86_64      buildonly-randconfig-005-20260709    clang-22
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260709    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                randconfig-001-20260709    clang-22
x86_64                randconfig-001-20260709    gcc-14
x86_64                         randconfig-002    clang-22
x86_64                randconfig-002-20260709    clang-22
x86_64                randconfig-002-20260709    gcc-14
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260709    clang-22
x86_64                randconfig-003-20260709    gcc-14
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260709    clang-22
x86_64                randconfig-004-20260709    gcc-14
x86_64                         randconfig-005    clang-22
x86_64                randconfig-005-20260709    clang-22
x86_64                randconfig-005-20260709    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260709    clang-22
x86_64                randconfig-006-20260709    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260709    gcc-14
x86_64                randconfig-011-20260710    clang-22
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260709    gcc-14
x86_64                randconfig-012-20260710    clang-22
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260709    gcc-14
x86_64                randconfig-013-20260710    clang-22
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260709    gcc-14
x86_64                randconfig-014-20260710    clang-22
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260709    gcc-14
x86_64                randconfig-015-20260710    clang-22
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260709    gcc-14
x86_64                randconfig-016-20260710    clang-22
x86_64                randconfig-071-20260709    clang-22
x86_64                randconfig-072-20260709    clang-22
x86_64                randconfig-073-20260709    clang-22
x86_64                randconfig-074-20260709    clang-22
x86_64                randconfig-075-20260709    clang-22
x86_64                randconfig-076-20260709    clang-22
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
xtensa                randconfig-001-20260709    gcc-8.5.0
xtensa                randconfig-002-20260709    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

