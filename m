Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ABEBC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE83C6B0005; Wed,  8 Jul 2026 09:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3926B0088; Wed,  8 Jul 2026 09:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFD536B008A; Wed,  8 Jul 2026 09:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B38A66B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:31:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BF24167771
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:31:14 +0000 (UTC)
X-FDA: 84965695668.01.923EAA3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B77F40006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:31:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D3HZZaiO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783517472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/BT9GUmElz7H+MklEp3iXPCkHH6+mV/ugMOuRvPF6mw=;
	b=PM9fKMsqbg8P4KFx4HCz4zrI2B2di9wKUkDT0st4+I/W81WTmplhTOSCU5XMPBExO/U0vl
	1lqLakAfUNKM2vpQ87WHXdmXGlQ63kS46IfBh9ElaFh3pZfME3sHA+dqluVEiPYYgIl/vj
	ukxPBcczde6TzuXYnmYigprqfYufQgg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D3HZZaiO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783517472;
	b=LyUmVnTpgrCR/rzJqk0L9EgPfQSGp76p4y804UVVFxFYmX06WT7yCejwUMPAdPKHxXGWfb
	ltt6CsfUfv1B1U7xvclD6WD8bswuawf1WZP3WjjaKT8iTJ1/rEqnzJEqJGHyM9ttBmAJeb
	ZyqbqxBCYYpv0C2CPIgs/2Z7n85w5+w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783517470; x=1815053470;
  h=date:from:to:cc:subject:message-id;
  bh=S9GwKFM0OhOTKmUwIau5gYp0Qb0n8ErXwvwgML0c4sU=;
  b=D3HZZaiOIp/e9Gv/itEdAME009wnQmbhqWy7/Nesm4dxT47jn1D4L/Wd
   o8WCulOvlq87uyn6qHjI9C7aVfMVyDsea8iSikY/F+B1WyieJRzAMcaN9
   fErhqFpx6G37BUeK7dMrEDZtB2JoN1lM2RdyBN5jNQp+WEo9DkQkFxguP
   EO9T9+nd0hPWjppWKTc92NqyDE1O51lWbVcLsV+rsJDURUoLwGBbbDqhz
   6hexhQYaRRmji/Q5wtLU6SH8mqNP2plzJ4R299qYxIEN2TKkOrD4xoCLm
   uTZcA8KqSbKW8TYdoiqBknlkcmGEJbcCao0ZB5pYIHcZCD/zX7NBKgVZ4
   A==;
X-CSE-ConnectionGUID: Opl3W3FiQOGx+oF0EuI8bA==
X-CSE-MsgGUID: cs7wsr+hQbqU1K/R1T9TYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="87861156"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="87861156"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 06:31:09 -0700
X-CSE-ConnectionGUID: 5hD/MdjUSUmbnih1b5dWnQ==
X-CSE-MsgGUID: VnrgdbivQbGr+I6tr3LtZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="253802024"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 08 Jul 2026 06:31:07 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whSMi-00000000GQV-0gVH;
	Wed, 08 Jul 2026 13:31:04 +0000
Date: Wed, 08 Jul 2026 21:30:04 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 302dfbff3e73be2ba5723237c6303244ec27cebb
Message-ID: <202607082153.gEvkpee7-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: eq4zs4z43bx64hkbax7ofrm6qwy1aayw
X-Rspamd-Queue-Id: 4B77F40006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783517470-13385
X-HE-Meta: U2FsdGVkX18MswLCVwxLsR36aDtA0X4k2BIGXHDYTXrc9Zmf583bTEewfmLmM3/hTyPXwiUQyZdDVlflQvJhvnwhHKJ9KV4ukq+zlcJ42ahRR8jHkjcRSIianIMtJNiHZnPqje7cUS531rXLAb/Mb4+8Dl99pjo3cnA4+gyW8uLiW89rD3HdWvyn3E6wEp9mpPII+X/r62+d55yQWvmayA6U/VRAHR1MgJkIRLRAWnOSXuVSju7KeENi7qpnOMT/7cLakqiKsyMNunAgk4Jbs/7xX6edoSdJhWqJztiqTJaV4gDqKBNxpV6VZo/QP0xA+R1o3avGQV+/KYd7vxejCvKT18Twc58y6TYjawVwb0X081GdsmEXAx0CvuGsxsk2ZOWpdeBK7Khh8lxI51610QTdnE5zI98f2T+VnCHCkEN5KBmIZz+VQSOBVmOJjbP76uqTRDEEIAeF6D6aLI0j2ghBhHXMNXh9z7pMrNJVMvUwnL+ELlZ2/Vjv6N6acziFSvrqBVJyMitkBQq6KlmYG8HxcAyXYLTVicVvJTXMTXhPGwnuCEegt2yfelF0+T75NG6789/aZHjAaGK80b7l6oq7Rkfv0L2RZWI8AFDIm6oxEMG17wuspm8hb8N4neJHv+9kYWj1Cb/8J0RCqwRN3V1zZoFrdrIbWiXYNUPv9iI2YKFrueEaN/bR/vMzXE6Yws4+O2cox/LcJyY4FX1R7UGEKvNr7imgKNGNPYEdlxl5H9jeiiZCP1xLjGueN8lTQ9KnSyQ9vuuWxq+Gjy72e3SXT7F/kF3Y7u/gXcI8Erf5oubRAgi9e1xW6XWGf+XY7YpgaJ/Ii0opoEo5D9/ssNZY5YAAy4ebx/Ebq+CdMqJRL8T0191RWxL14214dd96A+y3e3yyAYeF70UvJfzH5e88d2fjt4vok8/47lNCOfVKpLrSWxSRtLxQCLTE52R2z4gu2s1FnQ2PzMeTnFp
 Yl4I2Dcc
 aB7x3Glkgzqi7CJI9fiTPjQB4kjZEMHTmYoYW6DAPxTCHCpkaa1xDQ0AJddtThMnpfOdqUv4fD8kpRFrbKnU7cWEXZqMrO/l+6dduBAUzc4UsDMpxx+FGNwSs24srm6JJVt13u9ql7RlOpyLpeJ//SXFQduBlkcA4To+pLJxH+nNplqte5GLCr9kxP+a4f2i90VC4kDeo/+pKc3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 302dfbff3e73be2ba5723237c6303244ec27cebb  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 735m

configs tested: 333
configs skipped: 12

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
arc                         haps_hs_defconfig    gcc-16.1.0
arc                            randconfig-001    gcc-16.1.0
arc                   randconfig-001-20260708    gcc-13.4.0
arc                   randconfig-001-20260708    gcc-16.1.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260708    gcc-13.4.0
arc                   randconfig-002-20260708    gcc-15.2.0
arc                   randconfig-002-20260708    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                         lpc32xx_defconfig    clang-17
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260708    gcc-11.5.0
arm                   randconfig-001-20260708    gcc-13.4.0
arm                   randconfig-001-20260708    gcc-16.1.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260708    gcc-10.5.0
arm                   randconfig-002-20260708    gcc-13.4.0
arm                   randconfig-002-20260708    gcc-16.1.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260708    gcc-13.4.0
arm                   randconfig-003-20260708    gcc-16.1.0
arm                   randconfig-003-20260708    gcc-8.5.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260708    gcc-13.4.0
arm                   randconfig-004-20260708    gcc-16.1.0
arm                   randconfig-004-20260708    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    gcc-9.5.0
arm64                 randconfig-001-20260708    clang-23
arm64                 randconfig-001-20260708    gcc-9.5.0
arm64                          randconfig-002    gcc-9.5.0
arm64                 randconfig-002-20260708    clang-23
arm64                 randconfig-002-20260708    gcc-9.5.0
arm64                          randconfig-003    gcc-9.5.0
arm64                 randconfig-003-20260708    gcc-9.5.0
arm64                          randconfig-004    gcc-9.5.0
arm64                 randconfig-004-20260708    gcc-15.2.0
arm64                 randconfig-004-20260708    gcc-9.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    gcc-9.5.0
csky                  randconfig-001-20260708    gcc-11.5.0
csky                  randconfig-001-20260708    gcc-9.5.0
csky                           randconfig-002    gcc-9.5.0
csky                  randconfig-002-20260708    gcc-9.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260708    clang-23
hexagon               randconfig-001-20260708    gcc-11.5.0
hexagon               randconfig-001-20260708    gcc-13.4.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260708    clang-21
hexagon               randconfig-002-20260708    gcc-11.5.0
hexagon               randconfig-002-20260708    gcc-13.4.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    clang-22
i386        buildonly-randconfig-001-20260708    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260708    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260708    clang-22
i386        buildonly-randconfig-003-20260708    gcc-14
i386                 buildonly-randconfig-004    clang-22
i386        buildonly-randconfig-004-20260708    clang-22
i386        buildonly-randconfig-004-20260708    gcc-12
i386                 buildonly-randconfig-005    clang-22
i386        buildonly-randconfig-005-20260708    clang-22
i386        buildonly-randconfig-005-20260708    gcc-14
i386                 buildonly-randconfig-006    clang-22
i386        buildonly-randconfig-006-20260708    clang-22
i386        buildonly-randconfig-006-20260708    gcc-14
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
i386                  randconfig-011-20260708    gcc-14
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260708    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260708    clang-22
i386                  randconfig-013-20260708    gcc-14
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260708    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260708    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260708    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260708    gcc-13
i386                  randconfig-017-20260708    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260708    gcc-11.5.0
loongarch             randconfig-001-20260708    gcc-13.4.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260708    clang-23
loongarch             randconfig-002-20260708    gcc-11.5.0
loongarch             randconfig-002-20260708    gcc-13.4.0
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
nios2                 randconfig-001-20260708    gcc-11.5.0
nios2                 randconfig-001-20260708    gcc-13.4.0
nios2                 randconfig-001-20260708    gcc-9.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260708    gcc-11.5.0
nios2                 randconfig-002-20260708    gcc-13.4.0
nios2                 randconfig-002-20260708    gcc-8.5.0
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
parisc                         randconfig-001    clang-22
parisc                randconfig-001-20260708    clang-22
parisc                randconfig-001-20260708    gcc-12.5.0
parisc                         randconfig-002    clang-22
parisc                randconfig-002-20260708    clang-22
parisc                randconfig-002-20260708    gcc-10.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                      bamboo_defconfig    clang-21
powerpc                        randconfig-001    clang-22
powerpc               randconfig-001-20260708    clang-22
powerpc               randconfig-001-20260708    gcc-11.5.0
powerpc                        randconfig-002    clang-22
powerpc               randconfig-002-20260708    clang-22
powerpc               randconfig-002-20260708    gcc-13.4.0
powerpc64                      randconfig-001    clang-22
powerpc64             randconfig-001-20260708    clang-22
powerpc64             randconfig-001-20260708    clang-23
powerpc64                      randconfig-002    clang-22
powerpc64             randconfig-002-20260708    clang-22
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-23
riscv                 randconfig-001-20260708    clang-23
riscv                 randconfig-001-20260708    gcc-8.5.0
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260708    clang-23
riscv                 randconfig-002-20260708    gcc-8.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-23
s390                  randconfig-001-20260708    clang-20
s390                  randconfig-001-20260708    clang-23
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260708    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    clang-23
sh                    randconfig-001-20260708    clang-23
sh                    randconfig-001-20260708    gcc-16.1.0
sh                             randconfig-002    clang-23
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
x86_64               buildonly-randconfig-001    gcc-12
x86_64      buildonly-randconfig-001-20260708    clang-22
x86_64      buildonly-randconfig-001-20260708    gcc-12
x86_64               buildonly-randconfig-002    gcc-12
x86_64      buildonly-randconfig-002-20260708    gcc-12
x86_64      buildonly-randconfig-002-20260708    gcc-14
x86_64               buildonly-randconfig-003    gcc-12
x86_64      buildonly-randconfig-003-20260708    gcc-12
x86_64               buildonly-randconfig-004    gcc-12
x86_64      buildonly-randconfig-004-20260708    clang-22
x86_64      buildonly-randconfig-004-20260708    gcc-12
x86_64               buildonly-randconfig-005    gcc-12
x86_64      buildonly-randconfig-005-20260708    gcc-12
x86_64      buildonly-randconfig-005-20260708    gcc-14
x86_64               buildonly-randconfig-006    gcc-12
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
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260708    clang-22
x86_64                randconfig-011-20260708    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260708    clang-22
x86_64                         randconfig-013    clang-22
x86_64                randconfig-013-20260708    clang-22
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260708    clang-22
x86_64                randconfig-014-20260708    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260708    clang-22
x86_64                randconfig-015-20260708    gcc-14
x86_64                         randconfig-016    clang-22
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
xtensa                randconfig-001-20260708    gcc-8.5.0
xtensa                randconfig-002-20260708    gcc-16.1.0
xtensa                randconfig-002-20260708    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

