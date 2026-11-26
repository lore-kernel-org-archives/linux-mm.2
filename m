Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F31606A326
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 20:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=SFw+Al6F
Received: by kanga.kvack.org (Postfix)
	id B716C6B05B4; Thu, 26 Nov 2026 15:28:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA1A6B05B5; Thu, 26 Nov 2026 15:28:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3406B05B6; Thu, 26 Nov 2026 15:28:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59BD66B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:28:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE64D1C0165
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:28:22 +0000 (UTC)
X-FDA: 85478407644.14.06D0657
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8F7D040002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:28:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SFw+Al6F;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795724901;
	b=5joDl93hMQKuqHClqDgxxl8X2vdXqlbO5s7Y1B/3ESYDpQybo6AR4EZzRtWYbaxBaKS+9M
	ruyC1e328oZtWlCV9hVofKZ2bsgSTuY1FE1utGTnK5VmBiGvvcvgbhvGod1LoedfP+qdWK
	RvPgrDTPAQ2VnuYNiqtS10qtBsIoMi8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795724901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+PZxCBsSa9CaPD1mxweKbYUrMjw4HQHJ4ZtYjAEGa8=;
	b=JTXJ1FAefADbujqQyCuguYayRZ6iBO0AS3IXOSoAjTpGvZzOevEuRu7LGuEnfeOIDyzomS
	Evh+t6+PsT7yWsiXxkUBBYS/J8oBdkvKe7BkNeFw2ye00hesf6+wrVpNGxlRP87xfW4A7F
	+FuvEgiv1CSLVNXzvLU0LPvCGtJerGE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SFw+Al6F;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y+PZxCBsSa9CaPD1mxweKbYUrMjw4HQHJ4ZtYjAEGa8=; b=SFw+Al6FlSMRL+KFWLN6+G3aW1
	rGeeoQojH84twShugOLsskqJ0kZzHYpcEdebm80H4xCeChVYAHnSNM6k7KT95ZDIvqUSXO2FZgxjG
	5ygr5vaNTbzURCs6K286zjkA0CAX2X7Me742aRJY9Y1A8u8mimmTmYfLgNQ3Ppmt9NhK4v09qB7w7
	sXyJJysxMP42R5N88/unub5bpAGyyhQwHvoS0MYE72PU+x+Q6+Mom+l0bSco0K+KIhRNqKs2LfE2x
	uFqD0VVEkY/X5asxOZOy66pOAtQGlkz+73HHzIxNWL9+O5uD1i2RJlxrsXokPhxhnDm9mHMiaiqhl
	NXOh0vOA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWg4i-0000000ESgO-0GDX;
	Thu, 26 Nov 2026 20:28:12 +0000
Date: Thu, 26 Nov 2026 15:28:08 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, Jann Horn <jannh@google.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/vma: drop mm asynchronously in vma_start_read()
Message-ID: <mhibvp7socozh4kdctbopbkpngta7a6mol3u57hly7cu35rgpo@s6yvqaq2dm5y>
References: <20261124-vma-read-lock-mmdrop-async-v2-1-8139b5cf24bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-vma-read-lock-mmdrop-async-v2-1-8139b5cf24bb@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F7D040002
X-Rspam-User:
X-Stat-Signature: 9usyokatgi8gw6gfoxdtaib4caisr11r
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795724900-143667
X-HE-Meta: U2FsdGVkX1+0d44WZ01Uu5A3sY67xfN1SfOX1x2Xdr1lx6byfaqvic7glbe8VGfW6ENvoWJGa2BdFRKllgHgaLzMnmOfXZQBBj0Kph3h+C46UByKgQCm8z7DwkDDitv4W/HnXGnwYiZ7s5JqrluHIhFVOR/zDLueqsfHfvV2mLGMSNC/S2ltJMeSoQvQXAYqoYP3N08Zd15Yd7mKkMqZobCzVGUNX8IoOdFs7thCt3X4UoqC/pD6X7tPzINmeX1iKbIZbquV5A7mnekjxokNQDFMpowydnzfbmZ21ETZuut0KFYRIT2faKAJMIVpDesWUhrTjpjsDO2vDheSAKftgk6SFyyw2JE5KGIAIhyRcehxzESmSRO5xzXzeg+KhjDbrCLes/yGxlv+PgDbtmpSPeU588o+S0KNKSSCGrM3WPDX/WCs/CHn1C6PJwAEmzzWNB1/bdBZMcE0v9Jg7CUZ3kRKyeLi+gh+nzW3GdyKH2d8N2imGNS5cPzHoiHDj68ztbiwta9pq+XydAclxDwsI2JEym6VcPNW/GX6bni7A2BA4LLHim38p/ubwKnBRqtTTPzFaHnRpPYpvyFFdDhbhhjdICWQdIF6HasVqLuR7KlOk8pOd4ezKUAw8zY2NZCj1wG/cHAdi+jP4qDSc1+t6Sb5a+RuX5xZbTqgiqTJIaLcVzuruVozQSu0urCRZJe2lY4p2C+2Lr97PKDtr4yy6ypbDju8Eh5BtTgj1nodUkmCdlsSljYEodK3MIOTLIC3agP/dS6bxDi5kSI+DLpYqpHdcAzw8zpfuAxhrdIsY9NatapoSjK0eSI13GHAvb3YnDvwKKugfvsafPUkfKfNgXYaKapgOhrRFF2ixTqvMW59ofTT/Yo/E0ZPzu1qlwlKrLcuQhpVa5JBWpJSH96Gct7MLxCdgGV+TWT0JqIUtSWqAiz/TTO4PCEUAgQPVObftyUq+6CCc0TBmMkhnTc
 XXHVC/VB
 5VUOPKX5BiZxX15SzuPME/sW+JCP8LU2fBgxgpKTWHgEhlmuYr/RlLvPuely+h5BskAlFjymPHKenMVpNQZVbrMMtk11ARCK7X4h6u4qYCNx+KaGFdWkBNfblGJ3DqYrfc3KWiQSkBtSk1SWDR80WT/rdhI86D4DbXcB2d/iSCyNND13eOIlHqqX6nunR3Cc76PwZ9S1jbcOc3spCTH+QUwotDbHWJqles2LEDmXRNqqrUPZpg0bJOBy3TBWmm/y9dthmuC9E+Rk4Ak1R+FUvBipPUQABi/nWo88miuiJnHn/plXZ58aKezwNULbcLiOcc0kqNAJuiITHUqFNxcckxWyYyl9uUov1ZOtnyZpHxxms37ZviQ+4DQoNUiEnGscdTc1CAJa4+AszVjiQsZa9KbucrppJO3pZqftLZBB8pFI75A4MXttmTncI+uyxtQgr//3ZZ5aHHR0Rmj1Ji9pevh1KTJZh5DVwaIcUL7y4X/DH1xMGhoiOv0TIZOWoIBtegIwr3PYKrnknahRi9n8vQBGlsd+Y/vKMABAIOa2C09LtxwRrJIlKVCtyen6IfiAYxRNvVemeqcu3iO+2+0HsAzVCEOpR1FMa884KcTJdeZqVkX+kx1LSXiuy6hoWjxLBoP/NyCya111dnQzXY9cjnfQNgMbIv5HGM2U7UvzGmdmhYvZSCheLeYNRqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/24 06:56PM, Lorenzo Stoakes (ARM) wrote:
> Commit bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to
> per-VMA locks") open-codes a lock_next_vma() implementation that does
> roughly the same thing in bpf_iter_task_vma_find_next(), only without
> fallback to an mmap_lock.
> 
> This is because bpf_iter_task_vma_find_next() can be called from
> non-sleepable contexts.
> 
> However, lock_vma_under_rcu() gave no guarantee as to which contexts it is
> safe to be called from, and indeed it turns out this assumption is unsafe.
> 
> Since commit 9bbffee67ffd ("mm: fix a UAF when vma->mm is freed after
> vma->vm_refcnt got dropped"), this call chain is possible on x86:
> 
> lock_vma_under_rcu()
>   -> vma_start_read()
>     -> mmdrop()
>       -> __mmdrop()
>         -> mm_free_pgd()
>           -> pgd_free()
>             -> pgd_dtor()
>               -> spin_lock(&pgd_lock)
> 
> Thus, a plain spin_lock() can occur when lock_vma_under_rcu() is
> called. Since bpf_iter_task_vma_find_next() can be called in softirq
> context, this can deadlock, for example:
> 
> pgd_alloc()
>   -> spin_lock(&pgd_lock)
>     <softirq>
>     bpf_iter_task_vma_next()
>       -> lock_vma_under_rcu()
>         ...
> 	  -> spin_lock(&pgd_lock) [ DEADLOCK ]
> 
> Alexei Starovoitov also pointed out that a BPF program attached to
> trace_contention_end() can similarly cause a deadlock:
> 
>   pgd_alloc()
>     spin_lock(&pgd_lock)
>       queued_spin_lock_slowpath()
>         trace_contention_end()          <- pgd_lock is held
>           tp_btf/contention_end prog
>             bpf_iter_task_vma_next()
>               lock_vma_under_rcu()
>                 vma_start_read()
>                   mmdrop(other_mm)      <- last put takes pgd_lock again
> 
> Resolve the issue by having vma_start_read() use mmdrop_async() instead of
> mmdrop() so the work is deferred to a work queue.
> 
> Make mmdrop_async() an internal mm function, defined in mm/internal.h, to
> avoid abuse elsewhere (kernel/fork.c includes this header, so still retains
> access).
> 
> Commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on
> failure") accounted for the fact that the RCU lock had to be dropped for
> this operation, which is no longer applicable.
> 
> Remove the now-defunct comment on the 'heavy operation', but leave
> examining that to a follow up.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to per-VMA locks")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/DN267JUKDRNS.2VMV07CQ58R4X@gmail.com/
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
> v2:
> * Put the rcu_read_unlock() back where it was, a follow-up can address
>   anything else here.
> 
> v1:
> https://lore.kernel.org/r/20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org
> ---
>  kernel/fork.c  | 16 ----------------
>  mm/internal.h  |  3 +++
>  mm/mmap_lock.c | 19 +++++++++++++++++--
>  3 files changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5efceb8d58a7..4d5866c83481 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -744,22 +744,6 @@ void __mmdrop(struct mm_struct *mm)
>  }
>  EXPORT_SYMBOL_GPL(__mmdrop);
>  
> -static void mmdrop_async_fn(struct work_struct *work)
> -{
> -	struct mm_struct *mm;
> -
> -	mm = container_of(work, struct mm_struct, async_put_work);
> -	__mmdrop(mm);
> -}
> -
> -static void mmdrop_async(struct mm_struct *mm)
> -{
> -	if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
> -		INIT_WORK(&mm->async_put_work, mmdrop_async_fn);
> -		schedule_work(&mm->async_put_work);
> -	}
> -}
> -
>  static inline void free_signal_struct(struct signal_struct *sig)
>  {
>  	taskstats_tgid_free(sig);
> diff --git a/mm/internal.h b/mm/internal.h
> index de4593b3e3b6..cc95019c7e4b 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1671,4 +1671,7 @@ static inline bool can_spin_trylock(void)
>  /* char-mem.c */
>  bool file_is_dev_zero(const struct file *file);
>  
> +/* mmap_lock.c */
> +void mmdrop_async(struct mm_struct *mm);
> +
>  #endif	/* __MM_INTERNAL_H */
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 073c5125b424..d28bbc3ba734 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -306,11 +306,10 @@ static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  	 */
>  	other_mm = vma->vm_mm; /* use a copy as vma can be freed after we drop vm_refcnt */
>  
> -	/* __mmdrop() is a heavy operation, do it after dropping RCU lock. */
>  	rcu_read_unlock();
>  	mmgrab(other_mm);
>  	vma_refcount_put(vma);
> -	mmdrop(other_mm);
> +	mmdrop_async(other_mm);
>  
>  	return NULL;
>  }
> @@ -560,6 +559,22 @@ void __mm_reset_vma_seqcounts(struct mm_struct *mm)
>  }
>  EXPORT_SYMBOL(__mm_reset_vma_seqcounts);
>  
> +static void mmdrop_async_fn(struct work_struct *work)
> +{
> +	struct mm_struct *mm;
> +
> +	mm = container_of(work, struct mm_struct, async_put_work);
> +	__mmdrop(mm);
> +}
> +
> +void mmdrop_async(struct mm_struct *mm)
> +{
> +	if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
> +		INIT_WORK(&mm->async_put_work, mmdrop_async_fn);
> +		schedule_work(&mm->async_put_work);
> +	}
> +}
> +
>  #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
>  #include <linux/extable.h>
>  
> 
> ---
> base-commit: 913390e679e23e3a45643028ee7f992889094051
> change-id: 20261124-vma-read-lock-mmdrop-async-ba417cd1c1f0
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

