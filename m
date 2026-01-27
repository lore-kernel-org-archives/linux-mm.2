Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 703DAD2F000
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 12:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17916B00A0; Tue, 27 Jan 2026 07:25:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5586B00A1; Tue, 27 Jan 2026 07:25:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6786B00A2; Tue, 27 Jan 2026 07:25:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 879D36B00A0
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:25:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C4B9140B74
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:25:30 +0000 (UTC)
X-FDA: 84377664420.20.A694A34
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf15.hostedemail.com (Postfix) with ESMTP id D4665A0003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:25:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PkzuqnEY;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769516728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Lg4XnLjpHbIpwytBtM8mXdlIv/ZeB2t0o8sLWvm9mZ0=;
	b=u6MoPRQ/Do6diw/irFeVjgAdONPnbpG9pPGcyrRddLNuj5EOsVfugrWXa9S049mvB9PjDY
	1g0I6GgEnE0Oo5UETTYJSk1+KRYfgSsuwVFf/IquDVVWmT4IhvCVnm5AFfxP/fEMopZG/k
	6iPWOLkFfwa+VS9hc5o5mJ9VzNCCjQU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PkzuqnEY;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769516728; a=rsa-sha256;
	cv=none;
	b=RAaWb7217WXaOZT8luAwhKRosjzaCtbe91B71k2MCtPuz2P03oLcV8WORp5AhaGPVBJoX6
	W0NLPyEmEBYsAuMJBh449jLdcTa6XMLWoSfhLiy1792KUHjh8zEjZ8UevvGi3R3OneR+8T
	RPZV8KwuPsV4Q17gEsvATVS2Mswp+So=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769516728; x=1801052728;
  h=date:from:to:cc:subject:message-id;
  bh=O7N0kFApcw+lmYGGQGRy5yi9yfw+6tufg1LFkSEXvxk=;
  b=PkzuqnEY6xVyj3M77DBuUuL4wWk5KzGSGxFGfPq7zGkp2TpRQ2w/EaR4
   NYmEN9+5ZHYIzws5uYCfTB4sPPn7efha8fzYBO3ptSLJda25lCBf6XL9N
   /2HzBnKpybC3A+pGrLUlEOddtvLg8QHEmBLt/BsrpcPlcDhXCr5BrcOVA
   d/+7ADV1DA+4l8Ici2A0PqDhCLufEBBazJxEycXFfmm69RRQipw/AlECh
   kEPa9jgf7qdXI8ImDjD9KbhUCptaIVA1nTjGdcaYHS3hva/yur8AHQIzA
   hQ/MF7LpgIPdp87kLoN8DIl9SVxWW4txXfG0pG6tWnNpFaci/zNYai6z7
   A==;
X-CSE-ConnectionGUID: zegYk5QnQumKSnvRxXl9ZA==
X-CSE-MsgGUID: m6qQZkY5RISqz5YKI2wFwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="70870085"
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="70870085"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 04:25:27 -0800
X-CSE-ConnectionGUID: 98U8Zf/hT9CWCVJbxbT8IQ==
X-CSE-MsgGUID: abvT2Y0rSRmrEDUBS2raTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="238651252"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 27 Jan 2026 04:25:25 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vki8I-00000000YSi-29BH;
	Tue, 27 Jan 2026 12:25:22 +0000
Date: Tue, 27 Jan 2026 20:24:33 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH UNVERIFIED WARNING
 615aad0f61e0c7a898184a394dc895c610100d4f
Message-ID: <202601272025.0GiIThj4-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: D4665A0003
X-Rspamd-Server: rspam07
X-Stat-Signature: 7k7cjbu9oqpzy6n1ayq6ykgjy98qidwp
X-HE-Tag: 1769516727-836560
X-HE-Meta: U2FsdGVkX1/PoXdlngsKAQdLyIETBGK+u8FxoK4+2aHo3bLx36pBQoHlcy6A4YC356wNe9EHEgjZp0CLyUURlqZNB50ydRVJcXnwCtmqud6Q6zktKFsGI4lpsgspnIXqRZ/eiN8Hb4EmQZtF+FuIZ7BtXhpxG1sK+4C8tUsCQpXSNeBm/8RWT3Ypudaw4vCV/VjH0bXhuJeWJ9BSGebic8oEMD6UtdnzPw8k55YIZK7W3zvvEb/ppI3bjqvtMxTgFl5skxGRewquQ8afiP4fZsp2/YSWGN+hBBJ1gQOz+b8w41yF22GcbWhhhQBw8qufatxwcFF0dXGBD5QwP8SftRdt+3pSGojL56A9skyNFq2yp3kDE7e+rFEJi8KMXr4S6UKeZAHYnAf3/eAkzsVwKJ3dN8yR1xqEuDOHrNYCSMg+4D9e98exCBf9WoUHEGbZ3yEpyq2/ZikakDgj4SdBt2UW7FifekECnbJ39EvQUqsFq5v35GAth9QNIR88z+Hp28yAyN6Q+sbpc+0dmy5jgHcRPtKyDr5s3jmFU/NEsxqmPKVSA6rSDVEAvWttz5uviRUmt4/owGXUA6WNHeGyrL850brmB9v5rBjZqqACZy6p90qxLUjgPB1pjcX2/jfcR10OqVuBNCNUULrww50V94/cnAS3TnPzbpFxHsMkwUYL6cgk/amCQoi4dMG9Vu76Kj0a5nxMFu/nkBvtx3EtviEGNuMO2Q491zUwYAwETFfoNkYxC5oDjPuyFE4D3NPoULGAc0D/B6N1qUBkyHOXX9TpNDbjeeRnt507fBIAesLJ8xVWuQA0nTe1FYPp4bHRRfTfb+CrKcv62jJK2ZSb1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 615aad0f61e0c7a898184a394dc895c610100d4f  Add linux-next specific files for 20260126

Unverified Warning (likely false positive, kindly check if interested):

    drivers/regulator/tps65185.c:452:1: sparse: sparse: bad integer constant expression
    drivers/reset/spacemit/reset-spacemit-k1.c:302:1: sparse: sparse: bad integer constant expression
    lib/tests/list-private-test.c:75:1: sparse: sparse: bad integer constant expression
    lib/tests/min_heap_kunit.c:208:1: sparse: sparse: bad integer constant expression

Warning ids grouped by kconfigs:

recent_errors
|-- loongarch-randconfig-r112-20260127
|   |-- lib-tests-list-private-test.c:sparse:sparse:bad-integer-constant-expression
|   `-- lib-tests-min_heap_kunit.c:sparse:sparse:bad-integer-constant-expression
|-- parisc-randconfig-r121-20260127
|   `-- drivers-regulator-tps65185.c:sparse:sparse:bad-integer-constant-expression
`-- powerpc64-randconfig-r132-20260127
    `-- drivers-reset-spacemit-reset-spacemit-k1.c:sparse:sparse:bad-integer-constant-expression

elapsed time: 727m

configs tested: 247
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260127    gcc-14.3.0
arc                   randconfig-001-20260127    gcc-8.5.0
arc                   randconfig-002-20260127    gcc-11.5.0
arc                   randconfig-002-20260127    gcc-14.3.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260127    clang-22
arm                   randconfig-001-20260127    gcc-14.3.0
arm                   randconfig-002-20260127    clang-18
arm                   randconfig-002-20260127    gcc-14.3.0
arm                   randconfig-003-20260127    gcc-14.3.0
arm                   randconfig-004-20260127    clang-18
arm                   randconfig-004-20260127    gcc-14.3.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260127    gcc-10.5.0
arm64                 randconfig-001-20260127    gcc-15.2.0
arm64                 randconfig-002-20260127    clang-22
arm64                 randconfig-002-20260127    gcc-15.2.0
arm64                 randconfig-003-20260127    gcc-11.5.0
arm64                 randconfig-003-20260127    gcc-15.2.0
arm64                 randconfig-004-20260127    gcc-12.5.0
arm64                 randconfig-004-20260127    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260127    gcc-15.2.0
csky                  randconfig-002-20260127    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260127    clang-22
hexagon               randconfig-001-20260127    gcc-15.2.0
hexagon               randconfig-002-20260127    clang-22
hexagon               randconfig-002-20260127    gcc-15.2.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260127    clang-20
i386        buildonly-randconfig-001-20260127    gcc-14
i386        buildonly-randconfig-002-20260127    clang-20
i386        buildonly-randconfig-002-20260127    gcc-14
i386        buildonly-randconfig-003-20260127    gcc-14
i386        buildonly-randconfig-004-20260127    clang-20
i386        buildonly-randconfig-004-20260127    gcc-14
i386        buildonly-randconfig-005-20260127    gcc-14
i386        buildonly-randconfig-006-20260127    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260127    clang-20
i386                  randconfig-001-20260127    gcc-14
i386                  randconfig-002-20260127    clang-20
i386                  randconfig-002-20260127    gcc-14
i386                  randconfig-003-20260127    clang-20
i386                  randconfig-004-20260127    clang-20
i386                  randconfig-004-20260127    gcc-14
i386                  randconfig-005-20260127    clang-20
i386                  randconfig-005-20260127    gcc-14
i386                  randconfig-006-20260127    clang-20
i386                  randconfig-007-20260127    clang-20
i386                  randconfig-011-20260127    gcc-14
i386                  randconfig-012-20260127    gcc-12
i386                  randconfig-012-20260127    gcc-14
i386                  randconfig-013-20260127    gcc-14
i386                  randconfig-014-20260127    clang-20
i386                  randconfig-014-20260127    gcc-14
i386                  randconfig-015-20260127    clang-20
i386                  randconfig-015-20260127    gcc-14
i386                  randconfig-016-20260127    gcc-14
i386                  randconfig-017-20260127    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260127    gcc-15.2.0
loongarch             randconfig-002-20260127    clang-18
loongarch             randconfig-002-20260127    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260127    gcc-11.5.0
nios2                 randconfig-001-20260127    gcc-15.2.0
nios2                 randconfig-002-20260127    gcc-11.5.0
nios2                 randconfig-002-20260127    gcc-15.2.0
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260127    gcc-11.5.0
parisc                randconfig-002-20260127    gcc-13.4.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260127    gcc-14.3.0
powerpc               randconfig-002-20260127    clang-22
powerpc64             randconfig-001-20260127    gcc-11.5.0
powerpc64             randconfig-002-20260127    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260127    clang-22
riscv                 randconfig-002-20260127    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260127    gcc-13.4.0
s390                  randconfig-002-20260127    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260127    gcc-13.4.0
sh                    randconfig-002-20260127    gcc-10.5.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260127    gcc-15.2.0
sparc                 randconfig-002-20260127    gcc-15.2.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260127    clang-20
sparc64               randconfig-001-20260127    gcc-15.2.0
sparc64               randconfig-002-20260127    clang-20
sparc64               randconfig-002-20260127    gcc-15.2.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260127    clang-20
um                    randconfig-001-20260127    gcc-15.2.0
um                    randconfig-002-20260127    clang-22
um                    randconfig-002-20260127    gcc-15.2.0
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260127    clang-20
x86_64      buildonly-randconfig-001-20260127    gcc-14
x86_64      buildonly-randconfig-002-20260127    gcc-14
x86_64      buildonly-randconfig-003-20260127    gcc-14
x86_64      buildonly-randconfig-004-20260127    gcc-14
x86_64      buildonly-randconfig-005-20260127    gcc-14
x86_64      buildonly-randconfig-006-20260127    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260127    clang-20
x86_64                randconfig-001-20260127    gcc-14
x86_64                randconfig-002-20260127    clang-20
x86_64                randconfig-002-20260127    gcc-14
x86_64                randconfig-003-20260127    clang-20
x86_64                randconfig-004-20260127    clang-20
x86_64                randconfig-004-20260127    gcc-14
x86_64                randconfig-005-20260127    clang-20
x86_64                randconfig-006-20260127    clang-20
x86_64                randconfig-006-20260127    gcc-14
x86_64                randconfig-011-20260127    clang-20
x86_64                randconfig-012-20260127    clang-20
x86_64                randconfig-012-20260127    gcc-13
x86_64                randconfig-013-20260127    clang-20
x86_64                randconfig-014-20260127    clang-20
x86_64                randconfig-015-20260127    clang-20
x86_64                randconfig-015-20260127    gcc-13
x86_64                randconfig-016-20260127    clang-20
x86_64                randconfig-071-20260127    gcc-14
x86_64                randconfig-072-20260127    gcc-14
x86_64                randconfig-073-20260127    gcc-14
x86_64                randconfig-074-20260127    clang-20
x86_64                randconfig-074-20260127    gcc-14
x86_64                randconfig-075-20260127    clang-20
x86_64                randconfig-075-20260127    gcc-14
x86_64                randconfig-076-20260127    clang-20
x86_64                randconfig-076-20260127    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260127    gcc-15.2.0
xtensa                randconfig-002-20260127    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

