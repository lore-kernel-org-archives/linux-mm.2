Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA4CC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 00:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DFFA6B0088; Wed, 19 Aug 2026 20:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B77C6B0095; Wed, 19 Aug 2026 20:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CDA36B0098; Wed, 19 Aug 2026 20:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 033F76B0088
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:52:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F6FAA3157
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:52:14 +0000 (UTC)
X-FDA: 85119821388.13.31081AF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf19.hostedemail.com (Postfix) with ESMTP id CAD321A0005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:52:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=icLQ5TYo;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787187132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6b5BGVyvp/nd91jKtuQNUTUv40z4xf2H4GOX7f1G94=;
	b=wR13U5QfUagmA428Mix1mueyp6Kwerd95jnAass9u8ab4mr7hkt8FhyLzP8vvlnl2XH3Rv
	JEk9s7Pa6RiaFV6dNOkEnl5scGeQk7im0rttuf172KcmKZ7UBbXf1kglRdbHrWYnD9maus
	s8ISUdgDhVv/uZhzVRj+vjPKIMDoDWU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=icLQ5TYo;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787187132;
	b=1tSRPesBQ4F/xR/uvwETBYUUjh128g1B+iBaerdPGtyT308nQRSRN7RZkZMV2jj6rCDm6x
	Cpikhamy5Hg0RTw4zoAN4HMeDim/4A/yYd8DSf/HQI1A/jR+wshfhmq/IVYqtRNg5hn68p
	Rb2XEmTV/QAaEdtoMTnzQRE56FMhZh0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787187132; x=1818723132;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W1CJx4mpvTxeMRfM3r72nkrczXnLqwaeUwQq310Ggtw=;
  b=icLQ5TYofxaEOcWtGEjX/gWTLz7ZWWy9uYcKyaRg6vPjy5MI7mbRwL3i
   oX0JHuUF3oRURC4+cWN8qqgwc2r5EGSUCo5L0nnrcxkSUrJgTUlPhKtwD
   XpMIbj5OXgfeJAyWYeUdWEFs1/33YvSkdHGdDJSFQ1m2WvqnezCrGfm5u
   FZmi3GMHwUOeHlHMx50Oiu0jLRpWERUXXBg3+/ir3ihu+ZMU/q84y/8A7
   bNo67jK7tcYfI9yrtSpmTc3bagO9bFsJhw5RTImcj6gNYI2KR3BwQxKg3
   e+lrcWrjn+nCKei1eF9uQqsN3fsKIh1PWKsGRKTkFt4BgjVKoNbBW/g7S
   Q==;
X-CSE-ConnectionGUID: gmtkgPdTQYiW/iHDzReE6A==
X-CSE-MsgGUID: E5G2uNafRZ+Nelj6PJ8D3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="91524249"
X-IronPort-AV: E=Sophos;i="6.25,232,1779174000"; 
   d="scan'208";a="91524249"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 17:52:11 -0700
X-CSE-ConnectionGUID: kc4/KrlOQnycyhcFx5I9yg==
X-CSE-MsgGUID: t9vMTmQCRfqG4FeO5dHIug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,232,1779174000"; 
   d="scan'208";a="266370907"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 19 Aug 2026 17:52:07 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wwr0n-00000000hBR-126e;
	Thu, 20 Aug 2026 00:52:05 +0000
Date: Thu, 20 Aug 2026 08:51:18 +0800
From: kernel test robot <lkp@intel.com>
To: dayou5941@163.com, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, ziy@nvidia.com,
	linux-mm@kvack.org, Li Youhong <liyouhong@kylinos.cn>,
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory-failure: fix concurrent access issue in
 min_order_for_split()
Message-ID: <202608200820.y1lwo7dj-lkp@intel.com>
References: <20260805084224.2597547-1-dayou5941@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805084224.2597547-1-dayou5941@163.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CAD321A0005
X-Stat-Signature: mhf874q76sgfh6dyjuh1okkb5co7shro
X-Rspam-User: 
X-HE-Tag: 1787187131-93864
X-HE-Meta: U2FsdGVkX1917kygCoMzBarH4MnjSBDzUHTHjwaP1PEHqd/XlAvX90cg0MIL44kYXy/Na7tzXIhrjnvC4KviDEXd1L1hl9V3xzvU+uLLZoTmRWNQujg2ULhLRHZ1F590EvseY//rM6gnsw/elsFKs+WoY7JEMxcSLveFCkGLXKVNaLmHk7LQ1/3m4okIWkdPHlAIwlYpfUUqYSyOjEcIQPJZSOldNFdKBU6bTNXlH14R8JKlxN0LKAu9PHQURokNefP/eJz8YieXtlJF6J5eLdObt5UZ7k2F3PZhSS7uyW+kzbEKt9Mc+rSK84kQ8GPfa8jzfykhvroV5JeLjCN/3eIOpKmpcz2mWpNRktBYikQPyksJwhIWE/WqS2yU1ZEOIsgPwMw5yX0Jl5qPzKrsisbVE5z4NYeMBAvch+W73xX4ldkJK07+G0ddyN87iafFCtyEdcqs37bRg/QUbThiNZZrkWZOnGy23lGOIWEUQ3TqsuGv6KAAoSu94uwTIy558E3VQ9Fnfmat2g6k+/lqSaV3NxJVaBYvV7C94MAzOyA4j74uMtPsjsoCd5N0YblQt+B/V3xmJliosDREDOWU2byCxkgppjba2Gmt7yphRrBmM16OHbpVGGh4tIdYLsrIye0PqWvW3SzieOZMCXV9IQJeJ18X1uqgKBAPhZ8efJmTcdb1mdJ2Vyj+Z1gYLrgA0b7VxTHISccsvIPx47cWIKp5ZT55Fswj6g+sCGFw4sry8iYl6lEC0RfU58iCDLWe68J4kUK2c+SAco3m9Y+hqcxM4fhOr48paHdZQ51v626WjXmObtvfezZjzbm8ZsdN2+Y8pOb/bEf+VmrtHg9/oVOVtttTXYClYYnMxobvXvembGwZxnBIp8ae2SJ2Qp6EutvYsZPsLBheqAzPefqNSPuTHaos5o0vWN9Ba4JUm5ws/uppNoX2xJG073E0PC0F68ewwaIyX+SNNOdm5QC
 pprfyFVZ
 1DaVJ9mXqRNEtYySNX6G78yHOKNo5bqvxzg6G9+9hNhfaSUHsRolWZEHZd6Xz6VhyvLTAaXf/TuI438od1Pu8Buh9QAxWVqgXJk1jPTcaSXV/SBATX8oGDd60pv3RXOz+J6THVVi2FFjQzfYCDSaFB3cKRKhbYihgH2eZxfHm8W8nWHzsUgD08DIK3c3128Ymx7v2XROGcsE2ZMMxOV5WqJZ9wbLT/Ls418iWplh6LeAmYfNH16rvqYP923YUotNgcQTrdmawcT2CcWmDZEKRn15itdMGFAtLpDWOfIRBEaTST2IFxjdeh2ISB7PvPvLjdcdqWY1EQDfwOq9VBN1qOuw4Q976Jsihvg3G8k8MrlPTOe2HpoAfY4jDFbJdSJNwSlbVZukBVY+Pkq7+XrKj0e7Coj34MUUTNJN61A92nS9YA/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/dayou5941-163-com/mm-memory-failure-fix-concurrent-access-issue-in-min_order_for_split/20260805-164224
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260805084224.2597547-1-dayou5941%40163.com
patch subject: [PATCH v3] mm/memory-failure: fix concurrent access issue in min_order_for_split()
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260820/202608200820.y1lwo7dj-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260820/202608200820.y1lwo7dj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608200820.y1lwo7dj-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/memory-failure.c:2517:13: error: cannot assign to variable 'new_order' with const-qualified type 'const int'
    2517 |                 new_order = min_order_for_split(folio);
         |                 ~~~~~~~~~ ^
   mm/memory-failure.c:2513:13: note: variable 'new_order' declared const here
    2513 |                 const int new_order;
         |                 ~~~~~~~~~~^~~~~~~~~
   mm/memory-failure.c:2873:13: error: cannot assign to variable 'new_order' with const-qualified type 'const int'
    2873 |                 new_order = min_order_for_split(folio);
         |                 ~~~~~~~~~ ^
   mm/memory-failure.c:2870:13: note: variable 'new_order' declared const here
    2870 |                 const int new_order;
         |                 ~~~~~~~~~~^~~~~~~~~
   2 errors generated.


vim +2517 mm/memory-failure.c

  2360	
  2361	/**
  2362	 * memory_failure - Handle memory failure of a page.
  2363	 * @pfn: Page Number of the corrupted page
  2364	 * @flags: fine tune action taken
  2365	 *
  2366	 * This function is called by the low level machine check code
  2367	 * of an architecture when it detects hardware memory corruption
  2368	 * of a page. It tries its best to recover, which includes
  2369	 * dropping pages, killing processes etc.
  2370	 *
  2371	 * The function is primarily of use for corruptions that
  2372	 * happen outside the current execution context (e.g. when
  2373	 * detected by a background scrubber)
  2374	 *
  2375	 * Must run in process context (e.g. a work queue) with interrupts
  2376	 * enabled and no spinlocks held.
  2377	 *
  2378	 * Return:
  2379	 *   0             - success,
  2380	 *   -ENXIO        - memory not managed by the kernel
  2381	 *   -EOPNOTSUPP   - hwpoison_filter() filtered the error event,
  2382	 *   -EHWPOISON    - the page was already poisoned, potentially
  2383	 *                   kill process,
  2384	 *   other negative values - failure.
  2385	 */
  2386	int memory_failure(unsigned long pfn, int flags)
  2387	{
  2388		struct page *p;
  2389		struct folio *folio;
  2390		struct dev_pagemap *pgmap;
  2391		int res = 0;
  2392		unsigned long page_flags;
  2393		bool retry = true;
  2394	
  2395		if (!sysctl_memory_failure_recovery)
  2396			panic("Memory failure on page %lx", pfn);
  2397	
  2398		mutex_lock(&mf_mutex);
  2399	
  2400		if (!(flags & MF_SW_SIMULATED))
  2401			hw_memory_failure = true;
  2402	
  2403		p = pfn_to_online_page(pfn);
  2404		if (!p) {
  2405			res = arch_memory_failure(pfn, flags);
  2406			if (res == 0)
  2407				goto unlock_mutex;
  2408	
  2409			if (!pfn_valid(pfn) && !arch_is_platform_page(PFN_PHYS(pfn))) {
  2410				/*
  2411				 * The PFN is not backed by struct page.
  2412				 */
  2413				res = memory_failure_pfn(pfn, flags);
  2414				goto unlock_mutex;
  2415			}
  2416	
  2417			if (pfn_valid(pfn)) {
  2418				pgmap = get_dev_pagemap(pfn);
  2419				put_ref_page(pfn, flags);
  2420				if (pgmap) {
  2421					res = memory_failure_dev_pagemap(pfn, flags,
  2422									 pgmap);
  2423					goto unlock_mutex;
  2424				}
  2425			}
  2426			pr_err("%#lx: memory outside kernel control\n", pfn);
  2427			res = -ENXIO;
  2428			goto unlock_mutex;
  2429		}
  2430	
  2431	try_again:
  2432		res = try_memory_failure_hugetlb(pfn, flags);
  2433		/*
  2434		 * -ENOENT means the page we found is not hugetlb, so proceed with normal page handling
  2435		 */
  2436		if (res != -ENOENT)
  2437			goto unlock_mutex;
  2438	
  2439		if (TestSetPageHWPoison(p)) {
  2440			res = -EHWPOISON;
  2441			if (flags & MF_ACTION_REQUIRED)
  2442				res = kill_accessing_process(current, pfn, flags);
  2443			if (flags & MF_COUNT_INCREASED)
  2444				put_page(p);
  2445			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
  2446			goto unlock_mutex;
  2447		}
  2448	
  2449		/*
  2450		 * We need/can do nothing about count=0 pages.
  2451		 * 1) it's a free page, and therefore in safe hand:
  2452		 *    check_new_page() will be the gate keeper.
  2453		 * 2) it's part of a non-compound high order page.
  2454		 *    Implies some kernel user: cannot stop them from
  2455		 *    R/W the page; let's pray that the page has been
  2456		 *    used and will be freed some time later.
  2457		 * In fact it's dangerous to directly bump up page count from 0,
  2458		 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
  2459		 */
  2460		res = get_hwpoison_page(p, flags);
  2461		switch (res) {
  2462		case 0:
  2463			if (is_free_buddy_page(p)) {
  2464				if (take_page_off_buddy(p)) {
  2465					page_ref_inc(p);
  2466					res = MF_RECOVERED;
  2467				} else {
  2468					/* We lost the race, try again */
  2469					if (retry) {
  2470						ClearPageHWPoison(p);
  2471						retry = false;
  2472						goto try_again;
  2473					}
  2474					res = MF_FAILED;
  2475				}
  2476				res = action_result(pfn, MF_MSG_BUDDY, res);
  2477			} else {
  2478				res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
  2479			}
  2480			goto unlock_mutex;
  2481		case 1:
  2482			/* Got a refcount on a handlable page. */
  2483			break;
  2484		case -ENOTRECOVERABLE:
  2485			/*
  2486			 * Stable unhandlable kernel-owned page (PG_reserved,
  2487			 * slab, page tables, large-kmalloc).
  2488			 * No recovery possible.
  2489			 */
  2490			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
  2491			goto unlock_mutex;
  2492		default:
  2493			/* Transient lifecycle race with the page allocator. */
  2494			res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
  2495			goto unlock_mutex;
  2496		}
  2497	
  2498		folio = page_folio(p);
  2499	
  2500		/* filter pages that are protected from hwpoison test by users */
  2501		folio_lock(folio);
  2502		if (hwpoison_filter(p)) {
  2503			ClearPageHWPoison(p);
  2504			folio_unlock(folio);
  2505			folio_put(folio);
  2506			res = -EOPNOTSUPP;
  2507			goto unlock_mutex;
  2508		}
  2509	
  2510		folio_unlock(folio);
  2511	
  2512		if (folio_test_large(folio)) {
  2513			const int new_order;
  2514			int err;
  2515	
  2516			folio_lock(folio);
> 2517			new_order = min_order_for_split(folio);
  2518			folio_unlock(folio);
  2519	
  2520			/*
  2521			 * The flag must be set after the refcount is bumped
  2522			 * otherwise it may race with THP split.
  2523			 * And the flag can't be set in get_hwpoison_page() since
  2524			 * it is called by soft offline too and it is just called
  2525			 * for !MF_COUNT_INCREASED.  So here seems to be the best
  2526			 * place.
  2527			 *
  2528			 * Don't need care about the above error handling paths for
  2529			 * get_hwpoison_page() since they handle either free page
  2530			 * or unhandlable page.  The refcount is bumped iff the
  2531			 * page is a valid handlable page.
  2532			 */
  2533			folio_set_has_hwpoisoned(folio);
  2534			err = try_to_split_thp_page(p, new_order, /* release= */ false);
  2535			/*
  2536			 * If splitting a folio to order-0 fails, kill the process.
  2537			 * Split the folio regardless to minimize unusable pages.
  2538			 * Because the memory failure code cannot handle large
  2539			 * folios, this split is always treated as if it failed.
  2540			 */
  2541			if (err || new_order) {
  2542				/* get folio again in case the original one is split */
  2543				folio = page_folio(p);
  2544				res = -EHWPOISON;
  2545				kill_procs_now(p, pfn, flags, folio);
  2546				put_page(p);
  2547				action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
  2548				goto unlock_mutex;
  2549			}
  2550			VM_BUG_ON_PAGE(!page_count(p), p);
  2551			folio = page_folio(p);
  2552		}
  2553	
  2554		/*
  2555		 * We ignore non-LRU pages for good reasons.
  2556		 * - PG_locked is only well defined for LRU pages and a few others
  2557		 * - to avoid races with __SetPageLocked()
  2558		 * - to avoid races with __SetPageSlab*() (and more non-atomic ops)
  2559		 * The check (unnecessarily) ignores LRU pages being isolated and
  2560		 * walked by the page reclaim code, however that's not a big loss.
  2561		 */
  2562		shake_folio(folio);
  2563	
  2564		folio_lock(folio);
  2565	
  2566		/*
  2567		 * We're only intended to deal with the non-Compound page here.
  2568		 * The page cannot become compound pages again as folio has been
  2569		 * splited and extra refcnt is held.
  2570		 */
  2571		WARN_ON(folio_test_large(folio));
  2572	
  2573		/*
  2574		 * We use page flags to determine what action should be taken, but
  2575		 * the flags can be modified by the error containment action.  One
  2576		 * example is an mlocked page, where PG_mlocked is cleared by
  2577		 * folio_remove_rmap_*() in try_to_unmap_one(). So to determine page
  2578		 * status correctly, we save a copy of the page flags at this time.
  2579		 */
  2580		page_flags = folio->flags.f;
  2581	
  2582		/*
  2583		 * __munlock_folio() may clear a writeback folio's LRU flag without
  2584		 * the folio lock. We need to wait for writeback completion for this
  2585		 * folio or it may trigger a vfs BUG while evicting inode.
  2586		 */
  2587		if (!folio_test_lru(folio) && !folio_test_writeback(folio))
  2588			goto identify_page_state;
  2589	
  2590		/*
  2591		 * It's very difficult to mess with pages currently under IO
  2592		 * and in many cases impossible, so we just avoid it here.
  2593		 */
  2594		folio_wait_writeback(folio);
  2595	
  2596		/*
  2597		 * Now take care of user space mappings.
  2598		 * Abort on fail: __filemap_remove_folio() assumes unmapped page.
  2599		 */
  2600		if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
  2601			res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED);
  2602			goto unlock_page;
  2603		}
  2604	
  2605		/*
  2606		 * Torn down by someone else?
  2607		 */
  2608		if (folio_test_lru(folio) && !folio_test_swapcache(folio) &&
  2609		    folio->mapping == NULL) {
  2610			res = action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
  2611			goto unlock_page;
  2612		}
  2613	
  2614	identify_page_state:
  2615		res = identify_page_state(pfn, p, page_flags);
  2616		mutex_unlock(&mf_mutex);
  2617		return res;
  2618	unlock_page:
  2619		folio_unlock(folio);
  2620	unlock_mutex:
  2621		mutex_unlock(&mf_mutex);
  2622		return res;
  2623	}
  2624	EXPORT_SYMBOL_GPL(memory_failure);
  2625	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

