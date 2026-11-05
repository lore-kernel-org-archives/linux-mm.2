Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F47606D807
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=A5WOpuhL
Received: by kanga.kvack.org (Postfix)
	id 45F6D6B05B6; Thu,  5 Nov 2026 07:14:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436796B05BA; Thu,  5 Nov 2026 07:14:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34C6A6B05C0; Thu,  5 Nov 2026 07:14:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1409D6B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:14:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7369A86D0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:14:42 +0000 (UTC)
X-FDA: 85400958804.08.62C5EF7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2A038100010
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:14:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A5WOpuhL;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRwA5sbmlFTv4dr/TsrihpefpRsTJ7E+PJDAiAJhZlc=;
	b=sNIaSuM1yn93unO0DHEDxDAcVCVT2GlYINEoBP0uASL1ubAmvi5bFkyrxL2o4te2rITxd/
	U8Q+YYAcOIr5RCS9gJptsUseh/ClL2NUBnVS4Amep5kDR0NEZOGHTxFYMJSUzGqH2T0TUT
	4QvznAHVhEa7qRvG84o3uGxeeIHscNo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880880;
	b=aIJ9OGw5+MxOTvuZYEeS2SWScCcG9NJVrgbSfxwtHpMp6N9q+ziGcVf+rxQeOaeCtdwxBK
	nCCq9svKbafDvcnfItHnabVaeu7mBA68laM3eUhOT0yN1DqfpA/bq1pGs4T+78r9G+JkY3
	XiM904OVhwYOcoY2VKR+9HEZEU73kf0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A5WOpuhL;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793880880; x=1825416880;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hNZG3p/TmBT75mwn4JDU6B5IEwPzDkrT+siPwGcILcw=;
  b=A5WOpuhLXhQcfiSLsPt9hsHLGjQpUn3IDPe9imfl6H8zRzFnlQzPpgoY
   5MmscIQ6EQ7OPXtVcf0U32de5BG0BygUt0BAmmGEfQjnI4PaNVD+bL96J
   1z8EfuOnsfORwRwx4azQiZnBaf2hF2pGbu2mJhpdwurfq+vaDaXAhrXrF
   HD5ljEgwDJsqTeK5+ukYkia3uhp/pOmzlH1EGZ90EZdOqqkEhWzTdxme1
   KKE04YeclMvToN3tqPlX+AuNnttfb/tU0fki13x2grGfexp7QBM46A41n
   OxHLqvvvWlUGLf40CUltIXBSXy57WshLiHWhb2ICqsuhvmx7ChabDIayM
   g==;
X-CSE-ConnectionGUID: zaHJLtj1RyGFyHG1UJ249A==
X-CSE-MsgGUID: UdAvp6VxStWUZz4wKtaqSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2659736"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2659736"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 04:14:38 -0800
X-CSE-ConnectionGUID: n1CgJxqsSv2cC6PyZtAf1Q==
X-CSE-MsgGUID: PaUjo+ZjS1y3BQJZcClOSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7401165"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 05 Nov 2026 04:14:33 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOwMP-00000000mAX-3Cl8;
	Thu, 05 Nov 2026 12:14:29 +0000
Date: Thu, 5 Nov 2026 20:13:50 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>,
	David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>, Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, x86@kernel.org,
	loongarch@lists.linux.dev, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 2/5] powerpc/mm: drop powerpc vmemmap_can_optimize()
Message-ID: <202611052055.TcIXFI7V-lkp@intel.com>
References: <20261105061217.13302-3-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105061217.13302-3-songmuchun@bytedance.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A038100010
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5ow1uh5kfyeg93d5mgya4d8akroauc1e
X-Rspam-User: 
X-HE-Tag: 1793880879-620350
X-HE-Meta: U2FsdGVkX188TIaQWvfM8WNm8SZXn12ONNTlZ6OcKZ/jqxSHYPbfMMIlC7CEFfG8nfUdXvw+Q8TCOBxGN7DoYPKtifbz1lPvSBvwgbQtYbEBPpsxrrSkXb5VtaWaLlL7RKw1Q7v19i02dWjyEcliWOsne2LeaFXMEEYIdvktghwCBSMUNmKmSirwf0HpyQ7sGBRGjuB9cNyGw9DgF9HsccknXu5JXj8rJyxAoqi5Q1Yk0Gk2LkSCfxK+7t1mlwCQC4nB+BRLpCV6nR338sQN/I9MzTc0NMJ3g9vgUeUlQjHr1xyi38orOvqHc0YnFXZenfl/Ks9xmumc853pVuPzP6OCqiOp8G5TdQEOaAe7GLm2q3Ih0oEtmJ0NNBHXoZtZucqcSwTetrXXAwYcSo+Rcb6jZf3bOzlPn0H9+4gO7N7Gg54aYJGZeyppNjUpGFKCzJyuXGCLwMfnLbODVBg+e9WkCWFz0xWj6xO+u4YbD6co+u5s+q3OjU1Mc01+TTwdcApPo4FQgErMVvQ0EMVvRRIvcGFvGjzVIM3LvBhLvOiNeiKTBrWkgmrOi7NPLRW9N0QhIFcWrRdpZ1LSQMIU2D+Wazb2d6Jg5lUo1fpzY3mQXiSyM6BXtJU+HLFRWqVoc2poTiG9iCN4ThFv7+1chMD1byU9YrcrM2RwwmLogj6O/C1PWsyUKuVm9rNWHNoGiY5TR99nwpy9ENGwiUvuRg22IqkYKLxqc7MVyyBLlV8UsvAFD7dNKsmaDbmYL5I7YGAZoVZpEWc7Bsp5yGCJGuByObX2M2x+7UsYxsJ1jXiBc4q6cWNqfACEXshZWYekt9vhEr465WngYN4SIAPYW4SVCK1PXxYJVS+PRJfCdTmC0RhHvk/K7buwanrx/QkeD4yjaCUadB0TzhCzioGwZa5y7+ZakWUrCCPEckdEgytw531PEjQl6IUAMC7sCb+2kq5GHueXQtcKrr+JTRq
 pM2Hb6+M
 h+rUzIAMotXNdQ0uOnHqilU2XapAsfsjOIDUgzzFxMHsZ4WrId2H8rWnasC+6QXuMrv9W7217kQMQnL+dqLnTtIQ/4BZV9Iw5fEaIvxMtAA57vX+z1y6XCY9OeWEf+CHh/kjaDaynw5OWM3EeRDO+ZstjBJlc6G3/9erIaEFBISbrxgWudNbw3DnemIZ9TrAnMPdshMlU06gJZfkYFtA5zFnMZXZWibwRfNeFtW/8HJJF/o1QxgpnQEB6B7+MkN/BXPrxev8gQnDTHUStPEsQFXEPAEv1fhma6gIlXKayEHyJdo3maCzFJI3NrwdtvlkK26VwmsaGvuJUUydLYsJpaEznPrpukwP70fU9rfmLtLsexA5UHtr802S7q/gSkDqu3FeiN0MAYmQyMs20TE2DZmVmAj+RBFZmE3ARbWpBW+llXFuvn5+Ip4u3ZEShLmEFpllrFJ7kSnlH6q22kf/8wrsV/EKRIHoYOPMR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

kernel test robot noticed the following build errors:

[auto build test ERROR on dba8aba0a9a00ff781c03d82ae534fc6f8c2e263]

url:    https://github.com/intel-lab-lkp/linux/commits/Muchun-Song/powerpc-mm-make-vmemmap_populate_compound_pages-static/20261105-141213
base:   dba8aba0a9a00ff781c03d82ae534fc6f8c2e263
patch link:    https://lore.kernel.org/r/20261105061217.13302-3-songmuchun%40bytedance.com
patch subject: [PATCH v2 2/5] powerpc/mm: drop powerpc vmemmap_can_optimize()
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20261105/202611052055.TcIXFI7V-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261105/202611052055.TcIXFI7V-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611052055.TcIXFI7V-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/loongarch/kernel/asm-offsets.c:11:
   In file included from include/linux/mm.h:31:
   In file included from include/linux/pgtable.h:6:
   In file included from arch/loongarch/include/asm/pgtable.h:75:
   include/linux/vmemmap-optimization.h:62:9: error: call to undeclared function 'vmemmap_optimizable_order'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      62 |         return vmemmap_optimizable_order(section_compound_order(section));
         |                ^
>> include/linux/vmemmap-optimization.h:68:22: error: use of undeclared identifier 'vmemmap'; did you mean 'mem_map'?
      68 |         unsigned long pfn = page_to_pfn((struct page *)start);
         |                             ^
   include/asm-generic/memory_model.h:73:21: note: expanded from macro 'page_to_pfn'
      73 | #define page_to_pfn __page_to_pfn
         |                     ^
   include/asm-generic/memory_model.h:47:54: note: expanded from macro '__page_to_pfn'
      47 | #define __page_to_pfn(page)     (unsigned long)((page) - vmemmap)
         |                                                          ^
   include/linux/mmzone.h:1452:21: note: 'mem_map' declared here
    1452 | extern struct page *mem_map;
         |                     ^
   In file included from arch/loongarch/kernel/asm-offsets.c:11:
   In file included from include/linux/mm.h:31:
   In file included from include/linux/pgtable.h:6:
   In file included from arch/loongarch/include/asm/pgtable.h:75:
   include/linux/vmemmap-optimization.h:138:20: error: conflicting types for 'vmemmap_optimizable_order'
     138 | static inline bool vmemmap_optimizable_order(unsigned int order)
         |                    ^
   include/linux/vmemmap-optimization.h:62:9: note: previous implicit declaration is here
      62 |         return vmemmap_optimizable_order(section_compound_order(section));
         |                ^
   In file included from arch/loongarch/kernel/asm-offsets.c:11:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:7:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/loongarch/kernel/asm-offsets.c:11:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:7:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/loongarch/kernel/asm-offsets.c:11:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:7:
   include/linux/signal.h:99:4: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      99 |                         set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/loongarch/kernel/asm-offsets.c:11:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:7:
   include/linux/signal.h:101:11: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
     101 |                 return (set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/loongarch/kernel/asm-offsets.c:11:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:7:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/loongarch/kernel/asm-offsets.c:11:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:7:
   include/linux/signal.h:114:27: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/loongarch/kernel/asm-offsets.c:11:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:7:
   include/linux/signal.h:115:5: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/loongarch/kernel/asm-offsets.c:11:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:7:
   include/linux/signal.h:115:21: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];


vim +68 include/linux/vmemmap-optimization.h

    64	
    65	static inline void section_vmemmap_optimization_disable(unsigned long start,
    66			unsigned long end)
    67	{
  > 68		unsigned long pfn = page_to_pfn((struct page *)start);
    69		unsigned long nr_pages = (end - start) / sizeof(struct page);
    70		struct mem_section *section = __pfn_to_section(pfn);
    71	
    72		if (nr_pages < PAGES_PER_SECTION) {
    73			VM_WARN_ON_ONCE(section_vmemmap_optimizable(section));
    74			return;
    75		}
    76	
    77		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
    78		section_set_compound_order(section, 0);
    79	}
    80	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

