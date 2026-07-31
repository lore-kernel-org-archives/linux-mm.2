Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF80FC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 14:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4ED06B0092; Fri, 31 Jul 2026 10:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF4D6B0093; Fri, 31 Jul 2026 10:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15CD6B0095; Fri, 31 Jul 2026 10:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70A796B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:10:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF387140462
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:10:57 +0000 (UTC)
X-FDA: 85049258154.28.AEB2418
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4F6A3180008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:10:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FrBUIocc;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785507056;
	b=kmTj/K8pw44PsAj935Cg+564dD6Hc22bDHWhCv547nZRX5ExToR8jDF+hFhlrYN3gOq47g
	SZ+7qoySyYRtIloJ48JpGkwDjrwM3V1zFj627UjQxg3zXJqcRVwOKrIkRDX5Zgreo8+OoK
	WVYAA0+MxqIMbGggSuVOfbFWXxpko1g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FrBUIocc;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785507056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=NGiwgHWOezJt2hBdKiZJjk62wI8H8YGwRRUsHuHsTt4=;
	b=zC3+EoX7CIROoi5twPg+IMjg97vs+r+4QebiSc9HlHVzk7Fa+9u5m8Vyy6CUP9O6B14UuT
	Z/ETboE6X+pg5ZQ74lcaOlimhfms2ACwaHWu5Zc0wT5UDWQ/FsbYD1m66P4GJ2JSl1HiYw
	Eu9VnYInQIGPxQTnbchmrZ03ebMM7Bc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785507056; x=1817043056;
  h=date:from:to:cc:subject:message-id;
  bh=mK8SQSzWl2+2HPhrjcyupr8TXBBiJ8aOmMsLP/UaZiA=;
  b=FrBUIoccXf8IZmwodbiM/5bP9jqNV8Ncd8W+lMfPotQJi56PUhs/ij8r
   wfqcnFO2YFUwskK472A6cmyB29s5fVgDIJBwxmzMa8rv+x4bCafwN3uwZ
   n/hO1k3h523HpwPrX022ncK+ufUfsOqHbFaNisu9HVS0oS0mKgmZ32M4m
   znOKSRrwsxoSI6/PJLbaN1tVfqYOMsXhB0KKyCVvQqlDFluSvZox3LEXf
   9BtDfAldEfrjIjjMkxZaXsErXzlK+1ppT1dAEnqMU90elo4RHXEvzbC66
   TUBeVTN8ZFGZIy0oXvxjNZhgdMFZn0bfzHyhQVQ6J9mdbej4e5ZfaDSRR
   g==;
X-CSE-ConnectionGUID: BAWcgfpeQtyvMBT3cjXTEw==
X-CSE-MsgGUID: l0CblS1lQEu0rlnV+nitSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="103541133"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="103541133"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 07:09:43 -0700
X-CSE-ConnectionGUID: NCPei3Y0QAyjM138LFOsjA==
X-CSE-MsgGUID: vNxx0yabQfeAhIgZqiaWqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="265649558"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 31 Jul 2026 07:09:42 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wpnvf-0000000018S-37JY;
	Fri, 31 Jul 2026 14:09:39 +0000
Date: Fri, 31 Jul 2026 22:08:39 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:misc] BUILD SUCCESS
 78fac571b06490654af45c902c7ab5f651fe7067
Message-ID: <202607312228.k2PpXsYR-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: awpmf9fpk8ihg4i4ogbpeq496s7we49p
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4F6A3180008
X-Rspam-User: 
X-HE-Tag: 1785507055-212104
X-HE-Meta: U2FsdGVkX19Q5aGZp93/YeaqJRXGy1Bl+p0oKfoAsYkAU4E0zJvedPRNX0lt75jTVCSGfoq3EnBChprqn2K9ol+mVj+CjRGj14qnH17U3adZwBipKRrdTuZSiN1rBZNZ8BIWElFzRmAKw3InhI9bpk4yRSzBJbeHuccJrUdnsJyVV4tHnVhZRToHhUecOBAn1oRxPYTb1twZZ71AF8ENMGP0c7AOVOAeTFu1cElBwvbRKi02CM5Xz9mQeUt/UHaiJLXBUGLPN0asHa28eXL0l/c8lMbwYDgBBo/Oo0oFzM/3fimnAKDnDSKEt8S3pOTookXjdH02GieU9noBjcpQSNwrWHx9L1NHIKTQ+cJZwBrkI8W5PBCfN2WXZeb43hcfe4tufHgftLJedUunauzphEe/HlI2Q7Lmas3eHczmGAwnTu/q07gi0doQBOxCP0GZODAhcbvHh5PEtNHnI/JZeSZ4BgwZ5pVQeH0Q0bKJqYy03c/69eLWa4kOooYeWbc6u5f/v/ZRcpHB4KXjnx4BuaMH7rT+wT0t9BY4iYk9XYk2FUgaraoUTNNZ6qaZkpfYxCMVxciYusvuuoZKwBs5kJeP5QTrnnNA/sjaWbdzvuLXsEztsnqQbDIDeTrEpVEITTPXQQQAZiOXpjWn+Xks9mmHNJ/NJpVttq3brKWTZriwI0TuEHYoAmAtqOwZk5If/rJYSxPghY2v8VBrFyAUJV6yfaUJWyrlip51ZX3HpcIIliyTY0IqAD1l/Pra0f2IdpByFy60q+ELF9VnWZzAfEqqwu/eBf75LkoMnFiQJlR0vh6iRT41K2BKOPEBtAnRcqBy7FZeHn4ika4L2k9hnaopR5b1ffKvb745rnBh/HmOE7+SEMddEc+PqctwUsyLemrNV0ckr6urOlYW9UKGqd5Smz6/0Nj2IYEAhvMnipKWQOkC7IRlkYV/ujDWbkljm6sRIsGobs9gAJZ2d5G
 I7vgSDAV
 BwRoZxx7t7ZSNWXFlcd+XvBQfSTBtsMC3Q8iFCbN1zFZu0AtSo1zbSZwTBoNyatS3W6sI0MeKCnhH6mp8AoKr3k/A0b3zsDJ2CWpWQaqSh43r5ATh5WHyq5UU65fU9poT4vrVtEk8ZTciU2N2oNp6/EZd9Mel4rTtMcRPH3zphAlUcLm6jp46JUQm9Eml1UVquA/x8XhjjihTH9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git misc
branch HEAD: 78fac571b06490654af45c902c7ab5f651fe7067  mm/mm_init: remove unnecessary initialization of pgdat->per_cpu_nodestats

elapsed time: 794m

configs tested: 105
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260731    clang-17
arc                  randconfig-002-20260731    clang-17
arm                           mmp2_defconfig    gcc-16.1.0
arm                  randconfig-001-20260731    clang-17
arm                  randconfig-002-20260731    clang-17
arm                  randconfig-003-20260731    clang-17
arm                  randconfig-004-20260731    clang-17
arm64                randconfig-001-20260731    gcc-8.5.0
arm64                randconfig-002-20260731    gcc-8.5.0
arm64                randconfig-003-20260731    gcc-8.5.0
arm64                randconfig-004-20260731    gcc-8.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260731    gcc-8.5.0
csky                 randconfig-002-20260731    gcc-8.5.0
hexagon                       randconfig-001    clang-24
hexagon              randconfig-001-20260731    clang-24
hexagon              randconfig-002-20260731    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260731    clang-22
i386       buildonly-randconfig-002-20260731    clang-22
i386       buildonly-randconfig-003-20260731    clang-22
i386       buildonly-randconfig-004-20260731    clang-22
i386       buildonly-randconfig-005-20260731    clang-22
i386       buildonly-randconfig-006-20260731    clang-22
i386                 randconfig-001-20260731    gcc-14
i386                 randconfig-002-20260731    gcc-14
i386                 randconfig-003-20260731    gcc-14
i386                 randconfig-004-20260731    gcc-14
i386                 randconfig-005-20260731    gcc-14
i386                 randconfig-006-20260731    gcc-14
i386                 randconfig-007-20260731    gcc-14
i386                 randconfig-011-20260731    clang-22
i386                 randconfig-012-20260731    clang-22
i386                 randconfig-013-20260731    clang-22
i386                 randconfig-014-20260731    clang-22
i386                 randconfig-015-20260731    clang-22
i386                 randconfig-016-20260731    clang-22
i386                 randconfig-017-20260731    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260731    clang-24
loongarch            randconfig-002-20260731    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260731    clang-24
nios2                randconfig-002-20260731    clang-24
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-8.5.0
parisc               randconfig-001-20260731    gcc-8.5.0
parisc               randconfig-002-20260731    gcc-8.5.0
powerpc              randconfig-001-20260731    gcc-8.5.0
powerpc              randconfig-002-20260731    gcc-8.5.0
powerpc64            randconfig-001-20260731    gcc-8.5.0
powerpc64            randconfig-002-20260731    gcc-8.5.0
riscv                   nommu_k210_defconfig    clang-24
riscv                         randconfig-001    clang-19
riscv                randconfig-001-20260731    clang-19
riscv                randconfig-002-20260731    clang-19
s390                 randconfig-001-20260731    clang-19
s390                 randconfig-002-20260731    clang-19
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260731    clang-19
sh                   randconfig-002-20260731    clang-19
sparc                         randconfig-001    gcc-14
sparc                randconfig-001-20260731    gcc-14
sparc                randconfig-002-20260731    gcc-14
sparc64              randconfig-001-20260731    gcc-14
sparc64              randconfig-002-20260731    gcc-14
um                   randconfig-001-20260731    gcc-14
um                   randconfig-002-20260731    gcc-14
x86_64     buildonly-randconfig-001-20260731    gcc-14
x86_64     buildonly-randconfig-002-20260731    gcc-14
x86_64     buildonly-randconfig-003-20260731    gcc-14
x86_64     buildonly-randconfig-004-20260731    gcc-14
x86_64     buildonly-randconfig-005-20260731    gcc-14
x86_64     buildonly-randconfig-006-20260731    gcc-14
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260731    gcc-14
x86_64               randconfig-002-20260731    gcc-14
x86_64               randconfig-003-20260731    gcc-14
x86_64               randconfig-004-20260731    gcc-14
x86_64               randconfig-005-20260731    gcc-14
x86_64               randconfig-006-20260731    gcc-14
x86_64               randconfig-011-20260731    gcc-14
x86_64               randconfig-012-20260731    gcc-14
x86_64               randconfig-013-20260731    gcc-14
x86_64               randconfig-014-20260731    gcc-14
x86_64               randconfig-015-20260731    gcc-14
x86_64               randconfig-016-20260731    gcc-14
x86_64               randconfig-071-20260731    clang-22
x86_64               randconfig-072-20260731    clang-22
x86_64               randconfig-073-20260731    clang-22
x86_64               randconfig-074-20260731    clang-22
x86_64               randconfig-075-20260731    clang-22
x86_64               randconfig-076-20260731    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260731    gcc-14
xtensa               randconfig-002-20260731    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

