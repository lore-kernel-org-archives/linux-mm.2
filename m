Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9329FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 13:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53BAB6B0088; Thu, 30 Apr 2026 09:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC7F6B008A; Thu, 30 Apr 2026 09:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402216B0096; Thu, 30 Apr 2026 09:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5D66B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:11:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E19AC1C0DC8
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:07:35 +0000 (UTC)
X-FDA: 84715248870.22.47D9B84
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6706AC000F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:07:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HNb6jzen;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777554451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ro0NmzOWNP0EroojJcZZyIPxxPKcj55A/BCfZadES9k=;
	b=lsr2C6y/K2+eSaG9Ml+FtIkdemFH32KyR7Q8MNkHKHcz8hx2yDqrRKCA/YGVe2eKQMJ5DE
	5PjSP5rjQS9m6e5AjRbJsFos6TtlOe9A1cNVdeloKpTrT79w27Zo0g7nM9GFFocDfCDvaV
	5LhOvMvKC8sUYRcJ2UT6rKsPj8gr4Ds=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HNb6jzen;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777554451; a=rsa-sha256;
	cv=none;
	b=j/JtxCHp57vBZOMvZfHsnUjQsqXnGLqc0gHjZ/AaCQw0q/PFHMps1i+EPoMJS+YiibLVAX
	oue7aiEiuqKy8WJzLdBUTvN4V1BnRqJcQi39l7GP4U3uJYcpDMlyuAqv3AgKuUnibJntpu
	6SrM/dJZ2zkAoktCQdxKHdVEKoCMhII=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777554451; x=1809090451;
  h=date:from:to:cc:subject:message-id;
  bh=Z2cAcabUhgwviq787moawJMLwhFnq7gWY/8G4VRV1+0=;
  b=HNb6jzenX0MPoKW7taDOyT+qpkc01rEIYaFxIYJ2A/9clu7n0eMc6fBh
   UBYHKHePvL0WT9JSNUp5EfH2KQ8sQGR5EszFqYUjuMIoBUCdD3/ArjZuH
   8vF9ngNvEeaEufAvmgTfJlqQ+4QSjCaMrWFR3yAody3LmB6Dyd1fDpQDR
   IElKHM1ptlvqc8VGXWtZULgYGznGVr0Lr0+NSgDTZDGELwOj46Nl90Gpm
   UGL+xP+pyHOY7S/W5BB857kCHFthEGWJuBNiICntiq9Z8a7Jjx+LX6d11
   C4QUuM/hgPyF6S6LM027GFlbkMxvpQmfsPmVhqrCG/lpDuiYbkySUISiT
   A==;
X-CSE-ConnectionGUID: i8D5QuxcR9+jF/75jcJQXg==
X-CSE-MsgGUID: 59+nMyaiSMqMDrFoUKPBMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89963174"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="89963174"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 06:07:29 -0700
X-CSE-ConnectionGUID: mwJh41SQSU2C12Fvxh6Oxw==
X-CSE-MsgGUID: ne9qaGMaTM2y5y6JEpc5hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="264947044"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 30 Apr 2026 06:07:26 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIR6x-00000000CPM-2ZIz;
	Thu, 30 Apr 2026 13:07:23 +0000
Date: Thu, 30 Apr 2026 21:07:13 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [akpm-mm:mm-new 115/182] mm/internal.h:847:26: warning:
 implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int')
 changes value from 17179869184 to 0
Message-ID: <202604302039.yKocJk8m-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6706AC000F
X-Stat-Signature: djwnamtgoc86453yt455dpi4sstf164j
X-HE-Tag: 1777554449-997247
X-HE-Meta: U2FsdGVkX1/bMbJTn825FpWuAd7VCjhled5rYodvr1FzjgWtN3ntoqkjMxRt4NMiqBpS63lyGPgYFup3DBVzG8Z4BaAQiUaBRzFd9LHmAfnxFW2EeQ/Ddyq0m9uBf+Wj2pnqMJMKODoXjJ7LPKmDMflIyA/QeF08plQufufSZXQd75UYOz/PZcwBqQiH6lkewTNz9dQEAFG7fJCLWvvkPD/80OtkQ8t/LA1wdJMUqhrf2oy9VDzucbsoAmirZ3dHdmDnWh2BOvlGWT8O/b3iL1lly7icI+d4kxO4kHvHv88d9tUooXRBpJ2pWWRgInuLnkHGmCvysvlDGXw+Ud5IWTa5FgC+3+EoJRgBBNETWyswevNSTsTDvivisdTqzHyEutdOTw1H87Vp3Zc94M+tWdBWEabpijpF+ZaYjLU1aUgGqT9rT8k4fwU8GjUHps5bOLI2/Mx8vzOPChlRlPQoS/ZELa5l+ylcfgEO8rdxNpi01iFxiHJYFhXv2ZmlaT6esi46IXyHTAuidYpAYx+X7rGifF2I4+ZDVR6GcXLdU/mv95WcI4YqpmdyeGvxs/C/nI27JmD2/og+QvTWn20Pnpnx3MVfQPv33sfNSxvya4bGDf98gryb5+EvMomlOSEkC/5VM6N3nWxkQGr3o1H/eYK3FXW23W+6z8b0Ty2Iib9W8yfcE1Yp3A//wGEwihShtW083sz0vWT80QWcyKt+yrIQa/Od5b6qRBjYZHXzst3VATGInzLn/iLEfp1JGCzBHnaSjIEe1wrMzCnSL7iIrCnK+UslzENULESR4UpcOxaSI0SODzCBaHq7K2dKd+sMAKhnaM6QqdsmkqNLlkY09jlo+lA8dK0EdJSkgUZxqTZpU5TkTFwFHHrRZA6e2z4PcWxAMokoyoew3G2KNWGqabdoBdmaoe6P/qrKZmYUU7vjoq1wDY4h7hXyPS7UuM9qbqbH/JljjZx5GPjDOQe
 JiujaQ9n
 3XhpYO7v4fIjATAWh6ANcDKkEAOuNDKyxA4/vTCxadzxo7Kzu2KD93xf3PAcTnlJ3La9NhLuUjy0atmhjLFKqqd/7xih1vOlI3HY7vbT1D7woGI9XwpskvOb9ccKkBElW3EClW2Vx4R2pe0ACfeIsUENa1FIr+fRT1wiGvDYOV/HPVNOf9sHqWUrdnwGnyiCHaRFKoJflKBXOt3yOLxqGBfc+ejh3v6Omf7j5QgGAEHSsWIIQcG8K8uNgnGPN2yx8UwoqPG2En/FDwkW7PtZpJNUfGPVe2g0XhEJZfQ2tZg2IYijANEkaZOn+k877o6NgsD6mbQafLdNvMYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   0587fb0c820d86e5b77a975680d79b5176d09abb
commit: 78c22ab4ad70900027ae72e857274535c798ccfb [115/182] include/asm-generic/fixmap.h: reimplement nasty macros in C
config: riscv-allmodconfig (https://download.01.org/0day-ci/archive/20260430/202604302039.yKocJk8m-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604302039.yKocJk8m-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604302039.yKocJk8m-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/early_ioremap.c:18:
   In file included from arch/riscv/include/asm/fixmap.h:64:
   include/asm-generic/fixmap.h:93:26: error: use of undeclared identifier 'PAGE_KERNEL_NOCACHE'
      93 |         __set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
         |                                 ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:54:29: note: expanded from macro 'FIXMAP_PAGE_NOCACHE'
      54 | #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
         |                             ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:99:33: error: use of undeclared identifier 'PAGE_KERNEL_NOCACHE'
      99 |         __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
         |                                        ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:54:29: note: expanded from macro 'FIXMAP_PAGE_NOCACHE'
      54 | #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
         |                             ^~~~~~~~~~~~~~~~~~~
   In file included from mm/early_ioremap.c:20:
>> mm/internal.h:847:26: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 17179869184 to 0 [-Wconstant-conversion]
     847 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
         |                                 ^~~~~~~~~~~~~~~
   include/linux/mmzone.h:85:33: note: expanded from macro 'MAX_FOLIO_ORDER'
      85 | #define MAX_FOLIO_ORDER         (ilog2(SZ_16G) - PAGE_SHIFT)
         |                                  ~~~~~~^~~~~~~
   include/linux/sizes.h:56:19: note: expanded from macro 'SZ_16G'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:18: note: expanded from macro '_AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~~~~~~
   note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/log2.h:162:14: note: expanded from macro 'ilog2'
     162 |         __ilog2_u32(n) :                \
         |         ~~~~~~~~~~~ ^
   include/linux/mmdebug.h:123:50: note: expanded from macro 'VM_WARN_ON_ONCE'
     123 | #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
         |                                                  ^~~~
   include/asm-generic/bug.h:120:25: note: expanded from macro 'WARN_ON_ONCE'
     120 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   1 warning and 2 errors generated.


vim +847 mm/internal.h

904d58578fce53 Kefeng Wang             2023-05-16  831  
3c605096d31582 Joonsoo Kim             2014-11-13  832  extern int __isolate_free_page(struct page *page, unsigned int order);
624f58d8f46396 Alexander Duyck         2020-04-06  833  extern void __putback_isolated_page(struct page *page, unsigned int order,
624f58d8f46396 Alexander Duyck         2020-04-06  834  				    int mt);
58e3e5265484a1 Shengming Hu            2025-12-29  835  extern void memblock_free_pages(unsigned long pfn, unsigned int order);
13c526540b3169 David Hildenbrand       2024-06-07  836  extern void __free_pages_core(struct page *page, unsigned int order,
13c526540b3169 David Hildenbrand       2024-06-07  837  		enum meminit_context context);
9420f89db2dd61 Mike Rapoport (IBM      2023-03-21  838) 
1e3be4856f49d5 Tarun Sahu              2023-06-12  839  /*
1e3be4856f49d5 Tarun Sahu              2023-06-12  840   * This will have no effect, other than possibly generating a warning, if the
1e3be4856f49d5 Tarun Sahu              2023-06-12  841   * caller passes in a non-large folio.
1e3be4856f49d5 Tarun Sahu              2023-06-12  842   */
1e3be4856f49d5 Tarun Sahu              2023-06-12  843  static inline void folio_set_order(struct folio *folio, unsigned int order)
1e3be4856f49d5 Tarun Sahu              2023-06-12  844  {
1e3be4856f49d5 Tarun Sahu              2023-06-12  845  	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
1e3be4856f49d5 Tarun Sahu              2023-06-12  846  		return;
99132d24d76511 David Hildenbrand       2025-09-01 @847  	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
1e3be4856f49d5 Tarun Sahu              2023-06-12  848  
ebc1baf5c9b46c Matthew Wilcox (Oracle  2023-08-16  849) 	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
4996fc547f5b49 David Hildenbrand       2025-03-03  850  #ifdef NR_PAGES_IN_LARGE_FOLIO
4996fc547f5b49 David Hildenbrand       2025-03-03  851  	folio->_nr_pages = 1U << order;
1e3be4856f49d5 Tarun Sahu              2023-06-12  852  #endif
1e3be4856f49d5 Tarun Sahu              2023-06-12  853  }
1e3be4856f49d5 Tarun Sahu              2023-06-12  854  

:::::: The code at line 847 was first introduced by commit
:::::: 99132d24d76511f0f6ded2e25448765b632794aa mm: sanity-check maximum folio size in folio_set_order()

:::::: TO: David Hildenbrand <david@redhat.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

