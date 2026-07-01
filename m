Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75957C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C1806B00AB; Wed,  1 Jul 2026 05:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598986B00AC; Wed,  1 Jul 2026 05:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487906B00AD; Wed,  1 Jul 2026 05:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1958D6B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:23:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 963CDA02C6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:23:24 +0000 (UTC)
X-FDA: 84939669528.06.6CCA989
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7A8C9100009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:23:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EKkd78N8;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782897802;
	b=PAQDNgG+RPfSYvx5GqwfcwsPCS0CPigG3y2UQr4RTgBKu219ocWt31ezI/j1j8Z4z1nfDR
	+9aMvnPjWSgAfeeCuBVUh5gMxWBH+t2JhWoVo7GPRh52TrTOneHib1bjHEkADaXlA18fDy
	AVoeiHAt+F53BuKfR72YkEeP5oCHcYs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782897802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=7ojrwqN3tceks7m1qXnw0B4MSsM+A6Lt5LNTaC8Xhrk=;
	b=40cmGsKRexQCOCVBkVbuaYnssdyc63DWGKMdxyTTXZaWhA68fXM65dgVJP4GuoE58VDvVd
	xQeTLo8cHsnZKY32U96+grp3NVGvfUDbK7uzwa0tsypmR/CTGwg1isly0esFOUNKDYbVLI
	zQIG1aw08IJUHmVLwKtZfUPB5H+5gBM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EKkd78N8;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782897800; x=1814433800;
  h=date:from:to:cc:subject:message-id;
  bh=oXTc7s8cH4jcWsSdUGGbceNkWlNx572Il6RYbkdnFUk=;
  b=EKkd78N8o+rpewwnfTlFhO6zKryCx8fKQcX9u2+66KQv+rPTIEmPQpjt
   POBVm+DlJQSmw+4I+n+FvOuxhg+rWZ1NX3k1L9EKsJVfpwCjUQIaDVKp1
   vNsn+QbOaGDCwBZ5u34g5/Mzktje99+WP6yhJoqmluv8+NSsPL/BmXUrQ
   DPms0k9iWARn2OTD8CxRYPDKE6KfLDVE3FL/pgoqneWcHEdRHhyYtWI/5
   AJsFxpWRXxH13+YDcVhwmjf3re88NkOdyf+vMFBnUPyKWJlS53r3bnSda
   BEPbMg0AvZ8x9Xe87MmGyeLCJ8BZBpeHZTNH6xQYO3I07W85iBm8ZO4Ei
   Q==;
X-CSE-ConnectionGUID: icHnfXAzRj6V3eGNEY3/Pw==
X-CSE-MsgGUID: oMsb1uniQpS7qfQLchyppw==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="83498009"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="83498009"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 02:23:18 -0700
X-CSE-ConnectionGUID: C80Ity+TQnKG6ywx67HIUA==
X-CSE-MsgGUID: mO6BT4+SSKusJYco8gkaiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="254432579"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 01 Jul 2026 02:23:18 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wer9z-0000000098J-1sQz;
	Wed, 01 Jul 2026 09:23:11 +0000
Date: Wed, 01 Jul 2026 17:13:47 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:kernelcore-mirror] BUILD SUCCESS
 7783dcd79ae9c4aa48bc47bd4275772445dc4b2a
Message-ID: <202607011736.xg6Bf9wn-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: ikjfgbjbu7e9mhgajm7guj81jbn4hwh4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A8C9100009
X-HE-Tag: 1782897801-356233
X-HE-Meta: U2FsdGVkX1+qRzwtteesHUxiJzBJ39/5qqXl94h++OBNlIhzAXF2pmdsHiVCaoQrXx2OQwgoA0QzvZlAincRVlOfIOXMlUqYzZPY6+uOihHqe/eBoeBCo5tnI57fbwIS852xNITwMzM/htMu8WBR6RzOW/6qb1UjTsA61Dwvn4ZHGNekpc/nMnjImiM5IEO5vFv/lblVs2sn9uy/j6HW+5g2d6dqcShs0FrJ1Fg7tIsLUIRKYEfegc8UYL0ByoCe0Lxh6n7oPTm5l53U0ZbIk+HC4DIJb9S3piXdwIan10drW4Tdh2NcpUlF6hH9/5UMBvzZMfKO8Dk6M5D2NNUEdyACR3O6xzsMPkL0QubuCVdsHGyW2597PI3c7bIN8WRbOKdlsT7Edu5+i1A+vU6VbCuHaYFjlVV0w/k3Glsb31yLAi7qOp4sa2C8yy280zy4cZDxk0+Hx5BKoKPAPsoVjil51UeIdAradK+AfDeXyfLfAny3amJKyX78wBy/RzxLGrogzZDZBFTrJ0/28E5C9e/uMdF1dMB65bhwGS3EDLmn2zuLRYTx/XIHln8gA3zypjDTLB0H5PaaebSk7DEpYc9gXt8bUuui3bvLCdG0bMqs5FrvxQOgaCXCFrUcQR36e8lqp2cOWVrAzvIEnBt7QCeQS35anniuvhX0V7hpiyUHCmsZseCtFYif/fBVZyqJwskD75GfzJAgJ0VY7mzEHnmrmZ47oC1Mb+AElQM5FFirk1KZhuLKEThGOlhHySFbqAdFRVhzJdKqr2HfvOuPIA55TJqY7ppABFCb9+KKcyUKBS5zg8fnNrCFh+5oFzCLcbvwyE5aDymkoDdF9IJpImoXV4Fhls0AzXkLcK8XHMAvPr6PikO0evLjaGQrIS1yjDbWZ47aA06auJQmeKGo5xwoMatF4rLY132vNiCEb+RfUVb3hLF1RHvrq+I2crt22qfD1hp7UTbwmPDH/ym
 RSZ2akSB
 C72B4bSJwPW747PJyKJN4JCjKvkKHKcWxMK0fJtwpem8RKqg4+nE+N6PgCmNkw56x0Yron++QZbvVDILP8K0DIdVjoqg71wXGlGUz+ZL6ddlz0P3f6zvqFjG9+K9RYO76iCeeI2byue0Hu6xLXaAffrayPvKNPqqC4UnyTyZLyg6VOPSbP7BO/VY5LuV7lHhRahB8oOrOi8BSznY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git kernelcore-mirror
branch HEAD: 7783dcd79ae9c4aa48bc47bd4275772445dc4b2a  mm/mm_init: fix incorrect node_spanned_pages

elapsed time: 750m

configs tested: 238
configs skipped: 2

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
arc                   randconfig-001-20260701    gcc-12.5.0
arc                   randconfig-002-20260701    gcc-12.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260701    gcc-12.5.0
arm                   randconfig-002-20260701    gcc-12.5.0
arm                   randconfig-003-20260701    gcc-12.5.0
arm                   randconfig-004-20260701    gcc-12.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260701    gcc-12.5.0
arm64                 randconfig-002-20260701    gcc-12.5.0
arm64                 randconfig-003-20260701    gcc-12.5.0
arm64                 randconfig-004-20260701    gcc-12.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260701    gcc-12.5.0
csky                  randconfig-002-20260701    gcc-12.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260701    clang-23
hexagon               randconfig-001-20260701    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260701    clang-23
hexagon               randconfig-002-20260701    gcc-11.5.0
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386        buildonly-randconfig-001-20260701    clang-22
i386        buildonly-randconfig-002-20260701    clang-22
i386        buildonly-randconfig-003-20260701    clang-22
i386        buildonly-randconfig-004-20260701    clang-22
i386        buildonly-randconfig-005-20260701    clang-22
i386        buildonly-randconfig-006-20260701    clang-22
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260701    clang-22
i386                           randconfig-002    clang-22
i386                  randconfig-002-20260701    clang-22
i386                           randconfig-003    clang-22
i386                  randconfig-003-20260701    clang-22
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260701    clang-22
i386                           randconfig-005    clang-22
i386                  randconfig-005-20260701    clang-22
i386                           randconfig-006    clang-22
i386                  randconfig-006-20260701    clang-22
i386                           randconfig-007    clang-22
i386                  randconfig-007-20260701    clang-22
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260701    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260701    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260701    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260701    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260701    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260701    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260701    gcc-14
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                loongson32_defconfig    clang-18
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260701    clang-23
loongarch             randconfig-001-20260701    gcc-11.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260701    clang-23
loongarch             randconfig-002-20260701    gcc-11.5.0
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
mips                         db1xxx_defconfig    clang-23
mips                            gpr_defconfig    clang-23
mips                          rb532_defconfig    clang-23
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-23
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260701    clang-23
nios2                 randconfig-001-20260701    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260701    clang-23
nios2                 randconfig-002-20260701    gcc-11.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260701    clang-17
parisc                randconfig-002-20260701    clang-17
parisc64                            defconfig    clang-23
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                     asp8347_defconfig    clang-23
powerpc               randconfig-001-20260701    clang-17
powerpc               randconfig-002-20260701    clang-17
powerpc64             randconfig-001-20260701    clang-17
powerpc64             randconfig-002-20260701    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-23
riscv                 randconfig-001-20260701    clang-23
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260701    clang-23
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-23
s390                  randconfig-001-20260701    clang-23
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260701    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-17
sh                                  defconfig    gcc-14
sh                             randconfig-001    clang-23
sh                    randconfig-001-20260701    clang-23
sh                             randconfig-002    clang-23
sh                    randconfig-002-20260701    clang-23
sh                           se7206_defconfig    gcc-16.1.0
sh                   secureedge5410_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-13.4.0
sparc                 randconfig-001-20260701    gcc-13.4.0
sparc                          randconfig-002    gcc-13.4.0
sparc                 randconfig-002-20260701    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-13.4.0
sparc64               randconfig-001-20260701    gcc-13.4.0
sparc64                        randconfig-002    gcc-13.4.0
sparc64               randconfig-002-20260701    gcc-13.4.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-13.4.0
um                    randconfig-001-20260701    gcc-13.4.0
um                             randconfig-002    gcc-13.4.0
um                    randconfig-002-20260701    gcc-13.4.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    clang-22
x86_64      buildonly-randconfig-001-20260701    clang-22
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260701    clang-22
x86_64               buildonly-randconfig-003    clang-22
x86_64      buildonly-randconfig-003-20260701    clang-22
x86_64               buildonly-randconfig-004    clang-22
x86_64      buildonly-randconfig-004-20260701    clang-22
x86_64               buildonly-randconfig-005    clang-22
x86_64      buildonly-randconfig-005-20260701    clang-22
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260701    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260701    gcc-14
x86_64                randconfig-002-20260701    gcc-14
x86_64                randconfig-003-20260701    gcc-14
x86_64                randconfig-004-20260701    gcc-14
x86_64                randconfig-005-20260701    gcc-14
x86_64                randconfig-006-20260701    gcc-14
x86_64                randconfig-011-20260701    gcc-14
x86_64                randconfig-012-20260701    gcc-14
x86_64                randconfig-013-20260701    gcc-14
x86_64                randconfig-014-20260701    gcc-14
x86_64                randconfig-015-20260701    gcc-14
x86_64                randconfig-016-20260701    gcc-14
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260701    gcc-14
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260701    gcc-14
x86_64                         randconfig-073    gcc-14
x86_64                randconfig-073-20260701    gcc-14
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260701    gcc-14
x86_64                         randconfig-075    gcc-14
x86_64                randconfig-075-20260701    gcc-14
x86_64                         randconfig-076    gcc-14
x86_64                randconfig-076-20260701    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                         randconfig-001    gcc-13.4.0
xtensa                randconfig-001-20260701    gcc-13.4.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                randconfig-002-20260701    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

