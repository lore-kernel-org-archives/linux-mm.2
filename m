Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D3CCCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 23:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB35C8E0006; Thu,  6 Nov 2025 18:14:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D646F8E0002; Thu,  6 Nov 2025 18:14:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A318E0006; Thu,  6 Nov 2025 18:14:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4F098E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 18:14:31 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E8451A02CB
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 23:14:31 +0000 (UTC)
X-FDA: 84081738342.16.BEC32BC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7AA54A0006
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 23:14:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AlLmCn+k;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762470869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=P4c3TRL0SDM35e7bIbd88cwB1NH6k6veF0yPRQHVaWU=;
	b=gUjW23mRdHM2XielMHY+IL2j1DPFxLqmnL2q7Suqr8jx+vyI85HdNFVjaUFuECJ9YH5JTa
	VL1QYWXe3zrzMlDGMOm+omTDNaVJC6NhPu/1vsuc4gaW+tQDQBNtJW5EC8wFJIWNc/8oH3
	TSBn/9KCgbD0+tKTjufcR09OWXIvIxc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AlLmCn+k;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762470869; a=rsa-sha256;
	cv=none;
	b=7Hi2Nw1dgb2vzir9Fqd4kFb8w15eApb+ofCHj0aX7AsqrrbgSUyrAncgOMFkt/wLBninuR
	Vym05o9LtSVO3iOtBqhSKR770DDLAEeEZhnTf+13CWgg2YW6G1MRkNXt0f6c0+H47k0YL0
	KpQO78EasaqcgnoCKeD/iz7Vw70cu+M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762470869; x=1794006869;
  h=date:from:to:cc:subject:message-id;
  bh=TcHnuG849rs8otYF7ke+9P8jsbDwEtWTNVRGdMZy1Ts=;
  b=AlLmCn+kMdSeF3g65Aq7CTrTpBHAQl7ypmySc9IOIq9fzoaLSQyzjVoq
   MIFhnbGDW4IqcA+ILrSZd+x2lOmSgtsFm3AI+pXMLLx3gYBbtnWFL2HTv
   QZbpD6DgBZolMIxuBcNPd7QzoNSkbAmFUTPV96zOrCJBSwZsiGito89WS
   V7KLKRl6buTvh+zuXCFclmH0xh36NH9gNKW383n5gw3Oupg9DCRmuVuv3
   r+T7LttCrXQG0fTFUoHDYmUru7mRSOT/g50ZK2iM8trQKKzRIGIs61VOP
   O+Nqv9gDW5tmDAJxMdefRhn40uUJwDT4ESW2kHep8SuXydlGDcnZWrgrm
   A==;
X-CSE-ConnectionGUID: NVAETX7nTOSKZTtEkSZZkA==
X-CSE-MsgGUID: rFOu3LzJSHaipzcttYzgzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="64536827"
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="64536827"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 15:14:27 -0800
X-CSE-ConnectionGUID: 2iWkP4zmT+6lcQyLMbnklA==
X-CSE-MsgGUID: ey8LNFJLS7mmmpFTv44G2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="188050388"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 06 Nov 2025 15:14:26 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vH9BP-000URM-10;
	Thu, 06 Nov 2025 23:14:23 +0000
Date: Fri, 07 Nov 2025 07:14:18 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 df5d79720b152e7ff058f11ed7e88d5b5c8d2a0c
Message-ID: <202511070700.yqRgcVLD-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7AA54A0006
X-Stat-Signature: y7868u3ayr463bumu7idrsuai9wmi617
X-Rspam-User: 
X-HE-Tag: 1762470868-757140
X-HE-Meta: U2FsdGVkX1+8Sc4GhomOSU4hNQy+3qgwkrtjUgV1GFSPpps6qKXLhPAp+/hD8twh3tyhMp3PZADeAGMhi6GdfSMf0VJ0qTZ8UdpK/V/4JoI0r8XWXubmLGeOf9mnalIuGvXCnFvxjjUiLzug5gpk196oG1N5tGeg35RFDLsUp7sKHk3zNeqWWJfts1Dj6v5FopW8DHN0zl4/CzhFLHvJNQs1yA5YNtbc7ymDS3WZPoJV/fZwA5z4H9MBM0OtVWlGc7VgSKv5nw5kgP/dYnAeH8Bi/ygk/3FZbp4UBEjvPOi5wlwjzHOObOxCGsGo+hVrbqfCtgIj0cKiZaJg+J8MVpG9ryS9LxOjfxGJMSczafD1vTyrYYb2AauUoHIjZwEdlTrmNdSUEnC1olD88TrV+ytcdDlwVvAqueekvgUIq6sT0ETDq/bGfgU6Br7ROXXe97/XRrhPgZDoupaLVP3QNGv9ev93vIAdUDVJdWGHHYMUj67uRxqZUHHOSkfuA4ETc00oYRna12c4vvDrcn52nWlM5m/1vEU+9LQq4XMBQVWq6x4AG34NXu6G56d6qYhP6/Jyq8pK3Bf9UZlT7WJ6zSI2uBm+mKs56DdIYHQnoKpN68bA2Z/8ms2n0omqsxq/D9Du7js37FZuJ+S4yYOPZusdFCW8yB6MGvvNaRITDCqENlTuqcKxRyalHn2fk/m6vU5M26JPbbTMA1QQKzapGON08nbT8hpnM1l2rpqNsOC+zF+3V7XUdoWqosvls/T+iIQfb/P7JT+pEBoKKFb/W8FBslABZ2vtOkLhnspaYKQa01Xc6fFVww2lfgP7KAZ3N79bt0TAFKs78Ei5nY4mlK0BcmtraOj4A6U7O9F62bZXNbv2CTgMGI0IlwpV8wQVSW82if9mMfVwzba9lm7UM7UehswpU8G/RhzKLMQVNSig+DgN23bUahCyQnV9J3GeVjGRwCyp9d37PegaOrz
 4Pm0Ixky
 lj9G1V1Oji4T2Sip4ppy+39YWRnTB0/sTEDUNU3/yRkuPmMDfZsymoWffLEiLX1GwWECmsHxGrvNvymHbfpJCDiSiGxF6c53/ViJh/7R+KOBDNtXw6XAq2qIB6VISvYlzGJyzO2WwCrf0dQ8ijRxsFuTPUiYNnLzo2J6xTigrkrwUbySA/L5oEHlSew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: df5d79720b152e7ff058f11ed7e88d5b5c8d2a0c  Add linux-next specific files for 20251106

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202510291905.CNy7FYI0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510292307.DmOaSI39-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510300152.UG9LOpTY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511061542.0LO7xKs8-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511061613.whODAEJk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511061736.CiuroL7H-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511061746.dPegBnNf-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511062036.Ry8Z2APc-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511062050.2oBQXuua-lkp@intel.com

    Warning: arch/arm/mm/dma-mapping.c:1405 expecting prototype for arm_iommu_unmap_page(). Prototype was for arm_iommu_unmap_phys() instead
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7309 function parameter 'connector' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7309 function parameter 'force' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_hw_sequencer.c:1318 This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_hw_sequencer.c:1321 This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1355 function parameter 'link' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1355 function parameter 'type' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:872 function parameter 'edid_header' not described in 'link_detect_evaluate_edid_header'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:890 function parameter 'link' not described in 'link_detect_ddc_probe'
    Warning: drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_eeprom.c:845 expecting prototype for ras_core_eeprom_append(). Prototype was for ras_eeprom_append() instead
    Warning: drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_eeprom.c:845 function parameter 'ras_core' not described in 'ras_eeprom_append'
    Warning: drivers/gpu/drm/drm_vblank.c:2267 expecting prototype for drm_crtc_vblank_start_timer(). Prototype was for drm_crtc_vblank_cancel_timer() instead
    Warning: drivers/gpu/drm/xe/xe_pm.c:131 expecting prototype for xe_pm_might_block_on_suspend(). Prototype was for xe_pm_block_on_suspend() instead
    Warning: drivers/pmdomain/mediatek/mtk-mfg-pmdomain.c:244 struct __packed mtk_mfg_opp_entry { __le32 freq_khz; __le32 voltage_core; __le32 voltage_sram; __le32 posdiv; __le32 voltage_margin; __le32 power_mw; }; error: Cannot parse struct or union!
    Warning: kernel/nstree.c:353 expecting prototype for ns_tree_gen_id(). Prototype was for __ns_tree_gen_id() instead
    Warning: security/smack/smack_access.c:583 expecting prototype for smk_import_valid_allocated_label(). Prototype was for smk_import_allocated_label() instead
    Warning: security/smack/smack_access.c:583 function parameter 'gfp' not described in 'smk_import_allocated_label'
    drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_stream_encoder.c:1571:69: error: positional initialization of field in 'struct' declared with 'designated_init' attribute [-Werror=designated-init]

Unverified Error/Warning (likely false positive, kindly check if interested):

    Warning: arch/x86/platform/intel-quark/imr_selftest.c:128 expecting prototype for imr_self_test_exit(). Prototype was for device_initcall() instead
    Warning: arch/x86/platform/intel-quark/imr_selftest.c:128 function parameter 'imr_self_test_init' not described in 'device_initcall'
    Warning: drivers/irqchip/irq-ixp4xx.c:207 expecting prototype for ixp4x_irq_setup(). Prototype was for ixp4xx_irq_setup() instead

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-002-20251106
|   `-- Warning:arch-arm-mm-dma-mapping.c-expecting-prototype-for-arm_iommu_unmap_page().-Prototype-was-for-arm_iommu_unmap_phys()-instead
|-- arm-randconfig-004-20251107
|   `-- Warning:drivers-irqchip-irq-ixp4xx.c-expecting-prototype-for-ixp4x_irq_setup().-Prototype-was-for-ixp4xx_irq_setup()-instead
|-- i386-allmodconfig
|   |-- Warning:arch-x86-platform-intel-quark-imr_selftest.c-expecting-prototype-for-imr_self_test_exit().-Prototype-was-for-device_initcall()-instead
|   |-- Warning:arch-x86-platform-intel-quark-imr_selftest.c-function-parameter-imr_self_test_init-not-described-in-device_initcall
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   |-- Warning:drivers-pmdomain-mediatek-mtk-mfg-pmdomain.c-struct-__packed-mtk_mfg_opp_entry-__le32-freq_khz-__le32-voltage_core-__le32-voltage_sram-__le32-posdiv-__le32-voltage_margin-__le32-power_mw-error
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   |-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dce_stream_encoder.c:error:positional-initialization-of-field-in-struct-declared-with-designated_init-attribute
|-- i386-allyesconfig
|   |-- Warning:arch-x86-platform-intel-quark-imr_selftest.c-expecting-prototype-for-imr_self_test_exit().-Prototype-was-for-device_initcall()-instead
|   |-- Warning:arch-x86-platform-intel-quark-imr_selftest.c-function-parameter-imr_self_test_init-not-described-in-device_initcall
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-xe-xe_pm.c-expecting-prototype-for-xe_pm_might_block_on_suspend().-Prototype-was-for-xe_pm_block_on_suspend()-instead
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   |-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dce_stream_encoder.c:error:positional-initialization-of-field-in-struct-declared-with-designated_init-attribute
|-- m68k-allnoconfig
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- parisc-randconfig-002-20251106
|   `-- Warning:drivers-gpu-drm-xe-xe_pm.c-expecting-prototype-for-xe_pm_might_block_on_suspend().-Prototype-was-for-xe_pm_block_on_suspend()-instead
|-- s390-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|   |-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|   |-- Warning:drivers-gpu-drm-xe-xe_pm.c-expecting-prototype-for-xe_pm_might_block_on_suspend().-Prototype-was-for-xe_pm_block_on_suspend()-instead
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- s390-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_hw_sequencer.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|   |-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|   |-- Warning:drivers-gpu-drm-xe-xe_pm.c-expecting-prototype-for-xe_pm_might_block_on_suspend().-Prototype-was-for-xe_pm_block_on_suspend()-instead
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- sh-allmodconfig
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- sh-allyesconfig
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- sparc-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_hw_sequencer.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|   |-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|   |-- Warning:drivers-gpu-drm-xe-xe_pm.c-expecting-prototype-for-xe_pm_might_block_on_suspend().-Prototype-was-for-xe_pm_block_on_suspend()-instead
|   |-- Warning:drivers-pmdomain-mediatek-mtk-mfg-pmdomain.c-struct-__packed-mtk_mfg_opp_entry-__le32-freq_khz-__le32-voltage_core-__le32-voltage_sram-__le32-posdiv-__le32-voltage_margin-__le32-power_mw-error
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- x86_64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-xe-xe_pm.c-expecting-prototype-for-xe_pm_might_block_on_suspend().-Prototype-was-for-xe_pm_block_on_suspend()-instead
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- x86_64-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-xe-xe_pm.c-expecting-prototype-for-xe_pm_might_block_on_suspend().-Prototype-was-for-xe_pm_block_on_suspend()-instead
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- x86_64-kexec
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-bpf
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-rhel-9.4-func
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-kselftests
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-kunit
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-rhel-9.4-ltp
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_hw_sequencer.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|   `-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|-- x86_64-rhel-9.4-rust
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
`-- xtensa-randconfig-002-20251106
    |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
    `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label

elapsed time: 1051m

configs tested: 185
configs skipped: 7

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251106    gcc-12.5.0
arc                   randconfig-002-20251106    gcc-8.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   milbeaut_m10v_defconfig    clang-19
arm                   randconfig-001-20251106    gcc-11.5.0
arm                   randconfig-002-20251106    clang-22
arm                   randconfig-003-20251106    gcc-10.5.0
arm                   randconfig-004-20251106    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                            allyesconfig    clang-22
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251106    gcc-11.5.0
arm64                 randconfig-002-20251106    clang-19
arm64                 randconfig-003-20251106    gcc-14.3.0
arm64                 randconfig-004-20251106    gcc-15.1.0
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                             allyesconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251106    gcc-12.5.0
csky                  randconfig-002-20251106    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251106    clang-19
hexagon               randconfig-002-20251106    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251106    clang-20
i386        buildonly-randconfig-002-20251106    clang-20
i386        buildonly-randconfig-003-20251106    gcc-14
i386        buildonly-randconfig-004-20251106    clang-20
i386        buildonly-randconfig-005-20251106    gcc-14
i386        buildonly-randconfig-006-20251106    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20251106    gcc-14
i386                  randconfig-002-20251106    gcc-14
i386                  randconfig-003-20251106    gcc-14
i386                  randconfig-004-20251106    gcc-12
i386                  randconfig-005-20251106    gcc-14
i386                  randconfig-006-20251106    gcc-12
i386                  randconfig-007-20251106    gcc-12
i386                  randconfig-011-20251106    gcc-14
i386                  randconfig-012-20251106    clang-20
i386                  randconfig-013-20251106    clang-20
i386                  randconfig-014-20251106    clang-20
i386                  randconfig-015-20251106    gcc-14
i386                  randconfig-016-20251106    gcc-14
i386                  randconfig-017-20251106    gcc-13
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                        allyesconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251106    gcc-15.1.0
loongarch             randconfig-002-20251106    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                       m5249evb_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                            allyesconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251106    gcc-9.5.0
nios2                 randconfig-002-20251106    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251106    gcc-10.5.0
parisc                randconfig-002-20251106    gcc-10.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                     asp8347_defconfig    clang-22
powerpc                  mpc885_ads_defconfig    clang-22
powerpc               randconfig-001-20251106    gcc-14.3.0
powerpc               randconfig-002-20251106    clang-22
powerpc                     taishan_defconfig    clang-17
powerpc64             randconfig-002-20251106    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251106    clang-22
riscv                 randconfig-002-20251106    gcc-12.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251106    gcc-8.5.0
s390                  randconfig-002-20251106    gcc-14.3.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251106    gcc-11.5.0
sh                    randconfig-002-20251106    gcc-13.4.0
sh                            shmin_defconfig    gcc-15.1.0
sh                             shx3_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                            allyesconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251106    gcc-15.1.0
sparc                 randconfig-002-20251106    gcc-15.1.0
sparc                       sparc64_defconfig    gcc-15.1.0
sparc64                          allmodconfig    clang-22
sparc64                          allyesconfig    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251106    gcc-13.4.0
sparc64               randconfig-002-20251106    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251106    gcc-14
um                    randconfig-002-20251106    clang-22
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251106    gcc-12
x86_64      buildonly-randconfig-002-20251106    gcc-14
x86_64      buildonly-randconfig-003-20251106    gcc-14
x86_64      buildonly-randconfig-004-20251106    gcc-14
x86_64      buildonly-randconfig-005-20251106    clang-20
x86_64      buildonly-randconfig-006-20251106    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251106    clang-20
x86_64                randconfig-002-20251106    clang-20
x86_64                randconfig-003-20251106    clang-20
x86_64                randconfig-004-20251106    clang-20
x86_64                randconfig-005-20251106    gcc-14
x86_64                randconfig-006-20251106    clang-20
x86_64                randconfig-011-20251106    clang-20
x86_64                randconfig-012-20251106    clang-20
x86_64                randconfig-013-20251106    clang-20
x86_64                randconfig-014-20251106    gcc-14
x86_64                randconfig-015-20251106    gcc-14
x86_64                randconfig-016-20251106    gcc-12
x86_64                randconfig-071-20251106    clang-20
x86_64                randconfig-072-20251106    clang-20
x86_64                randconfig-073-20251106    gcc-14
x86_64                randconfig-074-20251106    clang-20
x86_64                randconfig-075-20251106    clang-20
x86_64                randconfig-076-20251106    gcc-14
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251106    gcc-9.5.0
xtensa                randconfig-002-20251106    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

