Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE9DC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16C016B0005; Sat, 11 Jul 2026 14:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D8B6B0088; Sat, 11 Jul 2026 14:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031E66B008A; Sat, 11 Jul 2026 14:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6B786B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:38:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 473521406E7
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:38:22 +0000 (UTC)
X-FDA: 84977356044.28.CA50A8B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf10.hostedemail.com (Postfix) with ESMTP id 65ACDC0006
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:38:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j0PUPmX+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783795100;
	b=paU/iiO+wI8r16DuTI6Y0WOkEB2e6lJL8YpPOAzVrakLni2x6nEc5ZX+emtQKXggFCs6CP
	QzrzGUHPJBcNPdaO2RGyWE64RLAc4L3HQ1Gq2r+G3WDl++SAIjdim5g9hSrjOl5VQfmT70
	gN6HmdFkuZfAuNwRxbfR19OXbHge4Oo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j0PUPmX+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783795100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=TGXaX1gzYl2V/yBDs7rZnUvCDXgjrQ+6AdaSBsVDLLY=;
	b=nF2sid/3TgGEB221vyk595kp3+I1on8TDdaiDCwOrRoEcFUL47LYStj57OesQxkwF5kXeL
	lmBK7/ISAGYO41B3Xc5pLg5k7Z/bi4EoJB4lLycZVktYKZ38e1e4VIf/cYdimHmyyjiw+H
	pWqz+pLUlgcZx7H/NgY90/5WQR/GpIQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783795099; x=1815331099;
  h=date:from:to:cc:subject:message-id;
  bh=J4Z0qoJBW+rTmSbmEb5N0u2fJsn4kMKe+TOpUHhBHZo=;
  b=j0PUPmX+fPB/B75lcHGZ4+6MDxTvdD6d322n9tSMFLUrAfjaS79iDOTg
   mBO4OB3PMEn/KLzGAdSGBqG9KpcolSRjrQPB21JMozYw3/gjDiwWwCPc7
   PFR8oV4Mbe3sbJSNtdurlmz6HjLNrzDCMEUDFP2bIBJvQfXm83VLhxMbE
   RDP70MCRhuslzT+mDPffEOdlUJIzujezhNhJVcAEOIiGuOd0ysfJ4ED5m
   Vzo6928waT905+xTHfjmggVJcSzELdafrMWPQBmxas7cEeTlfMAy9nRFr
   M2IGkJBr8HceUN9KT/AT5/CouDBWOHPDo6rVHPL5KGoxalG8b1vdwPVbN
   g==;
X-CSE-ConnectionGUID: S8EP8qqxSjGTB2sBQ+559g==
X-CSE-MsgGUID: UzSxW2TzSbOkTgPHaYWsQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="83449219"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="83449219"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2026 11:38:18 -0700
X-CSE-ConnectionGUID: e6434LUWTlC8w56V5hQkJw==
X-CSE-MsgGUID: cOV8WjgNTxSHLIC5ycjWJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="259475527"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 11 Jul 2026 11:38:16 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wicab-00000000KJV-2WDM;
	Sat, 11 Jul 2026 18:38:13 +0000
Date: Sun, 12 Jul 2026 02:37:07 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 61cccb8363fcc282d4ae0555b8739dd227f5ad0b
Message-ID: <202607120248.Sb8QeT4e-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 65ACDC0006
X-Rspam-User: 
X-Stat-Signature: ekefu9pa3dtp6ai8wtizg1xhz3osquit
X-Rspamd-Server: rspam03
X-HE-Tag: 1783795099-52688
X-HE-Meta: U2FsdGVkX18WjTbLr2tpuRwQsQy9FTRxRLin5hQDkBIHm57PSudzLnwl/nNWhwjpCZwEPRjitJaCuPIRx18bCCtc/IJs8E7iwls6ndKr09iPyOoSk1ic8C/qBN91oAHsQpCCZ36lvcHskV13JIA2Nyyvtt5zkLfPyLq+bxRy9W/Lu/Got2LsDZyVWjuUIYBCYESoH8dIm1i5RBF+9E4OxnpTrZGbFJCEQo+rOuR3aWEXfeEdxmXJJ4YXaSVy38/1bEwAge7gxI/0PvZVE5xNgEcXqcYZg0+X3ooGhGIHvIQjRfYdSgng22RApvtCbTQWpN6ftVcLzLIGwVMmZUL6TQy6V2bf5RCNoQlUZArHptWkM+nKp/1QsYg0jKrAwCD8b/e5ZDAhpdFMgteZU/k+kgJPS6GBpE3gh92t8+LsQCbx6oxiDoDeXGErIltogtZfCvEP/mQr9G1m6dSejrfizzQxhIxTMwfUSKjQQrkYbRQXdxYukcIoLyq9wL+kbUr2BnKHIE5Zsg5bdpOXL2Dr0cfVdScCO8fI6xKk98WRSnVt27KW/IGBXWBv+bblgM8ARMBc314Eo9Y0vBkykQ4BDo0ZnkWXpKonJ6ItCSoZ423wQeOODWXl2OkRwaq/SV5LOC8/QmcvsOshv8lKqhCXFQe7CGStu55vv7YU8pFEuD+u1HiwCqmG1fVTHudxorB+8lIOkZrz8aBUjR98xgGo3HHnllJ43mAer1Bijit/qdbpAK4DkHXsWngTHHXqzqcIBkyCKJ9wPDMQS8AsRaxx4L+pkI3y/tiXBVoI1zp/5HuH9fkV+z1F59z4tnSWxBVGP3gAOI2PlyYV/k6MmnHFAJ35Ie5pYj2fEFWiiPyMoeUMM6KvTBeQHuWEyiAJ0zVoEKQZdnIDmwLb4R7P3HqCB53AZSVbYWy3keRPi1nbLB+IxbGKsEADOhvNXOR5uOop09kdfJNNW6p6TzfhUCX
 UW9TC8L1
 lrEbcQ2Z1WbvPGpEUJ8+rXCBCEzxp/Kekj1uwiImYPZKMfrVHd5EDwjXnF00BJs2r7NjQgL9Z5177vwPHgeA6iCOa7Q2L6/ljMFsrU/GUlSXW8AEKf2FODHJ2IX5+o3bQ4LFljYx6K93pp7tduIXaxBvYEs92THvlzmyBLK5+rXyzBn4P1zaBWrH7kqm0+X2T1cGCUu8uv30yBwY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 61cccb8363fcc282d4ae0555b8739dd227f5ad0b  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 740m

configs tested: 312
configs skipped: 13

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
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260711    gcc-13.4.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260711    gcc-11.5.0
arc                   randconfig-002-20260711    gcc-13.4.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260711    gcc-11.5.0
arm                   randconfig-001-20260711    gcc-13.4.0
arm                            randconfig-002    gcc-15.2.0
arm                   randconfig-002-20260711    clang-17
arm                   randconfig-002-20260711    gcc-13.4.0
arm                            randconfig-003    clang-23
arm                   randconfig-003-20260711    gcc-13.4.0
arm                   randconfig-003-20260711    gcc-15.2.0
arm                            randconfig-004    gcc-13.4.0
arm                   randconfig-004-20260711    gcc-13.4.0
arm                         wpcm450_defconfig    gcc-16.1.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260711    gcc-16.1.0
arm64                 randconfig-001-20260711    gcc-8.5.0
arm64                 randconfig-002-20260711    clang-17
arm64                 randconfig-002-20260711    gcc-16.1.0
arm64                 randconfig-003-20260711    gcc-16.1.0
arm64                 randconfig-003-20260711    gcc-8.5.0
arm64                 randconfig-004-20260711    clang-17
arm64                 randconfig-004-20260711    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260711    gcc-16.1.0
csky                  randconfig-002-20260711    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260711    clang-17
hexagon               randconfig-001-20260711    gcc-16.1.0
hexagon               randconfig-002-20260711    clang-23
hexagon               randconfig-002-20260711    gcc-16.1.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260711    gcc-14
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260711    gcc-14
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260711    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260711    clang-22
i386        buildonly-randconfig-004-20260711    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260711    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260711    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260711    clang-22
i386                  randconfig-002-20260711    clang-22
i386                  randconfig-003-20260711    clang-22
i386                  randconfig-003-20260711    gcc-14
i386                  randconfig-004-20260711    clang-22
i386                  randconfig-004-20260711    gcc-12
i386                  randconfig-005-20260711    clang-22
i386                  randconfig-005-20260711    gcc-12
i386                  randconfig-006-20260711    clang-22
i386                  randconfig-006-20260711    gcc-14
i386                  randconfig-007-20260711    clang-22
i386                  randconfig-011-20260711    clang-22
i386                  randconfig-011-20260711    gcc-13
i386                  randconfig-012-20260711    gcc-13
i386                  randconfig-012-20260711    gcc-14
i386                  randconfig-013-20260711    gcc-13
i386                  randconfig-014-20260711    clang-22
i386                  randconfig-014-20260711    gcc-13
i386                  randconfig-015-20260711    clang-22
i386                  randconfig-015-20260711    gcc-13
i386                  randconfig-016-20260711    gcc-13
i386                  randconfig-016-20260711    gcc-14
i386                  randconfig-017-20260711    clang-22
i386                  randconfig-017-20260711    gcc-13
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260711    gcc-16.1.0
loongarch             randconfig-002-20260711    gcc-15.2.0
loongarch             randconfig-002-20260711    gcc-16.1.0
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
nios2                 randconfig-001-20260711    gcc-16.1.0
nios2                 randconfig-001-20260711    gcc-8.5.0
nios2                 randconfig-002-20260711    gcc-11.5.0
nios2                 randconfig-002-20260711    gcc-16.1.0
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
parisc                randconfig-001-20260711    clang-17
parisc                randconfig-001-20260711    gcc-12.5.0
parisc                         randconfig-002    clang-17
parisc                randconfig-002-20260711    clang-17
parisc                randconfig-002-20260711    gcc-10.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                     asp8347_defconfig    clang-23
powerpc                    mvme5100_defconfig    gcc-16.1.0
powerpc                        randconfig-001    clang-17
powerpc               randconfig-001-20260711    clang-17
powerpc               randconfig-001-20260711    gcc-11.5.0
powerpc                        randconfig-002    clang-17
powerpc               randconfig-002-20260711    clang-17
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260711    clang-17
powerpc64             randconfig-001-20260711    gcc-10.5.0
powerpc64                      randconfig-002    clang-17
powerpc64             randconfig-002-20260711    clang-17
powerpc64             randconfig-002-20260711    gcc-11.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    gcc-8.5.0
riscv                 randconfig-001-20260711    clang-17
riscv                 randconfig-001-20260711    gcc-8.5.0
riscv                          randconfig-002    gcc-8.5.0
riscv                 randconfig-002-20260711    gcc-8.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    gcc-8.5.0
s390                  randconfig-001-20260711    clang-19
s390                  randconfig-001-20260711    gcc-8.5.0
s390                           randconfig-002    gcc-8.5.0
s390                  randconfig-002-20260711    gcc-8.5.0
s390                       zfcpdump_defconfig    clang-22
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-8.5.0
sh                    randconfig-001-20260711    gcc-11.5.0
sh                    randconfig-001-20260711    gcc-8.5.0
sh                             randconfig-002    gcc-8.5.0
sh                    randconfig-002-20260711    gcc-8.5.0
sh                    randconfig-002-20260711    gcc-9.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260711    gcc-16.1.0
sparc                          randconfig-002    gcc-16.1.0
sparc                 randconfig-002-20260711    gcc-16.1.0
sparc                 randconfig-002-20260711    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-16.1.0
sparc64               randconfig-001-20260711    clang-23
sparc64               randconfig-001-20260711    gcc-16.1.0
sparc64                        randconfig-002    gcc-16.1.0
sparc64               randconfig-002-20260711    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-16.1.0
um                    randconfig-001-20260711    gcc-14
um                    randconfig-001-20260711    gcc-16.1.0
um                             randconfig-002    gcc-16.1.0
um                    randconfig-002-20260711    gcc-14
um                    randconfig-002-20260711    gcc-16.1.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-12
x86_64      buildonly-randconfig-001-20260711    gcc-14
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260711    gcc-12
x86_64      buildonly-randconfig-002-20260711    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260711    clang-22
x86_64      buildonly-randconfig-003-20260711    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260711    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260711    gcc-14
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260711    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                randconfig-001-20260711    clang-22
x86_64                         randconfig-002    clang-22
x86_64                randconfig-002-20260711    clang-22
x86_64                randconfig-002-20260711    gcc-14
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260711    clang-22
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260711    clang-22
x86_64                         randconfig-005    clang-22
x86_64                randconfig-005-20260711    clang-22
x86_64                randconfig-005-20260711    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260711    clang-22
x86_64                randconfig-006-20260711    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260711    clang-22
x86_64                randconfig-011-20260711    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260711    clang-22
x86_64                randconfig-012-20260711    gcc-14
x86_64                         randconfig-013    clang-22
x86_64                randconfig-013-20260711    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260711    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260711    gcc-14
x86_64                         randconfig-016    clang-22
x86_64                randconfig-016-20260711    clang-22
x86_64                randconfig-016-20260711    gcc-14
x86_64                randconfig-071-20260711    clang-22
x86_64                randconfig-071-20260711    gcc-14
x86_64                randconfig-072-20260711    gcc-14
x86_64                randconfig-073-20260711    clang-22
x86_64                randconfig-073-20260711    gcc-14
x86_64                randconfig-074-20260711    gcc-14
x86_64                randconfig-075-20260711    gcc-14
x86_64                randconfig-076-20260711    gcc-14
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
xtensa                randconfig-001-20260711    gcc-14.3.0
xtensa                randconfig-001-20260711    gcc-16.1.0
xtensa                         randconfig-002    gcc-16.1.0
xtensa                randconfig-002-20260711    gcc-16.1.0
xtensa                randconfig-002-20260711    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

