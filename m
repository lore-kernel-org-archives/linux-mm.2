Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9220DCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 19:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45B58E0003; Fri, 29 Aug 2025 15:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4AE8E0001; Fri, 29 Aug 2025 15:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABCE38E0003; Fri, 29 Aug 2025 15:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 962468E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:20:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1680813AABF
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:20:22 +0000 (UTC)
X-FDA: 83830761084.07.97222EC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9A2651C0003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:20:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QVJTNUqc;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756495219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NAjWIEF3OHDdqJteBDySUrwv+3jmvYWnfV9qt+QTII8=;
	b=V1Pf0XjAwOlhgpLRgmSuJ02SgejobNKreCduRHmlAeMHDs9EU1Ryf3P4M2BtRGL57E8lTS
	F13wMBqL5zOut+kwWJlKiuj+iuHfrqYCO6IwRU7lv65me0RkVGB43m1f0bXyTiH5Y2B6lh
	c0zuY+udxqBtHhsYSLKUGIiDxucWonM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QVJTNUqc;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756495219; a=rsa-sha256;
	cv=none;
	b=Wq8EAsTb6JqUDW45PpgsKwHMAwodA+pkrIvSCTbqu5hlorIbs4q3jMRkoK2YuScjDhwysc
	Xv24CsFZ3TANd0L8kD6ihVZNw0nXtXo5orEOqdJE6eQKXR5n4YDCte1Alg4QaaWAUQ5U22
	8FBiKCU1vKVfjTVJo2JFI/nFsV/JFG0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756495219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NAjWIEF3OHDdqJteBDySUrwv+3jmvYWnfV9qt+QTII8=;
	b=QVJTNUqcERL2pTZQEWiypTQgzDeWdclFO1/CZv0V2HmWFNC/nTZ0CHskzNFLi5gpTx6GKQ
	FmfsopOVkp8H90nTHkZbPkHXF1ebUgctrj6BRLHxAQAwelza4/jahStwfvHtOhFpfW4Ijj
	8FhOCv4290X34iC6J6kKgfaXovsr+SE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-fPQyDE3zNkC7b9g24xfObg-1; Fri, 29 Aug 2025 15:20:17 -0400
X-MC-Unique: fPQyDE3zNkC7b9g24xfObg-1
X-Mimecast-MFC-AGG-ID: fPQyDE3zNkC7b9g24xfObg_1756495216
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ccfd9063a0so831720f8f.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:20:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756495216; x=1757100016;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NAjWIEF3OHDdqJteBDySUrwv+3jmvYWnfV9qt+QTII8=;
        b=rB3qgNExTd8VUwQhOW+p0znuduBDLgiQUPcjTfqUrcJjvTS6/4ZSgNoW/WKSY5awkJ
         DwT4EFYUBZIm74Jxm8CCDwCnrHbMYEci26EdznOHwr1c0cHjVwyJ16MsPcySM+jIzq7v
         V+yf9eH62En0wWRxx5xsh0bFsoQLLG/BVDEKPGwYXu9lcI4fucPilWp1xlUNypS6pJ6M
         ugTY6TiZeTN4hqMfnRBlz74HJ3MIWlMfC7WvSz0MfluAETbttUtjlxe60/96daY+kvgT
         KWQPb/y8ymxZAvz+brzs7yeAmWR1UsQOnyVIvfWXt9FQE9M1TvEPz6c+18OT7FRC8tHG
         t73A==
X-Forwarded-Encrypted: i=1; AJvYcCV9yCDwLqeHtPDsPVz2OBaMESJ09vMxnbKakF+qO2IacMrwOzuiwDij3hfpMBRq3FkMRBMwkRg+Mg==@kvack.org
X-Gm-Message-State: AOJu0YyM8J0QntUXFih9rv/ECpZuDkCc9ZvYcd40X82XwF3MtndzWEzO
	XWHmjo+jgjqWyRkjwO0XejSlg2ySR2SpOhxmfjn934ZXfNCFahrCMXjhXS1qtUHdGaqp7QQKlkt
	XWybiK1QPBU+9vOiRNyJ9W5hvTbakIsvniIZctvUdAivQhAurc6sW3S/mxwFz
X-Gm-Gg: ASbGncunrlfD1jbWWjG/pNrNHzdcFNHF7zL58vSfjoML8kmOqWHSkgEJl3m0HmviRb4
	dmuUGIZHxw52xcFg5xDhihRsKazIiC+1ap2qUbpKT6a5HBlZedZ35Y6th3JaIM/zSVtw6V6W47F
	P2ADtF46pulUcjoRHg+CiV51FdE2BsKTMid22DHvgZIVQNpvI8DTPkKmxqD96rRde96rXQTKt58
	rSDnb7iXDvrFR1rA7zH66nIdPx3GbMyvkyRQLtVyebn+TSlqHLXsKWCSYOPM4Ut9p4CSC1EAwNn
	bCTkDYEP2qg8dhP/58IL4YKGhOzVrNe529xVc9PZD7rLc1OQv+RLd7CPTky6ovPbYEIxIdOeM3n
	5dHEQ/dYip0gcMqb3nolt/fmKtPT+tjc2ZVYYfnbiSE2He6OMwy/hSx4CkYUfDHEX
X-Received: by 2002:a05:6000:228a:b0:3cf:fcb6:ca0b with SMTP id ffacd0b85a97d-3cffcb6cf29mr2544897f8f.15.1756495216307;
        Fri, 29 Aug 2025 12:20:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHs0Uh+6VEcy1VTnuVxufD7ppXirHFfXgEbrAQ/o7ENL67ut/WpXEaakTh/mWWd5dNxuNogpg==
X-Received: by 2002:a05:6000:228a:b0:3cf:fcb6:ca0b with SMTP id ffacd0b85a97d-3cffcb6cf29mr2544885f8f.15.1756495215849;
        Fri, 29 Aug 2025 12:20:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d1052db1f0sm2828033f8f.23.2025.08.29.12.20.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 12:20:15 -0700 (PDT)
Message-ID: <bcf7e932-0a14-4cd9-b994-50114013d96b@redhat.com>
Date: Fri, 29 Aug 2025 21:20:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][v3] mm/hugetlb: Retry to allocate for early boot hugepage
 allocation
To: "Li,Rongqing" <lirongqing@baidu.com>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "osalvador@suse.de" <osalvador@suse.de>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "giorgitchankvetadze1997@gmail.com" <giorgitchankvetadze1997@gmail.com>
References: <8c6e91ecb80c4707a52c253481cba51c@baidu.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8c6e91ecb80c4707a52c253481cba51c@baidu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QdH5KVTxYxrf70x-PBbmjj8Z0pB47aJ7IQCHAhitmYY_1756495216
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9A2651C0003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dzhfk5scxs3r4wmy5zyw8xi4xno76m9t
X-HE-Tag: 1756495219-380556
X-HE-Meta: U2FsdGVkX19NNUdCa1GPEZjQD3yWX8DpzdthRMrzHTeAzHCVbhyac/oGfxP+rEONf8QGB4tFOMYJ+UWf4GrefXbOdbhvy1AfSYTssOBLkg7EfcbD9A0jURHuJ5wDEvNnkHVpJ7NbdjC/lqwTCqG1Zaj6ebr7iKuq49USZcsfeoKai0h+Y8tMShQCADg7UDS0QR/A40o9v8BKCyTU302pIo5uZpMFwhH1NazfuSOhWkNJtluHNEc0zjSo2sx46ptpUkRfW/Yu5X+7ojh+tTEpb2sKzCDiein+lwR9iu6oMpgKXmrg35K+d0DJWXEe9oWhaM4wU0rA6zsJp2RzHKs4RAvsMVTcTIDxLMSDWUu+gR7/jn47IMlhYRGlPHJztUAHTxhbcj2da5nyMONeHW0dWTsHJk584dwPFdw/gBgjPtlPMStZfU+u5ZXX2vbSwiBZOXYGUWU7Y3cARrpslUQgMiOrmIZFneans8ENvqag2XcTkU6KZgy03TLYwrFlp72QQaXlXnxpHhez2YydzvPxGKSDoQ/xU9tJyeqBE7J4RnQw0YY54uJNyVdbCeiqPswrG1VCMG7OOtDD51wyEF9OcZFjozyJ53M+zmpZZ9n6dV8q5sefV3ZwVkm2YgaSVe969SFjKMO1LM1ETZxIfbZxnIxbs7oD3vETbQM0sIo87RXLY83TMRW/NGPPccX2eYWgbs/O9JN8W6w9zbnnUkRAP8Mn9j+a7pAPkAdoYGGylBLZqi2rdS9KyOWUHL2KuJ0OJM4SgeACwkaMOBn8b9EckYSHZwb689x6szt4OfnN6tCdtikxrmZxHWgsFIVOXU5itpfCLhbe2n7B7aOsaoJ2tddVHs9C81Sl3wtCdhy3QDGEbUQJEdwQ3m/9aAbfrrnak571mzGhaTkr+op3lUPboq2q3F/kSM1QkHt6eK6SMiPhpSIZhKoiQm4vf9HJ3l8l3bgehG54t6jzImkW5oy
 lmrksg62
 wcFLOqp6XdV5W35seTHdIIG3HKL3PX12/fNZ7CvcZHu3WWD470TE9YOX/KQh4eOzj3um27oXzxO2H+v8L5/NaL2Gpy6JKmv+vwFLyZzSVPKwp7TLWGqpz9waiyxMhqxnY+fs+1dKuVOinmLi7RPblLh9MyyhNVVv+7et2GS1E7NtFC2jhDC9YsxKJRcN0CueO0Nr6yBR1DuNp9olc4hhEf5a+xaPBa0Q8r2UDZcFPZga8rL9Qeh2RW/ykCiASCgBmaJ6GU5P8L8Yef1r7als1V4Ldx66/VEpa/Ekjnnm8zGS966T4jTkZ46Onmxhhp9K6DMfyuMWuDEQwDUl/RqSQVHwz+QKV40zWaqrRtn5CY16V2xAe2juDPtUUT6Na9aidcO8hzM01u8W4g0m/3YVqy/i3mS2aqykUF4LDq2b5EihMzXW5PCFQA2U8F6L43woAIx/lSX1C3wU6IqZ51JR1t2qjSGRnnrEuxJVH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.08.25 17:20, Li,Rongqing wrote:
> 
> 
>> On 29.08.25 11:52, lirongqing wrote:
>>> From: Li RongQing <lirongqing@baidu.com>
>>>
>>> In cloud environments with massive hugepage reservations (95%+ of
>>> system RAM), single-attempt allocation during early boot often fails
>>> due to memory pressure.
>>>
>>> Commit 91f386bf0772 ("hugetlb: batch freeing of vmemmap pages")
>>> intensified this by deferring page frees, increase peak memory usage during
>> allocation.
>>>
>>> Introduce a retry mechanism that leverages vmemmap optimization
>>> reclaim (~1.6% memory) when available. Upon initial allocation
>>> failure, the system retries until successful or no further progress is
>>> made, ensuring reliable hugepage allocation while preserving batched
>> vmemmap freeing benefits.
>>>
>>> Testing on a 256G machine allocating 252G of hugepages:
>>> Before: 128056/129024 hugepages allocated
>>> After:  Successfully allocated all 129024 hugepages
>>>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>> ---
>>> Diff with v2: auto retry mechanism
>>> Diff with v1: add log if two-phase hugepage allocation is triggered
>>> 		add the knod to control split ratio
>>>
>>>    mm/hugetlb.c | 27 +++++++++++++++++++++++----
>>>    1 file changed, 23 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c index 753f99b..18e54ea 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -3589,10 +3589,9 @@ static unsigned long __init
>>> hugetlb_pages_alloc_boot(struct hstate *h)
>>>
>>>    	unsigned long jiffies_start;
>>>    	unsigned long jiffies_end;
>>> +	unsigned long remaining;
>>>
>>>    	job.thread_fn	= hugetlb_pages_alloc_boot_node;
>>> -	job.start	= 0;
>>> -	job.size	= h->max_huge_pages;
>>>
>>>    	/*
>>>    	 * job.max_threads is 25% of the available cpu threads by default.
>>> @@ -3616,10 +3615,30 @@ static unsigned long __init
>> hugetlb_pages_alloc_boot(struct hstate *h)
>>>    	}
>>>
>>>    	job.max_threads	= hugepage_allocation_threads;
>>> -	job.min_chunk	= h->max_huge_pages /
>> hugepage_allocation_threads;
>>>
>>>    	jiffies_start = jiffies;
>>> -	padata_do_multithreaded(&job);
>>> +	do {
>>> +		remaining = h->max_huge_pages - h->nr_huge_pages;
>>> +
>>> +		job.start     = h->nr_huge_pages;
>>> +		job.size      = remaining;
>>> +		job.min_chunk = remaining / hugepage_allocation_threads;
>>> +		padata_do_multithreaded(&job);
>>> +
>>> +		if (h->nr_huge_pages == h->max_huge_pages)
>>> +			break;
> 
> If all pages are allocated, it will break out from here. Since in most cases the first allocation is successful, I have moved this check to the very beginning.

Missed that, thanks!

> 
>>> +
>>> +		/*
>>> +		 * Retry allocation if vmemmap optimization is available, the
>>> +		 * optimization frees ~1.6% of memory of hugepages, this reclaimed
>>> +		 * memory enables additional hugepage allocations
>>
>> As I said, please remove any calculation details about the vmemmap.
>> That's not the place to have such calculations easily become stale.
>>
>> Something like the following:
>>
>> /*
>>    * Retry only if the vmemmap optimization might have been able to free
>>    * some memory back to the system.
>>    */
>>
> 
> Thanks, I will fix it
> 
>>> +		 */
>>> +		if (!hugetlb_vmemmap_optimizable(h))
>>> +			break;
>>> +
>>> +	/* Continue if progress was made in last iteration */
>>
>> Comment wrongly indented.
>>

Maybe just comment above the loop that we retry as long as we are making 
progress instead. It's unusual to see these tail comments in loops.

-- 
Cheers

David / dhildenb


