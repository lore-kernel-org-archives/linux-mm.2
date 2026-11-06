Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EB78606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 01:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YjMjxaXv
Received: by kanga.kvack.org (Postfix)
	id 5C1EA6B05B2; Thu,  5 Nov 2026 20:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572AD6B05B3; Thu,  5 Nov 2026 20:54:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461746B05B4; Thu,  5 Nov 2026 20:54:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12A186B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:54:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16A70A888A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:54:27 +0000 (UTC)
X-FDA: 85403024574.28.9A054D1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id 54E50180002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:54:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YjMjxaXv;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793930065;
	b=fHQfRNxVYlNyLHZ6eozZNNdULSSCEXKZhLB245CbJXLliuy9tlJP1jyT43K9KCkoHjLIQy
	1YzRWMIglKESCe0QSjz7moHY7FjylHhAr5oindH/7kD+VD9zX7c4Rlwm6ApAMlzxgwRJXg
	CPvslr+dI02SP5Gu31k0UG47QXCUi+s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YjMjxaXv;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793930065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=OzMiBDaS7l6UuJBibgUYEdXexUSYxGYeqcUpMn0sCvw=;
	b=2dHOoa0FM3g4NtFMFrjrqI1ORcX5akwY+6GlpPA+rngkstUmumkFE1+R0tRK7lMGFHJXfC
	toZhXG7EEn5uNCyEGzdE3DRDOLIdWmZCytx0LXObWbLIZ5jJKZn/O4awFUZ+WZf4Ynnnyb
	P6hr0iwHlUpqPUqjbYVO9kr0+hQCi0Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793930064; x=1825466064;
  h=date:from:to:cc:subject:message-id;
  bh=L+qunJOHFga32xwjkuKGKZmxtc8ksnVinIWaJwTYBtU=;
  b=YjMjxaXvTSLvwK4oH50GuFBfPEoGxOQaSY7/HjKN59KOvsY2jSAwkL6H
   gLQI9CpcuQAhYqAJYva6J1/SJhuzdCpM57L/cRDRZLtYPI/F15lgjtaOn
   e8BnWLE3/T2Io9tfLfgpHmTJD8Ffbu8FRYA3n94bUTdaA/CV5UNuJCN8o
   wlYldYyS7vJuCHRaSEDPJaWw9Rl6pDKKJJRVWjhIs8mDzG2HbVwEDdW/j
   4Izv3mDdClLS1fNfbTUMIHS0kK2x5oY/ERO3nplkwnpUNCbYkK3a4RXWi
   MFjMh1bW9AlZCe/Cji8+yW/4XsdrfjkSy9D9OIXxa6zPSP7Idbt9nC+Is
   A==;
X-CSE-ConnectionGUID: j0mI+/GaSDOjw2BVbgHcwA==
X-CSE-MsgGUID: tlKo9fIAS2m03KaHMd7d7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2756211"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2756211"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 17:54:22 -0800
X-CSE-ConnectionGUID: eDDvYLrRTYKk6HXcsyQQ9w==
X-CSE-MsgGUID: P1njgYiMRoWioRZounNv8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7150858"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 05 Nov 2026 17:54:20 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xP99m-00000000nBP-0Anl;
	Fri, 06 Nov 2026 01:54:18 +0000
Date: Fri, 06 Nov 2026 09:53:40 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 dba8aba0a9a00ff781c03d82ae534fc6f8c2e263
Message-ID: <20261106095340.lgMcCHGK-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 54E50180002
X-Stat-Signature: 571esbpfm3arxa68prbyiymi7ptggqz6
X-Rspam-User: 
X-HE-Tag: 1793930064-771496
X-HE-Meta: U2FsdGVkX19bFeImoGJquP6HrlEBMHctxcJ1CK7hEcvpVG3Scx84nG9/lxoqWOU3Is2UU7MGHLj2eshYgsUrXoEh29TLfh1yloQDqTZe4mGG1Bkac3+/yyaNt5UexOLdju7IrzWLT86+iPN+xs8F9gBe8/zujtfPJakgzcFJu/BY/2MkDuPT90KTBocMGRHDsSQDY5jrgCz7ayL9ZCTIqewEmAwj1CPoB4ghRsM7689xot7BYghn6i49e0DLRIRuwQaDOQ/Df0Rkwq0JCDbS0uepGJ0cPLnPJLzFpespqMzByy6usK2xUkPlISfZOHi9wM+aIwSzuITI2fhFFOSpzveL85LFMG5PyOn9hY/aOc83rDms5bDgCI8R74ml8V1AjTz7mr1aJ7OtViBB/VXy7TsVTZnGz6ygzHcVLgu5ZlbQdLVoLMGuvHB3K9joMy5qWqA61JFaz4BKCvBAvaPoY8SgNMFlJVki0l9NH17gcReMDvynBr+JCWdkHDAURt+f5oU2YGmZOIgtbTrLN5BAW+uShda+p3fUBTqp8smSo0r0WjAK0kHzWtIn81rQwvmD41CPNilxyT9nix5jhjcFvgn4hVjq8LG5r9gAtKnnqVoNyxfuNIj73OFHU7CQp4Giv4iCG8iIEDH49wRCwZM0gvipucXWlmmTypvj/7Ag1FH/C627quLG6ErH/W2YnqJzL8TcLUqF7QhKSRUowUXB4xPzKdSLqSofrnjoLG2Z09kMJ1Lsy9qZ5edNNSthZ/cX3wULkHyDYy00lidazujk5nmzCavIYbeEvdvkIIkKsjw+HP03vjjbaWuXreX4/7w4kKY3kHEBllH2hK9+RO7lIGK6DWFoMT8HzPfisnDz66j41FKL5DBu5aLu00ZC2ADTxH1G7wl8xAdJiXchj8aZqoDrDbthVL5EhI1P0byNRHZUog9vd78fVJgX90PZahfOj/IaU+wxf8AN88vNt/8
 EaBQ6ZAv
 RBOyCtRzCJwAxy111iILl0XjoKk6e50k1G1zeyAVlZU0aa3YXsWaM+/PcoC/vv+ohbMcpw1yPq0fsR1TpLy6Ihd/fL6ZdyZKz5cYz+fA7Rh0tmLnGx1PmcMh9/HydYh4+dDasnX/N4DNlnU5dAD8A4ldjFwQLAGBx5Sp8MjR+iC0TehIA6d1Rryx7z17wz0mVfxpiQtq6dgygbSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: dba8aba0a9a00ff781c03d82ae534fc6f8c2e263  riscv: mm: fix concurrency in mark_new_valid_map()

Error/Warning ids grouped by kconfigs:

recent_errors
`-- csky-allmodconfig
    `-- drivers-net-wireless-ath-ath11k-dbring.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc

elapsed time: 1078m

configs tested: 347
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261105    gcc-11.5.0
alpha                 randconfig-2001-20261105    gcc-8.5.0
alpha                 randconfig-2200-20261105    gcc-9.5.0  smatch
alpha                randconfig-r2104-20261105    gcc-11.5.0 cocci
alpha                randconfig-r2105-20261105    gcc-9.5.0  cocci
alpha                randconfig-r2111-20261105    gcc-14.4.0 cocci
alpha                randconfig-r2310-20261105    gcc-8.5.0  sparse
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261105    gcc-14.4.0
arc                   randconfig-1001-20261105    gcc-14.4.0
arc                   randconfig-2000-20261105    gcc-8.5.0
arc                   randconfig-2001-20261105    gcc-8.5.0
arc                   randconfig-2002-20261105    gcc-15.3.0
arc                   randconfig-2003-20261105    gcc-9.5.0
arc                   randconfig-2004-20261105    gcc-15.3.0
arc                   randconfig-2005-20261105    gcc-13.5.0
arc                   randconfig-2200-20261105    gcc-8.5.0  smatch
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                       integrator_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261105    gcc-14.4.0
arm                   randconfig-1001-20261105    gcc-14.4.0
arm                   randconfig-1002-20261105    gcc-14.4.0
arm                   randconfig-1003-20261105    gcc-14.4.0
arm                   randconfig-2000-20261105    gcc-10.5.0
arm                   randconfig-2001-20261105    clang-20
arm                   randconfig-2200-20261105    gcc-15.3.0 smatch
arm                          s3c6400_defconfig    gcc-16.2.0
arm                            sama5_defconfig    gcc-16.2.0
arm                            sunxi_defconfig    gcc-16.2.0
arm                            u8500_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261105    gcc-13.5.0
arm64                 randconfig-1001-20261105    gcc-13.5.0
arm64                 randconfig-1002-20261105    gcc-13.5.0
arm64                 randconfig-1003-20261105    gcc-13.5.0
arm64                 randconfig-2200-20261105    clang-20   smatch
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261105    gcc-13.5.0
csky                  randconfig-1001-20261105    gcc-13.5.0
csky                  randconfig-2000-20261105    gcc-16.2.0
csky                  randconfig-2001-20261105    gcc-13.5.0
csky                  randconfig-2200-20261105    gcc-9.5.0  smatch
csky                 randconfig-r2107-20261105    gcc-12.5.0 cocci
csky                 randconfig-r2301-20261105    gcc-10.5.0 sparse
csky                 randconfig-r2306-20261105    gcc-16.2.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261105    clang-19
hexagon               randconfig-1000-20261105    clang-24
hexagon               randconfig-1001-20261105    clang-24
hexagon               randconfig-2000-20261105    clang-24
hexagon               randconfig-2001-20261105    clang-24
hexagon               randconfig-2200-20261105    clang-17   smatch
hexagon              randconfig-r2109-20261105    clang-24   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386        buildonly-randconfig-1000-20261105    gcc-14
i386        buildonly-randconfig-1000-20261106    clang-22
i386        buildonly-randconfig-1001-20261105    gcc-14
i386        buildonly-randconfig-1001-20261106    clang-22
i386        buildonly-randconfig-1002-20261105    gcc-14
i386        buildonly-randconfig-1002-20261106    clang-22
i386        buildonly-randconfig-1003-20261105    gcc-14
i386        buildonly-randconfig-1003-20261106    clang-22
i386        buildonly-randconfig-1004-20261105    gcc-14
i386        buildonly-randconfig-1004-20261106    clang-22
i386        buildonly-randconfig-1005-20261105    gcc-14
i386        buildonly-randconfig-1005-20261106    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261105    gcc-14
i386                  randconfig-1001-20261105    gcc-14
i386                  randconfig-1002-20261105    clang-22
i386                  randconfig-1003-20261105    gcc-14
i386                  randconfig-1004-20261105    gcc-14
i386                  randconfig-1005-20261105    gcc-14
i386                  randconfig-1006-20261105    clang-22
i386                  randconfig-1007-20261105    clang-22
i386                  randconfig-1007-20261105    gcc-14
i386                  randconfig-1008-20261105    clang-22
i386                  randconfig-1009-20261105    clang-22
i386                  randconfig-1009-20261105    gcc-14
i386                  randconfig-1010-20261105    clang-22
i386                  randconfig-1011-20261105    clang-22
i386                  randconfig-1011-20261105    gcc-13
i386                  randconfig-1012-20261105    clang-22
i386                  randconfig-1013-20261105    clang-22
i386                  randconfig-2000-20261105    clang-22
i386                  randconfig-2001-20261105    clang-22
i386                  randconfig-2002-20261105    gcc-14
i386                  randconfig-2003-20261105    clang-22
i386                  randconfig-2004-20261105    clang-22
i386                  randconfig-2005-20261105    clang-22
i386                  randconfig-2100-20261105    clang-22   cocci
i386                  randconfig-2101-20261105    gcc-14     cocci
i386                  randconfig-2102-20261105    clang-22   cocci
i386                  randconfig-2103-20261105    gcc-14     cocci
i386                  randconfig-2104-20261105    gcc-14     cocci
i386                  randconfig-2105-20261105    gcc-14     cocci
i386                  randconfig-2200-20261105    clang-22   smatch
i386                  randconfig-2300-20261105    gcc-14     sparse
i386                  randconfig-2301-20261105    gcc-14     sparse
i386                  randconfig-2302-20261105    gcc-14     sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261105    clang-24
loongarch             randconfig-1000-20261105    gcc-16.2.0
loongarch             randconfig-1001-20261105    clang-24
loongarch             randconfig-2000-20261105    gcc-12.5.0
loongarch             randconfig-2001-20261105    gcc-16.2.0
loongarch             randconfig-2200-20261105    gcc-16.2.0 smatch
loongarch            randconfig-r2304-20261105    clang-24   sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5208evb_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261105    gcc-14.4.0
m68k                  randconfig-2001-20261105    gcc-16.2.0
m68k                  randconfig-2200-20261105    gcc-8.5.0  smatch
m68k                 randconfig-r2103-20261105    gcc-8.5.0  cocci
m68k                 randconfig-r2300-20261105    gcc-9.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261105    gcc-15.3.0
microblaze            randconfig-2001-20261105    gcc-8.5.0
microblaze            randconfig-2200-20261105    gcc-9.5.0  smatch
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                      eyeq6lplus_defconfig    gcc-16.2.0
mips                            ip28_defconfig    gcc-16.2.0
mips                            mtx1_defconfig    gcc-16.2.0
mips                  randconfig-2000-20261105    gcc-9.5.0
mips                  randconfig-2001-20261105    gcc-15.3.0
mips                  randconfig-2002-20261105    gcc-13.5.0
mips                  randconfig-2200-20261105    gcc-11.5.0 smatch
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261105    clang-24
nios2                 randconfig-1000-20261105    gcc-11.5.0
nios2                 randconfig-1001-20261105    clang-24
nios2                 randconfig-1001-20261105    gcc-10.5.0
nios2                 randconfig-2000-20261105    gcc-11.5.0
nios2                 randconfig-2001-20261105    gcc-8.5.0
nios2                 randconfig-2200-20261105    gcc-9.5.0  smatch
nios2                randconfig-r2100-20261105    gcc-10.5.0 cocci
nios2                randconfig-r2101-20261105    gcc-8.5.0  cocci
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261105    gcc-11.5.0
openrisc              randconfig-2001-20261105    gcc-16.2.0
openrisc              randconfig-2002-20261105    gcc-11.5.0
openrisc              randconfig-2200-20261105    gcc-16.2.0 smatch
openrisc             randconfig-r2110-20261105    gcc-16.2.0 cocci
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261105    clang-21
parisc                randconfig-1000-20261105    gcc-14.4.0
parisc                randconfig-1000-20261106    clang-19
parisc                randconfig-1001-20261105    clang-21
parisc                randconfig-1001-20261105    gcc-8.5.0
parisc                randconfig-1001-20261106    clang-19
parisc                randconfig-2000-20261105    gcc-8.5.0
parisc                randconfig-2001-20261105    gcc-15.3.0
parisc                randconfig-2200-20261105    gcc-15.3.0 smatch
parisc               randconfig-r2102-20261105    gcc-14.4.0 cocci
parisc               randconfig-r2308-20261105    gcc-16.2.0 sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261105    clang-20
powerpc               randconfig-1000-20261105    clang-21
powerpc               randconfig-1000-20261106    clang-19
powerpc               randconfig-1001-20261105    clang-21
powerpc               randconfig-1001-20261105    clang-24
powerpc               randconfig-1001-20261106    clang-19
powerpc               randconfig-2000-20261105    clang-24
powerpc               randconfig-2001-20261105    gcc-16.2.0
powerpc               randconfig-2002-20261105    clang-24
powerpc               randconfig-2200-20261105    clang-17   smatch
powerpc              randconfig-r2303-20261105    clang-17   sparse
powerpc64             randconfig-1000-20261105    clang-21
powerpc64             randconfig-1000-20261105    clang-24
powerpc64             randconfig-1000-20261106    clang-19
powerpc64             randconfig-1001-20261105    clang-21
powerpc64             randconfig-1001-20261106    clang-19
powerpc64             randconfig-2000-20261105    clang-17
powerpc64             randconfig-2001-20261105    gcc-8.5.0
powerpc64             randconfig-2002-20261105    clang-18
powerpc64             randconfig-2200-20261105    clang-24   smatch
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv              nommu_k210_sdcard_defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261105    clang-24
riscv                 randconfig-1001-20261105    clang-24
riscv                 randconfig-2000-20261105    clang-24
riscv                 randconfig-2001-20261105    clang-24
riscv                 randconfig-2002-20261105    clang-17
riscv                 randconfig-2003-20261105    clang-24
riscv                 randconfig-2004-20261105    clang-24
riscv                 randconfig-2005-20261105    clang-24
riscv                 randconfig-2200-20261105    clang-24   smatch
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261105    clang-24
s390                  randconfig-1001-20261105    clang-24
s390                  randconfig-2000-20261105    clang-24
s390                  randconfig-2001-20261105    gcc-8.5.0
s390                  randconfig-2002-20261105    clang-22
s390                  randconfig-2003-20261105    clang-24
s390                  randconfig-2004-20261105    clang-24
s390                  randconfig-2005-20261105    gcc-8.5.0
s390                  randconfig-2200-20261105    clang-24   smatch
s390                 randconfig-r2305-20261105    gcc-10.5.0 sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                              espt_defconfig    gcc-16.2.0
sh                           polaris_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261105    clang-24
sh                    randconfig-1001-20261105    clang-24
sh                    randconfig-2000-20261105    gcc-16.2.0
sh                    randconfig-2001-20261105    gcc-13.5.0
sh                    randconfig-2002-20261105    gcc-16.2.0
sh                    randconfig-2003-20261105    gcc-16.2.0
sh                    randconfig-2004-20261105    gcc-15.3.0
sh                    randconfig-2005-20261105    gcc-16.2.0
sh                    randconfig-2200-20261105    gcc-13.5.0 smatch
sh                              shx3_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261105    gcc-8.5.0
sparc                 randconfig-1001-20261105    gcc-8.5.0
sparc                 randconfig-2000-20261105    gcc-8.5.0
sparc                 randconfig-2001-20261105    gcc-13.5.0
sparc                 randconfig-2200-20261105    gcc-16.2.0 smatch
sparc                randconfig-r2311-20261105    gcc-16.2.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261105    gcc-8.5.0
sparc64               randconfig-1001-20261105    gcc-8.5.0
sparc64               randconfig-2000-20261105    clang-24
sparc64               randconfig-2001-20261105    clang-24
sparc64               randconfig-2200-20261105    gcc-8.5.0  smatch
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261105    gcc-8.5.0
um                    randconfig-1001-20261105    gcc-8.5.0
um                    randconfig-2000-20261105    gcc-14
um                    randconfig-2001-20261105    clang-17
um                    randconfig-2200-20261105    clang-19   smatch
um                   randconfig-r2106-20261105    gcc-14     cocci
um                   randconfig-r2309-20261105    clang-17   sparse
um                            x86_64_defconfig    gcc-14
x86_64                            alldefconfig    gcc-16.2.0
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261105    clang-22
x86_64                randconfig-1001-20261105    clang-22
x86_64                randconfig-1002-20261105    clang-22
x86_64                randconfig-1003-20261105    clang-22
x86_64                randconfig-1004-20261105    clang-22
x86_64                randconfig-1005-20261105    clang-22
x86_64                randconfig-1006-20261105    clang-22
x86_64                randconfig-1007-20261105    gcc-14
x86_64                randconfig-1008-20261105    clang-22
x86_64                randconfig-1009-20261105    gcc-14
x86_64                randconfig-1010-20261105    gcc-13
x86_64                randconfig-1011-20261105    clang-22
x86_64                randconfig-2000-20261105    clang-22
x86_64                randconfig-2001-20261105    gcc-14
x86_64                randconfig-2002-20261105    gcc-14
x86_64                randconfig-2004-20261105    clang-22
x86_64                randconfig-2005-20261105    clang-22
x86_64                randconfig-2100-20261105    gcc-14     cocci
x86_64                randconfig-2101-20261105    gcc-14     cocci
x86_64                randconfig-2102-20261105    gcc-14     cocci
x86_64                randconfig-2103-20261105    gcc-14     cocci
x86_64                randconfig-2104-20261105    gcc-14     cocci
x86_64                randconfig-2105-20261105    gcc-14     cocci
x86_64                randconfig-2200-20261105    clang-22   smatch
x86_64                randconfig-2301-20261105    clang-22   sparse
x86_64                randconfig-2302-20261105    clang-22   sparse
x86_64               randconfig-r2108-20261105    gcc-14     cocci
x86_64               randconfig-r2307-20261105    gcc-14     sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.2.0
xtensa                 generic_kc705_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261105    gcc-8.5.0
xtensa                randconfig-1001-20261105    gcc-8.5.0
xtensa                randconfig-2000-20261105    gcc-13.5.0
xtensa                randconfig-2001-20261105    gcc-11.5.0
xtensa                randconfig-2200-20261105    gcc-8.5.0  smatch
xtensa               randconfig-r2302-20261105    gcc-8.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

