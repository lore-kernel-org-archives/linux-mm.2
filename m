Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B7B2CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F708E0019; Wed, 10 Sep 2025 16:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF948E000D; Wed, 10 Sep 2025 16:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DEAC8E0019; Wed, 10 Sep 2025 16:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 783808E000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:49:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0810F1DD605
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:49:09 +0000 (UTC)
X-FDA: 83874530418.30.F3BF35E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1386BC0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:49:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=daKBRgDi;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757537347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=8SiUk5ynIc1mUo1/fGwNM/h9Vn3nmA92B78eXIKG52Q=;
	b=UddrERmEAL2jQscExODIJnSMA4Rr7LmRLcwT0i69GRtQUxGMB4g80wukKfiyWujKW7PWyj
	vFpJZ0TRgsycqT9d4LP38eKwVRsx+4RI//r357gk8U2O37exoq6onVG3+2XvytG/G9P7Nh
	LRpC9YsGjrgaCxGdHRjz4yaPiJF0/AM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=daKBRgDi;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757537347; a=rsa-sha256;
	cv=none;
	b=dD8WdRilmKahYV3EHkGBquC9bxjso0j0kmXcBcVXIrSlhU+F+zskWxARdz38cDiGG9ISi3
	LJAE2vX1meU7qx5DhcvSIe/iCz2P+Leu1R0eouSU4QpLOD/BMgIU1zWLzOFDnoeQzO5HKI
	m7d4LsktPAK6WnqJGZPMlspSWLfV9mg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757537346; x=1789073346;
  h=date:from:to:cc:subject:message-id;
  bh=s3tA4FgBoyZsb82S3GYIxMoPcLrCKEDfVdit1dSVGto=;
  b=daKBRgDip0YIJK9MKuqdGahLWXx3nLKjPOLY+jnjdyi/iX4TUQHaz5MO
   kHuU0a8/rJSoxviTF+mGH17iqqOoRyfgsiMiG/qaIsjBaMeN3AXu0gEPb
   Fu9BVnKP1m4NLVD0cFIQQMOJ0wOSlUC5RAz+q07pezk5sGOMqT0O29uIL
   73L2G3YLBkEOLnSmro2DAX7tPzHayK/cQvIHBVmWN2Ty+qzsp6Ol3Wjxh
   dCnpbdN7KgUjcvlMI27r849Kt2nSYrEKDKvUuvaba7hBLm9jbxu3sYE+G
   uT6cn4DeUPXhF2V+Q35CmDASFMDhby9lv1eVZCYFGYKU0uH8pqIZvZKjQ
   Q==;
X-CSE-ConnectionGUID: x5V7av1mTae06gFnaZHiuw==
X-CSE-MsgGUID: MivdYWmUR+Sh87WygnfJaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="63688593"
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="63688593"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 13:49:04 -0700
X-CSE-ConnectionGUID: +5DflAV3QmKZoPr/t43+aQ==
X-CSE-MsgGUID: 55vL1eVSQeaLdazNh+beRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="173345024"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 10 Sep 2025 13:49:02 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uwRkS-0006HF-0G;
	Wed, 10 Sep 2025 20:49:00 +0000
Date: Thu, 11 Sep 2025 04:48:42 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 5f540c4aade9f1d58fb7b9490b4b7d5214ec9746
Message-ID: <202509110443.dvwSKYxj-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Queue-Id: 1386BC0002
X-Rspamd-Server: rspam05
X-Stat-Signature: 45xd96njc9gc8qwhkma4ef5jxw7g5okj
X-Rspam-User: 
X-HE-Tag: 1757537345-246935
X-HE-Meta: U2FsdGVkX196N6T7QGsWXRxRvqjxnzTWCx78kIr09CK6vyK0BuAkuMKbS37AYuBdXianLLXu8VL9Od9lnmsKDeEykPgHuorWB+IVjr0lq655oAiNXC00s+kIl9JX6mnFqXxuu7DK3O1O824SLAv0OFl2F2zESEODXi4IN3XnkFAz4Dac1VC6Kduu0ke4JLSC5Yeddbgzgoilh/UWIB9sgc4/kijZUUVMYYJu+0PbIJWAEbPLVHa52QpGBMVvTX/L6wwHcsnck3oXEBZiUhF+1VoeaunS6RLQ0DFQ54DHu+gau+OzDkqQhGCqL79gkHRVo/2GlmE1kaXOJ5CUXYwWVM7Hvhmdt/unUy5I+urOzSKOOdq5WRypb6j6FaU+u5+y/nw39+Px0GoN0+3ULfsWo8+tl1JnCORGO2XAePa8U1cbK1XiM1mHx/PQsd3NOGIq+Ep7zNvYYIaO0LyN/YkZER76oX15O4oPha2iIfLwnp8ulMDStpmdUDKoaQ0uxDKe4evV4menbbD7d7mA3J4pUva0CsY7RE7t/EqWGr/fVX+Wx6rwB8LG1dIFf+mE5LDhUXL2W5cO2BEo4eONKrYl9ps9T0eJoK3krAxPYzBuNSSry7yMOT/IOCDedsLfPYbQdN/UOu4n58nlOR7DemF1d6aTEXSrKfRc9mfjAll0jQW407TOLQ8PELBK14POqxict8Ud44NzAX0S5Gp8THalfXHFSTSg+bzKhRyyILI+6bjynSjVIP8E2sFN0Gv2w/U5wxlm5w/EKgX/OYdUPl5FTo281dTdRh3SgKu8OpDYfJbb3Ds08cNGdUGzT9KGNFAulmPk5TFXracsNAgTQazU29TlQjUfi37taPLOuqshilBlSIncU8+VzrkRg/NHEvCMX5X8F7RXW7N14kN9B1Ep1nLAxrXbxjK3DSjvKfsZHZBW4x/cHkhnzqgSSsz6YNtyg0W+kCS7UHABMUo2JhJ
 Wzxw69Dv
 pk6pjuE6X6m0SBF+rZ7ukJ0VYULphs9UEF7JCqi6LXZe0AGnjBSBgDrNTcFION8K4pveWu6VoMmb5zDtx+HgF7vUuWZ660f1P/lkGPovbt0lwy1AIM/GmQa9IzETNLtFXDQqrrAaSLwGG3nOC5AbslVtymcAGukY9U86E5gfIjZkyOlrMYBTMPKzbBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 5f540c4aade9f1d58fb7b9490b4b7d5214ec9746  Add linux-next specific files for 20250910

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202508121500.RvXjS54z-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508122300.QreDWTZr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508231902.ZRQhIhd5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509101930.OsSQJxIP-lkp@intel.com

    Documentation/.renames.txt: warning: ignored by one of the .gitignore files
    ERROR: modpost: "typec_switch_put" [drivers/extcon/extcon-ptn5150.ko] undefined!
    arch/arm/boot/dts/arm/integratorap-im-pd1.dts:86.12-127.4: Warning (avoid_unnecessary_addr_size): /bus@c0000000/bus@c0000000/gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/arm/integratorap.dts:176.3-197.5: Warning (interrupt_map): /pci@62000000:interrupt-map: Missing property '#address-cells' in node /pic@14000000, using 0 as fallback
    arch/arm/boot/dts/arm/integratorcp.dts:198.9-223.4: Warning (avoid_unnecessary_addr_size): /bridge: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/broadcom/bcm2711.dtsi:564.4-571.11: Warning (interrupt_map): /scb/pcie@7d500000:interrupt-map: Missing property '#address-cells' in node /soc/interrupt-controller@40041000, using 0 as fallback
    arch/arm/boot/dts/broadcom/bcm47094-linksys-panamera.dts:140.13-191.6: Warning (avoid_unnecessary_addr_size): /mdio-mux@18003000/mdio@200/switch@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/broadcom/bcm5301x-nand-cs0.dtsi:10.18-19.5: Warning (avoid_unnecessary_addr_size): /nand-controller@18028000/nand@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/hisilicon/hi3620.dtsi:544.23-563.5: Warning (avoid_unnecessary_addr_size): /amba-bus/pinmux@803000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-adi-coyote.dts:68.4-78.31: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-arcom-vulcan.dts:125.4-135.30: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-dlink-dsm-g600.dts:134.4-144.30: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-freecom-fsg-3.dts:170.4-185.30: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-gateway-7001.dts:65.4-75.31: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-gateworks-gw2348.dts:120.4-140.30: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-goramo-multilink.dts:94.4-114.30: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-iomega-nas100d.dts:120.4-128.30: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-ixdpg425.dts:73.4-88.30: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-linksys-nslu2.dts:136.4-151.30: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-linksys-wrv54g.dts:173.4-179.31: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-netgear-wg302v1.dts:96.4-106.31: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp42x-usrobotics-usr8200.dts:140.4-148.30: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp43x-gateworks-gw2358.dts:136.4-166.30: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
    arch/arm/boot/dts/intel/ixp/intel-ixp4xx-reference-design.dtsi:111.4-131.30: Warning (interrupt_map): /soc/pci@c0000000:interrupt-map: Missing property '#address-cells' in node /soc/gpio@c8004000, using 0 as fallback
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
    arch/arm64/boot/dts/qcom/lemans.dtsi:4498.28-4559.6: Warning (avoid_unnecessary_addr_size): /soc@0/display-subsystem@ae00000/dsi@ae94000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/lemans.dtsi:4580.28-4632.6: Warning (avoid_unnecessary_addr_size): /soc@0/display-subsystem@ae00000/dsi@ae96000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/sm8550.dtsi:4093.22-4183.5: Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/sm8650.dtsi:5049.22-5140.5: Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/csky/abiv2/cacheflush.c:24:47: error: passing argument 2 of 'test_and_set_bit' from incompatible pointer type [-Werror=incompatible-pointer-types]
    arch/csky/abiv2/cacheflush.c:24:47: error: passing argument 2 of 'test_and_set_bit' from incompatible pointer type [-Wincompatible-pointer-types]
    arch/csky/abiv2/inc/abi/cacheflush.h:23:39: error: passing argument 2 of 'const_test_bit' from incompatible pointer type [-Werror=incompatible-pointer-types]
    arch/csky/abiv2/inc/abi/cacheflush.h:23:39: error: passing argument 2 of 'const_test_bit' from incompatible pointer type [-Wincompatible-pointer-types]
    extcon-ptn5150.c:(.text+0x377): undefined reference to `fwnode_typec_switch_get'
    extcon-ptn5150.c:(.text+0x5ee): undefined reference to `typec_switch_set'
    ld.lld: error: undefined symbol: typec_switch_put

Unverified Error/Warning (likely false positive, kindly check if interested):

    ERROR: modpost: "__hexagon_udivdi3" [drivers/md/md-mod.ko] undefined!
    ERROR: modpost: "__udivdi3" [drivers/md/md-mod.ko] undefined!
    arch/mips/boot/dts/mti/sead3.dts:69.17-91.4: Warning (avoid_unnecessary_addr_size): /flash@1c000000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- alpha-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
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
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
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
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
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
|-- arm-randconfig-001-20250910
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-adi-coyote.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-arcom-vulcan.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-dlink-dsm-g600.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-freecom-fsg-.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-gateway-.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-gateworks-gw2348.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-goramo-multilink.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-iomega-nas100d.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-ixdpg425.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-linksys-nslu2.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-linksys-wrv54g.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-netgear-wg302v1.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp42x-usrobotics-usr8200.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp43x-gateworks-gw2358.dts.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|   `-- arch-arm-boot-dts-intel-ixp-intel-ixp4xx-reference-design.dtsi.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
|-- arm-randconfig-002-20250910
|   |-- arch-arm-boot-dts-arm-integratorap-im-pd1.dts.-.:Warning-(avoid_unnecessary_addr_size):bus-c0000000-bus-c0000000-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-arm-integratorap.dts.-.:Warning-(interrupt_map):pci:interrupt-map:Missing-property-address-cells-in-node-pic-using-as-fallback
|   |-- arch-arm-boot-dts-arm-integratorcp.dts.-.:Warning-(avoid_unnecessary_addr_size):bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-ti-omap-omap2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap2420.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm-boot-dts-ti-omap-omap2420.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-scm_conf:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm-randconfig-003-20250910
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-ti-omap-omap2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap2420.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm-boot-dts-ti-omap-omap2420.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-scm_conf:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm-randconfig-004-20250910
|   `-- arch-arm-boot-dts-nxp-imx-imx7d.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|-- arm64-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-defconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-001-20250910
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-002-20250910
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- ld.lld:error:undefined-symbol:typec_switch_put
|-- arm64-randconfig-003-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-004-20250910
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-r112-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- csky-allnoconfig
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
|-- csky-randconfig-001-20250910
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-randconfig-002-20250910
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- hexagon-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- ERROR:__hexagon_udivdi3-drivers-md-md-mod.ko-undefined
|-- hexagon-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-006-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-061-20250910
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|-- i386-randconfig-062-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-063-20250910
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|-- i386-randconfig-141-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-r132-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-randconfig-r111-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-randconfig-r123-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- ERROR:__udivdi3-drivers-md-md-mod.ko-undefined
|-- microblaze-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- arch-mips-boot-dts-mti-sead3.dts.-.:Warning-(avoid_unnecessary_addr_size):flash-1c000000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- nios2-randconfig-r113-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- openrisc-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-001-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-002-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-cell_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-ge_imp3a_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-001-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-002-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-003-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-002-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-003-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-sh7785lcr_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-001-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-002-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-r131-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-001-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-002-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-i386_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-001-20250910
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- extcon-ptn5150.c:(.text):undefined-reference-to-fwnode_typec_switch_get
|   `-- extcon-ptn5150.c:(.text):undefined-reference-to-typec_switch_set
|-- um-randconfig-002-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-x86_64_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-005-20250911
|   `-- ERROR:typec_switch_put-drivers-extcon-extcon-ptn5150.ko-undefined
|-- x86_64-randconfig-121-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-122-20250910
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|-- x86_64-randconfig-123-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-161-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-randconfig-001-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-randconfig-002-20250910
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
`-- xtensa-randconfig-r133-20250910
    `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files

elapsed time: 747m

configs tested: 134
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                          axs101_defconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250910    gcc-13.4.0
arc                   randconfig-002-20250910    gcc-8.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20250910    gcc-8.5.0
arm                   randconfig-002-20250910    gcc-8.5.0
arm                   randconfig-003-20250910    clang-16
arm                   randconfig-004-20250910    gcc-8.5.0
arm                           spitz_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250910    clang-22
arm64                 randconfig-002-20250910    clang-22
arm64                 randconfig-003-20250910    gcc-9.5.0
arm64                 randconfig-004-20250910    gcc-13.4.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250910    gcc-12.5.0
csky                  randconfig-002-20250910    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250910    clang-22
hexagon               randconfig-002-20250910    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20250910    gcc-14
i386        buildonly-randconfig-002-20250910    gcc-13
i386        buildonly-randconfig-003-20250910    clang-20
i386        buildonly-randconfig-004-20250910    clang-20
i386        buildonly-randconfig-005-20250910    gcc-14
i386        buildonly-randconfig-006-20250910    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250910    clang-18
loongarch             randconfig-002-20250910    clang-18
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                        m5307c3_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250910    gcc-11.5.0
nios2                 randconfig-002-20250910    gcc-9.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           alldefconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250910    gcc-10.5.0
parisc                randconfig-002-20250910    gcc-9.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                        cell_defconfig    gcc-15.1.0
powerpc                    ge_imp3a_defconfig    gcc-15.1.0
powerpc               randconfig-001-20250910    gcc-8.5.0
powerpc               randconfig-002-20250910    gcc-8.5.0
powerpc               randconfig-003-20250910    clang-22
powerpc64             randconfig-002-20250910    gcc-11.5.0
powerpc64             randconfig-003-20250910    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250910    clang-22
riscv                 randconfig-002-20250910    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250910    clang-22
s390                  randconfig-002-20250910    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250910    gcc-15.1.0
sh                    randconfig-002-20250910    gcc-12.5.0
sh                        sh7785lcr_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250910    gcc-8.5.0
sparc                 randconfig-002-20250910    gcc-8.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250910    gcc-8.5.0
sparc64               randconfig-002-20250910    gcc-12.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20250910    clang-22
um                    randconfig-002-20250910    clang-22
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
xtensa                randconfig-001-20250910    gcc-8.5.0
xtensa                randconfig-002-20250910    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

