Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5218D3CC87
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 23:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2166A6B0005; Wed, 14 Jan 2026 18:38:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BDFF6B0089; Wed, 14 Jan 2026 18:38:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CD756B008A; Wed, 14 Jan 2026 18:38:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC42A6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:38:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DAE686D11
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:38:38 +0000 (UTC)
X-FDA: 84332186316.11.30BA885
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55420C0008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 23:38:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VbvG7L1p;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768433916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LcNqjjVNWGvtcLpjNLxX0c3jlyHG2NeY3ipzqJwQYkk=;
	b=w9gGaiIoxKbas9vZHVLmdyAFNqtSz4Xe3x00hdGg9ZkM1YAzdan4KCqMiqF6C85LUhxw0X
	u3zSS/9YMz0NDcAYsddi5XwhvTY46QMtk/DGMbqIHma37DY7Z/8ReeagtpTWn9YroK03mH
	vtzaqvMegOemWCBDib+bgkM7p3OMa5k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VbvG7L1p;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768433916; a=rsa-sha256;
	cv=none;
	b=qHsYT7s+aeVGUiRMH0bb7OmzmlLFLIPrKJI1gLTnSf0Lq0tvFB0weG67zGHm+8ToejOsSu
	xz6rhksUepGnBDBI+uGAIxzunWagufCrnIr8Xa2vEgr7CdtIwsNrOBdejQnZWCHzeqF+El
	PBhUVhfX1v+zmTZicJ/ve8t3rpD2gxk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768433916; x=1799969916;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=u0ggc6HpVniJWvMa3hoyVMdQ7otmCYiUkNcnnUNjD4Q=;
  b=VbvG7L1peaomsKAVap7Kw/Yooj1eM4MTNYPYgqknDkB43fdnvp289fXS
   zApQx3ctk4MMZgZWoApyMV+Aagvrx8QuAeAdbzI+KihbNR0Q37y+cqCJO
   suh2EryaFlaXaaOSFHyTiLYua+BqlXk1N4N2eMvDeyvHGwsbAUf5taa6n
   WhONlZUnFQRXSYQ1ZZNsORaXhMfeJT4k2rE7ddGuTuxfY+MpoJLfS0x4D
   IpF1HSXcfJ7pM5op7U5bnt8vZ30qfFjSCizoVsj+uWLG3s73lAPKFlJIF
   kTQp0ExKXUgNaps2c5tksm6Spn/Au2oi9uv69/5G+fmUAj3kuoavtdfmw
   g==;
X-CSE-ConnectionGUID: HtbfRyLRTOy6HMkJzl3yJg==
X-CSE-MsgGUID: 7CNA7Yj4R5Wabd2NLruQAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="69827229"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="69827229"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 15:38:35 -0800
X-CSE-ConnectionGUID: dca36A3BRXOhNp1Clj7iNA==
X-CSE-MsgGUID: pNKP+L72RZejs9ctcdOIiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="209863486"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 14 Jan 2026 15:38:31 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgARZ-00000000HCa-0hGP;
	Wed, 14 Jan 2026 23:38:29 +0000
Date: Thu, 15 Jan 2026 07:37:58 +0800
From: kernel test robot <lkp@intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 =?utf-8?Q?"Bj=C3=B6rn?= =?utf-8?Q?_T=C3=B6pel"?= <bjorn@rivosinc.com>,
 Jason Gunthorpe <jgg@nvidia.com>
Subject: fs/dax.c:728:39: sparse: sparse: incorrect type in argument
 1 (different base types)
Message-ID: <202601150722.hIi3GSF6-lkp@intel.com>
User-Agent: s-nail v14.9.25
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 55420C0008
X-Stat-Signature: pgo9kp837y5pd9p46m6dahu4qacy9wro
X-HE-Tag: 1768433916-759153
X-HE-Meta: U2FsdGVkX1+G5iBoO7uIR/BEJrdexXPgbFrn/tbgvCwoFcBu5oIVIyXKyx4N9+5F7t0zp4Z7j+jvud1TosTJ4n+GTZqK4LqC24fAcLssoiYuwpHaxfxxFTcZdILcuzbsMeMs+w2+TAjw4zM4Dp+ACGyH7ZlNz1I0nrCWmts33vLT6aWP/vn1mgsu1/rAJcnx6EmY4wKmTs8Lv902qbWLB3Bse5epXlbmwL0CA5Xsyqk4ccU1MUgQT6gIwgFE32coiSuDJRKszmjzk0BYT7OR5SRWRAh/c8zXmMYmKi4CJ/esak05nZY8VoFNBhExU2rYsRViHDiygavE1uu0F30WsmYZaSikcqIGpQdy6AfEgwSjZA10EPQa4y4h3+yHFzEYe9GecAbFibjD2PZFmvXLeTzw7DmMUXhXkiA8FfsKDEtw/qAh66Ow/PPIwKrA1UQUb51AeDKNvLzmIbdK6hhX+DOiCyYrALYC1MVAUheuuQQ8Y2siG5hd3aGMBpVU1AQdJqSX9k+LzD/FurRvNtbhHq+TFkDcRKUMVQbyiIkJVANC815bM1QvcRZ++Psni85jakT98jJ2yleRCu0upBIP7qBDD+AXBIkckvcV7IlVG/bCcwLZs5O8zJPYBKgPGo1Ql+AxQuZ34lf7/4Lk5Qb3VmCJ2JPluLQzztPoKAPTeJ3RPrvSDnNO7X7HpKjcaavot9yIfLm1zF8Pe8/RZEldwle/tGTYg4ELr2TZeBuk3HmHzriTXrqgqHM9L3Ks98DwGVuqKV+QZxjgsAkTHvnlSznub/l9iX2m8pho+hHQupM5Af7PIZm1d6oesCl/gE5zS8pgwSHOrrWHZLv5KwpE6pahanPxT8WTOiPW7QJPuQnOIQ2sazvic5wcOqLF0vDLkBJTZpHcH4urbWUCUbNB5sSvXj7HJC8PjYn3g5EEbfWt63PpCPFCXPZwE01LohJqCORp+/gnohobkYdj7uo
 /+GFcenF
 7yRGAoqdIIysbjyPhjcvPeEQbEs6ezXubodaCldDKYi1JwdVjjdeGarZSRGjZTQMyMYk9pU1ILDWb8hh0QLnpXQBbBHIIygpyVKYVF6GAMLbW6AFjiU1S4Ci6+7biO68lR2QeY3ghodpsYCaUtcp/zGeMJJG8PCjMWgh0lbQ/aKX7AQEWYsFEjTNITdEoL2uPblm7TgaNRffX/vlPLMcb8C5zSEsZkWZMXWf2hj8abymASouAQBhnvJsqq0dR5tsFe5nQOrFpf6dDZ3yPIPMvHvVkxVAyJoEaMiwq6wBMl3Zq1GrY2+zOAbztTgxz18dUhnJ3l4TdLR7B+Esyp8McEiyQA9CwdsEObH9g4k0QDU0trmZEklZnmRUm5okmV0KuE8Y4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alistair,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   944aacb68baf7624ab8d277d0ebf07f025ca137c
commit: d438d273417055241ebaaf1ba3be23459fc27cba mm: remove devmap related functions and page table bits
date:   6 months ago
config: s390-randconfig-r123-20260115 (https://download.01.org/0day-ci/archive/20260115/202601150722.hIi3GSF6-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260115/202601150722.hIi3GSF6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601150722.hIi3GSF6-lkp@intel.com/

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

2f437effc689ef Shiyang Ruan            2022-06-03  621  
ac401cc782429c Jan Kara                2016-05-12  622  /*
a77d19f46a37c0 Matthew Wilcox          2018-03-27  623   * Find page cache entry at given index. If it is a DAX entry, return it
a77d19f46a37c0 Matthew Wilcox          2018-03-27  624   * with the entry locked. If the page cache doesn't contain an entry at
a77d19f46a37c0 Matthew Wilcox          2018-03-27  625   * that index, add a locked empty entry.
ac401cc782429c Jan Kara                2016-05-12  626   *
3159f943aafdba Matthew Wilcox          2017-11-03  627   * When requesting an entry with size DAX_PMD, grab_mapping_entry() will
b15cd800682fca Matthew Wilcox          2018-03-29  628   * either return that locked entry or will return VM_FAULT_FALLBACK.
b15cd800682fca Matthew Wilcox          2018-03-29  629   * This will happen if there are any PTE entries within the PMD range
b15cd800682fca Matthew Wilcox          2018-03-29  630   * that we are requesting.
642261ac995e01 Ross Zwisler            2016-11-08  631   *
b15cd800682fca Matthew Wilcox          2018-03-29  632   * We always favor PTE entries over PMD entries. There isn't a flow where we
b15cd800682fca Matthew Wilcox          2018-03-29  633   * evict PTE entries in order to 'upgrade' them to a PMD entry.  A PMD
b15cd800682fca Matthew Wilcox          2018-03-29  634   * insertion will fail if it finds any PTE entries already in the tree, and a
b15cd800682fca Matthew Wilcox          2018-03-29  635   * PTE insertion will cause an existing PMD entry to be unmapped and
b15cd800682fca Matthew Wilcox          2018-03-29  636   * downgraded to PTE entries.  This happens for both PMD zero pages as
b15cd800682fca Matthew Wilcox          2018-03-29  637   * well as PMD empty entries.
642261ac995e01 Ross Zwisler            2016-11-08  638   *
b15cd800682fca Matthew Wilcox          2018-03-29  639   * The exception to this downgrade path is for PMD entries that have
b15cd800682fca Matthew Wilcox          2018-03-29  640   * real storage backing them.  We will leave these real PMD entries in
b15cd800682fca Matthew Wilcox          2018-03-29  641   * the tree, and PTE writes will simply dirty the entire PMD entry.
642261ac995e01 Ross Zwisler            2016-11-08  642   *
ac401cc782429c Jan Kara                2016-05-12  643   * Note: Unlike filemap_fault() we don't honor FAULT_FLAG_RETRY flags. For
ac401cc782429c Jan Kara                2016-05-12  644   * persistent memory the benefit is doubtful. We can add that later if we can
ac401cc782429c Jan Kara                2016-05-12  645   * show it helps.
b15cd800682fca Matthew Wilcox          2018-03-29  646   *
b15cd800682fca Matthew Wilcox          2018-03-29  647   * On error, this function does not return an ERR_PTR.  Instead it returns
b15cd800682fca Matthew Wilcox          2018-03-29  648   * a VM_FAULT code, encoded as an xarray internal entry.  The ERR_PTR values
b15cd800682fca Matthew Wilcox          2018-03-29  649   * overlap with xarray value entries.
ac401cc782429c Jan Kara                2016-05-12  650   */
b15cd800682fca Matthew Wilcox          2018-03-29  651  static void *grab_mapping_entry(struct xa_state *xas,
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  652) 		struct address_space *mapping, unsigned int order)
ac401cc782429c Jan Kara                2016-05-12  653  {
b15cd800682fca Matthew Wilcox          2018-03-29  654  	unsigned long index = xas->xa_index;
1a14e3779dd58c Jan Kara                2021-06-28  655  	bool pmd_downgrade;	/* splitting PMD entry into PTE entries? */
b15cd800682fca Matthew Wilcox          2018-03-29  656  	void *entry;
ac401cc782429c Jan Kara                2016-05-12  657  
b15cd800682fca Matthew Wilcox          2018-03-29  658  retry:
1a14e3779dd58c Jan Kara                2021-06-28  659  	pmd_downgrade = false;
b15cd800682fca Matthew Wilcox          2018-03-29  660  	xas_lock_irq(xas);
6be3e21d25ca2d Alistair Popple         2025-02-28  661  	entry = get_next_unlocked_entry(xas, order);
642261ac995e01 Ross Zwisler            2016-11-08  662  
b15cd800682fca Matthew Wilcox          2018-03-29  663  	if (entry) {
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  664) 		if (dax_is_conflict(entry))
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  665) 			goto fallback;
0e40de0338d005 Matthew Wilcox          2018-11-16  666  		if (!xa_is_value(entry)) {
49688e654e48ae Hao Li                  2020-07-29  667  			xas_set_err(xas, -EIO);
91d25ba8a6b0d8 Ross Zwisler            2017-09-06  668  			goto out_unlock;
91d25ba8a6b0d8 Ross Zwisler            2017-09-06  669  		}
91d25ba8a6b0d8 Ross Zwisler            2017-09-06  670  
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  671) 		if (order == 0) {
91d25ba8a6b0d8 Ross Zwisler            2017-09-06  672  			if (dax_is_pmd_entry(entry) &&
642261ac995e01 Ross Zwisler            2016-11-08  673  			    (dax_is_zero_entry(entry) ||
642261ac995e01 Ross Zwisler            2016-11-08  674  			     dax_is_empty_entry(entry))) {
642261ac995e01 Ross Zwisler            2016-11-08  675  				pmd_downgrade = true;
642261ac995e01 Ross Zwisler            2016-11-08  676  			}
642261ac995e01 Ross Zwisler            2016-11-08  677  		}
642261ac995e01 Ross Zwisler            2016-11-08  678  	}
642261ac995e01 Ross Zwisler            2016-11-08  679  
642261ac995e01 Ross Zwisler            2016-11-08  680  	if (pmd_downgrade) {
642261ac995e01 Ross Zwisler            2016-11-08  681  		/*
642261ac995e01 Ross Zwisler            2016-11-08  682  		 * Make sure 'entry' remains valid while we drop
b93b016313b3ba Matthew Wilcox          2018-04-10  683  		 * the i_pages lock.
642261ac995e01 Ross Zwisler            2016-11-08  684  		 */
b15cd800682fca Matthew Wilcox          2018-03-29  685  		dax_lock_entry(xas, entry);
642261ac995e01 Ross Zwisler            2016-11-08  686  
642261ac995e01 Ross Zwisler            2016-11-08  687  		/*
642261ac995e01 Ross Zwisler            2016-11-08  688  		 * Besides huge zero pages the only other thing that gets
642261ac995e01 Ross Zwisler            2016-11-08  689  		 * downgraded are empty entries which don't need to be
642261ac995e01 Ross Zwisler            2016-11-08  690  		 * unmapped.
642261ac995e01 Ross Zwisler            2016-11-08  691  		 */
b15cd800682fca Matthew Wilcox          2018-03-29  692  		if (dax_is_zero_entry(entry)) {
b15cd800682fca Matthew Wilcox          2018-03-29  693  			xas_unlock_irq(xas);
b15cd800682fca Matthew Wilcox          2018-03-29  694  			unmap_mapping_pages(mapping,
b15cd800682fca Matthew Wilcox          2018-03-29  695  					xas->xa_index & ~PG_PMD_COLOUR,
977fbdcd5986c9 Matthew Wilcox          2018-01-31  696  					PG_PMD_NR, false);
b15cd800682fca Matthew Wilcox          2018-03-29  697  			xas_reset(xas);
b15cd800682fca Matthew Wilcox          2018-03-29  698  			xas_lock_irq(xas);
e11f8b7b6c4ea1 Ross Zwisler            2017-04-07  699  		}
e11f8b7b6c4ea1 Ross Zwisler            2017-04-07  700  
d2c997c0f14535 Dan Williams            2017-12-22  701  		dax_disassociate_entry(entry, mapping, false);
b15cd800682fca Matthew Wilcox          2018-03-29  702  		xas_store(xas, NULL);	/* undo the PMD join */
698ab77aebffe0 Vivek Goyal             2021-04-28  703  		dax_wake_entry(xas, entry, WAKE_ALL);
7f0e07fb028951 Matthew Wilcox (Oracle  2021-05-04  704) 		mapping->nrpages -= PG_PMD_NR;
b15cd800682fca Matthew Wilcox          2018-03-29  705  		entry = NULL;
b15cd800682fca Matthew Wilcox          2018-03-29  706  		xas_set(xas, index);
642261ac995e01 Ross Zwisler            2016-11-08  707  	}
642261ac995e01 Ross Zwisler            2016-11-08  708  
b15cd800682fca Matthew Wilcox          2018-03-29  709  	if (entry) {
b15cd800682fca Matthew Wilcox          2018-03-29  710  		dax_lock_entry(xas, entry);
b15cd800682fca Matthew Wilcox          2018-03-29  711  	} else {
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  712) 		unsigned long flags = DAX_EMPTY;
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  713) 
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  714) 		if (order > 0)
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  715) 			flags |= DAX_PMD;
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  716) 		entry = dax_make_entry(pfn_to_pfn_t(0), flags);
b15cd800682fca Matthew Wilcox          2018-03-29  717  		dax_lock_entry(xas, entry);
b15cd800682fca Matthew Wilcox          2018-03-29  718  		if (xas_error(xas))
b15cd800682fca Matthew Wilcox          2018-03-29  719  			goto out_unlock;
7f0e07fb028951 Matthew Wilcox (Oracle  2021-05-04  720) 		mapping->nrpages += 1UL << order;
ac401cc782429c Jan Kara                2016-05-12  721  	}
b15cd800682fca Matthew Wilcox          2018-03-29  722  
642261ac995e01 Ross Zwisler            2016-11-08  723  out_unlock:
b15cd800682fca Matthew Wilcox          2018-03-29  724  	xas_unlock_irq(xas);
b15cd800682fca Matthew Wilcox          2018-03-29  725  	if (xas_nomem(xas, mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM))
b15cd800682fca Matthew Wilcox          2018-03-29  726  		goto retry;
b15cd800682fca Matthew Wilcox          2018-03-29  727  	if (xas->xa_node == XA_ERROR(-ENOMEM))
b15cd800682fca Matthew Wilcox          2018-03-29 @728  		return xa_mk_internal(VM_FAULT_OOM);
b15cd800682fca Matthew Wilcox          2018-03-29  729  	if (xas_error(xas))
b15cd800682fca Matthew Wilcox          2018-03-29 @730  		return xa_mk_internal(VM_FAULT_SIGBUS);
e3ad61c64abcee Ross Zwisler            2016-11-08  731  	return entry;
b15cd800682fca Matthew Wilcox          2018-03-29  732  fallback:
b15cd800682fca Matthew Wilcox          2018-03-29  733  	xas_unlock_irq(xas);
b15cd800682fca Matthew Wilcox          2018-03-29  734  	return xa_mk_internal(VM_FAULT_FALLBACK);
ac401cc782429c Jan Kara                2016-05-12  735  }
ac401cc782429c Jan Kara                2016-05-12  736  

:::::: The code at line 728 was first introduced by commit
:::::: b15cd800682fcaf27048b05e42f5c208e4c756c0 dax: Convert page fault handlers to XArray

:::::: TO: Matthew Wilcox <willy@infradead.org>
:::::: CC: Matthew Wilcox <willy@infradead.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

