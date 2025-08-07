Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D932DC87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 05:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414468E0002; Thu,  7 Aug 2025 01:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3F18E0001; Thu,  7 Aug 2025 01:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BEE8E0002; Thu,  7 Aug 2025 01:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 129F28E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:12:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83DDB140346
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:12:13 +0000 (UTC)
X-FDA: 83748790146.15.FF3EC1B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf11.hostedemail.com (Postfix) with ESMTP id C505640008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:12:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YRVX6rjR;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754543531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TDlu35C2RoQwfbjbJ9TAxXA6zBosiOdOG7TeDyRMS2Q=;
	b=L2vmzTwXISmhsX8FV8UNgFDO4EUL26J5jdhzkGOTbdWh+NMDPXVgg/DhXIFzecwImEMznx
	Vh8g7/yreULLxcYInGjIL0bDOcl8OBIHA9iVhys+lJ3U1ejb9mZ0OY3y2sFwt8+utzU2NN
	/e5OfWJtVlHZWJCmj3Xt/fPCHNJBGxA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754543531; a=rsa-sha256;
	cv=none;
	b=dyj0vw+T+I15LgVVUF0DPZK8MhS1BEU8hI02RsH2FYEz2L9jcu0KXYMJv7VfR7FFlVLncN
	U3cr+TfsTsCo9YsnmMKRkruFhR0uaePdZdPn9TWV9UGQJ23W/T6+jesdnttUad5IUKC7Sn
	jx1DgPmpLRGgKoKW+rnpiNemkxcHdkM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YRVX6rjR;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754543531; x=1786079531;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=0XmkXOQcLDYzg335/QlH9RwBSH4T3/v/mE3GmXmY994=;
  b=YRVX6rjR5B6pGWb42Ww6vHlckp9Q6x+O1bFAWcldMPNGt+pNr/b5I6QV
   cV1ctPmSOyodFsof5R0i9ZDt5cZWflkj8neLswgO7umGB9oN5p723aO3e
   KgbYlk3C7Udc2iy4vFb4ekXcgERAryxI3HhUJZJVYwcr9+VuoYBMKVHaE
   L3te0S7GeUW5mWiJBJR1+d8kAZWiPAN6Xk9g1Qm0xmRpn8MxwYnjlMd1t
   VHzypU46xdZ8sFi9OPREUeclGLatrIma3MQUBoGJvEkID0Cyyd1VqoRqy
   BWvBrRAzeXmU+Z8rWTpjj7SCMsigkWf7l5rcT1rNJ6OO9ikxG8vqYN/ly
   g==;
X-CSE-ConnectionGUID: RPSQcD7hS4Kj0yaCZ0iweg==
X-CSE-MsgGUID: bnB0j8JqQ/iqU0anCL47uQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56579335"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56579335"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 22:12:10 -0700
X-CSE-ConnectionGUID: CmM6LpXQQ1a7QQ7ERGFljQ==
X-CSE-MsgGUID: GP2Dj2g4R46OLW4TA+1K6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="164211505"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 06 Aug 2025 22:12:08 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujsv7-0002Oi-29;
	Thu, 07 Aug 2025 05:12:05 +0000
Date: Thu, 7 Aug 2025 13:08:58 +0800
From: kernel test robot <lkp@intel.com>
To: Klara Modin <klarasmodin@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [sj:mm-new 18/45] ERROR: modpost: __ex_table+0x1584 references
 non-executable section '.rodata.of_phy_register_fixed_link.str1.4'
Message-ID: <202508071326.pL3d1VJM-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: C505640008
X-Stat-Signature: rrsumj9sddubhe6qgkto5btf9g4cuc55
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754543530-782356
X-HE-Meta: U2FsdGVkX1/WRfnPdphXEYZQc88yLBsrFD4rU39xGglbF0XpIWik0Fvqv5ZGKc2fxOwMhkd245fb1BzXWyGic7W4EFsFDuIVaib4gnyAukBV3YoXlsQ1eQmw3KFE2J6SpKt/jAITa/j/isKZXL/1Fad7wZnHamwQ+ftWfwU0ltPfwyZAkR5Dd1DV9KEUFWhmIdXmIPWT7jm/OphBULVmcZqD9MOfpp/qwFS/CieehSdTYqa/5IcFbM4ITlZTY0Q54R9dqwVBzfMwopa6GTHCTef9yhkCV0eIaZWqzL008Gu9/QLMYHRGu1TTRrHIUMbLHFDq6WuF7DhX5oxTanSqHNwYSdJk5Oq120ZS5An0OPn9Y8/IR6uLK33RRLcCKy81OPxqwyXUOWgx5f104+9neeEUJPz7rPSs1p79P4IdZdIS/Iq/gf908wXZb9OuJRxAONyafQGWDY8Qbr2PMmYN5/MvbSz6dQOuoRAA5tSZB38JBqRKak7N15uiGJ4ZbY+K3IY6jk+E5DAp8tAkppLcSz2qmz3IuL/13Chc9WwYK51wJkzIMlnstyOwgVlEByYN8U2c6sBEjofKCEWW/rShmffQYNt3UUEvvF/K2UaAb5aMBXBGa8vMk+/9mh6UMFeAAJVjxSCvWSxBEJtA5pkOiO6bo0Z/Nc68j935En69+yqjijxME3VrS/6uGNABzmPyPgfN9KWUrKsr6jNK+d5kTJCyV/Beq/1MsRpKgKT43Ufc6Z+JHrl4ciZxVkgYKQVmF1Tx/TYeOEfZkCGeWQuenanYYDRtzmUHsDCjZgreOSBAg+2wAYGcLwUNE5kioHrvQwf1Mr+lmaiDel5FW7SBH0EXYFU9Ob5elGXnl5XVheiB5qSB3ZRuiA6e+myKeEo3qVgpt96SepvJToE2SxH/G6QiB+TKynTz7+uKEVz1Krx6I9ajQywkBBxVi9zsr3AA3nF+1uvo/CvZWoZhqwP
 DV8W5ETx
 2NC9CwCn0v2MIuT73L9klz2IgRlhutLR6kV3YOoKgVhOwGj9wE3grF0W6wcvTI54vZWS2Er//5UK/GsWSLhb84zSf/gevNEn1ayysFAvWLMfCejui3EwnXBVKTMzpTfL8QkEpCQIksrdJu549CkSM1grEA/aSHAQQVSpJiLX3cd5mqsILTCAv9wEcPHU0TFcObRS9pJlANLWXArMpWOoK9himowz576+uv0NZOzs46vzwUTF1Nxo1oYFzZIFhvPx43ZxUeOAv7xbjBgNRveChb7uM7wnaIGqJsmyxBd99D66GMsNOVf95wJR8MaNCWLMfEOdNyA9jlI3nUaUr752GIM6cto9csZIRRc+s8kFW/VZl1JBYU5bW/NmxnAyB4vHoSxjLbSmVwk4KToJyaqL7Jzw2BZB5GNsTe6055uplLI2xcHIOVHf8yG9OM0gDoKk7CnfusjtgnmklaRc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git mm-new
head:   b2a4beca30ba51331a16d7bb84387a70b692a66d
commit: 8e7e0c6d09502e44aa7a8fce0821e042a6ec03d1 [18/45] mm-filemap-align-last_index-to-folio-size-fix
config: riscv-randconfig-002-20250807 (https://download.01.org/0day-ci/archive/20250807/202508071326.pL3d1VJM-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250807/202508071326.pL3d1VJM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508071326.pL3d1VJM-lkp@intel.com/

Note: the sj/mm-new HEAD b2a4beca30ba51331a16d7bb84387a70b692a66d builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: vmlinux: section mismatch in reference: mt_set_height+0x18 (section: .text.mt_set_height) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __mas_set_range+0x22 (section: .text.__mas_set_range) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __mas_set_range+0x50 (section: .text.__mas_set_range) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_set_parent.isra.56+0x1c (section: .text.mas_set_parent.isra.56) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x6e (section: .text.mt_validate) -> fpc202_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x82 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x96 (section: .text.mt_validate) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x228 (section: .text.mt_validate) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x22c (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x240 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x248 (section: .text.mt_validate) -> fpc202_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x3a2 (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x3aa (section: .text.mt_validate) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x3d0 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x422 (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x55e (section: .text.mt_validate) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x6f2 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x778 (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0xc18 (section: .text.mt_validate) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0xc26 (section: .text.mt_validate) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0xc40 (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0xc8c (section: .text.mt_validate) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0xdea (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0xf08 (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_update_gap.part.55+0x34 (section: .text.mas_update_gap.part.55) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_update_gap.part.55+0x104 (section: .text.mas_update_gap.part.55) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_prev_slot+0x2e (section: .text.mas_prev_slot) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_next_slot+0x2c (section: .text.mas_next_slot) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_next+0xe0 (section: .text.mt_next) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_find+0xf0 (section: .text.mt_find) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_find+0x16e (section: .text.mt_find) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_find+0x1e4 (section: .text.mt_find) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mast_fill_bnode+0x1ca (section: .text.mast_fill_bnode) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mast_fill_bnode+0x216 (section: .text.mast_fill_bnode) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_node_store+0x182 (section: .text.mas_wr_node_store) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_node_store+0x368 (section: .text.mas_wr_node_store) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_adopt_children+0x44 (section: .text.mas_adopt_children) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_destroy_rebalance+0x410 (section: .text.mas_destroy_rebalance) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_destroy_rebalance+0x79e (section: .text.mas_destroy_rebalance) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_topiary_replace+0xbe (section: .text.mas_topiary_replace) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_topiary_replace+0x49e (section: .text.mas_topiary_replace) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x7f6 (section: .text.mas_spanning_rebalance) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x846 (section: .text.mas_spanning_rebalance) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x896 (section: .text.mas_spanning_rebalance) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0xae4 (section: .text.mas_spanning_rebalance) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0xb16 (section: .text.mas_spanning_rebalance) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0xb50 (section: .text.mas_spanning_rebalance) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_spanning_store.isra.63+0x30c (section: .text.mas_wr_spanning_store.isra.63) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_bnode+0x60a (section: .text.mas_wr_bnode) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_bnode+0xa14 (section: .text.mas_wr_bnode) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_bnode+0xef8 (section: .text.mas_wr_bnode) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_bnode+0xf42 (section: .text.mas_wr_bnode) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_bnode+0x1258 (section: .text.mas_wr_bnode) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_bnode+0x16c2 (section: .text.mas_wr_bnode) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_bnode+0x16fe (section: .text.mas_wr_bnode) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_store_entry+0x310 (section: .text.mas_wr_store_entry) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_store+0x5c (section: .text.mas_store) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mas_store_prealloc+0xaa (section: .text.mas_store_prealloc) -> fpc202_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mt_prev+0xe0 (section: .text.mt_prev) -> bh1770_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ___ratelimit+0x72 (section: .text.___ratelimit) -> wcd934x_slim_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ___ratelimit+0x1aa (section: .text.___ratelimit) -> wcd934x_slim_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ___ratelimit+0x1b8 (section: .text.___ratelimit) -> wcd934x_slim_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: seq_buf_putmem_hex+0x30 (section: .text.seq_buf_putmem_hex) -> wcd934x_slim_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ip6_string+0xa (section: .text.ip6_string) -> wcd934x_slim_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ip6_compressed_string+0xe8 (section: .text.ip6_compressed_string) -> wcd934x_slim_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mac_address_string+0x52 (section: .text.mac_address_string) -> wcd934x_slim_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: uuid_string+0x5c (section: .text.uuid_string) -> wcd934x_slim_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: bstr_printf+0x62 (section: .text.bstr_printf) -> tps6594_esm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: bstr_printf+0x66 (section: .text.bstr_printf) -> tps6594_pfsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: bstr_printf+0x6e (section: .text.bstr_printf) -> tps6594_pfsm_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: xa_destroy+0x78 (section: .text.xa_destroy) -> wcd934x_slim_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x4 (section: .init.text.efi_pe_entry) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x12 (section: .init.text.efi_pe_entry) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.efi_pe_entry) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.efi_pe_entry) -> pm800_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x4 (section: .init.text.efi_pe_entry) -> pm800_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x4 (section: .init.text.efi_pe_entry) -> pm800_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.exit_boot_func) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.exit_boot_func) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.exit_boot_func) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.exit_boot_func) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.exit_boot_func) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x4 (section: .init.text.exit_boot_func) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.exit_boot_func) -> pm886_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x4 (section: .init.text.get_fdt) -> pm886_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.efi_boot_kernel) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x4 (section: .init.text.efi_boot_kernel) -> pm886_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.efi_boot_kernel) -> pm886_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x4 (section: .init.text.efi_boot_kernel) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x4 (section: .init.text.efi_boot_kernel) -> pm886_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x4 (section: .init.text.efi_boot_kernel) -> pm886_i2c_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.efi_boot_kernel) -> pm805_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.efi_parse_option_graphics) -> act8945a_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.efi_parse_option_graphics) -> act8945a_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x8 (section: .init.text.efi_parse_option_graphics) -> act8945a_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0xa (section: .init.text.efi_parse_option_graphics) -> act8945a_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0xa (section: .init.text.efi_parse_option_graphics) -> act8945a_i2c_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.LVL10+0x0 (section: .init.text.strnlen) -> gsc_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: allowlist+0x2708 (section: .init.rodata) -> cast5_mod_fini (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: 0x1584 (section: __ex_table) -> 0x0 (section: .rodata.of_phy_register_fixed_link.str1.4)
>> ERROR: modpost: __ex_table+0x1584 references non-executable section '.rodata.of_phy_register_fixed_link.str1.4'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1588 (section: __ex_table) -> unimac_mdio_ids (section: .rodata.unimac_mdio_ids)
>> ERROR: modpost: __ex_table+0x1588 references non-executable section '.rodata.unimac_mdio_ids'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1590 (section: __ex_table) -> 0x0 (section: .rodata.unimac_mdio_probe.str1.4)
>> ERROR: modpost: __ex_table+0x1590 references non-executable section '.rodata.unimac_mdio_probe.str1.4'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1594 (section: __ex_table) -> hisi_femac_mdio_dt_ids (section: .rodata.hisi_femac_mdio_dt_ids)
>> ERROR: modpost: __ex_table+0x1594 references non-executable section '.rodata.hisi_femac_mdio_dt_ids'
WARNING: modpost: vmlinux: section mismatch in reference: 0x159c (section: __ex_table) -> 0x0 (section: .rodata.hisi_femac_mdio_wait_ready.isra.2.str1.4)
>> ERROR: modpost: __ex_table+0x159c references non-executable section '.rodata.hisi_femac_mdio_wait_ready.isra.2.str1.4'
WARNING: modpost: vmlinux: section mismatch in reference: 0x15a0 (section: __ex_table) -> hisi_femac_mdio_dt_ids (section: .rodata.hisi_femac_mdio_dt_ids)
ERROR: modpost: __ex_table+0x15a0 references non-executable section '.rodata.hisi_femac_mdio_dt_ids'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1668 (section: __ex_table) -> .LASF147 (section: .debug_str)
ERROR: modpost: __ex_table+0x1668 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x166c (section: __ex_table) -> .LASF149 (section: .debug_str)
ERROR: modpost: __ex_table+0x166c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1674 (section: __ex_table) -> .LASF151 (section: .debug_str)
ERROR: modpost: __ex_table+0x1674 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1678 (section: __ex_table) -> .LASF153 (section: .debug_str)
ERROR: modpost: __ex_table+0x1678 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1680 (section: __ex_table) -> .LASF155 (section: .debug_str)
ERROR: modpost: __ex_table+0x1680 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1684 (section: __ex_table) -> .LASF157 (section: .debug_str)
ERROR: modpost: __ex_table+0x1684 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x168c (section: __ex_table) -> .LASF159 (section: .debug_str)
ERROR: modpost: __ex_table+0x168c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1690 (section: __ex_table) -> .LASF153 (section: .debug_str)
ERROR: modpost: __ex_table+0x1690 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1698 (section: __ex_table) -> .LASF162 (section: .debug_str)
ERROR: modpost: __ex_table+0x1698 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x169c (section: __ex_table) -> .LASF153 (section: .debug_str)
ERROR: modpost: __ex_table+0x169c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16a4 (section: __ex_table) -> .LASF165 (section: .debug_str)
ERROR: modpost: __ex_table+0x16a4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16a8 (section: __ex_table) -> .LASF167 (section: .debug_str)
ERROR: modpost: __ex_table+0x16a8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16b0 (section: __ex_table) -> .LASF199 (section: .debug_str)
ERROR: modpost: __ex_table+0x16b0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16b4 (section: __ex_table) -> .LASF201 (section: .debug_str)
ERROR: modpost: __ex_table+0x16b4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16bc (section: __ex_table) -> .LASF203 (section: .debug_str)
ERROR: modpost: __ex_table+0x16bc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16c0 (section: __ex_table) -> .LASF205 (section: .debug_str)
ERROR: modpost: __ex_table+0x16c0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16c8 (section: __ex_table) -> .LASF2823 (section: .debug_str)
ERROR: modpost: __ex_table+0x16c8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x16cc (section: __ex_table) -> .LASF2825 (section: .debug_str)
ERROR: modpost: __ex_table+0x16cc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17a0 (section: __ex_table) -> .LASF3248 (section: .debug_str)
ERROR: modpost: __ex_table+0x17a0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17a4 (section: __ex_table) -> .LASF3250 (section: .debug_str)
ERROR: modpost: __ex_table+0x17a4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17ac (section: __ex_table) -> .LASF3252 (section: .debug_str)
ERROR: modpost: __ex_table+0x17ac references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17b0 (section: __ex_table) -> .LASF3250 (section: .debug_str)
ERROR: modpost: __ex_table+0x17b0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17b8 (section: __ex_table) -> .LASF3255 (section: .debug_str)
ERROR: modpost: __ex_table+0x17b8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17bc (section: __ex_table) -> .LASF3250 (section: .debug_str)
ERROR: modpost: __ex_table+0x17bc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17c4 (section: __ex_table) -> .LASF3258 (section: .debug_str)
ERROR: modpost: __ex_table+0x17c4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17c8 (section: __ex_table) -> .LASF3260 (section: .debug_str)
ERROR: modpost: __ex_table+0x17c8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17d0 (section: __ex_table) -> .LASF3262 (section: .debug_str)
ERROR: modpost: __ex_table+0x17d0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17d4 (section: __ex_table) -> .LASF3250 (section: .debug_str)
ERROR: modpost: __ex_table+0x17d4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17f4 (section: __ex_table) -> .LASF1295 (section: .debug_str)
ERROR: modpost: __ex_table+0x17f4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x17f8 (section: __ex_table) -> .LASF1297 (section: .debug_str)
ERROR: modpost: __ex_table+0x17f8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1800 (section: __ex_table) -> .LASF1299 (section: .debug_str)
ERROR: modpost: __ex_table+0x1800 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1804 (section: __ex_table) -> .LASF1301 (section: .debug_str)
ERROR: modpost: __ex_table+0x1804 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x183c (section: __ex_table) -> .L0  (section: .debug_frame)
ERROR: modpost: __ex_table+0x183c references non-executable section '.debug_frame'
WARNING: modpost: vmlinux: section mismatch in reference: 0x19c8 (section: __ex_table) -> .LASF324 (section: .debug_str)
ERROR: modpost: __ex_table+0x19c8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x19cc (section: __ex_table) -> .LASF326 (section: .debug_str)
ERROR: modpost: __ex_table+0x19cc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x19d4 (section: __ex_table) -> .LASF328 (section: .debug_str)
ERROR: modpost: __ex_table+0x19d4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x19d8 (section: __ex_table) -> .LASF326 (section: .debug_str)
ERROR: modpost: __ex_table+0x19d8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x19e0 (section: __ex_table) -> .LASF331 (section: .debug_str)
ERROR: modpost: __ex_table+0x19e0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x19e4 (section: __ex_table) -> .LASF333 (section: .debug_str)
ERROR: modpost: __ex_table+0x19e4 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x19ec (section: __ex_table) -> .LASF335 (section: .debug_str)
ERROR: modpost: __ex_table+0x19ec references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x19f0 (section: __ex_table) -> .LASF326 (section: .debug_str)
ERROR: modpost: __ex_table+0x19f0 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x19f8 (section: __ex_table) -> .LASF2613 (section: .debug_str)
ERROR: modpost: __ex_table+0x19f8 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x19fc (section: __ex_table) -> .LASF2615 (section: .debug_str)
ERROR: modpost: __ex_table+0x19fc references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1a04 (section: __ex_table) -> .LASF2617 (section: .debug_str)
ERROR: modpost: __ex_table+0x1a04 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1a08 (section: __ex_table) -> .LASF2619 (section: .debug_str)
ERROR: modpost: __ex_table+0x1a08 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1a10 (section: __ex_table) -> .LASF3060 (section: .debug_str)
ERROR: modpost: __ex_table+0x1a10 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1a14 (section: __ex_table) -> .LASF3062 (section: .debug_str)
ERROR: modpost: __ex_table+0x1a14 references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1a1c (section: __ex_table) -> .LASF3064 (section: .debug_str)
ERROR: modpost: __ex_table+0x1a1c references non-executable section '.debug_str'
WARNING: modpost: vmlinux: section mismatch in reference: 0x1a20 (section: __ex_table) -> .LASF3066 (section: .debug_str)
ERROR: modpost: __ex_table+0x1a20 references non-executable section '.debug_str'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

