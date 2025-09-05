Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A99ECA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923B96B000D; Fri,  5 Sep 2025 11:53:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3E26B0010; Fri,  5 Sep 2025 11:53:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C796B0011; Fri,  5 Sep 2025 11:53:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0336B000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:53:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D9F41197A5
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:53:56 +0000 (UTC)
X-FDA: 83855642472.01.8BD2C8E
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3EBF880006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:53:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nOFk903M;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757087634; a=rsa-sha256;
	cv=none;
	b=KAHR+BpFTOPnAkhAVMF6hAX4RS/XjaYqCXQmYDeDO6vniCvpxvZ388Rae5buWT87goidwt
	qj3YhJRaw/IucF6Vcvi7oNs78m8MusFQyZksxX9HqIP81X/slcad60hga77khUkXEeP41N
	0rphWdK3TWCL88J0oZH7h1ezwSX9w+Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nOFk903M;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757087634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBjnb9eHsc4AMjz+79Da56WGX1xcPGKADQKecHbj1Dg=;
	b=ut9NrmqUFWKR6CPma1LUxOkZtv0JtOzZGhLNRUiet6tnUXhgBAQwWqss2+1GpskC5JjTTO
	WUsjFgJW/8KTx0pcrHuRw9Z3oGaF2FyjUAZ3tBz0P4Rxc8jOzjd3FK9C5jVasNuWhatqcs
	J1vQPg3bhSNHOWLmLDM3XVVwOX56q10=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45b8b25296fso14601625e9.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 08:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757087633; x=1757692433; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bBjnb9eHsc4AMjz+79Da56WGX1xcPGKADQKecHbj1Dg=;
        b=nOFk903MlF1QxFkTCMHZoZvhqiEjqYTX2oWRQI7hXj09XgTd8Rp9C0GuaO8GMkohsx
         Fd2w2i0uy7XF/YT9gZHm/pv2bEhhPjiKc7bXn0OeILVbqE04Hg0svNy27vXDCuO6e5zT
         7Yml+/sn2gMygujWk1qzPnoHuGTYLChjGooj9qInMPBDudJ5Ydln9zCNI+iRRhYoFhKp
         hLhgpdhUeBxC/pfqeK+L97U9EfSUuF+VZYtD2R/fOQ6yMrgAy0+dz9blaUKWxAJ7TbWc
         MNhT6DxUw3nl63GM0utLBUKKgWLic50CjiQJ3pJ7n1H5NQ5xPL2jyl4xD5KOv0l/+07e
         q8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757087633; x=1757692433;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bBjnb9eHsc4AMjz+79Da56WGX1xcPGKADQKecHbj1Dg=;
        b=Ur0MrxGRneRHq5gEwasVJP/VlCyCrnRP6kSPt+Tx1PkLRAJ/CrTApV26dBgrdqgLw7
         TCloe9glydNldDFkdIAGu2WSa1e/gJQTGaZPfGKbemWhDt0b5xRmUeRHomXnxFcjp2BU
         mibz1JFm1x8qq4MoHjdMV7VmDM2HkddbErEsyFDm4+ASe2mVQGc0MnFgmIo0vAn2gCqr
         AChKzWyg9+LDCExzTBP2XUq+GbXjN6UcBrPA6gPRMgeIS0GoLN5QBq0FTb0m8f9uaU8c
         UVAoeuFqzDvRWZmI8dQj4/bsDsyhyMGqPd1VfJIlH6rLZ3IQak8rfqpLN9eUnkrADune
         K2sA==
X-Gm-Message-State: AOJu0YwTRWrZiiHgmuyluNM46xhOTJMJipCr7VGp3audDDOwRbgAl9Uj
	L8f1BtwKfn3iBlxSAnJKq9nvUZSs3RRzAFKLL+dAaqNIIIOSr43qNW2n
X-Gm-Gg: ASbGncuJbsJI3ep36oAMUuqZWVzLtoXG5hQS3g/bABO9eY0B2ZEPiSS1hbvdYOJLDaz
	PLWA1CjeiXAdDLjbq/1U1Qud+WdJIVrumiempO9R9dSNLJaHVCdBSYIb974rYldI5+dUc2tzcxv
	Jm8iIn3ONJ6qsy8IgdCOusHxeq/MlXF4qcWUw+7UrMXi/wYlRstK28XcJeEkqTpa6p5Wgvc67kf
	1RAUD/7CHdN7w4CFRLO5xWy4yuMyD/DeXPweL7FOo+aVIwrydI0N50XRUckBaESnNCrH2Pm2TSD
	K5cahjO1cOUUrjYb1pnnPHOQC/USUJkmfjM+EDSQkftk9uJ2gUjbRyz5evCUYjgZBLErefHdMUe
	5FO9jt2GAGFyQxxYKzmET5elEz2nGf+XwmzOyoMpWkcpBvPd77nXXHH0AEsj0k0DZmTIsQ7U=
X-Google-Smtp-Source: AGHT+IGU5mrUM+Z3bC8QJbKvkz8k5wsN0F9e+YsY1remvxpV8XQ0cvib1U6/IUD6PIX8cC7tM8wEKQ==
X-Received: by 2002:a05:600c:4e87:b0:45c:b5eb:b0c6 with SMTP id 5b1f17b1804b1-45dd5a2b4abmr42580715e9.5.1757087632220;
        Fri, 05 Sep 2025 08:53:52 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dcfa3ec60sm86415385e9.15.2025.09.05.08.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 08:53:51 -0700 (PDT)
Message-ID: <d48af6f4-2ded-40f5-849d-7aa991727a59@gmail.com>
Date: Fri, 5 Sep 2025 16:53:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
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
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <aadf50b1-151b-41c6-b60c-5f1f2a4f2d8e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3EBF880006
X-Stat-Signature: 8iryifrij3fnu5nwiic4egxkpt3ig819
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757087633-11300
X-HE-Meta: U2FsdGVkX1/qSvNPpo4CkvImWeWoOfSTcHWhA2iEHPnfreW2JgKPUYXnkvhFNysOg13HR1wNfLhk/ajtE/AeLGZY2cByTUETpxnbk8Nf4mpVa1PZKOVIiNu5EjYTEkUaVUwX3al62prWXDyvMIXqhq1IkGJ4lkBHfISAm4ArGq4dJX9BfVCLEsM2dRSfBh0DOJgSbTac8D3cLN6an+LJAF123ekKdxmpcwDo2urhGwmsD2AGRSqOBuyAu0uSsZXymDPn9BLMGDxHkBbH2nAlzJCHOG9ZBd33BaDYKy5E9IxP6htyoSxFFW/0ium393ITVqVV0iv5RMmlhCQtUSsJlgx3fIr2KOxj8j43kY/fIWkpOpiGMeeWSK5f445kRRABFri163Q2CZ9Xuum4TrX7yaNTyJvnp5UQsL70dOEd90OekDBo91fMwTLdsTKScEAz55bWjK3W1GLG2fyPihLPmj7caCkAVMFakv2jWqotJYrI6z3J54Myc3eW/S90g2SzS6GCA1lextjjkAf/DbJhIk7BgD1/HI4dxcFB6GVIVt5m6YCr3IK1uxgcAQXmhMljgihkeEcqFWeThNz28o69EqD7CYyF5TnBy5D2yNLaHIBsUh+NnXevbCQKIl4OgggqgEo6YmeH80Hz2CTLDfBK+sX7MY1iSWPoQbAge2SJlA93rrNyWYlfuvObCWRLL572moLb7cXNvBnUIOzNM1IJ6Ozm6Pm7OKteMnyIGcLDppHINXfJvb5sFadiN3tUcvZa/WB1CviXZV5Usr3M+f1208H1eYygNisWMfDFBmIOcPt6zqTdwam7sJTS5wGz2GH8uFbxVCRw2CaPIsMkNbMDuN/b1zjaAIiiyAFdZz62ofGm5KmeNn6k4/DHcc/C+O5fsOzDbrP2YThhhnb+eXdvAHLKwycrs4DiQOJ00PxSq/W6ek28RviFZU0AdqjXjZiPaBqEdS/qqnjzR/OX6G+
 5ayXXOjp
 HdByBZeQKbdFQJkwKh4TsW5X/oZDDv+pxLUKR22ow7mq6q8Q1qQAAm8AxGhd7Q9WbWafp0FMS+B9gxtxVj5pL2lT4d3W2HPX+Eab60z2Yp3j/Py6NRpHqkxdoJnU7fmxLYIjyE/n7Oyxo4PftRLdJ9a/w7C0eAU5hxC3z+oDa9QWlFs53Jy5qKy4xHYQNo0MBNEFT95cj1Y2E/q+w4YvBLG2Td5oCDDhvgBrqIwRJmNzrc574h4qFwoFcX+/DpDT0YoMRRikB5wHu0agCKClPhTQ5hmtRYgpD47JhrLvQikQ33Xr2VLrmbfG9Y2FZvwmq9EZ56WpfC2IKfi0pCFER/FK/KVu4Wquw1wsgix+sX0A9IF9NTsQUjZLFP89Wx5Vr59xXBo9pPaP7lm0UQphJ7833kWNTvIG02K+MbsQYmQS3AvbrcAySeKYwg/UxO5eriWUC/ZlmekCs8fvFqc7SdWLVSvk3RtYiNx1bOKnVrkyXYOtTmy0Cw6JAbA+xfllrW3gbA+vEHF7A+Z+9JbnYw57Mb+0s41CACwl4NyyxM70/1O+3Avl6M81CmfdOpdw5zmnZvS/eIJf7EYu/cKB8SCYDvtoUkSnn0RLb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 16:28, David Hildenbrand wrote:
> On 05.09.25 17:16, Usama Arif wrote:
>>
>>
>> On 05/09/2025 16:04, David Hildenbrand wrote:
>>> On 05.09.25 17:01, Usama Arif wrote:
>>>>
>>>>
>>>> On 05/09/2025 15:58, David Hildenbrand wrote:
>>>>> On 05.09.25 16:53, Usama Arif wrote:
>>>>>>
>>>>>>
>>>>>> On 05/09/2025 15:46, David Hildenbrand wrote:
>>>>>>> [...]
>>>>>>>
>>>>>>>>
>>>>>>>> The reason I did this is for the case if you change max_ptes_none after the THP is added
>>>>>>>> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
>>>>>>>> so that its considered for splitting.
>>>>>>>
>>>>>>> Yeah, I was assuming that was the reason why the shrinker is enabled as default.
>>>>>>>
>>>>>>> But in any sane system, the admin would enable the shrinker early. If not, we can look into handling it differently.
>>>>>>
>>>>>> Yes, I do this as well, i.e. have a low value from the start.
>>>>>>
>>>>>> Does it make sense to disable shrinker if max_ptes_none is 511? It wont shrink
>>>>>> the usecase you are describing below, but we wont encounter the increased CPU usage.>
>>>>>
>>>>> I don't really see why we should do that.
>>>>>
>>>>> If the shrinker is a problem than the shrinker should be disabled. But if it is enabled, we should be shrinking as documented.
>>>>>
>>>>> Without more magic around our THP toggles (we want less) :)
>>>>>
>>>>> Shrinking happens when we are under memory pressure, so I am not really sure how relevant the scanning bit is, and if it is relevant enought to change the shrinker default.
>>>>>
>>>>
>>>> yes agreed, I also dont have numbers to back up my worry, its all theoretical :)
>>>
>>> BTW, I was also wondering if we should just always add all THP to the deferred split list, and make the split toggle just affect whether we process them or not (scan or not).
>>>
>>> I mean, as a default we add all of them to the list already right now, even though nothing would ever get reclaimed as default.
>>>
>>> What's your take?
>>>
>>
>> hmm I probably didnt understand what you meant to say here:
>> we already add all of them to the list in __do_huge_pmd_anonymous_page and collapse_huge_page and
>> shrink_underused sets/clears split_underused_thp in deferred_split_folio decides whether we process or not.
> 
> This is what I mean:
> 
> commit 3952b6f6b671ca7d69fd1783b1abf4806f90d436 (HEAD -> max_ptes_none)
> Author: David Hildenbrand <david@redhat.com>
> Date:   Fri Sep 5 17:22:01 2025 +0200
> 
>     mm/huge_memory: always add THPs to the deferred split list
>         When disabling the shrinker and then re-enabling it, any anon THPs
>     allocated in the meantime.
>         That also means that we cannot disable the shrinker as default during
>     boot, because we would miss some THPs later when enabling it.
>         So always add them to the deferred split list, and only skip the
>     scanning if the shrinker is disabled.
>         This is effectively what we do on all systems out there already, unless
>     they disable the shrinker.
>         Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index aa3ed7a86435b..3ee857c1d3754 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4052,9 +4052,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>         if (folio_order(folio) <= 1)
>                 return;
>  
> -       if (!partially_mapped && !split_underused_thp)
> -               return;
> -
>         /*
>          * Exclude swapcache: originally to avoid a corrupt deferred split
>          * queue. Nowadays that is fully prevented by memcg1_swapout();
> @@ -4175,6 +4172,8 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>                 bool underused = false;
>  
>                 if (!folio_test_partially_mapped(folio)) {
> +                       if (!split_underused_thp)
> +                               goto next;
>                         underused = thp_underused(folio);
>                         if (!underused)
>                                 goto next;
> 
> 


Thanks for sending the diff! Now I know what you meant lol.

In the case of when shrinker is disabled, this could make the deferred split scan for partially mapped folios
very ineffective?

I am making up numbers, but lets there are 128 THPs in the system, only 2 of them are partially mapped
and sc->nr_to_scan is 32.

In the current code, with shrinker disabled, only the 2 partially mapped THPs will be on the deferred list, so
we will reclaim them in the first go.

With your patch, the worst case scenario is that the partially mapped THPs are at the end of the deferred_list
and we would need 4 calls for the shrinker to split them.

