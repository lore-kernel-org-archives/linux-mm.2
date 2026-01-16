Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFD4D4A613
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 08:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29C76B008C; Fri, 16 Jan 2026 03:42:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6E26B0092; Fri, 16 Jan 2026 03:42:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6086B0093; Fri, 16 Jan 2026 03:42:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7A296B008C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:42:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C8F38C0DE
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:42:07 +0000 (UTC)
X-FDA: 84337184694.07.2B221B3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf28.hostedemail.com (Postfix) with ESMTP id 53C20C0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:42:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G5HsKtCK;
	spf=pass (imf28.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768552925; a=rsa-sha256;
	cv=none;
	b=KiryVkY/zLTIVpvZRKpQHiCDtnMTDv8OFQLhhSgrMnxp7PZVH2lq2nLfVd6FkwurE/JTLQ
	zipGYrAs7BYkyOJ5uYYKe2wo3dVwBvFCK77OUZ+I73sKbYPDH6USB0wW1XrUhj2OjWk1eC
	vE6oC8XtDaGNGjBsRjNX88Sod5kfT00=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G5HsKtCK;
	spf=pass (imf28.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768552925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvujcxuX43F18hts9gEWVKT6HtdgmSMEGcJ3UyYGfag=;
	b=QGS82KcQelRGqHh6XnVptrHBPN9c98L7CUFLw3kLUmi49BGjRGDmb9c6RQEosmmfpL5EK5
	Fr8FYNhiEpm+6X8fguLFKeSC1G1jpN6na4vrDsmzRICy9hbixnVGnTo8BnjagXIkHConjS
	6VUj2l0JStU2gwYmot6uRMY1f1lQzRA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768552926; x=1800088926;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xJQAegHmnBap8tJhjWxG2vVLNHtpDOZ54DRGae/7vg8=;
  b=G5HsKtCKawBE1UFlpaTGLVOJmllEs6Cw+BWFyJR7bVXiXwmEGIiy71Mv
   RSSULGHIJANYCsit8oqdUp+qDwlBsJqs7xJ2P4XOrSm5icm1CuaMRv6zH
   Oh6XIMX5RbIvPoNkS3T95F9kLa/caPJmS93+JuZTQ8rD7x6J13Mozj58q
   tJvMTZ5BdUiSvh9EfJ/5BbZP9YF+B/g4UjkmqXdNUz3fYngyA/OUMsJKp
   +p8C/UaJzZ0dbAGDvTmEC6IlwXzPl6+qbwg59UNi3bRNqloXMvEisxD0G
   /O5Ip2bwQN6MSmW6igIXTdVJgaQYNXd29N9uaBoRPB8X7hIiim0yO2D0D
   A==;
X-CSE-ConnectionGUID: jYPMKYD3Tb2xfufQREwncg==
X-CSE-MsgGUID: XHAR+NGjRTKZUt+zBFk8VA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="73495803"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="73495803"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 00:42:04 -0800
X-CSE-ConnectionGUID: tl6lmrRvSnC54MaXItf+gA==
X-CSE-MsgGUID: lxPScIAeT6ijGyndnsl7nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="204797888"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 16 Jan 2026 00:42:00 -0800
Date: Fri, 16 Jan 2026 17:07:30 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Li <haolee.swjtu@gmail.com>, akpm@linux-foundation.org,
	harry.yoo@oracle.com, cl@gentwo.org, rientjes@google.com,
	roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, tim.c.chen@intel.com,
	yu.c.chen@intel.com, zhao1.liu@intel.com
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <aWn/0mn93MmUvTPY@intel.com>
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
 <aWi9nAbIkTfYFoMM@intel.com>
 <6be60100-e94c-4c06-9542-29ac8bf8f013@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6be60100-e94c-4c06-9542-29ac8bf8f013@suse.cz>
X-Stat-Signature: ku4daztumh4xy3ngrt139n3sp6kx7ij4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 53C20C0005
X-Rspam-User: 
X-HE-Tag: 1768552925-986720
X-HE-Meta: U2FsdGVkX195THBijuz4nLFkieZBFYNWH5e6gDUgO1HCLrTFtx3av0ImEqqZ6YKV+7OWFxFvcpL7NMFNbz3DrQRvOIxs6BIbf5wtOz5ggyWuEOqPbR08YiLc5ZnJ8/aY/AVrpwnohVLg1VJEx+ucPTXD/U74bfoKDywjDck/CL4HB24gN9gM9799x/ZYUHvP8kZUtPE/6EBwtpYHq+dGx2IzsoIcRxa3J2yNNJIgQazOaPKzn/qotF/9xA7+Iop95bSoKLr82VXCiuT5MlUiLHu3kss0WsCx9vuZpi0LhDFc1h6W3lVGnJKwa6OmX5sqE2lROQFeE6/05mZgk8/HOzJEQkC0FDq8mUyBwfe5yWzUSMYCD+kvvm1LCH7V2tPs78JDfTSgBIlrpmbMPkE9GvFu9IsJWa+TpVWWh7UqE+sFNeD+htuHj0HiYKfvtIPEKHf+URudC1ems1eSuRfbGjH8BS/tY+AiFezz5KfKoWFAbemdRXxuTa4xnlkCSlMzcXeByanOOU6UX7IWH7RgpR8sYqLtseNox/Ck2l20z/hWUQ5LWrNN3OqLddtMrWIrw7rUh1sAP/bC1VitqEogWbFPlz8wzj9nPk3Lfb6si5vAPa4ZLfxfmXrl49V6X2741pLax20B/ANHVY2JlB/bTyMWAZfbj1pUKo1q6oOMgE9nEU8i8v/veVNkwgBjdd4iXoyeqU/61WxqJRlHfDZwSlvSTzduehdbWF++b7WgK9hbrrEewFPx9hhQexJiEEXsMnNpb2b/waG/Xc4hvsiCf8rtP5izi1oT6+DRQv7+H4ObWKF1LmGFJN1syeVZxh0scRhPBzG3yh5OGSZlXH8dZj2eSZZttlJS4VLcjanUSaCfFdCX6OKs+uW2LJhtTQDv3i16Hqit1Sf99PxIdwz1q8ZlNDIuPw/W6VoJXAJkQ1bybwLGcfEJO28FgNZSaXDUfMe9EIlR7gSEJFkeDg5
 GMpyORwM
 YDR5ASJlfSuCszpOvpNLBU2YEUQP+F5blgwfwn6TovwxhxFxJ4W+KVj2L9/R28W33uW1gsRae0rV5tUHxD9v68JuYyy//cy7aly8/RZHLFEFghpcEaHeWSfLNUKYS/M1J3bkgnISCkiORnm9umqUR9zmTRouIQpj3HaF56zXBRwxp20qmYFnwjJ3wAQtWPt7MNChnXldK/0hFINeKcW9uAcQsVz3YERbbXUJ98y+zrzdjFkqqm5ukRP/gFDJlpH38KLQ6E3xH0H8/+7Q1ROkSzciN6VEKz91KFEINxTUl+Qwg2T7mQsf0mo23Pt+PhtHsTQYUBZsTjFxiD8rfqhnsYcyy6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > The following is the perf data comparing 2 tests w/o fix & with this fix:
> > 
> > # Baseline  Delta Abs  Shared Object            Symbol
> > # ........  .........  .......................  ....................................
> > #
> >     61.76%     +4.78%  [kernel.vmlinux]         [k] native_queued_spin_lock_slowpath
> >      0.93%     -0.32%  [kernel.vmlinux]         [k] __slab_free
> >      0.39%     -0.31%  [kernel.vmlinux]         [k] barn_get_empty_sheaf
> >      1.35%     -0.30%  [kernel.vmlinux]         [k] mas_leaf_max_gap
> >      3.22%     -0.30%  [kernel.vmlinux]         [k] __kmem_cache_alloc_bulk
> >      1.73%     -0.20%  [kernel.vmlinux]         [k] __cond_resched
> >      0.52%     -0.19%  [kernel.vmlinux]         [k] _raw_spin_lock_irqsave
> >      0.92%     +0.18%  [kernel.vmlinux]         [k] _raw_spin_lock
> >      1.91%     -0.15%  [kernel.vmlinux]         [k] zap_pmd_range.isra.0
> >      1.37%     -0.13%  [kernel.vmlinux]         [k] mas_wr_node_store
> >      1.29%     -0.12%  [kernel.vmlinux]         [k] free_pud_range
> >      0.92%     -0.11%  [kernel.vmlinux]         [k] __mmap_region
> >      0.12%     -0.11%  [kernel.vmlinux]         [k] barn_put_empty_sheaf
> >      0.20%     -0.09%  [kernel.vmlinux]         [k] barn_replace_empty_sheaf
> >      0.31%     +0.09%  [kernel.vmlinux]         [k] get_partial_node
> >      0.29%     -0.07%  [kernel.vmlinux]         [k] __rcu_free_sheaf_prepare
> >      0.12%     -0.07%  [kernel.vmlinux]         [k] intel_idle_xstate
> >      0.21%     -0.07%  [kernel.vmlinux]         [k] __kfree_rcu_sheaf
> >      0.26%     -0.07%  [kernel.vmlinux]         [k] down_write
> >      0.53%     -0.06%  libc.so.6                [.] __mmap
> >      0.66%     -0.06%  [kernel.vmlinux]         [k] mas_walk
> >      0.48%     -0.06%  [kernel.vmlinux]         [k] mas_prev_slot
> >      0.45%     -0.06%  [kernel.vmlinux]         [k] mas_find
> >      0.38%     -0.06%  [kernel.vmlinux]         [k] mas_wr_store_type
> >      0.23%     -0.06%  [kernel.vmlinux]         [k] do_vmi_align_munmap
> >      0.21%     -0.05%  [kernel.vmlinux]         [k] perf_event_mmap_event
> >      0.32%     -0.05%  [kernel.vmlinux]         [k] entry_SYSRETQ_unsafe_stack
> >      0.19%     -0.05%  [kernel.vmlinux]         [k] downgrade_write
> >      0.59%     -0.05%  [kernel.vmlinux]         [k] mas_next_slot
> >      0.31%     -0.05%  [kernel.vmlinux]         [k] __mmap_new_vma
> >      0.44%     -0.05%  [kernel.vmlinux]         [k] kmem_cache_alloc_noprof
> >      0.28%     -0.05%  [kernel.vmlinux]         [k] __vma_enter_locked
> >      0.41%     -0.05%  [kernel.vmlinux]         [k] memcpy
> >      0.48%     -0.04%  [kernel.vmlinux]         [k] mas_store_gfp
> >      0.14%     +0.04%  [kernel.vmlinux]         [k] __put_partials
> >      0.19%     -0.04%  [kernel.vmlinux]         [k] mas_empty_area_rev
> >      0.30%     -0.04%  [kernel.vmlinux]         [k] do_syscall_64
> >      0.25%     -0.04%  [kernel.vmlinux]         [k] mas_preallocate
> >      0.15%     -0.04%  [kernel.vmlinux]         [k] rcu_free_sheaf
> >      0.22%     -0.04%  [kernel.vmlinux]         [k] entry_SYSCALL_64
> >      0.49%     -0.04%  libc.so.6                [.] __munmap
> >      0.91%     -0.04%  [kernel.vmlinux]         [k] rcu_all_qs
> >      0.21%     -0.04%  [kernel.vmlinux]         [k] __vm_munmap
> >      0.24%     -0.04%  [kernel.vmlinux]         [k] mas_store_prealloc
> >      0.19%     -0.04%  [kernel.vmlinux]         [k] __kmalloc_cache_noprof
> >      0.34%     -0.04%  [kernel.vmlinux]         [k] build_detached_freelist
> >      0.19%     -0.03%  [kernel.vmlinux]         [k] vms_complete_munmap_vmas
> >      0.36%     -0.03%  [kernel.vmlinux]         [k] mas_rev_awalk
> >      0.05%     -0.03%  [kernel.vmlinux]         [k] shuffle_freelist
> >      0.19%     -0.03%  [kernel.vmlinux]         [k] down_write_killable
> >      0.19%     -0.03%  [kernel.vmlinux]         [k] kmem_cache_free
> >      0.27%     -0.03%  [kernel.vmlinux]         [k] up_write
> >      0.13%     -0.03%  [kernel.vmlinux]         [k] vm_area_alloc
> >      0.18%     -0.03%  [kernel.vmlinux]         [k] arch_get_unmapped_area_topdown
> >      0.08%     -0.03%  [kernel.vmlinux]         [k] userfaultfd_unmap_complete
> >      0.10%     -0.03%  [kernel.vmlinux]         [k] tlb_gather_mmu
> >      0.30%     -0.02%  [kernel.vmlinux]         [k] ___slab_alloc
> > 
> > I think the insteresting item is "get_partial_node". It seems this fix
> > makes "get_partial_node" slightly more frequent. HMM, however, I still
> > can't figure out why this is happening. Do you have any thoughts on it?
> 
> I'm not sure if it's statistically significant or just noise, +0.09% could
> be noise?

small number does't always mean it's noise. When perf samples get_partial_node
on the spin lock call chain, its subroutines (spin lock) are hotter, so
the proportion of subroutine execution is higher. If the function -
get_partial_node itself (excluding subroutines) executes very quickly,
the proportion is lower.

I also expend the perf data with call chain:

* w/o fix:

We can calculate the proportion of spin locks introduced by get_partial_node
is: 31.05% / 49.91% = 62.21%

    49.91%  mmap2_processes  [kernel.vmlinux]         [k] native_queued_spin_lock_slowpath
            |
             --49.91%--native_queued_spin_lock_slowpath
                       |
                        --49.91%--_raw_spin_lock_irqsave
                                  |
                                  |--31.05%--get_partial_node
                                  |          |
                                  |          |--23.66%--get_any_partial
                                  |          |          ___slab_alloc
                                  |          |
                                  |           --7.40%--___slab_alloc
                                  |                     __kmem_cache_alloc_bulk
                                  |
                                  |--10.84%--barn_get_empty_sheaf
                                  |          |
                                  |          |--6.18%--__kfree_rcu_sheaf
                                  |          |          kvfree_call_rcu
                                  |          |
                                  |           --4.66%--__pcs_replace_empty_main
                                  |                     kmem_cache_alloc_noprof
                                  |
                                  |--5.10%--barn_put_empty_sheaf
                                  |          |
                                  |           --5.09%--__pcs_replace_empty_main
                                  |                     kmem_cache_alloc_noprof
                                  |
                                  |--2.01%--barn_replace_empty_sheaf
                                  |          __pcs_replace_empty_main
                                  |          kmem_cache_alloc_noprof
                                  |
                                   --0.78%--__put_partials
                                             |
                                              --0.78%--__kmem_cache_free_bulk.part.0
                                                        rcu_free_sheaf


* with fix:

Similarly, the proportion of spin locks introduced by get_partial_node
is: 39.91% / 42.82% = 93.20%

    42.82%  mmap2_processes  [kernel.vmlinux]         [k] native_queued_spin_lock_slowpath
            |
            ---native_queued_spin_lock_slowpath
               |
                --42.82%--_raw_spin_lock_irqsave
                          |
                          |--39.91%--get_partial_node
                          |          |
                          |          |--28.25%--get_any_partial
                          |          |          ___slab_alloc
                          |          |
                          |           --11.66%--___slab_alloc
                          |                     __kmem_cache_alloc_bulk
                          |
                          |--1.09%--barn_get_empty_sheaf
                          |          |
                          |           --0.90%--__kfree_rcu_sheaf
                          |                     kvfree_call_rcu
                          |
                          |--0.96%--barn_replace_empty_sheaf
                          |          __pcs_replace_empty_main
                          |          kmem_cache_alloc_noprof
                          |
                           --0.77%--__put_partials
                                     __kmem_cache_free_bulk.part.0
                                     rcu_free_sheaf


So, 62.21% -> 93.20% could reflect that get_partial_node contribute more
overhead at this point.

> > So, I'd like to know if you think dynamically or adaptively adjusting
> > capacity is a worthwhile idea.
> 
> In the followup series, there will be automatically determined capacity to
> roughly match the current capacity of cpu partial slabs:
> 
> https://lore.kernel.org/all/20260112-sheaves-for-all-v2-4-98225cfb50cf@suse.cz/
> 
> We can use that as starting point for further tuning. But I suspect making
> it adjust dynamically would be complicated.

Thanks, will continue to evaluate this series.

Regards,
Zhao


