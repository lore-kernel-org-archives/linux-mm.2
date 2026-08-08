Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D8AFC55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 05:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3116B0099; Sat,  8 Aug 2026 01:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18AB06B009B; Sat,  8 Aug 2026 01:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054326B009D; Sat,  8 Aug 2026 01:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7D5C6B0099
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:07:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 355F11C0A4C
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:07:31 +0000 (UTC)
X-FDA: 85076919102.24.DBEECD5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf22.hostedemail.com (Postfix) with ESMTP id B88B9C0002
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:07:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mul4kLFl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786165649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=QQDUYwgEeH7i5V0F5TfwaKTr2PHZVJ3M3LJOoPS3m58=;
	b=Ipu1WcVGnhg87MWaxSrDomTSmfCisuzXBifRN1fIe/0NAUEcOW1kJwkfodQuhDVdOvmzTt
	WqHMv9FdgORGg5CYu/SgpyLl/sQrHVHEYGAOlT3deJrtho+tPUjNLaA8P0aJf11R73Hk1K
	mwmyzB/M0b3pQGUmOs1Ds//fkoEMnFs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mul4kLFl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786165649;
	b=NKDIOeteZRYGuXtN4dRn5gqHg75/phF9sv56cXgE44yjhaWYdEwsJZ3PPr9pgAZi3L+0Kq
	m5Cr7uav1gf2kqwx+0obgOZ9Ty2iZj3DPikg/gq0tThGk1q5Byg//+lfV49bE2ZtaPdyaU
	xaGz++x8K9DddlF+pz7ahrPOnFjSBBQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786165649; x=1817701649;
  h=date:from:to:cc:subject:message-id;
  bh=/Xi1ZoawYjvF26e6Kz5ej95BOmY21gnXZSm/krk+KYc=;
  b=mul4kLFlkezxy5hbMqd4f6DlK/lmOnhbBh+eXDgs6yNDkrOzNZrzQ448
   am9NaEf7L1yix9agYyFLUly7h8R80h8oM5kLrC+n7zrKz/AgS0xS5lFgh
   sr6393GGf6/fD8fbDdVcEhk0C7/A58RZ0Iji4qRmSS7JxKAImCsskD3Xt
   +gRKbcFldqQm7wDSZeVCoUVNRBxeHryWum99VNc7vf5lILAyxeCu8qHV5
   vbvyWE6o5pstlnzDczws88jJMCU292gncnSrBbcnL7DjjYYrDvCSdv8ba
   U51tXEcd4lMMc8UN86bacXloNZULThlsyXmnaAt1uoFjR8/wdMhQSkoyW
   w==;
X-CSE-ConnectionGUID: gI+WIjpgRDGkwk7jlgNLrQ==
X-CSE-MsgGUID: /0VwMchkSSqG8tzWZ1Dhkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11868"; a="109562888"
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="109562888"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 22:07:28 -0700
X-CSE-ConnectionGUID: 4fRn9+VBTv2t05qK7lUzjA==
X-CSE-MsgGUID: tPV6uJdCTNqkPS8Dry1UyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="260828899"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 07 Aug 2026 22:07:26 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wsZHH-00000000Jm1-3fN5;
	Sat, 08 Aug 2026 05:07:23 +0000
Date: Sat, 08 Aug 2026 13:06:48 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 8086604be9733378461a5534c39cb72635226b23
Message-ID: <202608081329.lUvUN2Er-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B88B9C0002
X-Stat-Signature: 9ece1bzzy93i8mte1kojabg88u9wezic
X-Rspam-User: 
X-HE-Tag: 1786165648-659476
X-HE-Meta: U2FsdGVkX1+PWkmUbZmhqkxBe6Lr5roEoUar6woKEkvazG1PUoYspFW+Tri71cuRMr6zLtJlPZL2YjHYNq15RbyPttVMRm7kb9VxBM+tumz4okzGhI5Y7H0cGTaI1sumEuiIlb0iow/bFIxWiNe9/4eRY/F7V7dxx5M2mgIFZNE2eYOwpZ0azBNpSgwYs90IVA+fvx3hN9Mkb92gwbbdu739WfHMcRw5648b1A5ADFBCydHgdLVcSwE8qA0NOVyDWuxdlyn6y19icof/nrbz5hRo4UWUW4C/8WH61CUcNc2OmAMdfT9HTftP/rWzbgb16yrK4oScivZY+FNy7ZFdvXEXbV+9RsRVbau7T/9JfOZHcrSb9b8lKtv2ms5v3+AhVUO8v0BEiY8g9lZzqHTK6KUN6HaLc9m6qWxscO1S+e35eTOaxXrFgf4t6jCac+qm21LzPaEp0bB/q75wn+XKR6TyHWcJg4+eidy7BwuYKG6a5zNvXdNG/d4p6rJkyJPBo4ojmXsY/I7b+KGSgQGQMuqt4MRuhEfsiN38JLdO8q1kvd5tsD4YoBf27/P/6s5oDYz/r2UHoDWHbPQCdi/JOAmB9GpnbGlW26fwIFwwcB9pLclYDoFKQOPANGwOnaO6UAFoyoMFc0m4oxOOR2yV05Gv/iNNdP/rM59/d5g6DzqXYgrPaV56e924r01j+LlDvH2bv2OCg2jn39Eog/4HFCE7+1UEbephUBdZ7Oo/WJ4XycMUHOxJ+BmxkwCozjQaGfXf9SMnGyrGeab6FOZ7MaZRmlQ7J1+2jLFN6wVUfBttE97GHMA1dr5pNoW+7KNoLMoq4Mwghx8OMfKFfmzwuW1WhpIULxAR3DZbALPesk4nLfFYvQq3TsYAo90bQQbmsZDoy6fi/SzNoWwKmJ+TpSS7+yEOHbUwAgHLoOpjKdVFxwxWDnMpfLGm3MUSJmxVK2SbqUHNI9uz48vxAft
 CQA07Yng
 2i1/N/sYVTAnTppEPBcij0r1EYEeG8i1XjND+/gztbIEvwC6t6vj6Y5JDp8WKKl9VR1Gj7qSHIyNQO2PSjC3lVD/iK14ff6GYZGJA/zPdHn9cijhyVSS4L8K2PAx75FcgTeRov8cCoyu+FhrnLmURoehuzukEbasxcObshIBlQ52+RNgWF/lIVMoaEZOHx3pxd83KgbK5ahczBpdbh6yAU/KHWaqsex7j6iPi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 8086604be9733378461a5534c39cb72635226b23  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Warning ids grouped by kconfigs:

recent_errors
`-- alpha-randconfig-r071-20260807
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 814m

configs tested: 97
configs skipped: 0

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260807    gcc-8.5.0
arc                  randconfig-002-20260807    gcc-14.3.0
arm                      imx_v4_v5_defconfig    clang-24
arm                  randconfig-001-20260807    clang-17
arm                  randconfig-002-20260807    gcc-12.5.0
arm                  randconfig-003-20260807    gcc-10.5.0
arm                  randconfig-004-20260807    gcc-16.1.0
arm64                randconfig-001-20260807    clang-24
arm64                randconfig-002-20260807    clang-24
arm64                randconfig-003-20260807    gcc-16.1.0
arm64                randconfig-004-20260807    clang-17
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260807    gcc-14.3.0
csky                 randconfig-002-20260807    gcc-16.1.0
hexagon              randconfig-001-20260807    clang-24
hexagon              randconfig-002-20260807    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260807    gcc-14
i386       buildonly-randconfig-002-20260807    gcc-14
i386       buildonly-randconfig-003-20260807    clang-22
i386       buildonly-randconfig-004-20260807    clang-22
i386       buildonly-randconfig-005-20260807    clang-22
i386       buildonly-randconfig-006-20260807    gcc-13
i386                 randconfig-001-20260807    clang-22
i386                 randconfig-002-20260807    clang-22
i386                 randconfig-003-20260807    clang-22
i386                 randconfig-004-20260807    gcc-14
i386                 randconfig-005-20260807    clang-22
i386                 randconfig-006-20260807    gcc-14
i386                 randconfig-007-20260807    gcc-14
i386                 randconfig-011-20260808    gcc-14
i386                 randconfig-012-20260808    clang-22
i386                 randconfig-013-20260808    gcc-14
i386                 randconfig-014-20260808    clang-22
i386                 randconfig-015-20260808    clang-22
i386                 randconfig-016-20260808    clang-22
i386                 randconfig-017-20260808    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260807    clang-24
loongarch            randconfig-002-20260807    clang-18
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260807    gcc-8.5.0
nios2                randconfig-002-20260807    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260807    gcc-9.5.0
parisc               randconfig-002-20260807    gcc-8.5.0
powerpc              randconfig-001-20260807    clang-24
powerpc              randconfig-002-20260807    clang-24
powerpc64            randconfig-001-20260807    gcc-8.5.0
powerpc64            randconfig-002-20260807    gcc-14.3.0
riscv                randconfig-001-20260807    gcc-12.5.0
riscv                randconfig-002-20260807    gcc-10.5.0
s390                 randconfig-001-20260807    gcc-9.5.0
s390                 randconfig-002-20260807    gcc-15.2.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260807    gcc-16.1.0
sh                   randconfig-002-20260807    gcc-16.1.0
sparc                randconfig-001-20260807    gcc-15.2.0
sparc                randconfig-002-20260807    gcc-16.1.0
sparc64              randconfig-001-20260807    clang-20
sparc64              randconfig-002-20260807    clang-20
um                   randconfig-001-20260807    gcc-14
um                   randconfig-002-20260807    clang-24
x86_64     buildonly-randconfig-001-20260807    clang-22
x86_64     buildonly-randconfig-002-20260807    gcc-14
x86_64     buildonly-randconfig-003-20260807    gcc-14
x86_64     buildonly-randconfig-004-20260807    clang-22
x86_64     buildonly-randconfig-005-20260807    clang-22
x86_64     buildonly-randconfig-006-20260807    clang-22
x86_64               randconfig-001-20260807    clang-22
x86_64               randconfig-002-20260807    gcc-14
x86_64               randconfig-003-20260807    clang-22
x86_64               randconfig-004-20260807    clang-22
x86_64               randconfig-005-20260807    clang-22
x86_64               randconfig-006-20260807    gcc-14
x86_64               randconfig-011-20260807    clang-22
x86_64               randconfig-012-20260807    clang-22
x86_64               randconfig-013-20260807    clang-22
x86_64               randconfig-014-20260807    gcc-14
x86_64               randconfig-015-20260807    gcc-14
x86_64               randconfig-016-20260807    gcc-14
x86_64               randconfig-071-20260807    gcc-13
x86_64               randconfig-072-20260807    clang-22
x86_64               randconfig-073-20260807    clang-22
x86_64               randconfig-074-20260807    clang-22
x86_64               randconfig-075-20260807    gcc-14
x86_64               randconfig-076-20260807    clang-22
xtensa               randconfig-001-20260807    gcc-8.5.0
xtensa               randconfig-002-20260807    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

