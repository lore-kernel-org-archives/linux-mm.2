Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D41CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C005A8006D; Mon, 27 Oct 2025 12:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0BE8000A; Mon, 27 Oct 2025 12:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED488006D; Mon, 27 Oct 2025 12:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4088000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:22:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE9F356D5F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:22:42 +0000 (UTC)
X-FDA: 84044412564.02.848137C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf20.hostedemail.com (Postfix) with ESMTP id 127EC1C000F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:22:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xc5ltPZq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761582161; a=rsa-sha256;
	cv=none;
	b=01Wuc6K3fUdAITHobkjjqPiKqsCbl13Hm8j7QNBxj7v70qrefqzgZTSRtG0aVFisuR9lbO
	1SjNsCXW+TXoeOYpTCyhgHMVRoWjQpggIvlzeuY9tpSEyVtePV2lX9Tnu3+mq3saCERV7t
	rTBSol99Vf8BhIX5oLvr2PYLJEryzcg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xc5ltPZq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761582161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=anKSqkCKJBefA9rU1r2HdopTmbChCc2ZWgzt8JCX3X0=;
	b=A89FfkTq7hu+MY82/eFxur41Vc+XZhFSB73gh22qF3nsSmYoEFnHuPDHEHZcPV5FLqq1zR
	IqpDhy8COmTtdd6myCRdPW54tII0/FgqTddXaSuW2tyinFH6Tu/JiHzmT3yPkDu9XLBPzv
	IN3AhBMZ5aLTDThZ8Yie5cJt+aLMd0o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761582160; x=1793118160;
  h=date:from:to:cc:subject:message-id;
  bh=jMiGTm2traNo0jr55VWbFpieZ2KGSRU406hQEKKhpgU=;
  b=Xc5ltPZqXtycGg0l5striorZCCKM1WFJ8+94szQuDXmd+LFWOAYs7M/q
   XDs4Oy29G/gnjKclri54dGUihzLs3sHLgI6Gr6vyz0p7sorEQvDCo15v3
   6358bmJl1xjefTdD1Qi1Y2+mxbOADHeMKpK1mwbLHmnGPJXsf3YT1uzC4
   oSsxcEhvLlG+SOGHf7BmNGtaJVI5f9LezdeXLV5VZWQkNHllHLrYVeNGe
   vACDvp+PmQa5OsqPJcysWp7t8X4VdrImozskBSepuv1rdsFyDez5Ta498
   TolJNVixWVCOqTAgn9k/vdCYc75plNe3iUmnhT55kjvdFV2kiyz7AGAre
   A==;
X-CSE-ConnectionGUID: mWYJyaqPSxqIjtHwKpmcMQ==
X-CSE-MsgGUID: tVbCPcJNS/u2HMt1F/3BiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74342544"
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="74342544"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 09:22:38 -0700
X-CSE-ConnectionGUID: F8p/XsXdTCmd0b2N5eOTDA==
X-CSE-MsgGUID: 945nvGiTQW65QT6/BUE0gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="184978736"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 27 Oct 2025 09:22:38 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vDPzP-000Gyz-01;
	Mon, 27 Oct 2025 16:22:35 +0000
Date: Tue, 28 Oct 2025 00:22:27 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 8fec172c82c2b5f6f8e47ab837c1dc91ee3d1b87
Message-ID: <202510280014.DZSbVkU7-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: qyq43kua5mpdfmy8ckykrxmn8or6udic
X-Rspamd-Queue-Id: 127EC1C000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761582159-919873
X-HE-Meta: U2FsdGVkX19CSjY6LLQ1eWEncIX35GJ7VidSR+M2tSJvErxDVAi8XAue807QQ5S3G/doni9bx8ulT+iWNKqpomZ3cPgBuyErrg2KW4rOSsaGATgadK6SIrgODcyrdOrhW4BpE2G4r/fxiE9J3APYKTy+XxDpc74C5M+9NxATrlGM78ia9U5o8GDuz5Hsbe8XjGYnZ2ikI5naIkPi99JnLY4nfkpu6SQw8PaAFMjCE+rQzsvXzvz/togOFmBpFanXIBLmfrEBqVuYPmWONXSDaPBKlXubohuaFIyIYLRFajz+BKfyxnJ1iD6LBJElNOoR+xk5iSXDMKQiZNIX2c9QarS59EKBjuyPS1IeyNyBYA+nt91xnIkOeQf1BMQa0FX3EsUizBRT1Ec4o48M7n22C2mvKISjmT2VabzzzlF8CKK4Z2uYxJ7Sijl5aEO62XcITkWTkzHIomEZBjdCfRroUl9WRl5OC06B8HpJn1KaJ/FJR6KkEZVue/ug7yYDKEkWAkw8mLrlxEU9r0HAh+bek6N1TePCu5orz468xReqGq9oUfIEB2mOAvZqDsAufQmb99FkC+YUWrxCIF7lNWYOZcYWcGEMhdFh7U/5hxfLJVMCFCIO7HTW9GBciDb8zsmo84Aa63H7esXPEZW3YKHKQUB0zicM2r/PUdBOO4mlj3nOOxQYLSOh0JsQPkEPZotzd9N+MHDt+Sk0iv9/eM98ScFQqDJxUjYTfBuB0ZVqjjHHpCwbRKYCtRBmDws30NV5c+5lx4nvIC5uXB3IK1zZ+56//w8GTI9Vzq5dreXBknsXwNDiI8K2Tsw5xWItTi3O5ueZpK73etcizgt4GOhGcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 8fec172c82c2b5f6f8e47ab837c1dc91ee3d1b87  Add linux-next specific files for 20251027

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202510211913.5a4SfQab-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510230222.gjGA0A40-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510230749.0FuAVuUT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510271906.1346pSIO-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510272037.nf7xzQxk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510210011.tanwPBXz-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510222101.dxkptxL9-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510222308.6LSfjKDk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510241912.s8uQLYlp-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242155.afchO66g-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242250.ZzaqW0pV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242322.aWclvr7e-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510250132.FdNONf4v-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510271426.wQOlaeao-lkp@intel.com

    ERROR: modpost: "__aeabi_uldivmod" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
    ERROR: modpost: "__udivdi3" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
    include/linux/device/devres.h:59:(.text.unlikely+0xa3): undefined reference to `codec_info_list'
    ld: sound/soc/sof/intel/hda.c:1172:(.text.unlikely+0xca): undefined reference to `asoc_sdw_get_codec_info_list_count'
    ld: sound/soc/sof/intel/hda.c:1184:(.text.unlikely+0xf1): undefined reference to `codec_info_list'
    sound/soc/sof/intel/hda.c:1179:(.text.unlikely+0x95): undefined reference to `codec_info_list'

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
    drivers/gpu/drm/xe/xe_pmu.c:517 set_supported_events() error: uninitialized symbol 'gt'.
    drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c:684 stmmac_mdio_register() error: buffer overflow 'new_bus->irq' 32 <= 32
    mm/userfaultfd.c:858 mfill_atomic() warn: inconsistent returns '&ctx->map_changing_lock'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-002-20251027
|   `-- ERROR:__aeabi_uldivmod-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- i386-randconfig-015-20251027
|   |-- include-linux-device-devres.h:(.text.unlikely):undefined-reference-to-codec_info_list
|   |-- ld:sound-soc-sof-intel-hda.c:(.text.unlikely):undefined-reference-to-asoc_sdw_get_codec_info_list_count
|   |-- ld:sound-soc-sof-intel-hda.c:(.text.unlikely):undefined-reference-to-codec_info_list
|   `-- sound-soc-sof-intel-hda.c:(.text.unlikely):undefined-reference-to-codec_info_list
|-- i386-randconfig-141-20251027
|   |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_core.c-ras_core_get_utc_second_timestamp()-error:we-previously-assumed-ras_core-could-be-null-(see-line-)
|   |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_core.c-ras_core_ras_interrupt_detected()-error:we-previously-assumed-ras_core-could-be-null-(see-line-)
|   |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_umc.c-ras_umc_log_pending_bad_bank()-warn:variable-dereferenced-before-check-ecc_node-(see-line-)
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_cs.c-amdgpu_cs_parser_bos()-warn:inconsistent-returns-p-bo_list-bo_list_mutex-.
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_virt.c-amdgpu_virt_init_critical_region()-warn:unsigned-init_hdr_offset-is-never-less-than-zero.
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_connector_group()-error:dereferencing-freed-memory-connector-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_crtc_group()-error:dereferencing-freed-memory-crtc-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_device_group()-error:dereferencing-freed-memory-dev-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_encoder_group()-error:dereferencing-freed-memory-encoder-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_plane_group()-error:dereferencing-freed-memory-plane-(line-)
|   |-- drivers-gpu-drm-xe-xe_pmu.c-set_supported_events()-error:uninitialized-symbol-gt-.
|   `-- mm-userfaultfd.c-mfill_atomic()-warn:inconsistent-returns-ctx-map_changing_lock-.
|-- microblaze-allmodconfig
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- parisc-allmodconfig
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- um-randconfig-001-20251027
|   `-- clang:error:linker-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- um-randconfig-r073-20251025
|   `-- drivers-net-ethernet-stmicro-stmmac-stmmac_mdio.c-stmmac_mdio_register()-error:buffer-overflow-new_bus-irq
`-- x86_64-randconfig-161-20251027
    |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_connector_group()-error:dereferencing-freed-memory-connector-(line-)
    |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_crtc_group()-error:dereferencing-freed-memory-crtc-(line-)
    |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_device_group()-error:dereferencing-freed-memory-dev-(line-)
    |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_encoder_group()-error:dereferencing-freed-memory-encoder-(line-)
    `-- drivers-gpu-drm-vkms-vkms_configfs.c-make_plane_group()-error:dereferencing-freed-memory-plane-(line-)

elapsed time: 728m

configs tested: 139
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251027    gcc-8.5.0
arc                   randconfig-002-20251027    gcc-8.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20251027    clang-22
arm                   randconfig-002-20251027    clang-22
arm                   randconfig-003-20251027    gcc-8.5.0
arm                   randconfig-004-20251027    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251027    clang-22
arm64                 randconfig-002-20251027    gcc-12.5.0
arm64                 randconfig-003-20251027    gcc-9.5.0
arm64                 randconfig-004-20251027    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251027    gcc-14.3.0
csky                  randconfig-002-20251027    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251027    clang-22
hexagon               randconfig-002-20251027    clang-17
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251027    gcc-13
i386        buildonly-randconfig-002-20251027    clang-20
i386        buildonly-randconfig-003-20251027    clang-20
i386        buildonly-randconfig-004-20251027    gcc-14
i386        buildonly-randconfig-005-20251027    clang-20
i386        buildonly-randconfig-006-20251027    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251027    gcc-15.1.0
loongarch             randconfig-002-20251027    gcc-13.4.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                          hp300_defconfig    gcc-15.1.0
m68k                            mac_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                         db1xxx_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251027    gcc-8.5.0
nios2                 randconfig-002-20251027    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251027    gcc-8.5.0
parisc                randconfig-002-20251027    gcc-12.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                      pcm030_defconfig    clang-22
powerpc               randconfig-001-20251027    clang-22
powerpc               randconfig-002-20251027    clang-22
powerpc               randconfig-003-20251027    gcc-8.5.0
powerpc64             randconfig-001-20251027    gcc-8.5.0
powerpc64             randconfig-002-20251027    gcc-10.5.0
powerpc64             randconfig-003-20251027    gcc-10.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251027    gcc-13.4.0
riscv                 randconfig-002-20251027    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251027    clang-22
s390                  randconfig-002-20251027    gcc-8.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                               j2_defconfig    gcc-15.1.0
sh                    randconfig-001-20251027    gcc-12.5.0
sh                    randconfig-002-20251027    gcc-15.1.0
sh                        sh7757lcr_defconfig    gcc-15.1.0
sh                            shmin_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251027    gcc-12.5.0
sparc                 randconfig-002-20251027    gcc-8.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251027    gcc-14.3.0
sparc64               randconfig-002-20251027    gcc-15.1.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251027    clang-22
um                    randconfig-002-20251027    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251027    gcc-14
x86_64      buildonly-randconfig-002-20251027    gcc-14
x86_64      buildonly-randconfig-003-20251027    gcc-14
x86_64      buildonly-randconfig-004-20251027    gcc-14
x86_64      buildonly-randconfig-005-20251027    gcc-14
x86_64      buildonly-randconfig-006-20251027    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251027    gcc-12.5.0
xtensa                randconfig-002-20251027    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

