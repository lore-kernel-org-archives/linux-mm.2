Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB497CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 179D16B014A; Fri,  8 May 2026 13:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A146B0209; Fri,  8 May 2026 13:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33F46B020A; Fri,  8 May 2026 13:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E27EC6B0207
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:07:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 881C6160228
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:07:08 +0000 (UTC)
X-FDA: 84744882936.24.8A4649C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id AC83FC001A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:07:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DvvE73lf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778260026; a=rsa-sha256;
	cv=none;
	b=q4BKG41LLXaKjrFISmDApSsxOkNmn955N/C/+Xj/9f1x0ID70RJzqpN7LWEQd0dkqKSiC/
	mzbqjFyNa6nH2+TbCHzOzSHDtp81lgRzaFVFac0ZxLjqy+c2M6cvCIptdRfL9dg/kK+XUH
	EZ1e7Inb0DGaniRRlWtp7FHFsHwGx8A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DvvE73lf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778260026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NomhxOQoy13YIqlciTQ2TDHTAbB1sJQeRfYXf0OqUvw=;
	b=ATGd5tryJYKy0iuac1pIKe+rB3XvLjQM6m9x+Se58Y/2oglNevMxI4CtG9WQxQAz7sMx3a
	fJQzwu50xGBmAVT9UE87rLPr01E37lGSQ1LxG0NQjspgehHUfyFCFxg1TEDRVoz0m3g4FI
	rjH6qVmx+KKHLmERcyENlV0Wfx5Juo0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A889044206;
	Fri,  8 May 2026 17:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CC8C2BCC7;
	Fri,  8 May 2026 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778260025;
	bh=nZlKOZi3D2FxQLGXjJnBU0HjVLTgkka2CeNKlpurw+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DvvE73lfByXNeN2jj9Xu6I68/hlJU8ru6ieTVyIwZmUi7KV1Cb04k6R23SnOoE9M6
	 2fm28DrRwlxKuBy0/OqOAIdrEjNPrzaMhNBdGqk8F/aRE0sk86TnTCrEVb56lyUjrK
	 MBrMyHXIeD6xOgdQl5EYtj271+Q8hwqyLxRrwxw9d2FIjC8/iWfRfEpgOxXCBs7EXt
	 k0z+LH4H7ilj2vDGBzNVIDKbVI4GCOy67wz2eWSFP25jAEKKyY4Spvz5OnMgUDETaS
	 Nh1sAO6782AqIaflWmEcaNCb9VW+K5ioS8xsybEi6d6G4ctPDtotlBGc8I7lBJ2bSq
	 1YX9Qc+ZOUjyw==
Date: Fri, 8 May 2026 18:06:59 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 2/6] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <af4V7pP4qdIsB0yA@lucifer>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429181957.7511C256@davehans-spike.ostc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429181957.7511C256@davehans-spike.ostc.intel.com>
X-Stat-Signature: rmeiirzpzptydny4cky1sqakew84uyhn
X-Rspam-User: 
X-Rspamd-Queue-Id: AC83FC001A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778260026-562416
X-HE-Meta: U2FsdGVkX1/GKCCGUwyh7eIkv8n84Na8rCOgsEahkqLH6FlM0KT5Hssm7nAW6LaBqBOIONSBi7r0uAQCVtk00CQR7R1i6+TOQmg1j8aTjybPa7yZ/Kh4PyeMd02n8GZ5LqE6fpJutM2Nr+jQ+3MnU+yhceRk8rWPv5ljjoFEuraI9BTaZ/XoCiiWGr5g/oh5bOkP2w1rewTMMF1jv36FX+Yslm1Bz0Llr8nOpA/NkvrDmriTfqSFHUiLN6Uf6QLFB+Qs0jiu4BtIEvCg4X44KXAVJhzqn2/1gRGRVZ6VCErYdUcDPscL48bUHxsZVsVe4URaZvcxVjSd1fskIAOc7xbSUxh7LZast306DGeD6xGDwm7ECuRzIk08BYzGsbKdeV1swzOG/wUqF7RhXR6UNt4cHXYXvFjs6zWymLrpWZs5JGX7isBEhY/osCTJiyBDFK4cdelgDdZq6SPdUHmu16OiHf1VV9ni02bBU5h/aPQtjeyCyx7QYdCm+/P+O/ER53bAf2bHSbhBpY0+IqJZdccSTxeoSG0EfSR7FnmWMNUspkbEoK7YODmtj722JlnWwGLS3pVbt7RAjkHFMnBCRqKsiyC9KMs55dP5EzmVq1BSqPHWi3DD/M22L7ggeGl7GFHfyKT0j8SatDUjSWMeWs2Dxg97WKQjSSrt0Bf2mdSNWiRtY7GCFfklbzLaBeBLXf+oixpOe5zb+L0PUguAFqA9OM2qTxqAgty7KSFjMTBPwgkLc+fXASAiVFYRetrWuuzxJ7HMDIllh1CJvwqTuwMG+T5vq5r3GEI98MUZ2PTrnzsSJMlLWs4y/cLy94BSI5Whe2yJH3XnalcGGWxUVbxG/EFE1D3TxZsaFjW4+g99KZwckppFGl/z69gX7w6V3kHeyHVHEPUsra9w7LC0ZuZvu3n1KBWOHtZ+X918Ca4z37YZSijhYLpjFvDfI2LNLbV3AfZtI3r1sGprweO
 3xhZAWNP
 RXZWVzo37RnCfFXcBkC/8lBIghpRgP7osldkRIPn6YPR4+tAVBv/8MfkKWClFqkGo91ld+i0tL/O7HZxrj3SZpNOxz8UH/NxMaVumI4Wi15jOnv4zOqG/RV7Gjwborhe7biNUTIvqEQwI/ml0rGld1anh7TajbcsyHiFqvZNjOhPtfA9H5UCFJRq7j8qnSjEygPaAai8AtUNrBOUCYBJsEiFTOum/ce+xKUBPUj8RwshWABYmCtPgU2OLgyFVY5i2BwzgA39xVAWUWEhpAZP0CDMTm/qJG05uxIpQljEEFA1IWt63gcglIStabG6TBm2+ojmNQ6FstA00/nXhLmbJ8Ba/BvqNBr7jJ2mN0QpOP8me/jo5BnQx9j4KS4JYZDOT6FwA+/9vhpiylKYL43FrqrQ4J3oiQ5nqGYEg0sg7cM8of3S7/ZfBewbaYPW4iE9A+AkJyTinhIQJiGnExPrHbJFsfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:19:57AM -0700, Dave Hansen wrote:
>
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
> support for the per-VMA lock, but but left mmap_read_trylock() as a
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

I mean this seems reasonable to me, I don't really understand why we'd fall back
to mmap... try lock :)

If semantically you're trylocking then as you say, lock_vma_under_rcu() already
does that.

Honestly I feel this could be submitted separate from the series.

I'm not a binder guy, but this looks right to me so:

Acked-by: Lorenzo Stoakes <ljs@kernel.org> with nit below addressed.

> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> ---
>
>  b/drivers/android/binder_alloc.c |   22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
>
> diff -puN drivers/android/binder_alloc.c~binder-try-vma-lock drivers/android/binder_alloc.c
> --- a/drivers/android/binder_alloc.c~binder-try-vma-lock	2026-04-29 11:18:50.066607065 -0700
> +++ b/drivers/android/binder_alloc.c	2026-04-29 11:18:50.069607180 -0700
> @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(s
>  	struct vm_area_struct *vma;
>  	struct page *page_to_free;
>  	unsigned long page_addr;
> -	int mm_locked = 0;

Man why are we using int instead of a bool in 2026 in the first place :P

>  	size_t index;
>
>  	if (!mmget_not_zero(mm))
> @@ -1151,15 +1150,10 @@ enum lru_status binder_alloc_free_page(s
>  	index = mdata->page_index;
>  	page_addr = alloc->vm_start + index * PAGE_SIZE;
>
> -	/* attempt per-vma lock first */
> +	/* attempt per-vma lock */
>  	vma = lock_vma_under_rcu(mm, page_addr);
> -	if (!vma) {
> -		/* fall back to mmap_lock */
> -		if (!mmap_read_trylock(mm))
> -			goto err_mmap_read_lock_failed;
> -		mm_locked = 1;
> -		vma = vma_lookup(mm, page_addr);
> -	}
> +	if (!vma)
> +		goto err_mmap_read_lock_failed;

Nit, but we probably want to rename that to err_vma_lock_failed or something!

>
>  	if (!mutex_trylock(&alloc->mutex))
>  		goto err_get_alloc_mutex_failed;
> @@ -1191,10 +1185,7 @@ enum lru_status binder_alloc_free_page(s
>  	}
>
>  	mutex_unlock(&alloc->mutex);
> -	if (mm_locked)
> -		mmap_read_unlock(mm);
> -	else
> -		vma_end_read(vma);
> +	vma_end_read(vma);
>  	mmput_async(mm);
>  	binder_free_page(page_to_free);
>
> @@ -1203,10 +1194,7 @@ enum lru_status binder_alloc_free_page(s
>  err_invalid_vma:
>  	mutex_unlock(&alloc->mutex);
>  err_get_alloc_mutex_failed:
> -	if (mm_locked)
> -		mmap_read_unlock(mm);
> -	else
> -		vma_end_read(vma);
> +	vma_end_read(vma);
>  err_mmap_read_lock_failed:
>  	mmput_async(mm);
>  err_mmget:
> _

