Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8582C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1ADC6B0095; Fri, 11 Sep 2026 15:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4FA6B0096; Fri, 11 Sep 2026 15:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86BF96B0098; Fri, 11 Sep 2026 15:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63C296B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:07:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5D3614031B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:07:25 +0000 (UTC)
X-FDA: 85202414850.28.6E9676A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2DFD3120006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:07:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMRSULqi;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789153644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETiJBHuuXeuIAEQKc1zcTyAWH7qqk4xH5LnWBOZQWFQ=;
	b=rjnci5qpjD64mjhK0vlRHTpQ9rFppzVSns0GrkKflrPxtL4D9YecQe2w/IQO9qpXDOh72X
	aDazx21T3woS/P2uxu/3cst+iuoZSWYmEEk2S83Cm8n8MDlIyGguLUjhTIQCB/WxomXX6n
	hoRuhtxA8sFRh6hd3Moywp6DKP6kdr4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789153644;
	b=cDfOOYnan4chBKMOoUH3js6z0F8K59EtS7DdLq8VbR8+6BDgUzzld+6xKV7vtHVm5U+Cbt
	ED0VoNrt7N9EjtgcCs30G64JjXubHfQp5ShlyHKGmt+iO5rwRwmbFUvWGeNTYWTUGUm2Hi
	SbCOb8rFTwh6jAOUsNgZQraXt0wSqks=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMRSULqi;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6368241FC9;
	Fri, 11 Sep 2026 19:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA8D1F00893;
	Fri, 11 Sep 2026 19:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789153643;
	bh=ETiJBHuuXeuIAEQKc1zcTyAWH7qqk4xH5LnWBOZQWFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SMRSULqitKzQ6fimXD+vIZw4bIjmVl52dToJt8fWJJ8sYhAWgV4sqEOWprhYotsCw
	 0JvYxwQcGitREfO8fJd9SiCdw2ykPwHrHXtKzcDoRhufHWmiKMxPUdyFDZs/jgjmN1
	 cIsYw8dsP5IS2e17uUB58DXiEbbIeY7E/LhLqM+ATzTWZK+TrePINDnqczTW3AsGC+
	 nFlFrdppQ5jHfh/8KOy3biVq3+JeFqerYTqO0fOVKEd4dmMRwJf6I1KjrBWX0j3yyj
	 bjW3vqMfJAAhQjwINWq1X9ySb9lNNDh3nGxtfeHTV07jjOIXXOQaZdJ4ehHPvKoBlH
	 NmPDBZ72TS4Jg==
Date: Fri, 11 Sep 2026 20:07:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
Message-ID: <aqRRUAxCsRC6IQIt@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-7-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910234737.1340642-7-surenb@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2DFD3120006
X-Stat-Signature: uctddsaaq4z4qh7xy6u7m8tjfzms81r7
X-Rspam-User: 
X-HE-Tag: 1789153644-23479
X-HE-Meta: U2FsdGVkX19mdxro5xedc1+kGWVeiRxwdYubIxgpxrbP4LLL4Z+WPfzVFbOlchUzOjLyjldRFW1lbG9pxhs4vr8uuJonL8NozhMz18tvuQt6rQNlXVwgDy7Qs0DDV1Ajwn5a8qUifxDxqrrrXrehNXMhYIW+ogCnD8KHLAqwr14Vy+LbrTgu56pQgv5rfG4yrTM7PBEVadNvAz6xsZINouJNf21zrW0rLQGmQIDFmoOrkoqk+EJvZYcuYYK2l1CWJsbeq8L4xgEv+sQRvgU5oHR47Y6xLiZ50y6uHEySx+qBMG0ipai56m8Q5GCcAsQgp22eEeLlgpELujediLw5HiG5TO4EumGMaqtXU/p9VoxZuPNvw1HHdi5p6GbJCl22x8W7C8yoAahZxq7kkuFMCZ4IT0O0cLOz0hH7LOpO4SWSv/I5TLCDOdojX2dOzxl/T+0D9/GF7GI9UkZ4hTwIreKaFJ5iz0qhXsaQ8rmpghXc4eOjRu9nW3Fvj1XfsY4J9PegUndMBzaC560glH5tbsX+w3UcwuK4PDwDtEe/uxCUfDohVjWii9W94srCLkvCuOiNYC6MpkPUnT46wDGgSRcmJp33Y0Hs6HUIb0bKm1MmJuK8ybgIehO+0bxosCgYKdTXTutlkFu1pZ/S/bPIerLuFnL37/FyTUBVAtRZIpAXBFstdn4aDaxaisDD2qyVtLUbceNijrOn3qHfwMy+7TE6vzkPQ58kxjXKP1zrh3WNWsbDXXLX3JEaDGFG88Prz5OzGS2lqoDywzuDECzl/HkpkC5mP686e6G60qn2jDcZjb7TqyH+xpuePPc4WLfozXv/WKGm+STqgo2PQiYO3698slgHe6ThHxdEYOTsr3JloKbuPx5cE4for0DFiQbOB47712yXFDMxT2FNBq0r5z2Y53zYJSrCilGAUVqsrP4iwz9/J8qnU6/D3GyEpnihUTy+RR7JmLLwdZiGv1d
 NaSWazUL
 F1QVlQWh8FoCHFkRZIUPLKgzYB4rd7XLf/7f/fj2AakjPKtI/hW2+AoqxLj7uWtv5wCsxYyQeVFWNOWqCO4JAMJuIJiztVAEc/tXIJG3/hewOlCu2SJxVyHNVopYMw8GKZB3ALS9S8RKKylfSYIFPpWhJz7pQ48Y/LG1siEiTq66VQpMFy1JH2JLhxg4JMw8zrhZxUjvFp2IFYBZ4DMraQwnxgMsNVbJcba5bMqBGR7W6tSMZb4BCsx7NUoweqZmjjyhSr+HaQEvITlW6JoRxOmVmYULHC/TsTD3BH/CQqIGpXhQhDQtw56PM6AxsECf+K7Rr0oAgQJyNAsKqyyjJ40M4MG+myHXPR0eOxevzTJB9iM+mmJKbINSdiQ0ATSMlcdfDl+MHZPCHNKP1Yyd+gNaWOs1Qe+xbOM35mDu6fHfurJK31qAcf5xK+dDGrPoq+YoH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 04:47:36PM -0700, Suren Baghdasaryan wrote:
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

Everything LGTM and it runs fine locally so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 159 +++++++++++++++++++--------------------------
>  1 file changed, 66 insertions(+), 93 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 9a3c996c1d61..6fee40bdd736 100644
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
> @@ -1384,12 +1374,14 @@ static int show_smap(struct seq_file *m, void *v)
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
> @@ -1400,89 +1392,66 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
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
> +	if (!IS_ERR(vma))
> +		vma_start = vma->vm_start;
> +
> +	while (vma) {
> +		unsigned long start;
> +
> +		if (IS_ERR(vma)) {
> +			ret = PTR_ERR(vma);
> +			goto out_unlock;
> +		}
> +
> +		if (vma->vm_start < last_vma_end) {
> +			/*
> +			 * After retaking the lock, already reported VMA grew
> +			 * or got merged with the next one and we found it
> +			 * again. Gather stats for the remaining portion by
> +			 * starting at last_vma_end.
> +			 */
> +			start = last_vma_end;
> +		} else {
> +			/* Found next unreported VMA, start from its beginning */
> +			start = vma->vm_start;
> +		}
> +		smap_gather_stats(priv, vma, &mss, start);
>  		last_vma_end = vma->vm_end;
>
>  		/*
> -		 * Release mmap_lock temporarily if someone wants to
> -		 * access it for write request.
> +		 * If the VMA lock is not taken, we hold the often contended
> +		 * mmap lock. This can happen if we had to fall back to the
> +		 * mmap lock.
> +		 *
> +		 * To relieve pressure, check if it is indeed contended, then
> +		 * temporarily release it.
>  		 */
> -		if (mmap_lock_is_contended(mm)) {
> -			vma_iter_invalidate(&vmi);
> -			unlock_ctx_mm(&priv->lock_ctx);
> -			ret = lock_ctx_mm(&priv->lock_ctx);
> -			if (ret) {
> -				release_task_mempolicy(priv);
> -				goto out_put_mm;
> -			}
> -
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
> @@ -1491,10 +1460,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
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
> 2.55.0.1007.g17ff1f9808-goog
>

--
Cheers, Lorenzo

