Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A6ACCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 08:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB648E006C; Thu,  9 Oct 2025 04:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EA78E0002; Thu,  9 Oct 2025 04:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D1B8E006C; Thu,  9 Oct 2025 04:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 989E08E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:14:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F4A088359
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:14:15 +0000 (UTC)
X-FDA: 83977863270.16.5EEAFF8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id B8DE8180006
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:14:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K7L9V1kj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759997652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/B31lhY4bVYeZNnk+dMlfOVrRbTYtHHzwgcdMMaTVE=;
	b=qf+cmSkQmARsXOIZPscY0QBoeeX7YKKeoi5aqRVqDBGoSCGpU0oBM2ScuoLE3DBG+Eiv7r
	am/xMEeWMlkzQ5wx4F3V2k7gzVckXpr0UICzQsV0mDQ9g6JeVVpOROmpmeN/JF+2eFHzD2
	3AI2Bo//khcUAoc3WJtIlaeSXoLGctE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759997652; a=rsa-sha256;
	cv=none;
	b=ZuO3oIMaxcoFW7aEePvSHJbNKk7k+hDeN/A/zBn4EsiqPvovhEVbh+gooPqtFXpHwZ4Ivr
	WJKktRDB6S+MttlghlIL5/f68jwwscG90Z9UoKFln+7njQ+b8usNajjJ7bIisvIJ+YzGbO
	urOlUzGpUhK6NnBgpBRTYParav8r69k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K7L9V1kj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759997652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z/B31lhY4bVYeZNnk+dMlfOVrRbTYtHHzwgcdMMaTVE=;
	b=K7L9V1kj9dW5vqUmuueWgdYBdBSKp+ryH8YkpBfqezEEEBX9FHdAXR9tTcy9x24kuzeFk0
	slF1sBvjKgU5r+R+T1Y/Qh4ud5akhTGkArFHPyLnYW85Jixg8PClTd6ruZM3u3E7qC5Lk6
	DAiNL3jD3sZVLp0PqUb4RiJ7agoLG0c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-LOhDDzH8PMinj8a0UIHncw-1; Thu, 09 Oct 2025 04:14:09 -0400
X-MC-Unique: LOhDDzH8PMinj8a0UIHncw-1
X-Mimecast-MFC-AGG-ID: LOhDDzH8PMinj8a0UIHncw_1759997648
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e3d9bf9e1so3724815e9.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 01:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759997648; x=1760602448;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z/B31lhY4bVYeZNnk+dMlfOVrRbTYtHHzwgcdMMaTVE=;
        b=iYkiJTdne6iJ3lyouTidzK4w2geq7HgVSZJ6bsrmnOC1wTPn4fuKF3KneYUb1A99yU
         AWfBCTCZ0hzR1vHeU/o3cuT3QJRIRykcO0pbOSG7CFztR91Oo5qYRMJIhG7hP6mENVbD
         ZETheThEodtglP0BTpqhi8ZV+IQ5jyl+najphzcpwoBkr67r0CzrJy6AL1D6lP8yIrN/
         KWhhJ0X4AOTwiCptsztLWpucBbGODiNnr0T1u81lRgOA4OGw69a2h7ILPVh3dweUfXXB
         U3sRB2VI2FjjBRVe7+cCaWkDzL8AFZq2WjYKQAWNt5W5SLVoEayrNkSVcSww+33XAF1v
         Ugzw==
X-Forwarded-Encrypted: i=1; AJvYcCVMu4Y8QZ5K6kaIqr/A3Pn+ijXoGWjPtJfqO2eS/BM/JhnDovsMHsBV0cgU33QFOPE+8BPB+qQTew==@kvack.org
X-Gm-Message-State: AOJu0YyXmipCcA5g5aJSKW0JuuOG7ksTg9ugMQbvYh/7FpXjIit1OdEO
	79Us69XDVxi7RsBtH1WyFtzzOHeZyirN9pCrMJZ1+ZhTrMR0QsfQ3eDkjmN57EONYurzh1c4uCz
	+E9Q/twlS7NQGRUdpIVccj/GhI4xdMzrykZv/mEcJvXZ7RFw7fJvc
X-Gm-Gg: ASbGncujQ4DeX2TISCGaSQ2yvLS1u+LsHwdWjS2ymBiHk6F7MWXJR6qa5y2FwHnwv56
	kXyXHCWa1hdvQ9A8X8bPEKSKyC6hyGpJpTraoqxKVdgkq4vHZBcvO39/pWcbXtIgeuiC7eR8UWi
	3U6QusfiV0AWkfqZXFvT5A1ehkuwiLaTgHPKA1B+mS+wTHnsPtB+7rb8NQzNHgOlz0grekNuL7L
	gGKgGd15V+iFcTLAox8/dCx0pCS81pRQWnxUzfnyZs93yQzJLmL8nYZ3v0NlAp2wcBWUnpObdcw
	DLbRlWtg3ISnaIH+mjQIHU9aAjDMwD/CMZ54OXMp+bqKRwm11gs9C4njpGpdTAGM/YSuEyTBrEy
	wQ3K5sGwf
X-Received: by 2002:a05:600c:4750:b0:45f:28d2:bd38 with SMTP id 5b1f17b1804b1-46fa9af3095mr47092945e9.18.1759997648105;
        Thu, 09 Oct 2025 01:14:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGo93r/upxlN0XWroa/gVbVuSE1HI9H4cBHGhOGnkYv+FuHkp7MlpzQ4ByJt+h+2JF6rzGBiQ==
X-Received: by 2002:a05:600c:4750:b0:45f:28d2:bd38 with SMTP id 5b1f17b1804b1-46fa9af3095mr47092215e9.18.1759997647608;
        Thu, 09 Oct 2025 01:14:07 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d6fb41sm71628175e9.17.2025.10.09.01.14.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 01:14:07 -0700 (PDT)
Message-ID: <9361c75a-ab37-4d7f-8680-9833430d93d4@redhat.com>
Date: Thu, 9 Oct 2025 10:14:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (bisected) [PATCH v2 08/37] mm/hugetlb: check for unreasonable
 folio sizes when registering hstate
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
 linux-kernel@vger.kernel.org
Cc: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-9-david@redhat.com>
 <3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu>
 <d3fc12d4-0b59-4b1f-bb5c-13189a01e13d@redhat.com>
 <faf62f20-8844-42a0-a7a7-846d8ead0622@csgroup.eu>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <faf62f20-8844-42a0-a7a7-846d8ead0622@csgroup.eu>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PgOwRqdYxY3zGPoNdzXaqO0174QLwHcjt5JkWJb5ju8_1759997648
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: zhuitqaasmqfk37pcsn8xnjzasmf85cs
X-Rspam-User: 
X-Rspamd-Queue-Id: B8DE8180006
X-HE-Tag: 1759997652-455215
X-HE-Meta: U2FsdGVkX1/PSbQ9pUomW4tt7sa94K0jIBXCKnfB2nYd0aLYUXYj2MI0bKbFU+qFXN/4VdrgXqJAZxo8dePxsZtxhn+d+nUHuPISsg2pp99iIu+rt/tAjx0nEStNplcQXhA4QWu3dzUyw2Nvk7HgN/xhojjZ/Q4uTILbtdSEYuICWMx2fQGbmiof9w+aoU7Se0BMQRrxolTZLp27xAyzULBmRvCvds2wcG+S4KTBssJHI/L/+9avlmoEZ8WBRF3w+3+GTAiAc1vcjxe8idQHWUGdnh7ZcQzdEhZqEA07D9G/AvImkg/f3vInnzfAFGKEwEZrYgA7QLTzrXx9rDi7TAX/YozBLsNP/6zOdErgufZ2HJwWRy12DNjMrQjTPshru/Lrn1uJFWKwhhNydRVVG7aSdDZ3mL8SV8yL7LOyRWU+tCBblFvupaBi2eTWYPJpgMEyROHbl8suYsySCYDDoUGZv15ywIn0mpmaBHZ7nXlktIKqkUdz+ws5gSFJuehZm9M+70L4UwhB7BA3SgXnSbwBrAGf+DOohbSIbIfd6X1TEylVRGTGjsAoBe12GzGkLa2+f31o9KwQyS0p+8NexkH2+qw12RdyrrChupah6iHWBiv4OmL2ChPQ0qkMgQOdZxNGD7yliz5p2pxBAYO6ExKzJ09xQlfWSm4+iU9wykv5ociq0p1OKDyDtvyL+JxluMIsgvJ+q0edGw8TbSnqvZgQIgCIbAOJesvRW7J9LDPOvJyC7G/G7f16YvxyrEE7ZQ3Jv0O3xJNl78l96CO6sC671GT0Xc9BzMEHwyi6aReS+dZMgNF9JI4RyzF1heT3JIXmCGnRxi8RTCxnCSzcWncTSRGzOk5clpO9WAq2XBukmZyvgM82cJklNdC6OxXjUXfpLO52ZiihBnw8aLVaIxxYSdCvAmO9ic9QwbdydR6ILXkVSCkFmq/pTZ6jA7GbikFC3R1ksNi6IqBdRjo
 7/RFOBhI
 2Kw216rWh4la/YMok3/Gv11FhHYPaecVwtLCq3MQ86P58st8QJK2PrGwsHb+qUGnnOacpqQDk+gPZmns1F7q2ag1ezxyvfdgZVvBG2xIM72sMIvgUIUYh6ZBTkx/DDxcy9jXpaq30iZnYEzijruFEXW06djVwx6FC4+0FTgmciMZPLZ/MHdsdDyfX6Lm1pPAwu8uewY1ejK2pm1pFmQu6N2kXU9WP3uSJjS5EZzxif8+xebCnBEd9JA4BYS/5JtbPfOvhTcFNwcHpkU7ARZY3k4I6uXfc4pxcTLp/P/IMrhUl4/IBjiY/SYva8S48xN1S0NUOuPyM4VlZXOlW6NBJtxKXD0UNLlGQmBzJko3xyUTj9fAETpIHMyPU90LtjkgdjHSJJcuHQsyLsRhsIscGgXCkE4f8Ad0b3TQIrWE7tVUtEiWRuf4JA8uhPcPOmkoPa6Em57iXh8cdXfLMWd0AsVHTE8po0gjpCiqGc1cr/nW6z5D54MbOUYOoagK0x1FbTWCSdpK5BPssLksUsBkhQl7x44PbIIojCrae
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 10:04, Christophe Leroy wrote:
> 
> 
> Le 09/10/2025 à 09:22, David Hildenbrand a écrit :
>> On 09.10.25 09:14, Christophe Leroy wrote:
>>> Hi David,
>>>
>>> Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index 1e777cc51ad04..d3542e92a712e 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>>>>         BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>>>>                 __NR_HPAGEFLAGS);
>>>> +    BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>>>>         if (!hugepages_supported()) {
>>>>             if (hugetlb_max_hstate || default_hstate_max_huge_pages)
>>>> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
>>>>         }
>>>>         BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>>>>         BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
>>>> +    WARN_ON(order > MAX_FOLIO_ORDER);
>>>>         h = &hstates[hugetlb_max_hstate++];
>>>>         __mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
>>>>         h->order = order;
>>
>> We end up registering hugetlb folios that are bigger than
>> MAX_FOLIO_ORDER. So we have to figure out how a config can trigger that
>> (and if we have to support that).
>>
> 
> MAX_FOLIO_ORDER is defined as:
> 
> #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> #define MAX_FOLIO_ORDER		PUD_ORDER
> #else
> #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
> #endif
> 
> MAX_PAGE_ORDER is the limit for dynamic creation of hugepages via
> /sys/kernel/mm/hugepages/ but bigger pages can be created at boottime
> with kernel boot parameters without CONFIG_ARCH_HAS_GIGANTIC_PAGE:
> 
>     hugepagesz=64m hugepages=1 hugepagesz=256m hugepages=1
> 
> Gives:
> 
> HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
> HugeTLB: 0 KiB vmemmap can be freed for a 1.00 GiB page
> HugeTLB: registered 64.0 MiB page size, pre-allocated 1 pages
> HugeTLB: 0 KiB vmemmap can be freed for a 64.0 MiB page
> HugeTLB: registered 256 MiB page size, pre-allocated 1 pages
> HugeTLB: 0 KiB vmemmap can be freed for a 256 MiB page
> HugeTLB: registered 4.00 MiB page size, pre-allocated 0 pages
> HugeTLB: 0 KiB vmemmap can be freed for a 4.00 MiB page
> HugeTLB: registered 16.0 MiB page size, pre-allocated 0 pages
> HugeTLB: 0 KiB vmemmap can be freed for a 16.0 MiB page

I think it's a violation of CONFIG_ARCH_HAS_GIGANTIC_PAGE. The existing 
folio_dump() code would not handle it correctly as well.

See how snapshot_page() uses MAX_FOLIO_NR_PAGES.

-- 
Cheers

David / dhildenb


