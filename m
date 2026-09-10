Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC4D4C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 03:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BAAB6B008A; Wed,  9 Sep 2026 23:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BAF6B008C; Wed,  9 Sep 2026 23:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581B56B0098; Wed,  9 Sep 2026 23:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 285456B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:52:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 577FF1C21D8
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:52:26 +0000 (UTC)
X-FDA: 85196480292.12.6385675
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1674040004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:52:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eB6tfGQK;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789012344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=dvmSpjNBwM/l5YYIZQ4u1G0WtcrVvNTeI0Ux7fKRycM=;
	b=HPRn5CH8p7xQQiNIt3+FOOOGoRySMBryaa0xiCjn8Ep50PZ/o3z/v25yUpk7F8Q7aOocP7
	99v7Xh//xW9VcgqHUQ0mwFip6TG0+27T/NJpYB58bmNZ4iukjHf2nT8jFDRPR59HyU7GsC
	fOi3HJhbFu+09mrDK5kod9b0bKBI9IA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789012344;
	b=D3MT3DGW0ABr0fZ828PjfLM0jMIyzQJ7iIXgOQDJtG/bD7VvzqNkTZULOHSevj4UJD0XXE
	FgxCMHmsANGpsAJJcbhaVMAfN1f1opaWkki8MtGl9UbGdhCI3fNtsBiooqaQmloeOerX2v
	7DBmyU7SJn0FMPKJkYRdoKRUEFvP0Hw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eB6tfGQK;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789012343; x=1820548343;
  h=date:from:to:cc:subject:message-id;
  bh=AlyXlczZVXfEJTEgbEv/drSMEZaRF5vCLVVb87MgeFs=;
  b=eB6tfGQKdYUWVL1z3kBGXZ6nhvgXc1czKHdtZOOpGhtauYaSRW+kei2V
   yoXmGJOoQwiKzCo5+807aAVUvzIGEulNlY9hQa+mipxApVQfZ/mhIdcpW
   0Zr94KS/SFDluXbNgelUWONBihM8hh031j48C/eZqcDzBgtM4bYdLfl/1
   /K5T31dKkc2+mRjHHsmdlCnvkx8QOZBWSdojs9p2gyVy03VBGxOanSnN8
   23aQE5RluxW+K3r9GVLX0dCczWqUf4XL3ga0idvinVQlUBg29UZv2A+Ty
   KyCtAI/Z5wkTTwjs/TDdMacApJP9BeDlMCdyX5jzRu7X/jnybc7aEreyZ
   g==;
X-CSE-ConnectionGUID: MKBRkjYnTcmxudQStI97Cg==
X-CSE-MsgGUID: rxUkCqQ3QJesSZ5mvBg03w==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="100114807"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="100114807"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:52:22 -0700
X-CSE-ConnectionGUID: C8q7CC3JQd2iqSCefA/pOA==
X-CSE-MsgGUID: 12/fdbYgTd+P1HhUvr1OEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="309763862"
Received: from lkp-server01.sh.intel.com (HELO a3e91e2cf319) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 09 Sep 2026 20:52:20 -0700
Received: from kbuild by a3e91e2cf319 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4Vpi-000000001Li-0ip8;
	Thu, 10 Sep 2026 03:52:18 +0000
Date: Thu, 10 Sep 2026 11:52:12 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH UNVERIFIED WARNING
 c68a982815dcce5464e3bf2a31ac94f5146c04ca
Message-ID: <202609101108.e0boW3mW-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: p7x8furnmaxyremkpj3s5weeoqhyj94c
X-Rspam-User: 
X-Rspamd-Queue-Id: 1674040004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789012342-697833
X-HE-Meta: U2FsdGVkX19FM+N6SLC+apGcE7mgNgfttmw+LatfCejBY7PnEtvJ86BphdZBvkDD+xE9YM7GCC1StD5Oyi6e2kMjhFI/cdbYs1+fIY7wczIJOJAOg4DHuCBRd+PCCbA1zA4BZzlHiwkTXhSjzlE6HPHM6O5020nX5sCrKnGr/KRdtd8qyBWJpTvVk5IktigzL+4eG03MSv0gnxvWm99vNZllVB0dHqgF9mz+ugzBv5vUP6+c9prXrcDaObt6K8n4NtWkwm/UCAYzcCTM+K+YRwPiqGND6LCzi416EHd7uywnMCU7atJ1YcdlIQPuWEkN1XVe7QlS8J3QrEwNAn/DJnMeelqfJCYTKxHnWTXYfBETxsSuOBz0lAnU1nPjAFBs2JAqEmwj6VvgB+o2IqinnsBx/zgNH7z/MLL+GlT7Nv5XiobLN+J8P+79GotvLQxD+8w4xds44UqTaYOrDzMMZcbqS4TwgkMsl4gnhr6N953w2Nbmlp8t3d8e3gCsRJNGLUBQrVuMJq8e70jWYmIOXK9Eb+MwTQC39SG6NK2+UQWhVgodShHdDHZ6jIF/fIc5rwm4+ltyYSTxm6k8BHLnR4akvS08FlsKQ7vxG5P/RJLmo3vpl2rJOgao1ZlxOt+u45U6/MptR0s/59KCyIFGNWRX1uXV9FV/MHyfTc6bKdbMxIJlYcCT1HVhsAtv/l91yYKDTRK93l0IihYTLFZEixjRdFKHxCRHRX89zcn9B8EL3Gt0ApFH6OR9S7zREo4XdJl2NiXYabQAxQgYejwPelaJ3JK1h71PZVpAz+knTaU70w09Ptz5JEEGbP8O7TckeCAxu6ee9XA31UOI4XKxugL0zJkCa84ZU/VreIkGaPmjTQP3lqGwrk6Yt01mKtdCnQQhidZkeV2urG/TFVb1odzvFyfLmQNleyxj1UQG5S2ZRMwHay5tQRtrKzqG4YyY11pn8wra7zlVrDtYKXC
 ehzhbiru
 U7ffMOC7bfmsyL1JuRt1ZT8KhtEnrpsKdx+zi2Ju2q4IzGnR4nZV+f/iO1EFfVEudmMtByE45fJPGQN625POwSHOXfLaocIUtAZDaw74EZVd+HEvRl+ZT1EvVEpmRSc5IutcNjltexT1l0QQaYYXKwrMGVrbwU10OftJobR3VaZlOKGTmiVxiXZMHWSOvMG80bFieZOZ3Ai7YjAjCahAvsBvturjbDB8rM7x5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: c68a982815dcce5464e3bf2a31ac94f5146c04ca  Add linux-next specific files for 20260909

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609100404.snOqfc72-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609100452.olYH79h9-lkp@intel.com

    drivers/gpu/drm/xe/xe_guc_pc.c:1254:9: sparse: sparse: Trying to use reserved word 'return' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1261:9: sparse: sparse: Trying to use reserved word 'return' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1269:9: sparse: sparse: Trying to use reserved word 'void' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1272:9: sparse: sparse: Trying to use reserved word 'if' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1276:9: sparse: sparse: Trying to use reserved word 'void' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1279:9: sparse: sparse: Trying to use reserved word 'if' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1282:9: sparse: sparse: Trying to use reserved word 'do' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1289:9: sparse: sparse: Trying to use reserved word 'do' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1379:15: sparse: sparse: cannot dereference this type
    drivers/gpu/drm/xe/xe_guc_pc.c:1386:15: sparse: sparse: cannot dereference this type
    drivers/gpu/drm/xe/xe_guc_pc.c:1400:17: sparse: sparse: Trying to use reserved word 'const' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1403:9: sparse: sparse: Trying to use reserved word 'case' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1407:17: sparse: sparse: Trying to use reserved word 'const' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1410:9: sparse: sparse: Trying to use reserved word 'case' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1413:9: sparse: sparse: Trying to use reserved word 'default' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1420:9: sparse: sparse: Trying to use reserved word 'default' as identifier
    fs/ntfs/mft.c:1065 mft_bitmap_alloc_free_rec() warn: mask and shift to zero: expr='bit >> 3'

Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-r121-20260910
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-case-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-const-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-default-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-do-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-if-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-return-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-void-as-identifier
|   `-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:cannot-dereference-this-type
|-- csky-randconfig-r122-20260910
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-case-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-const-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-default-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-do-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-if-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-return-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-void-as-identifier
|   `-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:cannot-dereference-this-type
|-- microblaze-randconfig-r132-20260910
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-case-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-const-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-default-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-do-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-if-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-return-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-void-as-identifier
|   `-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:cannot-dereference-this-type
|-- parisc-randconfig-r132-20260910
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-case-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-const-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-default-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-do-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-if-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-return-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-void-as-identifier
|   `-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:cannot-dereference-this-type
|-- s390-randconfig-r131-20260910
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-case-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-const-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-default-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-do-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-if-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-return-as-identifier
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-void-as-identifier
|   `-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:cannot-dereference-this-type
`-- x86_64-randconfig-161-20260909
    `-- fs-ntfs-mft.c-mft_bitmap_alloc_free_rec()-warn:mask-and-shift-to-zero:expr-bit

elapsed time: 781m

configs tested: 70
configs skipped: 0

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386         allmodconfig    gcc-14
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
i386         allyesconfig    gcc-14
loongarch    allmodconfig    clang-19
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    clang-24
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
openrisc     allmodconfig    clang-20
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    clang-24
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc       allyesconfig    clang-17
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh           allyesconfig    clang-17
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa       allyesconfig    clang-20
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

