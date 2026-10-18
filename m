Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3587CCCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 19:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866556B0093; Sun, 18 Oct 2026 15:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816726B0095; Sun, 18 Oct 2026 15:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C3C6B0096; Sun, 18 Oct 2026 15:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 371BB6B0093
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 15:34:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 718D140206
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:34:28 +0000 (UTC)
X-FDA: 85336748616.22.0E13DA1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3CABD140002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:34:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RfF4aSWF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792352066;
	b=1US9DdoNUilpoc+2ANnAs7dg/4VSTy6HTFU7USzrGnVG8EzDujGUjpvTf92dssebfYob1/
	KB+xqmIPCf1VT/bM37ocEArwFtJkTEt2AnIQJVWdxFZ+4ETy0jBKfQGiuYFTxSXsXy1pVg
	n7hv371rg5YR9GrxCwSU55UObwzQq/o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RfF4aSWF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792352066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=+UsYIsExn4+mU6FfmkPEK53l+f7eZpE1Z0PBXf63w0Y=;
	b=jNr5UrpjYX9sGvxF6x6zfJzxvdKdlTvE6ttcrsxDyONew+58HEEheiuLHQcHJSob1fWGEj
	xPD0t5f4/e7Of2jsrweI6I+RrRLIX295HP+d5xxFROuxrUfaqdI6KEMS1tPG4NyTKlPY5q
	3QYEcsu8mqI0leoaHqLS/Ug2hzz/Kqs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792352066; x=1823888066;
  h=date:from:to:cc:subject:message-id;
  bh=1pkyxdegs9CRpvDC3ugPAJJR/iE9sS/Vk2qPFfN5USg=;
  b=RfF4aSWFGEwUc+GLqEcFlZe54PtgCdY6NwQvNPkOY010b3rU/ykGzb7d
   pm0zkOMQwPBcRdu8bl+Pus5wC+cOjA5Wl2WHviF9HKOMv2VBObL52syQa
   0KLT47EVuPBte4GQ9ZBMdxGvujR/8e77tKz3HcPZJ4gk8MSHFn7BLLrgD
   nWPnsFipyxZBj2TeuPtu+QBgI2uuej0MoxLOpK3qq/jXwV5LJ7lSZry6J
   JwuFTXzTlpQBfKH6eT8wqRl+QUcHZd51k8VdAy51np1t8Vu01YXyOoikB
   DN1xTuEiXKzmZWCAkj+wUddw3iQJYV2wChLeNWz18JhRyg5NTPv93ysE4
   g==;
X-CSE-ConnectionGUID: R71nyNw2SWKqKJO1zL7nuw==
X-CSE-MsgGUID: DN2TRVyZT66dIskpsaAZ4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="927423"
X-IronPort-AV: E=Sophos;i="6.27,166,1787036400"; 
   d="scan'208";a="927423"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2026 12:34:24 -0700
X-CSE-ConnectionGUID: qPW+b/EFSrmq3ebZSOo9ww==
X-CSE-MsgGUID: OVA4mWqIQ36e6zE6hjWz+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,166,1787036400"; 
   d="scan'208";a="2255135"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 18 Oct 2026 12:34:22 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIWeB-00000000KkQ-1ned;
	Sun, 18 Oct 2026 19:34:19 +0000
Date: Mon, 19 Oct 2026 03:33:39 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 48fe11c8d0f1e4e59426a3606f20ac1130b6d8dc
Message-ID: <202610190335.lcT6OnpY-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 3CABD140002
X-Stat-Signature: 5z4bd1m96k1nfwe1edxgf77raux4d8ig
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792352064-403055
X-HE-Meta: U2FsdGVkX19J/B4lL3+qOONldK146A9/9lcZNOgHnFZbpF/nBRHd+xbiZTpMisuL2yCcFKcLHwTtIfm2vTAYCbsUj7EBfwnJ5kSWNZILnWGOSUobNih6gq0Yciyj9ehiso6IuHINqF0HoKM+D7u0GyIY/cTqUn3JrwWvcMUCOMxVbbhVri9WoNnOcDs5YZGlSmhzFHXX/PtvfG3LQ9Pj//Zm2XviLfRFezyXUgUKMCwSRfhyct9koP/spZlR9P23IwqaBcqV1AXImsV9MG+bnTJSUDiGtqJbitICHSqBmvjWHfZMLn6JNcvMI1wv8wEg4ttg5XbTUzs8COTEjv9hyMB828EL1lKP2TZOZMK1JoXVeGYYdk5f8K5cIOjbB12r9Y6BEBlfgdSAfJswhWO2/V9O36SP6se0HQ9k6HbWe27Dy6Vw3vJNcQGsXK+8/aKjZ1FP4U+QxgvdihmnD3+0nV0lOYfM7bvl6vdMDXyDYeVI1BnKhvbLiRyR/8KpZ72iLjdddIkHlBq//Bfq+mmrS0w4llSQ8Zfy6AHL2ZaXNRcBppIfv0a6RIDlWBkL243zgtdH//FSTMLa4Oz4xjARMd8zd9D+KlzgECsNNWpmMy1e0KXxRK/byI+dB8H0wD4VqX/Pgzqo3KXoEWKyLa3KLe/gbSVabVsbCdqngESWXgX0+J7DqqWyhsKifyYCxI02j7bstCqK4joMEHGli+dpspGdS7mddugrNnhj9axmVVwaGn0ezplgz2mxVFNk/LY/P1ZaACZfIXBI8jb5rtt4CoJiLpyUs5mOg4DVlpk2hRcGlWIYQQR6xK/roMZtTZiQtWkjS/0uZ1iJV2uycZq4SU3K11cbdBqpr352KRUQGVnIyPsx2U2ai7OOEpGabRWlZYEQ7i1LyEf5nSxns5aqp6SLpOWJW0SPcRhpR9DkiHxqHVyDPsn0ow7qP3VL1JCwpSGHtIPAVtV1BzI32Z4
 PlegdIOI
 Wb78HPIRmAmAByqlmVkslMmsWSWxSZgdigaUPLT5nwlOatPrq3lhkZ7pn2yv9iP3s6gnJYdwprHTB2w5EzVvzPNo5Ya8VzCObeog6Nivwdc1/hQOCJOhxeyAAffo9zHzTDSNP58h/qVFO01wFp73BqoyUyEs1ArB7Xx7065OWnTzPsbkeZOQtuOOFm7CFUDF9fciuTE7lvjS6XFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 48fe11c8d0f1e4e59426a3606f20ac1130b6d8dc  riscv: mm: exclude invalid THP PMDs from page table check

elapsed time: 829m

configs tested: 221
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             alldefconfig    gcc-16.1.0
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2311-20261018    gcc-11.5.0 sparse
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261018    gcc-11.5.0
arc                   randconfig-1001-20261018    gcc-8.5.0
arc                   randconfig-2000-20261018    gcc-8.5.0
arc                   randconfig-2001-20261018    gcc-10.5.0
arc                  randconfig-r2106-20261018    gcc-15.2.0 cocci
arc                  randconfig-r2304-20261018    gcc-8.5.0  sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                           ep93xx_defconfig    clang-24
arm                   randconfig-1000-20261018    gcc-8.5.0
arm                   randconfig-1001-20261018    clang-19
arm                   randconfig-1002-20261018    gcc-8.5.0
arm                   randconfig-1003-20261018    gcc-11.5.0
arm                   randconfig-2000-20261018    clang-24
arm                   randconfig-2001-20261018    clang-17
arm                  randconfig-r2105-20261018    gcc-8.5.0  cocci
arm                  randconfig-r2110-20261018    clang-17   cocci
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261018    gcc-8.5.0
arm64                 randconfig-1001-20261018    gcc-14.3.0
arm64                 randconfig-1002-20261018    gcc-12.5.0
arm64                 randconfig-1003-20261018    clang-19
arm64                 randconfig-2000-20261018    gcc-11.5.0
arm64                 randconfig-2001-20261018    gcc-13.4.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261018    gcc-15.2.0
csky                  randconfig-1001-20261018    gcc-13.4.0
csky                  randconfig-2000-20261018    gcc-12.5.0
csky                  randconfig-2001-20261018    gcc-14.3.0
csky                 randconfig-r2309-20261018    gcc-16.1.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261018    clang-24
hexagon               randconfig-1001-20261018    clang-21
hexagon               randconfig-2000-20261018    clang-24
hexagon               randconfig-2001-20261018    clang-24
hexagon              randconfig-r2100-20261018    clang-24   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261018    clang-22
i386        buildonly-randconfig-1001-20261018    clang-22
i386        buildonly-randconfig-1002-20261018    clang-22
i386        buildonly-randconfig-1003-20261018    clang-22
i386        buildonly-randconfig-1004-20261018    gcc-14
i386        buildonly-randconfig-1005-20261018    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261018    gcc-14
i386                  randconfig-1001-20261018    gcc-14
i386                  randconfig-1002-20261018    clang-22
i386                  randconfig-1003-20261018    clang-22
i386                  randconfig-1004-20261018    clang-22
i386                  randconfig-1005-20261018    gcc-14
i386                  randconfig-1006-20261018    gcc-14
i386                  randconfig-1007-20261018    clang-22
i386                  randconfig-1008-20261018    clang-22
i386                  randconfig-1009-20261018    clang-22
i386                  randconfig-1010-20261018    gcc-14
i386                  randconfig-1011-20261018    gcc-14
i386                  randconfig-1012-20261018    gcc-14
i386                  randconfig-1013-20261018    clang-22
i386                  randconfig-2000-20261018    clang-22
i386                  randconfig-2001-20261018    gcc-14
i386                  randconfig-2200-20261018    gcc-14     smatch
i386                  randconfig-2300-20261018    gcc-14     sparse
i386                  randconfig-2302-20261018    clang-22   sparse
i386                 randconfig-r2308-20261018    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261018    clang-24
loongarch             randconfig-1001-20261018    clang-18
loongarch             randconfig-2000-20261018    clang-24
loongarch             randconfig-2001-20261018    clang-24
loongarch            randconfig-r2303-20261018    gcc-13.4.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2101-20261018    gcc-10.5.0 cocci
m68k                 randconfig-r2111-20261018    gcc-8.5.0  cocci
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2103-20261018    gcc-8.5.0  cocci
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                 randconfig-r2200-20261018    clang-24   smatch
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261018    gcc-11.5.0
nios2                 randconfig-1001-20261018    gcc-11.5.0
nios2                 randconfig-2000-20261018    gcc-11.5.0
nios2                 randconfig-2001-20261018    gcc-10.5.0
nios2                randconfig-r2300-20261018    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2104-20261018    gcc-16.1.0 cocci
openrisc             randconfig-r2305-20261018    gcc-11.5.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261018    gcc-13.4.0
parisc                randconfig-1001-20261018    gcc-11.5.0
parisc                randconfig-2000-20261018    gcc-14.3.0
parisc                randconfig-2001-20261018    gcc-12.5.0
parisc64                             defconfig    gcc-16.1.0
powerpc                      akebono_defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                       cm5200_defconfig    clang-24
powerpc                  mpc836x_rdk_defconfig    clang-24
powerpc                       pasemi_defconfig    clang-24
powerpc               randconfig-1000-20261018    clang-24
powerpc               randconfig-1001-20261018    clang-24
powerpc               randconfig-2000-20261018    gcc-9.5.0
powerpc               randconfig-2001-20261018    gcc-8.5.0
powerpc              randconfig-r2202-20261018    clang-20   smatch
powerpc64             randconfig-1000-20261018    gcc-16.1.0
powerpc64             randconfig-1001-20261018    clang-24
powerpc64             randconfig-2001-20261018    gcc-10.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261019    gcc-11.5.0
riscv                 randconfig-1001-20261019    gcc-9.5.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261019    gcc-8.5.0
s390                  randconfig-1001-20261019    gcc-9.5.0
s390                 randconfig-r2108-20261018    gcc-8.5.0  cocci
s390                 randconfig-r2302-20261018    gcc-15.2.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261019    gcc-10.5.0
sh                    randconfig-1001-20261019    gcc-16.2.0
sh                    randconfig-2000-20261018    gcc-12.5.0
sh                    randconfig-2001-20261018    gcc-10.5.0
sh                            se7750_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261018    gcc-8.5.0
sparc                 randconfig-1001-20261018    gcc-13.4.0
sparc                 randconfig-2001-20261018    gcc-8.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261018    gcc-10.5.0
sparc64               randconfig-1001-20261018    clang-24
sparc64               randconfig-2001-20261018    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261018    clang-19
um                    randconfig-1001-20261018    gcc-14
um                    randconfig-2000-20261018    gcc-14
um                    randconfig-2001-20261018    clang-18
um                   randconfig-r2310-20261018    clang-22   sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261018    gcc-14
x86_64      buildonly-randconfig-1001-20261018    clang-22
x86_64      buildonly-randconfig-1002-20261018    clang-22
x86_64      buildonly-randconfig-1003-20261018    clang-22
x86_64      buildonly-randconfig-1004-20261018    gcc-14
x86_64      buildonly-randconfig-1005-20261018    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261018    clang-22
x86_64                randconfig-1001-20261018    gcc-14
x86_64                randconfig-1002-20261018    gcc-13
x86_64                randconfig-1003-20261018    gcc-14
x86_64                randconfig-1004-20261018    clang-22
x86_64                randconfig-1005-20261018    gcc-14
x86_64                randconfig-1006-20261018    clang-22
x86_64                randconfig-1007-20261018    clang-22
x86_64                randconfig-1008-20261018    gcc-14
x86_64                randconfig-1009-20261018    gcc-14
x86_64                randconfig-1010-20261018    gcc-14
x86_64                randconfig-1011-20261018    gcc-14
x86_64                randconfig-1012-20261018    clang-22
x86_64                randconfig-1013-20261018    gcc-14
x86_64                randconfig-1014-20261018    gcc-14
x86_64                randconfig-1015-20261018    gcc-14
x86_64                randconfig-1016-20261018    clang-22
x86_64                randconfig-1017-20261018    gcc-14
x86_64                randconfig-2200-20261018    gcc-14     smatch
x86_64                randconfig-2300-20261018    gcc-14     sparse
x86_64                randconfig-2301-20261018    gcc-14     sparse
x86_64                randconfig-2302-20261018    gcc-14     sparse
x86_64               randconfig-r2301-20261018    clang-22   sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20261018    gcc-8.5.0
xtensa                randconfig-1001-20261018    gcc-15.2.0
xtensa               randconfig-r2102-20261018    gcc-8.5.0  cocci
xtensa                     xip_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

