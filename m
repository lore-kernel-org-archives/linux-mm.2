Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A976C43327
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE07F6B013E; Thu,  2 Jul 2026 20:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91E46B0140; Thu,  2 Jul 2026 20:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80C76B0141; Thu,  2 Jul 2026 20:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD876B013E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:50:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95BAF1C7092
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:02:19 +0000 (UTC)
X-FDA: 84944908398.08.F964B89
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf31.hostedemail.com (Postfix) with ESMTP id C140420011
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:02:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fW0CNfoy;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783022537;
	b=tD1rKUWAECcpUaQK/kL5T8yaN/luMVfggbl27kJItvt9NgVapT5qLaw3cf7WSV//AVe1sZ
	cYIb0heFOb7Xt27w582qX8g8PxVwP5DlzMp9ORuynkwYPetvINIsTJzXS0HMwcafDZaYlR
	xwwRxIa2Ilkoxc6VjAjpa4S3B5/jZ8Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783022537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=1Q3CPQFBePSFyDedSDxyG3dqqyBNmbK8+WjbxLAP6mc=;
	b=E8OQrptToPctbs2LWDfoYPtmUOnEYRGhrWxVowtRrBoNwrAe2oHh+++XWBo4aLg9NXuEio
	y5ers/0uOzfh5dCRszDTOWQ6TOS0RWU4TePwtAn+4gl9YpR4ixbzCJ8vaJMOyUQXyszzoB
	JsxOImTU3wkmEmaEdmfKvW9sv4PbWkU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fW0CNfoy;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783022537; x=1814558537;
  h=date:from:to:cc:subject:message-id;
  bh=oWfGGuXI5LlDGf8RfWOc/+FJ1lMT+ALq7IdrqPCGp+s=;
  b=fW0CNfoytuSt8Tg4wMpBVZLi8kQqHtCm63u9t9sdAONLJoDmrgYjeeCi
   eeZczFshvXw1D0WjupAmui7miMJgMtDCxhgH+G9wlNtpJiJ1FoDh/CYam
   Lhp4yK+fdi0M1WTGC2kMcwBaE1od8CfhdZMGwdYv0GTbHbyE5H8X71aMw
   QNG3zUC//qsfB2WLPICIe26AgODLJgs8B2aRdhZJfBugadqick/JOEygd
   YkX/zwNyG/FRCqTW2XMeNHqB1rPvE2ICVDI2Rxyn+/qew7V6ZeeFLlRsK
   VB0RlbMfWFOyHNpOuzego29oMKOLSkvdZ6LmzFFXxwflIwCJbSu1AjVLi
   g==;
X-CSE-ConnectionGUID: wYfWHKJURRG6JNs76DWadw==
X-CSE-MsgGUID: T35WDkAqSyOLfrPTlWI//Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="83813168"
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="83813168"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 13:02:15 -0700
X-CSE-ConnectionGUID: 9uX+5ksGTGaWYFMhrBlBtg==
X-CSE-MsgGUID: 3qNADeZLTLOWyZpUQl2RZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="291070396"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 02 Jul 2026 13:02:13 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfNbu-00000000BBu-3kRB;
	Thu, 02 Jul 2026 20:02:10 +0000
Date: Fri, 03 Jul 2026 04:00:11 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 53dd0fe28a45bf38eb15c967e8eeb5a462a2abb3
Message-ID: <202607030400.YfsPmG2H-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C140420011
X-Stat-Signature: mbr3x4wa8chdgu6rowj8ugk9qfdhp4jd
X-HE-Tag: 1783022536-600838
X-HE-Meta: U2FsdGVkX1878FRBEPIJvUDZcEaxt/p7VIS9VIJkD+ucv6EKftMDebziW/fUqFpuvnIgYJGK7MgSwo5tRZkTQUZtwYMGFPb7mA9TzQnaFixCyJDm2iLlm0S27F8wJbISY0BmsvMX+ehIUxJB6IH9mFPqmXOveN4+LJHzBCpIrsAilsvqwWCcvhYWpCneukMjF3m/RTVGFPdp1hKjwzwkrRHnTkVNDWCTrf6jFEXDnbIukyHnE1BzoFganqMvNDxrDCn58Ncl8QIepE6/2QlINbr4qub/Qma5vzH5LU+dH2/P1SAN9wro+y6dHFsMY0M2Iv3K7EBwMfEwmHXUN+Dx6e4AssQl6zJo0qUm4LjzpD9UNsa2ntoEHE5OiF+XcDgaarhsqCsF//EjUEXqoUKW4UPSgS4lsJPAHa0g16UQf7bvQuJ2vVgP84P9Twy41zDUq5EMiX9WA93+003XWkzIhAo2uIKjRoa2n/1R04qbFKxgWF3CIFM1ET3/HoWr140jXljk4lyZ530tRHXX11fImXGPS+Wq/hw7yom2z77IvwxSmiaKHajldz+kx2B0rW5KDPUpyWIAwlaol+Ab8aKARBRyIkJl844mZ5yWwLJ+CRCctEFRnzRM2QqevuRytf/fbutuA1TuA5luED8eBDzSbZXxaswmw1dPfQx3+4oAtyWL6s8sl5sFGL72Y1MRQiBMINxwXlyhFiL8PzFSG6XF54jj9ZtcmkWAeg2f+txBgtBxTL1yuffvMMAmlByv+hb8id6fJwwllWGDzl2mHPZkNs/ECr8nbsvlGFpLUCA0nP4DVebm+knYW8I7strmqxwRXArQf8K2VZ6vEIaVgw22FtijqHJc/w3XCR95wmWzicLWMnaMS+/yCWt7UfUPBjcEf9b0vHSwfB9ib5wZyyVyFpR6LCjBTkxdaf280HhVK7aI2lP6CipwTPWoCswxhtCQ5gpkozlNT4cUhDXuJzH
 x0zU5g6R
 GPIQp9pSfPg6AbtCnvw8LiylzCDo+kt0Uga+y3seowncY9Gc3ObLV5rZtNrH6hrfICNHKYpSCBO1vZ/61bnLgXqcj+eI+UjpHezkcL/eynJyDV29DOqOZgiUMfN0p8ljPXZOAvaiq/ELmDTOQyh4S0F1+2kJkgDQ5H99BcopHvrxjLBmznCcL2Ancjz2twBEBn9pwJzRJDmGi1yA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 53dd0fe28a45bf38eb15c967e8eeb5a462a2abb3  Merge branch 'range-checks' into for-next

elapsed time: 744m

configs tested: 279
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
arc                            randconfig-001    gcc-16.1.0
arc                   randconfig-001-20260702    gcc-16.1.0
arc                   randconfig-001-20260702    gcc-8.5.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260702    gcc-16.1.0
arc                   randconfig-002-20260702    gcc-8.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    gcc-16.1.0
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260702    gcc-16.1.0
arm                   randconfig-001-20260702    gcc-8.5.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260702    gcc-16.1.0
arm                   randconfig-002-20260702    gcc-8.5.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260702    gcc-16.1.0
arm                   randconfig-003-20260702    gcc-8.5.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260702    gcc-16.1.0
arm                   randconfig-004-20260702    gcc-8.5.0
arm                        spear6xx_defconfig    clang-23
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
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260702    clang-23
hexagon               randconfig-001-20260702    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260702    clang-23
hexagon               randconfig-002-20260702    gcc-11.5.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    clang-22
i386        buildonly-randconfig-001-20260702    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260702    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260702    clang-22
i386                 buildonly-randconfig-004    clang-22
i386        buildonly-randconfig-004-20260702    clang-22
i386                 buildonly-randconfig-005    clang-22
i386        buildonly-randconfig-005-20260702    clang-22
i386                 buildonly-randconfig-006    clang-22
i386        buildonly-randconfig-006-20260702    clang-22
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
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260702    clang-23
loongarch             randconfig-002-20260702    gcc-11.5.0
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
mips                           ci20_defconfig    clang-23
mips                        omega2p_defconfig    clang-17
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260702    clang-23
nios2                 randconfig-001-20260702    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260702    clang-23
nios2                 randconfig-002-20260702    gcc-11.5.0
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
parisc                randconfig-001-20260702    gcc-10.5.0
parisc                         randconfig-002    clang-17
parisc                randconfig-002-20260702    clang-17
parisc                randconfig-002-20260702    gcc-12.5.0
parisc64                            defconfig    clang-23
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    clang-17
powerpc               randconfig-001-20260702    clang-17
powerpc                        randconfig-002    clang-17
powerpc               randconfig-002-20260702    clang-17
powerpc               randconfig-002-20260702    gcc-8.5.0
powerpc                         wii_defconfig    gcc-16.1.0
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260702    clang-17
powerpc64             randconfig-001-20260702    gcc-15.2.0
powerpc64                      randconfig-002    clang-17
powerpc64             randconfig-002-20260702    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    gcc-12.5.0
riscv                 randconfig-001-20260702    gcc-12.5.0
riscv                          randconfig-002    gcc-12.5.0
riscv                 randconfig-002-20260702    gcc-12.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    gcc-12.5.0
s390                  randconfig-001-20260702    gcc-12.5.0
s390                           randconfig-002    gcc-12.5.0
s390                  randconfig-002-20260702    gcc-12.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                 kfr2r09-romimage_defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-12.5.0
sh                    randconfig-001-20260702    gcc-12.5.0
sh                             randconfig-002    gcc-12.5.0
sh                    randconfig-002-20260702    gcc-12.5.0
sh                           se7619_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260702    gcc-16.1.0
sparc                          randconfig-002    gcc-16.1.0
sparc                 randconfig-002-20260702    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-16.1.0
sparc64               randconfig-001-20260702    gcc-16.1.0
sparc64                        randconfig-002    gcc-16.1.0
sparc64               randconfig-002-20260702    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-16.1.0
um                    randconfig-001-20260702    gcc-16.1.0
um                             randconfig-002    gcc-16.1.0
um                    randconfig-002-20260702    gcc-16.1.0
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
x86_64                randconfig-011-20260702    clang-22
x86_64                randconfig-012-20260702    clang-22
x86_64                randconfig-013-20260702    clang-22
x86_64                randconfig-014-20260702    clang-22
x86_64                randconfig-015-20260702    clang-22
x86_64                randconfig-016-20260702    clang-22
x86_64                randconfig-071-20260702    clang-22
x86_64                randconfig-072-20260702    clang-22
x86_64                randconfig-073-20260702    clang-22
x86_64                randconfig-074-20260702    clang-22
x86_64                randconfig-075-20260702    clang-22
x86_64                randconfig-076-20260702    clang-22
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
xtensa                         randconfig-001    gcc-16.1.0
xtensa                randconfig-001-20260702    gcc-16.1.0
xtensa                         randconfig-002    gcc-16.1.0
xtensa                randconfig-002-20260702    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

