Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90C19C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 18:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1221B6B008C; Tue,  8 Sep 2026 14:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9BD6B0092; Tue,  8 Sep 2026 14:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036126B0093; Tue,  8 Sep 2026 14:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B616E6B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:18:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 364671C297C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:18:01 +0000 (UTC)
X-FDA: 85191403962.28.961577E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41C91160007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:17:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=INtS85Uc;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788891479;
	b=Uzl0j21mi/O+lNChFkhPLnziAdOhlCxFEwzhDAOLAWfputJUD3sMATbpF3ARl/QCj7DtOB
	IpAS7vdeZyMUmyd6hbSbn6C1HjeoxopB50UXU9xE8kAJsQ8g1pYsqZwnL4/mvXyYcsFIfC
	hu9lxIELsyVnGenw7kpY36sHT9hoI1A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=INtS85Uc;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788891479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dyq0rqPF/caX+rIXtg60F4Gmdfs7agxcbClMUi/0adA=;
	b=Abq78GVmxjtTBHbe4IHvjmeUUvOC0UUELr76JfoKicMuWB46YSbwxUOAYb56N+Oz8lW4De
	pmuqSBQV6af8jaTSipNXfB6Rl/HuWPqyr1kyeDwtXbcqCFyKlah5mvzXkA7GnKgTIFiZ/S
	QeOHsLsbuQrxiafbR62mZotGmTT9bxM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Dyq0rqPF/caX+rIXtg60F4Gmdfs7agxcbClMUi/0adA=; b=INtS85UcGIp39zsvFAtotnIcaS
	0ZLfdrGzgYX0npQaS83goDT/jK8u9DrmWoL657TVhTug4Gixqa5JhZ72ooWNjF6J75V/q0aYdCZfX
	i7CXq8s5dPqFk0fUY8Vxss8bU9mzbFZFiAySwzMUjbLQM+A4/3Le9CTxYd7wxQgaBDMxvf90sfemU
	E6RaxBiTCFd5gHgMW8yshKwlm+qre6nBR3tSx+/1+0nHS4tfSUbN8lJmmCzvbnCD28xDKiClIIU/x
	QoExUPaSejDfb8I/Jk5ktObnKqSSd4XEHvGUUwjolHNZ2URvVaC91BZ9xnPFTivifxGVACMURpnve
	oCLx9Y2g==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x40OK-00000009xGe-0sAp;
	Tue, 08 Sep 2026 18:17:56 +0000
Date: Tue, 8 Sep 2026 14:17:54 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
Message-ID: <fzc3glxoh2h3tke6zofdfdnlpthxfw57dehotssuhdvwz2a23a@apizp53duf5j>
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-5-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907063918.3432401-5-surenb@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 41C91160007
X-Rspam-User: 
X-Stat-Signature: 6ut4wabb7i8kw1d8zn81kibdguhksyof
X-HE-Tag: 1788891479-793315
X-HE-Meta: U2FsdGVkX1/yGv8ww3Kd9ml3c4O+5fugg/Nw1pmrOxvMdH/R05uf7M5dQqfq81yMzJpNFSaAKTgGCjFlECdCe7U/msmaP5TMX5LVn0o+bR5Fk+aw5f1G5EH/MQ8+1IwJpDe1Plm+3CjwVdlz3TyUHoQuLMkOJK7wgq4t4LZYwaAAOTJRwv/cEOXuBNDLZQjY3LhCKlD0eMCCvAQFCBvXri6mmfEnCHyGJM+8uXa8y3G2sigspl29X4vosE7RWPOwmZmIOdU6CyFEE1h1URF9ix7dfMPYSWLOTrGu4N2Sljhdt6sRlf+6qDtSlJZseZvs3+aDJTsSTsKTlTl2+COnohJT3Wq544AmQLrkezJy8ViiCwWPlQuU1XMhDczmbJ9OGs9DnKXVZSYzgIVNBBLf1gghu97Pg0u5HPaevRHhp34J1Bgf53qedzfMVl+lqW0HYuOheJ/fVycoSZ1KoSKI/1h8foAJL16iLde2Ne3M+dGLht3uqN1fwVFtdIrEzPti/5XbWcx/R/S/g8zXH5bvCtevP13R+ADQYDR5QLpN1ZenIAJxN+8F7UVoXs0EwNhUhwyPopjRKXdfc7EbIE/EPr2aTyZcisMmLHctxpqeay2txDJSWLBO7fST46bGL78qpmcMZVAyD8qWAsFIiAGripyRM3OX+coMwNzANOFJKZzkv3kLvaLDzK804pnIxzVfx450cnl9yRxMwVu5ZY3dwIrctXeTR2ER6DUDLfC8yIey4YkozJEESgun/yCTL3GSN11wCpqJWCMHBQpgnGYRwz0k/P69IPx4DAR3K+EUiPZaWrf1OKY2o7J/IMViG4e2GT04B1ntXW6Gv78WNQ0cnM6JIAXGgqgPKQ/BMNBNKskTJxfwi67o0BK7+AxqjZmungGUL55vT2KWqNAjgdDxhY4n1E1vTftQF7LnkQv/qGTPMrR8muodPgnP0YUTS/21w6JC49QrlLeAdEoeZ10
 g5QXKNux
 rWQjrOK2AOSb6sV3vkCvdquaKJUvDX/+tgGCeOz1OQTqKfV0S8PMqPJpYkxCXKSIThBe7UB8hw4l8HJp1YqnJCBs3twiHZUFhYG31RcqOa3C5o97ggR//f55aR1V4zaOluzWHf9iD27pjf3WTdsSKaJPc49vvix7Cj92DWNuI7TvHeYchhE5ihciaOXblYpHm2u0hTXTkm29raCEMqyiDJMYURjs3lhmbMd1x0WrraM5gbY3x7Gr0B+Ew8EY5YLhTXDYilUikKywQqy1sJRqADHyqr/nqdEi2qud7DGaNd7jGbrC8uUsUgi6bKZ2P5MIBldLVd/AMA5gigPrlnGvf5OAjgIR7YX59MihsXDVAXZ83u6eiDYitJf3jHcj41sNZK0mqeGUvo/yDSd2f0p4mSMWSOzal8AJvTZUbAQ7lzMKy+U3Tiv/3UuoVZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/09/06 11:39PM, Suren Baghdasaryan wrote:
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
>    Median   Minimum   Maximum
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
>    Median   Minimum   Maximum
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
> 
> Remove now unused lock_ctx_mm() and move unlock_ctx_vma() next to
> unlock_ctx_mm() as they are logically related.
> 
> Remove a long comment about 4 cases that we handle when dropping the
> mmap lock in the middle of VMA walk due to contention. The first 3
> cases explained there are handled naturally and only case 4 needs to
> be handled in a special way, which is done in smap_gather_stats() by
> gathering stats from the portion of the VMA that has not yet been
> processed.
> For posterity, moving this comment here:
> 
> After dropping the lock, there are four cases to
> consider. See the following example for explanation.
> 
>   +------+------+-----------+
>   | VMA1 | VMA2 | VMA3      |
>   +------+------+-----------+
>   |      |      |           |
>  4k     8k     16k         400k
> 
> Suppose we drop the lock after reading VMA2 due to
> contention, then we get:
> 
> 	last_vma_end = 16k
> 
> 1) VMA2 is freed, but VMA3 exists:
> 
>    vma_next(vmi) will return VMA3.
>    In this case, just continue from VMA3.
> 
> 2) VMA2 still exists:
> 
>    vma_next(vmi) will return VMA3.
>    In this case, just continue from VMA3.
> 
> 3) No more VMAs can be found:
> 
>    vma_next(vmi) will return NULL.
>    No more things to do, just break.
> 
> 4) (last_vma_end - 1) is the middle of a vma (VMA'):
> 
>    vma_next(vmi) will return VMA' whose range
>    contains last_vma_end.
>    Iterate VMA' from last_vma_end.
> 
> [1] https://github.com/paulmckrcu/proc-mmap_sem-test
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  fs/proc/task_mmu.c | 153 ++++++++++++++++++---------------------------
>  1 file changed, 60 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 3351decd1172..641a155b0c61 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -130,28 +130,12 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
>  }
>  #endif
>  
> -static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	int ret = mmap_read_lock_killable(lock_ctx->mm);
> -
> -	if (!ret)
> -		lock_ctx->mmap_locked = true;
> -
> -	return ret;
> -}
> -
>  static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	mmap_read_unlock(lock_ctx->mm);
>  	lock_ctx->mmap_locked = false;
>  }
>  
> -static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	lock_ctx->locked_vma = NULL;
> -	lock_ctx->mmap_locked = false;
> -}
> -
>  static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	if (lock_ctx->locked_vma) {
> @@ -160,6 +144,12 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
>  	}
>  }
>  
> +static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
> +{
> +	lock_ctx->locked_vma = NULL;
> +	lock_ctx->mmap_locked = false;
> +}
> +
>  static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
>  					   loff_t last_pos)
>  {
> @@ -1376,12 +1366,14 @@ static int show_smap(struct seq_file *m, void *v)
>  static int show_smaps_rollup(struct seq_file *m, void *v)
>  {
>  	struct proc_maps_private *priv = m->private;
> +	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
> +	struct mm_struct *mm = lock_ctx->mm;
>  	struct mem_size_stats mss = {};
> -	struct mm_struct *mm = priv->lock_ctx.mm;
> +	unsigned long last_vma_end = 0;
> +	unsigned long vma_start = 0;
>  	struct vm_area_struct *vma;
> -	unsigned long vma_start = 0, last_vma_end = 0;
> +	loff_t pos = 0;
>  	int ret = 0;
> -	VMA_ITERATOR(vmi, mm, 0);
>  
>  	priv->task = get_proc_task(priv->inode);
>  	if (!priv->task)
> @@ -1392,89 +1384,60 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  		goto out_put_task;
>  	}
>  
> -	ret = lock_ctx_mm(&priv->lock_ctx);
> -	if (ret)
> -		goto out_put_mm;
> -
>  	hold_task_mempolicy(priv);
> -	vma = vma_next(&vmi);
> +	rcu_read_lock();
> +	reset_lock_ctx(lock_ctx);
>  
> +	vma_iter_init(&priv->iter, mm, 0);
> +	vma = proc_get_vma(m, &pos);
>  	if (unlikely(!vma))
>  		goto empty_set;
>  
> -	vma_start = vma->vm_start;
> -	do {
> -		smap_gather_stats(priv, vma, &mss, vma->vm_start);
> -		last_vma_end = vma->vm_end;
> +	if (!IS_ERR(vma) && vma != get_gate_vma(lock_ctx->mm))
> +		vma_start = vma->vm_start;
> +
> +	while (vma) {
> +		if (IS_ERR(vma)) {
> +			ret = PTR_ERR(vma);
> +			goto out_unlock;
> +		}
> +
> +		if (vma == get_gate_vma(lock_ctx->mm))
> +			break;
>  
>  		/*
> -		 * Release mmap_lock temporarily if someone wants to
> -		 * access it for write request.
> +		 * If after retaking the lock, already reported VMA grew or
> +		 * merged with the next one, smap_gather_stats() will gather
> +		 * stats for the remaining portion by starting at last_vma_end.
>  		 */
> -		if (mmap_lock_is_contended(mm)) {
> -			vma_iter_invalidate(&vmi);
> -			unlock_ctx_mm(&priv->lock_ctx);
> -			ret = lock_ctx_mm(&priv->lock_ctx);
> -			if (ret) {
> -				release_task_mempolicy(priv);
> -				goto out_put_mm;
> -			}
> +		smap_gather_stats(priv, vma, &mss, last_vma_end);
> +		last_vma_end = vma->vm_end;
>  
> +		/*
> +		 * If the VMA lock is not taken, we hold the often contended
> +		 * mmap lock. This can happen if we had to fall back to the
> +		 * mmap lock.
> +		 *
> +		 * To relieve pressure, check if it is indeed contended, then
> +		 * temporarily release it.
> +		 */
> +		if (lock_ctx->mmap_locked &&
> +		    mmap_lock_is_contended(lock_ctx->mm)) {
> +			unlock_ctx_mm(lock_ctx);
>  			/*
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
> +			 * Even though we previously fell back to mmap lock,
> +			 * we try taking VMA lock for the next VMA, since it
> +			 * might not be under modification. In the worst case
> +			 * we will fall back to mmap lock again.
>  			 */
> -			vma = vma_next(&vmi);
> -			/* Case 3 above */
> -			if (!vma)
> -				break;
> -
> -			/* Case 1 and 2 above */
> -			if (vma->vm_start >= last_vma_end) {
> -				smap_gather_stats(priv, vma, &mss, vma->vm_start);
> -				last_vma_end = vma->vm_end;
> -				continue;
> -			}
> -
> -			/* Case 4 above */
> -			if (vma->vm_end > last_vma_end) {
> -				smap_gather_stats(priv, vma, &mss, last_vma_end);
> -				last_vma_end = vma->vm_end;
> -			}

Thanks for this :)

> +			rcu_read_lock();
> +			reset_lock_ctx(lock_ctx);
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
> @@ -1483,10 +1446,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  
>  	__show_smap(m, &mss, true);
>  
> +out_unlock:
> +	if (lock_ctx->mmap_locked) {
> +		unlock_ctx_mm(lock_ctx);
> +	} else {
> +		unlock_ctx_vma(lock_ctx);
> +		rcu_read_unlock();
> +	}
>  	release_task_mempolicy(priv);
> -	unlock_ctx_mm(&priv->lock_ctx);
> -
> -out_put_mm:
>  	mmput(mm);
>  out_put_task:
>  	put_task_struct(priv->task);
> -- 
> 2.55.0.979.g7e5102b832-goog
> 

