Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA29C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1736B0093; Wed, 15 Jul 2026 00:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172256B0095; Wed, 15 Jul 2026 00:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03BD86B0096; Wed, 15 Jul 2026 00:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF2606B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:59:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AE831A05DC
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:59:48 +0000 (UTC)
X-FDA: 84989808456.30.E31E0D2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf26.hostedemail.com (Postfix) with ESMTP id B35B0140009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:59:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B8GkTfPz;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784091586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=zClwDAZDsO/V6/mEbr4d01KDmSx3/iTShxpwVZPQlc8=;
	b=piY4lcsN7DKd23OLjoOwcce1E+l0FMxbGhhpvDXsuMyPPHYaE+BJA38Xq5Q7NuSfvGcP0S
	g5F3Yehcy7If6d8L/UwEv1hKkv+Vn8PNs+X3TJ+0kP4duHpYZ7uLaVX1UQpT2tz+bKz1LN
	cOl2Pg18w3xrNOZIl2r3lCJaAhWhuL8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B8GkTfPz;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784091586;
	b=wbbKSKoRwivz4r7V0xbGslDpJYszqTwmxKDBQdmfCCCm+7UgmpiPOQKZD/V5aHUlVTTy7H
	AyyFHdgK3wKGSUwyDWOZBMn8Qp6iDVbxsmHjRfhKbrptUUiNF5iRyX6oyz+tmz0rf3WqJR
	c/hAlJk2DscY9yeP+bnYjBvicr2O1BA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784091586; x=1815627586;
  h=date:from:to:cc:subject:message-id;
  bh=pHjAtwDVaR4xFZ5vSz6vmAvqXtYB5lZv4MIthoOc0xo=;
  b=B8GkTfPzqjMHrr0I+JEQihvMgNxpL7kwRk+0bfbldCirKvZlVEkxX91q
   mCv0EPGwAP/wHyKqkOhLh54Qk4WjBQ6oXQP/WMQh00ncGIy3giBwFsD8d
   lg2gSkRZpuyeVF9Umnvo33SBDisP3qXwMAWslHeMPpFW2nvquyab5fv9T
   jFtRGqk5rrqmILcIHokJaB8pVZBySt9MSce+1/911nNpeOQXpTtKZAfvp
   FrEDVPpuSAdd1rCttEM6johcJm7ywCktPmeyc2MxgPkug2wmrKR4dA2n/
   JmTe8xZG+72rt/U/t5fLhLTgKfwsC9aKfqyontMGfQMoxJDjF/PMCnwQK
   Q==;
X-CSE-ConnectionGUID: OE35l3r/SCCBN0hvw6A44A==
X-CSE-MsgGUID: c1i6C7P6RQm/8r7pJawmxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="88398076"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="88398076"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 21:59:45 -0700
X-CSE-ConnectionGUID: wq+V4eYERjSJVIkZjgtYaA==
X-CSE-MsgGUID: wjjKwBU+QA2/QG4vGOQ8Pg==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 14 Jul 2026 21:59:42 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wjriQ-00000000NIl-2wj2;
	Wed, 15 Jul 2026 04:59:30 +0000
Date: Wed, 15 Jul 2026 12:59:14 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 2fc4daf5c4774d70254201aaa5a9d50cae52af5e
Message-ID: <202607151200.G5oomtPt-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B35B0140009
X-Stat-Signature: 9jifuj8en94jigmmhxbxr6hpzqd5mdgq
X-HE-Tag: 1784091585-882215
X-HE-Meta: U2FsdGVkX1/ODHDT/qka/KxD6dNir0HpyGpvL7ShREtFpwCtM8mj5Ph92K1RBfzFb/a0b0pHN6LqwuZ4ZSawAFHBOkGtKzydejxX6l7gOTX3KQ8ZfyDEXYX73GgDKaooE6LGmvMhNGfJJN+vcFAp/NuK8NErrc9Cdsdmcfy+tS4DFPWX6rIH8ZgnRtKDF1jTdso91tP3rdxRxKsBtOY0cONNnCY/juyGErKzSmM02AI5OYbDJ7w7tr3DgVQO8il57fb61SgXVuP7ba/NgUPcVNxcQyODCF7+mQ3qEvL7yVeDfgL7RTwAR7NCDB1aS5Tcf6J1/+pkwhxp00Yk+IUKixe8LOPfbFpS3uydnKNYn/mElUwwySi4jkTJxdiA5lyRs+V6wMqFhmxEuVbUYQo0gE6/iVDxV6+UBfecVRNhKR+im2VDecICUwzFZ1/7z5ygM32dG/rCTzXe6TgNSb6oAlPE3Wv6F+SGbwGE9N+l9eNm4b58PtbX9IuMfPVhtdh5WatiIxbOaorw30LC+atQHM6nRyrlCkrrgEOKCKeLha3RHvHkCqCA4mB702voGRUvpx86QCJn2l86EuHruPOdiuzaBk/fgb4D3D0fknm3fvY93kxoen5vsjFjlo/ybf7AmBj2+8QCXSHD+HIlHi3oaKDlw3kr3MHQhJorDp2PakBG8txsbl1zpFpHwACXqB3hnjfDENMKBvoybKx6uJbsE7qLFoh+uzXoNVk76T97gDzbkioqMYcKsWrIrtkyKajFiinydQSDjBMfFgb6+aZsFAjS24ANnghvavFFrQrFY0enHl687tRYNI5pEZ8ZBz2b8Bn+es2i6EbLv9wsaReA/sqdUGvwg8wiJDUfp4Lwg2ZSTDS4i7FSdips31iS37BitKgCEKiTsCXSaI7oNF3lXgbHJieVOm5bNnSUkh45f+vaAYoN/vBSrWisrVHw9S0YMtChml4nLrkDKzHSsQA
 ZXuEr5hU
 F+Gf8cLyg8vJthAiZphwl7R3wSsOaGNuZw9F/BHeJoo1cnoXSHnOgIDs8xVSd1cGL8WvOUeEjbdBxRVlnv2icpkFdLARbZRbG/Png0VglF+ZWQuW2PiPhR2EiawrgP4TdNJPLMUlM8CZkB44kZLsZPnpeJGwubOKm9akWqK+98T0W64Q+3Pbi9Fo7ahMs28BkVJfaOF+k+ibYugEaGQmmXTcPsOl1LAhswGYj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 2fc4daf5c4774d70254201aaa5a9d50cae52af5e  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:672 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 653)
    mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses

Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r071-20260714
|   `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)
|-- sparc-randconfig-r072-20260715
|   `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses
`-- x86_64-randconfig-161-20260714
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 853m

configs tested: 298
configs skipped: 26

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
arc                   randconfig-001-20260715    gcc-10.5.0
arc                   randconfig-001-20260715    gcc-9.5.0
arc                   randconfig-002-20260715    gcc-10.5.0
arc                   randconfig-002-20260715    gcc-15.2.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260715    clang-23
arm                   randconfig-001-20260715    gcc-10.5.0
arm                   randconfig-002-20260715    gcc-10.5.0
arm                   randconfig-003-20260715    gcc-10.5.0
arm                   randconfig-003-20260715    gcc-15.2.0
arm                   randconfig-004-20260715    gcc-10.5.0
arm                         socfpga_defconfig    gcc-16.1.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260714    clang-17
arm64                 randconfig-001-20260715    gcc-16.1.0
arm64                 randconfig-002-20260715    gcc-16.1.0
arm64                 randconfig-003-20260714    clang-17
arm64                 randconfig-003-20260715    gcc-16.1.0
arm64                 randconfig-004-20260714    clang-23
arm64                 randconfig-004-20260715    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260714    gcc-16.1.0
csky                  randconfig-001-20260715    gcc-16.1.0
csky                  randconfig-002-20260714    gcc-16.1.0
csky                  randconfig-002-20260715    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    clang-17
hexagon               randconfig-001-20260714    clang-20
hexagon                        randconfig-002    clang-23
hexagon               randconfig-002-20260714    clang-23
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260715    clang-22
i386        buildonly-randconfig-002-20260715    clang-22
i386        buildonly-randconfig-002-20260715    gcc-14
i386        buildonly-randconfig-003-20260715    clang-22
i386        buildonly-randconfig-003-20260715    gcc-14
i386        buildonly-randconfig-004-20260715    clang-22
i386        buildonly-randconfig-004-20260715    gcc-14
i386        buildonly-randconfig-005-20260715    clang-22
i386        buildonly-randconfig-006-20260715    clang-22
i386        buildonly-randconfig-006-20260715    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260714    gcc-14
i386                  randconfig-001-20260715    clang-22
i386                           randconfig-002    gcc-14
i386                  randconfig-002-20260714    gcc-13
i386                  randconfig-002-20260715    clang-22
i386                           randconfig-003    gcc-14
i386                  randconfig-003-20260714    clang-22
i386                  randconfig-003-20260715    clang-22
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260714    gcc-14
i386                  randconfig-004-20260715    clang-22
i386                           randconfig-005    gcc-14
i386                  randconfig-005-20260714    gcc-13
i386                  randconfig-005-20260715    clang-22
i386                           randconfig-006    gcc-14
i386                  randconfig-006-20260714    gcc-14
i386                  randconfig-006-20260715    clang-22
i386                           randconfig-007    gcc-14
i386                  randconfig-007-20260714    clang-22
i386                  randconfig-007-20260715    clang-22
i386                  randconfig-011-20260714    gcc-14
i386                  randconfig-011-20260715    gcc-14
i386                  randconfig-012-20260714    clang-22
i386                  randconfig-012-20260715    gcc-14
i386                  randconfig-013-20260714    clang-22
i386                  randconfig-013-20260715    gcc-14
i386                  randconfig-014-20260714    gcc-14
i386                  randconfig-014-20260715    gcc-14
i386                  randconfig-015-20260714    gcc-14
i386                  randconfig-015-20260715    gcc-14
i386                  randconfig-016-20260714    clang-22
i386                  randconfig-016-20260715    gcc-14
i386                  randconfig-017-20260714    gcc-12
i386                  randconfig-017-20260715    gcc-14
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    clang-23
loongarch             randconfig-001-20260714    gcc-16.1.0
loongarch             randconfig-001-20260715    gcc-16.1.0
loongarch                      randconfig-002    gcc-16.1.0
loongarch             randconfig-002-20260714    gcc-14.3.0
loongarch             randconfig-002-20260715    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
m68k                           virt_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        bcm63xx_defconfig    clang-23
mips                      maltaaprp_defconfig    clang-17
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260714    gcc-11.5.0
nios2                 randconfig-001-20260715    gcc-16.1.0
nios2                          randconfig-002    gcc-8.5.0
nios2                 randconfig-002-20260714    gcc-11.5.0
nios2                 randconfig-002-20260715    gcc-16.1.0
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
parisc                randconfig-001-20260714    gcc-13.4.0
parisc                randconfig-001-20260715    clang-23
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260714    gcc-11.5.0
parisc                randconfig-002-20260715    clang-23
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260715    clang-23
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260715    clang-23
powerpc64             randconfig-001-20260715    clang-23
powerpc64             randconfig-002-20260715    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260714    clang-17
riscv                 randconfig-001-20260715    gcc-15.2.0
riscv                 randconfig-002-20260714    gcc-10.5.0
riscv                 randconfig-002-20260715    gcc-15.2.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260714    gcc-8.5.0
s390                  randconfig-001-20260715    gcc-15.2.0
s390                  randconfig-002-20260714    clang-23
s390                  randconfig-002-20260715    gcc-15.2.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260714    gcc-10.5.0
sh                    randconfig-001-20260715    gcc-15.2.0
sh                    randconfig-002-20260714    gcc-12.5.0
sh                    randconfig-002-20260715    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260714    gcc-8.5.0
sparc                 randconfig-001-20260715    gcc-16.1.0
sparc                 randconfig-002-20260714    gcc-8.5.0
sparc                 randconfig-002-20260715    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260714    gcc-11.5.0
sparc64               randconfig-001-20260715    gcc-16.1.0
sparc64               randconfig-002-20260714    gcc-9.5.0
sparc64               randconfig-002-20260715    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260714    gcc-14
um                    randconfig-001-20260715    gcc-16.1.0
um                    randconfig-002-20260714    gcc-14
um                    randconfig-002-20260715    gcc-16.1.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260714    clang-22
x86_64      buildonly-randconfig-001-20260715    gcc-14
x86_64      buildonly-randconfig-002-20260714    clang-22
x86_64      buildonly-randconfig-002-20260715    gcc-14
x86_64      buildonly-randconfig-003-20260714    clang-22
x86_64      buildonly-randconfig-003-20260715    gcc-14
x86_64      buildonly-randconfig-004-20260714    gcc-14
x86_64      buildonly-randconfig-004-20260715    gcc-14
x86_64      buildonly-randconfig-005-20260714    clang-22
x86_64      buildonly-randconfig-005-20260715    gcc-14
x86_64      buildonly-randconfig-006-20260714    gcc-14
x86_64      buildonly-randconfig-006-20260715    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260714    gcc-14
x86_64                randconfig-001-20260715    clang-22
x86_64                randconfig-002-20260714    gcc-12
x86_64                randconfig-002-20260715    clang-22
x86_64                randconfig-003-20260714    gcc-14
x86_64                randconfig-003-20260715    clang-22
x86_64                randconfig-004-20260714    gcc-14
x86_64                randconfig-004-20260715    clang-22
x86_64                randconfig-005-20260714    clang-22
x86_64                randconfig-005-20260715    clang-22
x86_64                randconfig-006-20260714    clang-22
x86_64                randconfig-006-20260715    clang-22
x86_64                randconfig-011-20260715    clang-22
x86_64                randconfig-012-20260715    clang-22
x86_64                randconfig-012-20260715    gcc-14
x86_64                randconfig-013-20260715    clang-22
x86_64                randconfig-014-20260715    clang-22
x86_64                randconfig-015-20260715    clang-22
x86_64                randconfig-016-20260715    clang-22
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260714    gcc-14
x86_64                randconfig-071-20260715    gcc-14
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260714    clang-22
x86_64                randconfig-072-20260715    gcc-14
x86_64                         randconfig-073    clang-22
x86_64                randconfig-073-20260714    clang-22
x86_64                randconfig-073-20260715    gcc-14
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260714    gcc-13
x86_64                randconfig-074-20260715    gcc-14
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260714    clang-22
x86_64                randconfig-075-20260715    gcc-14
x86_64                         randconfig-076    clang-22
x86_64                randconfig-076-20260714    gcc-14
x86_64                randconfig-076-20260715    gcc-14
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
xtensa                randconfig-001-20260714    gcc-11.5.0
xtensa                randconfig-001-20260715    gcc-16.1.0
xtensa                randconfig-002-20260714    gcc-9.5.0
xtensa                randconfig-002-20260715    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

