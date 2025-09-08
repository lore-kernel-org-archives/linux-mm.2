Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76EECCA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03C98E000C; Mon,  8 Sep 2025 05:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4718E0001; Mon,  8 Sep 2025 05:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3618E000C; Mon,  8 Sep 2025 05:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 900368E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:14:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D5571DF7B5
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:14:55 +0000 (UTC)
X-FDA: 83865523350.26.6E61C0A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id D28A6C000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:14:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O05P3s2C;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757322893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzcPvwRTvfDw+yZlp7hvvbxIV0w0du39GWUeSOlm0y8=;
	b=3ZPvltvyvfmHRMR4Z0zEnbK5mP0eiEbft+bktHxTzQKqpm7IzPuuSG3CHZUmXPs09ihBkQ
	27j12NX8FmHrnj9oj76b1CADd7+3t9ssJ1B08C3ENzB1bavh/gLznKKwctZ9mUrVEoPGlq
	ECVv2L/icBaYPtCzSh2TGMrDJ3jbieI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O05P3s2C;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757322893; a=rsa-sha256;
	cv=none;
	b=fhkqHFvZ+T4eT0KnZHUdMweqeQCr0BBQb2MGthshrcZ+i0KlJIrgiV2Jo9xUeaRk1ggUBG
	SI61qC1iFgtuwfn4LA+yFa84+ZaTLaWJnRannEJBY0D5EwsIdnjCHDB+u461nSrCR6rrsm
	mQEcZJUZ7Q245KYlGBGrht1SMU03vrE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757322892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mzcPvwRTvfDw+yZlp7hvvbxIV0w0du39GWUeSOlm0y8=;
	b=O05P3s2ClftJNKUlEAp9CSJuw2FigmFyW7IVra0ecWf8TdLxAIobb9Bs7dBSeQg24z4t7/
	819qTaJRYyqKl8tKgUNKdxJyRYTjDq7+Fa5BrPACkaInrAquEYkbJQt1JLGAELfXqizZ1h
	i+dQDAaBI7C/HLihWeNfS3baXYA3cuo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-kEiuf3_JP8GTK6HiEnTeyA-1; Mon, 08 Sep 2025 05:14:50 -0400
X-MC-Unique: kEiuf3_JP8GTK6HiEnTeyA-1
X-Mimecast-MFC-AGG-ID: kEiuf3_JP8GTK6HiEnTeyA_1757322889
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45dda7c0e5eso23148705e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 02:14:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757322889; x=1757927689;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mzcPvwRTvfDw+yZlp7hvvbxIV0w0du39GWUeSOlm0y8=;
        b=BSGtcY5ymHSZUb2TXTxXQkwFZmas5LrOr9LYfOXAYX0y6tYBSjEm9lPKYuk14I0m+3
         dlh5CbxckO5nVW+8BJNEEuoLPcwL/uaZT/OySBQu30rHoPj4gVyRVx+E540GNMViyRpj
         EBFhJ/41qQvn0p2WHSIG/D6ayP2arD6vyt056ESaMFIpnN43CYIGD7AW8TXPSweamron
         JoCXqUkzbA5vq/dc18RBhLzfj/NhGGLvXDuWsWQI9ANs2X8GeKzy9Gtgu+tNvL4a0o+/
         X6mfSV1Fn8bdFBlAs1OW/MlD7fUNOgkQBKd4a2+OM/eUGXeuq9t3ZnZOosY/H4OWQGBM
         eF9w==
X-Gm-Message-State: AOJu0Yy6Gp93wOD4DnfJr9gqDqiT4HA4xLwfSY7iIhfqPxiGMYiUJJtz
	SDZJJyePZzFGjQTOCWCzSHmfo2w5oPCJC2BhAlRPAMZILxONURCn4wD1OEryAXSpF6dmUN+tuQx
	TEKuoU1YGNSYDR2PHIULrawS71CghRd4IjMtfLrv5JLgTP6/2tHr6
X-Gm-Gg: ASbGncvCvOQQ2lVJ9731Ylo+Q0eDktPRoikLmU+dfJxF/TtdmzEVLgiIV2qRXCtJfy7
	A8jRsvrmbhIUoHTIqpQp4DiMpLp5neOqR81/CvegbPoDzzcZKw9lyhxW124F/S211ad0BChLFn5
	cwx1GQQqDDbzMHqTgezOQd4kj4tTLEjN+kPZoxXl4G6rl4qfmq6hgG+HwVqePbcLaPOOaVZa63j
	M/0GAyckLrIokyCknRfohoArYpxW67qDat0YIR4IPb9NzhNJKwlIIIG1uIoBd8kM9Lg+flbqOf7
	S3T6A4f8H4oPrXZ7uWUBPzZ/HSX2NXmy9sC+lpXRwuUA/QOTzCQAc43e/yLhqk5ZPATxEavuuGM
	Ab8e8nOc6bcw+Ep3Q9nmL+wu/xh7+oFOUVG0pu/+ffQZacRjaL6dfG/7buJMNhOBm
X-Received: by 2002:a5d:588c:0:b0:3e0:a5a2:ec9b with SMTP id ffacd0b85a97d-3e64ca76350mr4700089f8f.52.1757322889386;
        Mon, 08 Sep 2025 02:14:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESch+TvPw/XuuDoI/s8ofhAgmUojqK0jp/GaJooIEd0GJefywm4JIByf3OsYAT9LaECB1NBw==
X-Received: by 2002:a5d:588c:0:b0:3e0:a5a2:ec9b with SMTP id ffacd0b85a97d-3e64ca76350mr4700054f8f.52.1757322888839;
        Mon, 08 Sep 2025 02:14:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf275d2717sm40764051f8f.15.2025.09.08.02.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 02:14:48 -0700 (PDT)
Message-ID: <1b95ca2a-bc1f-4e11-be4e-8341c3cc278e@redhat.com>
Date: Mon, 8 Sep 2025 11:14:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: Usama Arif <usamaarif642@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>
References: <20250905141137.3529867-1-david@redhat.com>
 <06874db5-80f2-41a0-98f1-35177f758670@gmail.com>
 <1aa5818f-eb75-4aee-a866-9d2f81111056@redhat.com>
 <8b9ee2fe-91ef-4475-905c-cf0943ada720@gmail.com>
 <b56b43c1-d49d-4302-a171-9b00bf9cfa54@redhat.com>
 <8461f6df-a958-4c34-9429-d6696848a145@gmail.com>
 <3737e6e5-9569-464c-8cd0-1ec9888be04b@redhat.com>
 <3c857cdb-01d0-4884-85c1-dfae46d8e4a0@gmail.com>
 <aadf50b1-151b-41c6-b60c-5f1f2a4f2d8e@redhat.com>
 <d48af6f4-2ded-40f5-849d-7aa991727a59@gmail.com>
 <701d2994-5b9a-4657-a616-586652f42df5@redhat.com>
 <686943a6-7043-41b0-bd4c-2bfc4463d49b@gmail.com>
 <e41c8d5d-5685-49f4-a5f5-87513674a03b@redhat.com>
 <27460707-3d93-4ff2-bc99-da96d26758e9@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <27460707-3d93-4ff2-bc99-da96d26758e9@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FlmcHdhQiM4hb8PlgN20SqESwBMsHdvlCzDwUzJwreI_1757322889
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D28A6C000A
X-Rspam-User: 
X-Stat-Signature: psun4ssdqwfm7upgbir34xhxfnmd9785
X-Rspamd-Server: rspam09
X-HE-Tag: 1757322892-486104
X-HE-Meta: U2FsdGVkX19bE+iEN32t1tbyDm9z62DqE2+d4y/ytCMrkT1zZpHexaY1LScaRYzkOefTPI78+OXLDJ79AVgyER8Fp6afSwgX7grcgLpoBp7zTmkduEvIoMmX0qBH4IzuBFFMxb6RJ+K7qMUnHfUfCqxXa1QcfqEIsWTKaV9F4Z44bn7VIE+pbUIfjbFZnZHOJAA6G8+EQw4Yu+ycpmk6v9UDC8TA+a88monRwGxyJIOxxoEroMaQPczs7U/+tiUzUERfOngkOll6mhX6N5H2XeglXNeaUAUJVaRZNn8O+VTK4HY14nH1J5XpCV7h/TNRKSxcPwsZ2n/YvCk8r4DhacQSz8tmnBwB3R+b7eLCbFOk4ou3YwZ8TBP9uWWHzFc+eX0on2NYGQIjlDS0sATFWOM8F45vg8OfFU+aEuOMM/VgbZ6tvnTIllXIbfxT9muOdUrSG6gvrvhtAo8Dw+g+uuImQG64JlGZLs0oJp5FVzZ51P8L6ubKyV5uixAOeYjGUSoDH+KRN1wn54zcx3dCZ7Q+ZSnlh5hsbV/pqcJUsUtm4mYiPyCY/lFgIDAaW6NiYKShoyLjR95xli45cDx0uvKCa91DKzkY4Pbi1hyeagN65SLgPRYw4h9Fibe6nWZhLE3akBg/bWeN7OLFroRibXLGzuDgDazzy5MyZgu+VPOdgpMVZNMRVXhKt8aY08rdbIv4wXKZHbVKY5oBfuWjhnvczyr9CaujdKL7ozum/s1dgpuMh2O+rEbeY/4CKYwCWhvSKpl9d1aXRjndRMXW65XbkUZZ6FzXA0Pk2kCqJltTJziVT98Td9V5O8zDbQ/k3nGDNBEoKGemEZ6deCklzjy7U5gHxxg4ZQ5TB97gM/sMyWk4y4+bVXglc99cPLEDc0/PTJydWyzuywV0YbDb+++lXqHUFgOvu3JzqIr0BV0jBBoOZG4dFFpXyI32XqiShnRWCNORwTizNTMoWd9
 IUj5NyXc
 D83rmapj5hm/raCDwb1C44c5U271Zno4D+Ai0YXxzfPO2HaePhOoNxJ3MHb1xAOfC4BHqjPg8pY3EQKNM50j/BAwDBAQiqL1GxsSiJIN6QG0Eyy73wuKXv8jrA0eJTrc5GkxVce9dBXNxkDQOfTWFe3X78TfDcO1GQWwM0atNJ7xIrsWyIBIsiRf3uFDxVAIM88Q8pwFz8VGsADTvKG5xTxOaEDNTlhu2lNIIDGnhhUTHgO2kUBm8HoZJojIk2Z0qlCUxei/rQI1OodXiOyHoib6xMl1SnRoDcpynxJucz1XNj3UwGlyzj+d0KwY/5iw/uZq0R2qSY/rL/iQtNo2vZ8PY7c1VPSccoZH5JF7qW8iK7wdh0GQ2VbP6Ql+3rZMMtFO4TAxO0jWgvCdouKZYN9BsL0u0nOxGxbeVNIrmPhBY5jgwbYX2aU0IMT1j8ROaocBtiGBLaHIebtmOf6AJKz4aX3rRmlq4V/jbC2tumLM93Ug=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 19:26, Usama Arif wrote:
> 
> 
> On 05/09/2025 17:55, David Hildenbrand wrote:
>> On 05.09.25 18:47, Usama Arif wrote:
>>>
>>>
>>> On 05/09/2025 16:58, David Hildenbrand wrote:
>>>> On 05.09.25 17:53, Usama Arif wrote:
>>>>>
>>>>>
>>>>> On 05/09/2025 16:28, David Hildenbrand wrote:
>>>>>> On 05.09.25 17:16, Usama Arif wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 05/09/2025 16:04, David Hildenbrand wrote:
>>>>>>>> On 05.09.25 17:01, Usama Arif wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 05/09/2025 15:58, David Hildenbrand wrote:
>>>>>>>>>> On 05.09.25 16:53, Usama Arif wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> On 05/09/2025 15:46, David Hildenbrand wrote:
>>>>>>>>>>>> [...]
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> The reason I did this is for the case if you change max_ptes_none after the THP is added
>>>>>>>>>>>>> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
>>>>>>>>>>>>> so that its considered for splitting.
>>>>>>>>>>>>
>>>>>>>>>>>> Yeah, I was assuming that was the reason why the shrinker is enabled as default.
>>>>>>>>>>>>
>>>>>>>>>>>> But in any sane system, the admin would enable the shrinker early. If not, we can look into handling it differently.
>>>>>>>>>>>
>>>>>>>>>>> Yes, I do this as well, i.e. have a low value from the start.
>>>>>>>>>>>
>>>>>>>>>>> Does it make sense to disable shrinker if max_ptes_none is 511? It wont shrink
>>>>>>>>>>> the usecase you are describing below, but we wont encounter the increased CPU usage.>
>>>>>>>>>>
>>>>>>>>>> I don't really see why we should do that.
>>>>>>>>>>
>>>>>>>>>> If the shrinker is a problem than the shrinker should be disabled. But if it is enabled, we should be shrinking as documented.
>>>>>>>>>>
>>>>>>>>>> Without more magic around our THP toggles (we want less) :)
>>>>>>>>>>
>>>>>>>>>> Shrinking happens when we are under memory pressure, so I am not really sure how relevant the scanning bit is, and if it is relevant enought to change the shrinker default.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> yes agreed, I also dont have numbers to back up my worry, its all theoretical :)
>>>>>>>>
>>>>>>>> BTW, I was also wondering if we should just always add all THP to the deferred split list, and make the split toggle just affect whether we process them or not (scan or not).
>>>>>>>>
>>>>>>>> I mean, as a default we add all of them to the list already right now, even though nothing would ever get reclaimed as default.
>>>>>>>>
>>>>>>>> What's your take?
>>>>>>>>
>>>>>>>
>>>>>>> hmm I probably didnt understand what you meant to say here:
>>>>>>> we already add all of them to the list in __do_huge_pmd_anonymous_page and collapse_huge_page and
>>>>>>> shrink_underused sets/clears split_underused_thp in deferred_split_folio decides whether we process or not.
>>>>>>
>>>>>> This is what I mean:
>>>>>>
>>>>>> commit 3952b6f6b671ca7d69fd1783b1abf4806f90d436 (HEAD -> max_ptes_none)
>>>>>> Author: David Hildenbrand <david@redhat.com>
>>>>>> Date:   Fri Sep 5 17:22:01 2025 +0200
>>>>>>
>>>>>>        mm/huge_memory: always add THPs to the deferred split list
>>>>>>            When disabling the shrinker and then re-enabling it, any anon THPs
>>>>>>        allocated in the meantime.
>>>>>>            That also means that we cannot disable the shrinker as default during
>>>>>>        boot, because we would miss some THPs later when enabling it.
>>>>>>            So always add them to the deferred split list, and only skip the
>>>>>>        scanning if the shrinker is disabled.
>>>>>>            This is effectively what we do on all systems out there already, unless
>>>>>>        they disable the shrinker.
>>>>>>            Signed-off-by: David Hildenbrand <david@redhat.com>
>>>>>>
>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>> index aa3ed7a86435b..3ee857c1d3754 100644
>>>>>> --- a/mm/huge_memory.c
>>>>>> +++ b/mm/huge_memory.c
>>>>>> @@ -4052,9 +4052,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>>>>>>            if (folio_order(folio) <= 1)
>>>>>>                    return;
>>>>>>     -       if (!partially_mapped && !split_underused_thp)
>>>>>> -               return;
>>>>>> -
>>>>>>            /*
>>>>>>             * Exclude swapcache: originally to avoid a corrupt deferred split
>>>>>>             * queue. Nowadays that is fully prevented by memcg1_swapout();
>>>>>> @@ -4175,6 +4172,8 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>>>>                    bool underused = false;
>>>>>>                      if (!folio_test_partially_mapped(folio)) {
>>>>>> +                       if (!split_underused_thp)
>>>>>> +                               goto next;
>>>>>>                            underused = thp_underused(folio);
>>>>>>                            if (!underused)
>>>>>>                                    goto next;
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>> Thanks for sending the diff! Now I know what you meant lol.
>>>>>
>>>>> In the case of when shrinker is disabled, this could make the deferred split scan for partially mapped folios
>>>>> very ineffective?
>>>>
>>>> I hope you realize that that's the default on each and every system out there that ships this feature :)
>>>>
>>>
>>> Yes, I made it default :)
>>>
>>> I am assuming people either keep shrinker enabled (which is an extremely large majority as its default), or disable shrinker
>>> and they dont flip flop between the 2 settings.
>>> There are 2 scenarios for the above patch:
>>>
>>> - shrinker is enabled (default): the above patch wont make a difference.
>>> - shrinker is disabled: the above patch makes splitting partially mapped folios inefficient.
>>>
>>> I didnt talk about the shrinker enabled case as it was a no-op and just talked about the shrinker disabled
>>> case.
>>
>>
>> Yeah, and I am saying that all you raised as a concern would be a problem already today in all default setups (-> 99.999999%). :)
>>
>> Probably we should not just disable the shrinker during boot, and once enabled, it would only split THPs created afterwards.
>>
> 
> I probably didnt understand this again lol. Sorry its friday evening :)
> 
> split_underused_thp is true at boot time [1]. You are saying we should not disable shrinker during boot, but it is already not
> disabled during boot, right?

It's all a mess, sorry, currently it's "enabled" as default but actually 
"disabled". Let me see if I can clean all that up.

-- 
Cheers

David / dhildenb


