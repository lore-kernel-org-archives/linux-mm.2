Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBE91FF60F4
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 17:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F66C6B0095; Tue, 31 Mar 2026 13:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3576B0096; Tue, 31 Mar 2026 13:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3436B0098; Tue, 31 Mar 2026 13:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20D076B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:44:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C032C8B3C7
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:44:57 +0000 (UTC)
X-FDA: 84607083834.04.37FDA20
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id D091A2000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:44:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=orcF7H9H;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774979096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vofdppwa9otl2577biBqhJMer4b1Y4JsoxCtUCoyMx4=;
	b=EUrU9SwOKi34TgKFIkgPagIUbH3ursfiwKE/tH2E5WxSaMXu2Db2zy5u+Gn/sDnPFyOPRa
	y/i2EG+P7tYm6NW5D3o3kEhxixgvI/Rgov8gw8uXlUJAkUsXbvhhh9p1p1MR0jedxKH+fU
	iAbXrMl7inNkpBC2ycZtYNKMFRl+EU8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=orcF7H9H;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774979096; a=rsa-sha256;
	cv=none;
	b=BvVKZLT7Ds2wjEHIJG2KebUdHFAwNaD2PrV2ZzIC6s/rYjdvBvso4BXsKMyI4G1ggs5ijV
	SHZVURjZFhaL4+AKl8qBWRWEMqYmIiFUeQiej053fDtJ0AimHNZ9Nw/KHZfhKTXtSELavw
	PGOuT9hw/riD4L3AcBBNKBi5Ph6YUFg=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38bd15d82bdso45797281fa.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774979094; x=1775583894; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vofdppwa9otl2577biBqhJMer4b1Y4JsoxCtUCoyMx4=;
        b=orcF7H9H4maVlJAoetUxP0Y/b1/HSgNisSLoTsYDrdmoDKzlMAz/nq68zI09Z9lSvY
         ZlWyuOahYfhBLbdFCSdgekE2hp48AkQ8rhoUeENtsz+DxKsG9rHSNVj1f0tZOOUgLSdm
         KuTehQ4dNNFVP8c3KQHeDslDBngGUKiUTZ90Clhha3hX2g5ZqCGWi4ipp8PtpHrKHZT0
         ZiCc7jsT+EgCF/eID5BGLOru/7B8pwuv/2CRRvWog5Zic+b2A0viEwfKSFYvAZFT8D/K
         rOztVIg9/fS2aFonHSJeI9QXwy1kD4isL24+Eyrzr2SssVp4j23Rsa8R3UNCQuscVDmK
         Q03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774979094; x=1775583894;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vofdppwa9otl2577biBqhJMer4b1Y4JsoxCtUCoyMx4=;
        b=dcXu3uOhNeRB8yqeycaRHC2Dtld/IYYMSms4MIpsJTdg9AOGtJ5RyO2W8DAnPbVKlI
         BvxFIovhoH0ZF90U7/pL83iUltW674QMmRng6xBi2ftJSYChmmLRbJEw+yBg/B8oEHZI
         ee7RgMvW0oFpWaxQ5hRb2lm5wgCm6oJDfeRJOP+t36wg8SeG8j0R6cTr8ymnlaXffiA2
         QZMRuE8FRltTrBfUYJx1J3xGIjysCYuJRSD5BTChKNEMhrpw8N/QxYSlHTTYOGivzOlc
         tfwqMkY+8+dVSOMp6Z45elQjGRbQVqIsxW4Cl4Ir0yf1nZanYNxQTZVFXnHVwBILG7p1
         ZmUg==
X-Forwarded-Encrypted: i=1; AJvYcCW3a3F+bysxOaKmHDzO5YoBwPimySW/Bl4uBsWc0YfEfkjmYg6nMh5jpXoTu5XF5mKpskw80TBLhQ==@kvack.org
X-Gm-Message-State: AOJu0YwiFsomDFsqnbPWNFFWCtV2ibwsfzkitNfxYrsW2u4iXG2/X5yD
	s5Svsko8CL5aU2AVRUloiVO7hVNnmeb3dkxF4yyadLruV98Uw7ggPBge
X-Gm-Gg: ATEYQzxRmhPyF4c7p+3pD+mGxZwMdp9vWhfpbOlUKjKmyJ5/mYgpq1BscBVjmgoeRq6
	WK2gSrFdZ+vuhVCwy8tgKjmBq44ATi/3G90G8GrMOQ4K9zI1BnYRv4pDLfutU5fRlh6VX0/Rh2W
	eGRoQ66u6ns5oxhZu0GKzUyLdSOpY3/9IhzCa7BhMQr9nyfODgKQGu1D7TgsYxOfo7AYno4BoS+
	ZUhWW2xEQlbLHpxNNd4G5X2wAZZMEB/U+D7PaXD1MQjStR4bT/Ru2Kc7OSEKgTMrBYcdve8TUsB
	vBrZFFPWbuD48b03NENZWFs16++rfDSKZT6PGChgXxalFhni2YkmT+UWD9TxUImGWfmnD20kTWt
	LgEFb3pAGEnQM4O1PUMmTy26eCZGsMv9qrBWWgLXOYbHY4z68iutmS4mLf7IpuYG4
X-Received: by 2002:a2e:2e03:0:b0:38a:2c06:a270 with SMTP id 38308e7fff4ca-38cc3131a92mr593751fa.30.1774979093718;
        Tue, 31 Mar 2026 10:44:53 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c836d3f3dsm26283081fa.8.2026.03.31.10.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 10:44:53 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 31 Mar 2026 19:44:51 +0200
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v8 1/6] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
Message-ID: <acwIE1FVoFaoYnLh@milan>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
 <20260327-vmalloc-shrink-v8-1-cc6b57059ed7@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327-vmalloc-shrink-v8-1-cc6b57059ed7@zohomail.in>
X-Rspam-User: 
X-Stat-Signature: 35z3wkwacbj649wyd8131udyjyzby9pt
X-Rspamd-Queue-Id: D091A2000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774979095-378145
X-HE-Meta: U2FsdGVkX1+UTvVwkgDgEaOzHF4NV0ifkACMigBYfTDlGtgzQDM/zQY8tid2prwwrTkNSbgR3CRSvtIzmPuiaq4tIvV31KRaGkzPNfn/d6hSqii5LJeXrwDl9a2Z/LSIx8I0vO9i4UEEc7uJXXoYOUe57k7+QFJ8KYbygr2DcfcmX9jOK67ln2G70NEyIAFT+9NG/kAPALMlVMrdw1hqE+Vi7eo3J6HL1qH3gDlKw7vDSKLNZkS76J/27K1NzYykNP582ATNtXwGQQhYrnWt9cqq6ovljIaVe51FO5TmNgR15BaECiriml+Sohb2atw0VKh6hGzLiyAkWe3UrZVAneaNIuOhiXdSbRIizFihUruJrWl59eJ1aRT0hj/irKScqc6K/clMJgMwCwGz1bl5M9STHi93yxY38IJKtUkqfDGnOoZZmWqBwFsE6RzF9E6zuYQo9BIT4xTMwVXEVDLGMB0xUf0E/5GBwI+kvug34ltAXibRm+O7XjdQxlmbkvEZRtiUYCK1JNiAEYG1mDrObAtHJyw2EPXQ+6W9c5lAHTVgzn+1/VcHgcefWVpZL0ivrIDndZts6HoTS9b9mQ9JEyikpcD22szOgP070axWZRyK9t2vQeQ9FjA+oKT1Muu7jdTq2U55lYOr4YBmPw6S4kC3cGe8rulgECSLKsRtGNeTwBPfGrch9wJuhvYcZ/t0ecuMVncQ7uMsiMFmVJ/VE3NOZoQoFK11ZiHyHo+7lr+702Y1HWIV4a0XN2CyDE+DoGWUC0Ld2clFAlBFwmIzUOalMV1Cg7OZWN02f8y4JTxTBPN15W8VaDEgXObfc6EyrmNGrPvMLs9Vhmkyv7CIQyrxsOmNSNDe9FRqnKhdDyB4LkC+VANLV7Yx9Ozx2kkgL5aPI5agn4IenQl8iQPcAj5kda6AdXayerjYZLIsf+qyO3RfqYZU1kgU99rwZjMNxa/8EV9wx1a3LqVXCNY
 6oPTmxp/
 mH7xGsTtG3wPP1V6+JCby5npGJ/INecYuQm6tlJwX4YxWCSbxrMmuhQjYgCwh/4cTI/D/VIFOzp2iiV4G92YjkXzbe4ZjV5jNAncABkBrMDPOA3JLlpABMNnxNBo2aIEspMBzruRsrzCKCcwr6FuzSCX4dDjkURfsjLO+2uGIWQWXLTxu449HvRqRf7uqSkTg6sJHjYahHo6Qf1ANLTxgDer/abOvTXHsdIEIZSN/bzbAjrnfuJXzu7ZCR1c0qE14NMZ5ssbWFiqt/CqeDnAZbRlj6m+K42MSil1tl17hEiR6wBuXd++XaENuJMzZE57DVI2xU9/5ulJ0r8z7mrdbDEdruZTjgcfmFQwN8clbQzBHqSUZ1xkSQseEWGgCBuLQDIaq9aVQgwIa2fR6CDHcwVciWTdQEJeMX7xkA4Wunf6rNcC0H6o7Bbik6NC8vM8YY7JzjqhorOOdNL4ExEZ73oJvNWpWQbCruajgjOAzWUR8DVpnxNb1VGgCZceojiM6L6mmYf2HA87vFHl5KEVRbY4r6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 03:18:37PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Extract the page-freeing loop and NR_VMALLOC stat accounting from
> vfree() into a reusable vm_area_free_pages() helper. The helper operates
> on a range [start_idx, end_idx) of pages from a vm_struct, making it
> suitable for both full free (vfree) and partial free (upcoming vrealloc
> shrink).
> 
> Freed page pointers in vm->pages[] are set to NULL to prevent stale
> references when the vm_struct outlives the free (as in vrealloc shrink).
> 
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 47 +++++++++++++++++++++++++++++++++--------------
>  1 file changed, 33 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d75151649c97..79a57955345d 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3416,6 +3416,38 @@ void vfree_atomic(const void *addr)
>  		schedule_work(&p->wq);
>  }
>  
> +/*
> + * vm_area_free_pages - free a range of pages from a vmalloc allocation
> + * @vm: the vm_struct containing the pages
> + * @start_idx: first page index to free (inclusive)
> + * @end_idx: last page index to free (exclusive)
> + *
> + * Free pages [start_idx, end_idx) updating NR_VMALLOC stat accounting.
> + * Freed vm->pages[] entries are set to NULL.
> + * Caller is responsible for unmapping (vunmap_range) and KASAN
> + * poisoning before calling this.
> + */
> +static void vm_area_free_pages(struct vm_struct *vm, unsigned int start_idx,
> +			       unsigned int end_idx)
> +{
> +	unsigned int i;
> +
> +	for (i = start_idx; i < end_idx; i++) {
> +		struct page *page = vm->pages[i];
> +
> +		BUG_ON(!page);
> +		/*
> +		 * High-order allocs for huge vmallocs are split, so
> +		 * can be freed as an array of order-0 allocations
> +		 */
> +		if (!(vm->flags & VM_MAP_PUT_PAGES))
> +			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> +		__free_page(page);
> +		vm->pages[i] = NULL;
> +		cond_resched();
> +	}
> +}
> +
>  /**
>   * vfree - Release memory allocated by vmalloc()
>   * @addr:  Memory base address
> @@ -3436,7 +3468,6 @@ void vfree_atomic(const void *addr)
>  void vfree(const void *addr)
>  {
>  	struct vm_struct *vm;
> -	int i;
>  
>  	if (unlikely(in_interrupt())) {
>  		vfree_atomic(addr);
> @@ -3459,19 +3490,7 @@ void vfree(const void *addr)
>  
>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>  		vm_reset_perms(vm);
> -	for (i = 0; i < vm->nr_pages; i++) {
> -		struct page *page = vm->pages[i];
> -
> -		BUG_ON(!page);
> -		/*
> -		 * High-order allocs for huge vmallocs are split, so
> -		 * can be freed as an array of order-0 allocations
> -		 */
> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> -		__free_page(page);
> -		cond_resched();
> -	}
> +	vm_area_free_pages(vm, 0, vm->nr_pages);
>  	kvfree(vm->pages);
>  	kfree(vm);
>  }
> 
> -- 
> 2.43.0
> 
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

