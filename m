Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC37ED4A5F9
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 04:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B96A6B0005; Thu, 15 Jan 2026 23:06:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4674B6B0088; Thu, 15 Jan 2026 23:06:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372D26B0089; Thu, 15 Jan 2026 23:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2429D6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:06:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDE671B9B2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:06:27 +0000 (UTC)
X-FDA: 84336490014.07.5AF7F66
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id E44CC1C0004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:06:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wzrpic83;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768536386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rl3VepKzZpDG9b9saQeL8NDmwp28k3iNH4hRxW9LzEY=;
	b=wPio1h7vcnD1tQYXTBOGLyhaXIdyKlWziYPXCVdgUVlmfgafFmyz6CpUUxx5PP4XYF9c3/
	47AwCv6jzMyT0JKRSgja3jHIUM9lATIbOBXGMza9aWjyhVGV7lBUwn62Pkv5rtIz5ODZGA
	4eFkbSWImnvaHRbCggu5srme3F5BFxM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wzrpic83;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768536386; a=rsa-sha256;
	cv=none;
	b=xFmyV0zOzw0uLUsdHmk5Xu5HyVOtqI4SIxgnD1q8oBLemTRzkZIa0zdXn5Wy4DqpMQrbKT
	JK0fB5a2cQrR5kLb2+qnbhy3wT5PvHWEcZ8q54+2l9Opp43fqglKWbjPLSSsbrEX+wl2XG
	w3p4Tqi4Ancfe7hXtpfl1B/kXEXqsl0=
Date: Fri, 16 Jan 2026 12:06:12 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768536382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rl3VepKzZpDG9b9saQeL8NDmwp28k3iNH4hRxW9LzEY=;
	b=Wzrpic83IluGlrgKf8BYeXUNMmOpemVOAsD14O3SsIdK8ilzk4qhUCzUyxV1fikAboEYGJ
	IMGiOIeTCdDOjA/g/ZFZDa9/OyeFvervQos5SX8WiKn4b4GMKmGdHFwZZyS7gU4gpX3myt
	wo64a2atYEL6SKtojnp0CZt6wcTUQts=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Hao Li <haolee.swjtu@gmail.com>, 
	akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	tim.c.chen@intel.com, yu.c.chen@intel.com
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <3foece42fc3wj3wgcnibi7cn2be73ancyjgrzdqfjeqvjtwkhj@lzqd572wfpvz>
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
 <aWi9nAbIkTfYFoMM@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWi9nAbIkTfYFoMM@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E44CC1C0004
X-Stat-Signature: ze685pze85uhrykjar8ptxn15o9xzjhf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768536385-640040
X-HE-Meta: U2FsdGVkX1+ESLeQ+KqqoDXUCzps3YdofMt6Mc6aBRpGIWoMsxcPNmbId+pKIfN6CREkb0oKpjIP42Rb/kt4feQHl86BkBAgpM0+eFs5a1HJC45CR41FhWdYddakJHP9UrGaeK09jWIv+QQ5QlBm811BEPEECRtyy31blSSRHRrqgfYL8B7E+WCJpMRQf3uuR/0v+2nTx5o1x3Gv6xIJF2kvY2RRQUuwIJcMx5g0YjZympW7+L/atY0FbVnE6pjXs4hVLmtEvNHfqjH5JFrkoxemsI8uQYmC8A7Pzbfax3s9L0IWfE/eJGP/IrPD8GXxziaqM/zHIm1j6xFMFizRG/2Po2kMjBe+qJi2/e7/+uJdm2SCPquJPR9UwWLuIy+zAb4llhp/BJxsFpRD57Nwc9ZMw6GnC6IDspc+NTLYzsa8xehlbRqFPGdp3N6kGNNOtV/MAfqpPX7TL4gsOSYkV2GOFWTDLOGpp1Cmc6h7xAuNr9nu0yaN6zQ8AspYpsDfpLQPvGRg3evu0E2wpcF7kiB08FYCsVW18pZCix5dx2INTLlTiPfhU1EL3otcXU26MOHOadNsmX2ykEtHbla1MjbPZC4zDxjYw/uZJDpnTm5xJqilt/4jPV1RyS3wmfIdEEFPT7GBnn0xJ0lAnKnHxJtT9n9Kmt7dofwCcRXqfMRxBKMRvTERuxZGer7eu5/vWSy+aRcdOh9HceyGiuVMnsrkPPmNxa7+80ixEaa31/+MXWXf5fOnCm/HNOurjfaV68iigv21fvlDmkIqRmTiyzm5XEYqSZW9pCvCEenU6+JOxX3+LTFCkY5mlFf3Xq5ojh4VBm3yM1lchwHHn7mDij71QQ9QMpWQXUbe0Vb2xb8IkU+L0bc/X47fLhoOMII+AMYfZXv4+TR1D3rLtfCzmSRzS45yHspFk2dxwwc3U1/8vQBb0eDFoTN66w66/oYCOBCA1HrxyV27ezLT9x5
 NTXOLO/7
 6e7iMWIa67buFFcWmtWJ+SYK59WBP/PW6QdxihTzQuSjAS0wH55V32U0EdT6yyqt4+KmKCr9qywb80gb4w4u0u7tF752zOZSJT0IBVfGvuVvD3UyPGv35ni2XlMy6pN4S0snWSH/SyWm/7I2FzAWpQ/DjBPo/p1ajuf6Lnt85N0Qinul8RCOzNEvaCXBXx9A42hZ6LzE1wYN5k9jA9ol1esiMRHIaSP3sNA0QtY3J4b0NtKhYVkZ87rrmOZOqVOGfUHnrQSJu+fDiqsg1Wa0CaKcq+EXjTr4eNk/kiYVR7lGxSSE9Lual7t1xuXMm/6xNpi9anpRq6aqG9YrCyk46xTJ9rLySjrO0/yE0
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

Hello, Zhao,

Thanks for running the performance test!

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

I'd like to dig a bit deeper to confirm whether the "256 tasks" result is truly
a regression. Could you please share the original full report, or let me know
which test case under will-it-scale/ you used?

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

