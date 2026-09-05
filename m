Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D42EC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 20:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A2D6B00A2; Sat,  5 Sep 2026 16:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B126B00AB; Sat,  5 Sep 2026 16:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520906B00AC; Sat,  5 Sep 2026 16:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 283BD6B00A2
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:54:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC3DE1403A4
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:54:09 +0000 (UTC)
X-FDA: 85180911018.05.6A9E23B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0F24A1C0002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:54:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ol6UGf8g;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788641646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=sv1oRcxOT7++b+/xJD6V8Wb5MULjcWynjhU6lh++JJE=;
	b=OawioO37GRADF/QZ3esFvlleyONn6A9HyA/K+Sr1AGxM1hJI8p4va55oE8aHENnXLWiDMD
	8HxTsteN5EgAkD4xkLvZnXEVNeEmRrfL5/dm/9fELgUKAsfKauFGXFEzXwkX5uRQStqNsG
	AKrNX8n/hdXxYzK2OiGyB/DXktChn7I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788641646;
	b=Tn+LU2EZshz9ma/KUtDJmbyerPfqg5bCw4kYr55OOlMyDA4YMyICE9th3z+kSZmgfDDQAL
	rRPvYW/GYErK06dREslxfVWtwSGeUAXLfRtuoRCe8SjGq3xKev0aHHbgEYvkJbzLLBxD5l
	P6ffASlrwL/qphR2XeuHasik4/qtc70=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ol6UGf8g;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788641646; x=1820177646;
  h=date:from:to:cc:subject:message-id;
  bh=IrtqqQ/IRt/sP+nXr2PYvYeteNiOTLLsyZ2C+V7F5dk=;
  b=Ol6UGf8gGZ8zOb1kkr4/8a5IChtGEhbgECTKbXFFk6zFrICTYCccKkbW
   0+jCwQ/lYmVLBdl5za4h/gKQ8b+brC2fGS5UNhr+BQ7sh/qp5MCdbX5UP
   BKXBlWZdlmjC6Ch0KieNIMGohgUGTh8ep3VOAcpL/DuU3f48TpeKsFVpx
   a78PbumvDYOBt+yRUPyDh1CqDiGeQMxb2Qk6suo3Rfz5H75CtEjjfowKW
   oRmHoOxXbiDPJBKPf6DqmHswCQjJPMgqmzLnz7Fcv5KfvcdrG1nloJBZZ
   q18sUgW8UCAo7qFkk0Faf6zknMfIeN8wX3ZOVjWnlz2/DjCRCiG88REu8
   A==;
X-CSE-ConnectionGUID: mSnoiRS3TCS4HVRPhdjYPw==
X-CSE-MsgGUID: y+EcuD4HSxeBlAhXG0z8LQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11897"; a="89159094"
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="89159094"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2026 13:54:05 -0700
X-CSE-ConnectionGUID: sUnaDvUZRRGlLqlSvNb0ag==
X-CSE-MsgGUID: MwjMf4TER+C6/EH3D7r10g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="269833792"
Received: from lkp-server01.sh.intel.com (HELO 73f3364bc37e) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 05 Sep 2026 13:54:03 -0700
Received: from kbuild by 73f3364bc37e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2xOj-00000000167-0zn6;
	Sat, 05 Sep 2026 20:54:01 +0000
Date: Sun, 06 Sep 2026 04:53:24 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 af5f12805e5cefa4fe68d6127c7e1fb78cd5535c
Message-ID: <202609060421.HKcEdqE8-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 5h9a9xxbeni3fbnxpzggyzzw3m5wwe85
X-Rspamd-Queue-Id: 0F24A1C0002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788641645-483125
X-HE-Meta: U2FsdGVkX1+YBncZcIpiiS8EQzUvX3VNMikjp5io2+oQWPDFs1O+CsFb3fnEoFcUqAUx3NuCCkv4P2HAoWzdANfWJqjbTwGiqn/wueKI3kxkoSbnUPluS61CpNgs5t8GsEICebzassx7MshJV5se1cGffLlRPf16yVtkncIniay4j7jXUeEV2bkRYpb+eO8/eT0gM7M18AKG0LStQ471vCtOjSOO4NU4Gv46fENOqcn2u7TeNdqSE6MQD9jfxyZmXtRcqbbSWiNLguBDWxAQjm2wJfXPxoVlqIdUD5DGjOJWp7c6SzgWVzq/zTd4QfV1XavJ8YzABtZlUNJHnPL57ipP49l8KEPW+IqSiWqyYR2mKEsjNIkpOUbB/lbHO+Fw57w1b9oAIqbtuYrvRDNEG0d9xCO9aJF/+cN8nHEhsuMHA6nDM0DbXqeDxH7tYfXqn2xNeLaEzZsaNFJgWt5BWkH05W58v7akKk7fWmFbsblxooSDnoRWAzlsIDMHrOVTsH8JKmWdn+GOLU/gf3OR2usEgbYxIXww9ROzHFrRFhy0pDZW7y+hzs9EqWmnR8TV/QFMi7WG7u5LCNxPOP4RwLXpZmChPM1tRRrZBkM+4UJ8E33OyxmyjkCxlA2QUv1q8VB32VMEwxTGyCQ3OovBngtnCXFI0ZcHZwmNawT7ffpagi5iJGdMiYo1XqG5g/+xNWT5I/0dk97sDHvn6dkwcUEoxfHtATIEzb8vQGY9lW5e08ElyyBsrNCGbjGKQNV7hSBJDq1DofQPU+I5edYmy8Sc0sSJ0rAbLYxgNlKY5PSOgxqw63pNAMNWN5mzrBkAiRZZhVTxpW6rIFq4AsqHrJtMCAnuGD561FykcR+kLp1AGNxoiQCiC95MPvtgVNcCHxMyDi+r3VpvDddQFkfa9EQBk7j5rPSwnWQm9IeoPdO+3WCEnXN+QESCvSyzOI+7yXL7C6kcaVy3O5um7kQ
 uGaSt5TY
 c/tG7r6VpaqmcDpHApgkmzS+U9zPi5yDx/j+AeBjCowkFQ6TjxudZv2nsaZe/CTpfwD9nDcD2sWQPe/FmBSuBAaJjQOvc80gaQQNHkkZF3M66Kq3vYK/AkkbzDIckSiLhYvZf0Z12Ip2sAqf2Tbnc/7sdGiNPjI9qK+E6w0W32d6AnZlkgdqf7I3X1abz006BnjchDMdm8Sv4KXY4kjJMBKBFsM8E0SKcHVMB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: af5f12805e5cefa4fe68d6127c7e1fb78cd5535c  Add linux-next specific files for 20260904

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609051257.z3X2SpAD-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609051727.O4ApRZZK-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609051831.TerdjESg-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609052317.DYE687Ur-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609060257.8wQo9w9N-lkp@intel.com

    drivers/net/dsa/motorcomm/chip.c:4229:22: warning: unused variable 'priv' [-Wunused-variable]
    fs/exfat/super.c:78:(.text+0x6eb): undefined reference to `__udivdi3'
    super.c:(.text+0x1fe4): undefined reference to `__udivdi3'

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609051647.SMk0YLBD-lkp@intel.com

    drivers/infiniband/ulp/iser/iser_initiator.c:614 iser_check_remote_inv() warn: missing unwind goto?

Error/Warning ids grouped by kconfigs:

recent_errors
|-- csky-randconfig-r113-20260905
|   `-- drivers-firewire-config-rom-parser-test.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-int-usertype-got-restricted-__be32-usertype
|-- i386-randconfig-052-20250512
|   `-- fs-exfat-super.c:(.text):undefined-reference-to-__udivdi3
|-- i386-randconfig-063-20260904
|   `-- drivers-gpu-drm-xe-xe_debugfs.c:sparse:sparse:symbol-inject_mempage_offline-was-not-declared.-Should-it-be-static
|-- mips-randconfig-r061-20260905
|   `-- drivers-net-dsa-motorcomm-chip.c:warning:unused-variable-priv
|-- powerpc-randconfig-r052-20260905
|   `-- super.c:(.text):undefined-reference-to-__udivdi3
`-- x86_64-randconfig-161-20260904
    `-- drivers-infiniband-ulp-iser-iser_initiator.c-iser_check_remote_inv()-warn:missing-unwind-goto

elapsed time: 1319m

configs tested: 55
configs skipped: 0

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
i386         allyesconfig    gcc-14
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
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

