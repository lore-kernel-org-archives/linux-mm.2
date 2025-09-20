Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C34CAC5A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 17:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266058E0003; Sat, 20 Sep 2025 13:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217108E0001; Sat, 20 Sep 2025 13:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D0F8E0003; Sat, 20 Sep 2025 13:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 004BF8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 13:13:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 645561D95D5
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 17:13:34 +0000 (UTC)
X-FDA: 83910275148.26.3B0DC06
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3492740005
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 17:13:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RfQJ5kx4;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758388412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwF+afxYayecVmfkK3GwI3w8G+HuJM/es7t0fR/vouk=;
	b=rvSt9rnYx3UwzWER0LdpY2slemQ4woFPYT8YbBCyhy6aGF2StA8d9xCcNGGM1YHMd4AusJ
	WCosPPgc9QxjFZ71vvostW/GgqiGG66Q9CJ5BQwE3oqiMglAtCixOG/XrdzSpHeEx9OPVd
	83QMdljTyAY0iYWNYfxCbPsN1lGmot0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RfQJ5kx4;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758388412; a=rsa-sha256;
	cv=none;
	b=mRbF9jLQ3CgPqohPWpTob51cj4iBw+0ymo/EikQbVHBaHCEEc2cohbsrMG2X0KM5T2ykzi
	AQdYuy+ODz96mAPC4B2Bste15xMov/nb+DC7ps9WY3eboivcFgdfTM6EF9AYmA8XKdjYil
	9uVA1YU3GKkkUBdT7OVdr1VMWXDv92Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758388411; x=1789924411;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5KG+OxVz1Flw/L7SwCG/sFt5K/1TtnEjpf6fe8kLhYo=;
  b=RfQJ5kx4Y4Ldk094fnfPPjpgAZDcBydC6hQSLSntvN5gFVXlRpicNIRq
   5MW1ivc78CNtKA3vaDOplhL6CpDhnRtF2H8OCbtb7wJU8qZ/24fXsAmHN
   ZZw65NIuxVzquzDyr4bYYYusuIrrQKYJoWLJLQ4WCuCF/Y66WFXYLjdU8
   YJFlyrLZSXt00L7PkTUFTuRJ1v8N3vT6caiuyivAkTsTICJea2yqQzobo
   toXvN08D5pK8Hx8bcHiJQkZSBGMqeISqxiaBjWH0XrC7axdhQmBee0Mqv
   mezKmN9YAQXMVwBq9e0YcErPJsTDedfOuZYIQUyeAnYY9XUkcf7xhsCYR
   A==;
X-CSE-ConnectionGUID: QkA6yIKMTimPzOj2zxIezQ==
X-CSE-MsgGUID: 3fypj1QkQOezUMXxA5sifw==
X-IronPort-AV: E=McAfee;i="6800,10657,11559"; a="48288953"
X-IronPort-AV: E=Sophos;i="6.18,281,1751266800"; 
   d="scan'208";a="48288953"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2025 10:13:29 -0700
X-CSE-ConnectionGUID: aGJub6TJSfuXNhh7mgYHgw==
X-CSE-MsgGUID: oZexoa1VTM62gdDAzDVxGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,281,1751266800"; 
   d="scan'208";a="207054036"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 20 Sep 2025 10:13:25 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v019H-0005Zf-0c;
	Sat, 20 Sep 2025 17:13:23 +0000
Date: Sun, 21 Sep 2025 01:12:24 +0800
From: kernel test robot <lkp@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Chris Mason <chris.mason@fusionio.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 4/4] mm/page_alloc: Batch page freeing in
 free_frozen_page_commit
Message-ID: <202509210003.8eaSRC0k-lkp@intel.com>
References: <20250919195223.1560636-5-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919195223.1560636-5-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3492740005
X-Stat-Signature: mimoxz51ix3ujm9n5sekgmijrj8ya85p
X-HE-Tag: 1758388410-10833
X-HE-Meta: U2FsdGVkX19EhnReTjub3QgDwS+cKpv981d+ut9a8orSks5JWfW44x0Oz2qHLJjpW3FNbQzyFy0Mb9+yzteDJ+fBrMB46Ovc268pTztxMV2rFjhQyekP1EhbjbHMW/kVGToSajRLgzS46+f01ci13Dudf7rzlJdhgTSJv2EYoDSiTh8hdK8gyD+4CPRgVZRL0EnrgBxhHbhTEqGJICth5q3hTsgSxSJ6YoQgMNaJMqaUgFunuGmOVc0qKxeys8EowBgfbiEoWvF5072VXOoMVLYsfaYffP8M3QsQ27ukqmCm7QaeyUh8mGkGGrf2OHGsJieBeu1iVqNtYIWT8JKN82OwwE12kiYxKsmWHrivSeEH6sk7bGVVxbZ5pEG8fCVWw6EtO5acwkA75Ov2D8XYqnsl1/yVHGnpYKT6QBF0NNJtQJUtVx5A2ge9Chpc5p5omi8rPXe7RGY1QYxKCI2XoqFPfdp88SfY69fQivZuyqqFviAqaiD0HDK/Mip7GNjkxRVmG4I6NgBLcLc4pNoPXHtKfmpGAxjpulcZQlPSEWRIesh7AJGgGplBgapJP2Ox3uAExh6eLH5Ur0zlIkKKqagxMCPQzgRdvOzygTZAw8fw1POoq4YmbxS8/uxCFwoJwM2ny6xOnUu4Z6eMsLPqkBjLKO59cFmS/lqqOpxs0LvpVAtbcemdy6sxrWfa61eS+0lfOVDqgzLtcBZS1XhXB2+D9agU5YisauAzsNmxTU9OIGJ8VGt7hKRSGgcb+d3sJjnPLrACOCo1qROQ9jASGelszIvpGo8eAC0QkYvESeKlTfqhUwj+AXL+ipEobJCpI09EH4VoJbRfRzU+hePsvX2I+ZWP51SlHwDfX5SgpLmG5SivGIoTbOo67mVOvxYPYyhoJnDYx+pjNX5qi8oek3TP3L/3YksvZS2fHzKH+lFeaRCPgV6Pa+JWSlun9mi83yfZDyHwBimHWbfoE8P
 tjRapSvf
 Z4hkrbKgXAvzAzO2rqmrRAX/q4v9Uii2m/XAmeJkuSxjsGwtCHHGVg3wI9O6gwvYyaQ5kP5rwW3Zklb07C5/50qVcQrRCOpQEj4C81+346XtOTZt7czPt7xwwTOip/GpTt4nBnWVLyosBKAY7qVf0Y1ySspYBnnJV95g5TINB0DzJPBrnS/RFcM1fcDqY0hHU4VxP505sZb8IAQ/ywzUlNiI1HXVWyw5tveLoXw++ygVGw+N3XD6zput4xJj/gTl1tARvlyo5xq12OaYKWaAzYW3ZgfJYqPMn8N2XJk+gIz6OXLb2JPJ7UXNHI5ImRDBDWQMnFOSXh4/bu1f3mWFBns2SAg785V/UOi/fKFwzeRtaTEkkc/74R3SUrxCVNnwAQC9+OsUenpbqrhtXkPH/t59dvtgK2aCrogap2QV5E2XR3ZkAGmH37JMfSgOboON5e0di3QTYY40B4dI5iud6r7JYsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 097a6c336d0080725c626fda118ecfec448acd0f]

url:    https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-page_alloc-vmstat-Simplify-refresh_cpu_vm_stats-change-detection/20250920-035357
base:   097a6c336d0080725c626fda118ecfec448acd0f
patch link:    https://lore.kernel.org/r/20250919195223.1560636-5-joshua.hahnjy%40gmail.com
patch subject: [PATCH 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit
config: powerpc-taishan_defconfig (https://download.01.org/0day-ci/archive/20250921/202509210003.8eaSRC0k-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250921/202509210003.8eaSRC0k-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509210003.8eaSRC0k-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/page_alloc.c:2891:23: error: use of undeclared identifier 'UP_flags'; did you mean 'fpi_flags'?
    2891 |                         pcp_trylock_finish(UP_flags);
         |                                            ^~~~~~~~
         |                                            fpi_flags
   mm/page_alloc.c:109:53: note: expanded from macro 'pcp_trylock_finish'
     109 | #define pcp_trylock_finish(flags)       local_irq_restore(flags)
         |                                                           ^
   include/linux/irqflags.h:240:61: note: expanded from macro 'local_irq_restore'
     240 | #define local_irq_restore(flags) do { raw_local_irq_restore(flags); } while (0)
         |                                                             ^
   include/linux/irqflags.h:177:28: note: expanded from macro 'raw_local_irq_restore'
     177 |                 typecheck(unsigned long, flags);        \
         |                                          ^
   include/linux/typecheck.h:11:9: note: expanded from macro 'typecheck'
      11 |         typeof(x) __dummy2; \
         |                ^
   mm/page_alloc.c:2833:29: note: 'fpi_flags' declared here
    2833 |                 unsigned int order, fpi_t fpi_flags)
         |                                           ^
>> mm/page_alloc.c:2891:4: warning: comparison of distinct pointer types ('unsigned long *' and 'typeof (fpi_flags) *' (aka 'int *')) [-Wcompare-distinct-pointer-types]
    2891 |                         pcp_trylock_finish(UP_flags);
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/page_alloc.c:109:35: note: expanded from macro 'pcp_trylock_finish'
     109 | #define pcp_trylock_finish(flags)       local_irq_restore(flags)
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/irqflags.h:240:39: note: expanded from macro 'local_irq_restore'
     240 | #define local_irq_restore(flags) do { raw_local_irq_restore(flags); } while (0)
         |                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/irqflags.h:177:3: note: expanded from macro 'raw_local_irq_restore'
     177 |                 typecheck(unsigned long, flags);        \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/typecheck.h:12:18: note: expanded from macro 'typecheck'
      12 |         (void)(&__dummy == &__dummy2); \
         |                ~~~~~~~~ ^  ~~~~~~~~~
   mm/page_alloc.c:2891:23: error: use of undeclared identifier 'UP_flags'; did you mean 'fpi_flags'?
    2891 |                         pcp_trylock_finish(UP_flags);
         |                                            ^~~~~~~~
         |                                            fpi_flags
   mm/page_alloc.c:109:53: note: expanded from macro 'pcp_trylock_finish'
     109 | #define pcp_trylock_finish(flags)       local_irq_restore(flags)
         |                                                           ^
   include/linux/irqflags.h:240:61: note: expanded from macro 'local_irq_restore'
     240 | #define local_irq_restore(flags) do { raw_local_irq_restore(flags); } while (0)
         |                                                             ^
   include/linux/irqflags.h:179:26: note: expanded from macro 'raw_local_irq_restore'
     179 |                 arch_local_irq_restore(flags);          \
         |                                        ^
   mm/page_alloc.c:2833:29: note: 'fpi_flags' declared here
    2833 |                 unsigned int order, fpi_t fpi_flags)
         |                                           ^
   mm/page_alloc.c:2893:24: error: use of undeclared identifier 'UP_flags'; did you mean 'fpi_flags'?
    2893 |                         pcp_trylock_prepare(UP_flags);
         |                                             ^~~~~~~~
         |                                             fpi_flags
   mm/page_alloc.c:108:51: note: expanded from macro 'pcp_trylock_prepare'
     108 | #define pcp_trylock_prepare(flags)      local_irq_save(flags)
         |                                                        ^
   include/linux/irqflags.h:239:55: note: expanded from macro 'local_irq_save'
     239 | #define local_irq_save(flags)   do { raw_local_irq_save(flags); } while (0)
         |                                                         ^
   include/linux/irqflags.h:172:28: note: expanded from macro 'raw_local_irq_save'
     172 |                 typecheck(unsigned long, flags);        \
         |                                          ^
   include/linux/typecheck.h:11:9: note: expanded from macro 'typecheck'
      11 |         typeof(x) __dummy2; \
         |                ^
   mm/page_alloc.c:2833:29: note: 'fpi_flags' declared here
    2833 |                 unsigned int order, fpi_t fpi_flags)
         |                                           ^
   mm/page_alloc.c:2893:4: warning: comparison of distinct pointer types ('unsigned long *' and 'typeof (fpi_flags) *' (aka 'int *')) [-Wcompare-distinct-pointer-types]
    2893 |                         pcp_trylock_prepare(UP_flags);
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/page_alloc.c:108:36: note: expanded from macro 'pcp_trylock_prepare'
     108 | #define pcp_trylock_prepare(flags)      local_irq_save(flags)
         |                                         ^~~~~~~~~~~~~~~~~~~~~
   include/linux/irqflags.h:239:36: note: expanded from macro 'local_irq_save'
     239 | #define local_irq_save(flags)   do { raw_local_irq_save(flags); } while (0)
         |                                      ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/irqflags.h:172:3: note: expanded from macro 'raw_local_irq_save'
     172 |                 typecheck(unsigned long, flags);        \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/typecheck.h:12:18: note: expanded from macro 'typecheck'
      12 |         (void)(&__dummy == &__dummy2); \
         |                ~~~~~~~~ ^  ~~~~~~~~~
   mm/page_alloc.c:2893:24: error: use of undeclared identifier 'UP_flags'
    2893 |                         pcp_trylock_prepare(UP_flags);
         |                                             ^
   mm/page_alloc.c:2896:24: error: use of undeclared identifier 'UP_flags'; did you mean 'fpi_flags'?
    2896 |                                 pcp_trylock_finish(UP_flags);
         |                                                    ^~~~~~~~
         |                                                    fpi_flags
   mm/page_alloc.c:109:53: note: expanded from macro 'pcp_trylock_finish'
     109 | #define pcp_trylock_finish(flags)       local_irq_restore(flags)
         |                                                           ^
   include/linux/irqflags.h:240:61: note: expanded from macro 'local_irq_restore'
     240 | #define local_irq_restore(flags) do { raw_local_irq_restore(flags); } while (0)
         |                                                             ^
   include/linux/irqflags.h:177:28: note: expanded from macro 'raw_local_irq_restore'
     177 |                 typecheck(unsigned long, flags);        \
         |                                          ^
   include/linux/typecheck.h:11:9: note: expanded from macro 'typecheck'
      11 |         typeof(x) __dummy2; \
         |                ^
   mm/page_alloc.c:2833:29: note: 'fpi_flags' declared here
    2833 |                 unsigned int order, fpi_t fpi_flags)
         |                                           ^
   mm/page_alloc.c:2896:5: warning: comparison of distinct pointer types ('unsigned long *' and 'typeof (fpi_flags) *' (aka 'int *')) [-Wcompare-distinct-pointer-types]
    2896 |                                 pcp_trylock_finish(UP_flags);
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/page_alloc.c:109:35: note: expanded from macro 'pcp_trylock_finish'
     109 | #define pcp_trylock_finish(flags)       local_irq_restore(flags)
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/irqflags.h:240:39: note: expanded from macro 'local_irq_restore'
     240 | #define local_irq_restore(flags) do { raw_local_irq_restore(flags); } while (0)
         |                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/irqflags.h:177:3: note: expanded from macro 'raw_local_irq_restore'
     177 |                 typecheck(unsigned long, flags);        \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/typecheck.h:12:18: note: expanded from macro 'typecheck'
      12 |         (void)(&__dummy == &__dummy2); \


vim +2891 mm/page_alloc.c

  2823	
  2824	/*
  2825	 * Tune pcp alloc factor and adjust count & free_count. Free pages to bring the
  2826	 * pcp's watermarks below high.
  2827	 *
  2828	 * May return a freed pcp, if during page freeing the pcp spinlock cannot be
  2829	 * reacquired. Return true if pcp is locked, false otherwise.
  2830	 */
  2831	static bool free_frozen_page_commit(struct zone *zone,
  2832			struct per_cpu_pages *pcp, struct page *page, int migratetype,
  2833			unsigned int order, fpi_t fpi_flags)
  2834	{
  2835		int high, batch;
  2836		int to_free, to_free_batched;
  2837		int pindex;
  2838		bool free_high = false;
  2839	
  2840		/*
  2841		 * On freeing, reduce the number of pages that are batch allocated.
  2842		 * See nr_pcp_alloc() where alloc_factor is increased for subsequent
  2843		 * allocations.
  2844		 */
  2845		pcp->alloc_factor >>= 1;
  2846		__count_vm_events(PGFREE, 1 << order);
  2847		pindex = order_to_pindex(migratetype, order);
  2848		list_add(&page->pcp_list, &pcp->lists[pindex]);
  2849		pcp->count += 1 << order;
  2850	
  2851		batch = READ_ONCE(pcp->batch);
  2852		/*
  2853		 * As high-order pages other than THP's stored on PCP can contribute
  2854		 * to fragmentation, limit the number stored when PCP is heavily
  2855		 * freeing without allocation. The remainder after bulk freeing
  2856		 * stops will be drained from vmstat refresh context.
  2857		 */
  2858		if (order && order <= PAGE_ALLOC_COSTLY_ORDER) {
  2859			free_high = (pcp->free_count >= (batch + pcp->high_min / 2) &&
  2860				     (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) &&
  2861				     (!(pcp->flags & PCPF_FREE_HIGH_BATCH) ||
  2862				      pcp->count >= batch));
  2863			pcp->flags |= PCPF_PREV_FREE_HIGH_ORDER;
  2864		} else if (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) {
  2865			pcp->flags &= ~PCPF_PREV_FREE_HIGH_ORDER;
  2866		}
  2867		if (pcp->free_count < (batch << CONFIG_PCP_BATCH_SCALE_MAX))
  2868			pcp->free_count += (1 << order);
  2869	
  2870		if (unlikely(fpi_flags & FPI_TRYLOCK)) {
  2871			/*
  2872			 * Do not attempt to take a zone lock. Let pcp->count get
  2873			 * over high mark temporarily.
  2874			 */
  2875			return true;
  2876		}
  2877		high = nr_pcp_high(pcp, zone, batch, free_high);
  2878		to_free = nr_pcp_free(pcp, batch, high, free_high);
  2879		while (to_free > 0 && pcp->count >= high) {
  2880			to_free_batched = min(to_free, batch);
  2881			free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
  2882			if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
  2883			    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
  2884					      ZONE_MOVABLE, 0))
  2885				clear_bit(ZONE_BELOW_HIGH, &zone->flags);
  2886	
  2887			high = nr_pcp_high(pcp, zone, batch, free_high);
  2888			to_free -= to_free_batched;
  2889			if (pcp->count >= high) {
  2890				pcp_spin_unlock(pcp);
> 2891				pcp_trylock_finish(UP_flags);
  2892	
  2893				pcp_trylock_prepare(UP_flags);
  2894				pcp = pcp_spin_trylock(zone->per_cpu_pageset);
  2895				if (!pcp) {
  2896					pcp_trylock_finish(UP_flags);
  2897					return false;
  2898				}
  2899			}
  2900		}
  2901	
  2902		return true;
  2903	}
  2904	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

