Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066F0C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 02:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD566B007B; Wed,  5 Aug 2026 22:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE6B6B008A; Wed,  5 Aug 2026 22:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179E86B0092; Wed,  5 Aug 2026 22:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 910086B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 22:29:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9339C40623
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:29:50 +0000 (UTC)
X-FDA: 85069264140.01.28F1ACF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED9D8180007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:29:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fTKut1P7;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785983388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jY7+oBUrKHkFO4iBtP2E++Vts1iHCUswnJVsbsvky4=;
	b=QhByZlYz3wIJBCddUaXDtK26CSCWhEqrykDcWEvnVsiViZA2eW8owgmohHwAHoqsAYG6fO
	XlSYQRla51n+eK474rNAYSa9KS8risTS2TNPNIw18/irZu5oo+KNz4uzFOCtE+9ITnYx3E
	Wn/FQrG8+adsj8oDuURDO+fkt6f1zxw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fTKut1P7;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785983388;
	b=r+PSsskJhxzdYSUjNpdrw/E40QQGm+1CPlaKBBCYO72HJYlD5WS4+F5kL5YmpErc8KdwvE
	dL9D90+8uB08QA96qdcLYm3eIHMnkN3zrVmAPZYfwhzv47Ot7vWl134dz4k+QaALmFR74H
	RMT/GN9aishA+9avQolZYWTsEKaM8IM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785983387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9jY7+oBUrKHkFO4iBtP2E++Vts1iHCUswnJVsbsvky4=;
	b=fTKut1P7QK6DCrS7ZG6DNc+7y4OCLy+sx07nJslDevYXnwI7Xne5WVx8fD0IfvJ19hsNRd
	QpYUyXprzVkTS6lLQMQ8qlBxhRokdNh3pdnIFL9eaakJ9MVtR4+3QoK6/k1avgMutNsm0G
	9xiUyAdVxCYrhQDJJ6EHpWF4trYH3hI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-dv40AkUEOQ-16mcOvB2DIg-1; Wed, 05 Aug 2026 22:29:45 -0400
X-MC-Unique: dv40AkUEOQ-16mcOvB2DIg-1
X-Mimecast-MFC-AGG-ID: dv40AkUEOQ-16mcOvB2DIg_1785983385
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51bec738909so15172041cf.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 19:29:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785983385; x=1786588185;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9jY7+oBUrKHkFO4iBtP2E++Vts1iHCUswnJVsbsvky4=;
        b=rWMHBoUenQ3SmuPPflxyGro5wvBI8xzpqM7A7PD/5OUg5J83dTOr0AzFT9/cxzcX89
         nwZ7pA3BldgpbcutPx6jfhg+CjQdDfeXwJfVj8wHuW4D5fGpEP/cAqhR2ILGlMvnXYI5
         q3i3eb5xhpyGVsQOeocQj+1h2rpk2qYdH3DtmY3E3avhxZ5wbPDyi4sJsRvZNhRwI0FX
         kMYQT/giR9eseoaDrfdOTPGvAKKv8w1oZMCUaeUKqdzTzROdTc4vPgAyBk1EQ48BEQOV
         ni/PQs2IFSZ1Xf224MpI7WJexg2n6+yXvVhwShIrlnr0vMiHwI0RrdOotp448pyTc5LI
         kCtg==
X-Forwarded-Encrypted: i=1; AHgh+RrbZV+W6dPZr72QqIOjmMES8wNO4755Z4R08n51wvjSTe0dH0viUfibvBrLa0coXVnQJk2D9On0lQ==@kvack.org
X-Gm-Message-State: AOJu0YyDf4DuTMNfKrx/+s2ywZZXQwjDyjb09ecw4/CKWz+WagZ7BYY8
	L+FGVXhd8AiMyrJ+wA6iD1eWqW9LJbptp5dbob4jAZSebyl9vw+Xo8mxj9Xku1yXp1lC42bbJ9g
	gKDPOdBKuJij0UYcxgJpiHYSXnaRoIQCRHaNFk4d9NchlCWhKZFvE
X-Gm-Gg: AR+sD11we7ssI1ey7jkA92xnIYT6NBrHvpzX0nqwL8Uejiva0LgBY4nDWmMJoz1dWON
	BRl3c43VBgPLWbnxqE/7vyJlNg3jbWEwQX+GLVmOKrp7wMfY0Hn9y5e+FAoMlwv1gXktsqwXdFL
	Qdt+ZxHbB6o83JmvN3DWUhYq4cvcobYf0EdnQgxUkmAzRrPzRJCymRo8Hv7ax5SXeSQYFEb59Rw
	POWtQbS3AR+sYsYXhP6RNRG1p7PKHQfWoQHlzAP18XM8WUD4UADnVcWbuEwNd4A2ysPdSxpQ6RF
	Sb2R4ozZZ2g5jQA1fFPc9QQ0nwmSVLy4DajYs+im4ldJfkmd6ucM8jnNGqU4joA60wrohiF6xd5
	JiVnMQJYge5w4EN1psZbJ8zRCJpiQcalotxbCH2nGfXRdgJ5A5lm/57zAnI4DxQ==
X-Received: by 2002:a05:622a:4ccf:b0:50d:e471:2d1e with SMTP id d75a77b69052e-52ce61b4ef7mr119776701cf.35.1785983384813;
        Wed, 05 Aug 2026 19:29:44 -0700 (PDT)
X-Received: by 2002:a05:622a:4ccf:b0:50d:e471:2d1e with SMTP id d75a77b69052e-52ce61b4ef7mr119776491cf.35.1785983384251;
        Wed, 05 Aug 2026 19:29:44 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-61-70-49-81-60.dsl.bell.ca. [70.49.81.60])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52ce892a067sm31848491cf.17.2026.08.05.19.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 19:29:43 -0700 (PDT)
Message-ID: <3374e351-f6ad-44b2-9ee1-dd3b9c33fbc3@redhat.com>
Date: Wed, 5 Aug 2026 22:29:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/11] mm: install PMD swap entries on swap-out
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-11-usama.arif@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260722152043.2273289-11-usama.arif@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Cg9ZTcg1fwhfEqPjwW-Y46ufFF_RS8nBoB9tkvrnCQo_1785983385
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED9D8180007
X-Stat-Signature: 4i5wicbkebdxspdco39yss6eahqorh4c
X-HE-Tag: 1785983387-572400
X-HE-Meta: U2FsdGVkX1/N5+ZUDJccUID2hd7Y4U7LwDBpDNQLY+A/wEr68UdwXHdqsIgLqZMIh8at4TutueFhvD4/m5sN/5Y5P59yF8rEg/VoqvTYEtrevZUHWMg1o8yhhYwo9fPAftg2vFi0bD5jJCHEyKCvq8x8Vo2svOEsYIjJVKouXjckltlW4/b39fCz3RKnPuDSa7lc4zGPWYUkC91HuWAjUbh21+Wab9/H6Wu/p8salFFqMhaWwy2K/IpF+lv2EtvSPOGd3qzu3ap8Mg6EHhxPdFj5TI6emE07VMB00TzNIfynXLWj6AFsCYQOsBxqKCMtwWRpy7Z0xIHZ+vzMnFe2lEvql4dzsGvQNXXebZPFvEBNOWRG6Ml3necgsDStz4I4FWit+t9zNQ/P3qpyMr6Pyju5US/xxmd/6MDNiJMYMxLz3fa/K9qz64sGBgPSY/BC5ynhBIQxm9mBclV0iYqu4+GRfZ1VNWD+q+XNUgwSma4OyOQJd6ZoUiN5b3bD964oI2amHzW0KxqIrtgEYWVzNwG7bdajCGe/wiWIHWLtmuea0iT8mrL9QCXDbzC1SCqqstK5dZSkg0P/NgKXw4TVDMDFF/07zvPwEPZr6eSIMp9lMo7pHl2+Dt2g63MCf1Am8dAGEdIHN3SCrFVVAUaVXw7d4Qakh2t9dSJOj2km66Bl98tovmhoS45wQMPzj8cftHnXL4LWrr0OUBRWCBCuDWBrh3AOVy1n06m+2F0hY43C+uWgkZmkBQgbmznRnjg8au3h+xb0Pk5s6IrRJ04O9RRnrl+CKk/ca0PQgaonDA46MeSdApAQDWilRiozaeOKNsNKevKcSTEQD88AjAOMZprl5UBSPhg0Mt2a1NZuMBhChMfGJtWBzqkZushx2MErf/pj8mt8vvxyMWKuxUgJJrT7IPNNqR4dLb0fXHXZQkag0zf5EXK5LuLxpA36BGVlWTKj+4MeCdLRDr6eziP
 pWh8XYDF
 J0XP7KMz13vCYkN/YJSEu7JS9krwPckbvQsMIbEOGiFvHiei6l2NwH/ylDuciDkRFAKfLoPwJRyGvv8a9frhaqD9zMDz061yDHZFJ3NQOym/s3/U9IVMrxSpSER5ciCyk6Be9E3G9OtTv7DObf4hFXuWsiAYqEwODsInlJeLWQhGdR/O4y4axRpBq6ggP8HnGHN+zv/My2Nbyrc87WaonpM5PDS9Y606Xpe+wNmRC1pzcbHBtBErys/R6fE5ZbnsUAx68SywGBRHR07lyiEF8lqjl3ZVx7LV+RaqToFqCTncB0eMKBtm8CTG02Q7gleuRFFeBJKWe9C6wNZ41lqESN2pI8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-22 11:19, Usama Arif wrote:
> Reclaim today splits a PMD-mapped anonymous THP into 512 PTE swap
> entries before unmap, losing the huge mapping across the swap
> round-trip and forcing khugepaged to rebuild it later. The contiguous
> swap range was already secured when the folio was added to the swap
> cache (a non-contiguous allocation would have split the folio earlier),
> so the PMD can be replaced by a single PMD-level swap entry instead.
> 
> This patch mirrors the existing PTE swap-out path at PMD granularity:
> - shrink_folio_list() drops TTU_SPLIT_HUGE_PMD for PMD-mappable
>    swapcache folios. zswap is handled by the PMD swap-in users: if any
>    covered slot currently has a zswap entry, they split the PMD swap
>    entry and fall back to the per-PTE path.
> - try_to_unmap_one() now has a PMD branch that calls
>    set_pmd_swap_entry() and adjusts MM_ANONPAGES / MM_SWAPENTS by
>    HPAGE_PMD_NR before walk_done. TTU_SPLIT_HUGE_PMD remains the
>    fallback.
> - set_pmd_swap_entry() is the installer. Mirroring the PTE swap-out
>    sequence at PMD granularity, it clears the present mapping (keeping
>    the original for rollback), bumps the swap_map refcount for the
>    folio's 512 slots, transfers the exclusive state in the swap entry,
>    propagates the dirty bit to the folio so writeback is not lost,
>    and installs a swap PMD that preserves the original
>    soft-dirty / uffd-wp / exclusive bits. Any failing step rolls back
>    the present mapping.
> 
> The swap entry value matches what 512 PTE swap entries would encode, so
> swap_map refcounting is unchanged: each of the 512 slots carries a
> count of 1, released individually on later split or together on swap-in.
> 
> Add thp_swpout_pmd to count each PMD mapping replaced by a PMD-level
> swap entry. Unlike the folio-level thp_swpout counter, a fork-shared THP
> can increment this counter once for each mapping; document that
> distinction.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>   Documentation/admin-guide/mm/transhuge.rst |  5 ++
>   include/linux/huge_mm.h                    |  2 +
>   include/linux/vm_event_item.h              |  1 +
>   mm/huge_memory.c                           | 80 ++++++++++++++++++++++
>   mm/rmap.c                                  | 19 +++++
>   mm/vmscan.c                                |  9 ++-
>   mm/vmstat.c                                |  1 +
>   7 files changed, 116 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 16f37135ed80..b421d7982db6 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -630,6 +630,11 @@ thp_swpout
>   	is incremented every time a huge page is swapout in one
>   	piece without splitting.
>   
> +thp_swpout_pmd
> +	is incremented every time a PMD mapping is replaced by a PMD-level
> +	swap entry. A fork-shared THP can increment this counter once for each
> +	PMD mapping that is swapped out.
> +
>   thp_swpout_fallback
>   	is incremented if a huge page has to be split before swapout.
>   	Usually because failed to allocate some continuous swap space
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index e7107e0991ad..41cf643a3f55 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -554,6 +554,8 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
>   
>   #ifdef CONFIG_THP_SWAP
>   vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf);
> +int set_pmd_swap_entry(struct page_vma_mapped_walk *pvmw,
> +		       struct folio *folio);
>   #else
>   static inline vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
>   {
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 2628ccda076a..f8fd4e13698c 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -108,6 +108,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>   		THP_ZERO_PAGE_ALLOC_FAILED,
>   		THP_SWPOUT,
>   		THP_SWPOUT_FALLBACK,
> +		THP_SWPOUT_PMD,
>   #endif
>   #ifdef CONFIG_BALLOON
>   		BALLOON_INFLATE,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6ef56936ced4..c014631e5a26 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -5561,3 +5561,83 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>   	trace_remove_migration_pmd(address, pmd_val(pmde));
>   }
>   #endif
> +
> +#ifdef CONFIG_THP_SWAP
> +/**
> + * set_pmd_swap_entry() - Replace a PMD mapping with a PMD-level swap entry.
> + * @pvmw: Page vma mapped walk context, must have pvmw->pmd set and
> + *        pvmw->pte NULL (i.e. PMD-mapped).
> + * @folio: The folio being swapped out. Must be in the swap cache.
> + *
> + * This installs a PMD-level swap entry in place of a present PMD mapping,
> + * avoiding the need to split the PMD into PTE-level swap entries.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int set_pmd_swap_entry(struct page_vma_mapped_walk *pvmw,
> +		       struct folio *folio)
> +{
> +	struct vm_area_struct *vma = pvmw->vma;
> +	struct mm_struct *mm = vma->vm_mm;
> +	unsigned long address = pvmw->address;
> +	unsigned long haddr = address & HPAGE_PMD_MASK;
> +	struct page *page = folio_page(folio, 0);
> +	bool anon_exclusive;
> +	pmd_t pmdval;
> +	swp_entry_t entry;
> +	pmd_t pmdswp;
> +
> +	if (!(pvmw->pmd && !pvmw->pte))
> +		return 0;

Should we call VM_WARN_ON_ONCE() and return an error instead? This
function is only called by try_to_unmap_one() under this condition. In
addition, returning zero would cause try_to_unmap_one() to assume that
the PMD swap entry was installed, which is not the case.

> +
> +	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> +	VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> +
> +	if (unlikely(folio_test_swapbacked(folio) !=
> +			folio_test_swapcache(folio))) {
> +		WARN_ON_ONCE(1);
> +		return -EBUSY;
> +	}
> +
> +	flush_cache_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
> +
> +	pmdval = pmdp_invalidate(vma, haddr, pvmw->pmd);
> +
> +	/* Update high watermark before we lower rss */
> +	update_hiwater_rss(mm);
> +
> +	if (folio_dup_swap(folio, NULL) < 0) {
> +		set_pmd_at(mm, haddr, pvmw->pmd, pmdval);
> +		return -ENOMEM;
> +	}
> +
> +	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
> +	anon_exclusive = PageAnonExclusive(page);
> +	if (anon_exclusive && folio_try_share_anon_rmap_pmd(folio, page)) {
> +		folio_put_swap(folio, NULL);
> +		set_pmd_at(mm, haddr, pvmw->pmd, pmdval);
> +		return -EBUSY;
> +	}
> +
> +	mm_prepare_for_swap_entries(mm);
> +
> +	if (pmd_dirty(pmdval))
> +		folio_mark_dirty(folio);
> +
> +	entry = folio->swap;
> +	pmdswp = softleaf_to_pmd(entry);
> +	if (pmd_soft_dirty(pmdval))
> +		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
> +	if (pmd_uffd(pmdval))
> +		pmdswp = pmd_swp_mkuffd(pmdswp);
> +	if (anon_exclusive)
> +		pmdswp = pmd_swp_mkexclusive(pmdswp);
> +	set_pmd_at(mm, haddr, pvmw->pmd, pmdswp);
> +
> +	folio_remove_rmap_pmd(folio, page, vma);
> +	folio_put(folio);
> +
> +	count_vm_event(THP_SWPOUT_PMD);
> +	return 0;
> +}
> +#endif /* CONFIG_THP_SWAP */
> diff --git a/mm/rmap.c b/mm/rmap.c
> index b7ead3e9f064..4574f7b969b6 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2282,6 +2282,25 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>   				goto walk_abort;
>   			}
>   
> +#ifdef CONFIG_THP_SWAP
> +			/*
> +			 * If the folio is in the swap cache and we're not
> +			 * asked to split, install a PMD-level swap entry.
> +			 */
> +			if (!(flags & TTU_SPLIT_HUGE_PMD) &&
> +			    folio_test_anon(folio) &&
> +			    folio_test_swapcache(folio)) {
> +				if (set_pmd_swap_entry(&pvmw, folio))
> +					goto walk_abort;
> +
> +				add_mm_counter(mm, MM_ANONPAGES,
> +					       -HPAGE_PMD_NR);
> +				add_mm_counter(mm, MM_SWAPENTS,
> +					       HPAGE_PMD_NR);
> +				goto walk_done;
> +			}
> +#endif
> +
>   			if (flags & TTU_SPLIT_HUGE_PMD) {
>   				/*
>   				 * We temporarily have to drop the PTL and
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9b8ee902f972..83bb34403e42 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1333,7 +1333,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   			enum ttu_flags flags = TTU_BATCH_FLUSH;
>   			bool was_swapbacked = folio_test_swapbacked(folio);
>   
> -			if (folio_test_pmd_mappable(folio))
> +			/*
> +			 * With THP_SWAP, PMD-mappable folios already in the
> +			 * swap cache can be unmapped with a PMD-level swap
> +			 * entry, avoiding the cost of splitting the PMD.
> +			 */
> +			if (folio_test_pmd_mappable(folio) &&
> +			    !(IS_ENABLED(CONFIG_THP_SWAP) &&
> +			      folio_test_swapcache(folio)))
>   				flags |= TTU_SPLIT_HUGE_PMD;
>   			/*
>   			 * Without TTU_SYNC, try_to_unmap will only begin to
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 4e26e5fd6666..68e6efc0dabd 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1422,6 +1422,7 @@ const char * const vmstat_text[] = {
>   	[I(THP_ZERO_PAGE_ALLOC_FAILED)]		= "thp_zero_page_alloc_failed",
>   	[I(THP_SWPOUT)]				= "thp_swpout",
>   	[I(THP_SWPOUT_FALLBACK)]		= "thp_swpout_fallback",
> +	[I(THP_SWPOUT_PMD)]			= "thp_swpout_pmd",
>   #endif
>   #ifdef CONFIG_BALLOON
>   	[I(BALLOON_INFLATE)]			= "balloon_inflate",


