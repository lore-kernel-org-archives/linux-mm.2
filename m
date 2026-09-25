Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27921C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32DB96B0093; Fri, 25 Sep 2026 06:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE796B0095; Fri, 25 Sep 2026 06:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5436B0096; Fri, 25 Sep 2026 06:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAFCC6B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:07:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79D6A1605DE
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:07:45 +0000 (UTC)
X-FDA: 85251858090.10.7EF1841
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id B8C9040002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:07:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W0y04VDz;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790330863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=xZmpwKR8YcYlTFsK6njNpfyG4MdG2p7yqYK/zsCXzsk=;
	b=RnbaFZ7JZRVt2a6AIzABaVw/BK0KI67QO2OsKaMTzrcUq2pTe9szYlxfRS+8K9pEKtbjRp
	H075cKSCBhUAJ/vp3zVSMkph4KyuD/kIIHXQoer2rdVU24jUusKqQ2KcVBw3V3JSyeAIQs
	UTEEd6zyU8zM0KDmNJTDqZN90m/VGzY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790330863;
	b=Xa2ROilPZpcihtjZ39xmrt6XctYr8tw+D063JlCuWsIbV9OiKa/eKJd5y5i0ONMipgGU/Y
	xgEMymXDf/vzaKqyC7dsXdXrRNpRwOidV8ZsDiwYb/b7V9BPuAR9Epy+bt2NbfPsmxdGaD
	xddmyjE8hm1yMiqoUu04CIkFwVhNbOk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W0y04VDz;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790330863; x=1821866863;
  h=date:from:to:cc:subject:message-id;
  bh=uRiSOSBUz3eAFSpX2wh1/s2MRRtpmEGhAso2B9joDKs=;
  b=W0y04VDzcjgdeXvleuirq5ESkZXVE+lb9ylIV6AmzB+tiumnC/WmA1sQ
   tD9zvG2W54on7iLL8F8uNHPsK1RoAZLk8k/Pu+vuPWU8omd0lkq2JO8Hw
   AzQUKdNClkTcITNtBhvouzNxeuoELbGjttTcbTfxJaavg33/hlqoNpIa0
   eAAn8iq9HrqVqLne8JWYO05At4Y5ZuQwkLB6+WDrAdzGm7+WVO5mtw2sx
   H8jpvZoF9ePxBoGPesE+VJ9rqoXnBMesG9IhQBSxmQ2xR6feXtE841NBX
   teX9OK7612UgBfyajOH3ZRBzgcqMMrbrRYPRA/eWpVCy/kWAffnSKbCLh
   w==;
X-CSE-ConnectionGUID: dzyiF9NSTRmx5kHolM/Wxg==
X-CSE-MsgGUID: KTimsTSYQNCGyqk94DCpcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="101641081"
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="101641081"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 03:07:42 -0700
X-CSE-ConnectionGUID: qnGsC4gtQBa6g9djoz0ASA==
X-CSE-MsgGUID: SMabCklgTBSjtJ9MN79F5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="270771421"
Received: from igk-lkp-server01.igk.intel.com (HELO a88263cc608e) ([10.211.93.152])
  by fmviesa009.fm.intel.com with ESMTP; 25 Sep 2026 03:07:39 -0700
Received: from kbuild by a88263cc608e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xA2q9-000000000g8-1nHB;
	Fri, 25 Sep 2026 10:07:37 +0000
Date: Fri, 25 Sep 2026 12:07:09 +0200
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 6102/7200]
 include/linux/mmzone.h:1160:29: error: use of undeclared identifier
 'PUD_SHIFT'
Message-ID: <202609251257.WwH2kzxF-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: rhjgj9hhgy8boyrk8yzqwi7n8o35h4sd
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B8C9040002
X-HE-Tag: 1790330862-71712
X-HE-Meta: U2FsdGVkX183LKJRfVVqDJ3BUfcG1LAV8fQmAJUJu3PUriw2UosJ2MKO9fqkQh0DBBCvy4MuTsVBE+UvQgO5GkC7uMS/JHxbke8tWXpUJRwRIjwyMm3KNTuoxN1t5gV8QLVbH99SiXIusD00j1X1Sdw1ez7l3tGc7uF/BBi+zIDIcbnXdfr6wKJh5xR/oI1Q4tKkfpoBiE9Pyp7t/W64IeZhJ5AwXgFm4/HD6lxbvUcLgnPnqXMZbkg7NaORpMqVEvBlmy4UjZsyWBaasg96yVK9h9CKF6ViFH6+J/E5U3VhX2rj0rru2N8MDogZzEIEz68014Wip+GlZBhGkb1fISnb4lKXjM3XJ8apx8Rvaq0eHUarcFf0FYDtP6kycNGGkhP+Tj1bbgPp+dwY6ReUTC6xMkgrVQViE4qIq7DHp+hiDizlMHItpiQ3yzcZCOJOM2UVsrpNjJHmCpQVwp4+fLRdO9Q8oAmxZdUsGFxye68B63Hmf9ucAxWq8A0nPX79q0HTZSnwpFpKYOqQKVMXf9NEKKUWRQtlkQYdOV95ntfbvs42zQG1odrlHmTvpBUhpoO+OfZT1HjvqL6fSR5CPHGghFgzFkf23MvgyUxvyyf9/vdWtRPzKTk6fpzRGHu5nasU2KY9zbwk/cEqfgxFv3jhIyXFZDUJFks6r+a/rkUxKie6YzKZXDrOIZlL14m+xa8aBznUwt9/VPhfuP5TzqusIeC9LZZKNQvjs9U5RnsX13myao6N6YzeVHzOWhiWXXNbJZ/AHFn4X0ibR8DaVam5fGvBzCHPvp0oXdSvx5ZcU+28vltwKo0Dx194ap1zLF3amAwEFKm6vK1Xy40GIUbfp059rBx9ESlXdO1BA6v+aM4hHgorHfWWg3Z/e3tByHL8sMrX082mOUuCjDgJArD5NgWvCaYlXH+/+SNzbrKbgvVOhk0y/eKyK/0o5YslEEz5LILt+A39thPhheB
 DWLdUTF+
 Z4DUXW+AXX4xknHfCT/wRmWsWLLPsn13faCauvS5lwq4xHmlCHDVmJcqfcQ75X44sfg4tKDwHyLBO1scFCeLu3urkEIw3aieBkEQdG20xh+vKSX3Vpx3jWxAab8oeog8T8dUSlWIsAuRUFor9uqsrqMcfEKX/7Yt2z/VCSWpLCdLNZu+szgIRjbO1ykC+oZ9WAYUgqZ6smKeHMrYtP7a6Uy2MAC6KWBq5Ajogk/0vAg/dQA82AcaswZD4XHXBv/NbHT1svTCDCJ4qZfZIGSBZXY3FbUfb12qpmlqMyZnHJy4kz+x6m+1BfNvDgJHeJhS1ObancJgGxOhyGbQ0gETYkG66uL4+ywHfWa2tpSnYiOhRjRFHcOrWgohxpK+njjmIj/NhysDghIBYsPKalyvJJF+By/MCaDWXMr/y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   4c253ac4b29b8c6cc6fdef8f92d4facde62e63b9
commit: 83c71ba4895fcfd11ec4746d0ef1585c70deb325 [6102/7200] mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
config: riscv-randconfig-r2106-20260925 (https://download.01.org/0day-ci/archive/20260925/202609251257.WwH2kzxF-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260925/202609251257.WwH2kzxF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609251257.WwH2kzxF-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/riscv/kernel/asm-offsets.c:9:
   In file included from include/linux/mm.h:8:
   In file included from include/linux/gfp.h:7:
>> include/linux/mmzone.h:1160:29: error: use of undeclared identifier 'PUD_SHIFT'
    1160 |         struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
         |                                    ^
   include/linux/mmzone.h:119:4: note: expanded from macro 'VMEMMAP_OPTIMIZATION_NR_ORDERS'
     119 |         ((__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 &&       \
         |           ^
   include/linux/mmzone.h:117:3: note: expanded from macro '__VMEMMAP_OPTIMIZATION_NR_ORDERS'
     117 |         (MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
         |          ^
   include/linux/mmzone.h:94:27: note: expanded from macro 'MAX_FOLIO_ORDER'
      94 | #define MAX_FOLIO_ORDER         (PUD_SHIFT - PAGE_SHIFT)
         |                                  ^
>> include/linux/mmzone.h:1160:29: error: use of undeclared identifier 'PUD_SHIFT'
   include/linux/mmzone.h:120:57: note: expanded from macro 'VMEMMAP_OPTIMIZATION_NR_ORDERS'
     120 |           IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION)) ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
         |                                                                ^
   include/linux/mmzone.h:117:3: note: expanded from macro '__VMEMMAP_OPTIMIZATION_NR_ORDERS'
     117 |         (MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
         |          ^
   include/linux/mmzone.h:94:27: note: expanded from macro 'MAX_FOLIO_ORDER'
      94 | #define MAX_FOLIO_ORDER         (PUD_SHIFT - PAGE_SHIFT)
         |                                  ^
   In file included from arch/riscv/kernel/asm-offsets.c:9:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:9:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:9:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:99:4: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      99 |                         set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:9:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:101:11: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
     101 |                 return (set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:9:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:9:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:27: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:9:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:5: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:9:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:21: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:9:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:116:5: warning: array index 1 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     116 |                         (set1->sig[1] == set2->sig[1]) &&
         |                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:9:


vim +/PUD_SHIFT +1160 include/linux/mmzone.h

3484b2de9499df Mel Gorman             2014-08-06  1152  
7cf91a98e607c2 Joonsoo Kim            2016-03-15  1153  	bool			contiguous;
7cf91a98e607c2 Joonsoo Kim            2016-03-15  1154  
e6ad640bc404eb Shakeel Butt           2022-08-26  1155  	CACHELINE_PADDING(_pad3_);
3484b2de9499df Mel Gorman             2014-08-06  1156  	/* Zone statistics */
3484b2de9499df Mel Gorman             2014-08-06  1157  	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
f19298b9516c1a Mel Gorman             2021-06-28  1158  	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
83c71ba4895fcf Muchun Song            2026-09-11  1159  #ifdef CONFIG_SPARSEMEM_VMEMMAP
e1b6218149da3f Muchun Song            2026-09-10 @1160  	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
622026e87c4019 Kiryl Shutsemau        2026-02-27  1161  #endif
22fc6eccbf4ce4 Ravikiran G Thirumalai 2006-01-08  1162  } ____cacheline_internodealigned_in_smp;
^1da177e4c3f41 Linus Torvalds         2005-04-16  1163  

:::::: The code at line 1160 was first introduced by commit
:::::: e1b6218149da3f0eef54e9466e3b31ec47d3c991 mm/sparse-vmemmap: rename HVO order macros

:::::: TO: Muchun Song <songmuchun@bytedance.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

