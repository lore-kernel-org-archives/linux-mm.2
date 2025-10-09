Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 275EECCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 13:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6D28E0090; Thu,  9 Oct 2025 09:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE698E0002; Thu,  9 Oct 2025 09:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD688E0090; Thu,  9 Oct 2025 09:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47ADC8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:05:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDC9811B051
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:05:18 +0000 (UTC)
X-FDA: 83978596716.27.5EEF8B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 611F914000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:05:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tpz7N4jz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760015116; a=rsa-sha256;
	cv=none;
	b=fFr6wdOrJArVwAEb8+fxZV+8xei5zIXIhmi1hTpFSgDSRUQvu+deNYlyLAtvcULg8tD4Xg
	RRS4p50U4B+aw1f8TCy/yBuf8+pd/4EpSFuG6IO+WsuQd1XZw4pukzxWKIYbdOmaf8vFJf
	1rNgp5jFvbj/fYvGSwkCKdgZycF8Gvw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tpz7N4jz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760015116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTHo4iuJRNf/FsWLVapxfI0HO0lapgIr2CMWX1RNMGw=;
	b=IC8gpTJffieDEZFMbh0USWSpOKVKTEmCzQK83T8bRNmRm+8SkxM6zrHK3mq1lqMzXk1ccD
	kOEy4RJJhqNNaakIjB+ttiDHc8UADysE/ihaf4kcd+yUxPxdCieRhtupGUSFdNb4THGfw4
	A7UXJTgzizkd5HAXikJUOBiMXALA+6Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760015115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oTHo4iuJRNf/FsWLVapxfI0HO0lapgIr2CMWX1RNMGw=;
	b=Tpz7N4jz6iIdYwVk4kJn2T+buAxBp8YBQh22nIsTvejWPt+8lUzckh90Q2N57hCEuumiI1
	FHLWEZAEyfVktvUqpGsAjD99xGLNrVEi2tChZU/7JmOMVBRA4dl5T5bYb9q/sgF90yemam
	zS+mGByG9fyvhR80p8uJeoQn9UNZujQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-NxhpeBlpMkO8r2oaQuTj-Q-1; Thu, 09 Oct 2025 09:05:14 -0400
X-MC-Unique: NxhpeBlpMkO8r2oaQuTj-Q-1
X-Mimecast-MFC-AGG-ID: NxhpeBlpMkO8r2oaQuTj-Q_1760015113
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e45899798so7116565e9.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 06:05:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760015113; x=1760619913;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oTHo4iuJRNf/FsWLVapxfI0HO0lapgIr2CMWX1RNMGw=;
        b=Z9x2dsDUtFNEyUjUxi9DoaBxTRrm4RR7EPrz67YhznyQmlYbp7ylNhwJHyY94jp6P7
         YkwzDfbUDvQzvbpFT4aYYqNuji6xv+lsZPMyy04aa2+K0WOIqTyBlDhBEEMVvajTz6xu
         Ph7nrdxnR7tyLvMFxpmPK/ZVNl7dEMTUzbxRxvlcZYsYLuxQsrkeE/7IL4AZ/BeIWe3R
         O3ECf42Pj848j9XQGgBxH9aVHI8ZS99Dq8+mNGJvjcHlkzL2BooyGuvfKh1pa5ZHPG6T
         iC3hVv6mk1/NbbXDVUK2+ArY95Jyfpf7lkm4E7n1/0P8uXqf88wYLMIcpikDMuhkwoqF
         Ni8g==
X-Forwarded-Encrypted: i=1; AJvYcCWjjav0uXddwAhyWa7kYtbDGzkWSd9pTpnt2Syzpvhn4mTxcmCEYi6qSQA4AOqsDJY06joVpUziGQ==@kvack.org
X-Gm-Message-State: AOJu0Yz20mbaFYluw/+wScYVhHjG2LKQ8uylCS/EURkqXSyWbqdN29J1
	24ytpCar9VvEYmc6EJ7tIG9uT0qyFMh3LonajFRhpNETOj+Eo1AENbKFmyJJtJ4TnlOgCvEIHnS
	8kiYusLlQ1nR210vl4AMdbVL6CXrl5u+W063pkOsxhrS5Xd8BZdxC
X-Gm-Gg: ASbGncuGNA64qe/+Eqb6hfHbfufHrfq+bz2MUygCYdT7CaCEGqsHzDZl4y7+EjLqqo6
	b/JNY1IdwMJQHPSCOPQCf5m1anE67tTwWB2yhgXKrVvJWVZ/0YeQy2Yb1Nn3TlcvvPqKZ8d3i0z
	snf1/LEf/km+VFnc2C3sll9kHcMGkKjHNVeJAugZAmUk5/+LTBMYsou1NsHRCPsXaM1EO4AUn7b
	PP3xDe9Ql4LLQufGyPsy0B5Yf7xqEsKz1ZXEVzo8yJZC2w3JCzxNbQ9f+c5JocyR5GV8V2d1Jmk
	Lj8fvfrY1qI83G+GJn9qNDnV+/ybi/vOdH7WzMNuTx7Vyd6EeftokXgZMAbIdFprzWyV41v7YKG
	y9fSbV5Rp
X-Received: by 2002:a05:600c:83c9:b0:46f:b42e:edd0 with SMTP id 5b1f17b1804b1-46fb42eee2emr2581325e9.41.1760015112995;
        Thu, 09 Oct 2025 06:05:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6MQEGKTHH3lQ2c+ldeRR4aSAzt+sOKbg+VkML9CB8VKORVPmv1RemKtJCCw7qNufQ/ws5mg==
X-Received: by 2002:a05:600c:83c9:b0:46f:b42e:edd0 with SMTP id 5b1f17b1804b1-46fb42eee2emr2580495e9.41.1760015112341;
        Thu, 09 Oct 2025 06:05:12 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46faf112fdbsm47591035e9.8.2025.10.09.06.05.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 06:05:11 -0700 (PDT)
Message-ID: <bce57a83-e7e1-4e3d-85ae-6234a98975ea@redhat.com>
Date: Thu, 9 Oct 2025 15:05:06 +0200
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
 <9361c75a-ab37-4d7f-8680-9833430d93d4@redhat.com>
 <03671aa8-4276-4707-9c75-83c96968cbb2@csgroup.eu>
 <1db15a30-72d6-4045-8aa1-68bd8411b0ba@redhat.com>
 <0c730c52-97ee-43ea-9697-ac11d2880ab7@csgroup.eu>
 <543e9440-8ee0-4d9e-9b05-0107032d665b@redhat.com>
 <4632e721-0ac8-4d72-a8ed-e6c928eee94d@csgroup.eu>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <4632e721-0ac8-4d72-a8ed-e6c928eee94d@csgroup.eu>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ask3uQOWb8d3VcTGerJDz58lb4B2QKXxCbqVFBwfsVA_1760015113
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 611F914000C
X-Stat-Signature: yysjekxbxiza4ycjfo54b4kgpk7xhgsp
X-HE-Tag: 1760015116-483985
X-HE-Meta: U2FsdGVkX19xgBcbFgpDlSDglqQP9SogV2lbaeTWmP+NDVddpJ/n2okgwEM+eQDnJcbz4yxhOOF/A6ab3wd/QGVIXsTlVqj0LleC+MTvgpb7ZVwwYk+xTPyVtbSs+zpE5YhB6FUNMCnj+aCFhRvIpp45l3p/NTf4OBnN3bTBVg7/k5ZRhU4134a4EOYYAayuoy7oiN9FnVCi6OcBTx2VizVuGktSw9yAgnKT26NNADpTEYWBifYzD0LZpIT4bq4ehgwEGQhlve86BVTrdg/bTgs835LNIsD1cbk+VCWyRBk2GGZniUU8GOFF7DTJ8dB3EfSlULLzwAoYBT6P76AWe1HtATJfxQQtD9QZR6Ryxf1keuLwvWrFlade6oLhBUOC/CJcw0x8GyvHFlIw0l45EHD62iFhRQOQGfWHOXU9FekSg+AGTH/nwI+A5C/49wik5Hs/TycNELVdK8bozKflZObp/Idqt6jkB3JbfIatHBApp0pt8zNlJXRZnvYas8PvqxU7AsPvMP0agSoakpUxDRQAQiG/0xpY8kkF7q4+fzHnMdRa44EiAQXsqZrvIc922Tth/Wmn6ZAoWVgcRjVKyP5Br+Nm/cpwsJLz24lWd+NMjDSegE72p5nuZIB6HNXIuLYeLGe7xvtC3AVdqTby2QrmwGfNub+Mj6kUblTZ4SZFviAIhf7fNFnPINFN8QxHkxqSM9fbB5gWGXsMM76IvFnnofoS3GJXyfKU0V+v/bHSIN+MNLoerY/BmgD7WXapsyKIuJ7aG77MORUNFjqiuPm5ZR2nd+/wx7oClKEodTzhGHyvpHg9ZsUXc5w1mJ+u/nCHYFf5UmCtBgwVV0/IsfaPQWMzzm3V54boH6yGbQffbO3FTLAEYRS+PMbcxhmGhG9ECjnBm3doJczXd0UdCMfb6e4jy7MYEdmT3Qeic5AKqo8QZozZzI085Xzd7bYf/4H9VHlaFvINNRpSdCx
 OiAEXHgc
 mXdNIpK3bCCL+jtlTcfeuKcnztlYqzNsssaqWikCJ5Ac9K5Exr+6q+7olRMNErOihQYyLTIlXvWFrgW/ftFui0ZY/1/gqVuUNUHzZXXjX6yVn1UCbLhvUK8GSbUugcRMlKpCw1kKy9dq3V7WS0mQwcJHO2nXDxxSKgydrUr5oR//srTX0ESzj3qa99oYFsCO09lgx7Uv6fwaSNcuDM6qUXBPExKMFDzqbtbguyM4PONSOrP1szWMWsrf6GEOqqtpyg7uGJ/PDS9MMQUo+myqK52voMBY5yxi/fwDNUV+w+DyGIOv8zoRtodxqmWQUkk+kchAsdonizd1tlnKKFotSwwddViERtc5tEJZ5xD3zot22slvNeYjSsBCwVxMrRn2TBhA6BLwXZX0QlAbLZPiyKdwAM2PvA9yHL+Iwys8FVOb5N6f5bMZFbOA7vtpq6k7rE/TBhzPh0CPCnXXmMSbc53U/GXfIRG9GT3NgduTSnqbKKZnz8Ac1ekKGWlXSJp/0/3b+IC4jwu0Q9Rjo95NXjPWLzEWeX8gg6lA9XXqQuvweE3gB7invJ6n84frXuV893yk/8D6XVo9QA0FWJpma5nhhPgY1qRrVysmy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 14:08, Christophe Leroy wrote:
> 
> 
> Le 09/10/2025 à 12:27, David Hildenbrand a écrit :
>> On 09.10.25 12:01, Christophe Leroy wrote:
>>>
>>>
>>> Le 09/10/2025 à 11:20, David Hildenbrand a écrit :
>>>> On 09.10.25 11:16, Christophe Leroy wrote:
>>>>>
>>>>>
>>>>> Le 09/10/2025 à 10:14, David Hildenbrand a écrit :
>>>>>> On 09.10.25 10:04, Christophe Leroy wrote:
>>>>>>>
>>>>>>>
>>>>>>> Le 09/10/2025 à 09:22, David Hildenbrand a écrit :
>>>>>>>> On 09.10.25 09:14, Christophe Leroy wrote:
>>>>>>>>> Hi David,
>>>>>>>>>
>>>>>>>>> Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
>>>>>>>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>>>>>>>> index 1e777cc51ad04..d3542e92a712e 100644
>>>>>>>>>> --- a/mm/hugetlb.c
>>>>>>>>>> +++ b/mm/hugetlb.c
>>>>>>>>>> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>>>>>>>>>>            BUILD_BUG_ON(sizeof_field(struct page, private) *
>>>>>>>>>> BITS_PER_BYTE <
>>>>>>>>>>                    __NR_HPAGEFLAGS);
>>>>>>>>>> +    BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>>>>>>>>>>            if (!hugepages_supported()) {
>>>>>>>>>>                if (hugetlb_max_hstate ||
>>>>>>>>>> default_hstate_max_huge_pages)
>>>>>>>>>> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int
>>>>>>>>>> order)
>>>>>>>>>>            }
>>>>>>>>>>            BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>>>>>>>>>>            BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
>>>>>>>>>> +    WARN_ON(order > MAX_FOLIO_ORDER);
>>>>>>>>>>            h = &hstates[hugetlb_max_hstate++];
>>>>>>>>>>            __mutex_init(&h->resize_lock, "resize mutex", &h-
>>>>>>>>>>> resize_key);
>>>>>>>>>>            h->order = order;
>>>>>>>>
>>>>>>>> We end up registering hugetlb folios that are bigger than
>>>>>>>> MAX_FOLIO_ORDER. So we have to figure out how a config can trigger
>>>>>>>> that
>>>>>>>> (and if we have to support that).
>>>>>>>>
>>>>>>>
>>>>>>> MAX_FOLIO_ORDER is defined as:
>>>>>>>
>>>>>>> #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>>>>>> #define MAX_FOLIO_ORDER        PUD_ORDER
>>>>>>> #else
>>>>>>> #define MAX_FOLIO_ORDER        MAX_PAGE_ORDER
>>>>>>> #endif
>>>>>>>
>>>>>>> MAX_PAGE_ORDER is the limit for dynamic creation of hugepages via
>>>>>>> /sys/kernel/mm/hugepages/ but bigger pages can be created at boottime
>>>>>>> with kernel boot parameters without CONFIG_ARCH_HAS_GIGANTIC_PAGE:
>>>>>>>
>>>>>>>        hugepagesz=64m hugepages=1 hugepagesz=256m hugepages=1
>>>>>>>
>>>>>>> Gives:
>>>>>>>
>>>>>>> HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
>>>>>>> HugeTLB: 0 KiB vmemmap can be freed for a 1.00 GiB page
>>>>>>> HugeTLB: registered 64.0 MiB page size, pre-allocated 1 pages
>>>>>>> HugeTLB: 0 KiB vmemmap can be freed for a 64.0 MiB page
>>>>>>> HugeTLB: registered 256 MiB page size, pre-allocated 1 pages
>>>>>>> HugeTLB: 0 KiB vmemmap can be freed for a 256 MiB page
>>>>>>> HugeTLB: registered 4.00 MiB page size, pre-allocated 0 pages
>>>>>>> HugeTLB: 0 KiB vmemmap can be freed for a 4.00 MiB page
>>>>>>> HugeTLB: registered 16.0 MiB page size, pre-allocated 0 pages
>>>>>>> HugeTLB: 0 KiB vmemmap can be freed for a 16.0 MiB page
>>>>>>
>>>>>> I think it's a violation of CONFIG_ARCH_HAS_GIGANTIC_PAGE. The
>>>>>> existing
>>>>>> folio_dump() code would not handle it correctly as well.
>>>>>
>>>>> I'm trying to dig into history and when looking at commit 4eb0716e868e
>>>>> ("hugetlb: allow to free gigantic pages regardless of the
>>>>> configuration") I understand that CONFIG_ARCH_HAS_GIGANTIC_PAGE is
>>>>> needed to be able to allocate gigantic pages at runtime. It is not
>>>>> needed to reserve gigantic pages at boottime.
>>>>>
>>>>> What am I missing ?
>>>>
>>>> That CONFIG_ARCH_HAS_GIGANTIC_PAGE has nothing runtime-specific in its
>>>> name.
>>>
>>> In its name for sure, but the commit I mention says:
>>>
>>>        On systems without CONTIG_ALLOC activated but that support gigantic
>>> pages,
>>>        boottime reserved gigantic pages can not be freed at all.  This
>>> patch
>>>        simply enables the possibility to hand back those pages to memory
>>>        allocator.
>>
>> Right, I think it was a historical artifact.
>>
>>>
>>> And one of the hunks is:
>>>
>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>> index 7f7fbd8bd9d5b..7a1aa53d188d3 100644
>>> --- a/arch/arm64/Kconfig
>>> +++ b/arch/arm64/Kconfig
>>> @@ -19,7 +19,7 @@ config ARM64
>>>            select ARCH_HAS_FAST_MULTIPLIER
>>>            select ARCH_HAS_FORTIFY_SOURCE
>>>            select ARCH_HAS_GCOV_PROFILE_ALL
>>> -       select ARCH_HAS_GIGANTIC_PAGE if CONTIG_ALLOC
>>> +       select ARCH_HAS_GIGANTIC_PAGE
>>>            select ARCH_HAS_KCOV
>>>            select ARCH_HAS_KEEPINITRD
>>>            select ARCH_HAS_MEMBARRIER_SYNC_CORE
>>>
>>> So I understand from the commit message that it was possible at that
>>> time to have gigantic pages without ARCH_HAS_GIGANTIC_PAGE as long as
>>> you didn't have to be able to free them during runtime.
>>
>> Yes, I agree.
>>
>>>
>>>>
>>>> Can't we just select CONFIG_ARCH_HAS_GIGANTIC_PAGE for the relevant
>>>> hugetlb config that allows for *gigantic pages*.
>>>>
>>>
>>> We probably can, but I'd really like to understand history and how we
>>> ended up in the situation we are now.
>>> Because blind fixes often lead to more problems.
>>
>> Yes, let's figure out how to to it cleanly.
>>
>>>
>>> If I follow things correctly I see a helper gigantic_page_supported()
>>> added by commit 944d9fec8d7a ("hugetlb: add support for gigantic page
>>> allocation at runtime").
>>>
>>> And then commit 461a7184320a ("mm/hugetlb: introduce
>>> ARCH_HAS_GIGANTIC_PAGE") is added to wrap gigantic_page_supported()
>>>
>>> Then commit 4eb0716e868e ("hugetlb: allow to free gigantic pages
>>> regardless of the configuration") changed gigantic_page_supported() to
>>> gigantic_page_runtime_supported()
>>>
>>> So where are we now ?
>>
>> In
>>
>> commit fae7d834c43ccdb9fcecaf4d0f33145d884b3e5c
>> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Date:   Tue Feb 27 19:23:31 2024 +0000
>>
>>       mm: add __dump_folio()
>>
>>
>> We started assuming that a folio in the system (boottime, dynamic,
>> whatever)
>> has a maximum of MAX_FOLIO_NR_PAGES.
>>
>> Any other interpretation doesn't make any sense for MAX_FOLIO_NR_PAGES.
>>
>>
>> So we have two questions:
>>
>> 1) How to teach MAX_FOLIO_NR_PAGES that hugetlb supports gigantic pages
>>
>> 2) How do we handle CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>
>>
>> We have the following options
>>
>> (A) Rename existing CONFIG_ARCH_HAS_GIGANTIC_PAGE to something else that is
>> clearer and add a new CONFIG_ARCH_HAS_GIGANTIC_PAGE.
>>
>> (B) Rename existing CONFIG_ARCH_HAS_GIGANTIC_PAGE -> to something else
>> that is
>> clearer and derive somehow else that hugetlb in that config supports
>> gigantic pages.
>>
>> (c) Just use CONFIG_ARCH_HAS_GIGANTIC_PAGE if hugetlb on an architecture
>> supports gigantic pages.
>>
>>
>> I don't quite see why an architecture should be able to opt in into
>> dynamically
>> allocating+freeing gigantic pages. That's just CONTIG_ALLOC magic and
>> not some
>> arch-specific thing IIRC.
>>
>>
>> Note that in mm/hugetlb.c it is
>>
>>       #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>       #ifdef CONFIG_CONTIG_ALLOC
>>
>> Meaning that at least the allocation side is guarded by CONTIG_ALLOC.
> 
> Yes but not the freeing since commit 4eb0716e868e ("hugetlb: allow to
> free gigantic pages regardless of the configuration")

Right, the freeing path is just always around as we no longer depend 
free_contig_range().

> 
>>
>> So I think (C) is just the right thing to do.
>>
>> diff --git a/fs/Kconfig b/fs/Kconfig
>> index 0bfdaecaa8775..12c11eb9279d3 100644
>> --- a/fs/Kconfig
>> +++ b/fs/Kconfig
>> @@ -283,6 +283,8 @@ config HUGETLB_PMD_PAGE_TABLE_SHARING
>>           def_bool HUGETLB_PAGE
>>           depends on ARCH_WANT_HUGE_PMD_SHARE && SPLIT_PMD_PTLOCKS
>>
>> +# An architecture must select this option if there is any mechanism
>> (esp. hugetlb)
>> +# could obtain gigantic folios.
>>    config ARCH_HAS_GIGANTIC_PAGE
>>           bool
>>
>>
> 
> I gave it a try. That's not enough, it fixes the problem for 64 Mbytes
> pages and 256 Mbytes pages, but not for 1 Gbytes pages.

Thanks!

> 
> Max folio is defined by PUD_ORDER, but PUD_SIZE is 256 Mbytes so we need
> to make MAX_FOLIO larger. Do we change it to P4D_ORDER or is it too much
> ? P4D_SIZE is 128 Gbytes

The exact size doesn't matter, we started with something that soundes 
reasonable.

I added the comment "There is no real limit on the folio size. We limit 
them to the maximum we currently expect (e.g., hugetlb, dax)."

We can set it to whatever we would expect for now.

-- 
Cheers

David / dhildenb


