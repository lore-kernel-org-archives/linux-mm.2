Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A33ED41C35
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 13:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B166B0023; Thu, 11 Dec 2025 08:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC0C6B0024; Thu, 11 Dec 2025 08:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8FD6B0026; Thu, 11 Dec 2025 08:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC4966B0023
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:01:08 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 520BF1A0151
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:01:08 +0000 (UTC)
X-FDA: 84207200616.29.6C88B2D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf07.hostedemail.com (Postfix) with ESMTP id EDF414002A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:01:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kzT5mPX1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765458066; a=rsa-sha256;
	cv=none;
	b=uLAVEnEvXaECtonH2B4nRZMn2R9Hf16lJgTVs8IjZ7RASytzTEVQZo1v7UNQmvbQQXcqlm
	lq9ol4ikSo8D157zHqxmWT6qwI+SOrGi+FcnqHdmYkRi4SuBvJwM9Kday8coYwmHNUxGPB
	/47TXI8+PFCA/hkliNTYOWqP8wCyiQo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kzT5mPX1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765458066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VAH7H/st6D1kZnq21KXqS65p3G9qf68xsaNkdM5E03E=;
	b=Z4IZ3FJtJTvsBtVQ9+zosEw2PmT9AwPILibBWDKi4HXGcGljMPnvQuF1K8SENtu0eE5u+R
	oB7hwFLeSLKAGnddHG6QOPTuHZ9L0VA8/qnT6zYUeiIgHCl+aICzS2frAehV/FeIMUyKqh
	Aut8ggw+Rw8LY8ZFOj2LxLrOpwAlbUk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765458065; x=1796994065;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Itvdqg8o936DZ6DkLwgXGCGQLBgTVnOvHDu9qGxqu+E=;
  b=kzT5mPX1LoQ42EYwwGe5gaW+7v2icHOgtk74KW1KZUQmSiCPsZsEOr/V
   AM18gd3w0SvhRBXxDBMTqICg2KXRYuKiP3CNd3obbwezdWXgE12PJbi/X
   yoPhyoT00EM5Xz9U5UrQje1Sv8ftiiokUmGjG1wEamqZ6Not/pThnQQl/
   pUYGCoqflD4wFGgA/THvt3laIrYWFRkVaMZ+WmBtY5VWC2ULRSPFTDWnF
   LKzcCDLveWBMeBKUNx2XuEPcG/LvxgSis73vkqHZHuu0PSOndqGqSguK3
   JED0ucq6dRA023beD8QLqYNhA6UgRWt5hdc3wEZCH7OVor5kztrRiYShW
   A==;
X-CSE-ConnectionGUID: I321ujmfRfe8vVXb6cKe9g==
X-CSE-MsgGUID: fXjM4wj3Sfy3DSshRB6McQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="78549472"
X-IronPort-AV: E=Sophos;i="6.21,267,1763452800"; 
   d="scan'208";a="78549472"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 05:01:03 -0800
X-CSE-ConnectionGUID: bLLGVK99TrqPkhrmk5SorQ==
X-CSE-MsgGUID: 15mOUc3AQbOccizYXjQeBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,267,1763452800"; 
   d="scan'208";a="227853306"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 11 Dec 2025 05:01:01 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vTgHy-000000004fb-429Y;
	Thu, 11 Dec 2025 13:00:58 +0000
Date: Thu, 11 Dec 2025 21:00:16 +0800
From: kernel test robot <lkp@intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: fs/dax.c:1891:16: sparse: sparse: incorrect type in return
 expression (different base types)
Message-ID: <202512112044.HKImx4Ds-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EDF414002A
X-Stat-Signature: eje9uwn1qbuxzn9ctte6rxddfszqbrnu
X-Rspam-User: 
X-HE-Tag: 1765458064-606291
X-HE-Meta: U2FsdGVkX19p6JycsVurlApeme22x3wMwlcuezsCEe8Pk4pZbmbAvIPqE4ib1E2uogM0KtbC+da8SgWjeZw8+pf8PodasRV3cxtL8Z+S/JRGUgMLIFxPbzvviu4pgLgp6MiT1xYtZh4R0Qbg7YNDqejV+kduB1/6j2rNfvWQJyqY9INR9XL8Etvc6xM5ooZMZhYYH0t9w+QXUgONYrF2R1L2xfxTr27F7ERGkdav16EYtZAsnUP8sEuNvTZWQmDDmu4ogtDFb0uW79DIa2BLIsSMgMq1r2A7X+uwY75iWERcXKeNe/Pnkp/nLCTpM7MET76Iw6oi6ET6fXIChFgE61V2A6OXMh/aZDvRh1S19g9EM5SXRA+QksBjXhWKUerBgTYLEm7Akf+1tIAVWisBEeMEmKMH/O9iEHGj0b2pH/SSk+abTT5WOrn92w4/xupTwu8lMuZKYL6bw5H1M8p1HFJrZphYgtsKT93vSOMrpi5CvSPb5rC84rhjfiRCKeKRzK6VZXuFfh8zfYTPj+CcZP0/TR+GucH0OVtfNJeKIKUOIHjwAIutzqnn0o1Sxx0ZndZueySPJLn2Xngpn9I9gdxNItElfGynqS0I3xPpfNqc8yVIYEJom8C7B0balZ5M1wExoKyLVqNVYJPB0iPiqzVUVFOvqJKYYy851rzHeVgQCnYiJe46SykvWMMy7zeKqBk2OKL2qyKf1hHB1BzKpy3bqgoX2EN/v5OGuWnmC7dz+ULGkmLEsYMuX6lWr0/n4I99uVwXV0srgIXmC8KfRhjugUtyzVqR9+S9Yy8Q90mGMBOTwoZRayyDB5PG9Fl16UZjXV0boHWCtWnm/ETI/wfYfK0jT8O+1gRgrSTUSapwOpnMQyDkuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   d358e5254674b70f34c847715ca509e46eb81e6f
commit: 38607c62b34b46317c46d5baf1df03ac6e48a1c6 fs/dax: properly refcount fs dax pages
date:   9 months ago
config: x86_64-randconfig-r113-20251211 (https://download.01.org/0day-ci/archive/20251211/202512112044.HKImx4Ds-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251211/202512112044.HKImx4Ds-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512112044.HKImx4Ds-lkp@intel.com/

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
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:153:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:153:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:153:1: sparse:     got restricted vm_fault_t
   fs/dax.c:727:39: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:727:39: sparse:     expected unsigned long v
   fs/dax.c:727:39: sparse:     got restricted vm_fault_t
   fs/dax.c:729:39: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:729:39: sparse:     expected unsigned long v
   fs/dax.c:729:39: sparse:     got restricted vm_fault_t
   fs/dax.c:733:31: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:733:31: sparse:     expected unsigned long v
   fs/dax.c:733:31: sparse:     got restricted vm_fault_t
   fs/dax.c:1376:41: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:1376:41: sparse:     expected int result
   fs/dax.c:1376:41: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:1885:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
   fs/dax.c:1885:21: sparse:     expected int ret
   fs/dax.c:1885:21: sparse:     got restricted vm_fault_t
   fs/dax.c:1888:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
   fs/dax.c:1888:21: sparse:     expected int ret
   fs/dax.c:1888:21: sparse:     got restricted vm_fault_t
>> fs/dax.c:1891:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted vm_fault_t @@     got int ret @@
   fs/dax.c:1891:16: sparse:     expected restricted vm_fault_t
   fs/dax.c:1891:16: sparse:     got int ret
   fs/dax.c:1909:46: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [usertype] ret @@
   fs/dax.c:1909:46: sparse:     expected int result
   fs/dax.c:1909:46: sparse:     got restricted vm_fault_t [usertype] ret
   fs/dax.c:1925:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [assigned] [usertype] ret @@     got unsigned long @@
   fs/dax.c:1925:21: sparse:     expected restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:1925:21: sparse:     got unsigned long
   fs/dax.c:1966:51: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:1966:51: sparse:     expected int result
   fs/dax.c:1966:51: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:2142:55: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t @@
   fs/dax.c:2142:55: sparse:     expected int result
   fs/dax.c:2142:55: sparse:     got restricted vm_fault_t
   fs/dax.c:2160:58: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:2160:58: sparse:     expected int result
   fs/dax.c:2160:58: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:279:13: sparse: sparse: context imbalance in 'wait_entry_unlocked' - unexpected unlock
   fs/dax.c:508:49: sparse: sparse: context imbalance in 'dax_lock_folio' - different lock contexts for basic block
   fs/dax.c:575:17: sparse: sparse: context imbalance in 'dax_lock_mapping_entry' - different lock contexts for basic block
   fs/dax.c:1148:9: sparse: sparse: context imbalance in 'dax_writeback_one' - unexpected unlock

vim +1891 fs/dax.c

  1826	
  1827	/**
  1828	 * dax_fault_iter - Common actor to handle pfn insertion in PTE/PMD fault.
  1829	 * @vmf:	vm fault instance
  1830	 * @iter:	iomap iter
  1831	 * @pfnp:	pfn to be returned
  1832	 * @xas:	the dax mapping tree of a file
  1833	 * @entry:	an unlocked dax entry to be inserted
  1834	 * @pmd:	distinguish whether it is a pmd fault
  1835	 */
  1836	static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
  1837			const struct iomap_iter *iter, pfn_t *pfnp,
  1838			struct xa_state *xas, void **entry, bool pmd)
  1839	{
  1840		const struct iomap *iomap = &iter->iomap;
  1841		const struct iomap *srcmap = iomap_iter_srcmap(iter);
  1842		size_t size = pmd ? PMD_SIZE : PAGE_SIZE;
  1843		loff_t pos = (loff_t)xas->xa_index << PAGE_SHIFT;
  1844		bool write = iter->flags & IOMAP_WRITE;
  1845		unsigned long entry_flags = pmd ? DAX_PMD : 0;
  1846		struct folio *folio;
  1847		int ret, err = 0;
  1848		pfn_t pfn;
  1849		void *kaddr;
  1850	
  1851		if (!pmd && vmf->cow_page)
  1852			return dax_fault_cow_page(vmf, iter);
  1853	
  1854		/* if we are reading UNWRITTEN and HOLE, return a hole. */
  1855		if (!write &&
  1856		    (iomap->type == IOMAP_UNWRITTEN || iomap->type == IOMAP_HOLE)) {
  1857			if (!pmd)
  1858				return dax_load_hole(xas, vmf, iter, entry);
  1859			return dax_pmd_load_hole(xas, vmf, iter, entry);
  1860		}
  1861	
  1862		if (iomap->type != IOMAP_MAPPED && !(iomap->flags & IOMAP_F_SHARED)) {
  1863			WARN_ON_ONCE(1);
  1864			return pmd ? VM_FAULT_FALLBACK : VM_FAULT_SIGBUS;
  1865		}
  1866	
  1867		err = dax_iomap_direct_access(iomap, pos, size, &kaddr, &pfn);
  1868		if (err)
  1869			return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
  1870	
  1871		*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);
  1872	
  1873		if (write && iomap->flags & IOMAP_F_SHARED) {
  1874			err = dax_iomap_copy_around(pos, size, size, srcmap, kaddr);
  1875			if (err)
  1876				return dax_fault_return(err);
  1877		}
  1878	
  1879		folio = dax_to_folio(*entry);
  1880		if (dax_fault_is_synchronous(iter, vmf->vma))
  1881			return dax_fault_synchronous_pfnp(pfnp, pfn);
  1882	
  1883		folio_ref_inc(folio);
  1884		if (pmd)
  1885			ret = vmf_insert_folio_pmd(vmf, pfn_folio(pfn_t_to_pfn(pfn)),
  1886						write);
  1887		else
  1888			ret = vmf_insert_page_mkwrite(vmf, pfn_t_to_page(pfn), write);
  1889		folio_put(folio);
  1890	
> 1891		return ret;
  1892	}
  1893	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

