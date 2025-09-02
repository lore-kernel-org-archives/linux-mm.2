Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E84ACA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E92B6B000C; Tue,  2 Sep 2025 07:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0C46B000D; Tue,  2 Sep 2025 07:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AF2A6B000E; Tue,  2 Sep 2025 07:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 747256B000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:31:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2503A11A9D0
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:31:13 +0000 (UTC)
X-FDA: 83844094026.26.CE89F22
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id B2828160004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:31:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K7bKabaI;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756812671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=DvlQ9T5dzDjt3Pp+cOthrYcdADjeZp/NUxfohy+PPM0=;
	b=EsOY1DCslp0PLOJvZljL0rJEV+T7DAxIE16a4RhfHva7+8UgGRq3qU/GXkn34UZBgGWWK2
	Zvj7/rIg2Xu37aGUJaspu7Awqb5AjYj18tLN4XC+rXxMjykDDaBikDjxSovjLQY0+nZ0dV
	bXV4/AFcMTf4wmwOd57ADDEU/C0Yf/c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K7bKabaI;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756812671; a=rsa-sha256;
	cv=none;
	b=HgvZlXnDNUeYGqNP7my8A7/7TR7WSsNZZsxyXrojL8UaPrXzL6hgIpWwt85bn5pmaORF62
	f3u3M60VCfCPWh2h4RyFERaWRSsA5/3++zNlJnBM9Zi8BPz0zOfF8Pn7BrLqgMhEeZImLG
	MIlCoKWk+wvswlpaWbWQ0J/8Lm+HCDk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756812671; x=1788348671;
  h=date:from:to:cc:subject:message-id;
  bh=ydFfqyXuPdz/86yTvg5TOK3h0ctjjPy2vkYvHBHx55s=;
  b=K7bKabaIkqJpmb6rHcI+3ujv8/4ZYWVOIWKkThJAPcDuodNU/JxbdOZz
   O//7/n2xGrKnRLt9sguZ4TJX4cjOWBl7JMiIl+V2+1MqKBbVKVCkkIRK4
   msjfpehoQn6atAjF6dYvy/7YfmtOf9KzSbZ59t9dP9Q5TKn2GN1mnIs2j
   O1K+O0ZQr03IjXsBP9f+6sSwqM0v7WtxFDuFsuC5poncd9G4o6ZShm6j8
   SaPfnPNMYXBImuDWJJ5+kgSTC86YlKc49BM6xQCCBCdRSPMC55Ear9hTi
   q7vh0WF5FBCSNbh1Q/KAWDM4xL0yMokN+yobgUrB7NvtaZfMuK+AnGCto
   w==;
X-CSE-ConnectionGUID: pU20TfYmTP6LzoM6iIjffg==
X-CSE-MsgGUID: M7hHcFa5RwOCIfptsu9uRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11540"; a="70510397"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="70510397"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 04:31:09 -0700
X-CSE-ConnectionGUID: 1NmdDOmJQCGaHUFmQv5c8A==
X-CSE-MsgGUID: REAAK0z5Q/a5a49luxOd1g==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 02 Sep 2025 04:31:08 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utPE3-0001uM-2A;
	Tue, 02 Sep 2025 11:31:01 +0000
Date: Tue, 02 Sep 2025 19:30:36 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 79533628b74b5ef659df73145075b54218890b5c
Message-ID: <202509021921.NyWcdkhJ-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B2828160004
X-Stat-Signature: 8u3hr1i3x7htmb197ghcq1eka4dihfmj
X-Rspam-User: 
X-HE-Tag: 1756812670-609248
X-HE-Meta: U2FsdGVkX194LAQsIbvZ3eqPYf5ecJV7t4spHZiDEvS21/sIUXwoOEdsztHiLgnXqqkiXhlNEf3mX+XIAd0izCZTMiHKP3j1TmSqqtsCdA0Rt2y87iZRL70dZ4UkxqnrWPuJj3a+dCDnafYNZCOM2eT3+W9EcnaqAnN91jWILj1YF9UThoo7csI1KTky6tfVM4Wd8cd9cIw11ke4UPyPsUc6aTJvLZKdxbtDNPFHvk6IOvPRVo9veED4Zg+vC9fZcH3fXDP8mHne4tUH4XnQQ2x6mtbtxoB/9yIRQKo62aBLGpQbcnXqGTEaq1bacUaRZJS46k77WxO6ASTKDMYngN499YQ6nssxv92bPieBI0eVWbPLN6ddun7kKM+23LOkX3KAxLAaj61KznMwH1Ir9rgjZJumF2LlwRwXGmQx78bLzVFM5HmDB1FMqtwcoFv+op4i27ocwrqigadBXgmCwV3EO63Q/gFpeNGri5poFYzPD4hFJr2W4PzB8/HjnbRgfK+mn/65v96v6W2wHU6qtfNEIUvtN1otj31Xk5+SuUFqdvQahSeDexSVeg6Lt0f3UAwQyBXN1NC+Q3KIbs+RzHxcoEusK6qLxGEjeZUpYW4AR1M/ZGIXyQm0ImVrvAQHnRpPH0ZjNKFpmUVpWxxiNlapUrlHDdMFO3FfIATwNN+JwpgWsVEtlKPD6+P7DOUjnANTrH59K9RbqW6uIF5obXeQ10l940JMhSTm5WhkLjJX9ob3PmMHeF82cfRxnOmwb3tz/y4G4j3MqiQ84I97GMeZCAf0Tf+KPfaRIFNISHshbyVXxUZ+2p3PFQEAiGevgsxFvLoZ9juJ22pOYlFtB9rWn7yPhOlk8tWxQAEdVfRoCbKRiFX3b5tkRGqE8fKC0PxYketCPuRE5lsqtF9iE0E+lVkLLBVZOFPByIPu2A5WI2vkitqstCY6VCitM+DtefCp4+2glF5s2zVPh2t
 mhDhoHWJ
 RaGfjivqMwmmH655O7V8Ars9+c5qT3caU+x9UZUWQ6jB7uVZA8Qfr+1M1N7EXnlRr76c/1iLrD9fn8kfqLeng2fMddqWtGak5ivPxREP+r8lv88o0ZJ9OMTRUTc+d8+2ya76e6wXDcz6sU53DqKnpi/6RlmVsfPFEPz6H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 79533628b74b5ef659df73145075b54218890b5c  memblock: drop for_each_free_mem_pfn_range_in_zone_from()

elapsed time: 1460m

configs tested: 112
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            alldefconfig    gcc-15.1.0
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                   randconfig-001-20250902    gcc-11.5.0
arc                   randconfig-002-20250902    gcc-9.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                             pxa_defconfig    gcc-15.1.0
arm                   randconfig-001-20250902    gcc-15.1.0
arm                   randconfig-002-20250902    gcc-8.5.0
arm                   randconfig-003-20250902    clang-22
arm                   randconfig-004-20250902    clang-22
arm                        realview_defconfig    clang-16
arm64                             allnoconfig    gcc-15.1.0
arm64                 randconfig-001-20250902    gcc-8.5.0
arm64                 randconfig-002-20250902    clang-22
arm64                 randconfig-003-20250902    gcc-12.5.0
arm64                 randconfig-004-20250902    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                  randconfig-001-20250902    gcc-14.3.0
csky                  randconfig-002-20250902    gcc-12.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon               randconfig-001-20250902    clang-18
hexagon               randconfig-002-20250902    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386        buildonly-randconfig-001-20250902    clang-20
i386        buildonly-randconfig-002-20250902    clang-20
i386        buildonly-randconfig-003-20250902    gcc-12
i386        buildonly-randconfig-004-20250902    clang-20
i386        buildonly-randconfig-005-20250902    gcc-12
i386        buildonly-randconfig-006-20250902    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch             randconfig-001-20250902    clang-22
loongarch             randconfig-002-20250902    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                          eyeq5_defconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250902    gcc-9.5.0
nios2                 randconfig-002-20250902    gcc-11.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250902    gcc-8.5.0
parisc                randconfig-002-20250902    gcc-11.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc               randconfig-001-20250902    gcc-9.5.0
powerpc               randconfig-002-20250902    gcc-8.5.0
powerpc               randconfig-003-20250902    gcc-11.5.0
powerpc                     tqm8540_defconfig    gcc-15.1.0
powerpc                         wii_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20250902    gcc-12.5.0
powerpc64             randconfig-002-20250902    clang-22
powerpc64             randconfig-003-20250902    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                 randconfig-001-20250902    gcc-13.4.0
riscv                 randconfig-002-20250902    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                  randconfig-001-20250902    clang-22
s390                  randconfig-002-20250902    gcc-10.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                          polaris_defconfig    gcc-15.1.0
sh                    randconfig-001-20250902    gcc-12.5.0
sh                    randconfig-002-20250902    gcc-12.5.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250902    gcc-14.3.0
sparc                 randconfig-002-20250902    gcc-8.5.0
sparc64               randconfig-001-20250902    clang-20
sparc64               randconfig-002-20250902    gcc-9.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                    randconfig-001-20250902    gcc-12
um                    randconfig-002-20250902    gcc-12
x86_64                            allnoconfig    clang-20
x86_64      buildonly-randconfig-001-20250902    clang-20
x86_64      buildonly-randconfig-002-20250902    clang-20
x86_64      buildonly-randconfig-003-20250902    clang-20
x86_64      buildonly-randconfig-004-20250902    gcc-12
x86_64      buildonly-randconfig-005-20250902    gcc-12
x86_64      buildonly-randconfig-006-20250902    gcc-12
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250902    gcc-9.5.0
xtensa                randconfig-002-20250902    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

