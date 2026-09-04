Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C21C61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 06:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679566B0088; Fri,  4 Sep 2026 02:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629CF6B008A; Fri,  4 Sep 2026 02:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519406B008C; Fri,  4 Sep 2026 02:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36BD86B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:20:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4D9C12071C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:20:11 +0000 (UTC)
X-FDA: 85175079822.11.C13A258
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id DAED21C0005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:20:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hgJrdBa5;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788502809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=L4QZYxym8tqD4tNNeiGC4V1lbfWQDeWXiNUEbycu76A=;
	b=3spKNc2btNdmWssaS85nK35nQSk0b/N2B7XnevPjDH/X8KdxGJ9EtohHu3nBavINu3gPju
	aNsyk0Jklj9hZlben2OeJt8qC7AX95P14b6s4T6ZA6sHilElmSKwYPhBGD5ec+qFyV35dB
	mjKwpH5n8jgMFhluKH4dqzVoBLuDZvc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788502809;
	b=rl/7NVNI4AneU4KzZwAYxa6hXXet0JbGWchnEIn22K3RTS07a0EDusu8MD01nNysj6ifXe
	Rt7u0sHdTuh6OR7xzmaSmkcICuGFuN1L2Hs/2Pm7wXSdcmw3DicFCDhKDCW/MvzMiRFGgB
	fdey9AJh9bAsYcq8dp0AlRAQXxOl8Ds=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hgJrdBa5;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788502809; x=1820038809;
  h=date:from:to:cc:subject:message-id;
  bh=9cbImcupship+485zNokOvzLoVRZpy8r9KRhkrz6eMw=;
  b=hgJrdBa5VND5hvgPBiuHDyX4ExIWoO7k4o8f7o0oV9coCXCxa404MAB4
   NCWarurWpObHawAp8mMhKHWS8lwp1oLW3ACmqSQf2ZR8ChloYvrB+VvwJ
   C3UrcLueWIN1J5yy6YY+40DaCgvNrV/5P0rxKbkyHnMsGAUCvoPlIiRwr
   Fudxk2s7v9cD3gZdK25zHlmG7ZfnXL6GNaW5sCMOoIQm9Q1YYtrZ2B7EY
   pQ/+/uO0Lhy86xEun9oYW7odXP+ExpWCpe2C1juV1QGYk2+/N7qSHNHHi
   DNOvhMY70niHvN6v1v1UVneN71Uqf1KOwwRdKNhR+oatP/tci8r7kxDpP
   A==;
X-CSE-ConnectionGUID: scmsAVEISvqBlSmLhlsK4g==
X-CSE-MsgGUID: LZPkPAE5Rtitjj+sIb6YLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88141463"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88141463"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 23:20:07 -0700
X-CSE-ConnectionGUID: VqXhzGlXTk2my69ZHy2wSg==
X-CSE-MsgGUID: UkzzmJfZSxu1b1FgoQHqaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="293466969"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 03 Sep 2026 23:20:06 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2NHP-000000005x2-15W4;
	Fri, 04 Sep 2026 06:20:03 +0000
Date: Fri, 04 Sep 2026 14:19:58 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 dbffc67777cd752ef3f77818109e1d2ef13e2949
Message-ID: <202609041455.Dj5aQuUj-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DAED21C0005
X-Stat-Signature: 3hym4yw8kngp4os9d7uxjt9fymgeuicb
X-HE-Tag: 1788502808-644495
X-HE-Meta: U2FsdGVkX1977n7m34RCzB+B0bepdEL82LF/ZrRJXISgNG22elVMGBbN83rlmyopiIf7Rueb6NPwtbBKCo3+CbVVBjtLPYqYoySEwZOG4nbe7f4o9jfn7tdemePxtNRt2pLxPKasBRJ4jdaAyG/sRBzLfm0UXap2VCMzpW23bNmn1lIblRPdd7Kuk1ybFEcioYYWry8RyJ74/jcefAOVdIW6qQJQo+V6VXQS+tSVA93GwB7kg0R80z0XR+13V62kIqJsCZj6LDJPeFwQUpYx7SvH06dS9B4hTdIjU+CtmvYf/QHw+vHKflNXjxki82HY/dpHKOTjuh2K2gRi8Vg8pUUMifZwPtZrPAtShblWzAyTkIBK+KPVfusCzZzCD/Iv82b33QwlUAvKQDtILejeXQYk3QtrMjauZlvcUJqis3t0gWSNDIkoKGAlVB5qEoMjX+MqgJi97DGgK985EquSIt4SBrx+uH7FS20q5K2j0HN/fn5MnaRdYHcwkLhRZzdxmDrg5QJGP/MwB7c3LFS6Dj8vWOebCLeKoZSsEpUQTr/XiPsZnH9ax8FVNXSaAIBC/99o8VAy3dP5aD+NqJHdCvkA9BAAPHmgHkfYVW7GdEyDCXC/ZTVwsyJQPCsGKHR/lgUJxpcNRWk5WENg3T/fwoxmzOWQoBBQWavdJbvpOLKBD2WcksOdnRsHfoLrYhXOYasOmOQTR+U+TKJWE+BKcYcoFrShjpoGaox7I6vo6Fkf0IDCp5cSBB3EC1l3xyJupKSBphfqimxW4oXcPZco+W009u8G1JGRM1sAszx53sY+fyCjXaeEb9ifQsZ7d/Zy9d99dSNaqPeVdaT1gDxkAkQSa7QXd8MnULjhkO8J6JwtLbszS0JWIsENWBCY2uhFNXbL1o8KngWdtdXWk3MdrCCqguGGtFmzciTBmC4i9jptLcNCOQTI2z+PN5mEf+poTgLyghQjhFlipqMX9Yx
 KIqqqSD4
 9FSQY35Xzkb6bYCgTC5Odcoyd2FgfAd85t5bvJDgWv92Q0Oh6Jetq5FwcU50pztNlNxAjNf9AvoeaVMqYsYdqguN8vhb1eSyM8aSe/0Qcr0WzjxXc/ZpnJLMcqP4oMoGK25KQOB1iWETbfVt5VYB22X3OhOZqOaK1oN/cUqFiiXVjWNH0HtM5Fim8g7jCAXN7yNzG8BYbPdjmtwE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: dbffc67777cd752ef3f77818109e1d2ef13e2949  mm/mm_init: remove zone_absent_pages_in_node()

elapsed time: 2964m

configs tested: 73
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-19
loongarch    allmodconfig    clang-24
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
um           allyesconfig    gcc-16.1.0
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

