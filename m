Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CCDACD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FBF86B0005; Thu,  4 Jun 2026 10:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ABE76B0088; Thu,  4 Jun 2026 10:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C17A6B008A; Thu,  4 Jun 2026 10:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 694A46B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:27:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 007FD140730
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:27:49 +0000 (UTC)
X-FDA: 84842459100.05.1321638
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1FAF440015
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:27:39 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780583261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R33ngYkbWnebADGAzsK5ks4popeK8vSxrgF0a+6sSXE=;
	b=hlxw4MRkFBl+4wAjwCG+ZmAMFzi28WegZxAI4v2ohXYtsJcYskpbVz7JHQLLa9IJ6jmzbZ
	ka5pWSfIQUKySZTusgp+KYAxnJVItkHzfgSfCw/UuVnaY0WBgF4NIlI0APgOrfnH51lVkA
	wpO2LLQ7NpsgAshfz/C/x7yv/0Ty5A8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X14LB1ei;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780583261;
	b=7u+OTEOz+wldzx5WKqWdalt0iHgayAPsylBRHqHMDMbGUxTZN4ZPNcFOtqEHbpfmW/FPKh
	GGXnQ+QDoKDoJrvROwAOTlZJWFtturcHBxEqqIe9r24dAC1ZZvwtjNFGaTTDAgvCDgGa0X
	p/GAF3IrhDGD0X92Bhj+CL/mcEPkkB0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780583260; x=1812119260;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=qYAsPKDXPUppKRwSP5FI2/CzU7v5gDFzmtLPJdUPH0M=;
  b=X14LB1ei1LZwqwxSDvqeL8YmFgL05Qx2wVdz0QCJ07ZYjMp3Tykh2UZd
   8I1Iunb/c01gtWxEXi81GhU08IysC4xoCPjJZyIB9G8bpcUfekBxhnJT7
   kyiH5UlzLOFgaLivD/rlvfupXfz8YPYIGUWEupNs6ytwmPDZOQFIMbrdT
   7AOxDSFGUZcZE0syefHHmrBzzNLzIzIOKXS5nJhx/sp9WW1OYB1RLFmTV
   WZscIzDa1yQdxxwyUplcIoFW0c0WN+fLkYjp/0BKi+sRqHW4GHbl9KZJm
   TZNV10xnFgPI2J6VdkiBzIdG+ZdUhxpfTIqEgJBNkLiHBjzYWmtyDSuRG
   g==;
X-CSE-ConnectionGUID: 4yORx6mQQWGRl8WjbP/uxg==
X-CSE-MsgGUID: 1VnMLvBxRHS7opUcyTIFdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="80550184"
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="80550184"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 07:27:38 -0700
X-CSE-ConnectionGUID: FZio8IAXSwmTFeqHuoxEpg==
X-CSE-MsgGUID: gs/P/7SfS/CPn4BnoD6cXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="243482543"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 04 Jun 2026 07:27:36 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wV92i-00000000EoS-4BsW;
	Thu, 04 Jun 2026 14:27:32 +0000
Date: Thu, 04 Jun 2026 22:27:22 +0800
From: kernel test robot <lkp@intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 =?utf-8?Q?"Bj=C3=B6rn?= =?utf-8?Q?_T=C3=B6pel"?= <bjorn@rivosinc.com>,
 Jason Gunthorpe <jgg@nvidia.com>
Subject: fs/dax.c:1370:41: sparse: sparse: incorrect type in argument
 3 (different base types)
Message-ID: <202606042228.F7YX6xYX-lkp@intel.com>
User-Agent: s-nail v14.9.25
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-HE-Tag: 1780583259-568827
X-HE-Meta: U2FsdGVkX1+uOXb8ki5AJ7iFz2Q7XxZJpRdiph5b3EqUpyhf8qP01Dyl9YihvIOHwajT3/uuAtFRh2uoYVUKwih1hz/5Xq/eld+BRUxH5gJF76U47iuzEwi4/ujZP2kdTuuAy8dX1jiIu2cwoi8TZSqcmGuulKgO6qTR9CXhTtEcjW2sl4aZsE6lQChHiEoGDra4/ld9kenjrB3xrYOfy3kjpe9EDtw9P/vtuBH0OZ+iJtEeyTy18Sibnn5qOdX1JtgpB7W0lMT2IYZGZTbgHi5i5FnjS6LIoFOpG+FjWv8d6UBHzXDGV/FvwIqY5GFbEbHH5Km2SJazk3glVwdZygf9EAaUVXDGEwoZ41iyNF6I2Fsfgcblj4Jp9ymxnfPxkJxl4SHKR9MneW47U61KeOQcpDHiY8a31KovjHSBGgwCVpBPqEtdDwoKQC0MKrS7yEewayEShXKlvukUO/z70URfiGU1wya0VSjKhde00AezFBFCwRaidHOvNdeXZQz/K0acrW7fnIJGRtLUN/BS3x32qL2OvmrBfBCXEEZEjRnw7coqypG2qMBZ1IEkp25uMfk4XyRLCOch1OhXi5fKMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   ba3e43a9e601636f5edb54e259a74f96ca3b8fd8
commit: d438d273417055241ebaaf1ba3be23459fc27cba mm: remove devmap related functions and page table bits
date:   11 months ago
config: s390-randconfig-r134-20260604 (https://download.01.org/0day-ci/archive/20260604/202606042228.F7YX6xYX-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 15.2.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260604/202606042228.F7YX6xYX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: d438d2734170 ("mm: remove devmap related functions and page table bits")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606042228.F7YX6xYX-lkp@intel.com/

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
   fs/dax.c:728:39: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:728:39: sparse:     expected unsigned long v
   fs/dax.c:728:39: sparse:     got restricted vm_fault_t
   fs/dax.c:730:39: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:730:39: sparse:     expected unsigned long v
   fs/dax.c:730:39: sparse:     got restricted vm_fault_t
   fs/dax.c:734:31: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:734:31: sparse:     expected unsigned long v
   fs/dax.c:734:31: sparse:     got restricted vm_fault_t
>> fs/dax.c:1370:41: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:1370:41: sparse:     expected int result
   fs/dax.c:1370:41: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:1878:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
   fs/dax.c:1878:21: sparse:     expected int ret
   fs/dax.c:1878:21: sparse:     got restricted vm_fault_t
   fs/dax.c:1881:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
   fs/dax.c:1881:21: sparse:     expected int ret
   fs/dax.c:1881:21: sparse:     got restricted vm_fault_t
   fs/dax.c:1884:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted vm_fault_t @@     got int ret @@
   fs/dax.c:1884:16: sparse:     expected restricted vm_fault_t
   fs/dax.c:1884:16: sparse:     got int ret
   fs/dax.c:1902:46: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [usertype] ret @@
   fs/dax.c:1902:46: sparse:     expected int result
   fs/dax.c:1902:46: sparse:     got restricted vm_fault_t [usertype] ret
   fs/dax.c:1918:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [assigned] [usertype] ret @@     got unsigned long @@
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

vim +1370 fs/dax.c

ff17b8df224b98 Shiyang Ruan    2022-06-03  1351  
e30331ff05f689 Ross Zwisler    2017-09-06  1352  /*
91d25ba8a6b0d8 Ross Zwisler    2017-09-06  1353   * The user has performed a load from a hole in the file.  Allocating a new
91d25ba8a6b0d8 Ross Zwisler    2017-09-06  1354   * page in the file would cause excessive storage usage for workloads with
91d25ba8a6b0d8 Ross Zwisler    2017-09-06  1355   * sparse files.  Instead we insert a read-only mapping of the 4k zero page.
91d25ba8a6b0d8 Ross Zwisler    2017-09-06  1356   * If this page is ever written to we will re-fault and change the mapping to
91d25ba8a6b0d8 Ross Zwisler    2017-09-06  1357   * point to real DAX storage instead.
e30331ff05f689 Ross Zwisler    2017-09-06  1358   */
e5d6df73302c8d Shiyang Ruan    2022-06-03  1359  static vm_fault_t dax_load_hole(struct xa_state *xas, struct vm_fault *vmf,
e5d6df73302c8d Shiyang Ruan    2022-06-03  1360  		const struct iomap_iter *iter, void **entry)
e30331ff05f689 Ross Zwisler    2017-09-06  1361  {
e5d6df73302c8d Shiyang Ruan    2022-06-03  1362  	struct inode *inode = iter->inode;
91d25ba8a6b0d8 Ross Zwisler    2017-09-06  1363  	unsigned long vaddr = vmf->address;
b90ca5cc32f59b Matthew Wilcox  2018-09-11  1364  	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
b90ca5cc32f59b Matthew Wilcox  2018-09-11  1365  	vm_fault_t ret;
e30331ff05f689 Ross Zwisler    2017-09-06  1366  
e5d6df73302c8d Shiyang Ruan    2022-06-03  1367  	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, DAX_ZERO_PAGE);
3159f943aafdba Matthew Wilcox  2017-11-03  1368  
38607c62b34b46 Alistair Popple 2025-02-28  1369  	ret = vmf_insert_page_mkwrite(vmf, pfn_t_to_page(pfn), false);
e30331ff05f689 Ross Zwisler    2017-09-06 @1370  	trace_dax_load_hole(inode, vmf, ret);
e30331ff05f689 Ross Zwisler    2017-09-06  1371  	return ret;
e30331ff05f689 Ross Zwisler    2017-09-06  1372  }
e30331ff05f689 Ross Zwisler    2017-09-06  1373  

:::::: The code at line 1370 was first introduced by commit
:::::: e30331ff05f689f8f2faeb51664299c4d7841f15 dax: relocate some dax functions

:::::: TO: Ross Zwisler <ross.zwisler@linux.intel.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

