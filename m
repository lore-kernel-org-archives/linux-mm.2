Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E34C8C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 04:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911686B008A; Sat, 29 Aug 2026 00:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2486B008C; Sat, 29 Aug 2026 00:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B09D6B0092; Sat, 29 Aug 2026 00:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0A86B008A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:26:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B66AE1A061C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:26:13 +0000 (UTC)
X-FDA: 85153019826.12.EAAF689
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id 09A8714000C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:26:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EA6O5jIK;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787977571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=T/aWLkzBVI/VIAQQKY6/wtEgBrVe+zV1J2fKgdGHUJc=;
	b=t6OgljnlUASYVmLWRZUP8F8OZIWiP1t4RxMtHTzdZ+xlR/knD+6FXaN9Ox9otCjoxXjAFO
	h/4fz+eeuegfisQiedxv3ZwQsmzpEQjRhEQS76HW8ZfgQANsXbj9muf8LoPswgfRLp6PT2
	inlcF7sQ7CB4SMznw++vmCE0Et4T1nE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787977571;
	b=SaA8xORSeOULlWP4EejjS13FHu+XhbrYowIR3u19qZb1iyhv20S/+MTRbbFDJ5SxdJLMvk
	B+VDlj88GIwLDtWwckLnqEWtPQOz7Pszg4DdCSft3ITadeFz0zHOZ0iHohDoITGWBl07/e
	SX0Tb6cyeAQLapwHNFbamg+hn1Tyqes=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EA6O5jIK;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787977571; x=1819513571;
  h=date:from:to:cc:subject:message-id;
  bh=osy4uTCsiN3URvtsQXKWIiu+SdzwYiN2rStibqB6GxM=;
  b=EA6O5jIK9oyA1mq2aad0xkRiY5mNflwSDne8tw1blJwap6TOg2g84RoB
   oPw8VVNXirVIFHrSKdJhbCz8fflAowzenaRkoifH384Q43nOI2fOAMFby
   cEucb5P4okU5/cnNvUx2VsPktO/lNBtvkiI6sksuMco4EhJRROBCphEo8
   W40G/kGFG09s9SvmpORDXC8cJpU4ExFQTM+skbYftMSX8oVxa5Dx51R4S
   UWrwJVm57xCtA1ZXviu628tBINF5FTn+M57lXRtcEr7AwPFt5Jrila0Rr
   aAXlL8PMQtSdl5qdjpOxmg+DTvBcEmhUlJ/BNtSAwa3q1e4xCR2m/h8LN
   Q==;
X-CSE-ConnectionGUID: pggjPqurSGmJrDqwUw3D3Q==
X-CSE-MsgGUID: dbI9hNAXTSm+T45DBCupGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="105857056"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="105857056"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 21:26:10 -0700
X-CSE-ConnectionGUID: cwlDOAQxSvKgwpckCjNCiQ==
X-CSE-MsgGUID: ljDTGcmITyydJ652Ewl4cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="293140226"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 28 Aug 2026 21:26:07 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x0Adp-00000000CNA-2Jbe;
	Sat, 29 Aug 2026 04:26:05 +0000
Date: Sat, 29 Aug 2026 12:25:51 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 d2aad7fdcda7ae8a726926f2d6de7fe9e8ee7563
Message-ID: <202608291234.wlX3byr7-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 09A8714000C
X-Stat-Signature: 71aqsca959ej1e8suyijmxm9ww5e68a1
X-HE-Tag: 1787977570-126388
X-HE-Meta: U2FsdGVkX1/8i3GuKZnizp1zoxCjQY43WfUrarlofNaGLiVLSvsNvXbDCSKSkVYzus6lti+Vs7yu5YvBRXrLfliCGSUo+Ij/2uSeDS51907DPqLWmMTo7/bolEPng2+P/8C7SeUHLcWpz6kaxlpaTOFNVwgs6zRNsMHamOqBMAK0wbSY+EvXLHGRNX+L1Wu53tX3cq0VfJ1R/DBW6novMkR+FO0R828POAmRqUip4br3De4NgMG+pI1lLY+VSJFjO2YcSyLZmWYQys41K84r1aCVHP60A452JbwsTOyPYJO//Fe1SzX0lLMEuJBugiJEMB51cKtDlsKq4JJndv0MTHpQnYobfSWALvr2wHoevmM9xEZVybdlYVSk2AWid+YGB8bfJBZ1yfkAXQshZwYkjstPWvm8OAUe4ImgclMtkSBUo+f4h5uUrwije/RQueS6WAC63Vxzl2Eubv6wqw65lbgG/qY6a3VOzL+DUiGc8eB/8BiaG0zdTmLzJ1zyHpM+VGqkI3RboATQ2FEv4+y7l0Q2vN2ZDiU6V3rUwyGHCasQveHn+QO6ctwFQnF8bB8Dyf4cebc4epUiLCGr6zxNIE0oAb4kiCxyEKyir+txFHgTjuu2rKJsnhQNooY0fYYo05kJvXW3YTcjCa5XXPFEMCSicXDIRuOB9o6tCqUKeKMpmIZGjtklUmh5dgkk7aW5Tu6bgGEACR2ouy73ga2nSwHioWrBr3RqYkCOusxeMp8aE06iiumccqJKVaJPodEN9D4BlWOka35Cv4Ry811i6kxWuOgC9vHsoWuHQIq8Dx/zX+Zf8OiiOzu0oM1b7BnQYpOD8DknjvwLbGtl0L8Dprd2Zk48QvGQKExfqSDfTZruNyHyRd2VheywDAFNDKodg2x1c3r03oQ1sbb4zyWVOJ6zohMWxeFzGT74NIGHYWFSZHSpqMKd6wgbM5g9am4syykcbyCFMXB9GjOBRLQ
 7AA9fUSB
 hn4WIEoteuOWw1/DhOHCcHUUc5dCKk4eXedbAJpteUKrsJhRJKaRvbib5vv3K3Y67b7BN1nma1ucP3yFYH4WYcsKr0kBePxkqWTkDj3eGh1emrgqRJDrWyjWSUMvQl+t29pJlfHbt+ch4fTdCKUccHTupZXB24SgilfbMvUubiZ07Q9dXRP6qgfe0yM/NijhECNuDRm7HhVFy0d8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: d2aad7fdcda7ae8a726926f2d6de7fe9e8ee7563  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 830m

configs tested: 163
configs skipped: 10

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-24
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-24
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                     nsimosci_hs_defconfig    gcc-16.1.0
arc                   randconfig-001-20260829    clang-18
arc                   randconfig-001-20260829    gcc-8.5.0
arc                   randconfig-002-20260829    clang-18
arc                   randconfig-002-20260829    gcc-11.5.0
arc                        vdk_hs38_defconfig    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-24
arm                              allyesconfig    gcc-16.1.0
arm                         at91_dt_defconfig    clang-17
arm                                 defconfig    clang-24
arm                             pxa_defconfig    gcc-16.1.0
arm                   randconfig-001-20260829    clang-18
arm                   randconfig-002-20260829    clang-18
arm                   randconfig-003-20260829    clang-18
arm                   randconfig-003-20260829    gcc-8.5.0
arm                   randconfig-004-20260829    clang-18
arm                   randconfig-004-20260829    gcc-8.5.0
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
hexagon                          allmodconfig    clang-24
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-24
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-24
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-002-20260828    gcc-14
i386        buildonly-randconfig-003-20260828    clang-22
i386        buildonly-randconfig-004-20260828    clang-22
i386        buildonly-randconfig-005-20260828    clang-22
i386                                defconfig    clang-22
i386                  randconfig-011-20260828    clang-22
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-24
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-24
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
m68k                       m5329evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                   sb1250_swarm_defconfig    gcc-16.1.0
nios2                         10m50_defconfig    gcc-11.5.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-24
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
openrisc                         allmodconfig    clang-20
openrisc                          allnoconfig    clang-24
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-24
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260828    gcc-9.5.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260828    gcc-8.5.0
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-24
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260828    gcc-10.5.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260828    gcc-12.5.0
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-24
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-24
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260828    gcc-8.5.0
sparc                          randconfig-002    gcc-11.5.0
sparc                 randconfig-002-20260828    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-12.5.0
sparc64               randconfig-001-20260828    gcc-11.5.0
sparc64                        randconfig-002    clang-20
sparc64               randconfig-002-20260828    gcc-9.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-24
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-24
um                    randconfig-001-20260828    clang-24
um                             randconfig-002    clang-24
um                    randconfig-002-20260828    gcc-14
um                           x86_64_defconfig    clang-24
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260828    clang-22
x86_64      buildonly-randconfig-002-20260828    gcc-14
x86_64      buildonly-randconfig-005-20260828    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-003-20260828    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-24
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

