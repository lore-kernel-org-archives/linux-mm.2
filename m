Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A08C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 19:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1736B00A8; Wed,  1 Jul 2026 15:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872A46B00A9; Wed,  1 Jul 2026 15:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763986B00AB; Wed,  1 Jul 2026 15:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF1C6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:34:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0199168573
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:34:18 +0000 (UTC)
X-FDA: 84941208996.06.10924ED
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf03.hostedemail.com (Postfix) with ESMTP id 098B120011
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:34:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dwk5L0xU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782934456;
	b=mGzgSHFifsQg6zYGrtPCJ9r6wbYusEX4VUTOCC2sKihfpbAjKWhR+hMphGVjp2gTcleAD7
	BqKoReAe3yTIdnlAnQC1dZYEEEm5myGyr3oDETxbuw2eUhgGd4Wtk2HibDvnDdThjpRgic
	rXFMtq/cV03yvwPo/LkDUaozIEhYdoc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782934456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=x3+I+coIQny/osRZblRUZdYj8JrqBEt60hy9nY8gCUg=;
	b=OCVQTF72GqRoNr9tUmEaB29VPaRlYBlGetKA4k0JJJKr4zRrzc5XOwqurtE8uZSI9uHEbA
	ifwK8BVhwLXfAaMj03JU9QZO+8kai/EAkjGbYiZtn+FwasayUKMKneYtoOeG+L0l645xVC
	jPKdCbUkEuzoko/hnvllpS1OetzYiDc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dwk5L0xU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782934456; x=1814470456;
  h=date:from:to:cc:subject:message-id;
  bh=xbqDp0XN+gMQ5BKfMQX92sRSi+F1YXzvvdCrWtXduEc=;
  b=Dwk5L0xU74jiVUPkkmgzuyrWUAZz/+LGK59Qa04NpwIlTOhGxZxkS5vq
   NVHSk8aPNORkTL6hZtt5L7QEoQeLupUVXEBYbTS3dvV75D4rM0dEd7tHs
   c7T87PAHIUhdIqEp2Q+fdgiegbeh32BXJVKHhMshtCq18ua6piQxq//t7
   A1vb9UsmqDZtFCG/XsnD/0iMq2hawLzk54BBK7MA/+IdPeISvslSBH85B
   ecI7TFBJLVC+CpBMBpfdmeIRBtG1orljVsrajXfb5oauRzU5RmhDmQh2B
   YGzj5KucVIAd1NFOKImdKCpLIY6lLI4r8euJNRn2h+cuuIdXPz/4wptRk
   A==;
X-CSE-ConnectionGUID: BtJt4LSwTPeN4m0VpD8f+w==
X-CSE-MsgGUID: fvdvtP55RQO6oZocBSkd4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="83766043"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="83766043"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 12:34:14 -0700
X-CSE-ConnectionGUID: oaX4V9tfTH62j7ztRSAwfQ==
X-CSE-MsgGUID: V4gLh8ukTAmUmM1MXE5VMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="256237997"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 01 Jul 2026 12:34:13 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wf0hG-000000009ZP-0F41;
	Wed, 01 Jul 2026 19:34:10 +0000
Date: Thu, 02 Jul 2026 03:33:13 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 f5ea2fbe68e0c9192c0c82ece4645beeace63345
Message-ID: <202607020359.FMDmPwjF-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 098B120011
X-Rspam-User: 
X-Stat-Signature: 5w159wiw994ytcahp58wayotm6mmc61w
X-HE-Tag: 1782934455-169055
X-HE-Meta: U2FsdGVkX1++axXEb+Wdnj0VMsbj19p/sjex0jwqzazU7pwaMKFU+43U+UOtTl1En5EDmfFDgJfQUHcoHl6HsAMFWHvbSLQX5oTBWrQPVAwLR/5mfqjD0G+9tCiUo6jGy5tvGXFAlBPwyMzQ3/N3Xdd6OZDp5NRF1ENxNpKwb6Mc9/xI4NawDVNGp5+uI6GzjZFXsNiEBT5VMhlvWlh0SfXsvJ9OZSHYm9SoEF3CguIelL+a7xgYDUAarvigY570gOTGo3nLu8arGp8DH2iCfAB37Fy846pLdM25g0p5YpgYUrY2blt7aq2DnHzM99BYaLhdUl+jxV1gmeEJcbMQzXjnxY9dFYrk+4tXPtN4uN0yZAlABZeQ1t6V0MZqpmqvKQqKypx3XUEpt7J+la91rsnnhD7C5V5HV2XV4c1yp82qe4OrUZ/2zv1AS7G20G5daCILe6gUEIPbvUyIoOXDNP3xYdORzcqvJx7o3ZtZfW1fPQc0u2T4VnoXM4YQHaJBEKgHSCClcP/nWrZtaPuKxNyeIC/uF13wnqRpXNWgNB5+v+E961mY5pWp55MPPPuU17PVF9OLWqZh/rePOJ6R5QGFKI+2fS5iooz4zrdcYYZ5cZz74SRcpnbH1srHHEcanlgoS5K1/ql+SSUjwSuotS0j3kztjMulebFXp2g2BtgI+MihMl4W5b+2ibGfh4Mv6TTGvZB1204iowRWMz5bOf6UlI3w5uQMt9mIYvlKFpADttIb2o4bhwVPFPsNWq9MsnC88olBOXcN+o4Q1wS2oVmY4aNAdHXAHjr3BncvCvDA9Yr7D6kGeoaR//2LIHblCzHxC1uhMckNhnGRkkylLojIenNOTKZturx0GrrdEqf07nLCFvsd9fAXmpPXSVA2UrwuMmJH1mMBVriP/7xrVnzhbsgXiNvcHpwqFdq4jf4HKRPOpRygMNXBBKaUpdfxQO7pDHaT+qXQridj2el
 m9Qn/c/x
 /XpsnxjrgFCQFzM5yeSsSC5+KFQOfwbPRqscq101bXxCwMMtMpv/hOr9f5ryfS0JpjVLcLN3ShyBddxpyU1LFfvbnCeqBm485pQqNcOVw9EWPNU7pnoyxeon/zKX3AUHMT1K0A8mZ3m0xwxP8jc1C0y4u+HGV3rvkrZ4qeZKuIMa+UfUcGfXdmPVJ9/WVV/5JZmtq4MO8NRVddpQUOLVJJyJSgn8JgiasqJYU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: f5ea2fbe68e0c9192c0c82ece4645beeace63345  mm/swap, PM: hibernate: atomically replace hibernation pin

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com

    mm/zsmalloc.c:1480:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-002-20260701
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- arc-randconfig-r123-20260701
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- i386-randconfig-003-20260701
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- m68k-defconfig
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- powerpc-randconfig-001
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
`-- um-randconfig-001-20260701
    `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used

elapsed time: 779m

configs tested: 322
configs skipped: 16

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
arc                   randconfig-001-20260701    gcc-12.5.0
arc                   randconfig-001-20260701    gcc-16.1.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260701    gcc-12.5.0
arc                   randconfig-002-20260701    gcc-16.1.0
arc                   randconfig-002-20260701    gcc-8.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260701    gcc-10.5.0
arm                   randconfig-001-20260701    gcc-12.5.0
arm                   randconfig-001-20260701    gcc-16.1.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260701    clang-17
arm                   randconfig-002-20260701    gcc-12.5.0
arm                   randconfig-002-20260701    gcc-16.1.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260701    gcc-10.5.0
arm                   randconfig-003-20260701    gcc-12.5.0
arm                   randconfig-003-20260701    gcc-16.1.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260701    clang-23
arm                   randconfig-004-20260701    gcc-12.5.0
arm                   randconfig-004-20260701    gcc-16.1.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260701    gcc-12.5.0
arm64                 randconfig-001-20260701    gcc-16.1.0
arm64                 randconfig-002-20260701    clang-17
arm64                 randconfig-002-20260701    gcc-12.5.0
arm64                 randconfig-003-20260701    gcc-12.5.0
arm64                 randconfig-004-20260701    clang-17
arm64                 randconfig-004-20260701    gcc-12.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260701    gcc-10.5.0
csky                  randconfig-001-20260701    gcc-12.5.0
csky                  randconfig-002-20260701    gcc-12.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260701    clang-23
hexagon               randconfig-001-20260701    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260701    clang-17
hexagon               randconfig-002-20260701    clang-23
hexagon               randconfig-002-20260701    gcc-11.5.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260701    clang-22
i386        buildonly-randconfig-002-20260701    clang-22
i386        buildonly-randconfig-003-20260701    clang-22
i386        buildonly-randconfig-003-20260701    gcc-14
i386        buildonly-randconfig-004-20260701    clang-22
i386        buildonly-randconfig-004-20260701    gcc-13
i386        buildonly-randconfig-005-20260701    clang-22
i386        buildonly-randconfig-006-20260701    clang-22
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260701    clang-22
i386                           randconfig-002    clang-22
i386                  randconfig-002-20260701    clang-22
i386                           randconfig-003    clang-22
i386                  randconfig-003-20260701    clang-22
i386                  randconfig-003-20260701    gcc-14
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260701    clang-22
i386                           randconfig-005    clang-22
i386                  randconfig-005-20260701    clang-22
i386                           randconfig-006    clang-22
i386                  randconfig-006-20260701    clang-22
i386                           randconfig-007    clang-22
i386                  randconfig-007-20260701    clang-22
i386                  randconfig-011-20260701    gcc-14
i386                  randconfig-012-20260701    gcc-12
i386                  randconfig-012-20260701    gcc-14
i386                  randconfig-013-20260701    clang-22
i386                  randconfig-013-20260701    gcc-14
i386                  randconfig-014-20260701    gcc-14
i386                  randconfig-015-20260701    clang-22
i386                  randconfig-015-20260701    gcc-14
i386                  randconfig-016-20260701    clang-22
i386                  randconfig-016-20260701    gcc-14
i386                  randconfig-017-20260701    clang-22
i386                  randconfig-017-20260701    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260701    clang-23
loongarch             randconfig-001-20260701    gcc-11.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260701    clang-19
loongarch             randconfig-002-20260701    clang-23
loongarch             randconfig-002-20260701    gcc-11.5.0
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
nios2                         3c120_defconfig    gcc-11.5.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260701    clang-23
nios2                 randconfig-001-20260701    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260701    clang-23
nios2                 randconfig-002-20260701    gcc-11.5.0
nios2                 randconfig-002-20260701    gcc-8.5.0
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
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260701    clang-17
parisc                randconfig-001-20260701    gcc-13.4.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260701    clang-17
parisc                randconfig-002-20260701    gcc-15.2.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260701    clang-17
powerpc               randconfig-001-20260701    gcc-8.5.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260701    clang-17
powerpc               randconfig-002-20260701    clang-23
powerpc                     redwood_defconfig    clang-23
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260701    clang-17
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260701    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    gcc-13.4.0
riscv                 randconfig-001-20260701    clang-17
riscv                 randconfig-001-20260701    clang-23
riscv                          randconfig-002    clang-17
riscv                 randconfig-002-20260701    clang-23
riscv                 randconfig-002-20260701    gcc-14.3.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    gcc-15.2.0
s390                  randconfig-001-20260701    clang-23
s390                           randconfig-002    clang-18
s390                  randconfig-002-20260701    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-14.3.0
sh                    randconfig-001-20260701    clang-23
sh                    randconfig-001-20260701    gcc-10.5.0
sh                             randconfig-002    gcc-9.5.0
sh                    randconfig-002-20260701    clang-23
sh                    randconfig-002-20260701    gcc-16.1.0
sh                           se7750_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260701    gcc-13.4.0
sparc                 randconfig-001-20260701    gcc-8.5.0
sparc                 randconfig-002-20260701    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260701    gcc-13.4.0
sparc64               randconfig-001-20260701    gcc-8.5.0
sparc64               randconfig-002-20260701    gcc-13.4.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260701    gcc-13.4.0
um                    randconfig-001-20260701    gcc-14
um                    randconfig-002-20260701    clang-23
um                    randconfig-002-20260701    gcc-13.4.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    clang-22
x86_64      buildonly-randconfig-001-20260701    clang-22
x86_64      buildonly-randconfig-001-20260701    gcc-14
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260701    clang-22
x86_64               buildonly-randconfig-003    clang-22
x86_64      buildonly-randconfig-003-20260701    clang-22
x86_64               buildonly-randconfig-004    clang-22
x86_64      buildonly-randconfig-004-20260701    clang-22
x86_64      buildonly-randconfig-004-20260701    gcc-14
x86_64               buildonly-randconfig-005    clang-22
x86_64      buildonly-randconfig-005-20260701    clang-22
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260701    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                randconfig-001-20260701    clang-22
x86_64                         randconfig-002    clang-22
x86_64                randconfig-002-20260701    clang-22
x86_64                randconfig-002-20260701    gcc-14
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260701    clang-22
x86_64                randconfig-003-20260701    gcc-14
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260701    clang-22
x86_64                         randconfig-005    clang-22
x86_64                randconfig-005-20260701    clang-22
x86_64                randconfig-005-20260701    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260701    clang-22
x86_64                randconfig-006-20260701    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260701    clang-22
x86_64                randconfig-011-20260701    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260701    clang-22
x86_64                randconfig-012-20260701    gcc-14
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260701    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260701    clang-22
x86_64                randconfig-014-20260701    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260701    clang-22
x86_64                randconfig-015-20260701    gcc-14
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260701    clang-22
x86_64                randconfig-016-20260701    gcc-14
x86_64                randconfig-071-20260701    clang-22
x86_64                randconfig-071-20260701    gcc-14
x86_64                randconfig-072-20260701    gcc-13
x86_64                randconfig-072-20260701    gcc-14
x86_64                randconfig-073-20260701    clang-22
x86_64                randconfig-073-20260701    gcc-14
x86_64                randconfig-074-20260701    clang-22
x86_64                randconfig-074-20260701    gcc-14
x86_64                randconfig-075-20260701    gcc-14
x86_64                randconfig-076-20260701    clang-22
x86_64                randconfig-076-20260701    gcc-14
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
xtensa                randconfig-001-20260701    gcc-13.4.0
xtensa                randconfig-001-20260701    gcc-8.5.0
xtensa                randconfig-002-20260701    gcc-13.4.0
xtensa                randconfig-002-20260701    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

