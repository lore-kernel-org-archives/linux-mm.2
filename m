Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FCFC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 16:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36096B00A7; Tue, 22 Jul 2025 12:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE67F6B00A9; Tue, 22 Jul 2025 12:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE0B6B00AA; Tue, 22 Jul 2025 12:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94A186B00A7
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:03:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66858B98A8
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:03:45 +0000 (UTC)
X-FDA: 83692371210.21.14A1DE0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id CFBB020005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:03:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cNn7kbfI;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753200223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v15CwaAASIebecWsLEoJV+pNv0uu/91AKcRmtsxqL0g=;
	b=VXbUjrq6tgOFIbuZCqhf7AePIZJeduIceGz3dW7SQdr1JizMzNbqIGbT+eljKzgadvXVKm
	fsXBbAUIWAdnJPDlK1CM8SdcgUlHmhk2MGA/K9yndNxEkMc5Xju2FebCHtKo/H6Q+B4C4V
	1VglI4WvmEnXgUxJtl5BHAnakXxianE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cNn7kbfI;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753200223; a=rsa-sha256;
	cv=none;
	b=W+tdyWgqEqg+cgQowL2/6k+Y1fTOPYhY9WXNg1riBwOnUP/b99P6vkQS7wgS3X1fxpvEp6
	wxKVjZohi0K0iumAXABVggiXhSqnImkUv+ydAMwWLNL/0Qoz7BEcYOivfy6PXpzFwi7wrN
	2gTSVrtXET4FzN2Ojy7bO56zrpm7ALs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753200222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=v15CwaAASIebecWsLEoJV+pNv0uu/91AKcRmtsxqL0g=;
	b=cNn7kbfIcAf0TYA8t/DPECl2U+tcHBM0ulU1tjnEMsVw5z2a9BSnFpy/KtH85zKOT/rpWv
	KDXzkXv+Rc+fSGtTmUd2rcar3RczRpHYEWaKS+gwXoTUDi8v4yGj0Dcg3TsDimAa/Oy63S
	PmdO7lfCcLGrjXhbS3sR5M8RtlN7LSc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-FdEs4bhaMeajAxqFwlNj9A-1; Tue, 22 Jul 2025 12:03:40 -0400
X-MC-Unique: FdEs4bhaMeajAxqFwlNj9A-1
X-Mimecast-MFC-AGG-ID: FdEs4bhaMeajAxqFwlNj9A_1753200219
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4562985ac6aso58163875e9.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753200219; x=1753805019;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v15CwaAASIebecWsLEoJV+pNv0uu/91AKcRmtsxqL0g=;
        b=L0XNto2r34Elfi0JDdXnMgRwaWiWHoTM0z73zm6vGKhAmJOS/TGdvANjB6cDNUJPCa
         w03PhG1PCBuZISnE+6d138Csm4B3tkDyVSz7wdJKvGS6sQFX8rDvozdjZ7jHsEk+lLYM
         LR9IDxYkvSTFIV6fKgTTGQjcg0ENtAJL8sU6oF8V3owglL6baBPYlLx9PhlqMYeMk9uZ
         T14YLRwBnW/kfSPCPKygSXFnvYSeu7ATwW0DalCrhXc1knSlao7WSkWlPwU6ew9fDmaL
         DlqKgzg6p78S753oLgsX6+OFa7n1tZ9pn465+qsyzhaftpKg8WUk1ov1A00NkJqnKbc5
         lRKw==
X-Forwarded-Encrypted: i=1; AJvYcCUzkQm3aM/iQJ1i9dY9kjpB3G0YvUICt/DnDxMtxJWTpTcjeaMgV+zgXTVnX/C1SfJTT2ETGAOY1w==@kvack.org
X-Gm-Message-State: AOJu0YyVrATC60ivsYzcOXIrbqmWNZDOqBp9VAgtPLeSg4bIMEOge5AV
	2tEQjzQKV1n6cGytxgRvOBby7sAWUoQyJ0LIFRcnYuG0o64gGTWhfydq7HRikX4T2C8awm3NThH
	txbd1Cg6VQiw8k/2HOF265g5ZRoAAQ+TA5mBvz5qZXCOvhQ3DJSe2
X-Gm-Gg: ASbGnctAzuqWkmQ7epidseTRJcNbcCG2iRR9iaDvtGDrdh1PaDarlkFwpLV5V5GKLiV
	2LsLtZHaDd0McbxF/vT/EEvXL1O4AQ7BhlNNgf357L6Gz16fA2u+l64zDnwNjiMl99uOWShlr4T
	5QBu5BrdQxOS7m8NSRNCbRZgywru36Ohdvr53TdYA3Acq9u3haPd9WajrT/VgePInnqLwfUB504
	UT3SE4iA4al012/g4bd9qZz0GojB3R/tqfZXg2dt+1gvOSCNl+g+sONn1fKlF/DSROTSBoMlFZ2
	/+Uo5jg+iWL/EhKiKG7/FnCNzztCTDoVx26rZ2fSzCKOqGmAHtNydc2lg9LmuHehgvR/dpABmUM
	7W0QeICD4Z6g1KSOvthGM5NbKCS8bDIemntUs3qts2VGlngJ4J/JqUx/5eyzKeTyo3NE=
X-Received: by 2002:a05:600c:c84:b0:456:d1c:ef38 with SMTP id 5b1f17b1804b1-4586798f55fmr1065735e9.24.1753200218107;
        Tue, 22 Jul 2025 09:03:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9KzrNKh9CcwV7LTDal3K5awiRUZDWhKDtMkNJxt2L01VFpDA1WbAK3crvJfh3A364TrxTpA==
X-Received: by 2002:a05:600c:c84:b0:456:d1c:ef38 with SMTP id 5b1f17b1804b1-4586798f55fmr1064865e9.24.1753200217207;
        Tue, 22 Jul 2025 09:03:37 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b74f5f3sm132242885e9.25.2025.07.22.09.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 09:03:36 -0700 (PDT)
Message-ID: <2765db16-431d-4c77-8091-889a45c18e35@redhat.com>
Date: Tue, 22 Jul 2025 18:03:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] khugepaged: Optimize
 __collapse_huge_page_copy_succeeded() by PTE batching
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250722150559.96465-1-dev.jain@arm.com>
 <20250722150559.96465-3-dev.jain@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250722150559.96465-3-dev.jain@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H3Ir49mLV5klApeMGIzwyV3mumziH_OG2-Vg1zic-UU_1753200219
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CFBB020005
X-Rspamd-Server: rspam06
X-Stat-Signature: nrshf7anekzqdqc7cpyahfse6anmhewc
X-HE-Tag: 1753200222-238202
X-HE-Meta: U2FsdGVkX191G9Yt6Rz5haKfOvb89ASripLCqBIhfgeEEvi6L8JCLFYjWXuE5u/SKFrN870b97jDPu7BshT1H8PV6eetm725KH499NAgm/KRrdwKI0e81VMrr4ZIj/o2WkwrzQ7EAjFYrxobyHbAg0J02iX/9xkD+tjAYUJGR2KBp7JSEq17aCXoAfeNisylHB+DnUU5Vggtv88gDGxxozlBqbVKFwoJ8qcTab5nK8EnpsI0crGojdIz3KaBsKkFR4iU9yMFeOhwLpT4ixnKHeL3JTtXpcEzkDdiwhd/Rmc4cfIctB4P2281hxc6rOTRhX/OtDpWi/N3c/J8TYNN8GvG8sIK8SIUlEV3etCl3TgmCuQcJ1UzviwjUBDIqNrWctr+vUxLbULzXRTMVswc17ayUVUT864A6Pr/5U2MoEMitHRQIivohNKJPeDsv3pjScQ3FgfkSqZhHcF7tQ29JcsenibOgIGr75EPKdAUqWNTvZZNG4LPmJlg/boWj5y9rjM57dyzIoSqtsIqHaNuxprr2dnlOkuyJTkPdV0aJYUW1SIU4VOwF83StM+HiAnR9kAAdntOzBNb5pcYnJxa8SuAz20esv7TamI91riAP8uiKzEeIVJs++5QQX2kjBJaCef/cp/qRFtX6MlnzECnLYuGl8SzJ1DiwU7xBSMkGNAEcnpq5C2HrlT15llGI3c/KZjo62ht9/6PkFVuK+f5ImSp31UHbacWPrdkAdsspS8ZnA5qsOTR5zEUrzKQMub5t/EshDkFQDPVD/wpL6zZPowAjaLz3bZXqEmAAUY4csuVE/C3sLAR0zGUnsPFddBjr1Hu7IkxtLfN7fz68rPjY38mbWQLjjRHLGZJ4AXd8W4lKUuftyvFrxNZq8tfA3gSxgTgMnNdYp+kIRkZ83Gae6lEb9xeYnFAfr9SUq0Hxf96s8TNTWiY+aeBR3jcI1FAZiS6DXNIrLOOZe7cK23
 MTWMVW53
 uU57A8uVbQSAlSvZh7AfmCvw2tpYQXNZ+5Gyrd3Ff2BH4j2GuKlUWjkOUnyNYAv4wMT8IuGNh5Zw2dP6nAyTgkmq965CvbKpMWCXbebJ7tG2+/JGg7USL0lQzgSWzyARl8TNs/0mF5VlgCsnWr40aKOBTuDY0sHddJ5SfsKohlvrfH0b2FTUGaB6+HjVSmBL8KVuUrsPYZYOYmn7I3X7FgkkivzJYPTXv6yG/CgjhLLjIRBJl7nu16EMe7HHilgyxjQRobpoIrqlgQZ8QEID2UfdTyOSzH0/YE61K22y18DHKwM+1PgLiTuvYRgQRc4cctN8mFAJot6fHaecaG21kdCdEvpWzn14c1DS685NmFoxziZfDW//DrXvQmNDTbIMM23U/w5dkL9zL/KxHxHEUucttOAx4v4CaD/asbQcd5ZjbyOf0vXWkxy1+48ap0Ds+j4vti5jk3MlLDRvntZClWxFM7Bq6JLR2Syjub7SvjIM/q1HkvZVHk5dm8McC8+BCgGgd4zOEXUTPUeg5gayBeovLLbSsM3ZhDGhEgZbQtUWx0x8WDLpZyLjAlr0JwCpqgrZ73tH68fZf9A8yiPsS2S2cOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 17:05, Dev Jain wrote:
> Use PTE batching to optimize __collapse_huge_page_copy_succeeded().
> 
> On arm64, suppose khugepaged is scanning a pte-mapped 2MB THP for collapse.
> Then, calling ptep_clear() for every pte will cause a TLB flush for every
> contpte block. Instead, clear_ptes() does a contpte_try_unfold_partial()
> which will flush the TLB only for the (if any) starting and ending contpte
> block, if they partially overlap with the range khugepaged is looking at.

I suggest not talking so much about arm specifics.

Simply say that batching reduced the number of TLB flushes, especially 
on architectures that support cont-pte optimizations.

> 
> For all arches, there should be a benefit due to batching atomic operations
> on mapcounts due to folio_remove_rmap_ptes() and saving some calls.

I would rephrase that to "Independent of that, batching PTE unmapping 
has known performance benfits (i.e., less refcount and mapcount updates)".

> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>   mm/khugepaged.c | 25 ++++++++++++++++++-------
>   1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a55fb1dcd224..63517ef7eafb 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -700,12 +700,15 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>   						spinlock_t *ptl,
>   						struct list_head *compound_pagelist)
>   {
> +	unsigned long end = address + HPAGE_PMD_SIZE;
>   	struct folio *src, *tmp;
> -	pte_t *_pte;
>   	pte_t pteval;
> +	pte_t *_pte;
> +	int nr_ptes;

Nit: I guess we should switch to "unsigned int" here now for consistency 
with folio_pte_batch().

>   
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
> -	     _pte++, address += PAGE_SIZE) {
> +	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
> +	     address += nr_ptes * PAGE_SIZE) {
> +		nr_ptes = 1;
>   		pteval = ptep_get(_pte);
>   		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>   			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
> @@ -722,18 +725,26 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>   			struct page *src_page = pte_page(pteval);
>   
>   			src = page_folio(src_page);
> -			if (!folio_test_large(src))
> +
> +			if (folio_test_large(src)) {
> +				int max_nr_ptes = (end - address) >> PAGE_SHIFT;

Dito.

> +
> +				nr_ptes = folio_pte_batch(src, _pte, pteval, max_nr_ptes);
> +			} else {
>   				release_pte_folio(src);
> +			}
> +

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


