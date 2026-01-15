Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65FD4D4114F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9666B0098; Thu, 15 Jan 2026 04:47:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8A926B009B; Thu, 15 Jan 2026 04:47:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0E16B009D; Thu, 15 Jan 2026 04:47:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A90086B0098
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:47:22 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5973B57A86
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:47:22 +0000 (UTC)
X-FDA: 84333720324.15.2214719
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf25.hostedemail.com (Postfix) with ESMTP id 92553A0007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:47:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NuOjLcxf;
	spf=pass (imf25.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768470440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78P1zlakmBOTRlf6nLy5vypSODn9Ltk+5BdYEaqz9qU=;
	b=VvKhilaz3EarH5Jd6hEfTZL6wnlCzVZQ6n5844xxrIw230omO1jIQgH6JD40nXqgToL9Zh
	e2mHh/RNP8Iie0p9PiMLczWcbGksY/S0PQD4rYtLOeGBpObwuUyQ1XIBWVw1dOC2aiQvbA
	LbEO8JjSaCsbxj//wPz8U8a1QXRtMAY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NuOjLcxf;
	spf=pass (imf25.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768470440; a=rsa-sha256;
	cv=none;
	b=DBwal+s2BrkLmgBqZJTmLAF0rL2n5lg9tXsvEgni3OqfA2MOuWWmL76b4+XN1byVKoOmN/
	rTxc2Z76xkGpYC9hgzbafZGpCerbzYBE74WDfTvQAR00Fg3xV40kDvpAwrhXsYchEUHKG9
	rqDYxptSzReqR2SaQ8JYI0Cq1Ccjai0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768470440; x=1800006440;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pUsFh1TjrJbtT/5IeJ6TbQyrT3Lb6WLEFHN+eJRAy94=;
  b=NuOjLcxfvMX/FHiFYY/z6lXT0++h9ThResOQ8UnBJOrthgMIxzZI1bV1
   0prkQY8mr7FOMgYV9TaV2XyTGalOShDVjczqw2V7vd4L5+hLIZDhMI3ru
   8q/BlYs9Ijaf+frUHTfUjJ4kODJcfELxGRf0KyjgDBNrfyE+Sx4i96a8l
   PdwSuHB7uzzF/gn2jnWCpkBx4qZYCMr+YJnfFgdO/Hz9XSYHGlA/xfjaA
   YtfesS39pT5Xuja/IUOE7ExmJs0BRSQWC7GDS2xRacH7Dc70z0retHfaC
   IiY4CZKHXmALjMy09/K4a4AMAKew51mJgf8RXG1c9D7MVbqDdM8QNaOsE
   Q==;
X-CSE-ConnectionGUID: wlHS8wPVSpi00bAWM2/VLA==
X-CSE-MsgGUID: Vr2xDyzgRqaRXNLuofNrlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="73616694"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="73616694"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 01:47:18 -0800
X-CSE-ConnectionGUID: X5YuPrgiSxax2MegQAIbrw==
X-CSE-MsgGUID: k1vqIDmQSDqWjFGuynXJTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="205421762"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa010.fm.intel.com with ESMTP; 15 Jan 2026 01:47:15 -0800
Date: Thu, 15 Jan 2026 18:12:44 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>, Hao Li <haolee.swjtu@gmail.com>
Cc: akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, tim.c.chen@intel.com,
	yu.c.chen@intel.com, zhao1.liu@intel.com
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <aWi9nAbIkTfYFoMM@intel.com>
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
X-Rspamd-Queue-Id: 92553A0007
X-Stat-Signature: izux7sjz1x7tn1fkcnqku985rk3g4ic7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768470439-287383
X-HE-Meta: U2FsdGVkX1+vGlBD8uUSWqjNRzZOWg2E8pZ3GJi/REWJDrUalXHlJk2oNalGQCcIPGm2tioAMYGRnhqhWRSwFyj70/1i/UjW7326j5pbX2NIXP3RP+MPMWrZLNNtR/nLIELJOfe0VO1715PNtwilBTYpN3EGUMt63A9wRKDCL4RPg5lCqLbaLdkJ22E35JsqILJQx0u+hyQxBu7sb3IVL9/7rnLT40gsv8ipKVq9cOI7/ZbQd9lXc9r8+TvV78Ao5Bv3NYEUL9lHLdywmRSyqHlk0rnBaZL+MXcvNCMLHC09R0XiH2DH7UTvFeyncdqkWjXvX+hTtT7WVQFv3dDI7dvEUQe+gAL6cc/XVPEuEoi//mhKRcAsJETd3oYqNsNlbcfZejIQ87zoaGl9M+T9NSjOkMCD9KhfeedUJ7FBbr8g3M09rmC3W1nE05xGyK2ce6LiP65oajCLoe1WwuZbzdZ2b1FXfPf1KGWcms235Fj0wFwWYdLPIeeZED4BM1DVl7xsg1bd4ER7dYW71hAPMxsFxywQaRIau4pQHT7AZAsWX5U+kWOKa7LahbDZAXpb1SpzGvgTsNttcJZ9dMMv4gpY6HO7y7HtFrJbA4SkkKR2w2DcwfpnPja/fmCHtDNW877cmDTinEBkBgwyYxCi+29JzrFPpo8R1xJ7A1jJFohrWCO6p3jo1bzZXsRQGzfMB3PaBv5ZoHQReUk1hU6L+l+OBu8V9Ee3IlNUiW0eOfeQvbiDf+quWBaIgfXGTzCWs4T9snGjro8NosBes+J3gCgGs1stIv67JPHFgGEHb25X9RYemN6IRfLTk3nF4QZb2A/HXz4zjG9nXhIhvFSKKznXYYkHRdVTW8l/gupJ+LVsnM1qOICiMRF9uCffeZ5EJ3pU88wfoppwcLNLYhrC7p2Pmg7OpS8sv4aPzPh5HdT4o/kkLdWEkGvuxV4e2cqydv20Z525qg59qyYhRzn
 wCkk0Cbp
 m5I2bm8jLIjzjjPTeY6N347JA4o/CpC+k6duAfdbcB4MxOw6EFmThoBdBvirwgqcy9fIrLvhZuN0L/lhmvN+qDgcLBfS3LGZ6kxIB1yGLPxv1claGINdJtqNF7mWQHvSOhPaGdJRF8LFZTIkxS6Bq7k2GrRFwfa1mGDsIO/ulUyQDCTNQh4/uYtqdXPJ96x3puDIb0Ya2jjx5C/hxzSxMk4uWrxl2w17Mrb1u7yCHF3zKrNhtCrmDDBdjZUm8ASq+exZtuAIv8Hugu30Z21sJznknethRqFT5XknDszWR7cI/tp1XrOn6jf6KRmRXi7ZNrPZyrnnvjDOVeRmi5FQ0fNqYlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Babka & Hao,

> Thanks, LGTM. We can make it smaller though. Adding to slab/for-next
> adjusted like this:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f21b2f0c6f5a..ad71f01571f0 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5052,7 +5052,11 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>          */
>  
>         if (pcs->main->size == 0) {
> -               barn_put_empty_sheaf(barn, pcs->main);
> +               if (!pcs->spare) {
> +                       pcs->spare = pcs->main;
> +               } else {
> +                       barn_put_empty_sheaf(barn, pcs->main);
> +               }
>                 pcs->main = full;
>                 return pcs;
>         }

I noticed the previous lkp regression report and tested this fix:

* will-it-scale.per_process_ops

Compared with v6.19-rc4(f0b9d8eb98df), with this fix, I have these
results:

nr_tasks   Delta
1          + 3.593%
8          + 3.094%
64         +60.247%
128        +49.344%
192        +27.500%
256        -12.077%

For the cases (nr_tasks: 1-192), there're the improvements. I think
this is expected since pre-cached spare sheaf reduces spinlock race:
reduce barn_put_empty_sheaf() & barn_get_empty_sheaf().

So (maybe too late),

Tested-by: Zhao Liu <zhao1.liu@intel.com>



But I find there are two more questions that might need consideration?

# Question 1: Regression for 256 tasks

For the above test - the case with nr_tasks: 256, there's a "slight"
regression. I did more testing:

(This is a single-round test; the 256-tasks data has jitter.)

nr_tasks   Delta
244	     0.308%
248	   - 0.805%
252	    12.070%
256	   -11.441%
258	     2.070%
260	     1.252%
264	     2.369%
268	   -11.479%
272	     2.130%
292	     8.714%
296	    10.905%
298	    17.196%
300	    11.783%
302	     6.620%
304	     3.112%
308	   - 5.924%

It can be seen that most cases show improvement, though a few may
experience slight regression.

Based on the configuration of my machine:

    GNR - 2 sockets with the following NUMA topology:

    NUMA:
      NUMA node(s):              4
      NUMA node0 CPU(s):         0-42,172-214
      NUMA node1 CPU(s):         43-85,215-257
      NUMA node2 CPU(s):         86-128,258-300
      NUMA node3 CPU(s):         129-171,301-343

Since I set the CPU affinity on the core, 256 cases is roughly
equivalent to the moment when Node 0 and Node 1 are filled.

The following is the perf data comparing 2 tests w/o fix & with this fix:

# Baseline  Delta Abs  Shared Object            Symbol
# ........  .........  .......................  ....................................
#
    61.76%     +4.78%  [kernel.vmlinux]         [k] native_queued_spin_lock_slowpath
     0.93%     -0.32%  [kernel.vmlinux]         [k] __slab_free
     0.39%     -0.31%  [kernel.vmlinux]         [k] barn_get_empty_sheaf
     1.35%     -0.30%  [kernel.vmlinux]         [k] mas_leaf_max_gap
     3.22%     -0.30%  [kernel.vmlinux]         [k] __kmem_cache_alloc_bulk
     1.73%     -0.20%  [kernel.vmlinux]         [k] __cond_resched
     0.52%     -0.19%  [kernel.vmlinux]         [k] _raw_spin_lock_irqsave
     0.92%     +0.18%  [kernel.vmlinux]         [k] _raw_spin_lock
     1.91%     -0.15%  [kernel.vmlinux]         [k] zap_pmd_range.isra.0
     1.37%     -0.13%  [kernel.vmlinux]         [k] mas_wr_node_store
     1.29%     -0.12%  [kernel.vmlinux]         [k] free_pud_range
     0.92%     -0.11%  [kernel.vmlinux]         [k] __mmap_region
     0.12%     -0.11%  [kernel.vmlinux]         [k] barn_put_empty_sheaf
     0.20%     -0.09%  [kernel.vmlinux]         [k] barn_replace_empty_sheaf
     0.31%     +0.09%  [kernel.vmlinux]         [k] get_partial_node
     0.29%     -0.07%  [kernel.vmlinux]         [k] __rcu_free_sheaf_prepare
     0.12%     -0.07%  [kernel.vmlinux]         [k] intel_idle_xstate
     0.21%     -0.07%  [kernel.vmlinux]         [k] __kfree_rcu_sheaf
     0.26%     -0.07%  [kernel.vmlinux]         [k] down_write
     0.53%     -0.06%  libc.so.6                [.] __mmap
     0.66%     -0.06%  [kernel.vmlinux]         [k] mas_walk
     0.48%     -0.06%  [kernel.vmlinux]         [k] mas_prev_slot
     0.45%     -0.06%  [kernel.vmlinux]         [k] mas_find
     0.38%     -0.06%  [kernel.vmlinux]         [k] mas_wr_store_type
     0.23%     -0.06%  [kernel.vmlinux]         [k] do_vmi_align_munmap
     0.21%     -0.05%  [kernel.vmlinux]         [k] perf_event_mmap_event
     0.32%     -0.05%  [kernel.vmlinux]         [k] entry_SYSRETQ_unsafe_stack
     0.19%     -0.05%  [kernel.vmlinux]         [k] downgrade_write
     0.59%     -0.05%  [kernel.vmlinux]         [k] mas_next_slot
     0.31%     -0.05%  [kernel.vmlinux]         [k] __mmap_new_vma
     0.44%     -0.05%  [kernel.vmlinux]         [k] kmem_cache_alloc_noprof
     0.28%     -0.05%  [kernel.vmlinux]         [k] __vma_enter_locked
     0.41%     -0.05%  [kernel.vmlinux]         [k] memcpy
     0.48%     -0.04%  [kernel.vmlinux]         [k] mas_store_gfp
     0.14%     +0.04%  [kernel.vmlinux]         [k] __put_partials
     0.19%     -0.04%  [kernel.vmlinux]         [k] mas_empty_area_rev
     0.30%     -0.04%  [kernel.vmlinux]         [k] do_syscall_64
     0.25%     -0.04%  [kernel.vmlinux]         [k] mas_preallocate
     0.15%     -0.04%  [kernel.vmlinux]         [k] rcu_free_sheaf
     0.22%     -0.04%  [kernel.vmlinux]         [k] entry_SYSCALL_64
     0.49%     -0.04%  libc.so.6                [.] __munmap
     0.91%     -0.04%  [kernel.vmlinux]         [k] rcu_all_qs
     0.21%     -0.04%  [kernel.vmlinux]         [k] __vm_munmap
     0.24%     -0.04%  [kernel.vmlinux]         [k] mas_store_prealloc
     0.19%     -0.04%  [kernel.vmlinux]         [k] __kmalloc_cache_noprof
     0.34%     -0.04%  [kernel.vmlinux]         [k] build_detached_freelist
     0.19%     -0.03%  [kernel.vmlinux]         [k] vms_complete_munmap_vmas
     0.36%     -0.03%  [kernel.vmlinux]         [k] mas_rev_awalk
     0.05%     -0.03%  [kernel.vmlinux]         [k] shuffle_freelist
     0.19%     -0.03%  [kernel.vmlinux]         [k] down_write_killable
     0.19%     -0.03%  [kernel.vmlinux]         [k] kmem_cache_free
     0.27%     -0.03%  [kernel.vmlinux]         [k] up_write
     0.13%     -0.03%  [kernel.vmlinux]         [k] vm_area_alloc
     0.18%     -0.03%  [kernel.vmlinux]         [k] arch_get_unmapped_area_topdown
     0.08%     -0.03%  [kernel.vmlinux]         [k] userfaultfd_unmap_complete
     0.10%     -0.03%  [kernel.vmlinux]         [k] tlb_gather_mmu
     0.30%     -0.02%  [kernel.vmlinux]         [k] ___slab_alloc

I think the insteresting item is "get_partial_node". It seems this fix
makes "get_partial_node" slightly more frequent. HMM, however, I still
can't figure out why this is happening. Do you have any thoughts on it?

# Question 2: sheaf capacity

Back the original commit which triggerred lkp regression. I did more
testing to check if this fix could totally fill the regression gap.

The base line is commit 3accabda4 ("mm, vma: use percpu sheaves for
vm_area_struct cache") and its next commit 59faa4da7cd4 ("maple_tree:
use percpu sheaves for maple_node_cache") has the regression.

I compared v6.19-rc4(f0b9d8eb98df) w/o fix & with fix aginst the base
line:

nr_tasks	w/o fix         with fix
1		- 3.643%	- 0.181%
8		-12.523%	- 9.816%
64		-50.378%	-20.482%
128		-36.736%	- 5.518%
192		-22.963%	- 1.777%
256		-32.926%	- 41.026%

It appears that under extreme conditions, regression remains significate.
I remembered your suggestion about larger capacity and did the following
testing:

	59faa4da7cd4	59faa4da7cd4	59faa4da7cd4	59faa4da7cd4	59faa4da7cd4
			(with this fix)	(cap: 32->64)	(cap: 32->128)	(cap: 32->256)
1	-8.789%		-8.805%		-8.185%		-9.912%		-8.673%
8	-12.256%	-9.219%		-10.460%	-10.070%	-8.819%
64	-38.915%	-8.172%		-4.700%		4.571%		8.793%
128	-8.032%		11.377%		23.232%		26.940%		30.573%
192	-1.220%		9.758%		20.573%		22.645%		25.768%
256	-6.570%		9.967%		21.663%		30.103%		33.876%

Comparing with base line (3accabda4), larger capacity could
significatly improve the Sheaf's scalability.

So, I'd like to know if you think dynamically or adaptively adjusting
capacity is a worthwhile idea.

Thanks for your patience.

Regards,
Zhao


