Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039C3CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 20:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26BE98E0006; Mon, 18 Aug 2025 16:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5DD8E0001; Mon, 18 Aug 2025 16:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06F7E8E0006; Mon, 18 Aug 2025 16:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5E528E0001
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:28:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47118114C0F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:28:41 +0000 (UTC)
X-FDA: 83791016442.29.54DA3F8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2D5CC160015
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:28:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Pw4RG67c;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755548919; a=rsa-sha256;
	cv=none;
	b=u1fFQzs5l4NT2VEu1SB31fma5NvuY3CtEt3IatACS35ZIrjAz0dcoDLvh5jdlCR+qxcurt
	EwGZ1DZCJL7LPSSObZM/6F94/ALaFRS2bTF5EUVcptQTmLvYCapuIfIDNRPFAZ+4Jk8MGi
	xBrBI5AIeQKnZdn+N1ie0bO2j1wZ0v0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Pw4RG67c;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755548919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=vQMDikosu3MPqocWrVAfuIaenkP5+3Lo6lraSUQ6DQo=;
	b=jWLnObWrwrht8301WfnOvyHRAaa4ZF2SaH7dI4oHBY2VfQhTQWt0g+mHmqEJNKUM4/dlz2
	w62Z+lsO0339MFRmKxlyJjNRijEY8rxvKy3IdSBS7M/iqZsp2hy7E3OKuBVoDHSwkShQre
	MIIx9E59LPma1l6xczSLMs+cmhAwwcE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755548918; x=1787084918;
  h=date:from:to:cc:subject:message-id;
  bh=2xWf6CCnWjD72YHaDDEXLxANLqlAtx+NHdYgPSefQfk=;
  b=Pw4RG67cqnxngGRTmTNCpaDU84UBTgt/+q1r2y2qrlKYbM+WizSVxOYb
   yMpInJbayYCdgk/C9OzpsxL6gNUlYS9CX+Ex/1m+qq1CBESzrg7PGQixW
   xqiq8FFCWlsjQ7lRydysLcKkTSsGjHW6b3i0tM8bElRw7vh9C6rh7lJ0e
   G+VCjRAYGTL/emwrdIOj4CUwrxc8BOblpUps7U54hBjgnWMrFMNzx/Dtl
   Rgp7upGXJQllqqa6LFebOSp3C3hMLKFL/YHsejuE+N7zoHB+v+qSY4XFa
   s+IuB5wiQW9Ih7jD9Z4F90kQGRzT5cMFZjUS7AjRRBlKnklSCeSg2UtJo
   w==;
X-CSE-ConnectionGUID: wKb1TCY6QYibmRCjm8lz+A==
X-CSE-MsgGUID: Ej3TQjadSvCYUcIS3veLVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="75237304"
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="75237304"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 13:28:37 -0700
X-CSE-ConnectionGUID: nNJvPnnqQZWdDqi1w/YmxQ==
X-CSE-MsgGUID: YNFbzKCBQY+Ofma29W1F0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="168476524"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 18 Aug 2025 13:28:34 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uo6SM-000G9j-2m;
	Mon, 18 Aug 2025 20:28:03 +0000
Date: Tue, 19 Aug 2025 04:27:14 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 3ac864c2d9bb8608ee236e89bf561811613abfce
Message-ID: <202508190436.XrBPy4Nd-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D5CC160015
X-Stat-Signature: e6p7wjzh6bdjetx9kw6xp1ub67aiw56w
X-HE-Tag: 1755548918-920805
X-HE-Meta: U2FsdGVkX18aPInMpso1b3o8QsOWQeui/3xig0IyOk8144E5RLApc/YAuqto4yfihTZvsqig2cxExwI4QDF9aq174e4L5p7d43WHOadekDprNXVOGOAkNojNkR3an1cj13k+396POXbNA6md62xIa677TJ5d8SXDjr0c1g5BSGQ9DJRR27fby18Kz7AEfMG8LxHD2kbTRj8JDoT4wxy+y3aybmfPXbz24ShDzF+PoU1YrspDZ34c0jeWTaBkJV9znbzMsM/s75kVHtfdy/1UtuebE9ZxwOlrMoRnq4dZtqkx6mhKUOY4sXl+caT6991MWSn4cqFJc001BUPWzmlaOSJj9f6GX1R03/ZIWv+j/ypjvEAfh3oBb8eu8bkFi2TKH25x3ohgSFTo4hgLp1JBx8xLeFgfsA12qEIQkF3ZwfwOZTloiCDdmdNaJei84Kl0vXkZx5FHuFZ1vPL7Jo3hkYAaa6yC0iR9SYC0qaS805U1/5Knj236VU0t5siZNCyZJQSJAcFvifH3SQ2kijjPDhvySKeHp3SxOYP6uFp9khHxliQ2p9yx4wCDK5TTayVF+s+LonPCkE3o/W5+RjpTaKSGmJMlx4+qr3W72/l/0CKQWrXhSn9T5agPBYTBVgi17hLin3rqbEwOZ7AIGPsdc6aRALh0aoBJ5q9v3eToZNrvwhpEWZYBnLmWgRb+lZZhL/ecGsoQ4Fj0cU6u9Xn9/M1WYuAkJJSSGw2kltMN9zNlgY3875t3O3zybjvRC75AxS4ShsaJApgdhwYORe+ZVzkx98RKJuFbUZHYM4h48ZRfgeyNS3hw1EWYsd7Wf4ywXxTqTSiMvSfkMf1g51y2j/xfqJFO7U/+ob1LU8BzC2hWaJYYd07b4+HSrq33Ux81qcSMQ00SmEBJEMekpIQb/2BNmzrjMbUQb5lTKiSzG/lkzeQ8FTVPGPykegEgaZhbuEIKjapm3OvnnQ82nmQ
 zEIx75cH
 ccnfob8H1hFHMlGU4+Ix7CFxL6+V5UUVPLJs0RoGpSAzmejf6aqQ1n2jD6E4hBND2Q7+3m99VldtWbw6PffzZ2V8A/jwuUL+iaxc4KPotwzJNpE7GAmr5mCMjonh4UeuR8k5zXWMAiQyIe0kTBdAjv00RUUgVMc89F7QGnrHYbF7sXpEuGrS0CvxD6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 3ac864c2d9bb8608ee236e89bf561811613abfce  Add linux-next specific files for 20250818

Error/Warning (recently discovered and may have been fixed):

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
    https://lore.kernel.org/oe-kbuild-all/202508150833.qVOkjjn0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508020200.mf738OTo-lkp@intel.com

    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-rk.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/stmmac-pci.ko] undefined!
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
    arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dtb: mdss@ae00000 (qcom,sc8180x-mdss): $nodename:0: 'mdss@ae00000' does not match '^display-subsystem@[0-9a-f]+$'
    arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dtb: mdss@ae00000 (qcom,sc8180x-mdss): Unevaluated properties are not allowed ('dsi-phy@ae94400', 'dsi-phy@ae96400', 'mdp@ae01000' were unexpected)
    arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dtb: mdss@ae00000 (qcom,sc8180x-mdss): dsi@ae94000:compatible: ['qcom,mdss-dsi-ctrl'] does not contain items matching the given schema
    arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dtb: mdss@ae00000 (qcom,sc8180x-mdss): dsi@ae96000:compatible: ['qcom,mdss-dsi-ctrl'] does not contain items matching the given schema
    arch/arm64/boot/dts/qcom/sc8180x-primus.dtb: mdp@ae01000 (qcom,sc8180x-dpu): $nodename:0: 'mdp@ae01000' does not match '^display-controller@[0-9a-f]+$'
    arch/arm64/boot/dts/qcom/sc8180x-primus.dtb: mdss@ae00000 (qcom,sc8180x-mdss): $nodename:0: 'mdss@ae00000' does not match '^display-subsystem@[0-9a-f]+$'
    arch/arm64/boot/dts/qcom/sc8180x-primus.dtb: mdss@ae00000 (qcom,sc8180x-mdss): Unevaluated properties are not allowed ('dsi-phy@ae94400', 'dsi-phy@ae96400', 'mdp@ae01000' were unexpected)
    arch/arm64/boot/dts/qcom/sc8180x-primus.dtb: mdss@ae00000 (qcom,sc8180x-mdss): dsi@ae94000:compatible: ['qcom,mdss-dsi-ctrl'] does not contain items matching the given schema
    arch/arm64/boot/dts/qcom/sc8180x-primus.dtb: mdss@ae00000 (qcom,sc8180x-mdss): dsi@ae96000:compatible: ['qcom,mdss-dsi-ctrl'] does not contain items matching the given schema
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
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data+0x150): undefined reference to `stmmac_simple_pm_ops'
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.o:(.data+0xd0): undefined reference to `stmmac_simple_pm_ops'
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data+0x124): undefined reference to `stmmac_simple_pm_ops'
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_GPUCC_615
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_VIDEOCC_615
    ld.lld: error: undefined symbol: stmmac_simple_pm_ops
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data+0x54): undefined reference to `stmmac_simple_pm_ops'
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.o:(.data+0x54): undefined reference to `stmmac_simple_pm_ops'
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'
    s390-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data.rel+0xe0): undefined reference to `stmmac_simple_pm_ops'

Unverified Error/Warning (likely false positive, kindly check if interested):

    (.head.text+0x0): relocation truncated to fit: R_MIPS_26 against `kernel_entry'
    (.head.text+0x900): relocation truncated to fit: R_OR1K_INSN_REL_26 against `no symbol'
    (.init.text+0x21bc): relocation truncated to fit: R_OR1K_INSN_REL_26 against `no symbol'
    (.ref.text+0xd8): relocation truncated to fit: R_MIPS_26 against `start_secondary'
    arch/mips/boot/dts/mti/sead3.dts:69.17-91.4: Warning (avoid_unnecessary_addr_size): /flash@1c000000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    fs/bcachefs/fsck.c:187 lookup_lostfound() error: uninitialized symbol 'subvolid'.
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
|-- arm-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arm-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_GPUCC_615
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_VIDEOCC_615
|-- arm-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arm-randconfig-051-20250818
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-052-20250818
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-053-20250818
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-054-20250818
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-055-20250818
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
|-- arm64-randconfig-001-20250818
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm6150.dtsi.-.:Warning-(interrupt_map):soc-pcie-1c08000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-002-20250818
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm6150.dtsi.-.:Warning-(interrupt_map):soc-pcie-1c08000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-051-20250818
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):Unevaluated-properties-are-not-allowed-(-dsi-phy-ae94400-dsi-phy-ae96400-mdp-ae01000-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae94000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae96000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):nodename:mdss-ae00000-does-not-match-display-subsystem-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):Unevaluated-properties-are-not-allowed-(-dsi-phy-ae94400-dsi-phy-ae96400-mdp-ae01000-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae94000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae96000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):nodename:mdss-ae00000-does-not-match-display-subsystem-9a-f
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
|-- arm64-randconfig-052-20250818
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):Unevaluated-properties-are-not-allowed-(-dsi-phy-ae94400-dsi-phy-ae96400-mdp-ae01000-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae94000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae96000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):nodename:mdss-ae00000-does-not-match-display-subsystem-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):Unevaluated-properties-are-not-allowed-(-dsi-phy-ae94400-dsi-phy-ae96400-mdp-ae01000-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae94000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae96000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):nodename:mdss-ae00000-does-not-match-display-subsystem-9a-f
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
|-- arm64-randconfig-053-20250818
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):Unevaluated-properties-are-not-allowed-(-dsi-phy-ae94400-dsi-phy-ae96400-mdp-ae01000-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae94000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae96000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):nodename:mdss-ae00000-does-not-match-display-subsystem-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):Unevaluated-properties-are-not-allowed-(-dsi-phy-ae94400-dsi-phy-ae96400-mdp-ae01000-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae94000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae96000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):nodename:mdss-ae00000-does-not-match-display-subsystem-9a-f
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
|-- arm64-randconfig-054-20250818
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):Unevaluated-properties-are-not-allowed-(-dsi-phy-ae94400-dsi-phy-ae96400-mdp-ae01000-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae94000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae96000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):nodename:mdss-ae00000-does-not-match-display-subsystem-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):Unevaluated-properties-are-not-allowed-(-dsi-phy-ae94400-dsi-phy-ae96400-mdp-ae01000-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae94000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae96000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):nodename:mdss-ae00000-does-not-match-display-subsystem-9a-f
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
|-- arm64-randconfig-055-20250818
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):Unevaluated-properties-are-not-allowed-(-dsi-phy-ae94400-dsi-phy-ae96400-mdp-ae01000-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae94000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae96000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:mdss-ae00000-(qcom-sc818-mdss):nodename:mdss-ae00000-does-not-match-display-subsystem-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdp-ae01000-(qcom-sc818-dpu):nodename:mdp-ae01000-does-not-match-display-controller-9a-f
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):Unevaluated-properties-are-not-allowed-(-dsi-phy-ae94400-dsi-phy-ae96400-mdp-ae01000-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae94000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):dsi-ae96000:compatible:qcom-mdss-dsi-ctrl-does-not-contain-items-matching-the-given-schema
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:mdss-ae00000-(qcom-sc818-mdss):nodename:mdss-ae00000-does-not-match-display-subsystem-9a-f
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
|-- arm64-randconfig-r053-20250818
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
|-- i386-buildonly-randconfig-004-20250818
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-buildonly-randconfig-006-20250818
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-randconfig-141-20250818
|   `-- fs-bcachefs-fsck.c-lookup_lostfound()-error:uninitialized-symbol-subvolid-.
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
|-- parisc-randconfig-002-20250818
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc64-randconfig-001-20250818
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
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
|   `-- s390-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.o:(.data.rel):undefined-reference-to-stmmac_simple_pm_ops
|-- sh-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sh-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc-randconfig-r054-20250818
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc64-randconfig-001-20250818
|   `-- drivers-i3c-master-..-internals.h:error:passing-const-void-to-parameter-of-type-void-discards-qualifiers-Werror-Wincompatible-pointer-types-discards-qualifiers
|-- um-allmodconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- um-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
`-- x86_64-randconfig-161-20250818
    `-- fs-bcachefs-fsck.c-lookup_lostfound()-error:uninitialized-symbol-subvolid-.

elapsed time: 932m

configs tested: 134
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250818    gcc-13.4.0
arc                   randconfig-002-20250818    gcc-12.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                         lpc32xx_defconfig    clang-17
arm                   randconfig-001-20250818    gcc-12.5.0
arm                   randconfig-002-20250818    clang-22
arm                   randconfig-003-20250818    clang-18
arm                   randconfig-004-20250818    gcc-10.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250818    gcc-11.5.0
arm64                 randconfig-002-20250818    gcc-12.5.0
arm64                 randconfig-003-20250818    gcc-8.5.0
arm64                 randconfig-004-20250818    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250818    gcc-15.1.0
csky                  randconfig-002-20250818    gcc-9.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250818    clang-22
hexagon               randconfig-002-20250818    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250818    clang-20
i386        buildonly-randconfig-002-20250818    clang-20
i386        buildonly-randconfig-003-20250818    gcc-12
i386        buildonly-randconfig-004-20250818    clang-20
i386        buildonly-randconfig-005-20250818    gcc-12
i386        buildonly-randconfig-006-20250818    gcc-12
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250818    gcc-15.1.0
loongarch             randconfig-002-20250818    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                          atari_defconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                  cavium_octeon_defconfig    gcc-15.1.0
mips                           gcw0_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250818    gcc-9.5.0
nios2                 randconfig-002-20250818    gcc-9.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250818    gcc-10.5.0
parisc                randconfig-002-20250818    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20250818    gcc-8.5.0
powerpc               randconfig-002-20250818    gcc-9.5.0
powerpc               randconfig-003-20250818    clang-22
powerpc64             randconfig-001-20250818    gcc-8.5.0
powerpc64             randconfig-002-20250818    clang-17
powerpc64             randconfig-003-20250818    gcc-10.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250818    gcc-10.5.0
riscv                 randconfig-002-20250818    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250818    clang-22
s390                  randconfig-002-20250818    gcc-8.5.0
s390                       zfcpdump_defconfig    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250818    gcc-12.5.0
sh                    randconfig-002-20250818    gcc-13.4.0
sh                          sdk7780_defconfig    gcc-15.1.0
sparc                            alldefconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250818    gcc-12.5.0
sparc                 randconfig-002-20250818    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250818    clang-22
sparc64               randconfig-002-20250818    gcc-12.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250818    gcc-11
um                    randconfig-002-20250818    gcc-12
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250818    gcc-12
x86_64      buildonly-randconfig-002-20250818    gcc-12
x86_64      buildonly-randconfig-003-20250818    gcc-12
x86_64      buildonly-randconfig-004-20250818    gcc-12
x86_64      buildonly-randconfig-005-20250818    gcc-12
x86_64      buildonly-randconfig-006-20250818    clang-20
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250818    gcc-14.3.0
xtensa                randconfig-002-20250818    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

