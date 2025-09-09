Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D4E7CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E808E000B; Tue,  9 Sep 2025 15:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD258E0001; Tue,  9 Sep 2025 15:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4DF8E000B; Tue,  9 Sep 2025 15:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 474E18E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:26:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1B47BAFBB
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:26:33 +0000 (UTC)
X-FDA: 83870693466.07.CA38398
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6474E4000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:26:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h4lV7Mpf;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757445992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=hNg+byozxa+9XsX8pDdBlQ6Wvg1uFijhBcg3BpqHt3c=;
	b=QISSYSx4fEgP3/K3eCYsdIamWqgY9Aqc+iPCz/LnQBWX53spO8fsjKovkzySscA+u+0rzC
	xb5eo5D52NKobV3wXM5/SHUIzqoEuFvHeSl30dFEeBFz40BVomhKmtOXxfo0bY2u6H5nB+
	pSSA4exnIgq5AjcIP5PFZ532qPpFUoA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h4lV7Mpf;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757445992; a=rsa-sha256;
	cv=none;
	b=ETfXSDegNDgikOu/5XV6aP3umIxOQtpanl1Jq8XhbyZx0te0SFMGGEIlVgpWxQ/XpEZyKg
	J3jlJgnshWbnuebHFT1dZLhU5fsdbrKXKwMv7CEd1tw9hvq/8KKkWgF/KU9Cm1umg9R9P7
	mXvjbMAg5uEHOxBZJcepBQ+8in/VvOk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757445991; x=1788981991;
  h=date:from:to:cc:subject:message-id;
  bh=DfGP5cCCKDorY9K0WFgKdg5WZ/qexEkvzDLsY6IuoTc=;
  b=h4lV7MpfhRg0WOp/hwsDUn80AxzgnQB+gCjsvXgnVPwmzZOlC/jtIoNZ
   A1yo8wiy67f+9CuUsGgu2IyYFAGe5qjM1W9Q8/hW3fy+CuADQNZU5Qh4b
   UCvcsjXfPZ6PyflAcK8+HwEm3eGg19pKp5ddvZmKYJdxeUwbAoWT/Af2l
   MP+ZEtDBlmE7mud5hGFVh+mqx8//QA8o+kd2AaWGlVRKXapnsbdyUH2Eh
   nFJRSoTMCHJUISowORUEKOgm6Qj6kGdj9h6sXUuFAtUEqVstmbNQCD+aO
   mSj93hrnRNkQ5x/Kwri7K45gjj4ftNyL/hgN/fx1Qu247hqgDYcRtXz6H
   A==;
X-CSE-ConnectionGUID: EU3Y03lST+SreVf+968uLw==
X-CSE-MsgGUID: pHxeiWHwTBCwcYAqCIB2Pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63573684"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63573684"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 12:26:30 -0700
X-CSE-ConnectionGUID: o1xYFd3uQ0qDgN+zfU1zyQ==
X-CSE-MsgGUID: ya80wNsFS0mbJUtMQU6XGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="177515930"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 09 Sep 2025 12:26:28 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uw3yz-0005D5-0l;
	Tue, 09 Sep 2025 19:26:25 +0000
Date: Wed, 10 Sep 2025 03:26:06 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 65dd046ef55861190ecde44c6d9fcde54b9fb77d
Message-ID: <202509100310.Ssbqjym7-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6474E4000B
X-Stat-Signature: y9azgb5nmpjbuofzfg69t9x4znsw47b4
X-HE-Tag: 1757445991-97403
X-HE-Meta: U2FsdGVkX19TiIM5ktja4jqvfWIF6E/lgFpY/5VahUhqQ51AXsCH7FXmPfyg8aWXmSODO9aTGt0gXghpmFl6eYEKfhlay5ec3Y0YbUO8S5txX1AkGxVg87yUUvHSssAut8wpAJFz3ONfCXVDYXTCIYYv02+KhC6cdRQJLhJgGY6Tjgy7PE3lReRVASB1qR4EeRsQ7clwrS/63JHf1qAji/UCQaWw4Q66iRRh580kvI2m46HOO9uUR3fHTK2Ve3h9QUraXlt79dNlXl7jZU0796SLkk9nQtvUPqKsktQzfART/nDX0zn9+7w4rMnz1qES7ncnIGju9y0PSNEKhB4QfYyOtklUi9I7Q8wU74CPdEfIsI5pnKp9/mXZTUn7mEhy7XAYDPDoVGp0E5yk9PnjNUsKjFvUWB6hRMOhcVPq8riaLyob44/fDxNzVmEC1zDKOuxmvxycFtp128vYD/M0OCV/sGAbUeic/oEnfzmzNwtqV2UxaxnDwO2RL5VXA9kQPZVIJ14rvN54+HEOHTyVJePop3/T0lrCtZW7rwdtwoJ+xxL8aJc9582iSEz1AMnAM9I2Nwy6eDkZnjBocfE1rhpQUe6+KeGqnmlvuntS/Om2p0Kw36YbLeUU14I+8HkJ062Qeub2HpJ3MUeGkgfBUFyL3qIisA8DDeOmguV/TjgpTPFEf/J0JmO189ItAncUFEqaMe5nuxTkm0B35Dm2p7cQ/e1mc1qoQ9PruCqYnEe80zmI/0YSR3EjAS6/hIBekRZUSSp4nsNITNDm315QJgcU38eOWq0Dcv0mKiVLo7Gzy3i2a7Fmsg762ggRbic4ShGUMse9iDauY2jBnhPNlTTSOr4Rf4uYrJpVw8Bdn8tQyI9pwWZOUYqmSamcEnAt+hgVRh8YS43imqCa6fhasZNBQOk4g1ZmRYjWSrmZQF0RRnMp2MACSrYI4lxX9gTtI7FEa8wNqKuStTsK9pb
 aSv/btl8
 hMY11gPD9GyorZfM56NENR323V5InywmQ1Jwr+wECNfd+hiTf787flUvqBr5mwtWSGXzlgT3g4PFT715xENYV3TyU8iQ9rkJ/3FhmMexsApu4R/xCNaCh6qk5fmzqXPtrZ/u2oknMfaC52ym/TnQq7oNIFVRpfL4De+qyEoHejvxkXUIyx+RsIJEiVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 65dd046ef55861190ecde44c6d9fcde54b9fb77d  Add linux-next specific files for 20250909

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202508121500.RvXjS54z-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508122300.QreDWTZr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508141518.uFdkyMsT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508211859.UoYsJbLN-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508231902.ZRQhIhd5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509030125.8uFYoFGf-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509092211.N6B8XbDf-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509100708.5mJZ2cLm-lkp@intel.com

    Warning: fs/ceph/mds_client.c:2704 function parameter 'path_info' not described in 'ceph_mdsc_build_path'
    arch/arm/boot/dts/alphascale/alphascale-asm9260.dtsi:19.7-28.4: Warning (avoid_unnecessary_addr_size): /cpus: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/arm/integratorap-im-pd1.dts:86.12-127.4: Warning (avoid_unnecessary_addr_size): /bus@c0000000/bus@c0000000/gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/arm/integratorap.dts:176.3-197.5: Warning (interrupt_map): /pci@62000000:interrupt-map: Missing property '#address-cells' in node /pic@14000000, using 0 as fallback
    arch/arm/boot/dts/arm/integratorcp.dts:198.9-223.4: Warning (avoid_unnecessary_addr_size): /bridge: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/arm/versatile-pb.dts:59.4-77.29: Warning (interrupt_map): /amba/pci@10001000:interrupt-map: Missing property '#address-cells' in node /amba/interrupt-controller@10003000, using 0 as fallback
    arch/arm/boot/dts/broadcom/bcm2711.dtsi:564.4-571.11: Warning (interrupt_map): /scb/pcie@7d500000:interrupt-map: Missing property '#address-cells' in node /soc/interrupt-controller@40041000, using 0 as fallback
    arch/arm/boot/dts/broadcom/bcm47094-linksys-panamera.dts:140.13-191.6: Warning (avoid_unnecessary_addr_size): /mdio-mux@18003000/mdio@200/switch@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/broadcom/bcm5301x-nand-cs0.dtsi:10.18-19.5: Warning (avoid_unnecessary_addr_size): /nand-controller@18028000/nand@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/hisilicon/hi3620.dtsi:544.23-563.5: Warning (avoid_unnecessary_addr_size): /amba-bus/pinmux@803000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/marvell/armada-381-netgear-gs110emx.dts:243.10-286.4: Warning (avoid_unnecessary_addr_size): /soc/spi@10600/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/marvell/armada-385-atl-x530.dts:182.10-210.4: Warning (avoid_unnecessary_addr_size): /soc/spi@10680/flash@1: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/marvell/armada-385-db-88f6820-amc.dts:129.10-150.4: Warning (avoid_unnecessary_addr_size): /soc/spi@10680/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/marvell/armada-385-turris-omnia.dts:564.10-586.4: Warning (avoid_unnecessary_addr_size): /soc/spi@10600/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/marvell/armada-390-db.dts:84.10-106.4: Warning (avoid_unnecessary_addr_size): /soc/spi@10680/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/marvell/armada-39x.dtsi:447.5-450.31: Warning (interrupt_map): /soc/pcie/pcie@1,0:interrupt-map: Missing property '#address-cells' in node /soc/pcie/pcie@1,0/interrupt-controller, using 0 as fallback
    arch/arm/boot/dts/marvell/armada-xp-98dx3236.dtsi:86.5-89.31: Warning (interrupt_map): /soc/pcie@82000000/pcie@1,0:interrupt-map: Missing property '#address-cells' in node /soc/pcie@82000000/pcie@1,0/interrupt-controller, using 0 as fallback
    arch/arm/boot/dts/marvell/armada-xp-mv78230.dtsi:93.5-96.31: Warning (interrupt_map): /soc/pcie@82000000/pcie@1,0:interrupt-map: Missing property '#address-cells' in node /soc/pcie@82000000/pcie@1,0/interrupt-controller, using 0 as fallback
    arch/arm/boot/dts/marvell/armada-xp-mv78260.dtsi:108.5-111.31: Warning (interrupt_map): /soc/pcie@82000000/pcie@1,0:interrupt-map: Missing property '#address-cells' in node /soc/pcie@82000000/pcie@1,0/interrupt-controller, using 0 as fallback
    arch/arm/boot/dts/marvell/armada-xp-mv78460.dtsi:129.5-132.31: Warning (interrupt_map): /soc/pcie@82000000/pcie@1,0:interrupt-map: Missing property '#address-cells' in node /soc/pcie@82000000/pcie@1,0/interrupt-controller, using 0 as fallback
    arch/arm/boot/dts/marvell/armada-xp-mv78460.dtsi:381.5-384.32: Warning (interrupt_map): /soc/pcie@82000000/pcie@a,0:interrupt-map: Missing property '#address-cells' in node /soc/pcie@82000000/pcie@a,0/interrupt-controller, using 0 as fallback
    arch/arm/boot/dts/mediatek/mt6572-jty-d101.dts:17.9-30.4: Warning (avoid_unnecessary_addr_size): /chosen: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/mediatek/mt6572-lenovo-a369i.dts:17.9-30.4: Warning (avoid_unnecessary_addr_size): /chosen: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/mediatek/mt7623.dtsi:766.3-768.36: Warning (interrupt_map): /pcie@1a140000:interrupt-map: Missing property '#address-cells' in node /interrupt-controller@10200100, using 0 as fallback
    arch/arm/boot/dts/mediatek/mt7623.dtsi:794.4-46: Warning (interrupt_map): /pcie@1a140000/pcie@0,0:interrupt-map: Missing property '#address-cells' in node /interrupt-controller@10200100, using 0 as fallback
    arch/arm/boot/dts/nuvoton/nuvoton-npcm730-gbs.dts:361.10-402.4: Warning (avoid_unnecessary_addr_size): /ahb/spi@fb000000/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nuvoton/nuvoton-npcm730-gsj.dts:138.10-179.4: Warning (avoid_unnecessary_addr_size): /ahb/spi@fb000000/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nuvoton/nuvoton-npcm730-kudo.dts:383.10-417.4: Warning (avoid_unnecessary_addr_size): /ahb/spi@fb000000/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nuvoton/nuvoton-npcm730-kudo.dts:443.10-463.4: Warning (avoid_unnecessary_addr_size): /ahb/spi@c0000000/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nuvoton/nuvoton-npcm750-evb.dts:131.10-147.4: Warning (avoid_unnecessary_addr_size): /ahb/spi@c0000000/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nuvoton/nuvoton-npcm750-evb.dts:70.10-125.4: Warning (avoid_unnecessary_addr_size): /ahb/spi@fb000000/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nvidia/tegra124.dtsi:37.3-41: Warning (interrupt_map): /pcie@1003000:interrupt-map: Missing property '#address-cells' in node /interrupt-controller@50041000, using 0 as fallback
    arch/arm/boot/dts/nvidia/tegra20.dtsi:793.3-42: Warning (interrupt_map): /pcie@80003000:interrupt-map: Missing property '#address-cells' in node /interrupt-controller@50041000, using 0 as fallback
    arch/arm/boot/dts/nvidia/tegra30.dtsi:36.3-42: Warning (interrupt_map): /pcie@3000:interrupt-map: Missing property '#address-cells' in node /interrupt-controller@50041000, using 0 as fallback
    arch/arm/boot/dts/nxp/imx/imx6q-novena.dts:229.7-248.4: Warning (avoid_unnecessary_addr_size): /soc/bus@2100000/ethernet@2188000/mdio: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nxp/imx/imx6qdl-aristainetos2.dtsi:323.7-334.4: Warning (avoid_unnecessary_addr_size): /soc/bus@2100000/ethernet@2188000/mdio: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i-ads2.dtsi:13.8-43.4: Warning (avoid_unnecessary_addr_size): /sound: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nxp/imx/imx6qdl-nit6xlite.dtsi:191.7-210.4: Warning (avoid_unnecessary_addr_size): /soc/bus@2100000/ethernet@2188000/mdio: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nxp/imx/imx6qdl-nitrogen6_max.dtsi:330.7-349.4: Warning (avoid_unnecessary_addr_size): /soc/bus@2100000/ethernet@2188000/mdio: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nxp/imx/imx6qdl-nitrogen6x.dtsi:264.7-283.4: Warning (avoid_unnecessary_addr_size): /soc/bus@2100000/ethernet@2188000/mdio: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nxp/imx/imx6qdl-sabrelite.dtsi:287.7-306.4: Warning (avoid_unnecessary_addr_size): /soc/bus@2100000/ethernet@2188000/mdio: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nxp/imx/imx6qdl.dtsi:281.4-284.29: Warning (interrupt_map): /soc/pcie@1ffc000:interrupt-map: Missing property '#address-cells' in node /soc/bus@2000000/gpc@20dc000, using 0 as fallback
    arch/arm/boot/dts/nxp/imx/imx6qdl.dtsi:56.9-74.4: Warning (avoid_unnecessary_addr_size): /clocks: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nxp/imx/imx6sx.dtsi:1461.4-1464.29: Warning (interrupt_map): /soc/pcie@8ffc000:interrupt-map: Missing property '#address-cells' in node /soc/bus@2000000/gpc@20dc000, using 0 as fallback
    arch/arm/boot/dts/nxp/imx/imx7d.dtsi:137.4-140.30: Warning (interrupt_map): /soc/pcie@33800000:interrupt-map: Missing property '#address-cells' in node /soc/interrupt-controller@31001000, using 0 as fallback
    arch/arm/boot/dts/nxp/ls/ls1021a-tsn.dts:254.10-282.4: Warning (avoid_unnecessary_addr_size): /soc/spi@1550000/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nxp/ls/ls1021a-tsn.dts:41.29-104.4: Warning (avoid_unnecessary_addr_size): /soc/spi@2100000/ethernet-switch@1: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/nxp/ls/ls1021a.dtsi:193.5-199.25: Warning (interrupt_map): /soc/scfg@1570000/interrupt-controller@1ac:interrupt-map: Missing property '#address-cells' in node /soc/interrupt-controller@1401000, using 0 as fallback
    arch/arm/boot/dts/nxp/ls/ls1021a.dtsi:820.4-823.32: Warning (interrupt_map): /soc/pcie@3400000:interrupt-map: Missing property '#address-cells' in node /soc/interrupt-controller@1401000, using 0 as fallback
    arch/arm/boot/dts/nxp/vf/vfxxx.dtsi:542.24-554.6: Warning (avoid_unnecessary_addr_size): /soc/bus@40080000/spi@400ad000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-href-stuib.dtsi:9.12-29.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-href-tvk1281618-r2.dtsi:10.12-30.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-href-tvk1281618-r3.dtsi:11.12-25.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-hrefprev60.dtsi:12.12-16.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-snowball.dts:62.12-102.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/synaptics/berlin2q-marvell-dmp.dts:25.13-78.4: Warning (avoid_unnecessary_addr_size): /regulators: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/am335x-evmsk.dts:124.30-153.4: Warning (avoid_unnecessary_addr_size): /gpio_buttons0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/am335x-sl50.dts:103.9-123.4: Warning (avoid_unnecessary_addr_size): /clocks: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/am3517.dtsi:126.36-136.5: Warning (avoid_unnecessary_addr_size): /ocp@68000000/pinmux@480025d8: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/dm814x.dtsi:479.25-487.7: Warning (avoid_unnecessary_addr_size): /ocp/l4ls@48000000/control@140000/pinmux@800: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/dm816x.dtsi:130.24-133.6: Warning (avoid_unnecessary_addr_size): /ocp/scrm@48140000/clocks: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/dm816x.dtsi:91.30-99.6: Warning (avoid_unnecessary_addr_size): /ocp/scrm@48140000/pinmux@800: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap2.dtsi:28.7-36.4: Warning (avoid_unnecessary_addr_size): /cpus: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap2420.dtsi:41.29-50.7: Warning (avoid_unnecessary_addr_size): /ocp/l4@48000000/scm@0/pinmux@30: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/omap/omap2420.dtsi:52.28-62.7: Warning (avoid_unnecessary_addr_size): /ocp/l4@48000000/scm@0/scm_conf@270: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
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
    arch/arm64/boot/dts/nvidia/tegra186.dtsi:1355.3-41: Warning (interrupt_map): /pcie@10003000:interrupt-map: Missing property '#address-cells' in node /interrupt-controller@3881000, using 0 as fallback
    arch/arm64/boot/dts/nvidia/tegra194.dtsi:2391.4-42: Warning (interrupt_map): /bus@0/pcie@14100000:interrupt-map: Missing property '#address-cells' in node /bus@0/interrupt-controller@3881000, using 0 as fallback
    arch/arm64/boot/dts/nvidia/tegra194.dtsi:2734.4-42: Warning (interrupt_map): /bus@0/pcie@141a0000:interrupt-map: Missing property '#address-cells' in node /bus@0/interrupt-controller@3881000, using 0 as fallback
    arch/arm64/boot/dts/qcom/lemans.dtsi:4497.28-4558.6: Warning (avoid_unnecessary_addr_size): /soc@0/display-subsystem@ae00000/dsi@ae94000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/lemans.dtsi:4579.28-4631.6: Warning (avoid_unnecessary_addr_size): /soc@0/display-subsystem@ae00000/dsi@ae96000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/sm8550.dtsi:4093.22-4183.5: Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/sm8650.dtsi:5049.22-5140.5: Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/csky/abiv2/cacheflush.c:24:47: error: passing argument 2 of 'test_and_set_bit' from incompatible pointer type [-Wincompatible-pointer-types]
    arch/csky/abiv2/inc/abi/cacheflush.h:23:39: error: passing argument 2 of 'const_test_bit' from incompatible pointer type [-Wincompatible-pointer-types]
    arch/sh/include/asm/atomic-irq.h:69:(.text+0xe34): undefined reference to `page_range_contiguous'
    arm-linux-gnueabi-ld: drivers/iio/adc/ad7779.c:646:(.text+0xd4): undefined reference to `iio_backend_chan_disable'
    arm-linux-gnueabi-ld: drivers/iio/adc/ad7779.c:886:(.text+0x35d0): undefined reference to `devm_iio_backend_request_buffer'
    arm-linux-gnueabi-ld: drivers/iio/adc/ad7779.c:890:(.text+0x3608): undefined reference to `devm_iio_backend_enable'
    drivers/iio/adc/ad7779.c:644:(.text+0xcc): undefined reference to `iio_backend_chan_enable'
    drivers/iio/adc/ad7779.c:795:(.text+0x3128): undefined reference to `iio_backend_num_lanes_set'
    drivers/iio/adc/ad7779.c:881:(.text+0x3514): undefined reference to `devm_iio_backend_get'
    drivers/infiniband/hw/mlx5/mr.c:840:31: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]

Unverified Error/Warning (likely false positive, kindly check if interested):

    arch/mips/boot/dts/mti/sead3.dts:69.17-91.4: Warning (avoid_unnecessary_addr_size): /flash@1c000000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-randconfig-001-20250909
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arm-allmodconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- arch-arm-boot-dts-arm-integratorap-im-pd1.dts.-.:Warning-(avoid_unnecessary_addr_size):bus-c0000000-bus-c0000000-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-arm-integratorap.dts.-.:Warning-(interrupt_map):pci:interrupt-map:Missing-property-address-cells-in-node-pic-using-as-fallback
|   |-- arch-arm-boot-dts-arm-integratorcp.dts.-.:Warning-(avoid_unnecessary_addr_size):bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm47094-linksys-panamera.dts.-.:Warning-(avoid_unnecessary_addr_size):mdio-mux-mdio-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ra
|   |-- arch-arm-boot-dts-broadcom-bcm5301x-nand-cs0.dtsi.-.:Warning-(avoid_unnecessary_addr_size):nand-controller-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-hisilicon-hi3620.dtsi.-.:Warning-(avoid_unnecessary_addr_size):amba-bus-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-39x.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-atl-x530.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-db-88f6820-amc.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-propert
|   |-- arch-arm-boot-dts-marvell-armada-db.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-netgear-gs110emx.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-prope
|   |-- arch-arm-boot-dts-marvell-armada-turris-omnia.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-xp-98dx3236.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78230.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78260.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78460.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie-a:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-a-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78460.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt6572-jty-d101.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-lenovo-a369i.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.-.:Warning-(interrupt_map):pcie-1a140000:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.:Warning-(interrupt_map):pcie-1a140000-pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-gbs.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-gsj.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-kudo.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-c0000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-kudo.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm750-evb.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-c0000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm750-evb.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-nvidia-tegra124.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nvidia-tegra20.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nvidia-tegra30.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-aristainetos2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-kontron-samx6i-ads2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):sound:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nit6xlite.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nitrogen6_max.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nitrogen6x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-p
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-sabrelite.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl.dtsi.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl.dtsi.-.:Warning-(interrupt_map):soc-pcie-1ffc000:interrupt-map:Missing-property-address-cells-in-node-soc-bus-gpc-20dc000-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx6sx.dtsi.-.:Warning-(interrupt_map):soc-pcie-8ffc000:interrupt-map:Missing-property-address-cells-in-node-soc-bus-gpc-20dc000-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx7d.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-tsn.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-ethernet-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-tsn.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a.dtsi.-.:Warning-(interrupt_map):soc-scfg-interrupt-controller-1ac:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-vf-vfxxx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-spi-400ad000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-stuib.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-snowball.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-synaptics-berlin2q-marvell-dmp.dts.-.:Warning-(avoid_unnecessary_addr_size):regulators:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_buttons0:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sl50.dts.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am3517.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-pinmux-480025d8:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm814x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4ls-control-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm816x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-scrm-clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm816x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-scrm-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap2420.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap2420.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-scm_conf:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- arch-arm-boot-dts-arm-integratorap-im-pd1.dts.-.:Warning-(avoid_unnecessary_addr_size):bus-c0000000-bus-c0000000-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-arm-integratorap.dts.-.:Warning-(interrupt_map):pci:interrupt-map:Missing-property-address-cells-in-node-pic-using-as-fallback
|   |-- arch-arm-boot-dts-arm-integratorcp.dts.-.:Warning-(avoid_unnecessary_addr_size):bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm47094-linksys-panamera.dts.-.:Warning-(avoid_unnecessary_addr_size):mdio-mux-mdio-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ra
|   |-- arch-arm-boot-dts-broadcom-bcm5301x-nand-cs0.dtsi.-.:Warning-(avoid_unnecessary_addr_size):nand-controller-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-hisilicon-hi3620.dtsi.-.:Warning-(avoid_unnecessary_addr_size):amba-bus-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-39x.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-atl-x530.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-db-88f6820-amc.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-propert
|   |-- arch-arm-boot-dts-marvell-armada-db.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-netgear-gs110emx.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-prope
|   |-- arch-arm-boot-dts-marvell-armada-turris-omnia.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-xp-98dx3236.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78230.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78260.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78460.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie-a:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-a-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78460.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt6572-jty-d101.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-lenovo-a369i.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.-.:Warning-(interrupt_map):pcie-1a140000:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.:Warning-(interrupt_map):pcie-1a140000-pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-gbs.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-gsj.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-kudo.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-c0000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-kudo.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm750-evb.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-c0000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm750-evb.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-nvidia-tegra124.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nvidia-tegra20.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nvidia-tegra30.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-aristainetos2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-kontron-samx6i-ads2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):sound:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nit6xlite.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nitrogen6_max.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nitrogen6x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-p
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-sabrelite.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl.dtsi.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl.dtsi.-.:Warning-(interrupt_map):soc-pcie-1ffc000:interrupt-map:Missing-property-address-cells-in-node-soc-bus-gpc-20dc000-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx6sx.dtsi.-.:Warning-(interrupt_map):soc-pcie-8ffc000:interrupt-map:Missing-property-address-cells-in-node-soc-bus-gpc-20dc000-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx7d.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-tsn.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-ethernet-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-tsn.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a.dtsi.-.:Warning-(interrupt_map):soc-scfg-interrupt-controller-1ac:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-vf-vfxxx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-spi-400ad000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-stuib.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-snowball.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-synaptics-berlin2q-marvell-dmp.dts.-.:Warning-(avoid_unnecessary_addr_size):regulators:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_buttons0:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sl50.dts.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am3517.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-pinmux-480025d8:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm814x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4ls-control-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm816x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-scrm-clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-dm816x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-scrm-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap2420.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap2420.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-scm_conf:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm-defconfig
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm47094-linksys-panamera.dts.-.:Warning-(avoid_unnecessary_addr_size):mdio-mux-mdio-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ra
|   |-- arch-arm-boot-dts-broadcom-bcm5301x-nand-cs0.dtsi.-.:Warning-(avoid_unnecessary_addr_size):nand-controller-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-hisilicon-hi3620.dtsi.-.:Warning-(avoid_unnecessary_addr_size):amba-bus-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-39x.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-atl-x530.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-db-88f6820-amc.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-propert
|   |-- arch-arm-boot-dts-marvell-armada-db.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-netgear-gs110emx.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-prope
|   |-- arch-arm-boot-dts-marvell-armada-turris-omnia.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-xp-98dx3236.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78230.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78260.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78460.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie-a:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-a-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78460.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt6572-jty-d101.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-lenovo-a369i.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.-.:Warning-(interrupt_map):pcie-1a140000:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.:Warning-(interrupt_map):pcie-1a140000-pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nvidia-tegra124.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nvidia-tegra20.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nvidia-tegra30.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-aristainetos2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-kontron-samx6i-ads2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):sound:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nit6xlite.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nitrogen6_max.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nitrogen6x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-p
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-sabrelite.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl.dtsi.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl.dtsi.-.:Warning-(interrupt_map):soc-pcie-1ffc000:interrupt-map:Missing-property-address-cells-in-node-soc-bus-gpc-20dc000-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx6sx.dtsi.-.:Warning-(interrupt_map):soc-pcie-8ffc000:interrupt-map:Missing-property-address-cells-in-node-soc-bus-gpc-20dc000-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx7d.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-tsn.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-ethernet-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-tsn.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a.dtsi.-.:Warning-(interrupt_map):soc-scfg-interrupt-controller-1ac:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-vf-vfxxx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-spi-400ad000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-stuib.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-snowball.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-synaptics-berlin2q-marvell-dmp.dts.-.:Warning-(avoid_unnecessary_addr_size):regulators:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_buttons0:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sl50.dts.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm-multi_v7_defconfig
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm47094-linksys-panamera.dts.-.:Warning-(avoid_unnecessary_addr_size):mdio-mux-mdio-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ra
|   |-- arch-arm-boot-dts-broadcom-bcm5301x-nand-cs0.dtsi.-.:Warning-(avoid_unnecessary_addr_size):nand-controller-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-hisilicon-hi3620.dtsi.-.:Warning-(avoid_unnecessary_addr_size):amba-bus-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-39x.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-atl-x530.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-db-88f6820-amc.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-propert
|   |-- arch-arm-boot-dts-marvell-armada-db.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-netgear-gs110emx.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-prope
|   |-- arch-arm-boot-dts-marvell-armada-turris-omnia.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-marvell-armada-xp-98dx3236.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78230.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78260.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78460.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie-a:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-a-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-marvell-armada-xp-mv78460.dtsi.-.:Warning-(interrupt_map):soc-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-pcie-pcie-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt6572-jty-d101.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-lenovo-a369i.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.-.:Warning-(interrupt_map):pcie-1a140000:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.:Warning-(interrupt_map):pcie-1a140000-pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nvidia-tegra124.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nvidia-tegra20.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nvidia-tegra30.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-aristainetos2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-kontron-samx6i-ads2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):sound:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nit6xlite.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nitrogen6_max.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-nitrogen6x.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-p
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl-sabrelite.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-ethernet-mdio:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl.dtsi.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-imx-imx6qdl.dtsi.-.:Warning-(interrupt_map):soc-pcie-1ffc000:interrupt-map:Missing-property-address-cells-in-node-soc-bus-gpc-20dc000-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx6sx.dtsi.-.:Warning-(interrupt_map):soc-pcie-8ffc000:interrupt-map:Missing-property-address-cells-in-node-soc-bus-gpc-20dc000-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-imx-imx7d.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-tsn.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-ethernet-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-tsn.dts.-.:Warning-(avoid_unnecessary_addr_size):soc-spi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a.dtsi.-.:Warning-(interrupt_map):soc-scfg-interrupt-controller-1ac:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nxp-vf-vfxxx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-spi-400ad000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-stuib.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-snowball.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-synaptics-berlin2q-marvell-dmp.dts.-.:Warning-(avoid_unnecessary_addr_size):regulators:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_buttons0:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sl50.dts.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm-randconfig-002-20250909
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm47094-linksys-panamera.dts.-.:Warning-(avoid_unnecessary_addr_size):mdio-mux-mdio-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ra
|   |-- arch-arm-boot-dts-broadcom-bcm5301x-nand-cs0.dtsi.-.:Warning-(avoid_unnecessary_addr_size):nand-controller-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-mediatek-mt6572-jty-d101.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-lenovo-a369i.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.-.:Warning-(interrupt_map):pcie-1a140000:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.:Warning-(interrupt_map):pcie-1a140000-pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-gbs.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-gsj.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-kudo.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-c0000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm730-kudo.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm750-evb.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-c0000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-nuvoton-nuvoton-npcm750-evb.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-spi-fb000000-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-
|   |-- arch-arm-boot-dts-st-ste-href-stuib.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-snowball.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm-boot-dts-ti-omap-omap5-uevm.dts.-.:Warning-(avoid_unnecessary_addr_size):evm_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm-randconfig-003-20250908
|   |-- arm-linux-gnueabi-ld:drivers-iio-adc-ad7779.c:(.text):undefined-reference-to-devm_iio_backend_enable
|   |-- arm-linux-gnueabi-ld:drivers-iio-adc-ad7779.c:(.text):undefined-reference-to-devm_iio_backend_request_buffer
|   |-- arm-linux-gnueabi-ld:drivers-iio-adc-ad7779.c:(.text):undefined-reference-to-iio_backend_chan_disable
|   |-- drivers-iio-adc-ad7779.c:(.text):undefined-reference-to-devm_iio_backend_get
|   |-- drivers-iio-adc-ad7779.c:(.text):undefined-reference-to-iio_backend_chan_enable
|   `-- drivers-iio-adc-ad7779.c:(.text):undefined-reference-to-iio_backend_num_lanes_set
|-- arm-randconfig-003-20250909
|   |-- arch-arm-boot-dts-mediatek-mt6572-jty-d101.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-lenovo-a369i.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.-.:Warning-(interrupt_map):pcie-1a140000:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.:Warning-(interrupt_map):pcie-1a140000-pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-synaptics-berlin2q-marvell-dmp.dts.-.:Warning-(avoid_unnecessary_addr_size):regulators:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-am3517.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-pinmux-480025d8:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm-randconfig-r111-20250909
|   |-- arch-arm-boot-dts-alphascale-alphascale-asm9260.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-arm-integratorap-im-pd1.dts.-.:Warning-(avoid_unnecessary_addr_size):bus-c0000000-bus-c0000000-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-arm-integratorap.dts.-.:Warning-(interrupt_map):pci:interrupt-map:Missing-property-address-cells-in-node-pic-using-as-fallback
|   |-- arch-arm-boot-dts-arm-integratorcp.dts.-.:Warning-(avoid_unnecessary_addr_size):bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm-boot-dts-arm-versatile-pb.dts.-.:Warning-(interrupt_map):amba-pci:interrupt-map:Missing-property-address-cells-in-node-amba-interrupt-controller-using-as-fallback
|-- arm-versatile_defconfig
|   `-- arch-arm-boot-dts-arm-versatile-pb.dts.-.:Warning-(interrupt_map):amba-pci:interrupt-map:Missing-property-address-cells-in-node-amba-interrupt-controller-using-as-fallback
|-- arm64-allmodconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-defconfig
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-001-20250909
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-002-20250909
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-003-20250909
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- csky-allnoconfig
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-defconfig
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-randconfig-001-20250909
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-randconfig-002-20250909
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- hexagon-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- hexagon-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- loongarch-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- loongarch-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- ld.lld:error:vmlinux.a(virt-kvm-eventfd.o):(function-kvm_notify_acked_gsi:.text):relocation-R_LARCH_B26-out-of-range:is-not-in-references-lock_is_held_type
|   `-- ld.lld:error:vmlinux.a(virt-kvm-eventfd.o):(function-kvm_notify_acked_irq:.text):relocation-R_LARCH_B26-out-of-range:is-not-in-references-dynamic_preempt_schedule_notrace
|-- loongarch-defconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- m68k-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- m68k-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- microblaze-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- microblaze-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- mips-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- arch-mips-boot-dts-mti-sead3.dts.-.:Warning-(avoid_unnecessary_addr_size):flash-1c000000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- openrisc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- parisc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- parisc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- parisc-randconfig-002-20250909
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc64-randconfig-r131-20250909
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|-- riscv-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- riscv-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- s390-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- s390-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- drivers-infiniband-hw-mlx5-mr.c:warning:sprintf-may-write-a-terminating-nul-past-the-end-of-the-destination
|-- sh-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sh-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sh-randconfig-r121-20250908
|   `-- arch-sh-include-asm-atomic-irq.h:(.text):undefined-reference-to-page_range_contiguous
|-- sparc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- um-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- um-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- x86_64-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- x86_64-rhel-9.4-rust
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
`-- xtensa-allyesconfig
    `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path

elapsed time: 727m

configs tested: 134
configs skipped: 5

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250909    gcc-8.5.0
arc                   randconfig-002-20250909    gcc-8.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                        multi_v7_defconfig    gcc-15.1.0
arm                             mxs_defconfig    clang-22
arm                       netwinder_defconfig    gcc-15.1.0
arm                   randconfig-001-20250909    clang-18
arm                   randconfig-002-20250909    clang-17
arm                   randconfig-003-20250909    clang-22
arm                   randconfig-004-20250909    clang-19
arm                       versatile_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250909    clang-16
arm64                 randconfig-002-20250909    gcc-11.5.0
arm64                 randconfig-003-20250909    gcc-11.5.0
arm64                 randconfig-004-20250909    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250909    gcc-15.1.0
csky                  randconfig-002-20250909    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250909    clang-22
hexagon               randconfig-002-20250909    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20250909    gcc-13
i386        buildonly-randconfig-002-20250909    clang-20
i386        buildonly-randconfig-003-20250909    clang-20
i386        buildonly-randconfig-004-20250909    clang-20
i386        buildonly-randconfig-005-20250909    clang-20
i386        buildonly-randconfig-006-20250909    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250909    gcc-15.1.0
loongarch             randconfig-002-20250909    gcc-15.1.0
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
nios2                 randconfig-001-20250909    gcc-11.5.0
nios2                 randconfig-002-20250909    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250909    gcc-8.5.0
parisc                randconfig-002-20250909    gcc-12.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                  mpc885_ads_defconfig    clang-22
powerpc                      pasemi_defconfig    clang-22
powerpc               randconfig-001-20250909    clang-22
powerpc               randconfig-002-20250909    clang-17
powerpc               randconfig-003-20250909    gcc-8.5.0
powerpc64             randconfig-001-20250909    clang-20
powerpc64             randconfig-002-20250909    gcc-10.5.0
powerpc64             randconfig-003-20250909    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250909    clang-22
riscv                 randconfig-002-20250909    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250909    gcc-11.5.0
s390                  randconfig-002-20250909    clang-18
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250909    gcc-15.1.0
sh                    randconfig-002-20250909    gcc-9.5.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250909    gcc-8.5.0
sparc                 randconfig-002-20250909    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250909    clang-22
sparc64               randconfig-002-20250909    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20250909    gcc-14
um                    randconfig-002-20250909    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250909    clang-20
x86_64      buildonly-randconfig-002-20250909    clang-20
x86_64      buildonly-randconfig-003-20250909    gcc-14
x86_64      buildonly-randconfig-004-20250909    clang-20
x86_64      buildonly-randconfig-005-20250909    gcc-14
x86_64      buildonly-randconfig-006-20250909    clang-20
x86_64                              defconfig    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250909    gcc-8.5.0
xtensa                randconfig-002-20250909    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

