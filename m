Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C22BCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 23:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94EDC8E019C; Tue, 28 Oct 2025 19:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9259D8E0015; Tue, 28 Oct 2025 19:04:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BDB8E019C; Tue, 28 Oct 2025 19:04:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3208E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:04:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D3ED88C31
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:04:41 +0000 (UTC)
X-FDA: 84049054362.06.EF16387
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2FA2E10000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:04:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="T/3nFruu";
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761692679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=XHB8IYa4TPQlxAqO8lOFazz7Llea/QnBOPGuYHDj+K4=;
	b=saJrENq90Eeq6fABr0aFNKJd1vmbGQMi0P2FSr8J2cjURNZKd1rDSOx5DvxcLW7tA55VJ/
	eyVqW6evWVMjIw2cEsU2GFL3v+AqpW7hpgNOxSuCik0Qf45GRXgLekPnoz6TmScKJgQSbd
	HqS2xh1BZwU4eNa3XOcbr55K8j6IDpc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="T/3nFruu";
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761692679; a=rsa-sha256;
	cv=none;
	b=3XAeVIeyIABNu2u53Cy/0/2sOs9oVtotDEJKMI39FxJi3S8bc5eBhc180oGf5Dr90s5peN
	KP1WjS8MGKn7DEKMn1ueT4dClAU45IqCQ1AJUG3/mkHiuha4tQY5iK1fb999NpLlBBtcGm
	Husoi8BBcU4BSFW92yQZeAAwX0Lwoq0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761692679; x=1793228679;
  h=date:from:to:cc:subject:message-id;
  bh=2mExawIdvPThfNGzdlugA77ZD8cny4vwz73N1zDohVo=;
  b=T/3nFruuDqccToJmH6atNSCfXxZVd9fS7LIXyaZFPoOrUYG4yaBCSj0W
   ku8RDrpKRn06x3jqwtBHasEotLBo5ctGzs/t4eXdcufPLEwvjqla69fn8
   HmEiR1VEot8KOOTbTpQ81Ld4gsBthNz1zrq5gT2aPvJP6JptjUMuI6ojN
   +rrMWlUX1UDE1z26J3FC5d6muZBgz1geJTya04A5GR2OAYlqEssvqSXof
   D+eEl46HKJA92yJCbfbCaUq2dXH0AlzNF3nIXc61t0CX4iukHVTdkITuK
   dkMC4oYELAbPz9cioaNZ1L963PCsGqEV9ddwGLRrrTf45RtIay3rImo9W
   g==;
X-CSE-ConnectionGUID: REHs0/R0Q0+r+DA1523jGA==
X-CSE-MsgGUID: fHIJGQ6+TQaY5rJGN5fQEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74096392"
X-IronPort-AV: E=Sophos;i="6.19,262,1754982000"; 
   d="scan'208";a="74096392"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 16:04:37 -0700
X-CSE-ConnectionGUID: 1xh8494sQZaSzWdwQtnjrg==
X-CSE-MsgGUID: JTIa6O7JTVKD4y5b+iAjSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,262,1754982000"; 
   d="scan'208";a="186237155"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 28 Oct 2025 16:04:36 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vDsjx-000JrH-1c;
	Tue, 28 Oct 2025 23:04:33 +0000
Date: Wed, 29 Oct 2025 07:03:16 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 f7d2388eeec24966fc4d5cf32d706f0514f29ac5
Message-ID: <202510290707.Ujf1kmIe-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: tjnmcfbymosrmndpq3h6o8ma1dw8m14j
X-Rspamd-Queue-Id: 2FA2E10000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761692677-859178
X-HE-Meta: U2FsdGVkX1/1p6u9X+e0C11WMDiyEfM4GNpsuC3sAxGuXPz4DqfyJFfcHMQtLKWxwDs6sUNeT+k2TnGphoeM4lv4+61pAcXbSEdWBcaStaVsqbLB2BH9MrOp1PNnS24eu2vBxqWNpddpoCle/Zz1kcjae6cS4p2M5cJh6d0Ye1P/hiw55/QtaNfkVCkAfVJZHVe5o0PZ88uOsxFqTF1J+k8nyX2QiYC7ADBIkqhiyiBtrrEI63UNC629JaNMIX75udJduTad0nqj322z0RTMQiqi6Snn4b3tFl2DWqmEcOEwQbaIE+EevKIPRMA0wH3vXO1IruvWK95/K7Ysgrk/s67r036VX+L60c6MwuFaWepQx3t+wAUtB9EWRJhiLRsL6q1bjlSRvB1+W0istvmCUvnCX6KzKdtquDemL1NEWiIgYwmPb12KFjmQsjNw51Z6GYuaRX35E0a4XQ6fIJhtQlgLeTFAKkZAGIjXU9A90wMeZkF4td7lAQ9/4YbuXq8yecbCKoN3m+QGz8vv9MenjGm1af40H/llOIdMM6q6LEr9q6z6ALQFE/6ujWQkSvXEiTmV7Wj0nHi9txIcBT+17PHG+cJIlcpTLg03QTSCJtMLK+N/JK72MC0S8cxA3iB19X5BPbw0d+QgBC/DrRZRLG97DZdHBDLG6m4grDzOo6m7bpQDVzZQyEsOD/RwSE+p10Xv064FYzE+Pb2TXyfwzGOrnJf6sfNoRd0MATkpXen/TOfAq5x867DYWCYqrg2Kl8t9FJ9LQ0OQ5GqU8iI1PZwS94zqq07mC1+YrYcrMsjcNjq/04RgCzB3YJSmKYyVT6ojvahTn6sogStkQpG78SZeNSBm7f0kxmtxCBK4XajYlxbRy9kw1JsKqWF2acyV15JaQs2rsSnlVlF0UkHTVwkb9WRW48fEBa5+ljW6F//B/BpMylsGM0srV9zdFla2RxogiJOddoz/2+kgUY3
 nyPsswtv
 HHTLYyWGjmQAir1UbsZ2DMkAqF0kPsWTCgwRX1+zC7HB0Yf+LmnaC4c3UfPmu3cE2rGyfxVKKE4dBVamNym6Gps07cUtrxvvS6Cde5w02giy9mT2jgtLzkuE4nB0Pm5fc25fBi7Yc3uGigvWgwjrUiYhoYxN9plmRsfq78TW/lGqGHc9n9sMuMfU7aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: f7d2388eeec24966fc4d5cf32d706f0514f29ac5  Add linux-next specific files for 20251028

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202510211913.5a4SfQab-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510230222.gjGA0A40-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510280634.g0xVebXG-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510282030.nzq0BTFH-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510282206.wI0HrqcK-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510282238.oRKSLKUV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510290348.IpSNHCxr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510222101.dxkptxL9-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510222308.6LSfjKDk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510241912.s8uQLYlp-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242155.afchO66g-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242250.ZzaqW0pV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242322.aWclvr7e-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510250132.FdNONf4v-lkp@intel.com

    ERROR: modpost: "__udivdi3" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
    Warning: drivers/gpio/gpio-mm-lantiq.c:90 function parameter 'chip' not described in 'ltq_mm_save_regs'
    arch/sh/include/cpu-sh3/cpu/dac.h:21:13: error: implicit declaration of function '__raw_readb' [-Wimplicit-function-declaration]
    arch/sh/include/cpu-sh3/cpu/dac.h:24:9: error: implicit declaration of function '__raw_writeb'; did you mean '__raw_write_lock'? [-Wimplicit-function-declaration]
    drivers/acpi/x86/s2idle.c:165:51: warning: '%s' directive argument is null [-Wformat-overflow=]
    net/core/dev.c:13302:31: warning: '__find_trim' defined but not used [-Wunused-function]

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_core.c:512 ras_core_get_utc_second_timestamp() error: we previously assumed 'ras_core' could be null (see line 508)
    drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_core.c:531 ras_core_ras_interrupt_detected() error: we previously assumed 'ras_core' could be null (see line 527)
    drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_umc.c:210 ras_umc_log_pending_bad_bank() warn: variable dereferenced before check 'ecc_node' (see line 208)
    drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c:1002 amdgpu_cs_parser_bos() warn: inconsistent returns '&p->bo_list->bo_list_mutex'.
    drivers/gpu/drm/vkms/vkms_configfs.c:223 make_crtc_group() error: dereferencing freed memory 'crtc' (line 222)
    drivers/gpu/drm/vkms/vkms_configfs.c:377 make_plane_group() error: dereferencing freed memory 'plane' (line 376)
    drivers/gpu/drm/vkms/vkms_configfs.c:491 make_encoder_group() error: dereferencing freed memory 'encoder' (line 490)
    drivers/gpu/drm/vkms/vkms_configfs.c:656 make_connector_group() error: dereferencing freed memory 'connector' (line 655)
    drivers/gpu/drm/vkms/vkms_configfs.c:770 make_device_group() error: dereferencing freed memory 'dev' (line 769)
    mm/userfaultfd.c:858 mfill_atomic() warn: inconsistent returns '&ctx->map_changing_lock'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-004-20251028
|   `-- net-core-dev.c:warning:__find_trim-defined-but-not-used
|-- mips-xway_defconfig
|   `-- Warning:drivers-gpio-gpio-mm-lantiq.c-function-parameter-chip-not-described-in-ltq_mm_save_regs
|-- openrisc-allmodconfig
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- parisc-allmodconfig
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- riscv-randconfig-r131-20251028
|   `-- drivers-pmdomain-mediatek-mtk-mfg-pmdomain.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le64-assigned-usertype-base-got-unsigned-long-long-usertype-shared_
|-- sh-randconfig-r072-20251028
|   |-- arch-sh-include-cpu-sh3-cpu-dac.h:error:implicit-declaration-of-function-__raw_readb
|   `-- arch-sh-include-cpu-sh3-cpu-dac.h:error:implicit-declaration-of-function-__raw_writeb
|-- x86_64-randconfig-007-20250922
|   `-- drivers-acpi-x86-s2idle.c:warning:s-directive-argument-is-null
`-- x86_64-randconfig-161-20251028
    |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_core.c-ras_core_get_utc_second_timestamp()-error:we-previously-assumed-ras_core-could-be-null-(see-line-)
    |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_core.c-ras_core_ras_interrupt_detected()-error:we-previously-assumed-ras_core-could-be-null-(see-line-)
    |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_umc.c-ras_umc_log_pending_bad_bank()-warn:variable-dereferenced-before-check-ecc_node-(see-line-)
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_cs.c-amdgpu_cs_parser_bos()-warn:inconsistent-returns-p-bo_list-bo_list_mutex-.
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_virt.c-amdgpu_virt_init_critical_region()-warn:unsigned-init_hdr_offset-is-never-less-than-zero.
    |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_connector_group()-error:dereferencing-freed-memory-connector-(line-)
    |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_crtc_group()-error:dereferencing-freed-memory-crtc-(line-)
    |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_device_group()-error:dereferencing-freed-memory-dev-(line-)
    |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_encoder_group()-error:dereferencing-freed-memory-encoder-(line-)
    |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_plane_group()-error:dereferencing-freed-memory-plane-(line-)
    `-- mm-userfaultfd.c-mfill_atomic()-warn:inconsistent-returns-ctx-map_changing_lock-.

elapsed time: 1078m

configs tested: 102
configs skipped: 5

tested configs:
alpha                   allnoconfig    gcc-15.1.0
alpha                  allyesconfig    gcc-15.1.0
alpha                     defconfig    gcc-15.1.0
arc                    allmodconfig    gcc-15.1.0
arc                     allnoconfig    gcc-15.1.0
arc                    allyesconfig    gcc-15.1.0
arc                       defconfig    gcc-15.1.0
arc         randconfig-001-20251028    gcc-8.5.0
arc         randconfig-002-20251028    gcc-13.4.0
arm                    allmodconfig    gcc-15.1.0
arm                     allnoconfig    clang-22
arm                    allyesconfig    gcc-15.1.0
arm                       defconfig    clang-22
arm             netwinder_defconfig    gcc-15.1.0
arm         randconfig-001-20251028    clang-22
arm         randconfig-002-20251028    clang-22
arm         randconfig-003-20251028    clang-22
arm         randconfig-004-20251028    gcc-8.5.0
arm               s3c6400_defconfig    gcc-15.1.0
arm              vexpress_defconfig    gcc-15.1.0
arm64                  allmodconfig    clang-19
arm64                   allnoconfig    gcc-15.1.0
arm64                  allyesconfig    clang-22
arm64                     defconfig    gcc-15.1.0
csky                   allmodconfig    gcc-15.1.0
csky                    allnoconfig    gcc-15.1.0
csky                   allyesconfig    gcc-15.1.0
csky                      defconfig    gcc-15.1.0
hexagon                allmodconfig    clang-17
hexagon                 allnoconfig    clang-22
hexagon                allyesconfig    clang-22
hexagon                   defconfig    clang-22
i386                   allmodconfig    gcc-14
i386                    allnoconfig    gcc-14
i386                   allyesconfig    gcc-14
i386                      defconfig    clang-20
i386        randconfig-011-20251028    gcc-14
i386        randconfig-012-20251028    clang-20
i386        randconfig-013-20251028    clang-20
i386        randconfig-014-20251028    clang-20
i386        randconfig-015-20251028    clang-20
i386        randconfig-016-20251028    gcc-14
i386        randconfig-017-20251028    gcc-14
loongarch              allmodconfig    clang-19
loongarch               allnoconfig    clang-22
loongarch              allyesconfig    clang-22
m68k                   allmodconfig    gcc-15.1.0
m68k                    allnoconfig    gcc-15.1.0
m68k                   allyesconfig    gcc-15.1.0
microblaze             allmodconfig    gcc-15.1.0
microblaze              allnoconfig    gcc-15.1.0
microblaze             allyesconfig    gcc-15.1.0
mips                   allmodconfig    gcc-15.1.0
mips                    allnoconfig    gcc-15.1.0
mips                   allyesconfig    gcc-15.1.0
nios2                  allmodconfig    gcc-11.5.0
nios2                   allnoconfig    gcc-11.5.0
nios2                  allyesconfig    gcc-11.5.0
openrisc               allmodconfig    gcc-15.1.0
openrisc                allnoconfig    gcc-15.1.0
openrisc               allyesconfig    gcc-15.1.0
openrisc                  defconfig    gcc-15.1.0
parisc                 allmodconfig    gcc-15.1.0
parisc                  allnoconfig    gcc-15.1.0
parisc                 allyesconfig    gcc-15.1.0
parisc                    defconfig    gcc-15.1.0
powerpc                allmodconfig    gcc-15.1.0
powerpc                 allnoconfig    gcc-15.1.0
powerpc                allyesconfig    clang-22
powerpc       mpc8313_rdb_defconfig    gcc-15.1.0
riscv                  allmodconfig    clang-22
riscv                   allnoconfig    gcc-15.1.0
riscv                  allyesconfig    clang-16
riscv                     defconfig    clang-22
s390                   allmodconfig    clang-18
s390                    allnoconfig    clang-22
s390                   allyesconfig    gcc-15.1.0
s390                      defconfig    clang-22
sh                     allmodconfig    gcc-15.1.0
sh                      allnoconfig    gcc-15.1.0
sh                     allyesconfig    gcc-15.1.0
sh                        defconfig    gcc-15.1.0
sh                  titan_defconfig    gcc-15.1.0
sparc                  allmodconfig    gcc-15.1.0
sparc                   allnoconfig    gcc-15.1.0
sparc                  allyesconfig    gcc-15.1.0
sparc                     defconfig    gcc-15.1.0
sparc64                allmodconfig    clang-22
sparc64                allyesconfig    gcc-15.1.0
sparc64                   defconfig    clang-20
um                     allmodconfig    clang-19
um                      allnoconfig    clang-22
um                     allyesconfig    gcc-14
um                        defconfig    clang-22
um                   i386_defconfig    gcc-14
um                 x86_64_defconfig    clang-22
x86_64                 allmodconfig    clang-20
x86_64                  allnoconfig    clang-20
x86_64                 allyesconfig    clang-20
x86_64                    defconfig    gcc-14
x86_64                rhel-9.4-rust    clang-20
xtensa                  allnoconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

