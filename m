Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35C4AC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 07:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDFC36B007B; Sat, 25 Jul 2026 03:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91076B0088; Sat, 25 Jul 2026 03:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA62F6B008A; Sat, 25 Jul 2026 03:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5A236B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:13:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2995A12027A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 07:13:11 +0000 (UTC)
X-FDA: 85026432582.28.E7A44F6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf29.hostedemail.com (Postfix) with ESMTP id AEBB0120002
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 07:13:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QROhDAIA;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784963589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Ves5ls51wjGf7ZRLx6f2ajRyTyIGCnvdWYvlufRCwWw=;
	b=8ZoQHboPHpFGhdVbJGu8mHDjoIHm4aVyyMCNIeinrUrowPqsZ9DWh22azRay2+asU1ghlz
	C9Nrm+JOVBRgYkOm6ePmljRB6GR9rBey2MLicM02ZwokFuQIqAOc5ZcH0tukYLnmPRCeH0
	PO01nqMvqsyWwF0QdYtYYmutmxmYr8k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784963589;
	b=8auZztm1r6275DjJeSu/mHSvX+UwRm0YvoNwDrxXWbhWrLdVpPflz2y0S+v8Xl2QeiGiz5
	t5dD9hlJwFcGxIcqKsKAzh/gEE7FDJ6XI948xQMW2Ll62u6X1kgfZDckx1kP/Yc2QVUN2t
	EVG17mVLrlBYx+gsszVUrMisF8YWANc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QROhDAIA;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784963587; x=1816499587;
  h=date:from:to:cc:subject:message-id;
  bh=MpetJc+dqyBth0NSHhYUJzOujxWmY7Dbkr/tCp/KxjA=;
  b=QROhDAIABA5K7iS4+vyvoqpFSh0DX36qNTAoZbJ1P5qSmlkWc5Mz4Wgq
   PspHB7VJW+2BTT0Z5jIaHHadDfKPi9/u3wE3a8WR7nhKdtit8zYKWpAx0
   W9/TEgyUBazzkQSKd6NGny2nbSBzZizO3olrX8r+FFXLrnbeX+XXjSY4m
   fdS+K7nzym4BTZHB/qtLDsNJczSyVnVKTFZKbwWKt6KNJ9/MP1uB+ipRe
   hIXH0SoQT4dyVgf4R6HTm1GFLKiTx1fjp12ocajXcV14JQ69xJzrHlY8i
   tRNGTDjS7AQZLvsPM7qKCmP1O+uRmee6SA9ICqWw0YV21o/WgkKmmBiOI
   g==;
X-CSE-ConnectionGUID: vSp3oeezRLShcZMoLTdKZA==
X-CSE-MsgGUID: tux/hg/3QgaSnUoJoX0Vpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="73160274"
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="73160274"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 00:13:06 -0700
X-CSE-ConnectionGUID: MVE1/rlCQHmLB5Ops7gaAA==
X-CSE-MsgGUID: GR3LEALYSeSyKPcCYqUYOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,184,1779174000"; 
   d="scan'208";a="259560280"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 25 Jul 2026 00:13:05 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnWYl-00000000bXi-0kmc;
	Sat, 25 Jul 2026 07:12:43 +0000
Date: Sat, 25 Jul 2026 15:11:38 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487
Message-ID: <202607251512.KMStVfrY-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 3emo7w6jb84iw9hjme8wnoodxstr8zri
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AEBB0120002
X-HE-Tag: 1784963587-950169
X-HE-Meta: U2FsdGVkX1/8KjlxUhOeB8Tf8UZZgaoUolgdnUyFfqOnrfWzUqEFFNa5NASCrgXoxqi5cPPJbFmIDn/goDw3WJuHvHL7EbGGWJG3nZhabbW9wdfChfWWwfKPnFxZs5HZC7oQnl6+UzgYSKn9zSN80Ijtw1xwqCJXa0oTU34GJ1D+gL/2fhre5E8YB6+6riuU0eC+KoOTHnEensgBAtySFqHW4lmyt1LaJBobj671iUX5rotyLgLEg0+spzcUL4PUFm8IIAMDRa1TrG0axskU8Zn/jAq/ffaLgHNllCmgXlMr3cA4DHJARHqu27ndjnW4vEU4ANWvRC+aSwtxoquIIVRay8RKPFFlIJhWC5Lr4VVJ5W0VInX9mApQfvR4Z2iWGX+d31NOOhDEINPYGihCqLWTVvTH9tPUNYaVAZ8/p49w8nxDOubaf4ECPi6w/FUJvWgJR/gxrRaaTnxPknjkIK0eTklQslPPnHNxNxuI0Qnx1OG4vsgwUAqlTLj0iqQQ/Jo3xDBs+WpysqKEBFJZ/5BNhTKmGfPFiE/sJLe3a0WSG8SokEpA2zujGCQEeVnOkXVqcXSGhv4R+4K1ookgwB7ZiGK84bOALi/0sk0XWFSnt8sS2XyNW9FsUfTJztoPzbGTqcBTyCIiiOwdvW27r4MwusCTseFPkKaqVrspBfGwzasCN478XuPSQRwW4K0emSiK5yQvTfMNS3EtyYJPjY/ltqEHWjYOAoPbLSCAmLOK44QYJXty87xE0W1TAU18jI8tdo6u25Twg4jwcr4YeTWHJfeB+iLlXSf5L31SPw0nAky1U0HO3SlO2xhRA/oyb36J6q2oRahfeDUo4hK9LDjosgmh037bR2wsChjVhhQAx1GVFVeFew0KtoZSC1zU/S5VbZxES9WUWjG35sMy40fAWhilwRAVB5+hQGnt4ZC7fWDCOMXySc+nxASXk6Rid9EJp34mGkrtx+7+VT2
 s8YvwjgB
 zQViTWsedFp61t0zs4Hb8QDe/mxK8TnMk+HsoPIIpzxxFKrOxpO3yKLtH8aGq5qiTUMj7eGNBar/+gZJ7C0aJOH2vk6uz3uyThxUu0rlERNHfPn1yE+WaU5disj6bQTBhxrWsNJU5M2gzRjjNGNIxB1qx5PoUGJExXzTdx5BCsB2ngxLG9w+xoq8wHhPxYteQFWOoO9k6cW2NBg7qmol7HHWpds9ArEFzRM05
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
    mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses

Warning ids grouped by kconfigs:

recent_errors
|-- microblaze-randconfig-r072-20260725
|   `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)
`-- um-randconfig-r073-20260725
    |-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)
    `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses

elapsed time: 998m

configs tested: 92
configs skipped: 8

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260725    gcc-11.5.0
arc                  randconfig-002-20260725    gcc-8.5.0
arm                  randconfig-001-20260725    gcc-8.5.0
arm                  randconfig-002-20260725    clang-21
arm                  randconfig-003-20260725    gcc-10.5.0
arm                  randconfig-004-20260725    gcc-15.2.0
arm64                randconfig-001-20260725    clang-24
arm64                randconfig-002-20260725    gcc-13.4.0
arm64                randconfig-003-20260725    clang-24
arm64                randconfig-004-20260725    clang-24
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260725    gcc-9.5.0
csky                 randconfig-002-20260725    gcc-16.1.0
hexagon                       randconfig-001    clang-17
hexagon              randconfig-001-20260725    clang-17
hexagon              randconfig-002-20260725    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260725    clang-22
i386       buildonly-randconfig-002-20260725    gcc-14
i386       buildonly-randconfig-003-20260725    clang-22
i386       buildonly-randconfig-004-20260725    clang-22
i386       buildonly-randconfig-005-20260725    gcc-14
i386       buildonly-randconfig-006-20260725    gcc-14
i386                 randconfig-001-20260725    clang-22
i386                 randconfig-002-20260725    gcc-14
i386                 randconfig-003-20260725    gcc-14
i386                 randconfig-004-20260725    gcc-12
i386                 randconfig-005-20260725    clang-22
i386                 randconfig-006-20260725    gcc-14
i386                 randconfig-007-20260725    gcc-14
i386                 randconfig-011-20260725    gcc-14
i386                 randconfig-012-20260725    gcc-14
i386                 randconfig-013-20260725    gcc-14
i386                 randconfig-014-20260725    clang-22
i386                 randconfig-015-20260725    clang-22
i386                 randconfig-016-20260725    clang-22
i386                 randconfig-017-20260725    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260725    gcc-16.1.0
loongarch            randconfig-002-20260725    gcc-13.4.0
m68k                      m5249evb_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260725    gcc-11.5.0
nios2                randconfig-002-20260725    gcc-9.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260725    gcc-10.5.0
parisc               randconfig-002-20260725    gcc-12.5.0
powerpc              randconfig-001-20260725    gcc-9.5.0
powerpc              randconfig-002-20260725    gcc-15.2.0
powerpc64            randconfig-001-20260725    clang-17
powerpc64            randconfig-002-20260725    clang-24
riscv                randconfig-001-20260725    gcc-8.5.0
riscv                randconfig-002-20260725    gcc-8.5.0
s390                 randconfig-001-20260725    gcc-10.5.0
s390                 randconfig-002-20260725    gcc-16.1.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260725    gcc-16.1.0
sh                   randconfig-002-20260725    gcc-11.5.0
sparc                randconfig-001-20260725    gcc-16.1.0
sparc                randconfig-002-20260725    gcc-8.5.0
sparc64              randconfig-001-20260725    gcc-8.5.0
sparc64              randconfig-002-20260725    gcc-10.5.0
um                   randconfig-001-20260725    gcc-14
um                   randconfig-002-20260725    clang-24
x86_64               randconfig-001-20260725    gcc-14
x86_64               randconfig-002-20260725    clang-22
x86_64               randconfig-003-20260725    clang-22
x86_64               randconfig-004-20260725    clang-22
x86_64               randconfig-005-20260725    clang-22
x86_64               randconfig-006-20260725    clang-22
x86_64               randconfig-011-20260725    gcc-14
x86_64               randconfig-012-20260725    gcc-14
x86_64               randconfig-013-20260725    gcc-14
x86_64               randconfig-014-20260725    gcc-14
x86_64               randconfig-015-20260725    gcc-14
x86_64               randconfig-016-20260725    gcc-14
x86_64               randconfig-071-20260725    gcc-14
x86_64               randconfig-072-20260725    gcc-14
x86_64               randconfig-073-20260725    gcc-14
x86_64               randconfig-074-20260725    gcc-14
x86_64               randconfig-075-20260725    gcc-14
x86_64               randconfig-076-20260725    clang-22
xtensa               randconfig-001-20260725    gcc-16.1.0
xtensa               randconfig-002-20260725    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

