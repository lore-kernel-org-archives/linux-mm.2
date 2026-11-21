Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29A3606A6BF
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=KRFZxMQZ
Received: by kanga.kvack.org (Postfix)
	id CDB5D6B05B3; Fri, 20 Nov 2026 20:05:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2956B05B4; Fri, 20 Nov 2026 20:05:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF106B05B5; Fri, 20 Nov 2026 20:05:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 964356B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:05:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FB2C120295
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:05:16 +0000 (UTC)
X-FDA: 85457332632.12.D919314
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id 95CD5C0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:05:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KRFZxMQZ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223114;
	b=B6ybnqnfvaRRXwLDdnKf66dFL5C41FY8Tyu3XbbfmiLX9OMFB3sU5b62UXxgYu2sM3rB+U
	z7q4O0tdlkQ3Y6G88eAC/mRaAXr87azl3qGaZHpxXi1zJbQB4fKiSkoF6flWjSb5i4VqL2
	t7WMMxK/BLFp2dzFAbYeTPiMLedviUg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=D6MUpByqUl21YvI4aTwA26R8B7fmmb3EiqJS1yLvH2A=;
	b=WMSt5tgw/bvFctoA9tBXjdoeTaFKzw4zuwsJXRq9sLCGp6eo+8KQH5LZxWmW0URXwuRDXm
	/L7Y6TSEMszIsEvd2caxH2wiDPclwX3u+TtPFBW6MKx883l35ipWFf4xnPCf5VOmA+l7vu
	7bQkhQC+a3K06E7kx9Jh1pRt8J8UabE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KRFZxMQZ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795223113; x=1826759113;
  h=date:from:to:cc:subject:message-id;
  bh=qkG1UrMDZs2x+TcV8lFs/sjiNEueuWccC0DFQWLou1U=;
  b=KRFZxMQZBbeLzdRVq0mBwj1rU+5V4btA4UV3VpWJyWVFYq2WHEpLixii
   4Ck0BD5eYoZXsbZwVmHRspXnKUs2qeV3LBvut9AqKBG8lyJnkV3l1h2IS
   4apezbPgjrDj2gj1YsdxqMy7jNA80AfQ2DrCdUm7cpYfryIBAjItw/oPg
   xczdZbTvaCoREvTejCvPfLDVVn+8qG0fx84ZUg1Wc0d5IH6VDQ3MV7DWB
   QB+8L2nQ9MfZPx2e5+rJXAk6lxmia4BlpRqkrtBH9DqigXA7oGzx53dhN
   W8GVcMT8j0iy8D59SxpTn4vWizbheWTEZlkmTqaSVdHYDfmyl4ErLzvdR
   g==;
X-CSE-ConnectionGUID: 6aBeao+sSK+yfeLGcblujA==
X-CSE-MsgGUID: 7qImZg2FQRW2qwqvLhL5xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4116065"
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="4116065"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 17:05:12 -0800
X-CSE-ConnectionGUID: +qcKEWHxQXCdMEx1EZsaDg==
X-CSE-MsgGUID: wXMdizheQVSLGIwPvmK++A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="11170173"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 20 Nov 2026 17:05:10 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUZXQ-00000001J6V-02Ze;
	Sat, 21 Nov 2026 01:05:08 +0000
Date: Sat, 21 Nov 2026 09:04:57 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 15f114dac9a7bde1796f0e54e22726fd31cfa8a5
Message-ID: <20261121090457.sQENk6l3-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95CD5C0005
X-Stat-Signature: y9fpi63zhtpw1u6q7p7qyhf6ybuyrhbs
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795223113-532600
X-HE-Meta: U2FsdGVkX1/3VP/aJnk6b7100iE1RUlZDjIdBYlDAVYf1Go7lJK+Yc8Qh+D/rMoF8YArilPFNfxx5qSm0MM0j3xNy1+IfyuLty+9wZAORLouBsG7IaPoVUGrj9aYyAP80IgrpX931SyHTYrTGuJ5/VlCGLrNhu6fkfvg1WbC8Yi76HJV+7NrgIeZd9NAWHBEOaHas75qukCCuAdE3ZwRVRVf/dcaSUnQBgzNqrwN6aMoPMkg1Iizxmtmu42ejNKyIxn+ohDpMtTIt0sTKCEZaomEvlvPsLuAgFHYU89EWYDoWqNXBwxs85Muz55E5FKd/aKcm42h9OwgCu9/vy5BjFuhGJiBj2oXUzYOmMECNUsO9U7ayLsT6u3/D60Y8FnGOr6QjsfS8Q4uEM3OJ4osDnip8/1E7T35AvbunRUd9qlbre0W5lVVGOhDgYjW9ZDSTdFSS/lO/HG1xP7F5KphE2GA5dT8pVDpD5a/4xZkN0jV/QufkCTnwsaYwfAZm6ItYhaXObj/DMWRuwKEWxHtQiI56t+j3DMSA6Bv5Z4WYqmUdmreszC6EFsJYmZQBHUWYvxMNDT8ltMlf7rhpKt41/qAwJbAKbyHxCavDgh1SX3hbKJa1IRpFYfjFAeoyt/jza5rgRP9vJja5RbmY7/BCkusYV9ymdXLAgyIqv3ebMwelZN7pYne/gTYbpvk3Kki1ez1Y4WO+wkcJl424JmwvW4aNjWhnEyXs7rcXb9MHk0a2hx+wZl5Oc24Jjf4c6JqbxO8kwFeeq/xanha1i7huII+8PvSzCDOdWmzG3WPpqqlDerH7SvumlLg/Zkwtq3b1tv1w9O24u9DH+VJTd6+V54OGFm21UvOZjCT0BYLu12A3AiOZbDJyzAMWE3dIb9g9MNOD3FkxrvOTH3g77xFYUJoXuSJYs7GFa6567VFBB6Co/ZutZifHGmxgpoMwRqVfr1t6auYEgxHoBdBnY3
 4ZZBG2Fz
 dhB9e79cKFAqUxZPdPcJTN9BPDSFJvTn6HIipPakzdcj8+qeUscZytD1e5JFixsI9nfqzRq6KtKvrxzBynb+af6U8qqG6POU8WpJFbP78yogNvCTqm0njeLDura8tZyPSdpK8W7R2SeNr1RckOpc49qTNdAyFRWqqBbTHWg1Q38luwl7Gx4HllsYmd16AuOq4q0lgJ9LbTpvQw6piz3OutSCQ44aMII/XXCgcXRDtYzayGXXMNVu6VYerrR/c/m3YpL/Wece8lVI1H+YFGWIuzqby1IXGIyYjYrvPzyARX1umn10iIX5NmNcCbAYp+MvLzXtIXXLImFLTzACJKsvRSD3jyQ+5GbNOqow7zVkyZf0GiSTkTreNTnsK7pwMSg5eOD+gW03CNDAkCGo/+Y+p5bxME11jZyFY+FAuu/0KBLcX+OUt2uexllyGHYmjI5jFYhlh2qfP7g8xqwpEV20AK0vzjPbADVBGOijg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 15f114dac9a7bde1796f0e54e22726fd31cfa8a5  lib/test_hmm: fix alloc tag leak when splitting device-private folios

elapsed time: 1091m

configs tested: 308
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                 randconfig-2000-20261120    gcc-13.5.0
alpha                 randconfig-2001-20261120    gcc-15.3.0
alpha                 randconfig-2200-20261120    gcc-15.3.0 smatch
alpha                randconfig-r2302-20261120    gcc-15.3.0 sparse
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                       axs103_smp_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261120    clang-17
arc                   randconfig-1000-20261121    clang-24
arc                   randconfig-1001-20261120    clang-17
arc                   randconfig-1001-20261121    clang-24
arc                   randconfig-2200-20261120    gcc-15.3.0 smatch
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                         clps711x_defconfig    gcc-16.2.0
arm                        omap2plus_defconfig    gcc-16.2.0
arm                           pxa168_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261120    clang-17
arm                   randconfig-1000-20261121    clang-24
arm                   randconfig-1001-20261120    clang-17
arm                   randconfig-1001-20261121    clang-24
arm                   randconfig-1002-20261120    clang-17
arm                   randconfig-1002-20261121    clang-24
arm                   randconfig-1003-20261120    clang-17
arm                   randconfig-1003-20261121    clang-24
arm                   randconfig-2000-20261120    gcc-11.5.0
arm                   randconfig-2001-20261120    gcc-8.5.0
arm                   randconfig-2002-20261120    clang-24
arm                   randconfig-2200-20261120    clang-17   smatch
arm                              rpc_defconfig    gcc-16.2.0
arm                         shmobile_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                 randconfig-1000-20261120    clang-18
arm64                 randconfig-1000-20261120    clang-24
arm64                 randconfig-1001-20261120    clang-18
arm64                 randconfig-1001-20261120    gcc-8.5.0
arm64                 randconfig-1002-20261120    clang-18
arm64                 randconfig-1003-20261120    clang-18
arm64                 randconfig-1003-20261120    clang-24
arm64                 randconfig-2000-20261120    clang-24
arm64                 randconfig-2001-20261120    gcc-8.5.0
arm64                 randconfig-2002-20261120    gcc-14.4.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                  randconfig-1000-20261120    clang-18
csky                  randconfig-1000-20261120    gcc-16.2.0
csky                  randconfig-1001-20261120    clang-18
csky                  randconfig-1001-20261120    gcc-12.5.0
csky                  randconfig-2001-20261120    gcc-16.2.0
csky                  randconfig-2200-20261120    gcc-15.3.0 smatch
csky                 randconfig-r2300-20261120    gcc-16.2.0 sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon               randconfig-1000-20261120    gcc-10.5.0
hexagon               randconfig-1000-20261121    gcc-11.5.0
hexagon               randconfig-1001-20261120    gcc-10.5.0
hexagon               randconfig-1001-20261121    gcc-11.5.0
i386                              allmodconfig    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261121    gcc-13
i386        buildonly-randconfig-1001-20261121    gcc-13
i386        buildonly-randconfig-1002-20261121    gcc-13
i386        buildonly-randconfig-1003-20261121    gcc-13
i386        buildonly-randconfig-1004-20261121    gcc-13
i386        buildonly-randconfig-1005-20261121    gcc-13
i386                  randconfig-1000-20261120    clang-22
i386                  randconfig-1000-20261120    gcc-14
i386                  randconfig-1001-20261120    clang-22
i386                  randconfig-1002-20261120    clang-22
i386                  randconfig-1003-20261120    clang-22
i386                  randconfig-1004-20261120    clang-22
i386                  randconfig-1005-20261120    clang-22
i386                  randconfig-1006-20261120    clang-22
i386                  randconfig-1006-20261120    gcc-14
i386                  randconfig-1007-20261120    clang-22
i386                  randconfig-1008-20261120    clang-22
i386                  randconfig-1009-20261120    clang-22
i386                  randconfig-1010-20261120    clang-22
i386                  randconfig-1011-20261120    clang-22
i386                  randconfig-1012-20261120    clang-22
i386                  randconfig-1013-20261120    clang-22
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261120    gcc-10.5.0
loongarch             randconfig-1000-20261121    gcc-11.5.0
loongarch             randconfig-1001-20261120    gcc-10.5.0
loongarch             randconfig-1001-20261121    gcc-11.5.0
loongarch             randconfig-2200-20261120    clang-18   smatch
loongarch            randconfig-r2101-20261120    clang-24   cocci
loongarch            randconfig-r2305-20261120    gcc-12.5.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5275evb_defconfig    gcc-16.2.0
m68k                         mvme16x_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261120    gcc-12.5.0
m68k                  randconfig-2001-20261120    gcc-8.5.0
m68k                  randconfig-2200-20261120    gcc-14.4.0 smatch
m68k                 randconfig-r2303-20261120    gcc-9.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261120    gcc-9.5.0
microblaze            randconfig-2200-20261120    gcc-11.5.0 smatch
microblaze           randconfig-r2308-20261120    gcc-15.3.0 sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                 econet_en751221_defconfig    gcc-16.2.0
mips                           eyeq5_defconfig    gcc-16.2.0
mips                      loongson2k_defconfig    gcc-16.2.0
mips                       maltasmvp_defconfig    gcc-16.2.0
mips                  randconfig-2200-20261120    clang-24   smatch
mips                 randconfig-r2307-20261120    clang-24   sparse
mips                 randconfig-r2311-20261120    clang-24   sparse
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261120    gcc-10.5.0
nios2                 randconfig-1000-20261121    gcc-11.5.0
nios2                 randconfig-1001-20261120    gcc-10.5.0
nios2                 randconfig-1001-20261121    gcc-11.5.0
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261120    gcc-9.5.0
openrisc              randconfig-2200-20261120    gcc-11.5.0 smatch
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                 generic-32bit_defconfig    gcc-16.2.0
parisc                randconfig-1000-20261120    gcc-11.5.0
parisc                randconfig-1000-20261121    gcc-10.5.0
parisc                randconfig-1001-20261120    gcc-11.5.0
parisc                randconfig-1001-20261121    gcc-10.5.0
parisc                randconfig-2200-20261120    gcc-8.5.0  smatch
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc                       chrp32_defconfig    gcc-16.2.0
powerpc                         icon_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261120    gcc-11.5.0
powerpc               randconfig-1000-20261121    gcc-10.5.0
powerpc               randconfig-1001-20261120    gcc-11.5.0
powerpc               randconfig-1001-20261121    gcc-10.5.0
powerpc               randconfig-2200-20261120    clang-17   smatch
powerpc              randconfig-r2306-20261120    gcc-16.2.0 sparse
powerpc                      taishan_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261120    gcc-11.5.0
powerpc64             randconfig-1000-20261121    gcc-10.5.0
powerpc64             randconfig-1001-20261120    gcc-11.5.0
powerpc64             randconfig-1001-20261121    gcc-10.5.0
powerpc64             randconfig-2200-20261120    gcc-16.2.0 smatch
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261120    gcc-11.5.0
riscv                 randconfig-1000-20261121    clang-17
riscv                 randconfig-1001-20261120    gcc-11.5.0
riscv                 randconfig-1001-20261121    clang-17
riscv                 randconfig-2001-20261120    gcc-10.5.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261120    gcc-11.5.0
s390                  randconfig-1000-20261121    clang-17
s390                  randconfig-1001-20261120    gcc-11.5.0
s390                  randconfig-1001-20261121    clang-17
s390                  randconfig-2000-20261120    gcc-8.5.0
s390                  randconfig-2200-20261120    clang-17   smatch
s390                        zfcpdump_defconfig    gcc-16.2.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                         dreamcast_defconfig    gcc-16.2.0
sh                 ecovec24-romimage_defconfig    gcc-16.2.0
sh                           kfr2r09_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261120    gcc-11.5.0
sh                    randconfig-1000-20261121    clang-17
sh                    randconfig-1001-20261120    gcc-11.5.0
sh                    randconfig-1001-20261121    clang-17
sh                    randconfig-2000-20261120    gcc-16.2.0
sh                    randconfig-2001-20261120    gcc-16.2.0
sh                    randconfig-2002-20261120    gcc-16.2.0
sh                    randconfig-2003-20261120    gcc-11.5.0
sh                    randconfig-2004-20261120    gcc-16.2.0
sh                    randconfig-2005-20261120    gcc-15.3.0
sh                    randconfig-2200-20261120    gcc-11.5.0 smatch
sh                   randconfig-r2309-20261120    gcc-13.5.0 sparse
sh                         sh7785lcr_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261121    gcc-14
sparc                 randconfig-1000-20261121    gcc-8.5.0
sparc                 randconfig-1001-20261121    gcc-14
sparc                 randconfig-1001-20261121    gcc-8.5.0
sparc                 randconfig-2000-20261120    gcc-16.2.0
sparc                 randconfig-2001-20261120    gcc-8.5.0
sparc                randconfig-r2301-20261120    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261121    clang-20
sparc64               randconfig-1000-20261121    gcc-14
sparc64               randconfig-1001-20261121    clang-20
sparc64               randconfig-1001-20261121    gcc-14
sparc64               randconfig-2000-20261120    gcc-8.5.0
sparc64               randconfig-2001-20261120    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261121    gcc-14
um                    randconfig-1001-20261121    clang-24
um                    randconfig-1001-20261121    gcc-14
um                    randconfig-2000-20261120    clang-24
um                    randconfig-2001-20261120    gcc-14
um                    randconfig-2200-20261120    clang-24   smatch
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261120    clang-22
x86_64      buildonly-randconfig-1001-20261120    clang-22
x86_64      buildonly-randconfig-1002-20261120    clang-22
x86_64      buildonly-randconfig-1003-20261120    clang-22
x86_64      buildonly-randconfig-1004-20261120    clang-22
x86_64      buildonly-randconfig-1005-20261120    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261120    clang-22
x86_64                randconfig-1000-20261121    clang-22
x86_64                randconfig-1001-20261120    clang-22
x86_64                randconfig-1001-20261121    clang-22
x86_64                randconfig-1002-20261120    clang-22
x86_64                randconfig-1002-20261121    clang-22
x86_64                randconfig-1003-20261120    clang-22
x86_64                randconfig-1003-20261121    clang-22
x86_64                randconfig-1004-20261120    clang-22
x86_64                randconfig-1004-20261121    clang-22
x86_64                randconfig-1005-20261120    clang-22
x86_64                randconfig-1005-20261121    clang-22
x86_64                randconfig-1006-20261121    clang-22
x86_64                randconfig-1007-20261121    clang-22
x86_64                randconfig-1008-20261121    gcc-14
x86_64                randconfig-1009-20261121    clang-22
x86_64                randconfig-1010-20261121    gcc-14
x86_64                randconfig-1011-20261121    clang-22
x86_64                randconfig-1012-20261120    clang-22
x86_64                randconfig-1013-20261120    clang-22
x86_64                randconfig-1014-20261120    clang-22
x86_64                randconfig-1015-20261120    clang-22
x86_64                randconfig-1016-20261120    clang-22
x86_64                randconfig-1017-20261120    clang-22
x86_64                randconfig-2000-20261120    gcc-14
x86_64                randconfig-2001-20261120    gcc-14
x86_64                randconfig-2002-20261120    clang-22
x86_64                randconfig-2003-20261120    clang-22
x86_64                randconfig-2005-20261120    gcc-14
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                            alldefconfig    gcc-16.2.0
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261121    gcc-14
xtensa                randconfig-1000-20261121    gcc-8.5.0
xtensa                randconfig-1001-20261121    gcc-11.5.0
xtensa                randconfig-1001-20261121    gcc-14
xtensa                randconfig-2200-20261120    gcc-9.5.0  smatch
xtensa               randconfig-r2310-20261120    gcc-15.3.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

