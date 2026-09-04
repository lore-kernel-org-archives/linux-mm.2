Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E59D3C79F87
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 18:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07EE86B008A; Fri,  4 Sep 2026 14:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F1A6B008C; Fri,  4 Sep 2026 14:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB8D6B0092; Fri,  4 Sep 2026 14:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B09296B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:44:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40D97801AF
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:44:59 +0000 (UTC)
X-FDA: 85176956718.30.5861FAB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id AE12C1A0007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:44:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eJUERQMi;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788547497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=yPiz4etSZ4uVK8SA9ONN2LabHRqQPxuOcoB/UL7+Aus=;
	b=8kRy3L8lKSgCQBGzW9eLHIWKm5S81/mxHzk5GcmM9RMIl9QJoe85ym0e97Qwm1Pf2FXBD/
	AKBV4A/lCxFIYTH7Fb1wlz+t1Fj84JDSC4kgMuHdz+EbVv/CEorzmR1D7FRO8x5cU5JaVQ
	6Z/i5N+wbA6e6wK87DFjlKa/hV1UqmY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788547497;
	b=pRml2aoWpLpfDy18+JyZWGhEH8rBOGhS1NsI97afF8Y9JFm7jENjCUgu4V7zCvAkC14sQK
	ZdWXcWNM0z7dpXon0db5NH/cJ5KwEixPXf3dIOapOgy58zwUhlVW1mFSxJTITZcMvwnUq1
	/H8FRIPraiTBa1nEjJwUvHltqT9r6Wo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eJUERQMi;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788547497; x=1820083497;
  h=date:from:to:cc:subject:message-id;
  bh=GATMvEBnUp24vVj527m0h2TPJ+ux9jeOddghKhOK4is=;
  b=eJUERQMiKfweDRDCwaaGAP7ExM+yZ8N3A6ksbg/AEc6uApk5dYj0Tap9
   BUJ2ThPI7b4GdgI7YFRqK8eJPuEiOVAudIXRThg+t8wwXCGmAPuQLK5He
   Rp9PayqZSmH1fHZ/CApC7G1L1MuKq02VYhSBTWFGr3i93k60aRdMlNQtc
   SnefbELo7iPR63X5XuunIBb4/P4ZsJNXqsV0DcOYJaefJ1dGm5C3Bibxc
   UfppZlyMo1AjZPK34JkktvrSTwgIKlZTUriIQ21YWcrYyKHVKHwms2mye
   ZIAHc8d65zSs19SljpH3wvYPKGQojmh/ixl9lG37TXPIz1U/teQjDSvBK
   A==;
X-CSE-ConnectionGUID: 0++qh/HRS+mJDilKwZhDeA==
X-CSE-MsgGUID: 8oEZGthYT5uon4k5Vz1y3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11896"; a="76614098"
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="76614098"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 11:44:55 -0700
X-CSE-ConnectionGUID: sqT61xydRJC762fPROe0mA==
X-CSE-MsgGUID: 5+5rc9f1TEmBsIOjUIHwpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="299987173"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 04 Sep 2026 11:44:53 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2YuB-00000000A5y-1U4S;
	Fri, 04 Sep 2026 18:44:51 +0000
Date: Sat, 05 Sep 2026 02:44:49 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 9d80aa4617b32f5054c5aa471d06b66704854935
Message-ID: <202609050245.M50lqUNI-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: ct93sybmqzujgzpm5w4nqu9zb361ri6e
X-Rspamd-Queue-Id: AE12C1A0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788547496-943730
X-HE-Meta: U2FsdGVkX1/ehIAPhvCMR7kmxDFbD/0VOLCJbqc7d2Et7BEYItGQwWGKhw6ccCGs5SfTq+rxa+ksglGshw5mS4e/4a8RbugpcXhYnBb3qUa/vOl94vVaLpGDLlxgzg0hfbZfp0TkgwNC4A40qLAVykA21GAwIDR2KBwGdqbUjRtCD5mrqkna0FtHWSp6QVazkCl8KLOenyZmxFvgMDgE4+THZgF6UglobNRKfN/hQ83StlZmjEMdsR/RG+g2JUVh6OVGv8RzM/UgZD5Y7QS7ZmQjSEkmE9X1gd+Z/lvgqkyL9UTZAYEKzLUzNt6u2pmjFgcgRsJ/t6nvhjm7+8laHXXs6a2Sb06N6WF7pPCRI0CDiaN77OWHYOsugo9QGXMWm94ARQAYC814EjZRqD0wvzWfI/BPBtmdyTr4Oxs1LvdaQ0PQ1ldwfXWIs6ruhdukABsEz6WBb5DkAK3oR0SBA2zTA5dIT18ih8KTai4qHJIKRNb2IRul1hA82OH5muDHWaZaVAh1J/ZnG3KPFgOLfst+M0UneIH+SaNe+OCbAZ2ZKzBzrHQp3zR8oPIFhNJTPVPyF//AoB3N86hv7p3TeZYcWxGIndHEUVJ5zA4Bk/TcIzLCIe0rcWIAygX4//asDQcyBrdmqBw6tSm5nV5r7s/CJjk9Q+gAipR8/SNZyPhsJ1qMTig+kuHNwOT+3wic3aCLephJ0tUXbZa5bhaPTZgKFSMaZi3/QmW7Ujnr/qlM2xcVH8AKpR0VFVEAGNY7wb8H6/aJYjliv6BtUhDJf92oTHVUjS15PB1mtTUQMzTPwq30hJf0wKRHJg9TKLXb7+Grzp/ajbckFBbkR5eJX/s3j0kR6WCh7hCuAi5MW5MwJn0Y0FVKRWPiT5XtCPBu2N2B/eXqb/jaCuMkHReI0ly0zIqqdYpfkX4dS3fTgaCer3P8atnahGdSKAq7buzMgKss3lfCAOTC6HwIczP
 4tPns5Af
 fYxr5T3gUofoLT2y83IOBctmxOWe5Hz9N29bisQTm/kY/ve46b5nF1YjumVcGT1SKH6F3Yh7tcG+vUOhwnVWqwbEVhPDeCwFpnAPKxk8mAUg7cycwCLvGhUOrPXA087UNd8HVRQTmadtqFjr+7yNCsuRZeRTFgyJnb3ZTDu92HyZ9dwLenAKhNPE+jVf8jMr6yq8rXGpPWB2leZpd4XlF+FXo/MSrpP8G7AM6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9d80aa4617b32f5054c5aa471d06b66704854935  Add linux-next specific files for 20260903

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609042120.6bgj0pUa-lkp@intel.com

    mm/memcontrol.c:2859:41: error: implicit declaration of function 'irq_work_queue'; did you mean 'drain_workqueue'? [-Werror=implicit-function-declaration]
    mm/memcontrol.c:4234:9: error: implicit declaration of function 'init_irq_work'; did you mean 'init_irq_proc'? [-Werror=implicit-function-declaration]
    mm/memcontrol.c:4443:9: error: implicit declaration of function 'irq_work_sync' [-Werror=implicit-function-declaration]

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/scsi/ipr.c:2935:1: internal compiler error: in final_scan_insn_1, at final.cc:2823

Error/Warning ids grouped by kconfigs:

recent_errors
|-- csky-allmodconfig
|   `-- drivers-scsi-ipr.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
`-- sparc-randconfig-r061-20260904
    |-- mm-memcontrol.c:error:implicit-declaration-of-function-init_irq_work
    |-- mm-memcontrol.c:error:implicit-declaration-of-function-irq_work_queue
    `-- mm-memcontrol.c:error:implicit-declaration-of-function-irq_work_sync

elapsed time: 1536m

configs tested: 46
configs skipped: 2

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
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
nios2         allnoconfig    gcc-11.5.0
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    gcc-16.1.0
um            allnoconfig    clang-17
um           allyesconfig    gcc-14
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

