Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 321D8CAC5A5
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 14:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E438E0003; Sat, 20 Sep 2025 10:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226058E0001; Sat, 20 Sep 2025 10:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7698E0003; Sat, 20 Sep 2025 10:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F146C8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 10:42:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB234138DC2
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 14:42:15 +0000 (UTC)
X-FDA: 83909893830.17.741ED74
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id D8066A0006
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 14:42:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UUxWlF70;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758379333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0wDsBuRq2H6RQQ9AH8G/m5FVgcbt+DyTV3Ew8ONCQk=;
	b=ifu/Wsi5tRLuq1LGtoBAQ4Le1fPu6cGqITTazANgdkATFD+qol95SE+MaHeUsYmtf1K4VK
	DoIJG5rk+ZzYegK/kdugvvfFyE0q1gd9gQa+opD2UmJZgtb4I9eqjBweIUvHWyXu9yyEoZ
	448ql/GPaJ23a63rQEqDgX5zak0oXjs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UUxWlF70;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758379333; a=rsa-sha256;
	cv=none;
	b=c5eLNxjGySGIa1sr08QSpf7h5kI6ZfBruhHPduLICIhE0LigyUt1YU2RqwIad0gRdwPVnZ
	tHDTQ4fNO8JoREfQEzLsUUa4+y3aleLvhVokQ5I/ox+o9WSoxqiB3S37LeWUQr2gu+/PeM
	jXBXUCV0uTDSFoIui3x4qwG56vRyJQY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758379333; x=1789915333;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mYEMBMY00zG8bw7SRkHiUSAmc6oUqyQZi0XqD7c7Phs=;
  b=UUxWlF70+h43saWnZGzD+BHVtJoU4BiJyYLj3JOOJ0v9m+2+gjvDQKo2
   qnlTegNmNLEWgDu/pz5LX2ezlVmSAVUM9vOiNfBJIfX7y0hpAjhQr4utZ
   Dj8wr7Rpi9TVknovWQz62gnrMIIQ/Zlm1EETbVnCq4/rmXjO1lbetNxi6
   iWtjEC6DTwX+O/CWpg5uanHwE0XZnYvNfuQ9wi1/ncdLlLJcpyJNVXTqv
   jWUwLTqPuaxYwjms5zx0Xhh9MLBmldLbSHSrd/bUNHGFFLJWfQ8PYpgG+
   gjuYwdbrmILrWZzsPOpbq/C9hNp9pXiqMu8DWhXTaJKj+NxnClzpcLBmG
   A==;
X-CSE-ConnectionGUID: DCzCO0p6ScWjobhPmmyLow==
X-CSE-MsgGUID: JRlQ3qhSSpmuDTGj8Z2jFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11559"; a="72131531"
X-IronPort-AV: E=Sophos;i="6.18,281,1751266800"; 
   d="scan'208";a="72131531"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2025 07:42:11 -0700
X-CSE-ConnectionGUID: G0MuOP/TSMqQsW5gXH8ukg==
X-CSE-MsgGUID: 46w8oVIuTPqFBpu6EoKOlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,281,1751266800"; 
   d="scan'208";a="176131374"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 20 Sep 2025 07:42:07 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uzymq-0005O3-0u;
	Sat, 20 Sep 2025 14:42:04 +0000
Date: Sat, 20 Sep 2025 22:41:48 +0800
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
Message-ID: <202509202221.bpQxfR5E-lkp@intel.com>
References: <20250919195223.1560636-5-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919195223.1560636-5-joshua.hahnjy@gmail.com>
X-Rspamd-Queue-Id: D8066A0006
X-Stat-Signature: dsz617kkzo6mj3b393k763i3agpeor56
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758379332-537840
X-HE-Meta: U2FsdGVkX19C4TQVTluSyCS58Eb5TsTg+aaVnMFUliXEUKapfwWLO3trnvJlmbNyh0MC1Bu+JR9b6LspB7y9de2d508C4tRJmRc6HFCb6YpfO9ueIJoHF0QQq8IwFrTrfINt3yijsv+W3jnESJZo6oQbK+vwqLzp/QNGuXE8CxUElJ2jlFn73S4/C0KTyR9TTWiM/kblDT904F3LUStTSNoC9ae0bv9kB1ocWLak7gM+UZTBjKBGPwSHD2jbO7OPkZ+8whnoAYOFUgdz2G5XA2wAbZr1kXkoMxCAuAeoGBDF+qeSpCWFbur2AMoT99053uD1zgTe0l0mPX6VkChgexYqIgI9ElCqn27woXRTSsitSZ2ySQxRscOTVAfYS2dxE6RAFZyCGUxiEqJgsP4P7LmHiY61GB5EaXRrJQQZ31GLqLl5NW+mz79xcUbq4i+AsF1/vI42Z9B7VbqCGI5tN2FgOuBswo4/xjkeDUrXSO+7Sxt3KD8yFQOb3/zgoXPjXEpVZtq9g78Ai1CDXM6vvSEn1ulPpgSvZcbr82IubxakgySxWkHenTspj1ZTEudAqJbKOGeGYq0JzY5A0y6bdfiUvYrYKYMe0An3uqIH+9h2Kx7OYSkNhihWvMydLsfR/h/UimVKsU6V2Kh6wiXmswjPe/TJ1A14WkRGuxfYcv8bx2JFVIxzrU31TgKgbzC62a61WI94GPJolle5noWsCysS1ePy7MnQ3hcu6XHoSkoAlDPeGEU2s2SB88wt7u9gRoXSSQCM41CaRlejSYTjAxxWP/bLOZN9PiKyPmyDNhqLJGEppaRJDgXoyChIO6hoH5D4GJA35U8CPml4xgjGoaEmG6svavrKrDjUCNH0ZKhBF3qegtJ/O2/MSlCoYHCbOJG88wtMIC2jloekWsYGu6as/TFRSUAOZr1LK7R2Us4KHKOGhkaWqLFle6U9vij8nr9ehgHHwnyH9IwIE2W
 UqAkWtM+
 kZcMvKc7Du7AVPykQA9PLdFDylvB4TcDsnEQntibcECiTc6ez4x5TRpOBj5kQoI6/kd7UuxgKBqIEMtE+Sp7TKPIc/FQuS6tNMQCMX2Kks/NVlDdCEkPNR9cpbaYuniGerwZUIOzo9vrJR6LGk1vxkxeXPmvK2aEMCS5ZY6mduO0FWEJ+0yusTR+QTkldXOpAOO9gleyGJtexbL+f7BLEP61HMziwjFQ+wqKcHa68xAFUZbAurBOuU7h04kz+Ew9H9emCHwWTIT1sev0A2DFGv39nzKhG/u6l9skz5egLRS50YKNY5KPfdYzlHq/PVDGPFn/1HDBhhbajxDAiSADTXOs0Ck03HSLdrwjN1lKl9TXaoDIp6J4nb/QCu1SyBTBTTJ7faiI1J2yyKR2Qgi/4qzc+w3/2jAHFqcu3B36ZXSLzMYVnazaEi7cuJmrMzFE+GfecH8q2vQuCHuVIt91o7i/jsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

kernel test robot noticed the following build errors:

[auto build test ERROR on 097a6c336d0080725c626fda118ecfec448acd0f]

url:    https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-page_alloc-vmstat-Simplify-refresh_cpu_vm_stats-change-detection/20250920-035357
base:   097a6c336d0080725c626fda118ecfec448acd0f
patch link:    https://lore.kernel.org/r/20250919195223.1560636-5-joshua.hahnjy%40gmail.com
patch subject: [PATCH 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit
config: x86_64-buildonly-randconfig-003-20250920 (https://download.01.org/0day-ci/archive/20250920/202509202221.bpQxfR5E-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250920/202509202221.bpQxfR5E-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509202221.bpQxfR5E-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/page_alloc.c:2891:23: error: use of undeclared identifier 'UP_flags'
    2891 |                         pcp_trylock_finish(UP_flags);
         |                                            ^
>> mm/page_alloc.c:2891:23: error: use of undeclared identifier 'UP_flags'
   mm/page_alloc.c:2893:24: error: use of undeclared identifier 'UP_flags'
    2893 |                         pcp_trylock_prepare(UP_flags);
         |                                             ^
   mm/page_alloc.c:2893:24: error: use of undeclared identifier 'UP_flags'
   mm/page_alloc.c:2896:24: error: use of undeclared identifier 'UP_flags'
    2896 |                                 pcp_trylock_finish(UP_flags);
         |                                                    ^
   mm/page_alloc.c:2896:24: error: use of undeclared identifier 'UP_flags'
   6 errors generated.


vim +/UP_flags +2891 mm/page_alloc.c

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

