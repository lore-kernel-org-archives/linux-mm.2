Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0D8C87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 04:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68FE6B00BF; Thu,  7 Aug 2025 00:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18656B00C0; Thu,  7 Aug 2025 00:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E07C6B00C1; Thu,  7 Aug 2025 00:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 81A086B00BF
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 00:03:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E318BC0791
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 04:03:56 +0000 (UTC)
X-FDA: 83748618072.26.BCA445F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11A2CA000D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 04:03:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X+Zd4IcD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754539435; a=rsa-sha256;
	cv=none;
	b=SZwOHAfrD0MEChui/vG7qXHl4Wu/8ANH1RGYpTXEjKDQgKb25B4mKKvL3eM43egk1OOd+s
	1NwifyFFc/rFKfjR21XRVLCvLed9asyf6b1q4eq9qvKQcWO4aY1MwdGbjzIs1c9Z0lyJwW
	7gYQD/RcxEfrpcXfacIssHp8rdmm6fc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X+Zd4IcD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754539435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mqWakfc4W6AZTaVXx0jb9hwZPLg9HJn1XBuR/BcBi9U=;
	b=Y8aR4n9Jc5AwsU4XAPyMCzFnhziREd1Ci70vQF+XJxtCDKY5uH1QIa0Wxu6ZtzdlpfNJLD
	nxjmqMSEk0Ui8jSriKGhQynhCgXYUWBPDbLXrAqE1ziWJIXALPwjfD7+VrKdMg1HLsDb+E
	S88p/d71M67CCWfTVanzYayLjD3MJcw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754539434; x=1786075434;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=+kfs2B0V8kGGIabF8VUSuYRS9Iu07MUf+/+GIV7koRA=;
  b=X+Zd4IcD8jRKn/OrbS3XcsCI5AdI7c9QZU9B3aJKrWtcPDwYPWAgqond
   aDry5jgUrAZKL9SDqXiVJlqRhdq+9GN1ZGPc6/nVGerfR2+oUAs2GphHL
   QrNHqUNYZHyAzUIqIuF/hVzdr2LmEmqXNOIwpN04w18QtqbJhImYPhSTY
   eeEoeEorvFDiRQ2NetIEYpEx2SruPnpwg9W7htYSkI5jSokoM0rwSOEnc
   OWZcP4qHXdRxsNxMowZ77ZF5Q2EmOnGGDVwLB3i5F75CxOdMOlCY6RXfy
   Z/Lq/kDGO6mIoioftelsfx5ol4KlxXxg626bBZthk3vy1XDymyguDg1/T
   w==;
X-CSE-ConnectionGUID: oT/3Y0yQQ+iVWdWG+/UlTg==
X-CSE-MsgGUID: Huokc5oJTHSd3WyKamH/dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="55901998"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="55901998"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 21:03:51 -0700
X-CSE-ConnectionGUID: vbwi7i1TS0qxAaomV3YqeA==
X-CSE-MsgGUID: YqBgIi/BQEKoE6PPygPDNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="164849413"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 06 Aug 2025 21:03:49 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujrr1-0002Lw-0N;
	Thu, 07 Aug 2025 04:03:47 +0000
Date: Thu, 7 Aug 2025 12:03:03 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [sj:mm-new 42/45] ERROR: modpost: __ex_table+0x1584 references
 non-executable section '.rodata.spk_ttyio_synth_probe.str1.4'
Message-ID: <202508071131.KsUs9Est-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: m3td6pkbptuf337d5nygkpnumnhe1n4j
X-Rspam-User: 
X-Rspamd-Queue-Id: 11A2CA000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1754539433-8350
X-HE-Meta: U2FsdGVkX1+UpkPj5183QeqfD9W5Dsghg7Ygkoo/cXixVhUfX4l6DQjZ8Hf8Hpy6mPJZmhLJjWjlKivCmSTIobFfGM6qL63tlpIej6C/m3Ip+7W8ywRTJVDLv1GWV+0gCAUz8nbEDNGg9lBz4IV52CFP5ZUWjf+TJeqqjhFX4Vh0vb7rPvkpkdeGhaIfbzV5Pa5v+rOHbgg2TfydpjDvTrGhbu86rmQGuCxB6oLvmgoUM85x0hs/tjK91zrO3iu0WQ4u3wn3RlAL6IjH66wv/TRFVd7qz7B3NvoUvk0BtBg2oBJ3Py9Yim0C6DYSmfI3bHEfbzpgAQQQ6vCd+vihf3iY/hBXkC9GBUk4cM5NJC7nfiLWUJ4etvtTYFt2piaUfMRHi9DJTX7R8M6NGIUwQ8j7ZN1O75XrpnSp7JgdPwF5mx1oPDgGI78nDN6hwoANQQmL2rViH9hWb8HI73wqNaG4Yn6MGyGhyWevO08/NsglV156PZGxtnxD00LDtpJfkQmwFlFloRYwjy+qOQVUM77tyyPOcxbk3PY/vrFnUPZ0AgGbt1aL9lkcNURIIx79AZWUbN7VDq7tO4Y3HysJxcuhIbNTE1POtGPVFat3QM52MalsRI/ikrl+5smRZHirWjGdsiSU5sPSy0xNRQ7xxvV4rmlRUW1C7/n4lA1zzOe9jjMU/bwFsgan5NpG5oDQbSMSYrsvEMD/SMS6Epbchv9ofxEfHbBkPZmSaziHynaTzGfb0yOP/es4RMG/7z0rLgKAKP/o+YYWLmIgw0JpyB4ozXoryWOW3L5lxWG/Oasvd/WuIEKV1/WiZErlS+mKdtPGzBhgIFAj31I2gVATWa/5ZdTh5/lim47VPa4Kh8ioRGfEcxPZYdNpPMFNMqBV5mNOjKiO74JcsjXjgArIa69dUJdQIOOIbUyeBAOpHz7NncdhK0FvE08qwL06fdCgIqJnQNJEyCTSVT37kIB
 hgYrYVnd
 30Nkpn4DesJBQa3/ZeuD0ARhmP6gCIip4CBUu/IlZMbxCnVmsNKzoqINDWmG8IvF15cMCAMj1NNB+RjCv8tLegFO9Vflo372ZFHo1cH6lUOoFj25ukVPEHhhXYAtc/8Z2skTU6xp5Z/NGZgjlEZt5DX4/OsCMQxIX0BGLnr2LjHliMuufiQXHvgwoQhwABBtNo3snItYZQeLea/DX7zSs3OMqmsOuUW/Si55/3IUh5jc0fmwrw6sb+mMJ6cd39cIE1c4QMcazImRM6bsp9ckY0oYjmkoqHx/Lsa10TbyDPwcXJ2MPZyYnJsngysniZYVKfAfEJibX65jaQAVyu3XrqXCWFSe9zC8M3lJ4qL14jC1+bW83QL3EEniKw9VBrfqfoj5drwkYH8L+G8lsI80A4BDJTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git mm-new
head:   b2a4beca30ba51331a16d7bb84387a70b692a66d
commit: 607a455e2f3d528b71be200e1e18e578273a602e [42/45] mm: change vma_start_read() to drop RCU lock on failure
config: riscv-randconfig-002-20250807 (https://download.01.org/0day-ci/archive/20250807/202508071131.KsUs9Est-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250807/202508071131.KsUs9Est-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508071131.KsUs9Est-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: vmlinux: section mismatch in reference: node_get+0x3a (section: .text.node_get) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: qrtr_ns_worker+0x30 (section: .text.qrtr_ns_worker) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: qrtr_ns_worker+0x110 (section: .text.qrtr_ns_worker) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: qrtr_ns_worker+0x312 (section: .text.qrtr_ns_worker) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: qrtr_tun_open+0xe (section: .text.qrtr_tun_open) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xdp_put_umem+0x54 (section: .text.xdp_put_umem) -> soc_bus_register (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: xdp_put_umem+0x68 (section: .text.xdp_put_umem) -> register_cpufreq_notifier (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: xdp_umem_create+0x1c (section: .text.xdp_umem_create) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xdp_umem_create+0x244 (section: .text.xdp_umem_create) -> register_cpufreq_notifier (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: xdp_umem_create+0x25a (section: .text.xdp_umem_create) -> soc_bus_register (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: xskq_create+0xe (section: .text.xskq_create) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xp_dma_map+0x5c (section: .text.xp_dma_map) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ida_alloc_range+0x98 (section: .text.ida_alloc_range) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ida_alloc_range+0x316 (section: .text.ida_alloc_range) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: kset_create_and_add+0x10 (section: .text.kset_create_and_add) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: kobject_create_and_add+0xe (section: .text.kobject_create_and_add) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: uevent_net_init+0xe (section: .text.uevent_net_init) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: kobject_uevent_env+0x72 (section: .text.kobject_uevent_env) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: kobject_uevent_env+0x324 (section: .text.kobject_uevent_env) -> .LVL169 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: kobject_uevent_env+0x32c (section: .text.kobject_uevent_env) -> .LVL171 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: kobject_uevent_env+0x360 (section: .text.kobject_uevent_env) -> .LVL170 (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: kobject_synth_uevent+0x106 (section: .text.kobject_synth_uevent) -> wm8994_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x1a (section: .text.mas_get_slot) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x22 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x3a (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x50 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x60 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x6a (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x74 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x80 (section: .text.mas_get_slot) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x9a (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0xb8 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0xc0 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0xd4 (section: .text.mas_get_slot) -> apds990x_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_empty_area_rev+0xf2 (section: .text.mas_empty_area_rev) -> apds990x_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x156 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x1a2 (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x230 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x238 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x240 (section: .text.mt_validate) -> apds990x_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x30c (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x314 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x65e (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x6bc (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x6d0 (section: .text.mt_validate) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x4ae (section: .text.mas_spanning_rebalance) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x4c6 (section: .text.mas_spanning_rebalance) -> apds990x_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x586 (section: .text.mas_spanning_rebalance) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x590 (section: .text.mas_spanning_rebalance) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x852 (section: .text.mas_spanning_rebalance) -> apds990x_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x87c (section: .text.mas_spanning_rebalance) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x916 (section: .text.mas_spanning_rebalance) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x968 (section: .text.mas_spanning_rebalance) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0xa3e (section: .text.mas_spanning_rebalance) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0xa46 (section: .text.mas_spanning_rebalance) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0xaa2 (section: .text.mas_spanning_rebalance) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0xaa6 (section: .text.mas_spanning_rebalance) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_spanning_store.isra.63+0x15c (section: .text.mas_wr_spanning_store.isra.63) -> apds990x_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_spanning_store.isra.63+0x2a2 (section: .text.mas_wr_spanning_store.isra.63) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_bnode+0x46 (section: .text.mas_wr_bnode) -> apds990x_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_bnode+0x60e (section: .text.mas_wr_bnode) -> apds990x_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: seq_buf_path+0x44 (section: .text.seq_buf_path) -> wcd934x_slim_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: number+0x76 (section: .text.number) -> tps6594_pfsm_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: number+0x98 (section: .text.number) -> tps6594_pfsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: number+0x9c (section: .text.number) -> tps6594_pfsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: number+0xa2 (section: .text.number) -> virtio_nsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: number+0xbc (section: .text.number) -> tps6594_pfsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0xd0 (section: .text.resource_string.isra.12) -> tps6594_pfsm_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0xda (section: .text.resource_string.isra.12) -> virtio_nsm_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0x158 (section: .text.resource_string.isra.12) -> virtio_nsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0x1ce (section: .text.resource_string.isra.12) -> tps6594_pfsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0x252 (section: .text.resource_string.isra.12) -> tps6594_pfsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0x2bc (section: .text.resource_string.isra.12) -> tps6594_pfsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0x2ec (section: .text.resource_string.isra.12) -> virtio_nsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: clock.isra.14+0x28 (section: .text.clock.isra.14) -> virtio_nsm_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: dentry_name+0x46 (section: .text.dentry_name) -> tps6594_pfsm_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: dentry_name+0x70 (section: .text.dentry_name) -> virtio_nsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: dentry_name+0x1d4 (section: .text.dentry_name) -> virtio_nsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: dentry_name+0x21e (section: .text.dentry_name) -> virtio_nsm_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: pointer+0x8a (section: .text.pointer) -> virtio_nsm_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xas_store+0xa4 (section: .text.xas_store) -> pm860x_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xas_store+0x5be (section: .text.xas_store) -> pm860x_i2c_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __xa_alloc_cyclic+0x9e (section: .text.__xa_alloc_cyclic) -> pm860x_i2c_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x16 (section: .text.__xa_insert) -> pm860x_i2c_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x3e (section: .text.__xa_insert) -> pm860x_i2c_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x46 (section: .text.__xa_insert) -> pm860x_i2c_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x54 (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x62 (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x7a (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x84 (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x90 (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x9a (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: xa_extract+0x564 (section: .text.xa_extract) -> pm860x_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xa_load+0x38 (section: .text.xa_load) -> pm860x_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xa_load+0x3c (section: .text.xa_load) -> pm860x_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xa_load+0x4e (section: .text.xa_load) -> pm800_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xa_load+0xaa (section: .text.xa_load) -> pm800_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.efi_parse_options) -> stmpe_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x4 (section: .init.text.efi_parse_options) -> stmpe_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: 0x1584 (section: __ex_table) -> 0x0 (section: .rodata.spk_ttyio_synth_probe.str1.4)
>> ERROR: modpost: __ex_table+0x1584 references non-executable section '.rodata.spk_ttyio_synth_probe.str1.4'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1588 (section: __ex_table) -> 0x0 (section: .rodata.spk_synth_is_alive_restart.str1.4)
>> ERROR: modpost: __ex_table+0x1588 references non-executable section '.rodata.spk_synth_is_alive_restart.str1.4'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1590 (section: __ex_table) -> 0x0 (section: .rodata.spk_set_num_var)
>> ERROR: modpost: __ex_table+0x1590 references non-executable section '.rodata.spk_set_num_var'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1594 (section: __ex_table) -> 0x0 (section: .rodata.spk_get_var.str1.4)
>> ERROR: modpost: __ex_table+0x1594 references non-executable section '.rodata.spk_get_var.str1.4'
WARNING: modpost: vmlinux: section mismatch in reference: 0x159c (section: __ex_table) -> __func__ (section: .rodata.__func__.53540)
ERROR: modpost: __ex_table+0x159c references non-executable section '.rodata.__func__.53540'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15a0 (section: __ex_table) -> 0x0 (section: .rodata.spk_get_var.str1.4)
ERROR: modpost: __ex_table+0x15a0 references non-executable section '.rodata.spk_get_var.str1.4'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15a8 (section: __ex_table) -> .LASF4598 (section: .debug_str)
ERROR: modpost: __ex_table+0x15a8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15ac (section: __ex_table) -> .LASF4600 (section: .debug_str)
ERROR: modpost: __ex_table+0x15ac references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15b4 (section: __ex_table) -> .LASF4602 (section: .debug_str)
ERROR: modpost: __ex_table+0x15b4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15b8 (section: __ex_table) -> .LASF4604 (section: .debug_str)
ERROR: modpost: __ex_table+0x15b8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15c0 (section: __ex_table) -> .LASF4606 (section: .debug_str)
ERROR: modpost: __ex_table+0x15c0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15c4 (section: __ex_table) -> .LASF4608 (section: .debug_str)
ERROR: modpost: __ex_table+0x15c4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15cc (section: __ex_table) -> .LASF4610 (section: .debug_str)
ERROR: modpost: __ex_table+0x15cc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15d0 (section: __ex_table) -> .LASF4608 (section: .debug_str)
ERROR: modpost: __ex_table+0x15d0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15d8 (section: __ex_table) -> .LASF4613 (section: .debug_str)
ERROR: modpost: __ex_table+0x15d8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15dc (section: __ex_table) -> .LASF4608 (section: .debug_str)
ERROR: modpost: __ex_table+0x15dc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1668 (section: __ex_table) -> .LASF762 (section: .debug_str)
ERROR: modpost: __ex_table+0x1668 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x166c (section: __ex_table) -> .LASF764 (section: .debug_str)
ERROR: modpost: __ex_table+0x166c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1674 (section: __ex_table) -> .LASF766 (section: .debug_str)
ERROR: modpost: __ex_table+0x1674 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1678 (section: __ex_table) -> .LASF768 (section: .debug_str)
ERROR: modpost: __ex_table+0x1678 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1680 (section: __ex_table) -> .LASF770 (section: .debug_str)
ERROR: modpost: __ex_table+0x1680 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1684 (section: __ex_table) -> .LASF772 (section: .debug_str)
ERROR: modpost: __ex_table+0x1684 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x168c (section: __ex_table) -> .LASF774 (section: .debug_str)
ERROR: modpost: __ex_table+0x168c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1690 (section: __ex_table) -> .LASF768 (section: .debug_str)
ERROR: modpost: __ex_table+0x1690 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1698 (section: __ex_table) -> .LASF777 (section: .debug_str)
ERROR: modpost: __ex_table+0x1698 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x169c (section: __ex_table) -> .LASF768 (section: .debug_str)
ERROR: modpost: __ex_table+0x169c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16a4 (section: __ex_table) -> .LASF780 (section: .debug_str)
ERROR: modpost: __ex_table+0x16a4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16a8 (section: __ex_table) -> .LASF782 (section: .debug_str)
ERROR: modpost: __ex_table+0x16a8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16b0 (section: __ex_table) -> printk_trace (section: .data.rel.local.printk_trace)
ERROR: modpost: __ex_table+0x16b0 references non-executable section '.data.rel.local.printk_trace'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16b4 (section: __ex_table) -> trace_die_notifier (section: .data.rel.local.trace_die_notifier)
ERROR: modpost: __ex_table+0x16b4 references non-executable section '.data.rel.local.trace_die_notifier'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16bc (section: __ex_table) -> trace_panic_notifier (section: .data.rel.local.trace_panic_notifier)
ERROR: modpost: __ex_table+0x16bc references non-executable section '.data.rel.local.trace_panic_notifier'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16c0 (section: __ex_table) -> tracepoint_printk_mutex (section: .data.rel.local.tracepoint_printk_mutex)
ERROR: modpost: __ex_table+0x16c0 references non-executable section '.data.rel.local.tracepoint_printk_mutex'
WARNING: modpost: vmlinux: section mismatch in reference: 0x180c (section: __ex_table) -> .LASF3916 (section: .debug_str)
ERROR: modpost: __ex_table+0x180c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1818 (section: __ex_table) -> .LASF3917 (section: .debug_str)
ERROR: modpost: __ex_table+0x1818 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1824 (section: __ex_table) -> .LLST172 (section: .debug_loc)
ERROR: modpost: __ex_table+0x1824 references non-executable section '.debug_loc'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1848 (section: __ex_table) -> .LASF3922 (section: .debug_str)
ERROR: modpost: __ex_table+0x1848 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1854 (section: __ex_table) -> .LLST161 (section: .debug_loc)
ERROR: modpost: __ex_table+0x1854 references non-executable section '.debug_loc'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1858 (section: __ex_table) -> .LASF3923 (section: .debug_str)
ERROR: modpost: __ex_table+0x1858 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1860 (section: __ex_table) -> .LASF78 (section: .debug_str)
ERROR: modpost: __ex_table+0x1860 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1864 (section: __ex_table) -> .LASF80 (section: .debug_str)
ERROR: modpost: __ex_table+0x1864 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x186c (section: __ex_table) -> .LASF82 (section: .debug_str)
ERROR: modpost: __ex_table+0x186c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1870 (section: __ex_table) -> .LASF84 (section: .debug_str)
ERROR: modpost: __ex_table+0x1870 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1878 (section: __ex_table) -> .LASF86 (section: .debug_str)
ERROR: modpost: __ex_table+0x1878 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x187c (section: __ex_table) -> .LASF88 (section: .debug_str)
ERROR: modpost: __ex_table+0x187c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1884 (section: __ex_table) -> .LASF90 (section: .debug_str)
ERROR: modpost: __ex_table+0x1884 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1888 (section: __ex_table) -> .LASF92 (section: .debug_str)
ERROR: modpost: __ex_table+0x1888 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1890 (section: __ex_table) -> .LASF94 (section: .debug_str)
ERROR: modpost: __ex_table+0x1890 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1894 (section: __ex_table) -> .LASF96 (section: .debug_str)
ERROR: modpost: __ex_table+0x1894 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x189c (section: __ex_table) -> .LASF98 (section: .debug_str)
ERROR: modpost: __ex_table+0x189c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x18a0 (section: __ex_table) -> .LASF100 (section: .debug_str)
ERROR: modpost: __ex_table+0x18a0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x18a8 (section: __ex_table) -> .LASF102 (section: .debug_str)
ERROR: modpost: __ex_table+0x18a8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x18ac (section: __ex_table) -> .LASF104 (section: .debug_str)
ERROR: modpost: __ex_table+0x18ac references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x18b4 (section: __ex_table) -> .LASF106 (section: .debug_str)
ERROR: modpost: __ex_table+0x18b4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x18b8 (section: __ex_table) -> .LASF104 (section: .debug_str)
ERROR: modpost: __ex_table+0x18b8 references non-executable section '.debug_str'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

