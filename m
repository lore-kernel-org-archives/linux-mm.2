Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9185B606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZSqX/PyV
Received: by kanga.kvack.org (Postfix)
	id 8CDF96B00EF; Sat, 21 Nov 2026 08:41:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F236B05B0; Sat, 21 Nov 2026 08:41:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7957E6B05B1; Sat, 21 Nov 2026 08:41:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50A0F6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:41:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B498CC04B8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:41:05 +0000 (UTC)
X-FDA: 85459237290.11.587E674
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0430D16000E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:41:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZSqX/PyV";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795268464;
	b=iBHibSmy0xzFPqbNGvT5CbutdHQtnIkjDLG6x0Vus9eXvq9C8sxLi4R80njml3NYO2JwNJ
	+ndVx6IKAg61udeC9fYznjM0PlsA2iBJmcmB5EEGEKkLcD2YNyv/VyJ4ShSwjvUYRD2gtQ
	SoJGXxwTr38SCQEeW3kEX0Vi2OjTous=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795268464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ze1XfukPlqWhXxeWdokIWjjT48DYgRLaaIcyK/o1tvY=;
	b=ZEHJFEhvZ/VDPm5C28ZnPlhU3chBsb9o7Fbdh7ECVwoqL+ZNSHUm80jGiusu4n7NlzBTY9
	VDepntvH/pkmW+Fxjaf46khSBhrvwh/l/hLrm0yJ/nkDHnum9IqSLUO/3GQ9TmvAEAi504
	/3P7m/DRwhTo5pwn/RX2Q+ID3pDqq0E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZSqX/PyV";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C0FB618F4;
	Sat, 21 Nov 2026 13:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442B71F000C4;
	Sat, 21 Nov 2026 13:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795268463;
	bh=ze1XfukPlqWhXxeWdokIWjjT48DYgRLaaIcyK/o1tvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZSqX/PyVpC6CU3SbqRR0szuxDgrLoipoK/D/Ig/FHo35MdiG+Ydp5+aj9HmGVa3Gp
	 H2yER/nX/UTD6DVV5O103kQGVpQuzF4nMslta1M7zMkk5xcWKlsSf/ga/tCH7aQKcb
	 3VnjmmgwbvqEsvYj+pKAjA+hAIT+RKjbW99SbaShivw6OEIQyyiXSpbcYRip3QaPgH
	 s+jVOEs76rgL24ZMdObAW0nAsidspJsJtaiDkFWrENsJQGQs4gGUwpk+fPvOTgYa1+
	 0cVKhp972pjgRkR708MODoEolIhsxwlseMaonESYnR3c7K/00fR3uU58VgCn5J318p
	 BtUS7JnPLP4wg==
Date: Sat, 21 Nov 2026 13:40:54 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Puranjay Mohan <puranjay@kernel.org>
Cc: bpf@vger.kernel.org, Puranjay Mohan <puranjay12@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>, kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH bpf v6 2/3] bpf: switch task_vma iterator from mmap_lock
 to per-VMA locks
Message-ID: <awGZWsCp6v63H_py@gremlin>
References: <20260408154539.3832150-1-puranjay@kernel.org>
 <20260408154539.3832150-3-puranjay@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408154539.3832150-3-puranjay@kernel.org>
X-Rspam-User:
X-Rspamd-Queue-Id: 0430D16000E
X-Stat-Signature: 4cbx5cgz7ghfqcm77ykmps7yz8i4rxm8
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795268463-229608
X-HE-Meta: U2FsdGVkX1/1scjnK4jWbyKTtiAj5cqPiEzBs1HbeonqxGxSPZ1Aflt/U8UCSfVPomzRnyIVt/u8+Ve91gbHvjLpn1wQfL1lI4rUULyA2gZouDtKCxF9GF4wEyc9xBDrFX7HekknNLE96kHsT4hMqxFEAe4Ue0RVww6JZ4vbEcE4OIev9q++dc/05Tpa7wTYpdTQtSu9eHKMy0MtUZKob+oXdDdomCahJzx4rvKjmoepDBpzJ1Frstajr/dJlJw/oV9jHB+iONzVIzeRJEFSV2VPypgUyqLAIafvBdWchZFMrZ0byiWSsrPVgsFZusAcSQeTSsXWhXnC6+MBRtbLMKFBQk+hmtl6AZaE4D2ukM/e1WvBK29r+Fvx5GODvG7NqmyLFwJePWwGGisKwQlmOW4Enu5Ej3xGEex7zVat5hyEzz+88/iZnWt7q3LzQ1d3dvaoLdeZ20rg/QZ78KK5ocyIopjOMyL0UbzUlJhbuyHi0BZ3sRtv3769bBMW/v77iKUFlQQXlIKMAxc5BXMO3FZ/a2yiEqFCYAopPm7YCMMdn5NApozJSgAvd4d9x9beLknRWgFvkAgsJzowk4qQmx0FN4dvq2VbwYpjYbjU11p34fq+Yv91kSzncox2IyC10iNjxShjUPVR8WvPKdO5rthyCtqToXU/MamLnzRAetCQS1L9eLGVHgawIqpQq0eVevgnVe4hug70jO1ar6wY8mxDkWLBoA1wBwpI5ClOOeED3OXtB+i+ERAff9QfcHr/3Pah3FPQfmQMmHVmL3UBUBLxPvPq87x34LKGeBDEOomXKTlasobil90pGhlGnRBWG5Gt7v8sQaKbTTjHBaprYt9ez1KSi450MDlOsHlf9CgPF/JrC2X2rq/fD+sL6t3s12+7WhaMkLEQFq0cJ3bi8EWGJlwy1vxtaq34C5FO6quWaYkOzAY9g+8uN1ZJM3w1BHmGm04D3zPhqvBvplb
 2ja8iYkS
 kMdxCdlCxEB+6GVYZrRpX0aiYeVVVcAf0Ps6GkUrMaOZlakGUgB9bPfH1l4B3sOlRufzkfsRkdNu7SMI757WMAqL0JUjidWdDhzSt8bw16mwOMU3Vx4fKBDlXhbXz0+larYAZcafdz5u5TOW0OHAmHQ6uMfV6rxYDwVNMsit3N/isGtAQzGBLowQjQ7CzCmcKK/cs65yACtClg/1sLX3pcTQPmbSbNS9Gl1RlkWtFxQ2YNq9oKeifk5M0mzofgB+YA4ivKElEs4tfKw0Gy4crV+Oe6TV86Nbu91JxeqB64phfKjyCsjIVqchUX++zaZS7+e7TP55LhezBXklWOZ1+BeBHKsXscGvowIIfa/Fis9Ly7TEFi+7rS3v2e6RTYBCbsI7OAeWD4F++aRB+XF4HUbfB9YYuBYSZQglTrSmlIRhx8wBGtoX9vvwX52J7OYASQ509JBMTVGvP4RWjZOSvr+KmU0wQVo5Dh5lQdDVn5gM5GlQFASSDT8x1iMpx56wv5UQfGv8chjAINb9/i/UCie1U2uTgQE0j/6hOGbiPXSWMHZz6O0pNIr3cGUnsAO6ZOkut7NGKmdan4zuGk0p9spqrx+7K8lCAMy0PkCWjB0C/bx11HSqgx65hfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+cc VMA team, Chris [whose AI fix this relates to]

On Wed, Apr 08, 2026 at 08:45:36AM -0700, Puranjay Mohan wrote:
> The open-coded task_vma iterator holds mmap_lock for the entire duration
> of iteration, increasing contention on this highly contended lock.
>
> Switch to per-VMA locking. Find the next VMA via an RCU-protected maple
> tree walk and lock it with lock_vma_under_rcu(). lock_next_vma() is not
> used because its fallback takes mmap_read_lock(), and the iterator must
> work in non-sleepable contexts.

Hmm :) In future if an API doesn't give you what you need please do ask us
in mm to offer one that does give you what you need, we don't bite :)

>
> lock_vma_under_rcu() is a point lookup (mas_walk) that finds the VMA
> containing a given address but cannot iterate across gaps. An
> RCU-protected vma_next() walk (mas_find) first locates the next VMA's
> vm_start to pass to lock_vma_under_rcu().
>
> Between the RCU walk and the lock, the VMA may be removed, shrunk, or
> write-locked. On failure, advance past it using vm_end from the RCU
> walk. Because the VMA slab is SLAB_TYPESAFE_BY_RCU, vm_end may be
> stale; fall back to PAGE_SIZE advancement when it does not make forward
> progress. Concurrent VMA insertions at addresses already passed by the
> iterator are not detected.
>
> CONFIG_PER_VMA_LOCK is required; return -EOPNOTSUPP without it.
>
> Signed-off-by: Puranjay Mohan <puranjay@kernel.org>

Hi guys,

This is buggy and can result in deadlock. You need to revert it or restrict
which contexts it can be called in.

I'm a little surprised you didn't cc- or even ping mm or the VMA team here, we
are always willing to help and it's clearly sub-optimal to write duplicative,
open-coded VMA traversal in BPF.

Let's be collaborative in future please :)

Anyway, unfortunately it seems that you've rather got yourselves in rather a
pickle here, as vma_start_read() can call mmdrop() and in x86 that can take a
pgd_lock in an invalid context.

Consider:

mmdrop()
  -> __mmdrop()
    -> mm_free_pgd()
      -> pgd_free()
        -> pgd_dtor()

And looking at pgd_dtor():

static void pgd_dtor(pgd_t *pgd)
{
	spin_lock(&pgd_lock);
	pgd_list_del(pgd);
	spin_unlock(&pgd_lock);
}

It's just a plain spin_[un]lock() which is invalid in softirq context, which you
are potentially calling from here.

You can get there from softirq via something like:

pgd_alloc()
  -> spin_lock(&pgd_lock)
    <softirq>
    bpf_iter_task_vma_next()
      -> vma_start_read()
        ... etc...
	< maybe deadlock >

It's not really sensible to alter core mm to accommodate this at this stage, so
probably the best course is to disallow this code path for softirq context, or
you could look into patching the x86 code.

Thanks!

> ---
>  kernel/bpf/task_iter.c | 91 +++++++++++++++++++++++++++++++++---------
>  1 file changed, 73 insertions(+), 18 deletions(-)
>
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index c1f5fbe9dc2f..87e87f18913d 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -9,6 +9,7 @@
>  #include <linux/bpf_mem_alloc.h>
>  #include <linux/btf_ids.h>
>  #include <linux/mm_types.h>
> +#include <linux/mmap_lock.h>
>  #include <linux/sched/mm.h>
>  #include "mmap_unlock_work.h"
>
> @@ -807,8 +808,8 @@ static inline void bpf_iter_mmput_async(struct mm_struct *mm)
>  struct bpf_iter_task_vma_kern_data {
>  	struct task_struct *task;
>  	struct mm_struct *mm;
> -	struct mmap_unlock_irq_work *work;
> -	struct vma_iterator vmi;
> +	struct vm_area_struct *locked_vma;
> +	u64 next_addr;
>  };
>
>  struct bpf_iter_task_vma {
> @@ -829,21 +830,19 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_task_vma *it,
>  				      struct task_struct *task, u64 addr)
>  {
>  	struct bpf_iter_task_vma_kern *kit = (void *)it;
> -	bool irq_work_busy = false;
>  	int err;
>
>  	BUILD_BUG_ON(sizeof(struct bpf_iter_task_vma_kern) != sizeof(struct bpf_iter_task_vma));
>  	BUILD_BUG_ON(__alignof__(struct bpf_iter_task_vma_kern) != __alignof__(struct bpf_iter_task_vma));
>
> -	/* bpf_iter_mmput_async() needs mmput_async() which requires CONFIG_MMU */
> -	if (!IS_ENABLED(CONFIG_MMU)) {
> +	if (!IS_ENABLED(CONFIG_PER_VMA_LOCK)) {
>  		kit->data = NULL;
>  		return -EOPNOTSUPP;
>  	}
>
>  	/*
>  	 * Reject irqs-disabled contexts including NMI. Operations used
> -	 * by _next() and _destroy() (mmap_read_unlock, bpf_iter_mmput_async)
> +	 * by _next() and _destroy() (vma_end_read, bpf_iter_mmput_async)
>  	 * can take spinlocks with IRQs disabled (pi_lock, pool->lock).
>  	 * Running from NMI or from a tracepoint that fires with those
>  	 * locks held could deadlock.
> @@ -886,18 +885,10 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_task_vma *it,
>  		goto err_cleanup_iter;
>  	}
>
> -	/* kit->data->work == NULL is valid after bpf_mmap_unlock_get_irq_work */
> -	irq_work_busy = bpf_mmap_unlock_get_irq_work(&kit->data->work);
> -	if (irq_work_busy || !mmap_read_trylock(kit->data->mm)) {
> -		err = -EBUSY;
> -		goto err_cleanup_mmget;
> -	}
> -
> -	vma_iter_init(&kit->data->vmi, kit->data->mm, addr);
> +	kit->data->locked_vma = NULL;
> +	kit->data->next_addr = addr;
>  	return 0;
>
> -err_cleanup_mmget:
> -	bpf_iter_mmput_async(kit->data->mm);
>  err_cleanup_iter:
>  	put_task_struct(kit->data->task);
>  	bpf_mem_free(&bpf_global_ma, kit->data);
> @@ -906,13 +897,76 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_task_vma *it,
>  	return err;
>  }
>
> +/*
> + * Find and lock the next VMA at or after data->next_addr.
> + *
> + * lock_vma_under_rcu() is a point lookup (mas_walk): it finds the VMA
> + * containing a given address but cannot iterate. An RCU-protected
> + * maple tree walk with vma_next() (mas_find) is needed first to locate
> + * the next VMA's vm_start across any gap.
> + *
> + * Between the RCU walk and the lock, the VMA may be removed, shrunk,
> + * or write-locked. On failure, advance past it using vm_end from the
> + * RCU walk. SLAB_TYPESAFE_BY_RCU can make vm_end stale, so fall back
> + * to PAGE_SIZE advancement to guarantee forward progress.
> + */
> +static struct vm_area_struct *
> +bpf_iter_task_vma_find_next(struct bpf_iter_task_vma_kern_data *data)
> +{
> +	struct vm_area_struct *vma;
> +	struct vma_iterator vmi;
> +	unsigned long start, end;
> +
> +retry:
> +	rcu_read_lock();
> +	vma_iter_init(&vmi, data->mm, data->next_addr);
> +	vma = vma_next(&vmi);
> +	if (!vma) {
> +		rcu_read_unlock();
> +		return NULL;
> +	}
> +	start = vma->vm_start;
> +	end = vma->vm_end;
> +	rcu_read_unlock();
> +
> +	vma = lock_vma_under_rcu(data->mm, start);
> +	if (!vma) {
> +		if (end <= data->next_addr)
> +			data->next_addr += PAGE_SIZE;
> +		else
> +			data->next_addr = end;
> +		goto retry;
> +	}
> +
> +	if (unlikely(vma->vm_end <= data->next_addr)) {
> +		data->next_addr += PAGE_SIZE;
> +		vma_end_read(vma);
> +		goto retry;
> +	}
> +
> +	return vma;
> +}
> +
>  __bpf_kfunc struct vm_area_struct *bpf_iter_task_vma_next(struct bpf_iter_task_vma *it)
>  {
>  	struct bpf_iter_task_vma_kern *kit = (void *)it;
> +	struct vm_area_struct *vma;
>
>  	if (!kit->data) /* bpf_iter_task_vma_new failed */
>  		return NULL;
> -	return vma_next(&kit->data->vmi);
> +
> +	if (kit->data->locked_vma) {
> +		vma_end_read(kit->data->locked_vma);
> +		kit->data->locked_vma = NULL;
> +	}
> +
> +	vma = bpf_iter_task_vma_find_next(kit->data);
> +	if (!vma)
> +		return NULL;
> +
> +	kit->data->locked_vma = vma;
> +	kit->data->next_addr = vma->vm_end;
> +	return vma;
>  }
>
>  __bpf_kfunc void bpf_iter_task_vma_destroy(struct bpf_iter_task_vma *it)
> @@ -920,7 +974,8 @@ __bpf_kfunc void bpf_iter_task_vma_destroy(struct bpf_iter_task_vma *it)
>  	struct bpf_iter_task_vma_kern *kit = (void *)it;
>
>  	if (kit->data) {
> -		bpf_mmap_unlock_mm(kit->data->work, kit->data->mm);
> +		if (kit->data->locked_vma)
> +			vma_end_read(kit->data->locked_vma);
>  		put_task_struct(kit->data->task);
>  		bpf_iter_mmput_async(kit->data->mm);
>  		bpf_mem_free(&bpf_global_ma, kit->data);
> --
> 2.52.0
>
>

--
Cheers, Lorenzo

