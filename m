Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33624D5B85E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 17:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2591F6B0088; Mon, 15 Dec 2025 12:46:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2033A6B0089; Mon, 15 Dec 2025 12:46:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB376B008A; Mon, 15 Dec 2025 12:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CECE36B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:46:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75EA913A915
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:46:10 +0000 (UTC)
X-FDA: 84222434100.16.D1D142A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 50A2BC0016
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:46:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bI1STBMS;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765820768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=fwGmhPVv+H6+gEOKlYaXgCdzldJioE7dpj+5ZZcC2Is=;
	b=aX4Vua+yT7NcPhH3FBUsRJZ26DKFJb3ooFDi1uTSxn/oMGoXUS3sS75az+ibToV9u4rS1s
	gPjZRIju7D7neC1szRrkpPxXs0quOxJqbWvra1Lw/bBJ+SCACPOrYIOoXV8iAfvex6khCu
	Ysn0hz4Va8ws02qdI6rt9PQE06BdlsA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765820768; a=rsa-sha256;
	cv=none;
	b=juJZKf8BMvvJIJ93GciKrJjXJKW9C/WT2uqKZzbA40gusc9i2/bKh0k46Q9Qmo/kp6dB7w
	h7UhoYgEGY/qLs8JzRjA3tfRMNDY9Y2eiX+5hHHzf+lyb8mTUJCCWYYBfDlQXns8oFAnES
	bdKhnBm6vCBVqvYDEBZuo3Tu31UGHPU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bI1STBMS;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765820767; x=1797356767;
  h=date:from:to:cc:subject:message-id;
  bh=kEsiZLLfhgwCP2UMeqXT3xjfzO4AhhfjuVhtgQGq6Ws=;
  b=bI1STBMSzvCdnY4cZxy1zeVT3nAbWlbuKih1S55a5QCcgJAQjsdJHaCn
   B6evlqvOyEGk4F6S4ozJkxzBbqFhiIe3bNniHvX71JufuWaHdxBphMv97
   +4LJZMer0eWYKe/6vM7cUQCExmhOywjakuJt3L7ebyz+2Paj4IhwGfyhQ
   wtXsyNnzOobSPYh8zwQYz9fFvb3O5RIRx/oHEpNdnGcElynubq/kzsAKL
   NsmLkILU3e9CqCblOU6OV4VLv9IVZIYvwKzl3kMPiGK2pRSdw5FVaw/8v
   /ppK616DOtaFlzmbgTxtgH1OgG4EjLYAvcfxtYoBzKKQYIg0+lUuEHOzs
   Q==;
X-CSE-ConnectionGUID: lmUQsg18Q+is/3pt53QxGg==
X-CSE-MsgGUID: yb5X6De9QlCE+d2rr0Qkyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="78368347"
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="78368347"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 09:46:06 -0800
X-CSE-ConnectionGUID: 5GVtnlqhTpS4GjasZnYACQ==
X-CSE-MsgGUID: CIjmW+1gR2K9w7FzsfFl+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="202698043"
Received: from lkp-server02.sh.intel.com (HELO 034c7e8e53c3) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 15 Dec 2025 09:46:05 -0800
Received: from kbuild by 034c7e8e53c3 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVCe2-000000000ZR-3JrT;
	Mon, 15 Dec 2025 17:46:02 +0000
Date: Tue, 16 Dec 2025 01:45:41 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD SUCCESS
 4a5663c04bb679631985a15efab774da58c37815
Message-ID: <202512160135.QBULfH3t-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: hqonaoi6hu3oyqsfgzkcwn5yd68gkkd5
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 50A2BC0016
X-Rspam-User: 
X-HE-Tag: 1765820767-869677
X-HE-Meta: U2FsdGVkX19C8GqM68kQxbIzwyEndgVfnqu7OUVk5ihYbmzAae68u74Deb4qI8qyY6FRjdbT798WRB4vypCAkDJdWV7RYoU1DWz1FcgVp1VU92gRfPkb1gHrTVjaiafcsmb5Dp+gKpiJjOtgcObMQbq0slVU+c91x6C8N0A+bEcyNWSj/U5qpwuynWnEhqU5qoMWgNIddauFaIgrQ0C5Z1vbXjfSk5AuELxNB0mvIU15LoXo7O3qGj+KNf6P/VHeXYHbvlO4umNhWR83HoN6Eshv0Big9wcZ/kNXqFsEBF2dnxZDhJqo9Vh6s5w71FNqx8gYm358f2GJsjvW9uqS8qsn3LqIzWe0OimQE0v0QKSHDZfBmcZC7zagT0SUlkTnvh9WzSQaSiXl3YWh+nc8q8JmE6zp+DdUqjiYFzoD+fWK4GefJ0HPbHqqTxPQ6ByL0Joks/6SIPFVe1X84tFzan9zQ4lxz8X/kPR6f8cRQxk13fISpvMY8Zml87SKJ5VB6wt+SX/L9fkZzdlErUTiyO05APLqEkHkl42MuQuYZruYfNBxuJEUyEsCMxkzRm7URxXJDr7ysUPSG3mmup4I3qECQG6LaNIBO/UmtUBmT/NqEPAZbf0IXGlkkXyYcBmWJ6IdWX6eC+PEPc6WqvCGofA2NNgpseX5G4YJ2wU+QbeNPDeoRq5YkQIouQKuVceGx0NWclxzLjIw2q/+RTEgN2Sleql2UlbsK8xwcc0wktYH15XKyu/qDFA1JkqExqeEaJwN1XbIDdtEi0/8NTFym530UHIb1ur7qs3gNHggcdW9jAvQHKS7habx25OS8mz1oij4cL02qhyZ8sLCTYoRfw1w1YIJwkY+cNdaOCPy7MQ60ibN+pnTIz0a/O4w/p66hV2QSNUSx9/omkCNqapl4sMlBvyAVukvSRpfCoL3DcMj8hgktOJEv+maPdTu8imNCNrkIOWtjWeiRCMrsoU
 hc9l7uI2
 NBG13mI06HXds97MWTye3d6VJ3sfaFWvOHQc/BLrpCbKQCdVYb4XyxFmqVqzIwRUvg/rNn++kiF8Mfn6RSIgRadnLG6npC51ybLfe+Gby09AYVRMWIS4BxPE6MAazaGFBF+qKQFybA4yMve7BcQ6D2tKNAbbK4kvHL3Ci
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 4a5663c04bb679631985a15efab774da58c37815  Add linux-next specific files for 20251215

elapsed time: 867m

configs tested: 231
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251215    clang-22
arc                   randconfig-001-20251215    gcc-10.5.0
arc                   randconfig-002-20251215    clang-22
arc                   randconfig-002-20251215    gcc-12.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.1.0
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                            hisi_defconfig    gcc-15.1.0
arm                        multi_v7_defconfig    gcc-15.1.0
arm                        mvebu_v5_defconfig    gcc-15.1.0
arm                   randconfig-001-20251215    clang-22
arm                   randconfig-002-20251215    clang-22
arm                   randconfig-003-20251215    clang-22
arm                   randconfig-004-20251215    clang-22
arm                   randconfig-004-20251215    gcc-10.5.0
arm                         s3c6400_defconfig    gcc-15.1.0
arm                        shmobile_defconfig    gcc-15.1.0
arm                         socfpga_defconfig    gcc-15.1.0
arm                       spear13xx_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251215    clang-22
arm64                 randconfig-002-20251215    clang-22
arm64                 randconfig-003-20251215    clang-22
arm64                 randconfig-004-20251215    clang-22
arm64                 randconfig-004-20251215    gcc-9.5.0
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251215    clang-22
csky                  randconfig-001-20251215    gcc-13.4.0
csky                  randconfig-002-20251215    clang-22
csky                  randconfig-002-20251215    gcc-9.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.1.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.1.0
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251215    clang-16
hexagon               randconfig-001-20251216    gcc-8.5.0
hexagon               randconfig-002-20251215    clang-22
hexagon               randconfig-002-20251216    gcc-8.5.0
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.1.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251215    clang-20
i386        buildonly-randconfig-002-20251215    clang-20
i386        buildonly-randconfig-003-20251215    gcc-14
i386        buildonly-randconfig-004-20251215    clang-20
i386        buildonly-randconfig-005-20251215    clang-20
i386        buildonly-randconfig-006-20251215    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20251215    clang-20
i386                  randconfig-002-20251215    clang-20
i386                  randconfig-003-20251215    clang-20
i386                  randconfig-004-20251215    clang-20
i386                  randconfig-005-20251215    clang-20
i386                  randconfig-006-20251215    clang-20
i386                  randconfig-007-20251215    clang-20
i386                  randconfig-011-20251215    clang-20
i386                  randconfig-011-20251215    gcc-14
i386                  randconfig-012-20251215    gcc-12
i386                  randconfig-012-20251215    gcc-14
i386                  randconfig-013-20251215    clang-20
i386                  randconfig-013-20251215    gcc-14
i386                  randconfig-014-20251215    gcc-14
i386                  randconfig-015-20251215    clang-20
i386                  randconfig-015-20251215    gcc-14
i386                  randconfig-016-20251215    gcc-14
i386                  randconfig-017-20251215    clang-20
i386                  randconfig-017-20251215    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.1.0
loongarch                           defconfig    clang-19
loongarch                loongson32_defconfig    gcc-15.1.0
loongarch             randconfig-001-20251215    gcc-14.3.0
loongarch             randconfig-001-20251216    gcc-8.5.0
loongarch             randconfig-002-20251215    clang-18
loongarch             randconfig-002-20251216    gcc-8.5.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.1.0
m68k                       m5208evb_defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                       bmips_be_defconfig    gcc-15.1.0
mips                      bmips_stb_defconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251215    gcc-11.5.0
nios2                 randconfig-001-20251216    gcc-8.5.0
nios2                 randconfig-002-20251215    gcc-11.5.0
nios2                 randconfig-002-20251216    gcc-8.5.0
openrisc                         alldefconfig    gcc-15.1.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                generic-32bit_defconfig    gcc-15.1.0
parisc                randconfig-001-20251215    gcc-12.5.0
parisc                randconfig-002-20251215    gcc-11.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                   lite5200b_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251215    gcc-9.5.0
powerpc               randconfig-002-20251215    clang-22
powerpc                     tqm8560_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20251215    gcc-8.5.0
powerpc64             randconfig-002-20251215    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.1.0
riscv                 randconfig-001-20251215    clang-22
riscv                 randconfig-002-20251215    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.1.0
s390                  randconfig-001-20251215    clang-22
s390                  randconfig-002-20251215    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251215    gcc-13.4.0
sh                    randconfig-002-20251215    gcc-15.1.0
sh                        sh7785lcr_defconfig    gcc-15.1.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251215    gcc-15.1.0
sparc                 randconfig-002-20251215    gcc-12.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20251215    clang-20
sparc64               randconfig-002-20251215    gcc-13.4.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.1.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251215    clang-22
um                    randconfig-002-20251215    gcc-14
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251215    clang-20
x86_64      buildonly-randconfig-001-20251215    gcc-14
x86_64      buildonly-randconfig-002-20251215    clang-20
x86_64      buildonly-randconfig-003-20251215    clang-20
x86_64      buildonly-randconfig-004-20251215    clang-20
x86_64      buildonly-randconfig-005-20251215    clang-20
x86_64      buildonly-randconfig-006-20251215    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251215    gcc-14
x86_64                randconfig-002-20251215    gcc-14
x86_64                randconfig-003-20251215    gcc-14
x86_64                randconfig-004-20251215    clang-20
x86_64                randconfig-004-20251215    gcc-14
x86_64                randconfig-005-20251215    gcc-14
x86_64                randconfig-006-20251215    clang-20
x86_64                randconfig-006-20251215    gcc-14
x86_64                randconfig-011-20251215    clang-20
x86_64                randconfig-012-20251215    clang-20
x86_64                randconfig-013-20251215    clang-20
x86_64                randconfig-014-20251215    clang-20
x86_64                randconfig-015-20251215    gcc-13
x86_64                randconfig-016-20251215    gcc-14
x86_64                randconfig-071-20251215    clang-20
x86_64                randconfig-072-20251215    clang-20
x86_64                randconfig-073-20251215    gcc-14
x86_64                randconfig-074-20251215    gcc-13
x86_64                randconfig-075-20251215    clang-20
x86_64                randconfig-076-20251215    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    gcc-15.1.0
xtensa                randconfig-001-20251215    gcc-8.5.0
xtensa                randconfig-002-20251215    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

