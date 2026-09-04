Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378C3C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 13:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432206B0088; Fri,  4 Sep 2026 09:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4036B008A; Fri,  4 Sep 2026 09:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F95A6B008C; Fri,  4 Sep 2026 09:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05EF66B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:37:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88BC3A094E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:37:33 +0000 (UTC)
X-FDA: 85176181986.23.F2DB64D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7E77114000C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:37:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mUSmphVV;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788529051;
	b=wqf7JYBawh43zWVQ5Ze+ZjUR80l1Wn/QFKMDECEQqrcq2vJ7+tC/qHsb8/QNc2cxuxzzwj
	RxjimlCMAQEzOvnommro/Q/dkPXJNAMN/LwhW1g9PEkG0o+hu2EnJmnjV4mics4FpZ9mmS
	gWhn71NVyupwYBBSFoL4p4QY+0kg3Qk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mUSmphVV;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788529051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=LA4BcyPGk3+hCItIRyvN1qJMNqXvX82wv8Mm3ndUWaE=;
	b=hJGbge8OKJ2zrqd6ZRXzjLngB1a8v7ylsf08bYx78lwqgdQ7kCqm7UPcRilK2NJZi8k9GF
	zM2YUQs1ZNB/ciQ+lA4pn+Ur2W3TO2wKIOO2WGE3MLwApE3TaKnXB8cxIJuyplS25ehwwK
	1Ja6nBbBMD0nPjsGvwuKvkbh6Ir+klo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788529050; x=1820065050;
  h=date:from:to:cc:subject:message-id;
  bh=FFhPNocyWoRlevwMBqguZAZZpXfJxpMrsibk/N2s+KA=;
  b=mUSmphVVjXdVCRyzyaQymAD/PYse196H9nPCxQKfczP2NO0lmnYGlZNR
   tXwOWEM2gRebelCKdAh3r0ksqjJOmGKn6+wUiGx/hShxKxTRTtctQ72Aw
   9NqEdVD7QPGKzU+s5l5uvTCSGUxNnmcotyTXURIBxqUlGKiLONMRB/UXn
   PWe8rk4B7GM3ZhNcuChLaZf6789Gf4BiOkufeSxqKsu8mSiPGQz3T/rlO
   pxb1hempH1FgVrd5qeU0ejYUB4KgOKIptKFzy30F8Z4aDeUjqD0P+yXoZ
   4AYq73YnV6JG5oSsmO2nlc0fv1npwEGS61e8oJvYYcZ06sVEdLBiI9yN5
   g==;
X-CSE-ConnectionGUID: ajcqrIqzSh2juLV75H+T6g==
X-CSE-MsgGUID: ukLlamqISqC4EFmHHMtFTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88172871"
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="88172871"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 06:37:29 -0700
X-CSE-ConnectionGUID: 2e/I0mJpQ1uuKsG3e56xmw==
X-CSE-MsgGUID: 14FJjKCJS3u1xq3nk1WmcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="268307053"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 04 Sep 2026 06:37:27 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2U6e-000000009os-3nwJ;
	Fri, 04 Sep 2026 13:37:24 +0000
Date: Fri, 04 Sep 2026 21:36:36 +0800
From: kernel test robot <lkp@intel.com>
To: David Stevens <stevensd@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 3196/3635] mm/memcontrol.c:2859:41:
 error: implicit declaration of function 'irq_work_queue'; did you mean
 'drain_workqueue'?
Message-ID: <202609042120.6bgj0pUa-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: gpj84gstud6u3k4rwzqirmoo6xbwjmkr
X-Rspamd-Queue-Id: 7E77114000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1788529050-106038
X-HE-Meta: U2FsdGVkX1+mfb0wxlL2jRuuI0/VRkurybRHqIzlgH8hS3l9S+FIHrSzZrMVvIJbWqQUPaIOdxCHNx96SuQUrFMOWzhR1EPw7t//gNh1FfxRN1GbUh+YA8wKSw/Fmgi71ouK+ANU6Gmk2quws9l7F/UZ01YgsUZ4dNRB/YMXp1teEdqxDQqRpT/AgDzFDxfUHFLBytpnsXs6e9BFgeldgCeqc3s/9jdAR76mp7cjtouL52Vu/H7C49qH+JFEqI+RuH8GXGLKVQ+/ofHNAMTuFW2BZnUGvEowS1ZEHLw+kgaC0ie1A/HTg5oF26jLCHy7UpqKyXbYleTay+RhXBoAAwIAobDbB/PP7c0hOAion8ieyC7GeLEm5EyNT0CbRjVB+FvN7HrVJsjMQIwd5svy+m68/M5I1qqvg92a8C9SGcWKFxcP8wWIR0V7IuHnO3rsvcBIsZ2fzOXt6IXE+flqp1G2IsknfoVGGkmn1IBgnbQtMpd0ldTJOGGc6d2C3zB2XphV5+b5hBiCWXuJxR9AnkjXxuoSM/tZcSfWpjrbXZ6PRC/W1A9UTeVLvBUWtQGPL67NyOmvhDMGTR3JakqEBA7MrHXmL93d5fQQHs4MKnvYPx3JRDQwikMIhH1yh/lWxjRjqaf/AjEFqBnQ80MLeY0W09Rv3r7pzjxVQPrXkS1dmun5YdoqV18c2Q/6C3stozDy8nYfSyRw/KJ6H4Nuz3yKMYLrEyJDJ0zHcM/MYOB6P+b73yyd+m2PIxzhlaluisH4GtJlHomb9TcmxmKSDtFmuvpxYE4OxPVMpzO/rmD2kLmf+x6nXRh03a7qb8PyiHGfrBftr3kXy6DLtqsyjIZHsuSP4ZTDiaP5jZBNOVv7cd7Hx/rMFn37pFvlLsnhxZaZ6k9ckvgqCajvjLLNA0ce2eRBN/Vypev4YixGmQiGQUlbTovYbc9bpCFiyh7K4wUWM71smNoVS1THZiv
 u6/+LJ+3
 HF0e5RIs8CEriwlQiwNxEI73nW0CtsoeXTMSQjJ+55Tccar/q7YtvzfYWdHg88M3+u4bntC8qJQrchOUf0Y4a55rJhbZlWENlT/2MQi0s+JFfgV+drU0kvgKOMEOwJZZzODdlxcWdKDtz6ADRZZ4bDGI9Wk0cCl1mKM6gzOrQw0CUxp5j6byG3jI+DeyHifNaSyaCMV0Y1OhXQxspGBklEx2ZjG2CzAWRaOhdADN5xIHlxBqWvpx+yAPOATbJ7ST+2D6efMfL1VmWTi2zjnIlxI6pbvl3+peWtmkJL1TOswZ93k5wCElzz71Rp12zNynlKplKpm6ZS40wCjG8iMAyLyNEIKgAlTSmorOd36H3Xa2ktiloaKTd5q5EaJgl73Ao9Rtc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   9d80aa4617b32f5054c5aa471d06b66704854935
commit: f4bb278a0bb905c7703993060e0d9271820f7532 [3196/3635] memcg: don't call schedule_work when no spinning is allowed
config: sparc-randconfig-r061-20260904 (https://download.01.org/0day-ci/archive/20260904/202609042120.6bgj0pUa-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 13.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260904/202609042120.6bgj0pUa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609042120.6bgj0pUa-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memcontrol.c: In function 'try_charge_memcg':
>> mm/memcontrol.c:2859:41: error: implicit declaration of function 'irq_work_queue'; did you mean 'drain_workqueue'? [-Werror=implicit-function-declaration]
    2859 |                                         irq_work_queue(&memcg->high_irq_work);
         |                                         ^~~~~~~~~~~~~~
         |                                         drain_workqueue
   mm/memcontrol.c: In function 'mem_cgroup_alloc':
>> mm/memcontrol.c:4234:9: error: implicit declaration of function 'init_irq_work'; did you mean 'init_irq_proc'? [-Werror=implicit-function-declaration]
    4234 |         init_irq_work(&memcg->high_irq_work, high_irq_work_func);
         |         ^~~~~~~~~~~~~
         |         init_irq_proc
   mm/memcontrol.c: In function 'mem_cgroup_css_free':
>> mm/memcontrol.c:4443:9: error: implicit declaration of function 'irq_work_sync' [-Werror=implicit-function-declaration]
    4443 |         irq_work_sync(&memcg->high_irq_work);
         |         ^~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +2859 mm/memcontrol.c

  2678	
  2679	static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
  2680				    unsigned int nr_pages)
  2681	{
  2682		unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
  2683		int nr_retries = MAX_RECLAIM_RETRIES;
  2684		struct mem_cgroup *mem_over_limit;
  2685		struct page_counter *counter;
  2686		unsigned long nr_reclaimed;
  2687		bool passed_oom = false;
  2688		unsigned int reclaim_options;
  2689		bool drained = false;
  2690		bool raised_max_event = false;
  2691		unsigned long pflags;
  2692		bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
  2693		int ret = 0;
  2694	
  2695	retry:
  2696		if (consume_stock(memcg, nr_pages))
  2697			return ret;
  2698	
  2699		if (!allow_spinning)
  2700			/* Avoid the refill and flush of the older stock */
  2701			batch = nr_pages;
  2702	
  2703		reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
  2704		if (!do_memsw_account() ||
  2705		    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
  2706			if (page_counter_try_charge(&memcg->memory, batch, &counter))
  2707				goto done_restock;
  2708			if (do_memsw_account())
  2709				page_counter_uncharge(&memcg->memsw, batch);
  2710			mem_over_limit = mem_cgroup_from_counter(counter, memory);
  2711		} else {
  2712			mem_over_limit = mem_cgroup_from_counter(counter, memsw);
  2713			reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
  2714		}
  2715	
  2716		if (batch > nr_pages) {
  2717			batch = nr_pages;
  2718			goto retry;
  2719		}
  2720	
  2721		/*
  2722		 * Prevent unbounded recursion when reclaim operations need to
  2723		 * allocate memory. This might exceed the limits temporarily,
  2724		 * but we prefer facilitating memory reclaim and getting back
  2725		 * under the limit over triggering OOM kills in these cases.
  2726		 */
  2727		if (unlikely(current->flags & PF_MEMALLOC))
  2728			goto force;
  2729	
  2730		if (unlikely(task_in_memcg_oom(current)))
  2731			goto nomem;
  2732	
  2733		if (!gfpflags_allow_blocking(gfp_mask))
  2734			goto nomem;
  2735	
  2736		/*
  2737		 * OOM victim still needs to charge memory to exit. OOM reaper should
  2738		 * help but it might fail on mmap_lock contention. If the victim is a
  2739		 * large thread group then all exiting threads might compete on oom_lock
  2740		 * just to learn that there is nothing really killable anymore. Bail
  2741		 * out early and fail the charge to expedite their exit. They are
  2742		 * considered fully reclaimed by the oom reaper and they shouldn't
  2743		 * contribute further charges.
  2744		 */
  2745		if (tsk_is_oom_victim(current) &&
  2746		    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
  2747			goto nomem;
  2748	
  2749		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
  2750		raised_max_event = true;
  2751	
  2752		psi_memstall_enter(&pflags);
  2753		nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
  2754							    gfp_mask, reclaim_options, NULL);
  2755		psi_memstall_leave(&pflags);
  2756	
  2757		if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
  2758			goto retry;
  2759	
  2760		if (!drained) {
  2761			drain_all_stock(mem_over_limit);
  2762			drained = true;
  2763			goto retry;
  2764		}
  2765	
  2766		if (gfp_mask & __GFP_NORETRY)
  2767			goto nomem;
  2768		/*
  2769		 * Even though the limit is exceeded at this point, reclaim
  2770		 * may have been able to free some pages.  Retry the charge
  2771		 * before killing the task.
  2772		 *
  2773		 * Only for regular pages, though: huge pages are rather
  2774		 * unlikely to succeed so close to the limit, and we fall back
  2775		 * to regular pages anyway in case of failure.
  2776		 */
  2777		if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
  2778			goto retry;
  2779	
  2780		if (nr_retries--)
  2781			goto retry;
  2782	
  2783		if (gfp_mask & __GFP_RETRY_MAYFAIL)
  2784			goto nomem;
  2785	
  2786		/* Avoid endless loop for tasks bypassed by the oom killer */
  2787		if (passed_oom && task_is_dying())
  2788			goto nomem;
  2789	
  2790		/*
  2791		 * keep retrying as long as the memcg oom killer is able to make
  2792		 * a forward progress or bypass the charge if the oom killer
  2793		 * couldn't make any progress.
  2794		 */
  2795		if (mem_cgroup_oom(mem_over_limit, gfp_mask,
  2796				   get_order(nr_pages * PAGE_SIZE))) {
  2797			passed_oom = true;
  2798			nr_retries = MAX_RECLAIM_RETRIES;
  2799			goto retry;
  2800		}
  2801	nomem:
  2802		/*
  2803		 * Memcg doesn't have a dedicated reserve for atomic
  2804		 * allocations. But like the global atomic pool, we need to
  2805		 * put the burden of reclaim on regular allocation requests
  2806		 * and let these go through as privileged allocations.
  2807		 */
  2808		if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH))) {
  2809			ret = -ENOMEM;
  2810			goto out;
  2811		}
  2812	force:
  2813		/*
  2814		 * The allocation either can't fail or will lead to more memory
  2815		 * being freed very soon.  Allow memory usage go over the limit
  2816		 * temporarily by force charging it.
  2817		 */
  2818		page_counter_charge(&memcg->memory, nr_pages);
  2819		if (do_memsw_account())
  2820			page_counter_charge(&memcg->memsw, nr_pages);
  2821	
  2822	out:
  2823		/*
  2824		 * Don't forget to raise a MEMCG_MAX event for forced or rejected
  2825		 * requests.
  2826		 */
  2827		if (!raised_max_event)
  2828			__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
  2829	
  2830		return ret;
  2831	
  2832	done_restock:
  2833		if (batch > nr_pages)
  2834			refill_stock(memcg, batch - nr_pages);
  2835	
  2836		/*
  2837		 * If the hierarchy is above the normal consumption range, schedule
  2838		 * reclaim on returning to userland.  We can perform reclaim here
  2839		 * if __GFP_RECLAIM but let's always punt for simplicity and so that
  2840		 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
  2841		 * not recorded as it most likely matches current's and won't
  2842		 * change in the meantime.  As high limit is checked again before
  2843		 * reclaim, the cost of mismatch is negligible.
  2844		 */
  2845		do {
  2846			bool mem_high, swap_high;
  2847	
  2848			mem_high = page_counter_read(&memcg->memory) >
  2849				READ_ONCE(memcg->memory.high);
  2850			swap_high = page_counter_read(&memcg->swap) >
  2851				READ_ONCE(memcg->swap.high);
  2852	
  2853			/* Don't bother a random interrupted task */
  2854			if (!in_task()) {
  2855				if (mem_high) {
  2856					if (allow_spinning)
  2857						schedule_work(&memcg->high_work);
  2858					else
> 2859						irq_work_queue(&memcg->high_irq_work);
  2860					break;
  2861				}
  2862				continue;
  2863			}
  2864	
  2865			if (mem_high || swap_high) {
  2866				/*
  2867				 * The allocating tasks in this cgroup will need to do
  2868				 * reclaim or be throttled to prevent further growth
  2869				 * of the memory or swap footprints.
  2870				 *
  2871				 * Target some best-effort fairness between the tasks,
  2872				 * and distribute reclaim work and delay penalties
  2873				 * based on how much each task is actually allocating.
  2874				 */
  2875				current->memcg_nr_pages_over_high += batch;
  2876				set_notify_resume(current);
  2877				break;
  2878			}
  2879		} while ((memcg = parent_mem_cgroup(memcg)));
  2880	
  2881		/*
  2882		 * Reclaim is set up above to be called from the userland
  2883		 * return path. But also attempt synchronous reclaim to avoid
  2884		 * excessive overrun while the task is still inside the
  2885		 * kernel. If this is successful, the return path will see it
  2886		 * when it rechecks the overage and simply bail out.
  2887		 */
  2888		if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
  2889		    !(current->flags & PF_MEMALLOC) &&
  2890		    gfpflags_allow_blocking(gfp_mask))
  2891			__mem_cgroup_handle_over_high(gfp_mask);
  2892		return ret;
  2893	}
  2894	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

