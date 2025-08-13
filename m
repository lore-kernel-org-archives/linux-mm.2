Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C42C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 17:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7AC99000BB; Wed, 13 Aug 2025 13:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0485900088; Wed, 13 Aug 2025 13:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7EAF9000BB; Wed, 13 Aug 2025 13:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78863900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:29:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31C1C1A0416
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:29:29 +0000 (UTC)
X-FDA: 83772420858.03.5402510
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id B9BAA100004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:29:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EEWWEFlq;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755106167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=PK145Nnlt2lXWjwmyQPdxrK1ndDIxRXJIRaAG2n5sLg=;
	b=KaHNgZ3iNWxbLsOCGKZFDaQzAbl1Ksv6f25r53fP7CiWpWIkKmu2T18QJWZf/yGjZC97Y5
	FfotePU/SoZC/ewc4hpNfWdzV+zR0TlI51HZThv5ZbipjuNjvVT51p0gGgnbCBZHj0NiS6
	bgCDTdHW8YDzl9vxPJhJ0FQfGn3T3Dw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755106167; a=rsa-sha256;
	cv=none;
	b=rpNboWde6gFbYZpu1/IgNsOvWw7Eru30Jceu4JT1LUHDPcob1vnvg9GLChwIjjLkbiLAo0
	+ByGIdv2qet/DyPiZAFPeeBdGu3WU/mGjfjbyKSwUsG5asAZkGveZnmf+fs5FjT6XpjYGB
	ZAxDFePruNASZtJxM93uJ200lhqM6bE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EEWWEFlq;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755106167; x=1786642167;
  h=date:from:to:cc:subject:message-id;
  bh=8T4UAM4CvaABEzQZ0/ldTeRDVtK6DEf1T3SA9EPZSGw=;
  b=EEWWEFlq1OeIXUG0c12J/0uFNYpMawyC+6cF+6DTncCTApByNlhvfZqf
   NDoXacfqe6B4qB8/oJ6dKef+Hl69P0+oiqoPV9Dl66TNs5hlewQ+djPao
   dM24/jPyw+7bjguRhG9/7eXqsAbpRI9YPzqUgmk7RBeBiUqJWVuVhhwdB
   mbJLrQxPoReh7mMIRftYT3H9Qj0vuhLKLIBNglAAP3tnW5gsEGGZr4iiA
   Hu4oZTRF0yoG6gQn+mHS5NOQ516FGprQNJOF8p7A7mH+cvVUaxlZodl2X
   BFjDzIrPRYWjkuk+UuK3LfDDcabnITEPZWhAwbsLJbrwuKXDXh1KJdz0K
   g==;
X-CSE-ConnectionGUID: Q4uyj/46SDe2cQrmbdR8oQ==
X-CSE-MsgGUID: ZU8sruzKQs6RntlC89CwGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="74862970"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="74862970"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 10:29:25 -0700
X-CSE-ConnectionGUID: avZTPQdmTj+M+479ChfNkg==
X-CSE-MsgGUID: 1QY/Mq+8QuC2PkRv2JQgUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="197386157"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 13 Aug 2025 10:29:23 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umFHs-000AAG-2M;
	Wed, 13 Aug 2025 17:29:20 +0000
Date: Thu, 14 Aug 2025 01:28:53 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 43c3c17f0c805882d1b48818b1085747a68c80ec
Message-ID: <202508140157.FeIUbclq-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B9BAA100004
X-Stat-Signature: jjqg3wx3ajf53dfjbre48yjf9jgk7mrc
X-Rspam-User: 
X-HE-Tag: 1755106166-943425
X-HE-Meta: U2FsdGVkX1+wohNlcymyW8pTnOYbBeg5qep4LEx2+cZzwxkf2mFqwCV4u46boECmY7Xd+Hbx+HqHLEeh2AEBGzEv2g+OEC2Qz7kLM1nWiBG3iNA+knhjCQxrIt5wE1rYpDnLrJCDuIM0eSST4syp4vN/G+5yzmAHNEysefFGH5ECCJsB8EkZDlOtlG46uawJUIxystkxlHvNMDxiRE49XUkzRuKuauTncfvKM0ZkdcF6daigTD5hrijX2Kyl8Q8Jf5KPeYDBCOgXxFq9KoHYE48ymgzvBq4yU3tINLw/QqpBKzK/YJ9ls2OnGv3se1D/bcBvU5mQUKEDMU4RWsrbK3i1vOTFV87IPYrVzPcsRhEo4B5MWHjye/q88Y0kjW/xUjA+jPQRWhnDDCrK88OdlB8XZxGUjoKYf8FaCWsgBYyTACg/H/HiwJzknDU/1OBIYRMc1pQjcfudA1hACzjiCjMcSglAQggnjyvYnz5khrkyirWBXY0rxo2/oUZQEqSq5lQfIBvAkYBdIXkK7cEUSEBmG5WnYy2KlI3zHZcltZMLnUKlSyqSUuRpZNSzRUAS6rtMBjXLp88p9+hcDAW7GX5mXe6yyKQn1QtFTLWbsKZetudHG9KArc3+1ZG3nB7XrzQd3IySd/eWoczsSze2bvXJNglwQX8mn4E/j4YzUnhglccV/7JmZHNAmuryT2LmyvsjFXyiSheWfQjEFsXP5NdvHx56FbA1ceZ5qM7cB8nC1CasMuZ2ZHDjvsJnk/eMzQ4swkfD3l/THCx2FtdG4DMMvHWW4Szd/+DQ1FyPCu5TABRrf2LgTQWMOmeYy1OUmvyLlZwY3F8i/p4BD1HLlL1TgsYxYu0/p+uOQRVAFxKSjeatozPUubCaa9WV535ePA64hnj/4XF6TtC4vDT928AasYz45z7qM7cP6BaSUSCwN2FwqdA8zVx6X7tRVRsQHSsrRtEHxMhXEFzol8R
 b0FodnOI
 AHQfzPwKHWIy7fBbXsi5EPwHWXhtcZ/R5Schc6JXnJfPMYwuLhDO1ARAmu0B7BPkBdElEAC3D37DMawJ2o79gDcsNqxBXj0XU+Pfs5ufv3qUGb7lKM6fsyr5ER34Pua9SrkWkUrskA/Y8X/jQFjJ9vtYrOssLfhrRtNv6uXxOAGo4iNdAeJm8TeY6BQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 43c3c17f0c805882d1b48818b1085747a68c80ec  Add linux-next specific files for 20250813

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202507142044.IrnmDHo3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507180503.nfyD9uRv-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507212020.72nw9OIi-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220802.0Iz9U37j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220927.C6zNUJt7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507271211.hvhQM36m-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508121500.RvXjS54z-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508122300.QreDWTZr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508131428.tYcAx1Pp-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508131441.o27616Pa-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508131651.BZD3v2Bq-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508132051.a7hJXkrd-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508132158.dEwQdick-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508140029.V6tDuUxc-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507301209.hFc4VENm-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508061925.bEevCphN-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508131953.HDaThIjM-lkp@intel.com

    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.ko] undefined!
    alpha-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data.rel+0xe0): undefined reference to `stmmac_simple_pm_ops'
    alpha-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data.rel+0xe0): undefined reference to `stmmac_simple_pm_ops'
    arch/arm/boot/dts/nvidia/tegra30-asus-p1801-t.dtb: pmic@2d (ti,tps65911): 'pmic-sleep-hog', 'wakeup-source' do not match any of the regexes: '^(vcc(io|[1-7])-supply)$', '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nvidia/tegra30-asus-p1801-t.dtb: pmic@2d (ti,tps65911): regulators:vddctrl: Unevaluated properties are not allowed ('nvidia,tegra-cpu-regulator' was unexpected)
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
    arch/arm64/boot/dts/rockchip/rk3582-radxa-e52c.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3582-radxa-e52c.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3582-radxa-e52c.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-armsom-sige7.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-armsom-sige7.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-armsom-sige7.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-armsom-w3.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-armsom-w3.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-armsom-w3.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-evb.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-evb.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-evb.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-genbook.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-genbook.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-genbook.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6a-io.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6a-io.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6a-io.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6a-wifi.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6a-wifi.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6a-wifi.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6b-io.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6b-io.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6b-io.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6b-wifi.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6b-wifi.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-edgeble-neu6b-wifi.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-evb1-v10.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-evb1-v10.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-evb1-v10.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-evb2-v10.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-evb2-v10.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-evb2-v10.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-firefly-itx-3588j.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-firefly-itx-3588j.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-firefly-itx-3588j.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-friendlyelec-cm3588-nas.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-friendlyelec-cm3588-nas.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-friendlyelec-cm3588-nas.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-h96-max-v58.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-h96-max-v58.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-h96-max-v58.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-ethernet-switch.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-ethernet-switch.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-ethernet-switch.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-pre-ict-tester.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-pre-ict-tester.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-pre-ict-tester.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-jaguar.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-jaguar.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-jaguar.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-mnt-reform2.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-mnt-reform2.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-mnt-reform2.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-nanopc-t6-lts.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-nanopc-t6-lts.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-nanopc-t6-lts.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-nanopc-t6.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-nanopc-t6.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-nanopc-t6.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-ok3588-c.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-ok3588-c.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-ok3588-c.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-max.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-max.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-max.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-ultra.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-ultra.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-ultra.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-quartzpro64.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-quartzpro64.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-quartzpro64.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5-itx.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5-itx.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5-itx.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b-pcie-ep.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b-pcie-ep.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b-pcie-ep.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b-pcie-srns.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b-pcie-srns.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b-pcie-srns.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b-plus.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b-plus.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b-plus.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5t.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5t.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-rock-5t.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-tiger-haikou-haikou-video-demo.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-tiger-haikou-haikou-video-demo.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-tiger-haikou-haikou-video-demo.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-tiger-haikou.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-tiger-haikou.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-tiger-haikou.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-toybrick-x0.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-toybrick-x0.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-toybrick-x0.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-evb1-v10.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-evb1-v10.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-evb1-v10.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-khadas-edge2.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-khadas-edge2.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-khadas-edge2.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6c.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6c.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6c.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6s.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6s.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6s.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-odroid-m2.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-odroid-m2.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-odroid-m2.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5b.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5b.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5b.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-roc-pc.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-roc-pc.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-roc-pc.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-rock-5c.dtb: /npu@fdab0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-rock-5c.dtb: /npu@fdac0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    arch/arm64/boot/dts/rockchip/rk3588s-rock-5c.dtb: /npu@fdad0000: failed to match any schema with compatible: ['rockchip,rk3588-rknn-core']
    fs/smb/client/cifs_debug.h:15:21: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
    fs/smb/client/smb2ops.c:778:16: warning: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_GPUCC_615
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_VIDEOCC_615
    kismet: WARNING: unmet direct dependencies detected for SM_GCC_6350 when selected by SM_VIDEOCC_6350
    ld.lld: error: undefined symbol: stmmac_simple_pm_ops
    sound/hda/codecs/ca0132.c:4222:2: error: expected expression
    sound/hda/codecs/ca0132.c:4247:2: error: expected expression
    sound/hda/core/stream.c:954:2: error: expected expression
    sound/hda/core/stream.c:954:2: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]

Unverified Error/Warning (likely false positive, kindly check if interested):

    (.head.text+0x0): relocation truncated to fit: R_MIPS_26 against `kernel_entry'
    (.ref.text+0xd8): relocation truncated to fit: R_MIPS_26 against `start_secondary'
    arch/mips/boot/dts/mti/sead3.dts:69.17-91.4: Warning (avoid_unnecessary_addr_size): /flash@1c000000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    clang: error: clang frontend command failed with exit code 139 (use -v to see invocation)
    drivers/gpu/drm/xe/xe_pt.c:2487 xe_pt_update_ops_run() error: uninitialized symbol 'ifence'.
    drivers/gpu/drm/xe/xe_pt.c:2492 xe_pt_update_ops_run() error: uninitialized symbol 'mfence'.
    include/linux/iov_iter.h:190 iterate_folioq() error: uninitialized symbol 'remain'.
    sound/hda/codecs/ca0132.c:4222:2: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   |-- alpha-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.o:(.data.rel):undefined-reference-to-stmmac_simple_pm_ops
|   `-- alpha-linux-ld:drivers-net-ethernet-stmicro-stmmac-stmmac_pci.o:(.data.rel):undefined-reference-to-stmmac_simple_pm_ops
|-- arc-allmodconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- arc-allyesconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- arm-allmodconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- arm-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_GPUCC_615
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_VIDEOCC_615
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-SM_GCC_6350-when-selected-by-SM_VIDEOCC_6350
|-- arm-allyesconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- arm-randconfig-004-20250813
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- arm-randconfig-051-20250813
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-052-20250813
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-053-20250813
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-054-20250813
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-055-20250813
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm64-allmodconfig
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
|   |-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
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
|-- arm64-randconfig-002-20250813
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm6150.dtsi.-.:Warning-(interrupt_map):soc-pcie-1c08000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-003-20250813
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm6150.dtsi.-.:Warning-(interrupt_map):soc-pcie-1c08000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- arm64-randconfig-004-20250813
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm6150.dtsi.-.:Warning-(interrupt_map):soc-pcie-1c08000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- ld.lld:error:undefined-symbol:stmmac_simple_pm_ops
|-- arm64-randconfig-051-20250813
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
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   `-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|-- arm64-randconfig-052-20250813
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
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   `-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|-- arm64-randconfig-053-20250813
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
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   `-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|-- arm64-randconfig-054-20250813
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
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   `-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|-- arm64-randconfig-055-20250813
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
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3582-radxa-e52c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-sige7.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-armsom-w3.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-evb.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-coolpi-cm5-genbook.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-io.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6a-wifi.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-io.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-edgeble-neu6b-wifi.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb1-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-evb2-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-firefly-itx-3588j.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-friendlyelec-cm3588-nas.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-h96-max-v58.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-pre-ict-tester.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-mnt-reform2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6-lts.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-nanopc-t6.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-ok3588-c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-max.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-plus.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-orangepi-ultra.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-quartzpro64.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-ep.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-pcie-srns.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b-plus.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-5t.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-rock-itx.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou-haikou-video-demo.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-tiger-haikou.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-toybrick-x0.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588-turing-rk1.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-coolpi-4b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-evb1-v10.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-gameforce-ace.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-indiedroid-nova.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-khadas-edge2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-nanopi-r6s.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-odroid-m2.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-orangepi-5b.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-roc-pc.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5a.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdab0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdac0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   `-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|-- hexagon-allmodconfig
|   |-- sound-hda-codecs-ca0132.c:error:expected-expression
|   `-- sound-hda-core-stream.c:error:expected-expression
|-- hexagon-allyesconfig
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- i386-allmodconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- i386-allyesconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- i386-randconfig-052-20250813
|   `-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- i386-randconfig-053-20250813
|   `-- fs-smb-client-smb2ops.c:warning:format-specifies-type-unsigned-long-but-the-argument-has-type-size_t-(aka-unsigned-int-)
|-- i386-randconfig-061-20250813
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-062-20250813
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- fs-smb-client-smb2ops.c:warning:format-specifies-type-unsigned-long-but-the-argument-has-type-size_t-(aka-unsigned-int-)
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-063-20250813
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-141-20250813
|   |-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-ifence-.
|   `-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-mfence-.
|-- loongarch-allmodconfig
|   |-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- loongarch-allyesconfig
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- loongarch-randconfig-002-20250813
|   `-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.ko-undefined
|-- m68k-allmodconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- m68k-allyesconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- microblaze-allmodconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- microblaze-allyesconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|   |-- arch-mips-boot-dts-mti-sead3.dts.-.:Warning-(avoid_unnecessary_addr_size):flash-1c000000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- openrisc-allyesconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- parisc-allmodconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- parisc-allyesconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- powerpc-allyesconfig
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- powerpc-randconfig-001-20250813
|   `-- fs-smb-client-smb2ops.c:warning:format-specifies-type-unsigned-long-but-the-argument-has-type-size_t-(aka-unsigned-int-)
|-- powerpc-randconfig-002-20250813
|   `-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- riscv-allmodconfig
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- riscv-allyesconfig
|   |-- sound-hda-codecs-ca0132.c:error:expected-expression
|   `-- sound-hda-core-stream.c:error:expected-expression
|-- s390-allmodconfig
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- sh-allmodconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- sh-allyesconfig
|   `-- fs-smb-client-cifs_debug.h:warning:format-lu-expects-argument-of-type-long-unsigned-int-but-argument-has-type-size_t-aka-unsigned-int
|-- um-allmodconfig
|   |-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- x86_64-allyesconfig
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- x86_64-randconfig-101-20250813
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- x86_64-randconfig-104-20250813
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|-- x86_64-randconfig-121-20250813
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- x86_64-randconfig-122-20250813
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- x86_64-randconfig-123-20250813
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- x86_64-randconfig-161-20250813
|   |-- include-linux-iov_iter.h-iterate_folioq()-error:uninitialized-symbol-remain-.
|   |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
|   `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
`-- x86_64-rhel-9.4-rust
    |-- sound-hda-codecs-ca0132.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions
    `-- sound-hda-core-stream.c:warning:label-followed-by-a-declaration-is-a-C23-extension-Wc23-extensions

elapsed time: 732m

configs tested: 129
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250813    gcc-11.5.0
arc                   randconfig-002-20250813    gcc-8.5.0
arc                           tb10x_defconfig    gcc-15.1.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20250813    clang-22
arm                   randconfig-002-20250813    gcc-8.5.0
arm                   randconfig-003-20250813    clang-22
arm                   randconfig-004-20250813    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250813    clang-22
arm64                 randconfig-002-20250813    gcc-12.5.0
arm64                 randconfig-003-20250813    clang-22
arm64                 randconfig-004-20250813    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250813    gcc-14.3.0
csky                  randconfig-002-20250813    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250813    clang-22
hexagon               randconfig-002-20250813    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250813    gcc-11
i386        buildonly-randconfig-002-20250813    clang-20
i386        buildonly-randconfig-003-20250813    gcc-11
i386        buildonly-randconfig-004-20250813    clang-20
i386        buildonly-randconfig-005-20250813    gcc-12
i386        buildonly-randconfig-006-20250813    gcc-12
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250813    clang-19
loongarch             randconfig-002-20250813    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                           ip22_defconfig    gcc-15.1.0
mips                           mtx1_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250813    gcc-11.5.0
nios2                 randconfig-002-20250813    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250813    gcc-14.3.0
parisc                randconfig-002-20250813    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                     ksi8560_defconfig    gcc-15.1.0
powerpc                       ppc64_defconfig    clang-22
powerpc               randconfig-001-20250813    clang-18
powerpc               randconfig-002-20250813    clang-22
powerpc               randconfig-003-20250813    clang-20
powerpc64             randconfig-001-20250813    clang-22
powerpc64             randconfig-002-20250813    gcc-8.5.0
powerpc64             randconfig-003-20250813    clang-17
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250813    clang-22
riscv                 randconfig-002-20250813    gcc-14.3.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250813    clang-22
s390                  randconfig-002-20250813    clang-18
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                     magicpanelr2_defconfig    gcc-15.1.0
sh                    randconfig-001-20250813    gcc-9.5.0
sh                    randconfig-002-20250813    gcc-9.5.0
sh                        sh7785lcr_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250813    gcc-8.5.0
sparc                 randconfig-002-20250813    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250813    gcc-8.5.0
sparc64               randconfig-002-20250813    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250813    gcc-12
um                    randconfig-002-20250813    gcc-11
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250813    gcc-10.5.0
xtensa                randconfig-002-20250813    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

