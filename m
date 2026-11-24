Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1F5606A323
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XV4ByG2X
Received: by kanga.kvack.org (Postfix)
	id 5BCFF6B082F; Tue, 24 Nov 2026 13:37:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CF56B0831; Tue, 24 Nov 2026 13:37:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434786B0832; Tue, 24 Nov 2026 13:37:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FE046B082F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:37:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 779701A0BFD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:37:48 +0000 (UTC)
X-FDA: 85470871416.20.0E6FB9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A261410000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:37:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XV4ByG2X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795545466;
	b=cH6PGgssstFxj2pH9Nu2d0UuLEJjwYM2eSSmaHeDvEJUYLZpC/JMzgWh4FmwzlaFAz5UP5
	OcseBzoImkAtITy9ePBY3ugbHAG6iXX1h0yy7lCIzYhzwhhXP4M082gjp0GE+quqy5OhIw
	0DwPNYIj7EcGgGPI3JJrG6EvZncwI1g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795545466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zoOCvzXXxSjQ7psF4Sy29PKoeBfrrhdMZ3HpFuOxUw=;
	b=E42tKnQ6A9j5hKDL/vRMtk8X6lcbEf9cqpK5YexFtioLmNQSbnHhlejsA/OZHY3/eYwTEk
	w+JJ397NbhuSCGO7GlmIoSbpxiH4mQ6EI6PYZvtuBQTMpzvi/NgK2WwcrMQqcum4I5PIzP
	6vJORj8h9fLAv2XmHqjoOzGMMBYD3M0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XV4ByG2X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13F7F4036A;
	Tue, 24 Nov 2026 18:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913561F000CF;
	Tue, 24 Nov 2026 18:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795545464;
	bh=1zoOCvzXXxSjQ7psF4Sy29PKoeBfrrhdMZ3HpFuOxUw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XV4ByG2XuzrRqRUkVee62FtVwtGgTWPmdUBklGJb424G4LLlpAtHqrmXf6s0G3W+A
	 Q3NrSDu7uJHYRw5azuUfvjpsjI8bgbSorFLdlAJSfNw45tvlIcrrFVD38ufggAp4w8
	 VG2xL/O5+lREKTAZu+jda5NIwR8XVt8/6JgLaZR3gdh12O0AsG9v6faZj4zUQninYN
	 y20o4UKbarZ+wPITdIarifBBNF7cZx59m44UsYvivZPDArXuZD9cAyTxM9snwDeDsE
	 Y9lMggrHiyjs07iCopzSQIdIEd8e/bHVww0DWHMUVP++Ey2MvhqfafsQRlgjPWrhvP
	 H2JsNFWKnROiQ==
Message-ID: <5e26dc91-37e9-4c29-b88a-bb3a3358709c@kernel.org>
Date: Tue, 24 Nov 2026 19:37:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 Jann Horn <jannh@google.com>, Puranjay Mohan <puranjay@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: p5rjqg3r7onsug5kkwpuczizipy1m8jt
X-Rspamd-Queue-Id: A261410000B
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795545466-623741
X-HE-Meta: U2FsdGVkX18j8jJXPYqVqVcAD1SG75iGKBdNXLlICcYVpkP1Xkp/HKcCsuDdtXuIhPXG9k9dK2ENG5+jDdI6ryt4IcTmZTUDxgLT4QTzfSDJkQ/PlBWD0ZmwtQHuHw1hDDGRjgWoTOwGJFlNIRmvlHuGM60G9fi+wKNHfSXjfeoc316aAZb+dINiff5zypUVgxfxfpq0Ouq4nKjall4Un+2lYdD0Ldh08dFEJODJQ/D4dQohZGXv2cxBy2AmU1ejboM778GfmortDGFO6IEV7YNx0nySGZcwla4YWSwxTqj89IlcOLcP+XK2A5T8DxN9kwDwkoSVWY8Hyz7YGArG05Cw1wal/GTbH45fgGHStwq1Sld3yMs1+kgIOmhna25WzsoWDpNbEEFm7nf4e2P6cS0Pm3/C4s3bhtXx4Q6QDxuoePe2iDxNux+ewaby5UpTPYzKwEWPjcGhS8tCVZxkmFdJFt1XCLx4ZzcNjRtKIy8tEaMEau96l8VQKnIk+35QZuBcXYRX5Fcr8q3P6fF+/F8MT0XpNrsiMd/wJgvRnPpT+UYZnTn3jkdLKI/2bXHSO+jc8Q68WgoznbDrrlzaJilkIIdTcrnFAcFelpL0U3A+zI8eP6dxU/yvRb9qnKqIP0C0JBZI7rNLdfaS2NcoshSTvLKOso+Lg90cw4DvJYR6CTcflq0LvEy8dyIpIfa+hBZGML4RZhF0+6iLzGK0IpxTZ7nb08XLdhi/NDwCfofZy5kB8mprH4pfMxNYmnCr+i5JhB5EbmdBy1niYq3G7xkMLWdJ0sqxzSaVmBOH9sbUfAw8iBnpymqpZguR+bi1WNis25LBE6k6ImMtIHzwlpG3VYrbGgZste2Umch3J8MTBrnsG3XCm2KOg55NB8BmYEog5kvIENVR8ZG9CdUt3J3Sj74wnE/H3xhNoOXiIGs8SNtZEyD6JpdC4yGS2ioKR/rOukEoP6b2KsnDYpf
 f6A3Q2T6
 vKwlewPeQAyySZCW7KlGsMCVuQGggMOVfAr6idFaMT309VGi3GVLFSssyw1k+OeoXBj0D5FvZQsqVnOQjSNb61PizRXPDuzAuvxVzkfRC6qnpwBKUe9bvHRicKhdZ0+COKbVNg77YlmNWemsjkoJKgWr2BXnwR8uuydJwnUMxjjS3QOLZzXjNH94p0yySGO6AYWxdYAddOsAQkUDi2ofFZVTfch2PdQjohy8ZRP6009+lRVZ9ZG6ggEJCOn37vEjwaWFqdyXalmYv27/6LnpMZUfCHM2NODWlIw6dCrlnzPXpCg5FWxSnnrFdbN1j/jGGJ9x3gQsfo5u/WJ991mA9mAT2wGyuAZ5ZWExS9PAsbQhcM/X+UDnzd61eu//5DQCtcWfPzMmZcUKnsDePuv1iuWfM0ouSEFw2NsWsyXCXeS0FniIdc6kDUBlIL0/trLpPv/224aEr1Ag8iZpw2koA7HSwIXbzx+zj317WgE1RXgw92m2ihcyotk+DrNnD4ozdwhZfVEXMIA0aAG62w+Fg68ShBwai06H/AObbG+a858eTxl+p5MSNdH0AqkUL8wHd1uDRkv+N6XYPIW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 13:26, Lorenzo Stoakes (ARM) wrote:
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
> For the sake of a backported fix, retain this behaviour, however drop the
> RCU lock last and remove the now irrelevant comment.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to per-VMA locks")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/DN267JUKDRNS.2VMV07CQ58R4X@gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Given how it should be rare to actually drop the mm here, it should be fine.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  kernel/fork.c  | 16 ----------------
>  mm/internal.h  |  3 +++
>  mm/mmap_lock.c | 21 ++++++++++++++++++---
>  3 files changed, 21 insertions(+), 19 deletions(-)
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
> index 073c5125b424..28b387fe543a 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -306,11 +306,10 @@ static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  	 */
>  	other_mm = vma->vm_mm; /* use a copy as vma can be freed after we drop vm_refcnt */
>  
> -	/* __mmdrop() is a heavy operation, do it after dropping RCU lock. */
> -	rcu_read_unlock();
>  	mmgrab(other_mm);
>  	vma_refcount_put(vma);
> -	mmdrop(other_mm);
> +	mmdrop_async(other_mm);
> +	rcu_read_unlock();
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


