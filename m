Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A08FD30CC2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 20:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6920D6B0005; Tue, 13 Jan 2026 15:36:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615B96B0088; Tue, 13 Jan 2026 15:36:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9AD6B0089; Tue, 13 Jan 2026 15:36:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35CFD6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:36:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5BF513A342
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:36:48 +0000 (UTC)
X-FDA: 84328099296.14.23F65E2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23B28180006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:36:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lCBPZdyH;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768336607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=PPJUqHafy8bL93yqSjLCe8y4bowIokTWZLdq3a1ktrQ=;
	b=vOZkcXL53y7G38rZ86Bt8makEP/nwnFfKR+cFrksvtOQurgpaEm1IrTdPhCHuBwtVmvGi7
	RiNgEl4Ug7oalxGDk2BT6525OnzXANjmSb/v9u5w5eP+wANj8QTAljvBrBjB3BwRGZa7RB
	gK0EbBlvfmswFHexON19ABcOAEBKx5M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lCBPZdyH;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768336607; a=rsa-sha256;
	cv=none;
	b=hhkrF/hgxfw5lGrcsJsjVHL5L7b9fl3G9G7ytqyOIDDcr44ahT1YjSYgfYSMvbRUNs1DVE
	7fZ+LCe1jxsMZSYCtS1PtcDpAoM1XHPbaLYKqQNq3JS2mWz7zQE+UudghcIRML/M9pOhSQ
	/vS5rh2E3VGtGlCXuUQ9gODqogzBJlI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768336606; x=1799872606;
  h=date:from:to:cc:subject:message-id;
  bh=AqFgpKxmtXXqS7TYE4xwLV2fxNU9d3LzGPzevw29smE=;
  b=lCBPZdyH9u3q0ahpwS39QoW1gGWvT7gDVfq0NJd95mC8pal0xjketGAm
   lClykgu2xHMZPtq43BI0sC/z+Z7OLNoaphxw9CZrPSkbGwBvA70zyD2O8
   kTdlw16JrAAsnwM2wzuxJBY9X2m6fOBaGiFePmtZBRrQFCjtd4mydOyTy
   AmLVqUOFBq+9M4sv2JCPvK3+KOYQ5k4J1pc4PowoX7xxmmoJK9M0jtMjm
   1N6j1bvOtd9RT3/LYtsMZQqvie5knYLA2grwdPn2YhaUjsZHezrwwlLq2
   rxqVUuxmzeRDQE/Ssa4G9hz5fTHWWtwhfycQfEUHYzeeFlBzn6xrmuQoE
   Q==;
X-CSE-ConnectionGUID: 85upnEF/SySh329mrhyOow==
X-CSE-MsgGUID: lGbfLqyORRmcvHn27psIPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="69712815"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69712815"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 12:36:45 -0800
X-CSE-ConnectionGUID: lt3CIW5ZQ2CuxXTdlWEVxQ==
X-CSE-MsgGUID: uq7MrdvNSKGMnJUadnAMlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204373417"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 13 Jan 2026 12:36:43 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfl85-00000000FLc-0BJC;
	Tue, 13 Jan 2026 20:36:41 +0000
Date: Wed, 14 Jan 2026 04:36:36 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 0f853ca2a798ead9d24d39cad99b0966815c582a
Message-ID: <202601140429.0PmhtIVW-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 23B28180006
X-Stat-Signature: m1dmxrrznwipz8toytmju83yrxnqut74
X-HE-Tag: 1768336605-310605
X-HE-Meta: U2FsdGVkX1+f7suy8yoWFENT2SIfGL6Taf7OUa2SSVaUJR4spE9gK7FIRV9GP96RwCVN6eLaJXRG2hEJwhKEzTA3hBTPlu1nu//fgFlnE+XKsr51MgCNKNYovJlBP5774y9pJzsrUH8q8IaWWW2ACMTY15cwXUTDbmnUTBXSuTo/xhyq6uJumWZ9ACiu7Wopf/IhsF/6i75eqRWk7hHXSg03u3lTKUo73sXnGV3U5O/l/vNFz18dPvPZ6Q52Cd3ZQFfM45Tr98f2Ee2N8ai4ofrMQ0R7S/46B73XIZl8caVcNMv57HslZjUp4SmW2juei/EQPMq1eW0DKzKslMFbM2L7qR8tCwUnY6kHAHhNOQ91L+5tVfMJlaCAgQfUCZrPJkPclaxeVrqMZ6p7W8yQwvTy12E691FuMTxTB0vqIaKbXO6YlfjUe+JM5P0NNkK67SGuW7w/P00wHsSTUfK4teV43Npckx5bXPo2gaL88D7NRfwRguddU2Rw6YOScmMMvtsPESSSXxXp3R3BylQP0c7jhd4KuL1R/ZEEFktlKFrrD8CaEmVMRHhDBGdjiosCz7jKfLZWTkuW+EZ/mXPQnhQq1XEYQDIGNqJVEIZY85leJTSmH0qZm4VnJd/CR2XTtHoW94rAi1YK6m9r0bZJqgu9Z7dNmPNFC9R/Wal8jjm18mZ3twhY311e1KYBIZbgO6UMRf+NPjfVaP7NrnKVLz8DwBE5fc33386KJW6VUzKXa+OHn9FQ1AEkASQ/0Vux74OeHtW3EPncZ1GqW5TCVEMrHrtxXH4TVnKCIFzFvbx+phwtzmiHNhV4nbmST5JVafebqRTiyeN2TXlyYFZHom3p5X06m6WsKXrlsnr1cABAAJ2QMitChG48kfrP1UBSFux+Hd1giSKM+0N0AE/nmKX0eBT3dhMXz3SCbNLOxez0k8pQxLsm3QZ3CJdkY6ZCE+X8n8soI6R0mSrNTUj
 2RTaMWPl
 k3giBoo+bsMdhVIXwmdcEYJ5JErleXEQ6Q5nIwUWNzBIsi2MV1BY/SYNHPG+uHuznyANJ5rNurWgM+s1t/uOhRsZE6DYr6rb641+0cipbwBzWgzTkZkdnyTZWICmTNZP9y/op0i9ItEE45ZalIzXjXkRjE5KwcBJ0abtM+RLT+f4wgg6ZVu0AHURN+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 0f853ca2a798ead9d24d39cad99b0966815c582a  Add linux-next specific files for 20260113

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202601132105.9lgSsC4U-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601132350.ZH49BEj0-lkp@intel.com

    Warning: drivers/char/tpm/tpm_ftpm_tee.c:172 expecting prototype for ftpm_tee_probe(). Prototype was for ftpm_tee_probe_generic() instead
    Warning: drivers/char/tpm/tpm_ftpm_tee.c:275 expecting prototype for ftpm_tee_remove(). Prototype was for ftpm_tee_remove_generic() instead

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/video/backlight/cgbc_bl.c:177:1: sparse: sparse: bad integer constant expression
    fs/fuse/file.c:1326:9: error: call to '__compiletime_assert_496' declared with 'error' attribute: min(((pos + len - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-allmodconfig
|   |-- Warning:drivers-char-tpm-tpm_ftpm_tee.c-expecting-prototype-for-ftpm_tee_probe().-Prototype-was-for-ftpm_tee_probe_generic()-instead
|   `-- Warning:drivers-char-tpm-tpm_ftpm_tee.c-expecting-prototype-for-ftpm_tee_remove().-Prototype-was-for-ftpm_tee_remove_generic()-instead
|-- hexagon-allmodconfig
|   `-- fs-fuse-file.c:error:call-to-__compiletime_assert_NNN-declared-with-error-attribute:min(((pos-len-)-)-(pos-)-max_pages)-signedness-error
`-- i386-randconfig-r122-20260113
    `-- drivers-video-backlight-cgbc_bl.c:sparse:sparse:bad-integer-constant-expression

elapsed time: 780m

configs tested: 304
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260113    clang-22
arc                   randconfig-001-20260113    gcc-8.5.0
arc                   randconfig-001-20260114    gcc-10.5.0
arc                   randconfig-002-20260113    clang-22
arc                   randconfig-002-20260113    gcc-10.5.0
arc                   randconfig-002-20260114    gcc-10.5.0
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                            hisi_defconfig    gcc-15.2.0
arm                   milbeaut_m10v_defconfig    clang-19
arm                        mvebu_v7_defconfig    clang-22
arm                         orion5x_defconfig    gcc-15.2.0
arm                          pxa168_defconfig    gcc-15.2.0
arm                   randconfig-001-20260113    clang-19
arm                   randconfig-001-20260113    clang-22
arm                   randconfig-001-20260114    gcc-10.5.0
arm                   randconfig-002-20260113    clang-22
arm                   randconfig-002-20260114    gcc-10.5.0
arm                   randconfig-003-20260113    clang-22
arm                   randconfig-003-20260114    gcc-10.5.0
arm                   randconfig-004-20260113    clang-22
arm                   randconfig-004-20260114    gcc-10.5.0
arm                           stm32_defconfig    clang-22
arm                           sunxi_defconfig    gcc-15.2.0
arm                           tegra_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260113    clang-22
arm64                 randconfig-001-20260114    clang-22
arm64                 randconfig-002-20260113    clang-22
arm64                 randconfig-002-20260114    clang-22
arm64                 randconfig-003-20260113    clang-22
arm64                 randconfig-003-20260113    gcc-9.5.0
arm64                 randconfig-003-20260114    clang-22
arm64                 randconfig-004-20260113    clang-22
arm64                 randconfig-004-20260113    gcc-12.5.0
arm64                 randconfig-004-20260114    clang-22
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260113    clang-22
csky                  randconfig-001-20260113    gcc-15.2.0
csky                  randconfig-001-20260114    clang-22
csky                  randconfig-002-20260113    clang-22
csky                  randconfig-002-20260113    gcc-9.5.0
csky                  randconfig-002-20260114    clang-22
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260113    clang-22
hexagon               randconfig-001-20260114    clang-22
hexagon               randconfig-002-20260113    clang-22
hexagon               randconfig-002-20260114    clang-22
i386                             allmodconfig    clang-20
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260113    clang-20
i386        buildonly-randconfig-001-20260113    gcc-14
i386        buildonly-randconfig-001-20260114    gcc-14
i386        buildonly-randconfig-002-20260113    clang-20
i386        buildonly-randconfig-002-20260114    gcc-14
i386        buildonly-randconfig-003-20260113    clang-20
i386        buildonly-randconfig-003-20260114    gcc-14
i386        buildonly-randconfig-004-20260113    clang-20
i386        buildonly-randconfig-004-20260114    gcc-14
i386        buildonly-randconfig-005-20260113    clang-20
i386        buildonly-randconfig-005-20260114    gcc-14
i386        buildonly-randconfig-006-20260113    clang-20
i386        buildonly-randconfig-006-20260113    gcc-14
i386        buildonly-randconfig-006-20260114    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260113    clang-20
i386                  randconfig-001-20260113    gcc-14
i386                  randconfig-001-20260114    gcc-14
i386                  randconfig-002-20260113    clang-20
i386                  randconfig-002-20260114    gcc-14
i386                  randconfig-003-20260113    clang-20
i386                  randconfig-003-20260114    gcc-14
i386                  randconfig-004-20260113    clang-20
i386                  randconfig-004-20260113    gcc-14
i386                  randconfig-004-20260114    gcc-14
i386                  randconfig-005-20260113    clang-20
i386                  randconfig-005-20260114    gcc-14
i386                  randconfig-006-20260113    clang-20
i386                  randconfig-006-20260114    gcc-14
i386                  randconfig-007-20260113    clang-20
i386                  randconfig-007-20260113    gcc-14
i386                  randconfig-007-20260114    gcc-14
i386                  randconfig-011-20260113    clang-20
i386                  randconfig-011-20260113    gcc-14
i386                  randconfig-012-20260113    gcc-14
i386                  randconfig-013-20260113    gcc-14
i386                  randconfig-014-20260113    gcc-14
i386                  randconfig-015-20260113    gcc-14
i386                  randconfig-016-20260113    gcc-14
i386                  randconfig-017-20260113    clang-20
i386                  randconfig-017-20260113    gcc-14
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260113    clang-22
loongarch             randconfig-001-20260113    gcc-15.2.0
loongarch             randconfig-001-20260114    clang-22
loongarch             randconfig-002-20260113    clang-22
loongarch             randconfig-002-20260114    clang-22
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                          multi_defconfig    gcc-15.2.0
m68k                           sun3_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                         bigsur_defconfig    gcc-15.2.0
mips                       bmips_be_defconfig    gcc-15.2.0
mips                     cu1000-neo_defconfig    gcc-15.2.0
mips                          eyeq6_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-22
nios2                             allnoconfig    clang-22
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260113    clang-22
nios2                 randconfig-001-20260113    gcc-8.5.0
nios2                 randconfig-001-20260114    clang-22
nios2                 randconfig-002-20260113    clang-22
nios2                 randconfig-002-20260113    gcc-11.5.0
nios2                 randconfig-002-20260114    clang-22
openrisc                         allmodconfig    clang-22
openrisc                          allnoconfig    clang-22
openrisc                            defconfig    gcc-15.2.0
openrisc                  or1klitex_defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                           allyesconfig    clang-19
parisc                              defconfig    gcc-15.2.0
parisc                generic-32bit_defconfig    gcc-15.2.0
parisc                randconfig-001-20260113    clang-19
parisc                randconfig-001-20260113    gcc-13.4.0
parisc                randconfig-001-20260114    gcc-14.3.0
parisc                randconfig-002-20260113    clang-19
parisc                randconfig-002-20260113    gcc-14.3.0
parisc                randconfig-002-20260114    gcc-14.3.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                   motionpro_defconfig    clang-22
powerpc                   motionpro_defconfig    gcc-15.2.0
powerpc                  mpc866_ads_defconfig    clang-22
powerpc                     powernv_defconfig    clang-22
powerpc               randconfig-001-20260113    clang-19
powerpc               randconfig-001-20260113    clang-22
powerpc               randconfig-001-20260114    gcc-14.3.0
powerpc               randconfig-002-20260113    clang-17
powerpc               randconfig-002-20260113    clang-19
powerpc               randconfig-002-20260114    gcc-14.3.0
powerpc                    sam440ep_defconfig    clang-22
powerpc                     tqm8560_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260113    clang-19
powerpc64             randconfig-001-20260114    gcc-14.3.0
powerpc64             randconfig-002-20260113    clang-19
powerpc64             randconfig-002-20260113    clang-22
powerpc64             randconfig-002-20260114    gcc-14.3.0
riscv                            alldefconfig    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv             nommu_k210_sdcard_defconfig    clang-22
riscv                 randconfig-001-20260113    gcc-15.2.0
riscv                 randconfig-001-20260113    gcc-9.5.0
riscv                 randconfig-001-20260114    gcc-15.2.0
riscv                 randconfig-002-20260113    gcc-15.2.0
riscv                 randconfig-002-20260113    gcc-8.5.0
riscv                 randconfig-002-20260114    gcc-15.2.0
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260113    gcc-15.2.0
s390                  randconfig-001-20260113    gcc-8.5.0
s390                  randconfig-001-20260114    gcc-15.2.0
s390                  randconfig-002-20260113    gcc-14.3.0
s390                  randconfig-002-20260113    gcc-15.2.0
s390                  randconfig-002-20260114    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                               allyesconfig    clang-19
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260113    gcc-15.2.0
sh                    randconfig-001-20260114    gcc-15.2.0
sh                    randconfig-002-20260113    gcc-14.3.0
sh                    randconfig-002-20260113    gcc-15.2.0
sh                    randconfig-002-20260114    gcc-15.2.0
sh                           se7619_defconfig    clang-22
sh                           se7724_defconfig    gcc-15.2.0
sh                           se7751_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260113    gcc-14.3.0
sparc                 randconfig-001-20260113    gcc-8.5.0
sparc                 randconfig-001-20260114    clang-20
sparc                 randconfig-002-20260113    gcc-14.3.0
sparc                 randconfig-002-20260113    gcc-8.5.0
sparc                 randconfig-002-20260114    clang-20
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260113    gcc-14.3.0
sparc64               randconfig-001-20260114    clang-20
sparc64               randconfig-002-20260113    gcc-14.3.0
sparc64               randconfig-002-20260113    gcc-8.5.0
sparc64               randconfig-002-20260114    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260113    gcc-14
um                    randconfig-001-20260113    gcc-14.3.0
um                    randconfig-001-20260114    clang-20
um                    randconfig-002-20260113    clang-22
um                    randconfig-002-20260113    gcc-14.3.0
um                    randconfig-002-20260114    clang-20
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260113    clang-20
x86_64      buildonly-randconfig-001-20260114    clang-20
x86_64      buildonly-randconfig-002-20260113    clang-20
x86_64      buildonly-randconfig-002-20260113    gcc-14
x86_64      buildonly-randconfig-002-20260114    clang-20
x86_64      buildonly-randconfig-003-20260113    clang-20
x86_64      buildonly-randconfig-003-20260114    clang-20
x86_64      buildonly-randconfig-004-20260113    clang-20
x86_64      buildonly-randconfig-004-20260113    gcc-14
x86_64      buildonly-randconfig-004-20260114    clang-20
x86_64      buildonly-randconfig-005-20260113    clang-20
x86_64      buildonly-randconfig-005-20260113    gcc-13
x86_64      buildonly-randconfig-005-20260114    clang-20
x86_64      buildonly-randconfig-006-20260113    clang-20
x86_64      buildonly-randconfig-006-20260114    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260113    gcc-14
x86_64                randconfig-002-20260113    gcc-14
x86_64                randconfig-003-20260113    clang-20
x86_64                randconfig-003-20260113    gcc-14
x86_64                randconfig-004-20260113    gcc-14
x86_64                randconfig-005-20260113    gcc-14
x86_64                randconfig-006-20260113    gcc-14
x86_64                randconfig-011-20260113    clang-20
x86_64                randconfig-011-20260113    gcc-13
x86_64                randconfig-012-20260113    clang-20
x86_64                randconfig-013-20260113    clang-20
x86_64                randconfig-014-20260113    clang-20
x86_64                randconfig-014-20260113    gcc-13
x86_64                randconfig-015-20260113    clang-20
x86_64                randconfig-015-20260113    gcc-14
x86_64                randconfig-016-20260113    clang-20
x86_64                randconfig-071-20260113    clang-20
x86_64                randconfig-071-20260113    gcc-13
x86_64                randconfig-072-20260113    clang-20
x86_64                randconfig-072-20260113    gcc-14
x86_64                randconfig-073-20260113    clang-20
x86_64                randconfig-073-20260113    gcc-13
x86_64                randconfig-074-20260113    clang-20
x86_64                randconfig-075-20260113    clang-20
x86_64                randconfig-076-20260113    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                           alldefconfig    gcc-15.2.0
xtensa                            allnoconfig    clang-22
xtensa                           allyesconfig    clang-22
xtensa                  audio_kc705_defconfig    clang-22
xtensa                randconfig-001-20260113    gcc-14.3.0
xtensa                randconfig-001-20260113    gcc-9.5.0
xtensa                randconfig-001-20260114    clang-20
xtensa                randconfig-002-20260113    gcc-14.3.0
xtensa                randconfig-002-20260113    gcc-15.2.0
xtensa                randconfig-002-20260114    clang-20

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

