Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C13A606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OpcouBhj
Received: by kanga.kvack.org (Postfix)
	id 36C4C6B05B0; Sun, 22 Nov 2026 13:56:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D9A6B05B2; Sun, 22 Nov 2026 13:56:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233BE6B05B5; Sun, 22 Nov 2026 13:56:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBE696B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:56:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B43AA078E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:56:10 +0000 (UTC)
X-FDA: 85463660100.02.F9716FA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0092E40002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:56:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OpcouBhj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373768;
	b=aXOVLL8eoU62ZtsJa2x170JHIscK8Ci1gbcEXdeYLiYJKV6KCcOXBt1E3yAuWKolyoC7ly
	OLBA+W9mVjimOymnEOgVzEtRqxSDRekJ+8aZeP0laF/w9Y/N5sccd2BWEHO9yr5HhJD34q
	DfGS0pPwW2qQb5wkUGpa86iA76kRu84=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=kznzQtzFyyUlX689Zw9K7kQNXH2Gi01M9oRQQ1Ar4fw=;
	b=mo6ShfcK/uPU0scDYazQZShpDykuLpHi8wobbsuJ4su++UmcV63wqlWPIdfFpYZjfCWT89
	In27lVfXsMP0YH54eqRCXlyHhWWzeEbZyyyPt4ZVoDexMiTT5LdKw9/fEW2Y9Nyo7tYCOf
	IEatIob/HKQ3/WjwajUYHzzS7DvJMt4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OpcouBhj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795373767; x=1826909767;
  h=date:from:to:cc:subject:message-id;
  bh=jdVUGEtpBI/vCTb3UYz+yoIgpfLfoHbL7GIKonKyRKs=;
  b=OpcouBhjR/GGFuMXv3+Xh8LQBw9s0KJYCIWF/OP75Iq+mcoxjaxfqD5P
   dN3LwROrEuqpyLOlj4MmG3xABxDeHrjmhkMzR2K500bapa9eD3Wf6LMF6
   0Ttov0Xb1I6t0a53u40aHpiB7VqcrFjrTpvm/g8i3WS77XbJ2wNbfumQD
   3WNAx/autNMzjFoH6Te9hPwOcz4A3B23og4RshQudcJV9VrNDcQ1t9q1c
   QmFWLx0KireIiTGW7rOVbxYT8DZrkee7ZUsYEVQuELl3TKl5EA/IPXicy
   ARsmnlAjtg9/UHy9fhSJqrI/6mUr57Suiy5bWNlyQ59P3ABz4ncPujq7R
   A==;
X-CSE-ConnectionGUID: Xrp9hLbDT9+8A16WjoYAwQ==
X-CSE-MsgGUID: +1XWQt+cTsCqrnsbB9MPbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11974"; a="4079144"
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="4079144"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2026 10:56:06 -0800
X-CSE-ConnectionGUID: s8u3xvfiRMWcZcNTgy/QWA==
X-CSE-MsgGUID: BMHaiWcZSgO/5uXzGtfa6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="11215236"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by orviesa001.jf.intel.com with ESMTP; 22 Nov 2026 10:56:04 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xVCjJ-000000004ao-1HuQ;
	Sun, 22 Nov 2026 18:56:01 +0000
Date: Sun, 22 Nov 2026 19:55:07 +0100
From: kernel test robot <lkp@intel.com>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Christian Brauner <christianvanbrauner@gmail.com>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [brauner-vfs:vfs.fixes 12/19] WARNING: modpost: vmlinux:
 section mismatch in reference: ieee80211_report_ack_skb+0x20 (section: .text)
 -> rcupdate_announce_bootup_oddness (section: .init.text)
Message-ID: <20261122195208.Owp21PY7-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0092E40002
X-Stat-Signature: bz1qqet4g5xmkiwsgbuqhjmuk4o3bojy
X-HE-Tag: 1795373766-146649
X-HE-Meta: U2FsdGVkX19GEN6UEAJHvMtwAhJu2V3UxMuUwakGBs+EyBTisgwHB0MRRKfgb/zo9VjRC4nxOnGSS//VsVzgTWNIcwdFaaPmgpIyDNufcBUqtbAMHswsN3YfqWsLEKImvMhzm08BhL4aRDshVr2yGZ9RGcp88a1PKnZJxEGWYCwEOOCBBB6k5AYIuzEjIsG1m9DsA1bXAOdh0UdA+Q6zN/r++M8A45ZJC9bDAGBddUZGYdOqfYzawLUZgSAZu6l5AqrRgpn76zOivCOObWJIpURIBvQzcE4c2R1OGoNoFPDjUzKA+DXRbbY2s5ZwyBd+ZZmMVwf7sUgnhusPUuIVwKAnIMHFw6v45kMBhkAhrmJQ2JBNk9lzkmMAqA5TOaWVx4cS4q697wZfKIOoCVL8m/DibLYq/j07jRtBe9zRU8/sq85cwrPz1TKktiIcaShLBwIrSZ2aYajEGZ9anZvAFd73HB7Jg8oZi2jtfsDtd/2DhdB43fF3yi/9Ln6u5Si0Uj4ZOelCfSIs3aMz8dNbpx7LNykcGdxRa+65FPW81OeSlags5pSzLPHCJMQ9dY1W9q5lXDDMUDeAXU3PS/OGPSRvfL0PJYwEUaefVdtb7OtIatk6z/vChwU/+uwpSXRdJ9OUFbiZLf1bDEWTb0Iavj0srT3kg6O73CFptq9dXLrdV7+Kj6+bnWoC36aQw63Y0aAZ6l1V/8pTRHwQkRTZOvNZ3C3qx/KcsDppFSgyWZwbvv0S3P0R8X4jn9OdosV7PbpzRE2/StWjr9x9XXz9JhPAVU4ZuHA2W0hEE/rbTskK16X3gdUHAD8DnZmfs1BUWaw9JrW4CYfGQ00H3Otu46wK5ERAxxJ/JdjdYqk8GGKuryYxubwmgsncCi4Ry36XkKn4qBm1YnPidjzCgpQ3e4fEErBOJfeZIFVObD51BqkFQCR56pyfGs0lNpzMc0bnazxxnwj4woOmp+7Uoh9
 TvkCBdM+
 nDww7YkYfC97AFJTGcl3sDAbPq1OD2lUZsV5MmhsIDEzi3YP61V0lcxI/ZT0MNweWfkCMv4yuBetBAf7vyDXugv2c7fxbo4v8YSoWuymkFqBS79WS5THgN5uBgemrB4uv6ik1cPCqWaftCyZMnVPZQAXEVT4KfE+QcZgwk3uVlAFTj3dXmsthWoX+7EOreHN5BDPWipbhD9t/0cqNS0Ffch6sjnBaYJgg40fxa569flUG5w6W7icHRBO5SmFgTyUhjkFV/acoVSj/DgoobNWf5t42jjm+2xFKBzvkbaNBz9x/6kcgdwbEeBsq0pDOsbXdJUOBTAY3oCidkAc706CE4naXpcaNj5HKXdKPcijrHBFyI//x6SMVpHPOvJW5x2a7fLDjqSv6xyzE9A4D892de9brMSPLYLFH27cjktFpDW7EckP4d9ybjgOB0mxpZDvgkI1ddEeP0hbctARYr4BUFbEi575KaVYf7p3tg00673IJkiAMXZtbkb300w83a8DE+JptnERe65IxUnfqq9Tu7owmv6ewgkJlDoJ5Db2nCEvvAVxFNmQQZGCBHBy2/DVMGwF3xJuYPgdEvrtpFHnvW44oiiibW2+dL8K2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.fixes
head:   d5b84d3d7e902c44b05b106718c579f3d3834812
commit: f4bd14573f4c77a8bda7b6e91b6757ddfc6bad9a [12/19] iov_iter: validate extracted segment for bvec alignment
config: loongarch-randconfig-r2106-20261122 (https://download.01.org/0day-ci/archive/20261122/20261122195208.Owp21PY7-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261122/20261122195208.Owp21PY7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261122195208.Owp21PY7-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: vmlinux: section mismatch in reference: nsim_queue_free+0xc0 (section: .text) -> .LVL46 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_queue_free+0xc4 (section: .text) -> .LVL31 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_init_netdevsim+0x2c (section: .text) -> .LVL37 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_init_netdevsim+0x3c (section: .text) -> .LVL45 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_init_netdevsim+0x44 (section: .text) -> .LVL49 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_init_netdevsim+0x54 (section: .text) -> .LVL50 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_ipsec_del_sa+0x74 (section: .text) -> .LVL67 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_ipsec_del_sa+0x78 (section: .text) -> .LVL70 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_ipsec_add_sa+0x1c (section: .text) -> .LVL72 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_ipsec_add_sa+0x338 (section: .text) -> .LBB296 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_ipsec_add_sa+0x370 (section: .text) -> .LBB319 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_ipsec_add_sa+0x390 (section: .text) -> .LBB327 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_ipsec_add_sa+0x3c4 (section: .text) -> .LBB332 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: nsim_ipsec_add_sa+0x3c8 (section: .text) -> .LBB355 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: fw_core_add_descriptor+0xec (section: .text) -> pnpacpi_option_resource (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: fw_core_remove_descriptor+0xb4 (section: .text) -> pnpacpi_option_resource (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: fw_schedule_bus_reset+0xc4 (section: .text) -> pnpacpi_parse_resource_option_data (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ar_context_init+0x1f4 (section: .text) -> __fixed_factor_clk_of_clk_init_declare (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: trace_event_raw_event_irqs+0xb0 (section: .text) -> .LBB404 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: handle_at_packet+0x210 (section: .text) -> __fixed_factor_clk_of_clk_init_declare (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: at_request_local_work+0x10 (section: .text) -> .LVL178 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: trace_event_raw_event_self_id_complete+0x14 (section: .text) -> .LBI405 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: trace_event_raw_event_self_id_complete+0x100 (section: .text) -> .LBB405 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: context_add_buffer+0xdc (section: .text) -> .LBI406 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: queue_iso_transmit+0x30 (section: .text) -> .LBB406 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: queue_iso_packet_per_buffer+0x204 (section: .text) -> .LBI408 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ohci_queue_iso+0x30 (section: .text) -> .LBB408 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ohci_allocate_iso_context+0x15c (section: .text) -> .LBI410 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ohci_allocate_iso_context+0x178 (section: .text) -> .LBB410 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ohci_allocate_iso_context+0x4dc (section: .text) -> .LBI411 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: at_context_transmit+0x50 (section: .text) -> .LBB411 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: pci_probe+0x30 (section: .text) -> .LBI412 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: pci_probe+0x48 (section: .text) -> .LBB412 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: pci_probe+0xf8 (section: .text) -> of_fixed_factor_clk_setup (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: pci_probe+0xfc (section: .text) -> .LBB413 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: pci_probe+0x1bc (section: .text) -> .LBI414 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: pci_probe+0x1d4 (section: .text) -> .LBB414 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: pci_probe+0x290 (section: .text) -> .LBI415 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: pci_probe+0x29c (section: .text) -> .LBB415 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: pci_probe+0x30c (section: .text) -> .LBI416 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: pci_probe+0x310 (section: .text) -> .LBB416 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: pci_probe+0x38c (section: .text) -> .LBI416 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ppkb_adap_smbus_xfer+0xbc (section: .text) -> genpd_debug_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cyapa_pip_retrieve_data_structure.constprop.0+0x10c (section: .text) -> virtio_mmio_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cyapa_gen6_show_baseline+0x30 (section: .text) -> .LBI1236 (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cyapa_gen6_show_baseline+0x100 (section: .text) -> .LVL546 (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cyapa_gen6_show_baseline+0x104 (section: .text) -> virtio_pci_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cyapa_gen6_show_baseline+0x158 (section: .text) -> .LVL545 (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cyapa_gen6_show_baseline+0x178 (section: .text) -> virtio_mmio_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cyapa_gen6_show_baseline+0x17c (section: .text) -> virtio_pci_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: elantech_setup_ps2+0x118 (section: .text) -> virtio_input_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: elantech_setup_ps2+0x13c (section: .text) -> virtio_input_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: elantech_setup_ps2+0x1f4 (section: .text) -> virtio_input_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: elantech_detect+0x1c4 (section: .text) -> virtio_input_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: rmi_2d_sensor_of_probe+0x224 (section: .text) -> regulator_userspace_consumer_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: rmi_2d_sensor_of_probe+0x228 (section: .text) -> pm8607_regulator_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: rmi_2d_sensor_of_probe+0x248 (section: .text) -> regulator_userspace_consumer_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: rmi_f34v7_read_queries+0x270 (section: .text) -> da9063_regulator_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: rmi_f34v7_read_queries+0x278 (section: .text) -> bq257xx_reg_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: rmi_f34v7_do_reflash+0x27c (section: .text) -> bd957x_regulator_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_device_probe+0x4a0 (section: .text) -> rt4803_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_host_notify_irq_teardown+0x1c (section: .text) -> rt4803_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_del_adapter+0x10c (section: .text) -> rt4803_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: trace_event_raw_event_i2c_result+0x14 (section: .text) -> rt4803_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_del_driver+0x1c (section: .text) -> rt4803_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __i2c_transfer+0x94 (section: .text) -> init_userspace_fs (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_transfer+0x18 (section: .text) -> init_userspace_fs (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __i2c_smbus_xfer+0x1a8 (section: .text) -> init_userspace_fs (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_smbus_xfer+0x18 (section: .text) -> init_userspace_fs (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_detect_slave_mode+0x10 (section: .text) -> rt5190a_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_detect_slave_mode+0x44 (section: .text) -> rt5739_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_detect_slave_mode+0x100 (section: .text) -> rt5190a_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_detect_slave_mode+0x104 (section: .text) -> rt5739_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: sdio_read_cccr+0x30 (section: .text) -> .LVL489 (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: sdio_read_cccr+0xf4 (section: .text) -> .LVL490 (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mmc_sdio_switch_hs+0x14 (section: .text) -> .LVL491 (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mmc_sdio_switch_hs+0x54 (section: .text) -> .LVL492 (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: sdio_set_bus_speed_mode+0x14 (section: .text) -> .LVL493 (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: sdio_set_bus_speed_mode+0x8c (section: .text) -> .LVL494 (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mmc_rca_show+0x14 (section: .text) -> amdgpu_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: info4_show+0x44 (section: .text) -> .LDL1 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: info3_show+0x44 (section: .text) -> .LVL0 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: info2_show+0x44 (section: .text) -> .LVL1 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: info1_show+0x44 (section: .text) -> .LVL3 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mmc_revision_show+0x18 (section: .text) -> .LVL4 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mmc_revision_show+0x1c (section: .text) -> .LVL6 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mmc_device_show+0x14 (section: .text) -> .LVL9 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mmc_vendor_show+0x14 (section: .text) -> .LVL10 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: rds_queue_reconnect+0x180 (section: .text) -> __TRACE_SYSTEM_WB_REASON_PERIODIC (section: .init.data)
WARNING: modpost: vmlinux: section mismatch in reference: _cfg80211_calculate_bitrate_eht_uhr+0x4bc (section: .text) -> .Lpcadd_hi102 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfg80211_calculate_bitrate+0x70 (section: .text) -> .Lpcadd_hi103 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfg80211_calculate_bitrate+0x150 (section: .text) -> .Lpcadd_hi104 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfg80211_calculate_bitrate+0x22c (section: .text) -> .Lpcadd_hi105 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfg80211_calculate_bitrate+0x2ac (section: .text) -> .Lpcadd_hi106 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfg80211_get_p2p_attr+0x104 (section: .text) -> .Lpcadd_hi107 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ieee80211_operating_class_to_chandef.part.0+0x4c (section: .text) -> .Lpcadd_hi108 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ieee80211_operating_class_to_chandef.part.0+0x50 (section: .text) -> pid_namespace_sysctl_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: cfg80211_wdev_channel_allowed+0xf4 (section: .text) -> pid_idr_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: trace_event_raw_event_rdev_change_virtual_intf+0x144 (section: .text) -> lockdep_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ieee80211_tx_rate_update+0x94 (section: .text) -> tasks_cblist_init_generic (section: .init.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: ieee80211_report_ack_skb+0x20 (section: .text) -> rcupdate_announce_bootup_oddness (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: aead_decrypt+0x224 (section: .text) -> .LBI53648 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ieee80211_add_nan_func+0xa8 (section: .text) -> tk_debug_sleep_time_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ieee80211_add_nan_func+0x190 (section: .text) -> tk_debug_sleep_time_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ieee80211_set_sta_4addr+0x314 (section: .text) -> time_ns_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ieee80211_set_sta_4addr+0x350 (section: .text) -> time_ns_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ieee80211_set_sta_4addr+0x43c (section: .text) -> time_ns_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mesh_path_send_to_gates+0xa8 (section: .text) -> .LVL1 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_stop+0x88 (section: .text) -> .LBI1710 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_stop+0x94 (section: .text) -> .LBB1710 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x18 (section: .text) -> .LBI1711 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0xac (section: .text) -> .LBB1711 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x394 (section: .text) -> .LBI1712 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x3c4 (section: .text) -> .LBB1712 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x44c (section: .text) -> .LBB1714 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x488 (section: .text) -> .LVL150 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x498 (section: .text) -> .LBI1736 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x4cc (section: .text) -> .LBB1736 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x54c (section: .text) -> .LBI1737 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x588 (section: .text) -> .LBB1737 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x648 (section: .text) -> .LBI1739 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x654 (section: .text) -> .LBB1739 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x6d8 (section: .text) -> .LBI1740 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x70c (section: .text) -> .LBB1740 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x7dc (section: .text) -> .LBI1741 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x814 (section: .text) -> .LBB1741 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x8d4 (section: .text) -> .LBI1742 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: drv_start+0x908 (section: .text) -> .LBB1742 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_cleanup_locked.isra.0+0x170 (section: .text) -> .LBB1744 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_cleanup_locked.isra.0+0x1a8 (section: .text) -> .LBB1745 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_cleanup_locked.isra.0+0x1b4 (section: .text) -> .LBI1746 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_cleanup_locked.isra.0+0x1f0 (section: .text) -> .LBB1746 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x7c (section: .text) -> .LBI1747 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0xb8 (section: .text) -> .LBB1747 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x144 (section: .text) -> .LBI1748 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x148 (section: .text) -> .LBB1748 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x194 (section: .text) -> .LBI1749 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x1f4 (section: .text) -> .LBB1749 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x20c (section: .text) -> .LBB1751 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x210 (section: .text) -> .LVL155 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x234 (section: .text) -> .LBI1786 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x244 (section: .text) -> .LBB1786 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x250 (section: .text) -> .LBB1751 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x294 (section: .text) -> .LBI1787 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x2a4 (section: .text) -> .LBB1786 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x2a8 (section: .text) -> .LBB1787 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_transmit_beacon.isra.0+0x2b0 (section: .text) -> .LBB1751 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x70 (section: .text) -> .LBI1789 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x74 (section: .text) -> .LBB1789 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x18c (section: .text) -> .LBI1790 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x194 (section: .text) -> .LBB1790 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x224 (section: .text) -> .LBI1748 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x25c (section: .text) -> .LBI1791 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x264 (section: .text) -> .LBB1791 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x338 (section: .text) -> .LBI1792 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x33c (section: .text) -> .LBB1792 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x3e8 (section: .text) -> .LBB1794 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x3f0 (section: .text) -> .LBB1751 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x3f4 (section: .text) -> .LBB1795 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x428 (section: .text) -> .LBI1796 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x434 (section: .text) -> .LBB1796 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x594 (section: .text) -> .LBI1797 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x5cc (section: .text) -> .LBB1797 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x624 (section: .text) -> .LBB1786 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x630 (section: .text) -> .LBB1751 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x684 (section: .text) -> .LBB1786 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x688 (section: .text) -> .LBI1798 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x690 (section: .text) -> .LBB1751 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x694 (section: .text) -> .LBB1798 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x6f4 (section: .text) -> .LBB1786 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x700 (section: .text) -> .LBB1751 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x7a4 (section: .text) -> .LBB1786 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x7a8 (section: .text) -> .LBI1799 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x7b0 (section: .text) -> .LBB1751 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_scan_worker+0x7b4 (section: .text) -> .LBB1799 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0xe4 (section: .text) -> .LBB1801 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x100 (section: .text) -> .LVL166 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x144 (section: .text) -> .LBI1802 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x148 (section: .text) -> .LBB1802 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x1a8 (section: .text) -> .LBI1803 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x1b4 (section: .text) -> .LBB1803 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x224 (section: .text) -> .LBI1748 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x234 (section: .text) -> .LBI1805 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x274 (section: .text) -> .LBB1805 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x290 (section: .text) -> .LBB1751 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x2d4 (section: .text) -> .LBI1806 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x2e4 (section: .text) -> .LBB1786 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x2e8 (section: .text) -> .LBB1806 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_process_beacon+0x2f0 (section: .text) -> .LBB1751 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0x60 (section: .text) -> .LBI1807 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0xf8 (section: .text) -> .LBB1807 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0x1c4 (section: .text) -> .LBI1808 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0x1cc (section: .text) -> .LBB1808 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0x264 (section: .text) -> .LBI1748 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0x274 (section: .text) -> .LBB1810 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0x298 (section: .text) -> .LBB1811 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0x29c (section: .text) -> .LBI1812 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0x2a4 (section: .text) -> .LBB1812 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0x2f0 (section: .text) -> .LBB1751 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0x2f4 (section: .text) -> .LBI1813 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac802154_beacon_worker+0x334 (section: .text) -> .LBB1813 (section: .init.text)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

