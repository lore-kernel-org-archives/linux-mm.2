Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68AF5C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 20:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6E28E0005; Thu,  7 Aug 2025 16:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E098E0001; Thu,  7 Aug 2025 16:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB4278E0005; Thu,  7 Aug 2025 16:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C65458E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:53:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70531160ABE
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:53:41 +0000 (UTC)
X-FDA: 83751162642.24.32C4D42
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf25.hostedemail.com (Postfix) with ESMTP id E4A51A0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:53:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f09YjgYu;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754600019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=o6Fn8aYbebz1lNGYqmMQi/fS8daIOoNvSdS0aKB5ExU=;
	b=kk61+eEti+HC2MHncJCRQPayDIYNHcvXvC6U+mTBAQu6e4NG0o7iKFaO1d834W6V64sfO/
	GVIcr+yegt8gf8fKHO7X8jcTM27k1jkMJJhVi/TMK6yW1uL/+/nU3RUPWVo1NszKB6s2M9
	qKiooV+mXGZ8N/beQrjmbRLMLJ073+g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754600019; a=rsa-sha256;
	cv=none;
	b=nRFXnWpsEzkgrZteiAz96Wzgn3pn2ldHVA0quHyjdwIflrOPC1q4A760m5sZcH7nF27hyL
	cGpNWU5tsLXw8pmgEBc1sZyNvfq50TRIOCGB9JBp8eBfMwKH1Ra1ozTnFgBmEnZ5T4Vuyk
	txC/JmOb+IQMmGKHQjoy0Dw7zsSotD0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f09YjgYu;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754600019; x=1786136019;
  h=date:from:to:cc:subject:message-id;
  bh=7isrgvFhEJRtfbWksoZDMk7bgsIO2VijkJGp5d3lTX0=;
  b=f09YjgYu09ja+UrglaQQPHg/UOFh2krQvokZtrP6c09/JLLEUCtL0PkL
   QUSlxSiUBND9sYlC0Hdl1ddkts7XR6OMyjd4rKc43o6l3bgbFIbcCrkkY
   7v5FvYhZOHjSym1M72uL5kL0PRbwOjwLMY4J4P+eUwbMjlHxBAtT9nU92
   ovq7IinUmdeGgSawT+LX0FyZyIDWyD74FuVBPFYoqD8rTLG8ifpBifmhG
   AD+q8ztIoS0/RidZWeX2lS82cB8W/g0+omZmTaqy4NmuGvS0uNDs5pQZR
   7yZU2umS2OZMu/LBBQJH/YPEXm6W/0YNY9j/kEDXZq2amWtCofbKDDuym
   Q==;
X-CSE-ConnectionGUID: Iwi3UUCVTX+/QiC3Iiuacw==
X-CSE-MsgGUID: Klz8oOOMTyaKgCIhXfVdtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67642310"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="67642310"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 13:53:37 -0700
X-CSE-ConnectionGUID: tEmHbozJSZCLHPJ+AZDWlg==
X-CSE-MsgGUID: YCobihCOQ2mwmmdCSPl2zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="195993775"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 07 Aug 2025 13:53:36 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uk7cD-0003Du-2a;
	Thu, 07 Aug 2025 20:53:33 +0000
Date: Fri, 08 Aug 2025 04:52:49 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 442d93313caebc8ccd6d53f4572c50732a95bc48
Message-ID: <202508080427.fZufSF7z-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Queue-Id: E4A51A0002
X-Stat-Signature: nh35rqrneck1y8wce7by5ucddg3u4ff7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754600018-174407
X-HE-Meta: U2FsdGVkX1+xjGzILgmblDEEv7gEf0YSVokFveT0gueMXFLTJHFmYX/vle03eb/UNurlcsO+804lj691uzmcVNnvbNO0IwzIHpiIy+VvXUicVJOzyOcg+9LnSz0GD21ZbKWw1/RHnONAWc5MDQbexqai1UuzrS5hVAlIki2qDDIj1FCJwUl4eM0+pEvU8yqgIr2kuLMwf9/0pEI3hyRH+Xmw8GrAhCSMCOjM4uzn0vq/OHEgVmJrbLmIQHKmgW/tCZjhkz81xEBrigs+eSBU+zPWkTj9PF3qAH09GgbAsFqdBBkGkuho2rsVRn+CIhXp/Z2QXZm51NR7hrsbxAiOprHzJr2hqBq1AlGufwWUCOEVt3Ut5wFu36dDHw0txwo8JHwWKSAgo9+0fb7zBJBKZ/aHMJCNCP5OsZV+2B8yckwcv6qszhTG0NAC1DRkDJcoGpAJqIuMjY2cAEkp3CMI7zJ3aRaFM+z9549EXlilZR/YDGqA2h9O1cInyrjHPQAzqGHVNPd5BhoqTqyBJ1TSkjhYBR/N++ip0dLQLAF1Hlh+2xwCNOntbUkWBaBEg0qLUYBp4NQTInpls00KrZl2habixohITXnQIWjcAvI9mjqRpxWHFLLp7kfifgQ9jXdXzjym0xDgdDjgL5gSFhd/MM9H9WeWKnkTYsM5Xu3lwRsRUo9miZpFUq/jL262HF7rWOTu+KiqfUHZzMN+72wFgH9AFLKIk9CyHKS5MLUbgWFlqKXC2NEvfM5lhasuLBYogfHqrZnKgzm3NRGVo/W8S5yO7L+BrrSBTIx3Yu3pCIh9BXbdFWSnfSbLjyozU2+tC8fJ6o5jx/DKtLpFXxjGPGz4KP/Qd+HzNfMhOX2JiyXQ6txV4DpFR90pX2EqBTqyYBiU5H9sUMxIET4vNpQZlWxk83xyg6Z+344y3ep8A4+85fShPPkaAY+g4vw/JFUSOseZsNwPYDjjLhWEydX
 f2EQ3B56
 muRtgvWfU2SOaTiZZzsIDtluaQGnWJv3iqyyYmbFDDH9SxJ+mh/M7a0roe1tyI7Bh6eKqpYppwLttRLsL0KjYvcbdzsqNbRyH0g8HchqRT9ooHjBhfwqNFjyEusnpxBIztQOb+m8KlBDkvDjOug6LLnrwU34/LGfw5gzNEazuOsoofJKJPF9H7yjaDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 442d93313caebc8ccd6d53f4572c50732a95bc48  Add linux-next specific files for 20250807

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202507142044.IrnmDHo3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507180503.nfyD9uRv-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507212020.72nw9OIi-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220802.0Iz9U37j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220927.C6zNUJt7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507271211.hvhQM36m-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508071840.SzIzxq5q-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508072107.qZvP2rOb-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507090913.B5udTYGY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507191110.FWkwuVJQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507301209.hFc4VENm-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508020200.mf738OTo-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508061925.bEevCphN-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508072327.FmSUD5jl-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508080201.nCHDEECD-lkp@intel.com

    ERROR: modpost: __ex_table+0x153c references non-executable section '.data.rel.local.f2fs_attr_sb_compression'
    ERROR: modpost: __ex_table+0x1560 references non-executable section '.data.rel.local.f2fs_attr_sb_encryption'
    ERROR: modpost: __ex_table+0x1560 references non-executable section '.data.rel.local.f2fs_attr_sb_sb_checksum'
    ERROR: modpost: __ex_table+0x1564 references non-executable section '.data.rel.local.f2fs_attr_sb_flexible_inline_xattr'
    ERROR: modpost: __ex_table+0x156c references non-executable section '.data.rel.local.f2fs_attr_sb_inode_crtime'
    ERROR: modpost: __ex_table+0x1570 references non-executable section '.data.rel.local.f2fs_attr_sb_project_quota'
    ERROR: modpost: __ex_table+0x1570 references non-executable section '.data.rel.local.f2fs_attr_unusable'
    ERROR: modpost: __ex_table+0x1578 references non-executable section '.data.rel.local.f2fs_attrs'
    ERROR: modpost: __ex_table+0x1588 references non-executable section '.data.rel.local.f2fs_base_attr_encryption'
    arch/arm/boot/dts/nvidia/tegra30-asus-p1801-t.dtb: pmic@2d (ti,tps65911): 'pmic-sleep-hog', 'wakeup-source' do not match any of the regexes: '^(vcc(io|[1-7])-supply)$', '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nvidia/tegra30-asus-p1801-t.dtb: pmic@2d (ti,tps65911): regulators:vddctrl: Unevaluated properties are not allowed ('nvidia,tegra-cpu-regulator' was unexpected)
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_GPUCC_615
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_VIDEOCC_615
    kismet: WARNING: unmet direct dependencies detected for SM_GCC_6350 when selected by SM_VIDEOCC_6350

Unverified Error/Warning (likely false positive, kindly check if interested):

    ERROR: modpost: __ex_table+0x1498 references non-executable section '.data.rel.local.f2fs_attr_reserved_blocks'
    ERROR: modpost: __ex_table+0x14a0 references non-executable section '.data.rel.local.f2fs_attr_reserved_segments'
    ERROR: modpost: __ex_table+0x14f4 references non-executable section '.data.rel.local.f2fs_attr_readdir_ra'
    ERROR: modpost: __ex_table+0x14f4 references non-executable section '.data.rel.local.f2fs_base_attr_casefold'
    ERROR: modpost: __ex_table+0x150c references non-executable section '.data.rel.local.f2fs_attr_sb_block_zoned'
    ERROR: modpost: __ex_table+0x1518 references non-executable section '.data.rel.local.f2fs_base_attr_lost_found'
    ERROR: modpost: __ex_table+0x151c references non-executable section '.data.rel.local.f2fs_base_attr_project_quota'
    ERROR: modpost: __ex_table+0x1530 references non-executable section '.data.rel.local.f2fs_base_attr_verity'
    ERROR: modpost: __ex_table+0x153c references non-executable section '.data.rel.local.f2fs_feat_groups'
    ERROR: modpost: __ex_table+0x1540 references non-executable section '.data.rel.local.f2fs_attr_seq_file_ra_mul'
    ERROR: modpost: __ex_table+0x1540 references non-executable section '.data.rel.local.f2fs_kset'
    ERROR: modpost: __ex_table+0x1548 references non-executable section '.data.rel.local.f2fs_sb_feat_groups'
    ERROR: modpost: __ex_table+0x154c references non-executable section '.data.rel.local.f2fs_stat_groups'
    ERROR: modpost: __ex_table+0x1554 references non-executable section '.data.rel.local.f2fs_tune_attrs'
    ERROR: modpost: __ex_table+0x1560 references non-executable section '.data.rel.ro.local.f2fs_feat_attr_ops'
    ERROR: modpost: __ex_table+0x1564 references non-executable section '.data.rel.ro.local.f2fs_feat_ktype'
    ERROR: modpost: __ex_table+0x156c references non-executable section '.data.rel.local.f2fs_base_attr_inode_checksum'
    ERROR: modpost: __ex_table+0x156c references non-executable section '.data.rel.ro.local.f2fs_feature_list_ktype'
    ERROR: modpost: __ex_table+0x1570 references non-executable section '.data.rel.ro.local.f2fs_ktype'
    ERROR: modpost: __ex_table+0x1578 references non-executable section '.data.rel.ro.local.f2fs_sb_ktype'
    ERROR: modpost: __ex_table+0x1584 references non-executable section '.data.rel.local.f2fs_base_attr_readonly'
    ERROR: modpost: __ex_table+0x1584 references non-executable section '.data.rel.ro.local.f2fs_stat_ktype'
    ERROR: modpost: __ex_table+0x1588 references non-executable section '.data.rel.local.f2fs_base_attr_sb_checksum'
    ERROR: modpost: __ex_table+0x1588 references non-executable section '.data.rel.ro.local.f2fs_tune_group'
    ERROR: modpost: __ex_table+0x1590 references non-executable section '.data.print_fmt_devres'
    ERROR: modpost: __ex_table+0x1594 references non-executable section '.data.rel.local.event_devres_log'
    arch/x86/kernel/crash.c:205 elf_header_exclude_ranges() warn: we never enter this loop
    arch/x86/kernel/crash.c:387 crash_setup_memmap_entries() warn: we never enter this loop
    clang: error: clang frontend command failed with exit code 139 (use -v to see invocation)
    drivers/gpu/drm/xe/xe_pt.c:2487 xe_pt_update_ops_run() error: uninitialized symbol 'ifence'.
    drivers/gpu/drm/xe/xe_pt.c:2492 xe_pt_update_ops_run() error: uninitialized symbol 'mfence'.
    drivers/net/ethernet/wangxun/libwx/wx_vf_common.c:101 wx_request_msix_irqs_vf() warn: why call request_threaded_irq() with a NULL thread
    drivers/net/ethernet/wangxun/libwx/wx_vf_common.c:117 wx_request_msix_irqs_vf() warn: 'entry->vector' from request_irq() not released on lines: 117.
    fs/bcachefs/fsck.c:187 lookup_lostfound() error: uninitialized symbol 'subvolid'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_GPUCC_615
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_VIDEOCC_615
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-SM_GCC_6350-when-selected-by-SM_VIDEOCC_6350
|-- arm-randconfig-051-20250807
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-052-20250807
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-053-20250807
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-054-20250807
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-055-20250807
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm64-allmodconfig
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- arm64-randconfig-r112-20250807
|   `-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|-- arm64-randconfig-r121-20250807
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- arm64-randconfig-r132-20250807
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-141-20250807
|   |-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-ifence-.
|   |-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-mfence-.
|   |-- drivers-net-ethernet-wangxun-libwx-wx_vf_common.c-wx_request_msix_irqs_vf()-warn:entry-vector-from-request_irq()-not-released-on-lines:.
|   |-- drivers-net-ethernet-wangxun-libwx-wx_vf_common.c-wx_request_msix_irqs_vf()-warn:why-call-request_threaded_irq()-with-a-NULL-thread
|   `-- fs-bcachefs-fsck.c-lookup_lostfound()-error:uninitialized-symbol-subvolid-.
|-- i386-randconfig-r131-20250807
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- loongarch-allmodconfig
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- loongarch-randconfig-r113-20250807
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   `-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|-- mips-randconfig-r111-20250807
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- powerpc-randconfig-r123-20250807
|   `-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|-- powerpc-randconfig-r133-20250807
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- powerpc64-randconfig-r122-20250807
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- riscv-randconfig-002-20250807
|   |-- ERROR:__ex_table-references-non-executable-section-.data.print_fmt_devres
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.event_devres_log
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_readdir_ra
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_reserved_blocks
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_reserved_segments
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_sb_block_zoned
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_sb_compression
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_sb_encryption
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_sb_flexible_inline_xattr
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_sb_inode_crtime
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_sb_project_quota
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_sb_sb_checksum
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_seq_file_ra_mul
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attr_unusable
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_attrs
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_base_attr_casefold
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_base_attr_encryption
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_base_attr_inode_checksum
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_base_attr_lost_found
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_base_attr_project_quota
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_base_attr_readonly
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_base_attr_sb_checksum
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_base_attr_verity
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_feat_groups
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_kset
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_sb_feat_groups
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_stat_groups
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.local.f2fs_tune_attrs
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.ro.local.f2fs_feat_attr_ops
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.ro.local.f2fs_feat_ktype
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.ro.local.f2fs_feature_list_ktype
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.ro.local.f2fs_ktype
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.ro.local.f2fs_sb_ktype
|   |-- ERROR:__ex_table-references-non-executable-section-.data.rel.ro.local.f2fs_stat_ktype
|   `-- ERROR:__ex_table-references-non-executable-section-.data.rel.ro.local.f2fs_tune_group
|-- um-allmodconfig
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
`-- x86_64-randconfig-161-20250807
    |-- arch-x86-kernel-crash.c-crash_setup_memmap_entries()-warn:we-never-enter-this-loop
    `-- arch-x86-kernel-crash.c-elf_header_exclude_ranges()-warn:we-never-enter-this-loop

elapsed time: 871m

configs tested: 132
configs skipped: 6

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250807    gcc-13.4.0
arc                   randconfig-002-20250807    gcc-12.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                         axm55xx_defconfig    clang-22
arm                                 defconfig    clang-22
arm                      jornada720_defconfig    clang-22
arm                   randconfig-001-20250807    clang-22
arm                   randconfig-002-20250807    gcc-10.5.0
arm                   randconfig-003-20250807    clang-22
arm                   randconfig-004-20250807    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250807    gcc-8.5.0
arm64                 randconfig-002-20250807    gcc-8.5.0
arm64                 randconfig-003-20250807    clang-22
arm64                 randconfig-004-20250807    gcc-14.3.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250807    gcc-15.1.0
csky                  randconfig-002-20250807    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250807    clang-22
hexagon               randconfig-002-20250807    clang-22
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250807    clang-20
i386        buildonly-randconfig-002-20250807    clang-20
i386        buildonly-randconfig-003-20250807    gcc-12
i386        buildonly-randconfig-004-20250807    gcc-11
i386        buildonly-randconfig-005-20250807    gcc-12
i386        buildonly-randconfig-006-20250807    gcc-12
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250807    clang-22
loongarch             randconfig-002-20250807    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                            alldefconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250807    gcc-11.5.0
nios2                 randconfig-002-20250807    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250807    gcc-8.5.0
parisc                randconfig-002-20250807    gcc-11.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                    amigaone_defconfig    gcc-15.1.0
powerpc                       ppc64_defconfig    clang-22
powerpc               randconfig-001-20250807    gcc-12.5.0
powerpc               randconfig-002-20250807    gcc-10.5.0
powerpc               randconfig-003-20250807    gcc-11.5.0
powerpc64             randconfig-001-20250807    gcc-11.5.0
powerpc64             randconfig-002-20250807    clang-22
powerpc64             randconfig-003-20250807    gcc-13.4.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                    nommu_virt_defconfig    clang-22
riscv                 randconfig-001-20250807    gcc-12.5.0
riscv                 randconfig-002-20250807    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250807    clang-22
s390                  randconfig-002-20250807    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250807    gcc-14.3.0
sh                    randconfig-002-20250807    gcc-9.5.0
sh                           se7721_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250807    gcc-14.3.0
sparc                 randconfig-002-20250807    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250807    clang-22
sparc64               randconfig-002-20250807    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250807    gcc-12
um                    randconfig-002-20250807    gcc-11
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250807    clang-20
x86_64      buildonly-randconfig-002-20250807    gcc-12
x86_64      buildonly-randconfig-003-20250807    clang-20
x86_64      buildonly-randconfig-004-20250807    clang-20
x86_64      buildonly-randconfig-005-20250807    gcc-11
x86_64      buildonly-randconfig-006-20250807    gcc-12
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250807    gcc-15.1.0
xtensa                randconfig-002-20250807    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

