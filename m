Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6857EA7961
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 04:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9A56B0088; Wed,  4 Feb 2026 23:00:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56046B0096; Wed,  4 Feb 2026 23:00:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59C66B009D; Wed,  4 Feb 2026 23:00:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A05C66B0088
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 23:00:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53ACD1A0386
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:00:53 +0000 (UTC)
X-FDA: 84409051986.03.13D386D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf08.hostedemail.com (Postfix) with ESMTP id 480CB160007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:00:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ijZSe+yd;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770264051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=cCuXNNRwUqL4hH8n+IilzZf/nJZa10JUb79hqYu1AVU=;
	b=ofQ9I7w1rj4NsI+x0vStxKL/TK++kYK8iP8mn/0XKecKxTsbcNC5HJN8DqNn6//1xIHoLn
	QNRaRUZxf/SKG1yaut+Xf2SJzpRhHXOmtYejctEtbEyDIfgUEVgLoRkBQmX1f0LhxLgobD
	fAXek8tjmweuk8xinlq1drJxpYVgOaE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ijZSe+yd;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770264051; a=rsa-sha256;
	cv=none;
	b=zP1sm5LOf0ApXLxA/shZB40EFKUUpRIe0ZuXiNmfiGOvyCtXKyH5KMNKh4jAQOFok4wTkD
	9k82wHswqeFO/oUl2mrrnadi7RrDAKUMb6LkADEH9IQcFDuC1UYvKdCqwMhUyEWRWRiyZH
	GAfCZpO4fa6001kimjTq3Vsvpvdu6RI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770264050; x=1801800050;
  h=date:from:to:cc:subject:message-id;
  bh=kVM26M+M5Oz+12STPjKVFqFJbQk7AGEhD19rhdni1yY=;
  b=ijZSe+yd+ye6mViCcII9Mytf1zPe0kuFRHukkR91cHUkT2Zr1sG0kyPR
   05bagARXGYQQYrhTdOQArBglvshGWTJgMsbLmd6px+c7tYn0ii5ph+VU8
   uNlmX5jE+gsxindDiBRIbLYEUI9qcq2kuGCTKCye1qoFGboJo0+ikxYfx
   anR3jwsooajXsC91qFRLIBVAoHnCDC/t2qvHh3EL87X72rstqxsFpHriW
   CQVgFAMp8Z9B6NM1YXsYTizfmE0FezZhjAT9uQUK7FvwmL5cYvq2v4V7l
   abTu1eldxaRI+QoH7zPo9Dliul9wdA5KX1epFiE/Z1YAYaJQ8geybSbyO
   w==;
X-CSE-ConnectionGUID: rAnbrHNGTs+yCLxZRM3eBQ==
X-CSE-MsgGUID: r+FLH/gDQJK1QxQxjURYkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71354671"
X-IronPort-AV: E=Sophos;i="6.21,273,1763452800"; 
   d="scan'208";a="71354671"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 20:00:49 -0800
X-CSE-ConnectionGUID: vPRsnToZQQ+emhl4KWebJw==
X-CSE-MsgGUID: fHXg5nzlT2mVbDq6fnJ7vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,273,1763452800"; 
   d="scan'208";a="210451218"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 04 Feb 2026 20:00:47 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vnqXt-00000000jOo-0wtD;
	Thu, 05 Feb 2026 04:00:45 +0000
Date: Thu, 05 Feb 2026 11:59:51 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 0f8a890c4524d6e4013ff225e70de2aed7e6d726
Message-ID: <202602051141.8HeFkcxm-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 480CB160007
X-Stat-Signature: y6eukxmjwf7ihx4tympuyr67u6ijrj4d
X-Rspam-User: 
X-HE-Tag: 1770264050-103671
X-HE-Meta: U2FsdGVkX1+QEOh44Cxxf5wdHb+IzS9LhZCFz4IfOfd/xt2OYVawaxb59DM0rqiitZGNVNSB2C4TaKQBa3Sh7mF2RJrdHx++2/PIWgNPZ0OO6DJ6UB1P6lVgCaodK4Kdjx4BRm22pDKDYDhNkVnxdsd/tt5r4nVqRna+XhP9DBDQmapaUAfpmZU7TJQpvqNV24AymHuAkAeh1EdBynsHuRe0ZbA4QwHwzwV3xCJB6NHDieL7Rs3TipCcwInRkr+Wdd7dPKkq/yrJIOrfPitLobTM4HJ88gTsmDl0n3oalmigR3T2vaX7A6/xBUgO3IMhgep52yVQ69J3BhTnNGkf9x1MN0yhlmmY/19xmoZpxGiL612lxWQ/Hw8z2xxltbD7+YVk2bSbN1YneHR6ujXGCWUylBP+9EWqVkeEC4sjZ9y0a1Y2JktBxT7iG5hqMLJ5ZgPh+gsuz+QukF3nKn6OXlD0y+SV1+Z9zSQzsyJVpVKAjW1WcQAfFogwVoMP7aX4N5sCLoUJbAdizTxL098RjjsfIo26fkzmrSIe+2eI62qN5yn4nvncKa45uonwlX0+m4NOOoBzR4G22fSEQJ8DSFayYolo74nfMxQLhWgPynoHpvhPGrfbObYTchRyXEZFI1s+Rh5h9nM6yBYtCEF2IveB7yhk4RJYAG2tmA8MMU9obFtuyowR2ixu25xWXk9kWRXHC1eGn9qQVJ4g4nGIupCTziEbPgmVZGWmk31TkLJTAHogEHj6mEAk6aqyfXhX2qmKVzcOdTwxfzA2BwwZ985ZQsEdS1uZwvp/cfLkgNl6OwAEGiP25kW4E66ojchkZ1i++b9ZZ43EFZjywV+CI4eEzGNcXWBPymqTG06cTnTG6aoHkWHXo6ZoVP7/8SjBRxGvNA1rl6pz9b1k80UFtax7cDKb4uyqqNR1hBNAFWnb/7bnCTeT5LCnpZQt1jPQ38E52hA2SQniWunD722
 mN5m8Jsq
 V3A7qRWR8s0b1++U6woK6ne46wNsP28sz56CLgkildcWTMjeNTK36oZoQmpOys4K0HUqV2ncp74E5rxpqUH8jC3DWpUd6O3MbqPya1WXw4ptb5345J9bGse6x9D17mJx3rJGcLu5iWgZnTBQ8HNoYQ3mXf2PEy7KEeUpl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 0f8a890c4524d6e4013ff225e70de2aed7e6d726  Add linux-next specific files for 20260204

Unverified Error/Warning (likely false positive, kindly check if interested):

    vmlinux.o: warning: objtool: cros_ec_hwmon_read() falls through to next function da9052_channel_is_visible()

Error/Warning ids grouped by kconfigs:

recent_errors
`-- x86_64-buildonly-randconfig-006-20260205
    `-- vmlinux.o:warning:objtool:cros_ec_hwmon_read-falls-through-to-next-function-da9052_channel_is_visible()

elapsed time: 737m

configs tested: 267
configs skipped: 4

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
arc                   randconfig-001-20260205    gcc-8.5.0
arc                   randconfig-002-20260205    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                       aspeed_g4_defconfig    clang-22
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                           imxrt_defconfig    gcc-15.2.0
arm                   randconfig-001-20260205    clang-22
arm                   randconfig-001-20260205    gcc-8.5.0
arm                   randconfig-002-20260205    gcc-8.5.0
arm                   randconfig-003-20260205    clang-22
arm                   randconfig-003-20260205    gcc-8.5.0
arm                   randconfig-004-20260205    gcc-8.5.0
arm                             rpc_defconfig    clang-18
arm                           sunxi_defconfig    gcc-15.2.0
arm                        vexpress_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260205    clang-22
arm64                 randconfig-001-20260205    gcc-10.5.0
arm64                 randconfig-002-20260205    gcc-10.5.0
arm64                 randconfig-003-20260205    clang-22
arm64                 randconfig-003-20260205    gcc-10.5.0
arm64                 randconfig-004-20260205    clang-19
arm64                 randconfig-004-20260205    gcc-10.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260205    gcc-10.5.0
csky                  randconfig-001-20260205    gcc-9.5.0
csky                  randconfig-002-20260205    gcc-10.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260205    clang-22
hexagon               randconfig-001-20260205    gcc-15.2.0
hexagon               randconfig-002-20260205    clang-22
hexagon               randconfig-002-20260205    gcc-15.2.0
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260205    gcc-13
i386        buildonly-randconfig-001-20260205    gcc-14
i386        buildonly-randconfig-002-20260205    clang-20
i386        buildonly-randconfig-002-20260205    gcc-14
i386        buildonly-randconfig-003-20260205    clang-20
i386        buildonly-randconfig-003-20260205    gcc-14
i386        buildonly-randconfig-004-20260205    clang-20
i386        buildonly-randconfig-004-20260205    gcc-14
i386        buildonly-randconfig-005-20260205    gcc-14
i386        buildonly-randconfig-006-20260205    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260205    gcc-13
i386                  randconfig-001-20260205    gcc-14
i386                  randconfig-002-20260205    clang-20
i386                  randconfig-002-20260205    gcc-13
i386                  randconfig-003-20260205    gcc-13
i386                  randconfig-004-20260205    gcc-13
i386                  randconfig-004-20260205    gcc-14
i386                  randconfig-005-20260205    clang-20
i386                  randconfig-005-20260205    gcc-13
i386                  randconfig-006-20260205    gcc-13
i386                  randconfig-007-20260205    gcc-13
i386                  randconfig-007-20260205    gcc-14
i386                  randconfig-011-20260205    gcc-14
i386                  randconfig-012-20260205    clang-20
i386                  randconfig-013-20260205    gcc-14
i386                  randconfig-014-20260205    clang-20
i386                  randconfig-015-20260205    gcc-14
i386                  randconfig-016-20260205    clang-20
i386                  randconfig-017-20260205    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260205    clang-22
loongarch             randconfig-001-20260205    gcc-15.2.0
loongarch             randconfig-002-20260205    gcc-15.2.0
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
mips                        bcm47xx_defconfig    gcc-15.2.0
mips                          eyeq6_defconfig    gcc-15.2.0
mips                      loongson3_defconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260205    gcc-11.5.0
nios2                 randconfig-001-20260205    gcc-15.2.0
nios2                 randconfig-002-20260205    gcc-11.5.0
nios2                 randconfig-002-20260205    gcc-15.2.0
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
parisc                randconfig-001-20260205    gcc-9.5.0
parisc                randconfig-002-20260205    gcc-8.5.0
parisc                randconfig-002-20260205    gcc-9.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                     mpc512x_defconfig    clang-22
powerpc                      ppc44x_defconfig    clang-22
powerpc                       ppc64_defconfig    clang-22
powerpc                      ppc6xx_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260205    gcc-15.2.0
powerpc               randconfig-001-20260205    gcc-9.5.0
powerpc               randconfig-002-20260205    clang-16
powerpc               randconfig-002-20260205    gcc-9.5.0
powerpc64             randconfig-001-20260205    clang-22
powerpc64             randconfig-001-20260205    gcc-9.5.0
powerpc64             randconfig-002-20260205    clang-22
powerpc64             randconfig-002-20260205    gcc-9.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260205    clang-19
riscv                 randconfig-002-20260205    clang-19
riscv                 randconfig-002-20260205    clang-22
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260205    clang-18
s390                  randconfig-001-20260205    clang-19
s390                  randconfig-002-20260205    clang-19
s390                  randconfig-002-20260205    clang-22
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260205    clang-19
sh                    randconfig-001-20260205    gcc-15.2.0
sh                    randconfig-002-20260205    clang-19
sh                    randconfig-002-20260205    gcc-10.5.0
sh                          rsk7201_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260205    gcc-12.5.0
sparc                 randconfig-001-20260205    gcc-15.2.0
sparc                 randconfig-002-20260205    gcc-12.5.0
sparc64                          alldefconfig    gcc-15.2.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260205    gcc-12.5.0
sparc64               randconfig-001-20260205    gcc-8.5.0
sparc64               randconfig-002-20260205    gcc-12.5.0
sparc64               randconfig-002-20260205    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260205    clang-22
um                    randconfig-001-20260205    gcc-12.5.0
um                    randconfig-002-20260205    gcc-12.5.0
um                    randconfig-002-20260205    gcc-13
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260205    clang-20
x86_64      buildonly-randconfig-001-20260205    gcc-14
x86_64      buildonly-randconfig-002-20260205    clang-20
x86_64      buildonly-randconfig-002-20260205    gcc-14
x86_64      buildonly-randconfig-003-20260205    gcc-14
x86_64      buildonly-randconfig-004-20260205    clang-20
x86_64      buildonly-randconfig-004-20260205    gcc-14
x86_64      buildonly-randconfig-005-20260205    clang-20
x86_64      buildonly-randconfig-005-20260205    gcc-14
x86_64      buildonly-randconfig-006-20260205    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260204    gcc-13
x86_64                randconfig-001-20260205    clang-20
x86_64                randconfig-002-20260204    gcc-14
x86_64                randconfig-002-20260205    clang-20
x86_64                randconfig-003-20260204    gcc-14
x86_64                randconfig-003-20260205    clang-20
x86_64                randconfig-004-20260204    gcc-14
x86_64                randconfig-004-20260205    clang-20
x86_64                randconfig-005-20260204    clang-20
x86_64                randconfig-005-20260205    clang-20
x86_64                randconfig-006-20260204    clang-20
x86_64                randconfig-006-20260205    clang-20
x86_64                randconfig-011-20260205    clang-20
x86_64                randconfig-012-20260205    clang-20
x86_64                randconfig-012-20260205    gcc-14
x86_64                randconfig-013-20260205    clang-20
x86_64                randconfig-013-20260205    gcc-14
x86_64                randconfig-014-20260205    clang-20
x86_64                randconfig-015-20260205    clang-20
x86_64                randconfig-015-20260205    gcc-14
x86_64                randconfig-016-20260205    clang-20
x86_64                randconfig-071-20260205    clang-20
x86_64                randconfig-072-20260205    clang-20
x86_64                randconfig-073-20260205    clang-20
x86_64                randconfig-074-20260205    clang-20
x86_64                randconfig-075-20260205    clang-20
x86_64                randconfig-076-20260205    clang-20
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
xtensa                          iss_defconfig    gcc-15.2.0
xtensa                randconfig-001-20260205    gcc-12.5.0
xtensa                randconfig-001-20260205    gcc-8.5.0
xtensa                randconfig-002-20260205    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

