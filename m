Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79A00CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A106B0005; Mon,  8 Jun 2026 11:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71596B0088; Mon,  8 Jun 2026 11:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A878E6B008A; Mon,  8 Jun 2026 11:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5436B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:52:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 453111C04F6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:52:29 +0000 (UTC)
X-FDA: 84857187618.16.BF89ECE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 54FE140008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:52:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OS8m7n6h;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780933947;
	b=P8AtPUxyyeSdFbLmxcBt8O1vOBb3/0cTNISFk5jZOqucZh46uz5yFyD0uOvcKl8pdC2k9M
	1p/PygYtPl1Eo8gDH8TCa9veE87WaOzlkVlbGtRGIDXeY3OMDfw1vMc2p8fl440wVS7sqj
	YPtjflJbHd1MgllM4sUQQC3a1HmkcV8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OS8m7n6h;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780933947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBm0zIKsLAEeJUSvIkeG9dorWmBmWw3H05wegj3RHso=;
	b=XycyDWh8m3JY7scWthpPNKgTOl2XaWEOY1Liq5LGE+rZ0bXwXcxuVQtCWub1uTg7B1mDu9
	SQsrI58npseu1RS8FM//R5OlwbaRcppWvzn2E2+SzrqmEMqA8+YzhJ8AQYdEkHhVr3Rsbz
	QliKbtZmaG4YdgCG+RE2DSDKUa/tOZQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D86D41E68;
	Mon,  8 Jun 2026 15:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF801F00893;
	Mon,  8 Jun 2026 15:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780933946;
	bh=BBm0zIKsLAEeJUSvIkeG9dorWmBmWw3H05wegj3RHso=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OS8m7n6h01FrWGbWX5puCFYy8j3ZW4kGuhu/vOJNyT0tS6xydKmghwTgoHS739Nxp
	 ly5+KYjxl929TSqCRhwvvBIAGWAj64I+GKOA4rzJ2wZAg7s9cZJmp3OPFy0T2Ku/KH
	 yNfR3BQCniXEXkibrmFeQ6RzQLgQod+xW26dAcOXFoqGb3tG/8WSC8VGwmFdmdb3oq
	 Dx6kG9vDB2yw+8GrCcGzHZSGHY45MABVe+ODsDKgI79rlSQRpESqegl53RiA2VbOaa
	 0NfPw8NteKEji4FmRoHCmrHIXxQBwOfxOwVsizVuUbbnlZ6IBbEz8sNoO8NUW9yff3
	 suRQcDgypLkbw==
Message-ID: <0d103616-56e5-4a31-abfc-f50f03253588@kernel.org>
Date: Mon, 8 Jun 2026 17:52:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260606015729.1837935-1-surenb@google.com>
 <20260606015729.1837935-2-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260606015729.1837935-2-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 54FE140008
X-Stat-Signature: nxmgq7n3wnnk9np5q9578qj8rh7jpbhi
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780933947-968826
X-HE-Meta: U2FsdGVkX18BjhaIUyqi5ontENkuatzjM/+OrxcTgYFBRd8v7WDk9eol28HeoHjM5oPIVNaAKom7YLtHH1lYBKttrXGEkGcZiMDSyfBRNHQRT2qCBUGybfCmLmcdxqI/XMRyIcaOatOMlv8ruTPmCYgAYdnpX4wG9VptEGWgi4ujhs/u7DSsYlis8xFMg6wx9KBOzirNjQMbk5wj/5q3EJNrzMBW5ligoIZS1zEby5JqjO5ITMksURrhjv/8uomZctMfJkX9lqazDhPbUm3qKBKZevXWLy6/teNTNSlc0hAdhWYGNdvO2fiFdpclIkBXdtf7tEQAd8I9NO3QGlV06EM/EHLekw+5KHn5NM/cp4awtAGOV09DuwAIYCokoAeOKuJELeebCL+1ATtc6DBsxtYdY5tmo+xzYU4V07+9H5gkoCZVVRNP8XnJInhVjIvElENubc9S9z9C7Nv1BpDu+q7aFFwV/ddoTscQdNBM3mb/y/hZ14PQXFlKtb8xG0uThjPzcomzf4HxOLR2RG+dy9yuwEoEwluKm4kyruMwdSZHGPoStWdAx7SBvhG4DdYqyBR1U4wEFChK873znpNbKBe/+LRg+05F9YtQ7/FOO3skKwHUXQ9uYhDPyzpSd1/iTXAR1fGBWpYLT+eSqhXEQXdHEfPpylpv9+CCRKoU+MOFsPLLDCUQjVq0IeAWhZUv0BtYd8EP77FkDpkjtRhmTo1djl0mHI1EBotPWXyRC/kSCKRlAgR0t3awNOY50bCGC4YnB7rrmYcsTbohVc7g4QFHPJa/+1GDKRigqxKmyqn1k+zV0xVAFDar5mbOYJ3S2svbZCJMbmXheG7n4NnDqZ2V8cxdQSHcT2C1toz73OJi2m9W2qlreDaA4/K9qXw9iayir+DnxlE0GZUDuFW0cXUPS817lu7Dn34OLNmJ/+6xEUAm+2ADECEs+8PPv2vsI6z+pfT0S5NIJ7zX2Ld
 ildqaGuR
 FT952D7G5xa/yL82ZwnIiY68s/R0HuVjJF9FL/o1Y53gqlJrLkZWme43UQw4ZFhrAlJdlVm+FQvvjT/KA8OZg8bqri/qAxpKIpkdHXV8r7+LbaVhixobOzIaLrMAHmqM8dF7AdgiBCQ+6x9aS8imFDldpAFRtVNnPPsZdmiABcDsZiGkZSFdqUvodOxhm8ZMCYGnxo/VNFibQhuHnRF2NusOoQyPET9Z2vxVvkL6AE+m0pibG1YrfzQzVFIifGbkyxdfsc5uJqeOl08kOL3i6a9+lcPMRQqcnN6DtSt6C/+B8slrnNZ8w1h8r0DusjQlO8ymrKK6enx9Es3XTi3kmdYqn4x1Naz6V0ZhH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/6/26 03:57, Suren Baghdasaryan wrote:
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
> 
> [1] https://github.com/paulmckrcu/proc-mmap_sem-test
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
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

is_mmap_lock_contended() vs. mmap_lock_is_contended() ... really nasty.

> +{
> +	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
> +
> +	if (!lock_ctx->mmap_locked)
> +		return false;
> +
> +	return !!mmap_lock_is_contended(lock_ctx->mm);

!! is not required anymore, the compiler nowadays knows how to handle booleans
correctly.

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
> +	loff_t pos = 0;
>  	int ret = 0;
> -	VMA_ITERATOR(vmi, mm, 0);
> +
>  

Is there now a double-empty line? (it's getting late here)

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
>  
> +	if (IS_ERR(vma)) {
> +		ret = PTR_ERR(vma);
> +		goto out_unlock;
> +	}
> +
>  	vma_start = vma->vm_start;
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

Can you refresh my brain why we now have to check for gate VMAs explicitly?

> +		/*
> +		 * If after retaking mmap_lock, already reported VMA grew or
> +		 * merged with the next one, then iterate from last_vma_end.
> +		 */
> +		smap_gather_stats(priv, vma, &mss,
> +				  vma->vm_start < last_vma_end ? last_vma_end : 0);
>  		last_vma_end = vma->vm_end;
>  
>  		/*
>  		 * Release mmap_lock temporarily if someone wants to
> -		 * access it for write request.
> +		 * take it for write request.
>  		 */
> -		if (mmap_lock_is_contended(mm)) {
> -			vma_iter_invalidate(&vmi);
> -			unlock_ctx_mm(&priv->lock_ctx);
> -			ret = lock_ctx_mm(&priv->lock_ctx);
> -			if (ret) {
> -				release_task_mempolicy(priv);
> +		if (is_mmap_lock_contended(priv)) {
> +			unlock_vma_range(&priv->lock_ctx);
> +			ret = lock_vma_range(m, lock_ctx);
> +			if (ret)
>  				goto out_put_mm;
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

That's quite the simplification.

> +			/* Resume from the last position. */
> +			pos = last_vma_end;
> +			vma_iter_init(&priv->iter, mm, pos);

I'll leave checking the VMA locking details to VMA locking experts :)

-- 
Cheers,

David

