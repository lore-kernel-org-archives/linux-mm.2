Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633B2D6AAFE
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 19:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE8C6B0005; Thu,  2 Apr 2026 15:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896D66B0089; Thu,  2 Apr 2026 15:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC476B008A; Thu,  2 Apr 2026 15:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68C836B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:50:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E897C5B8F2
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:50:51 +0000 (UTC)
X-FDA: 84614658702.24.DBBE051
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2883840004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:50:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G8OddZw7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775159450; a=rsa-sha256;
	cv=none;
	b=lQybWaXFeXyJiD0YJuQZxUlS9RWapwegbyfOzw6+Sp3UnZCZu3WJN/CRKisInufz/AOzj/
	fLi8DT3WDxvNbLMoq9w6yf28eXJj3QrWWkbb1pr/1zOg81/lX8rDqJGVQgb1G6MI/UR+fE
	LtyrsKDAnry79noW916elaHlYDZQYi0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G8OddZw7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775159450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=R1SPd4AZDgEo9ihdL5X0KThj8Lk9FhthXQ9EXScQc6s=;
	b=tQ4s3c0i6/mVs1PIncV9UqTwaZ1QLaOBZtlg6NtQkGOsdzEM1AslKrKkv3HuVv0Pa7LndG
	C2FCO/Ri3GS7yJP6MWY4SLRffQKL0ZAtzxEP1aWQDOzxwgHzW3biO3jzjiH0IsPG9q/AFm
	GRkeywCArWTqodsOqJKir3CgZoAMhtc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775159450; x=1806695450;
  h=date:from:to:cc:subject:message-id;
  bh=Q8Pbml1KMHc7OIRwyogsJavOhGVDlclwTqU0PjeBSIY=;
  b=G8OddZw7LFaHajafN3FN5XDalNOOzFhPmLZEyKTu3PKiKIMYvEeqZjwJ
   pVdC3gKih7gdfvlPxRoMWKivyqsLVjRVyoi+yRDbeZcr4qkAHKhJPQljC
   Bk/ldfK4Ss97D2UHG2rVPjoqn5U+OScPyOE8DZZ60eT5icoJAbNuDstYa
   +F0wBrYUFfwhFEms64wXVcbwGp42xsFpzyhxxmpXp8jKMIroPmYe9Dq2f
   Ma+YFUdwyHjBWcQ7ClnF/xRuoQTm9b2Ex4P2Q0WryWrW3gIBsS1vmRd00
   t2n1rvJ8cZY9M5y+3bnzICn7kfRMv6pyenL2+e4McBDoOwCytXy5sl0/5
   g==;
X-CSE-ConnectionGUID: cpZPTor+TWyTLTDkuWUBXg==
X-CSE-MsgGUID: fTe7k1C5SZSK0u+37rz9mA==
X-IronPort-AV: E=McAfee;i="6800,10657,11747"; a="87299909"
X-IronPort-AV: E=Sophos;i="6.23,156,1770624000"; 
   d="scan'208";a="87299909"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2026 12:50:48 -0700
X-CSE-ConnectionGUID: 1QTjENrgQ3ugxbC+zqmsoA==
X-CSE-MsgGUID: fskw3hGbTVihQZ4nFeUrhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,156,1770624000"; 
   d="scan'208";a="228692526"
Received: from lkp-server01.sh.intel.com (HELO 064ad336901d) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 02 Apr 2026 12:50:46 -0700
Received: from kbuild by 064ad336901d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w8O3v-000000000Nn-3HJR;
	Thu, 02 Apr 2026 19:50:43 +0000
Date: Fri, 03 Apr 2026 03:49:55 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 59bd1d914bb51ab99a33ce32420403ccd035ad29
Message-ID: <202604030346.uuJMTrgA-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: eyarqikybs1ypfxpjoiwnp4sibp87mz3
X-Rspamd-Queue-Id: 2883840004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775159448-96146
X-HE-Meta: U2FsdGVkX1+knK6qMpJH+OLKJ4g7O2VVae4gNVXPG6oiLizkTSUOoYa8BLGPJ0L4ky9zUtaHUIZp1s4wbaI2B9NVWrJ8WVFG02RzO3WHZe67Y98kWZJQjPQVkcCLXGzgmqca+y0/2xt8Ju1gWVRF4J9AwLVZOKEppunG57FYb4Ie7rTPunZ3XwPd/95amrBZtgaLj9QfitMnikLZyJGX+HMCMTP0ML8v8ug7kJ9AbqDcFN1hvjQvo9czZUE5bOS9pp6SUNwr7wTDre4QtqxJlpyPSx2snwLrcQ7mRF2QTxYM/YwQemFhiTeR6q+2ZRFlDFf77DIw6QF3uncBRdjoSdlr+qX2RQgTpfSyq9CXGauzNsKl+kPz5SEHElbpkXkxFV2+04R1FL5k7usW+xMm5JqOdbKol3xNU8PRVo5ovOewRvxnmrfHZSz6AzyZRWZTRMjfBxtqS724FcA1/0/snIqLyeuyFn/0LW83JBVbX/lbp/Us4F8m9jPm+KK/Qf17Nw/yKQmoAnfZjJA49wH9zOSJAu4/fBv2Ongcw5PVCvDLBSj76paw4QohPqd6ZAsP+RwyUjp6+Se5KTcK9D6zCa6060V6a5mJ/IKI58cBRiorytoz6MTCBFAv8Euc0KPyVGCioAGOA26pRvDycmtqm4lsLKG8hv/yTdxxymq9DQIerXDwoKlPHRemEzxDsO5sD52Qs76/jxDEyvKjtaXtA3EW8x+orZK/50Cv05QXaXSH2uOqZkoJLqRKUF+wSRsf1Rs1JaKG+EXx2mpVlkT8YCa0IaYrBItJhwU2W9tg4lxyZvkr9oXcuheuyKVcpOEcUDWA4zcMXvJdL0eN5/q8NiaQAOBprJf6xY/n8UA+B0hrB5Z++EaGfrHSlSw2QenXXVHvt/ddLSVMmmCZ0WTPZzph9+MRNcbeiqpF3OCFfUP+iwGS2OsJotYEzUarCot/uLq3Dj5yobYycbbwyYS
 Fa016whN
 C7EaH1s1INhnvpki1Rvf/Vugsr4dbXIX16hCzZlN+ca5VEpkAhNwfe99arwA95iZzliXR/dmfmhA8irifHAqjIZqLVmk8ZTwm2Whqxs0YAneE9haXFaodW7ZNsOIaJmM8w1DYytp56Qd2qumuOcbw+WjkWA/JP20Bn1O6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 59bd1d914bb51ab99a33ce32420403ccd035ad29  memblock: warn when freeing reserved memory before memory map is initialized

elapsed time: 751m

configs tested: 183
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260402    gcc-11.5.0
arc                   randconfig-002-20260402    gcc-11.5.0
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                                 defconfig    gcc-15.2.0
arm                         orion5x_defconfig    clang-23
arm                   randconfig-001-20260402    gcc-11.5.0
arm                   randconfig-002-20260402    gcc-11.5.0
arm                   randconfig-003-20260402    gcc-11.5.0
arm                   randconfig-004-20260402    gcc-11.5.0
arm                       spear13xx_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260402    gcc-15.2.0
arm64                 randconfig-002-20260402    gcc-15.2.0
arm64                 randconfig-003-20260402    gcc-15.2.0
arm64                 randconfig-004-20260402    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260402    gcc-15.2.0
csky                  randconfig-002-20260402    gcc-15.2.0
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260402    clang-18
hexagon               randconfig-001-20260403    clang-23
hexagon               randconfig-002-20260402    clang-18
hexagon               randconfig-002-20260403    clang-23
i386                             allmodconfig    clang-20
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260402    clang-20
i386        buildonly-randconfig-001-20260403    gcc-14
i386        buildonly-randconfig-002-20260402    clang-20
i386        buildonly-randconfig-002-20260403    gcc-14
i386        buildonly-randconfig-003-20260402    clang-20
i386        buildonly-randconfig-003-20260403    gcc-14
i386        buildonly-randconfig-004-20260402    clang-20
i386        buildonly-randconfig-004-20260403    gcc-14
i386        buildonly-randconfig-005-20260402    clang-20
i386        buildonly-randconfig-005-20260403    gcc-14
i386        buildonly-randconfig-006-20260402    clang-20
i386        buildonly-randconfig-006-20260403    gcc-14
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260402    clang-20
i386                  randconfig-002-20260402    clang-20
i386                  randconfig-003-20260402    clang-20
i386                  randconfig-004-20260402    clang-20
i386                  randconfig-005-20260402    clang-20
i386                  randconfig-006-20260402    clang-20
i386                  randconfig-007-20260402    clang-20
i386                  randconfig-011-20260402    clang-20
i386                  randconfig-012-20260402    clang-20
i386                  randconfig-013-20260402    clang-20
i386                  randconfig-014-20260402    clang-20
i386                  randconfig-015-20260402    clang-20
i386                  randconfig-016-20260402    clang-20
i386                  randconfig-017-20260402    clang-20
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260402    clang-18
loongarch             randconfig-001-20260403    clang-23
loongarch             randconfig-002-20260402    clang-18
loongarch             randconfig-002-20260403    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                                defconfig    clang-19
m68k                        stmark2_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-19
nios2                 randconfig-001-20260402    clang-18
nios2                 randconfig-001-20260403    clang-23
nios2                 randconfig-002-20260402    clang-18
nios2                 randconfig-002-20260403    clang-23
openrisc                         allmodconfig    clang-23
openrisc                          allnoconfig    clang-23
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-19
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260402    clang-20
parisc                randconfig-002-20260402    clang-20
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                     mpc512x_defconfig    clang-23
powerpc               randconfig-001-20260402    clang-20
powerpc               randconfig-002-20260402    clang-20
powerpc64             randconfig-001-20260402    clang-20
powerpc64             randconfig-002-20260402    clang-20
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260402    clang-23
riscv                 randconfig-002-20260402    clang-23
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260402    clang-23
s390                  randconfig-002-20260402    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-19
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260402    clang-23
sh                    randconfig-002-20260402    clang-23
sparc                             allnoconfig    clang-23
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260402    gcc-14
sparc                 randconfig-002-20260402    gcc-14
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260402    gcc-14
sparc64               randconfig-002-20260402    gcc-14
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260402    gcc-14
um                    randconfig-002-20260402    gcc-14
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260402    clang-20
x86_64      buildonly-randconfig-002-20260402    clang-20
x86_64      buildonly-randconfig-003-20260402    clang-20
x86_64      buildonly-randconfig-004-20260402    clang-20
x86_64      buildonly-randconfig-005-20260402    clang-20
x86_64      buildonly-randconfig-006-20260402    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260402    gcc-14
x86_64                randconfig-002-20260402    gcc-14
x86_64                randconfig-003-20260402    gcc-14
x86_64                randconfig-004-20260402    gcc-14
x86_64                randconfig-005-20260402    gcc-14
x86_64                randconfig-006-20260402    gcc-14
x86_64                randconfig-011-20260402    clang-20
x86_64                randconfig-012-20260402    clang-20
x86_64                randconfig-013-20260402    clang-20
x86_64                randconfig-014-20260402    clang-20
x86_64                randconfig-015-20260402    clang-20
x86_64                randconfig-016-20260402    clang-20
x86_64                randconfig-071-20260402    clang-20
x86_64                randconfig-072-20260402    clang-20
x86_64                randconfig-073-20260402    clang-20
x86_64                randconfig-074-20260402    clang-20
x86_64                randconfig-075-20260402    clang-20
x86_64                randconfig-076-20260402    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260402    gcc-14
xtensa                randconfig-002-20260402    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

