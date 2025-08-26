Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D05D2CA0FF0
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5128E00EA; Tue, 26 Aug 2025 10:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F256B0113; Tue, 26 Aug 2025 10:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B108E00EA; Tue, 26 Aug 2025 10:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFE2C6B0112
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:22:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A10B08152C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:22:48 +0000 (UTC)
X-FDA: 83819124816.22.8095A7E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1E13820005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:22:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NjZGSZ8W;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756218166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h39i1jZswq+DsNG6K29l9TcQzwNCCY98bFn/fI62p0M=;
	b=4zDfwSCC/60S9WkkCu6e16ORlNejeKzrF4FgdP0vS0NnkRBxiwJvswe4ez7sMiN/22V1oB
	u+v5LBIBlQfw1N4hBAgMIyOaFUkdaIFqEszr2HVLDZAin8U7yhd9wkbxRQiR8dtHQVb5AX
	6zDXQtCYW6TwvBSw205nwUy9wfVORyI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NjZGSZ8W;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756218166; a=rsa-sha256;
	cv=none;
	b=TqLdVdcBfn1IPA7NzedlAj26ysSmvenbeSrbJMZ015ox0dod6esQMp9ywkbl4CE3j2hZrE
	VF5c3QPGwqDqYQ1o8VARlWsnsT8JPJr5h1Xv/sSr7lJbX1TxR0RxQsusGDplxnPGKU44SX
	1naEXw0SXLwvIGWqDguc49r4se4OZ5s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756218165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h39i1jZswq+DsNG6K29l9TcQzwNCCY98bFn/fI62p0M=;
	b=NjZGSZ8WoGrTDqtD1D1R2sedcCNgCBRsQHMjDQUV2hWOCjSyoZ2onj0LTDot3UWOVLP2PO
	L9dacWephzdHNq77KkCry6bBFzkJ7ZjB6L7lWrOVxn6n/ruEpTmf+bkmcy3Nt8TRAX0+oK
	yK7f6QV2ggpua1dP+0zWkl7B+K43tOM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-DTgjgN66Mb6DWf11P8bytg-1; Tue, 26 Aug 2025 10:22:44 -0400
X-MC-Unique: DTgjgN66Mb6DWf11P8bytg-1
X-Mimecast-MFC-AGG-ID: DTgjgN66Mb6DWf11P8bytg_1756218163
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3c380aa1ac0so2166824f8f.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:22:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756218163; x=1756822963;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h39i1jZswq+DsNG6K29l9TcQzwNCCY98bFn/fI62p0M=;
        b=Q/r218K//fNuC/oZQAO/qf+NByPjZtG/XJvMeLxDOMpQStLmITryaShW3hdgpYD8IK
         9TmABCbBvDb6RsuTUtk1ys2TRj4YdgSdBFub4DsA5I9kIsXS8/UEm/ucS3+3c3tXYo1L
         St70I91rRr7AnuYgYZEyVDRataHCfS00ufT8f1okK6iskzu/CUEEycR3nUjG6ivSBKmK
         bPaesQSCNl/VxpmBUTAdFF733OUfLPBo8MJymeql7srz8oNjDPSvl+nLj6ki84DCKHEg
         AOBXCcusRr46NW1o7IGZnCgr/PIGRitXZiyuaPyK9a0MnOpvDYMew32xyvymZAxzn5tr
         68Pw==
X-Forwarded-Encrypted: i=1; AJvYcCXuPV0tfQeesYqQGypWokfY/3UK+uMO3tVrPKGLShefKAtq1Xv4ITphEK9I/JYChgeRNidSKTBb0w==@kvack.org
X-Gm-Message-State: AOJu0Yx8C231q9b2Jln/5Cd2b9BAFuaZur8QxNdF4oW8gseceo2i85He
	zZWtXYN09/9s/ZYUPuZFz4T8zyX1qZVJQMPFtDunKNWTid5uyBsheRfCwy9eywt3fzTiMIOccjU
	k/tczr2jAdsvS30nwEOLoNlH4KUPzaKj9pVwlhVDmvQtQ2jADev9u
X-Gm-Gg: ASbGnctxEqqx7W6TCTIe9pQEyfsmEFsixHxR9xqHq3QGERN9cNqXV2IBDpoKWk06wt4
	dfpTN3lqTjoomXkdbhmdwbs5ZO2s/0fmpt2cokraTlHe/Y9ETBmBd7oqa4LYv+WGYq8DW5lE01V
	BmFI5t8iQyUVzOI+7H1aClrE+iW8YLS3aCR/EHCSC6TUsqvhP1DXmPgIhy/k2WjLhAg6L5YU+ty
	mvf292Nu9FhBBATroetllKoLVdNUNJyxZDwBwd4ISX1BnHYPLyTnHqcSUfKijBjEgCR6sDBiULR
	uIsM7TD6LOE6a/vB0hTcXrtGSXjBEUpSV1ZFUCpIdAD3eck1gwuLtiM/afopkyrRvSnBVc1TZQ=
	=
X-Received: by 2002:a05:6000:18ad:b0:3b7:940e:6529 with SMTP id ffacd0b85a97d-3c5da73ee7bmr12909646f8f.10.1756218162697;
        Tue, 26 Aug 2025 07:22:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoilF3OQdCbMR7mv9ylZSZkZgVzsErxb/ICdf5VRA2VO3gRqFa7W9pSbkINxHmbx1/dDo64A==
X-Received: by 2002:a05:6000:18ad:b0:3b7:940e:6529 with SMTP id ffacd0b85a97d-3c5da73ee7bmr12909579f8f.10.1756218161800;
        Tue, 26 Aug 2025 07:22:41 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c711d9f3a8sm16439115f8f.62.2025.08.26.07.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 07:22:41 -0700 (PDT)
Message-ID: <54bfb6c0-eb35-4e53-ab45-04139623abb0@redhat.com>
Date: Tue, 26 Aug 2025 16:22:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 01/11] mm/zone_device: support large zone device private
 folios
To: Balbir Singh <balbirs@nvidia.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
 <20250812024036.690064-2-balbirs@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250812024036.690064-2-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CregJuBFNG3rfxPW4uCgG4ynuz8etHjtcZ2izLkj4hI_1756218163
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jkimhdfz9z9shyiaz8sxrzk6b69oj58f
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E13820005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756218165-427956
X-HE-Meta: U2FsdGVkX189OTNy5CEDwkMACsQmrHXcD0W2JP0bvEcoTq0LnbI2+tpa8yjvaW85Gke7DD7TyjHZnzJVDQ57AE3QnG47nen0Qlcq9BFojd0JIC1tcc+LNdhwqrajNH3qcyXkUfkB6yPJfN/KecOOtc7d+zc7eDXje1fy0zC1BUSc/xtkogNdFNJ2xfathGcyWrgzffCduoxarYvr9OR/m6lczzzQdQD1wWiM/0dahMG45dPaaYu89/29vQzK8Cma/X1lLCgJjW5eECGNoLVWR6/RSotQVBRbkJ2Zt87jeVti2SQXV9qmWkHP3ubpU8gH7ZTwoQbk9ULlWpjnOT9H5x0PoqQjajhSkwcEQqQdiLcjLd33X9bifRq6wowFAXYvf1Pvuyp8208BJQuLOhM3h7eYGOWSI1DNWNoKnamLgPRsJu9a3KIZQU5VAPt3HHSSNUFsaSsuLuIISwoO8bGpNuWK8YSappI4Sr7yUTAEA3LgLCjjsQBLoZ8z2a6mI36mitApFVYRcK2KTCrw8eQxTIex4+xRmAoRySdUUSC1dntDG2Dq+jk6ebY1Vv66Bw9Jad+gUZj9bPk6Ey4bD9CtPnIPLGhDQ2sGRMy/DJ/VQ+xUX1Qp1flzJ9PHttNC+IhIdinRANTu6ksPfYuiTbtbPAuojJzw3iQIgEAx2nms8/1zLgx0x6/bgrexrSXj3PLh8zBOsr/H4UwV9wWzk8KTuqFvAbKfESfTY9p42esP321iQr33h0GQzfVO2syGLtfxsPEOLsqL3f0nw3qp6+NPlqzrZajwJcMJfv/40wz9JZ2LxW/GID5rQUTphBpP686xf7KR76UusGL4dcGhq2bv3DuW2r6kYuhTjEftdDA4b/1fb9X849X3hufCZSQ7zffCF2gXK3UnTx40NCm5h3180+udeNChdELy5Zt6tqQJ4BdrkxAMI4GBb6OzvPRXNGy+jtn9J4k/Eusz5Y0A+Dv
 SgPPBig0
 hxGVRZzreBC7Tp7NUJ7+k0AhuQudYYIHQgwEAcY+rxrYQoTIrwBuhiCfJLVnkoxln3WQnPr0IPiAe/z2m/jtk/oC+0LCo/a1fUgXCQzfLa/ov19dWCdsKzKV7xBBSAL4c3LMJhoYKpGQCVMqzlSMKzn8c8g3Hn3Up3AIS538mEf5VWJhP3ULac6FVzQvkfXRkI28NXgBTQFSGxpxU5aeL8N96D9xZgGEHPaoVlUBo+2rM8e3j57zBhShNQQUZO0+t0dB9E3rjhF4PLQbY8hAT/+oY9ESQbFWMXwG2Zn3RO0j+9Q736/0wwg3sZKNz5QEw9U0weV4hjtmO4NFXDqs5gLOgTSncS+rHHsWEDXXZ/9L8QKdGwjYpWm6vSA+dHYYCtLslu0DKPzNcDUrB5DCDEiIoRNuhOFB1zAi97Xel+5g7BGZeW16y7fWdYN2ZIKytHSrHVEYK4m6vb5GycC+KZGb4vsSO1FZhnmILsYuLQTSsPhfAWMjieVRcSEBT5FrEKDUjSDmccOpEtas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 04:40, Balbir Singh wrote:
> Add routines to support allocation of large order zone device folios
> and helper functions for zone device folios, to check if a folio is
> device private and helpers for setting zone device data.
> 
> When large folios are used, the existing page_free() callback in
> pgmap is called when the folio is freed, this is true for both
> PAGE_SIZE and higher order pages.
> 
> Zone device private large folios do not support deferred split and
> scan like normal THP folios.

[...]


>   #else
>   static inline void *devm_memremap_pages(struct device *dev,
>   		struct dev_pagemap *pgmap)
> diff --git a/mm/memremap.c b/mm/memremap.c
> index b0ce0d8254bd..13e87dd743ad 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -427,20 +427,19 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
>   void free_zone_device_folio(struct folio *folio)
>   {
>   	struct dev_pagemap *pgmap = folio->pgmap;
> +	unsigned long nr = folio_nr_pages(folio);
> +	int i;

Not that it will currently matter much but

unsigned long i, nr = folio_nr_pages(folio);

might be more consistent

>   
>   	if (WARN_ON_ONCE(!pgmap))
>   		return;
>   
>   	mem_cgroup_uncharge(folio);
>   
> -	/*
> -	 * Note: we don't expect anonymous compound pages yet. Once supported
> -	 * and we could PTE-map them similar to THP, we'd have to clear
> -	 * PG_anon_exclusive on all tail pages.
> -	 */
>   	if (folio_test_anon(folio)) {
> -		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
> -		__ClearPageAnonExclusive(folio_page(folio, 0));
> +		for (i = 0; i < nr; i++)
> +			__ClearPageAnonExclusive(folio_page(folio, i));
> +	} else {
> +		VM_WARN_ON_ONCE(folio_test_large(folio));
>   	}
>   
>   	/*
> @@ -464,11 +463,15 @@ void free_zone_device_folio(struct folio *folio)
>   
>   	switch (pgmap->type) {
>   	case MEMORY_DEVICE_PRIVATE:

Why are you effectively dropping the

if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))

> +		percpu_ref_put_many(&folio->pgmap->ref, nr);
> +		pgmap->ops->page_free(&folio->page);


> +		folio->page.mapping = NULL;

Why are we adding this here? Does not seem large-folio specific.

> +		break;
>   	case MEMORY_DEVICE_COHERENT:
>   		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
>   			break;
> -		pgmap->ops->page_free(folio_page(folio, 0));
> -		put_dev_pagemap(pgmap);
> +		pgmap->ops->page_free(&folio->page);
> +		percpu_ref_put(&folio->pgmap->ref);

This looks like an independent change that does not belong in this patch.


Can't you just leave the code as is and simply convert percpu_ref_put
to percpu_ref_put_many()? What am I missing?

>   		break;
>   
>   	case MEMORY_DEVICE_GENERIC:
> @@ -491,14 +494,23 @@ void free_zone_device_folio(struct folio *folio)
>   	}
>   }
>   
> -void zone_device_page_init(struct page *page)
> +void zone_device_folio_init(struct folio *folio, unsigned int order)
>   {
> +	struct page *page = folio_page(folio, 0);
> +
> +	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);

order vs. pages is wrong.

In context of [1] this should probably be

	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);

And before that is in

	VM_WARN_ON_ONCE((1u << order) > MAX_FOLIO_NR_PAGES);

because we don't involve the buddy, so likely buddy limits do not apply.

[1] https://lore.kernel.org/all/20250821200701.1329277-1-david@redhat.com/

> +
>   	/*
>   	 * Drivers shouldn't be allocating pages after calling
>   	 * memunmap_pages().
>   	 */
> -	WARN_ON_ONCE(!percpu_ref_tryget_live(&page_pgmap(page)->ref));
> -	set_page_count(page, 1);
> +	WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));
> +	folio_set_count(folio, 1);
>   	lock_page(page);
> +
> +	if (order > 1) {
> +		prep_compound_page(page, order);
> +		folio_set_large_rmappable(folio);
> +	}
>   }
> -EXPORT_SYMBOL_GPL(zone_device_page_init);
> +EXPORT_SYMBOL_GPL(zone_device_folio_init);
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 568198e9efc2..b5837075b6e0 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1769,9 +1769,13 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
>   	 * the folio is unmapped and at least one page is still mapped.
>   	 *
>   	 * Check partially_mapped first to ensure it is a large folio.
> +	 *
> +	 * Device private folios do not support deferred splitting and
> +	 * shrinker based scanning of the folios to free.
>   	 */
>   	if (partially_mapped && folio_test_anon(folio) &&
> -	    !folio_test_partially_mapped(folio))
> +	    !folio_test_partially_mapped(folio) &&
> +		!folio_is_device_private(folio))

Please indent like the previous line.

if (partially_mapped && folio_test_anon(folio) &&
    !folio_test_partially_mapped(folio) &&
    !folio_is_device_private(folio))

>   		deferred_split_folio(folio, true);
>   
>   	__folio_mod_stat(folio, -nr, -nr_pmdmapped);


-- 
Cheers

David / dhildenb


