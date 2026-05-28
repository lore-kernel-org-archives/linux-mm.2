Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BABD2CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 05:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB466B0005; Thu, 28 May 2026 01:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83946B0088; Thu, 28 May 2026 01:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBFB46B008A; Thu, 28 May 2026 01:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD2F36B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 01:09:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 410DF917EC
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:09:59 +0000 (UTC)
X-FDA: 84815651718.26.365217E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf04.hostedemail.com (Postfix) with ESMTP id 886154000E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nwUkPd7L;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779944997; a=rsa-sha256;
	cv=none;
	b=h+dqgJ9tphscpLH+KSnr6+icattBRT34G3gxRyVpAJrmRpkU0vbvyanysNsKGXyghxpoVa
	LJ1zWDXcI0gL1AAVnSnl8F9jloATioQJg1evtfNXIyqE+Jf6W2P2Psm50gAGaFKTUtyv+S
	YNBqjnCTDHJKfZaMWeYHnAaNVKxtR1I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nwUkPd7L;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779944997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=eelhDCdw1kYU6txTVKa9PxCxzYnSFi0fc7/6FrGqPHo=;
	b=AQKTckQVCN15r7YVc8aZ1AuWG1wHfug516LrcwaJHYmvQ35zHluEBKxLUpRZzAklhHESMi
	DeIavofEMWJV2RcUBrzHyfVG54zd13iaemx+fBbsshgjSnyMqEXIHGdOzgL/rpAtXOdKIN
	H/06sffiNue4SYbPdoBme1lPNwbiTAA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779944996; x=1811480996;
  h=date:from:to:cc:subject:message-id;
  bh=nQo2IzY0UlFf8tCUPnT/P5Gd5KBr5ac8QxT5To5kt+8=;
  b=nwUkPd7LwaEzBydZ0gwWFUkZkAzhN2lB9LzeJEJFxi2UHgQu2qHQf2/w
   CP5uOL0RC0Ofu/J5ZPPcyPZqtt0N+2XggsID8w7ty4MwItoZQxSGahuH6
   n4SOH8qm8Rl/wQx61AMXXStYRiOH/l9bqEN73Vhn0sUqod4JUsYXfQWMp
   I4F6SUY++RYA7RA0ch0umoWqrf+DQtWAQjSb8ddZFFxcxqGpE8a5FVOHi
   VLEIl5156B6UDnC2jnWFNX8xWsqVYbKaL9f0HlGnT8ZAFvogi6zLmYp18
   dyeyVFszp01mv9J+eGmylTCmE8enZfp3RsQqMrSmkekUySdQYiHFj39JW
   w==;
X-CSE-ConnectionGUID: QmUG/NvaQQWQv/QqgiLh3Q==
X-CSE-MsgGUID: EHLa9yviRsSowbZRdPGeYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80773702"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="80773702"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 22:09:54 -0700
X-CSE-ConnectionGUID: F+SVkDKHRwWqJojPL3xybg==
X-CSE-MsgGUID: yq65eNt+R3+pSelFKVBWqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="266341877"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 27 May 2026 22:09:53 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wST0A-000000005Yg-2fh1;
	Thu, 28 May 2026 05:09:50 +0000
Date: Thu, 28 May 2026 13:09:31 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 audit@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 e7d700e14934e68f86338c5610cf2ae76798b663
Message-ID: <202605281316.GwqEa9Tn-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 886154000E
X-Stat-Signature: gsb7feqerzq8s39pzks7p66jw65g6c9x
X-HE-Tag: 1779944996-85182
X-HE-Meta: U2FsdGVkX18FDB4WdM8ex4Zm8G3pEo0LYquL17cqE2cLy5gnHfUbro1PUKEHWBTQi446g1QHhx+vcLMT9LiHz4AdcJAZYC/6j3icVeGzSITr43xKuzVHYWl4XgdGhAi4Uavmm5ebHf9rjhc0ZqmazRebCHmeo/NsUg8hrmIURU2sUfx9vfBR9k267nxaT9V95C1MmZ45fjYWVKAe0s7R5MC0l1kWRMmEjLSsB7oJ/x5TaBlLTNFFoJ1WVlm8LDcqA0U5VGFW1SwzlmF4NLEDgDzBvOHXLbzq80vzrwtOsZIKpLv2LT30sj0pvzAUyBtWRPhxuIkQpZuss0AXh/IdpfkqhlaM7szDSoLy/8tmMhavGN+DB5fR97FCWUs69HSON9fPeZmhOcSFlLaL5qphMkUID51DxGD6y+UdSXdySOGH2Ca+g/+cJw4CS0ETqgFl3kSkrhjm3rccgaIsE7DJBAAxKLaFFmIb6ng5dOt+xUtib35sRO4rxtnSRq4giI6GN0EEwCRx/GM+QCuG3QtmyTN5Nnsax7HlU4+GxOpIMDpkECvbWfG48Ok3vt+1FFs3Qb2aklXx9HvdSxAbvOYFWzpFpIxw+9Z3hz6GmwTynu0gtW9/vIkX6+kvHI41DsXCSd935yK9WBznPVSpfOT+pigcNG9PRlh/phsl33QxX68+dUW0xcspf246KYLgT1ma/F5vXZfZnUaY5I0SuVQ6VcsVU3tRTZG+weIXF6uN1BIGXwW1Xk4jAUuLtBDRnx1/5TS0SProXwUZp0ga09r+ObHWsbEg9OjR6+Pyz8vg8ZA58rnBw2u91u3vpo/ithZi2zSrhEo8Wva4lE3H7K5arvWDCf/jU6AvXlUC53/0kCHj36v0AMlT8ENdTo7W132GahabvAosO2w/DS8dIWAJ7sHhYNQueo9be50roWA5mX1Fipo6WERPsbLy+rrnzPPk9WED8WiaW/zwjSTO6ee
 FHivXiP9
 rZ07774ZZulptpNJHmsqSPDS8GCeuz0l8Q/LLphfG1VAyt6U5Y4AJ2X/SAKLsYEVb1J8n/Gc4AGclWZJhQejpwFLi7CTo6v4TdEgdULt+SRZj+H+O68hVqFoLSgYWRkDLaFDB7h3cdpxtUZPDelE3iUg1rpV4xSHA25prBLfzla+Vi/QbrujOS0yFoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: e7d700e14934e68f86338c5610cf2ae76798b663  Add linux-next specific files for 20260527

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202605280441.YSawqHBc-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202605280456.3Hhpgxl0-lkp@intel.com

    kernel/auditfilter.c:592:15: error: incompatible pointer types assigning to 'struct audit_fsnotify_mark *' from 'int (struct task_struct *)' [-Wincompatible-pointer-types]
    kernel/auditfilter.c:592:17: error: use of undeclared identifier 'audit_alloc_mark'; did you mean 'audit_alloc'?
    kernel/auditfilter.c:592:38: error: 'audit_alloc_mark' undeclared (first use in this function); did you mean 'audit_alloc'?
    kernel/auditfilter.c:592:60: error: too many arguments provided to function-like macro invocation
    kernel/auditfilter.c:592:85: error: macro 'audit_alloc_mark' passed 4 arguments, but takes just 3
    kernel/auditfilter.c:879:10: error: use of undeclared identifier 'audit_dupe_exe'; did you mean 'audit_dupe_rule'?
    kernel/auditfilter.c:879:31: error: 'audit_dupe_exe' undeclared (first use in this function); did you mean 'audit_dupe_rule'?
    kernel/auditfilter.c:879:59: error: macro 'audit_dupe_exe' passed 3 arguments, but takes just 2
    kernel/auditfilter.c:879:8: error: incompatible pointer to integer conversion assigning to 'int' from 'struct audit_entry *(struct audit_krule *, struct audit_watch_ctx *)' [-Wint-conversion]

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202605280927.Yv6FGE1L-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202605281126.3E7Ggbfe-lkp@intel.com

    drivers/pinctrl/renesas/pinctrl-rzt2h.c:197 rzt2h_pinctrl_set_pfc_mode() warn: subtract is higher precedence than shift
    lib/raid/raid6/arm/recov_neon_inner.c:32 __raid6_2data_recov_neon() warn: statement has no effect 'uint8x16_t'
    lib/raid/raid6/arm/recov_neon_inner.c:81 __raid6_datap_recov_neon() warn: statement has no effect 'uint8x16_t'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-003-20260528
|   |-- kernel-auditfilter.c:error:incompatible-pointer-to-integer-conversion-assigning-to-int-from-struct-audit_entry-(struct-audit_krule-struct-audit_watch_ctx-)
|   |-- kernel-auditfilter.c:error:incompatible-pointer-types-assigning-to-struct-audit_fsnotify_mark-from-int-(struct-task_struct-)
|   |-- kernel-auditfilter.c:error:too-many-arguments-provided-to-function-like-macro-invocation
|   |-- kernel-auditfilter.c:error:use-of-undeclared-identifier-audit_alloc_mark
|   `-- kernel-auditfilter.c:error:use-of-undeclared-identifier-audit_dupe_exe
|-- arm64-randconfig-r071-20260528
|   |-- drivers-pinctrl-renesas-pinctrl-rzt2h.c-rzt2h_pinctrl_set_pfc_mode()-warn:subtract-is-higher-precedence-than-shift
|   |-- lib-raid-raid6-arm-recov_neon_inner.c-__raid6_2data_recov_neon()-warn:statement-has-no-effect-uint8x16_t
|   `-- lib-raid-raid6-arm-recov_neon_inner.c-__raid6_datap_recov_neon()-warn:statement-has-no-effect-uint8x16_t
`-- microblaze-defconfig
    |-- kernel-auditfilter.c:error:audit_alloc_mark-undeclared-(first-use-in-this-function)
    |-- kernel-auditfilter.c:error:audit_dupe_exe-undeclared-(first-use-in-this-function)
    |-- kernel-auditfilter.c:error:macro-audit_alloc_mark-passed-arguments-but-takes-just
    `-- kernel-auditfilter.c:error:macro-audit_dupe_exe-passed-arguments-but-takes-just

elapsed time: 762m

configs tested: 165
configs skipped: 6

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260528    gcc-8.5.0
arc                   randconfig-002-20260528    gcc-8.5.0
arc                    vdk_hs38_smp_defconfig    gcc-15.2.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260528    gcc-8.5.0
arm                   randconfig-002-20260528    gcc-8.5.0
arm                   randconfig-003-20260528    clang-23
arm                   randconfig-004-20260528    clang-23
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260528    clang-23
arm64                 randconfig-002-20260528    gcc-15.2.0
arm64                 randconfig-003-20260528    gcc-11.5.0
arm64                 randconfig-004-20260528    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260528    gcc-15.2.0
csky                  randconfig-002-20260528    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260528    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260528    clang-20
i386        buildonly-randconfig-002-20260528    clang-20
i386        buildonly-randconfig-003-20260528    clang-20
i386        buildonly-randconfig-004-20260528    clang-20
i386        buildonly-randconfig-005-20260528    clang-20
i386        buildonly-randconfig-006-20260528    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260528    gcc-14
i386                  randconfig-002-20260528    clang-20
i386                  randconfig-003-20260528    clang-20
i386                  randconfig-004-20260528    gcc-14
i386                  randconfig-005-20260528    clang-20
i386                  randconfig-006-20260528    clang-20
i386                  randconfig-007-20260528    clang-20
i386                  randconfig-011-20260528    gcc-12
i386                  randconfig-012-20260528    gcc-14
i386                  randconfig-013-20260528    gcc-14
i386                  randconfig-014-20260528    gcc-14
i386                  randconfig-015-20260528    clang-20
i386                  randconfig-016-20260528    gcc-14
i386                  randconfig-017-20260528    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-002-20260528    clang-23
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
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260528    gcc-11.5.0
nios2                 randconfig-002-20260528    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260528    gcc-8.5.0
parisc                randconfig-002-20260528    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-002-20260528    gcc-12.5.0
powerpc64             randconfig-001-20260528    gcc-12.5.0
powerpc64             randconfig-002-20260528    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260528    clang-18
riscv                 randconfig-002-20260528    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                  randconfig-001-20260528    clang-23
s390                  randconfig-002-20260528    gcc-12.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260528    gcc-13.4.0
sh                    randconfig-002-20260528    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260528    gcc-11.5.0
sparc                 randconfig-002-20260528    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260528    gcc-8.5.0
sparc64               randconfig-002-20260528    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260528    clang-23
um                    randconfig-002-20260528    gcc-14
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260528    clang-20
x86_64      buildonly-randconfig-002-20260528    clang-20
x86_64      buildonly-randconfig-003-20260528    gcc-14
x86_64      buildonly-randconfig-004-20260528    gcc-14
x86_64      buildonly-randconfig-005-20260528    clang-20
x86_64      buildonly-randconfig-006-20260528    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260528    clang-20
x86_64                randconfig-002-20260528    clang-20
x86_64                randconfig-003-20260528    gcc-14
x86_64                randconfig-004-20260528    gcc-14
x86_64                randconfig-005-20260528    gcc-14
x86_64                randconfig-006-20260528    clang-20
x86_64                randconfig-011-20260528    clang-20
x86_64                randconfig-012-20260528    gcc-14
x86_64                randconfig-013-20260528    clang-20
x86_64                randconfig-014-20260528    clang-20
x86_64                randconfig-015-20260528    clang-20
x86_64                randconfig-016-20260528    gcc-14
x86_64                randconfig-071-20260528    clang-20
x86_64                randconfig-072-20260528    clang-20
x86_64                randconfig-073-20260528    gcc-14
x86_64                randconfig-074-20260528    clang-20
x86_64                randconfig-075-20260528    gcc-14
x86_64                randconfig-076-20260528    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260528    gcc-15.2.0
xtensa                randconfig-002-20260528    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

