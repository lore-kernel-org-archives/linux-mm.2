Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81C13CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE5FB8E000D; Fri,  5 Sep 2025 11:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBDDA8E0001; Fri,  5 Sep 2025 11:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3598E000D; Fri,  5 Sep 2025 11:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA6828E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:57:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54F34B7F2D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:57:14 +0000 (UTC)
X-FDA: 83855650788.04.AC73CE4
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 59E684000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:57:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bVMAtGwF;
	spf=pass (imf17.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757087832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T307WFdeH75VLzRB5+iWmitggBHVAbxN1ojM9RIT92Y=;
	b=jR79sldpt5HpvbnHnD/5NTAIpYB5j2npV9SDSvOF4/mipArNTZziDmpt3Z5t/1v6zanCd3
	vhmgKnDoL1zBPYZ3xf426w2LL09WWcYDQ8CghLQUIJEElFRIR7Zb4BLbQh2OVRwM3FhUi+
	xu8po4yX/xWeqB7kyyHUO4zYzZwPpzM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bVMAtGwF;
	spf=pass (imf17.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757087832; a=rsa-sha256;
	cv=none;
	b=j//lHUUlDOi14IfMFnnY1sVYCuPERBlnSUo+UGxswTAQX4ZyI3+cJTjnkZd89weD7nfSLt
	j15OzQVojQ8Iq7K59GdEjEC5DIgEnCWiQ9zPzKQ88sqi369EXJWoKo1xdVO+DKcMHn+4uj
	6aDNTT8jsSgPFPJ0Gl77+4xNEIYe26c=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45dd16c484dso13080355e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 08:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757087831; x=1757692631; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T307WFdeH75VLzRB5+iWmitggBHVAbxN1ojM9RIT92Y=;
        b=bVMAtGwFzw1PwOITBTHUskgHui+ixzvCXyMbGgNuL6BtJYWAvMa2SopXqteatyx1MQ
         EQel9ovVoXvoytNd29R0/FUUl+a2wy6uMyDFnsh3Hwd0mBFeRZrI8nmo+M4f5EB6LWlq
         FFKOynUG//EZvoVrrybahUc373s5+kBKXzy0Ca9rGtcMt/dWGIpqgr1BkMg9RyKwgi50
         FXLwBEVa1aLhlH+rd4+slxencYAQOmwpJsA9eDKymagorfO/CaF2CmRdsmY+/iVI8KvM
         Ao7Ea5zex6kMITbotNv4a27PnjjokkDE0vZ75MZyecLbDDfext/FuJkvjUhraX5S0muD
         Mljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757087831; x=1757692631;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T307WFdeH75VLzRB5+iWmitggBHVAbxN1ojM9RIT92Y=;
        b=oUYDdglXhKQXwBfJ+uK+5C7WVwafj5MMHSarE4M+Ox2jLPo8FcbygA6Al/bxUk/mBi
         3qOWhxfaY+I31tDcdTfzw2b4qXjlrnXGdI0pT1YzO2nbGjRl6U/unbiyNY61BIXYiz5Y
         zMb1+gDxoNDIOd/56830UVGVL55/vNuHUsDGvfH+LrCThRZgtNC973ZHtOvv30fniqCC
         ll1d/D9NKTNYL5qYL92dt9rKS3nRBeYbXpa/kjnD/N+H1zLepmxlF2u7FPEgTG5n1TNL
         iY3gC07iEvkqOFSe3ONSsY+5V/zAR5LRYWiiG0n7pumzOx5WD6TQhFwjtBWLjs3ijnco
         FT/w==
X-Gm-Message-State: AOJu0YwbHJ1jMhrHSabC/M6zTpFtYEujorBBw+OhqzabWlzowcpeq9ec
	zMHUAic/ly83e8Gom+5JsQBdeM39kYfukuXjZkMXiD9FfKv1tQnqNZp7ca0o4HUSfdk=
X-Gm-Gg: ASbGncskUU/pPckXcxz2crd11NQxeK5TnufLG2UEq7tvHExYHE0EUQnij3efn1iVVLW
	/WCecbRxme1f+A7uMX4iKY0ABxcFcV7f2i/UjZeGLhdzzGMkmHOxED3GI1IapxDY6e4ruIKsh/t
	ekckcOtxlIKtgFrAwjHxcaa514ivswrg0v6I+IRokpy3mpXhK5f9s3nx1h+CrDz5N7ylcaxmPpm
	FvtJbmiu4HPcA10w8ywoZHnE9lm7e4tWoQ/VkYuvBD6r30+XCat7u0i/GAEf85ulxVfWleFtHc/
	bmj9+/rKJj9Kq3Nc/53v1nG4i863es/z2VhiDHWW64jHfPavAM7iIurDtfFF8+24YNKGRT5KM6H
	t+Pr5IwU3GGR+ZDJut/l59VHR3uDdAhjeVbM8Zdc8dMR/4uWyMuC2zeQW66ZqSQvtqQFLlhw=
X-Google-Smtp-Source: AGHT+IFLhKjW4Fe8S8wpI/2bRVPjo1z45/c0rrhsn3wSoJ918bHUq1R21JnyukRzj20J+gUQTw8xlQ==
X-Received: by 2002:a05:600c:4fcd:b0:456:19eb:2e09 with SMTP id 5b1f17b1804b1-45b85528589mr219556995e9.8.1757087830802;
        Fri, 05 Sep 2025 08:57:10 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45cb5693921sm136327205e9.0.2025.09.05.08.57.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 08:57:10 -0700 (PDT)
Message-ID: <3a8a3ede-b14d-4b42-a2a1-5d62ef132f2a@gmail.com>
Date: Fri, 5 Sep 2025 16:57:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
Content-Language: en-GB
From: Usama Arif <usamaarif642@gmail.com>
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
 <d48af6f4-2ded-40f5-849d-7aa991727a59@gmail.com>
In-Reply-To: <d48af6f4-2ded-40f5-849d-7aa991727a59@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 59E684000D
X-Rspam-User: 
X-Stat-Signature: z6g4m1qhse434g7m8efrkm9nf8t3u1nt
X-Rspamd-Server: rspam09
X-HE-Tag: 1757087832-151050
X-HE-Meta: U2FsdGVkX1+Q9/+tTSOCbyc0ShSqZ5stvflF9Nd1Xt7mzqRm0uHZR+TnAUcXpgZWE9JrrbiUNOY0qyfL+XA0omtOv4GupA+B8FULmz0HMzuRHVO9HNMHdrQ3USDh75YiDj7sFfe6w3c1mAINHnnEvpptO9iRTNDMIqsLm6ZlyMF/L9vccNVEzYgqjpd6cO73aKwbLpvgh6rsmOheW4kj/tfuyqmpJxdae58bglL9EtneIqmuxtZjesehxINC6lriMPw7eyIpWsuI70qy3JeSkdvW8JQeZo3rEk28coS7psZJ0cc5v0xNKSoUmCPp1/co7KmwkcJCzT79jppvDHfuUY+k2ysRb7HZBUJwzBsn+G+wxpIx84TKU85BABgSLlGuptOk3cehuwYgwe1P+jGaC3NdhpmGUj0lXdAcRpm2BZ+RJxxwiLJ7jojV09fvs4M+LWW7wvceGv4XBG2cZr5kGiXJo0haUSYiG6m2zAYqHEk4F0v4rwznFf4WNDOzN4PN4RkZN+Gkths2kUphxo1v9450FsLFat81cJ5rMjRCM+mHu60C858c5W8pQ/HMfc6x6ipeYbvh/e0lRRcJ5gH/BLTDIGH8/I62i33+bzjdCF7EoyLanrlxudKtaIUwrREeg0kS+eoz5qbr7zOhau3dGLm8M+cuWgdo8p4hQydZuoMEt8Z9W+EGd9VJiLRVgI+gfr9OxM+ovrkdK7lsRrqDwuFC8Au70NXVloFy9V21DozPTZar6AYd97jI1Ul4o7jB3b3MQjv4FOTFciaGAsjR0sB4AhKg4h0sUnU73rix64R9ooAzVuk+d/puys6R1Bsh/3pGlOVvAnS5w9BrW78tRl9r3tsF87fT88AxibIHeOxntEKGHywlOqdWu4JFnjPUbzxzKzcS/dQeH7eZHa+9NiUZjbIjfr1pFsqVohgInP9ar6VcMp3+aAih/kAG9N32odjLDsXOjN2Ad/C3m0J
 +g/jjZpl
 LAzZSURiu1pyEMq6Gjoy62LenJg4+BFyyfA9gSceqfcKPJcOwf1ZCFXoRgVm1W9/6pjKd5CRXOUafgqRXd+zMaL8GDQWvrXq8zzq5YWjUK48OgwXWdLLV3y3gOFf9UnuVNZhvrzDt2d46mn+UhvjT1A9IjZaF1O1RTli6+89STAgtSDpPKhqJyeadViHm44bsUpGvDqYPFq/HKvf2LXqit9cGJ9ksSEwDft2JqGdyWxz6hv//OCtiRbPOytGjD45ckL3tVkzHWRX0uUzuS/zbdL5h3F6KzY5CEKGUbDcwV/7iM5UNTtBDbPhj7cJ8E5iBC9SRRMUSlM/GZxc6dd7jCq/jIhA7NsmBIuHBeER8nVzHUCBpwduA60IgnTxl5xysvsXjLFtyGgc+3ehuFwF93BGcUytQ61u4CcbtqyJ+Jx9ANI6NNGBGeXbLXpVmNozZNtrYGCGzqNQEx/aCD6nMrcMWcyI1Qo5ptNADAi1eVmNDUJsnVMWxWR/iZPWCAZDYrOIDsFoQX9cZCF3C0GCkx3Lk8r3xJfWiBhL1QiOz+Fr0zLOe5zXiuowEA3Bp8BDgKGHcsofgnIfTuYRqjqdXDhIGiCjGHt2mXXWH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 16:53, Usama Arif wrote:
> 
> 
> On 05/09/2025 16:28, David Hildenbrand wrote:
>> On 05.09.25 17:16, Usama Arif wrote:
>>>
>>>
>>> On 05/09/2025 16:04, David Hildenbrand wrote:
>>>> On 05.09.25 17:01, Usama Arif wrote:
>>>>>
>>>>>
>>>>> On 05/09/2025 15:58, David Hildenbrand wrote:
>>>>>> On 05.09.25 16:53, Usama Arif wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 05/09/2025 15:46, David Hildenbrand wrote:
>>>>>>>> [...]
>>>>>>>>
>>>>>>>>>
>>>>>>>>> The reason I did this is for the case if you change max_ptes_none after the THP is added
>>>>>>>>> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
>>>>>>>>> so that its considered for splitting.
>>>>>>>>
>>>>>>>> Yeah, I was assuming that was the reason why the shrinker is enabled as default.
>>>>>>>>
>>>>>>>> But in any sane system, the admin would enable the shrinker early. If not, we can look into handling it differently.
>>>>>>>
>>>>>>> Yes, I do this as well, i.e. have a low value from the start.
>>>>>>>
>>>>>>> Does it make sense to disable shrinker if max_ptes_none is 511? It wont shrink
>>>>>>> the usecase you are describing below, but we wont encounter the increased CPU usage.>
>>>>>>
>>>>>> I don't really see why we should do that.
>>>>>>
>>>>>> If the shrinker is a problem than the shrinker should be disabled. But if it is enabled, we should be shrinking as documented.
>>>>>>
>>>>>> Without more magic around our THP toggles (we want less) :)
>>>>>>
>>>>>> Shrinking happens when we are under memory pressure, so I am not really sure how relevant the scanning bit is, and if it is relevant enought to change the shrinker default.
>>>>>>
>>>>>
>>>>> yes agreed, I also dont have numbers to back up my worry, its all theoretical :)
>>>>
>>>> BTW, I was also wondering if we should just always add all THP to the deferred split list, and make the split toggle just affect whether we process them or not (scan or not).
>>>>
>>>> I mean, as a default we add all of them to the list already right now, even though nothing would ever get reclaimed as default.
>>>>
>>>> What's your take?
>>>>
>>>
>>> hmm I probably didnt understand what you meant to say here:
>>> we already add all of them to the list in __do_huge_pmd_anonymous_page and collapse_huge_page and
>>> shrink_underused sets/clears split_underused_thp in deferred_split_folio decides whether we process or not.
>>
>> This is what I mean:
>>
>> commit 3952b6f6b671ca7d69fd1783b1abf4806f90d436 (HEAD -> max_ptes_none)
>> Author: David Hildenbrand <david@redhat.com>
>> Date:   Fri Sep 5 17:22:01 2025 +0200
>>
>>     mm/huge_memory: always add THPs to the deferred split list
>>         When disabling the shrinker and then re-enabling it, any anon THPs
>>     allocated in the meantime.
>>         That also means that we cannot disable the shrinker as default during
>>     boot, because we would miss some THPs later when enabling it.
>>         So always add them to the deferred split list, and only skip the
>>     scanning if the shrinker is disabled.
>>         This is effectively what we do on all systems out there already, unless
>>     they disable the shrinker.
>>         Signed-off-by: David Hildenbrand <david@redhat.com>
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index aa3ed7a86435b..3ee857c1d3754 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4052,9 +4052,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>>         if (folio_order(folio) <= 1)
>>                 return;
>>  
>> -       if (!partially_mapped && !split_underused_thp)
>> -               return;
>> -
>>         /*
>>          * Exclude swapcache: originally to avoid a corrupt deferred split
>>          * queue. Nowadays that is fully prevented by memcg1_swapout();
>> @@ -4175,6 +4172,8 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>                 bool underused = false;
>>  
>>                 if (!folio_test_partially_mapped(folio)) {
>> +                       if (!split_underused_thp)
>> +                               goto next;
>>                         underused = thp_underused(folio);
>>                         if (!underused)
>>                                 goto next;
>>
>>
> 
> 
> Thanks for sending the diff! Now I know what you meant lol.
> 
> In the case of when shrinker is disabled, this could make the deferred split scan for partially mapped folios
> very ineffective?
> 
> I am making up numbers, but lets there are 128 THPs in the system, only 2 of them are partially mapped
> and sc->nr_to_scan is 32.
> 
> In the current code, with shrinker disabled, only the 2 partially mapped THPs will be on the deferred list, so
> we will reclaim them in the first go.
> 
> With your patch, the worst case scenario is that the partially mapped THPs are at the end of the deferred_list
> and we would need 4 calls for the shrinker to split them.


And I am hoping people are not dynamically enabling/disabling THP shrinker :)


I have ideas about dynamically changing max_ptes_none, maybe based on system metrics like memory pressure,
but not enabling/disabling shrinker.


