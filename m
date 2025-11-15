Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B26CEB2CA
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 08:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937A88E0020; Sat, 15 Nov 2025 03:15:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E87B8E0005; Sat, 15 Nov 2025 03:15:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AFCB8E0020; Sat, 15 Nov 2025 03:15:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6538D8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 03:15:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D851B4D7E0
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 08:15:43 +0000 (UTC)
X-FDA: 84112132566.16.DDB27BB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F2A840012
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 08:15:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WsC9lh83;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763194541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=OIEFz2SXJ6rrJVAHMrYEW0wt2dwLF3WWj5U4yXVTp0A=;
	b=toaELqBrZc/kwkRLRWNQ/VUnIaq5r6XthaCSmSPCeNqAilvtE8HBa881ewGDGOsWuXOTmu
	FFTmGT12G1oYFiQGNFanZsq/as8nzulSgXntx1QVag3mPwjbZx2Gkol1vcxt42GAkqi+ij
	+OWDn/DtJasUlISA1FG2ekXO/+3heF8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WsC9lh83;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763194541; a=rsa-sha256;
	cv=none;
	b=uqIRCmN7cHPdwvChJesSzUEXt28isstjHwicUgNlQmXvCWejGrt2Dt19H9b/DENoGQUQL6
	60Q7v6+0QtWB/mnbJKJTz+5AXENX0XSqru2pmv/OQzRRCAPm6MZkMEPaP0OL7m4bpqz1+A
	QSscSD8O4HNPe9OHCiVGumXyEEDTBzY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763194540; x=1794730540;
  h=date:from:to:cc:subject:message-id;
  bh=H0eZYJCpoSvX0wKbkFvQT3vWUPm2Bz8A/b6z6GlqE8k=;
  b=WsC9lh8391f6XlRNv2R/XV0tsFFrtQIUcH+YMQ+U2nvxUvz6zjfL85tR
   uWZfiUvmdeW+Ss6ZwZT7K9VxUn45n3PStFFstrhOB+VVA7EJvsXRq6bcy
   titDMErVi38ktu0c8fggGOa4dXXAw9GiHO8dkqdu14a9DgFTe6tLOgTco
   DJ2ja6KZuDWMkwmkM73CRlSKjxzOZCLsPGR3S+GrJhiiCUba4dXc98/3E
   RXJVXVa8rKNzG1tC48bwAnu2urN92DhkrFG6bGUbI+LvHWV45khLYE3rz
   O/C+ZhQ9LqCKu/Ols0Ffol39MyFK0cykA76bIOqEPakSGKtfsKIPmfK3U
   A==;
X-CSE-ConnectionGUID: bL1y+gHSRcC+dx/UAuf1jw==
X-CSE-MsgGUID: 7ntaFz6FTviGvwQy+JupTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="76622778"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="76622778"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2025 00:15:38 -0800
X-CSE-ConnectionGUID: 6YVShjMeRsO3SLeWROokIg==
X-CSE-MsgGUID: xGP5se9uQna0q14CISzFbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="189254008"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 15 Nov 2025 00:15:37 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKBRX-0007oN-1P;
	Sat, 15 Nov 2025 08:15:35 +0000
Date: Sat, 15 Nov 2025 16:15:03 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 0f2995693867bfb26197b117cd55624ddc57582f
Message-ID: <202511151652.qJVie0vk-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F2A840012
X-Stat-Signature: bmoar94m8n84yb8gdn3dnd17gzkojm7r
X-Rspam-User: 
X-HE-Tag: 1763194540-980614
X-HE-Meta: U2FsdGVkX1/abL4ojE98/IOl87DPNb1SXKu8qjsYS0tlfwg2t8GR0IvscRKpIVrYJs1Tv1hv/BbK6ULXDAvwbDgbOfAR7JDLHYH+oyUd/FeNF47YJyzaslYVGGTEDv4ADGui9/VX+UexB50RRik9Q+d4IiyC34Digsfc82xCzPeN21dtmRMiqbTNTesly8suPrKGdOCkCOniH2lPVXnMRYMzNlXbHrzmiQIJeLzOMwFZG72Hx7sJktgLuK/oz02KLlHEMvQtDM09u5mJNLnqky/AT+De32Z8o8K2ybcdtwD6w2qkH4A1dIClzDwXu5KPscf8rfni0c4w5OOxORI/L5bKcXiNW1Zdy1KuqxbWAhiQ7NvnKEfebeEOZ5PT1JLEELWvloOQR4iRPzjaMvojThEqnSj7SY/GbRBsZDdkXq/ioFYz9hvkPXOiz1cd1M8RYwb07Z+mtnPTP7dHL5tTO6s+s4LkVMVjoLdXwD5CmFpr54TBAxlntS0ovEqyY5E3+8Ar3ip+8YKRhv7ltEwx8Ut2fYFZ4K1qrPhfhX027iHYjH9f3D23gYE7Suo0DKz4y9/YARl69vBeZ/PlmI1o62dGiBvcKuhaj0udAHh+o+VZGh+xxEHL3pj4oZjoPSA0JCZSdBwOt1ZP/4t7nspFm7FczNqa9v4m70lZM4dz1X/v2NvFA5nIR+IFxCpZ5UjYWQJtacAVXJSWaL9/dQ3fk3m7XGB5tFh44hSB3M4sH/TxqUzMrFFQsMR/zigroyPYO5W/mE+844O4U65Lf/GduGOMyWTk2pJ9Ro68MWYMG4mU+0XS4mxdcGSg9OH5yC0XK1kXKy1GGv/xl3xp8ZmMf9hegLvylb3JJVYLxkCPiUeV5E7KLy13auPbTYJQSEUmb2yuFu/i6Uj5gU1Kz13nrIJwAR1y7kH0Jx8Aa8Ooj2c2//lFvm+Vcs5T1ZTHypLPfQDFz5Qlk8s9Koqp/7d
 DhBsekwu
 SPRZTZlCqGvxBHc58uvyKjxwNZIVQHB4Opm6rOQDps7CU5I7ZjYv8Eynq0JPJF2cz0vs/wha7UTj78BueSpCh77onnhQVXQaQN5wtlAZM+wNS1giaBD9FBll7y3hB2LskvHchL+L+vIu7d7R0ZhsobiYZ0W453gD2VuK4pCA4YN3Yhd4GkG/zs4dh2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 0f2995693867bfb26197b117cd55624ddc57582f  Add linux-next specific files for 20251114

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202511061542.0LO7xKs8-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511062036.Ry8Z2APc-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511150929.3vUi6PEJ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511150837.pTOmpYet-lkp@intel.com

    ERROR: modpost: "__divdi3" [drivers/gpu/drm/xe/xe.ko] undefined!
    ERROR: modpost: "ip_send_check" [net/core/selftests.ko] undefined!
    ERROR: modpost: "udp4_hwcsum" [net/core/selftests.ko] undefined!
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_hw_sequencer.c:1321 This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    Warning: drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_eeprom.c:845 expecting prototype for ras_core_eeprom_append(). Prototype was for ras_eeprom_append() instead
    Warning: drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_eeprom.c:845 function parameter 'ras_core' not described in 'ras_eeprom_append'
    Warning: kernel/nstree.c:391 expecting prototype for ns_tree_gen_id(). Prototype was for __ns_tree_gen_id() instead
    drivers/pinctrl/pinctrl-mpfs-iomux0.c:221: undefined reference to `pinconf_generic_dt_node_to_map'
    include/linux/pinctrl/pinconf-generic.h:235: undefined reference to `pinconf_generic_dt_node_to_map'
    ld: net/core/selftests.c:148:(.text+0x74d): undefined reference to `udp4_hwcsum'
    net/core/selftests.c:104:(.text+0x61b): undefined reference to `ip_send_check'
    pinctrl-mpfs-iomux0.c:(.rodata.cst4+0x4): undefined reference to `pinconf_generic_dt_node_to_map'

Unverified Error/Warning (likely false positive, kindly check if interested):

    ERROR: modpost: "__udivdi3" [drivers/gpu/drm/xe/xe.ko] undefined!
    Warning: drivers/dma/ppc4xx/adma.c:1328 expecting prototype for ppc440spe_adma_device_estimate(). Prototype was for ppc440spe_adma_estimate() instead
    Warning: drivers/dma/ppc4xx/adma.c:1845 expecting prototype for ppc440spe_rxor_set_region_data(). Prototype was for ppc440spe_rxor_set_region() instead
    Warning: drivers/dma/ppc4xx/adma.c:1845 function parameter 'desc' not described in 'ppc440spe_rxor_set_region'
    Warning: drivers/dma/ppc4xx/adma.c:1845 function parameter 'mask' not described in 'ppc440spe_rxor_set_region'
    Warning: drivers/dma/ppc4xx/adma.c:1845 function parameter 'xor_arg_no' not described in 'ppc440spe_rxor_set_region'
    Warning: drivers/dma/ppc4xx/adma.c:3021 expecting prototype for ppc440spe_adma_pq_zero_sum_set_dest(). Prototype was for ppc440spe_adma_pqzero_sum_set_dest() instead
    Warning: drivers/dma/ppc4xx/adma.c:3021 function parameter 'paddr' not described in 'ppc440spe_adma_pqzero_sum_set_dest'
    Warning: drivers/dma/ppc4xx/adma.c:3021 function parameter 'qaddr' not described in 'ppc440spe_adma_pqzero_sum_set_dest'
    Warning: drivers/dma/ppc4xx/adma.c:3021 function parameter 'sw_desc' not described in 'ppc440spe_adma_pqzero_sum_set_dest'
    Warning: drivers/firmware/stratix10-svc.c:58 This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    sound/soc/codecs/cs-amp-lib.c:534 cs_amp_create_debugfs() warn: 'dir' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-defconfig
|   `-- Warning:drivers-firmware-stratix10-svc.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-015-20251114
|   `-- ERROR:__udivdi3-drivers-gpu-drm-xe-xe.ko-undefined
|-- i386-randconfig-061-20251114
|   `-- ERROR:__divdi3-drivers-gpu-drm-xe-xe.ko-undefined
|-- parisc-randconfig-r112-20251114
|   `-- pinctrl-mpfs-iomux0.c:(.rodata.cst4):undefined-reference-to-pinconf_generic_dt_node_to_map
|-- powerpc-randconfig-001-20251115
|   |-- Warning:drivers-dma-ppc4xx-adma.c-expecting-prototype-for-ppc440spe_adma_device_estimate().-Prototype-was-for-ppc440spe_adma_estimate()-instead
|   |-- Warning:drivers-dma-ppc4xx-adma.c-expecting-prototype-for-ppc440spe_adma_pq_zero_sum_set_dest().-Prototype-was-for-ppc440spe_adma_pqzero_sum_set_dest()-instead
|   |-- Warning:drivers-dma-ppc4xx-adma.c-expecting-prototype-for-ppc440spe_rxor_set_region_data().-Prototype-was-for-ppc440spe_rxor_set_region()-instead
|   |-- Warning:drivers-dma-ppc4xx-adma.c-function-parameter-desc-not-described-in-ppc440spe_rxor_set_region
|   |-- Warning:drivers-dma-ppc4xx-adma.c-function-parameter-mask-not-described-in-ppc440spe_rxor_set_region
|   |-- Warning:drivers-dma-ppc4xx-adma.c-function-parameter-paddr-not-described-in-ppc440spe_adma_pqzero_sum_set_dest
|   |-- Warning:drivers-dma-ppc4xx-adma.c-function-parameter-qaddr-not-described-in-ppc440spe_adma_pqzero_sum_set_dest
|   |-- Warning:drivers-dma-ppc4xx-adma.c-function-parameter-sw_desc-not-described-in-ppc440spe_adma_pqzero_sum_set_dest
|   `-- Warning:drivers-dma-ppc4xx-adma.c-function-parameter-xor_arg_no-not-described-in-ppc440spe_rxor_set_region
|-- um-randconfig-r073-20251115
|   `-- sound-soc-codecs-cs-amp-lib.c-cs_amp_create_debugfs()-warn:dir-is-an-error-pointer-or-valid
|-- x86_64-buildonly-randconfig-001-20251115
|   |-- ld:net-core-selftests.c:(.text):undefined-reference-to-udp4_hwcsum
|   `-- net-core-selftests.c:(.text):undefined-reference-to-ip_send_check
|-- x86_64-buildonly-randconfig-005-20251114
|   |-- ERROR:ip_send_check-net-core-selftests.ko-undefined
|   `-- ERROR:udp4_hwcsum-net-core-selftests.ko-undefined
|-- x86_64-kexec
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_hw_sequencer.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-bpf
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_hw_sequencer.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-func
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_hw_sequencer.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-kselftests
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_hw_sequencer.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-kunit
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_hw_sequencer.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-ltp
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_hw_sequencer.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
`-- xtensa-randconfig-001-20251115
    |-- drivers-pinctrl-pinctrl-mpfs-iomux0.c:undefined-reference-to-pinconf_generic_dt_node_to_map
    `-- include-linux-pinctrl-pinconf-generic.h:undefined-reference-to-pinconf_generic_dt_node_to_map

elapsed time: 1554m

configs tested: 124
configs skipped: 8

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251114    gcc-8.5.0
arc                   randconfig-002-20251114    gcc-15.1.0
arc                           tb10x_defconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                                 defconfig    clang-22
arm                   randconfig-001-20251114    gcc-15.1.0
arm                   randconfig-002-20251114    gcc-14.3.0
arm                   randconfig-003-20251114    clang-22
arm                   randconfig-004-20251114    clang-22
arm                           sunxi_defconfig    gcc-15.1.0
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
i386                              allnoconfig    gcc-14
i386        buildonly-randconfig-001-20251114    gcc-14
i386        buildonly-randconfig-002-20251114    clang-20
i386        buildonly-randconfig-003-20251114    clang-20
i386        buildonly-randconfig-004-20251114    gcc-14
i386        buildonly-randconfig-005-20251114    clang-20
i386        buildonly-randconfig-006-20251114    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20251114    clang-20
i386                  randconfig-002-20251114    clang-20
i386                  randconfig-003-20251114    clang-20
i386                  randconfig-004-20251114    gcc-14
i386                  randconfig-005-20251114    gcc-14
i386                  randconfig-006-20251114    clang-20
i386                  randconfig-007-20251114    clang-20
i386                  randconfig-011-20251114    gcc-12
i386                  randconfig-012-20251114    gcc-14
i386                  randconfig-013-20251114    gcc-14
i386                  randconfig-014-20251114    clang-20
i386                  randconfig-015-20251114    gcc-14
i386                  randconfig-016-20251114    gcc-14
i386                  randconfig-017-20251114    gcc-14
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
m68k                              allnoconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                            gpr_defconfig    clang-18
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-002-20251114    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251114    gcc-12.5.0
parisc                randconfig-002-20251114    gcc-11.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                       ebony_defconfig    clang-22
powerpc               randconfig-001-20251114    clang-17
powerpc               randconfig-002-20251114    clang-22
powerpc                 xes_mpc85xx_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20251114    gcc-8.5.0
powerpc64             randconfig-002-20251114    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251114    gcc-13.4.0
riscv                 randconfig-002-20251114    clang-22
s390                              allnoconfig    clang-22
s390                                defconfig    clang-22
s390                  randconfig-001-20251114    gcc-8.5.0
s390                  randconfig-002-20251114    gcc-11.5.0
sh                                allnoconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                            migor_defconfig    gcc-15.1.0
sh                    randconfig-001-20251114    gcc-10.5.0
sh                    randconfig-002-20251114    gcc-15.1.0
sh                           se7206_defconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251114    gcc-14.3.0
sparc                 randconfig-002-20251114    gcc-12.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251114    gcc-8.5.0
sparc64               randconfig-002-20251114    gcc-14.3.0
um                                allnoconfig    clang-22
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251114    gcc-13
um                    randconfig-002-20251114    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64      buildonly-randconfig-001-20251114    clang-20
x86_64      buildonly-randconfig-002-20251114    gcc-14
x86_64      buildonly-randconfig-003-20251114    gcc-14
x86_64      buildonly-randconfig-004-20251114    clang-20
x86_64      buildonly-randconfig-005-20251114    clang-20
x86_64      buildonly-randconfig-006-20251114    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251114    clang-20
x86_64                randconfig-002-20251114    gcc-14
x86_64                randconfig-003-20251114    clang-20
x86_64                randconfig-004-20251114    clang-20
x86_64                randconfig-005-20251114    gcc-12
x86_64                randconfig-006-20251114    gcc-14
x86_64                randconfig-071-20251114    clang-20
x86_64                randconfig-072-20251114    clang-20
x86_64                randconfig-073-20251114    clang-20
x86_64                randconfig-074-20251114    clang-20
x86_64                randconfig-075-20251114    gcc-14
x86_64                randconfig-076-20251114    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251114    gcc-14.3.0
xtensa                randconfig-002-20251114    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

