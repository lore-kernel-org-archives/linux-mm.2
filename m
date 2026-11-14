Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318EF606A330
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PUjp8QvH
Received: by kanga.kvack.org (Postfix)
	id 59BC86B05D2; Sat, 14 Nov 2026 02:39:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BA06B05D5; Sat, 14 Nov 2026 02:39:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461F76B05DD; Sat, 14 Nov 2026 02:39:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7896B05D5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:39:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9ED31140383
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:39:04 +0000 (UTC)
X-FDA: 85432923408.21.114FAD1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf25.hostedemail.com (Postfix) with ESMTP id 19522A0002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:39:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PUjp8QvH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794641942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=u5fbqJZqUQIQQuhJIRc0y4RCEZQ0IdjiumVQHNVjXEk=;
	b=zRC8LZtD3XlINZg7unFHP4worAzq1mvAxmlaOuRqbu/bg9URxLpq2UD5dQEY7L4Nly60xh
	qScEcNHpCFNCo7ZmzEvze+kffsotXgp1G3vFp1Hi/KaTP/TiQ7+hxN+jTh4/2zMpwIYf2P
	KCZQMgQBd5Uhwfj6wujUo20MeTtmrGM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PUjp8QvH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794641942;
	b=Hz1EMeKmamNT9fRXGfCkcIlswR9xYBvIeOPOowkqUzryIjqVCDX/7+Dl8fKCn0iEsRWU/1
	iqzB5xWu8HNcoG8qb+OazggQMff13gS5RygmW/ow5RmLxUx6S1kL6b5SCRKdXxR8RREqRQ
	I22UgRGz6jDCxMGexMJdiqtBNbi1sk8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794641942; x=1826177942;
  h=date:from:to:cc:subject:message-id;
  bh=AqoJ2fhbWb3UdE4ZpN7cWLtXLZ5V/iIOSZ29Bivbgr0=;
  b=PUjp8QvHcedJNEcviUh6TVmJILg3aVgaRCIzxUF9ePZkQq5RSLVQaKri
   CkL+V8bsYP5o2RvqUCy6LTcUeWc78Aq9BmSOcjWD4rBp7PITad8GI7qff
   R0K8MBwFk8ixkLvJmfqrbBcq5k2TLaGYBEQML94xO2lqnuLWlvnYTpJON
   gUrQ8NRtaUXqjAls8+Wf1Bit8/uAdYNwkEV3rQaDKE8XI+SIe6OzTjG/e
   Pd7EV6vHNQ2SzyuFF0G36sVWGstKchgM5pj+Q6EzVxHUocDl64JCFvsGV
   NHqNtMmzs/m2HGu+5EKoCBUwyBxB0YZbpplcJk8F7/oMoEYhlu4mN9XAW
   Q==;
X-CSE-ConnectionGUID: mWhLlVElSV6Gy7lTuGtjBg==
X-CSE-MsgGUID: GcLJVPluTTGtXQ6QZM0IUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3525351"
X-IronPort-AV: E=Sophos;i="6.27,213,1787036400"; 
   d="scan'208";a="3525351"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 23:39:01 -0800
X-CSE-ConnectionGUID: ncoYh5CuQ/W5vOWYgFsN3g==
X-CSE-MsgGUID: HSZVKRfCQEeUlFJRpkTTkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,213,1787036400"; 
   d="scan'208";a="9362430"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 13 Nov 2026 23:38:59 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xS8Lg-0000000156s-2gAv;
	Sat, 14 Nov 2026 07:38:56 +0000
Date: Sat, 14 Nov 2026 15:38:29 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 6d582d78fad9d828e575ca0cdcff8ea47a77220b
Message-ID: <20261114153829.5Udj5fyT-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 19522A0002
X-Stat-Signature: by9pxrjaqhkxbuxwa3qjfz3ecp3wdoya
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794641941-81267
X-HE-Meta: U2FsdGVkX1+EgdjlOYoKIO0M89qpo2libXwePb2uD80Px/5GQ3RyhJakX4oVmQ0eR+E/s/DV19s1mEmKt1kxML2sCL+hVg/DK+a1HGWKqhqZjhGGzeB9oh+dmEw0WJfStAmjUKo5q03guaH350OsZHlIgzyGfWAp9vKjfRhGz4Wqnvu1aDXQu2hKQjbOzkdxpzbR460s0iED+9GvvcItk061y3ktNiXyg2J4pFAFqyrHHSHaUThUdj6nuP/waQcd0YtXN/UQSXQo0BwapruJnhY4Kpr5Yw/jti5tuqDD63h/tFO3mYnxrF/ifXxdpfflqv62uxuUcbJM93IR0THoImJtFULnOoS3mQXzHkU7HzpwU9M/mT6rKh7y1q+IBCEwYa3frk25Po4qBuV9mnrYXS5znsSf9WkOimFQFG4k2pcf19GozxqFxHQNAYT2FKc0VvrSe5BJxifaJ1E4SP+TXRmkt+PJhH7ISjYMyHkjR5CwOia0B7XlH8fWqMsyfbDWv0QWopLJ+NyUwoo88swhsoxjEyki3dkwDKWpBjk5ZN8w+RJv6vrCiH6CPJQmlfPqToU8BmhIBranDYLlx5ujsJRHER6OqQ8ZqgdBF3e3WuBKKg2ZoCzpzNezOhARcwWSgtIOtnkATmATJSJntDE+fo82gDO/yrTBSolju9Y2IVa1HcYhjAeqxarfM179FO1D9psXjwNFqDNbXTq2MPX50oWHS5UJK5Gze7EJzvDuPcybOr8++l2IYYujpzrSLRC/GzPkj9Pg079S6g3StwHSIOS68+UDroN1JRvio3gwfO7Lx0679NFYYkk80ZyInaZzZe3j/1UqlHE8fNfNA5Zd0TPQObmZdD/RHuu0rBXjqKzeAEUA5BmjNxvvBI1KMGE5NbAgszcebihqYMhrzfLEIfMLYyNW2+2Xo+V3uF6tUNEp3kC+wY3yzUCpGh2he/8DJ8SV8f94hNJ2Tlk4M53
 QSUbyWKA
 ivoIKYCHDpNLB+YWP3qA1dIW2VJ/e2n0FgaIL+jlOZ82lhTt9TGhA8dfRV6CjmRZz6EV3OC2u09CuWYtBMMQ1WJN5SuCX2EUIS59N68vstCjzy/uSBJHr8uWif2gaEPHgjFWJH9t1jHPo3TrsiMaIuQPisYjE/k4VPmTAPoHGQxEaDFlzCcVNGN3+Bch3dQr8sPgTrOgN0ICO5K4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 6d582d78fad9d828e575ca0cdcff8ea47a77220b  Add linux-next specific files for 20261112

Error/Warning (recently discovered and may have been fixed):

    arc-linux-ld: drivers/leds/rgb/leds-asus-aura-scsi.c:391: undefined reference to `scsi_register_device_handler'

Unverified Error/Warning (likely false positive, kindly check if interested):

    kernel/bpf/liveness.c:2135:1: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-2003-20261113
|   `-- arc-linux-ld:drivers-leds-rgb-leds-asus-aura-scsi.c:undefined-reference-to-scsi_register_device_handler
`-- x86_64-dcg_x86_64_defconfig-func
    `-- kernel-bpf-liveness.c:warning:the-frame-size-of-bytes-is-larger-than-bytes

elapsed time: 1478m

configs tested: 383
configs skipped: 4

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261112    gcc-10.5.0
alpha                 randconfig-2000-20261112    gcc-13.5.0
alpha                 randconfig-2001-20261112    gcc-10.5.0
alpha                 randconfig-2001-20261112    gcc-8.5.0
alpha                 randconfig-2200-20261112    gcc-15.3.0 smatch
alpha                randconfig-r2102-20261112    gcc-16.2.0 cocci
alpha                randconfig-r2302-20261112    gcc-8.5.0  sparse
alpha                randconfig-r2307-20261112    gcc-13.5.0 sparse
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                             hsdk_defconfig    clang-24
arc                   randconfig-1000-20261114    clang-24
arc                   randconfig-1001-20261114    clang-24
arc                   randconfig-2000-20261112    gcc-8.5.0
arc                   randconfig-2001-20261112    gcc-8.5.0
arc                   randconfig-2002-20261112    gcc-8.5.0
arc                   randconfig-2003-20261112    gcc-11.5.0
arc                   randconfig-2003-20261112    gcc-8.5.0
arc                   randconfig-2004-20261112    gcc-13.5.0
arc                   randconfig-2004-20261112    gcc-8.5.0
arc                   randconfig-2005-20261112    gcc-15.3.0
arc                   randconfig-2005-20261112    gcc-8.5.0
arc                   randconfig-2200-20261112    gcc-8.5.0  smatch
arc                  randconfig-r2103-20261112    gcc-16.2.0 cocci
arm                               alldefconfig    clang-24
arm                                allnoconfig    gcc-16.2.0
arm                        aspeed_g5_defconfig    clang-24
arm                          bcm2835_defconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                           moxart_defconfig    clang-24
arm                         multi_v5_defconfig    clang-24
arm                           pxa3xx_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261114    clang-24
arm                   randconfig-1001-20261114    clang-24
arm                   randconfig-1002-20261114    clang-24
arm                   randconfig-1003-20261114    clang-24
arm                   randconfig-2000-20261112    gcc-11.5.0
arm                   randconfig-2001-20261112    gcc-11.5.0
arm                   randconfig-2001-20261112    gcc-13.5.0
arm                   randconfig-2002-20261112    clang-24
arm                   randconfig-2002-20261112    gcc-11.5.0
arm                   randconfig-2200-20261112    gcc-10.5.0 smatch
arm                  randconfig-r2101-20261112    gcc-11.5.0 cocci
arm                  randconfig-r2308-20261112    clang-24   sparse
arm                  randconfig-r2310-20261112    gcc-8.5.0  sparse
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261114    gcc-16.2.0
arm64                 randconfig-1001-20261114    gcc-16.2.0
arm64                 randconfig-1002-20261114    gcc-16.2.0
arm64                 randconfig-1003-20261114    gcc-16.2.0
arm64                 randconfig-2000-20261112    clang-17
arm64                 randconfig-2000-20261112    gcc-11.5.0
arm64                 randconfig-2001-20261112    clang-24
arm64                 randconfig-2001-20261112    gcc-11.5.0
arm64                 randconfig-2002-20261112    clang-24
arm64                 randconfig-2002-20261112    gcc-11.5.0
arm64                 randconfig-2200-20261112    clang-24   smatch
arm64                randconfig-r2302-20261112    gcc-8.5.0  sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261114    gcc-16.2.0
csky                  randconfig-1001-20261114    gcc-16.2.0
csky                  randconfig-2000-20261112    gcc-16.2.0
csky                  randconfig-2001-20261112    gcc-16.2.0
csky                  randconfig-2200-20261112    gcc-11.5.0 smatch
csky                 randconfig-r2107-20261112    gcc-16.2.0 cocci
csky                 randconfig-r2111-20261112    gcc-16.2.0 cocci
csky                 randconfig-r2301-20261112    gcc-8.5.0  sparse
csky                 randconfig-r2309-20261112    gcc-14     sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261114    clang-24
hexagon               randconfig-1001-20261114    clang-24
hexagon               randconfig-2000-20261112    clang-24
hexagon               randconfig-2000-20261112    gcc-16.2.0
hexagon               randconfig-2001-20261112    clang-24
hexagon               randconfig-2001-20261112    gcc-16.2.0
hexagon               randconfig-2200-20261112    clang-22   smatch
hexagon              randconfig-r2105-20261112    gcc-16.2.0 cocci
hexagon              randconfig-r2106-20261112    gcc-12.5.0 cocci
hexagon              randconfig-r2302-20261112    clang-24   sparse
i386                               allnoconfig    gcc-16.2.0
i386        buildonly-randconfig-1000-20261114    gcc-14
i386        buildonly-randconfig-1001-20261114    gcc-14
i386        buildonly-randconfig-1002-20261114    gcc-14
i386        buildonly-randconfig-1003-20261114    gcc-14
i386        buildonly-randconfig-1004-20261114    gcc-14
i386        buildonly-randconfig-1005-20261114    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261114    gcc-12
i386                  randconfig-1001-20261114    gcc-12
i386                  randconfig-1002-20261114    gcc-12
i386                  randconfig-1003-20261114    gcc-12
i386                  randconfig-1004-20261114    gcc-12
i386                  randconfig-1005-20261114    gcc-12
i386                  randconfig-1006-20261114    gcc-12
i386                  randconfig-1007-20261114    clang-22
i386                  randconfig-1008-20261114    clang-22
i386                  randconfig-1009-20261114    clang-22
i386                  randconfig-1010-20261114    clang-22
i386                  randconfig-1011-20261114    clang-22
i386                  randconfig-1012-20261114    clang-22
i386                  randconfig-1013-20261114    clang-22
i386                  randconfig-2000-20261112    gcc-13
i386                  randconfig-2000-20261112    gcc-14
i386                  randconfig-2001-20261112    gcc-14
i386                  randconfig-2002-20261112    gcc-14
i386                  randconfig-2003-20261112    clang-22
i386                  randconfig-2003-20261112    gcc-14
i386                  randconfig-2004-20261112    gcc-14
i386                  randconfig-2005-20261112    clang-22
i386                  randconfig-2005-20261112    gcc-14
i386                  randconfig-2100-20261112    clang-22   cocci
i386                  randconfig-2101-20261112    clang-22   cocci
i386                  randconfig-2102-20261112    clang-22   cocci
i386                  randconfig-2103-20261112    clang-22   cocci
i386                  randconfig-2104-20261112    clang-22   cocci
i386                  randconfig-2105-20261112    clang-22   cocci
i386                  randconfig-2200-20261112    gcc-14     smatch
i386                  randconfig-2300-20261112    clang-22   sparse
i386                  randconfig-2301-20261112    clang-22   sparse
i386                  randconfig-2302-20261112    clang-22   sparse
i386                  randconfig-2302-20261112    gcc-14     sparse
i386                 randconfig-r2106-20261112    gcc-16.2.0 cocci
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261114    clang-24
loongarch             randconfig-1001-20261114    clang-24
loongarch             randconfig-2000-20261112    gcc-9.5.0
loongarch             randconfig-2001-20261112    gcc-9.5.0
loongarch             randconfig-2200-20261112    clang-24   smatch
loongarch            randconfig-r2100-20261112    gcc-11.5.0 cocci
loongarch            randconfig-r2303-20261112    gcc-8.5.0  sparse
loongarch            randconfig-r2306-20261112    gcc-14     sparse
loongarch            randconfig-r2306-20261112    gcc-14.4.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                          amcore_defconfig    clang-24
m68k                                 defconfig    clang-24
m68k                         m5407c3_defconfig    clang-24
m68k                         mvme16x_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261112    gcc-10.5.0
m68k                  randconfig-2000-20261112    gcc-16.2.0
m68k                  randconfig-2001-20261112    gcc-10.5.0
m68k                  randconfig-2200-20261112    gcc-14.4.0 smatch
m68k                 randconfig-r2101-20261112    gcc-16.2.0 cocci
m68k                 randconfig-r2109-20261112    gcc-16.2.0 cocci
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261112    gcc-10.5.0
microblaze            randconfig-2000-20261112    gcc-9.5.0
microblaze            randconfig-2001-20261112    gcc-10.5.0
microblaze            randconfig-2001-20261112    gcc-8.5.0
microblaze            randconfig-2200-20261112    gcc-15.3.0 smatch
microblaze           randconfig-r2108-20261112    gcc-16.2.0 cocci
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                            gcw0_defconfig    clang-24
mips                            ip32_defconfig    gcc-16.2.0
mips                            jazz_defconfig    clang-24
mips                     maltaup_xpa_defconfig    gcc-16.2.0
mips                  randconfig-2000-20261112    gcc-13.5.0
mips                  randconfig-2001-20261112    gcc-13.5.0
mips                  randconfig-2002-20261112    gcc-13.5.0
mips                  randconfig-2200-20261112    gcc-13.5.0 smatch
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261114    clang-24
nios2                 randconfig-1001-20261114    clang-24
nios2                 randconfig-2000-20261112    gcc-9.5.0
nios2                 randconfig-2001-20261112    gcc-9.5.0
nios2                 randconfig-2200-20261112    gcc-11.5.0 smatch
nios2                randconfig-r2110-20261112    gcc-16.2.0 cocci
nios2                randconfig-r2304-20261112    gcc-10.5.0 sparse
nios2                randconfig-r2305-20261112    gcc-11.5.0 sparse
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261112    gcc-13.5.0
openrisc              randconfig-2001-20261112    gcc-13.5.0
openrisc              randconfig-2002-20261112    gcc-13.5.0
openrisc              randconfig-2200-20261112    gcc-16.2.0 smatch
openrisc             randconfig-r2104-20261112    gcc-11.5.0 cocci
openrisc             randconfig-r2107-20261112    gcc-12.5.0 cocci
openrisc             randconfig-r2301-20261112    clang-24   sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261114    gcc-8.5.0
parisc                randconfig-1001-20261114    gcc-8.5.0
parisc                randconfig-2000-20261112    gcc-9.5.0
parisc                randconfig-2001-20261112    gcc-9.5.0
parisc                randconfig-2200-20261112    gcc-8.5.0  smatch
parisc               randconfig-r2102-20261112    gcc-11.5.0 cocci
parisc               randconfig-r2305-20261112    gcc-8.5.0  sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                  canyonlands_defconfig    clang-24
powerpc                         cell_defconfig    gcc-16.2.0
powerpc                       cm5200_defconfig    clang-24
powerpc                      mpc5200_defconfig    clang-24
powerpc                     mvme5100_defconfig    clang-24
powerpc               randconfig-1000-20261114    gcc-8.5.0
powerpc               randconfig-1001-20261114    gcc-8.5.0
powerpc               randconfig-2000-20261112    clang-17
powerpc               randconfig-2001-20261112    clang-17
powerpc               randconfig-2002-20261112    clang-17
powerpc               randconfig-2200-20261112    clang-24   smatch
powerpc              randconfig-r2109-20261112    gcc-12.5.0 cocci
powerpc              randconfig-r2310-20261112    gcc-14     sparse
powerpc                     sam440ep_defconfig    gcc-16.2.0
powerpc                   storcenter_defconfig    clang-24
powerpc                      tqm8540_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261114    gcc-8.5.0
powerpc64             randconfig-1001-20261114    gcc-8.5.0
powerpc64             randconfig-2000-20261112    clang-17
powerpc64             randconfig-2001-20261112    clang-17
powerpc64             randconfig-2002-20261112    clang-17
powerpc64            randconfig-r2110-20261112    gcc-12.5.0 cocci
powerpc64            randconfig-r2300-20261112    clang-24   sparse
powerpc64            randconfig-r2304-20261112    clang-24   sparse
powerpc64            randconfig-r2307-20261112    gcc-14     sparse
powerpc64            randconfig-r2308-20261112    gcc-14     sparse
riscv                             alldefconfig    gcc-16.2.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-2000-20261112    clang-19
riscv                 randconfig-2001-20261112    clang-19
riscv                 randconfig-2002-20261112    clang-19
riscv                 randconfig-2003-20261112    clang-19
riscv                 randconfig-2004-20261112    clang-19
riscv                 randconfig-2005-20261112    clang-19
riscv                 randconfig-2200-20261112    clang-24   smatch
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-2000-20261112    clang-24
s390                  randconfig-2000-20261112    gcc-16.2.0
s390                  randconfig-2001-20261112    clang-17
s390                  randconfig-2001-20261112    clang-24
s390                  randconfig-2002-20261112    clang-24
s390                  randconfig-2002-20261112    gcc-12.5.0
s390                  randconfig-2003-20261112    clang-24
s390                  randconfig-2003-20261112    gcc-10.5.0
s390                  randconfig-2004-20261112    clang-24
s390                  randconfig-2004-20261112    gcc-12.5.0
s390                  randconfig-2005-20261112    clang-24
s390                  randconfig-2200-20261112    clang-24   smatch
s390                 randconfig-r2104-20261112    gcc-16.2.0 cocci
s390                 randconfig-r2105-20261112    gcc-11.5.0 cocci
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                   defconfig    gcc-14
sh                    randconfig-2000-20261112    gcc-16.2.0
sh                    randconfig-2000-20261112    gcc-9.5.0
sh                    randconfig-2001-20261112    gcc-15.3.0
sh                    randconfig-2001-20261112    gcc-16.2.0
sh                    randconfig-2002-20261112    gcc-16.2.0
sh                    randconfig-2002-20261112    gcc-9.5.0
sh                    randconfig-2003-20261112    gcc-16.2.0
sh                    randconfig-2004-20261112    gcc-16.2.0
sh                    randconfig-2005-20261112    gcc-16.2.0
sh                    randconfig-2200-20261112    gcc-16.2.0 smatch
sh                   randconfig-r2300-20261112    gcc-15.3.0 sparse
sh                   randconfig-r2304-20261112    gcc-8.5.0  sparse
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261114    gcc-12.5.0
sparc                 randconfig-1001-20261114    gcc-12.5.0
sparc                 randconfig-2000-20261112    clang-24
sparc                 randconfig-2000-20261112    gcc-8.5.0
sparc                 randconfig-2001-20261112    clang-24
sparc                 randconfig-2001-20261112    gcc-11.5.0
sparc                 randconfig-2200-20261112    gcc-11.5.0 smatch
sparc                randconfig-r2103-20261112    gcc-11.5.0 cocci
sparc                randconfig-r2303-20261112    gcc-13.5.0 sparse
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261114    gcc-12.5.0
sparc64               randconfig-1001-20261114    gcc-12.5.0
sparc64               randconfig-2000-20261112    clang-24
sparc64               randconfig-2001-20261112    clang-24
sparc64               randconfig-2001-20261112    gcc-8.5.0
sparc64               randconfig-2200-20261112    gcc-10.5.0 smatch
sparc64              randconfig-r2108-20261112    gcc-12.5.0 cocci
sparc64              randconfig-r2303-20261112    clang-24   sparse
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261114    gcc-12.5.0
um                    randconfig-1001-20261114    gcc-12.5.0
um                    randconfig-2000-20261112    clang-24
um                    randconfig-2001-20261112    clang-24
um                    randconfig-2200-20261112    clang-20   smatch
um                   randconfig-r2111-20261112    gcc-12.5.0 cocci
um                   randconfig-r2309-20261112    clang-24   sparse
um                   randconfig-r2311-20261112    clang-24   sparse
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261114    gcc-14
x86_64      buildonly-randconfig-1001-20261114    gcc-14
x86_64      buildonly-randconfig-1002-20261114    gcc-14
x86_64      buildonly-randconfig-1003-20261114    gcc-14
x86_64      buildonly-randconfig-1004-20261114    gcc-14
x86_64      buildonly-randconfig-1005-20261114    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261114    gcc-14
x86_64                randconfig-1001-20261114    gcc-14
x86_64                randconfig-1002-20261114    gcc-14
x86_64                randconfig-1003-20261114    gcc-14
x86_64                randconfig-1004-20261114    gcc-14
x86_64                randconfig-1005-20261114    gcc-14
x86_64                randconfig-1012-20261114    clang-22
x86_64                randconfig-1013-20261114    clang-22
x86_64                randconfig-1014-20261114    clang-22
x86_64                randconfig-1015-20261114    clang-22
x86_64                randconfig-1016-20261114    clang-22
x86_64                randconfig-1017-20261114    clang-22
x86_64                randconfig-2000-20261112    gcc-14
x86_64                randconfig-2001-20261112    gcc-14
x86_64                randconfig-2002-20261112    clang-22
x86_64                randconfig-2002-20261112    gcc-14
x86_64                randconfig-2003-20261112    clang-22
x86_64                randconfig-2003-20261112    gcc-14
x86_64                randconfig-2004-20261112    clang-22
x86_64                randconfig-2004-20261112    gcc-14
x86_64                randconfig-2005-20261112    clang-22
x86_64                randconfig-2005-20261112    gcc-14
x86_64                randconfig-2100-20261112    clang-22   cocci
x86_64                randconfig-2101-20261112    clang-22   cocci
x86_64                randconfig-2101-20261112    gcc-14     cocci
x86_64                randconfig-2102-20261112    clang-22   cocci
x86_64                randconfig-2102-20261112    gcc-14     cocci
x86_64                randconfig-2103-20261112    clang-22   cocci
x86_64                randconfig-2103-20261112    gcc-12     cocci
x86_64                randconfig-2104-20261112    clang-22   cocci
x86_64                randconfig-2105-20261112    clang-22   cocci
x86_64                randconfig-2200-20261112    gcc-13     smatch
x86_64                randconfig-2300-20261112    clang-22   sparse
x86_64                randconfig-2300-20261112    gcc-14     sparse
x86_64                randconfig-2301-20261112    clang-22   sparse
x86_64                randconfig-2301-20261112    gcc-12     sparse
x86_64                randconfig-2302-20261112    clang-22   sparse
x86_64               randconfig-r2100-20261112    gcc-16.2.0 cocci
x86_64               randconfig-r2305-20261112    clang-24   sparse
x86_64               randconfig-r2311-20261112    gcc-14     sparse
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                           iss_defconfig    clang-24
xtensa                randconfig-1000-20261114    gcc-12.5.0
xtensa                randconfig-1001-20261114    gcc-12.5.0
xtensa                randconfig-2000-20261112    gcc-11.5.0
xtensa                randconfig-2000-20261112    gcc-16.2.0
xtensa                randconfig-2001-20261112    gcc-16.2.0
xtensa                randconfig-2001-20261112    gcc-8.5.0
xtensa                randconfig-2200-20261112    gcc-13.5.0 smatch
xtensa               randconfig-r2300-20261112    gcc-8.5.0  sparse
xtensa               randconfig-r2301-20261112    gcc-14.4.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

