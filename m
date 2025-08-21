Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A82CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 21:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD238E005C; Thu, 21 Aug 2025 17:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58C5E8E0056; Thu, 21 Aug 2025 17:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405DD8E005C; Thu, 21 Aug 2025 17:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 284048E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:00:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAAAE16054B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:00:48 +0000 (UTC)
X-FDA: 83801983776.20.D61ABCD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 38B41120021
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:00:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JMBH47ee;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755810046; a=rsa-sha256;
	cv=none;
	b=tKjrZM0PIti/dCgkL8yT0Va/tjOlqMQpKDIt3aU9cMuYRyNNMHGcrx/WDQ4WAdknLWaCoO
	q5eUvvUtDK6+JJhgQEtE84expbTwRazYt3ejmJtC1k9NCr483GBp4Dtm+mSVi81pYTBrPi
	Z/jA7z6t4TtmNt/RHa4yH7b2QlWDUk4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JMBH47ee;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755810046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cp1mFCWwcTWQzzsUUmh88+YFkDBcq7Y5lQlba0VlHo0=;
	b=Vjx4VvGgwY2AvYuqLMrLcdL54tMdyNCeR0nuyMOZBsob1OSur9Jz1hyq2V2V/494CUPYGr
	1ihMBA/lY8DQtiWnYGmLSBNne0lCbdhQT/ZUiVF+BAM/rZZJRqgarGTdRjfWfkN8DOZkd3
	3V3MRTLL5+QYdscjq4LuHNtdHKMfqxI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755810045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Cp1mFCWwcTWQzzsUUmh88+YFkDBcq7Y5lQlba0VlHo0=;
	b=JMBH47eeutAISS6f5GCISxL8siJ6hd2R90IpiZ2JbiKmNobB2KJMAXtYXqfzisZZBX1ryl
	0HyM/KyKIIj67Gd58GVHZqw7+y+rUCrZJs/ZqpeBcib0t9oDZs5XfJ/JE6faXBH0HDX4R1
	4v7OYY266AJNlJLB97rS3D3eHVJB8NU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-C11uPJuENXyqiMMhLnlVxw-1; Thu, 21 Aug 2025 17:00:42 -0400
X-MC-Unique: C11uPJuENXyqiMMhLnlVxw-1
X-Mimecast-MFC-AGG-ID: C11uPJuENXyqiMMhLnlVxw_1755810041
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9e4146902so573811f8f.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:00:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810041; x=1756414841;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cp1mFCWwcTWQzzsUUmh88+YFkDBcq7Y5lQlba0VlHo0=;
        b=D/f468zC5Xsh8oROBPXbL6r9XarKqhbkS4a+HZajhXoIdwnnvxQbW4T6e3n60QiS0G
         tf7D5+KO8aomVHcuQuVJpZ5RQKJJf4KpvvGxOKaImabAMh31SFuWa4oT1MJJs0tEo+GG
         /AT0dsz/AYx4YY31IxvWwuJDAz4kevR7ls8u5HL1uXZHoBBaxDlYwAOa3ryCgxdttrjU
         +TTXQ5CT7zalMryV2/ogC65IOFZWJzS2liO1uiv+yQcXmmDklqbtf1oig+4lD+D/EYp6
         pg+UelzOcl9r8d1TI8/G48IygxPzazXFDhO6Ad8tASh2u5BnGYTNEuPxZWsdqwhONcvP
         Pd4w==
X-Forwarded-Encrypted: i=1; AJvYcCVd8K86hAWZmgNCx4DMyQgp37jgjYt6X4XERqSAc9UNXBy45+Sv7WvXc/Pv4dOShIuKEiF/0zw0Jw==@kvack.org
X-Gm-Message-State: AOJu0YyXb7HwiCu4m9DGrDgY7y6uYdQsAXd+p2JF0ooi2SFgkB6dTV3X
	uRZZkqIQTqWQ9U4OgMrWQznYMZxdgk7DeZnwYc/8NF8Btma8HN6nguY8LcWLIfwPCVHJVyInGmI
	ocM4j7LJiQU+D6pOABNl3biAFYZmlVs61zDm9tHUxSYIZiyVkE8J3
X-Gm-Gg: ASbGncuDNkvAY6C40IFpfkMsR37X0yKiJq8KTJT6/wqzBz3QSotujtOj8gmjg2FlFo2
	ox1kh7cA1/Cm8icxGAEEw3VKw+VIv+51RQafeTUL62WdzAknpWd3ov6A4LhEk7U0KT5Fp8+EF6N
	ZycjBQGMeOI3Fy2Fv1dVTAbtcUqtOxFkOFKawmCkx7qE7vauE9l/N4UycKwWUv3eu7unZf9Nmmq
	1EErReJ6o1iqb1pBbZDn9IybsH/p2aXtq5PRPZfDjgyU4+aQI0thDsAXbcnACLB7kZzfJeWCI9T
	TE9Qwbi98VFVvNIEEVh2FStaDIKT0Dx6jhXlO4xDox9HNeWfbrWEvzJuxp4eTajLv2blxOh5Gpy
	8HGlXboQSY0RaM8DcqPoudCHvwX4pQWATfSJd+b8/EiVRDGRhjtGvVlaf1O0cfw==
X-Received: by 2002:a05:6000:200d:b0:3a5:2465:c0c8 with SMTP id ffacd0b85a97d-3c5daa27e6amr265237f8f.7.1755810041353;
        Thu, 21 Aug 2025 14:00:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7vpqV63aDfbj4LuprqMLqq42InG6u1nR+Dt/+ZPeyx1uRJcEanVY8H02OCG3yOg5OQPh6rw==
X-Received: by 2002:a05:6000:200d:b0:3a5:2465:c0c8 with SMTP id ffacd0b85a97d-3c5daa27e6amr265173f8f.7.1755810040805;
        Thu, 21 Aug 2025 14:00:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f26:ba00:803:6ec5:9918:6fd? (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c4ccbf04fasm3476159f8f.7.2025.08.21.14.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 14:00:40 -0700 (PDT)
Message-ID: <23c6e511-19b2-4662-acfc-18692c899a6c@redhat.com>
Date: Thu, 21 Aug 2025 23:00:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 13/35] mm: simplify folio_page() and folio_page_idx()
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
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
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-14-david@redhat.com>
 <E1AA1AC8-06E4-4896-B62B-F3EA0AE3E09C@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <E1AA1AC8-06E4-4896-B62B-F3EA0AE3E09C@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hrDMbqb_692JWTs00Nzt9WBviHCb8FswMIxYT6EXh94_1755810041
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 38B41120021
X-Stat-Signature: 1snnxtdnp7ffdtsi69g1ra6hzeeiqa4j
X-HE-Tag: 1755810046-200125
X-HE-Meta: U2FsdGVkX18ENQHbDf1PldGo+N2a6x2j5j6MW6RILB0cP0RSe73htQojMs7j2GuRh9KhHzh6bQMrni5An0S2iyXyMGqAhVOHgMj75MMEDySBDz00V7tyz9KCYwXGL3lYTsHckG1H+oGK98WZkhoy1GB9VDfAKUME4BPNMrXYqUbTYbGdX5QmrD+VjD8V7Ojzm9sHIGnmgczWah/HQLAbLEqFTjhanJJB5+b5lwkThVtwtTBR/XJQEzejd8VaP3kCAYfM1350QbQ5fiT1/lo8b8fVotcS/+VPc4tDIQBHtlBqcrKadLdJy+a+VPB+Ww4OBGaBmhbC7lq+RtKxczCF7Gl+Ahy3rRUh7BfGxGsiyQPxdVzlAFcLsmcytFKuNcsnNTial7YDkuSzr15RdLzQToMQpBk9+YAvs5bz767/OAXnjBc4NmG+0vGojBiVYKv+ict5NQG8PH543pBoW7x0hXy9V/Ksb+eA8GvDhcXHnyVQ/38W2HZaxBo8cNoX5hzn8r0DaJ38qJWPVQx/0fr71o872/NgXc3nm1N3ns6k1EdQ1HHjnvY4VmT2d1AtnJ0UoU3whWPNEH9anu7Dq5rXCb5Y8/q/46jDaty7AIRzZ4w1I+8oB9IQcA1V+8x0WxQUTXZhChpzdgWCyTrYlkIxFXRd7el7JI/YwGXU70vF8mRXECqWPlo8MXtUcde7DRiBnxR6Hlm19rCEMd73DUFRynJArWe4zn6s0tnoVvqPycBbMziJYKwoRHQSFFGofN8hag1Pi12B2QKwKCfAZM3cbcKnEZzcXx4ZTS/zmo3y98YYZ3cThxuFGNOJYZfXxa51BfbwewvqzrTfrNpdhad7yYGpuUPbxEpbJOtH46TNkX03TcHX8MvqF7QxSGadV7sl2oBOsy7y/uOUdWJ+hz1lkL9EnB6Pa6N4ED6b0ekzW9yhz+37VDsaTYrMSoKdEGtNBJHADPGX6kLlAR/qF+b
 xlM53Bzt
 M8dg3CSzkuAdZKhyMIMBaBoUKlM+TZwJ+fLKxlR9t67ZikopNFNPP4DNvqjD/ol9iK5bzxboezwZ3u832CpLhJ6K9hk4dJpBkp7TmPO7IHGxl50DrkBZSOslJptQVi/dQh0ieo+7bkU+Ar1KDUA+JXW4E4CSvnj/XrgPpeEiwOCAu1fJSoz/YQ5LTqtxQ3n2Uc9VdZwr+P1xMTRWyOVhqiViG2LOoft6fkSLtZlGdHXt0wdRYvFEzawmd74PPluLhOWdGSPJSrnXy2JGQ6KUWKIo7r4j5isIKrvPjR68OTbR7fyfktNFBnMX3g/nOckbLnNTSIIStMk6rzBae/PIicoA27k0C9ft9tDgW8QsKcKpuaM5o/zUBwILglmkeTz4sGEC6asm5M8Sid92wgpoJAhbgs7s2i7aCgiN8/3QKhGhWool38DTujsuzHBztNXLyYHbcXsf913jFymcC/xicLFL+vbRInSUVoBvT3aWvXyokyBRpvzBSfVK6Cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.25 22:55, Zi Yan wrote:
> On 21 Aug 2025, at 16:06, David Hildenbrand wrote:
> 
>> Now that a single folio/compound page can no longer span memory sections
>> in problematic kernel configurations, we can stop using nth_page().
>>
>> While at it, turn both macros into static inline functions and add
>> kernel doc for folio_page_idx().
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   include/linux/mm.h         | 16 ++++++++++++++--
>>   include/linux/page-flags.h |  5 ++++-
>>   2 files changed, 18 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 48a985e17ef4e..ef360b72cb05c 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -210,10 +210,8 @@ extern unsigned long sysctl_admin_reserve_kbytes;
>>
>>   #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>>   #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
>> -#define folio_page_idx(folio, p)	(page_to_pfn(p) - folio_pfn(folio))
>>   #else
>>   #define nth_page(page,n) ((page) + (n))
>> -#define folio_page_idx(folio, p)	((p) - &(folio)->page)
>>   #endif
>>
>>   /* to align the pointer to the (next) page boundary */
>> @@ -225,6 +223,20 @@ extern unsigned long sysctl_admin_reserve_kbytes;
>>   /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
>>   #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE)
>>
>> +/**
>> + * folio_page_idx - Return the number of a page in a folio.
>> + * @folio: The folio.
>> + * @page: The folio page.
>> + *
>> + * This function expects that the page is actually part of the folio.
>> + * The returned number is relative to the start of the folio.
>> + */
>> +static inline unsigned long folio_page_idx(const struct folio *folio,
>> +		const struct page *page)
>> +{
>> +	return page - &folio->page;
>> +}
>> +
>>   static inline struct folio *lru_to_folio(struct list_head *head)
>>   {
>>   	return list_entry((head)->prev, struct folio, lru);
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index d53a86e68c89b..080ad10c0defc 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -316,7 +316,10 @@ static __always_inline unsigned long _compound_head(const struct page *page)
>>    * check that the page number lies within @folio; the caller is presumed
>>    * to have a reference to the page.
>>    */
>> -#define folio_page(folio, n)	nth_page(&(folio)->page, n)
>> +static inline struct page *folio_page(struct folio *folio, unsigned long nr)
>> +{
>> +	return &folio->page + nr;
>> +}
> 
> Maybe s/nr/n/ or s/nr/nth/, since it returns the nth page within a folio.

Yeah, it's even called "n" in the kernel docs ...

> 
> Since you have added kernel doc for folio_page_idx(), it does not hurt
> to have something similar for folio_page(). :)

... which we already have! (see above the macro) :)

Thanks!

-- 
Cheers

David / dhildenb


