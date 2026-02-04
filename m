Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2654FE83EED
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 08:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4496B008A; Wed,  4 Feb 2026 03:18:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031646B0092; Wed,  4 Feb 2026 03:18:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C3C6B0093; Wed,  4 Feb 2026 03:18:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D4C846B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:18:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFE4C1A072A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:18:17 +0000 (UTC)
X-FDA: 84406071834.16.71970E4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6CB0380006
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:18:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NSOTUhhj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770193096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=R1MufWmj4/wNCFyFYPHYp2R2L+WS/3QYjGJisYEaTxQ=;
	b=6NLrLgxxkSOyv9H6rMhrzuFCpkGIU1PnIacD4SNvupMJ9UJ2EvzmUjBiV7wAVKMvdNsv3G
	uvtY4yuQlv9x1gSyi8IVtr3NWyQbKkXZInGqOp9VMarAZIdOAoWKk+x8FmuKuGNvf0VRFX
	1ni0BUoq8sCgKU4KqWoRhfJa9oP20MQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770193096; a=rsa-sha256;
	cv=none;
	b=KPJci5v5IYS62nmqT9bXBtkJGJBkXw5arW+rWsvEAgRiYdLixpcrhJ2Yq2/YVS57b/pjxL
	y+iDA/E0HFg+dPQcFCeBYmsJi1MZMWUOEPbRyxQ5BwxM7tRZbTobP7rdX4p0VnRZaGlagW
	Kg8rJTZLBEWXClAa6bt0k2qNYYdDFks=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NSOTUhhj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770193096; x=1801729096;
  h=date:from:to:cc:subject:message-id;
  bh=bEh9sNJVxGOj11R9+Pt5+CbrLPxPY5Ft8QFs4+Gs950=;
  b=NSOTUhhjpFyTXer42SKAu3jyTnguhZukmPErSX2Mtz9NUcSylsqyqjBr
   2/JBYicRePOuYV3x21L6El1pSapfK+JNOBXC1Eu6kWfN3DNXm+Fy5NUft
   efsHtNd6fCKN7zOLpadnhp+I40klY1SIyLdTdJ5IaK6GA9W3iyWyPl9FM
   ujm3hjiheGGblElvl7vreAytDbu9CJMrCJJ/49mZMuETKTThV/WGqGS9s
   3SQun4y0fRrRc3F+XO8ZiE+u2WMI05/B8eItL2yWZ+U7PfDbZorsY1UAM
   3g1P2vRx/MX5I6rHc0AzdlwHZ8FwqNb/Wo5IWQdXsA8ldyMsoG/oazC2/
   Q==;
X-CSE-ConnectionGUID: imKNaLv1Rk6WX7VHhi5teg==
X-CSE-MsgGUID: TlAWNhxmQHqBPLa0FL+ezA==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71409799"
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="71409799"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 00:18:14 -0800
X-CSE-ConnectionGUID: MHwl82IrSaKz9vT/YeQ0zg==
X-CSE-MsgGUID: to0RkkXnTqmYiRSvyEN4+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="214791801"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 04 Feb 2026 00:18:12 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vnY5S-00000000hay-0wcJ;
	Wed, 04 Feb 2026 08:18:10 +0000
Date: Wed, 04 Feb 2026 16:17:47 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 5c009020744fe129e4728e71c44a6c7816c9105e
Message-ID: <202602041637.uMOBbnse-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 6CB0380006
X-Stat-Signature: i9t5rk7e7ebgipbfgp3wrskyngrgw69r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770193095-59984
X-HE-Meta: U2FsdGVkX19BBZGvxotecWbbuH3m+6lW6Ca2xvs/5lvZ28WLKJnLbYUBA3SBa5pJTIFjINwEhbQdCipSG3q4XcxaO4MjCcNoxU++GucLL4RUmfaic0U6WZ39aVlWpLlxZhdZ9wUrYApXThqBafjjhFxqrpnMXPM+VqOr1ywG10VdLFZjIvoYHYu0rKL7akk5vCW4N3yqqMv+uXrOwk96jD2FeT3ZA+pKMphBF66L34Y+1W81ftgM69K68l9qT7XAm7Jp/djI7a9WwvrIOYN/+WmPWJxcu7bK8Lcv3by+a5FbCRN3qBffYTFn5wltOzZZJ4hUPnYbGtvzXGniuH0vHRY5rgYUb24wqeTW3eY0izzyvBnLbIywNtPkyXqQsX+yq7lnK7ZM8l9nKDwFmh9Rbr81QxUxAhOifpNq/T+jmulOzO/gxLsg5JBwdXWwV0xE/nJ6gAfxQJ2Gb3tMxMFLb6GdCl3QuIw4jjRd2jQuKupFzG1WBqpBhnYhJW7ZfkQ0khU+72Cv2HmMRVxVu8dBpZiessNfX6/mT2IW+nnEOvlXK+f2Ye0hXGMZmVVZ/jJEkjNkMXID8gbfat6OItr9EwrNVIkQ84vQVrZxoRqM/9IMnVD7ZfoLe9w/XBTah6U4Q+XvleMnWr8gA/1soeqi7YArUUMCFMzVeeWu2wln4BfkKJeP0j+wFWiHQSrp4j2xWLnS9iSg8L+4lNFqiavTMGr2JsX41ALIiULwHtcLx1qZPhkpHPhLL293tYqeqScuIDi38wJxlIaW+MJObmfZTZx2HEu88T02Nou2DSPbkxAvh53dpHG1WBar8/ZV9i8xBj11X7U/MN4MOhTuaEQj/HJGmtVPpa0VYRyDp1ukQkEXvuSbaubqNvnjb1QP8NzQdBcfdS91mnYtVAFih6xCV0KVO2osudh5XLM2vsP5X0wlXpXQduv9IatWKxWkfee6Y4SgQjWitN/ohFq6z3h
 EWQXyftc
 xf7az3uzGzdjRCy/e8uq3XWpE15BLIot9q4WgDZFhVFdd0Wc8ComlZra3OaLRxjeWKyVYtGeWvo0I/rG/iIRRSTLT4d0MZsisI+/2cWNmU46wGt4TrjKXM0CT2i31UdtFbRUpuPgYHsp5LTVpu2M1Ii43tLZr8Yuz8Kazo1r17I5S47qllqFpkC3h6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 5c009020744fe129e4728e71c44a6c7816c9105e  Add linux-next specific files for 20260203

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild/202602041310.ZBuXDXC5-lkp@intel.com

    include/linux/compiler_types.h:630:45: error: call to '__compiletime_assert_699' declared with attribute error: min(((pos + len - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error

Unverified Error/Warning (likely false positive, kindly check if interested):

    net/ipv4/tcp_output.c:754 tcp_options_write() error: we previously assumed 'tp' could be null (see line 722)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- mips-allyesconfig
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(((pos-len-)-)-(pos-)-max_pages)-signedness-error
`-- s390-randconfig-r071-20260204
    `-- net-ipv4-tcp_output.c-tcp_options_write()-error:we-previously-assumed-tp-could-be-null-(see-line-)

elapsed time: 726m

configs tested: 198
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260204    gcc-9.5.0
arc                   randconfig-002-20260204    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                          ep93xx_defconfig    clang-22
arm                          pxa910_defconfig    gcc-15.2.0
arm                   randconfig-001-20260204    clang-22
arm                   randconfig-002-20260204    gcc-11.5.0
arm                   randconfig-003-20260204    clang-22
arm                   randconfig-004-20260204    gcc-8.5.0
arm                        vexpress_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260204    gcc-8.5.0
arm64                 randconfig-002-20260204    clang-22
arm64                 randconfig-003-20260204    clang-22
arm64                 randconfig-004-20260204    gcc-14.3.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260204    gcc-11.5.0
csky                  randconfig-002-20260204    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260204    clang-19
hexagon               randconfig-002-20260204    clang-18
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260204    clang-20
i386        buildonly-randconfig-002-20260204    gcc-14
i386        buildonly-randconfig-003-20260204    gcc-14
i386        buildonly-randconfig-004-20260204    gcc-14
i386        buildonly-randconfig-005-20260204    gcc-14
i386        buildonly-randconfig-006-20260204    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260204    gcc-14
i386                  randconfig-002-20260204    gcc-14
i386                  randconfig-003-20260204    clang-20
i386                  randconfig-004-20260204    gcc-12
i386                  randconfig-005-20260204    gcc-14
i386                  randconfig-006-20260204    gcc-14
i386                  randconfig-007-20260204    gcc-14
i386                  randconfig-011-20260204    clang-20
i386                  randconfig-012-20260204    gcc-14
i386                  randconfig-013-20260204    clang-20
i386                  randconfig-014-20260204    clang-20
i386                  randconfig-015-20260204    gcc-13
i386                  randconfig-016-20260204    clang-20
i386                  randconfig-017-20260204    clang-20
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260204    gcc-15.2.0
loongarch             randconfig-002-20260204    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                         10m50_defconfig    gcc-11.5.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260204    gcc-11.5.0
nios2                 randconfig-002-20260204    gcc-11.5.0
openrisc                         alldefconfig    gcc-15.2.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260204    gcc-8.5.0
parisc                randconfig-002-20260204    gcc-10.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260204    clang-22
powerpc               randconfig-002-20260204    gcc-14.3.0
powerpc                     tqm8541_defconfig    clang-22
powerpc64             randconfig-001-20260204    clang-19
powerpc64             randconfig-002-20260204    gcc-11.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20260204    gcc-8.5.0
riscv                 randconfig-002-20260204    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                  randconfig-001-20260204    clang-19
s390                  randconfig-002-20260204    gcc-9.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260204    gcc-14.3.0
sh                    randconfig-002-20260204    gcc-12.5.0
sh                   sh7724_generic_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260204    gcc-8.5.0
sparc                 randconfig-002-20260204    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260204    clang-22
sparc64               randconfig-002-20260204    gcc-9.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260204    gcc-14
um                    randconfig-002-20260204    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260204    gcc-12
x86_64      buildonly-randconfig-002-20260204    gcc-14
x86_64      buildonly-randconfig-003-20260204    clang-20
x86_64      buildonly-randconfig-004-20260204    gcc-14
x86_64      buildonly-randconfig-005-20260204    clang-20
x86_64      buildonly-randconfig-006-20260204    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260204    gcc-13
x86_64                randconfig-002-20260204    gcc-14
x86_64                randconfig-003-20260204    gcc-14
x86_64                randconfig-004-20260204    gcc-14
x86_64                randconfig-005-20260204    clang-20
x86_64                randconfig-006-20260204    clang-20
x86_64                randconfig-011-20260204    clang-20
x86_64                randconfig-012-20260204    gcc-14
x86_64                randconfig-013-20260204    clang-20
x86_64                randconfig-014-20260204    gcc-14
x86_64                randconfig-015-20260204    gcc-14
x86_64                randconfig-016-20260204    gcc-14
x86_64                randconfig-071-20260204    gcc-14
x86_64                randconfig-072-20260204    gcc-14
x86_64                randconfig-073-20260204    gcc-14
x86_64                randconfig-074-20260204    gcc-14
x86_64                randconfig-075-20260204    gcc-14
x86_64                randconfig-076-20260204    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260204    gcc-9.5.0
xtensa                randconfig-002-20260204    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

