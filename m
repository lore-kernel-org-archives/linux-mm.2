Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E056DCD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 19:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2416B008C; Sat, 13 Jun 2026 15:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283D06B0092; Sat, 13 Jun 2026 15:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171DF6B0093; Sat, 13 Jun 2026 15:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 017F06B008C
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 15:21:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A6061A043E
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:21:17 +0000 (UTC)
X-FDA: 84875857794.02.88F5D4C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id 237FBC0004
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:21:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IW9mhRJH;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781378475;
	b=NcfVmlyYiuAlkhkSMFnlBpEts2MXqy87Cu51BbBqLUM4VGN8KdNKA/0sM9Ju5Ma76yEU7D
	Qc9T6/hp9Xgu7a9e4LG1dh0UW1/vkzzi0JTa2Wn5T6h9UbANHOfgO9uBF+ccRoj/B4Wzj0
	oD22Q8/zmh0gSc89VbMfrxI6KdwHzTQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IW9mhRJH;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781378475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=KJIqS81VQdtWASn7hLXOtwH+XwgR0NXEPtfbQNW/L+U=;
	b=EiQekp7Flv1VU+tJG7hniEqr8miTOVGYdzXgAVCStvt/SkIKBLiCt71zg5147DzfDJJ7k3
	cyhydszZ8KgSvTt3esqX4R3/VLR73bc+M3ePo81WnqikArlNpLuDHxgH1vhWCqaFYQdMjk
	5zYvuaGOl9aJ6U83IhOWLt/a+hlNlM8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781378475; x=1812914475;
  h=date:from:to:cc:subject:message-id;
  bh=UdZZGW5QbTirbTSCuLF6x6DYYuTXZcD/mEQS9t1eeeQ=;
  b=IW9mhRJHxuK++pNrmzVhqeLamqhydHuOa8KVECoQ8k+UEe7ua9aFzYWp
   bYUiI8WnGK+vF+t2C05QYFyJ5Z07zU8uGhdLBGloKzROdcA0OkCxSZ3CM
   XUqYDU26TZZxPeZXv5JmBZWM21jyszDB7YpxyAOSVb88IbtsCwyGxr/WB
   WdmInQUc6B7lvi6vJOOjqyTNrCi4cey6JSkyL6alGD4ErYgM8UOIbkLQ9
   6HtljGDDCkqBqDiCI+yN5Xq/WjZq5rzvLREd6MRXmIdfp61VVX5EjNmR6
   1xJZB42F6rYItqLsoismApUALTpzzqU+uZQnIZbj2ZZTnoQwiyn4f1Zoe
   w==;
X-CSE-ConnectionGUID: qW8pHGh/SjaWfgxjoswJrQ==
X-CSE-MsgGUID: i92FbgduReyNHWs+EUufXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11816"; a="82183824"
X-IronPort-AV: E=Sophos;i="6.24,203,1774335600"; 
   d="scan'208";a="82183824"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2026 12:21:14 -0700
X-CSE-ConnectionGUID: CAOmgBrJQPSomtQem7ho1Q==
X-CSE-MsgGUID: sl2CzatoQMSnv90QwmAIIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,203,1774335600"; 
   d="scan'208";a="240750457"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 13 Jun 2026 12:21:12 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wYTun-00000000QD8-2AOP;
	Sat, 13 Jun 2026 19:21:09 +0000
Date: Sun, 14 Jun 2026 03:20:42 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 9d335aed8840f6bf83ba93309ae5e185de829c21
Message-ID: <202606140331.1bGmcbPy-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 237FBC0004
X-Rspam-User: 
X-Stat-Signature: 6e8kzgie76ds5txoydw39rdwzi484njk
X-HE-Tag: 1781378474-322458
X-HE-Meta: U2FsdGVkX18rwIEFTPxtQ0Q99wsZUQY+DzyoN5CdQbS+Wfq5XqMJ5+tGNleYypDvaT0NxhrfUCgZB0OUWckMvrpFrWI06KmjGOC/8q+qXy5wbzEScvCLodjKDdx+PsKG4j8jfEEscL6oFVPWgqSEDKrxYOsImlWPUbdBmpJ3f944gto9ezTgW0SVKVji8cW9yCqSJV7xcocG5CRXhyKEwHIF7MtBcywginLz/2C7U0/5c1rW9rYM4rTITTBtw+WcIFwdZytrqHq6r2jZTYugessUa7ISDGW85VSrYvjXHL32RbnIFxLPNwUzz2UwFB15q/clzp4077UcqKdSLPst4/RJC1YV1IOywaFgqpbYyLDT34mqnnRH7D/WB+09pG3NZI6znlamUyd8Dcu5zPrX5tAymDMEWdhfjsU7s/ui5btG9CCtezn2nxJbhTNqxZ2hhTxOMJwrVBhRS3R0WzlJlBL8IdgUAAoACQe+tgsF7vkamMXvSffZ7Yc3aM4iKSy5vyTGRe5mDU36E2775J8uWG1P0mJe7tDLdfWesdS6CwcbhmG1/0i11dYmtt5/p5kzTxMBkEmg36N0ctySsjb3LRSr0P79KrOOxGid+2rZGU6FzrpeUd+MNnoL0F5S4Y43PL9j5YC0eJEMk39ebLP6kiyxm6l7l/O3YMvR5iaf+xkB6pv5Bczp3ss3gbHZBJHeJrhTzTSdAmM4WfioKtLXa8idLnVc5f0/UlDHODNb+miF7/PC8PkUWERcS3v1NfhjVZa/koztlhEzmtT+D+V/5LyXS1CcQJi2K/wYGHRbHvNJ5VBMLVHL0V6cMVI8Xix7FO/JuSpxhvK5nJcVYHPmn+9Lnis+ZH7UrfNBU8MIkxCaEnSE6fnmOhpiRcKDMiqIRYvyNIzm2R0imx8BRylmBmy0hpFMXDaCJG0rxFahvYTDv3sfvBfkccL3SI7GUUfnnjU59BJ8PhgJTqsO4C2
 +Lp8MzaJ
 26O6Fk3Ofcix+YL/UiDJQMmReiR4oheBKkcXP/RoNEIH6eFnBNw4Z94l16Eq4gUWN/Ul60UwrEZX4c35WNK+mmBtms/kTPLGIqMmayIqGz9ynTlAPvSgpHTw80e+wwHsm8uSB7V+hLeFqKHsOByWJQz9ZfprDA8w43ri+SW7t80kVb7IU56DYJ2O9p+YEOStrG1+ztHdYef1MFXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 9d335aed8840f6bf83ba93309ae5e185de829c21  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 910m

configs tested: 284
configs skipped: 5

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
arc                   randconfig-001-20260613    gcc-12.5.0
arc                   randconfig-001-20260614    gcc-11.5.0
arc                   randconfig-002-20260613    gcc-14.3.0
arc                   randconfig-002-20260614    gcc-11.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260613    gcc-8.5.0
arm                   randconfig-001-20260614    gcc-11.5.0
arm                   randconfig-002-20260613    clang-17
arm                   randconfig-002-20260614    gcc-11.5.0
arm                   randconfig-003-20260613    clang-23
arm                   randconfig-003-20260614    gcc-11.5.0
arm                   randconfig-004-20260613    clang-23
arm                   randconfig-004-20260614    gcc-11.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260613    gcc-16.1.0
arm64                 randconfig-002-20260613    clang-16
arm64                 randconfig-002-20260613    gcc-16.1.0
arm64                 randconfig-003-20260613    clang-23
arm64                 randconfig-003-20260613    gcc-16.1.0
arm64                 randconfig-004-20260613    clang-19
arm64                 randconfig-004-20260613    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260613    gcc-16.1.0
csky                  randconfig-002-20260613    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260613    clang-23
hexagon               randconfig-001-20260614    clang-16
hexagon               randconfig-002-20260613    clang-23
hexagon               randconfig-002-20260614    clang-16
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260613    gcc-14
i386        buildonly-randconfig-001-20260614    gcc-14
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260613    gcc-14
i386        buildonly-randconfig-002-20260614    gcc-14
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260613    clang-22
i386        buildonly-randconfig-003-20260613    gcc-14
i386        buildonly-randconfig-003-20260614    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260613    gcc-13
i386        buildonly-randconfig-004-20260613    gcc-14
i386        buildonly-randconfig-004-20260614    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260613    clang-22
i386        buildonly-randconfig-005-20260613    gcc-14
i386        buildonly-randconfig-005-20260614    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260613    gcc-14
i386        buildonly-randconfig-006-20260614    gcc-14
i386                                defconfig    clang-22
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260613    clang-22
i386                  randconfig-001-20260613    gcc-14
i386                           randconfig-002    gcc-14
i386                  randconfig-002-20260613    clang-22
i386                           randconfig-003    gcc-14
i386                  randconfig-003-20260613    clang-22
i386                  randconfig-003-20260613    gcc-14
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260613    clang-22
i386                           randconfig-005    gcc-14
i386                  randconfig-005-20260613    clang-22
i386                           randconfig-006    gcc-14
i386                  randconfig-006-20260613    clang-22
i386                  randconfig-006-20260613    gcc-14
i386                           randconfig-007    gcc-14
i386                  randconfig-007-20260613    clang-22
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260613    clang-22
i386                  randconfig-011-20260613    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260613    clang-22
i386                  randconfig-012-20260613    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260613    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260613    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260613    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260613    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260613    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260613    clang-18
loongarch             randconfig-001-20260614    clang-16
loongarch             randconfig-002-20260613    clang-23
loongarch             randconfig-002-20260614    clang-16
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
m68k                        m5407c3_defconfig    gcc-16.1.0
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
nios2                 randconfig-001-20260613    gcc-11.5.0
nios2                 randconfig-001-20260614    clang-16
nios2                 randconfig-002-20260613    gcc-10.5.0
nios2                 randconfig-002-20260614    clang-16
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
parisc                         randconfig-001    gcc-15.2.0
parisc                randconfig-001-20260613    gcc-15.2.0
parisc                randconfig-001-20260613    gcc-9.5.0
parisc                         randconfig-002    gcc-15.2.0
parisc                randconfig-002-20260613    gcc-15.2.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                  mpc885_ads_defconfig    clang-23
powerpc                        randconfig-001    gcc-15.2.0
powerpc               randconfig-001-20260613    gcc-14.3.0
powerpc               randconfig-001-20260613    gcc-15.2.0
powerpc                        randconfig-002    gcc-15.2.0
powerpc               randconfig-002-20260613    gcc-15.2.0
powerpc               randconfig-002-20260613    gcc-8.5.0
powerpc64                      randconfig-001    gcc-15.2.0
powerpc64             randconfig-001-20260613    clang-23
powerpc64             randconfig-001-20260613    gcc-15.2.0
powerpc64                      randconfig-002    gcc-15.2.0
powerpc64             randconfig-002-20260613    clang-16
powerpc64             randconfig-002-20260613    gcc-15.2.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260613    gcc-10.5.0
riscv                 randconfig-001-20260613    gcc-8.5.0
riscv                 randconfig-001-20260614    gcc-9.5.0
riscv                 randconfig-002-20260613    clang-23
riscv                 randconfig-002-20260613    gcc-10.5.0
riscv                 randconfig-002-20260614    gcc-9.5.0
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260613    clang-23
s390                  randconfig-001-20260613    gcc-10.5.0
s390                  randconfig-001-20260614    gcc-9.5.0
s390                  randconfig-002-20260613    clang-16
s390                  randconfig-002-20260613    gcc-10.5.0
s390                  randconfig-002-20260614    gcc-9.5.0
s390                       zfcpdump_defconfig    clang-22
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-23
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260613    gcc-10.5.0
sh                    randconfig-001-20260614    gcc-9.5.0
sh                    randconfig-002-20260613    gcc-10.5.0
sh                    randconfig-002-20260613    gcc-16.1.0
sh                    randconfig-002-20260614    gcc-9.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260613    gcc-11.5.0
sparc                 randconfig-001-20260613    gcc-13.4.0
sparc                 randconfig-002-20260613    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260613    gcc-11.5.0
sparc64               randconfig-001-20260613    gcc-13.4.0
sparc64               randconfig-002-20260613    clang-23
sparc64               randconfig-002-20260613    gcc-13.4.0
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260613    gcc-13.4.0
um                    randconfig-001-20260613    gcc-14
um                    randconfig-002-20260613    gcc-13.4.0
um                    randconfig-002-20260613    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260613    clang-22
x86_64      buildonly-randconfig-002-20260613    clang-22
x86_64      buildonly-randconfig-003-20260613    clang-22
x86_64      buildonly-randconfig-004-20260613    clang-22
x86_64      buildonly-randconfig-005-20260613    clang-22
x86_64      buildonly-randconfig-005-20260613    gcc-14
x86_64      buildonly-randconfig-006-20260613    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260613    gcc-14
x86_64                randconfig-002-20260613    gcc-12
x86_64                randconfig-003-20260613    gcc-14
x86_64                randconfig-004-20260613    clang-22
x86_64                randconfig-005-20260613    clang-22
x86_64                randconfig-006-20260613    clang-22
x86_64                randconfig-011-20260613    clang-22
x86_64                randconfig-011-20260613    gcc-13
x86_64                randconfig-012-20260613    clang-22
x86_64                randconfig-013-20260613    clang-22
x86_64                randconfig-014-20260613    clang-22
x86_64                randconfig-015-20260613    clang-22
x86_64                randconfig-016-20260613    clang-22
x86_64                randconfig-016-20260613    gcc-14
x86_64                randconfig-071-20260613    clang-22
x86_64                randconfig-072-20260613    clang-22
x86_64                randconfig-073-20260613    clang-22
x86_64                randconfig-074-20260613    gcc-13
x86_64                randconfig-075-20260613    gcc-14
x86_64                randconfig-076-20260613    gcc-14
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
xtensa                randconfig-001-20260613    gcc-11.5.0
xtensa                randconfig-001-20260613    gcc-13.4.0
xtensa                randconfig-002-20260613    gcc-13.4.0
xtensa                randconfig-002-20260613    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

