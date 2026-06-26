Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B8FECDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159D86B008A; Fri, 26 Jun 2026 04:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B2E6B0092; Fri, 26 Jun 2026 04:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3DEC6B0093; Fri, 26 Jun 2026 04:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF6C56B008A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:06:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3071C8D920
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:06:52 +0000 (UTC)
X-FDA: 84921332664.18.BBBAD2B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf21.hostedemail.com (Postfix) with ESMTP id 32B161C0003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:06:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aOtKjibV;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782461210;
	b=SlBhZtyxzCcyGuaQs03R0ap4KkXn19ckbkKb0UJGutpIfa91Ty01k9Wh8cc7RzTZZmGZ66
	wi/xarKJhTvXVVo4WgSQC3jg+AJQArMhlauvcI3AbRaMzWRdxuJVT/Rtwam7i3xntA8j8/
	CZxjxatwJqQWTwVMfpwKpCGpPBtPETA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782461210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Vjv1LtbvrHpInQE2KwHegUEyKSFZAGh6kClZltmSZYU=;
	b=Pp/q5V6JeM3d1/iUn16uuHudQ7p8CZc9oVn37JmUAEyoR2Tw1Q/uevpivH1fdjZNjz4BMq
	C1RFuKy3XNUwB4Z3YgeBi3qYxJg0siysbukfRuvRgoYa/YzfCU5+JKKZWFOWoCUEsbvaFb
	6ZtZFfgxHIQ3xXJXUJZqX2fWET3Moag=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aOtKjibV;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782461210; x=1813997210;
  h=date:from:to:cc:subject:message-id;
  bh=4j6n37cVOeTQEpctE0tqVFQuDJIfEJSd1YSdbZVVxdA=;
  b=aOtKjibVK1vdlDh2wp2q3j2KM2pHaLLCdCViAXx+sf6BgWrMRNBJIQxi
   L0iaTFfWsEBggrS5zK29R/CYbuz9J/aBZfC4apYhKZgPIEZ3d5kRiWT2m
   tTN90PMJGcruI/VH5Uc8MjcCJYLqGPooRxbx0w7RDPVH7V4SPwMatzZfO
   cMld54SIe24DUdr5Nwdmd3WvFW4UKD6OoJv6QZBMppzgwagHNipf1PHFf
   dPvH/hKttsFByU4gg62xijGzxyAcjEvqIuQ+b9Tt7geaaRf/e8RH3t6iw
   fswCFIq2eUHG4/L6m2d1oAKa3CuMJAZplbXdKO59Q69VKVZiDDyHdXMXN
   w==;
X-CSE-ConnectionGUID: b6JEpZWrSqGnJswEsRrbEw==
X-CSE-MsgGUID: i5Gxu84ZRoWdArzt7CBhLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11828"; a="93606107"
X-IronPort-AV: E=Sophos;i="6.24,226,1774335600"; 
   d="scan'208";a="93606107"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 01:06:48 -0700
X-CSE-ConnectionGUID: 400PD0BBQ1CYz8JnU+eBjQ==
X-CSE-MsgGUID: nJ/ib+BGSwOymFutel+Jcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,226,1774335600"; 
   d="scan'208";a="251928211"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 26 Jun 2026 01:06:46 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wd1aF-000000004ub-2F2d;
	Fri, 26 Jun 2026 08:06:43 +0000
Date: Fri, 26 Jun 2026 16:06:00 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 openipmi-developer@lists.sourceforge.net,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH UNVERIFIED WARNING
 30ffa8de54e5cc80d93fd211ca134d1764a7011f
Message-ID: <202606261645.OLSSQmr6-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: j59or9ay5tfwnpmid4w9ufyewphmjx5u
X-Rspam-User: 
X-Rspamd-Queue-Id: 32B161C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782461208-833667
X-HE-Meta: U2FsdGVkX1+vlILFW3UdsQBf6DdP/OZOkXAqqAi+yy5t/XJkd1eWS3qq8Yzskw7qWeiaO7CUEMqy5FnFPdE/juJV1BALeU/qnfLpE55t/rIh2ieuZCbS6JGq2rolrtMrX8YqguoBI170XZrhZFDx6vXnvVmEl8KYzkwP2pOePQMDnZCrUB6zZCUeHN1GEgnUmsh9EZwxUNX2t6aUVpLe53xBiuHZfkXZ00kx7cVssOmE4xYvQ7mU/URAOakjT5NxHcVOVBq0AHXz+e3E4yLJUYPB6awbzfQC6PxM8ZC1bS19eV4khUViSi6epSSQzLICWyvdDhgoosWbZlz4vpeaju7UjtyvLEVyaQpftqKVsJM3UFXY+dORuPgy5+GdfAo09jury//UQD9U7WpsP4/T5IWs+3wdJ4H2zOlksHfdxvx+lzvXIoGIonzfwgiVySBuj8vhF6+yFBEJFvZoIGp9PBbX3SrhmsMCJMpkHT9pqPuQbzsQhHAZ3A5raNKD8SU+Hjyg9Vzg/yZe5/TjRQciu6To2g/JMtxOBfw8Q0THXHqSzO31TwAG210l0aZXRUzBrf8mZiF/AenZf6JPKwsGi9Hfq1t7c9yylPs1UVjHL8cS3e84WRzX0losJ9xkXL9NCXksmvfta8z5mA0YY6cGH4ynZVtkm9080vgmkLQiWev9HpjiPgHXwPdD67mFvkmXSm+cvKWN/2UE223G7ki5zCOEzXAzMiehkJTiTIPJd+jSpenCmwEE73SnS5clussSgun+M1OSx3IH5HFIp+TOZN8XEWZYxQubUSKQ6vcPhy9451C0wABWb5U0WKZQfULvDpD51mlaIw4GLS0H39FZzoe51Mbrd9XhhZVXnvmp/UoPxi9ETdsTcTcmPJ3sZwew0aOsgBqr7DHzHSSzOS5sfYaED/YTOgwi7CYJcUbGpz2EnvcjZ4CqmfvR/2O9F8UJETVZPystICCmUKf+Ijk
 VkVzGHsi
 99jg0k3INf96PyAht6430DT/3qwWReug5dW5uRqDrAkTElfvrg9AM96RThqAI+C+NgseCJHWT4qd/WIhCMuug33C6gGM9thP6xVJxiPc2o3cdfnIOVGp9QMYyqSY1bBAiLr+xO3mmlRshwXyj/8726SjBoUPfbzv+ljfv2sSaJh4FO8T47wPhwrKxNcSEeZaDEtCLhLwOa/R66vs7cI+IgmAuWcYBawIpz8iP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 30ffa8de54e5cc80d93fd211ca134d1764a7011f  Add linux-next specific files for 20260625

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202606261001.a4rYzg2M-lkp@intel.com

    drivers/char/ipmi/ssif_bmc.c:158 ssif_bmc_read() error: calling 'spin_unlock_irqrestore()' with bogus flags
    drivers/char/ipmi/ssif_bmc.c:231 ssif_bmc_write() error: calling 'spin_unlock_irqrestore()' with bogus flags

Warning ids grouped by kconfigs:

recent_errors
`-- i386-randconfig-r073-20260624
    |-- drivers-char-ipmi-ssif_bmc.c-ssif_bmc_read()-error:calling-spin_unlock_irqrestore()-with-bogus-flags
    `-- drivers-char-ipmi-ssif_bmc.c-ssif_bmc_write()-error:calling-spin_unlock_irqrestore()-with-bogus-flags

elapsed time: 729m

configs tested: 328
configs skipped: 3

tested configs:
alpha                            alldefconfig    gcc-16.1.0
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                            randconfig-001    gcc-16.1.0
arc                   randconfig-001-20260626    gcc-11.5.0
arc                   randconfig-001-20260626    gcc-13.4.0
arc                   randconfig-001-20260626    gcc-16.1.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260626    gcc-13.4.0
arc                   randconfig-002-20260626    gcc-16.1.0
arc                   randconfig-002-20260626    gcc-9.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260626    gcc-13.4.0
arm                   randconfig-001-20260626    gcc-16.1.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260626    clang-23
arm                   randconfig-002-20260626    gcc-13.4.0
arm                   randconfig-002-20260626    gcc-16.1.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260626    gcc-13.4.0
arm                   randconfig-003-20260626    gcc-16.1.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260626    clang-21
arm                   randconfig-004-20260626    gcc-13.4.0
arm                   randconfig-004-20260626    gcc-16.1.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260626    gcc-8.5.0
arm64                 randconfig-002-20260626    clang-17
arm64                 randconfig-002-20260626    gcc-8.5.0
arm64                 randconfig-003-20260626    gcc-15.2.0
arm64                 randconfig-003-20260626    gcc-8.5.0
arm64                 randconfig-004-20260626    gcc-13.4.0
arm64                 randconfig-004-20260626    gcc-8.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260626    gcc-16.1.0
csky                  randconfig-001-20260626    gcc-8.5.0
csky                  randconfig-002-20260626    gcc-16.1.0
csky                  randconfig-002-20260626    gcc-8.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260626    clang-23
hexagon               randconfig-001-20260626    gcc-11.5.0
hexagon               randconfig-002-20260626    clang-17
hexagon               randconfig-002-20260626    gcc-11.5.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260626    gcc-14
i386                 buildonly-randconfig-002    clang-22
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260626    gcc-14
i386                 buildonly-randconfig-003    clang-22
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260626    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260626    gcc-12
i386        buildonly-randconfig-004-20260626    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260626    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260626    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    gcc-14
i386                  randconfig-001-20260626    clang-22
i386                  randconfig-001-20260626    gcc-14
i386                           randconfig-002    gcc-14
i386                  randconfig-002-20260626    gcc-14
i386                           randconfig-003    gcc-14
i386                  randconfig-003-20260626    clang-22
i386                  randconfig-003-20260626    gcc-14
i386                           randconfig-004    gcc-14
i386                  randconfig-004-20260626    clang-22
i386                  randconfig-004-20260626    gcc-14
i386                           randconfig-005    gcc-14
i386                  randconfig-005-20260626    gcc-14
i386                           randconfig-006    gcc-14
i386                  randconfig-006-20260626    gcc-14
i386                           randconfig-007    gcc-14
i386                  randconfig-007-20260626    gcc-14
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260626    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260626    clang-22
i386                  randconfig-012-20260626    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260626    clang-22
i386                  randconfig-013-20260626    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260626    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260626    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260626    clang-22
i386                  randconfig-016-20260626    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260626    clang-22
i386                  randconfig-017-20260626    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260626    gcc-11.5.0
loongarch             randconfig-001-20260626    gcc-16.1.0
loongarch             randconfig-002-20260626    clang-18
loongarch             randconfig-002-20260626    gcc-11.5.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                     loongson2k_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260626    gcc-11.5.0
nios2                 randconfig-002-20260626    gcc-11.5.0
nios2                 randconfig-002-20260626    gcc-8.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260626    gcc-8.5.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260626    gcc-12.5.0
parisc                randconfig-002-20260626    gcc-8.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                      ep88xc_defconfig    gcc-16.1.0
powerpc                   motionpro_defconfig    clang-23
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260626    clang-23
powerpc               randconfig-001-20260626    gcc-8.5.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260626    gcc-11.5.0
powerpc               randconfig-002-20260626    gcc-8.5.0
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260626    clang-17
powerpc64             randconfig-001-20260626    gcc-8.5.0
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260626    gcc-13.4.0
powerpc64             randconfig-002-20260626    gcc-8.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv             nommu_k210_sdcard_defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-23
riscv                          randconfig-001    gcc-13.4.0
riscv                 randconfig-001-20260626    clang-23
riscv                 randconfig-001-20260626    gcc-11.5.0
riscv                          randconfig-002    clang-17
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260626    clang-23
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-23
s390                           randconfig-001    gcc-15.2.0
s390                  randconfig-001-20260626    clang-23
s390                           randconfig-002    clang-18
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260626    clang-23
s390                  randconfig-002-20260626    gcc-8.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    clang-23
sh                             randconfig-001    gcc-14.3.0
sh                    randconfig-001-20260626    clang-23
sh                    randconfig-001-20260626    gcc-9.5.0
sh                             randconfig-002    clang-23
sh                             randconfig-002    gcc-9.5.0
sh                    randconfig-002-20260626    clang-23
sh                    randconfig-002-20260626    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260626    gcc-12.5.0
sparc                 randconfig-002-20260626    gcc-12.5.0
sparc                 randconfig-002-20260626    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260626    clang-20
sparc64               randconfig-001-20260626    gcc-12.5.0
sparc64               randconfig-002-20260626    clang-20
sparc64               randconfig-002-20260626    gcc-12.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260626    clang-18
um                    randconfig-001-20260626    gcc-12.5.0
um                    randconfig-002-20260626    clang-23
um                    randconfig-002-20260626    gcc-12.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260626    gcc-14
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260626    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260626    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260626    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260626    gcc-14
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260626    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260626    clang-22
x86_64                randconfig-002-20260626    clang-22
x86_64                randconfig-002-20260626    gcc-14
x86_64                randconfig-003-20260626    clang-22
x86_64                randconfig-004-20260626    clang-22
x86_64                randconfig-005-20260626    clang-22
x86_64                randconfig-005-20260626    gcc-13
x86_64                randconfig-006-20260626    clang-22
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260626    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260626    gcc-14
x86_64                         randconfig-013    clang-22
x86_64                randconfig-013-20260626    clang-22
x86_64                randconfig-013-20260626    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260626    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260626    gcc-14
x86_64                         randconfig-016    clang-22
x86_64                randconfig-016-20260626    gcc-14
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260626    gcc-14
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260626    clang-22
x86_64                randconfig-072-20260626    gcc-14
x86_64                         randconfig-073    clang-22
x86_64                         randconfig-073    gcc-14
x86_64                randconfig-073-20260626    gcc-14
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260626    gcc-14
x86_64                         randconfig-075    gcc-13
x86_64                         randconfig-075    gcc-14
x86_64                randconfig-075-20260626    gcc-14
x86_64                         randconfig-076    clang-22
x86_64                         randconfig-076    gcc-14
x86_64                randconfig-076-20260626    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260626    gcc-12.5.0
xtensa                randconfig-002-20260626    gcc-10.5.0
xtensa                randconfig-002-20260626    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

