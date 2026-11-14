Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B64E8606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CBTECmCH
Received: by kanga.kvack.org (Postfix)
	id 8F16D6B05B0; Fri, 13 Nov 2026 21:15:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874496B05B2; Fri, 13 Nov 2026 21:15:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B976B05B3; Fri, 13 Nov 2026 21:15:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4113C6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:15:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7D88120305
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:15:25 +0000 (UTC)
X-FDA: 85432107810.24.FFFA0A4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 80A1440005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:15:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CBTECmCH;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794622524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9FeubvktBgAETYvC2uxnJ3EvkscANF/vDuXfLb3yfcQ=;
	b=bvyyVr9z1e9ZFRFP0+mXjlW+SntHFjHQt1MhgknJpOXZbMlrzzoj/uVLtWzcjjMTdF9KlK
	e94liInsSD9Z78Q83B4qBYuTvrohH2WVphVJ/UHXNzBJizoNyePAj5tQCGKWUKGAEXzOb/
	VA3fYePwo+8f3vAu0Zk+XSjDiQffqvE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794622524;
	b=b3Ar7eggDAQdvyXFr/lwZrz+3DuPK2qsXahjgFnK2dLDxX/ioTowrBOcD246byuwrGZlE/
	GT9pVax67XMGJKDUuTm4vco041SlC9Es+fnmPuxOtfD0gNR7p46Q6QxwyJ/VnNtBcqu0dR
	qRt8NdMobHi/1xRu4W5SclIGTZ/RuCI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CBTECmCH;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794622523; x=1826158523;
  h=date:from:to:cc:subject:message-id;
  bh=fR7BsFIvcagKeW7TEWSgGeudP2Ms+mLse507gkHfOGU=;
  b=CBTECmCHT7pKlRehOL6Xr9rXvfroRYlWi0pMcslKl8mlqaMZb2PgkPzY
   BDO4GQ6M1SQ6BClOMvrKOSNz5aEG66/MH2K4s0GhsBsE0N5CVUMaA1AAf
   f70ipQEI6rpxRfNe+t9IDKXS1w3jK03g9ODpPyUwYvGS9sYEQZx3zLMM0
   hSONjzMb1Trui5EeO6TkFKmHl/txGALL3ejMIwyrVsgGeZ1xBelT3jZ6E
   YNtbLJzXiQvrlP6bzvutSRJzH/hwjydg9wv7jRhjX3VqgPeaUYHRrCnYY
   Z1HR5/3EpbwD+dIH7mcZkeWmZ+JzrmLz7JTVSf0qIQIPxplxHiZ9Fh0Zp
   A==;
X-CSE-ConnectionGUID: aRf7a/2HSXGs7HxEJwqZwg==
X-CSE-MsgGUID: nKZEEH8PRJ2C73YabSzybw==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3331960"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3331960"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 18:15:22 -0800
X-CSE-ConnectionGUID: 9woqzpGtRhizKUfUkFOVAQ==
X-CSE-MsgGUID: aXcWpbh9RniFOSUdcv74rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="9243540"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 13 Nov 2026 18:15:19 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xS3IT-000000014jT-0K1A;
	Sat, 14 Nov 2026 02:15:17 +0000
Date: Sat, 14 Nov 2026 10:14:53 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 31a696f9c37defab0f28f774e00ac7f135889ec3
Message-ID: <20261114101453.lXVCUJvX-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 80A1440005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: r5cj6zobk4tz1zqmpsjcwyo5m8usxjqt
X-Rspam-User: 
X-HE-Tag: 1794622522-121717
X-HE-Meta: U2FsdGVkX1818UnLku3nawse03TMQWI9WfkJl8GJJ5QpO26KhqJCNcG2OT3qKyTmiuLdUGFivK7TNHqzxlwhMPAErNt7VEvcTyOHAFjbEOgS46m57gJYSfyY5cfFkJ4xEyYJC+0VOhox5Bff6T6swDNiB1PgGsk0fbX0kxvdl87xRX/Z/dLAS0P4ZmnFYI/HjysWV+7dtR602ZyYEIahw+4LP7a1bVXiIUDJSA5Bg70+XAkSN7IkoUjAiR1wZ49v1dPCyWbFz30U+FRCyoYHllE17zURqWIUIs/x6cs6IFiVuKgOe+Q5xALpngIP62GNptapdmRynVQ7UsmafVdLxAEF6o3ZDoqNMOQNav1h+bs6xENFdyY/cJstZuGfesundxrxVsQTDw5RpZZbXF9ZCvhXihfBnFGcPzXnWug48iAFmKrEGc7XjkCwfox3Y4dUo0lJXJjmWW/VtoesRRGnbnW6XKciBQBLyX4d5bkufOamfZPX711QruqNwg4gr/+y8bB8lMKtWzNTu5JQDIXo9ciRqUk+0NDjTSs1lbzllCUz943MGv/+3pjKzAXgggCP4+vZw0k2N2i0S80DTY+uUIAJm2qjAcCpYYgjgFt02q0apEaZlV33jY8hSydXkPKOLDpFIJPI6dU1MYYJMRyzBAd+GiNzQct5CqQN5F/TBIb/EB3qPlGhXa6g5RWp6MymIs2NOweg4hJsCtops6Q0jg2dQ6z0iuc/r9jt2OG0GLDAg0+YknZSNkQYgLy8PlnqJqSCX6Jcoy5wle9FlaqeludfOE4DEMnjOWYU8BZERci0y0wWYSVsKOMpeXfmUByNciVFHdnvpv6WJeJmy1wOi0i1Zo0bkGFIE5NDkOFoOnGNvLV3Cw6whjH0QJswClh1U7VjyZaOSH0hRPtrqppmm4GhbrGlv3mpTHTjlHGBtUyMYCttwlBUk3iuZTjQW+wHoTVlr69O8BRMy5kqeyq
 S6/Jd7H+
 lfbcEFiEwsfwUUZF4t9VyLyqvcZxVuZLfAIE5M6S8qa4a2WSrGwHVWuC90BBacDoL7RdjWvzSKNP/7rEE2e8nTJowSJW6AMSrSYFDKT1Rw73sObOk9agKTICGcdEogosVVdCVS6R2rxV3iL+jqMfVuEHl2Ex+s3pQXHbcF6O5sirLxEa19dNCUCphkgvz3+oDYmJz0im3WLZ5csw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 31a696f9c37defab0f28f774e00ac7f135889ec3  zram: avoid duplicate slots in batched writeback

elapsed time: 1043m

configs tested: 242
configs skipped: 12

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261113    gcc-10.5.0
arc                   randconfig-1000-20261114    clang-24
arc                   randconfig-1001-20261113    gcc-10.5.0
arc                   randconfig-1001-20261114    clang-24
arm                               alldefconfig    gcc-16.2.0
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                      am200epdkit_defconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                             mps2_defconfig    clang-24
arm                   randconfig-1000-20261113    gcc-10.5.0
arm                   randconfig-1000-20261114    clang-24
arm                   randconfig-1001-20261113    gcc-10.5.0
arm                   randconfig-1001-20261114    clang-24
arm                   randconfig-1002-20261113    gcc-10.5.0
arm                   randconfig-1002-20261114    clang-24
arm                   randconfig-1003-20261113    gcc-10.5.0
arm                   randconfig-1003-20261114    clang-24
arm                            sama7_defconfig    gcc-16.2.0
arm                            stm32_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261113    gcc-15.3.0
arm64                 randconfig-1000-20261114    gcc-16.2.0
arm64                 randconfig-1001-20261113    gcc-15.3.0
arm64                 randconfig-1001-20261114    gcc-16.2.0
arm64                 randconfig-1002-20261113    gcc-15.3.0
arm64                 randconfig-1002-20261114    gcc-16.2.0
arm64                 randconfig-1003-20261113    gcc-15.3.0
arm64                 randconfig-1003-20261114    gcc-16.2.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261113    gcc-15.3.0
csky                  randconfig-1000-20261114    gcc-16.2.0
csky                  randconfig-1001-20261113    gcc-15.3.0
csky                  randconfig-1001-20261114    gcc-16.2.0
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261114    clang-24
hexagon               randconfig-1001-20261114    clang-24
i386                              allmodconfig    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386        buildonly-randconfig-1000-20261113    clang-22
i386        buildonly-randconfig-1001-20261113    clang-22
i386        buildonly-randconfig-1002-20261113    clang-22
i386        buildonly-randconfig-1003-20261113    clang-22
i386        buildonly-randconfig-1004-20261113    clang-22
i386        buildonly-randconfig-1005-20261113    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261113    clang-22
i386                  randconfig-1001-20261113    clang-22
i386                  randconfig-1002-20261113    clang-22
i386                  randconfig-1003-20261113    clang-22
i386                  randconfig-1004-20261113    clang-22
i386                  randconfig-1005-20261113    clang-22
i386                  randconfig-1006-20261113    clang-22
i386                  randconfig-1007-20261114    clang-22
i386                  randconfig-1008-20261114    clang-22
i386                  randconfig-1009-20261114    clang-22
i386                  randconfig-1010-20261114    clang-22
i386                  randconfig-1011-20261114    clang-22
i386                  randconfig-1012-20261114    clang-22
i386                  randconfig-1013-20261114    clang-22
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261114    clang-24
loongarch             randconfig-1001-20261114    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                          amcore_defconfig    clang-24
m68k                          amcore_defconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5475evb_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           ath79_defconfig    gcc-16.2.0
mips                   decstation_64_defconfig    gcc-16.2.0
mips                       malta_kvm_defconfig    gcc-16.2.0
mips                         qi_lb60_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261114    clang-24
nios2                 randconfig-1001-20261114    clang-24
openrisc                          alldefconfig    gcc-16.2.0
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-11.5.0
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc                   or1klitex_defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261113    gcc-13.5.0
parisc                randconfig-1000-20261114    gcc-8.5.0
parisc                randconfig-1001-20261113    gcc-13.5.0
parisc                randconfig-1001-20261114    gcc-8.5.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                  canyonlands_defconfig    clang-24
powerpc                   iss476-smp_defconfig    clang-24
powerpc                  mpc8313_rdb_defconfig    gcc-16.2.0
powerpc                       ppc6xx_defconfig    clang-24
powerpc               randconfig-1000-20261113    gcc-13.5.0
powerpc               randconfig-1000-20261114    gcc-8.5.0
powerpc               randconfig-1001-20261113    gcc-13.5.0
powerpc               randconfig-1001-20261114    gcc-8.5.0
powerpc                   storcenter_defconfig    gcc-16.2.0
powerpc                  xes_mpc85xx_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261113    gcc-13.5.0
powerpc64             randconfig-1000-20261114    gcc-8.5.0
powerpc64             randconfig-1001-20261113    gcc-13.5.0
powerpc64             randconfig-1001-20261114    gcc-8.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261113    gcc-12.5.0
riscv                 randconfig-1000-20261114    gcc-15.3.0
riscv                 randconfig-1001-20261113    gcc-12.5.0
riscv                 randconfig-1001-20261114    gcc-15.3.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261113    gcc-12.5.0
s390                  randconfig-1000-20261114    gcc-15.3.0
s390                  randconfig-1001-20261113    gcc-12.5.0
s390                  randconfig-1001-20261114    gcc-15.3.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                                j2_defconfig    clang-24
sh                      magicpanelr2_defconfig    clang-24
sh                           r7780mp_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261113    gcc-12.5.0
sh                    randconfig-1000-20261114    gcc-15.3.0
sh                    randconfig-1001-20261113    gcc-12.5.0
sh                    randconfig-1001-20261114    gcc-15.3.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261113    gcc-8.5.0
sparc                 randconfig-1000-20261114    gcc-12.5.0
sparc                 randconfig-1001-20261113    gcc-8.5.0
sparc                 randconfig-1001-20261114    gcc-12.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261113    gcc-8.5.0
sparc64               randconfig-1000-20261114    gcc-12.5.0
sparc64               randconfig-1001-20261113    gcc-8.5.0
sparc64               randconfig-1001-20261114    gcc-12.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261113    gcc-8.5.0
um                    randconfig-1000-20261114    gcc-12.5.0
um                    randconfig-1001-20261113    gcc-8.5.0
um                    randconfig-1001-20261114    gcc-12.5.0
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261113    clang-22
x86_64      buildonly-randconfig-1001-20261113    clang-22
x86_64      buildonly-randconfig-1002-20261113    clang-22
x86_64      buildonly-randconfig-1003-20261113    clang-22
x86_64      buildonly-randconfig-1004-20261113    clang-22
x86_64      buildonly-randconfig-1005-20261113    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261113    clang-22
x86_64                randconfig-1000-20261114    gcc-14
x86_64                randconfig-1001-20261113    clang-22
x86_64                randconfig-1001-20261114    gcc-14
x86_64                randconfig-1002-20261113    clang-22
x86_64                randconfig-1002-20261114    gcc-14
x86_64                randconfig-1003-20261113    clang-22
x86_64                randconfig-1003-20261114    gcc-14
x86_64                randconfig-1004-20261113    clang-22
x86_64                randconfig-1004-20261114    gcc-14
x86_64                randconfig-1005-20261113    clang-22
x86_64                randconfig-1005-20261114    gcc-14
x86_64                randconfig-1006-20261113    clang-22
x86_64                randconfig-1007-20261113    clang-22
x86_64                randconfig-1008-20261113    clang-22
x86_64                randconfig-1009-20261113    clang-22
x86_64                randconfig-1010-20261113    clang-22
x86_64                randconfig-1011-20261113    clang-22
x86_64                randconfig-1012-20261113    gcc-14
x86_64                randconfig-1012-20261114    clang-22
x86_64                randconfig-1013-20261113    gcc-14
x86_64                randconfig-1013-20261114    clang-22
x86_64                randconfig-1014-20261113    gcc-14
x86_64                randconfig-1014-20261114    clang-22
x86_64                randconfig-1015-20261113    gcc-14
x86_64                randconfig-1015-20261114    clang-22
x86_64                randconfig-1016-20261113    gcc-14
x86_64                randconfig-1016-20261114    clang-22
x86_64                randconfig-1017-20261113    gcc-14
x86_64                randconfig-1017-20261114    clang-22
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-11.5.0
xtensa                randconfig-1000-20261113    gcc-8.5.0
xtensa                randconfig-1000-20261114    gcc-12.5.0
xtensa                randconfig-1001-20261113    gcc-8.5.0
xtensa                randconfig-1001-20261114    gcc-12.5.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

