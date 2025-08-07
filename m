Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFC6C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E538E0002; Thu,  7 Aug 2025 15:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE0B8E0001; Thu,  7 Aug 2025 15:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141F98E0002; Thu,  7 Aug 2025 15:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F18608E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:17:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4499116BD2
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:17:07 +0000 (UTC)
X-FDA: 83750919294.29.FAB68BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7099180009
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:17:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XTrqeL53;
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754594225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NAG7882ntfyDwZ1tQUnH3K0Qiov0AWeHthKD6O9zYA=;
	b=DaMr++R1qqm90yvpdb6zhlzNiheCFFKIqV0iQVjPeuOey/b3ZM7xFZSWDtKzwAr9NwkEz7
	zo8JE4muxDxOK2TrZOONLRblkkoxlOk8adkZA9Awu/UvrQzsRQRFeD29AWU9KSz74hZ77V
	I8xebIl0fVw+mSmUFho2fRcDx7FE77k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XTrqeL53;
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754594225; a=rsa-sha256;
	cv=none;
	b=VN9Bh1AfKPOOImRy/ti0rhG/qRifC/BiHdGa5rDrvIBaGnish9+FDwEmw8U/45zz0NNYbX
	SDEAnTgMZ0CY6QIyNqFj5n8Vus8cCLXo36BybXPgnp2N4SgVABlfH1AwsCBEhiDxKPDeXb
	oZqG3dZEnpGrPq5ek+GBKQezG7ivzOQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754594224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2NAG7882ntfyDwZ1tQUnH3K0Qiov0AWeHthKD6O9zYA=;
	b=XTrqeL5340+ueyuvCBb21EUK3m85Mjn1Z2MZE9Pq6ExG53l21rM0ITdO8Dy0XKE+Qxp4aF
	ywRJS9hSDCCkDFSmUhTBZrwC92EAoAvb6RfxEu3Y/7tF26T2CIdZuOGRHm67ATAEM8kPWe
	BIJkS+lgSs0fE9R8h6P+bpWuMVX0Wvk=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-Nwhd7kuxPGCYUqbE-lL8nQ-1; Thu, 07 Aug 2025 15:17:03 -0400
X-MC-Unique: Nwhd7kuxPGCYUqbE-lL8nQ-1
X-Mimecast-MFC-AGG-ID: Nwhd7kuxPGCYUqbE-lL8nQ_1754594223
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e9029300081so1621250276.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 12:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754594223; x=1755199023;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2NAG7882ntfyDwZ1tQUnH3K0Qiov0AWeHthKD6O9zYA=;
        b=R66sa3li+9F7MmVCljBf7An7e4lFF59DElWxoVeybNrUTgn3JmAag1qOi6oONIKUC4
         SK9T1OKzJM3WnbBMtp3eADbMjafv9mDEs2jS6N9kT8k5a7OZsvcBVvwpilMULdJ7Rq7T
         PcTXkZUDRt8QdGzpdahut4kp4nhlkmYXcks+Cmqpc7ZlpJKQiGTyCdyQ/ilwQPe3Q5jC
         NJOTf7gxES8GPRZGGpI5rk0p3bALAnzLktS5xCw/9fbnTERpVOnd/fJiYpSOfASByRjK
         nJlQCCHgVhlRJgzd+dSJuvad9af/qGOBvCZntqr2SF174L+5BwYd/4M/SX9jb+nql0an
         nxWA==
X-Forwarded-Encrypted: i=1; AJvYcCVzE1PE9xO4pJ1ddvJ0mpuqCduh+11GBXfndyPql/c9F2mmk0PYQcCiT/MVb4sAnsUEPA2KbciIKg==@kvack.org
X-Gm-Message-State: AOJu0YwwxltYtdWzAGNwfSiO0tCxOMuWnOql9gkxjVSI3UF3yMCBFgro
	4uEe+8YeU0ovl/DI7lDJ56Z+QxeGezxCrLn4o0RY7pVfQ0LUDpL2vBKvztpiikHKu3Z39g1m8Ln
	xw//2213AekTJVZ6CHZkbjZZeWqFvqTho6ckTRSRzBWvsaM2y7OOg
X-Gm-Gg: ASbGncv8rZm3PfdlXozqgn4ACRHrLyoaM0C9vW2T5QOQUYWg2JSEXX/Cgrd3euH2rRD
	IK/Zg0Iad0ozg2/5SpSV83v9rcomJJIWxs9s3CGXF6IYI9zP5oq0PSn7FlCxmHPcDFwJ6+Va9iE
	nKy5Sf/fMMoAKM47Mv39D5uW3LmU5SzA/OK73JnYAmhL1Q8QGvbU+qDcomDV1gHPfm22QHlGBfQ
	0oNRYvXzTveUuR2RiWdVc4SsPxy7MUJH3CxUKyuow43hQaeWcKjm8JliW5WYHslOjr+KIm3XK8k
	rlu4lSwAJdzw+wXglGji/6fQnTSYPaVP/h+q1ZF3u9Pmo9iah6xUCehN9NrfpvX505ghxJwtGKB
	L+KNB7lBXAu/yNsUmqE0Vww==
X-Received: by 2002:a05:6902:2b09:b0:e8c:b1d:22a7 with SMTP id 3f1490d57ef6-e904b5adf4amr490702276.36.1754594222918;
        Thu, 07 Aug 2025 12:17:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+pj3fy1zuLl10nK/ZcqOdNqN1EjfLHvJU5HbCNMR9pbt1kap2k3U2BygFe8kr46PFVoYdpg==
X-Received: by 2002:a05:6902:2b09:b0:e8c:b1d:22a7 with SMTP id 3f1490d57ef6-e904b5adf4amr490655276.36.1754594222338;
        Thu, 07 Aug 2025 12:17:02 -0700 (PDT)
Received: from x1.local (bras-base-aurron9134w-grc-11-174-89-135-171.dsl.bell.ca. [174.89.135.171])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9049f5fd19sm161227276.24.2025.08.07.12.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 12:17:01 -0700 (PDT)
Date: Thu, 7 Aug 2025 15:16:57 -0400
From: Peter Xu <peterx@redhat.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, 21cnbao@gmail.com,
	ngeoffray@google.com, Suren Baghdasaryan <surenb@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Barry Song <v-songbaohua@oppo.com>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
Message-ID: <aJT7qQzEs_p36yfI@x1.local>
References: <20250807103902.2242717-1-lokeshgidra@google.com>
MIME-Version: 1.0
In-Reply-To: <20250807103902.2242717-1-lokeshgidra@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 03cVpgXSzQV03d4tFAF-dpIerDy96HJ1coWs7VVJf1c_1754594223
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: cud4ti31phaj5mof36cycfuewm36pki5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7099180009
X-Rspam-User: 
X-HE-Tag: 1754594225-12854
X-HE-Meta: U2FsdGVkX19SguGFM/0JFMLT3FXepVBqoddBYBj7wgQf1DEmd4zT01AT2oASRoL8mzMdn4eayG0u6XmEXWVeW8Oi74StDWSInSxPoOZty+oGXmRkCXmT3IVbFpNc5JYzpHbts5vr9MK2hi/5yCAPyK6tuKVlhN/YDiYtvPsnqkM5m8sGOe/zuYvAwnO3Y4b1G/3jJBsq05kP5cOuT9Gx7hjARMLs5DSO85ofGkh3oh86575Rc93BsahS1z2HL+Yt76f/cH6z/hE0TPzu5II+EDNfjJl9mYO4L4EZo03Dpezrm0Bt+PHzzSk5gCg4MpdcAq5psAP1xDHvVAMU4XFyrs4ncLQplPA1sbckys9+sdCA2XctWHF2SE6j9ESXoqcjBHeohpiOjk50ZsL7Qm4VVat1sadQcUjmlqQu6ImE2ypmeFpwJvVMGUNclY8ddDmu0JmGpY8soe2OZLPOCF4V6ICiPqwk/wfuOUObTWhuU/DE6dw8LUzcamVjDviIfK1xcBB0cIeW02H8sjz1B8kodRmfbqQ8zMmQX4Z+qiP/+jFCu3ToBXdYpa9WREHtVyJ17EAP5NiY4eRasIki29lWy28N9qT5EsTE6txnP4QK2N9x5NSOE66Qlq8eF9IumTVWGclFMu/oUQ1LgxswnNGbuGykiKKl5WPuUXI6EleH1Cr/Evi31mXLqrR5HRBNMs5eeRyIjFAOGtstalczvBRCRW72tRUIst8w/UOZUP4mUZsrivmnm0Swt0F8RitIXiMM/xmCUfjs+i52At/754R/A5jLnT8nFzD8rqMf07eBhf2F2F+GyYaPP5OXyPprtrnbXip0kTZ1+W2ZuN2mDhNcTrd+G5DPNZiPbTHqbgL+B4oe8eMO+Utq7/knmYAOdIvRRZ+kx2Xr1NlDY3cz/WkpW+95jdXP7EwjO9DxWz4h9MacKLaviqN2NKQsaZ7ee0Lse8/Dk7L5+GinsKJPRl1
 IMgeIwo4
 E/vcj/V02modHls8AGhmsUByxFarapr65lhVBwOL6u2CHgEsCyUeFNuNk7o6qz7usupWmp47OjLp8ZAQBRVeLZfUWx4fJAsNqtHjKDPuGBk76DguzLiNt+yhZZiz3Hz9ML0Ft7m4FYfihyyMCSRIJXhGtYyWbPnzmiLtvPdXm+ZX6EF0Q66E8Vtul8d1dbws1G77SMq+ibMXTudX02pBkupft9xeWQzT7/j/RTqSFXB50Du6t6Iy0qYyhPbRAipAYJvm1xglcfoeOm1JhMtNv49PGD/5Kvp/JKaAl2j1VFYoBdTjZrmYI6d7v+xbF7QzOjJltr82DwCpG4ZQALU0VLrZQ+cKMxwvnDLWmfWxefXH9ZzfFIAgvov7imOvFA9C0LiufFtmhszgG9dGcl0PmG9c6kDQjAoHPAAXoK8z6VLgAfv34ZR6e9yKV1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Lokesh,

On Thu, Aug 07, 2025 at 03:39:02AM -0700, Lokesh Gidra wrote:
> MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> for moving present pages. Mitigate this cost by opportunistically
> batching present contiguous pages for TLB flushing.
> 
> Without batching, in our testing on an arm64 Android device with UFFD GC,
> which uses MOVE ioctl for compaction, we observed that out of the total
> time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> ~20% in vm_normal_folio().
> 
> With batching, the proportion of vm_normal_folio() increases to over
> 70% of move_pages_pte() without any changes to vm_normal_folio().

Do you know why vm_normal_folio() could be expensive? I still see quite
some other things this path needs to do.

> Furthermore, time spent within move_pages_pte() is only ~20%, which
> includes TLB-flush overhead.

Indeed this should already prove the optimization, I'm just curious whether
you've run some benchmark on the GC app to show the real world benefit.

> 
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Barry Song <v-songbaohua@oppo.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> ---
> Changes since v2 [1]
> - Addressed VM_WARN_ON failure, per Lorenzo Stoakes
> - Added check to ensure all batched pages share the same anon_vma
> 
> Changes since v1 [2]
> - Removed flush_tlb_batched_pending(), per Barry Song
> - Unified single and multi page case, per Barry Song
> 
> [1] https://lore.kernel.org/all/20250805121410.1658418-1-lokeshgidra@google.com/
> [2] https://lore.kernel.org/all/20250731104726.103071-1-lokeshgidra@google.com/
> 
>  mm/userfaultfd.c | 179 +++++++++++++++++++++++++++++++++--------------
>  1 file changed, 128 insertions(+), 51 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index cbed91b09640..78c732100aec 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1026,18 +1026,64 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
>  	       pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
>  }
>  
> -static int move_present_pte(struct mm_struct *mm,
> -			    struct vm_area_struct *dst_vma,
> -			    struct vm_area_struct *src_vma,
> -			    unsigned long dst_addr, unsigned long src_addr,
> -			    pte_t *dst_pte, pte_t *src_pte,
> -			    pte_t orig_dst_pte, pte_t orig_src_pte,
> -			    pmd_t *dst_pmd, pmd_t dst_pmdval,
> -			    spinlock_t *dst_ptl, spinlock_t *src_ptl,
> -			    struct folio *src_folio)
> +/*
> + * Checks if the two ptes and the corresponding folio are eligible for batched
> + * move. If so, then returns pointer to the folio, after locking it. Otherwise,
> + * returns NULL.
> + */
> +static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
> +						 unsigned long src_addr,
> +						 pte_t *src_pte, pte_t *dst_pte,
> +						 struct anon_vma *src_anon_vma)
> +{
> +	pte_t orig_dst_pte, orig_src_pte;
> +	struct folio *folio;
> +
> +	orig_dst_pte = ptep_get(dst_pte);
> +	if (!pte_none(orig_dst_pte))
> +		return NULL;
> +
> +	orig_src_pte = ptep_get(src_pte);
> +	if (pte_none(orig_src_pte) || !pte_present(orig_src_pte) ||

pte_none() check could be removed - the pte_present() check should make
sure it's !none.

> +	    is_zero_pfn(pte_pfn(orig_src_pte)))
> +		return NULL;
> +
> +	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
> +	if (!folio || !folio_trylock(folio))
> +		return NULL;

So here we don't take a refcount anymore, while the 1st folio that got
passed in will still has the refcount boosted.  IMHO it would still be
better to keep the behavior the same on the 1st and continuous folios..

Or if this is intentional, maybe worth some comment.  More below on this..

> +	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) ||
> +	    folio_anon_vma(folio) != src_anon_vma) {
> +		folio_unlock(folio);
> +		return NULL;
> +	}
> +	return folio;
> +}
> +
> +static long move_present_ptes(struct mm_struct *mm,
> +			      struct vm_area_struct *dst_vma,
> +			      struct vm_area_struct *src_vma,
> +			      unsigned long dst_addr, unsigned long src_addr,
> +			      pte_t *dst_pte, pte_t *src_pte,
> +			      pte_t orig_dst_pte, pte_t orig_src_pte,
> +			      pmd_t *dst_pmd, pmd_t dst_pmdval,
> +			      spinlock_t *dst_ptl, spinlock_t *src_ptl,
> +			      struct folio *src_folio, unsigned long len,
> +			      struct anon_vma *src_anon_vma)

(Not an immediate concern, but this function has potential to win the
 max-num-of-parameters kernel function.. :)

>  {
>  	int err = 0;
> +	unsigned long src_start = src_addr;
> +	unsigned long addr_end;
>  
> +	if (len > PAGE_SIZE) {
> +		addr_end = (dst_addr + PMD_SIZE) & PMD_MASK;
> +		if (dst_addr + len > addr_end)
> +			len = addr_end - dst_addr;

Use something like ALIGN() and MIN()?

> +
> +		addr_end = (src_addr + PMD_SIZE) & PMD_MASK;
> +		if (src_addr + len > addr_end)
> +			len = addr_end - src_addr;

Same here.

> +	}
> +	flush_cache_range(src_vma, src_addr, src_addr + len);
>  	double_pt_lock(dst_ptl, src_ptl);
>  
>  	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
> @@ -1051,31 +1097,54 @@ static int move_present_pte(struct mm_struct *mm,
>  		err = -EBUSY;
>  		goto out;
>  	}
> +	arch_enter_lazy_mmu_mode();
> +
> +	addr_end = src_start + len;
> +	while (true) {
> +		orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
> +		/* Folio got pinned from under us. Put it back and fail the move. */
> +		if (folio_maybe_dma_pinned(src_folio)) {
> +			set_pte_at(mm, src_addr, src_pte, orig_src_pte);
> +			err = -EBUSY;
> +			break;
> +		}
>  
> -	orig_src_pte = ptep_clear_flush(src_vma, src_addr, src_pte);
> -	/* Folio got pinned from under us. Put it back and fail the move. */
> -	if (folio_maybe_dma_pinned(src_folio)) {
> -		set_pte_at(mm, src_addr, src_pte, orig_src_pte);
> -		err = -EBUSY;
> -		goto out;
> -	}
> -
> -	folio_move_anon_rmap(src_folio, dst_vma);
> -	src_folio->index = linear_page_index(dst_vma, dst_addr);
> +		folio_move_anon_rmap(src_folio, dst_vma);
> +		src_folio->index = linear_page_index(dst_vma, dst_addr);
>  
> -	orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
> -	/* Set soft dirty bit so userspace can notice the pte was moved */
> +		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
> +		/* Set soft dirty bit so userspace can notice the pte was moved */
>  #ifdef CONFIG_MEM_SOFT_DIRTY
> -	orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
> +		orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
>  #endif
> -	if (pte_dirty(orig_src_pte))
> -		orig_dst_pte = pte_mkdirty(orig_dst_pte);
> -	orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
> +		if (pte_dirty(orig_src_pte))
> +			orig_dst_pte = pte_mkdirty(orig_dst_pte);
> +		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
> +		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> +
> +		src_addr += PAGE_SIZE;
> +		if (src_addr == addr_end)
> +			break;
> +		src_pte++;
> +		dst_pte++;
> +
> +		folio_unlock(src_folio);
> +		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte,
> +							dst_pte, src_anon_vma);
> +		if (!src_folio)
> +			break;
> +		dst_addr += PAGE_SIZE;
> +	}
> +
> +	arch_leave_lazy_mmu_mode();
> +	if (src_addr > src_start)
> +		flush_tlb_range(src_vma, src_start, src_addr);
>  
> -	set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
>  out:
>  	double_pt_unlock(dst_ptl, src_ptl);
> -	return err;
> +	if (src_folio)
> +		folio_unlock(src_folio);
> +	return src_addr > src_start ? src_addr - src_start : err;
>  }
>  
>  static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
> @@ -1140,7 +1209,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
>  	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
>  	double_pt_unlock(dst_ptl, src_ptl);
>  
> -	return 0;
> +	return PAGE_SIZE;
>  }
>  
>  static int move_zeropage_pte(struct mm_struct *mm,
> @@ -1154,6 +1223,7 @@ static int move_zeropage_pte(struct mm_struct *mm,
>  {
>  	pte_t zero_pte;
>  
> +	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);

If it's a zero page hence not writtable, do we still need to flush cache at
all?  Looks harmless, but looks like not needed either.

>  	double_pt_lock(dst_ptl, src_ptl);
>  	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
>  				 dst_pmd, dst_pmdval)) {
> @@ -1167,20 +1237,19 @@ static int move_zeropage_pte(struct mm_struct *mm,
>  	set_pte_at(mm, dst_addr, dst_pte, zero_pte);
>  	double_pt_unlock(dst_ptl, src_ptl);
>  
> -	return 0;
> +	return PAGE_SIZE;
>  }
>  
>  
>  /*
> - * The mmap_lock for reading is held by the caller. Just move the page
> - * from src_pmd to dst_pmd if possible, and return true if succeeded
> - * in moving the page.
> + * The mmap_lock for reading is held by the caller. Just move the page(s)
> + * from src_pmd to dst_pmd if possible, and return number of bytes moved.
>   */
> -static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
> -			  struct vm_area_struct *dst_vma,
> -			  struct vm_area_struct *src_vma,
> -			  unsigned long dst_addr, unsigned long src_addr,
> -			  __u64 mode)
> +static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
> +			    struct vm_area_struct *dst_vma,
> +			    struct vm_area_struct *src_vma,
> +			    unsigned long dst_addr, unsigned long src_addr,
> +			    unsigned long len, __u64 mode)
>  {
>  	swp_entry_t entry;
>  	struct swap_info_struct *si = NULL;
> @@ -1196,9 +1265,8 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
>  	struct mmu_notifier_range range;
>  	int err = 0;
>  
> -	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
>  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
> -				src_addr, src_addr + PAGE_SIZE);
> +				src_addr, src_addr + len);
>  	mmu_notifier_invalidate_range_start(&range);
>  retry:
>  	/*
> @@ -1257,7 +1325,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
>  		if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
>  			err = -ENOENT;
>  		else /* nothing to do to move a hole */
> -			err = 0;
> +			err = PAGE_SIZE;
>  		goto out;
>  	}
>  
> @@ -1375,10 +1443,14 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
>  			}
>  		}
>  
> -		err = move_present_pte(mm,  dst_vma, src_vma,
> -				       dst_addr, src_addr, dst_pte, src_pte,
> -				       orig_dst_pte, orig_src_pte, dst_pmd,
> -				       dst_pmdval, dst_ptl, src_ptl, src_folio);
> +		err = move_present_ptes(mm, dst_vma, src_vma,
> +					dst_addr, src_addr, dst_pte, src_pte,
> +					orig_dst_pte, orig_src_pte, dst_pmd,
> +					dst_pmdval, dst_ptl, src_ptl, src_folio,
> +					len, src_anon_vma);
> +		/* folio is already unlocked by move_present_ptes() */
> +		folio_put(src_folio);
> +		src_folio = NULL;

So the function above now can move multiple folios but keep holding the
1st's refcount..  This still smells error prone, sooner or later.

Would it be slightly better if we take a folio pointer in
move_present_ptes(), and releae everything there (including reset the
pointer)?

Thanks,

>  	} else {
>  		struct folio *folio = NULL;
>  
> @@ -1732,7 +1804,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  {
>  	struct mm_struct *mm = ctx->mm;
>  	struct vm_area_struct *src_vma, *dst_vma;
> -	unsigned long src_addr, dst_addr;
> +	unsigned long src_addr, dst_addr, src_end;
>  	pmd_t *src_pmd, *dst_pmd;
>  	long err = -EINVAL;
>  	ssize_t moved = 0;
> @@ -1775,8 +1847,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  	if (err)
>  		goto out_unlock;
>  
> -	for (src_addr = src_start, dst_addr = dst_start;
> -	     src_addr < src_start + len;) {
> +	for (src_addr = src_start, dst_addr = dst_start, src_end = src_start + len;
> +	     src_addr < src_end;) {
>  		spinlock_t *ptl;
>  		pmd_t dst_pmdval;
>  		unsigned long step_size;
> @@ -1841,6 +1913,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  						  dst_addr, src_addr);
>  			step_size = HPAGE_PMD_SIZE;
>  		} else {
> +			long ret;
> +
>  			if (pmd_none(*src_pmd)) {
>  				if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES)) {
>  					err = -ENOENT;
> @@ -1857,10 +1931,13 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  				break;
>  			}
>  
> -			err = move_pages_pte(mm, dst_pmd, src_pmd,
> -					     dst_vma, src_vma,
> -					     dst_addr, src_addr, mode);
> -			step_size = PAGE_SIZE;
> +			ret = move_pages_ptes(mm, dst_pmd, src_pmd,
> +					      dst_vma, src_vma, dst_addr,
> +					      src_addr, src_end - src_addr, mode);
> +			if (ret > 0)
> +				step_size = ret;
> +			else
> +				err = ret;
>  		}
>  
>  		cond_resched();
> 
> base-commit: 6e64f4580381e32c06ee146ca807c555b8f73e24
> -- 
> 2.50.1.565.gc32cd1483b-goog
> 

-- 
Peter Xu


