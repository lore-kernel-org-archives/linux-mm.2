Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6294CCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319E86B008A; Tue, 23 Jun 2026 07:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CB006B008C; Tue, 23 Jun 2026 07:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BAD56B0092; Tue, 23 Jun 2026 07:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC9666B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:15:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52DDEC1FE5
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:15:42 +0000 (UTC)
X-FDA: 84910922124.07.7D662A1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf24.hostedemail.com (Postfix) with ESMTP id B162D180010
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:15:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="be/WVOdn";
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782213340;
	b=Upv2TaVu1j/Pi8sQLGQPXW0Eq35HWEPhFZflrGBZoeR7C6C+J2F7KP7SiWLjEgDUV670z0
	NVd/NZmgRpu526Gh2V+IeqPtVYr3nBjLx35RRm8by+lafCzyV502ch0YB2PWt4vYkyl1Cm
	0zqUIeH8lZkfNK1ZjRSau01POhWLs90=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782213340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Zgij1x6CLJcXbh1ECmu5bovLJYADaJfbMd2mNN9plFk=;
	b=QiVxKuW8wO07J3KFxjGKDkGPrOhIdDOHYxn9RrycEW80fGMbRXIf7MzlAUVYJq/3ThXYZt
	76Hk7zwFiQdlX22IDzb5+qgiJ1pUk+6TgTq6y0JudJ9jJ1QI5O2oliccbdCHBUJjqWODqz
	FX9hQc+CsEkVIDcWdpJFXOGJcfeX1sM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="be/WVOdn";
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782213340; x=1813749340;
  h=date:from:to:cc:subject:message-id;
  bh=KcNq6s9nGMaY0etdzTWCo/MpQoTAMzGDSY7HSbCPM5o=;
  b=be/WVOdnUTrV7q8E5FYkBQvNd+pSvzMsyfqfxa+GZ3sifqDb8cEHbbfc
   sYCvxlsA/voRM14QSWBKtB1WHBT5p3HQ5OJNC24aC3COhdoPf+9GcquDO
   OCjO1CPjImg9Ir951MDuv8f0fnS6nXZRCW69/1U3wwQ2pwfOwlHPPPTO5
   jn6Tn0LVXwnFUShup1YFa4CMyBQEacqsYfrzqihEgjtuaCcaMJk4qJZ6g
   qhljUwNcQAkt7kpeQLwTfwurszZIDG38eMpLYVs+QDPwDoIoPdEMXv3ZM
   x4PH/XWwQAmM4QXYZlG5i8C/MChyyHc7oJbK7h8epshYAAL5ENlagxKql
   g==;
X-CSE-ConnectionGUID: Gfa/X03nTEOdU8Jbvf0HQw==
X-CSE-MsgGUID: SHWnzQO3RLiFJaDaHPuzsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="82822572"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="82822572"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 04:15:38 -0700
X-CSE-ConnectionGUID: ftyivKRmSWyp+Td5ZW0/DA==
X-CSE-MsgGUID: GF79X0GWTcyVTiGInOG51A==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 23 Jun 2026 04:15:36 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wbz6M-000000002Th-0utB;
	Tue, 23 Jun 2026 11:15:34 +0000
Date: Tue, 23 Jun 2026 19:15:30 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 189ce3c81f8188fb737d59a8a8784f074e830238
Message-ID: <202606231918.8lBNPlJx-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B162D180010
X-Rspam-User: 
X-Stat-Signature: cisn7scm5g5shnoyjsxusgytgw5ype7d
X-HE-Tag: 1782213339-571312
X-HE-Meta: U2FsdGVkX192GOSraVzUg+//ttOfLyaczvUacZ+cb9byvhI5vtb7uUgccJ54wfGlRxCQV7WENLKLkZ47/tm/u5aQjWkMqFs0s9azdcJFhj+MiwIBG02Aan1EaQxS8z2iVPUoDCnYXfC1eXIyVNsdFKs+78PRQler8zUEpEuYDR41gw14GKAZi7sKDk0vTMtqBWR41/DEpKuScInfh0pxwl+PbUI70Xy9gJ0FggckEYp7s+t0EqaiFmPL3kS5rgdLMtSMcC5GK7OYJ68Q8VzAA6AQux0wWQbZnHFUD5O9y3TZz/ZP3TGRI3v2wgOm9Me1nbJZNKkwfbmzMTN3CcDMP3Yfu0S2Fke/A/k+4kjhwlAsJcvAJPufIeL2aYUvYzmTqGYFc4hlr8vPtSULZLPIooaubuDZQT1s28K1t3a98X/igKqx+WESl+P9Vbq+7KS4jNCMXtK5s1Vba327TkUcoiva1RTbe/+Tw0GF3ev8WU8a9mfpv7wqwu+rJGc6kaNL+bCawGiiR6395u1/q7sfTh+jSySQMiPP1BtH2muSEDTQ5vPD389vAUFSkmQRRU6Dpl6QL/OQjqcw4ZPOYDDng9Itc8Bxl7c7zdoEnLlDiMYNpFxPj/Iz/P1AgKGv4anPvzxZ2tT7rF8rPQrw2jeofY2MAra65HqEXczlRvDkmzRFzZx4fzkOjZFNL6J6HDiwk58gxaHWAraMnWNkfbiRJOYNsRXj4i5S76hLEk8L9Rdd61ufDIAkqlDeBo8nlLUne0axx+K7jyWRs15QCE+TRZBW8jnygNG0+7a01sqLf+vjHB2D4U71iHt9xmPqSNsJwOMHGdZ4BjOY+DpsrZ+OcJ6/r+kqNk9Ah+bkzAcDeinTWnu6pt2D0mwDyZBE/tQvJQKOsLEIRj8zmCdMwIEHYFZ/Ukpx+aCNckL4slmF0Uda3CLPcDAhgtE9srymSMoTbGKAxRRI/n7aIPOEbfU
 eybtVyyB
 6kSWKy29iEbljeAdqpcjUDp/AVtmi/NZ44+eyXgoRvWYvz+hoYP0nchOT2zHZq+dKJ4vh2DFZl5EE2ZcN/iIx6tFOlnYMMrLV5F3qXn1sJdJLFKhLiOP7Rp6LYohWgrYDwU/u6LxiH/bBCmapy0dXtfZ847Aobc3wWgTYv5uM90ftYS0mNx8bhQLWe5pMlxdgAq47RB11q7PvNE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 189ce3c81f8188fb737d59a8a8784f074e830238  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 771m

configs tested: 306
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
arc                   randconfig-001-20260623    clang-23
arc                   randconfig-001-20260623    gcc-10.5.0
arc                   randconfig-002-20260623    clang-23
arc                   randconfig-002-20260623    gcc-16.1.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260623    clang-23
arm                   randconfig-002-20260623    clang-23
arm                   randconfig-002-20260623    gcc-10.5.0
arm                   randconfig-003-20260623    clang-23
arm                   randconfig-004-20260623    clang-23
arm                   randconfig-004-20260623    gcc-14.3.0
arm                           spitz_defconfig    gcc-16.1.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    clang-23
arm64                 randconfig-001-20260623    clang-23
arm64                 randconfig-001-20260623    gcc-14.3.0
arm64                          randconfig-002    clang-23
arm64                 randconfig-002-20260623    clang-23
arm64                 randconfig-002-20260623    gcc-14.3.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260623    clang-23
arm64                 randconfig-003-20260623    gcc-14.3.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260623    clang-23
arm64                 randconfig-004-20260623    gcc-14.3.0
arm64                 randconfig-004-20260623    gcc-8.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    clang-23
csky                  randconfig-001-20260623    clang-23
csky                  randconfig-001-20260623    gcc-14.3.0
csky                  randconfig-001-20260623    gcc-16.1.0
csky                           randconfig-002    clang-23
csky                  randconfig-002-20260623    clang-23
csky                  randconfig-002-20260623    gcc-14.3.0
csky                  randconfig-002-20260623    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260623    clang-23
hexagon               randconfig-001-20260623    gcc-11.5.0
hexagon               randconfig-001-20260623    gcc-8.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260623    clang-18
hexagon               randconfig-002-20260623    gcc-11.5.0
hexagon               randconfig-002-20260623    gcc-8.5.0
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260623    clang-22
i386        buildonly-randconfig-001-20260623    gcc-14
i386        buildonly-randconfig-002-20260623    gcc-14
i386        buildonly-randconfig-003-20260623    gcc-14
i386        buildonly-randconfig-004-20260623    gcc-14
i386        buildonly-randconfig-005-20260623    gcc-14
i386        buildonly-randconfig-006-20260623    clang-22
i386        buildonly-randconfig-006-20260623    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260623    clang-22
i386                  randconfig-001-20260623    gcc-14
i386                  randconfig-002-20260623    clang-22
i386                  randconfig-003-20260623    clang-22
i386                  randconfig-003-20260623    gcc-14
i386                  randconfig-004-20260623    clang-22
i386                  randconfig-004-20260623    gcc-14
i386                  randconfig-005-20260623    clang-22
i386                  randconfig-006-20260623    clang-22
i386                  randconfig-007-20260623    clang-22
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260623    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260623    clang-22
i386                  randconfig-012-20260623    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260623    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260623    clang-22
i386                  randconfig-014-20260623    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260623    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260623    clang-22
i386                  randconfig-016-20260623    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260623    clang-22
i386                  randconfig-017-20260623    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260623    gcc-11.5.0
loongarch             randconfig-001-20260623    gcc-14.3.0
loongarch             randconfig-001-20260623    gcc-8.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260623    gcc-11.5.0
loongarch             randconfig-002-20260623    gcc-16.1.0
loongarch             randconfig-002-20260623    gcc-8.5.0
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
nios2                            alldefconfig    gcc-11.5.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260623    gcc-11.5.0
nios2                 randconfig-001-20260623    gcc-8.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260623    gcc-11.5.0
nios2                 randconfig-002-20260623    gcc-8.5.0
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
parisc                         randconfig-001    gcc-11.5.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260623    gcc-11.5.0
parisc                         randconfig-002    gcc-11.5.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260623    gcc-11.5.0
parisc                randconfig-002-20260623    gcc-8.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                      ppc44x_defconfig    clang-17
powerpc                        randconfig-001    gcc-10.5.0
powerpc                        randconfig-001    gcc-11.5.0
powerpc               randconfig-001-20260623    clang-23
powerpc               randconfig-001-20260623    gcc-11.5.0
powerpc                        randconfig-002    gcc-11.5.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260623    clang-23
powerpc               randconfig-002-20260623    gcc-11.5.0
powerpc64                      randconfig-001    clang-16
powerpc64                      randconfig-001    gcc-11.5.0
powerpc64             randconfig-001-20260623    clang-23
powerpc64             randconfig-001-20260623    gcc-11.5.0
powerpc64                      randconfig-002    clang-23
powerpc64                      randconfig-002    gcc-11.5.0
powerpc64             randconfig-002-20260623    gcc-11.5.0
powerpc64             randconfig-002-20260623    gcc-12.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260623    clang-23
riscv                 randconfig-001-20260623    gcc-8.5.0
riscv                 randconfig-002-20260623    gcc-8.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260623    gcc-15.2.0
s390                  randconfig-001-20260623    gcc-8.5.0
s390                  randconfig-002-20260623    clang-19
s390                  randconfig-002-20260623    gcc-8.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260623    gcc-16.1.0
sh                    randconfig-001-20260623    gcc-8.5.0
sh                    randconfig-002-20260623    gcc-16.1.0
sh                    randconfig-002-20260623    gcc-8.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260623    gcc-8.5.0
sparc                 randconfig-002-20260623    gcc-11.5.0
sparc                 randconfig-002-20260623    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260623    gcc-8.5.0
sparc64               randconfig-002-20260623    clang-21
sparc64               randconfig-002-20260623    gcc-8.5.0
um                               allmodconfig    clang-17
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260623    clang-23
um                    randconfig-001-20260623    gcc-8.5.0
um                    randconfig-002-20260623    gcc-14
um                    randconfig-002-20260623    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260623    clang-22
x86_64      buildonly-randconfig-001-20260623    gcc-14
x86_64      buildonly-randconfig-002-20260623    clang-22
x86_64      buildonly-randconfig-002-20260623    gcc-14
x86_64      buildonly-randconfig-003-20260623    clang-22
x86_64      buildonly-randconfig-004-20260623    clang-22
x86_64      buildonly-randconfig-005-20260623    clang-22
x86_64      buildonly-randconfig-006-20260623    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260623    gcc-14
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260623    gcc-14
x86_64                         randconfig-003    clang-22
x86_64                         randconfig-003    gcc-14
x86_64                randconfig-003-20260623    gcc-14
x86_64                         randconfig-004    clang-22
x86_64                         randconfig-004    gcc-14
x86_64                randconfig-004-20260623    gcc-14
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260623    clang-22
x86_64                randconfig-005-20260623    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                         randconfig-006    gcc-14
x86_64                randconfig-006-20260623    clang-22
x86_64                randconfig-006-20260623    gcc-14
x86_64                randconfig-011-20260623    clang-22
x86_64                randconfig-011-20260623    gcc-14
x86_64                randconfig-012-20260623    gcc-14
x86_64                randconfig-013-20260623    clang-22
x86_64                randconfig-013-20260623    gcc-14
x86_64                randconfig-014-20260623    clang-22
x86_64                randconfig-014-20260623    gcc-14
x86_64                randconfig-015-20260623    gcc-14
x86_64                randconfig-016-20260623    clang-22
x86_64                randconfig-016-20260623    gcc-14
x86_64                randconfig-071-20260623    gcc-14
x86_64                randconfig-072-20260623    gcc-14
x86_64                randconfig-073-20260623    gcc-14
x86_64                randconfig-074-20260623    gcc-14
x86_64                randconfig-075-20260623    gcc-14
x86_64                randconfig-076-20260623    clang-22
x86_64                randconfig-076-20260623    gcc-14
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
xtensa                randconfig-001-20260623    gcc-8.5.0
xtensa                randconfig-002-20260623    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

