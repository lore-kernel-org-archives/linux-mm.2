Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3703D4A609
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18BDB6B0088; Fri, 16 Jan 2026 04:12:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D5C6B0089; Fri, 16 Jan 2026 04:12:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C846B008A; Fri, 16 Jan 2026 04:12:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB93A6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:12:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C414160550
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:12:10 +0000 (UTC)
X-FDA: 84337260420.13.5710BC3
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id BEB251C000F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:12:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=agtlbvbj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768554728; a=rsa-sha256;
	cv=none;
	b=lggFaGg9fif7j6JIH88qyraReE/8LKzB3nnDj+F3BG4OUnKtqzw8BG+SsE/gXKgbgx4/P5
	+TBoSYBC5/9giFaIV2anr+Du0Z9N1G607hBdZ/NrGGX1sfOJS2ucLEpQA5pRqDrKQf7Ahb
	TrkVlGANOBy4cZkfLuQBWcQ+ZEQzN+8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=agtlbvbj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768554728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LMqgc+njQZPOT+0Z1lK1JUBtQEL6lka+n6YtKR3cVKQ=;
	b=GJiVb4h5Wm5xo45NVYN4Xwa0rySPMilb1X6XLIWCo1QFyTEt96Vwuyn9oM4u26eRPU8F58
	kOuKjsS0fzJH70HVfAgu8AzVck6XnpPBvYbzPq6FK3GeWqIvqocikfE4ZCgyq9fnMwj1Ny
	LcGIIVR33oH0CiGp+gOsM9f5DMFn5pY=
Date: Fri, 16 Jan 2026 17:11:58 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768554727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LMqgc+njQZPOT+0Z1lK1JUBtQEL6lka+n6YtKR3cVKQ=;
	b=agtlbvbjnDv6ZtXgA4Ky00Q2HmSqv8zB1y750DbXP3WST9G8emkGd+ooM2SxZSvHUKotO0
	fEfsuEFkr+m719/K+2sCJ6g2SEYe38gCINv5u54ZgLQyTAaFEWkW/wEOGJW/HsQg3MgVgn
	PTp7nDQ7URW/Joszmnp0zl3Hw51tB/c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Hao Li <haolee.swjtu@gmail.com>, 
	akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	tim.c.chen@intel.com, yu.c.chen@intel.com
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <ohyhyc6tldamsaon2sq2l5hslyhtnovquxt36gcidlumtio44p@uwvk27px4trp>
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
 <aWi9nAbIkTfYFoMM@intel.com>
 <6be60100-e94c-4c06-9542-29ac8bf8f013@suse.cz>
 <aWn/0mn93MmUvTPY@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWn/0mn93MmUvTPY@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BEB251C000F
X-Rspamd-Server: rspam06
X-Stat-Signature: 7k8yyt13nkysbt8zt6beegiqmh3k3hdd
X-Rspam-User: 
X-HE-Tag: 1768554728-11673
X-HE-Meta: U2FsdGVkX1+rrQDlxYvbBI69x0+lnKAP4XqL+2HC7sESmXnWeKkv1L5A5UAe6I9ngyHODoVF2SkxLN0irgXt6boZW8qJyrZTr+KicH4OP3f0G49u6spOpkp9teUti36OD0PkjO+4LOQF8fBRnesE6yMUZu/EZoOLCRlms0REfvzzJHRlc2BlxI7CuH1x2fN1a/QME7IlvZSli/0j6hUNt6mOh3pb2vbiUkhny+4BBXD6l2+DCn0YvhT/eTBi8rIGbj2jG1fFmdtTmByudQYKwNh9auHVfhev7dqHyhmkv8fqZurI1AlUn0KITXR8Eqmv+ONveMRmfZ6voMduZKYBgo+6y67wd2wIVGJQXkbhI8LFTrVcnMBGeI6/JbO365U82ya+Jv9nOCGVpqbCd7Yg33jI+4y3wLkwnkFZpTWdyM8tMWhV3sw9LJWin2ctYP5tqyKjv6MimV9VbwLwN71/VocmxxJQpBvKsV0cwCquPbuL1lL16BqwdqTdRMP3D2SNwotywgSOYxHfVBNInqvcmxXoLbDwVrxVdX1qIP/kLxiezlQtmF43KdRnxXewpA0gT+bcPeL6+gW5vxzdU4Y9xrWSAoooRN+KFrc0akWks6aXLo74gQxXYYvsqCWeef3DOr0kVsHGuTMApQVjTGx7C0iFZt3hQ162GrEaG7eILK+3xzu8JgyvDyTJfIMW0K4WrgcAB1ScusGQh7bqZgdp9lUsuo0U0Sy4OwKZPeWST/EKz1G8zANzdLcP62kOqLJ7Vrd/GweZ0bkwemKPT9sFsqha0GJCSbwznXcGTKoJeHiS9l3j7JGX1o/OMcZBAjqibgnOuK8C3agYSdrljhmx6YpVE6+Mfevd27jlghSjTk/cL04CWhLKrSNgVkN8oD1upwEQerf4kdDExQ0VnXFALzDr8t7XziZrd4HZhw0Buqp7gZI5ArGFrweIWM9oSDS5IgProiz6S43gW23ya9Z
 EpqocQiI
 bpvgIWTT6IJkv7givV0ZxWyFlLe+L0m1WWhsnk8i37oGA/iYeCZXe2qasCKKZLHjoT9lvClT3WiRLZFpB9hWMFgCu+SigaBake1aQWF6dBm+O2tIe5GRlSpDt1Sr/PMKmFM7RyIZKGhq/LUENAirQEQpUZ+jjZ2uU3atLa1DxtpSk59L11TgMu0rutC6PUYlhbqzkiRqpJ9xqVIRZE6CIyV/4Fjzp9P86XwhZftWNZpILq4FGujODkf9otu9MgwmmKW3mo7X2OH1Be2jm8DqDA6xTlb91+CvmDrF/4lq8L46QN70HDrQ/ibgzJi48+doKYlJTPrixISmuxCFFjkCgo6hSEGtcUKyB3cQn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 05:07:30PM +0800, Zhao Liu wrote:
> > > The following is the perf data comparing 2 tests w/o fix & with this fix:
> > > 
> > > # Baseline  Delta Abs  Shared Object            Symbol
> > > # ........  .........  .......................  ....................................
> > > #
> > >     61.76%     +4.78%  [kernel.vmlinux]         [k] native_queued_spin_lock_slowpath
> > >      0.93%     -0.32%  [kernel.vmlinux]         [k] __slab_free
> > >      0.39%     -0.31%  [kernel.vmlinux]         [k] barn_get_empty_sheaf
> > >      1.35%     -0.30%  [kernel.vmlinux]         [k] mas_leaf_max_gap
> > >      3.22%     -0.30%  [kernel.vmlinux]         [k] __kmem_cache_alloc_bulk
> > >      1.73%     -0.20%  [kernel.vmlinux]         [k] __cond_resched
> > >      0.52%     -0.19%  [kernel.vmlinux]         [k] _raw_spin_lock_irqsave
> > >      0.92%     +0.18%  [kernel.vmlinux]         [k] _raw_spin_lock
> > >      1.91%     -0.15%  [kernel.vmlinux]         [k] zap_pmd_range.isra.0
> > >      1.37%     -0.13%  [kernel.vmlinux]         [k] mas_wr_node_store
> > >      1.29%     -0.12%  [kernel.vmlinux]         [k] free_pud_range
> > >      0.92%     -0.11%  [kernel.vmlinux]         [k] __mmap_region
> > >      0.12%     -0.11%  [kernel.vmlinux]         [k] barn_put_empty_sheaf
> > >      0.20%     -0.09%  [kernel.vmlinux]         [k] barn_replace_empty_sheaf
> > >      0.31%     +0.09%  [kernel.vmlinux]         [k] get_partial_node
> > >      0.29%     -0.07%  [kernel.vmlinux]         [k] __rcu_free_sheaf_prepare
> > >      0.12%     -0.07%  [kernel.vmlinux]         [k] intel_idle_xstate
> > >      0.21%     -0.07%  [kernel.vmlinux]         [k] __kfree_rcu_sheaf
> > >      0.26%     -0.07%  [kernel.vmlinux]         [k] down_write
> > >      0.53%     -0.06%  libc.so.6                [.] __mmap
> > >      0.66%     -0.06%  [kernel.vmlinux]         [k] mas_walk
> > >      0.48%     -0.06%  [kernel.vmlinux]         [k] mas_prev_slot
> > >      0.45%     -0.06%  [kernel.vmlinux]         [k] mas_find
> > >      0.38%     -0.06%  [kernel.vmlinux]         [k] mas_wr_store_type
> > >      0.23%     -0.06%  [kernel.vmlinux]         [k] do_vmi_align_munmap
> > >      0.21%     -0.05%  [kernel.vmlinux]         [k] perf_event_mmap_event
> > >      0.32%     -0.05%  [kernel.vmlinux]         [k] entry_SYSRETQ_unsafe_stack
> > >      0.19%     -0.05%  [kernel.vmlinux]         [k] downgrade_write
> > >      0.59%     -0.05%  [kernel.vmlinux]         [k] mas_next_slot
> > >      0.31%     -0.05%  [kernel.vmlinux]         [k] __mmap_new_vma
> > >      0.44%     -0.05%  [kernel.vmlinux]         [k] kmem_cache_alloc_noprof
> > >      0.28%     -0.05%  [kernel.vmlinux]         [k] __vma_enter_locked
> > >      0.41%     -0.05%  [kernel.vmlinux]         [k] memcpy
> > >      0.48%     -0.04%  [kernel.vmlinux]         [k] mas_store_gfp
> > >      0.14%     +0.04%  [kernel.vmlinux]         [k] __put_partials
> > >      0.19%     -0.04%  [kernel.vmlinux]         [k] mas_empty_area_rev
> > >      0.30%     -0.04%  [kernel.vmlinux]         [k] do_syscall_64
> > >      0.25%     -0.04%  [kernel.vmlinux]         [k] mas_preallocate
> > >      0.15%     -0.04%  [kernel.vmlinux]         [k] rcu_free_sheaf
> > >      0.22%     -0.04%  [kernel.vmlinux]         [k] entry_SYSCALL_64
> > >      0.49%     -0.04%  libc.so.6                [.] __munmap
> > >      0.91%     -0.04%  [kernel.vmlinux]         [k] rcu_all_qs
> > >      0.21%     -0.04%  [kernel.vmlinux]         [k] __vm_munmap
> > >      0.24%     -0.04%  [kernel.vmlinux]         [k] mas_store_prealloc
> > >      0.19%     -0.04%  [kernel.vmlinux]         [k] __kmalloc_cache_noprof
> > >      0.34%     -0.04%  [kernel.vmlinux]         [k] build_detached_freelist
> > >      0.19%     -0.03%  [kernel.vmlinux]         [k] vms_complete_munmap_vmas
> > >      0.36%     -0.03%  [kernel.vmlinux]         [k] mas_rev_awalk
> > >      0.05%     -0.03%  [kernel.vmlinux]         [k] shuffle_freelist
> > >      0.19%     -0.03%  [kernel.vmlinux]         [k] down_write_killable
> > >      0.19%     -0.03%  [kernel.vmlinux]         [k] kmem_cache_free
> > >      0.27%     -0.03%  [kernel.vmlinux]         [k] up_write
> > >      0.13%     -0.03%  [kernel.vmlinux]         [k] vm_area_alloc
> > >      0.18%     -0.03%  [kernel.vmlinux]         [k] arch_get_unmapped_area_topdown
> > >      0.08%     -0.03%  [kernel.vmlinux]         [k] userfaultfd_unmap_complete
> > >      0.10%     -0.03%  [kernel.vmlinux]         [k] tlb_gather_mmu
> > >      0.30%     -0.02%  [kernel.vmlinux]         [k] ___slab_alloc
> > > 
> > > I think the insteresting item is "get_partial_node". It seems this fix
> > > makes "get_partial_node" slightly more frequent. HMM, however, I still
> > > can't figure out why this is happening. Do you have any thoughts on it?
> > 
> > I'm not sure if it's statistically significant or just noise, +0.09% could
> > be noise?
> 
> small number does't always mean it's noise. When perf samples get_partial_node
> on the spin lock call chain, its subroutines (spin lock) are hotter, so
> the proportion of subroutine execution is higher. If the function -
> get_partial_node itself (excluding subroutines) executes very quickly,
> the proportion is lower.
> 
> I also expend the perf data with call chain:
> 
> * w/o fix:
> 
> We can calculate the proportion of spin locks introduced by get_partial_node
> is: 31.05% / 49.91% = 62.21%
> 
>     49.91%  mmap2_processes  [kernel.vmlinux]         [k] native_queued_spin_lock_slowpath
>             |
>              --49.91%--native_queued_spin_lock_slowpath
>                        |
>                         --49.91%--_raw_spin_lock_irqsave
>                                   |
>                                   |--31.05%--get_partial_node
>                                   |          |
>                                   |          |--23.66%--get_any_partial
>                                   |          |          ___slab_alloc
>                                   |          |
>                                   |           --7.40%--___slab_alloc
>                                   |                     __kmem_cache_alloc_bulk
>                                   |
>                                   |--10.84%--barn_get_empty_sheaf
>                                   |          |
>                                   |          |--6.18%--__kfree_rcu_sheaf
>                                   |          |          kvfree_call_rcu
>                                   |          |
>                                   |           --4.66%--__pcs_replace_empty_main
>                                   |                     kmem_cache_alloc_noprof
>                                   |
>                                   |--5.10%--barn_put_empty_sheaf
>                                   |          |
>                                   |           --5.09%--__pcs_replace_empty_main
>                                   |                     kmem_cache_alloc_noprof
>                                   |
>                                   |--2.01%--barn_replace_empty_sheaf
>                                   |          __pcs_replace_empty_main
>                                   |          kmem_cache_alloc_noprof
>                                   |
>                                    --0.78%--__put_partials
>                                              |
>                                               --0.78%--__kmem_cache_free_bulk.part.0
>                                                         rcu_free_sheaf
> 
> 
> * with fix:
> 
> Similarly, the proportion of spin locks introduced by get_partial_node
> is: 39.91% / 42.82% = 93.20%
> 
>     42.82%  mmap2_processes  [kernel.vmlinux]         [k] native_queued_spin_lock_slowpath
>             |
>             ---native_queued_spin_lock_slowpath
>                |
>                 --42.82%--_raw_spin_lock_irqsave
>                           |
>                           |--39.91%--get_partial_node
>                           |          |
>                           |          |--28.25%--get_any_partial
>                           |          |          ___slab_alloc
>                           |          |
>                           |           --11.66%--___slab_alloc
>                           |                     __kmem_cache_alloc_bulk
>                           |
>                           |--1.09%--barn_get_empty_sheaf
>                           |          |
>                           |           --0.90%--__kfree_rcu_sheaf
>                           |                     kvfree_call_rcu
>                           |
>                           |--0.96%--barn_replace_empty_sheaf
>                           |          __pcs_replace_empty_main
>                           |          kmem_cache_alloc_noprof
>                           |
>                            --0.77%--__put_partials
>                                      __kmem_cache_free_bulk.part.0
>                                      rcu_free_sheaf
> 
> 
> So, 62.21% -> 93.20% could reflect that get_partial_node contribute more
> overhead at this point.

Thanks for the detailed notes. I'll try to reproduce it to see what exactly
happened.

-- 
Thanks,
Hao

> 
> > > So, I'd like to know if you think dynamically or adaptively adjusting
> > > capacity is a worthwhile idea.
> > 
> > In the followup series, there will be automatically determined capacity to
> > roughly match the current capacity of cpu partial slabs:
> > 
> > https://lore.kernel.org/all/20260112-sheaves-for-all-v2-4-98225cfb50cf@suse.cz/
> > 
> > We can use that as starting point for further tuning. But I suspect making
> > it adjust dynamically would be complicated.
> 
> Thanks, will continue to evaluate this series.
> 
> Regards,
> Zhao
> 
> 

