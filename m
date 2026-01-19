Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84313D4A5EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 06:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47C36B010F; Mon, 19 Jan 2026 01:08:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5E56B0111; Mon, 19 Jan 2026 01:08:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F44E6B0112; Mon, 19 Jan 2026 01:08:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFB36B010F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 01:08:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCE79BA699
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:08:16 +0000 (UTC)
X-FDA: 84347683392.21.542C171
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id C4467A0005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:08:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXjG5qwQ;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768802895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTDjQR82/vk1BvXipZ6tULerKvdg0ZCDBfCj6stPKS0=;
	b=HH1EOKJoANggmBgPowvO3pJ544nFD1azOmMotujENiGK+XKOcL8ZhdVJEggM6BSUPDB42U
	+JVqFGzw62jI9GONHCBGcWAprsKSNQTLU8nOoIX3oqz9gCFvuAj8xfGkxG1bYWekuFYUxU
	hzn4KK4LOlN8EkP8ZWHr/9mu1MfTcRc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXjG5qwQ;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768802895; a=rsa-sha256;
	cv=none;
	b=IyfQ3sDgmDGo55+EjaoImbF9sVXtTjTkiHml85rAKkugU34lYIT/mkNBnu3yI/2/9A4Ela
	z50rVe1A2WS4ogRNiYSCY0LT+xqQ+Qxojrgv5SjHU/MBUINQmhjW8tJbhF4qjyoHGq6/6h
	bMwp6EAOaclJ8rhtHA0NVpzOAW3Ktxc=
Date: Mon, 19 Jan 2026 14:07:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768802892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qTDjQR82/vk1BvXipZ6tULerKvdg0ZCDBfCj6stPKS0=;
	b=lXjG5qwQehpfpUa/UhNrzyIbGoNOJja/w6l0GMg1Hc+lfs+ytfZNxoYllNRMDDubRz/FQ7
	sOuIaaL/OY8e3+BGqDZd00Cg2ruUTl/5GlYsk5yLe9j8Ffo4NUs/FE1418KfLbPafbz5B6
	3lrkQYQPQ14N+y5VtByhV9poXPzML6k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Hao Li <haolee.swjtu@gmail.com>, 
	akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	tim.c.chen@intel.com, yu.c.chen@intel.com
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <3ozekmmsscrarwoa7vcytwjn5rxsiyxjrcsirlu3bhmlwtdxzn@s7a6rcxnqadc>
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
 <aWi9nAbIkTfYFoMM@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWi9nAbIkTfYFoMM@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ybf69egak4et1unw4mstf6836mdkxc7z
X-Rspam-User: 
X-Rspamd-Queue-Id: C4467A0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768802894-903114
X-HE-Meta: U2FsdGVkX19l35yLO9oGZZM89g89qxfbD9jCUchJXQTdFKgy7SBPczWkkRU/l02AEqdH6yAB4gvEkJka9hNaEnu82MmOhfGoqVvecA1DWr9kpPJdX48EQDiw5jdSgJGqe9w+sf8HJA+3kbuHLB0PUTXeKUgrgqarDzw6MJL3s4i6ohfnInvLC4m4Shp8DGkhOh2V2inB/lKXhWLCB9E4WaOcOa/bIsBX9RwvNRtib8A3lANIHc2VApfBXaqjl2zazydNrNrLGU114H8XUuU9n22L87w/PfHREw0cajbohQPi52hksZ8dfmvK3HWNx6WkfcsmpCeoBVwteFu2HsbtikvsnlXDEoJNfWDvhGBMg4j8J3FawN0Ghh214QladqqOEoNuc3TuVfrfV4XDyg2Jm46bC7v6J5qLWTLSLWORrNU3FAF4XmBbnTSJlanpbDUX9o0K/TVfbf8+rU9UZ51uQEmBoBibOH67elEGFt4uLYi0jqqnlCResJPH0LEiYpgVMU5F5IGgD23Y+Z1bC79GuqJksLzM8ILNAEyupYQiTUngh9dA1JUNXLBwm74FGezRoD+xcSzCSKnDlLz60JjgW2jEliNYik/j/aCnkMM4MZZbmPSYVxmbL7G7eYDOdOewtAl2tlVwt3Rl8kWWyNetrkHMhqZ39z/09fTRi68GGc9AnotBeSl0qYjE/81fZPVsR4aAPHsR4t7Cv9WweChfrTsWcYGzD0HeKe51HEp1TdgH4427Bh/Kk6HBAFN+eLOcj7OT0fW1eF8YK74htTJb9Gw4tuB6bO6MyMz7wi6KXgdH7L3Q+/5Xcxfyqlx23MedivKwdqACs9joeJRcZmgNR47CTVX+8NnjwJFVrtPvhoF0fMDrrKjyegAt+k2qAje3DrQLxFhsC5Sr4Jtey7Ow6zoaHf8N6WyTyf0sdLKgTcWH2PRfLcG2fYhgduJ2airwu71sE9LdOwJAnoPIEkO
 h74TPQl4
 qVmWT74+uwypJ9yQgy0yVz5+IRn8/SORbLHtJcs7k1b2MUveTfeOYMh1v5o1dB45qm0xqWMa5iS4b20PISndRedp5uMPejnwoh/Jz2fIQg2bGH6UXbPrW0hxLzinVppXsPItPZR8WCUbtvA7gnqepNwCUsK+sPAVq0cO/k+K8Vm3aP3h9nf87MfeyH0gTXBwGR30X+bCodfGvNdr1P/kWWokfBzMTKNi9A+c//udxmTpz1W/7SkX2ad/69S0uT4uxn1hSM1T3JUmj3cSKDXZesyS3e78oRlRkKDH5CxBIs2XBwPKHbgW4qstBCcGoH8Sb9ApVyd7YDaPF1Fwj+WV2+/O79IIULAAbcO9j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 06:12:44PM +0800, Zhao Liu wrote:
> Hi Babka & Hao,
> 
> > Thanks, LGTM. We can make it smaller though. Adding to slab/for-next
> > adjusted like this:
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index f21b2f0c6f5a..ad71f01571f0 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5052,7 +5052,11 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
> >          */
> >  
> >         if (pcs->main->size == 0) {
> > -               barn_put_empty_sheaf(barn, pcs->main);
> > +               if (!pcs->spare) {
> > +                       pcs->spare = pcs->main;
> > +               } else {
> > +                       barn_put_empty_sheaf(barn, pcs->main);
> > +               }
> >                 pcs->main = full;
> >                 return pcs;
> >         }
> 
> I noticed the previous lkp regression report and tested this fix:
> 
> * will-it-scale.per_process_ops
> 
> Compared with v6.19-rc4(f0b9d8eb98df), with this fix, I have these
> results:
> 
> nr_tasks   Delta
> 1          + 3.593%
> 8          + 3.094%
> 64         +60.247%
> 128        +49.344%
> 192        +27.500%
> 256        -12.077%
> 
> For the cases (nr_tasks: 1-192), there're the improvements. I think
> this is expected since pre-cached spare sheaf reduces spinlock race:
> reduce barn_put_empty_sheaf() & barn_get_empty_sheaf().
> 
> So (maybe too late),
> 
> Tested-by: Zhao Liu <zhao1.liu@intel.com>
> 
> 
> 
> But I find there are two more questions that might need consideration?
> 
> # Question 1: Regression for 256 tasks
> 
> For the above test - the case with nr_tasks: 256, there's a "slight"
> regression. I did more testing:
> 
> (This is a single-round test; the 256-tasks data has jitter.)
> 
> nr_tasks   Delta
> 244	     0.308%
> 248	   - 0.805%
> 252	    12.070%
> 256	   -11.441%
> 258	     2.070%
> 260	     1.252%
> 264	     2.369%
> 268	   -11.479%
> 272	     2.130%
> 292	     8.714%
> 296	    10.905%
> 298	    17.196%
> 300	    11.783%
> 302	     6.620%
> 304	     3.112%
> 308	   - 5.924%
> 
> It can be seen that most cases show improvement, though a few may
> experience slight regression.
> 
> Based on the configuration of my machine:
> 
>     GNR - 2 sockets with the following NUMA topology:
> 
>     NUMA:
>       NUMA node(s):              4
>       NUMA node0 CPU(s):         0-42,172-214
>       NUMA node1 CPU(s):         43-85,215-257
>       NUMA node2 CPU(s):         86-128,258-300
>       NUMA node3 CPU(s):         129-171,301-343
> 
> Since I set the CPU affinity on the core, 256 cases is roughly
> equivalent to the moment when Node 0 and Node 1 are filled.
> 
> The following is the perf data comparing 2 tests w/o fix & with this fix:
> 
> # Baseline  Delta Abs  Shared Object            Symbol
> # ........  .........  .......................  ....................................
> #
>     61.76%     +4.78%  [kernel.vmlinux]         [k] native_queued_spin_lock_slowpath
>      0.93%     -0.32%  [kernel.vmlinux]         [k] __slab_free
>      0.39%     -0.31%  [kernel.vmlinux]         [k] barn_get_empty_sheaf
>      1.35%     -0.30%  [kernel.vmlinux]         [k] mas_leaf_max_gap
>      3.22%     -0.30%  [kernel.vmlinux]         [k] __kmem_cache_alloc_bulk
>      1.73%     -0.20%  [kernel.vmlinux]         [k] __cond_resched
>      0.52%     -0.19%  [kernel.vmlinux]         [k] _raw_spin_lock_irqsave
>      0.92%     +0.18%  [kernel.vmlinux]         [k] _raw_spin_lock
>      1.91%     -0.15%  [kernel.vmlinux]         [k] zap_pmd_range.isra.0
>      1.37%     -0.13%  [kernel.vmlinux]         [k] mas_wr_node_store
>      1.29%     -0.12%  [kernel.vmlinux]         [k] free_pud_range
>      0.92%     -0.11%  [kernel.vmlinux]         [k] __mmap_region
>      0.12%     -0.11%  [kernel.vmlinux]         [k] barn_put_empty_sheaf
>      0.20%     -0.09%  [kernel.vmlinux]         [k] barn_replace_empty_sheaf
>      0.31%     +0.09%  [kernel.vmlinux]         [k] get_partial_node
>      0.29%     -0.07%  [kernel.vmlinux]         [k] __rcu_free_sheaf_prepare
>      0.12%     -0.07%  [kernel.vmlinux]         [k] intel_idle_xstate
>      0.21%     -0.07%  [kernel.vmlinux]         [k] __kfree_rcu_sheaf
>      0.26%     -0.07%  [kernel.vmlinux]         [k] down_write
>      0.53%     -0.06%  libc.so.6                [.] __mmap
>      0.66%     -0.06%  [kernel.vmlinux]         [k] mas_walk
>      0.48%     -0.06%  [kernel.vmlinux]         [k] mas_prev_slot
>      0.45%     -0.06%  [kernel.vmlinux]         [k] mas_find
>      0.38%     -0.06%  [kernel.vmlinux]         [k] mas_wr_store_type
>      0.23%     -0.06%  [kernel.vmlinux]         [k] do_vmi_align_munmap
>      0.21%     -0.05%  [kernel.vmlinux]         [k] perf_event_mmap_event
>      0.32%     -0.05%  [kernel.vmlinux]         [k] entry_SYSRETQ_unsafe_stack
>      0.19%     -0.05%  [kernel.vmlinux]         [k] downgrade_write
>      0.59%     -0.05%  [kernel.vmlinux]         [k] mas_next_slot
>      0.31%     -0.05%  [kernel.vmlinux]         [k] __mmap_new_vma
>      0.44%     -0.05%  [kernel.vmlinux]         [k] kmem_cache_alloc_noprof
>      0.28%     -0.05%  [kernel.vmlinux]         [k] __vma_enter_locked
>      0.41%     -0.05%  [kernel.vmlinux]         [k] memcpy
>      0.48%     -0.04%  [kernel.vmlinux]         [k] mas_store_gfp
>      0.14%     +0.04%  [kernel.vmlinux]         [k] __put_partials
>      0.19%     -0.04%  [kernel.vmlinux]         [k] mas_empty_area_rev
>      0.30%     -0.04%  [kernel.vmlinux]         [k] do_syscall_64
>      0.25%     -0.04%  [kernel.vmlinux]         [k] mas_preallocate
>      0.15%     -0.04%  [kernel.vmlinux]         [k] rcu_free_sheaf
>      0.22%     -0.04%  [kernel.vmlinux]         [k] entry_SYSCALL_64
>      0.49%     -0.04%  libc.so.6                [.] __munmap
>      0.91%     -0.04%  [kernel.vmlinux]         [k] rcu_all_qs
>      0.21%     -0.04%  [kernel.vmlinux]         [k] __vm_munmap
>      0.24%     -0.04%  [kernel.vmlinux]         [k] mas_store_prealloc
>      0.19%     -0.04%  [kernel.vmlinux]         [k] __kmalloc_cache_noprof
>      0.34%     -0.04%  [kernel.vmlinux]         [k] build_detached_freelist
>      0.19%     -0.03%  [kernel.vmlinux]         [k] vms_complete_munmap_vmas
>      0.36%     -0.03%  [kernel.vmlinux]         [k] mas_rev_awalk
>      0.05%     -0.03%  [kernel.vmlinux]         [k] shuffle_freelist
>      0.19%     -0.03%  [kernel.vmlinux]         [k] down_write_killable
>      0.19%     -0.03%  [kernel.vmlinux]         [k] kmem_cache_free
>      0.27%     -0.03%  [kernel.vmlinux]         [k] up_write
>      0.13%     -0.03%  [kernel.vmlinux]         [k] vm_area_alloc
>      0.18%     -0.03%  [kernel.vmlinux]         [k] arch_get_unmapped_area_topdown
>      0.08%     -0.03%  [kernel.vmlinux]         [k] userfaultfd_unmap_complete
>      0.10%     -0.03%  [kernel.vmlinux]         [k] tlb_gather_mmu
>      0.30%     -0.02%  [kernel.vmlinux]         [k] ___slab_alloc
> 
> I think the insteresting item is "get_partial_node". It seems this fix
> makes "get_partial_node" slightly more frequent. HMM, however, I still
> can't figure out why this is happening. Do you have any thoughts on it?

Hello, Zhao,

I tested the performance degradation issue we discussed concerning nr_tasks=256.
However, my results differ from yours, so I'd like to share my setup and
findings for clarity and comparison:

1. Machine Configuration

The topology of my machine is as follows:

CPU(s):              384
On-line CPU(s) list: 0-383
Thread(s) per core:  2
Core(s) per socket:  96
Socket(s):           2
NUMA node(s):        2

Since my machine only has 192 cores when counting physical cores, I had to
enable SMT to support the higher number of tasks in the LKP test cases. My
configuration was as follows:

will-it-scale:
  mode: process
  test: mmap2
  no_affinity: 0
  smt: 1

The sequence of test cases I used was: nr_tasks= 1, 8, 64, 128, 192, 256, 384.

I noticed that your test command did not enable SMT, but I believe this
difference should not significantly affect the results. I wanted to highlight
this to ensure we account for any potential impact these differences might have
on our results.

2. Kernel Configuration

I conducted tests using the commit f0b9d8eb98dfee8d00419aa07543bdc2c1a44fb1
first, then applied the patch and tested again.

Each test was run 10 times, and I took the average results.

3. Test Results (Without Patch vs. With Patch)

will-it-scale.1.processes -1.27%
will-it-scale.8.processes +0.19%
will-it-scale.64.processes +25.81%
will-it-scale.128.processes +112.88%
will-it-scale.192.processes +157.42%
will-it-scale.256.processes +70.63%
will-it-scale.384.processes +132.12%
will-it-scale.per_process_ops +27.21%
will-it-scale.scalability +135.10%
will-it-scale.time.involuntary_context_switches +127.54%
will-it-scale.time.voluntary_context_switches +0.01%
will-it-scale.workload +94.47%

From the above results, it appears that the patch improved performance across
the board.


4. Further Analysis

I conducted additional tests by running "./mmap2_processes -t 384 -s 25 -m" both
without and with the patch, and sampled the results using perf.

Here's the "perf report --no-children -g" output without the patch:

```
-   65.72%  mmap2_processes  [kernel.kallsyms]     [k] native_queued_spin_lock_slowpath                                                                                                  
   - 55.33% testcase
      - 55.33% __mmap                                                                                                                                                                    
         - 55.32% entry_SYSCALL_64_after_hwframe
            - do_syscall_64
               - 55.30% ksys_mmap_pgoff
                  - 55.30% vm_mmap_pgoff
                     - 55.28% do_mmap
                        - 55.24% __mmap_region
                           - 44.35% mas_preallocate
                              - 44.34% mas_alloc_nodes
                                 - 44.34% kmem_cache_alloc_noprof
                                    - 44.33% __pcs_replace_empty_main
                                       + 21.23% barn_put_empty_sheaf
                                       + 15.95% barn_get_empty_sheaf
                                       + 5.50% barn_replace_empty_sheaf
                                       + 1.33% _raw_spin_unlock_irqrestore
                           + 10.24% mas_store_prealloc
                           + 0.56% perf_event_mmap
   - 10.38% __munmap
      - 10.38% entry_SYSCALL_64_after_hwframe
         - do_syscall_64
            - 10.36% __x64_sys_munmap
               - 10.36% __vm_munmap
                  - 10.36% do_vmi_munmap
                     - 10.35% do_vmi_align_munmap
                        - 10.14% mas_store_gfp
                           - 10.13% mas_wr_node_store
                              - 10.09% kvfree_call_rcu
                                 - 10.09% __kfree_rcu_sheaf
                                    - 10.08% barn_get_empty_sheaf
                                       + 9.17% _raw_spin_lock_irqsave
                                       + 0.90% _raw_spin_unlock_irqrestore
```

Here's the "perf report --no-children -g" output with the patch:

```
+   30.36%  mmap2_processes  [kernel.kallsyms]     [k] perf_iterate_ctx
-   28.80%  mmap2_processes  [kernel.kallsyms]     [k] native_queued_spin_lock_slowpath
   - 24.72% testcase
      - 24.71% __mmap
         - 24.68% entry_SYSCALL_64_after_hwframe
            - do_syscall_64
               - 24.61% ksys_mmap_pgoff
                  - 24.57% vm_mmap_pgoff
                     - 24.51% do_mmap
                        - 24.30% __mmap_region
                           - 18.33% mas_preallocate
                              - 18.30% mas_alloc_nodes
                                 - 18.30% kmem_cache_alloc_noprof
                                    - 18.28% __pcs_replace_empty_main
                                       + 9.06% barn_replace_empty_sheaf
                                       + 6.12% barn_get_empty_sheaf
                                       + 3.09% refill_sheaf
                           + 2.94% mas_store_prealloc
                           + 2.64% perf_event_mmap
   - 4.07% __munmap
      - 4.04% entry_SYSCALL_64_after_hwframe
         - do_syscall_64
            - 3.98% __x64_sys_munmap
               - 3.98% __vm_munmap
                  - 3.95% do_vmi_munmap
                     - 3.91% do_vmi_align_munmap
                        - 2.98% mas_store_gfp
                           - 2.90% mas_wr_node_store
                              - 2.75% kvfree_call_rcu
                                 - 2.73% __kfree_rcu_sheaf
                                    - 2.71% barn_get_empty_sheaf
                                       + 1.68% _raw_spin_lock_irqsave
                                       + 1.03% _raw_spin_unlock_irqrestore
                        - 0.76% vms_complete_munmap_vmas
                             0.67% vms_clear_ptes.part.41
```

Using perf diff, I compared the results before and after applying the patch:

```
# Event 'cycles:P'
#
# Baseline  Delta Abs  Shared Object         Symbol
# ........  .........  ....................  ..................................................
#
    65.72%    -36.92%  [kernel.kallsyms]     [k] native_queued_spin_lock_slowpath
    14.65%    +15.70%  [kernel.kallsyms]     [k] perf_iterate_ctx
     2.10%     +2.45%  [kernel.kallsyms]     [k] unmap_page_range
     1.09%     +1.26%  [kernel.kallsyms]     [k] mas_wr_node_store
     1.01%     +1.14%  [kernel.kallsyms]     [k] free_pgd_range
     0.84%     +0.92%  [kernel.kallsyms]     [k] __mmap_region
     0.50%     +0.76%  [kernel.kallsyms]     [k] memcpy
     0.62%     +0.63%  [kernel.kallsyms]     [k] __cond_resched
     0.49%     +0.51%  [kernel.kallsyms]     [k] mas_walk
     0.39%     +0.42%  [kernel.kallsyms]     [k] mas_empty_area_rev
     0.32%     +0.40%  [kernel.kallsyms]     [k] mas_next_slot
     0.34%     +0.39%  [kernel.kallsyms]     [k] refill_sheaf
     0.26%     +0.36%  [kernel.kallsyms]     [k] mas_prev_slot
     0.24%     +0.29%  [kernel.kallsyms]     [k] do_syscall_64
     0.25%     +0.28%  [kernel.kallsyms]     [k] mas_find
     0.20%     +0.28%  [kernel.kallsyms]     [k] kmem_cache_alloc_noprof
     0.24%     +0.27%  [kernel.kallsyms]     [k] strlen
     0.26%     +0.27%  [kernel.kallsyms]     [k] perf_event_mmap
     0.25%     +0.26%  [kernel.kallsyms]     [k] do_mmap
     0.22%     +0.25%  [kernel.kallsyms]     [k] mas_store_gfp
     0.25%     +0.24%  [kernel.kallsyms]     [k] mas_leaf_max_gap
```


I also sampled the execution counts of several key functions using bpftrace.

Without Patch:

```
@cnt[barn_put_empty_sheaf]: 38833037
@cnt[barn_replace_empty_sheaf]: 41883891
@cnt[__pcs_replace_empty_main]: 41884885
@cnt[barn_get_empty_sheaf]: 75422518
@cnt[mmap]: 489634255
```

With Patch:

```
@cnt[barn_put_empty_sheaf]: 2382910
@cnt[barn_replace_empty_sheaf]: 90681637
@cnt[__pcs_replace_empty_main]: 90683656
@cnt[barn_get_empty_sheaf]: 82710919
@cnt[mmap]: 1113853385
```

From the above results, I found that the execution count of the
barn_put_empty_sheaf function dropped by an order of magnitude after applying
the patch. This is likely due to the patch's effect: when pcs->spare is NULL,
the empty sheaf is cached in pcs->spare instead of calling barn_put_empty_sheaf.
This reduces contention on the barn spinlock significantly.

At the same time, I noticed that the execution counts for
barn_replace_empty_sheaf and __pcs_replace_empty_main increased, but their
proportion in the perf sampling decreased. This suggests that the average
execution time for these functions has decreased.

Moreover, the total number of mmap executions after applying the patch
(1113853385) is more than double that of the unpatched kernel (489634255). This
further supports our analysis: since the test case duration is fixed at 25
seconds, the patched kernel runs faster, resulting in more iterations of the
test case and more mmap executions, which in turn increases the frequency of
these functions being called.

Based on my tests, everything appears reasonable and explainable. However, I
couldn't reproduce the performance drop for nr_tasks=256, and it's unclear why
our results differ. I'd appreciate it if you could share any additional insights
or thoughts on what might be causing this discrepancy. If needed, we could also
consult Vlastimil for further suggestions to better understand the issue or
explore other potential factors.

Thanks!

-- 
Thanks,
Hao

> 
> # Question 2: sheaf capacity
> 
> Back the original commit which triggerred lkp regression. I did more
> testing to check if this fix could totally fill the regression gap.
> 
> The base line is commit 3accabda4 ("mm, vma: use percpu sheaves for
> vm_area_struct cache") and its next commit 59faa4da7cd4 ("maple_tree:
> use percpu sheaves for maple_node_cache") has the regression.
> 
> I compared v6.19-rc4(f0b9d8eb98df) w/o fix & with fix aginst the base
> line:
> 
> nr_tasks	w/o fix         with fix
> 1		- 3.643%	- 0.181%
> 8		-12.523%	- 9.816%
> 64		-50.378%	-20.482%
> 128		-36.736%	- 5.518%
> 192		-22.963%	- 1.777%
> 256		-32.926%	- 41.026%
> 
> It appears that under extreme conditions, regression remains significate.
> I remembered your suggestion about larger capacity and did the following
> testing:
> 
> 	59faa4da7cd4	59faa4da7cd4	59faa4da7cd4	59faa4da7cd4	59faa4da7cd4
> 			(with this fix)	(cap: 32->64)	(cap: 32->128)	(cap: 32->256)
> 1	-8.789%		-8.805%		-8.185%		-9.912%		-8.673%
> 8	-12.256%	-9.219%		-10.460%	-10.070%	-8.819%
> 64	-38.915%	-8.172%		-4.700%		4.571%		8.793%
> 128	-8.032%		11.377%		23.232%		26.940%		30.573%
> 192	-1.220%		9.758%		20.573%		22.645%		25.768%
> 256	-6.570%		9.967%		21.663%		30.103%		33.876%
> 
> Comparing with base line (3accabda4), larger capacity could
> significatly improve the Sheaf's scalability.
> 
> So, I'd like to know if you think dynamically or adaptively adjusting
> capacity is a worthwhile idea.
> 
> Thanks for your patience.
> 
> Regards,
> Zhao
> 
> 

