Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 067D0C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09936B00AA; Thu,  9 Jul 2026 14:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB266B00AB; Thu,  9 Jul 2026 14:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8CD6B00AC; Thu,  9 Jul 2026 14:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 676066B00AA
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:20:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F40DC120196
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:20:10 +0000 (UTC)
X-FDA: 84970052622.13.7BBE598
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf07.hostedemail.com (Postfix) with ESMTP id 470034000B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:20:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iVLf+1SM;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783621209;
	b=pEcQKAPbtq+A32dVTqNrzJGiZV66/DkB5KdUs56huLf7SAL2M9qii3QaZQbL53C7doCw/m
	UcI+//YpRPfslCJUONNXqfdMUiQcSLtgNKyfbkNb8oCGk0B0OcVxf+K1HrJuPmU9Nxbbse
	LSuVkfw/LCbEkYtB3/ySHkWN16Yuafc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iVLf+1SM;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783621209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=V685RW2S7msonmREI5axMTfzhkqs4PxJIRTFlWMsAVA=;
	b=oOxlZYg9gVkIW4/k4Tg6xh1Nb5mOFK/PPQPZW/OCe5IcfFFfORo5wfxnWhvym5g++KJZkL
	4sY4w6OZjQZcaTicD1jJPERdTgKPyhgNaFMoTXAYewHTNJgb6srx2Djl4fWSKuJ1tNwx0D
	PBu1cONLle821CDQtDM/TMmERt9edhE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783621208; x=1815157208;
  h=date:from:to:cc:subject:message-id;
  bh=8gBhi1ORBX+A50QV36hb2+k5R5F4tpqt0htS/u1Moo4=;
  b=iVLf+1SMx5fUWFm4D6CW47uSUAxWeVFCDAxITAQXDQkmYF/1UDoBX+d9
   1Qq/YXylS0Ai+RxTacrQKyq+tFt2PRgpiTVe9WUYT9DyIMRKJIzNEcmb+
   J7x5hKfOaK7pBibIEi0sGLgE5wGD6ZagWVu30Fm62SS1fNHHzqyzlr8cQ
   U6AOzx+eqyGsmrXUvPZAK89jIctS0n1tbJ/n6XbcOzawW2eTdRMkDE4Et
   c0cT0EYVR+9eRxNAaBP9pB68Vrr4tbpaS7Pt56Aa58utc6FmdSw1BC3fW
   J71cCHcgTtieT+16jmzNTnPSn9s7e7y0pa1V1wHbtSecYHDc4bQy7X/e7
   g==;
X-CSE-ConnectionGUID: kwznvJq7ScKaFiO9ZVjVPw==
X-CSE-MsgGUID: F3OSruRPRgiRShH4WZLcaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="95689635"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="95689635"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:20:07 -0700
X-CSE-ConnectionGUID: 8WEgy/CRQYGRGSmXkz334Q==
X-CSE-MsgGUID: 8rIRdb24TR2OTaViBvXNdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="255307540"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 09 Jul 2026 11:20:05 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whtLt-00000000Hz5-3e7W;
	Thu, 09 Jul 2026 18:20:01 +0000
Date: Fri, 10 Jul 2026 02:19:35 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 59e34180e138a293260301c139cf7ee800978533
Message-ID: <202607100221.C2m3eOCN-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 470034000B
X-Stat-Signature: 63zz7t4114rx4iqri8hejam5zx6z8mpk
X-HE-Tag: 1783621208-583174
X-HE-Meta: U2FsdGVkX1+dBaISm4SxMU727Zj0eZOWrwAMiTEzRCh0zq4l4bhfmUKyrrh2OyclSnwgo1CrBkjZR8Lxmm8G8Ip66+V9l/AvLoUO7g5HGjCep9gGIUG2I6/qvPxPqzJd3M3LWKlrM0Eu8ST+w/K8uldAVGbBX/KyBtS+YtiOGn50YyL2ffmUqJB8wumg3i7mQBSQc6RfQxlN8FD8LHteVy3XeoXLNcDCIxe2O7qFg6VgmHULvHDLgc2ar3o9fw45iN6wMnhOVrupdlokAUnOvudUXebj/Jo6QHp2H/rHfrzFM+DWDVrD2uSYqSxNCw0UxXbjHkNeHyM7g2BLzlFs17/5VV2+fHeGbbLXQiVigSfWa0z88VWQIg2fAdJ/Y2QCe5yaIse3jXf1heBSKHQ2CVxAdYN5FGQ+FK8y+oeBJg/EyTGi5Lc6bLWrZ7Ij7NZVA+23qRWsgdf+91d0lMlXBDQA7YKFWkpvEGzzGd4HavHfm0mV5UCn2Y6Yedij2V7mNBAc2DawEdCVNNITP+GTkCeWHrV+7QMpqP7pe7Ebh2ZVLAaXGtlNg7pYC2ClvOYT/l4gLNL8ZOm0/vxDfGTj3oZeY57Nxs5mGXFBRcb9FvIPxvzuyzLz9NT+HgPK1mD/JBfV3I2VBJvrYBTAv7EQEsrIog71+bsVW5kSqx+RoH9zlUs+AY+ODAFdG2qFVgo6s7GZrX16f09cfr7JrtRTNtqEjs1ZWBky4+B5b/AVjKI7pSxvXpXUZ7uxeQv15Q80UFtVJTWRSfTMREyqhCVHe0tniVpi6Qk7O6bbdDt0Uuz2kCGelriaxtNNAyYNWi+su4LeVBI+6S4eHy4XeAQQLkSn6Gq3ZoFjj9DdYI8Wy8bThOiAIVk+vtKTZK8dpDJaok2ew8y6zpwokrcrdX1Axd8adSukymu5Yvci73FlQfQPX7ax5I/C7g3fX3VA9mPNqqEmw+YOaWoXLuueCKn
 CWsZ251x
 vBsBKWppDqUkwJsEx2td6eCcCqgx+ufezNaeq8Esd1CFY6TNcJLFe+cQljhPrZp47OOmAIv+LgDu0UfoQu+vca5QXP7htCGLDhKy4PxqI/tKY2Vzw+nESdvKN2j/yw6mPIAJCk0zbTzcQO9KukX0Y3OCyhcdOZwGME5iCRoYdG/696FC6iUMcj1IEtasoVcCt5sCUBoY5T0+q5MJt/RJU3J4vUw0ZzgjZebNS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 59e34180e138a293260301c139cf7ee800978533  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK-lkp@intel.com

    mm/alloc_tag.c:356:58: error: implicit declaration of function 'compat_ptr' [-Wimplicit-function-declaration]
    mm/alloc_tag.c:472:58: error: implicit declaration of function 'compat_ptr' [-Wimplicit-function-declaration]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- sparc-randconfig-r063-20260709
|   `-- mm-alloc_tag.c:error:implicit-declaration-of-function-compat_ptr
`-- sparc64-randconfig-001-20260709
    `-- mm-alloc_tag.c:error:implicit-declaration-of-function-compat_ptr

elapsed time: 732m

configs tested: 312
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
arc                   randconfig-001-20260709    gcc-8.5.0
arc                   randconfig-002-20260709    gcc-8.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                         at91_dt_defconfig    clang-17
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260709    gcc-8.5.0
arm                   randconfig-002-20260709    gcc-8.5.0
arm                   randconfig-003-20260709    gcc-8.5.0
arm                   randconfig-004-20260709    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260709    clang-22
arm64                 randconfig-001-20260709    gcc-16.1.0
arm64                 randconfig-002-20260709    gcc-16.1.0
arm64                 randconfig-002-20260709    gcc-8.5.0
arm64                 randconfig-003-20260709    clang-22
arm64                 randconfig-003-20260709    gcc-16.1.0
arm64                 randconfig-004-20260709    gcc-16.1.0
arm64                 randconfig-004-20260709    gcc-8.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260709    gcc-14.3.0
csky                  randconfig-001-20260709    gcc-16.1.0
csky                  randconfig-002-20260709    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260709    clang-17
hexagon               randconfig-001-20260709    clang-18
hexagon               randconfig-002-20260709    clang-18
hexagon               randconfig-002-20260709    clang-23
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260709    gcc-14
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260709    gcc-14
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260709    gcc-13
i386        buildonly-randconfig-003-20260709    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260709    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260709    clang-22
i386        buildonly-randconfig-005-20260709    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260709    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260709    clang-22
i386                  randconfig-001-20260709    gcc-14
i386                  randconfig-002-20260709    gcc-14
i386                  randconfig-003-20260709    clang-22
i386                  randconfig-003-20260709    gcc-14
i386                  randconfig-004-20260709    clang-22
i386                  randconfig-004-20260709    gcc-14
i386                  randconfig-005-20260709    gcc-14
i386                  randconfig-006-20260709    gcc-14
i386                  randconfig-007-20260709    clang-22
i386                  randconfig-007-20260709    gcc-14
i386                  randconfig-011-20260709    clang-22
i386                  randconfig-011-20260709    gcc-14
i386                  randconfig-012-20260709    gcc-14
i386                  randconfig-013-20260709    clang-22
i386                  randconfig-013-20260709    gcc-14
i386                  randconfig-014-20260709    gcc-14
i386                  randconfig-015-20260709    clang-22
i386                  randconfig-015-20260709    gcc-14
i386                  randconfig-016-20260709    clang-22
i386                  randconfig-016-20260709    gcc-14
i386                  randconfig-017-20260709    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260709    clang-18
loongarch             randconfig-002-20260709    clang-18
loongarch             randconfig-002-20260709    clang-23
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
m68k                      m54418evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                         10m50_defconfig    gcc-11.5.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260709    clang-18
nios2                 randconfig-001-20260709    gcc-8.5.0
nios2                 randconfig-002-20260709    clang-18
nios2                 randconfig-002-20260709    gcc-8.5.0
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
parisc                randconfig-001-20260709    clang-23
parisc                randconfig-001-20260709    gcc-9.5.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260709    clang-23
parisc                randconfig-002-20260709    gcc-8.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260709    clang-23
powerpc               randconfig-001-20260709    gcc-14.3.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260709    clang-23
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260709    clang-19
powerpc64             randconfig-001-20260709    clang-23
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260709    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-22
riscv                 randconfig-001-20260709    clang-22
riscv                 randconfig-001-20260709    clang-23
riscv                          randconfig-002    clang-22
riscv                 randconfig-002-20260709    clang-22
riscv                 randconfig-002-20260709    gcc-10.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-22
s390                  randconfig-001-20260709    clang-17
s390                  randconfig-001-20260709    clang-22
s390                           randconfig-002    clang-22
s390                  randconfig-002-20260709    clang-22
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    clang-22
sh                    randconfig-001-20260709    clang-22
sh                    randconfig-001-20260709    gcc-16.1.0
sh                             randconfig-002    clang-22
sh                    randconfig-002-20260709    clang-22
sh                    randconfig-002-20260709    gcc-12.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260709    gcc-15.2.0
sparc                 randconfig-001-20260709    gcc-8.5.0
sparc                          randconfig-002    gcc-11.5.0
sparc                 randconfig-002-20260709    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-12.5.0
sparc64               randconfig-001-20260709    gcc-15.2.0
sparc64               randconfig-001-20260709    gcc-8.5.0
sparc64                        randconfig-002    clang-20
sparc64               randconfig-002-20260709    clang-23
sparc64               randconfig-002-20260709    gcc-8.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-23
um                    randconfig-001-20260709    gcc-14
um                    randconfig-001-20260709    gcc-8.5.0
um                             randconfig-002    clang-23
um                    randconfig-002-20260709    clang-23
um                    randconfig-002-20260709    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-12
x86_64      buildonly-randconfig-001-20260709    clang-22
x86_64      buildonly-randconfig-001-20260709    gcc-13
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260709    clang-22
x86_64      buildonly-randconfig-002-20260709    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260709    clang-22
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260709    clang-22
x86_64      buildonly-randconfig-004-20260709    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260709    clang-22
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260709    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260709    clang-22
x86_64                randconfig-001-20260709    gcc-14
x86_64                         randconfig-002    clang-22
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260709    clang-22
x86_64                randconfig-002-20260709    gcc-14
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260709    clang-22
x86_64                randconfig-003-20260709    gcc-14
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260709    clang-22
x86_64                randconfig-004-20260709    gcc-14
x86_64                         randconfig-005    clang-22
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260709    clang-22
x86_64                randconfig-005-20260709    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260709    clang-22
x86_64                randconfig-006-20260709    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260709    clang-22
x86_64                randconfig-011-20260709    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260709    clang-22
x86_64                randconfig-012-20260709    gcc-14
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260709    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260709    clang-22
x86_64                randconfig-014-20260709    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260709    gcc-13
x86_64                randconfig-015-20260709    gcc-14
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260709    clang-22
x86_64                randconfig-016-20260709    gcc-14
x86_64                randconfig-071-20260709    clang-22
x86_64                randconfig-071-20260709    gcc-14
x86_64                randconfig-072-20260709    clang-22
x86_64                randconfig-072-20260709    gcc-14
x86_64                randconfig-073-20260709    clang-22
x86_64                randconfig-073-20260709    gcc-13
x86_64                randconfig-074-20260709    clang-22
x86_64                randconfig-074-20260709    gcc-14
x86_64                randconfig-075-20260709    clang-22
x86_64                randconfig-076-20260709    clang-22
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
xtensa                          iss_defconfig    gcc-16.1.0
xtensa                         randconfig-001    gcc-8.5.0
xtensa                randconfig-001-20260709    gcc-8.5.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                randconfig-002-20260709    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

