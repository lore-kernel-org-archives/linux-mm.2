Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 078C9F53D7B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 17:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2006B0329; Mon, 16 Mar 2026 13:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6994F6B032A; Mon, 16 Mar 2026 13:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0DE6B032B; Mon, 16 Mar 2026 13:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 483DA6B0329
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:12:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCC641602B0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:12:42 +0000 (UTC)
X-FDA: 84552570564.02.818D680
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id CB455180013
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:12:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y5+Q/2+F";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773681160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M6+A23HBU2e9zD5HhDvJ+x1NGZghXMudqlydZMoWGqQ=;
	b=JRDTAs2OPsBaKAazUa73WHdkITu3OZhOfPer3sPVfS3Jj7RScexsJIK7E89ZWxQYD5TYO6
	ZD8EXE/K11IVPhtYejtgKsK/+EdEOE3yqwnBl5whhXloAUsGnpYp1tderRYN9Cxcp2cmcb
	k8nOyqd1ZKG8UVuGWoLXsGqew8AUQSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773681160; a=rsa-sha256;
	cv=none;
	b=sVmBt/WdJkHgWuR6z2uGC90fPPyRwK2C3C5MX+t4Ui30Rsw2jLvSQcFLLdQncGCpOx4lO/
	81GHQehmCmGgKlD8fOwZMg/qnxCSGbsDG/Ef7j5P41aXAnXF0Og7efBggTBFZ+CaYkf/np
	/Nb+rXtEEwVp1cgu89Ds+S0ZaB2ox18=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y5+Q/2+F";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a13323ba85so5579699e87.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773681159; x=1774285959; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M6+A23HBU2e9zD5HhDvJ+x1NGZghXMudqlydZMoWGqQ=;
        b=Y5+Q/2+FV3la/oiis8ka2BY3pusBJVeN9nVWet4aIEYXZ3W89K1YIIPMu/eyfdxQs0
         O8HDa9fmxuqJvFuKVW5OB0pNrPsWhVzzf5KSCI/2zGDwAhmGg1/T15ouHOuIEp7DsaVd
         F/w68JYrDoMp+tIvCzPLPF2JN2raQmGKM3sElOo2cQitNGZwEqs7Ib3sweyNuWw6oHG9
         08He+Ph+RA9p0VBgjM5m4c+QWUs5wWP1jEwR1lkqwDxBfnBL0LVAaK2XdZL4V+Q0Syub
         qQGtDwfxE8FkZLxVhNQ0pdhOR52iaipz/PJxSqpRaOelye5KGYAHD+UjdhfG9dwob3kN
         TJ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773681159; x=1774285959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M6+A23HBU2e9zD5HhDvJ+x1NGZghXMudqlydZMoWGqQ=;
        b=Q6dIF3wKDK/RpwbDsSf505y843E6dbxExNKll1GMp2P1IKoQUyEzuvoINSdVY8Ae6x
         pVZw05xEtCMGYx0ckdivgByd8maN/jmgVEYS5yK1zCIpXhUxByClcUflbhXa3sB88MPn
         QYoFtbPg+nlJuVPd2mrZxhcfJ14Zk5sm01IUA2vSNXPhE78XYZjOEsQzfowQEDg7WXmI
         evQ5fxbZdnWLUmbFj+gInV/0euvs/d1bsyJz6rfYJcqX+hPi+MeN0C0Q7WzZiaHomfAp
         tRQi0R55JrSZkC/9MNBUiCyDCPFPvCG47DKtdESWu7VCUwEwJ9PpkzG/x8RDGBoEn+4O
         nfhw==
X-Forwarded-Encrypted: i=1; AJvYcCUxVpWdF5jUiPQ4zSD9Q444gtSR8Y3wp9WoUuMljUsRIq1VJrdD/S5NhW8urgubAlGUI7NX0Vy/2w==@kvack.org
X-Gm-Message-State: AOJu0Yz+s0S1FgOdEdNBjbRk7SSLJEXL2ju5gfkC1Id8iXhoyeRb8eaa
	K94oVcZI809t6AOYrB6yG3vGRVBwg5YNwswP1tMQ3j/wkrPFlET6Nyr3oj4J9tSg
X-Gm-Gg: ATEYQzxU3/BbvucT4suNXltqH5ctLypDsC/1Q9S4gxzeK3hzMqe0srBCEHcB9H0uBsL
	j/2wcV1SC3qaD9RNtI16/hwujZAAmBy6aZiY3oo1ktP4891UoaVgAr1HBO5P5UXErkbDRvbw5fa
	TYorfH9tEKAVyqCXlRcC/em8GJwvwUP60LHiVPpPLab+93gs+eadvfZrFgULq5RVDrqb9dVASrI
	c2PkAX5tcYCUjkUDSNQc8EcdyWAc1IOWjCdOyMpzKHIQJrzqzTI4gFxvVT5rp60hS3HKFeKWdQw
	5QnQS2p5+CiYeb9fluqGrapQkteFsKJbmPZ4+jhY0jo6lPeVVW3M6c2KwMsct3OMRGNi5mqvoRI
	Guiz4q3IB/3t3no2K13oNVYm4VlKrn4DbCrPqG2QL7kDJcQ2Xef7G9VKFhtUmCBm2
X-Received: by 2002:a05:6512:318c:b0:5a1:d06:573 with SMTP id 2adb3069b0e04-5a162b26175mr4681214e87.43.1773681158666;
        Mon, 16 Mar 2026 10:12:38 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a155f33c8bsm3785022e87.3.2026.03.16.10.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 10:12:38 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 16 Mar 2026 18:12:36 +0100
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v4 2/3] mm/vmalloc: free unused pages on vrealloc() shrink
Message-ID: <abg6BG0MT6sKy-FT@milan>
References: <20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in>
 <20260314-vmalloc-shrink-v4-2-c1e2e0bb5455@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314-vmalloc-shrink-v4-2-c1e2e0bb5455@zohomail.in>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB455180013
X-Stat-Signature: wrtaad6j4345e4qikt3jfpimdhxsr5cg
X-Rspam-User: 
X-HE-Tag: 1773681160-375078
X-HE-Meta: U2FsdGVkX19Kw/vYv8zeMvPWKjaWk1+iXcXdb4WhcKSnqUmqkjW/VRjE3nXPKWl8G7plIE9lJClrrAg5Ykh6651pZxeJ+DtDlm6PFsxoUeZtQ6N+yHjUp+q33nuINoC+eiReOcOwvKegQYMiytVulMWvazTJwFhl5ua6te/cNR3xWAELJOGS/fTSFjJ7y4Tscf4ZA5eDP09X6f3eR9/TKGlYwC+3uZRMb8T2RzmvHI+96Y+DRVJTF0djZExU6Vda5FWiqkDSjSVw3sdK84UiNJzydD1BG4PxzKmKcPRf84z+gVK5L0ngn+LAwd9/JFFdfCrGrcJ5hZkB6jPMBQJTrV3CXkL04qe1/Cyp4evp/12XCxaHVByiLxcLRXXxSmEnndiPZaAGLuB1mcGCe9lz1+O0yAIR+wWcdnlmh+WMW9dhZcbnmAfG4x9I8ZK/rZo69fWUb9CSV6EzxXqgk+Z+MGyHGV2K4TBCvZuboSu+FCj7KFt4e1IZt2ds0GkhkfNbdOIqAPwqtevon0uGTDWN8oPHCUroMf/lzJbETZxPld1eqK8nrN1kH57TGXlmQYtdMFP6SSD7CZ1c0nYwKiDozkW/erVKgooPF8ltDY0pUiP3kuq/q2Ek+7HvxqFZQBUezfRjJ3Ke0YYv/5HCIasCvVCgK4yGwckLjxnjjUvr86fLuWAbz4DwdOeMaQhTZoRFtfKRt26c15MsoKjm8HWyZjOluAoR5AGWsN4Yg38bDeIaWGqc76fgiE1htVMtjjXhcOcvG08tZW7IdW8EILGydZ8vjGjAxHNHumUpJgqd7g6EH2cKRxGJSfVzxUbOD0rp9qT9X6+mwgwhrOWvxLwLbsFMSNGAkrsDmiZPbkN79LKwaPJhoIOQXlJeKHaXZ2Q4S6MarUEDcT2ZdypCHMsZSIUoWWZ1/207NLcuFVTD8yW92Fq+C157TMDhUcM0kNAkb/QMZXhgxy5mNFk0xLq
 EguIcODV
 sOIMppP8YhcPjW76saCxyBGbj9kLwLucK2M9HZALzNLBX2KsD0ceLrCQecb4fcQquoEBJjCyx/rQD55Hn4yfX21E5TffADUNh7rowYnmhskeiB2WvihVzyuUK4ronfKtd0Z5gOnbwLIHxoFbnjN56p/5R0l6gDZY1yVWjr+KhQgaeKajedOo477bVl3HsjJ/dYDhLgLqLJpCVFSQJ7wOeyIosrlcT3Cn1yrp6oUOIbNB1U/KtIiafpmshBmuQaOaxxsLUptycRnqnh75YTFG1FelTJzmAYexkkXIzgy0ZPMfvYtzHLZJ1rKH4O8DIzGINRg6tYLA8PP9FE0D+Miy/k/yWzTAxQuMBC4bhgfBYHFUi53rYCnqSjieLBCMRVCpPpLF4bSHQiYuMU6E0m5tRkWGqqhMeJnEVfNkpa7bl7UutAFLoEWbP773fdpNN8ooX+8Ig+bKMsI6rVNNwt+ZB0zdKM+qejDSGuCmk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 14, 2026 at 02:34:14PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> When vrealloc() shrinks an allocation and the new size crosses a page
> boundary, unmap and free the tail pages that are no longer needed. This
> reclaims physical memory that was previously wasted for the lifetime
> of the allocation.
> 
> The heuristic is simple: always free when at least one full page becomes
> unused. Huge page allocations (page_order > 0) are skipped, as partial
> freeing would require splitting.
> 
> The virtual address reservation (vm->size / vmap_area) is intentionally
> kept unchanged, preserving the address for potential future grow-in-place
> support.
> 
> Fix the grow-in-place check to compare against vm->nr_pages rather than
> get_vm_area_size(), since the latter reflects the virtual reservation
> which does not shrink. Without this fix, a grow after shrink would
> access freed pages.
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index b29bf58c0e3f..2c455f2038f6 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4345,14 +4345,23 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  			goto need_realloc;
>  	}
>  
> -	/*
> -	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
> -	 * would be a good heuristic for when to shrink the vm_area?
> -	 */
>  	if (size <= old_size) {
> +		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> +
>  		/* Zero out "freed" memory, potentially for future realloc. */
>  		if (want_init_on_free() || want_init_on_alloc(flags))
>  			memset((void *)p + size, 0, old_size - size);
> +
> +		/* Free tail pages when shrink crosses a page boundary. */
> +		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm)) {
> +			unsigned long addr = (unsigned long)p;
> +
> +			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
> +				     addr + (vm->nr_pages << PAGE_SHIFT));
> +
> +			vm_area_free_pages(vm, new_nr_pages, vm->nr_pages);
> +			vm->nr_pages = new_nr_pages;
> +		}
>  		vm->requested_size = size;
>  		kasan_vrealloc(p, old_size, size);
>  		return (void *)p;
> @@ -4361,7 +4370,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  	/*
>  	 * We already have the bytes available in the allocation; use them.
>  	 */
> -	if (size <= alloced_size) {
> +	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
>  		/*
>  		 * No need to zero memory here, as unused memory will have
>  		 * already been zeroed at initial allocation time or during
> 
> -- 
> 2.43.0
> 
> 
Do we perform vm_reset_perms(vm) for tail pages? As i see you update the
vm->nr_pages when shrinking. Then on vfree() we have:

<snip>
/*
 * Flush the vm mapping and reset the direct map.
 */
static void vm_reset_perms(struct vm_struct *area)
{
	unsigned long start = ULONG_MAX, end = 0;
	unsigned int page_order = vm_area_page_order(area);
	int flush_dmap = 0;
	int i;

	/*
	 * Find the start and end range of the direct mappings to make sure that
	 * the vm_unmap_aliases() flush includes the direct map.
	 */
	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
...
<snip>

i.e. tail pages go back to the page allocator without resetting permission.

--
Uladzslau Rezki

