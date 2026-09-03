Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2469CC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0666B00BF; Thu,  3 Sep 2026 05:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3599C6B00C0; Thu,  3 Sep 2026 05:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B9C6B00C2; Thu,  3 Sep 2026 05:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E47576B00BF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:22:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B1A7120481
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:22:59 +0000 (UTC)
X-FDA: 85171911678.16.30D7CA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id AD6E6180003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:22:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CsLTmwDY;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVH46s0TiBnSL1nhlyLYQT7Nebe0o5BJiT5/S7ZnuZY=;
	b=n88uxU3YoQsv2llVY1/izx9spHIXhcDEbjCjEoetgEPLs32EiVCZObVrMn7D8RbkJc3Yok
	TfK9/RV5pBUrT9pbCFcSjjop6MET/e3+N4hPiyKmkpW6zfkaNs3WKmEBLjZQyIGSkfTpdm
	fVHMlInwp87S5gIt1V5sJyZ5bydqlzs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427377;
	b=Zsw6a05t0qx9OLhZHolvE4AC5CtxgqIeaiCOXBL9/EvzQX2SLsBFqCwHovdQiefUqChSWI
	J+MaF2m56EfiIiR0gIpByJsX9H+TyzN86tO4i/jyHFmW4T+GUAH1sjQEbtYmn524DwCqiD
	3Hz+2Vg0qgUCBWTUQA41ZBA0gtNeAWk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CsLTmwDY;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE3EB42B20;
	Thu,  3 Sep 2026 09:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969871F000E9;
	Thu,  3 Sep 2026 09:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788427376;
	bh=CVH46s0TiBnSL1nhlyLYQT7Nebe0o5BJiT5/S7ZnuZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CsLTmwDYUQuPdEGJ2URh4YYrVQjku/PYtQd8szB9HFBHKuxNiHG8jlkrL7gi1baJv
	 baOlP721yc+Gapvn+co/bsCE+vzOe7wj38uGpYqZPkxomRAwIz0bQTUhRLhTAuqqra
	 dcAYfgKFIupV+om73sgPaweqXIGMwkg5fWtKJMpvY7FG1n04OkQOJYThS8OWkrXRF/
	 6d+zCI/PEFFnvI3TBktpF/UQ7XAfs6aQrSu5o0XLNpvLlz/KIh0d4q4F8mng6kmC35
	 gHgYzeK4HV1Zw3Tpumbe8aupeoEBK6jboDtDlQeHq19XetZJxR/N2esfUJW+ShNiZf
	 qTij8AvQ7COkA==
Date: Thu, 3 Sep 2026 12:22:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	usama.arif@linux.dev, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	kas@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
Message-ID: <apk8ZRr6do_YAlzf@kernel.org>
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD6E6180003
X-Stat-Signature: ysixot88awssd53rgs4upduiays5qp3j
X-HE-Tag: 1788427377-511503
X-HE-Meta: U2FsdGVkX1+Ld+2BD+AOTXfvcg/3QbiQ+jbyw0mazu81CjTg6taygGhEaiDkHoRA+HbuIfrXIRIAivMUGRwFpOdKD1D2YY3dO3trDywYXIC8N06idcsutwjHBlVb5P+BnO5RX1s+TUMc8JtmaxEIwKWIcH+6LAprFkZjLokdpLD2jVHiI8hD6xONuSqRN4TSEe1xnV3MtfRzP9LHWGgN5Hi5cnCtk2vSWYY8/+sQl2oi7Ru5xGT9ZAm0Qo2fcPJ3wsGnp1b+JTz6TtZl7S/7AmXSvgW3wYJ9sOhL1ig41VJTZrkEnlziCvnhUSadokiCSw+KYLsYw/VIig9O91QJUuHaL8a/9TQMXChZFO2k4IFf51+WZS8rhEnEab5Lqz2SkeiY3ecuO/Km3uwuJeLP7LG9JXg8jTiDEuhR3uySEjbc//xghTq1SXkZQ8Ez7CVKiXige4Dg/jIiqwQES31vYoPVX/5f+yzTaGSvvY1Vc5kch0/57BB1HexQ9x4s5NSJAvrXLPuT/YtWO0eH4iXEzz4svwtzOeTsDFXSanoPLErJnu4Pz8WXYRc3CEGb1Ut7D/r0Iake4V7ycvPLmIiFo36n32/FQEg+FJUPRyst3SK6jG5xPo4VCwSkA+oHkb6Z9XNMgnlhh0vUmPvfQSIopepRjZIo1QG88AuhGBjVKx5CrNNp1aBSNPbVASdcc3IqC0TfFOXGciaDzBnesH1CfpK4snhm+Gw3RJ6fCrLvW5RVEGW3P84lvZ0hzleZddjqh3SfGC6A14xnPxJxMzRoXsjZNs2VajWNNW+2LQzwwkIM8TRrIaUZF8pmTRTWm1NKjz8HCjs+a+6e2lwDYNENWncd9NlUPFTA68zQXZpxfJ7+VADNE5/xgIWGCGXA4iZhYajx+LQ3SSr4eq8wyrWjpkNdPlwSaO9pqpAGP682c/XxPUKcwYomDRj9kK6Flkerllr0Vy6tKFSRFDRDpbi
 /WJM43iy
 sayDaqbjewz0X1qXGFwl7c3gMRikUf+a8VyuAbjt1s9ydgxQub6L+9GHBqJDJ9AbKtdo4XWEUoL/Ar4nfMOnPwCr1MVmR4LZDx+LZksv95Dk5N5NpPxMVDjd3/KxKjSuZMOVfdJSbfABW41QtlCMYxH97SdDmFwx68f5zVtShESzkPOQyMT2knEW1l78gaGh2nZIZDE0C8SD6DhaQlrvECsAze9okx9YkgiJeJRioTqtnKhF1TPlQND+0CoIlo3009NsTqF+Ri+K8/e9dJuDpyWkkuxueoLriZrgY1kMMVc3g6jJLjMm+6/tU21HS52Tg09ifJvw5WcYD/OLwZE/wEMhWNONQiNiPpJiHb+Qsxp5rK6kqLVfZazR3UShL3G/DOO36l4xUirP+hD9F8Ez0++I6nA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 11:18:16PM +0800, Xueyuan Chen wrote:
> The persistent huge zero folio is shared globally and should stay zero
> after initialization. As Jann Horn pointed out [1], kernel bugs have
> ended up writing to pages that were meant to be read-only, including in
> security-sensitive cases. Making the folio read-only in the direct map
> turns such writes into faults instead of silent zero-page corruption.
> 
> Add a page-based helper consistent with the existing direct-map interfaces.
> Handle TLB invalidation in the architecture implementation; unsupported
> architectures retain their current behavior.
> 
> Protect the folio after initialization. Skip highmem folios, which have no
> permanent direct-map mapping.
> 
> Inspired by Jann Horn's read-only zero page work [1] and follow-up
> discussion [3] with Yang Shi.
> 
> Link: https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b49@google.com [1]
> Link: https://lore.kernel.org/r/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org [2]
> Link: https://lore.kernel.org/r/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com [3]
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Co-developed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  include/linux/set_memory.h | 17 +++++++++++++++++
>  mm/huge_memory.c           | 13 ++++++++++---
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3fe293cfed8c..ed9ce04b18a1 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -54,6 +54,23 @@ static inline bool can_set_direct_map(void)
>  #endif
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>  
> +#ifndef set_direct_map_ro
> +/**
> + * set_direct_map_ro - make a direct-map range read-only
> + * @page: first page in the direct-map range
> + * @nr: number of pages in the range
> + *
> + * Make the direct-map range starting at @page read-only and invalidate stale
> + * writable translations before returning.
> + *
> + * Return: 0 on success, or a negative error code on failure.
> + */
> +static inline int set_direct_map_ro(struct page *page, unsigned int nr)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #ifdef CONFIG_X86_64
>  int set_mce_nospec(unsigned long pfn);
>  int clear_mce_nospec(unsigned long pfn);
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 54494c3fa983..742283b36d74 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -42,6 +42,7 @@
>  #include <linux/pgalloc_tag.h>
>  #include <linux/pagewalk.h>
>  #include <linux/cleanup.h>
> +#include <linux/set_memory.h>
>  
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -291,10 +292,16 @@ static int __init huge_zero_init(void)
>  	huge_zero_folio = alloc_huge_zero_folio();
>  	if (!huge_zero_folio) {
>  		pr_warn("Allocating persistent huge zero folio failed\n");
> -	} else {
> -		huge_zero_pfn = folio_pfn(huge_zero_folio);
> -		count_vm_event(THP_ZERO_PAGE_ALLOC);
> +		return 0;
>  	}
> +
> +	huge_zero_pfn = folio_pfn(huge_zero_folio);
> +	count_vm_event(THP_ZERO_PAGE_ALLOC);
> +
> +	/* Highmem folios have no permanent direct-map mapping to protect. */
> +	if (!folio_test_highmem(huge_zero_folio))
> +		set_direct_map_ro(folio_page(huge_zero_folio, 0), HPAGE_PMD_NR);

Sorry, I don't remember if it was discussed previously, but why can't we
use the existing set_memory_ro() here?

> +
>  	return 0;
>  }
>  
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

