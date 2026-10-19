Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FEAD608829E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gGG7ihL9
Received: by kanga.kvack.org (Postfix)
	id B22B96B02B6; Mon, 19 Oct 2026 11:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3256B02B8; Mon, 19 Oct 2026 11:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8F66B02B9; Mon, 19 Oct 2026 11:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16AE96B02B6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:48:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CF9A80750
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:48:28 +0000 (UTC)
X-FDA: 85339807896.13.A969DDD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1B6A11A000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:48:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gGG7ihL9;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792424906;
	b=c3F+P1B4Ks7fJdIURvLTCrqKVujAVY1Qb/XOcD4g/WReB5kXWOcsgIglV3qz6AdO+Ccj+z
	PdeTzVdj07TttZmkcKdEYw1qmjN1LCvE+aNDU1JFLN93y3q0TnHsrykx6kInKvo9m5ZO4v
	3bZScMhVv+fQ0ghVx88umX7mMZwCjKY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gGG7ihL9;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792424906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=F8PVlVs2IJaK6fJestfGqrxDWHNz0DI/vUp6pIrI+Pk=;
	b=srbgQW964z4Zbb4NFgxaYOnz4gGQg38sE/5YEVFiiLG6y8mXJRSDLnLaXp43m7gVPDNtVh
	Bd/vduXb3IeGl7/o687vPXWeK9tNy0//WQixGrqMMBwBe3uKuWKNz+WtveEbx7A5jZkzr6
	NIjVbgT/qDSi/ZsGnpd/zjaUvf/8jDg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792424906; x=1823960906;
  h=date:from:to:cc:subject:message-id;
  bh=rnE4ZqNt7wRMBKTIcVXaTrmIhT9zQtM3P3J7+zT1ghE=;
  b=gGG7ihL9W/vguvfENMxjtsozlNhxKSg5Mz2/ISikbjjwnw7cwe2gldrf
   Mh/SWGN+7a9hfTLkyZA+ndvQ5ntX3vwprXMlDhjoniOvM7caULiTcv1JK
   Qlg4i3ADbd9BP7fT29iYdLBqI8IJP5EkIxWvjvPWSm1xFxORlRsJTaBic
   llGh7v0CNttK9dVqjqhoWCzvGT3wcqU8gS9vOkZUjuI8szNC2eFYBTxAq
   zeMoUz+DQVPJ8IhM++FbJtPKbRCNF3EpUsIV2SrV1FsaZeMqfwzfCZ1TP
   hE3VfUPa2cAfY+K2GroD/wcaQZ369MjC5dozis5W6bWhjEFhnXD2FNyd3
   g==;
X-CSE-ConnectionGUID: SINjrKtWSoexbqBuykj6Rg==
X-CSE-MsgGUID: AE1rDUFxReSLg25F5uONNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1005107"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1005107"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:48:25 -0700
X-CSE-ConnectionGUID: M+c19PufTYqpUqsf9s+7Qw==
X-CSE-MsgGUID: VoiUl8uvQDmy1FFtTlCDYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="3035350"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 19 Oct 2026 08:48:23 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIpb2-00000000Ls6-0xva;
	Mon, 19 Oct 2026 15:48:20 +0000
Date: Mon, 19 Oct 2026 23:48:01 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 2887e63d2e8e0cf55402612d8996ce955a2c3e55
Message-ID: <202610192358.tww7xinY-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B6A11A000B
X-Stat-Signature: 65iyh14gmzrr9kfh8fk7z7hfqa11dfy1
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,RCVD_IN_DNSWL_BLOCKED,
	RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792424905-46082
X-HE-Meta: U2FsdGVkX19FKScZCBUNxzLgwf7nfVI2aKOmrd05UaMofTrySZqe/8ENAL0INPkJwTozYbLIE2NWtZy/0cR3RxEoNqTAtVCYwl8TgypeZ0a4ZShu+TVw37Gm0CdNuuxI5wVX9DHtbuKMIJhbxFRCi2GYnOa1nn9wdZTDLXrIuY65v+7kARdrmcaqq+6ulBe3Hx002/dSSEadswBClyk48YAgUXNZn9j63g/uJ+sE7CISKKMFn/96ODV6VcvkTVp974qNwo2Rd2yYo8clTozQ7/aa35CdEY9+XGwIekB2CMnWZau4pFMvJ7/TvPEGOqxBjSgdN0gyfIFRbe24gS0lAwNdKdia+srQFYifBdM++M/JSpsLyATrjl0NAMkvJvYx+6LtCRxubZ/18tmAuj+JpHBe68s5c7zAczptnCpizEqv56ktq2C+R/IytjeNxnXZ1eT3MCh7dyEac4Zd6HCF/xunYfbjPkzuFaBWLlo4SApT3tutGupVZeF0/C5pM3AcAqrLDmBhzDDpkJ2W1dbrZSzlRDINn31dNZkbhHqALp0GitioZx1THdoCKxW28A0PE/QoYMffqbP1PP0JCmXnqRTi7R2QbkTpLDWcx8FH3i2D6KP7OGEPam7EU76x9gQ426fFUzFm+7gSjrQo4KGZ7JMwl/fV+V90iRrhjYWSgdrxY7OQ4UknxJpQ850rV7+EUHdGfPeGUVfZJsvqiMwQn9Ys/bMCqJSumCq2yBBnkBCoBAEBeEhxPcMXxcz5kc9hran+b/s2zFnagJ+BFb6Q21cNG6ervfzEQW3uJKYnGp0CuyguCE7fzmvfiq0alWrUBerc5v77Gb0dGyAWIQlm/e9+5mRB/XlGKewiJOCPU6j1LKL/fPUbkcyDBMPMrzo+f/PwwSCxIXvpUxHmbzy6QqSRgO6aaK+LBy6L3+STFDPvSMzRJQMEP07xCk9AhJqB1sctqFdd0EV4Cb/J8it
 IC77aWbl
 pLdMzUVuS2BVSHik5wJyDOT24Jx2yk2Lu+PicC+H1u8utGWg8f0YRnrQhpl1BQ0n/uNeprdZL06XGcQNamomG2tkoB/E5xJC3uCxNfJ5XnJ8roT8KsPdPy1rjZ9M/QELjBYf2XC16VoLbSlBzmZsiCs4IiDEVknMf5CFIZXH1ppQmzwJ6nBicZBkdCGnrTBafUtdxKeAsSIJAYjQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 2887e63d2e8e0cf55402612d8996ce955a2c3e55  riscv: mm: exclude invalid THP PMDs from page table check

elapsed time: 809m

configs tested: 304
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                randconfig-r2302-20261019    gcc-11.5.0 sparse
alpha                randconfig-r2308-20261019    gcc-15.3.0 sparse
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261019    gcc-8.5.0
arc                   randconfig-1001-20261019    gcc-16.2.0
arc                   randconfig-2000-20261019    gcc-8.5.0
arc                   randconfig-2001-20261019    gcc-8.5.0
arc                  randconfig-r2103-20261019    gcc-8.5.0  cocci
arc                  randconfig-r2104-20261019    clang-24   cocci
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                         mvebu_v7_defconfig    clang-24
arm                              pxa_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261019    clang-24
arm                   randconfig-1001-20261019    clang-18
arm                   randconfig-1002-20261019    clang-21
arm                   randconfig-1003-20261019    clang-24
arm                   randconfig-2000-20261019    gcc-8.5.0
arm                   randconfig-2001-20261019    clang-17
arm                   randconfig-2001-20261019    gcc-8.5.0
arm                  randconfig-r2105-20261019    clang-24   cocci
arm                            spitz_defconfig    gcc-16.2.0
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261019    clang-21
arm64                 randconfig-1001-20261019    clang-24
arm64                 randconfig-1002-20261019    gcc-8.5.0
arm64                 randconfig-1003-20261019    clang-24
arm64                 randconfig-2000-20261019    gcc-14.4.0
arm64                 randconfig-2000-20261019    gcc-15.3.0
arm64                 randconfig-2001-20261019    gcc-15.3.0
arm64                 randconfig-2001-20261019    gcc-8.5.0
arm64                randconfig-r2100-20261019    gcc-14.4.0 cocci
arm64                randconfig-r2106-20261019    clang-24   cocci
arm64                randconfig-r2202-20261019    gcc-15.3.0 smatch
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261019    gcc-14.4.0
csky                  randconfig-1001-20261019    gcc-12.5.0
csky                  randconfig-2000-20261019    gcc-15.3.0
csky                  randconfig-2000-20261019    gcc-16.2.0
csky                  randconfig-2001-20261019    gcc-15.3.0
csky                 randconfig-r2102-20261019    gcc-14.4.0 cocci
csky                 randconfig-r2310-20261019    gcc-16.2.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261019    clang-24
hexagon               randconfig-1001-20261019    clang-24
hexagon               randconfig-2000-20261019    clang-17
hexagon               randconfig-2000-20261019    gcc-15.3.0
hexagon               randconfig-2001-20261019    clang-24
hexagon               randconfig-2001-20261019    gcc-15.3.0
hexagon              randconfig-r2201-20261019    clang-24   smatch
hexagon              randconfig-r2308-20261019    clang-20   sparse
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261019    gcc-14
i386        buildonly-randconfig-1001-20261019    gcc-14
i386        buildonly-randconfig-1002-20261019    gcc-14
i386        buildonly-randconfig-1003-20261019    clang-22
i386        buildonly-randconfig-1004-20261019    clang-22
i386        buildonly-randconfig-1005-20261019    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261019    gcc-14
i386                  randconfig-1001-20261019    clang-22
i386                  randconfig-1002-20261019    gcc-14
i386                  randconfig-1003-20261019    gcc-12
i386                  randconfig-1004-20261019    gcc-14
i386                  randconfig-1005-20261019    clang-22
i386                  randconfig-1006-20261019    gcc-14
i386                  randconfig-1007-20261019    gcc-14
i386                  randconfig-1008-20261019    gcc-14
i386                  randconfig-1009-20261019    clang-22
i386                  randconfig-1010-20261019    gcc-14
i386                  randconfig-1011-20261019    clang-22
i386                  randconfig-1012-20261019    gcc-14
i386                  randconfig-1013-20261019    clang-22
i386                  randconfig-2000-20261019    clang-22
i386                  randconfig-2000-20261019    gcc-8.5.0
i386                  randconfig-2001-20261019    clang-22
i386                  randconfig-2001-20261019    gcc-8.5.0
i386                  randconfig-2100-20261019    gcc-14     cocci
i386                  randconfig-2101-20261019    gcc-14     cocci
i386                  randconfig-2102-20261019    clang-22   cocci
i386                  randconfig-2102-20261019    gcc-14     cocci
i386                  randconfig-2103-20261019    gcc-14     cocci
i386                  randconfig-2104-20261019    gcc-14     cocci
i386                  randconfig-2105-20261019    gcc-14     cocci
i386                  randconfig-2200-20261019    gcc-14     smatch
i386                  randconfig-2300-20261019    gcc-14     sparse
i386                  randconfig-2301-20261019    gcc-14     sparse
i386                  randconfig-2302-20261019    clang-22   sparse
i386                  randconfig-2302-20261019    gcc-14     sparse
i386                 randconfig-r2101-20261019    gcc-13     cocci
i386                 randconfig-r2303-20261019    clang-22   sparse
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261019    gcc-16.2.0
loongarch             randconfig-1001-20261019    gcc-16.2.0
loongarch             randconfig-2000-20261019    clang-24
loongarch             randconfig-2000-20261019    gcc-11.5.0
loongarch             randconfig-2001-20261019    gcc-11.5.0
loongarch             randconfig-2001-20261019    gcc-12.5.0
loongarch            randconfig-r2103-20261019    gcc-14.4.0 cocci
loongarch            randconfig-r2200-20261019    gcc-16.2.0 smatch
m68k                              alldefconfig    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                 randconfig-r2311-20261019    clang-20   sparse
m68k                            sun3_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
microblaze           randconfig-r2108-20261019    gcc-14.4.0 cocci
microblaze           randconfig-r2304-20261019    gcc-15.3.0 sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                            ip30_defconfig    gcc-16.2.0
mips                       maltasmvp_defconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261019    gcc-10.5.0
nios2                 randconfig-1001-20261019    gcc-8.5.0
nios2                 randconfig-2000-20261019    gcc-11.5.0
nios2                 randconfig-2001-20261019    gcc-11.5.0
nios2                randconfig-r2305-20261019    gcc-11.5.0 sparse
nios2                randconfig-r2306-20261019    gcc-10.5.0 sparse
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc             randconfig-r2106-20261019    gcc-14.4.0 cocci
openrisc             randconfig-r2301-20261019    gcc-10.5.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261019    gcc-12.5.0
parisc                randconfig-1001-20261019    gcc-10.5.0
parisc                randconfig-2000-20261019    gcc-11.5.0
parisc                randconfig-2000-20261019    gcc-15.3.0
parisc                randconfig-2001-20261019    gcc-11.5.0
parisc                randconfig-2001-20261019    gcc-8.5.0
parisc               randconfig-r2102-20261019    gcc-12.5.0 cocci
parisc               randconfig-r2105-20261019    gcc-10.5.0 cocci
parisc               randconfig-r2300-20261019    gcc-10.5.0 sparse
parisc               randconfig-r2310-20261019    clang-20   sparse
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261019    clang-24
powerpc               randconfig-1001-20261019    gcc-8.5.0
powerpc               randconfig-2000-20261019    clang-22
powerpc               randconfig-2000-20261019    gcc-8.5.0
powerpc               randconfig-2001-20261019    clang-22
powerpc               randconfig-2001-20261019    clang-24
powerpc              randconfig-r2109-20261019    clang-17   cocci
powerpc              randconfig-r2111-20261019    clang-24   cocci
powerpc              randconfig-r2307-20261019    clang-20   sparse
powerpc64             randconfig-1000-20261019    gcc-10.5.0
powerpc64             randconfig-1001-20261019    gcc-11.5.0
powerpc64             randconfig-2000-20261019    clang-22
powerpc64             randconfig-2000-20261019    clang-24
powerpc64             randconfig-2001-20261019    clang-22
powerpc64             randconfig-2001-20261019    clang-24
powerpc64            randconfig-r2201-20261019    clang-24   smatch
powerpc64            randconfig-r2306-20261019    clang-20   sparse
powerpc64            randconfig-r2309-20261019    clang-20   sparse
riscv                              allnoconfig    gcc-16.2.0
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261019    gcc-11.5.0
riscv                 randconfig-1001-20261019    gcc-9.5.0
riscv                 randconfig-2000-20261019    clang-17
riscv                 randconfig-2000-20261019    gcc-13.5.0
riscv                 randconfig-2001-20261019    clang-24
riscv                 randconfig-2001-20261019    gcc-13.5.0
riscv                randconfig-r2101-20261019    gcc-14.4.0 cocci
riscv                randconfig-r2107-20261019    clang-24   cocci
riscv                randconfig-r2111-20261019    gcc-8.5.0  cocci
riscv                randconfig-r2200-20261019    clang-19   smatch
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                  randconfig-1000-20261019    gcc-8.5.0
s390                  randconfig-1001-20261019    gcc-9.5.0
s390                  randconfig-2000-20261019    clang-20
s390                  randconfig-2000-20261019    gcc-13.5.0
s390                  randconfig-2001-20261019    gcc-10.5.0
s390                  randconfig-2001-20261019    gcc-13.5.0
s390                 randconfig-r2202-20261019    clang-24   smatch
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261019    gcc-10.5.0
sh                    randconfig-1001-20261019    gcc-16.2.0
sh                    randconfig-2000-20261019    gcc-13.5.0
sh                    randconfig-2001-20261019    gcc-13.5.0
sh                    randconfig-2001-20261019    gcc-15.3.0
sh                           sdk7780_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261019    gcc-16.2.0
sparc                 randconfig-1001-20261019    gcc-12.5.0
sparc                 randconfig-2000-20261019    gcc-11.5.0
sparc                 randconfig-2000-20261019    gcc-16.2.0
sparc                 randconfig-2001-20261019    gcc-11.5.0
sparc                randconfig-r2100-20261019    gcc-13.5.0 cocci
sparc                randconfig-r2110-20261019    gcc-14.4.0 cocci
sparc                randconfig-r2311-20261019    gcc-14.4.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261019    gcc-15.3.0
sparc64               randconfig-1001-20261019    clang-20
sparc64               randconfig-2000-20261019    gcc-11.5.0
sparc64               randconfig-2000-20261019    gcc-8.5.0
sparc64               randconfig-2001-20261019    clang-24
sparc64               randconfig-2001-20261019    gcc-11.5.0
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261019    clang-24
um                    randconfig-1001-20261019    clang-20
um                    randconfig-2000-20261019    gcc-11.5.0
um                    randconfig-2000-20261019    gcc-12
um                    randconfig-2001-20261019    gcc-11.5.0
um                    randconfig-2001-20261019    gcc-12
um                   randconfig-r2104-20261019    clang-17   cocci
um                   randconfig-r2110-20261019    clang-24   cocci
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261019    clang-22
x86_64      buildonly-randconfig-1001-20261019    clang-22
x86_64      buildonly-randconfig-1002-20261019    gcc-14
x86_64      buildonly-randconfig-1003-20261019    gcc-14
x86_64      buildonly-randconfig-1004-20261019    gcc-14
x86_64      buildonly-randconfig-1005-20261019    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261019    gcc-14
x86_64                randconfig-1001-20261019    gcc-14
x86_64                randconfig-1002-20261019    gcc-14
x86_64                randconfig-1003-20261019    gcc-14
x86_64                randconfig-1004-20261019    clang-22
x86_64                randconfig-1005-20261019    gcc-14
x86_64                randconfig-1006-20261019    clang-22
x86_64                randconfig-1007-20261019    clang-22
x86_64                randconfig-1008-20261019    gcc-14
x86_64                randconfig-1009-20261019    gcc-14
x86_64                randconfig-1010-20261019    clang-22
x86_64                randconfig-1011-20261019    gcc-14
x86_64                randconfig-1012-20261019    gcc-14
x86_64                randconfig-1013-20261019    clang-22
x86_64                randconfig-1014-20261019    clang-22
x86_64                randconfig-1015-20261019    clang-22
x86_64                randconfig-1016-20261019    gcc-13
x86_64                randconfig-1017-20261019    gcc-14
x86_64                randconfig-2000-20261019    clang-22
x86_64                randconfig-2000-20261019    gcc-14
x86_64                randconfig-2001-20261019    clang-22
x86_64                randconfig-2100-20261019    clang-22   cocci
x86_64                randconfig-2101-20261019    clang-22   cocci
x86_64                randconfig-2101-20261019    gcc-14     cocci
x86_64                randconfig-2102-20261019    clang-22   cocci
x86_64                randconfig-2103-20261019    clang-22   cocci
x86_64                randconfig-2103-20261019    gcc-14     cocci
x86_64                randconfig-2104-20261019    clang-22   cocci
x86_64                randconfig-2105-20261019    clang-22   cocci
x86_64                randconfig-2105-20261019    gcc-14     cocci
x86_64                randconfig-2200-20261019    clang-22   smatch
x86_64                randconfig-2300-20261019    gcc-14     sparse
x86_64                randconfig-2301-20261019    clang-22   sparse
x86_64                randconfig-2301-20261019    gcc-14     sparse
x86_64                randconfig-2302-20261019    gcc-14     sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                            rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261019    gcc-16.2.0
xtensa                randconfig-2000-20261019    gcc-11.5.0
xtensa                randconfig-2000-20261019    gcc-15.3.0
xtensa                randconfig-2001-20261019    gcc-11.5.0
xtensa                randconfig-2001-20261019    gcc-8.5.0
xtensa               randconfig-r2107-20261019    gcc-12.5.0 cocci
xtensa               randconfig-r2108-20261019    gcc-14.4.0 cocci
xtensa               randconfig-r2109-20261019    gcc-14.4.0 cocci

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

