Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E57C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201D76B008A; Thu, 10 Sep 2026 11:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0DB6B009E; Thu, 10 Sep 2026 11:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EDD56B009F; Thu, 10 Sep 2026 11:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E838B6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:20:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91A6E804EE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:20:57 +0000 (UTC)
X-FDA: 85198215354.01.25BF1CD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3DC8618000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:20:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zozhw4k1;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789053655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=8BayN0Ejy498d7RF9UchD4BowntY7xZfoI1o9sxQduo=;
	b=xDuXlvsx7oMeZOoX57mCLAyq7lHqL/Qh5fGtImEQo3z3+f+E99I6njTGr30PEbDDVKmz0C
	M8UBy+rIy0s5fkUB3Vf2J2dHZf/8Cqe/TAlzNO5S0Ugkxb0NIW7lM44JEHrZkord9B9dAG
	VO7ObX25VUnb75PuA+9CE0TAObShzTE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zozhw4k1;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789053655;
	b=f2Y4cWy2LQyNjMZh7Qh4KNhif0xnEeRysP97qjm91luzFOH9xmJ21KWjdEAlvJ8OnOnc6+
	txj8LAr84zsBQRT+nlp7YwfVhIHpNOLSxdhY7v4NW69FJ4XcD5hM7J9SJAys2CXgit++Ht
	S4kFx/qH2M+jSS5uzH60a6UQF0/WyjI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789053655; x=1820589655;
  h=date:from:to:cc:subject:message-id;
  bh=HoInOlsBJColKNSa9k2lX+WFe9e0+VE3iX2mzKsHXCY=;
  b=Zozhw4k1pzPov2M13WvSYRlkLauyTzmp48Bn4EfA97yZTrg7TCOs9YQG
   xCtus/Og01RRJDwRnb58rn4TwdNYqO2j8Tu62R60zszlHaVhwIpaKl2bN
   7Skvr9oHTP7qzHINGBZvyNIJ1WmG1pRyC5pKDIboxFFte5wJbRMJG4Gqn
   +yWD0znovBFTdJd3z8d3ROTmxjqboOD/Qlkxyu1KFvDeQB1iYgH40YNsR
   RmY7QLH3Kiv4dAYvSmqVDauZCnyTPMBMwppbs3GtTohUmC0mxnEDS6Z0t
   z60cM7uiWsVQKT9OAghhnwEzf5yLaC8Qyp6PM1VcqzhdfrRXDtU9xCnqM
   w==;
X-CSE-ConnectionGUID: zTMtEYf3QAS/Zwet5PmnGg==
X-CSE-MsgGUID: kN+RaWl5RqWQ9VgN4A38sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89349998"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="89349998"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 08:20:54 -0700
X-CSE-ConnectionGUID: fqpZ910GTyi12MUg0/wVOA==
X-CSE-MsgGUID: mTzi1CUcQBGbNBUmkqTf4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="296650520"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 10 Sep 2026 08:20:53 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4ga2-000000000Cz-2blF;
	Thu, 10 Sep 2026 15:20:50 +0000
Date: Thu, 10 Sep 2026 23:05:57 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 6e33dc90df108c76899dc544a42d17adcba61668
Message-ID: <202609102354.ns94kIZj-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: 9redkycnom8nommwm659a3db9q9nqw19
X-Rspamd-Queue-Id: 3DC8618000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1789053655-483204
X-HE-Meta: U2FsdGVkX1/j2tYefUYiN5lkJaH62Uy/yoQJvtA4ey1Tu4eHd9+8BZQXvVMjbAXt6pFqfIZO/IzyvK0luKnncUYofSVowyGFYggn5rM8Q3Ibuf+dgPKi2zsJ+lrhYqiLY2YRduxiORSqgeVVoTtcyGsko3C6EBmBhchdeZN4e0GuB68WXXo0wIArHeGfucH2CxFW2hv31XRU4hDPFpIMfGe1kWXRWohAHxKs+xmWYvQVNi8ENV4cj5gKaDDQlsEe62O2r9ka2BF2R2WFI7JhYeg+x/Egx8G/QnEYjsrSp5VHh775G8Q9HFfzczCL0DM72K359+HiRTt3Q55E4GBql/u+Y+mVOtzCfrn/7O0DGZda57ndYEmwSCce4ydR644605Yr96si/Vc2VyB+oXg0YdRuMuyDmGD+YDe6EmCqHtL7l8Mz4QhsU1nqRDKtxIAhTFczke3F19s4lnhh5rEXaU/eSCWpdmvBX6uyb76ASmq9oQ1hFIQmCecctaf5kt7ErKAOnFKdsB6IWpjs1guMdyGcZzNUF0lZ0ezT8oCT/nhq5JT1rBeg0MONxZWtv6k+nqZwO5PtAFt01bimNQmZXw1bjYzo9uc4PxO5lOfy+JULTglFypUlfNrg/WMd3O4kFNzulJbjNBwN5FC2niXX829lyu8eDm+Hv+KOioWeOIa+AdmEqvwXhEdUIocPATGicMiCufKppxSU9Zbd84VIg7odE8aEltCTdymT3/IrWh8Hr7yaLsM7L/XW24WYoZZ8fgpilnPn1F4Wa8uJj2dyn3MmzIauolXivq61ifBnWEPSwUZ9atyGbYo+xtMLkzRUMdelEGalgl9Hzf2OzCpItCI0Z4AqMdEZ52yv0WCdEbDFWpj1HUuOZy0lS8HWZl/rjZ+lz/FG09KO4k4+kE8Cb9YKHqEGDC8wJQ8pNZ0Bw5jcVoNpEYjWiy7xM6D6RnAAlwp3B8zKmmiJRmT/kj3
 ACDhZ+PG
 tTUeEHNSOKDnHeWaDisXbHKqefPYSq9s7PnZafj4eUtB2u154wl7PwqYTj88VPWI1vqSKhtf5zBj/SNoawxo4ozqKwbRFAjyTWnbt4YjgcgH4O+qf8obnzSi4s0H+YL4Ny7WY5y3k+xDpBMBsxOH2NPp1bG5jUOBWbWRhwFqbJuUEhgmsCDAgc7ZSd79nQPeuOMeTTrxkSrunsMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: 6e33dc90df108c76899dc544a42d17adcba61668  MAINTAINERS: update memblock tree URLs

elapsed time: 1283m

configs tested: 60
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha          allnoconfig    gcc-16.1.0
alpha         allyesconfig    gcc-16.1.0
arc           allmodconfig    clang-24
arc            allnoconfig    gcc-16.1.0
arc           allyesconfig    clang-24
arm            allnoconfig    gcc-16.1.0
arm           allyesconfig    clang-24
arm64         allmodconfig    clang-24
arm64          allnoconfig    gcc-16.1.0
csky          allmodconfig    gcc-16.1.0
csky           allnoconfig    gcc-16.1.0
hexagon       allmodconfig    gcc-16.1.0
hexagon        allnoconfig    gcc-16.1.0
i386          allmodconfig    clang-22
i386           allnoconfig    gcc-16.1.0
i386          allyesconfig    clang-22
loongarch     allmodconfig    clang-24
loongarch      allnoconfig    gcc-16.1.0
m68k          allmodconfig    gcc-16.1.0
m68k           allnoconfig    gcc-16.1.0
m68k          allyesconfig    clang-24
microblaze     allnoconfig    gcc-16.1.0
microblaze    allyesconfig    gcc-16.1.0
mips          allmodconfig    gcc-16.1.0
mips           allnoconfig    gcc-16.1.0
mips          allyesconfig    gcc-16.1.0
nios2         allmodconfig    clang-20
nios2          allnoconfig    clang-24
openrisc      allmodconfig    clang-20
openrisc       allnoconfig    clang-24
parisc        allmodconfig    gcc-16.1.0
parisc         allnoconfig    clang-24
parisc        allyesconfig    clang-17
parisc        allyesconfig    gcc-16.1.0
powerpc       allmodconfig    gcc-16.1.0
powerpc        allnoconfig    clang-24
riscv         allmodconfig    clang-24
riscv          allnoconfig    clang-24
riscv         allyesconfig    clang-24
s390          allmodconfig    clang-17
s390           allnoconfig    clang-24
s390          allyesconfig    gcc-16.1.0
sh            allmodconfig    gcc-16.1.0
sh             allnoconfig    clang-24
sh            allyesconfig    clang-17
sh            allyesconfig    gcc-16.1.0
sparc          allnoconfig    clang-24
sparc64       allmodconfig    clang-20
um            allmodconfig    clang-17
um             allnoconfig    clang-24
um            allyesconfig    gcc-16.1.0
x86_64        allmodconfig    clang-22
x86_64         allnoconfig    clang-24
x86_64        allyesconfig    clang-22
x86_64        rhel-9.4-bpf    gcc-14
x86_64      rhel-9.4-kunit    gcc-14
x86_64        rhel-9.4-ltp    gcc-14
x86_64       rhel-9.4-rust    clang-22
xtensa         allnoconfig    clang-24
xtensa        allyesconfig    clang-20

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

