Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEF4CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E238E0002; Wed, 24 Sep 2025 07:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E948E0001; Wed, 24 Sep 2025 07:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6FF8E0002; Wed, 24 Sep 2025 07:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4768D8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:41:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 142BAC0507
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:41:10 +0000 (UTC)
X-FDA: 83923952700.03.20283DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 323CF4000D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:41:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d+V2WNT7;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7NBE1Ki5OUP9jlGIoLwtwOf/hcQQQ6mkLCpqaV+pnQ=;
	b=M2d9dZcz7AJI38QnPpPV+TTwjoehAHf1dsF4rtPpHsr9uaJD0zPWqQ9OQbpgvLbztLkLuP
	VigogMh9Dc93MNvCEDcorh1iQ1Xc4TDivWdVi9hlKK9zyY/pUUodjUzVLCVXsxtsUcR/L6
	2hsAHMcl8WSQgtfvMrkSb1OBiHfHHyM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d+V2WNT7;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714067; a=rsa-sha256;
	cv=none;
	b=zxzbIJTNwLXwwnExTyyA/FCUhAd+KMU6viSrz/OvuyNsDvpjEmqsjQ0DjT5YPMiq5+f5u9
	VINBqHofwQScT3cECQ+BZKmvflYB1zO0WGx/vxkX2voVdPZDqNU6TIev+71Di/UynoTxwU
	0tQwZAB6vDs/xS7diNSW4L22U4k1cNY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758714065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A7NBE1Ki5OUP9jlGIoLwtwOf/hcQQQ6mkLCpqaV+pnQ=;
	b=d+V2WNT7l+PmaEdtsSwTovgIMszDqX9eGVPYYrkGL2O/dRbbGJoqd9KgKLEi7KKNxh0iBV
	QJsjCpH11m3EtLtj3EMdrd/gAEhPh6SrfhFqNsX4YUgSa5Ody4TAcnYPSFm/rA8TGGfiA9
	FzGGeTwVk6LVVLXU29yJ9cpnsc06HR4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-CgOSfMs9MpGwYYdP_cMm6w-1; Wed, 24 Sep 2025 07:41:02 -0400
X-MC-Unique: CgOSfMs9MpGwYYdP_cMm6w-1
X-Mimecast-MFC-AGG-ID: CgOSfMs9MpGwYYdP_cMm6w_1758714061
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee1365964cso4649497f8f.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714061; x=1759318861;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A7NBE1Ki5OUP9jlGIoLwtwOf/hcQQQ6mkLCpqaV+pnQ=;
        b=c/dGkQoElz0xz46bhGOWI41uxEmLt43j5AaKLXQ+BBcydnmNqwHgkG8ns8LO12lG29
         gBcSj5YEao588Dr9GC/LrDlahDaE2xDLbpUK3nm4oXP3Wxz5uqrUvqIgDAoRRR7IPF4j
         a30zJINyKXP1nwy0Ae8dw4ITw5qfWjX6+b1WX1+qdiDLdqorHSsq7mZZ0spBFYvBc3Zf
         qKPqr8eDJ4D4BTCC1vOtF7Y8s4xjrGOkIbV+1BqD5vy8bAUVgT1Xgge6qwFtVeqyQg7J
         n6/BfrryzjGIhLSv6xJtbKKz5aI9UYnQ5oW3P5N8Q7LYlFyD4iItnleQifRJvpg9nacq
         W1+Q==
X-Forwarded-Encrypted: i=1; AJvYcCW5m2IjVqS1mLytXshUhAG/9x4AjiWiYF+otcBimlOnahyS5o4uEr/+EZDuuF3i5Ya+ElzO8TcxPg==@kvack.org
X-Gm-Message-State: AOJu0YwlIjSU1m6tZWaEYNz3ASqOa6F+3qVPCri1+DP2uS57rEinICEn
	6K8kFpt6ciWfo/KZdsItrz6K78iq0DVtxPDRX5T7DHfTK8895yltBKpISmUBSa4mZHFtalucwxP
	mz5RBu7hN0u7GHX9fDyfYzoiF5ZAu+q7qZYfQXfajsd/jkChYESoO
X-Gm-Gg: ASbGncs7tZOkmD8+rIIjl0OICJpWPJc3SttZDp9q0OyIyjyYj3/d12xaNuM4jsO0md9
	MNwmvrwapJEJ2Dot3dJwZn8JBJM8T51Wd7+VXhcxOR/nUHmf7zIR4L88YyDRxUqk26m3kaeiw3a
	V+mgkSv0lVC85rEC0u4USqDd6L5rlamhyQ/FFlbTi016Y2ctw2Dd+zdRHhbdObmpam7SilaBlXW
	Mg3h0TNIYEubas20KF1sDQMOBm+dr3ndYLo0vKdrKiRCTTDe5vXZcGQYIHzADTlNpk7BeykbyOl
	HS8T1vwCzkQlLDtAOpmE0CW0zEwPGEI9OXVWU7qaSOx0KREaA+G8YLaQi4ZhVMRBqbHGhv6taZN
	7yfiHyeVIdEsEtwYywSGrN7GQ7bg5JOWRcO1szITYJ7UsrensHBIvK5avP/ywxeFzwQ==
X-Received: by 2002:a05:6000:25c8:b0:3e7:1f63:6e7d with SMTP id ffacd0b85a97d-405ccbd6d4cmr5702081f8f.45.1758714060940;
        Wed, 24 Sep 2025 04:41:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgfrvynla+wHkmS6uu0qZf4arTWCZv+c0BaB+ytWjIg9L+sNJcWew+zKX2Y4WNBmLdO2qKlg==
X-Received: by 2002:a05:6000:25c8:b0:3e7:1f63:6e7d with SMTP id ffacd0b85a97d-405ccbd6d4cmr5702054f8f.45.1758714060475;
        Wed, 24 Sep 2025 04:41:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f02f332c31sm21831543f8f.45.2025.09.24.04.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 04:40:59 -0700 (PDT)
Message-ID: <81a827ce-24f7-4038-bca7-c96dc558cb38@redhat.com>
Date: Wed, 24 Sep 2025 13:40:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
To: Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, Dev Jain
 <dev.jain@arm.com>, Wei Yang <richard.weiyang@gmail.com>,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
 <5491dfda-862a-4c31-b64f-5339007a5302@arm.com>
 <09284390-5a1a-47e0-9929-0a5ba98c836e@redhat.com>
 <760C8EBD-9201-4680-8B9B-CAD7641A81C4@nvidia.com>
 <aNPW4Ynrxyn23Ko8@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNPW4Ynrxyn23Ko8@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bszth41LFuYqbQKero_FnShLfgB7UamBVZ6V32MTl8M_1758714061
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 323CF4000D
X-Stat-Signature: wwgetfswpp86cq7p8n7h6pcuxrpxw63j
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758714066-327522
X-HE-Meta: U2FsdGVkX1/TAx6hAXXR9UWFDE4pOnCL+vhP6yH6YyzPcKXRANZtqEK0ZT/P8gRi0MbEsOnKrhluqffrM3n8Wb0Q/i/+zc1WiMsQUaKD4N7ToehchZJYTa8u3nuJq4piQblVcJqXzkTRZEz08yKxwPSu6YH3ShQO2kFeXz+12MO6oDrdTJ+/SUuU6OVUMwZ8pqWtqWnyW+E36dYf4JcqdrUgJ6y7JuNqXdkwoMx9gSTVXD4NRRpt39r/AJF2r7dRwAacM74sUVw56t0EAIV62EGG5CBYRhEyTTq4ZtNuBJdlmI5cvNbUpcDBUjYs8joEsi6+QNLW0yz7yxb7OE/U/o4aDxqghAElPut8z+K9p9uhW20pbd7wxJ6WmKgPtntXCjgomPuDFAauiAMon9MkqlfaHFMdPc0abzcgp0Dwp61hhqizk3+7rSIIUoSlw9Ri3Qs3wbOzp4NtBEGMjkVcW1db+825y4tFJBw1QHfsoBgQ3ta8TeuRu5imVT7Y3ydo/C+MjalmK/jnWiAgDBBqrbJKAfk136W6pxmIs9ccXAkwN4yqF9Xl51HDpEFQ6s2Crj3uul4s4fW+ZxQDfNl4+d00/ndSIgktWy7vkr99JWEjKAikHIIMZUhYu8s3orBXkJTUKj6MWjueHJKZeNFwDsPHaWotVX3SQF1wHu4QRwzNJm96LQ/waPYqdkGzCJ3tSjytLr9iKyXn3lnLGF4a61A+EODjqEw3/ELYZNZC6mji+NTn7PGvR1ijFMQic934HGKZT3Hep5VDjsaQ5xVsK8Ts9e72kG32oDYbjDvR2iY2U/UPbnFh5iEV0YhI4WYYhqjfKwEWOK9KGEdWyhprnD/1m/wNY8E5zB3gRNj7fAgaUcJ020KtzzARiiWDQv2ZnX+/H4aKVOLoWQRrXvXezptFiFsgM/16YWPZc3ccQvdkGElWIzIpi+mkQEPFmVtw8CqEVPEEgqKdqKRdtr4
 Xclqynfq
 uGasr1z0c/UZgRSY70+ws+6WtEebiFRf4Q8r/PFGAfNOkh8S96j5JMpvbwDHr/wGwSt/wyH8LhRGlLQ6XgmG33y75PurNtTQyaFnB7RxdANQlMEbaoEns9rJsdfUyMxsQ1rmhdJ/osHpJKMQWdNp8BGHoijHHTc6Lp4ncWEQMRXvXOLtUFTQqzpIBIjQDOqmIuKANR/L0T2M4fp2cBue84XeI2Z0Wt30nuOWFOcPnGOO+wu4p6oWmz7r027zxsCbwSuEDf9atOuz6D0M7Cw4dWIKPSP/YywTmC6uiUg6+uJAP3HGwDjL7bpRnGd/OsBNjkubBz7VZVNpD/mV8bOsFucwelfEWEpJFV2joYyzdPQxnn9EZRfFKlrf1d/BTWCSU9BVpXL6ETO8fMdWZqEMHnFBfD+zYoD59YtZaFATwRreR4FatDxsYUSJbB6mB0ZOt+2mBQ/i39liSZyvhMbNxQFGV5Mo3ASkjNErGjSLA9xrh8AKnVADSCOsl1xvM+bpGpc8/PZT9BSmOwLkhfxRyvAZxF4SDopzs3IS3t1dcGo6+CWA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 13:32, Michal Hocko wrote:
> On Tue 23-09-25 11:07:28, Zi Yan wrote:
>> On 23 Sep 2025, at 3:48, David Hildenbrand wrote:
>>
>>> On 23.09.25 09:06, Anshuman Khandual wrote:
>>>> On 23/09/25 7:16 AM, Zi Yan wrote:
>>>>> On 22 Sep 2025, at 20:19, Wei Yang wrote:
>>>>>
>>>>>> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
>>>>>> introduced generic method for alloc_contig_pages(). But the alignment
>>>>>> calculation seems wrong.
>>>>>>
>>>>>> Since ALIGN() only accept power of two value, while nr_pages could be
>>>>>> any positive one, the result is not defined.
>>>>>
>>>>> The result would not be any value lower than zone->zone_start_pfn,
>>>>> so the worst case is getting an unaligned PFN range. I guess
>>>>> most of the time nr_pages would be power of 2.
>>>>
>>>> Agreed.
>>>>
>>>> Also as Dev had pointed out earlier, this function gives no
>>>> guarantee on alignment of non-power-of-2 requests. Hence I
>>>> don't have a strong opinion either way, but does it really
>>>> qualify for a "Fixes:" tag ?
>>>
>>> I'd say if there is nothing to fix, then this patch is not required.
>>>
>>> What likely does make sense would be that a non-power-of-2 would be aligned to the smallest contained power of 2.
>>>
>>> E.g., a 6 MiB request would be aligned to 2 MiB instead of multiples of 6 MiB.
>>>
>>> Not sure what the existing ALIGN would do with that ...
>>
>> Something like the code below:
>>
>> pfn = ALIGN(zone->zone_start_pfn, rounddown_pow_of_two(nr_pages));
> 
> Please let's not try to fix a non-existent problem here. If there is no
> alignement requirement then make sure we document it and drop the
> existing ALIGN which doesn't seem to serve any actual purpose rather
> than make the code more subtle and more obscure for no known reason.

I think we need at least one initial align because the zone_start_pfn 
might not be aligned to the desired order/nr_pages.

So I don't think we can drop it.

-- 
Cheers

David / dhildenb


