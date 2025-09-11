Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39607CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 12:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F587900003; Thu, 11 Sep 2025 08:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CDA2900002; Thu, 11 Sep 2025 08:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6951D900003; Thu, 11 Sep 2025 08:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55048900002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:04:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EECF4140451
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:04:33 +0000 (UTC)
X-FDA: 83876837226.04.A316A03
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6E9D0A0022
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:04:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BEICEPI+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757592271; a=rsa-sha256;
	cv=none;
	b=5s59w/Cl80lle0pF3D3iPil56mNVx5thAySEIBohxRmjhTDf723ubK2bxUjKVxx4Ll6vkU
	xzrDb1pMZWYhzD3SYlamPo/Mi4KJD7hKk+YZi5dKae3kgjlqRwLxgnRIf8Zy7DFrb/DZ5L
	w9fMQ3ymIAi7r7twOwokvgV0g7HtlxM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BEICEPI+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757592271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuZPErlVPfP4Zi7OehwAoScM8rfscgPVz8IjeFSlZfc=;
	b=j4y1pdaMObAR6f5HGopxRC0yHiTx9Rc45KZKpJ3qv9phEJkpDmEw3jDUUETnfjFExUmbKr
	N74oqAcKtoGjK1kY2Ay1b9sgHilyU8EmDnraqDsnZ7PFEpGE2FkY3W5O7xAXY7nNtCGVbr
	3Iyg9ZjxE7y9O7Z82prTc3RLsd/vZr8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757592270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EuZPErlVPfP4Zi7OehwAoScM8rfscgPVz8IjeFSlZfc=;
	b=BEICEPI+XKEA1tgJ61XnCtifDdNA0RJaEhVHg29X8Jyr5qs1Wv+sDcCzgWLKCp9JhVzO90
	6Uz977rR0LxC9CTD5IjrmA+4B1llAZnpQIn5Zv5ueAoNUru6FC0UW6DFTBMaYRNDOGc4Ld
	t2IB/ET8P35zeVNZ1a8Q+rqgEgNNLdA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-sRovzYWZMXqCkifG6d0jGw-1; Thu, 11 Sep 2025 08:04:29 -0400
X-MC-Unique: sRovzYWZMXqCkifG6d0jGw-1
X-Mimecast-MFC-AGG-ID: sRovzYWZMXqCkifG6d0jGw_1757592268
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45e037fd142so4709365e9.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:04:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757592268; x=1758197068;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EuZPErlVPfP4Zi7OehwAoScM8rfscgPVz8IjeFSlZfc=;
        b=IZPjgX82s0+ywVwAEV0d8xKKyJMnTt+t6sY18G4SoNw9u0hcwd3ikpUac95SPFG39m
         hEUN3xNLc07Iva3lAthZNlTgaVFi+wtnX9lzvd9/XP1Tuy2XF1s2v/WJrrM+IDnngX4B
         OjFBjzhIFx9BGlqx/EvNHkVn/5sIzMsVZ8LckB/94avXPJl2nb7sxI8LTs726rkn9opX
         4VotkPOyCnz/5kHRA3D3sQBscqzXtGvdjutPHYHuP1wJShlQR+wtWTIPGLX1Gmv5K26C
         6RYxzTQnDhuPy5O/KqmMa33SOBSZCY2e8bKeZ27s3VUGYn5mPCL5RGALgurmN+ZJaeCc
         07jg==
X-Forwarded-Encrypted: i=1; AJvYcCUsBTc4jFwpI8LRkGDqRePP3xGnV4nSgIzcWLDmUYZfUPGzaUxRiSWvP02UgHL3wiAyV7HkImMQ8w==@kvack.org
X-Gm-Message-State: AOJu0Yx88WjKoe8V0jvJhJrwLl+ToDkGPfUgVm+u8/rQuTqtX+kLM67n
	faoQqjYgHVGE6fOZ0bsFOEB/vA7aftc3V5nPL2IHgG/PdBEx24uA0Uy5FHYBJWufrXzNkVN5/uK
	AemnDf2y4tWX1FU9HLf+2N802d/ZI076cFluzwKywRpI2cd26kAeQ
X-Gm-Gg: ASbGncvZE4avQtOfgj9nhxa2i02nNqIzvYK/M9MVqRDxVZeciOhGJVXDipIsCrd5/oo
	4NyPgL/rjoIWL9gJkUk22AfbAZ+DS19Mke/f7QdkHDMpvXIXF1kCYGK5a6cemZhGKtIq9TPqFGt
	cUihRqvsF40lR1P8aupMJ1KdpL1LruWcx5oYyqIWTuFxzSX7eXLxQobowfOUgsT0RComR9oqBUG
	qMg/xgtkoJjK/925aFNjiXHU3ILNf6u7PkEo1x9mnq16DuR33EZbtdOWZgZUssqN5Sv4ZTe3yyF
	jWouGHqvN852suy0XUhe8zcBw90UJ5CB3IRbQoqBfyOtcoHjQptD+ulPIfeatcpgmo7vlnbI/VK
	MfREYCavmRKORHQAk3S05tQ0z2oA4cFRc4JMdL4+fXlHr4DiUdL2xM13pzo8xzuvi+qQ=
X-Received: by 2002:a05:600c:17d8:b0:45e:598:90b0 with SMTP id 5b1f17b1804b1-45e05989245mr12298495e9.9.1757592268210;
        Thu, 11 Sep 2025 05:04:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8gojWv48o7hPnSlLmGoQLH2lzL/OCbhuDjeyev+XCC7h++EYG0R0k7MthrD+iGwxnZwbgRA==
X-Received: by 2002:a05:600c:17d8:b0:45e:598:90b0 with SMTP id 5b1f17b1804b1-45e05989245mr12298135e9.9.1757592267679;
        Thu, 11 Sep 2025 05:04:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0187f0a7sm13295915e9.3.2025.09.11.05.04.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 05:04:27 -0700 (PDT)
Message-ID: <6f1857b8-45db-4017-b6e8-02ecfa2104a3@redhat.com>
Date: Thu, 11 Sep 2025 14:04:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 03/15] mm/rmap: extend rmap and migration support
 device-private entries
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
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
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-4-balbirs@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908000448.180088-4-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8sybpQzU_dN_RrpFo68-QoL8jY7F4Sxz1IgweodY48g_1757592268
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E9D0A0022
X-Stat-Signature: w1nkr6pq76sx8x6qw7gga1am3yzzdafc
X-Rspam-User: 
X-HE-Tag: 1757592271-803135
X-HE-Meta: U2FsdGVkX1+/1zSJ/8vjETfJd1llNamzvF7gyj3aZtGgISOu0Ru+i5DHlJIIZBBxs/aNmAL0NDdPRRmDhg6Q1KPeeuOjRHNjOEDsgDg+LiJhbOxqjub4x27SWSUbp7AcxHYhAtRhBbL6aMgBjqXecjvWhW5gOrJotlnOJiRq0i6PwqY8YalXOsYTTazdqbCm1gvRn3ZfILYEtRsy0TrNNSQB1GE8No5E6vkbJZKmH4EhZloDE68hqHW3r3tVipztYdfv97Th3rUbCZycYmnOHUjUVSEQk0ooX+AIqlyvw5jNk5GzHIloLMVL4ndl9WhFkSj+6AIPWkHe1IS9191cIZ4Gvm3k8k/Pn3B2829hpwwN99bIUxMeLGluFix0n3F2ByAmW1LMMJ3H7XmFsiGEB20xIYIZiVvhzvYfcGuRLRKv1da2wLvW0BBNY+934wxRocJQH9++3IR6LbKo6YXBEUTwgYVIipvjJg7kcKyibLuMUbYbvTtDTRXBEn2ChhQbkVPfdS3tzaiE9d9/1LKEVLSJuDnE1tA3e9faJS0tmUdfniL5Z8vd9ej00zzavI6vDxzisLzswW8pvJiyvgxuPRXNyjoYCeOGCpHO0G8o5UF3iBPZOjXzIoNyeKYqKdz4fBII8mmuZmVXlpKIe0D7Z/sEH3kI+euKGmwmC4PlDJnyaSk7AeXgGG9KPTGz7J29qSkpIhLNux2SW1vXkkc5+fhVMi8dBf1L2dGOH1Leh/98RC4nkBXcyhPsB+4kkab3u6kKxPbFnfozChn0pwMD0lZDTana6qHF4ee57HESd9xnAuGc0keys8u/4ngCZn9851bG5eyu39PSU9pacmQQxTHQx88Q6sB58YxsR1LKNhL0Zl2TJ7n2tx1DjUwU20J4MOS5RBOgzem6BjwWb3Y+HHU7SV6KTgtKUC1nkwGWCXVNP0Aya9mUd5yoqswZnXbP1J254NONpasiqC3GypI
 O3Un2t29
 RbyhNXd33fol+MYnRMH0jvBfYgWCG/+S1iV1TRfcurCxIJMZ/HHxtBG9axu+HyFhiOHlNMOaoRRrKtYcxiYskxzMtM2H66kURUJdB4m39ZOUIuIh9Qe6Kff56vxl/d1gq5JWKy/+04fpCAn/+MB+BeTLIpXiK45FpJYKp7ttSnyD7CweDTYuhW4jgeRGabzjVmWxiwOJrSvyeN57tLha2Y9IKmHqa1weK/AwAC581HwR6Vgmqo7539o0rf7GnKjjS5uFYD28RnocMUPHhKvHrxR4tcDXnwMgmVvvQsdm9eDvlVj7aA/J4p3nvJWjGA7eb404WEuwNGEZIRIVO6IftKX9glXvN6Knc+nsSutTBgNnGvK07WT217ngpc0HRYAOCo661/McsrtyuZBK9aWeAnD99ShqyUEcvjIj/SBtqDzGT7BzDL9ZDF/qzrTiNcYj7U/K3OAFldtRA6qor1b54+8jgmuzlxHEcgWYZoJuyfX5eBdq7ZgS/o5VxkOy1zMaV6vJXlfZCF9n6RSW75hLhYTWfxcl2UrVq/zf0KecaRapFKL1sI7vwAYgQXwQk22GDBMLZmVUrS0q0p60ng2FhzTnZLZBQCpX9uafIafKHxwqz2nbaUAHDDyrTozIrdEm4WEISk+Z3vRHShWI2WUeBMlLxpSq8QaT5aSB/bJKi9cb+1caZpRvLZNR/qP+AsEa84rqBsXUDUZJEFu6NFVL/hGIJ1bfn8PpqlJIX4+FL2OsTFaMVQ6Asbrn9UMzbX6wz3KJtt+/AKWVXSwOKyh9Dv6d+7gMlZUPOg2ECPryPgCHtBTNA98ch7td5mveDwj/9qXJVZ86neNN1bPw2ibTB5B+FmsWONsqeoYlDb289CSNeaf8iIhQ0XtKnhFTZ2JJ0eEVG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 02:04, Balbir Singh wrote:

subject:

"mm/rmap: rmap and migration support for device-private PMD entries"


> Add device-private THP support to reverse mapping infrastructure,
> enabling proper handling during migration and walk operations.
> 
> The key changes are:
> - add_migration_pmd()/remove_migration_pmd(): Handle device-private
>    entries during folio migration and splitting
> - page_vma_mapped_walk(): Recognize device-private THP entries during
>    VMA traversal operations
> 
> This change supports folio splitting and migration operations on
> device-private entries.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---

[...]


> +++ b/mm/page_vma_mapped.c
> @@ -250,12 +250,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>   			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>   			pmde = *pvmw->pmd;
>   			if (!pmd_present(pmde)) {
> -				swp_entry_t entry;
> +				swp_entry_t entry = pmd_to_swp_entry(pmde);
>   
>   				if (!thp_migration_supported() ||
>   				    !(pvmw->flags & PVMW_MIGRATION))
>   					return not_found(pvmw);
> -				entry = pmd_to_swp_entry(pmde);
>   				if (!is_migration_entry(entry) ||
>   				    !check_pmd(swp_offset_pfn(entry), pvmw))
>   					return not_found(pvmw);

Why this change? Looks unrelated.

> @@ -277,6 +276,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>   			 * cannot return prematurely, while zap_huge_pmd() has
>   			 * cleared *pmd but not decremented compound_mapcount().

Reminder to self: cleanup compound_mapcount() leftovers

>   			 */
> +			swp_entry_t entry;
> +
> +			entry = pmd_to_swp_entry(pmde);

swp_entry_t entry = pmd_to_swp_entry(pmde);

> +
> +			if (is_device_private_entry(entry)) {
> +				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> +				return true;
> +			}
> +
>   			if ((pvmw->flags & PVMW_SYNC) &&
>   			    thp_vma_suitable_order(vma, pvmw->address,
>   						   PMD_ORDER) &&
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 236ceff5b276..6de1baf7a4f1 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1063,8 +1063,10 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
>   		} else {
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>   			pmd_t *pmd = pvmw->pmd;
> -			pmd_t entry;
> +			pmd_t entry = pmdp_get(pmd);
>   
> +			if (!pmd_present(entry))
> +				continue;
>   			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
>   				continue;
>   

If you just did a pmdp_get() you should use it in these functions as 
well. If not (cleanup later), do a straight *pmd like the others.



Apart from that nothing jumped at me.

-- 
Cheers

David / dhildenb


