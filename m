Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7749CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671DE8E00DC; Wed, 29 Oct 2025 15:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3DE8E00B2; Wed, 29 Oct 2025 15:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BCE8E00DC; Wed, 29 Oct 2025 15:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02D3C8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:08:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0DAEBC09C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:08:12 +0000 (UTC)
X-FDA: 84052087224.19.D939CB3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf15.hostedemail.com (Postfix) with ESMTP id 95D91A0012
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:08:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cvTXB6Tw;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=NFhiNkxBpx5A6KjJEFbk49LGWxlBuiu1RJ3/OjEs7Rk=;
	b=OfHzl/muP1jIktjDJI4pNEpd2T8pslBBsNBADulLzDCxWJ5e7kTHcON2lgV9GFgxZliKja
	wpHWCvGhJMRVhPkReUMBe/JtWtO6aKgku1YDBHqT/VWxcDy9T2FHrynXQjBcEUhnbr3gQ3
	CnbMUDNtbAmOHd0BXZzKlfd+Mmzh9iM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cvTXB6Tw;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761764890; a=rsa-sha256;
	cv=none;
	b=t1PCoQh2QyeSQOvT4Z5KmqnDOmQANat4QJBRL45K212Ift7EZDTO8GdALeQeUrPsYNXpe3
	ixaPxmnZkIvWARURMQvW8AqEYlBOOAiZ46NHpDoWNdanAjoNpComOjAAO5aQPOn3EPR+UY
	ytMjiB3fev8xkdLIkJZ+A5b90+ZR7Sw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761764889; x=1793300889;
  h=date:from:to:cc:subject:message-id;
  bh=a8LcVepdM+GiPaSHQJU0Tf5fATzX0wfMHlnDT1KEYSQ=;
  b=cvTXB6Twd6sQFYaPQ/Qxx2sVWVuMS6q4PhzFmTQ6KvYy1TcyRBrVjALB
   1OdJwO5wphKlQyBc3lvV1PO8SQBwOepWaHNZ6PV+0EgeqDhXyEAfApZZ2
   Q4/XFaSLXo41KknMSn7OvHES4bJWXkaxddSIr1phvYRd7spWER3vZotxd
   t+vzlMwjJZ+jHrwCKj9079yEKpOAGpVFkzhtjwJDT7p4IVLn0OMMeqZDD
   yaAX4osYQtXgxCULq1X2prsCvxX0Ipy13C4hn8cddN/FOcYcJAvO1QawW
   UU8ufN8KXNdhR6K2lFNDL4/Bf5DvRIYencX7JRJ60DZrVjtMlPqVmAEnu
   g==;
X-CSE-ConnectionGUID: I/I9/jUfRpy0GBSz7vfUzw==
X-CSE-MsgGUID: Gqo+lcaXRz6SWURCDcjfOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74496785"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74496785"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 12:08:07 -0700
X-CSE-ConnectionGUID: mO5y20d1QAS0VVJXQX8WjA==
X-CSE-MsgGUID: 0fkMVC9zRg+Ur/n+jk8GjA==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 29 Oct 2025 12:08:02 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vEBWD-000L56-0n;
	Wed, 29 Oct 2025 19:07:45 +0000
Date: Thu, 30 Oct 2025 03:07:22 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 f9ba12abc5282bf992f9a9ae87ad814fd03a0270
Message-ID: <202510300306.TNY2dC98-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 95D91A0012
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4kpdyeijac8zo31m6pyz1zdgkp3c17qo
X-HE-Tag: 1761764889-514958
X-HE-Meta: U2FsdGVkX1+HWfRPvaeEWZaiki1WSDzX8W1s/JEtiOG/FNZUI8+yFuQkzdJXR5LRvx1WdYy4773Wj2nRsP6y7yI3hkFfzsZlWEFc28zdiqKZUt93k3vW0dKkEAVO++7RP0xucUsSWd3QBHMklqwiovKNNVeP9X//SPU4nuddOD3M4PT1JChcjj+ozsQuuqGBZI+uUnTFvx0KiArX5TXhf95v1s2eGyJT7/q5DAwnmIC/MTyTaF19zL7cMQCaIDJ5qbhrPI6sNSCOiUG3NXPzsuTAqn30AhYY2sHPsUcVN99OEDKKOsP1tqKK7L/F7uKKTbDBWJ9P2e4vbvXRej0HfCmK4o15XE5A9/2QwF2N/M+fPJoE0NFIFTF92EQ+o0Ka2GEadQYit/01wcIJ8uYeWmVWcq+yUjg183Jm7yrYsfBNFoh4eVFs97Td3ZdnyqsL6i0bMZjCOGH1xfZz1klTLQWyS3BVF+hAXkDg8XaOMdd/N5yE84UEfJ73zjjVaGu4fHfHtCSIKSCeWYkxdQKGyFYyoAlIIoILRJK55sa3Ir7Wx45q6vK7QzaPReO9Xn4v+cfna+LC1H55iUyhVUZq2PHDT8iHBCvpkq2TntNy+IN0xhX0qjfeeAJyr/u3BL+enBxNVWnc93sH/9AtOLLjwC7E9tM9P60d0lTNHHSiWrXYU0kBCwRTw0H/Xwcl3BSQR9yxzuZFQ7h+kC46v0aeIZ8wRcvXZkbR4XQeS8lSSKh5upsVlBbaQfI2aBIUPrPcz7kYOEpK3iQvRVtLIB1WWLNqBHtfivbGvOM3aTBEH3Ib/imr9Z9b6a2oMJcGVM/xQvXrmr7yo2J+d4Pw0PZfymYDr2CzkZyVDzPpUvU9AjgStj37lW1DvTwc2r8IpnD5siAF9ah5uL/Z63Skl8NK0OrMukQEjg9MaVyxC9f4HB2PfI4FmLDxbcJMae+DD/jCfhlDl0rhl8FJ5265REa
 RR2ubbqU
 nuKHOMhpPuMkoNOstjQQEABtQQgfPsfJnOLErmQtYwMCBC4771PEretnwLxQ+o8Cc4dsKW4iiz9qvQ2ibMK0+zNLgl8qpVyzCTGC4wXM/nkVbkyhKqEpmWLdn8VKSCfP/jOfvX79wWgthxgZOQ9wPEs0Y75XWSHXu15CNIaZVXrbVe0UTaIFdZztnMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: f9ba12abc5282bf992f9a9ae87ad814fd03a0270  Add linux-next specific files for 20251029

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202510211913.5a4SfQab-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510230222.gjGA0A40-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510271906.1346pSIO-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510290348.IpSNHCxr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510291235.IsyuIDrm-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510291500.a2Lg0OSH-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510291626.PW7a9uD7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510291650.TFCWQxkj-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510291905.CNy7FYI0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510292115.MtowRumM-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510292307.DmOaSI39-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510292356.JnTUBxCl-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510300033.pwwkKnVb-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510300152.UG9LOpTY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510222101.dxkptxL9-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510222308.6LSfjKDk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510241912.s8uQLYlp-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242155.afchO66g-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242250.ZzaqW0pV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242322.aWclvr7e-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510250132.FdNONf4v-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510290821.p45JqxMU-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510292021.XfUW1Zro-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510292251.VyXccjIA-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510292330.95H9QLiY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510300101.souVJGhV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510300330.jn0dtIZb-lkp@intel.com

    ERROR: modpost: "__udivdi3" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
    ERROR: modpost: "devm_backlight_device_register" [drivers/gpu/drm/panel/panel-visionox-rm69299.ko] undefined!
    Warning: drivers/gpio/gpio-mm-lantiq.c:90 function parameter 'chip' not described in 'ltq_mm_save_regs'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7242 function parameter 'connector' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7242 function parameter 'force' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1300 function parameter 'link' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1300 function parameter 'type' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1354 function parameter 'link' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1354 function parameter 'type' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:872 function parameter 'edid_header' not described in 'link_detect_evaluate_edid_header'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:890 function parameter 'link' not described in 'link_detect_ddc_probe'
    aarch64-linux-ld: mtk-mfg-pmdomain.c:(.text+0x18b8): undefined reference to `mbox_free_channel'
    aarch64-linux-ld: mtk-mfg-pmdomain.c:(.text+0x2050): undefined reference to `mbox_request_channel_byname'
    arch/riscv/include/asm/vdso/processor.h:23:2: error: expected instruction format
    arch/x86/hyperv/hv_crash.c:631:2: error: must use 'struct' tag to refer to type 'smp_ops'
    arch/x86/hyperv/hv_crash.c:631:9: error: 'smp_ops' undeclared (first use in this function)
    arch/x86/hyperv/hv_crash.c:631:9: error: expected identifier or '('
    drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_stream_encoder.c:1571:69: error: positional initialization of field in 'struct' declared with 'designated_init' attribute [-Werror=designated-init]
    drivers/gpu/drm/amd/amdgpu/../ras/ras_mgr/amdgpu_ras_mgr.c:132:(.text+0x4f0): undefined reference to `__udivdi3'
    include/linux/pinctrl/pinconf-generic.h:235:(.ltext+0x4dd): undefined reference to `pinconf_generic_dt_node_to_map'
    mtk-mfg-pmdomain.c:(.text+0x1880): undefined reference to `mbox_free_channel'
    mtk-mfg-pmdomain.c:(.text+0x1f6c): undefined reference to `mbox_request_channel_byname'
    mtk-mfg-pmdomain.c:(.text+0x20c): undefined reference to `mbox_send_message'

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/accel/ivpu/ivpu_gem.c:59:54-61: WARNING: Consider using %pe to print PTR_ERR()
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:1213 CalculatePrefetchSchedule() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:2755 TruncToValidBPP() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:3176 CalculateDCFCLKDeepSleep() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:3754 CalculateVMGroupAndRequestTimes() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:4056 CalculateStutterEfficiency() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:4206 CalculateSwathAndDETConfiguration() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:4789 CalculateSurfaceSizeInMall() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:5201 CalculateVMRowAndSwath() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:6019 CalculatePrefetchBandwithSupport() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:6201 CalculateMaxVStartup() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:6923 dml_core_mode_support() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:8380 dml_core_mode_programming() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_core.c:9362 dml_core_mode_programming() warn: for statement not indented
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_util.c:118 dml_floor() warn: if statement not indented
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_util.c:152 dml_max() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/display_mode_util.c:733 dml_get_num_active_planes() warn: if statement not indented
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/dml2_mall_phantom.c:468 dml2_svp_drr_schedulable() error: we previously assumed 'pipe->stream' could be null (see line 454)
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/dml2_mall_phantom.c:557 subvp_vblank_schedulable() error: we previously assumed 'subvp_pipe' could be null (see line 549)
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/dml2_policy.c:208 dml2_policy_build_synthetic_soc_states() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../display/dc/dml2_0/dml2_wrapper.c:527 dml2_validate_only() warn: inconsistent indenting
    drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_core.c:512 ras_core_get_utc_second_timestamp() error: we previously assumed 'ras_core' could be null (see line 508)
    drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_core.c:531 ras_core_ras_interrupt_detected() error: we previously assumed 'ras_core' could be null (see line 527)
    drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_umc.c:210 ras_umc_log_pending_bad_bank() warn: variable dereferenced before check 'ecc_node' (see line 208)
    drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c:1002 amdgpu_cs_parser_bos() warn: inconsistent returns '&p->bo_list->bo_list_mutex'.
    drivers/gpu/drm/vkms/vkms_configfs.c:223 make_crtc_group() error: dereferencing freed memory 'crtc' (line 222)
    drivers/gpu/drm/vkms/vkms_configfs.c:377 make_plane_group() error: dereferencing freed memory 'plane' (line 376)
    drivers/gpu/drm/vkms/vkms_configfs.c:491 make_encoder_group() error: dereferencing freed memory 'encoder' (line 490)
    drivers/gpu/drm/vkms/vkms_configfs.c:656 make_connector_group() error: dereferencing freed memory 'connector' (line 655)
    drivers/gpu/drm/vkms/vkms_configfs.c:770 make_device_group() error: dereferencing freed memory 'dev' (line 769)
    drivers/net/wireless/intel/iwlwifi/mld/rx.c:464 iwl_mld_decode_he_phy_data() error: uninitialized symbol 'nsts'.
    drivers/pmdomain/mediatek/mtk-pm-domains.c:824 scpsys_add_one_domain() error: we previously assumed 'pd->data' could be null (see line 799)
    drivers/spi/spi-aspeed-smc.c:980:2-7: opportunity for str_yes_no(found)
    fs/userfaultfd.c:1515 userfaultfd_unregister() warn: comparison of a potentially tagged address (userfaultfd_unregister, -2, __UNIQUE_ID_x__921)
    mm/msync.c:90 __do_sys_msync() warn: comparison of a potentially tagged address (__do_sys_msync, -2, __UNIQUE_ID_x__874)
    mm/userfaultfd.c:858 mfill_atomic() warn: inconsistent returns '&ctx->map_changing_lock'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm64-randconfig-r071-20251028
|   `-- drivers-net-wireless-intel-iwlwifi-mld-rx.c-iwl_mld_decode_he_phy_data()-error:uninitialized-symbol-nsts-.
|-- arm64-randconfig-r073-20251029
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-CalculateDCFCLKDeepSleep()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-CalculateMaxVStartup()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-CalculatePrefetchBandwithSupport()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-CalculatePrefetchSchedule()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-CalculateStutterEfficiency()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-CalculateSurfaceSizeInMall()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-CalculateSwathAndDETConfiguration()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-CalculateVMGroupAndRequestTimes()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-CalculateVMRowAndSwath()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-TruncToValidBPP()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-dml_core_mode_programming()-warn:for-statement-not-indented
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-dml_core_mode_programming()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_core.c-dml_core_mode_support()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_util.c-dml_floor()-warn:if-statement-not-indented
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_util.c-dml_get_num_active_planes()-warn:if-statement-not-indented
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-display_mode_util.c-dml_max()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-dml2_mall_phantom.c-dml2_svp_drr_schedulable()-error:we-previously-assumed-pipe-stream-could-be-null-(see-line-)
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-dml2_mall_phantom.c-subvp_vblank_schedulable()-error:we-previously-assumed-subvp_pipe-could-be-null-(see-line-)
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-dml2_policy.c-dml2_policy_build_synthetic_soc_states()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml2_0-dml2_wrapper.c-dml2_validate_only()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_core.c-ras_core_get_utc_second_timestamp()-error:we-previously-assumed-ras_core-could-be-null-(see-line-)
|   |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_core.c-ras_core_ras_interrupt_detected()-error:we-previously-assumed-ras_core-could-be-null-(see-line-)
|   |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_umc.c-ras_umc_log_pending_bad_bank()-warn:variable-dereferenced-before-check-ecc_node-(see-line-)
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_cs.c-amdgpu_cs_parser_bos()-warn:inconsistent-returns-p-bo_list-bo_list_mutex-.
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq.c-amdgpu_userq_start_sched_for_enforce_isolation()-warn:inconsistent-indenting
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_virt.c-amdgpu_virt_init_critical_region()-warn:unsigned-init_hdr_offset-is-never-less-than-zero.
|   |-- fs-userfaultfd.c-userfaultfd_unregister()-warn:comparison-of-a-potentially-tagged-address-(userfaultfd_unregister-__UNIQUE_ID_x__921)
|   |-- mm-msync.c-__do_sys_msync()-warn:comparison-of-a-potentially-tagged-address-(__do_sys_msync-__UNIQUE_ID_x__874)
|   `-- mm-userfaultfd.c-mfill_atomic()-warn:inconsistent-returns-ctx-map_changing_lock-.
|-- arm64-randconfig-r131-20251029
|   |-- aarch64-linux-ld:mtk-mfg-pmdomain.c:(.text):undefined-reference-to-mbox_free_channel
|   |-- aarch64-linux-ld:mtk-mfg-pmdomain.c:(.text):undefined-reference-to-mbox_request_channel_byname
|   |-- mtk-mfg-pmdomain.c:(.text):undefined-reference-to-mbox_free_channel
|   |-- mtk-mfg-pmdomain.c:(.text):undefined-reference-to-mbox_request_channel_byname
|   `-- mtk-mfg-pmdomain.c:(.text):undefined-reference-to-mbox_send_message
|-- i386-randconfig-007-20251029
|   `-- ERROR:devm_backlight_device_register-drivers-gpu-drm-panel-panel-visionox-rm69299.ko-undefined
|-- i386-randconfig-014-20251029
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- i386-randconfig-063-20251029
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- i386-randconfig-141-20251029
|   `-- mm-userfaultfd.c-mfill_atomic()-warn:inconsistent-returns-ctx-map_changing_lock-.
|-- microblaze-allmodconfig
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- mips-xway_defconfig
|   `-- Warning:drivers-gpio-gpio-mm-lantiq.c-function-parameter-chip-not-described-in-ltq_mm_save_regs
|-- openrisc-allmodconfig
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- parisc-allmodconfig
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- parisc-randconfig-002-20251029
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- powerpc-randconfig-002-20251029
|   `-- drivers-gpu-drm-amd-amdgpu-..-ras-ras_mgr-amdgpu_ras_mgr.c:(.text):undefined-reference-to-__udivdi3
|-- powerpc64-randconfig-r072-20251029
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_connector_group()-error:dereferencing-freed-memory-connector-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_crtc_group()-error:dereferencing-freed-memory-crtc-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_device_group()-error:dereferencing-freed-memory-dev-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_encoder_group()-error:dereferencing-freed-memory-encoder-(line-)
|   `-- drivers-gpu-drm-vkms-vkms_configfs.c-make_plane_group()-error:dereferencing-freed-memory-plane-(line-)
|-- riscv-allyesconfig
|   `-- arch-riscv-include-asm-vdso-processor.h:error:expected-instruction-format
|-- sparc64-randconfig-r054-20251029
|   |-- drivers-spi-spi-aspeed-smc.c:WARNING:invalid-free-of-devm_-allocated-data
|   `-- drivers-spi-spi-aspeed-smc.c:opportunity-for-str_yes_no(found)
|-- um-randconfig-001-20251029
|   |-- clang:error:linker-command-failed-with-exit-code-(use-v-to-see-invocation)
|   `-- include-linux-pinctrl-pinconf-generic.h:(.ltext):undefined-reference-to-pinconf_generic_dt_node_to_map
|-- um-randconfig-r073-20251025
|   `-- drivers-pmdomain-mediatek-mtk-pm-domains.c-scpsys_add_one_domain()-error:we-previously-assumed-pd-data-could-be-null-(see-line-)
|-- x86_64-randconfig-005-20251029
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dce_stream_encoder.c:error:positional-initialization-of-field-in-struct-declared-with-designated_init-attribute
|-- x86_64-randconfig-073-20251029
|   `-- arch-x86-hyperv-hv_crash.c:error:smp_ops-undeclared-(first-use-in-this-function)
|-- x86_64-randconfig-103-20251029
|   |-- arch-x86-hyperv-hv_crash.c:error:expected-identifier-or-(
|   |-- arch-x86-hyperv-hv_crash.c:error:must-use-struct-tag-to-refer-to-type-smp_ops
|   `-- drivers-accel-ivpu-ivpu_gem.c:WARNING:Consider-using-pe-to-print-PTR_ERR()
`-- x86_64-randconfig-161-20251029
    `-- mm-userfaultfd.c-mfill_atomic()-warn:inconsistent-returns-ctx-map_changing_lock-.

elapsed time: 975m

configs tested: 186
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251029    gcc-15.1.0
arc                   randconfig-002-20251029    gcc-15.1.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                      footbridge_defconfig    clang-17
arm                       multi_v4t_defconfig    clang-16
arm                   randconfig-001-20251029    gcc-8.5.0
arm                   randconfig-002-20251029    clang-22
arm                   randconfig-003-20251029    clang-22
arm                   randconfig-004-20251029    clang-22
arm                         wpcm450_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                            allyesconfig    clang-22
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251029    gcc-12.5.0
arm64                 randconfig-002-20251029    clang-22
arm64                 randconfig-003-20251029    gcc-13.4.0
arm64                 randconfig-004-20251029    gcc-11.5.0
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                             allyesconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251029    gcc-9.5.0
csky                  randconfig-002-20251029    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251029    clang-20
hexagon               randconfig-002-20251029    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251029    gcc-14
i386        buildonly-randconfig-002-20251029    gcc-14
i386        buildonly-randconfig-003-20251029    clang-20
i386        buildonly-randconfig-004-20251029    gcc-14
i386        buildonly-randconfig-005-20251029    gcc-14
i386        buildonly-randconfig-006-20251029    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20251029    gcc-14
i386                  randconfig-002-20251029    gcc-14
i386                  randconfig-003-20251029    clang-20
i386                  randconfig-004-20251029    gcc-14
i386                  randconfig-005-20251029    clang-20
i386                  randconfig-006-20251029    gcc-14
i386                  randconfig-007-20251029    clang-20
i386                  randconfig-011-20251029    gcc-14
i386                  randconfig-012-20251029    clang-20
i386                  randconfig-013-20251029    gcc-14
i386                  randconfig-014-20251029    gcc-14
i386                  randconfig-015-20251029    gcc-14
i386                  randconfig-016-20251029    gcc-14
i386                  randconfig-017-20251029    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                        allyesconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251029    clang-22
loongarch             randconfig-002-20251029    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                        maltaup_defconfig    clang-22
mips                           xway_defconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                            allyesconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251029    gcc-11.5.0
nios2                 randconfig-002-20251029    gcc-9.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251029    gcc-12.5.0
parisc                randconfig-002-20251029    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                     ksi8560_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251029    clang-22
powerpc               randconfig-002-20251029    gcc-12.5.0
powerpc                     sequoia_defconfig    clang-17
powerpc64             randconfig-001-20251029    clang-22
powerpc64             randconfig-002-20251029    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251029    clang-20
riscv                 randconfig-002-20251029    clang-19
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251029    gcc-11.5.0
s390                  randconfig-002-20251029    gcc-8.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251029    gcc-11.5.0
sh                    randconfig-002-20251029    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                            allyesconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251029    gcc-8.5.0
sparc                 randconfig-002-20251029    gcc-15.1.0
sparc64                          allmodconfig    clang-22
sparc64                          allyesconfig    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251029    clang-20
sparc64               randconfig-002-20251029    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251029    clang-22
um                    randconfig-002-20251029    clang-22
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251029    gcc-14
x86_64      buildonly-randconfig-002-20251029    clang-20
x86_64      buildonly-randconfig-003-20251029    clang-20
x86_64      buildonly-randconfig-004-20251029    clang-20
x86_64      buildonly-randconfig-005-20251029    clang-20
x86_64      buildonly-randconfig-006-20251029    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251029    gcc-14
x86_64                randconfig-002-20251029    gcc-14
x86_64                randconfig-003-20251029    clang-20
x86_64                randconfig-004-20251029    gcc-14
x86_64                randconfig-005-20251029    gcc-12
x86_64                randconfig-006-20251029    gcc-14
x86_64                randconfig-011-20251029    clang-20
x86_64                randconfig-012-20251029    clang-20
x86_64                randconfig-013-20251029    gcc-14
x86_64                randconfig-014-20251029    clang-20
x86_64                randconfig-015-20251029    gcc-13
x86_64                randconfig-016-20251029    gcc-13
x86_64                randconfig-071-20251029    clang-20
x86_64                randconfig-072-20251029    clang-20
x86_64                randconfig-073-20251029    gcc-14
x86_64                randconfig-074-20251029    gcc-14
x86_64                randconfig-075-20251029    gcc-14
x86_64                randconfig-076-20251029    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251029    gcc-8.5.0
xtensa                randconfig-002-20251029    gcc-8.5.0
xtensa                         virt_defconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

