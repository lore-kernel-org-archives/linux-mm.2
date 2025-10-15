Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72077CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 05:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1C08E0008; Wed, 15 Oct 2025 01:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52038E0003; Wed, 15 Oct 2025 01:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F0E8E0008; Wed, 15 Oct 2025 01:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A93938E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:47:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CEC247AB3
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:47:12 +0000 (UTC)
X-FDA: 83999265504.11.434876E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC6A120008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:47:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kxtB0kA7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760507230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abz9pwXegKguH4pVbCsCgnT0bKKxyI1Zwc/i0KAN2Dk=;
	b=3Mp2IRgXuxe7O1smoYTjIhF8BhMcJmwlwo3ZM2wIq/wqx9hC4gw7of0F6yoSjZy71OA5e7
	Rq/FzUQ7ADWd8TsEfPkxyAtsb2ljGMSuTVofmtfIWTYB9VB7gUL8D8nDyPT5wZQfk1H7c3
	ZwHDsax9gvDsk86/seNmWBrnhXJRW0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760507230; a=rsa-sha256;
	cv=none;
	b=38KxqR1akntZPbyBBsJHBxu/tjevxjOBL3Um1zyCkpkf1++1afeBIaziW/gB/pcMOW9Xju
	i4i2+vJ9HHLyOzn7FgY3BOHZCJ7xZKJ7e/ygKmEzteljR3AH9rKoruT9/2eiXc8UujG9ZU
	x33m8/uZ26g+sd6+UFXYXtqsLD7N4Qo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kxtB0kA7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760507230; x=1792043230;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MYfl7HglXJhcnj6wgQtpZ6h2FIItm3ZGsGiqPO19MYA=;
  b=kxtB0kA7ger+yUyq1/R02LbPkPmNfNyVwptGlhvVQQ/f4z67nIiFnLRZ
   QWguE8SLfHKAcW7J6To1TKSmr49XAYDszWI612XPDqulQKRGCfewxOYES
   4IHRniPdvEQdh8VBgb5O+zmQwN0dCmhquI01GsDG06NfDQO5d1dVTfAOa
   29zs2O3UcwB7efRHigll5YpfCTNAv1VwZBVd8UWdd55o6YeR2XdEMzzKN
   iIBqMpa0cpCYDbY2+R9KFLo/5wIH6HXMbQr/nZJx8E0noMb8dI9FisIaE
   lfx5KurrwF1b6RqHpNu0jo6KtW7tNhdcKnWp7z01TLIJHSLJ4MmfHZZCE
   A==;
X-CSE-ConnectionGUID: XYm9XKKyTwG05jkEbnyQ2Q==
X-CSE-MsgGUID: zO49Fb/gQ3uTlD6eqa21dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="50238389"
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="50238389"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 22:47:08 -0700
X-CSE-ConnectionGUID: xwQu8lhvTje6lV03kfeu8w==
X-CSE-MsgGUID: 7KGptdEKQo2HatExJrjPyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="187166294"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 14 Oct 2025 22:47:06 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v8uLk-0003V0-1H;
	Wed, 15 Oct 2025 05:47:01 +0000
Date: Wed, 15 Oct 2025 13:46:26 +0800
From: kernel test robot <lkp@intel.com>
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: Re: [PATCH v2] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
Message-ID: <202510151358.YFw4KsDG-lkp@intel.com>
References: <20251014151126.87589-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014151126.87589-1-pedrodemargomes@gmail.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: xfzh4ptyjibosbc96ohtpwt3jyh76tmp
X-Rspam-User: 
X-Rspamd-Queue-Id: DC6A120008
X-HE-Tag: 1760507229-711785
X-HE-Meta: U2FsdGVkX19TKOOblsp9BxCUxs9LPhymN4OA34sGlyijZZ6UdNjTE6jisn7QTkjMigE157RgFb0q4n6Xt3Uzr3WEBDgIf2pC8bXqp7qfqFQZG9SH0ZOQhAwn/kECQ2mbRo1vQq4JcXYEcwiAR+0UML/rDsbm6kKrC7HB1Yx2cGhzAk6oyytdFj8EsIR4kmoocKUEOR/4LEWBZDrostApKPtrKJEuV/JgVG6lnLmgaUFwctlb0mI//VRg6kz2pC3mIWS/maaOxS/3BVWkMWO1fh6OoaVedOspziLRHouIwpBKMndxCnZA/BhVyU0INqilDQtHHWo7KKLZDxgmRKxzrsk+15EzahUP8lOHHI/eC93goEi6ouu5hHlCdPoMqzi2H+6LFFwYIMJXpow1elYj11+QQAtXZew62+VkQoHva65HzXKz5av47PyoXFKslAEcDT7q+05XZys5fD8gJinCFj9FURqlmc43y5gAPvWgmqIFcflrxUfSrNKWzM9lrUNejErELdvuhm3mdizNsD/aVbYuDhDVZGsuslrdK+G5duTyMWslWK/G7i0QHENnOZrtx3XkV6wkE2xpjFkTswtG6bttm6fFH5tti9k3Svyd2O75io8flWQtdK+0a7qCkjNRDsGqgDjVLG1uiAGEhn0wzR5bSfxCXOTv8OPev2iohxZWd0h5KWIutGvMKko7uZT9/yLl+NCchtVmccyXHJ/sllX58gC8PQ3ujInsESY/abes9zK3lDZZTBIspEC/4KG2snaS3KK0Q18jPOsg64yk7i6DGyMvg54PkmrVLh7d8zIOJaZ1KnF+jXQe0000yNduH6aLpzUuUjwHUXk0Y7uUBdcycpfMsSc3HeWLlcrCJtdEZ0TtbGvsdJQCkbFb44+8sR96PnF/whyoXoyv/HsNXx/YL1KJpoZn1xCoNx6dWHRtIEU/D4AwUDsEXpDXpfOXXKiWoMS5CizawRHHlvq
 2t8Qkv26
 oENnTfWfA+/7lkZ/xGW2O9kc1ZmCFRZCjDJMHPuzELzikVY1Sj2p2zxUGLjgccxWyy6I1xHz21KhihFkHMaEqNkpEkgRKGYARCIfTXOTMAiCIYiV+ijBKwHItzxs9VTU7jAMb8EkqGRlG0q9KO3bP9YuzA4Q4IvhOyD4wU7We0kQRQnpKBOYkdmyXh0YKwoKPKFCx67QXJ+ZCo90If7m6LDjSBQZCCoE/B+6j/V5qrmCSQSCIzXd1Pz/S4l1kYmREoOVdhpQlEQY1ABTzVpgR5v97sXnd7g1dI/XGO23kGY8lfZdfW2E1+wm11BEV4RVoUPi02dW5pvXFhUMvEhtQLgfQKSkQm+FZSr6kaXegvXnZPEF9SOzEJSw5q3J/vxYTATBCtUkd0q1rqzjNY5cLYXGmUO43JGWDlTjx0aTvQtFywu4XHdPdKrPm/bLcXWlFV3beRW2E4tB6S3M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pedro,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v6.18-rc1 next-20251014]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pedro-Demarchi-Gomes/ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item/20251014-231721
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251014151126.87589-1-pedrodemargomes%40gmail.com
patch subject: [PATCH v2] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
config: riscv-randconfig-002-20251015 (https://download.01.org/0day-ci/archive/20251015/202510151358.YFw4KsDG-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 39f292ffa13d7ca0d1edff27ac8fd55024bb4d19)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251015/202510151358.YFw4KsDG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510151358.YFw4KsDG-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/ksm.c:2604:2: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
    2604 |         struct ksm_walk_private walk_private = {
         |         ^
   1 warning generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for ARCH_HAS_ELF_CORE_EFLAGS
   Depends on [n]: BINFMT_ELF [=n] && ELF_CORE [=n]
   Selected by [y]:
   - RISCV [=y]


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

