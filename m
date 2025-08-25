Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89B2CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 18:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12DE58E0062; Mon, 25 Aug 2025 14:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105A38E0038; Mon, 25 Aug 2025 14:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C338E0062; Mon, 25 Aug 2025 14:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2C678E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:32:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1E92B9C5C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:32:39 +0000 (UTC)
X-FDA: 83816125638.04.4B8C8EC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4F4C818000D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:32:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QaLwgUM6;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756146757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bluti57k39MttADONVHVsAxBvXyqb5R7ZWo2ok70EgM=;
	b=oQyrHhtGlxWNAl+kXNpU60CMGsmspmbU6AEJ+roTWk9KhJ5u98jG+OdzSsoKCECBfsSpEl
	cxR5Z39aOIyDEouOaJWpOrm8sP3cp3BqA59nnuedtnVcifKIe6EJtCVuTre7BqcnswfLXm
	SLuSRTcJDjttrbFTODK5bFKYHv5Xgvw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QaLwgUM6;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756146757; a=rsa-sha256;
	cv=none;
	b=vrVZVnac89UvR9buKrQua4/hpvBg04hGyZtJKT1KzsnYirp0/HKD86iauTItbGXubc8ezh
	xe2kK9vfwvPm/cDfBtB2to6QrIW3hF0/jV3mnwO6jrVjcdLhJBTGKLih8CG36tiNpjkFMg
	sCqhTDmyeJ/VHs+HQMb5mcAPGwNoDbE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756146756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bluti57k39MttADONVHVsAxBvXyqb5R7ZWo2ok70EgM=;
	b=QaLwgUM67P0pBnaSlF9vPnbSSsU1jQ5fdcdb836XP332LaK56RqlzQ0LdHEXkMzIiwfdmA
	J20fW4Qj+4j2DKlTPDDhqd7SFkzXCCD7UPwrTttYN6gmDuEcZnTOuHoK/5kiPSiEgxCRlz
	ayUbNNmjYi6wd8c2NXkTC3Op0q2JugM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-H0ih5HVwNBGljUlhHAQJCA-1; Mon, 25 Aug 2025 14:32:33 -0400
X-MC-Unique: H0ih5HVwNBGljUlhHAQJCA-1
X-Mimecast-MFC-AGG-ID: H0ih5HVwNBGljUlhHAQJCA_1756146752
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b6490ea91so2323205e9.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:32:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756146752; x=1756751552;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bluti57k39MttADONVHVsAxBvXyqb5R7ZWo2ok70EgM=;
        b=tDRvbpTYi9ScIu+dqqMUTKUR3c6rvOC6I5yf8AMunszjjpXvgATA7P4j1i7Qn6P54l
         x7ApDuwGmSHGwdPbLzYZf83E5UH7ep2LNkTgB1+zlVj9HJERmZYCT8tMD/ndAelToyWo
         0oyQkIrQGb0AMcWya1uQPwhLTv0AscanYynwxFRblo5L+v2s23dWs4E84Py/Ns8hkimS
         vdtyTWLnLrYFFR1qnGDCVhjW1Rt01jMGPAcAGIN5NP0NqLKvnFKqY96eb5FggY3vfoi4
         EPUTWsl15Y4uNh5pp9E5gShjX6WovXyhFdeh/e5p70wj44D5x7qzusKlKhwtoQZQU0aj
         9ogg==
X-Forwarded-Encrypted: i=1; AJvYcCXn3PjRHR2ce+X50jfFFmPCBdV+ZYnjJwnQuGJ2uLxKfL2b5fbDpGYRCBPpTHCvM9Dzl3lq1LrHeA==@kvack.org
X-Gm-Message-State: AOJu0Yw+uRm+9SZP3Jgu2XlMSEVjA9Sky+KP6QugHPhw7zD75ar9gKHL
	08AIsKgwi18OfBVJTRkmc28Li/tqZ1446ZTgETFe5dV7p7Fg4+ODVqwIULJIawcKXQn3TmFwRYm
	Etj6EGrpuhFrrISkGVfs4vJ+Evi28+elHkYOhf0Fmp5pezkZ4CKf5
X-Gm-Gg: ASbGncuMYvlIHLlXqC4GBkIsgqUV0MO8/BIWAWlbZWCTSt5jQ+Y1CG7JsAthtgOGyqi
	MHeQbFvYS7dRA2YhH8MdHGtMXx1wJ5f0FUo4eF18ovVSAVMhoXucdEvYAOKgaaGXZwFchvwCFXL
	rw7aqzb3eCVsKPZov6JbHIWgGmJLaffPJkDXxKbMpKWxVvnm83GpruhyA1aGFqukgaPNWenALTm
	RTpN/sbihjIaCfBllcOkTBOlpBWtcCSALj4FlnujL6cUrcocle2rGoAStRjOucCXxiF29KEFj/0
	p+INVaK5fbkfa4cw/SgIkP3XP2jOgNr22uTgdLDZy7KDXD9vzWetTmHXg+7hIsK27pmntJ+JbcY
	rRC4T/sjpaDX2br/ddT9A0RkGqWTzoWB5lVMzNmI/g7Jw9/N9dil5Fk2h+UVJ2g++dwA=
X-Received: by 2002:a05:600c:4e90:b0:458:a559:a693 with SMTP id 5b1f17b1804b1-45b517b957emr126710875e9.18.1756146752244;
        Mon, 25 Aug 2025 11:32:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxuQzAylX90vNEmmjxyPSaWFpv8tCbOTWCm8WazHqaDOnMAPM4HK8CKvM3oYkR/BEIZaOMIA==
X-Received: by 2002:a05:600c:4e90:b0:458:a559:a693 with SMTP id 5b1f17b1804b1-45b517b957emr126710235e9.18.1756146751795;
        Mon, 25 Aug 2025 11:32:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c7119c4200sm12481975f8f.53.2025.08.25.11.32.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 11:32:31 -0700 (PDT)
Message-ID: <7ffd0abd-27a1-40a8-b538-9a01e21abb29@redhat.com>
Date: Mon, 25 Aug 2025 20:32:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: update kernel-doc for MEMBLOCK_RSRV_NOINIT
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
References: <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
 <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
 <aKmDBobyvEX7ZUWL@kernel.org>
 <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
 <aKxz9HLQTflFNYEu@kernel.org>
 <a72080b4-5156-4add-ac7c-1160b44e0dfe@redhat.com>
 <aKx6SlYrj_hiPXBB@kernel.org>
 <f8140a17-c4ec-489b-b314-d45abe48bf36@redhat.com>
 <aKyMfvWe8JetkbRL@kernel.org>
 <dbd2ec55-0e7f-407a-a8bd-e1ac83ac2a0a@redhat.com>
 <aKyWIriZ1bmnIrBW@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aKyWIriZ1bmnIrBW@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EuU2SPI1OlBRmzsy1tYCxt91ZVmR82ijer68qkE95Qg_1756146752
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: stz44weodj5rqa4tbm5eowq1g3yf7hrt
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F4C818000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1756146757-259631
X-HE-Meta: U2FsdGVkX18wZPuHCEPx4BBOatmTTXwGqlct6IRmOVuTodmHF+Xy/iZU2G2R882aPtI/mGy6cUs3hNFJakfanQon68aQmm/XdBDzEF7aZehtNppmwlRbsdkrVorgo2RkJBlKplIdBiBED1Yk3GjmOIBYBr5r1TZ38p7nE37U2OiK/Y53fWbISD7xyoCq24NGNVHLRLDJCnZn1u0+5WMhhSuQUgW3kHgQpos7qlUV5YvSHonvi3OpngBqk+0mfn2sd31+2lYuNdwsuQoHCCKnSB3+JZ5KxRjSK0uyC/vFwgff7PyAHg6B7lqwm5zvVTi0rzdx/YycAxv12edka5Y7XM512nztV8Sl9XtZ0Cnw+mEWXJk7+gq97pz2MeItdZMNozmvKABlwusyxmjSt02BYCgYVvVg8/q8YaR+GSBdaTOjjwxRnEQF5Oub45w2B17ToO/6B9D3MQy1Pnvr1D/CiPsUupPWm13Oq7QcYzxTXdphge+LcsP2ZU6PO4oZcLNGIYPnIAx7I2XLsbpqmyzLztf9AMOEOAe3bbGMl61lZJrbtWR+Lhw4/zQc2l4RrFJAqKJW4ZOMAoi7n56C0Xt/yxCIAOmf6E7B56un8G6i0LogwTY0G+ea7d6QV2V9yW0hMccUODWh15g9YaN1c7QLWXBgHRaPDywzs6WH76cNhGV7uc0Q+3KePUrChu/1iiARTb9YRZWLmYtAe8zeVOpded6slDaHAacvpaDEjNC46rJXNV/kOMdPc6D4ae9eb6mejB2+LMfCLVbov/uo+lWzOOauHYjSGfntfxFT8uJfEZvTGqVRa5oKBMMzU8gI/5li0c7wXRTvjBTArUSXK5tRu4kCpzEFeDo8n12kGboJ0roFZUyp7KQVy9b7ZlzS/+kD/7kES49NeNXuyou1pDXZ24wayhGhZIV5vaBuAC56Rwr8f9Sgz5q2g0eluBEQZzfEo2/EKU3/Lsa0PwDv0gC
 QDDWAgkO
 xVcv6cGIgAZZu+esZL/qa/k1ROne6OvAKZSD93xjnYL8RKnihgDwKnTzEBbrt8BBYZsvlFtDOw5zllIF4gGpkHfIkkpSCNA8L3NEF7Gsnu50ONb1jkULU7ZGw+8hosHhXzrob7ay4JfeAhYg1x+Tejmt8f3rH9tUWk/LD1Loqz1705+pZ926430Rf4556MmAVUykmHcCvJCz5maYb0o467d+tkJqc42gD3GOx8GjrppVogKmcy318/UKJXriE1bwzczqwwuPFReSnKUjVE6//dZiuiDzxVZjdmskVJsF3JqGHe2F/h6BVG8uwM/7gnDOk83g75SUsjjlv+XHhZl5vyWIEPXJTLpbEJEfXETA25rJx5nus+tKABV5lIRk3DHEtn3utan/2Iuj91oWBQhxnAZ4o/xvWL7aw7U+FcuEaL8XWAcBgCqdVqvi9kuZWGXMEDmF7FrNHloiqhP3Lhx3kDIEh8GhKpslii+bK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.08.25 18:58, Mike Rapoport wrote:
> On Mon, Aug 25, 2025 at 06:23:48PM +0200, David Hildenbrand wrote:
>>
>> I don't quite understand the interaction with PG_Reserved and why anybody
>> using this function should care.
>>
>> So maybe you can rephrase in a way that is easier to digest, and rather
>> focuses on what callers of this function are supposed to do vs. have the
>> liberty of not doing?
> 
> How about
>   
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index b96746376e17..fcda8481de9a 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -40,8 +40,9 @@ extern unsigned long long max_possible_pfn;
>    * via a driver, and never indicated in the firmware-provided memory map as
>    * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
>    * kernel resource tree.
> - * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
> - * not initialized (only for reserved regions).
> + * @MEMBLOCK_RSRV_NOINIT: reserved memory region for which struct pages are not
> + * fully initialized. Users of this flag are responsible to properly initialize
> + * struct pages of this region
>    * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
>    * either explictitly with memblock_reserve_kern() or via memblock
>    * allocation APIs. All memblock allocations set this flag.
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 154f1d73b61f..46b411fb3630 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1091,13 +1091,20 @@ int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
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
> + * not be fully initialized to allow the caller optimize their initialization.
> + *
> + * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, setting this flag
> + * completely bypasses the initialization of struct pages for such region.
> + *
> + * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, struct pages in this
> + * region will be initialized with default values but won't be marked as
> + * reserved.

Sounds good.

I am surprised regarding "reserved", but I guess that's because we don't 
end up calling "reserve_bootmem_region()" on these regions in 
memmap_init_reserved_pages().


-- 
Cheers

David / dhildenb


