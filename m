Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEE6CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6E4D6B0092; Tue, 13 Oct 2026 07:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47106B009D; Tue, 13 Oct 2026 07:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D603C6B009E; Tue, 13 Oct 2026 07:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC4C56B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:49:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37E02140B0E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:49:52 +0000 (UTC)
X-FDA: 85317433824.21.108F5D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9D8904000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:49:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FXoMtWX+;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791892190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G78GCGexl4AmpaQPtR/ZnZzU2sTMtYA9Jm+zImCCMg0=;
	b=f4ZgKIgaU1kcYyqk9N6/aKUKIqCX7zL8py/ABBveEoyPNbheevxwSIOIILUu9R6p/jFc0D
	UICGLm03bCWUDlTVtMyoBXKSOkUR/1ds6/h6/ym/toRj4KlZXADvWUZm4vG/D3A4FFn27f
	l7jM8dcnphym091/hLTrEsCDR/ukMKw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791892190;
	b=PtAvxF/w1K5f4tKBH1pSHQukk2N7uaZZ/hP0Epfx+2c7BEKfFj8CBmbczKTt63zRaEUs6C
	NwVcYzPkpFa35AKcbapZ4W/eWh1x/EyRhJ8ZLBdAKimanQzPPVwG95TR4qelfCpctSbM5j
	47ncMjygTkLyhNyAcebdMzqD1Z8dHsk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FXoMtWX+;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0787F60A59;
	Tue, 13 Oct 2026 11:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473A51F00898;
	Tue, 13 Oct 2026 11:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791892189;
	bh=G78GCGexl4AmpaQPtR/ZnZzU2sTMtYA9Jm+zImCCMg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FXoMtWX+E0Ns8PGdn2KmS+jJAun6cLyIIFVnKAdLaacvI92ehKO56NFEEM8hx/43G
	 Mdvh6lvy7PAhXlgcQ74kUERl8nUJOocW/dfXpn455qV1cVbPaOmKUCGsCpEKGAanSh
	 C7Awb/wt6k7m+NPUXnAl7YY//5zrOY6E6Ik93oi+7JNTKweJzDyZlzZFlPqyudlSVq
	 pjmacYMfzBYErSUgDV2vSoXIC7snuIMYJUVKUKsMctMcDd1+AjtrMc7GhtSBOITdWS
	 Kfd6YjvwtF32KATyRwEEDWMmMDBW7x8aKzVRleLm0o4zBw/NCi+nnPZFoUd/V/LfbD
	 cFpa8Zqqfg4cw==
Date: Tue, 13 Oct 2026 12:49:47 +0100
From: Harry Yoo <harry@kernel.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Vitaly Vul <vitaly.vul@partner.samsung.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] mempool: optimize mempool resizing
Message-ID: <as4Xi9hPZldwGdzK@thinkstation>
References: <20261013091408.1231786-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013091408.1231786-1-vitaly.wool@konsulko.se>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9D8904000A
X-Stat-Signature: zkr4w4rrnfmn5wseimiw4ob3ghhpzu7a
X-HE-Tag: 1791892190-664955
X-HE-Meta: U2FsdGVkX1+MITmIXpIYjUBbQoSqPP9HENDdv1CZGNhQc+lsfGK+kZ01u15ip/gmnsA8g4K6yysqPt2NcWJnF9YOd8P3dmDAQTGk/jfnG3v+WndHGIatKfoJARKCTDMgi8H7MoCHnJbPoC4PpAc+SdfyPwdMrIgxT0idHjH6N11ZnUxpBk2VqxgwdvA8TZXCJnn4po66hOOv4o95brkzkMaHLSahT6u1Ok/6LjbffDac0JeEN+WqT9wuQquFiMo9omEFCAZVHZM9lEefPIJ3niDdoQUfOCrWgCx5K7d2I7/r9CZtuKiUsPxr7JPbLAxE9+gAcZXEGY0HqxHEuj1B0I7TJ6RM4fdVW+gsi6s97hBPm4bw3C49hXC7H1FQaKOY5YrHzYtDj/Pnq30QtLf16OOOpN+CkJ274MGBnDwMh8/N8cynkXFwL/bExYT16HKxG0tlodnc3SzW59VXdyyI7+pKvtpmtEQ8QCwItluby1pTtYY/vz5m9gl3tvtCEWLqZiobE28yL92o0VMvYz6DtC/RpXncVSUvWVXiV6vzpsJab49KqpsnZCJ7ae4XPPUBMcz4NOVZEC2hkDcjM8jDVe07RHIbN4lvoyQ4bKmWMQOypXkhTiVK1Uu45fkCIhPr7HxDlp8juWiylez96TmOiHPw/A/Q/fv1X2idbKgoIIxDN80fERgNc8/5ARY9GgG3rTcOqX8u0Xj8T0bFWYWBLcdHPqzU4vX3NARE7xrZ6N7Q7bHeNQG0Xj2AdimiWAaBEhENMnf926l1ier55nGbqniVfLSbFvYtZcElQh2MTPs+M5o+8Gx8xQ9F1BuUQsNd7bIhxNmHa5bKeCFrwWLyNxLAhFoHIazboSPuP+Qty9lgmOyH2PDgP0V7CTaPHg587h/+niyvgebtroUpX9MgPYhhiNTi0j1iTzDVvB4B8UnyyiZ4ygYgbawoGcgDrf677y99r1Ybc9nMLyirtEX
 fxg+L1j1
 WJK/wyeWVZCWdhOSdx7awBMWVh6HzKCvrCxccylUd30UK9n1mqMbkQU4WdC8ubnlEiBpfkGMkamI5ewVe0gfJxJG3MTcuSoTcduSlSBalexaXTBhHO0DMjXMm81ZiEPOVDpO+r5Xa3V5mOrUpu8uJok798xhVDQ7CfszJdpQi9dEVCNR18Xnf1JoVrGFOGOYn37sMfYjXnfJqvOrpnNWHmYUS2Y0ramryRamxf4KSfNXAAQSuFqO2cuzdErAb+/PjGMhYDKgCEKA6rcZ3RWSoYZlbRbxemFkdL9cKMZ1n06UsnRU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I think this has unresolved feedback from Christoph [1] and Damien [2],
so adding them to Cc list.

[1] https://lore.kernel.org/linux-mm/20260626042252.GA7997@lst.de
[2] https://lore.kernel.org/linux-mm/9104ac5d-ed2b-409d-8220-512dd4581966@kernel.org

On Tue, Oct 13, 2026 at 11:14:08AM +0200, Vitaly Wool wrote:
> Resizing mempool to a bigger size currently requires a new allocation and
> a data copy to a new larger elements array which doesn't go well with the
> idea of having a fast and deadlock free memory allocations during exreme
> load.

Please elaborate the problematic scenario more in detail.
Have you obsesrved the problem in practice?

> This situation can't be completely avoided but its occurrence can be
> vastly minimized if we track the actual number of slots in the elements
> array. This patch introduces a new member of struct mempool which is set
> when the array is allocated in mempool_init_node() and only changes when
> mempool_resize() replaces the array with a bigger one.  Growing a pool to a
> size that still fits the existing array now just raises min_nr and refills
> the pool.
> 
> A racing resize may enlarge the array while the lock is dropped for the
> allocation, so __elements_size is checked again once the lock is
> retaken, and the unneeded array is freed.  The array being replaced is
> now freed after dropping the lock.
> 
> Signed-off-by: Vitaly Vul <vitaly.vul@partner.samsung.com>
> ---
>  include/linux/mempool.h |  1 +
>  mm/mempool.c            | 43 ++++++++++++++++++++++++++---------------
>  2 files changed, 28 insertions(+), 16 deletions(-)
> 
> Changelog:
> * v2: all the API / behavioral changes are dropped, only the
>   optimization remains
> 
> diff --git a/include/linux/mempool.h b/include/linux/mempool.h
> index 6da502aef2f7..a8a411290bf0 100644
> --- a/include/linux/mempool.h
> +++ b/include/linux/mempool.h
> @@ -20,6 +20,7 @@ typedef struct mempool {
>  	int min_nr;		/* nr of elements at *elements */
>  	int curr_nr;		/* Current nr of elements at *elements */
>  	void **elements;
> +	int __elements_size;	/* nr of slots in *elements, never shrinks */
>  
>  	void *pool_data;
>  	mempool_alloc_t *alloc;
> diff --git a/mm/mempool.c b/mm/mempool.c
> index cb74e718b2c6..1911a696737b 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -261,6 +261,7 @@ int mempool_init_node(struct mempool *pool, int min_nr,
>  					    gfp_mask, node_id);
>  	if (!pool->elements)
>  		return -ENOMEM;
> +	pool->__elements_size = max(1, min_nr);
>  
>  	/*
>  	 * First pre-allocate the guaranteed number of buffers,
> @@ -353,6 +354,8 @@ EXPORT_SYMBOL(mempool_create_node_noprof);
>   * This function shrinks/grows the pool. In the case of growing,
>   * it cannot be guaranteed that the pool will be grown to the new
>   * size immediately, but new mempool_free() calls will refill it.
> + * Shrinking keeps the elements array, so growing the pool again up to
> + * the largest size it ever had does not reallocate it.
>   * This function may sleep.
>   *
>   * Note, the caller must guarantee that no mempool_destroy is called
> @@ -364,7 +367,7 @@ EXPORT_SYMBOL(mempool_create_node_noprof);
>  int mempool_resize(struct mempool *pool, int new_min_nr)
>  {
>  	void *element;
> -	void **new_elements;
> +	void **new_elements = NULL;
>  	unsigned long flags;
>  
>  	BUG_ON(new_min_nr <= 0);
> @@ -381,24 +384,31 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
>  		pool->min_nr = new_min_nr;
>  		goto out_unlock;
>  	}
> -	spin_unlock_irqrestore(&pool->lock, flags);
> -
> -	/* Grow the pool */
> -	new_elements = kmalloc_objs(*new_elements, new_min_nr);
> -	if (!new_elements)
> -		return -ENOMEM;
>  
> -	spin_lock_irqsave(&pool->lock, flags);
> -	if (unlikely(new_min_nr <= pool->min_nr)) {
> -		/* Raced, other resize will do our work */
> +	/*
> +	 * Grow the pool.  The elements array is only reallocated if it is too
> +	 * small, it may still be large from before an earlier shrink.
> +	 */
> +	if (new_min_nr > pool->__elements_size) {
>  		spin_unlock_irqrestore(&pool->lock, flags);
> -		kfree(new_elements);
> -		goto out;
> +		new_elements = kmalloc_objs(*new_elements, new_min_nr);
> +		if (!new_elements)
> +			return -ENOMEM;
> +
> +		spin_lock_irqsave(&pool->lock, flags);
> +		if (unlikely(new_min_nr <= pool->min_nr)) {
> +			/* Raced, other resize will do our work */
> +			goto out_unlock;
> +		}
> +		/* A racing resize may have enlarged the array meanwhile */
> +		if (new_min_nr > pool->__elements_size) {
> +			memcpy(new_elements, pool->elements,
> +			       pool->curr_nr * sizeof(*new_elements));
> +			/* The old array is freed below, outside the lock */
> +			swap(pool->elements, new_elements);
> +			pool->__elements_size = new_min_nr;
> +		}
>  	}
> -	memcpy(new_elements, pool->elements,
> -			pool->curr_nr * sizeof(*new_elements));
> -	kfree(pool->elements);
> -	pool->elements = new_elements;
>  	pool->min_nr = new_min_nr;
>  
>  	while (pool->curr_nr < pool->min_nr) {
> @@ -418,6 +428,7 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
>  out_unlock:
>  	spin_unlock_irqrestore(&pool->lock, flags);
>  out:
> +	kfree(new_elements);
>  	return 0;
>  }
>  EXPORT_SYMBOL(mempool_resize);
> -- 
> 2.39.5
> 

-- 
Cheers,
Harry / Hyeonggon

