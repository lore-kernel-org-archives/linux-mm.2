Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35796CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 19:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607528E0001; Thu, 21 Aug 2025 15:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8666B0111; Thu, 21 Aug 2025 15:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A75A8E0001; Thu, 21 Aug 2025 15:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30FE46B0110
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:36:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D80A7C0552
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:36:16 +0000 (UTC)
X-FDA: 83801770752.21.4DBD57A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7521040011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:36:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MCdjMAmY;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755804975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/nttXUrZOugrHj0Q2QT2N4BiLdE3etTtCUKnxynWWpQ=;
	b=VYj6mX90Nk2Loq45O4/qAEsN46rxxk/c2AYPqXIwBpFGmMIaxzVeNlp2MvyuyVD87G76Dj
	pGK4XZgCk9rFHHrvqpVi7VL7AzD33aZnLQHE+9Fa2l7TxyHNEzi7vNQJOsHsma/A6C0vPQ
	RrRgP0noCxz4AjuV4aldX1WvjMHoSB4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MCdjMAmY;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755804975; a=rsa-sha256;
	cv=none;
	b=NMBAtEAMWX7W8ZfE4eyzvX7WPHJAvi+zHHV0umjAby3TzbQKMzcB3ZWuzYb9CJNLptfcri
	IvKQesxMBAL0PQu2gE908qhP5nerWQfqLO+zyjmiXD6XYH3zwCBagGLmCPFigdBHoR7xqA
	MSdghFLLY14rbEEvrJKV/Ic3xprzhfc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755804975; x=1787340975;
  h=date:from:to:cc:subject:message-id;
  bh=/vOAvxTru7vE/k+C5DJ73ap2KpSoAF6fAx1xb1P6+4g=;
  b=MCdjMAmY+P79gUt8ixGGycPYtP+4GADl/rtH6IB1PP8bJuqxCbDS+dBU
   0IOilVDMR9hO4Edop4TCVK8B9uah8wfWGS2v9XFyOn0K7bnGG32vFVGdL
   sVNccr5U4HDjJ0TSY9/BVnJqOsSA4/6QfZmtjVyMUCDJZk9p+HHiWYCDq
   +eLZ6HQi4+52/EbOnT36AUWibie42gD62hWqmHXW7ACa7zHpGtZAi/DY9
   yvshpCUgNmyOuBaJtPa84Hf6/ObPKAsKuMsLTD2K5c5RF3UzV43f8V2V5
   QHd2tw+hFqqt6Xfctwh+tjATzQ0XtHaxGQGgDnMhlKbm+roUtqz2mD8Jm
   w==;
X-CSE-ConnectionGUID: yGd1Ys3WRs6OBqRaCJtcpA==
X-CSE-MsgGUID: MYysv/b0Tu+5vqalFm6gLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="75564404"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="75564404"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 12:36:13 -0700
X-CSE-ConnectionGUID: ZrmhyInNQN60apBd8+r90g==
X-CSE-MsgGUID: Kex/QuU6Qx6phos5GS8tMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="173772628"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 21 Aug 2025 12:36:11 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1upB4z-000Kc3-0E;
	Thu, 21 Aug 2025 19:36:09 +0000
Date: Fri, 22 Aug 2025 03:36:01 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 7fa4d8dc380fbd81a9d702a855c50690c9c6442c
Message-ID: <202508220339.9YjbxTJL-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Queue-Id: 7521040011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 15xo6we8wf8g54jact73wo8knxpm5ghq
X-HE-Tag: 1755804974-184483
X-HE-Meta: U2FsdGVkX18c/v7vTFIZU/C4HCrt7I0meeJVL1eeQJZpjL5OoAWbZVgLwXIS9CLQj/KSPkuNGCCvwRgUnmIvDZQmbej8aiwQA8H3iFzZaezII/KS6rn2O0s5uOv03V5lMo1u57D95d2c5taTAoHWKgKzRU+z9K/ZvvFNtQlSEC07MUxUKktcXEYdcagjVk9jYvxPnJfr7owbtiq6ytKRdmGT7CZKAnHermccMyDqkpq0dUaHP8Sl5482Plt+znGPZSp/dz6iVwMLNeDQrZ8D0I/bOsAKxU7O7bAvKzk89xOHzksa1N+BKqi7yzws84JvW5LszgzeMM/cxNvyvnD9qFQ8m64L9feofzMFs0hoQF4sn4ROUVHwJyKQkfe1VYpSatwjiNxwE1532QmvKd9d82dVhyLUeZqSFMxsuooHso9a/FWFTBhcxl5flGBQl6EXYievEyyUs7WquAcufheD1g5gGhEp56YSUirZmzOfnan2OSmldhRnbEV5l+ajgYD//6uL5todeyNsKB8+0b+Z/R8+HpXTAnp5kqWRdlA/eeGnV6iRJJsbi3hVf/vIh8hDBS9sUy5XEkdr9mfMuaQ+aeek74gdGephNHN+skHfXCUrzqEFdAZMbpN2tDJBM8kCLlanXbMZt8rhgPqUAIs4//aHCsjQhaQGm49yKkLa+7nUve0ok/W91o/GxmeqJ2FCkbG74VBJjyp8sTPhx8aDHxdC/zwBi56whg0Hb67r65wmxYZaC9UJCUcy7zxB8j+R0EY9LWbn5OGYAsDJlY308hvvKGcXB/kijuvkhJFMyW5pSxPc49pbeHVNL6GA7QUZKN9OFg3uIT3lgR8X0bOBZKA0jCE14L67yfCqP9OvbALy8ZBw4lT+gqGxD485X/RPfgBOqvs3eaLZnypYXhQdGUGEDghFFwpx7ltN/maFEPphPyGcSthXfYhPeGPEg/a2oL7Z58CDW0c4U63XVrZ
 hhCnu2gX
 Vk+C30PXe18T2n6f64wwqLeS4bqr6vIUI1UShnDUGR+Pvyb1ECMDXvowRLPNhqiycgnoe/yDpGOt/8fvtZot3xa5Ayg0CB16wurvidWF+2l0M8Kd+vyO3AEmu103BJ9T5965261JV+t4Z8sLDKufuru+qaOTo+FhRR9MDRsbPPjkZzIA7ctaRhb5ZLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 7fa4d8dc380fbd81a9d702a855c50690c9c6442c  Add linux-next specific files for 20250821

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202508121500.RvXjS54z-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508122300.QreDWTZr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508132051.a7hJXkrd-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508132158.dEwQdick-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508140029.V6tDuUxc-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508141518.uFdkyMsT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508211706.DnJPQQMn-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508211859.UoYsJbLN-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508212031.ir9b3B6Q-lkp@intel.com

    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-rk.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/stmmac-pci.ko] undefined!
    Warning: fs/ceph/mds_client.c:2704 function parameter 'path_info' not described in 'ceph_mdsc_build_path'
    alpha-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data.rel+0xe0): undefined reference to `stmmac_simple_pm_ops'
    alpha-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data.rel+0xa0): undefined reference to `stmmac_simple_pm_ops'
    alpha-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.o:(.data.rel+0xa0): undefined reference to `stmmac_simple_pm_ops'
    alpha-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data.rel+0xe0): undefined reference to `stmmac_simple_pm_ops'
    arch/arm64/boot/dts/nvidia/tegra186.dtsi:1355.3-41: Warning (interrupt_map): /pcie@10003000:interrupt-map: Missing property '#address-cells' in node /interrupt-controller@3881000, using 0 as fallback
    arch/arm64/boot/dts/nvidia/tegra194.dtsi:2391.4-42: Warning (interrupt_map): /bus@0/pcie@14100000:interrupt-map: Missing property '#address-cells' in node /bus@0/interrupt-controller@3881000, using 0 as fallback
    arch/arm64/boot/dts/nvidia/tegra194.dtsi:2734.4-42: Warning (interrupt_map): /bus@0/pcie@141a0000:interrupt-map: Missing property '#address-cells' in node /bus@0/interrupt-controller@3881000, using 0 as fallback
    arch/arm64/boot/dts/qcom/lemans.dtsi:4497.28-4558.6: Warning (avoid_unnecessary_addr_size): /soc@0/display-subsystem@ae00000/dsi@ae94000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/lemans.dtsi:4579.28-4631.6: Warning (avoid_unnecessary_addr_size): /soc@0/display-subsystem@ae00000/dsi@ae96000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/lemans.dtsi:7623.3-7626.29: Warning (interrupt_map): /pcie@1c00000:interrupt-map: Missing property '#address-cells' in node /soc@0/interrupt-controller@17a00000, using 0 as fallback
    arch/arm64/boot/dts/qcom/lemans.dtsi:7793.3-7796.29: Warning (interrupt_map): /pcie@1c10000:interrupt-map: Missing property '#address-cells' in node /soc@0/interrupt-controller@17a00000, using 0 as fallback
    arch/arm64/boot/dts/qcom/sm6150.dtsi:1122.4-1125.30: Warning (interrupt_map): /soc@0/pcie@1c08000:interrupt-map: Missing property '#address-cells' in node /soc@0/interrupt-controller@17a00000, using 0 as fallback
    arch/arm64/boot/dts/qcom/sm8550.dtsi:4087.22-4177.5: Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/sm8650.dtsi:5048.22-5139.5: Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    drivers/infiniband/hw/mlx5/mr.c:840:31: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data+0x1ac): undefined reference to `stmmac_simple_pm_ops'
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data+0x150): undefined reference to `stmmac_simple_pm_ops'
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.o:(.data+0xd0): undefined reference to `stmmac_simple_pm_ops'
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data+0x124): undefined reference to `stmmac_simple_pm_ops'
    kernel/bpf/helpers.c:1784:17: warning: argument 2 null where non-null expected because argument 3 is nonzero [-Wnonnull]
    ld.lld: error: undefined symbol: stmmac_simple_pm_ops
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data+0x54): undefined reference to `stmmac_simple_pm_ops'
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.o:(.data+0x54): undefined reference to `stmmac_simple_pm_ops'
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'
    s390-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data.rel+0xe0): undefined reference to `stmmac_simple_pm_ops'

Unverified Error/Warning (likely false positive, kindly check if interested):

    (.head.text+0x900): relocation truncated to fit: R_OR1K_INSN_REL_26 against `no symbol'
    (.init.text+0x21bc): relocation truncated to fit: R_OR1K_INSN_REL_26 against `no symbol'
    or1k-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'
    or1k-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data+0x54): undefined reference to `stmmac_simple_pm_ops'
    or1k-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.o:(.data+0x54): undefined reference to `stmmac_simple_pm_ops'
    or1k-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- alpha-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.o:(.data.rel):undefined-reference-to-stmmac_simple_pm_ops
|   |-- alpha-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-rk.o:(.data.rel):undefined-reference-to-stmmac_simple_pm_ops
|   |-- alpha-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-stm32.o:(.data.rel):undefined-reference-to-stmmac_simple_pm_ops
|   `-- alpha-linux-ld:drivers-net-ethernet-stmicro-stmmac-stmmac_pci.o:(.data.rel):undefined-reference-to-stmmac_simple_pm_ops
|-- arc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-randconfig-r123-20250821
|   `-- mm-zswap.c:sparse:sparse:symbol-zswap_stored_incompressible_pages-was-not-declared.-Should-it-be-static
|-- arm-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arm-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arm-randconfig-004-20250821
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arm64-allmodconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm6150.dtsi.-.:Warning-(interrupt_map):soc-pcie-1c08000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- arm64-defconfig
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm6150.dtsi.-.:Warning-(interrupt_map):soc-pcie-1c08000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-002-20250821
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm6150.dtsi.-.:Warning-(interrupt_map):soc-pcie-1c08000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-003-20250821
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm6150.dtsi.-.:Warning-(interrupt_map):soc-pcie-1c08000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-004-20250821
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm6150.dtsi.-.:Warning-(interrupt_map):soc-pcie-1c08000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- hexagon-allmodconfig
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-rk.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-stm32.ko-undefined
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- hexagon-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- ld.lld:error:undefined-symbol:stmmac_simple_pm_ops
|-- i386-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- loongarch-allmodconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- loongarch-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- loongarch-defconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- m68k-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- m68k-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- microblaze-allmodconfig
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-rk.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-stm32.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-stmmac-pci.ko-undefined
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- microblaze-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- microblaze-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|   |-- microblaze-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-rk.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|   |-- microblaze-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-stm32.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|   `-- microblaze-linux-ld:drivers-net-ethernet-stmicro-stmmac-stmmac_pci.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|-- openrisc-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_OR1K_INSN_REL_26-against-no-symbol
|   |-- (.init.text):relocation-truncated-to-fit:R_OR1K_INSN_REL_26-against-no-symbol
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- or1k-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|   |-- or1k-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-rk.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|   |-- or1k-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-stm32.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|   `-- or1k-linux-ld:drivers-net-ethernet-stmicro-stmmac-stmmac_pci.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|-- parisc-allmodconfig
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-rk.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-stm32.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-stmmac-pci.ko-undefined
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- parisc-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- hppa-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|   |-- hppa-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-rk.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|   |-- hppa-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-stm32.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|   `-- hppa-linux-ld:drivers-net-ethernet-stmicro-stmmac-stmmac_pci.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|-- powerpc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc-randconfig-r064-20250821
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- riscv-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- riscv-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- s390-allmodconfig
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-rk.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-stm32.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-stmmac-pci.ko-undefined
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- s390-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- drivers-infiniband-hw-mlx5-mr.c:warning:sprintf-may-write-a-terminating-nul-past-the-end-of-the-destination
|   `-- s390-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.o:(.data.rel):undefined-reference-to-stmmac_simple_pm_ops
|-- s390-randconfig-001-20250821
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sh-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sh-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sh-randconfig-002-20250821
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc-randconfig-r063-20250821
|   `-- kernel-bpf-helpers.c:warning:argument-null-where-non-null-expected-because-argument-is-nonzero
|-- um-allmodconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- um-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- um-randconfig-002-20250821
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- x86_64-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- x86_64-randconfig-r121-20250821
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
`-- x86_64-rhel-9.4-rust
    `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path

elapsed time: 728m

configs tested: 135
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                         haps_hs_defconfig    gcc-15.1.0
arc                   randconfig-001-20250821    gcc-9.5.0
arc                   randconfig-002-20250821    gcc-13.4.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20250821    gcc-13.4.0
arm                   randconfig-002-20250821    clang-22
arm                   randconfig-003-20250821    clang-22
arm                   randconfig-004-20250821    clang-22
arm                           u8500_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250821    clang-22
arm64                 randconfig-002-20250821    clang-22
arm64                 randconfig-003-20250821    gcc-11.5.0
arm64                 randconfig-004-20250821    gcc-13.4.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250821    gcc-13.4.0
csky                  randconfig-002-20250821    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250821    clang-20
hexagon               randconfig-002-20250821    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250821    gcc-12
i386        buildonly-randconfig-002-20250821    gcc-12
i386        buildonly-randconfig-003-20250821    clang-20
i386        buildonly-randconfig-004-20250821    gcc-12
i386        buildonly-randconfig-005-20250821    gcc-12
i386        buildonly-randconfig-006-20250821    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250821    gcc-14.3.0
loongarch             randconfig-002-20250821    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                        mvme16x_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250821    gcc-9.5.0
nios2                 randconfig-002-20250821    gcc-10.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250821    gcc-12.5.0
parisc                randconfig-002-20250821    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                    mvme5100_defconfig    gcc-15.1.0
powerpc                         ps3_defconfig    gcc-15.1.0
powerpc               randconfig-001-20250821    clang-17
powerpc               randconfig-002-20250821    clang-22
powerpc               randconfig-003-20250821    gcc-9.5.0
powerpc                     skiroot_defconfig    clang-22
powerpc64             randconfig-002-20250821    clang-22
powerpc64             randconfig-003-20250821    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250821    clang-17
riscv                 randconfig-002-20250821    gcc-9.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250821    gcc-14.3.0
s390                  randconfig-002-20250821    clang-18
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250821    gcc-15.1.0
sh                    randconfig-002-20250821    gcc-13.4.0
sh                     sh7710voipgw_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250821    gcc-14.3.0
sparc                 randconfig-002-20250821    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250821    gcc-8.5.0
sparc64               randconfig-002-20250821    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250821    clang-19
um                    randconfig-002-20250821    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250821    clang-20
x86_64      buildonly-randconfig-002-20250821    clang-20
x86_64      buildonly-randconfig-003-20250821    clang-20
x86_64      buildonly-randconfig-004-20250821    gcc-12
x86_64      buildonly-randconfig-005-20250821    clang-20
x86_64      buildonly-randconfig-006-20250821    clang-20
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                generic_kc705_defconfig    gcc-15.1.0
xtensa                randconfig-001-20250821    gcc-11.5.0
xtensa                randconfig-002-20250821    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

