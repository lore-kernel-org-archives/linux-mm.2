Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDA5EB1049
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA336B0088; Tue, 10 Mar 2026 07:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68176B0089; Tue, 10 Mar 2026 07:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A076B008A; Tue, 10 Mar 2026 07:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9FEC36B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:01:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4FEC8B9C66
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:01:51 +0000 (UTC)
X-FDA: 84529863222.09.5CB82C9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1DCE21A0012
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:01:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YuhS0OnN;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773140509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=gW9hx7xvC5ZdwdTr+erid93BOp0Bq7pVNwTG2kyiWLs=;
	b=qM6NC0+SHLb8VBIqycm+KaaOZcbnPmM4JC/4PrPv3JR4YLGawSoT+IH1I6yteqENPTVifW
	T+GI7VAP5gZ4BO6KRwy58tip3bCTPQHZCgwth1aoZ4OmwJDLFWUi3nYntlXlM1FOLV2yrM
	E3Prym3HykXvhixLsVlJDKhp815DbTw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YuhS0OnN;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773140509; a=rsa-sha256;
	cv=none;
	b=7aitB/0WaL6Kef1Hd/CshxoO4QdqNzZVUi+LAiFAxwf4qyYM/nH7tDsJriO5FcZBVAJtsS
	Js4FnpspVkbMeFDC9OKvnD6Ub6a9XAtiaCePVEvIyC4CK4NLZWXpYlNVIKgqzBvpv6YdeM
	RsI2/5eMyERKtEYif8IZUmMSB4e9NIk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773140509; x=1804676509;
  h=date:from:to:cc:subject:message-id;
  bh=0363HotuGN7sdHQJHTiXexKBNTIXiWOmW8wkRAmaKIQ=;
  b=YuhS0OnN3YrBOPuHR3qNpwOrMndcpBWBElonCIE57eBW9umBxLOPuiZr
   fJ9BwkdpnJZsGgxD1pEr1lOy7CwzRYIx9zPO5BmlmWTQiIoniXv21MvV3
   5uVCKgIF1dBjHbVrQJOP439NYZFFr3Ln9FcjU4ZQbkvKsRYd8+lnzWw1g
   PmrqjLHoUxWM5b+Mh5EShrZ1uccyCxG03o+ddTK5BkolvLyaV+Nn1U0yL
   KWwBmzYqABkJj7uHsE0xoLu3v4ZM1YmF3q0gzqYedELc/iAF24q5nd5gG
   yP/XaeNYpoe/QJEz1RtWhNUimbt/oign3W5VcIU3kWMaDfofeqRjJLUKJ
   w==;
X-CSE-ConnectionGUID: hSEhCVSVSTWeByEMdjqfmQ==
X-CSE-MsgGUID: xPUVExkXSD65XJq3grMkFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11724"; a="74260015"
X-IronPort-AV: E=Sophos;i="6.23,112,1770624000"; 
   d="scan'208";a="74260015"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 04:01:32 -0700
X-CSE-ConnectionGUID: OkdWG4p2T7yQCn2YA/0wfg==
X-CSE-MsgGUID: qhDe0unITYmPWsnjrmvclg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,112,1770624000"; 
   d="scan'208";a="224761838"
Received: from lkp-server01.sh.intel.com (HELO 434e41ea3c86) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 10 Mar 2026 04:01:30 -0700
Received: from kbuild by 434e41ea3c86 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vzuq7-000000001l6-3qhR;
	Tue, 10 Mar 2026 11:01:27 +0000
Date: Tue, 10 Mar 2026 19:00:41 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 343f51842f4ed7143872f3aa116a214a5619a4b9
Message-ID: <202603101931.UYp2uFxv-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: wokdhfdq1wtb9rk43kpkdm9t7h3aqnoz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DCE21A0012
X-HE-Tag: 1773140508-305506
X-HE-Meta: U2FsdGVkX1+sFNF0wb9zSNkb9L6FGBYY4r2JRZdbFYfkAJdu4NzRKXm8s/27bI7Wcl6c3fAVk63xUnTnh1zUpT7FK0CD3DntIBsqgeZCAeBZTSgwvLZNqdTHY876ZEoSlUzD7zrZ/I1MuN49VTzGp5Oq54MAqAq0zGkd998anxJXawMHlJxO3rsUuf0XQP580CfUwPDHrpWyLe6WQRNchnKyDCh0evwZY92my6KvoK7UkCMp3eaKlm2an+XJ0uUkaMDc7Pg3kxzq1l4QgUr0iDackYbzqjkNq3x1oVuzjivJvrqI78norPOmB01GRVVnCNGrUxAdCsq+PqydGlmqL2PO+lwf2TEzJoUBxf1oAfIDEljGoItJ8I/aACJWKB96YkTdGlYQAQ25gUHmieuvesUf/drgSTAVJAmOz93PDfjvEdu+bAoX/3CgBUdRYahXDfN6yPG/908CqLDsEkfjGBoI9/jzVJG1josh2H49O31ljajDp+GYgiK4K6037acYTermh72P9GHQxGj3j7+LwpQSOZ+1gxS10/xZTErVN7hkUOBb/NthfuO8F0aF0zLa7y8bqODggK+2hpybJm9Y2ZdYUeg8O7hwR+foVc2/LoeN//nGpT6NcMSeQnWyqpUrg42C3yuawZtJtbD50/vMmBI/VetiG+eEXspLGaJ5uNoODmpzJDxSfM/vgZ0yKBMoWhd7hNlvwMZmPxz6EFb1hDHC9qA1lpJ7zJWVbMN3yLHID+/bsi1VeyZPTW01OxUAH6v/ycQGEQhQ8gA1c+4iin/xy3uw8BOmt83cwM15O21expZNRUU3xJ/h2mQYms+YrpdlXtpYjTuhIHzerCcbxc1nPRkAjYlP0EofX4t11xdXy4h73NdOYvaI7MPs8WV8jXCNdTfhY27QOpyrSNdshMgxRZqYOy1jMJ7HD1/M8HdzRPbb6vgOwmeBGOWU6m013iR6KjbsflW5LtlGtlr
 qpmRtZho
 SJUZp4eaaL8dV6zzh223ycuZzvss7vrASpeylyh1/EADAHVRWbNrgriwcPJRZkDM7Jl18YM/lprO570o9SRXkkaxYee0iK0zKOROTky+bl0pEKkUlhwH9obfECXLS1kzPgmnMZWmpL4GZ+uopa/k5VX+f8eU6xX04bvz/rLMVWLu5I+VGoReIkbUFtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 343f51842f4ed7143872f3aa116a214a5619a4b9  Add linux-next specific files for 20260309

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202603100730.J3pi4xqi-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603100736.KcTrzKrn-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603100745.tbDqpgNK-lkp@intel.com

    drivers/gpu/drm/amd/amdgpu/amdgpu_display.c:1777:8: error: call to undeclared function 'drm_fb_helper_gem_is_fb'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    drivers/gpu/drm/amd/amdgpu/amdgpu_display.c:1777:8: error: implicit declaration of function 'drm_fb_helper_gem_is_fb'; did you mean 'drm_fb_helper_from_client'? [-Werror=implicit-function-declaration]
    drivers/gpu/drm/radeon/radeon_device.c:1592:22: error: implicit declaration of function 'drm_fb_helper_gem_is_fb'; did you mean 'drm_fb_helper_from_client'? [-Werror=implicit-function-declaration]
    drivers/gpu/drm/radeon/radeon_device.c:1592:8: error: call to undeclared function 'drm_fb_helper_gem_is_fb'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-004-20260310
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_display.c:error:call-to-undeclared-function-drm_fb_helper_gem_is_fb-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- drivers-gpu-drm-radeon-radeon_device.c:error:call-to-undeclared-function-drm_fb_helper_gem_is_fb-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-randconfig-141-20260310
|   `-- drivers-reset-core.c-__fwnode_reset_control_get()-warn:inconsistent-indenting
|-- loongarch-randconfig-001-20260310
|   `-- drivers-gpu-drm-radeon-radeon_device.c:error:implicit-declaration-of-function-drm_fb_helper_gem_is_fb
`-- powerpc-randconfig-001-20260310
    `-- drivers-gpu-drm-amd-amdgpu-amdgpu_display.c:error:implicit-declaration-of-function-drm_fb_helper_gem_is_fb

elapsed time: 730m

configs tested: 199
configs skipped: 5

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260310    gcc-8.5.0
arc                   randconfig-001-20260310    gcc-9.5.0
arc                   randconfig-002-20260310    gcc-15.2.0
arc                   randconfig-002-20260310    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                            qcom_defconfig    clang-23
arm                   randconfig-001-20260310    clang-23
arm                   randconfig-001-20260310    gcc-8.5.0
arm                   randconfig-002-20260310    gcc-12.5.0
arm                   randconfig-002-20260310    gcc-8.5.0
arm                   randconfig-003-20260310    gcc-10.5.0
arm                   randconfig-003-20260310    gcc-8.5.0
arm                   randconfig-004-20260310    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260310    clang-16
arm64                 randconfig-002-20260310    gcc-13.4.0
arm64                 randconfig-003-20260310    gcc-11.5.0
arm64                 randconfig-004-20260310    gcc-8.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260310    gcc-15.2.0
csky                  randconfig-002-20260310    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260310    clang-23
hexagon               randconfig-002-20260310    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260310    gcc-14
i386        buildonly-randconfig-002-20260310    clang-20
i386        buildonly-randconfig-003-20260310    gcc-14
i386        buildonly-randconfig-004-20260310    gcc-14
i386        buildonly-randconfig-005-20260310    gcc-14
i386        buildonly-randconfig-006-20260310    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260310    gcc-14
i386                  randconfig-002-20260310    gcc-14
i386                  randconfig-003-20260310    clang-20
i386                  randconfig-004-20260310    clang-20
i386                  randconfig-005-20260310    gcc-14
i386                  randconfig-006-20260310    gcc-14
i386                  randconfig-007-20260310    gcc-12
i386                  randconfig-011-20260310    gcc-14
i386                  randconfig-012-20260310    clang-20
i386                  randconfig-013-20260310    gcc-14
i386                  randconfig-014-20260310    clang-20
i386                  randconfig-015-20260310    clang-20
i386                  randconfig-016-20260310    gcc-14
i386                  randconfig-017-20260310    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260310    gcc-13.4.0
loongarch             randconfig-002-20260310    clang-18
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
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260310    gcc-11.5.0
nios2                 randconfig-002-20260310    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260310    gcc-14.3.0
parisc                randconfig-002-20260310    gcc-13.4.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260310    gcc-9.5.0
powerpc               randconfig-002-20260310    clang-23
powerpc                    sam440ep_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260310    gcc-15.2.0
powerpc64             randconfig-002-20260310    gcc-8.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260310    clang-19
riscv                 randconfig-002-20260310    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260310    gcc-9.5.0
s390                  randconfig-002-20260310    clang-19
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260310    gcc-15.2.0
sh                    randconfig-002-20260310    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260310    gcc-15.2.0
sparc                 randconfig-002-20260310    gcc-12.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260310    clang-20
sparc64               randconfig-002-20260310    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260310    gcc-14
um                    randconfig-002-20260310    clang-23
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260310    gcc-14
x86_64      buildonly-randconfig-002-20260310    gcc-14
x86_64      buildonly-randconfig-003-20260310    gcc-12
x86_64      buildonly-randconfig-003-20260310    gcc-14
x86_64      buildonly-randconfig-004-20260310    gcc-12
x86_64      buildonly-randconfig-004-20260310    gcc-14
x86_64      buildonly-randconfig-005-20260310    gcc-14
x86_64      buildonly-randconfig-006-20260310    clang-20
x86_64      buildonly-randconfig-006-20260310    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260310    gcc-14
x86_64                randconfig-002-20260310    clang-20
x86_64                randconfig-003-20260310    clang-20
x86_64                randconfig-004-20260310    clang-20
x86_64                randconfig-005-20260310    clang-20
x86_64                randconfig-006-20260310    gcc-14
x86_64                randconfig-011-20260310    gcc-14
x86_64                randconfig-012-20260310    clang-20
x86_64                randconfig-013-20260310    gcc-14
x86_64                randconfig-014-20260310    clang-20
x86_64                randconfig-015-20260310    gcc-14
x86_64                randconfig-016-20260310    clang-20
x86_64                randconfig-071-20260310    clang-20
x86_64                randconfig-072-20260310    clang-20
x86_64                randconfig-073-20260310    clang-20
x86_64                randconfig-074-20260310    gcc-14
x86_64                randconfig-075-20260310    gcc-14
x86_64                randconfig-076-20260310    clang-20
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
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260310    gcc-15.2.0
xtensa                randconfig-002-20260310    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

