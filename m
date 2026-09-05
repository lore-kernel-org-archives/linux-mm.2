Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE81C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 06:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30516B0088; Sat,  5 Sep 2026 02:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E10B6B008A; Sat,  5 Sep 2026 02:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0086B008C; Sat,  5 Sep 2026 02:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 628666B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 02:01:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 569AB1602C5
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 06:01:15 +0000 (UTC)
X-FDA: 85178660910.10.8D90ABD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0C1EB1C0007
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 06:01:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bjijJwGD;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788588073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=T/9lO1xiPzGoqYbSWp5CmF5EjP3hvv7jsmRPdz65z8w=;
	b=dAvwnifs46DrZR5hs5qo2+/TiuA79NDy6e5QSbxYsc9ZXJatcG/WFs4a0Smbu4NPVMrf6S
	wNpmiOaGi4M0BfxRlhXR0wgVxFMG+UUJ/fGYYOck/uN48aqUHJE3aVY1+KejGi4O7+8Pyh
	21gizrP2xwDwnyaRAUrKI6aQrJtz6KU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788588073;
	b=hSJOBXbNU5Lq2ZQlAya0fZ+lidCcRh6qIFw7lNn45tA7514+5rcBPl4dZTi6bVRzVlW5Cm
	dP6JdHrPcC4HY3bYn7R70PsD0T+E8x8o2p3VlIunOeBeX48TErDl9ihVCixPMi2E7gKTix
	XSk/Ek4XFwXdvs4S7BFVDldK+GBbKL8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bjijJwGD;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788588072; x=1820124072;
  h=date:from:to:cc:subject:message-id;
  bh=lM22okNgFz1OuO8OLS+hbAQLYLsF6ANgD6I/iw0cgQU=;
  b=bjijJwGDJEj4ooE8Evo7NiOrbHE2p1fCO+oQs1hk3ANwTPsoAqoBNYgo
   gGBlvB9C/9rQGY7CQbjrpDy1iTNF/KjG3pM7P4uEtPGpnjlz6nPCAXSit
   5FO/YZYoI2nBDVGKAhWlri2rRwEm1ZZ7Ug9XGmbGIZ8pQrIq48pP3oBuC
   5BmRD+eboVPFJNyN7SP+2dhxN0T+Nisw75u0TV+LpkILQfmLvaS4Rqp9v
   cb/vy4fDToAHz0hfV4YTG1xz35UaVLBGbDmhlk7Rh/o8Hxgu0tZmcTI2l
   sBjW8p8YZg2zb0YwZMdAnsZaUVvBq8DxuaPnTnc6NS84d4AbnsEs+Pzw3
   g==;
X-CSE-ConnectionGUID: w5A9wWAuRSqrYpLydSpN4A==
X-CSE-MsgGUID: ETwQIVySRWeQlbmSxyK/bQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11896"; a="106601157"
X-IronPort-AV: E=Sophos;i="6.25,263,1779174000"; 
   d="scan'208";a="106601157"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 23:01:10 -0700
X-CSE-ConnectionGUID: jHx/Xdi8Qc+O/62lcj6/xA==
X-CSE-MsgGUID: Up5SPOhLSqCiO1GgvNOexw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,263,1779174000"; 
   d="scan'208";a="267655865"
Received: from lkp-server01.sh.intel.com (HELO 73f3364bc37e) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 04 Sep 2026 23:01:09 -0700
Received: from kbuild by 73f3364bc37e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2jSc-0000000009j-28qD;
	Sat, 05 Sep 2026 06:01:06 +0000
Date: Sat, 05 Sep 2026 14:01:06 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
Message-ID: <202609051403.2OSmiAZR-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: dbr3mtrczya1czqxf1jummqwezcdxnyi
X-Rspamd-Queue-Id: 0C1EB1C0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788588071-867647
X-HE-Meta: U2FsdGVkX19nModAplzNMunEsGGYEo3ojsjvoM9qoRoVONTZ87+Fy6PH4SG5oC0Fa5wvenrhevA0MffYZtsJFO5hbj28lZnS3EtDXOt8B5sudVQrFdkneqGTPiUsgyJH0bmSDiwpZIBBbQ6tVDohJAL1dM0nZcp9S7Ul0UuVswfkBcVkoa1XO87yWCRy3t/LGeoofaRyn1n1AGkMiU0IGfrh3R2zrT2D+m0xlaE2tqTHr+MXoXYxmlMrL5wzsMejzkjT0wXBUmT+wbTWVe+Xv4ZsV+xq9lFKvCkLDQJ/weHfcRYFD+M0D4wUeLcPAE0U1pV0985zjoLkLlU0mamjyUcQCQZbmOUe/EVSs2j+btmntlyzxC6LpOPxxDGYwKPGPQ6yS33XLONIeSUqZBGRKdIdD5vnkYs0QOXX0uW9SAWRlBBq7y6DMehnEY2cZHfIbXYcNI1p6WyHEmsscWIzB5aZFZu7dTkj4AuLqPtQqQz9LYP826iKT+yYGP2tmbVdCmkmY7d/8zZi2/9zeA1r11hSP4JqruECb6O6FP0/UKGjLMXU4+Ca0hwcFmthxd883RUAPctAxhRMXGBMJI3DidkfSeGvXge6IzBMEflk/XVYtzRslq3DDO63xzaCbRBpqc85NWM8TIeVB3Je6VzKKSh1bJapLxuAHUCBOc4yIOapAO2GgmQwlGYJvcWkvQioUZHoXo0NQqYZ1U3Dpif+gMD5gz5bYSoSmL8Rnthd5wPHPe23btOE1b51P+beL16ZJFU643G3sCfliZRsA2xKFtvImft/nyPvCgITumqx7UxjOnYyX6XPIFQbtk6whBfq/ImZ37SiZsw8DSmhHSKKd/KcwXB0fsut5uG709l5RmvllLFb7NMc/h9OKLBw9T8aiXQdsaRYi8fZ4IDeJIf5+BNklSsXW+u6L+Akpp9kOvTpdGLAhTMcCIWg9E8g4ygtkGiiZVJdMN1MYyOjujS
 Y7/tcm7W
 SgGw968YryK3QFPSZTua4LnovCLcBvAwOZK44h+wl30x9/fMgbFZgJ3LQW2xxh/oKudeTGTLErIOoD43JRahWk7PVXo1qZTioUlFxuucf9mXJKwzfALygs7lEMIUZeDvUZqEAikPMgF1rDM7p8D+Bhr/qGQhbE82pjjGkfu8rgJOxm2FbFva0kozj8srdwhxnLbDJPYY80KW+jGoc1Il2d/xFoWHghXEiPE2C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4  mm/swap, PM: hibernate: atomically replace hibernation pin

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609050628.ywCLhOj5-lkp@intel.com

    mm/memory_hotplug.c:1507:13: warning: 'node_is_memoryless' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
`-- x86_64-randconfig-161-20260904
    `-- mm-memory_hotplug.c:warning:node_is_memoryless-defined-but-not-used

elapsed time: 1477m

configs tested: 52
configs skipped: 3

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon       allnoconfig    clang-24
i386         allmodconfig    gcc-14
i386          allnoconfig    gcc-14
loongarch    allmodconfig    clang-19
loongarch     allnoconfig    clang-20
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um           allyesconfig    gcc-14
x86_64        allnoconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

