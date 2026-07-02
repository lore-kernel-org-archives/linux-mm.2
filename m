Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E17C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1896B010C; Thu,  2 Jul 2026 20:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838806B0115; Thu,  2 Jul 2026 20:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4496B0118; Thu,  2 Jul 2026 20:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F87F6B010C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:58:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E19B40155
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:32:21 +0000 (UTC)
X-FDA: 84944228082.23.F215227
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6DF6D40002
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:32:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=caK0ekhq;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783006339;
	b=uNCyyJSG9hcW9ACTRwfTOJjFzWQyxsrCuToDCdIhfkpQjnGffErPpUUJBn0czj/R0wPf4b
	dniKzLT/JM8HoqrC0llPAF+CQFBBwPcSA8ZdSrR57+JDFfWcQLn6pihjuM8DNXGqBq+BgT
	f8xohC4LJe7MKxS95fL1nll0usPe/nU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783006339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=sqVMmLOVmRLOkNiVvKy2oXk1Yz8Y2EGUn1XoeVRzf6s=;
	b=eNkiz5Nc682eEqeMwoK0qTgQFzh9oD9IEOeikEst0tMQLYZQmlCuxZxDxaYJ5aOB0JY0U7
	8olRNfs0bG8Wv3s662e+8XLwsxcMWnWPWxcnrkJDJPqyLusqJ2XQ0CizN1ZxVXzUTtBcG8
	w9IQfmRGYriXNpu8vEsk2rS1aPxY+gQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=caK0ekhq;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783006338; x=1814542338;
  h=date:from:to:cc:subject:message-id;
  bh=FzMKNRTeO+O41k+fVNRFgURIjMdoyCzap3BQpGqIkVI=;
  b=caK0ekhqN5phI9PjyJcagkthUGwy+aiAjuHWjNUbkf4GwTIT8f/N7jme
   wfkDMihPlnEnc67Bwe1ZwP2KvOUfCxKxTuSpiuhoK5boPbF0tXpZlimZi
   tAWBdqnB1sGqMiFbANtO2SCepGu7+A2QchYxSW2WJGlIBRL75ceWx2xSP
   0j9y7eZZHM9bVwybf+9hFKKoJd+Jh6o8OhdL3kc1HlMv3HLCWur7zZZIR
   IUYusee/MhR3SMcedkv5rpjZV2vWE86Ye5haeKURQbPTKDNjA3B2NgdgU
   uKNdCJcUdz36h92CVnGFur6Q/J2pXbtUAZEn90UYNeKNGzU6GcPDPCBHk
   Q==;
X-CSE-ConnectionGUID: 87m6gMh+TxyaCCHZbzYokQ==
X-CSE-MsgGUID: EQzTQKEDSF+3je/RD6Ewvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="95268746"
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="95268746"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 08:32:16 -0700
X-CSE-ConnectionGUID: j1SAfSh2RQCW/JqBt9iGlQ==
X-CSE-MsgGUID: P4OqRXb+SEeisYI6AVYBBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="248912358"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2026 08:32:13 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfJOd-00000000Auh-0luO;
	Thu, 02 Jul 2026 15:32:11 +0000
Date: Thu, 02 Jul 2026 23:31:59 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 f4b4fac1867633ac17c35842f03933f6a7a4425f
Message-ID: <202607022346.lOHuTDpa-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6DF6D40002
X-Stat-Signature: bp66g1t1d89x6fsi9hhmdsdkd5xzgdq5
X-HE-Tag: 1783006338-498047
X-HE-Meta: U2FsdGVkX19EgYuG1xFeAiTuRRi5SjB57YqY/Ck4vdESea3hC24x2p8llIZnjE6N09B2uHqdQYf8LoQUC77uS/m2wyhw1vr4iUdkhdfIA5oAfzr3ncVY7ipZWQ2Llf7LUHy3PhPR58yqYxsluEE+FP846EY4m+R6xuhuZiL7WLFhDqDmFwSh292eOnHGnsVwr76Le9RW1u9rNxyHEDxXI914Ufd1U7i3/aAbfYirhV4KxxR5n0U5DSn7kUT/p/MdLQKxQ9FH8ExJWnzR2Sw982Mauh7kwXSRZrc9lZhrxuWQG8JM146LLvwPdLLufuHZCkotIdnWN3XytlHkVjpAGs/eOFYaTJW8GsXgl31vdzgx3QSFoEjy0geR25rxYU9he2YEWkSvJO+WzgyXPkSggJ6Ft1iYCcGp8UhAh5U2DUuwkfcibRWCcvvxvQaCbHF70WjQTbvmpbJrFW37GL4LHBU8o0pGVz6LZr0nHz4QiGYG1iF9SXuXrTUppGDdaxLtG8IsWsMFjYlJlaUjZYbkFlu6iTD9nYSqt7aRKvAg4Yu3nFF14fpEg5M53bOo2wA0MEebKIC8Srkw718bdL+Tgi9BWCrAmObOr6X/EURoFbmkN4mHcyNCOO0cKz4sTy99O3h02iDcTfjK8z8DpVVCuvhZfuRlkGt9WuE+bdDxFgDRdKQu1yA7fBZW6MIsCvlvQRclJq1kzpfn0Lh5+Xb1Gmaat3TrRsmH/qxwPXJDbhEjfS0vSSdp4E2lTROpEZZSruuYftq/5u7vEd50PDXM7Iw086+puiZ1040IEjgY5708VxBwLAqKII8VQ/IMGZK8wlDeqrxtZlA5kNxaOo5njdeHivq/V+izff4Q7tupGNlHR3xsFShR4tglGzJn2LWXD5NHZMcUgbiQfGcMq8+i5iMv4WFboP3ltEyAUIf0ejUiGsd57Rvt1pKUoiTamigh0B03lSlI/hjCoJ8Pbbp
 Ui7wiM92
 s7NPCjnTolad8CsESLH0jNiZ2iNHUGdHSas9gLN88k0i6Y5WBVTNBLTYCA1u8sahIc2oSlD8xiCCl/8/raZTRXjIf9+nQ0kHSVCxmVKg+f51rOlRYhOCcUy3kQY9o4eNFp5LwcOh6RWEZBVG8/V/Zdl8Hd73kXMswLPqmLqtmF5duBmzbkbdOWj9XTIJGqCHRUe2kroLfj3/K3RUeyshCJXuM7y5VmEQTqgts
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: f4b4fac1867633ac17c35842f03933f6a7a4425f  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com

    mm/vmpressure.c:254 vmpressure() warn: check likely/unlikely parentheses

Warning ids grouped by kconfigs:

recent_errors
`-- microblaze-randconfig-r071-20260702
    `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses

elapsed time: 744m

configs tested: 316
configs skipped: 12

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
arc                   randconfig-001-20260702    gcc-8.5.0
arc                   randconfig-002-20260702    gcc-13.4.0
arc                   randconfig-002-20260702    gcc-8.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260702    clang-17
arm                   randconfig-001-20260702    gcc-8.5.0
arm                   randconfig-002-20260702    gcc-15.2.0
arm                   randconfig-002-20260702    gcc-8.5.0
arm                   randconfig-003-20260702    gcc-10.5.0
arm                   randconfig-003-20260702    gcc-8.5.0
arm                   randconfig-004-20260702    gcc-8.5.0
arm                        spear6xx_defconfig    clang-23
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260702    clang-22
arm64                 randconfig-001-20260702    gcc-15.2.0
arm64                 randconfig-002-20260702    gcc-15.2.0
arm64                 randconfig-002-20260702    gcc-8.5.0
arm64                 randconfig-003-20260702    gcc-15.2.0
arm64                 randconfig-004-20260702    clang-17
arm64                 randconfig-004-20260702    gcc-15.2.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260702    gcc-15.2.0
csky                  randconfig-001-20260702    gcc-9.5.0
csky                  randconfig-002-20260702    gcc-15.2.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260702    clang-19
hexagon               randconfig-001-20260702    clang-23
hexagon               randconfig-001-20260702    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260702    clang-20
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
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260702    clang-22
i386                  randconfig-001-20260702    gcc-14
i386                  randconfig-002-20260702    clang-22
i386                  randconfig-002-20260702    gcc-14
i386                  randconfig-003-20260702    gcc-14
i386                  randconfig-004-20260702    clang-22
i386                  randconfig-004-20260702    gcc-14
i386                  randconfig-005-20260702    gcc-14
i386                  randconfig-006-20260702    gcc-14
i386                  randconfig-007-20260702    gcc-14
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260702    clang-22
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260702    clang-22
i386                  randconfig-012-20260702    gcc-13
i386                           randconfig-013    clang-22
i386                  randconfig-013-20260702    clang-22
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260702    clang-22
i386                           randconfig-015    clang-22
i386                  randconfig-015-20260702    clang-22
i386                           randconfig-016    clang-22
i386                  randconfig-016-20260702    clang-22
i386                  randconfig-016-20260702    gcc-14
i386                           randconfig-017    clang-22
i386                  randconfig-017-20260702    clang-22
i386                  randconfig-017-20260702    gcc-14
loongarch                        allmodconfig    clang-19
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
loongarch             randconfig-002-20260702    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
m68k                       m5329evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
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
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260702    clang-23
nios2                 randconfig-001-20260702    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260702    clang-23
nios2                 randconfig-002-20260702    gcc-11.5.0
nios2                 randconfig-002-20260702    gcc-8.5.0
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
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    clang-17
powerpc               randconfig-001-20260702    clang-17
powerpc                        randconfig-002    clang-17
powerpc               randconfig-002-20260702    clang-17
powerpc               randconfig-002-20260702    gcc-8.5.0
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260702    clang-17
powerpc64             randconfig-001-20260702    gcc-15.2.0
powerpc64                      randconfig-002    clang-17
powerpc64             randconfig-002-20260702    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    gcc-12.5.0
riscv                 randconfig-001-20260702    gcc-12.5.0
riscv                 randconfig-001-20260702    gcc-15.2.0
riscv                          randconfig-002    gcc-12.5.0
riscv                 randconfig-002-20260702    clang-23
riscv                 randconfig-002-20260702    gcc-12.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    gcc-12.5.0
s390                  randconfig-001-20260702    clang-23
s390                  randconfig-001-20260702    gcc-12.5.0
s390                           randconfig-002    gcc-12.5.0
s390                  randconfig-002-20260702    gcc-12.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-12.5.0
sh                    randconfig-001-20260702    gcc-12.5.0
sh                    randconfig-001-20260702    gcc-16.1.0
sh                             randconfig-002    gcc-12.5.0
sh                    randconfig-002-20260702    gcc-12.5.0
sh                    randconfig-002-20260702    gcc-15.2.0
sh                           se7619_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260702    gcc-16.1.0
sparc                          randconfig-002    gcc-16.1.0
sparc                 randconfig-002-20260702    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-16.1.0
sparc64               randconfig-001-20260702    clang-23
sparc64               randconfig-001-20260702    gcc-16.1.0
sparc64                        randconfig-002    gcc-16.1.0
sparc64               randconfig-002-20260702    gcc-10.5.0
sparc64               randconfig-002-20260702    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-16.1.0
um                    randconfig-001-20260702    gcc-14
um                    randconfig-001-20260702    gcc-16.1.0
um                             randconfig-002    gcc-16.1.0
um                    randconfig-002-20260702    gcc-14
um                    randconfig-002-20260702    gcc-16.1.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    clang-22
x86_64      buildonly-randconfig-001-20260702    clang-22
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260702    clang-22
x86_64      buildonly-randconfig-002-20260702    gcc-14
x86_64               buildonly-randconfig-003    clang-22
x86_64      buildonly-randconfig-003-20260702    clang-22
x86_64               buildonly-randconfig-004    clang-22
x86_64      buildonly-randconfig-004-20260702    clang-22
x86_64               buildonly-randconfig-005    clang-22
x86_64      buildonly-randconfig-005-20260702    clang-22
x86_64      buildonly-randconfig-005-20260702    gcc-14
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260702    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260702    clang-22
x86_64                randconfig-002-20260702    clang-22
x86_64                randconfig-002-20260702    gcc-14
x86_64                randconfig-003-20260702    clang-22
x86_64                randconfig-004-20260702    clang-22
x86_64                randconfig-004-20260702    gcc-14
x86_64                randconfig-005-20260702    clang-22
x86_64                randconfig-006-20260702    clang-22
x86_64                randconfig-006-20260702    gcc-14
x86_64                randconfig-011-20260702    clang-22
x86_64                randconfig-011-20260702    gcc-14
x86_64                randconfig-012-20260702    clang-22
x86_64                randconfig-012-20260702    gcc-14
x86_64                randconfig-013-20260702    clang-22
x86_64                randconfig-014-20260702    clang-22
x86_64                randconfig-014-20260702    gcc-12
x86_64                randconfig-015-20260702    clang-22
x86_64                randconfig-015-20260702    gcc-14
x86_64                randconfig-016-20260702    clang-22
x86_64                         randconfig-071    clang-22
x86_64                randconfig-071-20260702    clang-22
x86_64                randconfig-071-20260702    gcc-14
x86_64                         randconfig-072    clang-22
x86_64                randconfig-072-20260702    clang-22
x86_64                randconfig-072-20260702    gcc-14
x86_64                         randconfig-073    clang-22
x86_64                randconfig-073-20260702    clang-22
x86_64                         randconfig-074    clang-22
x86_64                randconfig-074-20260702    clang-22
x86_64                randconfig-074-20260702    gcc-12
x86_64                         randconfig-075    clang-22
x86_64                randconfig-075-20260702    clang-22
x86_64                         randconfig-076    clang-22
x86_64                randconfig-076-20260702    clang-22
x86_64                randconfig-076-20260702    gcc-14
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
xtensa                randconfig-002-20260702    gcc-14.3.0
xtensa                randconfig-002-20260702    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

