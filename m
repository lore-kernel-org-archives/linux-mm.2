Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB58CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 19:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6039F9001CB; Thu, 14 Aug 2025 15:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4C7900172; Thu, 14 Aug 2025 15:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36AE69001CB; Thu, 14 Aug 2025 15:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D00C900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:08:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85DAD14074D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:08:23 +0000 (UTC)
X-FDA: 83776298886.09.0A33812
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id 52F86140007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:08:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kzMf3Kzi;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755198501; a=rsa-sha256;
	cv=none;
	b=lrTWLW9bblwm+0KLCI8IRxTa4gIaMOeN69setxH2sImKXl3HEnvPD/1Kud9qRaQgwvfbr7
	VyJJrk5E9RMrv0iJAqPkohMBTmTiRuPXXqD7SUkCPuXEKcMHFEMv0fbk6E/xBWDBaHy9Qq
	r2UuBgfgzCqk1isp7FuF6zcUDPWVyHU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kzMf3Kzi;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755198501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=hq+8mZ2PWm8FAXTEmuXASUvbwe75WIEoVVUAuZj9Id0=;
	b=tTwn4pnAS5IaOpm+2zyztdJDYaMGNYDs295R+FfcpPiqFLCKwOlPYVbj8BiPW7CKl7WBXm
	vZhyxJG4MbXSaAhxtkDqahw/O6vCggiPS3GqBS+fUqJbciPAx9U11+x2JkqdvdMAb7DCqU
	zIspFrnS8tHS+xCQbEjGMVXCLf4s41s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755198501; x=1786734501;
  h=date:from:to:cc:subject:message-id;
  bh=BJqLeseZYwyVzoe4qtp/CPDQN2DOVCn9zO1H9DIqXOU=;
  b=kzMf3Kzir8B04KeVOE622tozgSGTZFdgDWI0ZFWeqGI7oWNKUcDdQt0T
   cKdeQuMgoDHeq66pmugRzuKhaWqTPJlfqdBL1C49pa8Lfd/J9zVG93D1F
   2kXlF8/9wFPsKdImc08Hg5XupTK8Dkku2ffpIdTHKv0phgyckgWsk+g8M
   8c8pGnb0EsvNUi7z1kU9sPx/gI9GGeZ+9uyAPoGyZj1jno/er/P6gmto+
   uJyJfWnnKoyufyo4/brh2sInbccvPh1UBU9Z2GJN6kuE8HhguLKIGVZJC
   /umeihL2c4kAPGcl9weh6vv1xdfL55u0najrVLXkC79+DELB0fJnf7T/s
   w==;
X-CSE-ConnectionGUID: 9b0cAFa5SS+jnNuK4ZwFeA==
X-CSE-MsgGUID: AOAWSPK4RUuTLPcEDx+gQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57671562"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57671562"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 12:08:19 -0700
X-CSE-ConnectionGUID: rvKzdhiUQK+sgv+s8IPH0g==
X-CSE-MsgGUID: Mt9J2uVHT/6oEiBWl780dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="197680580"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 14 Aug 2025 12:08:17 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umdJ8-000BGO-36;
	Thu, 14 Aug 2025 19:08:14 +0000
Date: Fri, 15 Aug 2025 03:07:58 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 931e46dcbc7e6035a90e9c4a27a84b660e083f0a
Message-ID: <202508150329.eXbKqdy2-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 52F86140007
X-Stat-Signature: qo558b13ofcoqahm6giwb4adt3rh7acs
X-Rspam-User: 
X-HE-Tag: 1755198500-925009
X-HE-Meta: U2FsdGVkX1+ky5DNCDunXg1JCYAx1CESG3eUWxj/mXmIznCe/b6D0mbh6eDEIyyCkfx1fG3uAvQyFbtHp7yv1krSlx+ev+Xn5xzjEgkdviIGXKhcikqD7JGHyZKvdPqLWkJuFF1fqAIXZuTlj+kUKTwZtb1vD8HWB26NBHDWqWOviI4tcFnbECRPjzwzXRQcu8m/7cXMGI0cVxhInLnRvJCz6LW2Ynafesadx3/M/0OLRABy9hV+4zzY3fS7t55pbKehm06xO/184I1H2pe96qOWAP+mU0UQX86mTzLVUDw5ejWbwArSHi5iHlbUmhDICkA5uXUDrZGYFTWRIO7lRSOMHLW3XOMmTmDdaH5xvGTCHaunVfTrsO0qTJO5Ed6YLnJxfr6ZAFX2Yey7/LcJw7JihKFfSnrnJegNzirvCbG5OfkYxXBd8Gtpy+M9V9HY/PwJdh/mDJEKMiZkBqeOcPd90ojBVYA1uAeOxYML2IAvUfJCFUJttFPxRZBJ5NTHTKYc0AaA2bVwZemWJcOKD/ldlcv0YplYba8ScEOiXTloYB6r4ezBxcvFour1hUL51Oto6YIT+eZ/oRJ5aF+1OAz1ZQqcSodsw6ymAxVbx9ft6nEDSwcCVZftlqSiKNIvx7aT4vF72fK8aOH13HNNIq0Cu9nn1skooTXJM339cq17oJPcg8XFARY5UKJJ4D2CaS4LjdL6jK5mAMuMmeSJLkCX8Px50DT/2hhFw7Wot9sZhn5JVpSGzSp682EcKSjS4fbx2PX6Fw1Il7aBohyVVaQe/G3Oqg07I+z407FVRtCC3LD1tl2JH9Ermx1xxxIorzxiLOg/u8aJ8xY3k+HoDFgydZvLbreMRs9gN8Rqr2JtaaOJ0+HwzCtJp+pPkGy1o7oACDzY3ppDUt2sxNn8P1pp+GF20XI+yvMDtyrKBDh1BUHOMro1ST9ixhVXEgF8m4Aq6/qXqKdKGCelF8D
 Ycy9T74T
 jbjg+1BF8PYdJe6pYqmk1gRR24PpUnJFQ7sSZS5jLqjTbgUZtT6aLSD3DuQZRNtHVeybNjKmsbjY55/mwW1t3jdkivuE1EDrd/nx0P1Yx+XQxUXrlDISryzT0WM55FUHrtZvtz5YYGqceJmyMhGEp7D/Ryw/CfFvmAGpCRyQhQLXHVYQUOAgd4JmOkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 931e46dcbc7e6035a90e9c4a27a84b660e083f0a  Add linux-next specific files for 20250814

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202507180503.nfyD9uRv-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507212020.72nw9OIi-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220802.0Iz9U37j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220927.C6zNUJt7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507271211.hvhQM36m-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508010846.fwKbJz68-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508121500.RvXjS54z-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508122300.QreDWTZr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508131428.tYcAx1Pp-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508132051.a7hJXkrd-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508132158.dEwQdick-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508140029.V6tDuUxc-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508141518.uFdkyMsT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508142038.M8MuVqEP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508150253.wFvCsKUQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507281707.XMC5a55P-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507281810.It1bDuo3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507301209.hFc4VENm-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508020200.mf738OTo-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508061925.bEevCphN-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508131953.HDaThIjM-lkp@intel.com

    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-rk.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/stmmac-pci.ko] undefined!
    Warning: fs/ceph/mds_client.c:2703 function parameter 'path_info' not described in 'ceph_mdsc_build_path'
    Warning: fs/ceph/mds_client.c:2704 function parameter 'path_info' not described in 'ceph_mdsc_build_path'
    alpha-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data.rel+0xe0): undefined reference to `stmmac_simple_pm_ops'
    alpha-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data.rel+0xa0): undefined reference to `stmmac_simple_pm_ops'
    alpha-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.o:(.data.rel+0xa0): undefined reference to `stmmac_simple_pm_ops'
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
    arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dtb: mdp@ae01000 (qcom,sc8180x-dpu): $nodename:0: 'mdp@ae01000' does not match '^display-controller@[0-9a-f]+$'
    arch/arm64/boot/dts/qcom/sc8180x-primus.dtb: mdp@ae01000 (qcom,sc8180x-dpu): $nodename:0: 'mdp@ae01000' does not match '^display-controller@[0-9a-f]+$'
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
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.0.dtb: clock-generator@36 (silabs,si5341): 'clock-output-names' does not match any of the regexes: '^out@[0-9]$', '^pinctrl-[0-9]+$', '^vddo[0-9]-supply$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.0.dtb: clock-generator@36 (silabs,si5341): out@0: 'always-on' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dtb: clock-generator@36 (silabs,si5341): 'clock-output-names' does not match any of the regexes: '^out@[0-9]$', '^pinctrl-[0-9]+$', '^vddo[0-9]-supply$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dtb: clock-generator@36 (silabs,si5341): out@0: 'always-on' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revB.dtb: clock-generator@36 (silabs,si5341): 'clock-output-names' does not match any of the regexes: '^out@[0-9]$', '^pinctrl-[0-9]+$', '^vddo[0-9]-supply$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revB.dtb: clock-generator@36 (silabs,si5341): out@0: 'always-on' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dtb: clock-generator@36 (silabs,si5341): 'clock-output-names' does not match any of the regexes: '^out@[0-9]$', '^pinctrl-[0-9]+$', '^vddo[0-9]-supply$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dtb: clock-generator@36 (silabs,si5341): out@0: 'always-on' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dtb: clock-generator@36 (silabs,si5341): 'clock-output-names' does not match any of the regexes: '^out@[0-9]$', '^pinctrl-[0-9]+$', '^vddo[0-9]-supply$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dtb: clock-generator@36 (silabs,si5341): out@0: 'always-on' does not match any of the regexes: '^pinctrl-[0-9]+$'
    drivers/i3c/master/../internals.h:54:9: error: passing 'const void *' to parameter of type 'void *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data+0x1ac): undefined reference to `stmmac_simple_pm_ops'
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data+0x140): undefined reference to `stmmac_simple_pm_ops'
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data+0x124): undefined reference to `stmmac_simple_pm_ops'
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_GPUCC_615
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_VIDEOCC_615
    ld.lld: error: undefined symbol: stmmac_simple_pm_ops
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'

Unverified Error/Warning (likely false positive, kindly check if interested):

    (.head.text+0x0): relocation truncated to fit: R_MIPS_26 against `kernel_entry'
    (.head.text+0x900): relocation truncated to fit: R_OR1K_INSN_REL_26 against `no symbol'
    (.init.text+0x21bc): relocation truncated to fit: R_OR1K_INSN_REL_26 against `no symbol'
    (.ref.text+0xd8): relocation truncated to fit: R_MIPS_26 against `start_secondary'
    arch/mips/boot/dts/mti/sead3.dts:69.17-91.4: Warning (avoid_unnecessary_addr_size): /flash@1c000000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    clang: error: clang frontend command failed with exit code 139 (use -v to see invocation)
    drivers/gpu/drm/xe/xe_pt.c:2487 xe_pt_update_ops_run() error: uninitialized symbol 'ifence'.
    drivers/gpu/drm/xe/xe_pt.c:2492 xe_pt_update_ops_run() error: uninitialized symbol 'mfence'.
    fs/bcachefs/fsck.c:187 lookup_lostfound() error: uninitialized symbol 'subvolid'.
    include/linux/iov_iter.h:190 iterate_folioq() error: uninitialized symbol 'remain'.
    or1k-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'
    or1k-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data+0x54): undefined reference to `stmmac_simple_pm_ops'
    or1k-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'
    sound/hda/codecs/generic.c:198 parse_user_hints() warn: assigning (-2) to unsigned variable 'spec->mixer_nid'
    sound/soc/intel/avs/boards/rt5640.c:151 avs_create_dai_link() warn: excess argument passed to 'devm_kasprintf'

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
|-- arm-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arm-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_GPUCC_615
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_VIDEOCC_615
|-- arm-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arm-randconfig-051-20250814
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-052-20250814
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-053-20250814
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-054-20250814
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-055-20250814
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
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
|-- arm64-randconfig-001-20250814
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   `-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|-- arm64-randconfig-051-20250814
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
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
|   |-- arch-arm64-boot-dts-rockchip-rk3588s-rock-5c.dtb:npu-fdad0000:failed-to-match-any-schema-with-compatible:rockchip-rk3588-rknn-core
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   `-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|-- arm64-randconfig-052-20250814
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
|-- arm64-randconfig-053-20250814
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
|-- arm64-randconfig-054-20250814
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
|-- arm64-randconfig-055-20250814
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
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-rk.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-stm32.ko-undefined
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- hexagon-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- ld.lld:error:undefined-symbol:stmmac_simple_pm_ops
|-- i386-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-randconfig-061-20250814
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-062-20250814
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-063-20250814
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-141-20250814
|   |-- fs-bcachefs-fsck.c-lookup_lostfound()-error:uninitialized-symbol-subvolid-.
|   `-- include-linux-iov_iter.h-iterate_folioq()-error:uninitialized-symbol-remain-.
|-- loongarch-allmodconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- loongarch-defconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- loongarch-randconfig-r053-20250814
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
|   `-- microblaze-linux-ld:drivers-net-ethernet-stmicro-stmmac-stmmac_pci.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- arch-mips-boot-dts-mti-sead3.dts.-.:Warning-(avoid_unnecessary_addr_size):flash-1c000000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- openrisc-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_OR1K_INSN_REL_26-against-no-symbol
|   |-- (.init.text):relocation-truncated-to-fit:R_OR1K_INSN_REL_26-against-no-symbol
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- or1k-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|   |-- or1k-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-rk.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
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
|   `-- hppa-linux-ld:drivers-net-ethernet-stmicro-stmmac-stmmac_pci.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|-- powerpc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- riscv-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- riscv-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- riscv-randconfig-001-20250814
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- s390-allmodconfig
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-rk.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-stm32.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-stmmac-pci.ko-undefined
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- s390-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sh-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sh-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc64-randconfig-001-20250814
|   `-- drivers-i3c-master-..-internals.h:error:passing-const-void-to-parameter-of-type-void-discards-qualifiers-Werror-Wincompatible-pointer-types-discards-qualifiers
|-- um-allmodconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- um-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- x86_64-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- x86_64-randconfig-121-20250814
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- x86_64-randconfig-122-20250814
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- x86_64-randconfig-123-20250814
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- x86_64-randconfig-161-20250814
|   |-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-ifence-.
|   |-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-mfence-.
|   |-- fs-bcachefs-fsck.c-lookup_lostfound()-error:uninitialized-symbol-subvolid-.
|   |-- include-linux-iov_iter.h-iterate_folioq()-error:uninitialized-symbol-remain-.
|   |-- sound-hda-codecs-generic.c-parse_user_hints()-warn:assigning-to-unsigned-variable-spec-mixer_nid
|   `-- sound-soc-intel-avs-boards-rt5640.c-avs_create_dai_link()-warn:excess-argument-passed-to-devm_kasprintf
`-- x86_64-rhel-9.4-rust
    `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path

elapsed time: 894m

configs tested: 133
configs skipped: 6

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                        nsimosci_defconfig    gcc-15.1.0
arc                   randconfig-001-20250814    gcc-12.5.0
arc                   randconfig-002-20250814    gcc-13.4.0
arc                    vdk_hs38_smp_defconfig    gcc-15.1.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                            mps2_defconfig    clang-22
arm                   randconfig-001-20250814    clang-22
arm                   randconfig-002-20250814    clang-22
arm                   randconfig-003-20250814    gcc-10.5.0
arm                   randconfig-004-20250814    gcc-8.5.0
arm                           sunxi_defconfig    gcc-15.1.0
arm                         vf610m4_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250814    clang-17
arm64                 randconfig-002-20250814    gcc-8.5.0
arm64                 randconfig-003-20250814    gcc-10.5.0
arm64                 randconfig-004-20250814    gcc-13.4.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250814    gcc-15.1.0
csky                  randconfig-002-20250814    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250814    clang-20
hexagon               randconfig-002-20250814    clang-22
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250814    clang-20
i386        buildonly-randconfig-002-20250814    gcc-12
i386        buildonly-randconfig-003-20250814    gcc-12
i386        buildonly-randconfig-004-20250814    clang-20
i386        buildonly-randconfig-005-20250814    gcc-12
i386        buildonly-randconfig-006-20250814    gcc-12
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250814    clang-22
loongarch             randconfig-002-20250814    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250814    gcc-10.5.0
nios2                 randconfig-002-20250814    gcc-9.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250814    gcc-10.5.0
parisc                randconfig-002-20250814    gcc-13.4.0
parisc64                            defconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20250814    gcc-8.5.0
powerpc               randconfig-002-20250814    gcc-8.5.0
powerpc               randconfig-003-20250814    gcc-10.5.0
powerpc                     stx_gp3_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20250814    clang-22
powerpc64             randconfig-002-20250814    clang-22
powerpc64             randconfig-003-20250814    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250814    clang-22
riscv                 randconfig-002-20250814    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250814    clang-22
s390                  randconfig-002-20250814    gcc-8.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250814    gcc-9.5.0
sh                    randconfig-002-20250814    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250814    gcc-14.3.0
sparc                 randconfig-002-20250814    gcc-12.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250814    clang-22
sparc64               randconfig-002-20250814    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250814    clang-22
um                    randconfig-002-20250814    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250814    clang-20
x86_64      buildonly-randconfig-002-20250814    clang-20
x86_64      buildonly-randconfig-003-20250814    gcc-12
x86_64      buildonly-randconfig-004-20250814    clang-20
x86_64      buildonly-randconfig-005-20250814    gcc-12
x86_64      buildonly-randconfig-006-20250814    gcc-12
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                       common_defconfig    gcc-15.1.0
xtensa                randconfig-001-20250814    gcc-8.5.0
xtensa                randconfig-002-20250814    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

