Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF785CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CE18E0024; Thu, 16 Oct 2025 15:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324598E0002; Thu, 16 Oct 2025 15:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23ABB8E0024; Thu, 16 Oct 2025 15:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11A288E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:19:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9ECBC58F6D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:19:45 +0000 (UTC)
X-FDA: 84004941930.02.84BC517
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 366DD1C0018
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:19:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0eQrpaP;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760642383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yb/0fjZKRdUPIMg/FjU3+zKOM59G4HAx5G6i741PI2A=;
	b=A5pL7AxNxOH8KUfcDZjCV4jmjRRQ8MXem1UniasFGb8b9noD8ab98pldbxrhQq9fDLKNo2
	++ff+hfb2K40wJ2Jv9cgNBa0bxQT2pniN4ombS5k9PxWzW/miBKsFnl5j66QrQgCY4ypF7
	6M7yz5IhdQQk5bPTY0gPRKAgTUuJxOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760642383; a=rsa-sha256;
	cv=none;
	b=YV0asLL2BRjaAAD4CR/X2G6zGh00HphufHpnPp+eCFYqQ/Tw9hSxOuLfJDOx1RWtIN7u39
	J0vq+b8fUc7mrDDHPUgVJBfUDBmt0WqUo85EMWFU0iYQrwuHEuLD8UeRmpL5zjKAttF4j+
	J45SLeki9fz0bZqhBRV6Pnxcp+jsxM0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0eQrpaP;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760642382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yb/0fjZKRdUPIMg/FjU3+zKOM59G4HAx5G6i741PI2A=;
	b=A0eQrpaPbTobmN/4VCVEmlVjAEfCxVhGWMd/Jk6YLxrLKh3DfVRdttzK+ekxCNO57px0Ft
	C7jgi/ubk2LpjYCNYZuvpVg9uVKR9hxUN4A40vC3vbBusKlAoC3+3K/9ZqkFHFstVNsADm
	XYZsaH3bPjZ7f41dIOuvQS6rgeubCcc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-AEcUmDYbPfOgLvFANtgU2Q-1; Thu, 16 Oct 2025 15:19:41 -0400
X-MC-Unique: AEcUmDYbPfOgLvFANtgU2Q-1
X-Mimecast-MFC-AGG-ID: AEcUmDYbPfOgLvFANtgU2Q_1760642380
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f7b5c27d41so746129f8f.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:19:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760642380; x=1761247180;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yb/0fjZKRdUPIMg/FjU3+zKOM59G4HAx5G6i741PI2A=;
        b=DNl/l6mfZHB4qAkheZ0gYrP1VjGuBiIO27Icd9OQMll+hUlo2j38IJKp2IrcjQg2In
         enVanHpxedkQ1N66eMTMEDXz10VivOiUU3xx3kKJOUHCLvcsAxOo0WqJqX9Es5GVkJnU
         FtTTR0Ukchfdp/gI/4KPbj4X3PTssTh5Ton3deAWC0yXLvXxip9Ot8ndBGMkDWDRKCnw
         L0NDvLPRsRBXqOVC+m2lAtc8V7737bOZNbuKbuPnG6nekEfezHMu0SgeEVHk7di27hfk
         pUMs5zN9C0FHeJR0EecjWTzeUhvWy6wTCPxqOo2sh42vAyqWWZmZlL55oM0o667NQ1Qw
         zsRA==
X-Forwarded-Encrypted: i=1; AJvYcCVpW1nYXIqu03F3ehz2wIzC3Q2IqnKzMXkveBvu0dZg10cfPcrUq2vo774+lt71NbYQpfFZwe8aAg==@kvack.org
X-Gm-Message-State: AOJu0Yx5xGZReRVStLcUiI4xOG5kguqM3QGI8z6xJ53u6wSU9G5jm9Jf
	jBIJktU1JxPzmMP9RpA0/ZK8D0q/HMH2ezohX+jhq5gXNlWyE+WxB2l7TFcaOROWlZxeNMLcUis
	hE5Dcji+o/lsNGtoYPbkhain/3c0H88E8f9uzB3SImtRlFfLDdeMZ
X-Gm-Gg: ASbGnct/CzP4SZNzVxyvj7dE2N5yqHBve/uQV+fq9rhOJtFWdR2Ag+K+PAVD2gheVA3
	UeX4AofZjYQ/HryoxqtjDlWdhqEaSy3IqqhHzsjUlzcWRavvTUWWBN0E/oEHVs/VfmVFOYiGGeD
	qX60PG8XvyxLz2x1wk7quQxCF07CZ8Eddds1IFdb4OR8uLFz5BgBf4TRP77xLfQmnyqlXSsEzuA
	wIhrgIBENCOVbCR6ENnUm7vRlZ5SRMAS/LTpwWwFu5bZRniGOZYkhDC4skd8TMKOZeWwyKlCx15
	V7+YmjBJjGXXENsFrU3ldHgznTJ8iQPX3pxo1veVYxQrzod5Qc7MaChCFVWkPuqkTyH+B/Vonuk
	DO3bv8N4heEAQfjoKeh2Y9+52dDMHF4EgiRKcAKJtxNuAkMr45HU+XRhu5L6z6y3RRh6M630rNC
	1x9zq5gUg3nqXxqv9prrVsmFNvg1Y=
X-Received: by 2002:a05:6000:40dc:b0:426:f4b4:f0fb with SMTP id ffacd0b85a97d-42704b3dbefmr1160852f8f.2.1760642380079;
        Thu, 16 Oct 2025 12:19:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLw8poqBeKMwG+Y17fin/AxZjfBGfrix3JG7ScO+xNrKVpK/Tuqp8mBFFhdUCO1uufmUy+qQ==
X-Received: by 2002:a05:6000:40dc:b0:426:f4b4:f0fb with SMTP id ffacd0b85a97d-42704b3dbefmr1160831f8f.2.1760642379606;
        Thu, 16 Oct 2025 12:19:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42704141cd0sm2838360f8f.11.2025.10.16.12.19.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 12:19:39 -0700 (PDT)
Message-ID: <fefe4510-c105-4e7b-8468-3ef6e32a244e@redhat.com>
Date: Thu, 16 Oct 2025 21:19:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] mm: huge_memory: use folio_needs_prot_numa() for
 pmd folio
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-4-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015123516.2703660-4-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c3Rj8K6HPUQb0-53B2KW2Ajo69e_VjMYOo92L0IG4Rw_1760642380
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: a85giyph5ekn5474q7iitk3uxajci8js
X-Rspam-User: 
X-Rspamd-Queue-Id: 366DD1C0018
X-HE-Tag: 1760642383-110832
X-HE-Meta: U2FsdGVkX1+KIx25s0KuEafY+vYPOEu5At27nPQGD1WOX7jGc7hO0b2HOo9YZbSEKcSPG2sKMMu7cLNsE0BfTydUo0bT79+niXhljsPuw6Ae0yjyKXCiwvi/6+lQ2VTrNKc0nQw8fPeLC2PZCWnUrUQLX8NrVp70dH8absBmz4LtE6iRXHk+0H2NgDQ/RZeyhB0i90purjUhvFLJqaH/zZjjtDlBh8v0t/MgyCMaHf9XnUt644xocR8ksx58W2r/oZiBkN6+TzQQPVgbPBN2tvmbIq6+hZjpKw7HvRXmvL8jGZQVQHefndDkXcPtzhVsfCZNtb5QeuBaIqs+EU7kLTkFpwhJ0u3oTorRfKCNQd6Pt/lkciVmg3bkomH1ET80z+EwEE8w2awNiyBm/HzkTNPju9OGs8Rs5zVRRsHdxoxaDRL+NdO6S15RUHni/UUizt8H6YXGwnqzKnh0/apW+LhtCEbQi5ZhM0sm2vwrvqtig74O6dCslOgIa1oRBXh5Brg1u0lEvuwcqSukVqBFGK4UtgAPeWX+XjKHwH4Vk3QrkUu2BcpAlpKcB4PfJIpiR8vVKCs8e8agN2cFVTizyQqxtgbAjJryTr9Fi2YDjMEaLYsWIVOMVoGv0EtoxsZcp0s+5t8X1WdLR7V2g2j6HNi3KIN5L0Yo1ms9uIR9ybpvXtbJSAFmjDS+oCVJ5s1Iw7JYxHULC3AvfpfhwNk1kdqDE9BUb65LoN2dUWpASzlrVD5+JP/tamXCFfho8oT9NAAAA48fnKtPzHRjU6YUjY1pRnwEi1/C+qfuFQPnjUSyG4tCdhDoDSl1u18KJcIFHzn40PoRzkH+uZ6mnjnsT9okV5lUkPXk7MFN2gJUZr+Rx1Yy/MdTSTgaq6mAuTSKj+rxne97aN8+gGXwmg0jn/RyiYnbtRB8vN3J8oKCYOdm+wa2io72sjmWt5eqGFNIVSB4c48Gpt4vD9KhMkQ
 bock0oiv
 aBcZLpqXISb0qsEZvImTsr6uDecYinYc9zAZ4rdnDydLLPK5m0Zb+MZmqzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 14:35, Kefeng Wang wrote:
> Rename prot_numa_skip() to folio_needs_prot_numa(), and remove
> ret by directly return value instead of goto style.
> 
> The folio checks for prot numa should be suitable for pmd folio
> too, which helps to avoid unnecessary pmd change and folio
> migration attempts.

It would be good to describe here which additional checks we are now 
performing in the PMD case.

Because that's a real change.

> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/huge_memory.c | 21 +++++++--------------
>   mm/internal.h    |  2 ++
>   mm/mprotect.c    | 45 +++++++++++++++++++++++----------------------
>   3 files changed, 32 insertions(+), 36 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1d1b74950332..c7364dcb96c1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2395,8 +2395,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   #endif
>   
>   	if (prot_numa) {
> -		struct folio *folio;
> -		bool toptier;
> +		int target_node = NUMA_NO_NODE;
>   		/*
>   		 * Avoid trapping faults against the zero page. The read-only
>   		 * data is likely to be read-cached on the local CPU and
> @@ -2408,19 +2407,13 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		if (pmd_protnone(*pmd))
>   			goto unlock;
>   
> -		folio = pmd_folio(*pmd);
> -		toptier = node_is_toptier(folio_nid(folio));
> -		/*
> -		 * Skip scanning top tier node if normal numa
> -		 * balancing is disabled
> -		 */
> -		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> -		    toptier)
> -			goto unlock;
> +		/* Get target node for single threaded private VMAs */
> +		if (!(vma->vm_flags & VM_SHARED) &&
> +		    atomic_read(&vma->vm_mm->mm_users) == 1)
> +			target_node = numa_node_id();
>   
> -		if (folio_use_access_time(folio))
> -			folio_xchg_access_time(folio,
> -					       jiffies_to_msecs(jiffies));
> +		if (!folio_needs_prot_numa(pmd_folio(*pmd), vma, target_node))
> +			goto unlock;
>   	}
>   	/*
>   	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..5f63d5c049b1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1378,6 +1378,8 @@ void vunmap_range_noflush(unsigned long start, unsigned long end);
>   
>   void __vunmap_range_noflush(unsigned long start, unsigned long end);
>   
> +bool folio_needs_prot_numa(struct folio *folio, struct vm_area_struct *vma,
> +		int target_node);
>   int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
>   		      unsigned long addr, int *flags, bool writable,
>   		      int *last_cpupid);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index ed44aadb7aaa..0ae8f4a277b2 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,26 +118,30 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>   	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>   }
>   
> -static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> -		struct folio *folio)
> +/**
> + * folio_needs_prot_numa() - Whether the folio needs prot numa
> + * @folio: The folio.
> + * @vma: The VMA mapping.
> + * @target_node: The numa node being accessed.
> + *
> + * Return: Returns true if folio needs prot numa and the access time of
> + *	   folio is adjusted. Returns false otherwise.

I guess you could drop the other Returns like

Return: true if .... Otherwise false.

> + */
> +bool folio_needs_prot_numa(struct folio *folio, struct vm_area_struct *vma,
> +		int target_node)

[...]

>   
>   /* Set nr_ptes number of ptes, starting from idx */
> @@ -314,8 +315,8 @@ static long change_pte_range(struct mmu_gather *tlb,
>   			 * Avoid trapping faults against the zero or KSM
>   			 * pages. See similar comment in change_huge_pmd.
>   			 */
> -			if (prot_numa && prot_numa_skip(vma, target_node,
> -							folio)) {
> +			if (prot_numa && !folio_needs_prot_numa(folio, vma,
> +								target_node)) {

You can fit that into a single line to improve readability. Alternatively

if (prot_numa &&
     !folio_needs ...)

>   				/* determine batch to skip */
>   				nr_ptes = mprotect_folio_pte_batch(folio,
>   					  pte, oldpte, max_nr_ptes, /* flags = */ 0);


-- 
Cheers

David / dhildenb


