Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 136ECCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728416B0005; Fri, 12 Jun 2026 11:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9366B0092; Fri, 12 Jun 2026 11:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF106B0093; Fri, 12 Jun 2026 11:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0C46B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:19:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6152160CE6
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:19:56 +0000 (UTC)
X-FDA: 84871620792.02.AADEC22
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf15.hostedemail.com (Postfix) with ESMTP id 25FCDA0003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:19:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="e8wbVhO/";
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781277595;
	b=WmZZhHo35ZWxW1w1Cw6vMkQEAafYaHGctSCf5mu5AFgKa7FLDOXaGIJNnLsD1mSLGAlm1D
	Ns7Sb4xtflgfDQxtN0A3TYHnLh5itJR/VP88LeHV4LRk55c2WdfwwE5AXJtNwb0ZwKfV3f
	V5QLgEF0bn4AD9NKxlD10Sr7lIYEjDs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="e8wbVhO/";
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781277595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=2vl/fnlHZOBrN4qRdvp5VrgZKn8jJwVtnG4rncAvaAQ=;
	b=6gtMpT51Pqlpc3oqWdKDBcSSNvkbkVaMQU0k9Lw4kGK/jLSLAnedEKFc5505xkZVvW1a7F
	Lx3NIS8dFyvklyaY7Rn6Fh14ccTYZsALS/0bYmASZ4xFwbLuDQMIs0l9MwjSTujc8ScqfT
	jxE/3/Es+x7CiP8xzHj5pK6qy6qcfaQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781277594; x=1812813594;
  h=date:from:to:cc:subject:message-id;
  bh=SwGtALDiJer6aizgrpzr8BylbhEOzB6W8ibXodOqUjA=;
  b=e8wbVhO/wRwC2WdxmpxetlAAdFppBCeNaadzhD97z1nti4iXYOcaMewC
   WSSOkuIw7sgTdHE24bMSPWWjgXM2BgLoO747Yy9342JJttw0YBFRLgDn9
   znys0B99HyCKqOij+AqK0QPgX3O9q6/vju6pNXLIZfMyMvG+Euj1o4dgf
   EnGr2II7Tp/EKMgvFIyYf5Qb5VPZs5ohdy/8WK+LGlntgBGTPkzg1xzMQ
   ifPnA0uKQ8M1cGOIdS8lVHmhsoLa87y9ZEd8a67wmAodgpugNrDGuLQNu
   3z1UvmNQsoxidWY+S9aTLJ28n7IRg9YQzyu8cEG0hxAXhCSaNTQoJEFU/
   Q==;
X-CSE-ConnectionGUID: Lk2hnRaxQ7uOWmk7mOW/MQ==
X-CSE-MsgGUID: WO9nh0ldTwarY6e2ypHF1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81120906"
X-IronPort-AV: E=Sophos;i="6.24,200,1774335600"; 
   d="scan'208";a="81120906"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 08:19:53 -0700
X-CSE-ConnectionGUID: NydMJbhFR1ud7EEhZg6FMg==
X-CSE-MsgGUID: LIILtkvfSwO0NejLIXFsmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,200,1774335600"; 
   d="scan'208";a="242699783"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 12 Jun 2026 08:19:51 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wY3fg-00000000Ovd-3gKJ;
	Fri, 12 Jun 2026 15:19:48 +0000
Date: Fri, 12 Jun 2026 23:18:59 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 57a68dff1fb64022386175e7014e006a92bdfa7b
Message-ID: <202606122350.W84DFotR-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25FCDA0003
X-Rspam-User: 
X-Stat-Signature: 5k5hgng5ww7wnqn4kzwhzus99z5knub4
X-HE-Tag: 1781277593-714011
X-HE-Meta: U2FsdGVkX18xsL8BpYp1Zl5+rw01s1wIWTPJ/p6R3NFo8GkaPTOXlG+Lqgz2gnBD2AWCVbPjegmFuF8MMy/gSSvA72Yz4Ak7nG9wG9fj+F3jcaILlILUutk7RpMI535CRaFS9TZ594GXgDZbRvV7bZPDzBlUBsmgel6CsaFmPluiuxBXMNlnnKKVRQN1flcTEt8bxskgQ08oUkwYEw3k5f7aIYhYv/DZplrH0M4L54O6JxSe/JZPyzUVjXHGkbkkta0RhwvZmVp1PAwNes3ewCBmFWiLuWq53SK2UGEz69aQQMfHlmEnjDA74DAHYI0oriEXsisRLLh8cNRgF8PiCzBwS6bvoMkSEXMRYhN4ihKflSOcLdRtEq0z640mUIN7Mi7Q5oywLPbeaVDShUzeCkTqe7MaDGZHRrCjmsOwvJUGCMqyE1QzBZKkN/oIzXtfGl2ePo9SbKv0SdckY9Yu+OQ+MwkZagzizAifiqfsbRolvjf05NPgn6z+R+UyLhbjJIekSLQlZ+h9gFRO1P9oD0tK0ohp9eHMSP5pL0sdBIUWnGL9T/pCJ7a/g3w2529kUqi4C5ZwTfKRtUyHgNIZIhg6I9MScNle3qvjrkP89bHa2CL/KKZ2sInKNEpTjrlyy0s7z32pOOZOvPyuxqyW41TZC5sfHaLQGx1CJqt75DIH7J7nkVLnwMfpDdD0U4P3PsVerlDClbcRqihDgKfrlgpvHyix6GiBjtBMOElX0B8xt9U8r1T//rCE5GCdBhHAq2EDKs2oZBenhGDLs88wl5a4Y99FgvZkZl5MyMHfMS2ZIcvAAeeb71xqhQJncU/aT8qgyA6Xk2ar6/PHhuN/9ubDZrmoxYoudduD3QoHFmJNBBjikjWm/05Fc1CdFx8CTkHPxRVaSsKSzGHvV+Xq1xbaBStVpDfDkYhEFt9fxte2bYt+SObtl66Hq4U58/22CH+9IG9qKYHQz/iNfSJ
 EeHRlNWp
 ZOlKNcxvx7QANvc1L1Bbq+MHtx5CW8+v28lhBPt5jwGEHlZO/lUBvYbfHl3tY55PcumSXh6eB2tC9fOGl38VUQxOgjsO5v1Q9xVX55gC/jIrWQJR8ZkxMPGow92Ww62LTRYAicwAM02tuCqDcAcdE4K0CfBpNPX4FZMnrquzvMETuySo9ERLVX5epnUU9K+ecMvLfzohynrxwssU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 57a68dff1fb64022386175e7014e006a92bdfa7b  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 808m

configs tested: 304
configs skipped: 6

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
arc                        nsim_700_defconfig    gcc-16.1.0
arc                   randconfig-001-20260612    gcc-13.4.0
arc                   randconfig-002-20260612    gcc-13.4.0
arc                   randconfig-002-20260612    gcc-15.2.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                         axm55xx_defconfig    clang-23
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260612    gcc-11.5.0
arm                   randconfig-001-20260612    gcc-13.4.0
arm                   randconfig-002-20260612    gcc-10.5.0
arm                   randconfig-002-20260612    gcc-13.4.0
arm                   randconfig-003-20260612    gcc-11.5.0
arm                   randconfig-003-20260612    gcc-13.4.0
arm                   randconfig-004-20260612    gcc-13.4.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    gcc-13.4.0
arm64                 randconfig-001-20260612    gcc-13.4.0
arm64                          randconfig-002    gcc-13.4.0
arm64                 randconfig-002-20260612    clang-23
arm64                 randconfig-002-20260612    gcc-13.4.0
arm64                          randconfig-003    gcc-13.4.0
arm64                 randconfig-003-20260612    gcc-13.4.0
arm64                 randconfig-003-20260612    gcc-9.5.0
arm64                          randconfig-004    gcc-13.4.0
arm64                 randconfig-004-20260612    gcc-11.5.0
arm64                 randconfig-004-20260612    gcc-13.4.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    gcc-13.4.0
csky                  randconfig-001-20260612    gcc-11.5.0
csky                  randconfig-001-20260612    gcc-13.4.0
csky                           randconfig-002    gcc-13.4.0
csky                  randconfig-002-20260612    gcc-13.4.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260612    clang-23
hexagon               randconfig-001-20260612    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260612    clang-23
hexagon               randconfig-002-20260612    gcc-11.5.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260612    clang-22
i386        buildonly-randconfig-001-20260612    gcc-14
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260612    gcc-14
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260612    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260612    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260612    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260612    clang-22
i386        buildonly-randconfig-006-20260612    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260612    clang-22
i386                  randconfig-001-20260612    gcc-14
i386                  randconfig-002-20260612    clang-22
i386                  randconfig-003-20260612    clang-22
i386                  randconfig-003-20260612    gcc-14
i386                  randconfig-004-20260612    clang-22
i386                  randconfig-004-20260612    gcc-14
i386                  randconfig-005-20260612    clang-22
i386                  randconfig-006-20260612    clang-22
i386                  randconfig-007-20260612    clang-22
i386                  randconfig-007-20260612    gcc-12
i386                  randconfig-011-20260612    clang-22
i386                  randconfig-012-20260612    clang-22
i386                  randconfig-013-20260612    clang-22
i386                  randconfig-014-20260612    clang-22
i386                  randconfig-015-20260612    clang-22
i386                  randconfig-015-20260612    gcc-14
i386                  randconfig-016-20260612    clang-22
i386                  randconfig-016-20260612    gcc-14
i386                  randconfig-017-20260612    clang-22
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260612    clang-23
loongarch             randconfig-001-20260612    gcc-11.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260612    clang-23
loongarch             randconfig-002-20260612    gcc-11.5.0
loongarch             randconfig-002-20260612    gcc-16.1.0
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
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260612    clang-23
nios2                 randconfig-001-20260612    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260612    clang-23
nios2                 randconfig-002-20260612    gcc-11.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-23
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260612    gcc-12.5.0
parisc                randconfig-002-20260612    gcc-14.3.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                      ppc64e_defconfig    gcc-16.1.0
powerpc64             randconfig-001-20260612    gcc-8.5.0
powerpc64             randconfig-002-20260612    gcc-11.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    gcc-11.5.0
riscv                 randconfig-001-20260612    gcc-11.5.0
riscv                 randconfig-001-20260612    gcc-13.4.0
riscv                          randconfig-002    gcc-11.5.0
riscv                 randconfig-002-20260612    clang-23
riscv                 randconfig-002-20260612    gcc-11.5.0
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    gcc-11.5.0
s390                  randconfig-001-20260612    clang-23
s390                  randconfig-001-20260612    gcc-11.5.0
s390                           randconfig-002    gcc-11.5.0
s390                  randconfig-002-20260612    gcc-11.5.0
s390                  randconfig-002-20260612    gcc-8.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-23
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-11.5.0
sh                    randconfig-001-20260612    gcc-11.5.0
sh                             randconfig-002    gcc-11.5.0
sh                    randconfig-002-20260612    gcc-11.5.0
sh                    randconfig-002-20260612    gcc-13.4.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-8.5.0
sparc                 randconfig-001-20260612    gcc-8.5.0
sparc                          randconfig-002    gcc-8.5.0
sparc                 randconfig-002-20260612    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-8.5.0
sparc64               randconfig-001-20260612    clang-20
sparc64               randconfig-001-20260612    gcc-8.5.0
sparc64                        randconfig-002    gcc-8.5.0
sparc64               randconfig-002-20260612    gcc-12.5.0
sparc64               randconfig-002-20260612    gcc-8.5.0
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-8.5.0
um                    randconfig-001-20260612    gcc-14
um                    randconfig-001-20260612    gcc-8.5.0
um                             randconfig-002    gcc-8.5.0
um                    randconfig-002-20260612    clang-23
um                    randconfig-002-20260612    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260612    clang-22
x86_64      buildonly-randconfig-001-20260612    gcc-14
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260612    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260612    clang-22
x86_64      buildonly-randconfig-003-20260612    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260612    clang-22
x86_64      buildonly-randconfig-004-20260612    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260612    clang-22
x86_64      buildonly-randconfig-005-20260612    gcc-14
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260612    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260612    clang-22
x86_64                randconfig-002-20260612    clang-22
x86_64                randconfig-002-20260612    gcc-14
x86_64                randconfig-003-20260612    clang-22
x86_64                randconfig-003-20260612    gcc-14
x86_64                randconfig-004-20260612    clang-22
x86_64                randconfig-004-20260612    gcc-14
x86_64                randconfig-005-20260612    clang-22
x86_64                randconfig-005-20260612    gcc-14
x86_64                randconfig-006-20260612    clang-22
x86_64                         randconfig-011    clang-22
x86_64                randconfig-011-20260612    clang-22
x86_64                randconfig-011-20260612    gcc-14
x86_64                         randconfig-012    clang-22
x86_64                randconfig-012-20260612    clang-22
x86_64                         randconfig-013    clang-22
x86_64                randconfig-013-20260612    clang-22
x86_64                         randconfig-014    clang-22
x86_64                randconfig-014-20260612    clang-22
x86_64                randconfig-014-20260612    gcc-14
x86_64                         randconfig-015    clang-22
x86_64                randconfig-015-20260612    clang-22
x86_64                randconfig-015-20260612    gcc-14
x86_64                         randconfig-016    clang-22
x86_64                randconfig-016-20260612    clang-22
x86_64                randconfig-016-20260612    gcc-14
x86_64                randconfig-071-20260612    gcc-14
x86_64                randconfig-072-20260612    gcc-12
x86_64                randconfig-072-20260612    gcc-14
x86_64                randconfig-073-20260612    clang-22
x86_64                randconfig-073-20260612    gcc-14
x86_64                randconfig-074-20260612    clang-22
x86_64                randconfig-074-20260612    gcc-14
x86_64                randconfig-075-20260612    clang-22
x86_64                randconfig-075-20260612    gcc-14
x86_64                randconfig-076-20260612    clang-22
x86_64                randconfig-076-20260612    gcc-14
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
xtensa                  nommu_kc705_defconfig    gcc-16.1.0
xtensa                         randconfig-001    gcc-8.5.0
xtensa                randconfig-001-20260612    gcc-10.5.0
xtensa                randconfig-001-20260612    gcc-8.5.0
xtensa                         randconfig-002    gcc-8.5.0
xtensa                randconfig-002-20260612    gcc-12.5.0
xtensa                randconfig-002-20260612    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

