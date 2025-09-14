Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24228CA0EE8
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 18:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1376E8E0002; Sun, 14 Sep 2025 14:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8E28E0001; Sun, 14 Sep 2025 14:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19628E0002; Sun, 14 Sep 2025 14:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D93D08E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:56:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3AFEB119B73
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 18:56:19 +0000 (UTC)
X-FDA: 83888761278.08.34D6AEA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6ACC3160003
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 18:56:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C8glCeuR;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757876177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=5+kv/rg64ELfDk0m4UcXl6qxxZoLtpdfMSpEO5WSEq8=;
	b=KIPGtSdik8d+GEyY2J3yvsz4oJSDktNXfnxaud290tRN0/d8Z9D2kZsUD0dnocptYBP2UQ
	A3GBInXxXOS7eZMQQiBKyUi8QyoD5VWIq2hb8QTKrdKTHDm+355FnoZ/jROhNOfIF6SkkY
	etrZzwyjPz/DwTM5V71vw6IhYqjaYaY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757876177; a=rsa-sha256;
	cv=none;
	b=CV77qxCECE+XtFhtdqcvlHqCMK57ENO2BD2Uamr6AzPGvar4hanXsOvjNFjb0F0jDGstWs
	a5okiN5eF3JLWPb6roGFflHKKrTbyqMrFfah6ZUNZC3DRhKcBMvvoCVgi1TK4nD/HX3D4K
	BrkKdEgJfdKQHfloq7ZLDS8LKAHO5YE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C8glCeuR;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757876177; x=1789412177;
  h=date:from:to:cc:subject:message-id;
  bh=yUSGoeAuTPqijYtuUdyvmBlNV2IAiDfkn4zwO7YvcYE=;
  b=C8glCeuRLupjBK+Drpygj5IbJYIn5vOnP9KaVudT2izyIooRjBmmmRU9
   cT4q1AhRehO6/bPhWnupF6UZjndJCGxzvRL931MifEz9A/6pCQnObWvqf
   FWj1UnavF6ORXEwoDrup+w1F/X1e+CjWQcDMGvPG01qDrofgjCKLyLfSE
   VkgBOVkwMDyHhOtuuvTuofmY3MTiwylJIXrpB45WozfiIYSNB+SKEqoFs
   xei/QtDzGAb4akuAZksEEkjJqNOI4l9JJ83v/PqLQewmugMZhuaf4RREX
   EPWZCGr03WX/rNJem8iiZfZ2XL7xxMkpfNB2WM8IEFZ4Zef+49rcoD4f8
   w==;
X-CSE-ConnectionGUID: nZmgUemSRm+iNRfTHdPNwA==
X-CSE-MsgGUID: oa9vX2qxQgSp3VgOnJHu9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60058516"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60058516"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 11:56:15 -0700
X-CSE-ConnectionGUID: wG2RzWsoSzmJW4OeSk/F7g==
X-CSE-MsgGUID: 3ZrylrDHTF+yayP9wacEow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,264,1751266800"; 
   d="scan'208";a="174368234"
Received: from lkp-server02.sh.intel.com (HELO eb5fdfb2a9b7) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2025 11:56:13 -0700
Received: from kbuild by eb5fdfb2a9b7 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uxrtT-0002dc-1G;
	Sun, 14 Sep 2025 18:56:11 +0000
Date: Mon, 15 Sep 2025 02:55:40 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 e68f150bc11d0a05cbe984a4e5c0f72a95cae07d
Message-ID: <202509150230.nwOVCLAe-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Queue-Id: 6ACC3160003
X-Stat-Signature: s3cduhctwtxc9x6zqfc15tfy1ysp4xm3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757876176-904833
X-HE-Meta: U2FsdGVkX1/OcVhCx7IG+RhAbnxAVTw8kquTLPC2JxytMUBUB5GlEBhU77LIgb5TOxgCFsGf8CcJpPO4gG51/UimcDRLoeOGzXON6rFK6/hXnP7fVT1eQ18oHF8eUU+JGNouEnMuhUHd6ymuIyQaSro5auu00YHYW9BvMGD51PRazYBlmn/qbGRH4hSqoTn4ptjAFu/xktpQmMsFPjcn1hsuCcFloUVyGUBEsSnh6ATEPBy8NPaGH99gJ/YDuLqzaOPChtzA/iyHVety3vlqodGI0eCwri5tFzg0xBnZLCxMpxZ5GVI2FW7CJ/1sJjpXBVeLVFwrI9OxjJGEPUaB8GW+ituxr98EWGD8AsffX8RKTvGAyke0eEyoA4aSdMXPxqZRj9MXJ3/RqfmRCuC+E3rYVUDJrvZ+4U1PkzoQKRZHflHhFMRPZEoH0MsDnBR8DD9wFp3PGkE8I2AdvDCd3c2naY6npUrr81YGxsMEX+oTUsP/l4ulaKa0q/PuBS0iipYTa96zXeWLOxztxtckSHiwR+0LM3F6ikuEpiSjYfGF/VAsQ0nkVKjLgClLdbxMd1Dk8V7P524RwcQMNQn1oJQyDuGgEUQhpT7PUDBVYBT3SbJvwcQjRMqpzGoNa/K1ZobxK5btzNUdx2iz2jSqkEa4gvaNp7MLLgsbhmdeXZfB+udCb1CRTRjW6KIndz7wMDGBOlAyReBfY26rXtbod5mbxFAED90vmNd/BRcYsU6tz6BszmDcYbhy9Pk4CzI4LJRmQWmOfAPG4rjmQlaOQu6oqU29B0Yxr81SVaZVZ/gQMocLa8/V7IaPdU+sKL0eKYPM/Try9w3qC5tPUqb6VD4qDSW+QiFsUCaDwfaUFBprQQrLIEJrRzHmW2n4gZjjwcfWqTPMM+GEdU+Pn61pj/032ZCaGqvqOlsKB67Uj0oKdqpugBgqYfetl2PlbLXbVRVOZ2Y+5q0bgA0LEev
 Ughn92CM
 dXurAb57s4jVYJfnOiIMC7NknVkzUooC8GvKjKMPnXlV9hk2VdxXlG5k6IL5cC99sLuDD5ugYrhix2dDbBc6MUviHdbnhlA35LXH/pHc6Omcq4BLtrkBs4x4VMn7z2pLdsLb4L3HTX4+U2Z7Itj8y83pnxpcNGwtaJ2zp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: e68f150bc11d0a05cbe984a4e5c0f72a95cae07d  memblock: drop for_each_free_mem_pfn_range_in_zone_from()

elapsed time: 726m

configs tested: 128
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                   randconfig-001-20250914    gcc-9.5.0
arc                   randconfig-002-20250914    gcc-10.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                            mmp2_defconfig    gcc-15.1.0
arm                        multi_v7_defconfig    gcc-15.1.0
arm                   randconfig-001-20250914    clang-22
arm                   randconfig-002-20250914    clang-19
arm                   randconfig-003-20250914    gcc-14.3.0
arm                   randconfig-004-20250914    gcc-12.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                 randconfig-001-20250914    gcc-9.5.0
arm64                 randconfig-002-20250914    clang-22
arm64                 randconfig-003-20250914    clang-17
arm64                 randconfig-004-20250914    gcc-8.5.0
csky                              allnoconfig    gcc-15.1.0
csky                  randconfig-001-20250914    gcc-15.1.0
csky                  randconfig-002-20250914    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon               randconfig-001-20250914    clang-22
hexagon               randconfig-002-20250914    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20250914    gcc-13
i386        buildonly-randconfig-002-20250914    gcc-14
i386        buildonly-randconfig-003-20250914    gcc-14
i386        buildonly-randconfig-004-20250914    gcc-14
i386        buildonly-randconfig-005-20250914    clang-20
i386        buildonly-randconfig-006-20250914    gcc-14
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch             randconfig-001-20250914    clang-22
loongarch             randconfig-002-20250914    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                       m5475evb_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                   sb1250_swarm_defconfig    gcc-15.1.0
nios2                         10m50_defconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250914    gcc-10.5.0
nios2                 randconfig-002-20250914    gcc-11.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250914    gcc-8.5.0
parisc                randconfig-002-20250914    gcc-10.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20250914    clang-22
powerpc               randconfig-002-20250914    clang-22
powerpc               randconfig-003-20250914    clang-22
powerpc64             randconfig-001-20250914    clang-22
powerpc64             randconfig-002-20250914    clang-22
powerpc64             randconfig-003-20250914    gcc-13.4.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250914    clang-22
riscv                 randconfig-002-20250914    gcc-12.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250914    gcc-10.5.0
s390                  randconfig-002-20250914    gcc-15.1.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250914    gcc-15.1.0
sh                    randconfig-002-20250914    gcc-10.5.0
sh                           se7724_defconfig    gcc-15.1.0
sh                        sh7785lcr_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250914    gcc-11.5.0
sparc                 randconfig-002-20250914    gcc-14.3.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250914    gcc-8.5.0
sparc64               randconfig-002-20250914    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20250914    clang-22
um                    randconfig-002-20250914    clang-18
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250914    clang-20
x86_64      buildonly-randconfig-002-20250914    clang-20
x86_64      buildonly-randconfig-003-20250914    clang-20
x86_64      buildonly-randconfig-004-20250914    clang-20
x86_64      buildonly-randconfig-005-20250914    gcc-14
x86_64      buildonly-randconfig-006-20250914    clang-20
x86_64                              defconfig    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                       common_defconfig    gcc-15.1.0
xtensa                randconfig-001-20250914    gcc-14.3.0
xtensa                randconfig-002-20250914    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

