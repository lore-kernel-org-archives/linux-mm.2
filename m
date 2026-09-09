Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57F6DC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 21:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704156B008A; Wed,  9 Sep 2026 17:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5186B00A0; Wed,  9 Sep 2026 17:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1EB6B00A1; Wed,  9 Sep 2026 17:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41F276B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:56:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAA661601F3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:56:38 +0000 (UTC)
X-FDA: 85195583676.22.8644BE2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf07.hostedemail.com (Postfix) with ESMTP id DF59140003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:56:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RaoWBPZU;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788990996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9c2KME4UizAQchKXSOTOeJLr1Iyu5g05ePM082XYKVA=;
	b=BIRi4mD0sky4xuzEslXd5Hx0/dVXRnuGI0tvpQpVOD5rIEH5wZFRZPMZ4YWPZ3NKN/dqkf
	F/1AAex8UBFdAq8XRMb3NE3xbDGwttGLbNhf4mEXm6Z6Tr/oYcJHCDRVOoffVd9QifP/Gy
	TD/TNjCIwRBv3JY/4RVsBINvkrB1Kis=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RaoWBPZU;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788990996;
	b=3FdkuxKz7xB/PuwowgNc6m0XHbJCa0en7SN0qoZEgb3yazkPaG03nk+x+dAxnRGjCWzRlC
	3bvle2nL3JMRAlRX8XpTf7pRdxhkD+tkBfmWhKkGweGgMu49OvFPKhrE/0Q3fFB6ZGdd8p
	2hSheByxcHA5e+IYrEpdVlvMLZjIaZs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788990996; x=1820526996;
  h=date:from:to:cc:subject:message-id;
  bh=FfcwknCvOB14lwM6tB+YRx4KGEn8x/b3vHavrs0EThc=;
  b=RaoWBPZUPew33dp0LH5xzqT2aApD69LAbKavrCkaOXkpAzLpgRnRa1AN
   KV0l58+/o8q2X2bd6HIDM6Yjn9TicwND57SBNNAqzdYDsi5zyFbuTdw9N
   Dma0stCEQQn5GJ+amUTheTdKnll7zg69BK5EPWyedDOz77MeYIfssP3il
   PM46IcZHIPQ5EvpGJdPyrveeDJcfdg9ZJUa03rNxrVKO1PhLGl+Q50oyR
   fKs8Ve2XNUs+7W6qY9SeZXfCoZfNqf0Abca3TgrzgZZ2Y/+1qAKHuPAtI
   nnXYeBcdhYX62/+EfDnGmUFIz3qo09M1kkcKwBxKmZQY0Mh4A7P7ejfJN
   w==;
X-CSE-ConnectionGUID: 3Z4vNB6MRD2hkDpP+Q4C8A==
X-CSE-MsgGUID: oA+X5435QP+Um7jSgH31Rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89449337"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="89449337"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 14:56:35 -0700
X-CSE-ConnectionGUID: Snj2jEi4QeuWOhXtZogyJw==
X-CSE-MsgGUID: pp+WCcJYSwCjka1r3bQ+7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="275583826"
Received: from lkp-server01.sh.intel.com (HELO a3e91e2cf319) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 09 Sep 2026 14:56:34 -0700
Received: from kbuild by a3e91e2cf319 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4QHO-000000000z2-2sFx;
	Wed, 09 Sep 2026 21:56:30 +0000
Date: Thu, 10 Sep 2026 05:56:22 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 0bffe67ab8a72b3725cc31c4b525709bd3a3e223
Message-ID: <202609100517.0DrzxrW4-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF59140003
X-Stat-Signature: n9ziknrdojhwfmefzqupgukwq7pkoaz6
X-Rspam-User: 
X-HE-Tag: 1788990995-977014
X-HE-Meta: U2FsdGVkX18lDDakbp2vi1PrwN3HoWLnEENmzbs1m0GsWDmobp28yHWpzzFKwOgh9uZC/qR0bwRXOe65/EOoogmA2YZ4p6jlW9bZynlB4yC7lWacS4og1zk2rNGcXrifmZiJyDD5sSmBsN13XxninBglfNLDqTsc1MmqD0lnqz1cXA/NMQmIJAqk0PeQ1oh1HHXpIOqlI7jT7/bGA9bKxJu1gl3j2I2V0RHLIbJpnas60zafX8o+NPZP+ub9pP6ZaGECYFSDa+BGpZWGTFDXAsi2DgNTSvmqDCBdn9JiJRgOw9WNE2/MGYcTGtxhmivrbfUEDz+iINi6kcJtvJkcF8vFxyWBW9SNWq+x9UPHrX2cNX3FnZ5B9LGkpVgRAVT8Ud06EO0wVM7Fr+nT47vi8w56W2wgxtaNvHUXL2R4jDYvHMA7RZrOhm15lUBNmVj1stx/ghSwRUiPMhDL6KFqJv//4xqOR6D8XcoTyEYlqSrh/JYfcGJn3k9/SKZZEKVuA4C4sfacIVuxelVyhpRoxr2bwdsMCnGCUwv3jPFrz4I3NFT09O6zdVUuKPLO6Kbtp2iPctckiChqWN0fOzHIODis7AEw60GxFPA3LKQDA16G0OAmx6uCxCPhQMhNEHNGGEK7K/VVl0jJbCk4fny2gNuNkScH++BbzA4jy+2LgfKCIBB+HJgiZT0AFLDa0AVCpWVUUUdMRGOSSTZfMOC+pJEnuzFG6Dm35SVI/9MamE3m5myxiw9C9O8qoqdQGLgTHXPkbEqkEqz52sSQTkoRrbUFjxKxXFh8PDzTVxfjeXA1mKZ0WDSOaQwUILhc51PybjVRDaYN1PRXra9hKOZN7pIxKXaA1o2vlX5cOIyXOUMCqwc0+7Dc+3PRTfw//yhlSCukGeScHS/XKx/HZJzfEWsyBUY+vbIVM/J29vcp4UVud5X+5Z++WVjMPn+tDDTJIdJBeX4NWY8fUGyJfms
 2VreZCPf
 2fQJ04TcHoFMgJRpAzIidAyTWGs7HsjySW8QfDVLNZj4tLZdERFmBND45nfRztEllBgf9+7q8svsUH6FaAdWkVnTvhi5MjfI7vSGL9Kz99Lm5pMKqaQv8tCr9FkIneOY+hPR2TGpWcBRJ8Xn+NbwULc6Ohks4dUlaZlM+6678eco5aWapRv6aWgvIGC6XoWcL7/h5b7+GfNb8e6csBC/hlHuEdx8RG2X49ZBt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 0bffe67ab8a72b3725cc31c4b525709bd3a3e223  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609100351.ALNh2KwC-lkp@intel.com

    include/linux/mmzone.h:1692:10: error: call to undeclared function 'NODE_DATA'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    include/linux/mmzone.h:1692:26: error: member reference type 'int' is not a pointer
    include/linux/mmzone.h:1780:35: error: conflicting types for 'NODE_DATA'

Error/Warning ids grouped by kconfigs:

recent_errors
`-- x86_64-randconfig-123-20260910
    |-- include-linux-mmzone.h:error:call-to-undeclared-function-NODE_DATA-ISO-C99-and-later-do-not-support-implicit-function-declarations
    |-- include-linux-mmzone.h:error:conflicting-types-for-NODE_DATA
    `-- include-linux-mmzone.h:error:member-reference-type-int-is-not-a-pointer

elapsed time: 730m

configs tested: 69
configs skipped: 0

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    gcc-14
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    gcc-14
loongarch    allmodconfig    clang-19
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-14
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

