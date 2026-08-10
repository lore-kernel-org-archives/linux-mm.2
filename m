Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAFEC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B12C6B007B; Mon, 10 Aug 2026 14:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861B76B008A; Mon, 10 Aug 2026 14:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A046B0093; Mon, 10 Aug 2026 14:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF446B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:32:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 599DC16025E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:32:24 +0000 (UTC)
X-FDA: 85086205008.14.AD65E01
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 851F816000A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:32:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PZtUpNit;
	spf=pass (imf08.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786386742;
	b=yXbLeGfhPvs2zd515goftLIvIpuXKvgPKbYDKe1xzD5qpeMOERVOSCLOvcub+esixVnzkT
	O2paJ7pNBVwN9ZUeXTZX/M4wIU9PVu+k2V4bMfFpzrx0OWg6obNZ2PvtzNN5Px4pObqY3A
	6VohjeiRizEmPGhq9uYw+HLBTcmaQCk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PZtUpNit;
	spf=pass (imf08.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786386742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yc1i9jCZ38+WjTOLsbw1yfhU6KnLG4orWewt9NM2biU=;
	b=nhnDMMbM0yclRbQISUzuJsYVJVVRBMfgFEriBfX3xMdxPV4qej2Y+iPIM2Yys1mDvn8Jy5
	yNpxkS/wI4q8GQ3MoA5Du896JuyV5JrTtc4UIekhinj2BrW8ipIsXFo8e5siABi2f6IkTs
	J2XUm9ADLohzROMYZGhrxB++rCpWQLE=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ccdf36f63dso17055ad.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786386741; x=1786991541; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yc1i9jCZ38+WjTOLsbw1yfhU6KnLG4orWewt9NM2biU=;
        b=PZtUpNitMrabOWDq3CEdpMPF0y2IuCFGXKLagKtBZXtWTK+Yrb4hyVEL5SDkB09Onc
         5BOf6pm9h39GpZmXxk3AH274FubKDinLAHsfUd2+c6+//j8CxRPHadKC8uZ0xwOHnis+
         KNjyz7R8EhjS6JBsbqJkaqP+YB9sY6f35z1DlyE/W+lqkhs3pSp0Hvh1IHA28GdO30jO
         /apP8xnj06bYhjUbAfwoTuDblk4vGbNkvmSHrpA2HBb0bILfzgUO/JkPn2ENWA7Bd57R
         gVAevIQGbktx6Ui16HTSkN6gOfRW0ZTKvCpQLBNYkkPrjI7w16DNRx9cRgk88B1Eo3mK
         LLeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786386741; x=1786991541;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Yc1i9jCZ38+WjTOLsbw1yfhU6KnLG4orWewt9NM2biU=;
        b=HXTYkwpjSvzIk3RXp8t6FhHFmHEPVhPJvsACkSVlJNDp9vcCOXpsn7aj0FAg8M3sI5
         9v48CxcR3Dj8aARj56Qm4tWzv5HPB6UXSJF4tFPM6opm/TU1iwwEN/oRxkLVnUM2QLGP
         8Nq4J14CdbF3bB4+QiNcD0Y4CwWwlgZuBEWl+vxcYE3Nc5j1UHsH6jS9IMTYdoYB0Ccj
         KVvKAPVC3cG+H/frkU6xP94pNL3FW8ZN63sN9GjpdLP03PU0xJRFp85+4Ju2jJ/yLWrs
         ZyoawqZJlUDesXM+Hj362T3CCAwkRaa81XRK4PGC6MxGclG8KN14MKEolywQVaePefNZ
         xliA==
X-Forwarded-Encrypted: i=1; AHgh+RqLPeou9hgxdeSeGx/WTyt84bjaschqdGygTNv5h6ltH6VKacteNJ/UmKGrp4YG1pvo5c9Qa28vsg==@kvack.org
X-Gm-Message-State: AOJu0Yzh6x8MhrtqcO3QP3IsX9pGzxtmGwCJRlVav1zTH9Ma7AHVXId7
	MYE33nwkUl2mAOjYNx5G8N7Smg6jYsLuqnEHOKsR0WnqYJ66M4Js76yaU/06o+F/aQ==
X-Gm-Gg: AR+sD13daNCQ11wcnziUIuB+Q1qqZ8YxWaHJ2LtUxjCbdmu/zPl1kkRzkjV6x07CdRQ
	Qmr/Zh3MxCyncvbhh2q9ApPqH20AOjnOIbYwk5Fvt1kgu52gCIgGCKY9kZTI1FaTrSXg533+OB9
	gv+UQPTiQEQdCYmnozfagzm54zrjroci2SZX/ShemRiFsrx2UMKs8zr/ODd26tRw7RUd2sNPpFp
	16voMwjR/b5EPMQqK5h5uTtQgX3iLx3GtSEeD62TXyugKuc0+WyJYJMpENDPtahLHSd1MgiO27g
	JnQvelGx+R5ADucPbqmL4d+3hyM2kMd8ae5ofG9Emk6wcRsheMW1TWNFdImIJqx31ebllMhJyc4
	HLprWHccEcgtoQjrM9oOCPS06UWh3d5ddmwSPn87wU29kb8KKBnIXTiDPtHLq6aNynNnQiuhOgt
	O690q/X9B//k2YbOoMYN0vRBmNygrB1lL9wO/c2TgeRnVFgTN1c94EvJAAn7UZhjCXg5mKFLk8F
	8pJbMIES4XX6Mv+cdVf25pL6mERkqLtIucsAgeZVDXpJiMNDb6TQHiKpgJL5B6q35VVUy6dHf4N
	H/e8G18=
X-Received: by 2002:a17:903:2ce:b0:2ca:6bf:5bac with SMTP id d9443c01a7336-2d3105ceb62mr1449205ad.8.1786386740920;
        Mon, 10 Aug 2026 11:32:20 -0700 (PDT)
Received: from google.com (193.67.125.34.bc.googleusercontent.com. [34.125.67.193])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe8f35b16bsm4507503a12.20.2026.08.10.11.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 11:32:19 -0700 (PDT)
Date: Mon, 10 Aug 2026 18:32:15 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org,
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org,
	jannh@google.com, aliceryhl@google.com, arve@android.com,
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
	davem@davemloft.net, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <anoZL76y3WGXMArB@google.com>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260806200548.3124802-3-surenb@google.com>
X-Rspamd-Queue-Id: 851F816000A
X-Stat-Signature: sx5ssxx67z4busymt4bis4zixdc6arib
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786386742-504291
X-HE-Meta: U2FsdGVkX1+PylNO45yCwCubQsLqvHY87aHU2JF7HkAADT1GpWPXMqTgF1qUxOVBzgIccz3tjTgY1ftA6L8VXedMou5wvXxKJVkm2jNtpmmT7R29/geyf/xAnQkudb+4PNvBM7qZksRnDoaH0D5YMtbas2l6M8DqL5Jevlsc2y+q1UkN9Kky31zVWdSTWf0ZdgsZg4Nr/iL0fzHsvvWfbOOCnmGvCDlhZ0X0FzSclqevPbpT+ktVYT/vDowGFXhg0OhTG7/Ev7MDiWzfdw8fcGMKDR3frA+3Ez2w/qZXJxlgRTOivJBGT6nvcCRCyCzNuPB/RWccnteS0p+d9T682/F9Z3gD4JVkhpt+JaRyPGd5e/84cCGv47+123zoDgTFR77B8fHEq67w6Yr68ndvAWmQbDVViy5rKnXr8MyvL13N7gK0KiyZr/pZvM8pZLo1CVFz/QOw3UwFDDXosI49rCt5tXssWOvLe/tHEr89F+v8vCXPdWut9+IaBnjPvvADdfPZG/A2lo1ThWulFuRCxdd2OUdJZcAgJWiq20bcxz8Z3mbmt1QV/o5Z7yGhJt51iaL6NG3jBMPyMUoEc4sO4o9vlw3EbGEP2W1RGx9DL0g5qpgt5Y4eXcYI8IqVVvrDgWVPViosm8vwDwtjSdloMlv4iEWnZEHWxgcTy8emIhNESYpjr876r0bnmf3fDT/F/MU0oQh51vWcdr14Xd+5HgQ+0Owof2RlZ0kQ9Mosv625y2Clg1YM1QfPKPAfAd9XT/HZbOY1zHFZv82yjblAYRipQ5iKwRZLWSO1bK8LgFJ386NTpG/A/CIJQ4EAVtq9XZnKrvFoOaF/CWRBe/38wRzgOJR/JihL1+6/linJzDlAM/rZuNnG+VpWgwh1zq0Jk/zofsJzixTQUnQbx4xojoPrf9J+UTOyRfYpweHzJphnII0Q9zHI9VtuO9Fl4hJQzhID1ddaSh2IhukZMdZ
 lbTKKZOh
 X9ig/Er8DyA9N9OE+SWGTe1akTYHMNh/OEU6P06fDnzZxVRi+bd/0+qXYXwTcisqDx6NvjHqEhLIuIEo2g3klUuH+D0ARRgnK4lb7j4casbCcGFSR7C/FzQOJAs+c/LP+LL6gp2fDCWXV6XGHJOB+Dfy1y03P7ME3MgWgsJUqYvhxo6AT7slDPP5XuAAVYWvRht4oKuEA56PctIFB2Dsq8saLZFsUAb863POkCrRbf2wxEILxGFf8X1aS6zgcwU2L9u+24HccS6+rPSk3O5xbVK3s0OnZ/gaLBPYItN5AgbQ2lcMpFXs9GoAGdHo1HANNKnzMdGkZg8eJDkt0eTVD8lqhRv7a9I3Z2xW7WJf/gYeW5Cd4Lu+9f6bsBQt8ZJdnMKXzgHxnDX/y8gy/DDuZk8gq6cfEUMxlU+UqtMea27YCOoINyRXcNnwR3/cAIQ69f4wQsa+2Rcneqhmd7U1+k5t2d7daAIFzAvPtNkM85UEpgdpONYiSK1MFjmatgG1TOxNK7NEEcydohgUmELrBKO7vat0cxdw7FXFkLWnmSufpxaohRsIP6b0sYznpxWaVgnaa4NEM5l0OqaMyFWWVirtF4szeAuAjO4pEN2mZu8NDo+LAtX0MpKsZ3N2/jclwl9Mb8VmBY2+7rCu6cG8i1TbCBRden+EFBCE54zRMAacjW73bPgwmyr9vvUjzaMpl8VMFYE5+nxU1tUT7I1GkR5aBxP1pg/N5A6VGyzXbY2gHSH5yH1aSmHoBMpTluPaYvnrWZQzJ6zesHFWKVO7UDRuugw==
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

Do we need to explain how lock_vma_under_rcu() works here?

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

The comments seem redundant, the label is enough. This works:

	vma = lock_vma_under_rcu(mm, page_addr);
	if (!vma && binder_alloc_is_mapped(alloc))
		goto err_vma_lock_failed;


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

This introduces an "extra" change. We'll now release pages without a
valid vma (e.g. after munmap()). Before, these pages were expected to be
released via close() in binder_alloc_deferred_release() later.

I don't see anything wrong with it. However, it does seem out of the
scope of this patch which just drops the mmap_read_lock() calls. Or at
least I don't see how this part is necessary.

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

This mutex_unlock() is now dead-code.

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

