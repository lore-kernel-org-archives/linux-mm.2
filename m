Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32FDCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 04:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6928E0014; Wed, 15 Oct 2025 00:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E388E0005; Wed, 15 Oct 2025 00:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB648E0014; Wed, 15 Oct 2025 00:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0F68E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:03:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 936FA889C9
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:03:30 +0000 (UTC)
X-FDA: 83999004180.11.E950B4F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4DD8F140007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:03:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PyCQoIin;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760501008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NimySag0Sef5n+/vHjVPAOLkp+NFnfS2H5ZeEqKuVlc=;
	b=dWvWYKx1G+AMO09dthAv3+Ud5X9FRcqrG3EWBbFKezg5Zn1XCyUsZ7Xi/Koseh9z+eeXz0
	W1uwC1/ygW63tP/mMqR5JCopE2KDOOwms7Bx7+AaJiXsofIbgeLZ3fWYQs09PMWhlE9PDy
	GBO4EniZHSwbQHtoOhRzZOdGVTEhHGY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760501008; a=rsa-sha256;
	cv=none;
	b=1Pe+3+DkBQVONkMWESdl7nAbAW86FJk1reEyxuLYaaMX4Rfd1JGR2SWzL2vTq805qUMe7B
	8TO9Wyz2rAc4Y9r36OTZLkgrdfm2oqiZfasTO18m6a/OijgZHxKgHCsYb/Rzul1LWiW1Bg
	A44FvFs5lenhAIG9Q9SuL4BYez/McgY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PyCQoIin;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760501009; x=1792037009;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=egGXa1DVkypUzbzXpr9muh+nr7JIYX1Rgjps9eQtSfU=;
  b=PyCQoIinVOE+p8x63/4uhMVSrv550MtROguOtL6BJiuBLcSNeTjdcPLv
   Qn940/FBmNsNlCiI8aadILH6SWT8KFichDgWCX5ELD01u6mxOKuR+wP6s
   xLq4Zy5twAbULGCDN0EEcznxXCFv1NaUmC/YTXIM231Oho07Wj9N9jf2p
   iVUSlYibOOv5jzlSIkH8yKw3m4aseRbUB5zfuH1OzFFp+l/G0YAo+28+9
   qZYi50yrXyisuJV2ZBA45RUhHi4TfT8jATD+OSPrCALhNOTsHBsqDZ28u
   XCc+D+1WmoeuzanOIgaIeRZC1jnDL7yHNHbgPQYS7epquAwpZARVzgyeI
   w==;
X-CSE-ConnectionGUID: mmJAyB4USSeKrkeJDbPhWw==
X-CSE-MsgGUID: yZDkOiF0QyuExJZPc3UkJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="62375713"
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="62375713"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 21:03:25 -0700
X-CSE-ConnectionGUID: C7IYtpBwQSOimFTAEppubg==
X-CSE-MsgGUID: nt0A1rC7QUexJJNIKSr7Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="182489591"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 14 Oct 2025 21:03:21 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v8sii-0003QL-2j;
	Wed, 15 Oct 2025 04:03:17 +0000
Date: Wed, 15 Oct 2025 11:53:00 +0800
From: kernel test robot <lkp@intel.com>
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: Re: [PATCH v2] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
Message-ID: <202510151108.UqsNiDSP-lkp@intel.com>
References: <20251014151126.87589-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014151126.87589-1-pedrodemargomes@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DD8F140007
X-Rspamd-Server: rspam02
X-Stat-Signature: 9skoser4ne8huwadyzumbkbigaos878h
X-HE-Tag: 1760501008-684401
X-HE-Meta: U2FsdGVkX1+EJ3norApNQR13H+BPh7RjMr6mCKTyDCIgBKWQe4tHVQE8vv2X9y/bDhfU4Mpn1GFlVnmuKbNNboXro+fcWM3dzN+Ix7s7t2oXMTJqONNS+tNRsgjZwtebXZ0+cxAolDMqWG0If88du4ciiaTOPhloQn3ujPwqVZeJgkzRyuJIDzYbI/zQLKKUOmF12H/8/iiHgm7ir/s0pitz2pGNQTwzgggZEnbsq5wuJnzbvWuTURbT5oVe3v0ti+TlD+jpoXkwAMUonbvqj4yqlPM+aDuxAn+BErehsYFbe6aRZNgTaC5G2p4zgaE3chlSm1PQHxzxxOcE4Cfvkh/4WsSTchZMc++bIaDTpmW3S41klxYXxBXrVreXC7kmMSW4WD6bU4s5XT4FDSl9SXHMgJOaUDm2BDCMYyKSSHopLB/jWbJmETLMUTeVniKcN0kIBHCzifXNLyilw0Ifzixfy+iJRrqHT4LBUzPd4H1hbTY3K8UG6yvtoqFIC7Pb/TF12e+2yCdYcPWhrTv8lyAwEv/3Q0Uo3v0oZAMNfILkvuxjX06sNn1nh8wq6Y6eEfw1q5UlkRmCDPIzFU6w06KKu5fv1Bfs7E2EyP8pVzoYMPKiqcoLeA8oROP+UR3RBLGsbLqcGNYmp6wWr8/oeZIM0hLXyzn8FovVTefC6ZFX2CzW4aIsPBeYf++cFnEtyiV2O3QmAcIXuZ4oSsSiwJ6KbkfcE4QONBPIZLPO+FFETv7NvBPD07TTmsGM7MX7dmlIEM0VpMK8t8foJc1vBkTFu9OSaYUD92gCPfOjNjGmGFNirj0fOp7NKBAVZ0g2h6uaADRhYJfgFufLpctCwswq5km+h3sbRJrh/xUDni3rKR5JUhkX+VY8IJvcMFz/LNthBvbEyJd5y/VAdSTPRE1MtK4Ch9dxkKPMvIGaO2iRyHbyhPnDcL9YEvtWg965lsyAmUY+jge/5AA6aTe
 lizAbHtt
 kE5SwYC2xfMH820P/LKWG8mCm693rdITjVmdCrYJmsjmbTcivOkdRRo20lwVgXALkgzE7dkM9wrtiCrzUFZ8UIYOpRKb7Vadf9I71F2WJ1brYmlO4FfFbAQ1HrZyMz6wyVIejVox4gUYxdXATZnvUY3fSXRNkzXPg3Lq7/we9uHN5B6x5utKb95jbjTXmbUUdqQq+kfCJgtYXgtQyGMYKbve7QXanAwzdnF7aK1dVLdzW4zQd8YV3ybg1iEzMD9tRuWJK6fuXIsVGPciYyqe1ziEmYwWYAuIosqvQwWpsb0oxeeGMunYKJAro1nJPpmsX2NqNfSPQT/vbDjdYywt95Yv9np6LMe5lpjeqNQqUoGsY7OiYUzOGGAna1C7rCyOqeUHx2Ra2oXGagrguXSuYwOWvcUaO1XjYtsJOPOqbUj7HZndiUf5KbomZbnY+pgZs/PNkIKGU0PD1ucI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pedro,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.18-rc1 next-20251014]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pedro-Demarchi-Gomes/ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item/20251014-231721
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251014151126.87589-1-pedrodemargomes%40gmail.com
patch subject: [PATCH v2] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
config: m68k-randconfig-r071-20251015 (https://download.01.org/0day-ci/archive/20251015/202510151108.UqsNiDSP-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251015/202510151108.UqsNiDSP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510151108.UqsNiDSP-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/ksm.c: In function 'scan_get_next_rmap_item':
>> mm/ksm.c:2604:2: error: a label can only be part of a statement and a declaration is not a statement
     struct ksm_walk_private walk_private = {
     ^~~~~~


vim +2604 mm/ksm.c

  2527	
  2528	static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
  2529	{
  2530		struct mm_struct *mm;
  2531		struct ksm_mm_slot *mm_slot;
  2532		struct mm_slot *slot;
  2533		struct ksm_rmap_item *rmap_item;
  2534		int nid;
  2535	
  2536		if (list_empty(&ksm_mm_head.slot.mm_node))
  2537			return NULL;
  2538	
  2539		mm_slot = ksm_scan.mm_slot;
  2540		if (mm_slot == &ksm_mm_head) {
  2541			advisor_start_scan();
  2542			trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
  2543	
  2544			/*
  2545			 * A number of pages can hang around indefinitely in per-cpu
  2546			 * LRU cache, raised page count preventing write_protect_page
  2547			 * from merging them.  Though it doesn't really matter much,
  2548			 * it is puzzling to see some stuck in pages_volatile until
  2549			 * other activity jostles them out, and they also prevented
  2550			 * LTP's KSM test from succeeding deterministically; so drain
  2551			 * them here (here rather than on entry to ksm_do_scan(),
  2552			 * so we don't IPI too often when pages_to_scan is set low).
  2553			 */
  2554			lru_add_drain_all();
  2555	
  2556			/*
  2557			 * Whereas stale stable_nodes on the stable_tree itself
  2558			 * get pruned in the regular course of stable_tree_search(),
  2559			 * those moved out to the migrate_nodes list can accumulate:
  2560			 * so prune them once before each full scan.
  2561			 */
  2562			if (!ksm_merge_across_nodes) {
  2563				struct ksm_stable_node *stable_node, *next;
  2564				struct folio *folio;
  2565	
  2566				list_for_each_entry_safe(stable_node, next,
  2567							 &migrate_nodes, list) {
  2568					folio = ksm_get_folio(stable_node,
  2569							      KSM_GET_FOLIO_NOLOCK);
  2570					if (folio)
  2571						folio_put(folio);
  2572					cond_resched();
  2573				}
  2574			}
  2575	
  2576			for (nid = 0; nid < ksm_nr_node_ids; nid++)
  2577				root_unstable_tree[nid] = RB_ROOT;
  2578	
  2579			spin_lock(&ksm_mmlist_lock);
  2580			slot = list_entry(mm_slot->slot.mm_node.next,
  2581					  struct mm_slot, mm_node);
  2582			mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
  2583			ksm_scan.mm_slot = mm_slot;
  2584			spin_unlock(&ksm_mmlist_lock);
  2585			/*
  2586			 * Although we tested list_empty() above, a racing __ksm_exit
  2587			 * of the last mm on the list may have removed it since then.
  2588			 */
  2589			if (mm_slot == &ksm_mm_head)
  2590				return NULL;
  2591	next_mm:
  2592			ksm_scan.address = 0;
  2593			ksm_scan.rmap_list = &mm_slot->rmap_list;
  2594		}
  2595	
  2596		slot = &mm_slot->slot;
  2597		mm = slot->mm;
  2598	
  2599		mmap_read_lock(mm);
  2600		if (ksm_test_exit(mm))
  2601			goto no_vmas;
  2602	
  2603	get_page:
> 2604		struct ksm_walk_private walk_private = {
  2605			.page = NULL,
  2606			.folio = NULL,
  2607			.vma = NULL
  2608		};
  2609	
  2610		walk_page_range(mm, ksm_scan.address, -1, &walk_ops, (void *) &walk_private);
  2611		if (walk_private.page) {
  2612			flush_anon_page(walk_private.vma, walk_private.page, ksm_scan.address);
  2613			flush_dcache_page(walk_private.page);
  2614			rmap_item = get_next_rmap_item(mm_slot,
  2615				ksm_scan.rmap_list, ksm_scan.address);
  2616			if (rmap_item) {
  2617				ksm_scan.rmap_list =
  2618						&rmap_item->rmap_list;
  2619	
  2620				ksm_scan.address += PAGE_SIZE;
  2621				if (should_skip_rmap_item(walk_private.folio, rmap_item)) {
  2622					folio_put(walk_private.folio);
  2623					goto get_page;
  2624				}
  2625	
  2626				*page = walk_private.page;
  2627			} else {
  2628				folio_put(walk_private.folio);
  2629			}
  2630			mmap_read_unlock(mm);
  2631			return rmap_item;
  2632		}
  2633	
  2634		if (ksm_test_exit(mm)) {
  2635	no_vmas:
  2636			ksm_scan.address = 0;
  2637			ksm_scan.rmap_list = &mm_slot->rmap_list;
  2638		}
  2639		/*
  2640		 * Nuke all the rmap_items that are above this current rmap:
  2641		 * because there were no VM_MERGEABLE vmas with such addresses.
  2642		 */
  2643		remove_trailing_rmap_items(ksm_scan.rmap_list);
  2644	
  2645		spin_lock(&ksm_mmlist_lock);
  2646		slot = list_entry(mm_slot->slot.mm_node.next,
  2647				  struct mm_slot, mm_node);
  2648		ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
  2649		if (ksm_scan.address == 0) {
  2650			/*
  2651			 * We've completed a full scan of all vmas, holding mmap_lock
  2652			 * throughout, and found no VM_MERGEABLE: so do the same as
  2653			 * __ksm_exit does to remove this mm from all our lists now.
  2654			 * This applies either when cleaning up after __ksm_exit
  2655			 * (but beware: we can reach here even before __ksm_exit),
  2656			 * or when all VM_MERGEABLE areas have been unmapped (and
  2657			 * mmap_lock then protects against race with MADV_MERGEABLE).
  2658			 */
  2659			hash_del(&mm_slot->slot.hash);
  2660			list_del(&mm_slot->slot.mm_node);
  2661			spin_unlock(&ksm_mmlist_lock);
  2662	
  2663			mm_slot_free(mm_slot_cache, mm_slot);
  2664			/*
  2665			 * Only clear MMF_VM_MERGEABLE. We must not clear
  2666			 * MMF_VM_MERGE_ANY, because for those MMF_VM_MERGE_ANY process,
  2667			 * perhaps their mm_struct has just been added to ksm_mm_slot
  2668			 * list, and its process has not yet officially started running
  2669			 * or has not yet performed mmap/brk to allocate anonymous VMAS.
  2670			 */
  2671			mm_flags_clear(MMF_VM_MERGEABLE, mm);
  2672			mmap_read_unlock(mm);
  2673			mmdrop(mm);
  2674		} else {
  2675			mmap_read_unlock(mm);
  2676			/*
  2677			 * mmap_read_unlock(mm) first because after
  2678			 * spin_unlock(&ksm_mmlist_lock) run, the "mm" may
  2679			 * already have been freed under us by __ksm_exit()
  2680			 * because the "mm_slot" is still hashed and
  2681			 * ksm_scan.mm_slot doesn't point to it anymore.
  2682			 */
  2683			spin_unlock(&ksm_mmlist_lock);
  2684		}
  2685	
  2686		/* Repeat until we've completed scanning the whole list */
  2687		mm_slot = ksm_scan.mm_slot;
  2688		if (mm_slot != &ksm_mm_head)
  2689			goto next_mm;
  2690	
  2691		advisor_stop_scan();
  2692	
  2693		trace_ksm_stop_scan(ksm_scan.seqnr, ksm_rmap_items);
  2694		ksm_scan.seqnr++;
  2695		return NULL;
  2696	}
  2697	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

