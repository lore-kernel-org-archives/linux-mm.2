Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1018FC55172
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 01:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06D96B007B; Sat,  1 Aug 2026 21:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9186B0088; Sat,  1 Aug 2026 21:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0116B008A; Sat,  1 Aug 2026 21:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B26956B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 21:38:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 385B0803DE
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 01:38:59 +0000 (UTC)
X-FDA: 85054620798.27.D029F15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2CC6B2000A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 01:38:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AGikiPa3;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785634737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=C19hve588DnzcFH8uWCj+YwuZLkTgJ8CLuGSsBQ1Bkc=;
	b=t5ZoGghCr2IZ9/svk5bJYhFwy2jEfGdWSPv6CFr21m/AUa2py0oh9ZZw5wHai4JnnBGPrc
	0o/u9P0nP6XlFw3lgOY/+BtN2zOqwy1DW970QZMg+Wfrp9dk3vhax3xe8nohEJarmEMWW5
	WMCp6Iy0NtE4ICh8dUVeMYvOWixfjIY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785634737;
	b=8Sq6OWAd79jztAUyh39G8Af+uhbeWbtqbGtObAv83nAG/P5/i8fvceMcU8F2rsXPdbPCAs
	ye6aVrz0CQg37CCEViuK+n/sNiHHfescq/bgurajw/tYW4PmvuVLZMzEVXJeigA/4VXWXy
	sR4jyX9Rbsr60KuDs2jZJOkL5mezLYQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AGikiPa3;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785634736; x=1817170736;
  h=date:from:to:cc:subject:message-id;
  bh=hS10nZx5Hn0mGgHEEt2AXD26Xiyvngo2nHPew1Xm0Sg=;
  b=AGikiPa3feo27mXUfeufVKLYfUcdFGsLWyvqyGnFx2aDDjhPlqY6XofJ
   sKQp0o3WkDQuzADfVY6Jfldh1ejKBQc6cp38JtnBn9f4k0Rg7wrrrSgp5
   CFYVbD4/2P7ZkYZ3fkxqa0Kf75gh6P7NsPXghxdKjHHt95QcwBmoXeoRI
   d1UmGENbuxASMdPcim4/6NZwUikLpuJjY216yTzoEUaujEm8HF/ISuSZc
   fclXxpjSp6jz7V8+smmJy/r5f1ZxGMg7ooltylCvUAquXZOJtmOI14TbN
   TkbNkMHIoArW4QoBhW8kWxKF0mADf05u+v7phxqUlyfsfleYFJsJm36OU
   Q==;
X-CSE-ConnectionGUID: Ejc0G+BWRpW6FZZSlZ95gQ==
X-CSE-MsgGUID: aYkr8wZWRfu/QmhBCuSDaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11862"; a="96575758"
X-IronPort-AV: E=Sophos;i="6.25,199,1779174000"; 
   d="scan'208";a="96575758"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2026 18:38:55 -0700
X-CSE-ConnectionGUID: 5mnELcdQSY6EdwCplfUJwQ==
X-CSE-MsgGUID: mDxZVVnkSG2YJmumGepz3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,199,1779174000"; 
   d="scan'208";a="285519037"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 01 Aug 2026 18:38:52 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wqLA9-000000004Ej-3hke;
	Sun, 02 Aug 2026 01:38:49 +0000
Date: Sun, 02 Aug 2026 09:38:15 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 1dbd7c34bb92dd9c0b0363b75f6ec444299af108
Message-ID: <202608020900.F5dVXAQc-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CC6B2000A
X-Stat-Signature: c1onjwutzgbrn9db1sptk8wbeqz8ezui
X-Rspam-User: 
X-HE-Tag: 1785634735-820955
X-HE-Meta: U2FsdGVkX1978hzJMUXAL64bJvNNr/t+cuuFJ7RakjZznpYwy9ls2onWYhmLjTI2OAGs5iucpGbU73Ws95fnJEmGaKtHOYMG628mcJuKRUOvwY8XW5jAU84dN3hP6ZXm6+GfvB82F2/3Br4YXgketcIfco9HqbGg0h1LgPsqYE5BBcny5gjuXbz/Hjw2+DfxkeiTv/OlqHlx69Dr89kL0hHkm4cVqBfY/D4Th1cLRtGt7XmQCLrDfEV1UVaFH0s3/q0pMMVZT6Ejwp7uMg6xrmPLJyn4uE5GA7RUbGBTfLJBRCdpL0PG66K7gaTFj03RDbx3vdugjTOEXyjx8cuFW3Vwf4clhzpgmJv3LG3PxTEfWPAF1O6FslrIgtCZntVXC0AZI7uheziBpOsXPzmhRedZXScilztNjsNYJfVs3/5IauLkDPvCVpWqNQLJhW7XxrufRF/nYKdAlLIiLHW+tCg+KI1Rh9xXrSDHElHQj3RNFJolQ27BWwJ6uLo3Y8e+bo0+5DXa+btXd6643FpsPSqdMJc2WSeViDqsqCWpFMVolYUqtJqFzQPp2kAUh19zk6Qa/NTxpRVnF/nNT//XHZAXNHuYI6RoHoMeGFvjYAyitVjE+2C5KOoJk9vInQ+mwpJP8rw1sb/TTpZD1wQN4i7kX3yQ+raAP7daNgaIJ4eBYnMxJ2ZPb5FwJ5xZuhCEMHRom5TOGNp2deCRF1bPVKXP+HLpCP6pEYI8Ktdb6aDrU2CQoV7klCpfSv+98ibRP7yjKnROeaXxcMn5JFeBLIgb8S/DqlWY8sckZ3ZWhOG6nQ0+4Ma8WE7x6h5MaXn/IHRiiaMjo/CAC9Le+q8nXrKd0f11drrX/ZQeTrvYL3m/PTnkMJXG4W4gN+jwMMIRl+a7rTKRTGyjIQBiMNPLq3gb9o+MaZ7h5E9rFThiMUFxhxjg+ykPJ2GNbivsSoYYm6UMDEACybhpF/+mjP9
 ef0/bfb4
 bgtqAD21+eYCCrJv9HHI5c1sYXV7RxnDDYw44AvX0TOg+zX+vBUFnXZujAn15yvehTLdVAUJxHqmDJZ8vhsFu6AbwtW1yaBlUN7K1tl8TjhGYama0x2rAfitEyYz7atxtLul1j7uT+Mh24tNKHRSHx4VcD8JBVndn38s+6DkHxTuizuHGKp9yVJwrKlJz72T4062/WQalOF8w95k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 1dbd7c34bb92dd9c0b0363b75f6ec444299af108  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 744m

configs tested: 181
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    gcc-8.5.0
arc                  randconfig-001-20260801    gcc-14.3.0
arc                  randconfig-001-20260802    gcc-15.2.0
arc                  randconfig-002-20260801    gcc-12.5.0
arc                  randconfig-002-20260802    gcc-15.2.0
arm                  randconfig-001-20260801    clang-24
arm                  randconfig-001-20260802    gcc-15.2.0
arm                  randconfig-002-20260801    gcc-8.5.0
arm                  randconfig-002-20260802    gcc-15.2.0
arm                  randconfig-003-20260801    gcc-12.5.0
arm                  randconfig-003-20260802    gcc-15.2.0
arm                  randconfig-004-20260801    clang-18
arm                  randconfig-004-20260802    gcc-15.2.0
arm64                randconfig-001-20260802    gcc-9.5.0
arm64                randconfig-002-20260802    gcc-9.5.0
arm64                randconfig-003-20260802    gcc-9.5.0
arm64                randconfig-004-20260802    gcc-9.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260801    gcc-12.5.0
csky                 randconfig-001-20260802    gcc-9.5.0
csky                 randconfig-002-20260801    gcc-10.5.0
csky                 randconfig-002-20260802    gcc-9.5.0
hexagon                       randconfig-001    clang-17
hexagon              randconfig-001-20260801    clang-24
hexagon              randconfig-001-20260802    clang-24
hexagon              randconfig-002-20260801    clang-17
hexagon              randconfig-002-20260802    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260801    clang-22
i386       buildonly-randconfig-001-20260802    gcc-14
i386       buildonly-randconfig-002-20260801    clang-22
i386       buildonly-randconfig-002-20260802    gcc-14
i386       buildonly-randconfig-003-20260801    clang-22
i386       buildonly-randconfig-003-20260802    gcc-14
i386       buildonly-randconfig-004-20260801    clang-22
i386       buildonly-randconfig-004-20260802    gcc-14
i386       buildonly-randconfig-005-20260801    gcc-14
i386       buildonly-randconfig-005-20260802    gcc-14
i386       buildonly-randconfig-006-20260801    gcc-14
i386       buildonly-randconfig-006-20260802    gcc-14
i386                 randconfig-001-20260801    clang-22
i386                 randconfig-001-20260802    gcc-14
i386                 randconfig-002-20260801    gcc-14
i386                 randconfig-002-20260802    gcc-14
i386                 randconfig-003-20260801    clang-22
i386                 randconfig-003-20260802    gcc-14
i386                 randconfig-004-20260801    clang-22
i386                 randconfig-004-20260802    gcc-14
i386                 randconfig-005-20260801    clang-22
i386                 randconfig-005-20260802    gcc-14
i386                 randconfig-006-20260801    clang-22
i386                 randconfig-006-20260802    gcc-14
i386                 randconfig-007-20260801    clang-22
i386                 randconfig-007-20260802    gcc-14
i386                 randconfig-011-20260801    clang-22
i386                 randconfig-011-20260802    gcc-14
i386                 randconfig-012-20260801    gcc-14
i386                 randconfig-012-20260802    gcc-14
i386                 randconfig-013-20260801    gcc-14
i386                 randconfig-013-20260802    gcc-14
i386                 randconfig-014-20260801    clang-22
i386                 randconfig-014-20260802    gcc-14
i386                 randconfig-015-20260801    clang-22
i386                 randconfig-015-20260802    gcc-14
i386                 randconfig-016-20260801    gcc-14
i386                 randconfig-016-20260802    gcc-14
i386                 randconfig-017-20260801    clang-22
i386                 randconfig-017-20260802    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260801    clang-18
loongarch            randconfig-001-20260802    clang-24
loongarch            randconfig-002-20260801    gcc-16.1.0
loongarch            randconfig-002-20260802    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260801    gcc-8.5.0
nios2                randconfig-001-20260802    clang-24
nios2                randconfig-002-20260801    gcc-11.5.0
nios2                randconfig-002-20260802    clang-24
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260801    gcc-11.5.0
parisc               randconfig-001-20260802    gcc-14.3.0
parisc               randconfig-002-20260801    gcc-9.5.0
parisc               randconfig-002-20260802    gcc-14.3.0
powerpc                  bluestone_defconfig    clang-24
powerpc              randconfig-001-20260801    clang-20
powerpc              randconfig-001-20260802    gcc-14.3.0
powerpc              randconfig-002-20260801    gcc-10.5.0
powerpc              randconfig-002-20260802    gcc-14.3.0
powerpc64            randconfig-001-20260801    clang-24
powerpc64            randconfig-001-20260802    gcc-14.3.0
powerpc64            randconfig-002-20260801    clang-24
powerpc64            randconfig-002-20260802    gcc-14.3.0
riscv                randconfig-001-20260801    gcc-14.3.0
riscv                randconfig-001-20260802    gcc-13.4.0
riscv                randconfig-002-20260801    clang-20
riscv                randconfig-002-20260802    gcc-13.4.0
s390                 randconfig-001-20260801    gcc-15.2.0
s390                 randconfig-001-20260802    gcc-13.4.0
s390                 randconfig-002-20260801    clang-24
s390                 randconfig-002-20260802    gcc-13.4.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260801    gcc-16.1.0
sh                   randconfig-001-20260802    gcc-13.4.0
sh                   randconfig-002-20260801    gcc-16.1.0
sh                   randconfig-002-20260802    gcc-13.4.0
sh                          se7724_defconfig    gcc-16.1.0
sparc                randconfig-001-20260801    gcc-8.5.0
sparc                randconfig-001-20260802    gcc-12.5.0
sparc                randconfig-002-20260801    gcc-11.5.0
sparc                randconfig-002-20260802    gcc-12.5.0
sparc64              randconfig-001-20260801    gcc-9.5.0
sparc64              randconfig-001-20260802    gcc-12.5.0
sparc64              randconfig-002-20260801    gcc-15.2.0
sparc64              randconfig-002-20260802    gcc-12.5.0
um                   randconfig-001-20260801    clang-17
um                   randconfig-001-20260802    gcc-12.5.0
um                   randconfig-002-20260801    gcc-14
um                   randconfig-002-20260802    gcc-12.5.0
x86_64     buildonly-randconfig-001-20260801    clang-22
x86_64     buildonly-randconfig-001-20260802    gcc-12
x86_64     buildonly-randconfig-002-20260801    clang-22
x86_64     buildonly-randconfig-002-20260802    gcc-12
x86_64     buildonly-randconfig-003-20260801    gcc-13
x86_64     buildonly-randconfig-003-20260802    gcc-12
x86_64     buildonly-randconfig-004-20260801    clang-22
x86_64     buildonly-randconfig-004-20260802    gcc-12
x86_64     buildonly-randconfig-005-20260801    clang-22
x86_64     buildonly-randconfig-005-20260802    gcc-12
x86_64     buildonly-randconfig-006-20260801    clang-22
x86_64     buildonly-randconfig-006-20260802    gcc-12
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260801    clang-22
x86_64               randconfig-001-20260802    clang-22
x86_64               randconfig-002-20260801    gcc-14
x86_64               randconfig-002-20260802    clang-22
x86_64               randconfig-003-20260801    gcc-14
x86_64               randconfig-003-20260802    clang-22
x86_64               randconfig-004-20260801    clang-22
x86_64               randconfig-004-20260802    clang-22
x86_64               randconfig-005-20260801    gcc-14
x86_64               randconfig-005-20260802    clang-22
x86_64               randconfig-006-20260801    gcc-14
x86_64               randconfig-006-20260802    clang-22
x86_64               randconfig-011-20260801    clang-22
x86_64               randconfig-011-20260802    clang-22
x86_64               randconfig-012-20260801    gcc-14
x86_64               randconfig-012-20260802    clang-22
x86_64               randconfig-013-20260801    clang-22
x86_64               randconfig-013-20260802    clang-22
x86_64               randconfig-014-20260801    gcc-14
x86_64               randconfig-014-20260802    clang-22
x86_64               randconfig-015-20260801    clang-22
x86_64               randconfig-015-20260802    clang-22
x86_64               randconfig-016-20260801    clang-22
x86_64               randconfig-016-20260802    clang-22
x86_64               randconfig-071-20260801    gcc-14
x86_64               randconfig-071-20260802    gcc-12
x86_64               randconfig-072-20260801    gcc-14
x86_64               randconfig-072-20260802    gcc-12
x86_64               randconfig-073-20260801    clang-22
x86_64               randconfig-073-20260802    gcc-12
x86_64               randconfig-074-20260801    gcc-14
x86_64               randconfig-074-20260802    gcc-12
x86_64               randconfig-075-20260801    clang-22
x86_64               randconfig-075-20260802    gcc-12
x86_64               randconfig-076-20260801    clang-22
x86_64               randconfig-076-20260802    gcc-12
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260801    gcc-9.5.0
xtensa               randconfig-001-20260802    gcc-12.5.0
xtensa               randconfig-002-20260801    gcc-15.2.0
xtensa               randconfig-002-20260802    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

