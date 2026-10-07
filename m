Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BAD0CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 20:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9826B0088; Wed,  7 Oct 2026 16:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27ADA6B008C; Wed,  7 Oct 2026 16:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C6C6B0092; Wed,  7 Oct 2026 16:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4DC46B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:35:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 590DA1A037C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 20:35:27 +0000 (UTC)
X-FDA: 85296985494.19.2D6B0CA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf02.hostedemail.com (Postfix) with ESMTP id 100498000A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 20:35:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=khEhDfdK;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791405325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8NBeKTxK3VSBh6ulP6Jy8jPj6Ij4tj7U3ozVAxbVqM=;
	b=2sfNmMMn6i+yGnewcINbl7AFz1bQ46jVy6geu3rg70q916XkOMEHNqPXT1O2WpAM8t7lpH
	E3oJu85Mwk+EifLgG9K1zpmfFfehvOwWpHP57lx2Trrxp066v1SJEwvixJ8o+JXAJMBW/x
	qqYUmU+QuBZ6MUw5p9EJS+FY0+hsBQE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791405325;
	b=tfTU2tv/o8e5DRhW8qakSOIYsba73eamdTr6PC8iTkKoMYSF+rhvMPqZPexDiskGIHVHJm
	1J0uQ5C/85OjnM2iWySdgYh0fPE9seY9DKQr3P5cTurY6p2Yh5oJeL41P20cu2K8cZf9TJ
	acrVOMczX3Fmr/pM2wMQiHsLyM93g2M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=khEhDfdK;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791405325; x=1822941325;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JbeNIEU4iUQ8SYi2b45GJTIYlcE248gtt7WfKvw82fI=;
  b=khEhDfdKiqF3SCgfrgsDGVt1ur7dtC0FZZDiLOd6979g3MdtiwbNd5F7
   sWUrW1856GuVB3m75kfYOlx3LQnaEygxNa2Mcz7t10XfE+5Qik5+SKvbf
   Age1zM+OImnkwaX1mMI08BBNM7t/zALhIsJwhwIBlf5W+HspKkdqTegrX
   p6pmPYG2yiBNOPZsePhMakQA4Szvhtuy8UmmF8Pt74BMY0YGDgOw/NCy5
   t/A2kU1qPTzkAVdjz7p44+nqZu/wJaq7olDFFqBCp7cUT7QpgIadiUJZl
   nHZ3NhdhFQUnGG1HckMkQwWj4kXIqL+jQgxIe8DPJxanKJpVKsarkr7/w
   g==;
X-CSE-ConnectionGUID: /0MtQncqQK+yNBxm9GXjYw==
X-CSE-MsgGUID: F1GqBUwGQtiObhWUM/Miig==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="197570"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="197570"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 13:35:23 -0700
X-CSE-ConnectionGUID: 5+0X6H5+RjqXJ0za8As3dQ==
X-CSE-MsgGUID: mK0Qw6jLTKS+Hhk4m333jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="285468564"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 07 Oct 2026 13:35:19 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xEYM8-000000003Vo-1pez;
	Wed, 07 Oct 2026 20:35:16 +0000
Date: Thu, 8 Oct 2026 04:35:12 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v8 14/15] mm/kasan: Introduce helpers for lazy MMU mode
 sanitizer
Message-ID: <202610080433.XoFeDwjr-lkp@intel.com>
References: <e42d9f02ec1f8478a50fce424b95d0e7ff6a359f.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e42d9f02ec1f8478a50fce424b95d0e7ff6a359f.1791365932.git.agordeev@linux.ibm.com>
X-Rspamd-Queue-Id: 100498000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: sxr4im4qb7b434119hpboaqbt5ai36x6
X-HE-Tag: 1791405323-324113
X-HE-Meta: U2FsdGVkX19I28kbGBBTgHCqQ9r1u8gITrQM1b79Q1Yc0/lTpXYnalVbq+FLWUf2FV/p7pmYEg/FtnOtqCidJk5SNFD12gqlprdvBS4R+aAgODH9vIFxomHkJexaSFXvaZac52LF3gUwly90mQHnvao5mSKof1mmPdkQP/kDF8sIZmvDFpz2FrTH/Pb0xUIgRooB1iZlihpPcRvmtIJ+WvmNIPT0u90PMDjTzcsx7uzpJefUJpA20KsbpZLaM5kpoj2X14EJrg96a4HOy0sDyNnYd5sc6FUcvJxjwC2aIDqLzqSXB4mUQqm+HrO9T7lQ+9TRX97yiOp/NZxNqMjYDCSP0kusfCoc+yxWY6bw1CcAGsRIkl+Kvxue04063PkUNV3rlf6jn2ATZHrdtSXZ7Gvbhp2XSGI1xBqTdW4ZXHSQvhr93JmPF9Eil1kVFcFb5NO4YpfDLbmHjY29gBmOsZq9LCDG+OpVkIF4AAFOxdxA9aUSa0wdil7zT9Ea3Tq1oMNdR7P0WeQIcADvqfbkQSXxeOrNPY2wTgYCg2RGvAClgw4WnWgkrlwudPk8cAX0+2Y1pnHC+U16pIUXgD9Fsujw096wubYKqxNoPVAmy7I5IhRJdpCtNaDC5WzWJaW13xr+F40+k+DY6ViwvYWZOc2hwiXuAh6Nq73p0e6Vzq5RVvJjV+0my6XFBYdoEqOQ6veVHqjPa6m1rob1xa99TcdcfaUpNckLM0HQzM6DjbF1uUxklU54QZ2W0Cwje0zWcx0ut5oVWGsEwXjyFk1LnNT4VeBGT/n5wNML7YePendYHb/EbeLtyRJy1fzG27iYlg6hvsmGWMZPNXGTGLtYzH9sUlgpRomzACjqFg4QQN8czYEAT64YomGz9bJ4fHR8BqxXaaXHI0hZ2KMHsigHYY42KQxRJADop4eFoJv49snlF9WfPJE2UVmd80wcXPIcBgFPWbk2xlNMNgUtEe0
 uPrFfAH2
 bJquyxejIHBGZINafD5c4rZvTWP203WUNkEXYbwx3hw7jiODN67zAPviLzmAkp5rtUeUwx9bnGSq0OnCLDt9nQr9cT5dSDMlRVSjA8QAUQ0cES3mgocFKTuEseLlx2cfafB0KiYHv/301rSWbEQRc9f4MxhAav7iJsNLY+yeBtUnipLSfEHmRANv5TgN46CRLkmNrCivSTrJMYb3uDOR3Ls5F34New4x/rgn3PXWFN9wXG/2mK5F0wln+8kc9ZtAJ4GFrCuDSe00wTI7zdFg3shfHZQPIX3DRBahiDLo3rquievbUcKaEuVAMoFrM0yCs96ExyvMsg6i3q/e0Ui2F5VYuxsrssUUzdqkNbePiilaLD4TvJCfyzA41hqftbOwxjdh6R5sIV/CFL7quWX6F5PU5YpaYglkwLLAcN4WZG6UoY9ZEufNoPKBWs5UVTnMfR1j/BqMPUqXMVtQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexander,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.3-rc6]
[cannot apply to akpm-mm/mm-everything s390/features kvms390/next next-20261006]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Gordeev/mm-introduce-hw_pte_t-for-PTE-table-storage/20261007-134144
base:   linus/master
patch link:    https://lore.kernel.org/r/e42d9f02ec1f8478a50fce424b95d0e7ff6a359f.1791365932.git.agordeev%40linux.ibm.com
patch subject: [PATCH v8 14/15] mm/kasan: Introduce helpers for lazy MMU mode sanitizer
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20261008/202610080433.XoFeDwjr-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261008/202610080433.XoFeDwjr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610080433.XoFeDwjr-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:31:
   In file included from include/linux/pgtable.h:6:
   In file included from arch/arm/include/asm/pgtable.h:16:
   In file included from arch/arm/include/asm/pgtable-nommu.h:13:
   In file included from include/linux/slab.h:276:
>> include/linux/kasan.h:430:37: error: unknown type name 'hw_pte_t'
     430 | static inline void kasan_poison_pte(hw_pte_t *pte, int nr) {}
         |                                     ^
   include/linux/kasan.h:431:39: error: unknown type name 'hw_pte_t'
     431 | static inline void kasan_unpoison_pte(hw_pte_t *pte, int nr) {}
         |                                       ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[2]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[2]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:27: warning: array index 3 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                                          ^         ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:5: warning: array index 2 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                          ^         ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:21: warning: array index 2 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                                          ^         ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:157:1: warning: array index 3 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     157 | _SIG_SET_BINOP(sigorsets, _sig_or)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/signal.h:138:8: note: expanded from macro '_SIG_SET_BINOP'
     138 |                 a3 = a->sig[3]; a2 = a->sig[2];                         \
         |                      ^      ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:157:1: warning: array index 2 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     157 | _SIG_SET_BINOP(sigorsets, _sig_or)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/signal.h:138:24: note: expanded from macro '_SIG_SET_BINOP'
     138 |                 a3 = a->sig[3]; a2 = a->sig[2];                         \
         |                                      ^      ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:157:1: warning: array index 3 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     157 | _SIG_SET_BINOP(sigorsets, _sig_or)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/signal.h:139:8: note: expanded from macro '_SIG_SET_BINOP'
     139 |                 b3 = b->sig[3]; b2 = b->sig[2];                         \


vim +/hw_pte_t +430 include/linux/kasan.h

   420	
   421	static inline void kasan_unpoison_range(const void *address, size_t size) {}
   422	static inline void kasan_poison_pages(struct page *page, unsigned int order,
   423					      bool init) {}
   424	static inline bool kasan_unpoison_pages(struct page *page, unsigned int order,
   425						bool init)
   426	{
   427		return false;
   428	}
   429	static inline void kasan_poison_slab(struct slab *slab) {}
 > 430	static inline void kasan_poison_pte(hw_pte_t *pte, int nr) {}
   431	static inline void kasan_unpoison_pte(hw_pte_t *pte, int nr) {}
   432	static inline void kasan_unpoison_new_object(struct kmem_cache *cache,
   433						void *object) {}
   434	static inline void kasan_poison_new_object(struct kmem_cache *cache,
   435						void *object) {}
   436	static inline void *kasan_init_slab_obj(struct kmem_cache *cache,
   437					const void *object)
   438	{
   439		return (void *)object;
   440	}
   441	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

