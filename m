Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54780C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 16:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA7C6B008C; Tue, 22 Jul 2025 12:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9ADE6B0092; Tue, 22 Jul 2025 12:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B630C6B0093; Tue, 22 Jul 2025 12:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A1C2F6B008C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:17:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E81C58FD9
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:17:10 +0000 (UTC)
X-FDA: 83692405020.15.658CC81
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id D1CAFC000E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:17:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="FJ/hdL/5";
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753201028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgrmDxPukJEiLJxm8blqAG1LGqhXeXnp1DkbV6uZnXo=;
	b=1luhoW5jpfeUR9B6uQdQ2IXCbjD5eSAC+ZznbI7Kxq86u37i4CO77X9Aze3C0X/am8uDCt
	Dh9qWL7/3U/I/8xPAdQOW8+5M/Z/zTB4vtEZw6gXknTN2klJtxin2hx8sGSquMEm4iSIxY
	N3CyodYV+W5nCqXtWdaO+Fg40wsn8GQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753201028; a=rsa-sha256;
	cv=none;
	b=tgV17y3UPFqlLSYMaBot61UnNxmToV2lGugJgIj6nSv/F2auebb1DmtyTUuTh6lc0eL1nW
	4zKksey2LdqyjS6rTsZYWVUDljdvmZ2huhK9wCKOkawCR//cPVWMoQ0F5+GcUMNgVb3kj1
	nGaNeGlkNxHfKDNOCHcseLsbkBJ/VgM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="FJ/hdL/5";
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753201027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zgrmDxPukJEiLJxm8blqAG1LGqhXeXnp1DkbV6uZnXo=;
	b=FJ/hdL/5T0FHeJ3Ip5JkWLoABHtsDiFXHYLNNzg70bsU8soj6pQ1QQcw859Hh3Gjm8z3YO
	a7l7gJ7JX27eZu9QwR8YL6zusPi9dSYPSxXYw4K3D85UA7oG5MvwjD9ww4geoxdDOZKS+Z
	FHVhthL3h1G1VeeXeRwDAX6rLQV/jU8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-UE2v-0QSMzyLttABZl-wPA-1; Tue, 22 Jul 2025 12:17:05 -0400
X-MC-Unique: UE2v-0QSMzyLttABZl-wPA-1
X-Mimecast-MFC-AGG-ID: UE2v-0QSMzyLttABZl-wPA_1753201025
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a50816cc58so2074077f8f.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753201025; x=1753805825;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zgrmDxPukJEiLJxm8blqAG1LGqhXeXnp1DkbV6uZnXo=;
        b=dR2PjS87C96yj7wtYveDlTmN/CMg3KnGL60RWgy3qQh/ZGqClknWBV6yHe2kFVRmXu
         c/DXvLzr0NlJTQlrgN/iO7aZeZxob0ciFY36RIRhQWOlMm0N7rFaoEYxeZXNPuGmUclx
         dz8+FyJ4KVMM+QnWenL/SVSJWne0poP8csDBZ5HlWlA7To7QGYWIf7WxKOzV1s+mLM5+
         Z7jfzT3zdpZZ0P/Y8JdRcXVVU3pqaZNyqrrsgOyxyHW4Hx0vCW6GfYi1HYmfD9suRuxy
         SvA8JX5rPl/Lyk5+ElrPT1OX5tqCknZyTf/VBfoQQLaG9ltOQI4ghb2ZZRISxslCYmM2
         cFSA==
X-Forwarded-Encrypted: i=1; AJvYcCUU5zzT1v3o+RlS8/AesNlmDku4CWPy7HG9NZNngX6n1e2/Pt+6ivUx9QlmYXvA2aybAIbisvAFtw==@kvack.org
X-Gm-Message-State: AOJu0YzOseoBrG8TeJNHx17OTznXOTmBJlFr1Jq1SvHvjffyIJy96NBM
	msPZCnrf8ErcbmiJgejkPL0HHh5w4CGibGa2veQ8+9v6RSdFG84bQ1avx8fHj+eGJ1b2O5CMqNJ
	uUZ9RU0LpJxjT4VlRU2Z7NQg+4n7vuC2abnVgTK4e0YA1mxZWEO+x
X-Gm-Gg: ASbGncudzZv4M5sFm79PWzL8h+0grYpk7L37qyax3xhG2x4q/GbA0SvSObg3/HL3S1i
	MlBb8CZfHROdX4LlWEmBv0BaRBrSszP4vzWPLE9N535CHEPZa+M7ugI+LwLuNlBUBPOOZAAgLzF
	3j6pbWVjaoqbfmPeAcGe0z2JqgJkBwkEM+Y/dhwaCz7fJCgyIpmtI84K1RYX+/Zsc9esc553D/3
	6/Tj/DhaYmuwbc7NK1vEBmjbJRVxayzN+1w8eBqOBXhDHzW8YNv9wE1TZiblK92kjbQ6IJdXVtV
	CfAlmsKFVGR+HuoZNmIWFziUGF8bXKtzFMSKjAJsbWx6nZc3AG6E01VvJ7TXKXn/nKWmG6Q=
X-Received: by 2002:a05:600c:4f46:b0:456:1d4e:c161 with SMTP id 5b1f17b1804b1-456352d0b48mr212646555e9.2.1753201024559;
        Tue, 22 Jul 2025 09:17:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBlPu188TQS5+VNgBWuYZr82JHaWKwW9P5rBiofD6Df6J5XVyjTwzc+rPD8gpRnyI4ohUcDQ==
X-Received: by 2002:a05:600c:4f46:b0:456:1d4e:c161 with SMTP id 5b1f17b1804b1-456352d0b48mr212646265e9.2.1753201023959;
        Tue, 22 Jul 2025 09:17:03 -0700 (PDT)
Received: from [192.168.3.141] (p4fe0f597.dip0.t-ipconnect.de. [79.224.245.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45862cf0fcbsm23088775e9.0.2025.07.22.09.17.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 09:17:02 -0700 (PDT)
Message-ID: <c9a34cf3-96a5-4a92-8e4c-34d67b1d3fe8@redhat.com>
Date: Tue, 22 Jul 2025 18:17:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] khugepaged: Optimize collapse_pte_mapped_thp() by
 PTE batching
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250722150559.96465-1-dev.jain@arm.com>
 <20250722150559.96465-4-dev.jain@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250722150559.96465-4-dev.jain@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _1s9QYunByfu8xeCn6VPZqyqjxqpApgJ_hiua7aJxwM_1753201025
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D1CAFC000E
X-Stat-Signature: syg89zfrztq5qckgbsnmqmok69ubrsiw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753201027-281730
X-HE-Meta: U2FsdGVkX1/jXLbpK7xMIbZy/rG8AhWLcUEhar9tgM09ZLqABXexuz9D++TVOe0lNvWMpXKzrF4enXWmBadfAjteqEsw86RxS6IQLavneCENodeX0CGzB5EXlV0RfTAlvmnHSw1iQz/i845pH3A5TQ9y8USDikyBhEZDLYWX/QBL44k9Mzoa6Lw3EdNK87qxBcupzjKh4lJEYbzqet3GnTG/7z6OALIZ57N84uXopr3VNx6uVmPHfWKQH/P1AsvemvSepv5u32jM69xbEXSfCecodfFYA15PBLobfS9/yIYVhk4ynpNZRp6Ir5ypaGfHm4qJtL6i+5W5QCzGgxbOWmlESe2LccZjwf3eqFO3R5YDDssGhAolOpnDGZEdOZWW+hybpaDRFbY7jU1yKP4nXPbmw4SXnPm/9rBzDelWXKu7x1x+tPyg/GC776OvmlfYdVYsQFs3RKAgTeuLvel0iWCzusvq0gc+f87PRvm1MsgVYpA/3hoA8ESyRtSFuImvUpAz6DYYS4vbqlXDw5Yr195N1w37PAa9/XNtzVcr+RxjbbFMOTrGIqMInJx4+UUBbPOMDDa7TT+dCmtNd3a8rexjEdDQhiBXjIheDvjQplVp/IWLz7Z9OFlWDUO12BDDvyoNcYdNi8SIBoDX18/5CXWjijl7Ts3AuF8T56SznwZUjg4Y+iIVFd9y2UG1qRTQoGeN7sR5AWCCBVAlxdEyKumhUWEhgLnWNixZS7fHqjjEY8wm7b2Ct5JIZoHZSVoSEkz8JF6WcjYCVHJJtJtGow49mSGwLbk6lBromdjkvxosr5LfPwC1D2+FHB0yR+iR8QFEN2ffcX2/8ii2pr5qDOuPjym2gtQMWs8c2peQ1sefwXzTs9eKB4oQqgYHM2AI3IauwdMntPR/rlUptlbOxledj96u6k9fuxQw1YjkIIgB/hQ3UvaYIIDDraoJvvTevcT9IB2yyuxRW7VmnZF
 RWBouyjp
 KgiFgl+6D1Dp5LHNBeBlkUQFaAPVD9YVp4jPG8vbgxJjkvgV6CEXxzvvoI0Jya1dmSeH9x0qCFykGipW19aAOI4MmzPkA5EHFhqJMWPbYeYB32iWVMWZ3v0YZsGfvgqQMiSF8MMMU0Jj58P4yybLTlcIK6iRdJEhNyTgPSn0cFMOm/9MFi1e3zZz3/s5A+f6csbYsEm2ZLrIQfk4XFushv3sajRA3siOcnukb2YZDkKXRSZsndDJ0i/tFeQCo597ECJ2s3DwdDcpWI9x4/tY6EwWJyw/3jJeNAtnvhDhJhw3TFcJk7TzZkcnR+Uu9NvArQ3CADgS1BFSEcGecK4de/O3rdybPmPJPtJ767CWYn4jS4U2VNd+eRnS6YetESb/w7tgMklbLQE2Cs44zmCC68s1xsutY1sN5Fikr1aXva6oe/mdJU8rJJY5KejYEnbgh6sM/6Pj/AwuSo/Uuhh8vAkvDai84FlcVV2rehSIyWVwniaMacABpHXIzhhJJk1MQy528PBE6dGUEFOwICODIyYpVTHdIizwvutjsf3Tq1H/3SoHCbEmY9WGYabyslU/b09CBhyNBBIZEoMY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 17:05, Dev Jain wrote:
> Use PTE batching to optimize collapse_pte_mapped_thp().
> 
> On arm64, suppose khugepaged is scanning a pte-mapped 2MB THP for collapse.
> Then, calling ptep_clear() for every pte will cause a TLB flush for every
> contpte block. Instead, clear_ptes() does a contpte_try_unfold_partial()
> which will flush the TLB only for the (if any) starting and ending contpte
> block, if they partially overlap with the range khugepaged is looking at.
> 
> For all arches, there should be a benefit due to batching atomic operations
> on mapcounts due to folio_remove_rmap_ptes() and saving some calls.

Please simplify that (and make it less arm specific) like suggested for 
patch #2.

PTE batching has known benefits on all architectures :)

> 
> Note that we do not need to make a change to the check
> "if (folio_page(folio, i) != page)"; if i'th page of the folio is equal
> to the first page of our batch, then i + 1, .... i + nr_batch_ptes - 1
> pages of the folio will be equal to the corresponding pages of our
> batch mapping consecutive pages.

Yeah, that must stay to make the comment from "step 1" happy.

> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>   mm/khugepaged.c | 32 ++++++++++++++++++++------------
>   1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 63517ef7eafb..1ff0c7dd2be4 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1503,15 +1503,16 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
>   int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>   			    bool install_pmd)
>   {
> +	int nr_mapped_ptes = 0, nr_batch_ptes, result = SCAN_FAIL;
>   	struct mmu_notifier_range range;
>   	bool notified = false;
>   	unsigned long haddr = addr & HPAGE_PMD_MASK;
> +	unsigned long end = haddr + HPAGE_PMD_SIZE;
>   	struct vm_area_struct *vma = vma_lookup(mm, haddr);
>   	struct folio *folio;
>   	pte_t *start_pte, *pte;
>   	pmd_t *pmd, pgt_pmd;
>   	spinlock_t *pml = NULL, *ptl;
> -	int nr_ptes = 0, result = SCAN_FAIL;
>   	int i;
>   
>   	mmap_assert_locked(mm);
> @@ -1625,11 +1626,15 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>   		goto abort;
>   
>   	/* step 2: clear page table and adjust rmap */
> -	for (i = 0, addr = haddr, pte = start_pte;
> -	     i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE, pte++) {
> +	for (i = 0, addr = haddr, pte = start_pte; i < HPAGE_PMD_NR;
> +	     i += nr_batch_ptes, addr += nr_batch_ptes * PAGE_SIZE,
> +	     pte += nr_batch_ptes) {
 > +		int max_nr_batch_ptes = (end - addr) >> PAGE_SHIFT;>   		struct 
page *page;
>   		pte_t ptent = ptep_get(pte);
>   
> +		nr_batch_ptes = 1;
> +
>   		if (pte_none(ptent))
>   			continue;
>   		/*
> @@ -1643,26 +1648,29 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>   			goto abort;
>   		}
>   		page = vm_normal_page(vma, addr, ptent);
> +
>   		if (folio_page(folio, i) != page)
>   			goto abort;
>   
> +		nr_batch_ptes = folio_pte_batch(folio, pte, ptent, max_nr_batch_ptes);

Same comment regarding matching types for folio_pte_batch(), now that we 
changed that -- unsigned int.

> +
>   		/*
>   		 * Must clear entry, or a racing truncate may re-remove it.
>   		 * TLB flush can be left until pmdp_collapse_flush() does it.
>   		 * PTE dirty? Shmem page is already dirty; file is read-only.
>   		 */
> -		ptep_clear(mm, addr, pte);
> -		folio_remove_rmap_pte(folio, page, vma);
> -		nr_ptes++;
> +		clear_ptes(mm, addr, pte, nr_batch_ptes);
> +		folio_remove_rmap_ptes(folio, page, nr_batch_ptes, vma);
> +		nr_mapped_ptes += nr_batch_ptes;
>   	}
>   
>   	if (!pml)
>   		spin_unlock(ptl);
>   
>   	/* step 3: set proper refcount and mm_counters. */
> -	if (nr_ptes) {
> -		folio_ref_sub(folio, nr_ptes);
> -		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
> +	if (nr_mapped_ptes) {
> +		folio_ref_sub(folio, nr_mapped_ptes);
> +		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
>   	}
>   
>   	/* step 4: remove empty page table */
> @@ -1695,10 +1703,10 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>   			: SCAN_SUCCEED;
>   	goto drop_folio;
>   abort:
> -	if (nr_ptes) {
> +	if (nr_mapped_ptes) {
>   		flush_tlb_mm(mm);
> -		folio_ref_sub(folio, nr_ptes);
> -		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
> +		folio_ref_sub(folio, nr_mapped_ptes);
> +		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);

Doing the TLB flush and adjusting the refcount after dropping the PTL 
... interesting. Well, nothing surprises me in khugpaged code anymore.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


