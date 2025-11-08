Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B6A1CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 03:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CBC68E0006; Fri,  7 Nov 2025 22:11:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67BDE8E0003; Fri,  7 Nov 2025 22:11:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A728E0006; Fri,  7 Nov 2025 22:11:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 366658E0003
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:11:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF7641A0679
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 03:11:06 +0000 (UTC)
X-FDA: 84085963332.11.2F65CB3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf24.hostedemail.com (Postfix) with ESMTP id 41D8E180010
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 03:11:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ayYLCd7L;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762571465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9SqYdVht4aSYQE8hqnAkr8UMnT/RgpZkNPnjcWL0Bjw=;
	b=fJiHNCgxUVRp3TQob72lXL75Rj06+miWXuOGO6zgNA2b2suFeg/v1ptejbAvG2BWlFjSxd
	TqHdHuYroALA/ohJRWQWz6SgkZsIMZvtK91HV7grQ5kXMeotUtDEhafDUqFg1rYH8e1Kvu
	RY2mSq4D7PRcl3muHMndjMRJDOXYUNc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ayYLCd7L;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762571465; a=rsa-sha256;
	cv=none;
	b=DbL77j34s01utcp9lJGLfVsZb2fZPV10uk+zKJ1Thl312JCXtR6fM7ANIoDsZb9kRaHKd5
	WJAma+JJ2tZJzmRgUUG2UrMy8kRNAxS+VZ2rG6EWJEGk2daua4/TLjWkyHc7+P0ZHubvaF
	mDSoJHKMiPTa4iRtmkD3e/ioCiQ4gK8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762571465; x=1794107465;
  h=date:from:to:cc:subject:message-id;
  bh=poBHZ5E++CeRsgIwkW8toTp1CNc6Hl3sTcvfK4CFY1o=;
  b=ayYLCd7LL1a6Nze3dvGjY9xdSFJR4wFGOtr1TjrrfinawomkbktRGebr
   ybMZf8opDEDFk3t2kkdpZZ8J50xKawX0mNtpcN/lPxxJ+rpT7UDrIGT+a
   uBWIbpR99vO12YEVwBHDnRxOFlcibGJYBJpOkhggzmbGCYg7d88Do8txd
   Fa8tlQeN3XP11JYvYZ7RJzBR8hNwBNxA3olta9hGxEOMS8ENi2v/dHLtW
   jhhHlhKPwDC4pfjBhrUYrifzr76Fw7tZszMZxcZ0UgHix3rnR4c1APRhx
   s+UMftUO6OWrD3kB0eUWH7Edput++r5wfy01TH1DMhqXey386xfRBsjLy
   g==;
X-CSE-ConnectionGUID: p96cCUtlR12ODWpBrAnwzg==
X-CSE-MsgGUID: c/vFMUuSQ8accAXMPV+7cQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11606"; a="75832670"
X-IronPort-AV: E=Sophos;i="6.19,288,1754982000"; 
   d="scan'208";a="75832670"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 19:11:03 -0800
X-CSE-ConnectionGUID: mmWMZFZ0RgSP95b6teBgDw==
X-CSE-MsgGUID: EMN+Tao3QAic4VaGysrPGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,288,1754982000"; 
   d="scan'208";a="193222390"
Received: from lkp-server01.sh.intel.com (HELO 6ef82f2de774) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 07 Nov 2025 19:11:01 -0800
Received: from kbuild by 6ef82f2de774 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vHZLu-0000eh-2P;
	Sat, 08 Nov 2025 03:10:58 +0000
Date: Sat, 08 Nov 2025 11:10:06 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 9c0826a5d9aa4d52206dd89976858457a2a8a7ed
Message-ID: <202511081136.1r4NPgRJ-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 41D8E180010
X-Stat-Signature: tf38uusnpaz537cg6wpdxai4m5udxcjf
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762571464-288460
X-HE-Meta: U2FsdGVkX1/lia+1Ni9z7IdVn8nuEA1D/5dcpabyLYVHwvWpR5d0BZybuckziF9fuhSk44ib8ba6srqQXvL8FMBvXz8CCGuDWmc945YfGBIMjpAjDj0q5inFs0rrCc3S9Kvne/AAz0c7/ItPBTuBrUG4d610/K/sgZXTSBo49UOpQxC93m9hjVDUV0UnN+JFRhfce67y3iL5yJZ6MR1wH36uh9Z4XSB1fsmH8sk6cAsKikxloWMKFrGxXfKaCaVxcSia8033Zihy5R581uqsw0d8DDndJ64YHGOiBml0vzJd5Vbs0MRmzztTfLAIPeC1jabJQlJRnRDfyo4nbHgnm2rHQODAqXRTvGzRJH+D3P944kpTGHmM5KMY66rfpsQpxiWdj+O03tvtH0glGmGre2ulddaTHtxzvdmzmP/4q6pkP/f2NbV0AYgk1QTMRorxnIUD5YKoIHxQj5VitW2Ks9LqxxSm1NGr8j95/+eT5xjvRtHfA4762ozG6x5yifLSB3E6zaZ5Rn6mO2HT/1q0ot2JuVWi/U6f8I1KyVRwTioqAo63VCu6mwpk8cInCIcyDR4xJ55rWQ0W/S0lIqOpUzYeGZwwsTO/hQhKYiWerKlSwBzLpUCYvBxHRjDk4frwDeYRzfqUAHgUr/zVIOmO/zZLiNws8BsvFOaYJifsYf2EgopWW0c8VKGggFTyFK8tep3sRAN2cO1jmL5UvkhbzSAAMdThvP4XzrjGbN0mAgndRKXyxATKuKgdPHkAigTvcCiidgdzh4/svWW+/HF/EW6V+DU9LMsX77Rob292XvXvOkoZ0U1beOWFBeV9Vu+YHJGjUFPyGA5diA4+sweDWik8hCiVkNzAzY/jtBEcfT8gz4r4VwdsIm8rfXEUuSrDb58GDUv4SogBoqroLX73svc2B8/nNIHk4+30X2NTOMpY4Uwjg7ieBOj8n9fYaYsJ7oo+j0mSHljz6x8WfwA
 PR9+kz3B
 IXFMemX06Act1YKVUmh2SLFJ2EznWoq6QZvMSRuvQlisRLKlJmJ9aObyyoK+1Pp4VM16pCSf7ZiTxvGmQHIQVK9mlK2Y+REt4CWbvoklSuwWJU58TcDhzHm+taNGhs1cFt3w1sCjAnx0QpO9ercBcILO5UhFrfPXKz61nmKUzfvuUtOwTLj7LNI0I+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9c0826a5d9aa4d52206dd89976858457a2a8a7ed  Add linux-next specific files for 20251107

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202510291905.CNy7FYI0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510300152.UG9LOpTY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511061542.0LO7xKs8-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511061613.whODAEJk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511061736.CiuroL7H-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511061746.dPegBnNf-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511062036.Ry8Z2APc-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511062050.2oBQXuua-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511080729.ldd6looN-lkp@intel.com

    ERROR: modpost: "ip_send_check" [net/core/selftests.ko] undefined!
    ERROR: modpost: "udp4_hwcsum" [net/core/selftests.ko] undefined!
    Warning: arch/arm/mm/dma-mapping.c:1405 expecting prototype for arm_iommu_unmap_page(). Prototype was for arm_iommu_unmap_phys() instead
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7317 function parameter 'connector' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7317 function parameter 'force' not described in 'amdgpu_dm_connector_detect'
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
    alpha-linux-ld: include/linux/pinctrl/pinconf-generic.h:235:(.text+0x158): undefined reference to `pinconf_generic_dt_node_to_map'
    drivers/pinctrl/pinctrl-pic64gx-gpio2.c:268: undefined reference to `pinconf_generic_dt_node_to_map'

Unverified Error/Warning (likely false positive, kindly check if interested):

    kernel/nstree.c:727:1: internal compiler error: in change_address_1, at emit-rtl.cc:2299
    mm/damon/sysfs.c:1754:1: internal compiler error: in stop_search_p, at reorg.cc:284

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
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
|-- alpha-randconfig-r064-20251107
|   `-- alpha-linux-ld:include-linux-pinctrl-pinconf-generic.h:(.text):undefined-reference-to-pinconf_generic_dt_node_to_map
|-- arm-allyesconfig
|   |-- Warning:arch-arm-mm-dma-mapping.c-expecting-prototype-for-arm_iommu_unmap_page().-Prototype-was-for-arm_iommu_unmap_phys()-instead
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
|-- arm64-allmodconfig
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
|-- hexagon-allmodconfig
|   |-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- hexagon-allyesconfig
|   |-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- loongarch-allmodconfig
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
|-- microblaze-allmodconfig
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
|-- microblaze-allyesconfig
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
|-- nios2-allmodconfig
|   |-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- nios2-allyesconfig
|   |-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- openrisc-allmodconfig
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
|-- powerpc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|   |-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|   |-- Warning:drivers-gpu-drm-xe-xe_pm.c-expecting-prototype-for-xe_pm_might_block_on_suspend().-Prototype-was-for-xe_pm_block_on_suspend()-instead
|   |-- Warning:drivers-pmdomain-mediatek-mtk-mfg-pmdomain.c-struct-__packed-mtk_mfg_opp_entry-__le32-freq_khz-__le32-voltage_core-__le32-voltage_sram-__le32-posdiv-__le32-voltage_margin-__le32-power_mw-error
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- riscv-allmodconfig
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
|-- sh-allmodconfig
|   `-- mm-damon-sysfs.c:internal-compiler-error:in-stop_search_p-at-reorg.cc
|-- sh-allnoconfig
|   `-- kernel-nstree.c:internal-compiler-error:in-change_address_1-at-emit-rtl.cc
|-- sparc-allyesconfig
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
|-- sparc64-allmodconfig
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
|-- sparc64-allyesconfig
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
|-- um-allmodconfig
|   |-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|   |-- Warning:drivers-gpu-drm-xe-xe_pm.c-expecting-prototype-for-xe_pm_might_block_on_suspend().-Prototype-was-for-xe_pm_block_on_suspend()-instead
|   |-- Warning:drivers-pmdomain-mediatek-mtk-mfg-pmdomain.c-struct-__packed-mtk_mfg_opp_entry-__le32-freq_khz-__le32-voltage_core-__le32-voltage_sram-__le32-posdiv-__le32-voltage_margin-__le32-power_mw-error
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- um-allyesconfig
|   |-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|   |-- Warning:drivers-gpu-drm-xe-xe_pm.c-expecting-prototype-for-xe_pm_might_block_on_suspend().-Prototype-was-for-xe_pm_block_on_suspend()-instead
|   |-- Warning:drivers-pmdomain-mediatek-mtk-mfg-pmdomain.c-struct-__packed-mtk_mfg_opp_entry-__le32-freq_khz-__le32-voltage_core-__le32-voltage_sram-__le32-posdiv-__le32-voltage_margin-__le32-power_mw-error
|   |-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|   |-- Warning:security-smack-smack_access.c-expecting-prototype-for-smk_import_valid_allocated_label().-Prototype-was-for-smk_import_allocated_label()-instead
|   `-- Warning:security-smack-smack_access.c-function-parameter-gfp-not-described-in-smk_import_allocated_label
|-- x86_64-kexec
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4
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
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-bpf
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
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-func
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
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-kselftests
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
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- x86_64-rhel-9.4-kunit
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
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
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
|   |-- Warning:drivers-gpu-drm-drm_vblank.c-expecting-prototype-for-drm_crtc_vblank_start_timer().-Prototype-was-for-drm_crtc_vblank_cancel_timer()-instead
|   `-- Warning:kernel-nstree.c-expecting-prototype-for-ns_tree_gen_id().-Prototype-was-for-__ns_tree_gen_id()-instead
|-- xtensa-randconfig-001-20251106
|   `-- drivers-pinctrl-pinctrl-pic64gx-gpio2.c:undefined-reference-to-pinconf_generic_dt_node_to_map
`-- xtensa-randconfig-001-20251108
    |-- ERROR:ip_send_check-net-core-selftests.ko-undefined
    `-- ERROR:udp4_hwcsum-net-core-selftests.ko-undefined

elapsed time: 1337m

configs tested: 185
configs skipped: 5

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                         haps_hs_defconfig    gcc-15.1.0
arc                   randconfig-001-20251107    gcc-8.5.0
arc                   randconfig-002-20251107    gcc-9.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                            qcom_defconfig    clang-22
arm                   randconfig-001-20251107    clang-17
arm                   randconfig-002-20251107    gcc-13.4.0
arm                   randconfig-003-20251107    clang-22
arm                   randconfig-004-20251107    gcc-8.5.0
arm                        realview_defconfig    clang-16
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                            allyesconfig    clang-22
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251107    gcc-8.5.0
arm64                 randconfig-002-20251107    clang-22
arm64                 randconfig-003-20251107    gcc-8.5.0
arm64                 randconfig-004-20251107    clang-22
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                             allyesconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251107    gcc-12.5.0
csky                  randconfig-002-20251107    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251107    clang-22
hexagon               randconfig-002-20251107    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251107    clang-20
i386        buildonly-randconfig-002-20251107    clang-20
i386        buildonly-randconfig-003-20251107    gcc-13
i386        buildonly-randconfig-004-20251107    gcc-14
i386        buildonly-randconfig-005-20251107    clang-20
i386        buildonly-randconfig-006-20251107    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20251107    clang-20
i386                  randconfig-002-20251107    gcc-13
i386                  randconfig-003-20251107    clang-20
i386                  randconfig-004-20251107    clang-20
i386                  randconfig-005-20251107    gcc-14
i386                  randconfig-006-20251107    clang-20
i386                  randconfig-007-20251107    clang-20
i386                  randconfig-011-20251107    gcc-14
i386                  randconfig-012-20251107    clang-20
i386                  randconfig-013-20251107    clang-20
i386                  randconfig-014-20251107    gcc-14
i386                  randconfig-015-20251107    clang-20
i386                  randconfig-016-20251107    clang-20
i386                  randconfig-017-20251107    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                        allyesconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251107    gcc-15.1.0
loongarch             randconfig-002-20251107    clang-19
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                       m5208evb_defconfig    gcc-15.1.0
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
nios2                 randconfig-001-20251107    gcc-11.5.0
nios2                 randconfig-002-20251107    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                generic-32bit_defconfig    gcc-15.1.0
parisc                randconfig-001-20251107    gcc-8.5.0
parisc                randconfig-002-20251107    gcc-12.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20251107    clang-22
powerpc               randconfig-002-20251107    clang-22
powerpc64             randconfig-001-20251107    gcc-14.3.0
powerpc64             randconfig-002-20251107    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251107    clang-22
riscv                 randconfig-002-20251107    gcc-13.4.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251107    gcc-8.5.0
s390                  randconfig-002-20251107    gcc-15.1.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                          polaris_defconfig    gcc-15.1.0
sh                    randconfig-001-20251107    gcc-13.4.0
sh                    randconfig-002-20251107    gcc-11.5.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                            allyesconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251107    gcc-11.5.0
sparc                 randconfig-002-20251107    gcc-15.1.0
sparc64                          alldefconfig    gcc-15.1.0
sparc64                          allmodconfig    clang-22
sparc64                          allyesconfig    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251107    gcc-8.5.0
sparc64               randconfig-002-20251107    gcc-9.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251107    clang-22
um                    randconfig-002-20251107    clang-22
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251107    gcc-14
x86_64      buildonly-randconfig-002-20251107    clang-20
x86_64      buildonly-randconfig-003-20251107    gcc-14
x86_64      buildonly-randconfig-004-20251107    clang-20
x86_64      buildonly-randconfig-005-20251107    gcc-14
x86_64      buildonly-randconfig-006-20251107    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251107    clang-20
x86_64                randconfig-002-20251107    gcc-14
x86_64                randconfig-003-20251107    clang-20
x86_64                randconfig-004-20251107    clang-20
x86_64                randconfig-005-20251107    clang-20
x86_64                randconfig-006-20251107    gcc-12
x86_64                randconfig-011-20251107    gcc-14
x86_64                randconfig-012-20251107    gcc-14
x86_64                randconfig-013-20251107    clang-20
x86_64                randconfig-014-20251107    clang-20
x86_64                randconfig-015-20251107    gcc-14
x86_64                randconfig-016-20251107    gcc-14
x86_64                randconfig-071-20251107    clang-20
x86_64                randconfig-072-20251107    gcc-14
x86_64                randconfig-073-20251107    clang-20
x86_64                randconfig-074-20251107    clang-20
x86_64                randconfig-075-20251107    clang-20
x86_64                randconfig-076-20251107    gcc-14
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251107    gcc-10.5.0
xtensa                randconfig-002-20251107    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

