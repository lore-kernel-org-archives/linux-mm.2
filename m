Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7201ECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 20:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B79A66B04BE; Mon,  1 Jun 2026 16:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50986B04BF; Mon,  1 Jun 2026 16:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40906B04C0; Mon,  1 Jun 2026 16:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8B26B04BE
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:18:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BFC61207B4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:18:35 +0000 (UTC)
X-FDA: 84832456590.06.0DA49EE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf31.hostedemail.com (Postfix) with ESMTP id DD5E72000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:18:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dMWy6v9H;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780345113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fvdhCaoizL5hWe603qycHmjXKI9IYx2Z/RtGzdEweaY=;
	b=aUg99TkXNJ4NS4OCYQ6TS+2AzQEa1d5swCBX4lgsWHkuAwE7FsU8uuw1OyQg+keuOQrD18
	iTQM5h2eUcDk8kNHaM0HALVPtbSgJmceN2WAevtiMAMiJisGDHRlKSic1GF753oE/SYhgt
	uZgVn/R0DhF/6noNlKTT+xt5G9EXcLI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dMWy6v9H;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780345113;
	b=w8hzMne3A3bYgeQK7uCI0fZbZwY0H4yBBq2vNhggweXBESJwyhWfNZSB9GoNpgOIbrIHk4
	xQcbL6cFZTVAVubJDPHoBu2OlGDj40R7YZlytT5T+o7+xUDhcvq5TxrGHnH0V8MGg5aJ9j
	NHF6OfaLvJcsikMQ+QMK1fjEyi9h8Cg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780345112; x=1811881112;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=XT3mFTv/03DzlACFSY9c/9jd3+SMzGNPzBbhDEIv5Ek=;
  b=dMWy6v9H1210Y/AJJ1HLYWg1OF7nfjPAK50PAOXEXskNBr2Z9cMjLXwS
   x42GVDXY2L9w0pnP0EqgAf+xp7hbYW9xaHNIyKH11/KZ5UsEVMvxelvyk
   meg5OKu+/z0+QniMkBAvsUoThbhIAZ65zsio1DMC81kVGosAvhfLUp1jY
   abRzrtz94OubvFn1JkZdEYXB984HcBQwhvZcdIB2rwqjpyA+cyLwTQ2Eh
   2KCxBMtaTuKCgMjnMh0WIHQPiAKWqem6gy64CWohLSa5o1gZL3qK/wm1k
   P2E2qxy+hzduWA/EdJgrTlOVZTu6fGl87Thb235BCH1bNqC5Oabg1gLIU
   g==;
X-CSE-ConnectionGUID: tZY99iMrRXiiZaT5SJXNNw==
X-CSE-MsgGUID: UgMmXWWtTiuqQCeDQzTVrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="68651173"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="68651173"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 13:18:30 -0700
X-CSE-ConnectionGUID: aCJ1GA0ORj+jX/gcQlM3RQ==
X-CSE-MsgGUID: v9Rdk4oKTDKhf+NoUwZhag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="248603907"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 01 Jun 2026 13:18:27 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wU95c-00000000B3W-1VFW;
	Mon, 01 Jun 2026 20:18:24 +0000
Date: Tue, 02 Jun 2026 04:17:28 +0800
From: kernel test robot <lkp@intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 =?utf-8?Q?"Bj=C3=B6rn?= =?utf-8?Q?_T=C3=B6pel"?= <bjorn@rivosinc.com>,
 Jason Gunthorpe <jgg@nvidia.com>
Subject: fs/dax.c:728:39: sparse: sparse: incorrect type in argument
 1 (different base types)
Message-ID: <202606020427.izbA3vh3-lkp@intel.com>
User-Agent: s-nail v14.9.25
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DD5E72000B
X-Stat-Signature: 3n1dd8zicmmmrs595fdkhtj9zi33u5c8
X-Rspam-User: 
X-HE-Tag: 1780345111-923152
X-HE-Meta: U2FsdGVkX192Sta4FTLYSQUcmu3++5fqByA9MUF6/ytVyQRYLY/Nel2Xl94Nb8lGxCS5gtG6eJTQ4osM4UdKbkX4JGhh3led6/k4N4aSFFQaPTmdLGRdKq98mK9xBAUi+MsxwWydr3CBRisFD/Dgl/pasRXGC/Ex0BK+WT+DobPI7zPLHyRsQswmWB8Zd1NFuOiZxrSZvXQvUw94N0Xj7K9mOBxxT5OuneVklpW/J7OC2f9jWrkOimwpC6/QEvCRekas/E8nanxqYcgumfvDH3dtfPTwlQxPfPc47H938l4etN6isNhSrKozZl3KmvbNyBC+Bibu4PqieqXSOsyeW6aQ0rt3QHrPItEAwUvGMzEFXCWuFPl+MB8Iy+WmQH3zAMhq9j6DxoIcKG0duWcIzMU0tSTngUFb7Gaoqd+XbHrhl8SDIIhRXxiaOC6dqcaNZB7XjcEcrWjyLUqA6cIR2DjF2ZHV3b8684NeVLrwBZKDh8n0tgPGKcj9BIIbNFIA/Os+TbQtEE9lN6KimdhovJiSZgVk4sufADZhVgJkgNgg8b6lJPWVQPeWQRV02Hm8Kdr+M34LD820vbnW8ALcFtsZvxMANFuqCmcYqhMLv4ZtLL9DBcU3TyFWUYL1+fb9JzzUyWceYJLZNqxaOUo1Xnip9ez/b0skbCmgW6w1kZnLnvCCXTTRRAzQw/ib47mUL8AOG7aLZ2E2E9Yh6lrZsXHRxX+gM1neNbiQcsRfypMQSVLWCYCX3eBLOSOpPMxmX/zbbfQ7HsJFuntin8Hayf5Tswd/d+A102d2WsWKDSIN4LqwCxSnn327s1aIiS9+oluFF4nQv1sS433MW5OS50Q9VJGAFOhBYzUq/nVa/bTccjcpPErrBXwy2JQo+r7YKT6QuuM49dm2Oi6C4VZacRIK7Qehp8bUke0xGBSCHIWlSGsW5/mQN97ViIDCYlZNcyeYrtXJL7qKM9AbjNQ
 eeDhlj5B
 0gVpM+4SEWjrPxIC6xWWrkm7TXI2mAnSIEtuQaFT0tmZe3nGs2gpyr1H9LOTo/Grjnr+IV/vCrgpy09+SIGCPfmZYYwabApQK8zkXXZ6UoszTGlzMKSVOYoi/127wc/mxu+YqTwWzIMCjR2Ku7Dgv5L39zfzXKqlKNuSj6v2cpWEIIkAXJcpwvPFFmxKkPqSLwfjaWvCmkUMgm845pXlL4K41t/Az2oqd0RB/vD5WfLswMcVVwgfZoht+5diEzyLZy3DH0lM/AHEt9EZ0LFSptcYm+wQr0qjt8+/Q40iVR4i5xFlOYuaxxXmxkF1y5xwh1R4Bx0CEwuWyMu7y1Z8c8cAlhGMOxRyItDvHaFY8VomlUnqFNPsGyihhZWoEufGiKlmJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   e43ffb69e0438cddd72aaa30898b4dc446f664f8
commit: d438d273417055241ebaaf1ba3be23459fc27cba mm: remove devmap related functions and page table bits
date:   11 months ago
config: s390-randconfig-r112-20260601 (https://download.01.org/0day-ci/archive/20260602/202606020427.izbA3vh3-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 10.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260602/202606020427.izbA3vh3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: d438d2734170 ("mm: remove devmap related functions and page table bits")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606020427.izbA3vh3-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   fs/dax.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/fs_dax.h):
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
>> fs/dax.c:728:39: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:728:39: sparse:     expected unsigned long v
   fs/dax.c:728:39: sparse:     got restricted vm_fault_t
   fs/dax.c:730:39: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:730:39: sparse:     expected unsigned long v
   fs/dax.c:730:39: sparse:     got restricted vm_fault_t
   fs/dax.c:734:31: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:734:31: sparse:     expected unsigned long v
   fs/dax.c:734:31: sparse:     got restricted vm_fault_t
   fs/dax.c:1370:41: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:1370:41: sparse:     expected int result
   fs/dax.c:1370:41: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
>> fs/dax.c:1878:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
   fs/dax.c:1878:21: sparse:     expected int ret
   fs/dax.c:1878:21: sparse:     got restricted vm_fault_t
   fs/dax.c:1881:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
   fs/dax.c:1881:21: sparse:     expected int ret
   fs/dax.c:1881:21: sparse:     got restricted vm_fault_t
>> fs/dax.c:1884:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted vm_fault_t @@     got int ret @@
   fs/dax.c:1884:16: sparse:     expected restricted vm_fault_t
   fs/dax.c:1884:16: sparse:     got int ret
>> fs/dax.c:1902:46: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [usertype] ret @@
   fs/dax.c:1902:46: sparse:     expected int result
   fs/dax.c:1902:46: sparse:     got restricted vm_fault_t [usertype] ret
>> fs/dax.c:1918:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [assigned] [usertype] ret @@     got unsigned long @@
   fs/dax.c:1918:21: sparse:     expected restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:1918:21: sparse:     got unsigned long
   fs/dax.c:1961:51: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:1961:51: sparse:     expected int result
   fs/dax.c:1961:51: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:2041:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [assigned] [usertype] ret @@     got unsigned long @@
   fs/dax.c:2041:21: sparse:     expected restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:2041:21: sparse:     got unsigned long
   fs/dax.c:2076:62: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:2076:62: sparse:     expected int result
   fs/dax.c:2076:62: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:2138:55: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t @@
   fs/dax.c:2138:55: sparse:     expected int result
   fs/dax.c:2138:55: sparse:     got restricted vm_fault_t
   fs/dax.c:2156:58: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:2156:58: sparse:     expected int result
   fs/dax.c:2156:58: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:279:13: sparse: sparse: context imbalance in 'wait_entry_unlocked' - unexpected unlock
   fs/dax.c:509:49: sparse: sparse: context imbalance in 'dax_lock_folio' - different lock contexts for basic block
   fs/dax.c:576:17: sparse: sparse: context imbalance in 'dax_lock_mapping_entry' - different lock contexts for basic block
   fs/dax.c:1142:9: sparse: sparse: context imbalance in 'dax_writeback_one' - unexpected unlock

vim +728 fs/dax.c

2f437effc689ef9 Shiyang Ruan            2022-06-03  621  
ac401cc782429cc Jan Kara                2016-05-12  622  /*
a77d19f46a37c0f Matthew Wilcox          2018-03-27  623   * Find page cache entry at given index. If it is a DAX entry, return it
a77d19f46a37c0f Matthew Wilcox          2018-03-27  624   * with the entry locked. If the page cache doesn't contain an entry at
a77d19f46a37c0f Matthew Wilcox          2018-03-27  625   * that index, add a locked empty entry.
ac401cc782429cc Jan Kara                2016-05-12  626   *
3159f943aafdbac Matthew Wilcox          2017-11-03  627   * When requesting an entry with size DAX_PMD, grab_mapping_entry() will
b15cd800682fcaf Matthew Wilcox          2018-03-29  628   * either return that locked entry or will return VM_FAULT_FALLBACK.
b15cd800682fcaf Matthew Wilcox          2018-03-29  629   * This will happen if there are any PTE entries within the PMD range
b15cd800682fcaf Matthew Wilcox          2018-03-29  630   * that we are requesting.
642261ac995e01d Ross Zwisler            2016-11-08  631   *
b15cd800682fcaf Matthew Wilcox          2018-03-29  632   * We always favor PTE entries over PMD entries. There isn't a flow where we
b15cd800682fcaf Matthew Wilcox          2018-03-29  633   * evict PTE entries in order to 'upgrade' them to a PMD entry.  A PMD
b15cd800682fcaf Matthew Wilcox          2018-03-29  634   * insertion will fail if it finds any PTE entries already in the tree, and a
b15cd800682fcaf Matthew Wilcox          2018-03-29  635   * PTE insertion will cause an existing PMD entry to be unmapped and
b15cd800682fcaf Matthew Wilcox          2018-03-29  636   * downgraded to PTE entries.  This happens for both PMD zero pages as
b15cd800682fcaf Matthew Wilcox          2018-03-29  637   * well as PMD empty entries.
642261ac995e01d Ross Zwisler            2016-11-08  638   *
b15cd800682fcaf Matthew Wilcox          2018-03-29  639   * The exception to this downgrade path is for PMD entries that have
b15cd800682fcaf Matthew Wilcox          2018-03-29  640   * real storage backing them.  We will leave these real PMD entries in
b15cd800682fcaf Matthew Wilcox          2018-03-29  641   * the tree, and PTE writes will simply dirty the entire PMD entry.
642261ac995e01d Ross Zwisler            2016-11-08  642   *
ac401cc782429cc Jan Kara                2016-05-12  643   * Note: Unlike filemap_fault() we don't honor FAULT_FLAG_RETRY flags. For
ac401cc782429cc Jan Kara                2016-05-12  644   * persistent memory the benefit is doubtful. We can add that later if we can
ac401cc782429cc Jan Kara                2016-05-12  645   * show it helps.
b15cd800682fcaf Matthew Wilcox          2018-03-29  646   *
b15cd800682fcaf Matthew Wilcox          2018-03-29  647   * On error, this function does not return an ERR_PTR.  Instead it returns
b15cd800682fcaf Matthew Wilcox          2018-03-29  648   * a VM_FAULT code, encoded as an xarray internal entry.  The ERR_PTR values
b15cd800682fcaf Matthew Wilcox          2018-03-29  649   * overlap with xarray value entries.
ac401cc782429cc Jan Kara                2016-05-12  650   */
b15cd800682fcaf Matthew Wilcox          2018-03-29  651  static void *grab_mapping_entry(struct xa_state *xas,
23c84eb7837514e Matthew Wilcox (Oracle  2019-07-03  652) 		struct address_space *mapping, unsigned int order)
ac401cc782429cc Jan Kara                2016-05-12  653  {
b15cd800682fcaf Matthew Wilcox          2018-03-29  654  	unsigned long index = xas->xa_index;
1a14e3779dd58c1 Jan Kara                2021-06-28  655  	bool pmd_downgrade;	/* splitting PMD entry into PTE entries? */
b15cd800682fcaf Matthew Wilcox          2018-03-29  656  	void *entry;
ac401cc782429cc Jan Kara                2016-05-12  657  
b15cd800682fcaf Matthew Wilcox          2018-03-29  658  retry:
1a14e3779dd58c1 Jan Kara                2021-06-28  659  	pmd_downgrade = false;
b15cd800682fcaf Matthew Wilcox          2018-03-29  660  	xas_lock_irq(xas);
6be3e21d25ca2db Alistair Popple         2025-02-28  661  	entry = get_next_unlocked_entry(xas, order);
642261ac995e01d Ross Zwisler            2016-11-08  662  
b15cd800682fcaf Matthew Wilcox          2018-03-29  663  	if (entry) {
23c84eb7837514e Matthew Wilcox (Oracle  2019-07-03  664) 		if (dax_is_conflict(entry))
23c84eb7837514e Matthew Wilcox (Oracle  2019-07-03  665) 			goto fallback;
0e40de0338d005f Matthew Wilcox          2018-11-16  666  		if (!xa_is_value(entry)) {
49688e654e48ae1 Hao Li                  2020-07-29  667  			xas_set_err(xas, -EIO);
91d25ba8a6b0d81 Ross Zwisler            2017-09-06  668  			goto out_unlock;
91d25ba8a6b0d81 Ross Zwisler            2017-09-06  669  		}
91d25ba8a6b0d81 Ross Zwisler            2017-09-06  670  
23c84eb7837514e Matthew Wilcox (Oracle  2019-07-03  671) 		if (order == 0) {
91d25ba8a6b0d81 Ross Zwisler            2017-09-06  672  			if (dax_is_pmd_entry(entry) &&
642261ac995e01d Ross Zwisler            2016-11-08  673  			    (dax_is_zero_entry(entry) ||
642261ac995e01d Ross Zwisler            2016-11-08  674  			     dax_is_empty_entry(entry))) {
642261ac995e01d Ross Zwisler            2016-11-08  675  				pmd_downgrade = true;
642261ac995e01d Ross Zwisler            2016-11-08  676  			}
642261ac995e01d Ross Zwisler            2016-11-08  677  		}
642261ac995e01d Ross Zwisler            2016-11-08  678  	}
642261ac995e01d Ross Zwisler            2016-11-08  679  
642261ac995e01d Ross Zwisler            2016-11-08  680  	if (pmd_downgrade) {
642261ac995e01d Ross Zwisler            2016-11-08  681  		/*
642261ac995e01d Ross Zwisler            2016-11-08  682  		 * Make sure 'entry' remains valid while we drop
b93b016313b3ba8 Matthew Wilcox          2018-04-10  683  		 * the i_pages lock.
642261ac995e01d Ross Zwisler            2016-11-08  684  		 */
b15cd800682fcaf Matthew Wilcox          2018-03-29  685  		dax_lock_entry(xas, entry);
642261ac995e01d Ross Zwisler            2016-11-08  686  
642261ac995e01d Ross Zwisler            2016-11-08  687  		/*
642261ac995e01d Ross Zwisler            2016-11-08  688  		 * Besides huge zero pages the only other thing that gets
642261ac995e01d Ross Zwisler            2016-11-08  689  		 * downgraded are empty entries which don't need to be
642261ac995e01d Ross Zwisler            2016-11-08  690  		 * unmapped.
642261ac995e01d Ross Zwisler            2016-11-08  691  		 */
b15cd800682fcaf Matthew Wilcox          2018-03-29  692  		if (dax_is_zero_entry(entry)) {
b15cd800682fcaf Matthew Wilcox          2018-03-29  693  			xas_unlock_irq(xas);
b15cd800682fcaf Matthew Wilcox          2018-03-29  694  			unmap_mapping_pages(mapping,
b15cd800682fcaf Matthew Wilcox          2018-03-29  695  					xas->xa_index & ~PG_PMD_COLOUR,
977fbdcd5986c9f Matthew Wilcox          2018-01-31  696  					PG_PMD_NR, false);
b15cd800682fcaf Matthew Wilcox          2018-03-29  697  			xas_reset(xas);
b15cd800682fcaf Matthew Wilcox          2018-03-29  698  			xas_lock_irq(xas);
e11f8b7b6c4ea13 Ross Zwisler            2017-04-07  699  		}
e11f8b7b6c4ea13 Ross Zwisler            2017-04-07  700  
d2c997c0f14535e Dan Williams            2017-12-22  701  		dax_disassociate_entry(entry, mapping, false);
b15cd800682fcaf Matthew Wilcox          2018-03-29  702  		xas_store(xas, NULL);	/* undo the PMD join */
698ab77aebffe08 Vivek Goyal             2021-04-28  703  		dax_wake_entry(xas, entry, WAKE_ALL);
7f0e07fb0289519 Matthew Wilcox (Oracle  2021-05-04  704) 		mapping->nrpages -= PG_PMD_NR;
b15cd800682fcaf Matthew Wilcox          2018-03-29  705  		entry = NULL;
b15cd800682fcaf Matthew Wilcox          2018-03-29  706  		xas_set(xas, index);
642261ac995e01d Ross Zwisler            2016-11-08  707  	}
642261ac995e01d Ross Zwisler            2016-11-08  708  
b15cd800682fcaf Matthew Wilcox          2018-03-29  709  	if (entry) {
b15cd800682fcaf Matthew Wilcox          2018-03-29  710  		dax_lock_entry(xas, entry);
b15cd800682fcaf Matthew Wilcox          2018-03-29  711  	} else {
23c84eb7837514e Matthew Wilcox (Oracle  2019-07-03  712) 		unsigned long flags = DAX_EMPTY;
23c84eb7837514e Matthew Wilcox (Oracle  2019-07-03  713) 
23c84eb7837514e Matthew Wilcox (Oracle  2019-07-03  714) 		if (order > 0)
23c84eb7837514e Matthew Wilcox (Oracle  2019-07-03  715) 			flags |= DAX_PMD;
23c84eb7837514e Matthew Wilcox (Oracle  2019-07-03  716) 		entry = dax_make_entry(pfn_to_pfn_t(0), flags);
b15cd800682fcaf Matthew Wilcox          2018-03-29  717  		dax_lock_entry(xas, entry);
b15cd800682fcaf Matthew Wilcox          2018-03-29  718  		if (xas_error(xas))
b15cd800682fcaf Matthew Wilcox          2018-03-29  719  			goto out_unlock;
7f0e07fb0289519 Matthew Wilcox (Oracle  2021-05-04  720) 		mapping->nrpages += 1UL << order;
ac401cc782429cc Jan Kara                2016-05-12  721  	}
b15cd800682fcaf Matthew Wilcox          2018-03-29  722  
642261ac995e01d Ross Zwisler            2016-11-08  723  out_unlock:
b15cd800682fcaf Matthew Wilcox          2018-03-29  724  	xas_unlock_irq(xas);
b15cd800682fcaf Matthew Wilcox          2018-03-29  725  	if (xas_nomem(xas, mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM))
b15cd800682fcaf Matthew Wilcox          2018-03-29  726  		goto retry;
b15cd800682fcaf Matthew Wilcox          2018-03-29  727  	if (xas->xa_node == XA_ERROR(-ENOMEM))
b15cd800682fcaf Matthew Wilcox          2018-03-29 @728  		return xa_mk_internal(VM_FAULT_OOM);
b15cd800682fcaf Matthew Wilcox          2018-03-29  729  	if (xas_error(xas))
b15cd800682fcaf Matthew Wilcox          2018-03-29  730  		return xa_mk_internal(VM_FAULT_SIGBUS);
e3ad61c64abceeb Ross Zwisler            2016-11-08  731  	return entry;
b15cd800682fcaf Matthew Wilcox          2018-03-29  732  fallback:
b15cd800682fcaf Matthew Wilcox          2018-03-29  733  	xas_unlock_irq(xas);
b15cd800682fcaf Matthew Wilcox          2018-03-29  734  	return xa_mk_internal(VM_FAULT_FALLBACK);
ac401cc782429cc Jan Kara                2016-05-12  735  }
ac401cc782429cc Jan Kara                2016-05-12  736  

:::::: The code at line 728 was first introduced by commit
:::::: b15cd800682fcaf27048b05e42f5c208e4c756c0 dax: Convert page fault handlers to XArray

:::::: TO: Matthew Wilcox <willy@infradead.org>
:::::: CC: Matthew Wilcox <willy@infradead.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

