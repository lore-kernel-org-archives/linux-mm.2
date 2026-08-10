Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4676CC5AE5D
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 10:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB636B008C; Mon, 10 Aug 2026 06:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136606B0092; Mon, 10 Aug 2026 06:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F400B6B009B; Mon, 10 Aug 2026 06:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA4616B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:22:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E651120711
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:22:26 +0000 (UTC)
X-FDA: 85084970292.17.A92CCD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 943474000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:22:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F4DFGiUo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786357344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwWyhFg/k6MrmsUSXMiKAMqnHT9uyrXn8kBQTew3w3E=;
	b=RU0aaGYTLvhUxWXp9B8KRBNdBZmAS6Gf/xGRJUjUTbIyCB6BakdISRIV9RtukvwHIGKxIQ
	INfG5YkKOqh1LWDsxwdOHVX8EglIqHkanvTv7KPrZZDW5W2S71HXp068D3WUO0ELD/QZiL
	W8tTE9CdaD2O718Lf8MXV7NlzL63AVg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F4DFGiUo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786357344;
	b=0I59gaFqeIqf63tg9b8NXBnqqHjcEfDE9bf3ZRaYewfzfku1d8d7oSZKLNLFYk+q2Fr6Fs
	R8h7WYTYvLN080uzmfSnR8SsJumqkdR0JebLJuWjJ+mJLvEi2gqNXT5g3vhOfoEIT+JFKd
	gdoHioer/jQboJTxU4v7Do+4vQPPyVg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2EC9402D0;
	Mon, 10 Aug 2026 10:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1941F00A3A;
	Mon, 10 Aug 2026 10:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786357343;
	bh=NwWyhFg/k6MrmsUSXMiKAMqnHT9uyrXn8kBQTew3w3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F4DFGiUogDGpvWOhBc03f9eNfgF1LMtt/2L2dIaYpep9XEijeB8ET1w/ArB1+ePzR
	 sG3dh/9uOGKG3SZNiQ3cyq/FW5WkVTVRJ5dRhEne3kLdDM1KRzsfPDrLX983W5lUxr
	 svMHHvpZas2a48IV4ul8miZCjHaPQvy3/bGy/tyqfLs5avvTAVjqPegCXm5n9JTnHl
	 1TND+v4Q4Y6zpU4DXq+ViR6FT+E4nhq85aFVbUr6qNar1iAVeOThgwsHF2SyVVV4si
	 mxqbvTpgY0N3ZgtCJeFqIrYIGw0KCFtlUH8+tbn3GDSfslxbw961odYqt4ajxzjXkE
	 Puk1uLltxxjJg==
Date: Mon, 10 Aug 2026 11:22:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@kernel.org, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <anmlTpwKW-c51wYB@lucifer>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260806200548.3124802-3-surenb@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 943474000B
X-Stat-Signature: 9dnm4gnj7hscixm3ahhd5aeodmhziexe
X-Rspam-User: 
X-HE-Tag: 1786357344-736164
X-HE-Meta: U2FsdGVkX18Bq3ea40VPF08KE+6TxMs+7Oz0NS4MlyYgvC0/O4TQcqfa8tQHczPxfPM1D2i5djPgsLoM8eOkv2QfwzMvoAKEocqrGdW2gwEyNnst4hnjGrT9hiTnzlJB8Q1MO2b51arOD57S9P9Z9U2e9DzNwxeLU2wx2aFPspDPIJdZC0k6nrMuufZH2qqB1vxObLVSeWo14z7BdysW90wO7J2y327ARtMud0fDkpZHSqBGz0E5TpQyz4Otzm2GaFIWFI+B2RFRf6HNM+37ltUrJcSjeY3Sls18lSZjsUkUdukF0PtdavRptDZXmN+PdTc1tPz/X9s2/WdtSezNf6aiA+9JNL7676wxpVpdFmCSi/ZDe7TfUnvnlCN6omsmm5VQB8wRr3dEVYapBd5MDvgBwzwfEHkDvnxlWolMp6N4x5h3r2TQBiaLo/aVlyP0sL8DGz2h/689GBA/atVStqH+v2xZLYHBTTcKpGrt1bTdNZXegS0anioBvfWM58c+b/4xcZ9+5IoEn9HpAiGbVQw0PGtiGef4XsK4CUJW28XkLe3HoB6+MK5koqjR0MuyhWpqw94dsJlD8c7eg1sGqosb/UE5OyWO82BwC4BgNdDF+DUWTzHOJPRGARaCdq57XTRQK94aJxC+fACHmQzicQ+ISWAQR6GOtpgpHq+weXgk8GgXAj/Y78yo6EMEjRl6uDP/iZi/bxOFzSh8diZR6wN55OK8e2JSSbUvWquBzH5Mjujr8wEMTtz72vnHCGDIF05sqmTnBFKiSkUwASB4jA6puLKxQHPoHrZml/lQEkZyW3lI1LGRndkUJQSHBWNjIxGYQaaKb7aeXNR4Y0HkqQLoEDHP3m9vlaPQTnPQYNQVKKErBtnhT9lR4gRvG+3/JAf3an1hKHQ6KGl05FpdqBjGF15zY+q0UN5hZzNmzP4tTmqyybuEypkABt53ZPT/39P40rmqPH0BDSnu3D8
 3SZ0Oh5I
 SJ3h5JqKC79JLvbEBIXln1idUdn7fRtNP9ETiWI9QFubkfMvhurzMTpWJ4otsiuWfYrsKOM6dJ29MIVcoAS9iQeCG84FJFUVy4TOH2lB3ZqlKS2Ex7u1Yj0d7zN01AgIp4y1M9TZ1hJmc4eZXKoqR/yfvUW+/iNJiattr6wSFioeMuA38VRUOFlLpfuegabwxvKXD2buavv8TugLlnlcccr7YGYn61lbZ2gg1vGZbqMwJl8RaaLXBZIDWXGcHdowZnovUF4gZHZp8iCgGqVDA11yF4YeTSpNChF+zVS2wXp3ut4WCI8XQW5//5qiGm6AFmSrdRsSR1iTQ7VFcnfe2ukLDIabv+x92GtmqbbID9og/sfsIA7cYZoBI2+teNYyUpSllNqKTE1vqBrb75xTTTqVSYitGl5wZgpsYQFHF4/qCT6PLtJgWLMq/icGp+49dOjcmMwpXllCEEYnVjfqRFn7nbAxf2Y6QRmD4DDgX5JWYzIkDtrQlADLcnG0JC/FVoRdZ544yBUJALyr8yJh3gxT0Qh3FAd65wxwPUlvn2UNDc/zUoRC7uFQP0ed+nNJKW8eUK0510b5oAX7tiWc4JMyCZR6Uq0uxtxUbyTumJKxHY8fxD9i1Ik24sfjW4E/I0oC1YJy0lgnZde9Sut6XtaTXMs0QGWltJbKSoFimDpWWEVJOGOH3oljXjQiXULrgeP0F1PPnBF5hCMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:05:45PM -0700, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> it and mmap_read_trylock().
>
> Long Version:
>
> == Background ==
>
> Historically, binder used an mmap_read_trylock() in its shrinker code.
> This ensures that reclaim is not blocked on an mmap_lock. Commit
> 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> support for the per-VMA lock, but left mmap_read_trylock() as a
> fallback.
>
> This was presumably because the per-VMA locking can fail for several
> reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> to mmap_read_trylock().
>
> == Problem ==
>
> The fallback is not worth the complexity here. lock_vma_under_rcu() is
> essentially already a non-blocking trylock. The main reason it fails
> is also the reason mmap_read_trylock() fails: something is holding
> mmap_write_lock().
>
> The only remedy for a collision with mmap_write_lock() is to wait,
> which this code can not do. So the "fallback" after
> lock_vma_under_rcu() failure is not really a fallback: it is really
> likely to just be retrying in vain. That retry in an of itself isn't
> horrible. But it adds complexity.
>
> == Solution ==
>
> Now that per-VMA locks are universally available, lock_vma_under_rcu()
> will not persistently fail. Rely on it alone and simplify the code.
> The removal of the fallback does not affect NOMMU case because binder
> driver depends on CONFIG_MMU.
>
> Full disclosure: I originally tried to do this with
> lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> trylock semantics. Claude caught this in a review and suggested the
> approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> I guess.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Thanks, LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/android/binder_alloc.c | 45 ++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index e4488ad86a65..c13a588c37de 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
>  	struct vm_area_struct *vma;
>  	struct page *page_to_free;
>  	unsigned long page_addr;
> -	int mm_locked = 0;
>  	size_t index;
>
>  	if (!mmget_not_zero(mm))
> @@ -1151,27 +1150,25 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
>  	index = mdata->page_index;
>  	page_addr = alloc->vm_start + index * PAGE_SIZE;
>
> -	/* attempt per-vma lock first */
> +	/*
> +	 * Attempt per-vma lock. This is essentially a
> +	 * "trylock". It can fail even if the VMA exists
> +	 * for 'page_addr'.
> +	 */
>  	vma = lock_vma_under_rcu(mm, page_addr);
>  	if (!vma) {
> -		/* fall back to mmap_lock */
> -		if (!mmap_read_trylock(mm))
> -			goto err_mmap_read_lock_failed;
> -		mm_locked = 1;
> -		vma = vma_lookup(mm, page_addr);
> +		/*
> +		 * If the vma exists, we can't continue because we cannot
> +		 * remove the page from the vma. However, if the vma was
> +		 * unmapped, it's okay to continue.
> +		 */
> +		if (binder_alloc_is_mapped(alloc))
> +			goto err_vma_lock_failed;
>  	}
>
>  	if (!mutex_trylock(&alloc->mutex))
>  		goto err_get_alloc_mutex_failed;
>
> -	/*
> -	 * Since a binder_alloc can only be mapped once, we ensure
> -	 * the vma corresponds to this mapping by checking whether
> -	 * the binder_alloc is still mapped.
> -	 */
> -	if (vma && !binder_alloc_is_mapped(alloc))
> -		goto err_invalid_vma;
> -
>  	trace_binder_unmap_kernel_start(alloc, index);
>
>  	page_to_free = alloc->pages[index];
> @@ -1182,7 +1179,12 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
>  	list_lru_isolate(lru, item);
>  	spin_unlock(&lru->lock);
>
> -	if (vma) {
> +	/*
> +	 * Since a binder_alloc can only be mapped once, we ensure
> +	 * the vma corresponds to this mapping by checking whether
> +	 * the binder_alloc is still mapped.
> +	 */
> +	if (vma && binder_alloc_is_mapped(alloc)) {
>  		trace_binder_unmap_user_start(alloc, index);
>
>  		zap_vma_range(vma, page_addr, PAGE_SIZE);
> @@ -1191,23 +1193,18 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
>  	}
>
>  	mutex_unlock(&alloc->mutex);
> -	if (mm_locked)
> -		mmap_read_unlock(mm);
> -	else
> +	if (vma)
>  		vma_end_read(vma);
>  	mmput_async(mm);
>  	binder_free_page(page_to_free);
>
>  	return LRU_REMOVED_RETRY;
>
> -err_invalid_vma:
>  	mutex_unlock(&alloc->mutex);
>  err_get_alloc_mutex_failed:
> -	if (mm_locked)
> -		mmap_read_unlock(mm);
> -	else
> +	if (vma)
>  		vma_end_read(vma);
> -err_mmap_read_lock_failed:
> +err_vma_lock_failed:
>  	mmput_async(mm);
>  err_mmget:
>  	return LRU_SKIP;
> --
> 2.55.0.654.g21b8a5bc05-goog
>

--
Cheers, Lorenzo

