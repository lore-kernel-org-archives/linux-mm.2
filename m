Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E94BCD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 03:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29AB86B0005; Mon,  8 Jun 2026 23:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2250D6B0088; Mon,  8 Jun 2026 23:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EC786B008A; Mon,  8 Jun 2026 23:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED8A36B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 23:37:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4834D1C1AD9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:37:12 +0000 (UTC)
X-FDA: 84858963504.24.7BC51F4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4831980006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:37:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bA0CPMlq;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780976230;
	b=sZBoFeHSdpXp0uSJD0QWUY+I8s+Q4VIlx6aYjMMJDuaEtEx9axpS1tBIHLtdfH/fNZS6Z+
	HSJgNconNPEfDND4MslJZl+r13fDkEIRoWuudZjPfV9fhikZGMp+PjHBInWgIC4e+/jsnp
	g+fvgeswWOnGlwYUL7J/fmnHFvnN280=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bA0CPMlq;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780976230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=sAU94trGdt4pmC8akWxyY2yODZN6Ff6XllokUmBz0fw=;
	b=8hF/b29JOuBlD9hB5tmh3JcoNIyrQo9iSX/QQQE+iftSANzoRlc/+3Lbvl13FfaCdftsB5
	Wa3tXGmPs+TTQfL/9GChmMD1pd7Hx3N9TN4ddt0da9dyqfrIk8ETqsUXC3S+CiklTY4vxd
	ryTsEovGKowsNP7ArY0oXGEOjXeoGlo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780976229; x=1812512229;
  h=date:from:to:cc:subject:message-id;
  bh=KW5C4lJSk6O2gOxYt1A2csvxMRKpWeYC2DUHpt6Hpco=;
  b=bA0CPMlqeGN/jTQLjknJNTAZnoF5asZHt+NHIFjhsa+MpcEM4geACaBU
   8OIwZQHIDRVefPoXqpvOcdUJp4kOZYRTNWaUdH7sJOYkoAOYosppIfmXZ
   AimfrFeMyhfZdv9RSji1eF3BK0rpACtnqYcquQm1fa1JRRxkzNdx7g1yu
   tmaSHxmpilLul9iGsa3ZponLRcDyZueTv7rgJYdZ3nQ6TXMss3zQZZCBK
   SQ/iDYnXRz+eAT8DU4sJiefpnTUrWYJnd9g5esfuE5J2DyrcrLrR/8CHN
   L4KRa3LoYkCYuZKthEjqhxaJM0W3UlJc0voKRkZM9d1GQpbyMMtsrL1o7
   g==;
X-CSE-ConnectionGUID: 8ouTqUXTSBqhtWCiXE/Uwg==
X-CSE-MsgGUID: bNujCjXUTYysZA171oe0OA==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="92050281"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="92050281"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 20:37:08 -0700
X-CSE-ConnectionGUID: n2nXO1NuTPSYrVoazEOnig==
X-CSE-MsgGUID: F8H7oA6wS960+pPHh8laNQ==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 08 Jun 2026 20:37:07 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wWnGy-00000000JaG-22YX;
	Tue, 09 Jun 2026 03:37:04 +0000
Date: Tue, 09 Jun 2026 11:36:49 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 7c2eee9c136734825ff524dd8b2146438a4f8250
Message-ID: <202606091134.TX4vLFgO-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4831980006
X-Rspam-User: 
X-Stat-Signature: fx1yznzgzh7qtm7c4jwe876zhw9p6hqu
X-HE-Tag: 1780976229-331284
X-HE-Meta: U2FsdGVkX19iLkYMXE3e9Kpk4lkD2lF2wS4OVa6xGlAlBdiTTBRBkQb15xjRYCf6KpnANZQ7GmM2E/5IfbCcOToWtAWzEjDIWS0NVZJ3okO/bQCmeFZm8+/LnK6r7t/wMVRK0Y6mrZo3cqIT5wknmF00uUL7G+zbCzzaMg++mgPmET5qi3vq/fuNB9IAgJV1Tt5gXyGSdrS9xt5DSya5axgKtNpCoxtU+LpGO9E+qaJQ000mLpNhzzRaI1VK0lcZgulwPDcfkzAhGQ83Vjp6y1oaQmET0eNrFypYxHAN4nYYeGIo6D/k9m2q9ddkfD5++cWYCr+i/sxmwuE47lwWgqTdCF2AgSQEE8dyR1HtnbzjABDAqB9Bn9Rur5Z88wmhsYZR48dqsajlsYJ/+m0qzMcbiHqId+I+l6nzNeAmlt3babnuAiQcnMe5X9FfY2RwdTcnqu0mJ1zia7DzIMRbMbxce+9ZN617mm8BkK1wxKvgvnNZ3Xr8v/AucHHw4ImQswqm8tLZm+xHf5QX85yTUuY4iND1aShq3kPicOBBoBldAaXp5A1gRZA6ypZKgSPH4Cc2iyViEJ3SjSjcovwnEzC8Jruli2QXkUNr75W8ELywWsgMDhsT6uFCHHneVwcOpIq2RRwpSl/fd49Ljxdtrp8UwwE+Mjfab7STATQeysPvAJpJmDx98phEs2vrfaED6vsju1wqAltUJ8XBstTpjWEfRMXbAfUmQrc6DAgMy5uFHggB/kTlOlTCipWk+IDsF6K7tAn5AAJl3rzcjY6ajnb5n1r7UqflULym1pd+3GBUwMKf88Q7pyNaD9H5UNnPdu03SVMz3kdeHZbYjyMfUJhXLqSy7TdN2j42s3DhaKLh7H4b1RdisElkDoAx/gscyYObWMQjLrjS6Vr2bN/eezC4gsVwjWdaCAPEB7eJAurGhycYgdcL7dfF3BLD3crt2ymPO7EKzX7aAYNydtn
 T4kWvkbm
 Ncv2t4EzDA4Lg7DOWImhJKNP94xkTV7JQDwUwovfnIdqLKboxk8llIa7MpzyHI97YXHKMEnzFHEFpiNXMxqZnbu/JLr4T8Y9mdXEMkzlfc2gU9XH2bt2Y6GqB7ABkyQH5Xqi/rxjGTgNaf5FqvdHHejUBtbXkWLTTdqkDia/cNHTxr/4OETc0H4u/iPjsPcJqJnjXvTn5k5XjY1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: 7c2eee9c136734825ff524dd8b2146438a4f8250  memblock: don't touch memblock arrays when memblock_free() is called late

elapsed time: 9939m

configs tested: 123
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260609    gcc-15.2.0
arc                   randconfig-002-20260609    gcc-13.4.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                   randconfig-001-20260609    gcc-13.4.0
arm                   randconfig-002-20260609    clang-23
arm                   randconfig-004-20260609    clang-23
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                 randconfig-001-20260609    clang-23
arm64                 randconfig-002-20260609    gcc-13.4.0
arm64                 randconfig-003-20260609    gcc-15.2.0
arm64                 randconfig-004-20260609    clang-23
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                  randconfig-001-20260609    gcc-9.5.0
csky                  randconfig-002-20260609    gcc-11.5.0
hexagon                          allmodconfig    clang-23
hexagon                           allnoconfig    clang-23
hexagon               randconfig-001-20260609    clang-18
hexagon               randconfig-002-20260609    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260609    gcc-14
i386        buildonly-randconfig-004-20260609    clang-22
i386                                defconfig    clang-22
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-20
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260609    clang-23
loongarch             randconfig-002-20260609    clang-23
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260609    gcc-11.5.0
nios2                 randconfig-002-20260609    gcc-11.5.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260609    gcc-14.3.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260609    gcc-16.1.0
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    gcc-16.1.0
powerpc               mpc834x_itxgp_defconfig    clang-23
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260609    clang-23
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260609    clang-23
powerpc64                      randconfig-001    clang-16
powerpc64             randconfig-001-20260609    gcc-8.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                 randconfig-002-20260609    clang-23
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260609    clang-23
s390                  randconfig-002-20260609    gcc-16.1.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260609    gcc-13.4.0
sh                    randconfig-002-20260609    gcc-11.5.0
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260609    gcc-16.1.0
sparc                 randconfig-002-20260609    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64               randconfig-001-20260609    clang-23
sparc64               randconfig-002-20260609    gcc-10.5.0
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260609    gcc-14
um                    randconfig-002-20260609    gcc-12
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-22
x86_64                              defconfig    gcc-14
x86_64                randconfig-011-20260609    gcc-14
x86_64                randconfig-012-20260609    clang-22
x86_64                randconfig-013-20260609    gcc-14
x86_64                randconfig-014-20260609    gcc-14
x86_64                randconfig-015-20260609    clang-22
x86_64                randconfig-016-20260609    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260609    gcc-16.1.0
xtensa                randconfig-002-20260609    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

