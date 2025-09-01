Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C93CA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 23:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D7C8E000D; Mon,  1 Sep 2025 19:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00D878E0002; Mon,  1 Sep 2025 19:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF01B8E000D; Mon,  1 Sep 2025 19:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B854D8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:28:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44539140834
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 23:28:54 +0000 (UTC)
X-FDA: 83842273788.25.834C998
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf01.hostedemail.com (Postfix) with ESMTP id F21E940009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 23:28:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iJ7iV790;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756769332; a=rsa-sha256;
	cv=none;
	b=aKPfMVeIgpDjRNQXRF0NOMEeHCBOBRK7D0jFyU2qoUj8zlLWBedODHkSI5UANho8Ud7+ho
	0p1kvjv6ik+yA6T0avFjzi2nfSxdFt/zAD0dsm85WqV+5IdWyeWVdefzM1xa0flnJ/LL7b
	XhyAL13DdujRHymCXxyRvcpO6UW1Shs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iJ7iV790;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756769332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=BohLSMiLvWPA+f2XPaUqLcC0L1LCs+M70kXvuJ5c8lc=;
	b=gLjMrWrncI4+2Fu6NwCZjDau7QbQBSBGqReX5J0kqGA2kfqeW73bszzHRLZFaL54coJjsx
	JqrUvu9UfFWILbsDiUtT8aV7/5pnCq+pEXYs/N5eUBfoZ9mnAITlweNwUh9mwn31D9iD2z
	/ss6SjhxAmMMREy5AvYHU17epGq0bI4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756769331; x=1788305331;
  h=date:from:to:cc:subject:message-id;
  bh=EY18t/ru7cfSHcx7L8GHioBnJ+RswSp6xctOY6i8sKg=;
  b=iJ7iV790f6vKcr+HHufRZmsjp03mtfa2UVoIbRbcxmsQmpa+nCYUH7fQ
   i1X/4n+WlWIWOSBPqiuqeHlAqvelhI48GyCTOOi/GkVu+0QTI71ItJqQn
   wa4b1VaQNVGn8GvQvaHg9J+hxautn+YMi8Rnp+EZkgI05YG37LFyglb9Z
   ydSOeRNxZrSMq/oqaVAiYk0lFRxJQ1XFNyiQQFieKxKWSwgdxIj0Sj0ai
   i1P360EXuXzhE64YJ/0uT+b25Rsf2sSXw1YYhCcCA1acjV50UtNrBDBVB
   FnYMhyGXv3At26LG30OuBwi6iTuBQXnRt21zAlHK07Ur5yvKvQbJJXOeq
   g==;
X-CSE-ConnectionGUID: fQWyzo32SR+m/kj2LhBKzg==
X-CSE-MsgGUID: JqijMCt8QPORVOVK7X8K+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11540"; a="58723589"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="58723589"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 16:28:49 -0700
X-CSE-ConnectionGUID: ZhMBYIFWR6m+oSgruDtkXw==
X-CSE-MsgGUID: BZASElVgQJW1HBab2cPYWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="171090322"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 01 Sep 2025 16:28:47 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utDwG-0001Cn-1q;
	Mon, 01 Sep 2025 23:28:07 +0000
Date: Tue, 02 Sep 2025 07:26:58 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 33bcf93b9a6b028758105680f8b538a31bc563cf
Message-ID: <202509020723.Le0Ka7WV-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: F21E940009
X-Stat-Signature: qr3161ybthom65dhmoqepz4934e8hcan
X-HE-Tag: 1756769330-832153
X-HE-Meta: U2FsdGVkX18e4cvsjl946l0QB0+kW/kZpnFzMXzJjl2cQt9xqWXUT9HAAANBv4V0RU2njHDO3EW//maW6x8GFb2tGkbQmYUUs+VV9pJI0RtOXVkjE6KNJv7klkUKLKD/FIBeeHUuwutlMXOZvJKocLvaexggU1sEeFpGQYD/LBNTYhSuWAKpSb24QrFo6R445D/0xWfCrxoalL8yFNyeHOz0o8QyXaSZjc7cKFKZitYoeJ4lhCpr7ak2bmYUwaCMvErOKrgZ+ofku5R8w/FSoHaL7Pi0KHDzkzompmyhW5i/xAGsPxLqzzeRm/fVvq5+rZUDAYLQvIzlej1X+BD0tyauBZtCzDvJpw8Z2WTVDFMfso5l66NuXfc6YI0Jyp6hC5HBbBH7f1vUpsp/3jXqt8u33ntpfPIsZoIv+fXDxizYmSnxpJCTBtJROqOeo2E7L2YRZhjycElNzcsYKM21XStVvNjH00mYUyp7dxSuHU3F2fi7588FJN0PUCmOceRgaSd9Vhf1Hmlyjiy7ekqz/Ke6Aj2An7Fv2ILmdkz76uiY50Gd/1i9d7BXDIE/mq1d+TiAgt4PugMeGirnUG0nIjdAUXJgUMrq+xzpsbfgwpCQl8ML/2wHolb1zL1T1obX9VUxxZkGNUdqrzQz+9J7dwRsLyIEF4wuoecMXw9N4jshqXzhGBY7mwLgPkYDOKKWzUIkuk5+cB43sk2IzDb9zn/9qeMpQyxAdmoM+3lF6ty5t9A2srH6kYlWefmaxHSHNubrp9mbV04KeMD1Kymjon3v1SpNeBJ+8fHSBP6o3zR+gJ1XUPknj7J2kTvB6M86VZDFTzJBgcWBU3wncOIwFtfibXCOOdz+s0wlndRBGBoTrxK5gKBknDegpGzJB5q6yWDy5qZ4K+8mP7rRZouNei1gHau4jdQ+ghWWVvcwNBGgoyu2D0ckrD23QGYAKVejEXuEyRxRnsRDg8jBTbz
 Ix45BWmN
 xjKbIqRddKKejOL7HHzIO0dUQ4xMtKbhQJs0wiSxJb29B0F/ikAZUhXj2UW8uxKIpSN+WPs4N5iXQf0GtiWN1PBOWBJ/7x4FbtCNWQKhOVNEVpnXkoV2SJgLACAiYeT/aVGnolQNLXHnrjLEEWvdc2fltE5ri5QA4+IcjtbybzM/mXvA2LWXi9B3OHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 33bcf93b9a6b028758105680f8b538a31bc563cf  Add linux-next specific files for 20250901

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202508121500.RvXjS54z-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508122300.QreDWTZr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508141518.uFdkyMsT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508142038.M8MuVqEP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508211859.UoYsJbLN-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508231902.ZRQhIhd5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508290749.ti6u3cLL-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509020109.vNCZ636X-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509020150.BE26jcTk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509020426.WJtrdwOU-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509020737.MXLgn37j-lkp@intel.com

    Warning: fs/ceph/mds_client.c:2704 function parameter 'path_info' not described in 'ceph_mdsc_build_path'
    arch/arm/boot/dts/alphascale/alphascale-asm9260.dtsi:19.7-28.4: Warning (avoid_unnecessary_addr_size): /cpus: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/arm/integratorap-im-pd1.dts:86.12-127.4: Warning (avoid_unnecessary_addr_size): /bus@c0000000/bus@c0000000/gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/arm/integratorap.dts:176.3-197.5: Warning (interrupt_map): /pci@62000000:interrupt-map: Missing property '#address-cells' in node /pic@14000000, using 0 as fallback
    arch/arm/boot/dts/arm/integratorcp.dts:198.9-223.4: Warning (avoid_unnecessary_addr_size): /bridge: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/arm/versatile-pb.dts:59.4-77.29: Warning (interrupt_map): /amba/pci@10001000:interrupt-map: Missing property '#address-cells' in node /amba/interrupt-controller@10003000, using 0 as fallback
    arch/arm/boot/dts/broadcom/bcm2711.dtsi:564.4-571.11: Warning (interrupt_map): /scb/pcie@7d500000:interrupt-map: Missing property '#address-cells' in node /soc/interrupt-controller@40041000, using 0 as fallback
    arch/arm/boot/dts/broadcom/bcm47094-linksys-panamera.dts:140.13-191.6: Warning (avoid_unnecessary_addr_size): /mdio-mux@18003000/mdio@200/switch@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/broadcom/bcm5301x-nand-cs0.dtsi:10.18-19.5: Warning (avoid_unnecessary_addr_size): /nand-controller@18028000/nand@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/cirrus/ep7209.dtsi:27.7-35.4: Warning (avoid_unnecessary_addr_size): /cpus: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
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
    arch/arm/boot/dts/marvell/kirkwood-6281.dtsi:32.5-35.30: Warning (interrupt_map): /mbus@f1000000/pcie@82000000/pcie@1,0:interrupt-map: Missing property '#address-cells' in node /mbus@f1000000/pcie@82000000/pcie@1,0/interrupt-controller, using 0 as fallback
    arch/arm/boot/dts/marvell/kirkwood-98dx4122.dtsi:32.5-35.30: Warning (interrupt_map): /mbus@f1000000/pcie@82000000/pcie@1,0:interrupt-map: Missing property '#address-cells' in node /mbus@f1000000/pcie@82000000/pcie@1,0/interrupt-controller, using 0 as fallback
    arch/arm/boot/dts/marvell/kirkwood-dir665.dts:196.11-241.4: Warning (avoid_unnecessary_addr_size): /ocp@f1000000/mdio-bus@72004/switch@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/marvell/kirkwood-l-50.dts:211.21-267.4: Warning (avoid_unnecessary_addr_size): /ocp@f1000000/mdio-bus@72004/switch@10: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/marvell/kirkwood-linksys-viper.dts:162.12-207.4: Warning (avoid_unnecessary_addr_size): /ocp@f1000000/mdio-bus@72004/switch@10: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/marvell/kirkwood-rd88f6281.dtsi:77.19-117.4: Warning (avoid_unnecessary_addr_size): /ocp@f1000000/mdio-bus@72004/switch@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/marvell/kirkwood.dtsi:45.18-59.5: Warning (avoid_unnecessary_addr_size): /mbus@f1000000/nand@12f: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/mediatek/mt6572-jty-d101.dts:17.9-30.4: Warning (avoid_unnecessary_addr_size): /chosen: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/mediatek/mt6572-lenovo-a369i.dts:17.9-30.4: Warning (avoid_unnecessary_addr_size): /chosen: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/mediatek/mt7623.dtsi:766.3-768.36: Warning (interrupt_map): /pcie@1a140000:interrupt-map: Missing property '#address-cells' in node /interrupt-controller@10200100, using 0 as fallback
    arch/arm/boot/dts/mediatek/mt7623.dtsi:794.4-46: Warning (interrupt_map): /pcie@1a140000/pcie@0,0:interrupt-map: Missing property '#address-cells' in node /interrupt-controller@10200100, using 0 as fallback
    arch/arm/boot/dts/microchip/at91-q5xr5.dts:50.17-72.4: Warning (avoid_unnecessary_addr_size): /ahb/ebi@10000000/flash@0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/microchip/at91sam9g45.dtsi:838.10-841.7: Warning (avoid_unnecessary_addr_size): /ahb/apb/isi@fffb4000/port: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/microchip/at91sam9x5dm.dtsi:29.15-46.4: Warning (avoid_unnecessary_addr_size): /panel: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/microchip/pm9g45.dts:168.12-184.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/moxa/moxart-uc7112lx.dts:61.19-71.4: Warning (avoid_unnecessary_addr_size): /gpio_keys_polled: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/moxa/moxart.dtsi:27.9-30.4: Warning (avoid_unnecessary_addr_size): /clocks: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
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
    arch/arm/boot/dts/st/spear320-hmi.dts:128.13-148.5: Warning (avoid_unnecessary_addr_size): /ahb/gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/spear3xx.dtsi:13.7-21.4: Warning (avoid_unnecessary_addr_size): /cpus: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/spear600.dtsi:11.7-19.4: Warning (avoid_unnecessary_addr_size): /cpus: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-href-stuib.dtsi:9.12-29.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-href-tvk1281618-r2.dtsi:10.12-30.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-href-tvk1281618-r3.dtsi:11.12-25.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-hrefprev60.dtsi:12.12-16.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/st/ste-snowball.dts:62.12-102.4: Warning (avoid_unnecessary_addr_size): /gpio_keys: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/synaptics/berlin2q-marvell-dmp.dts:25.13-78.4: Warning (avoid_unnecessary_addr_size): /regulators: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/davinci/da850-lcdk.dts:119.13-144.4: Warning (avoid_unnecessary_addr_size): /vga-bridge: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm/boot/dts/ti/davinci/da850-lcdk.dts:346.18-392.5: Warning (avoid_unnecessary_addr_size): /aemif@68000000/cs3/nand@2000000,0: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
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
    arch/arm64/boot/dts/qcom/sm8550.dtsi:4087.22-4177.5: Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/sm8650.dtsi:5048.22-5139.5: Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
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
    drivers/gpu/drm/amd/amdgpu/mes_v12_0.c:915 mes_v12_0_inv_tlbs_pasid() warn: error code type promoted to positive: 'mes_inv_tlbs.invalidate_tlbs.hub_id'
    drivers/infiniband/hw/mlx5/mr.c:840:31: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
    include/linux/compiler.h:197:82: error: expression in static assertion is not an integer
    include/linux/compiler_types.h:572:38: error: call to '__compiletime_assert_543' declared with attribute error: FIELD_PREP: value too large for the field
    include/linux/compiler_types.h:572:38: error: call to '__compiletime_assert_659' declared with attribute error: min(__x, __y) signedness error
    include/linux/compiler_types.h:572:38: error: call to '__compiletime_assert_679' declared with attribute error: FIELD_PREP: value too large for the field
    include/linux/fortify-string.h:115:33: warning: argument 2 null where non-null expected [-Wnonnull]
    include/net/sock.h:384:45: error: 'struct sock_common' has no member named 'skc_v6_daddr'; did you mean 'skc_daddr'?

Unverified Error/Warning (likely false positive, kindly check if interested):

    arch/mips/boot/dts/mti/sead3.dts:69.17-91.4: Warning (avoid_unnecessary_addr_size): /flash@1c000000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- alpha-randconfig-r133-20250902
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:FIELD_PREP:value-too-large-for-the-field
|-- arc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-allyesconfig
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
|-- arm-randconfig-001-20250901
|   `-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|-- arm-randconfig-002-20250901
|   |-- arch-arm-boot-dts-nxp-imx-imx7d.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   `-- arch-arm-boot-dts-nxp-vf-vfxxx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-spi-400ad000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm-randconfig-003-20250901
|   `-- arch-arm-boot-dts-nxp-imx-imx7d.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|-- arm-randconfig-004-20250901
|   |-- arch-arm-boot-dts-arm-integratorap-im-pd1.dts.-.:Warning-(avoid_unnecessary_addr_size):bus-c0000000-bus-c0000000-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-arm-integratorap.dts.-.:Warning-(interrupt_map):pci:interrupt-map:Missing-property-address-cells-in-node-pic-using-as-fallback
|   `-- arch-arm-boot-dts-arm-integratorcp.dts.-.:Warning-(avoid_unnecessary_addr_size):bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm-randconfig-051-20250901
|   |-- arch-arm-boot-dts-alphascale-alphascale-asm9260.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-arm-integratorap-im-pd1.dts.-.:Warning-(avoid_unnecessary_addr_size):bus-c0000000-bus-c0000000-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-arm-integratorap.dts.-.:Warning-(interrupt_map):pci:interrupt-map:Missing-property-address-cells-in-node-pic-using-as-fallback
|   |-- arch-arm-boot-dts-arm-integratorcp.dts.-.:Warning-(avoid_unnecessary_addr_size):bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-arm-versatile-pb.dts.-.:Warning-(interrupt_map):amba-pci:interrupt-map:Missing-property-address-cells-in-node-amba-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm47094-linksys-panamera.dts.-.:Warning-(avoid_unnecessary_addr_size):mdio-mux-mdio-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ra
|   |-- arch-arm-boot-dts-broadcom-bcm5301x-nand-cs0.dtsi.-.:Warning-(avoid_unnecessary_addr_size):nand-controller-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-cirrus-ep7209.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-hisilicon-hi3620.dtsi.-.:Warning-(avoid_unnecessary_addr_size):amba-bus-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp4xx-reference-design.dtsi.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
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
|   |-- arch-arm-boot-dts-marvell-kirkwood-.dtsi.-.:Warning-(interrupt_map):mbus-f1000000-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-mbus-f1000000-pcie-pcie-interrupt-controller-using-as-f
|   |-- arch-arm-boot-dts-marvell-kirkwood-98dx4122.dtsi.-.:Warning-(interrupt_map):mbus-f1000000-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-mbus-f1000000-pcie-pcie-interrupt-controller-us
|   |-- arch-arm-boot-dts-marvell-kirkwood-dir665.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-marvell-kirkwood-l-.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-marvell-kirkwood-linksys-viper.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-marvell-kirkwood-rd88f6281.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm-boot-dts-marvell-kirkwood.dtsi.-.:Warning-(avoid_unnecessary_addr_size):mbus-f1000000-nand-12f:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-jty-d101.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-lenovo-a369i.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.-.:Warning-(interrupt_map):pcie-1a140000:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.:Warning-(interrupt_map):pcie-1a140000-pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-microchip-at91-q5xr5.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-ebi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-microchip-at91sam9g45.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ahb-apb-isi-fffb4000-port:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-microchip-at91sam9x5dm.dtsi.-.:Warning-(avoid_unnecessary_addr_size):panel:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-microchip-pm9g45.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-moxa-moxart-uc7112lx.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys_polled:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-moxa-moxart.dtsi.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|   |-- arch-arm-boot-dts-st-spear320-hmi.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-spear3xx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-spear600.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-stuib.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-snowball.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-synaptics-berlin2q-marvell-dmp.dts.-.:Warning-(avoid_unnecessary_addr_size):regulators:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-davinci-da850-lcdk.dts.-.:Warning-(avoid_unnecessary_addr_size):aemif-cs3-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-davinci-da850-lcdk.dts.-.:Warning-(avoid_unnecessary_addr_size):vga-bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm-randconfig-052-20250901
|   |-- arch-arm-boot-dts-alphascale-alphascale-asm9260.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-arm-integratorap-im-pd1.dts.-.:Warning-(avoid_unnecessary_addr_size):bus-c0000000-bus-c0000000-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-arm-integratorap.dts.-.:Warning-(interrupt_map):pci:interrupt-map:Missing-property-address-cells-in-node-pic-using-as-fallback
|   |-- arch-arm-boot-dts-arm-integratorcp.dts.-.:Warning-(avoid_unnecessary_addr_size):bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-arm-versatile-pb.dts.-.:Warning-(interrupt_map):amba-pci:interrupt-map:Missing-property-address-cells-in-node-amba-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm47094-linksys-panamera.dts.-.:Warning-(avoid_unnecessary_addr_size):mdio-mux-mdio-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ra
|   |-- arch-arm-boot-dts-broadcom-bcm5301x-nand-cs0.dtsi.-.:Warning-(avoid_unnecessary_addr_size):nand-controller-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-cirrus-ep7209.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-hisilicon-hi3620.dtsi.-.:Warning-(avoid_unnecessary_addr_size):amba-bus-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp4xx-reference-design.dtsi.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
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
|   |-- arch-arm-boot-dts-marvell-kirkwood-.dtsi.-.:Warning-(interrupt_map):mbus-f1000000-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-mbus-f1000000-pcie-pcie-interrupt-controller-using-as-f
|   |-- arch-arm-boot-dts-marvell-kirkwood-98dx4122.dtsi.-.:Warning-(interrupt_map):mbus-f1000000-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-mbus-f1000000-pcie-pcie-interrupt-controller-us
|   |-- arch-arm-boot-dts-marvell-kirkwood-dir665.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-marvell-kirkwood-l-.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-marvell-kirkwood-linksys-viper.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-marvell-kirkwood-rd88f6281.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm-boot-dts-marvell-kirkwood.dtsi.-.:Warning-(avoid_unnecessary_addr_size):mbus-f1000000-nand-12f:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-jty-d101.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-lenovo-a369i.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.-.:Warning-(interrupt_map):pcie-1a140000:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.:Warning-(interrupt_map):pcie-1a140000-pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-microchip-at91-q5xr5.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-ebi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-microchip-at91sam9g45.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ahb-apb-isi-fffb4000-port:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-microchip-at91sam9x5dm.dtsi.-.:Warning-(avoid_unnecessary_addr_size):panel:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-microchip-pm9g45.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-moxa-moxart-uc7112lx.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys_polled:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-moxa-moxart.dtsi.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|   |-- arch-arm-boot-dts-st-spear320-hmi.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-spear3xx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-spear600.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-stuib.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-snowball.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-synaptics-berlin2q-marvell-dmp.dts.-.:Warning-(avoid_unnecessary_addr_size):regulators:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-davinci-da850-lcdk.dts.-.:Warning-(avoid_unnecessary_addr_size):aemif-cs3-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-davinci-da850-lcdk.dts.-.:Warning-(avoid_unnecessary_addr_size):vga-bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm-randconfig-053-20250901
|   |-- arch-arm-boot-dts-alphascale-alphascale-asm9260.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-arm-integratorap-im-pd1.dts.-.:Warning-(avoid_unnecessary_addr_size):bus-c0000000-bus-c0000000-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-arm-integratorap.dts.-.:Warning-(interrupt_map):pci:interrupt-map:Missing-property-address-cells-in-node-pic-using-as-fallback
|   |-- arch-arm-boot-dts-arm-integratorcp.dts.-.:Warning-(avoid_unnecessary_addr_size):bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-arm-versatile-pb.dts.-.:Warning-(interrupt_map):amba-pci:interrupt-map:Missing-property-address-cells-in-node-amba-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm47094-linksys-panamera.dts.-.:Warning-(avoid_unnecessary_addr_size):mdio-mux-mdio-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ra
|   |-- arch-arm-boot-dts-broadcom-bcm5301x-nand-cs0.dtsi.-.:Warning-(avoid_unnecessary_addr_size):nand-controller-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-cirrus-ep7209.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-hisilicon-hi3620.dtsi.-.:Warning-(avoid_unnecessary_addr_size):amba-bus-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp4xx-reference-design.dtsi.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
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
|   |-- arch-arm-boot-dts-marvell-kirkwood-.dtsi.-.:Warning-(interrupt_map):mbus-f1000000-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-mbus-f1000000-pcie-pcie-interrupt-controller-using-as-f
|   |-- arch-arm-boot-dts-marvell-kirkwood-98dx4122.dtsi.-.:Warning-(interrupt_map):mbus-f1000000-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-mbus-f1000000-pcie-pcie-interrupt-controller-us
|   |-- arch-arm-boot-dts-marvell-kirkwood-dir665.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-marvell-kirkwood-l-.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-marvell-kirkwood-linksys-viper.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-marvell-kirkwood-rd88f6281.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm-boot-dts-marvell-kirkwood.dtsi.-.:Warning-(avoid_unnecessary_addr_size):mbus-f1000000-nand-12f:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-jty-d101.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-lenovo-a369i.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.-.:Warning-(interrupt_map):pcie-1a140000:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.:Warning-(interrupt_map):pcie-1a140000-pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-microchip-at91-q5xr5.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-ebi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-microchip-at91sam9g45.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ahb-apb-isi-fffb4000-port:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-microchip-at91sam9x5dm.dtsi.-.:Warning-(avoid_unnecessary_addr_size):panel:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-microchip-pm9g45.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-moxa-moxart-uc7112lx.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys_polled:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-moxa-moxart.dtsi.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|   |-- arch-arm-boot-dts-st-spear320-hmi.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-spear3xx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-spear600.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-stuib.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-snowball.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-synaptics-berlin2q-marvell-dmp.dts.-.:Warning-(avoid_unnecessary_addr_size):regulators:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-davinci-da850-lcdk.dts.-.:Warning-(avoid_unnecessary_addr_size):aemif-cs3-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-davinci-da850-lcdk.dts.-.:Warning-(avoid_unnecessary_addr_size):vga-bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm-randconfig-054-20250901
|   |-- arch-arm-boot-dts-alphascale-alphascale-asm9260.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-arm-integratorap-im-pd1.dts.-.:Warning-(avoid_unnecessary_addr_size):bus-c0000000-bus-c0000000-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-arm-integratorap.dts.-.:Warning-(interrupt_map):pci:interrupt-map:Missing-property-address-cells-in-node-pic-using-as-fallback
|   |-- arch-arm-boot-dts-arm-integratorcp.dts.-.:Warning-(avoid_unnecessary_addr_size):bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-arm-versatile-pb.dts.-.:Warning-(interrupt_map):amba-pci:interrupt-map:Missing-property-address-cells-in-node-amba-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm47094-linksys-panamera.dts.-.:Warning-(avoid_unnecessary_addr_size):mdio-mux-mdio-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ra
|   |-- arch-arm-boot-dts-broadcom-bcm5301x-nand-cs0.dtsi.-.:Warning-(avoid_unnecessary_addr_size):nand-controller-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-cirrus-ep7209.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-hisilicon-hi3620.dtsi.-.:Warning-(avoid_unnecessary_addr_size):amba-bus-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp4xx-reference-design.dtsi.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
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
|   |-- arch-arm-boot-dts-marvell-kirkwood-.dtsi.-.:Warning-(interrupt_map):mbus-f1000000-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-mbus-f1000000-pcie-pcie-interrupt-controller-using-as-f
|   |-- arch-arm-boot-dts-marvell-kirkwood-98dx4122.dtsi.-.:Warning-(interrupt_map):mbus-f1000000-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-mbus-f1000000-pcie-pcie-interrupt-controller-us
|   |-- arch-arm-boot-dts-marvell-kirkwood-dir665.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-marvell-kirkwood-l-.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-marvell-kirkwood-linksys-viper.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-marvell-kirkwood-rd88f6281.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm-boot-dts-marvell-kirkwood.dtsi.-.:Warning-(avoid_unnecessary_addr_size):mbus-f1000000-nand-12f:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-jty-d101.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-lenovo-a369i.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.-.:Warning-(interrupt_map):pcie-1a140000:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.:Warning-(interrupt_map):pcie-1a140000-pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-microchip-at91-q5xr5.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-ebi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-microchip-at91sam9g45.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ahb-apb-isi-fffb4000-port:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-microchip-at91sam9x5dm.dtsi.-.:Warning-(avoid_unnecessary_addr_size):panel:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-microchip-pm9g45.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-moxa-moxart-uc7112lx.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys_polled:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-moxa-moxart.dtsi.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|   |-- arch-arm-boot-dts-st-spear320-hmi.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-spear3xx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-spear600.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-stuib.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-snowball.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-synaptics-berlin2q-marvell-dmp.dts.-.:Warning-(avoid_unnecessary_addr_size):regulators:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-davinci-da850-lcdk.dts.-.:Warning-(avoid_unnecessary_addr_size):aemif-cs3-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-davinci-da850-lcdk.dts.-.:Warning-(avoid_unnecessary_addr_size):vga-bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm-randconfig-055-20250901
|   |-- arch-arm-boot-dts-alphascale-alphascale-asm9260.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-arm-integratorap-im-pd1.dts.-.:Warning-(avoid_unnecessary_addr_size):bus-c0000000-bus-c0000000-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-arm-integratorap.dts.-.:Warning-(interrupt_map):pci:interrupt-map:Missing-property-address-cells-in-node-pic-using-as-fallback
|   |-- arch-arm-boot-dts-arm-integratorcp.dts.-.:Warning-(avoid_unnecessary_addr_size):bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-arm-versatile-pb.dts.-.:Warning-(interrupt_map):amba-pci:interrupt-map:Missing-property-address-cells-in-node-amba-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm2711.dtsi.-.:Warning-(interrupt_map):scb-pcie-7d500000:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-broadcom-bcm47094-linksys-panamera.dts.-.:Warning-(avoid_unnecessary_addr_size):mdio-mux-mdio-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ra
|   |-- arch-arm-boot-dts-broadcom-bcm5301x-nand-cs0.dtsi.-.:Warning-(avoid_unnecessary_addr_size):nand-controller-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-cirrus-ep7209.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-hisilicon-hi3620.dtsi.-.:Warning-(avoid_unnecessary_addr_size):amba-bus-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|   |-- arch-arm-boot-dts-intel-ixp-intel-ixp4xx-reference-design.dtsi.-.:Warning-(interrupt_map):soc-pci-c0000000:interrupt-map:Missing-property-address-cells-in-node-soc-gpio-c8004000-using-as-fallback
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
|   |-- arch-arm-boot-dts-marvell-kirkwood-.dtsi.-.:Warning-(interrupt_map):mbus-f1000000-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-mbus-f1000000-pcie-pcie-interrupt-controller-using-as-f
|   |-- arch-arm-boot-dts-marvell-kirkwood-98dx4122.dtsi.-.:Warning-(interrupt_map):mbus-f1000000-pcie-pcie:interrupt-map:Missing-property-address-cells-in-node-mbus-f1000000-pcie-pcie-interrupt-controller-us
|   |-- arch-arm-boot-dts-marvell-kirkwood-dir665.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-range
|   |-- arch-arm-boot-dts-marvell-kirkwood-l-.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-marvell-kirkwood-linksys-viper.dts.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-o
|   |-- arch-arm-boot-dts-marvell-kirkwood-rd88f6281.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-f1000000-mdio-bus-switch:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm-boot-dts-marvell-kirkwood.dtsi.-.:Warning-(avoid_unnecessary_addr_size):mbus-f1000000-nand-12f:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-jty-d101.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt6572-lenovo-a369i.dts.-.:Warning-(avoid_unnecessary_addr_size):chosen:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.-.:Warning-(interrupt_map):pcie-1a140000:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-mediatek-mt7623.dtsi.:Warning-(interrupt_map):pcie-1a140000-pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm-boot-dts-microchip-at91-q5xr5.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-ebi-flash:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-microchip-at91sam9g45.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ahb-apb-isi-fffb4000-port:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-pr
|   |-- arch-arm-boot-dts-microchip-at91sam9x5dm.dtsi.-.:Warning-(avoid_unnecessary_addr_size):panel:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-microchip-pm9g45.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-moxa-moxart-uc7112lx.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys_polled:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-moxa-moxart.dtsi.-.:Warning-(avoid_unnecessary_addr_size):clocks:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|   |-- arch-arm-boot-dts-st-spear320-hmi.dts.-.:Warning-(avoid_unnecessary_addr_size):ahb-gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-spear3xx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-spear600.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-stuib.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-href-tvk1281618-r3.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60.dtsi.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-st-ste-snowball.dts.-.:Warning-(avoid_unnecessary_addr_size):gpio_keys:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-synaptics-berlin2q-marvell-dmp.dts.-.:Warning-(avoid_unnecessary_addr_size):regulators:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-davinci-da850-lcdk.dts.-.:Warning-(avoid_unnecessary_addr_size):aemif-cs3-nand:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-davinci-da850-lcdk.dts.-.:Warning-(avoid_unnecessary_addr_size):vga-bridge:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm64-randconfig-001-20250901
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-003-20250901
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   `-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|-- arm64-randconfig-051-20250901
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm64-randconfig-052-20250901
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm64-randconfig-053-20250901
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm64-randconfig-054-20250901
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- arm64-randconfig-055-20250901
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
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
|-- csky-randconfig-001-20250901
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-randconfig-002-20250901
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- hexagon-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- hexagon-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- hexagon-randconfig-002-20250901
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-buildonly-randconfig-006-20250901
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-randconfig-141-20250901
|   |-- drivers-gpu-drm-amd-amdgpu-mes_v12_0.c-mes_v12_0_inv_tlbs_pasid()-warn:error-code-type-promoted-to-positive:mes_inv_tlbs.invalidate_tlbs.hub_id
|   `-- drivers-gpu-drm-amd-amdgpu-mes_v12_0.c-mes_v12_0_inv_tlbs_pasid()-warn:unsigned-mes_inv_tlbs.invalidate_tlbs.hub_id-is-never-less-than-zero.
|-- loongarch-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- loongarch-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
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
|   |-- (.head.text):relocation-truncated-to-fit:R_OR1K_INSN_REL_26-against-no-symbol
|   |-- (.init.text):relocation-truncated-to-fit:R_OR1K_INSN_REL_26-against-no-symbol
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- parisc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- parisc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- parisc-randconfig-002-20250901
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- include-net-sock.h:error:struct-sock_common-has-no-member-named-skc_v6_daddr
|-- powerpc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- riscv-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- riscv-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- riscv-randconfig-r131-20250901
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:FIELD_PREP:value-too-large-for-the-field
|-- s390-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- s390-allyesconfig
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- drivers-infiniband-hw-mlx5-mr.c:warning:sprintf-may-write-a-terminating-nul-past-the-end-of-the-destination
|-- s390-randconfig-001-20250901
|   `-- include-linux-fortify-string.h:warning:argument-null-where-non-null-expected
|-- sh-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sh-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc-randconfig-002-20250902
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(__x-__y)-signedness-error
|-- sparc-randconfig-r073-20250901
|   `-- include-linux-compiler.h:error:expression-in-static-assertion-is-not-an-integer
|-- um-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- um-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- x86_64-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
`-- x86_64-rhel-9.4-rust
    `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path

elapsed time: 1017m

configs tested: 135
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250901    gcc-8.5.0
arc                   randconfig-002-20250901    gcc-11.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                         axm55xx_defconfig    clang-22
arm                                 defconfig    clang-22
arm                   randconfig-001-20250901    clang-22
arm                   randconfig-002-20250901    clang-22
arm                   randconfig-003-20250901    clang-22
arm                   randconfig-004-20250901    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250901    clang-16
arm64                 randconfig-002-20250901    gcc-13.4.0
arm64                 randconfig-003-20250901    clang-22
arm64                 randconfig-004-20250901    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250901    gcc-12.5.0
csky                  randconfig-002-20250901    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250901    clang-17
hexagon               randconfig-002-20250901    clang-17
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250901    clang-20
i386        buildonly-randconfig-002-20250901    clang-20
i386        buildonly-randconfig-003-20250901    gcc-12
i386        buildonly-randconfig-004-20250901    clang-20
i386        buildonly-randconfig-005-20250901    gcc-12
i386        buildonly-randconfig-006-20250901    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250901    gcc-15.1.0
loongarch             randconfig-002-20250901    clang-18
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                           ip30_defconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250901    gcc-11.5.0
nios2                 randconfig-002-20250901    gcc-9.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
openrisc                 simple_smp_defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250901    gcc-11.5.0
parisc                randconfig-002-20250901    gcc-11.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                    amigaone_defconfig    gcc-15.1.0
powerpc                     ep8248e_defconfig    gcc-15.1.0
powerpc                     mpc83xx_defconfig    clang-22
powerpc               randconfig-001-20250901    clang-22
powerpc               randconfig-002-20250901    clang-22
powerpc               randconfig-003-20250901    gcc-13.4.0
powerpc64             randconfig-001-20250901    clang-16
powerpc64             randconfig-002-20250901    gcc-13.4.0
powerpc64             randconfig-003-20250901    gcc-12.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250901    clang-22
riscv                 randconfig-002-20250901    clang-20
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250901    gcc-13.4.0
s390                  randconfig-002-20250901    gcc-13.4.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                         ap325rxa_defconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250901    gcc-15.1.0
sh                    randconfig-002-20250901    gcc-15.1.0
sh                            titan_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250901    gcc-8.5.0
sparc                 randconfig-002-20250901    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250901    clang-20
sparc64               randconfig-002-20250901    gcc-13.4.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250901    gcc-12
um                    randconfig-002-20250901    gcc-12
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250901    clang-20
x86_64      buildonly-randconfig-002-20250901    clang-20
x86_64      buildonly-randconfig-003-20250901    gcc-12
x86_64      buildonly-randconfig-004-20250901    clang-20
x86_64      buildonly-randconfig-005-20250901    gcc-12
x86_64      buildonly-randconfig-006-20250901    clang-20
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250901    gcc-8.5.0
xtensa                randconfig-002-20250901    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

