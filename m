Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C646CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A6D6B00A4; Tue,  9 Jun 2026 06:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B206B00A7; Tue,  9 Jun 2026 06:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41B06B00A9; Tue,  9 Jun 2026 06:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A06D36B00A4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:00:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A6628EBEF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:00:35 +0000 (UTC)
X-FDA: 84859929630.23.E3AD89C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 774C4160019
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:00:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NW9pHGbx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780999233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F74k5+na939DfUaKRjYG4me9UF0aTw9WJCXxM9pNAHc=;
	b=SRi2b6BOgDgfDJku7aQ4up96rXRI4q1Imj43a0XsOb/BmAtvsA3UfCY6Xu+6erBrXopV1C
	c9pexU+Xqntb0jI8DVvTpsiJNFx24rq5+oUiYcaNUB9QEB0ly9J4WfAFhu9f+arD3zZ8Ru
	GgE7DG8ku+CSNTj61q2yOHfdzmzj1BA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NW9pHGbx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780999233;
	b=jqnC9Y3W1Skw2U8vlt7za8lVf2r7MIONbX0Mfe4oChCCjd0zdmRVuCo86o81YBKu/T2d1u
	7ZfigO9QaFiLyVAq4WF1ndmOTMZzqSvOhvfNoLx4lrdMPQnspEicznzx1NhBTkurpP1atE
	cFrmofO2dn6xNmfRRVf06xpYabUgaH8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B6D041979;
	Tue,  9 Jun 2026 10:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C8E1F00893;
	Tue,  9 Jun 2026 10:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780999232;
	bh=F74k5+na939DfUaKRjYG4me9UF0aTw9WJCXxM9pNAHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NW9pHGbx8Pi5Ni/xS/pbKjs6FnVfobOPffrSgcCUZpdrk1F/clCaWzTy8bi+YRMb/
	 ieY9YEuY+dWN4SQZgZbJQNJDQATyVDQezLHnLehQW4bJzp2jj2kTk5O0qrKgc9c+f4
	 7sc/Csqtitr7i6LB8t6iEpQYjAncssKz7p+UphInANwoFXknBt9hUWh99aeXSPXomH
	 fbgkqBcAAZKHuj+L9Jqnq7pLI/on5ZJ/DJMBEEJrkybTq3ZdORWfPtmgqZA3V4nxC5
	 BKE71mXRTNJPfmzFhTjxPHjvjHENJn4UO03B6jqFHupaLR88s82p9bGC3S2pDh/ku0
	 OWJNZ0lohfIuQ==
Date: Tue, 9 Jun 2026 11:00:25 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
Message-ID: <aifO_rCurVhFRTcl@lucifer>
References: <20260606015729.1837935-1-surenb@google.com>
 <20260606015729.1837935-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260606015729.1837935-2-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 774C4160019
X-Stat-Signature: ade76isapfj99wuoquemra367cesn3tj
X-HE-Tag: 1780999233-175415
X-HE-Meta: U2FsdGVkX1+wzSl5ZK0CRtke/J+EyJa9ExaJXbAReipkOoI8gjmDT6IhInHZicZSBRTyQ72A2gE+4fRoamuqIDk/7TvzhNnLYc00gaKgRKL9vK+Qk/oeMNUoe9fYQModYFe5X6ygf+oQqWAYBkn9ML7r/PpPGZzdy4/wJRzi3jKvO8V4QG7sn72UZnm5UZTIhYyfFpi/RS/sP4Zoe5mpeKDTa+GCN2gre/DfZiWV/ziaiVSbvalXxxx5j+SmDqsCzfMUgIhEbga/4PVA+Eyd20AAYkLbJ8Tl3JTjItKpSBczIInF5WKnxSMP9wmneO1qIe/0xSjOidWGnD/TuWxMV0T7mCoZ4/x32SM7/3xiIv5bwZkZCGvhLBPobbmu9/D3+6hzLACUJyZ+3n1qp084jpx6ZZXi2DNmdRYF96zb8V6eLv2MvrNYKQCeFU+lO5pklaFmGQPGqKnfccOOCdm1dPyzgRxez7C20ZtyKAD7WIKw2F8rv1yKRlEjQWvoDBsOjFFIyfTbmrr3jhLTWCl8UquNuwy0qQs3+SVH1Ecy+d1pycIifrIH48Ux3iJJJOvcQfLT4z8wrjWjoqVmEIfjXFRkBUA69CI8yJ8gpzuvUOa/1ufmoMKRYOiIP1Xcdivyq8UGeWSkIxEIEYqxbfuXf4Zdyf+94J8PiaEDEnYHO0l4u2RKg2kij4iVHEiX+qaksFxgsiGryGiOb02xoxRcmS8aFQw+a5QCHHqfLRIqQWiDxTSRgLmqD+oa6h4vTyGtUyE85LgHEQ/vQyg+JFVMnjsP0Wtk5yz+WFrTZ306KeBd0IF/l6bsI3JDEE1fE74HsKNILbZmViUhb1gdSmT3IrF/E1yAsgyWAOcF+iGYk1eBdhpmoz4A7PHpA606qxXmE6+aFSAIR/wQ5bLI93qgnP4gSHvRPnZiin7WXubB3l21Zos2TbgvVvrt60CEiua/pbdg4v+/N/S6qfzE9Ce
 WCeOd3NJ
 Ayrkn+MO5QphGjXan88WjCglfI6HIXR3UfAnMWkEfb4CN1d64JtfvFTHKZ6kjlvaFRjDoPJ6INWELFNPFcYh5w6VLHdueIxZEuMJ4l8nAwXytBmhx97++fkCNMzg3RWxzRP7L1Y0oce0bDQMTeGTxrydw1p0Vx34WuJk+T3puYNPPFwrmMJwtdzcPlPJHIs9jfaxDqDnIMhmYIvAw03FzQj0q0pFy2dXXe+DRZoLY7P4eCDspy30rG1vjLxIvacxPbwivNTQ8SJP+5Y6Fk9j2W7m6Z56+TfDAtKqvbllKjdJJmItC79WfAP4Fch/aBN7wc9iU4S2PCXxMgvMrFZ7N0otvNbfuUuAfwd013cdvb1tYOYyD3huI3rGUkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 06:57:29PM -0700, Suren Baghdasaryan wrote:
> proc/pid/smaps_rollup can be read using the combination of RCU and
> VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> required to safely traverse the VMA tree and VMA lock stabilizes the
> VMA being processed and the pagetable walk.
> Note that we have to keep the logic to drop mmap_lock on contention
> because even when using per-VMA locks we might have to fall back to
> holding the mmap_lock.
>
> Running Paul's contention benchmark [1] shows considerable improvement
> both in median and in the worst case latencies:
>
> Execution command: run-proc-vs-map.sh --nsamples 20 --rawdata -- \
> --busyduration 2 --procfile smaps_rollup
>
> Baseline:
>
>     0.174     0.161     2.553
>     0.174     0.164     2.663
>     0.174     0.165     2.664
>     0.174     0.166     2.679
>     0.174     0.167     2.691
>     0.174     0.168     2.704
>     0.174     0.169     2.729
>     0.174     0.172     2.741
>     0.174     0.174     2.745
>     0.174     0.174     2.755
>     0.174     0.175     2.790
>     0.174     0.177     2.809
>     0.174     0.179     3.096
>     0.174     0.183     3.144
>     0.174     0.184     3.158
>     0.174     0.185     3.175
>     0.174     0.185     4.568
>     0.174     0.198     4.821
>     0.174     0.214     5.143
>     0.174     0.251     5.220
>
> Patched:
>
>     0.007     0.007     1.952
>     0.007     0.007     1.955
>     0.007     0.007     1.955
>     0.007     0.007     1.955
>     0.007     0.007     1.957
>     0.007     0.007     1.969
>     0.007     0.007     2.065
>     0.007     0.007     2.075
>     0.007     0.007     2.146
>     0.007     0.007     2.195
>     0.007     0.007     2.223
>     0.007     0.007     2.259
>     0.007     0.007     2.488
>     0.007     0.007     2.562
>     0.007     0.007     2.599
>     0.007     0.007     2.697
>     0.007     0.007     3.030
>     0.007     0.007     3.075
>     0.007     0.007     3.145
>     0.007     0.007     3.225

Ohhh lovely!

>
> [1] https://github.com/paulmckrcu/proc-mmap_sem-test
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Having looked through it carefully the logic looks correct to me, but I
think we can improve how this is implemented, so attach a patch with my
suggestions folded up to make life easier!

> ---
>  fs/proc/task_mmu.c | 134 ++++++++++++++++++++-------------------------
>  1 file changed, 59 insertions(+), 75 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 023422fcee12..c2bd9f5bbbcd 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -233,6 +233,16 @@ static inline void reacquire_rcu(struct proc_maps_private *priv)
>  	vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
>  }
>
> +static inline bool is_mmap_lock_contended(struct proc_maps_private *priv)

Hmm seems David and I are saying the same things :) but yeah this name being
very close to mmap_lock_is_contended() is suboptimal.

Also the inline is pointless here and suppresses the compiler unused check which
isn't helpful.

But in general, given we already have the lock context I think we can do away
with this altogether, see below.


> +{
> +	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
> +
> +	if (!lock_ctx->mmap_locked)
> +		return false;
> +
> +	return !!mmap_lock_is_contended(lock_ctx->mm);

As David said, !! is not a necessary incantation any more :)

> +}
> +
>  #else /* CONFIG_PER_VMA_LOCK */
>
>  static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> @@ -268,6 +278,11 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
>  	return false;
>  }
>
> +static inline bool is_mmap_lock_contended(struct proc_maps_private *priv)
> +{
> +	return !!mmap_lock_is_contended(priv->lock_ctx.mm);

Similarly. But also as above I don't think we need this.

> +}
> +
>  static inline void drop_rcu(struct proc_maps_private *priv) {}
>  static inline void reacquire_rcu(struct proc_maps_private *priv) {}
>
> @@ -1486,12 +1501,15 @@ static int show_smap(struct seq_file *m, void *v)
>  static int show_smaps_rollup(struct seq_file *m, void *v)
>  {
>  	struct proc_maps_private *priv = m->private;
> +	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
> +	struct mm_struct *mm = lock_ctx->mm;
>  	struct mem_size_stats mss = {};
> -	struct mm_struct *mm = priv->lock_ctx.mm;
>  	struct vm_area_struct *vma;
> -	unsigned long vma_start = 0, last_vma_end = 0;
> +	unsigned long vma_start = 0;
> +	unsigned long last_vma_end = 0;

I mean I kinda prefer these separate but obviously not necessary :P

> +	loff_t pos = 0;
>  	int ret = 0;
> -	VMA_ITERATOR(vmi, mm, 0);
> +

Yeah extra line as David said :)

>
>  	priv->task = get_proc_task(priv->inode);
>  	if (!priv->task)
> @@ -1502,89 +1520,55 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  		goto out_put_task;
>  	}
>
> -	ret = lock_ctx_mm(&priv->lock_ctx);
> +	hold_task_mempolicy(priv);
> +	ret = lock_vma_range(m, lock_ctx);
>  	if (ret)
>  		goto out_put_mm;
>
> -	hold_task_mempolicy(priv);
> -	vma = vma_next(&vmi);
> -
> -	if (unlikely(!vma))
> +	vma_iter_init(&priv->iter, mm, 0);
> +	vma = proc_get_vma(m, &pos);
> +	if (unlikely(!vma) || vma == get_gate_vma(priv->lock_ctx.mm))
>  		goto empty_set;

Is the gate VMA check here necessary? We already check it in the loop.

>
> +	if (IS_ERR(vma)) {
> +		ret = PTR_ERR(vma);
> +		goto out_unlock;
> +	}

Again this is duplicated.

> +
>  	vma_start = vma->vm_start;

Could just drop the gate check, and replace this with:

	vma_start = IS_ERR(vma) ? 0 : vma->vm_start;

> -	do {
> -		smap_gather_stats(priv, vma, &mss, 0);
> +	while (vma) {
> +		if (IS_ERR(vma)) {
> +			ret = PTR_ERR(vma);
> +			goto out_unlock;
> +		}
> +
> +		if (vma == get_gate_vma(priv->lock_ctx.mm))
> +			break;
> +
> +		/*
> +		 * If after retaking mmap_lock, already reported VMA grew or
> +		 * merged with the next one, then iterate from last_vma_end.
> +		 */

Hmm, but if the already reported VMA grew, vma->vm_start would not be <
last_vma_end would it?

So surely this is only covering the merge case?

> +		smap_gather_stats(priv, vma, &mss,
> +				  vma->vm_start < last_vma_end ? last_vma_end : 0);

I don't love how compressed this is.

I also don't love that 0 is taken to be 'start from vma->vm_start' and I
also don't love that the code in smap_gather_stats() actually special cases
this...

How about passing last_vma_end and making smap_gather_stats() more sane? In
the other invocation of smap_gather_stats() we could pass vma->vm_start
here.

We can then move the comment into smap_gather_stats(). E.g.:

		/* Handles the case of VMA merged since mmap locked drop too. */
		smap_gather_stats(priv, vma, &mss, last_vma_end);

To make life easier I put all of my suggestions into a patch which I've
attached :) (though it is untested) let me know what you think.


>  		last_vma_end = vma->vm_end;
>
>  		/*
>  		 * Release mmap_lock temporarily if someone wants to
> -		 * access it for write request.
> +		 * take it for write request.

I think this is better rewritten to reflect the changes. E.g.:

		/*
		 * If the VMA lock is not taken, we hold the often contended
                 * mmap lock. This can be because the arch doesn't support VMA
                 * locks,or we had to fall back to the mmap lock.
		 *
		 * To relieve pressure, check if it is indeed contended, then
                 * temporarily release it.
		 */

>  		 */
> -		if (mmap_lock_is_contended(mm)) {
> -			vma_iter_invalidate(&vmi);
> -			unlock_ctx_mm(&priv->lock_ctx);
> -			ret = lock_ctx_mm(&priv->lock_ctx);
> -			if (ret) {
> -				release_task_mempolicy(priv);
> +		if (is_mmap_lock_contended(priv)) {

We have both mm and lock_ctx already.

So we could instead do:

		if (lock_ctx->mmap_locked && mmap_lock_is_contended(mm)) {
			...

Right?

> +			unlock_vma_range(&priv->lock_ctx);

OK this confuses me - we're gated on lock_ctx->mmap_locked, so this is exactly
the same as unlock_ctx_mm(lock_ctx) right?

There's no situation here where the VMA lock would be unlocked.

Surely it'd therefore be clearer to just call unlock_ctx_mm(lock_ctx)
direct?

> +			ret = lock_vma_range(m, lock_ctx);
> +			if (ret)
>  				goto out_put_mm;


In the case of VMA locks being supported, but we fell back to mmap locks, this
seems to just be getting us back to the invariant that the RCU read lock is
held.

However, it's a bit confusing given we're explicitly checking for the
mmap_locked case, so I think it's worth a comment explaining that we might have
fallen back to mmap lock, but could still get the VMA lock on the next VMA.

E.g.:

	/*
	 * If we are using VMA locks but fell back to an mmap lock, we may
         * be able to VMA lock the next VMA, so reset the lock and try again.
	 *
	 * Otherwise, if the arch doesn't support VMA locks, this simply
         * retakes the mmap lock.
	 */


> -			}
> -
> -			/*
> -			 * After dropping the lock, there are four cases to
> -			 * consider. See the following example for explanation.
> -			 *
> -			 *   +------+------+-----------+
> -			 *   | VMA1 | VMA2 | VMA3      |
> -			 *   +------+------+-----------+
> -			 *   |      |      |           |
> -			 *  4k     8k     16k         400k
> -			 *
> -			 * Suppose we drop the lock after reading VMA2 due to
> -			 * contention, then we get:
> -			 *
> -			 *	last_vma_end = 16k
> -			 *
> -			 * 1) VMA2 is freed, but VMA3 exists:
> -			 *
> -			 *    vma_next(vmi) will return VMA3.
> -			 *    In this case, just continue from VMA3.
> -			 *
> -			 * 2) VMA2 still exists:
> -			 *
> -			 *    vma_next(vmi) will return VMA3.
> -			 *    In this case, just continue from VMA3.
> -			 *
> -			 * 3) No more VMAs can be found:
> -			 *
> -			 *    vma_next(vmi) will return NULL.
> -			 *    No more things to do, just break.
> -			 *
> -			 * 4) (last_vma_end - 1) is the middle of a vma (VMA'):
> -			 *
> -			 *    vma_next(vmi) will return VMA' whose range
> -			 *    contains last_vma_end.
> -			 *    Iterate VMA' from last_vma_end.
> -			 */
> -			vma = vma_next(&vmi);
> -			/* Case 3 above */
> -			if (!vma)
> -				break;
> -
> -			/* Case 1 and 2 above */
> -			if (vma->vm_start >= last_vma_end) {
> -				smap_gather_stats(priv, vma, &mss, 0);
> -				last_vma_end = vma->vm_end;
> -				continue;
> -			}
>
> -			/* Case 4 above */
> -			if (vma->vm_end > last_vma_end) {
> -				smap_gather_stats(priv, vma, &mss, last_vma_end);
> -				last_vma_end = vma->vm_end;
> -			}

OK so you're rolling all this up into the 'if after retaking mmap_lock'
bit.

I don't love that we're losing this information, but also it's maybe a
little more than we need here and it's making

But perhaps could we transfer this into the commit message as a
later-findable justification?

> +			/* Resume from the last position. */
> +			pos = last_vma_end;
> +			vma_iter_init(&priv->iter, mm, pos);
>  		}
> -	} for_each_vma(vmi, vma);
> +		vma = proc_get_vma(m, &pos);
> +	}
>
>  empty_set:
>  	show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
> @@ -1593,10 +1577,10 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>
>  	__show_smap(m, &mss, true);
>
> -	release_task_mempolicy(priv);
> -	unlock_ctx_mm(&priv->lock_ctx);
> -
> +out_unlock:
> +	unlock_vma_range(&priv->lock_ctx);
>  out_put_mm:
> +	release_task_mempolicy(priv);

Previously this was done under the mmap lock, now it's not. I don't think
this should be an issue but just highlighting.

>  	mmput(mm);
>  out_put_task:
>  	put_task_struct(priv->task);
> --
> 2.54.0.1032.g2f8565e1d1-goog
>

Cheers, Lorenzo

----8<----
From d94e7a192242f2cefb10bbfa12495e46c3d4c973 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Tue, 9 Jun 2026 10:39:39 +0100
Subject: [PATCH] ideas

---
 fs/proc/task_mmu.c | 89 ++++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 47 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index c2bd9f5bbbcd..16bf3cd8c7c7 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -233,16 +233,6 @@ static inline void reacquire_rcu(struct proc_maps_private *priv)
 	vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
 }

-static inline bool is_mmap_lock_contended(struct proc_maps_private *priv)
-{
-	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
-
-	if (!lock_ctx->mmap_locked)
-		return false;
-
-	return !!mmap_lock_is_contended(lock_ctx->mm);
-}
-
 #else /* CONFIG_PER_VMA_LOCK */

 static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
@@ -278,11 +268,6 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 	return false;
 }

-static inline bool is_mmap_lock_contended(struct proc_maps_private *priv)
-{
-	return !!mmap_lock_is_contended(priv->lock_ctx.mm);
-}
-
 static inline void drop_rcu(struct proc_maps_private *priv) {}
 static inline void reacquire_rcu(struct proc_maps_private *priv) {}

@@ -1375,17 +1360,24 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)

 #endif /* CONFIG_PER_VMA_LOCK */

-/*
- * Gather mem stats from @vma with the indicated beginning
- * address @start, and keep them in @mss.
+/**
+ * smap_gather_stats() - Gather mem stats from @vma.
+ * @priv: proc maps private state.
+ * @vma: The VMA whoms stats we wish to gather.
+ * @mss: The accumulated stats.
+ * @start: The address from which to start.
  *
- * Use vm_start of @vma as the beginning address if @start is 0.
+ * This gathers stats for the whole of the VMA unless the mmap lock was dropped
+ * and we raced a VMA merge, in which case we only gather stats for the
+ * remainder of the merged range.
  */
 static void smap_gather_stats(struct proc_maps_private *priv,
 			      struct vm_area_struct *vma,
-			      struct mem_size_stats *mss, unsigned long start)
+			      struct mem_size_stats *mss,
+			      unsigned long start)
 {
 	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
+	const bool is_partial = start > vma->vm_start;

 	/* Invalid start */
 	if (start >= vma->vm_end)
@@ -1408,20 +1400,20 @@ static void smap_gather_stats(struct proc_maps_private *priv,
 		 * Unless we know that the shmem object (or the part mapped by
 		 * our VMA) has no swapped out pages at all.
 		 */
-		unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const bool shared_or_ro = vma_test(vma, VMA_SHARED_BIT) ||
+			!vma_test(vma, VMA_WRITE_BIT);

-		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
-					!(vma->vm_flags & VM_WRITE))) {
+		if (!is_partial && (!shmem_swapped || shared_or_ro))
 			mss->swap += shmem_swapped;
-		} else {
+		else
 			ops = get_smaps_shmem_walk_ops(priv);
-		}
 	}

-	if (!start)
-		walk_page_vma(vma, ops, mss);
-	else
+	if (is_partial)
 		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
+	else
+		walk_page_vma(vma, ops, mss);

 	reacquire_rcu(priv);
 }
@@ -1476,7 +1468,7 @@ static int show_smap(struct seq_file *m, void *v)
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};

-	smap_gather_stats(priv, vma, &mss, 0);
+	smap_gather_stats(priv, vma, &mss, vma->vm_start);

 	show_map_vma(m, vma);

@@ -1510,7 +1502,6 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 	loff_t pos = 0;
 	int ret = 0;

-
 	priv->task = get_proc_task(priv->inode);
 	if (!priv->task)
 		return -ESRCH;
@@ -1527,15 +1518,10 @@ static int show_smaps_rollup(struct seq_file *m, void *v)

 	vma_iter_init(&priv->iter, mm, 0);
 	vma = proc_get_vma(m, &pos);
-	if (unlikely(!vma) || vma == get_gate_vma(priv->lock_ctx.mm))
+	if (unlikely(!vma))
 		goto empty_set;

-	if (IS_ERR(vma)) {
-		ret = PTR_ERR(vma);
-		goto out_unlock;
-	}
-
-	vma_start = vma->vm_start;
+	vma_start = IS_ERR(vma) ? 0 : vma->vm_start;
 	while (vma) {
 		if (IS_ERR(vma)) {
 			ret = PTR_ERR(vma);
@@ -1545,20 +1531,29 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 		if (vma == get_gate_vma(priv->lock_ctx.mm))
 			break;

-		/*
-		 * If after retaking mmap_lock, already reported VMA grew or
-		 * merged with the next one, then iterate from last_vma_end.
-		 */
-		smap_gather_stats(priv, vma, &mss,
-				  vma->vm_start < last_vma_end ? last_vma_end : 0);
+		/* Handles the case of VMA merged since mmap locked drop too. */
+		smap_gather_stats(priv, vma, &mss, last_vma_end);
 		last_vma_end = vma->vm_end;

 		/*
-		 * Release mmap_lock temporarily if someone wants to
-		 * take it for write request.
+		 * If the VMA lock is not taken, we hold the often contended
+                 * mmap lock. This can be because the arch doesn't support VMA
+                 * locks,or we had to fall back to the mmap lock.
+		 *
+		 * To relieve pressure, check if it is indeed contended, then
+                 * temporarily release it.
 		 */
-		if (is_mmap_lock_contended(priv)) {
-			unlock_vma_range(&priv->lock_ctx);
+		if (lock_ctx->mmap_locked && mmap_lock_is_contended(mm)) {
+			unlock_ctx_mm(lock_ctx);
+
+			/*
+			 * If we are using VMA locks but fell back to an mmap
+			 * lock, we may be able to VMA lock the next VMA, so
+			 * reset the lock and try again.
+			 *
+			 * Otherwise, if the arch doesn't support VMA locks,
+			 * this simply retakes the mmap lock.
+			 */
 			ret = lock_vma_range(m, lock_ctx);
 			if (ret)
 				goto out_put_mm;
--
2.54.0

