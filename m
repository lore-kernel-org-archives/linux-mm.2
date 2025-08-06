Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071BCC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 08:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10B88E000B; Wed,  6 Aug 2025 04:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E83D8E0001; Wed,  6 Aug 2025 04:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE4C8E000B; Wed,  6 Aug 2025 04:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 802748E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:08:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 280FF1403AF
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:08:42 +0000 (UTC)
X-FDA: 83745606084.24.CE89A2B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 90DC41C0007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:08:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AmDrYEvo;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754467719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idlUt3rsM+yBY2pffT/6Us1aEZrNslTr2qkjcKhWpWM=;
	b=i6u11IpsZO+/7g6CcN+sMWEVEHkKRGhxhxe7dLGPVdtVQjy1ZX2WyasJy6N5Zf6voP6k+9
	SLlcyzXRNnZzQ1hUeTlE3YNycn1yOe8mWSrykj1AOSRw+6JXI48dHYw0bErCd7puh5rYcv
	GLHRUNQtxE7pYOGX2D4S5x8PPPExseU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754467719; a=rsa-sha256;
	cv=none;
	b=d0YBL0Hga6Yo3+zUGzRe84Sf7xEJMiNApWlrM8N+TxfLQcAC0n1afkKQwEimGFjx89iA5T
	hHJzfF0QSAUHBUbdQk3JY6MlOI21ad4Fvi8lYHPG6blFS3JLhWnURh6jURs/y5Rok1buea
	BgxNZwFaAJmDa3EsIJtRYLsflXQZNwM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AmDrYEvo;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754467718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=idlUt3rsM+yBY2pffT/6Us1aEZrNslTr2qkjcKhWpWM=;
	b=AmDrYEvo9vgs5+Eii0UAt5YAoL+K9eQxeCqd59LtcMMUyKHiZanb8o+GNkTlQvjOL+9YU3
	6Dd9i/zxzK3tVdbvX6xA2gZkmDnj8qAP8l7r3EABq+pVJNjvCo1Xa8+FApIIT4nzhyUuyc
	4aRC5bc9UwEbadX2xkgzE2XBhH3pG1w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-d8CxoNVCNie4DuOK4spnwA-1; Wed, 06 Aug 2025 04:08:37 -0400
X-MC-Unique: d8CxoNVCNie4DuOK4spnwA-1
X-Mimecast-MFC-AGG-ID: d8CxoNVCNie4DuOK4spnwA_1754467716
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459d4b5db81so16544835e9.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 01:08:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754467716; x=1755072516;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=idlUt3rsM+yBY2pffT/6Us1aEZrNslTr2qkjcKhWpWM=;
        b=O5LumeAWwA2ynd19YBhj43EyjflOZoQvVjadC3AP8AxBTIsQvk9H6WWQSq1Dj8DER7
         NpJbrDd+x+R+RrEEGjbkMmfnOuS9VUm4ugMyi6XTKnbmarjt6FBNYewjx9LplEHxqzN5
         +9km84yF5gX1ndXVp40C+UsFd/y+h26zb8MV7yjZAAVGDPh5JkVrJqM8r0Edx+bp7Q1c
         aROfIn654q7XEO1ObTV4fN7EnvWWLhQe8TBUjL0Y6kUejZyeGrO6nJUV+MkKgbIQb8Xg
         esLd1OzHFwzn007B+vQ56QWeyO9Q6uQHHpLqx3PKouBqzHsE+2Oj8lvIt0wJ5lWrsgW+
         G2Lg==
X-Forwarded-Encrypted: i=1; AJvYcCVrzB7vH0NPQ9Vugk/S39LOHp+GD8XKjzq+eZizgjBiGPtYcvqad4gh0j37HRzB5qS4EMKMgSxvqw==@kvack.org
X-Gm-Message-State: AOJu0YyY/diYH0EbLY9PyEGdaiUePwLi5V7WwQ/RIPX085/tdSN6xRX9
	VSlmchzUiky4wie4CE0ic/Hr7zU4cq2C3HoSqsHhKbg7mfqKjgRSyBwNJb5jEDTaRa8oofQFwth
	LgGRTEbK6pX4Ue82yppLodJhLchW5B6ycRIbKM99OjfWVlr5Yh6/7
X-Gm-Gg: ASbGncvx4vR7OMYS309vXpu39zP3TZfYmahooUvVnGOn2pw3usEzw9/mraP4rhquJp7
	OzgdJYjGaA6hvSPYRVV485xweiDWPTobdDjCTlUf9l5NwsNytJV3E5ERqiIDbfMvnfCRzzJr7wJ
	lj4yt2ird/5KmTafsSCZeZSIf8uUMOQI0p1WvgC0DkDlD++WBtZyBuVQOKurILLjlpj0aXeiyfA
	B2+ScbMTEhrTZrljqxbST5ICd4iZ5I51tC5KreX30yv6IAQdFVpUQejgYPxSLw4HrjaQ7wsC/r0
	3euG9r3z/C7zUzW57+TrM+L3aZtvKHcQZnKf8h//H23m/zFNzwH14sBGnonBpEwnlZ1AhyM=
X-Received: by 2002:a05:600c:5307:b0:459:dde3:1a56 with SMTP id 5b1f17b1804b1-459e7e4cbbdmr10991035e9.28.1754467716132;
        Wed, 06 Aug 2025 01:08:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnF+JC70Y+wij7D0xhvmStL7sg8B0/W7PEfpWoYIUbNo5rKcmTj513UkofaGh3WuFA13jIvg==
X-Received: by 2002:a05:600c:5307:b0:459:dde3:1a56 with SMTP id 5b1f17b1804b1-459e7e4cbbdmr10990605e9.28.1754467715584;
        Wed, 06 Aug 2025 01:08:35 -0700 (PDT)
Received: from [192.168.3.141] (p4fe0ffa9.dip0.t-ipconnect.de. [79.224.255.169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e58400f5sm35850175e9.2.2025.08.06.01.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 01:08:34 -0700 (PDT)
Message-ID: <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
Date: Wed, 6 Aug 2025 10:08:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: ryan.roberts@arm.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 jannh@google.com, anshuman.khandual@arm.com, peterx@redhat.com,
 joey.gouly@arm.com, ioworker0@gmail.com, baohua@kernel.org,
 kevin.brodsky@arm.com, quic_zhenhuah@quicinc.com,
 christophe.leroy@csgroup.eu, yangyicong@hisilicon.com,
 linux-arm-kernel@lists.infradead.org, hughd@google.com,
 yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250718090244.21092-7-dev.jain@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6-07Lrsiw1TTmqylTJd-iwiONtAXk7uIx-Vw8WBCymc_1754467716
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 90DC41C0007
X-Stat-Signature: 4adkhuszk4orcqcsueysrkxnwmf6iecd
X-Rspam-User: 
X-HE-Tag: 1754467719-337348
X-HE-Meta: U2FsdGVkX18bmWebZiU9/ABQEi2vSS7lHCtwEAKaD55+gmpC3k3t0ocX+XDgK4ca444kpjhxbizfS5GMzNRn2BolOGWoRlJCW5UMmhEB345ts+o/nChNxuT3CS9oeFLC0+nARJu4CzC12++mNg4cZkd4A0T/+XrARTMpBI1LgautQHjk+fu1a5RNDcMY6WdNV+qkjMs6U+TbDxeKbiFKw6AMP3rVP2u7zobp7ujxHXwyXu5K6dEyNdmZ/tA2Tn4kIe1sjWAX9enXQiqNejRc3VSsHTCp7NkbjoLeBftq2Doahq+zkkVjf/K8M7E4F6RjDW3mSJafIUSISoOWmsnHTNsR4UGKvhf+4A9wsfYqhHQfzI5b37wtPlYqPq7knLkXXORD3vES5PbQ/xxeWKk4U8wnB/OKt7Sx0FvXbx4OZ5goOcMTdVL0xLsPihY/L5SJeQZFHaFoQPZ6yUBn0FmTDiU3eG56HbpcHoYGwTBVYjAYpC2BeIQEkT+GsyaCRWmzCAWiOvurJHjPLbLAh0b232L2Yr5Bmz6L4OXgLpIqrRxjKHKG1tN30ywugpq6HbGwFqnKLPvBAtQF+HVFeeBcA2KVWPWJCcg3tQEJgTvb9fxMgjbfVXfIB3wbrg7AMiwB1l2PspYbkCiWBx1LvhY0u30NvCvnoI+iknU0odqvZaWZvN8rTXQz/lyd1xNwxwn0HnAnlGVHtTw6Cf2MSUyJqVpCDL0pqgwwRAz+/825FP/ksIbsYqTA4amhx801lZT4MA54O9jPSo3NP6zxWjKnVBSeghERzPFQlJ6wZWlgQjsG9DFWUM1ct2/b5UNxW5VlSLMS7eGHmfTUSkLgj9eFL+SMO3Ok7AGqbc/KnYb8a6vF/bca9OdJTDNrPibVMkqn36x/rs0Cf/e3lfh0+Vc/H1J6rlOGd5u8igO9+G0ZawW5F9To5Q+JFnBUXW2KUop6Ijes0WmUhEce/sUIehf
 zsZtu9xh
 gg5mXxoTxvS/jYuReDcHRKJoYMKWvWu5ZH5yjema1qTvcfkc0bULGHF0VCm5qQpulBAgAsISCJx1oZf2bsKmFMp1LzZnEH5Fl2G/1fl+RFHvlomWf9v0YWll6XoUSYgPN9515VozC0BcOTdWSFmipvRfNUzTTLjnJLmjh+hhJTjTHz6sQb6bw/lappBiahraXY8oTQxCbRYLBOvlLIsFq+3SKMvWfnHzvtacaU/IqbittE5zYyz38Sh+CiapAcrpKMjV505Vwk4R3oK9im9nBs8InaQO0P66N3aLLFaWimAA/xAk+ZWTNuXKPad15CaZLvaLn2oUsbnqYJoiVrb40YgneS4eBisQBO/A14gDs46xkeG3JZwVzORWIdQUzUpGNQhHCglk6ahOvKccxsX2tos+KbtkLazZv7sX6kPZLpPugQjR7bV0tvQpajPtRVjPROLIBO+UgTOS8fWy99eE4CKMIbjKvzTIbi+Ko
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.07.25 11:02, Dev Jain wrote:
> Use folio_pte_batch to batch process a large folio. Note that, PTE
> batching here will save a few function calls, and this strategy in certain
> cases (not this one) batches atomic operations in general, so we have
> a performance win for all arches. This patch paves the way for patch 7
> which will help us elide the TLBI per contig block on arm64.
> 
> The correctness of this patch lies on the correctness of setting the
> new ptes based upon information only from the first pte of the batch
> (which may also have accumulated a/d bits via modify_prot_start_ptes()).
> 
> Observe that the flag combination we pass to mprotect_folio_pte_batch()
> guarantees that the batch is uniform w.r.t the soft-dirty bit and the
> writable bit. Therefore, the only bits which may differ are the a/d bits.
> So we only need to worry about code which is concerned about the a/d bits
> of the PTEs.
> 
> Setting extra a/d bits on the new ptes where previously they were not set,
> is fine - setting access bit when it was not set is not an incorrectness
> problem but will only possibly delay the reclaim of the page mapped by
> the pte (which is in fact intended because the kernel just operated on this
> region via mprotect()!). Setting dirty bit when it was not set is again
> not an incorrectness problem but will only possibly force an unnecessary
> writeback.
> 
> So now we need to reason whether something can go wrong via
> can_change_pte_writable(). The pte_protnone, pte_needs_soft_dirty_wp,
> and userfaultfd_pte_wp cases are solved due to uniformity in the
> corresponding bits guaranteed by the flag combination. The ptes all
> belong to the same VMA (since callers guarantee that [start, end) will
> lie within the VMA) therefore the conditional based on the VMA is also
> safe to batch around.
> 
> Since the dirty bit on the PTE really is just an indication that the folio
> got written to - even if the PTE is not actually dirty but one of the PTEs
> in the batch is, the wp-fault optimization can be made. Therefore, it is
> safe to batch around pte_dirty() in can_change_shared_pte_writable()
> (in fact this is better since without batching, it may happen that
> some ptes aren't changed to writable just because they are not dirty,
> even though the other ptes mapping the same large folio are dirty).
> 
> To batch around the PageAnonExclusive case, we must check the corresponding
> condition for every single page. Therefore, from the large folio batch,
> we process sub batches of ptes mapping pages with the same
> PageAnonExclusive condition, and process that sub batch, then determine
> and process the next sub batch, and so on. Note that this does not cause
> any extra overhead; if suppose the size of the folio batch is 512, then
> the sub batch processing in total will take 512 iterations, which is the
> same as what we would have done before.
> 
> For pte_needs_flush():
> 
> ppc does not care about the a/d bits.
> 
> For x86, PAGE_SAVED_DIRTY is ignored. We will flush only when a/d bits
> get cleared; since we can only have extra a/d bits due to batching,
> we will only have an extra flush, not a case where we elide a flush due
> to batching when we shouldn't have.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>


I wanted to review this, but looks like it's already upstream and I 
suspect it's buggy (see the upstream report I cc'ed you on)

[...]

> +
> +/*
> + * This function is a result of trying our very best to retain the
> + * "avoid the write-fault handler" optimization. In can_change_pte_writable(),
> + * if the vma is a private vma, and we cannot determine whether to change
> + * the pte to writable just from the vma and the pte, we then need to look
> + * at the actual page pointed to by the pte. Unfortunately, if we have a
> + * batch of ptes pointing to consecutive pages of the same anon large folio,
> + * the anon-exclusivity (or the negation) of the first page does not guarantee
> + * the anon-exclusivity (or the negation) of the other pages corresponding to
> + * the pte batch; hence in this case it is incorrect to decide to change or
> + * not change the ptes to writable just by using information from the first
> + * pte of the batch. Therefore, we must individually check all pages and
> + * retrieve sub-batches.
> + */
> +static void commit_anon_folio_batch(struct vm_area_struct *vma,
> +		struct folio *folio, unsigned long addr, pte_t *ptep,
> +		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
> +{
> +	struct page *first_page = folio_page(folio, 0);

Who says that we have the first page of the folio mapped into the first 
PTE of the batch?

> +	bool expected_anon_exclusive;
> +	int sub_batch_idx = 0;
> +	int len;
> +
> +	while (nr_ptes) {
> +		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
> +		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
> +					first_page, expected_anon_exclusive);
> +		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
> +				       sub_batch_idx, expected_anon_exclusive, tlb);
> +		sub_batch_idx += len;
> +		nr_ptes -= len;
> +	}
> +}
> +
> +static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
> +		struct folio *folio, unsigned long addr, pte_t *ptep,
> +		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
> +{
> +	bool set_write;
> +
> +	if (vma->vm_flags & VM_SHARED) {
> +		set_write = can_change_shared_pte_writable(vma, ptent);
> +		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
> +				       /* idx = */ 0, set_write, tlb);
> +		return;
> +	}
> +
> +	set_write = maybe_change_pte_writable(vma, ptent) &&
> +		    (folio && folio_test_anon(folio));
> +	if (!set_write) {
> +		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
> +				       /* idx = */ 0, set_write, tlb);
> +		return;
> +	}
> +	commit_anon_folio_batch(vma, folio, addr, ptep, oldpte, ptent, nr_ptes, tlb);
> +}
> +
>   static long change_pte_range(struct mmu_gather *tlb,
>   		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
>   		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
> @@ -206,8 +302,9 @@ static long change_pte_range(struct mmu_gather *tlb,
>   		nr_ptes = 1;
>   		oldpte = ptep_get(pte);
>   		if (pte_present(oldpte)) {
> +			const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;
>   			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
> -			struct folio *folio;
> +			struct folio *folio = NULL;
>   			pte_t ptent;
>   
>   			/*
> @@ -221,11 +318,16 @@ static long change_pte_range(struct mmu_gather *tlb,
>   
>   					/* determine batch to skip */
>   					nr_ptes = mprotect_folio_pte_batch(folio,
> -						  pte, oldpte, max_nr_ptes);
> +						  pte, oldpte, max_nr_ptes, /* flags = */ 0);
>   					continue;
>   				}
>   			}
>   
> +			if (!folio)
> +				folio = vm_normal_folio(vma, addr, oldpte);
> +
> +			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
> +
>   			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
>   			ptent = pte_modify(oldpte, newprot);
>   
> @@ -248,14 +350,13 @@ static long change_pte_range(struct mmu_gather *tlb,
>   			 * COW or special handling is required.
>   			 */
>   			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
> -			    !pte_write(ptent) &&
> -			    can_change_pte_writable(vma, addr, ptent))
> -				ptent = pte_mkwrite(ptent, vma);
> -
> -			modify_prot_commit_ptes(vma, addr, pte, oldpte, ptent, nr_ptes);
> -			if (pte_needs_flush(oldpte, ptent))
> -				tlb_flush_pte_range(tlb, addr, PAGE_SIZE);
> -			pages++;
> +			     !pte_write(ptent))
> +				set_write_prot_commit_flush_ptes(vma, folio,
> +				addr, pte, oldpte, ptent, nr_ptes, tlb);

While staring at this:

Very broken indentation.

> +			else
> +				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
> +					nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);

Semi-broken intendation.

> +			pages += nr_ptes;
>   		} else if (is_swap_pte(oldpte)) {
>   			swp_entry_t entry = pte_to_swp_entry(oldpte);
>   			pte_t newpte;


-- 
Cheers,

David / dhildenb


