Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389CBCCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A228E0075; Thu,  9 Oct 2025 06:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561A48E0002; Thu,  9 Oct 2025 06:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4506B8E0075; Thu,  9 Oct 2025 06:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33F358E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:30:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4A9D1A07A6
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:30:38 +0000 (UTC)
X-FDA: 83978206956.12.BA4F470
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 68FE7180013
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:30:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QhNlqUuE;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760005836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kNnaE3wosVbbZxnmP0sVKpcafEUi286yAMPQXV2QSw=;
	b=p3QURK6rVYTGh/eX7s3unov+hnrq7W0ZBQND4lJp+h/Smeg3owifr7WTVdmpgl3VLBQzLX
	Q+dPeun9TtEFoD4aHM5AfTCm0g9IYlDStcp9RrQUZGXX4wHQuyaKw4Cg2euSMlyXJJgVSq
	uPPec3501gS3mCC9br+nF3HNrLPqhFA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QhNlqUuE;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760005836; a=rsa-sha256;
	cv=none;
	b=c+fSRcQaUXMVj39G5UTddqstrCI6mf5DrkBTvxPnle6j7wZqOZ01s7VKtn+/ubXb57Tf7B
	4jRxMKKIk2yC4kKMVu3gbmEkghgG/1BWP4efdRIG1c7YAW6wqRzllzDEVF3ofleF7YKDnN
	0Bn+Yf9+QrGjoZwOXcfxtvkRTRXq+H0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760005835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5kNnaE3wosVbbZxnmP0sVKpcafEUi286yAMPQXV2QSw=;
	b=QhNlqUuEsZntvTKx/8um0mOXPrBTaocXHhJUBiXc0eBjqWRq2yTGClJBkTGOc2yp7VwzTy
	QjsteWnmZaTPA0KvttQcbt9UdhQhB5/iu4v2IN3rowl2TpF4BlKjApsiN7jS1ukF677+wu
	UOH+Qgx/PilnAElVViX2pOLP3CclQVw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-Dvlh4z7-NeCliDbfQih3Vw-1; Thu, 09 Oct 2025 06:30:34 -0400
X-MC-Unique: Dvlh4z7-NeCliDbfQih3Vw-1
X-Mimecast-MFC-AGG-ID: Dvlh4z7-NeCliDbfQih3Vw_1760005833
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e36f9c651so5380315e9.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:30:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760005833; x=1760610633;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5kNnaE3wosVbbZxnmP0sVKpcafEUi286yAMPQXV2QSw=;
        b=bd5EDX3c8Ktr/40f5ko00vg+MU9KnOZKIxk8SVUeYGP5QAosySzUYxaimBTtwStvmI
         zKX/Jge1kz0D3HyravDcsmgFEOfuw8NmXeeGNLmSw0VlwynBsndUEdFafy0PtdlqaScr
         aSCnmT4SJZq9w+jZd+ZlZ3t3i5ZWhRLuUmuneO9T8bo92CmI52h3b2+E56yCanjS4g24
         ixHI6Vu1gati+3Ytoyyp0XXj9h0rhCLBBweTYW/zJ9m95fKRppglsp8+01ECfay8yySW
         L3gG3tBBURgbhccu9nUSXOjFKxT3XXnqw3gSwPIgkbx6xXvtTkqiMUzXVgG6grluSbHE
         OuFg==
X-Forwarded-Encrypted: i=1; AJvYcCVL1htXAcRROKCBcF2xjWVY9E+Xzx6VRSPgDL/cTC+ZjSoQFkNBYDY8Bq1WHrunHU9HrEf8eRBIqw==@kvack.org
X-Gm-Message-State: AOJu0YwO5qMsBaehGzvu7My7uPKkQrrQ8o4cxEfPM/tCwDCedcOcPRIh
	9pNWm6zHpeWFPZQk4rxc5r73XR8exzZIveF8XBFNQo588Nk3OvTt7bxpKPUPaEnYY1o1pnNvuJW
	DmHv940I2fVq3PynfbKa9H6SqVH8kWpbUc1/5lw4P7HiD3BoBJl1o
X-Gm-Gg: ASbGncs5TXzMk6VLAJ+2mHnUfL2YZ4RMyTXjpLwTkRZT4EEX6MwHgY4fVkpagtQF0Fg
	scZg9sPPMzS/1hWT0WWhRb1LbKEUGmzl1XFUXOyLTZkgR0r5zvneWOKkBzesIlBvVmwaaiSJrbI
	fGVotUNJ4v8q3OQe0NtthWc3fN8A7H2dKU+8jhjxO0jncU3CMl3yj3hywCl/O+9eAth//CPCytE
	E7ePnAKvzpgXO8eqbM6w0BMwWrbv37QJgxC8ixZiO9CeFULHFmaSzRsBY/yqaDRPh/L6q4vW9OV
	JNY/Q/FhNLTz3rNoRUmg2cBWqUZylf6iERhUqcumYkLW456vGVLCu4VHU7RvzkQEZPzfae12DNW
	YEukVVszE
X-Received: by 2002:a05:600c:8b22:b0:46e:4882:94c7 with SMTP id 5b1f17b1804b1-46fa9b02c6amr45782655e9.28.1760005833130;
        Thu, 09 Oct 2025 03:30:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFU6FTiIKoa0UkBC9Zx589zDahv6+GU8nNOKIx+xH1kxdPK8/6eRVsJOlUDPEfHImp4fkFddw==
X-Received: by 2002:a05:600c:8b22:b0:46e:4882:94c7 with SMTP id 5b1f17b1804b1-46fa9b02c6amr45781975e9.28.1760005832588;
        Thu, 09 Oct 2025 03:30:32 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3cc939sm34647705e9.1.2025.10.09.03.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 03:30:32 -0700 (PDT)
Message-ID: <7d82cf5e-f60c-4295-9566-c40f6897fce7@redhat.com>
Date: Thu, 9 Oct 2025 12:30:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 06/35] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
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
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-7-david@redhat.com>
 <fa2e262c-d732-48e3-9c59-6ed7c684572c@nvidia.com>
 <5a5013ca-e976-4622-b881-290eb0d78b44@redhat.com>
 <a04d8499-85ad-40b4-8173-dcc81a5a71bf@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <a04d8499-85ad-40b4-8173-dcc81a5a71bf@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x2aGGhTBTNAMZ0Vh8Hve1Pgc3T2NGmPC4A_JPWIplMw_1760005833
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 68FE7180013
X-Stat-Signature: gm9jwpnw1iobk3bzz4wz8xbx4m81my46
X-Rspam-User: 
X-HE-Tag: 1760005836-731708
X-HE-Meta: U2FsdGVkX1+GRs+q+zlqq75JkHbLiOn2mReGXI0Fxn4ncADvz3SMRUaoke+PJUYF6NN9HIAvRxhrp7CDHAdFajfez5bbIBZWBsP4hi5Ismgru/7cmzq1/e+KUa0xuBNkXF5ovlYt8Ot8cXNDlpQctJylf0cwUg3avTFrxB2h/Qxpp6flCwTlECmN7BLibjgeGuC3hMWWTvzk2KNcP4l5UmDjppMnGyhecdR3F6xv7mXmoidHje6odBsv7f6hRC+FzA7/GXcB4q+eCRCnmVjckRL33ZFV9J0AISsqa0nCocJJVfSgBzDKlwgrslse4Cwc4tpFkrkxpP+CeHESJigNCPlWFNTbX0Q4dyJQtoK8rRUK7a7D2rpN4e+wr7kOwMrGV0T02cbcsfGpQPmmheVtWVW+fi9++gyoe3aBZme926QE5XEYAWgie8oSic1ZDZGHYVog9t2VvQjzTMGI1FppOvZXheqNNzyxx/IMGS3uP7YnXzOc/t6bGb6cy8zBve3GD5CZ9u62jbpv0F8okCoYI+VZTK9j4vjnpw7hW58nHk0FUMToEXIwXoDPJpdDDnfquqxOpb78ALUKro/I9X7FBQuQoHnptU+1wyihRqSHxGYpJErXHctYb/R7PzMYMdkSxsfdE7jBhzEGfyb9HE1jiBLuu/T61pr1YtpYoEVYa0cKidimpZtUexjbJsApye402++FUUJUGAHYXEVM79teFHjM9+wjBimp2PXh1s6tnUfdLQHB6Dj6cwHDDwyuBN4UviZBbGe0EUPvNF6Rkn95ee6fhCLITk8o7S3/e3SuxyrFUPRb6gfLVecbJtG3IH/jEczQrTYg90cvVL9KScel5faxZOZwsduPki6WADNN2Asy80FGO+axccZ7UHB4aH0EEHbKOqgnb+CNLmByarU+MZPN2vysKu5XaRKs+WnR0XVMkpSvOHUKgAPPBVID85QlzsGCnMYZA44+8EkGp7e
 qbTOvZrB
 T28ZBzcYUBdDuTgwvrVmJYxkJb/RSoEKx05yituBqKhz2yJwLv2Cs9ftGRJTSCpc4J/N3w9knsk+cGYOCH7TR/HKc5LSMVjd+NH2TgLyxyhsORikCyxBkQIVwoWeEPuJ3EMRvrb1/V7KB7TZ1rPgRKWbMdQpCMuto+ovYosFmjla/Rgde0rAzhbmxQKDwa4ergAv3FSq9VanbeYS879oz5LaTD8Wzv7YTDLmT3hh9piCCWZXN5ArqAWZ3N5KqRqPWMkbTPkIxHn9jLDBWgSvL7AwqECOgC8pkKnFKNWiV8mzUkLWFqbUYdcx2g+113XLGafgDhlbQKLIFKzvA8R6bS8U1lDqfX4JAyxciP/sHfwxX7W5LrDWomYHbg7YHGARsErUlcaV5NTQjc3GryWxfRG/oMOKSujD95m/kH4QXeZsGTwmEJ8u2Ef7epVpt/d5sN5FQBPNvec8HzjihbnEQ5xoCSQxOuv+ZLN74atPecSzMlZroyQae4icD5l8QaqSQ33Qp9FB4qfD8Ot2t8QBMb/tzgqiDYNjtvl+kgWQpH5P7gs6807pZxOBvJciVImOfR61Y3pgri+Uu8NDOXIJ75FuZf0/efpXkP+mkDdT+ueDv1RLLn6HeEPAOAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 12:25, Balbir Singh wrote:
> On 10/9/25 17:12, David Hildenbrand wrote:
>> On 09.10.25 06:21, Balbir Singh wrote:
>>> On 8/22/25 06:06, David Hildenbrand wrote:
>>>> Let's reject them early, which in turn makes folio_alloc_gigantic() reject
>>>> them properly.
>>>>
>>>> To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
>>>> and calculate MAX_FOLIO_NR_PAGES based on that.
>>>>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>> ---
>>>>    include/linux/mm.h | 6 ++++--
>>>>    mm/page_alloc.c    | 5 ++++-
>>>>    2 files changed, 8 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>> index 00c8a54127d37..77737cbf2216a 100644
>>>> --- a/include/linux/mm.h
>>>> +++ b/include/linux/mm.h
>>>> @@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
>>>>      /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>>>>    #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>>> -#define MAX_FOLIO_NR_PAGES    (1UL << PUD_ORDER)
>>>> +#define MAX_FOLIO_ORDER        PUD_ORDER
>>>
>>> Do we need to check for CONTIG_ALLOC as well with CONFIG_ARCH_HAS_GIGANTIC_PAGE?
>>>
>>
>> I don't think so, can you elaborate?
>>
> 
> The only way to allocate a gigantic page is to use CMA, IIRC, which is covered by CONTIG_ALLOC

As we are discussing as part of v2 right now, there is the way to just 
obtain them from memblock during boot.

> 
>>>>    #else
>>>> -#define MAX_FOLIO_NR_PAGES    MAX_ORDER_NR_PAGES
>>>> +#define MAX_FOLIO_ORDER        MAX_PAGE_ORDER
>>>>    #endif
>>>>    +#define MAX_FOLIO_NR_PAGES    (1UL << MAX_FOLIO_ORDER)
>>>> +
>>>>    /*
>>>>     * compound_nr() returns the number of pages in this potentially compound
>>>>     * page.  compound_nr() can be called on a tail page, and is defined to
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index ca9e6b9633f79..1e6ae4c395b30 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>>>>    int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>>>                      acr_flags_t alloc_flags, gfp_t gfp_mask)
>>>>    {
>>>> +    const unsigned int order = ilog2(end - start);
>>>
>>> Do we need a VM_WARN_ON(end < start)?
>>
>> I don't think so.
>>
> 
> end - start being < 0, completely breaks ilog2. But we would error out because ilog2 > MAX_FOLIO_ORDER, so we should fine

Right, and if we have code that buggy that does it, it probably 
shouldn't be our responsibility to sanity check that :)

It would have been completely buggy before this patch.

> 
>>>
>>>>        unsigned long outer_start, outer_end;
>>>>        int ret = 0;
>>>>    @@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>>>                            PB_ISOLATE_MODE_CMA_ALLOC :
>>>>                            PB_ISOLATE_MODE_OTHER;
>>>>    +    if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
>>>> +        return -EINVAL;
>>>> +
>>>>        gfp_mask = current_gfp_context(gfp_mask);
>>>>        if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>>>>            return -EINVAL;
>>>> @@ -6947,7 +6951,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>>>                free_contig_range(end, outer_end - end);
>>>>        } else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
>>>>            struct page *head = pfn_to_page(start);
>>>> -        int order = ilog2(end - start);
>>>>              check_new_pages(head, order);
>>>>            prep_new_page(head, order, gfp_mask, 0);
>>>
>>> Acked-by: Balbir Singh <balbirs@nvidia.com>
>>
>> Thanks for the review, but note that this is already upstream.
>>
> 
> Sorry, this showed up in my updated mm thread and I ended up reviewing it, please ignore if it's upstream

I'm happy for any review (better in reply to v2), because any bug caught 
early is good!


-- 
Cheers

David / dhildenb


