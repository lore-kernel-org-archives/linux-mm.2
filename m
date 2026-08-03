Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF639C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C8C6B00E1; Mon,  3 Aug 2026 09:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3C556B00E2; Mon,  3 Aug 2026 09:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B8F6B00E3; Mon,  3 Aug 2026 09:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B48F6B00E1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:39:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A865140663
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:10:43 +0000 (UTC)
X-FDA: 85059690366.24.F1A5EBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 60D7D140008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:10:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JiUiJCOy;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1AHQgHItUAjyCfSWii/TMz98UWdEFUg8DqjV+05t70=;
	b=6pftrTsls1Wd1R6Cow9vzKoMjyHbDtNiktuc5W5VtwhDgoHTMNekg7s8OIifD9HcePtXrS
	TnOvodG0NBMHY/j6cQW6suttwYjdvfkqjx/1WBO4WC4L+DWPF/nYrmYxEixtrUuV5A314t
	7ARliGX6jXJBzxoy7o6Zjbr6tWRqyhM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JiUiJCOy;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755441;
	b=i9/482Aa96fBEAFRmsJZPqFAR63ZwvN/9qoAG5oiqOZ/j9/goRnjfTjM5+b14uqafDKNkT
	JAxoYFpCSebuuxpwWOhuaWAiq8k3TQJjOv4gcyHDZr98/x5FRFDXRl8tVdp8T8e8ScZA/w
	cFML3ThYWhb85cFWVFReQBQcI0S+4X8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81BD5423E1;
	Mon,  3 Aug 2026 11:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D121F000E9;
	Mon,  3 Aug 2026 11:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755440;
	bh=X1AHQgHItUAjyCfSWii/TMz98UWdEFUg8DqjV+05t70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JiUiJCOye7/jl1rGGRpqCOJgVh16/YcyclOxKfogRjggIMDGxj9QsmGN6ZXUVIUPm
	 JPfO9GDePDAomLfbjEXVKJYDg1y26wrH1mfyhczkWxGXX+KL0b2KoZpRJa9VNRiRjJ
	 FuJyDqfl4tLeONgNL6s4ZEWnK3XEziDZrqsvuBlzZQ2HWisN91O0dHjbOHDrsAlbdH
	 AKvDLK9NKVCzwK+PB1ArR80DX8LuGlNUPcERKHVlgJeQ1D2JbjmQd02AolrO3A5BaJ
	 T+IOZuDn1ZLtBUtPMQpIFRz6TeZFH6OV/SkPfXgqpzdUEXavltTrZrml7ugpIlduzo
	 tMzhGgF2PDKHQ==
Date: Mon, 3 Aug 2026 12:10:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <anByp6uVW77uofKx@lucifer>
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260802215459.2769283-3-surenb@google.com>
X-Rspamd-Queue-Id: 60D7D140008
X-Rspam-User: 
X-Stat-Signature: 3e6wfkrat3e1cf8mcgh5w7gx6ynf4hhg
X-Rspamd-Server: rspam04
X-HE-Tag: 1785755441-419493
X-HE-Meta: U2FsdGVkX1+dixypL0SeF2Hnof0aXF6k0L3VW/wIPhDQFMVcRtkoRkzCE+i/IbNm/vMI0fJX8iIR1PNmfGyAse/UVVlJJFC8QH0SUznFKVFcBwG6u9Dz2hl/3vjGeFcg2/+RRlDPJ82gcmMwqLBIdo9iW2tWMzUyEx3g4n5XW66QJZrbyfd0pIeDv3SGu8Wm5UWmQhAhADCc/8bd9QzDJfub+eAsZzfea/RZqD7zk/pcehBczt5dpvzCKKOOv52I71X/1GJ+djHC+GnxDMTI7oFTVTILrNg+7ugFpbf5xq5C0RzkXnth5YvWkLto42Xc/ROnDgEr0mWvjuJQIiHPNwRv4OFFN04QmuKHtXUbvNL0dp5zf2oJUGfgcVRVjqyWcGTbLXxNJYiML/kiIXVfuDFWeNy/91WztkbtC/lxRPO1r8uf4naKW6ySvtaDfVz1CsrotZABti0aF6J/qa84X5FNBky6ZcQzeFHol+J188qidcWYFLIgJJbiPy4BSDEz9vYcP5C77AuJdijZ5RWiCmRWtkL+6BO40xkMS0p4Bbm/Ud3yK2WeHn1hb9lJBn8ecus7apeveyjDKq35n9WPFVe0bnXxLbnvM6a5qD0YVgTVcP8JCOa1j9SKlHxKFOIzYcx44LWp6sRsEODJVrTEmMhCYIJasVopeu0VKkeMJ8l/CM+Sltbjh2IjXIlOaPAcglswG967In/RS4OCiJt8W5qp2X6m6QaS3/xfbv/7K1r6XBOnkErumr+kQMuIEdWfXHW6SS96yhgXZAz9KFYkapeiXphZDSdDaL21ePffjcMc61SabvUyC9r1V18BD2KTKbqIfiSRMWvcgrbRVH1PZ5xFVD1xD8iA5rfCQyc5GvEo4wbHjZiNnxqsjo1d3wHIZ07TYJB0z+KQhO4AzC0U3gJq09eFOBKUNcROk0+dQUAzskv2a0TDnrFomTU8D2P6+mQ7xgbvMxRKDeq+/Ws
 18lekfss
 PFl21v2Ns5jdzo7wwsGoGFjbhtoe+63hREwLVQcAS2V9N0Rid3zfP8jaecf8KlcaNBLEamnVui///Vaxmv39+ZXwVA2t1AN1+vkx5kRk31OH8+otxP7JHRwvFIJREn0b0UTDtG38IrgrOwyDXoxw6ON5l/LOpC7x6q2vi5AgU0KN1CH2g+A1F2pyO6i3cGMOeborhEHj9JKXM7vHiNT6n1lMjuXVWAnTi/yG87pVyHUXH0/HDgnWXWFFRZc9o7gJNmtp6iWx0qQAOUeww6S34ILUKYpTVTMBx0MbSCrg4kM8KMtjWquDXnJk8CifarCAUXJQ+Ps4KfkVDxS5h02bFrAs5DR/XIXvKCcKkz91aNPT3fD4cCr/4qa7FNfBWIBN9jpcgsytMIPbW9MiS/AqonHiYO8EJBHPuCOEcax4Cw5xstV7rnSkXVZ6TJrDMiJgL6WqAqZL6QPk143GDg3U4mS8GlZIdUImv80UwsAuhrXeZ3KH0O58qDCDycw7T1ah3HPpLMG66dcytUGnf7IYNvw1oNueJiwKnsXlcyyoZcD4go5BqHKEG8asjYJFN2eY69W71h9xijV/RdV+k9IyYnr4sanDCGMATayZmiQvLLsicxL2hx1GXxvQ4kCsx05OXEoWOWJVcMKrF8pc8M/ihaN1dtM+R+ZJSDzZqTXbENywoj8jeYGRFpkKUQCL30O6qc5nJ+EtnzSGvPqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 02:54:56PM -0700, Suren Baghdasaryan wrote:
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
>
> Full disclosure: I originally tried to do this with
> lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> trylock semantics. Claude caught this in a review and suggested the
> approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> I guess.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
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
>  drivers/android/binder_alloc.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index e4488ad86a65..84104ba04e30 100644
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
> @@ -1151,14 +1150,20 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
>  	index = mdata->page_index;
>  	page_addr = alloc->vm_start + index * PAGE_SIZE;
>
> -	/* attempt per-vma lock first */
> +	/*
> +	 * Attempt per-vma lock. This is essentially a
> +	 * "trylock". It can fail even if the VMA exists
> +	 * for 'page_addr'.
> +	 */

This makes me wonder whether lock_vma_under_rcu() should really become
vma_trylock() at some point in time? :)

Or at least have 'trylock' in the name.

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

Hmm, it seems a bit odd to me that you also have:

	if (vma && !binder_alloc_is_mapped(alloc))
		goto err_invalid_vma;

Below?

So you have:

Before:

                        	|binder_alloc_is_mapped()?
				|yes   	no
			--------|-----------------
	vma is mapped?	yes	|OK	abort
			no	|OK	OK

Now:

                        	|binder_alloc_is_mapped()?
				|yes   	no
			--------|-----------------
	vma is mapped? maybe	|abort	OK
			yes	|OK	abort
			no	|OK	OK

The 'maybe' is because the VMA trylock failed.

So the issue is you might have a case where the VMA _is_ mapped but
!binder_alloc_is_mapped(), which previously aborted because of the vma &&
!binder_alloc_is_mapped() check.

It seems like:

	/*
	 * Since a binder_alloc can only be mapped once, we ensure
	 * the vma corresponds to this mapping by checking whether
	 * the binder_alloc is still mapped.
	 */
	if (vma && !binder_alloc_is_mapped(alloc))
		goto err_invalid_vma;

Is testing for a specific scenario 'we found a VMA but it turns out it's
invalid' and aborting if so.

So either this check should be removed or you should uncondtionally abort if
!vma I think?


>  	}
>
>  	if (!mutex_trylock(&alloc->mutex))
> @@ -1191,9 +1196,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
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
> @@ -1203,11 +1206,9 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
>  err_invalid_vma:
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
> 2.55.0.508.g3f0d502094-goog
>

--
Cheers, Lorenzo

