Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF1BCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41EF38E0207; Fri, 15 Aug 2025 13:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6C88E0001; Fri, 15 Aug 2025 13:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E57F8E0207; Fri, 15 Aug 2025 13:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11F758E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:53:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87E11137A2F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:53:38 +0000 (UTC)
X-FDA: 83779739316.02.ACF9C2C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf17.hostedemail.com (Postfix) with ESMTP id A228240015
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:53:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lK35YWYs;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755280416; a=rsa-sha256;
	cv=none;
	b=F1kElyhjUvucmTzjLLZvu9suNHurlqDbfeX8R++YY+JLTFCUV9drfOc2o2jNsghQA8PH23
	Cxi8TUwml8xHC3vChzJnd6HB93GO4srMC6aMUUinOuoGBxCSSA0AViG1lmx34W3PaGvCpj
	IuwGo3c4HwVbs/C5vxvj7edf8Hrzeg4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lK35YWYs;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755280416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=LYErVvDH5oJBRfj35lLDBfFrH3imgZxSON0Qo8Lh0HI=;
	b=tFeu4heOqW6Q6Age1Ow8i8FyvZwjOo6VJKgwW11qmksnTI+1P24kZTLDSkSjoFUrrDxUnM
	7h79IVA2TeMy72RB+Nrj3mj0VPHA02hCqBLxZ/T3EzxnytNFVnxPwP2a8tW2Stqm9fTXFn
	YJs8U1BcjTBPmeHn4AO48ORRY4BlfLM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755280415; x=1786816415;
  h=date:from:to:cc:subject:message-id;
  bh=iIMtNhJfCYYM4ZsRMaBiEnLUZHVgDBgQkNmJULYKkRc=;
  b=lK35YWYsQVl826oCMWk+Hjy0pQnb06L1gXbBjPIlz4GZ0SWOEBniJ35q
   tthwBaQCruXyOW6QQMwG+mCdMxKNYP1/XTRNfb/YayRfB4ug1ls3AS1F5
   GHmz7FM+pKOKOn2vnTorVv99BMfsWVw+yj3zyIgFOBSFyLnV/VEUTZdiZ
   RH0kgp28oJB2DYKKZ3XWM3+SHtzDoFLug1oOJ5b43GuOLn/d7IHtnH5Tl
   bbOSbDM74uxVpOCj5SHzOGba6dgxuoDPSeMVwFT9CB0I2z1b5lKVb61OV
   i3fnzcBTbPVI8JW6gscXJU9b7NALmLQBi0UqnBxc6td34VeAjUAmymrwM
   Q==;
X-CSE-ConnectionGUID: r8FSPTP9TWml58Sb30odmA==
X-CSE-MsgGUID: 7gITlfsPQtiDU4EUbOYaOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11523"; a="45177217"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="45177217"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 10:53:32 -0700
X-CSE-ConnectionGUID: NRbbPKLCSLOMxOHlvm7FLg==
X-CSE-MsgGUID: dnAmMY6qTzuMipthPALaIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="167446241"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 15 Aug 2025 10:53:30 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umycJ-000CCN-0v;
	Fri, 15 Aug 2025 17:53:27 +0000
Date: Sat, 16 Aug 2025 01:52:39 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 1357b2649c026b51353c84ddd32bc963e8999603
Message-ID: <202508160155.DJiDUWVA-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Queue-Id: A228240015
X-Stat-Signature: eahwgy48t1rdxzcfo1hfr9mok7j35owb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755280415-816273
X-HE-Meta: U2FsdGVkX1/T/8Km2Ul2Ilg9VkDyC89m7qFasGiKEaxkPSGyXLdCvJyHP4ACCGCh/mCeSFtK6y/+oQwVn83uwcZ151KD8p7gRmK7TWceQanFVZHNupUKG5mbatdZUKTR4k3ECrba6CgFqqQFkzKtXx4YhdYqJfk+uvhlr+z49mwUfgd2DML2M8nTdicLa9JdgPdTDqBcZtn0qwC/Oli4jyjoIty9KywQx7Vh1YMw5+1gh1d/dwptVXDq5APzeoOpsb/4akOa7LUog1cJHxnTfgkOp4Wsydswz82GC+W2ep5tb0CFjll8BA5/2ncumvdo6y6o/4kCZ9j4UvP6qHswz0dBgl+0oVeAzvBi9Geqjp6PlVbyVq4+aTUafVxvIIHUAiy4ZLQnNO1eBAiRodU513ydrLNCjw4JVOVfqxxCj9cFbs79p01qVFkmnqdSn4snQ2M2WMuf05wxG3dWE4a53NphuZ/c0iEUwwz/cQsxe2mWxKOsFztr+E8DqqKnNiu0cNTR7WBAKz+Lj23VBlspqjoCxmcjulUR370ZZ0aPpAT6y8S9UrghvZSuEVhqsmVbVksVc5iOkzTdoa2GyyPbthuOsK+wv65hes0b0yrEThNI4AV57LNC1w+mgDYTQ4dc/1AUKeDAmSfqoNJBXCv7q41VxWZ5+0iaKz3emY8PRYRvZdTuhXjnCad/eCpBkoWybEr43Y1u3E76kcC6dGn48e1N3gTmzN8YzOAZ8GcSKSj74FotRuZM8EnzKbLH+4SLZjZk3nG9NUOUMZAHb70H4bI3RDkoVo4Bz4sDEf7puH/EdwLf5NWhLiLQIYtIo/ukiFjwGIvXhoWweLCGyp4Ct+EBekMzgfMUgebmgvp7+BiIjXLKkerE/gctsDa8FKNT4hYUbZiD8knu2hMr6uyzjaMAO1+sovhXZOkjsMVxG+BNUnBG/u9n7hEQh/YrVA+7AfNOBKx5ALybVaKMOU8
 qarGdZ1N
 YuqIh14lZ+gWdkM9PZunHqaZoLr5HA9XefIOHOoFZmR2pnOYSH8dlobeaKVUNdvlsCoohc2HuTIwVKQ8yI3+lW9HC4wX62e2gCq8lhKjW9iY3HVT4Ayjy8N+uFlZYNIU9jxlwqzSN/maxvp/AZgbYhBxAIHKa1avfOqCM8Vs23SBff9KAtrdp0Nv9YQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 1357b2649c026b51353c84ddd32bc963e8999603  Add linux-next specific files for 20250815

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
    https://lore.kernel.org/oe-kbuild-all/202508132158.dEwQdick-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508141518.uFdkyMsT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508142038.M8MuVqEP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508150253.wFvCsKUQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508150833.qVOkjjn0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508151712.qMqD87iI-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507301209.hFc4VENm-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508020200.mf738OTo-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508061925.bEevCphN-lkp@intel.com

    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-rk.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.ko] undefined!
    ERROR: modpost: "stmmac_simple_pm_ops" [drivers/net/ethernet/stmicro/stmmac/stmmac-pci.ko] undefined!
    Warning: fs/ceph/mds_client.c:2704 function parameter 'path_info' not described in 'ceph_mdsc_build_path'
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
    drivers/md/dm-pcache/cache_dev.c:52:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data+0x1ac): undefined reference to `stmmac_simple_pm_ops'
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data+0x150): undefined reference to `stmmac_simple_pm_ops'
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.o:(.data+0xd0): undefined reference to `stmmac_simple_pm_ops'
    hppa-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data+0x124): undefined reference to `stmmac_simple_pm_ops'
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_GPUCC_615
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_VIDEOCC_615
    ld.lld: error: undefined symbol: stmmac_simple_pm_ops
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data+0x54): undefined reference to `stmmac_simple_pm_ops'
    microblaze-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'
    s390-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data.rel+0xe0): undefined reference to `stmmac_simple_pm_ops'

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
    or1k-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'
    or1k-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-rk.o:(.data+0x54): undefined reference to `stmmac_simple_pm_ops'
    or1k-linux-ld: drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.o:(.data+0x54): undefined reference to `stmmac_simple_pm_ops'
    or1k-linux-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o:(.data+0x74): undefined reference to `stmmac_simple_pm_ops'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-randconfig-002-20250815
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arm-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arm-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_GPUCC_615
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_VIDEOCC_615
|-- arm-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arm-randconfig-051-20250815
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-052-20250815
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-053-20250815
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-054-20250815
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-055-20250815
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
|   |-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|   `-- drivers-md-dm-pcache-cache_dev.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-false
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
|-- arm64-randconfig-051-20250815
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
|-- arm64-randconfig-052-20250815
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
|-- arm64-randconfig-053-20250815
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
|-- arm64-randconfig-054-20250815
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
|-- arm64-randconfig-055-20250815
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
|-- arm64-randconfig-r052-20250815
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c00000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(interrupt_map):pcie-1c10000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm6150.dtsi.-.:Warning-(interrupt_map):soc-pcie-1c08000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-17a00000-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- csky-randconfig-r123-20250815
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
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
|-- i386-randconfig-141-20250815
|   |-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-ifence-.
|   |-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-mfence-.
|   `-- fs-bcachefs-fsck.c-lookup_lostfound()-error:uninitialized-symbol-subvolid-.
|-- loongarch-allmodconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- loongarch-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- drivers-md-dm-pcache-cache_dev.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-false
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
|   `-- microblaze-linux-ld:drivers-net-ethernet-stmicro-stmmac-stmmac_pci.o:(.data):undefined-reference-to-stmmac_simple_pm_ops
|-- microblaze-randconfig-r122-20250815
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- arch-mips-boot-dts-mti-sead3.dts.-.:Warning-(avoid_unnecessary_addr_size):flash-1c000000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- mips-randconfig-r133-20250815
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- nios2-randconfig-001-20250815
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
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
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- drivers-md-dm-pcache-cache_dev.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-false
|-- powerpc64-randconfig-003-20250815
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc64-randconfig-r131-20250815
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- riscv-allmodconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- drivers-md-dm-pcache-cache_dev.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-false
|-- riscv-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- drivers-md-dm-pcache-cache_dev.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-false
|-- s390-allmodconfig
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-rk.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-dwmac-stm32.ko-undefined
|   |-- ERROR:stmmac_simple_pm_ops-drivers-net-ethernet-stmicro-stmmac-stmmac-pci.ko-undefined
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- s390-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- s390-linux-ld:drivers-net-ethernet-stmicro-stmmac-dwmac-loongson.o:(.data.rel):undefined-reference-to-stmmac_simple_pm_ops
|-- s390-randconfig-r111-20250815
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- sh-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sh-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc64-randconfig-r053-20250815
|   `-- drivers-i3c-master-..-internals.h:error:passing-const-void-to-parameter-of-type-void-discards-qualifiers-Werror-Wincompatible-pointer-types-discards-qualifiers
|-- um-allmodconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- um-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- x86_64-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- drivers-md-dm-pcache-cache_dev.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-false
|-- x86_64-randconfig-r113-20250815
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- x86_64-randconfig-r121-20250815
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
`-- x86_64-rhel-9.4-rust
    `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path

elapsed time: 769m

configs tested: 122
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250815    gcc-8.5.0
arc                   randconfig-002-20250815    gcc-9.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                          pxa910_defconfig    gcc-15.1.0
arm                   randconfig-001-20250815    clang-16
arm                   randconfig-002-20250815    clang-18
arm                   randconfig-003-20250815    gcc-14.3.0
arm                   randconfig-004-20250815    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250815    gcc-8.5.0
arm64                 randconfig-002-20250815    gcc-8.5.0
arm64                 randconfig-003-20250815    clang-22
arm64                 randconfig-004-20250815    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250815    gcc-15.1.0
csky                  randconfig-002-20250815    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250815    clang-22
hexagon               randconfig-002-20250815    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250815    gcc-12
i386        buildonly-randconfig-002-20250815    clang-20
i386        buildonly-randconfig-003-20250815    clang-20
i386        buildonly-randconfig-004-20250815    clang-20
i386        buildonly-randconfig-005-20250815    clang-20
i386        buildonly-randconfig-006-20250815    gcc-12
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250815    clang-22
loongarch             randconfig-002-20250815    clang-20
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
nios2                 randconfig-001-20250815    gcc-11.5.0
nios2                 randconfig-002-20250815    gcc-11.5.0
openrisc                         alldefconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250815    gcc-8.5.0
parisc                randconfig-002-20250815    gcc-14.3.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                      mgcoge_defconfig    clang-22
powerpc               mpc834x_itxgp_defconfig    clang-22
powerpc                  mpc866_ads_defconfig    clang-22
powerpc               randconfig-001-20250815    gcc-11.5.0
powerpc               randconfig-002-20250815    clang-19
powerpc               randconfig-003-20250815    gcc-11.5.0
powerpc64             randconfig-001-20250815    gcc-14.3.0
powerpc64             randconfig-002-20250815    gcc-10.5.0
powerpc64             randconfig-003-20250815    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250815    gcc-11.5.0
sh                   secureedge5410_defconfig    gcc-15.1.0
sh                          urquell_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc64                             defconfig    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250815    clang-20
x86_64      buildonly-randconfig-002-20250815    gcc-12
x86_64      buildonly-randconfig-003-20250815    gcc-12
x86_64      buildonly-randconfig-004-20250815    clang-20
x86_64      buildonly-randconfig-005-20250815    clang-20
x86_64      buildonly-randconfig-006-20250815    gcc-12
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

