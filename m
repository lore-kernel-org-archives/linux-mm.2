Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68E4ACA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F488E0050; Mon, 25 Aug 2025 12:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56D08E0038; Mon, 25 Aug 2025 12:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46288E0050; Mon, 25 Aug 2025 12:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 931158E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:23:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 407C5118609
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:23:58 +0000 (UTC)
X-FDA: 83815801356.15.60FF85E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1F5F714000A
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:23:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VsHGDOX3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756139036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJ9VR6/AHZevQeWHrHcSWQbnm5iFaXQGfgpXOMo3AYo=;
	b=hjWg5sWbqgLLIyp60x1FPy+8Pe9DJjaKKy6kl9Q1A92xetygWc/VYzyCBJ4uNV32xLrVz6
	cDJOod3wDH5A3br1aWlvQnk1j5fMKHzi6xsqMmZYi1h4wC9L7DFkk+Lyw20lgkOdyzdqmc
	0oiTn9Sl0sQ72p0lXL3Ewg0PgP7jDGA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VsHGDOX3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756139036; a=rsa-sha256;
	cv=none;
	b=jbDaxYau8ms45LAQQJaEo0TCztm4Pqcjjq+aSQ2VIPdNrYBRSo7ZMr1sXwcgLLjk5qNbPc
	ps3W0a9EFENnL1IEFzMqoWwQ0BPiYP6Qtfd9XlLeeJn9J0R2YtOw7SefePyIgjZzeubJPP
	L+ZggO4TOWRvLgQO1MnL/xIi03t1Uis=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756139035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZJ9VR6/AHZevQeWHrHcSWQbnm5iFaXQGfgpXOMo3AYo=;
	b=VsHGDOX33VXOlszpqhvxaqkGEcifetePTHJ2MAdahtpiXd8/T3XrGs5jacxK5vV3szunef
	Pdm8ACMAY321UklkIuDQF+WB2ezknlSmWZ+n0vAO4VJSDzKqVAHv+pXZrnMZwOS0mS2N7C
	U9IxT2WerqXsUaL7i8PYV/qZ1Xq5cJU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-KH2K207fOV2XxLUWC1RxIA-1; Mon, 25 Aug 2025 12:23:53 -0400
X-MC-Unique: KH2K207fOV2XxLUWC1RxIA-1
X-Mimecast-MFC-AGG-ID: KH2K207fOV2XxLUWC1RxIA_1756139032
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0cb0aaso34959515e9.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:23:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756139032; x=1756743832;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZJ9VR6/AHZevQeWHrHcSWQbnm5iFaXQGfgpXOMo3AYo=;
        b=dY3sZyUjLuomp0i6wqDheE3Wer8ZTeFcOpiZT5cs6lc+Wug4F9dkeUQq/j7BWGokOE
         FSxuJQ20/C5vfGBocBPoJgveaCLsG+5upWQ3BpIv3PEPs5YPYEqxgVrkyXdEAvXOtbf6
         /f/eHuI3kz/xMXYJTZ3SnV0XJ8YR9zdbzMjR7L2EBHvV5xSgyDXv25RLcMF/aZTL7rdt
         gsi2VkaLnMFrSg4pcxTjNL4ZgA2w9VTX5jmjhQoripHSkLoaq2fKKzJ8trybP60GUwot
         cv9YLXWmI2W04rs8OccfjhGo59ce1nckD5ZQzVgqC62bH/R9Oz7M2vreSMV/egSipmj2
         5VDA==
X-Forwarded-Encrypted: i=1; AJvYcCXB8bsOTRfgXCCXo25XB2FtBgH4t/THtOOT27tvM90tj+JLgGIGh4TOlQjCv2fWT5tSOtn0PZJy6w==@kvack.org
X-Gm-Message-State: AOJu0Yxm+nLlY+6L3ApueozXqwGymSFsejZn38SLarl8Oq/gGMQnwsz9
	FEymh1gz6xcPnu/puZkfxHnKSuCXceoSPGzZiiCSGYYbOwawH+7Ao+8UXPdwMzfLi+4eA9PlOqB
	vfPwa2yObBkWCgEpA61V5+bPGNA7AqayjX7utvk2L3os/XKFDO6K7
X-Gm-Gg: ASbGncsQQ9bgb6fb0fpQA8IXoMmt74SF3nWloijBZyWfs4CT3VMlQVVrVgDZetPCveN
	pPx7U/12HspZLsEIqdhddta2NCE0ifWlQLMVTJPbQxQAbElckIlvtvGSiBNA8d6vIlGqAm+X2uR
	MYdyjIj/MORU0jLfI9C8BRCR+3iFAztaK12c8/Pp1CtiDqxPT1obOMoJuvvj8pj0I2gTmspTSic
	FXS50nmWxUqriwIlkWBG5nWBy8wpgWto5uLQSvwVVfqeA16+KoqAPLuBMfAYOupnGV1+ekOeiob
	aUM4GU+dVrBUXNu/P/xQRsd0ZnaICYZrq2vT6rmEzlYPtc1Gj0JNyW3K96UZ51Y1alc9su+6GAu
	mF0LkfP3jEEPwHQc6sFSMtNaiIfFLatZs2qkZjH8IQFmHLUwnetoNLvLyo4UU6QgOd8w=
X-Received: by 2002:a05:600c:4685:b0:458:bfe1:4a91 with SMTP id 5b1f17b1804b1-45b517c5551mr109881795e9.20.1756139031896;
        Mon, 25 Aug 2025 09:23:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwiDwmGl/nPb74qkNKdwOJy23XqbHKXC5/+W47v3i62q/hY+QH66S6ZkeqOx/rk3ktbwdSNA==
X-Received: by 2002:a05:600c:4685:b0:458:bfe1:4a91 with SMTP id 5b1f17b1804b1-45b517c5551mr109881195e9.20.1756139031315;
        Mon, 25 Aug 2025 09:23:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5fec8e80sm29037215e9.0.2025.08.25.09.23.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 09:23:50 -0700 (PDT)
Message-ID: <dbd2ec55-0e7f-407a-a8bd-e1ac83ac2a0a@redhat.com>
Date: Mon, 25 Aug 2025 18:23:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
To: Mike Rapoport <rppt@kernel.org>
Cc: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-11-david@redhat.com>
 <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
 <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
 <aKmDBobyvEX7ZUWL@kernel.org>
 <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
 <aKxz9HLQTflFNYEu@kernel.org>
 <a72080b4-5156-4add-ac7c-1160b44e0dfe@redhat.com>
 <aKx6SlYrj_hiPXBB@kernel.org>
 <f8140a17-c4ec-489b-b314-d45abe48bf36@redhat.com>
 <aKyMfvWe8JetkbRL@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aKyMfvWe8JetkbRL@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aBQdGbN5ITldwYsFnBA_1Nn7uYo3SVFe9xgqvWZDXrw_1756139032
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F5F714000A
X-Stat-Signature: bgrerf1mo9ip57p3yyhf19rzd6gr7gw4
X-Rspam-User: 
X-HE-Tag: 1756139035-424060
X-HE-Meta: U2FsdGVkX1+zHGYbUvnQL7FdebEiN42jkxedA03IlHkP99hBiHnqU+B7ALFkuD8Iji18+LtvstMnQD1OQw/gOn5j/frmd8vGtlc/mrF397nHSwirY7Ho9L+AMY+ToUb9n+NdwMU6Ss36gGVHn0DTsdffBVI4xR9ywIlX+ZTEGd4GXpgmezNv9u2Dp3+FQ9rwuOGCcYlyJHIxAp5nIvS4a5hJN6PP8FodAsmaTwMGbtvl6DM39Q/auHE4O5MOK1UcU8IeK2l4qXzUzQCSNWfZ4m+z0SqMAiMEaze3AS/+QIyQ/JlIpb+yNiC8kr02t1h3OmVUIkLht/wt3LDQez6ChopKDPBy1W9MhNUljTWKQpiw/Zv87JByyKtU11MwTMWyFrcVkLW1/dTSNMxYt/NQ7FdPb4kSDy3FlsAms2xPjKpNopPPGb1YVaVfDIqamhRalQRkczq5ysUcJ4ct+hEGvfFXek7hDLDkGgeOAsvUjQu2TJGTFTGB52ZvlaSaXMPlVL2JSDXAhoyT+Ki454KBtpaeuYJqlaoXAL6mBhKCi6IOEmFmAJjboDf57/LpTMGXET4tjpi4LVDRqNVV7F6d86s3+nhsHWou9xNSUrsQcuVyFCE5yKMpBPG8k/hZFJng3Y6pKmcSR7lh33ijqNFEWURdOYein5uKG2FBHsYTXmmVXEZOeVgcuFChYSCzFLbCAaYqZS6U1i+7e7pZald0KxiEvip9B0vreHbHFntjHBKzaEu5iBkCQtX7kZ/zpp5K5mKLdIxT282bbZID1xl4UF0CValLEMP3Bn0uzESeClz9UVRbxE2P3TOxRG0+K8rHSbMeD6jWQo7ByhT1qznoEhAY2NsEdwc1iw2D3nd4OxaSM90Cvrrc8Ih+azsL60AfFk6gJug5hsyVb9IV/mx4Cn4xvLdQsFT/ZXOPc31gLzxEPqJG1zJXhzLVyrFR7ORw6i6Jqq0288kLFtJNWfN
 EO9Il7o/
 aJOkHKa3gH2fH+jM3dwmCO5LLIltg1OcyP2OsRI3tY92Tsl8YoxP24pF8rK4z2Wmywq0N/UYqgVVHG40qhMbRXnjTtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>   
>> We should do something like:
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 154f1d73b61f2..ed4c563d72c32 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -1091,13 +1091,16 @@ int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
>>   /**
>>    * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
>> - * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
>> - * for this region.
>> + * MEMBLOCK_RSRV_NOINIT which allows for the "struct pages" corresponding
>> + * to this region not getting initialized, because the caller will take
>> + * care of it.
>>    * @base: the base phys addr of the region
>>    * @size: the size of the region
>>    *
>> - * struct pages will not be initialized for reserved memory regions marked with
>> - * %MEMBLOCK_RSRV_NOINIT.
>> + * "struct pages" will not be initialized for reserved memory regions marked
>> + * with %MEMBLOCK_RSRV_NOINIT if this function is called before initialization
>> + * code runs. Without CONFIG_DEFERRED_STRUCT_PAGE_INIT, it is more likely
>> + * that this function is not effective.
>>    *
>>    * Return: 0 on success, -errno on failure.
>>    */
> 
> I have a different version :)
>   
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index b96746376e17..d20d091c6343 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -40,8 +40,9 @@ extern unsigned long long max_possible_pfn;
>    * via a driver, and never indicated in the firmware-provided memory map as
>    * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
>    * kernel resource tree.
> - * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
> - * not initialized (only for reserved regions).
> + * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages don't have
> + * PG_Reserved set and are completely not initialized when
> + * %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled (only for reserved regions).
>    * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
>    * either explictitly with memblock_reserve_kern() or via memblock
>    * allocation APIs. All memblock allocations set this flag.
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 154f1d73b61f..02de5ffb085b 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1091,13 +1091,15 @@ int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
>   
>   /**
>    * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
> - * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
> - * for this region.
> + * MEMBLOCK_RSRV_NOINIT
> + *
>    * @base: the base phys addr of the region
>    * @size: the size of the region
>    *
> - * struct pages will not be initialized for reserved memory regions marked with
> - * %MEMBLOCK_RSRV_NOINIT.
> + * The struct pages for the reserved regions marked %MEMBLOCK_RSRV_NOINIT will
> + * not have %PG_Reserved flag set.
> + * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, setting this flags also
> + * completly bypasses the initialization of struct pages for this region.

s/completly/completely.

I don't quite understand the interaction with PG_Reserved and why 
anybody using this function should care.

So maybe you can rephrase in a way that is easier to digest, and rather 
focuses on what callers of this function are supposed to do vs. have the 
liberty of not doing?

-- 
Cheers

David / dhildenb


