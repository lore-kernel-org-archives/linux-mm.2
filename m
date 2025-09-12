Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 130B0CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 07:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290838E0007; Fri, 12 Sep 2025 03:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2416E8E0001; Fri, 12 Sep 2025 03:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1303C8E0007; Fri, 12 Sep 2025 03:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 032D58E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:18:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC682C0728
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:18:13 +0000 (UTC)
X-FDA: 83879744466.12.5F9E6E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6116240011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:18:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QxQhI6Ry;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757661491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDPn9i+ROjOktEcFqZQr6V2FH+/7TX02fcqnES/TaE8=;
	b=1buD/82PrKOd4eWI5aGo6ZB4mLbmYtt9HzEcB0de5hQqNIYCyrXBMSw6tD0pGU2XaAh+7C
	5Pgz+vmfgBj+7l+CJBJ1U+yS5ukeSXH3pw2T3rIfcx5lJpKB4SA0bddTpAsAhTMb1fnxTc
	Buu35tgtxpVTtKrzc42xLW+/hzzsNbg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757661491; a=rsa-sha256;
	cv=none;
	b=KgAAuHyr9k6B+fFOl1z/0ZFVH9Dv5+uhuPXtosycnQd5IGWLw8zCtLwwxF+m4z/CTHEmXP
	OqcpdJg+GnUuEJrtxIwKUX1hmPik/Vi/Q00O58Ez14/DhijFEdgO+iy+DvAN5RkpMxu7MU
	nPR98OKODtr4nLIUguh0aNo54i7tWx4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QxQhI6Ry;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757661490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iDPn9i+ROjOktEcFqZQr6V2FH+/7TX02fcqnES/TaE8=;
	b=QxQhI6Ry8XKSjpSVJC3kxgOOZgPlSVXdQXqHGbqIxIizQzpV1GZo8SNxoB5eRkiYacoZyh
	puLUay8q1pYo++WFIPFfb5tQA3e9Z74qsDUBY0Y21n5d9iH+2yFbNbd/NbTcilGe59UDYo
	asaRkgRdT/YDFUng6PYHGxVVLspifa8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-uBl8n8QbMlG_lDhhfTMkHA-1; Fri, 12 Sep 2025 03:18:09 -0400
X-MC-Unique: uBl8n8QbMlG_lDhhfTMkHA-1
X-Mimecast-MFC-AGG-ID: uBl8n8QbMlG_lDhhfTMkHA_1757661488
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3df2f4aedd1so1158191f8f.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757661488; x=1758266288;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iDPn9i+ROjOktEcFqZQr6V2FH+/7TX02fcqnES/TaE8=;
        b=PcCxUfXIo8EXi9g9FCzCuBmfsQVqeU3PZf2BqgVTAwVmFYWsCJQeH1z0a6G1tQ/Hc6
         1dU+mz0OI3t9qVsnl8O+KZEYAVGtE5jFqd0+Z4apChS0vpwUJRybOoM7BksKJcz5e08+
         lNEgCtsZYBL1GS3MymrtrwRFGOLnXCLFjetb1ha7AESSSzp5IEm4oKsW7IIVgfAMA/y4
         ezf775O1Fz5KqyxiOn1UuiR1l0W1QW6UkB2QsGqUwVyehqWObrRuqpGpKZxVw1iWC2jp
         QNivD/LqGXZCfrgdVUbuTkBcMWoYjJBvj1a03x4KCges/17US6D4jpi6z+IsrW4VNpM1
         YQ6A==
X-Forwarded-Encrypted: i=1; AJvYcCVlpy6nHa1puevQ7vgor8rehis8LnlAHRz/7QTsSDAqC7m1Y6waqvJQJrD1sKrbAskSUJ2qsrzqmQ==@kvack.org
X-Gm-Message-State: AOJu0Yytinz0XtqTAdet4+2rUaYNlP6UAUVpIB03UqMgxzthf0mkrnHz
	qV1GDuVUi6yRy2ZjbcXljxzU99oMO1S2+YM4YdbZJWt9TvyJK4bxFWuedL8yrrT08OHeNzjfJ8c
	HnmBtwoQf6hUtTpY+g1Q7w/C1f/DYgkVg5HkGPUSj7jroLwUt+LOC
X-Gm-Gg: ASbGncsSNaZoFSHPw0nQHeydqTEEO5Osyo+yMrq8+HM1hl6OdZC68T87/xP2x0wdIPY
	wopMKgb801FX5zfqQIPTR8o9YNHuoPSYfqmIr/+cgv+h0kuTW0rVJ5a2vPK256Hj8HbejVg5K3G
	1H+kcQyQyk0mIN+HPqVXggricYJXaZ/cAXrSS7j8IvPRQbuHY9mSDSBSHxr7d6z5/L+qJsbernH
	isi1i+HJi2VRm7f2G1ABLKV80jWiJkMLXXIu5yAopEhDxDqwIZ1vgFttg3I3fzfLdnZg5YxBa1S
	Uate9g4E96iVU7DmTZgbfZ1dLFi2yyQg5rG+m/9k89tipeN4sry77/8Y8Z54hzYfF6jpq/v/4zC
	ARBi0ciNfd3n+R/U/qkJPFfoEVp6id6bmMpINRC5SlXyqP+d97v2m6Ba22Wd8RXB60Eg=
X-Received: by 2002:a5d:5f83:0:b0:3e4:f194:2887 with SMTP id ffacd0b85a97d-3e7659eb2bemr1337409f8f.30.1757661487952;
        Fri, 12 Sep 2025 00:18:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPXxsOxhFTYCghkOEPpsdV2JUDBqNQ6DGNj36WCmCFmKU/uRa3052c1dggd4fz2t3h+edjSw==
X-Received: by 2002:a5d:5f83:0:b0:3e4:f194:2887 with SMTP id ffacd0b85a97d-3e7659eb2bemr1337373f8f.30.1757661487453;
        Fri, 12 Sep 2025 00:18:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607cd9fasm5350431f8f.35.2025.09.12.00.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 00:18:06 -0700 (PDT)
Message-ID: <3a842ae3-f13a-4f5d-8870-d81cf1f0d56d@redhat.com>
Date: Fri, 12 Sep 2025 09:18:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 20250910133958.301467-1-wangkefeng.wang@huawei.com,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
 <20250911065659.617954-5-wangkefeng.wang@huawei.com>
 <90e926c9-40cb-4791-8360-e3d145fe3503@redhat.com>
 <8508e8fb-77cc-43a7-8460-456f68a552ba@huawei.com>
 <667133bd-0021-4d4e-9cde-fc8c1324522a@redhat.com>
 <d63e7e02-b2ab-46fb-b981-ad4f4f28d634@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d63e7e02-b2ab-46fb-b981-ad4f4f28d634@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gu5y_n2ZEqbdPiOqJbbVDYvOkPhDAbjepfBzpCJmFzA_1757661488
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6116240011
X-Stat-Signature: q49hwomj6giymcis9bik6ae7byb3h9tx
X-Rspam-User: 
X-HE-Tag: 1757661491-563016
X-HE-Meta: U2FsdGVkX1+VhIqrz12NotEZHhXdlY45Y9OyfOsUFlRLJG6pzS+3VMmt174h0UNemZoTOv9v8y7zOPqsMO3gP/DRkokroGCbqhkAHbJ6bzAeGxrhU784azuRsql4c2xxQRpIvxPLwLt+rRUp5p0zOVBv8N/sgOEblf8xxFPaua0+tkZRGmpYp5NR37s403DrS38uqbw99o+u5qrAh+kKKZ8f+7wV88tqz2GwjpmXZfa/vFqs7Eg1m2ZL+fCLmUmPcj2tC9rRUVbT1TKpTNb99sEv+49Slukh8OpOcgvZiBiED9NVAB3ZDpYptS5yOQV8KtTU9G1KW67x55sxRNEVSf2us2OrLyTmLQ4x0/Va97rQnGt+fqcgHmbz1GjFVaIIg5jpk1RnL2csNiL8FK92hOqtjLuqZJDVRZLpTaeGx7quxXTE3Ar8kKUWqJ91umcc6sFUDa8GMFjD52ACH8VQkTB2WO3FUYGKx58OPgasqYvMcAGZgkvDANIdoWpiztzrCm3bKYsWNHyOAiTCFgiOr14wRt6Dja9NwuqzsAfPrDctC9TetLk6RzrJIga+0s+n3dCtTjo3yJP3+tHaKDmSA6Dr3EIn8fxIv9acbKm4gvYoSKFjT9T+H29U6FVRcxJ+p7HxzQHE38UH7sWn4kK4q6A0GCSznAzcD6vsDZ+jdHCYLnmvbmeU6LHge3SAze1Cm0GvUtN4RGGf/UQfVzNOFCLU5V4dqJlNXxLERL2MZA3KtEZyDkXQtmBD6JxLyb2UipIULAFmPtMsB/lASgQ6tF4WRLvXk4XprJ5ka5uuLGxwHGU1BWzL1W2+9oEIj/tXR2ba32TtYw6l1TwdlywqYvD0Vzop8PU1kReJQCNB/uy6vht3xBbH7JdptcMv4fKsW/u5q0DetDeAJMpe26dfEg9OfuU+8mm96ExX1N73O8/6fAw4T/M+NZeFKed8Lbi2jRVrgQqwwKIiovaX9iF
 ARMrpBdC
 oGO/4ahnZsMa+TDMeYfRy/x3xgcN0LXIO9LfzOJugThImZYgeyDG9LL55KPHjiBmqZPqVzmnBS1gM8H61r8Xyu2H5M2mWplHH+l+U59MoYOUmRiRWCELY39DR3+Ttq+ft0tJmvlVLs+sS+5o+c1uTEBp+F4vcYjwJLNV0eCFvTzT58WU+Ic1r34etv+p6zc99PjVrEFxk2u1HxyzvO4B2pgK2OHeG9ggN5I8gH5OFBvwbwhgqf4YjyX4io2hZsQ3+yMN6lYFzP+jWusXdwn6duqdEjwqrnrcpTVbvh7wGQULGw1p7a04Y8feK2QGvWOXWvzrbwgWHTmIuPLzUaCFNYNSqGG+YEJlvskgp40G5kDHRwesHwCuZQJlAEKdHPMVufp5IYXSUVSfJbUQPtX0GQAoeM3wOinNyQrGAkPRekXYVwwUqkDb1Nu0vNVr5UVyLIR7S3/y0MyPZd3HI1vasgncvWa6gWZ21aRpfOLl351lPuc9/uxkTPyoyhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 08:57, Kefeng Wang wrote:
> 
> 
> On 2025/9/12 2:56, David Hildenbrand wrote:
>> On 11.09.25 11:11, Kefeng Wang wrote:
>>>
>>>
>>> On 2025/9/11 16:25, David Hildenbrand wrote:
>>>> On 11.09.25 08:56, Kefeng Wang wrote:
>>>>> The alloc_gigantic_folio() allocates a folio by alloc_contig_range()
>>>>> with refcount increated and then freeze it, convert to allocate a
>>>>> frozen
>>>>> folio directly to remove the atomic operation about folio refcount,
>>>>> also
>>>>> saving atomic operation during __update_and_free_hugetlb_folio too.
>>>>>
>>>>> Rename some functions to make them more self-explanatory,
>>>>>
>>>>>      folio_alloc_gigantic            -> folio_alloc_frozen_gigantic
>>>>>      cma_{alloc,free}_folio          -> cma_{alloc,free}_frozen_folio
>>>>>      hugetlb_cma_{alloc,free}_folio  -> hugetlb_cma_{alloc,free}
>>>>> _frozen_folio
>>>>
>>>> Can we just get rid of folio_alloc_frozen_gigantic?
>>>>
>>>
>>> OK, we could kill it.
>>>
>>>> Further, can we just get rid of cma_{alloc,free}_frozen_folio() as well
>>>> and just let hugetlb use alloc_contig_range_frozen() etc?
>>>
>>> HugeTLB can allocate folio by alloc_contig_frozen_pages() directly, but
>>> it could allocate from hugetlb_cma, cma_alloc_folio() need change some
>>> cma metadata, so we need to keep it.
>>
>> Hm. Assuming we just have cma_alloc_frozen() -- again, probably what
>> cma_alloc() would look like in the future, hugetlb can just construct a
>> folio out of that.
> 
> I get your point，firstly, we could convert to use cma_alloc_frozen()
> instead of cma_alloc_folio() in hugetlb_cma_alloc_folio().
> 
>>
>> Maybe we just want a helper to create a folio out of a given page range?
>>
>> And that page range is either obtained through cma_alloc_frozen() or
>> alloc_contig_frozen_pages().
>>
>> Just a thought, keeping in mind that these things should probably just
>> work with frozen pages and let allcoating of a memdesc etc. be taken
>> care of someone else.
>>
>> I'd be happy if we can remove the GFP_COMPOUND parameter from
>> alloc_contig*.
> 
> But not sure about this part,  GFP_COMPOUND for alloc_contig* is
> introduced by commit e98337d11bbd "mm/contig_alloc: support __GFP_COMP",
> if we still allocate a range of order-0 pages and create a folio
> outside, it will slow the large folio allocation.

Assuming we leave the refcount untouched (frozen), I guess what's left is

a) Calling post_alloc_hook() on each free buddy chunk we isolated
b) Splitting all pages to order 0

Splitting is updating the page owner + alloc tag + memcg, and currently 
still updating the refcount.


I would assume that most of the overhead came from the atomics when 
updating the refcount in split_page, which we would optimize out.

     Perf profile before:
       Alloc
         - 99.99% alloc_pool_huge_folio
            - __alloc_fresh_hugetlb_folio
               - 83.23% alloc_contig_pages_noprof
                  - 47.46% alloc_contig_range_noprof
                     - 20.96% isolate_freepages_range
                          16.10% split_page
                     - 14.10% start_isolate_page_range
                     - 12.02% undo_isolate_page_range

Would be interesting trying to see how much overhead would remain when 
just dealing

OTOH, maybe we can leave GFP_COMPOUND support in but make the function
more generic, not limited to folios (I suspect many users will not want 
folios, except hugetlb).

Maybe just a

struct page * cma_alloc_compound(struct cma *cma, unsigned int order, 
unsigned int align, bool no_warn);

That would allocate a frozen compoud page starting today already.

-- 
Cheers

David / dhildenb


