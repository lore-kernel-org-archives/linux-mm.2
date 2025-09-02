Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E350CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 21:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1238E0007; Tue,  2 Sep 2025 17:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871BC8E0001; Tue,  2 Sep 2025 17:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB488E0007; Tue,  2 Sep 2025 17:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 47CE28E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:29:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A09B81DD4C2
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:29:29 +0000 (UTC)
X-FDA: 83845601658.22.4A63DB2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf19.hostedemail.com (Postfix) with ESMTP id 30E5B1A0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:29:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ceOk4JTc;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756848567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=jhfoADWIUdoQHUIER+Q9wkin7dGcActp1HugCMvr7DU=;
	b=pSbs7dcqAIoU/6U79uY1eisoOMbccjHp7EX2YsOZ6evEkY+qzAwF0gE96cJcJUarTVQ4bO
	KhqqPmBWqlGdxphaueG4ybwInKnSPQ9XrMkiLKWYdkPGAZJvg97ocReOkMZZp+MUZrQQWJ
	J+/ASfLj0hbgayiAl1PYyVpC3oi2dNI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ceOk4JTc;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756848567; a=rsa-sha256;
	cv=none;
	b=ZG/pRUTAJUHKtj+Wd8+HhYVB1FBPqlnXVHcy5xc4wZmqHezaKKZ8865Dhg+8i5CeUlljpV
	x7LjNdizIsRwN3Q9JOcOisnNY70MC5yZVVdSxuhs8+E7xc51OuVSLV4vLhHdXscAUTV5at
	i+GuOxsyOZ2i6r62uALS5iNlKAWxvzk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756848566; x=1788384566;
  h=date:from:to:cc:subject:message-id;
  bh=QiPSz8z8wEQumbeBmh+qUzHQT57rKjkEl+UnJ1Fq/W4=;
  b=ceOk4JTcLk7N5xvO6pF1PSJHFkemHeL9I3yUc7jvVdJXdNEMa88n+o0y
   MbFljS66upVajmZp0qQsIRYkHHQgEL3FP0UZUQ5Sz3iUqOMBcM92UXDAV
   +Ns8hdOxq33YQHcYPIUSQfbfXIbQw3pAR0E8ChwTl4XwG1+ConpWWGchr
   boJjKyYaZM1X2vFak5mAo5Pk3S6QmCTLVJHpqpmeIiYkaLT4ZNpdGiSur
   hxZcj58nm7ea6C6nWOMHAxDugRQxxWvXeL9Xx4/H3Kt8bfI0JtZrYDwKC
   +3HiV4OCzLO3y5DZddacyWYny5rqY63IdiwVAPgYUNZKieRUk4QvUhMQe
   w==;
X-CSE-ConnectionGUID: fi+00MToSQOucMqiAvHGyg==
X-CSE-MsgGUID: LOupoSNVTOiVtxZYkQDkaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="84565301"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="84565301"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 14:29:24 -0700
X-CSE-ConnectionGUID: r4K2KrOMQX26VkD4MiTRVg==
X-CSE-MsgGUID: 2MqRZVL7TuSnmQlkBzA+6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="170663183"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 02 Sep 2025 14:29:22 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utYYg-00032r-2g;
	Tue, 02 Sep 2025 21:29:05 +0000
Date: Wed, 03 Sep 2025 05:28:13 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 3db46a82d467bd23d9ebc473d872a865785299d8
Message-ID: <202509030536.s1ONTOsI-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Stat-Signature: t5r6posna61zri94zrn74kt5rcyhnnc3
X-Rspam-User: 
X-Rspamd-Queue-Id: 30E5B1A0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756848565-430988
X-HE-Meta: U2FsdGVkX1+ltwGMkmiO9eH5R/0G0/tPVfeC/94+sLcHfV0MJl6llIi3ESMW+rGtQbA1ROgCK9ZiV41NsY6PF75Fbp26RPgZDD7xIpUeateYJjOYZGy+FN480AxqlWE7ShUpduAX4pGXikANqLQH6o1ytA4MP/gdlgkumkE3IouR/YMU7VtQhMexYJJnoXEvcv/5E10mjlKKSuzap16OIl1sPLerLfaZXaTngpvtw2RjJi0eg6pund4acFLZPod3qkgHfdPp60rRCUKQvY5li4pp/hmpXgA0YFyTqtH9cqf98w5fqC/YkJJCLW0ioDxZXrPTl5gjaTpRkfVh0+VVPr9/jHBX5dUh28duDjXLMk9mbjQTLMjUNeEllGmW9I9SpaY6N6CVzAqI0l8gOEmBBDC3aeX2jWaF203Ne+CLP/JfqfH4qHkzOQ55YeBHW0K6Z9jKE0qw6J8OZ1XbWgZ1w0LKTkkoOeQyn03WFsDZ+UNYcZ938OEbVHVnUl0dZJvnXM8RttOKG8QLxlJ1MuC0/P/+2Hcb25U/IYOiaUxvJHpt58BhyVbrAfS1+Cr4IIMdwqcmaMrNi4SIScV166rne4DHu3S4YZE+ngmM1uy+5KmVM/A4ZVyakSUmZ01wQcllZ9WpINEgQPU3jXvLUkw9aUZYw5xjoI1l1ziDokmJBCzSsMBbAQKb2V4iuuqOe5oZOvAMOnxWgs9z9/E0u6S+ydxmRQSqz602LI1us/SwIeISTcJrEvF/2VGdA8+0xt9ItctEWCa6i1cqwhY3mMVTszlcHWOK36DKsTWY+IGEdfzbGU7ubzwPJfcgWumwrQEASU5OkSTF6HIDZOAErlU+m9bULGKJs4BhigiPZHBEwPC1UqDts7364JCiWoZucAegSX7G7WjvSPLGhA+RorQgdUA9ZBshmaLumfAc858haX6ETrkyNHpD0f5HRndA2egbs/27p7dTUfPdC0v9+X/
 NZYcCQ5y
 h/fZqFHthnMDrge/70R+SWiJ3IZpZeV0Eb+Mw/dxzlMIkua8JWPH5yqfMAW20PdK5qWkTQWJl2Wk4hO0MIAFTW/vVIxdPW4XW9pdla/iCNmn1Gzq9jKzi1N057M9G6tQGuLDadRDhFZHCFqyOsRYNuWN3N/rCiba4mfxT5+tEPVI4KLaVwryP9RJvaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 3db46a82d467bd23d9ebc473d872a865785299d8  Add linux-next specific files for 20250902

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202508121500.RvXjS54z-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508122300.QreDWTZr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508141518.uFdkyMsT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508142038.M8MuVqEP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508211859.UoYsJbLN-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508231902.ZRQhIhd5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508300519.tZQHY6HA-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509020426.WJtrdwOU-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509020737.MXLgn37j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509021101.Bz8COtDw-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509021811.rZ3p8UnU-lkp@intel.com

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
    arch/arm64/boot/dts/freescale/imx8mp-aristainetos3-helios-lvds.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-aristainetos3-helios-lvds.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-aristainetos3-proton2s.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-aristainetos3-proton2s.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-aristainetos3-proton2s.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-debix-som-a-bmb-08.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-debix-som-a-bmb-08.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-dhcom-drc02.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-dhcom-pdk2.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-dhcom-pdk2.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-dhcom-pdk3.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-dhcom-pdk3.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-dhcom-pdk3.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-dhcom-picoitx.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-dhcom-picoitx.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-lvds0-imx-lvds-hdmi.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-lvds0-imx-lvds-hdmi.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-lvds1-imx-lvds-hdmi.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-lvds1-imx-lvds-hdmi.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-mx8-dlvds-lcd1.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-mx8-dlvds-lcd1.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-pcie-ep.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk-pcie-ep.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-evk.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp-edimm2.2.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp-edimm2.2.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-iota2-lumpy.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-iota2-lumpy.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-kontron-smarc-eval-carrier.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-kontron-smarc-eval-carrier.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-libra-rdk-fpsc-lvds.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-libra-rdk-fpsc-lvds.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-libra-rdk-fpsc.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-libra-rdk-fpsc.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-msc-sm2s-ep1.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-msc-sm2s-ep1.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-navqp.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-nitrogen-enc-carrier-board.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-nitrogen-enc-carrier-board.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-nitrogen-smarc-universal-board.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-nitrogen-smarc-universal-board.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk-no-eth.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk-no-eth.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk-no-eth.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-basic.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-basic.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-hdmi.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-hdmi.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-lt6.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-lt6.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-lt6.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-mi1010ait-1cp1.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-mi1010ait-1cp1.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revc-bd500.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revc-bd500.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revc-tian-g07017.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc-dev.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc-dev.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81-moduline-display-106-av101hdt-a10.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81-moduline-display-106-av101hdt-a10.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81-moduline-display-106-av123z7m-n17.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81-moduline-display-106-av123z7m-n17.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81-moduline-display-106.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81-moduline-display-106.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dtb: isp@32e10000 (fsl,imx8mp-isp): power-domains: [[97, 6]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dtb: isp@32e20000 (fsl,imx8mp-isp): power-domains: [[97, 6]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-var-som-symphony.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-var-som-symphony.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw71xx-2x.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw71xx-2x.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx-2x.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx-2x.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx-2x.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx-2x.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx-imx219.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx-imx219.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx-rpidsi.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx-rpidsi.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw75xx-2x.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw75xx-2x.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw82xx-2x.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-venice-gw82xx-2x.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-nonwifi-dahlia.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-nonwifi-dahlia.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-nonwifi-dahlia.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-nonwifi-dev.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-nonwifi-dev.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-nonwifi-ivy.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-nonwifi-mallow.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-nonwifi-mallow.dtb: isp@32e20000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-nonwifi-yavia.dtb: isp@32e10000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-nonwifi-yavia.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-nonwifi-yavia.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi-dahlia.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi-dahlia.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi-dev.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi-dev.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi-ivy.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi-ivy.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi-mallow.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi-mallow.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi-yavia.dtb: isp@32e10000 (fsl,imx8mp-isp): clocks: [[2, 276], [2, 270], [2, 269]] is too short
    arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi-yavia.dtb: isp@32e20000 (fsl,imx8mp-isp): clock-names: ['isp', 'aclk', 'hclk'] is too short
    arch/arm64/boot/dts/nvidia/tegra186.dtsi:1355.3-41: Warning (interrupt_map): /pcie@10003000:interrupt-map: Missing property '#address-cells' in node /interrupt-controller@3881000, using 0 as fallback
    arch/arm64/boot/dts/nvidia/tegra194.dtsi:2391.4-42: Warning (interrupt_map): /bus@0/pcie@14100000:interrupt-map: Missing property '#address-cells' in node /bus@0/interrupt-controller@3881000, using 0 as fallback
    arch/arm64/boot/dts/nvidia/tegra194.dtsi:2734.4-42: Warning (interrupt_map): /bus@0/pcie@141a0000:interrupt-map: Missing property '#address-cells' in node /bus@0/interrupt-controller@3881000, using 0 as fallback
    arch/arm64/boot/dts/qcom/lemans.dtsi:4497.28-4558.6: Warning (avoid_unnecessary_addr_size): /soc@0/display-subsystem@ae00000/dsi@ae94000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/lemans.dtsi:4579.28-4631.6: Warning (avoid_unnecessary_addr_size): /soc@0/display-subsystem@ae00000/dsi@ae96000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/sm8550.dtsi:4093.22-4183.5: Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    arch/arm64/boot/dts/qcom/sm8650.dtsi:5049.22-5140.5: Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
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
    drivers/bluetooth/bpa10x.c:77:33: error: array type has incomplete element type 'struct h4_recv_pkt'
    drivers/bluetooth/bpa10x.c:78:11: error: 'H4_RECV_ACL' undeclared here (not in a function)
    drivers/bluetooth/bpa10x.c:78:4: error: 'H4_RECV_ACL' undeclared here (not in a function)
    drivers/bluetooth/bpa10x.c:79:11: error: 'H4_RECV_SCO' undeclared here (not in a function)
    drivers/bluetooth/bpa10x.c:79:4: error: 'H4_RECV_SCO' undeclared here (not in a function)
    drivers/bluetooth/bpa10x.c:80:11: error: 'H4_RECV_EVENT' undeclared here (not in a function)
    drivers/bluetooth/bpa10x.c:80:4: error: 'H4_RECV_EVENT' undeclared here (not in a function)
    drivers/bluetooth/bpa10x.c:99:23: error: implicit declaration of function 'h4_recv_buf' [-Werror=implicit-function-declaration]
    drivers/bluetooth/bpa10x.c:99:37: error: implicit declaration of function 'h4_recv_buf' [-Werror=implicit-function-declaration]
    drivers/bluetooth/btmtksdio.c:442:33: error: array type has incomplete element type 'struct h4_recv_pkt'
    drivers/bluetooth/btmtksdio.c:443:11: error: 'H4_RECV_ACL' undeclared here (not in a function)
    drivers/bluetooth/btmtksdio.c:443:4: error: 'H4_RECV_ACL' undeclared here (not in a function)
    drivers/bluetooth/btmtksdio.c:444:11: error: 'H4_RECV_SCO' undeclared here (not in a function)
    drivers/bluetooth/btmtksdio.c:444:4: error: 'H4_RECV_SCO' undeclared here (not in a function)
    drivers/bluetooth/btmtksdio.c:445:11: error: 'H4_RECV_EVENT' undeclared here (not in a function)
    drivers/bluetooth/btmtksdio.c:445:4: error: 'H4_RECV_EVENT' undeclared here (not in a function)
    drivers/bluetooth/btmtksdio.c:493:34: error: invalid use of undefined type 'struct h4_recv_pkt'
    drivers/bluetooth/btmtksdio.c:493:38: error: invalid use of undefined type 'const struct h4_recv_pkt'
    drivers/bluetooth/btmtksdio.c:493:48: error: invalid use of undefined type 'struct h4_recv_pkt'
    drivers/bluetooth/btmtksdio.c:493:52: error: invalid use of undefined type 'const struct h4_recv_pkt'
    drivers/bluetooth/btmtkuart.c:231:33: error: array type has incomplete element type 'struct h4_recv_pkt'
    drivers/bluetooth/btmtkuart.c:232:11: error: 'H4_RECV_ACL' undeclared here (not in a function)
    drivers/bluetooth/btmtkuart.c:232:4: error: 'H4_RECV_ACL' undeclared here (not in a function)
    drivers/bluetooth/btmtkuart.c:233:11: error: 'H4_RECV_SCO' undeclared here (not in a function)
    drivers/bluetooth/btmtkuart.c:233:4: error: 'H4_RECV_SCO' undeclared here (not in a function)
    drivers/bluetooth/btmtkuart.c:234:11: error: 'H4_RECV_EVENT' undeclared here (not in a function)
    drivers/bluetooth/btmtkuart.c:234:4: error: 'H4_RECV_EVENT' undeclared here (not in a function)
    drivers/bluetooth/btmtkuart.c:371:18: error: implicit declaration of function 'h4_recv_buf' [-Werror=implicit-function-declaration]
    drivers/bluetooth/btmtkuart.c:371:32: error: implicit declaration of function 'h4_recv_buf' [-Werror=implicit-function-declaration]
    drivers/bluetooth/btmtkuart.c:371:32: error: implicit declaration of function 'h4_recv_buf' [-Wimplicit-function-declaration]
    drivers/bluetooth/btnxpuart.c:1741:33: error: array type has incomplete element type 'struct h4_recv_pkt'
    drivers/bluetooth/btnxpuart.c:1742:11: error: 'H4_RECV_ACL' undeclared here (not in a function)
    drivers/bluetooth/btnxpuart.c:1742:4: error: 'H4_RECV_ACL' undeclared here (not in a function)
    drivers/bluetooth/btnxpuart.c:1743:11: error: 'H4_RECV_SCO' undeclared here (not in a function)
    drivers/bluetooth/btnxpuart.c:1743:4: error: 'H4_RECV_SCO' undeclared here (not in a function)
    drivers/bluetooth/btnxpuart.c:1744:11: error: 'H4_RECV_EVENT' undeclared here (not in a function)
    drivers/bluetooth/btnxpuart.c:1744:4: error: 'H4_RECV_EVENT' undeclared here (not in a function)
    drivers/bluetooth/btnxpuart.c:1745:11: error: 'H4_RECV_ISO' undeclared here (not in a function)
    drivers/bluetooth/btnxpuart.c:1745:4: error: 'H4_RECV_ISO' undeclared here (not in a function)
    drivers/bluetooth/btnxpuart.c:1759:19: error: implicit declaration of function 'h4_recv_buf' [-Werror=implicit-function-declaration]
    drivers/bluetooth/btnxpuart.c:1759:26: error: implicit declaration of function 'h4_recv_buf' [-Werror=implicit-function-declaration]
    drivers/bluetooth/btnxpuart.c:1759:26: error: implicit declaration of function 'h4_recv_buf' [-Wimplicit-function-declaration]
    drivers/infiniband/hw/mlx5/mr.c:840:31: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
    fs/smb/server/transport_tcp.c:269:47: error: no member named 'skc_v6_daddr' in 'struct sock_common'
    include/acpi/processor.h:448:13: warning: 'acpi_processor_register_idle_driver' defined but not used [-Wunused-function]
    include/acpi/processor.h:451:13: warning: 'acpi_processor_unregister_idle_driver' defined but not used [-Wunused-function]
    include/linux/compiler.h:197:82: error: expression in static assertion is not an integer
    include/linux/compiler_types.h:572:38: error: call to '__compiletime_assert_661' declared with attribute error: min(__x, __y) signedness error
    include/linux/compiler_types.h:572:38: error: call to '__compiletime_assert_962' declared with attribute error: min(__x, __y) signedness error
    include/linux/fortify-string.h:115:33: warning: argument 2 null where non-null expected [-Wnonnull]

Unverified Error/Warning (likely false positive, kindly check if interested):

    aarch64-linux-ld: Unexpected GOT/PLT entries detected!
    aarch64-linux-ld: Unexpected run-time procedure linkages detected!
    arch/mips/boot/dts/mti/sead3.dts:69.17-91.4: Warning (avoid_unnecessary_addr_size): /flash@1c000000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property
    fs/btrfs/tests/inode-tests.c:787 test_btrfs_get_extent() warn: Function too hairy.  No more merges.
    pvr_power.c:(.text+0x2b4): undefined reference to `pwrseq_power_off'
    pvr_power.c:(.text+0x2d4): undefined reference to `pwrseq_power_on'
    pvr_power.c:(.text+0x30c): undefined reference to `devm_pwrseq_get'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- arc-randconfig-001-20250902
|   |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtkuart.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
|   |-- drivers-bluetooth-btmtkuart.c:error:implicit-declaration-of-function-h4_recv_buf
|   `-- include-linux-compiler.h:error:expression-in-static-assertion-is-not-an-integer
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
|-- arm-randconfig-001-20250902
|   |-- drivers-bluetooth-btmtksdio.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtksdio.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtksdio.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtksdio.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
|   |-- drivers-bluetooth-btmtksdio.c:error:invalid-use-of-undefined-type-const-struct-h4_recv_pkt
|   |-- drivers-bluetooth-btmtksdio.c:error:invalid-use-of-undefined-type-struct-h4_recv_pkt
|   `-- include-linux-compiler.h:error:expression-in-static-assertion-is-not-an-integer
|-- arm-randconfig-002-20250902
|   |-- arch-arm-boot-dts-ti-omap-omap2.dtsi.-.:Warning-(avoid_unnecessary_addr_size):cpus:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm-boot-dts-ti-omap-omap2420.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-pinmux:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm-boot-dts-ti-omap-omap2420.dtsi.-.:Warning-(avoid_unnecessary_addr_size):ocp-l4-scm-scm_conf:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm-randconfig-003-20250902
|   |-- arch-arm-boot-dts-nxp-imx-imx7d.dtsi.-.:Warning-(interrupt_map):soc-pcie:interrupt-map:Missing-property-address-cells-in-node-soc-interrupt-controller-using-as-fallback
|   `-- arch-arm-boot-dts-nxp-vf-vfxxx.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-bus-spi-400ad000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm-randconfig-051-20250902
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
|-- arm-randconfig-052-20250902
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
|-- arm-randconfig-053-20250902
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
|-- arm-randconfig-054-20250902
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
|-- arm-randconfig-055-20250902
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
|-- arm64-randconfig-001-20250902
|   |-- aarch64-linux-ld:Unexpected-GOT-PLT-entries-detected
|   |-- aarch64-linux-ld:Unexpected-run-time-procedure-linkages-detected
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   |-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(__x-__y)-signedness-error
|   |-- pvr_power.c:(.text):undefined-reference-to-devm_pwrseq_get
|   |-- pvr_power.c:(.text):undefined-reference-to-pwrseq_power_off
|   `-- pvr_power.c:(.text):undefined-reference-to-pwrseq_power_on
|-- arm64-randconfig-002-20250902
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae94000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-lemans.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-display-subsystem-ae00000-dsi-ae96000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-r
|   |-- arch-arm64-boot-dts-qcom-sm8550.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|   `-- arch-arm64-boot-dts-qcom-sm8650.dtsi.-.:Warning-(avoid_unnecessary_addr_size):soc-usb-a600000:unnecessary-address-cells-size-cells-without-ranges-dma-ranges-or-child-reg-or-ranges-property
|-- arm64-randconfig-004-20250902
|   |-- arch-arm64-boot-dts-nvidia-tegra186.dtsi.:Warning-(interrupt_map):pcie:interrupt-map:Missing-property-address-cells-in-node-interrupt-controller-using-as-fallback
|   |-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie-141a0000:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|   `-- arch-arm64-boot-dts-nvidia-tegra194.dtsi.:Warning-(interrupt_map):bus-pcie:interrupt-map:Missing-property-address-cells-in-node-bus-interrupt-controller-using-as-fallback
|-- arm64-randconfig-051-20250902
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-helios-lvds.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-helios-lvds.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-beacon-kit.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-beacon-kit.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-data-modul-edm-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-data-modul-edm-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-model-a.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-model-a.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-som-a-bmb-.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-som-a-bmb-.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-drc02.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk2.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk2.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-picoitx.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-picoitx.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-lvds-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-lvds-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-lvds-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-lvds-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-mx8-dlvds-lcd1.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-mx8-dlvds-lcd1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-pcie-ep.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-pcie-ep.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-icore-mx8mp-edimm2..dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-icore-mx8mp-edimm2..dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-iota2-lumpy.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-iota2-lumpy.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-bl-osm-s.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-bl-osm-s.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-dl.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-smarc-eval-carrier.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-smarc-eval-carrier.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc-lvds.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc-lvds.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-msc-sm2s-ep1.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-msc-sm2s-ep1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-navqp.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-enc-carrier-board.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-enc-carrier-board.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-smarc-universal-board.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-smarc-universal-board.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-toradex-smarc-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-toradex-smarc-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av101hdt-a10.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av101hdt-a10.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av123z7m-n17.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av123z7m-n17.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-var-som-symphony.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-var-som-symphony.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw71xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw71xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw72xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw72xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw73xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw73xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-rpidsi.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-rpidsi.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw75xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw75xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw82xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw82xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-ivy.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-mallow.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-mallow.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dahlia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-ivy.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-ivy.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-mallow.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-mallow.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-yavia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
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
|-- arm64-randconfig-052-20250902
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-helios-lvds.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-helios-lvds.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-beacon-kit.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-beacon-kit.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-data-modul-edm-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-data-modul-edm-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-model-a.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-model-a.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-som-a-bmb-.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-som-a-bmb-.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-drc02.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk2.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk2.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-picoitx.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-picoitx.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-lvds-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-lvds-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-lvds-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-lvds-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-mx8-dlvds-lcd1.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-mx8-dlvds-lcd1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-pcie-ep.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-pcie-ep.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-icore-mx8mp-edimm2..dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-icore-mx8mp-edimm2..dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-iota2-lumpy.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-iota2-lumpy.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-bl-osm-s.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-bl-osm-s.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-dl.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-smarc-eval-carrier.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-smarc-eval-carrier.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc-lvds.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc-lvds.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-msc-sm2s-ep1.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-msc-sm2s-ep1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-navqp.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-enc-carrier-board.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-enc-carrier-board.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-smarc-universal-board.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-smarc-universal-board.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-toradex-smarc-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-toradex-smarc-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av101hdt-a10.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av101hdt-a10.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av123z7m-n17.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av123z7m-n17.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-var-som-symphony.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-var-som-symphony.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw71xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw71xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw72xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw72xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw73xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw73xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-rpidsi.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-rpidsi.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw75xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw75xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw82xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw82xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-ivy.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-mallow.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-mallow.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dahlia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-ivy.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-ivy.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-mallow.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-mallow.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-yavia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
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
|-- arm64-randconfig-053-20250902
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-helios-lvds.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-helios-lvds.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-beacon-kit.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-beacon-kit.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-data-modul-edm-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-data-modul-edm-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-model-a.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-model-a.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-som-a-bmb-.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-som-a-bmb-.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-drc02.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk2.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk2.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-picoitx.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-picoitx.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-lvds-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-lvds-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-lvds-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-lvds-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-mx8-dlvds-lcd1.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-mx8-dlvds-lcd1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-pcie-ep.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-pcie-ep.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-icore-mx8mp-edimm2..dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-icore-mx8mp-edimm2..dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-iota2-lumpy.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-iota2-lumpy.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-bl-osm-s.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-bl-osm-s.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-dl.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-smarc-eval-carrier.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-smarc-eval-carrier.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc-lvds.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc-lvds.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-msc-sm2s-ep1.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-msc-sm2s-ep1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-navqp.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-enc-carrier-board.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-enc-carrier-board.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-smarc-universal-board.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-smarc-universal-board.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-toradex-smarc-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-toradex-smarc-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av101hdt-a10.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av101hdt-a10.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av123z7m-n17.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av123z7m-n17.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-var-som-symphony.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-var-som-symphony.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw71xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw71xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw72xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw72xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw73xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw73xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-rpidsi.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-rpidsi.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw75xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw75xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw82xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw82xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-ivy.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-mallow.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-mallow.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dahlia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-ivy.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-ivy.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-mallow.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-mallow.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-yavia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
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
|-- arm64-randconfig-054-20250902
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-helios-lvds.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-helios-lvds.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-beacon-kit.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-beacon-kit.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-data-modul-edm-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-data-modul-edm-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-model-a.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-model-a.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-som-a-bmb-.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-som-a-bmb-.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-drc02.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk2.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk2.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-picoitx.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-picoitx.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-lvds-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-lvds-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-lvds-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-lvds-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-mx8-dlvds-lcd1.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-mx8-dlvds-lcd1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-pcie-ep.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-pcie-ep.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-icore-mx8mp-edimm2..dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-icore-mx8mp-edimm2..dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-iota2-lumpy.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-iota2-lumpy.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-bl-osm-s.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-bl-osm-s.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-dl.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-smarc-eval-carrier.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-smarc-eval-carrier.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc-lvds.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc-lvds.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-msc-sm2s-ep1.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-msc-sm2s-ep1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-navqp.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-enc-carrier-board.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-enc-carrier-board.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-smarc-universal-board.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-smarc-universal-board.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-toradex-smarc-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-toradex-smarc-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av101hdt-a10.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av101hdt-a10.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av123z7m-n17.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av123z7m-n17.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-var-som-symphony.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-var-som-symphony.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw71xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw71xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw72xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw72xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw73xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw73xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-rpidsi.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-rpidsi.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw75xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw75xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw82xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw82xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-ivy.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-mallow.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-mallow.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dahlia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-ivy.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-ivy.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-mallow.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-mallow.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-yavia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
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
|-- arm64-randconfig-055-20250902
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-helios-lvds.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-helios-lvds.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-aristainetos3-proton2s.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-beacon-kit.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-beacon-kit.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-data-modul-edm-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-data-modul-edm-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-model-a.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-model-a.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-som-a-bmb-.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-debix-som-a-bmb-.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-drc02.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk2.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk2.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-pdk3.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-picoitx.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-dhcom-picoitx.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-dlvds-hdmi-channel0.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-lvds-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds0-imx-lvds-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-dlvds-hdmi-channel0.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-lvds-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-lvds1-imx-lvds-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-mx8-dlvds-lcd1.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-mx8-dlvds-lcd1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-pcie-ep.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk-pcie-ep.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-evk.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-icore-mx8mp-edimm2..dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-icore-mx8mp-edimm2..dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-iota2-lumpy.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-iota2-lumpy.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-bl-osm-s.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-bl-osm-s.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-dl.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-smarc-eval-carrier.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-kontron-smarc-eval-carrier.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc-lvds.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc-lvds.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-libra-rdk-fpsc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-msc-sm2s-ep1.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-msc-sm2s-ep1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-navqp.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-enc-carrier-board.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-enc-carrier-board.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-smarc-universal-board.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-nitrogen-smarc-universal-board.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk-no-eth.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-phyboard-pollux-rdk.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-toradex-smarc-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-toradex-smarc-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314-lvds-tm070jvhg33.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mp-ras314.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-g133han01.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl-lvds-tm070jvhg33.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tqma8mpql-mba8mpxl.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av101hdt-a10.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av101hdt-a10.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av123z7m-n17.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-tx8p-ml81-moduline-display-av123z7m-n17.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e10000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-ultra-mach-sbc.dtb:isp-32e20000-(fsl-imx8mp-isp):power-domains:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-var-som-symphony.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-var-som-symphony.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw71xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw71xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw72xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw72xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw73xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw73xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-imx219.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-imx219.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-rpidsi.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx-rpidsi.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw74xx.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw75xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw75xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw82xx-2x.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-venice-gw82xx-2x.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dahlia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-ivy.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-mallow.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-mallow.dtb:isp-32e20000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-nonwifi-yavia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dahlia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dahlia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dev.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-dev.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-ivy.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-ivy.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-mallow.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-mallow.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-yavia.dtb:isp-32e10000-(fsl-imx8mp-isp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-verdin-wifi-yavia.dtb:isp-32e20000-(fsl-imx8mp-isp):clock-names:isp-aclk-hclk-is-too-short
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
|-- csky-randconfig-001-20250902
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-randconfig-002-20250902
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-randconfig-r113-20250902
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|   |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtkuart.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
|   |-- drivers-bluetooth-btmtkuart.c:error:implicit-declaration-of-function-h4_recv_buf
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_ISO-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
|   |-- drivers-bluetooth-btnxpuart.c:error:implicit-declaration-of-function-h4_recv_buf
|   `-- include-linux-compiler.h:error:expression-in-static-assertion-is-not-an-integer
|-- hexagon-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- hexagon-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- hexagon-randconfig-002-20250902
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- i386-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
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
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- parisc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- parisc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- powerpc64-randconfig-r071-20250902
|   `-- fs-btrfs-tests-inode-tests.c-test_btrfs_get_extent()-warn:Function-too-hairy.-No-more-merges.
|-- riscv-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- riscv-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- riscv-randconfig-002-20250902
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   `-- fs-smb-server-transport_tcp.c:error:no-member-named-skc_v6_daddr-in-struct-sock_common
|-- riscv-randconfig-r132-20250902
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
|-- sparc-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- sparc-randconfig-002-20250902
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(__x-__y)-signedness-error
|-- sparc64-randconfig-001-20250902
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- um-allmodconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- um-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- um-randconfig-002-20250902
|   `-- include-linux-fortify-string.h:warning:argument-null-where-non-null-expected
|-- x86_64-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- x86_64-randconfig-075-20250902
|   |-- drivers-bluetooth-bpa1.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-bpa1.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-bpa1.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-bpa1.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
|   |-- drivers-bluetooth-bpa1.c:error:implicit-declaration-of-function-h4_recv_buf
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_ISO-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
|   `-- drivers-bluetooth-btnxpuart.c:error:implicit-declaration-of-function-h4_recv_buf
|-- x86_64-randconfig-122-20250902
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- include-acpi-processor.h:warning:acpi_processor_register_idle_driver-defined-but-not-used
|   `-- include-acpi-processor.h:warning:acpi_processor_unregister_idle_driver-defined-but-not-used
|-- x86_64-rhel-9.4-rust
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- xtensa-allyesconfig
|   `-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|-- xtensa-randconfig-001-20250902
|   |-- Warning:fs-ceph-mds_client.c-function-parameter-path_info-not-described-in-ceph_mdsc_build_path
|   |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btmtkuart.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
|   |-- drivers-bluetooth-btmtkuart.c:error:implicit-declaration-of-function-h4_recv_buf
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_ISO-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
|   |-- drivers-bluetooth-btnxpuart.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
|   |-- drivers-bluetooth-btnxpuart.c:error:implicit-declaration-of-function-h4_recv_buf
|   `-- include-linux-compiler.h:error:expression-in-static-assertion-is-not-an-integer
`-- xtensa-randconfig-002-20250902
    |-- drivers-bluetooth-bpa1.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-bpa1.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-bpa1.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-bpa1.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
    |-- drivers-bluetooth-bpa1.c:error:implicit-declaration-of-function-h4_recv_buf
    |-- drivers-bluetooth-btmtksdio.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-btmtksdio.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-btmtksdio.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-btmtksdio.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
    |-- drivers-bluetooth-btmtksdio.c:error:invalid-use-of-undefined-type-const-struct-h4_recv_pkt
    |-- drivers-bluetooth-btmtksdio.c:error:invalid-use-of-undefined-type-struct-h4_recv_pkt
    |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-btmtkuart.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-btmtkuart.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
    |-- drivers-bluetooth-btmtkuart.c:error:implicit-declaration-of-function-h4_recv_buf
    |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_ACL-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_EVENT-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_ISO-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-btnxpuart.c:error:H4_RECV_SCO-undeclared-here-(not-in-a-function)
    |-- drivers-bluetooth-btnxpuart.c:error:array-type-has-incomplete-element-type-struct-h4_recv_pkt
    |-- drivers-bluetooth-btnxpuart.c:error:implicit-declaration-of-function-h4_recv_buf
    `-- include-linux-compiler.h:error:expression-in-static-assertion-is-not-an-integer

elapsed time: 938m

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
arc                   randconfig-001-20250902    gcc-11.5.0
arc                   randconfig-002-20250902    gcc-9.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                        neponset_defconfig    gcc-15.1.0
arm                   randconfig-001-20250902    gcc-15.1.0
arm                   randconfig-002-20250902    gcc-8.5.0
arm                   randconfig-003-20250902    clang-22
arm                   randconfig-004-20250902    clang-22
arm                           stm32_defconfig    gcc-15.1.0
arm                    vt8500_v6_v7_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250902    gcc-8.5.0
arm64                 randconfig-002-20250902    clang-22
arm64                 randconfig-003-20250902    gcc-12.5.0
arm64                 randconfig-004-20250902    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250902    gcc-14.3.0
csky                  randconfig-002-20250902    gcc-12.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250902    clang-18
hexagon               randconfig-002-20250902    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250902    clang-20
i386        buildonly-randconfig-002-20250902    clang-20
i386        buildonly-randconfig-003-20250902    gcc-12
i386        buildonly-randconfig-004-20250902    clang-20
i386        buildonly-randconfig-005-20250902    gcc-12
i386        buildonly-randconfig-006-20250902    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250902    clang-22
loongarch             randconfig-002-20250902    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                        mvme147_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                        bcm63xx_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250902    gcc-9.5.0
nios2                 randconfig-002-20250902    gcc-11.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250902    gcc-8.5.0
parisc                randconfig-002-20250902    gcc-11.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20250902    gcc-9.5.0
powerpc               randconfig-002-20250902    gcc-8.5.0
powerpc               randconfig-003-20250902    gcc-11.5.0
powerpc                        warp_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20250902    gcc-12.5.0
powerpc64             randconfig-002-20250902    clang-22
powerpc64             randconfig-003-20250902    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250902    gcc-13.4.0
riscv                 randconfig-002-20250902    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250902    clang-22
s390                  randconfig-002-20250902    gcc-10.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250902    gcc-12.5.0
sh                    randconfig-002-20250902    gcc-12.5.0
sh                        sh7757lcr_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250902    gcc-14.3.0
sparc                 randconfig-002-20250902    gcc-8.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250902    clang-20
sparc64               randconfig-002-20250902    gcc-9.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250902    gcc-12
um                    randconfig-002-20250902    gcc-12
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250902    clang-20
x86_64      buildonly-randconfig-002-20250902    clang-20
x86_64      buildonly-randconfig-003-20250902    clang-20
x86_64      buildonly-randconfig-004-20250902    gcc-12
x86_64      buildonly-randconfig-005-20250902    gcc-12
x86_64      buildonly-randconfig-006-20250902    gcc-12
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250902    gcc-9.5.0
xtensa                randconfig-002-20250902    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

