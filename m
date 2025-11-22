Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 632EFCF64B1
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 08:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8836A6B0008; Sat, 22 Nov 2025 03:42:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85AD46B000E; Sat, 22 Nov 2025 03:42:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770A56B0011; Sat, 22 Nov 2025 03:42:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66C966B0008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 03:42:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E6391A03FF
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:42:53 +0000 (UTC)
X-FDA: 84137602626.08.91B5812
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf19.hostedemail.com (Postfix) with ESMTP id 60E301A0005
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:42:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HkX05+10;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763800971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=eeWM27hham+ls2dXQENqBW5b01CafqP5B9C0OMjeWZo=;
	b=NTmprgPKL3uQis7rFX8/kx8owvOhnuU5QGGDnRVYTIfLVL+7zmOx9pY36vy4wJYyEd8B2a
	twfOO3LKDPpx9iTNTF4UhOfrt+GG1/e+FpYQ2hZFhGD0FAW8NbtlZCAypoBya+1RnTgomq
	WhNjb3U+X19KJsF9BY0TUgPgCWhceHY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HkX05+10;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763800971; a=rsa-sha256;
	cv=none;
	b=D1Fgy+ZKlR8vgzTTHWAmKw9fRmggPwsWbUbD3SPZCGLmYMDLfCaPcSAbK0/hNijeoSnvR8
	+rCX4JlvURrmz9t6OBE59dHasviXFF7Ga3LANUWFIiyfUOivRiyr6UDrDWZDuJ9nW9qCW5
	uT8LbVtEpYjjNlJGiRQzpEkkpmBQDdI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763800970; x=1795336970;
  h=date:from:to:cc:subject:message-id;
  bh=Ez1KYXWXlUNAJufoDcgLxOSLf9COrcSFnSVD5+JHKaI=;
  b=HkX05+10fLFmwIT1CLgZdiwVZBXf77gumAP46iGaxw+vdqqR1hTo7uf5
   Lo/R2bXu6QNoEF1QNWOKvUSi/llmVLjD4udaJsoLfl6XqDC0c78/6FsXA
   wsfhO6e0FBQC7S3aBbU7rn5oHmyqQQH7tBH97vfPTia5Hxf0ritQkfW2i
   I/+UP0FAOBFYtS5UUfqRx2GhFNmpXUjcwSiqH7oPRe72ZVVArIBPCmsBk
   bJS09Cux86Uo9Ci3vGd9r7vLmH3EwjJ9TFawOx2zSYDXeEFi0BUY0QI5e
   pVF/zRH9LjDOUOovOig/KhVgsb2/u0Dp0pD5A71NwzT6x3gehX3FbyTFD
   A==;
X-CSE-ConnectionGUID: HHUaVtVTQ3ONZMPLhI1+sw==
X-CSE-MsgGUID: UDcVQP3vRkScx2WPC6C9ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="77245536"
X-IronPort-AV: E=Sophos;i="6.20,217,1758610800"; 
   d="scan'208";a="77245536"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2025 00:42:49 -0800
X-CSE-ConnectionGUID: +bhOCjTMQFiWAqNNm5t/BQ==
X-CSE-MsgGUID: wPV8MPDJQf+AddpjmfcdTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,217,1758610800"; 
   d="scan'208";a="215248790"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 22 Nov 2025 00:42:47 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vMjCf-0007Ih-1F;
	Sat, 22 Nov 2025 08:42:45 +0000
Date: Sat, 22 Nov 2025 16:42:19 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 d724c6f85e80a23ed46b7ebc6e38b527c09d64f5
Message-ID: <202511221612.a1XoP50V-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 60E301A0005
X-Stat-Signature: 1iocp1yno5n5yytkoryktbbcx5tb4ejx
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763800970-953136
X-HE-Meta: U2FsdGVkX1+Tj4tYpH3atWxNfxUXSOhrcCRKw4wkf5k2g9E4DtNjVjRFJfO8iOpouewlhgwlOMhnMzfVoY88/fsppVDbzWl/GBJFuwahDwHE+VOL61nrpr6Z5n/p/Mu4C81ChPcq8FxyVsNQXRE7iTQoGW63qIqBQMh7/yO6jA44KdNw1Ie5Bm6dMSCdYm1wr/kMx5PcjT3VtgxpMvR3jzLv093tlSCgp0NL+qE+ZNrbMGeMXFHBbi5CILcUJQE1CmSNbRPJpAHKrxyQTXUAsfmYGTYiQynQ1hGfldnXanr+d4j6a3UnITaNxQCV303xD3EO3e+On7MM//lxt/pJ1FCO3iRuOFzarcHzeM2Ff/U/IxdNbynI9Fao9BwYy27tZ7VzvZ7+EMcydI11SUB4E/6GR5EPlZ9SvoVYppnwlx6v5Tq00Ggjutb0sUAWNLRt3tnt+idzLNEkj9a6iX/7HtnvJ5/hCUFBwSg+XLtiIDb4/RmxMvHGB+42EWksFxrOBoxG3FekAq3H5AbWUNbbw+bI/3so7VrtWanEMwaFTdYaE90BJqzW5jzi3HkdzCgfMASc+ftOcelJdw6+fozUibRkjVHK9V8Bb8+zPivAnM1z75yd73r9ZjDL1Fh5wIxGLPSv43l+Hc3z4vOCIhPpDOyfO0qp59C+sMTPPPECBROdaDVmHGOQNpR5dn0NPrlNEJaDnIydfODdz1ZtA49SB4a55m2V3brsI04FLsFtSCstRnU+WvoUO/ZslBo87ntIOD1Kpp1PtM55K4XpSvFbd041I0C346/INR0NU6OrwtgyWszneK8gVF9fw5MH9lkzC/sTGBBslLZA+0Xfuh45x9ehAD/Mh048Vu/gRpHXL8yUgNbxg3FQq6mFVS4PojMoLWofPElA4ADgS9evDgi+/hO44u2JpH4n3sM31EJxygsj/qVD5OPIDQZR37mn+K59TekO3gFtOW9eh5XUiHU
 I//W5Kul
 XF6iWKDW+y0hRKQBSKJ2jTBert4VdRLuTVQniTBnDZQHIgBUKeCB3sx/1qkqxDnU6EqCY+GThzgaJ33Ai9t+1IvqKVdOkEE44zpsgsXxbEKDr2Heul9fJUHtxQEZ0KXWKJV3nsvE0jFeCkfbERwAD39vFacB9gTBDT8gPaAxjylIPe0uDGS73pN+4hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: d724c6f85e80a23ed46b7ebc6e38b527c09d64f5  Add linux-next specific files for 20251121

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202511062036.Ry8Z2APc-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511212208.JsHl71jh-lkp@intel.com

    (.text+0x1e8): undefined reference to `ip_send_check'
    WARNING: modpost: vmlinux: section mismatch in reference: qcom_cpufreq_ipq8064_name_version+0x1fa (section: .text) -> qcom_cpufreq_ipq806x_match_list (section: .init.rodata)
    Warning: drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_eeprom.c:845 expecting prototype for ras_core_eeprom_append(). Prototype was for ras_eeprom_append() instead
    Warning: drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_eeprom.c:845 function parameter 'ras_core' not described in 'ras_eeprom_append'
    hppa-linux-ld: (.text+0x39c): undefined reference to `udp4_hwcsum'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- parisc-randconfig-001-20251121
|   |-- (.text):undefined-reference-to-ip_send_check
|   `-- hppa-linux-ld:(.text):undefined-reference-to-udp4_hwcsum
|-- powerpc64-randconfig-001-20251121
|   `-- WARNING:modpost:vmlinux:section-mismatch-in-reference:qcom_cpufreq_ipq8064_name_version-(section:.text)-qcom_cpufreq_ipq806x_match_list-(section:.init.rodata)
|-- x86_64-rhel-9.4
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|-- x86_64-rhel-9.4-func
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
`-- x86_64-rhel-9.4-kselftests
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
    `-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append

elapsed time: 1576m

configs tested: 137
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251121    gcc-8.5.0
arc                   randconfig-002-20251121    gcc-13.4.0
arm                               allnoconfig    clang-22
arm                                 defconfig    clang-22
arm                   randconfig-001-20251121    gcc-10.5.0
arm                   randconfig-002-20251121    gcc-11.5.0
arm                   randconfig-003-20251121    clang-22
arm                   randconfig-004-20251121    gcc-10.5.0
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251121    gcc-8.5.0
arm64                 randconfig-002-20251121    clang-22
arm64                 randconfig-003-20251121    gcc-8.5.0
arm64                 randconfig-004-20251121    gcc-10.5.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251121    gcc-14.3.0
csky                  randconfig-002-20251121    gcc-11.5.0
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251121    clang-22
hexagon               randconfig-002-20251121    clang-22
i386                              allnoconfig    gcc-14
i386        buildonly-randconfig-001-20251121    gcc-14
i386        buildonly-randconfig-002-20251121    gcc-14
i386        buildonly-randconfig-003-20251121    clang-20
i386        buildonly-randconfig-004-20251121    clang-20
i386        buildonly-randconfig-005-20251121    clang-20
i386        buildonly-randconfig-006-20251121    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20251121    gcc-14
i386                  randconfig-002-20251121    clang-20
i386                  randconfig-003-20251121    gcc-14
i386                  randconfig-004-20251121    clang-20
i386                  randconfig-005-20251121    clang-20
i386                  randconfig-006-20251121    gcc-14
i386                  randconfig-007-20251121    gcc-14
i386                  randconfig-011-20251121    clang-20
i386                  randconfig-012-20251121    clang-20
i386                  randconfig-013-20251121    clang-20
i386                  randconfig-014-20251121    clang-20
i386                  randconfig-015-20251121    clang-20
i386                  randconfig-016-20251121    gcc-14
i386                  randconfig-017-20251121    gcc-14
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251121    gcc-15.1.0
loongarch             randconfig-002-20251121    clang-22
m68k                              allnoconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       alldefconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                      bmips_stb_defconfig    clang-22
mips                        omega2p_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251121    gcc-11.5.0
nios2                 randconfig-002-20251121    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251121    gcc-12.5.0
parisc                randconfig-002-20251121    gcc-12.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                 canyonlands_defconfig    clang-22
powerpc                     mpc5200_defconfig    clang-22
powerpc               randconfig-001-20251121    clang-18
powerpc               randconfig-002-20251121    gcc-11.5.0
powerpc64             randconfig-001-20251121    gcc-8.5.0
riscv                             allnoconfig    gcc-15.1.0
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251121    gcc-14.3.0
s390                              allnoconfig    clang-22
s390                                defconfig    clang-22
s390                  randconfig-001-20251121    gcc-13.4.0
s390                  randconfig-002-20251121    clang-19
sh                                allnoconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                        edosk7705_defconfig    gcc-15.1.0
sh                          r7785rp_defconfig    gcc-15.1.0
sh                    randconfig-001-20251121    gcc-10.5.0
sh                    randconfig-002-20251121    gcc-11.5.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251121    gcc-13.4.0
sparc                 randconfig-002-20251121    gcc-8.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251121    clang-22
sparc64               randconfig-002-20251121    clang-22
um                                allnoconfig    clang-22
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251121    clang-22
um                    randconfig-002-20251121    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64      buildonly-randconfig-001-20251121    gcc-14
x86_64      buildonly-randconfig-002-20251121    gcc-14
x86_64      buildonly-randconfig-003-20251121    gcc-14
x86_64      buildonly-randconfig-004-20251121    clang-20
x86_64      buildonly-randconfig-005-20251121    gcc-14
x86_64      buildonly-randconfig-006-20251121    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251121    gcc-14
x86_64                randconfig-002-20251121    clang-20
x86_64                randconfig-003-20251121    clang-20
x86_64                randconfig-004-20251121    gcc-14
x86_64                randconfig-005-20251121    clang-20
x86_64                randconfig-006-20251121    gcc-13
x86_64                randconfig-011-20251121    clang-20
x86_64                randconfig-012-20251121    gcc-14
x86_64                randconfig-013-20251121    gcc-14
x86_64                randconfig-014-20251121    gcc-14
x86_64                randconfig-015-20251121    gcc-14
x86_64                randconfig-016-20251121    gcc-14
x86_64                randconfig-071-20251121    gcc-14
x86_64                randconfig-072-20251121    gcc-14
x86_64                randconfig-073-20251121    gcc-12
x86_64                randconfig-074-20251121    clang-20
x86_64                randconfig-075-20251121    gcc-14
x86_64                randconfig-076-20251121    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
xtensa                            allnoconfig    gcc-15.1.0
xtensa                generic_kc705_defconfig    gcc-15.1.0
xtensa                randconfig-001-20251121    gcc-11.5.0
xtensa                randconfig-002-20251121    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

