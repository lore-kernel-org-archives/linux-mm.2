Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE74BCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 21:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0724A8E0005; Thu, 11 Sep 2025 17:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0234F8E0001; Thu, 11 Sep 2025 17:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C8A8E0005; Thu, 11 Sep 2025 17:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFFFB8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:44:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C2EA1A05BF
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:44:49 +0000 (UTC)
X-FDA: 83878299498.26.58B5D93
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id CC302A0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:44:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ive+8O38;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757627087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=5o4HVSr9a2Eib8zkyudlX1wUqwsJEx3Kvv6/HLmuX74=;
	b=IkH4PIpb1Tolylk7wLZQdX9vNKmA/aV4pKKcfoAn11ASaHV2G/J8qCH+dQUpxcVQrbBBWJ
	yprF/k2n5PCbGLyeDQ3hPP2wc/Wtqt1I4MAKx4d/Wl9ICTPotnVqHS3uGa8MobE7JXJHe9
	7s/SACfVrodm8PiprtS87ziW4EpS9tk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ive+8O38;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757627087; a=rsa-sha256;
	cv=none;
	b=dthzMMNtvxImBqBIFwM0uel0xbwB7XdyZxNubA+UEXEPM4sDvT7Qup8fMBDUmlODwehiYl
	7qFIQiJA54w84LG5UMO3WdRWpp+aKUm1WtGO6xhknzKn+6XogE21xOhiNqSKzcMa+X2/70
	CcM2JSbK2/RoUNt6KW3yFO+14Az/hOM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757627087; x=1789163087;
  h=date:from:to:cc:subject:message-id;
  bh=t3q8PKSPoDNJIG02FycNX2nkfNFqnoTavddlGISIILQ=;
  b=ive+8O38c5Y9DdGhKQra5gIQGjzglyneCRl3jOnJLG3BRx/EMJvknSq3
   Azq7S3MoDQk3jUmZT7RuFrFmZhiVmgUnYS8qYdhTb9VUJd+BFXs8tIegk
   RdQKlYH++EFCxv4yFLUQ5eqS7Yz4yyFGgIJLSDS3lK9mlX1rs9U4ptfMv
   gs/rvjocP9PWBm9MywD38k8k9OLa2DTVHihc0WT5AjMIXDF7DJVc0IehV
   oguZIlZcyqU2Wb2S1QrNsXnGFu/9DEQCmcfs9oMnf3N/S4qBjzYDCSyZb
   VoT4UYCjTlI1YCREWyji0dPwcUEju2j1sCKB+dAXdG5BiiFkQzQMgwbK5
   g==;
X-CSE-ConnectionGUID: /T9r6OYFTqaPFcG/23dcjQ==
X-CSE-MsgGUID: 0wUMwAHfSPuUU77/Ey6GUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11550"; a="63606155"
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="63606155"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 14:44:45 -0700
X-CSE-ConnectionGUID: S0cEg4PDRkGzaQQJ+SdXEQ==
X-CSE-MsgGUID: HOd0nkwNTW+4NLC2hqDwvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="173705726"
Received: from lkp-server02.sh.intel.com (HELO eb5fdfb2a9b7) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 11 Sep 2025 14:44:44 -0700
Received: from kbuild by eb5fdfb2a9b7 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uwp5t-0000eh-2s;
	Thu, 11 Sep 2025 21:44:41 +0000
Date: Fri, 12 Sep 2025 05:44:18 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 8f21d9da46702c4d6951ba60ca8a05f42870fe8f
Message-ID: <202509120504.2S3NDRe9-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CC302A0006
X-Stat-Signature: qhnk3o9knb4bwx4z599khxfuga4ru7eq
X-HE-Tag: 1757627086-429615
X-HE-Meta: U2FsdGVkX1/0CrEP/l5BWkJLCYG5DsV7Y0BrdArHhcBFpScmmFoVBb6Gcc8ZkXdXKDISGI6ex+j4iUskoKUY8m5boGQDQf3duJz2udUQB1gD6pk++SlIz7jv4SBUMvqci1m22hUaiiN7IG/xq9fvsAeGkHtodO/O65nTr4gYlCzxAq6e9iZiUzrqrticsHG0qCA/W6X2wAnGFiObFw9L+g2yhuVQVK/1Aq+GP/UR0NB5i6nm3kcg4c0lw//5jVwI3u7g+iLik2Y3O+Crk7kUGnv0EP7l5DTVMBrq2jnLx4aMSi8YXUpIGsKlNyJTOsfMYdHp7VToOBlNOgLR3Wmazm1ewMSj8T7f+qwqVrw30oTR3MjN644S/+ZY601QVRB0nmYOElunAhQVpIbV+DijdcDENpnq6DfqnLsa2qGiYGZ5HlgOmq4eQSMynpYubYw0lhcY6YODr0GltJNQ/S1R8d5b0l2QMDDknZUuLltAHMbyCcxASb+gIayTTZOKlIhMCM+Du338j+vGa27kbtKEV+cN1EOoCIv2GohgAOo2UPcoeZfjo4/JTRnsnmiv9FSBOA5c9BpqpMp+JMYzD4fdDgVR55uI+Ls6Pz4e9B+oipMQi+kZvIq8qYRlOSiUzy9s1mAUyEY+ggo3nNABvxK0xyD6fC0BNiZeH0nR1LGHzw82XrxrHfz6qkQTe7IquyoVlwOAjkXeBRStKanU5X2/8T8Z5pJ63xcyf8bVmX4vmCjNqqvKrz8N228vRQ6LorsZyAG4X7k9QrM+zi4+6BvHTd2YYv4eWtnHYCsTpQ16wrW9miT4ROStxl8pzYUC48wx7UDCJJ3IEcpLX++4RhLOWzycnF0wr3VteGjxQ7wOwCPbxvSZsS9DZy/PlGwSm6sMftEYmpP/5SUqZqDdZbJw6VxQJtliwDs/nKWh35NrthIUbNIL7xX9STPxp3NWKpTZ7byMJE71QapuFi4Si2X
 ERq33v1d
 L4TWYrCCdjHzpfxh6lyzDJzRe3qluH/i65ugMDS/HOGA7/NheFLn3tMVWg6NSHt+he7w6z6ZWsqY5Lm1VjBRBFnXGWxmCr9xzaPGcijnHCr441nqHrnMvT/BTLeHKoEow+ybi2Qyiwcm076nPV9hhBn86KeiWO8po3wjUVq0+kpexYjwuRleNco5UfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 8f21d9da46702c4d6951ba60ca8a05f42870fe8f  Add linux-next specific files for 20250911

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202508142038.M8MuVqEP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508211859.UoYsJbLN-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508231902.ZRQhIhd5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509052225.NIyWDaaP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509061641.M9r43HWa-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509101930.OsSQJxIP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509112222.EQkEhLyH-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509112310.qXbyQPpQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509112313.0XfkfKPl-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509120048.WXKCbnyT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509120150.hzd9vw51-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509120229.YpG1CcD3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509120259.hEa4EM5r-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509120423.5Zmxqx6o-lkp@intel.com

    Documentation/.renames.txt: warning: ignored by one of the .gitignore files
    arch/arm/boot/dts/broadcom/bcm2711.dtsi:564.4-571.11: Warning (interrupt_map): /scb/pcie@7d500000:interrupt-map: Missing property '#address-cells' in node /soc/interrupt-controller@40041000, using 0 as fallback
    arch/arm/boot/dts/broadcom/bcm47094-linksys-panamera.dts:140.13-191.6: Warning (avoid_unnecessary_addr_size): /mdio-mux@18003000/mdio@200/switch@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/broadcom/bcm5301x-nand-cs0.dtsi:10.18-19.5: Warning (avoid_unnecessary_addr_size): /nand-controller@18028000/nand@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/hisilicon/hi3620.dtsi:544.23-563.5: Warning (avoid_unnecessary_addr_size): /amba-bus/pinmux@803000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nxp/imx/imx7d.dtsi:137.4-140.30: Warning (interrupt_map): /soc/pcie@33800000:interrupt-map: Missing property '#address-cells' in node /soc/interrupt-controller@31001000, using 0 as fallback
    arch/arm/boot/dts/nxp/vf/vfxxx.dtsi:542.24-554.6: Warning (avoid_unnecessary_addr_size): /soc/bus@40080000/spi@400ad000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-href-stuib.dtsi:9.12-29.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-href-tvk1281618-r2.dtsi:10.12-30.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-href-tvk1281618-r3.dtsi:11.12-25.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-hrefprev60.dtsi:12.12-16.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-snowball.dts:62.12-102.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/am335x-evmsk.dts:124.30-153.4: Warning (avoid_unnecessary_addr_size): /gpio_buttons0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/am335x-sl50.dts:103.9-123.4: Warning (avoid_unnecessary_addr_size): /clocks: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/am3517.dtsi:126.36-136.5: Warning (avoid_unnecessary_addr_size): /ocp@68000000/pinmux@480025d8: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/dm814x.dtsi:479.25-487.7: Warning (avoid_unnecessary_addr_size): /ocp/l4ls@48000000/control@140000/pinmux@800: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/dm816x.dtsi:130.24-133.6: Warning (avoid_unnecessary_addr_size): /ocp/scrm@48140000/clocks: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/dm816x.dtsi:91.30-99.6: Warning (avoid_unnecessary_addr_size): /ocp/scrm@48140000/pinmux@800: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap3-gta04.dtsi:203.18-218.4: Warning (avoid_unnecessary_addr_size): /pinmux@48002274: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap3-gta04.dtsi:221.18-236.4: Warning (avoid_unnecessary_addr_size): /pinmux@480022d8: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap3-overo-alto35-common.dtsi:38.12-50.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap3-overo-chestnut43-common.dtsi:31.12-49.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap3-overo-gallop43-common.dtsi:31.12-49.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap3-overo-palo35-common.dtsi:31.12-49.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap3-overo-palo43-common.dtsi:31.12-49.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap3.dtsi:105.31-116.7: Warning (avoid_unnecessary_addr_size): /ocp@68000000/l4@48000000/scm@2000/pinmux@30: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap3.dtsi:145.32-156.7: Warning (avoid_unnecessary_addr_size): /ocp@68000000/l4@48000000/scm@2000/pinmux@a00: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap34xx.dtsi:78.36-88.5: Warning (avoid_unnecessary_addr_size): /ocp@68000000/pinmux@480025d8: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap36xx.dtsi:115.36-125.5: Warning (avoid_unnecessary_addr_size): /ocp@68000000/pinmux@480025a0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap5-uevm.dts:52.11-69.4: Warning (avoid_unnecessary_addr_size): /evm_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/lemans-evk.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): clocks: [[225, 1], [225, 11], [225, 15], [225, 18], [225, 19]] is too short
    arch/arm64/boot/dts/qcom/lemans-evk.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): reg: [[0, 183844864, 0, 260], [0, 183845376, 0, 192], [0, 183848960, 0, 1904], [0, 183853056, 0, 156], [0, 183857152, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/lemans-evk.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): clocks: [[225, 1], [225, 28], [225, 32], [225, 35], [225, 36]] is too short
    arch/arm64/boot/dts/qcom/lemans-evk.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): reg: [[0, 183877632, 0, 260], [0, 183878144, 0, 192], [0, 183881728, 0, 1904], [0, 183885824, 0, 156], [0, 183889920, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcm6490-idp.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-industrial-mezzanine.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-vision-mezzanine.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcs9100-ride-r3.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): reg: [[0, 183844864, 0, 260], [0, 183845376, 0, 192], [0, 183848960, 0, 1904], [0, 183853056, 0, 156], [0, 183857152, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/qcs9100-ride-r3.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): reg: [[0, 183877632, 0, 260], [0, 183878144, 0, 192], [0, 183881728, 0, 1904], [0, 183885824, 0, 156], [0, 183889920, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/qcs9100-ride.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): reg: [[0, 183844864, 0, 260], [0, 183845376, 0, 192], [0, 183848960, 0, 1904], [0, 183853056, 0, 156], [0, 183857152, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/qcs9100-ride.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): reg: [[0, 183877632, 0, 260], [0, 183878144, 0, 192], [0, 183881728, 0, 1904], [0, 183885824, 0, 156], [0, 183889920, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/sa8775p-ride-r3.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): reg: [[0, 183844864, 0, 260], [0, 183845376, 0, 192], [0, 183848960, 0, 1904], [0, 183853056, 0, 156], [0, 183857152, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/sa8775p-ride-r3.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): reg: [[0, 183877632, 0, 260], [0, 183878144, 0, 192], [0, 183881728, 0, 1904], [0, 183885824, 0, 156], [0, 183889920, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/sa8775p-ride.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): reg: [[0, 183844864, 0, 260], [0, 183845376, 0, 192], [0, 183848960, 0, 1904], [0, 183853056, 0, 156], [0, 183857152, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/sa8775p-ride.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): reg: [[0, 183877632, 0, 260], [0, 183878144, 0, 192], [0, 183881728, 0, 1904], [0, 183885824, 0, 156], [0, 183889920, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/sc7280-crd-r3.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-crd-pro.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-crd.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-evoker-lte.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-evoker.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-herobrine-r1.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-villager-r0.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-villager-r1-lte.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-villager-r1.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-zombie-lte.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-zombie-nvme-lte.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-zombie-nvme.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-zombie.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-idp.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-idp2.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dtb: displayport-controller@ae9a000 (qcom,sc8180x-edp): reg: [[0, 183083008, 0, 512], [0, 183083520, 0, 512], [0, 183084032, 0, 1536], [0, 183085568, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc8180x-primus.dtb: displayport-controller@ae9a000 (qcom,sc8180x-edp): reg: [[0, 183083008, 0, 512], [0, 183083520, 0, 512], [0, 183084032, 0, 1536], [0, 183085568, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sm6350-sony-xperia-lena-pdx213.dtb: displayport-controller@ae90000 (qcom,sm6350-dp): clocks: [[127, 1], [127, 7], [127, 11], [127, 14], [127, 15]] is too short
    arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dtb: displayport-controller@ae90000 (qcom,sm6350-dp): clocks: [[141, 1], [141, 7], [141, 11], [141, 14], [141, 15]] is too short
    arch/arm64/boot/dts/qcom/sm7325-nothing-spacewar.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sm8250-samsung-r8q.dtb: displayport-controller@ae90000 (qcom,sm8250-dp): clocks: [[193, 0], [193, 12], [193, 18], [193, 21], [193, 26]] is too short
    arch/arm64/boot/dts/qcom/sm8250-samsung-x1q.dtb: displayport-controller@ae90000 (qcom,sm8250-dp): clocks: [[193, 0], [193, 12], [193, 18], [193, 21], [193, 26]] is too short
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
    arch/csky/abiv2/cacheflush.c:24:47: error: passing argument 2 of 'test_and_set_bit' from incompatible pointer type [-Werror=incompatible-pointer-types]
    arch/csky/abiv2/cacheflush.c:24:47: error: passing argument 2 of 'test_and_set_bit' from incompatible pointer type [-Wincompatible-pointer-types]
    arch/csky/abiv2/inc/abi/cacheflush.h:23:39: error: passing argument 2 of 'const_test_bit' from incompatible pointer type [-Werror=incompatible-pointer-types]
    arch/csky/abiv2/inc/abi/cacheflush.h:23:39: error: passing argument 2 of 'const_test_bit' from incompatible pointer type [-Wincompatible-pointer-types]
    arch/csky/abiv2/inc/abi/cacheflush.h:23:39: error: passing argument 2 of 'generic_test_bit' from incompatible pointer type [-Werror=incompatible-pointer-types]
    arch/csky/abiv2/inc/abi/cacheflush.h:24:44: error: passing argument 2 of 'clear_bit' from incompatible pointer type [-Werror=incompatible-pointer-types]
    drivers/hid/hid-steelseries.c:599:1: warning: label 'srws1_remove' defined but not used [-Wunused-label]
    drivers/infiniband/hw/mlx5/mr.c:840:31: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
    drivers/mfd/tps6594-core.c:753:7: error: call to undeclared function 'FIELD_GET'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    drivers/mfd/tps6594-core.c:767:21: error: implicit declaration of function 'FIELD_GET' [-Werror=implicit-function-declaration]
    drivers/mfd/tps6594-core.c:767:21: error: implicit declaration of function 'FIELD_GET' [-Wimplicit-function-declaration]
    drivers/mfd/tps6594-core.c:767:7: error: call to undeclared function 'FIELD_GET'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    drivers/mfd/tps6594-core.c:767:7: error: implicit declaration of function 'FIELD_GET' [-Werror=implicit-function-declaration]
    include/linux/fortify-string.h:115:30: warning: argument 2 null where non-null expected [-Wnonnull]
    include/linux/fortify-string.h:115:33: warning: argument 2 null where non-null expected [-Wnonnull]

Unverified Error/Warning (likely false positive, kindly check if interested):

    ERROR: modpost: __ex_table+0x1444 references non-executable section '__tracepoints_strings'
    drivers/char/tpm/tpm_ppi.c:349 tpm_show_ppi_tcg_operations() warn: inconsistent returns 'global &tpm_ppi_lock'.
    drivers/char/tpm/tpm_ppi.c:378 tpm_show_ppi_vs_operations() warn: inconsistent returns 'global &tpm_ppi_lock'.
    drivers/gpu/drm/xe/xe_bo.c:2225 xe_bo_create_novm() error: uninitialized symbol 'bo'.
    drivers/gpu/drm/xe/xe_bo.c:2914 xe_gem_create_ioctl() error: uninitialized symbol 'bo'.
    drivers/gpu/drm/xe/xe_dma_buf.c:253 xe_dma_buf_init_obj() error: uninitialized symbol 'bo'.
    drivers/gpu/drm/xe/xe_vm.c:2408 new_vma() error: uninitialized symbol 'vma'.
    io_uring/query.c:98 io_query() error: uninitialized symbol 'ret'.
    kernel/power/energy_model.c:649 em_dev_register_pd_no_update() error: we previously assumed 'dev->em_pd' could be null (see line 594)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- alpha-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- alpha-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- alpha-randconfig-r121-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- mm-slub.c:sparse:sparse:non-ANSI-function-declaration-of-function-flush_all_rcu_sheaves
|-- alpha-randconfig-r133-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- mm-slub.c:sparse:sparse:non-ANSI-function-declaration-of-function-flush_all_rcu_sheaves
|-- arc-alldefconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-randconfig-002-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-bcm2835_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-001-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm47094-linksys-panamera.dts.-.:Warning-(avoid_unnecessary_addr_size):mdio-mux-mdio-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ra
|   |-- arch-arm-boot-dts-broadcom-bcm5301x-nand-cs0.dtsi.-.:Warning-(avoid_unnecessary_addr_size):nand-controller-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-hisilicon-hi3620.dtsi.-.:Warning-(avoid_unnecessary_addr_size):amba-bus-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-stuib.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-snowball.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am3517.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-pinmux-480025d8:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm814x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4ls-control-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm816x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-scrm-clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm816x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-scrm-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap3-gta04.dtsi.-.:Warning-(avoid_unnecessary_addr_size):pinmux-480022d8:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap3-gta04.dtsi.-.:Warning-(avoid_unnecessary_addr_size):pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap3-overo-alto35-common.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-proper
|   |-- arch-arm-boot-dts-ti-omap-omap3-overo-chestnut43-common.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-ti-omap-omap3-overo-gallop43-common.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-prop
|   |-- arch-arm-boot-dts-ti-omap-omap3-overo-palo35-common.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-proper
|   |-- arch-arm-boot-dts-ti-omap-omap3-overo-palo43-common.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-proper
|   |-- arch-arm-boot-dts-ti-omap-omap3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-pinmux-a00:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap34xx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-pinmux-480025d8:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap36xx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-pinmux-480025a0:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm-boot-dts-ti-omap-omap5-uevm.dts.-.:Warning-(avoid_unnecessary_addr_size):evm_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm-randconfig-002-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-arm-boot-dts-nxp-imx-imx7d.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   `-- arch-arm-boot-dts-nxp-vf-vfxxx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-spi-400ad000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm-randconfig-003-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-004-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-051-20250911
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_buttons0:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sl50.dts.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm814x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4ls-control-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm816x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-scrm-clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm816x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-scrm-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm-boot-dts-ti-omap-omap5-uevm.dts.-.:Warning-(avoid_unnecessary_addr_size):evm_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm-randconfig-r113-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-fortify-string.h:warning:argument-null-where-non-null-expected
|-- arm64-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-002-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-003-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-fortify-string.h:warning:argument-null-where-non-null-expected
|-- arm64-randconfig-004-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-051-20250911
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-fairphone-fp5.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-shift-otter.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-industrial-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-vision-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-crd-r3.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd-pro.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-herobrine-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r0.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm6350-sony-xperia-lena-pdx213.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7325-nothing-spacewar.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-r8q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-x1q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
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
|-- arm64-randconfig-052-20250911
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-fairphone-fp5.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-shift-otter.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-industrial-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-vision-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-crd-r3.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd-pro.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-herobrine-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r0.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm6350-sony-xperia-lena-pdx213.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7325-nothing-spacewar.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-r8q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
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
|-- arm64-randconfig-053-20250911
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-fairphone-fp5.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-shift-otter.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-industrial-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-vision-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-crd-r3.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd-pro.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-herobrine-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r0.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm6350-sony-xperia-lena-pdx213.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7325-nothing-spacewar.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-r8q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
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
|-- arm64-randconfig-054-20250911
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-fairphone-fp5.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-shift-otter.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-industrial-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-vision-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-crd-r3.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd-pro.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-herobrine-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r0.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm6350-sony-xperia-lena-pdx213.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7325-nothing-spacewar.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-r8q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
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
|-- arm64-randconfig-055-20250911
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-fairphone-fp5.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-shift-otter.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-industrial-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-vision-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-crd-r3.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd-pro.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-herobrine-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r0.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm6350-sony-xperia-lena-pdx213.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7325-nothing-spacewar.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-r8q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
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
|-- arm64-randconfig-r112-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   `-- mm-slub.c:sparse:sparse:non-ANSI-function-declaration-of-function-flush_all_rcu_sheaves
|-- csky-allnoconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-defconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-randconfig-001-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-randconfig-001-20250912
|   `-- drivers-hid-hid-steelseries.c:warning:label-srws1_remove-defined-but-not-used
|-- csky-randconfig-002-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- hexagon-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-randconfig-001-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-randconfig-002-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-002-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-buildonly-randconfig-003-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-004-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-buildonly-randconfig-005-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-006-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-061-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-062-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-063-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-141-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_bo.c-xe_bo_create_novm()-error:uninitialized-symbol-bo-.
|   |-- drivers-gpu-drm-xe-xe_bo.c-xe_gem_create_ioctl()-error:uninitialized-symbol-bo-.
|   |-- drivers-gpu-drm-xe-xe_dma_buf.c-xe_dma_buf_init_obj()-error:uninitialized-symbol-bo-.
|   `-- drivers-gpu-drm-xe-xe_vm.c-new_vma()-error:uninitialized-symbol-vma-.
|-- i386-randconfig-r122-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- mm-slub.c:sparse:sparse:non-ANSI-function-declaration-of-function-flush_all_rcu_sheaves
|-- loongarch-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-randconfig-002-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- m68k-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- m68k-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- m68k-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- microblaze-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- microblaze-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-randconfig-001-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- nios2-randconfig-002-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- openrisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- openrisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- openrisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-001-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-randconfig-002-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-eiger_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-ppc6xx_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-002-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-003-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- powerpc64-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-002-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-fortify-string.h:warning:argument-null-where-non-null-expected
|-- powerpc64-randconfig-003-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-002-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- ERROR:__ex_table-references-non-executable-section-__tracepoints_strings
|-- s390-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-infiniband-hw-mlx5-mr.c:warning:sprintf-may-write-a-terminating-nul-past-the-end-of-the-destination
|-- s390-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-002-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-002-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-r132-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- mm-slub.c:sparse:sparse:non-ANSI-function-declaration-of-function-flush_all_rcu_sheaves
|-- sparc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-002-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-001-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc64-randconfig-002-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- sparc64-randconfig-r111-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- mm-slub.c:sparse:sparse:non-ANSI-function-declaration-of-function-flush_all_rcu_sheaves
|-- um-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-i386_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-002-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-x86_64_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-001-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-002-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-003-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-004-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-005-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-006-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-121-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|-- x86_64-randconfig-122-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|-- x86_64-randconfig-123-20250911
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-161-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-char-tpm-tpm_ppi.c-tpm_show_ppi_tcg_operations()-warn:inconsistent-returns-global-tpm_ppi_lock-.
|   |-- drivers-char-tpm-tpm_ppi.c-tpm_show_ppi_vs_operations()-warn:inconsistent-returns-global-tpm_ppi_lock-.
|   |-- io_uring-query.c-io_query()-error:uninitialized-symbol-ret-.
|   `-- kernel-power-energy_model.c-em_dev_register_pd_no_update()-error:we-previously-assumed-dev-em_pd-could-be-null-(see-line-)
|-- x86_64-rhel-9.4-rust
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- xtensa-audio_kc705_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-randconfig-001-20250911
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
`-- xtensa-randconfig-002-20250911
    |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
    `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET

elapsed time: 865m

configs tested: 132
configs skipped: 5

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              alldefconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250911    gcc-8.5.0
arc                   randconfig-002-20250911    gcc-12.5.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                         bcm2835_defconfig    clang-22
arm                                 defconfig    clang-22
arm                   randconfig-001-20250911    clang-22
arm                   randconfig-002-20250911    gcc-14.3.0
arm                   randconfig-003-20250911    clang-22
arm                   randconfig-004-20250911    clang-16
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250911    gcc-13.4.0
arm64                 randconfig-002-20250911    gcc-8.5.0
arm64                 randconfig-003-20250911    gcc-8.5.0
arm64                 randconfig-004-20250911    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250911    gcc-15.1.0
csky                  randconfig-002-20250911    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250911    clang-20
hexagon               randconfig-002-20250911    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20250911    clang-20
i386        buildonly-randconfig-002-20250911    clang-20
i386        buildonly-randconfig-003-20250911    clang-20
i386        buildonly-randconfig-004-20250911    clang-20
i386        buildonly-randconfig-005-20250911    clang-20
i386        buildonly-randconfig-006-20250911    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250911    gcc-15.1.0
loongarch             randconfig-002-20250911    gcc-15.1.0
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
nios2                 randconfig-001-20250911    gcc-11.5.0
nios2                 randconfig-002-20250911    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250911    gcc-8.5.0
parisc                randconfig-002-20250911    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                       eiger_defconfig    clang-22
powerpc                      ppc6xx_defconfig    gcc-15.1.0
powerpc               randconfig-001-20250911    gcc-8.5.0
powerpc               randconfig-002-20250911    gcc-15.1.0
powerpc               randconfig-003-20250911    gcc-8.5.0
powerpc64             randconfig-001-20250911    clang-22
powerpc64             randconfig-002-20250911    gcc-11.5.0
powerpc64             randconfig-003-20250911    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250911    clang-20
riscv                 randconfig-002-20250911    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250911    gcc-11.5.0
s390                  randconfig-002-20250911    clang-16
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250911    gcc-9.5.0
sh                    randconfig-002-20250911    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250911    gcc-15.1.0
sparc                 randconfig-002-20250911    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250911    gcc-8.5.0
sparc64               randconfig-002-20250911    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20250911    clang-22
um                    randconfig-002-20250911    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250911    gcc-14
x86_64      buildonly-randconfig-002-20250911    gcc-14
x86_64      buildonly-randconfig-003-20250911    clang-20
x86_64      buildonly-randconfig-004-20250911    clang-20
x86_64      buildonly-randconfig-005-20250911    clang-20
x86_64      buildonly-randconfig-006-20250911    gcc-14
x86_64                              defconfig    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                  audio_kc705_defconfig    gcc-15.1.0
xtensa                randconfig-001-20250911    gcc-12.5.0
xtensa                randconfig-002-20250911    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

