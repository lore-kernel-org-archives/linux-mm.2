Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA7D8CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC26A8E0014; Fri,  5 Sep 2025 11:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73CB8E0001; Fri,  5 Sep 2025 11:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62648E0014; Fri,  5 Sep 2025 11:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B326E8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:58:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 585B613A7D4
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:58:48 +0000 (UTC)
X-FDA: 83855654736.29.55B02BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05B75180006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:58:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LHp0aIcY;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757087926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evLRFYt3UNymMNEcAX6nqhM5iAqoK2ROkZRbyKGwjHg=;
	b=fgOqmylPTvVQfsLqpAN26t39a2uo//hFkpLqGHe7xEirx4nGtStRUiGDgD7XxCbCVpn/a4
	dF2cEvblvNXDunL5cknNyBMkZWPC9MnWkaqJG/eHNGZfBBblWlQIGggXPqV1dBGHGXSpcc
	/CMaR6kLM+lLAeDJLzoRF/2kSa8VQTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757087926; a=rsa-sha256;
	cv=none;
	b=s0ZDyuim9zS3EXdslwc6DPEitBDfsOstQmX4owwyfIzSFfneQAvMnz9Z+X56SMOSpkm53L
	1xW+KXgbKSR32L8R8E6yb8ouL5MSGY8JIup8Tw3WSS/YqiT1Guf/sReD4E6fuFTcmg2vA+
	JCmLr06Bx0z9tblAORF9yGnw1fFwkEM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LHp0aIcY;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757087925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=evLRFYt3UNymMNEcAX6nqhM5iAqoK2ROkZRbyKGwjHg=;
	b=LHp0aIcYy10IlAUusxPh0mqCHQgRWroaivU9AyZQAIRd4JFIiWhBUryVvOYziLfddMDlBb
	pNVldnshWMRGetNwOHQZOKQMS9BevIw8d+N0eCo7Ku54GpTjPAslfZeWCnA86ggQSRN/5C
	bnVIxkpBSeleLzxAW9M6Dd1LMMwTDJw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-IVDJLEbBOsKlceH0yIAfQA-1; Fri, 05 Sep 2025 11:58:44 -0400
X-MC-Unique: IVDJLEbBOsKlceH0yIAfQA-1
X-Mimecast-MFC-AGG-ID: IVDJLEbBOsKlceH0yIAfQA_1757087923
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b96c2f4ccso14855125e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 08:58:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757087923; x=1757692723;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=evLRFYt3UNymMNEcAX6nqhM5iAqoK2ROkZRbyKGwjHg=;
        b=MU5Bwzyjk+//4xWGGN/EgE3jsyMrfepAcuj6Nc3eJ5d6KA/e6YQ/iGqyrkZcAU/PTd
         9WtmO0xH29I5PI9OYyHlubpoj3MVFjj2lY/b5hEVVhkVKcA8hoDTokzdiD98ES3sUVrR
         FiikXdhhvECbi/ABDWW/vHcyM9daL2tjrmM864IlI69CH4LZ/A7mvvcKpNtAgyIlIVMt
         UpkIIVfu439Y6jrMn5FticoYlqyOOLTP2uw1rgNJoDwaIVSgc7Kqlsmfcd46ViMr5giv
         80sC7ehZIA2MntT7ouAugW7XJHQeWk8n0jYgSzNNm51keWgeNv7qaluQVvjoDoRLi1Bq
         Lrbw==
X-Gm-Message-State: AOJu0YwiDanLnhVSO3c9OR5dIKX+oBYsybjcOSwk55EmRbu618q/CoPV
	qQetS1m0tICqRjV/uoLfC2yadJWcsdianJSK531LnbF1HvMejZhOzlpkLmG9UcgVxeUNoHsJpBl
	TIYxavVa0xibcyFftmsvIMKA0NhmPG4uTfJV7qCkS3XapYWZqNbrz
X-Gm-Gg: ASbGncs+zrkaohkrOqE8nojuxLU5i0Qa1ciUH1+8tV4hC36dOwRi/b8xqZoBxhL5y0C
	SDntketZ4ErwKba/6lLjvwPAjtGVWLsis0mIdAmoKRPEkY3eR+nDenJ/VkF/IEZ2S4kd+D/JUPN
	Re3vilZCupo+Ug/FC4M8eyf7m1rF+OzG78+Wh68EToUIPUqaH5/03LfbvroZpYAQICkWjEGpv4f
	e36w56tu6iaAvJZSJQwnMErEuqNcR7HdapPH7gtJ1rzjPR8MsQ1h6v/opi/DCGMno15tmoWYN3k
	+1APaydffyUWfzpkkZsaMUrbTPf9kYvGTS300dyorAe8rO4OrLKQZQv24rTjqLIiCtzZtYt6+sv
	oL+Jzp9w61/S5OdPeYrWZqWoLcD2XXBa27om43im0+9DZJDW9JqaLrlNn
X-Received: by 2002:a05:600c:1387:b0:45b:615c:cd2 with SMTP id 5b1f17b1804b1-45b85525da3mr231052865e9.8.1757087922813;
        Fri, 05 Sep 2025 08:58:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlYTbzshuwgip8AqARcntuswSYuXuNnM+V4fp0Ahk+2j2BHbQnTrjYIr7ArN49BJka1MwcfQ==
X-Received: by 2002:a05:600c:1387:b0:45b:615c:cd2 with SMTP id 5b1f17b1804b1-45b85525da3mr231052395e9.8.1757087922244;
        Fri, 05 Sep 2025 08:58:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c93sm420569445e9.14.2025.09.05.08.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 08:58:41 -0700 (PDT)
Message-ID: <701d2994-5b9a-4657-a616-586652f42df5@redhat.com>
Date: Fri, 5 Sep 2025 17:58:40 +0200
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d48af6f4-2ded-40f5-849d-7aa991727a59@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DlMrNEIUhoDpXwffzh4G0Fd1hsjKtF1BPwbFcpIeCWE_1757087923
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05B75180006
X-Stat-Signature: 6xqh5caqmgjmdf5h8sfcpxepzzseysos
X-HE-Tag: 1757087925-595663
X-HE-Meta: U2FsdGVkX1/TLxUeHTv2BeihHiSYWU7NVKDKX2aQRqquXkHtCwJdus+3uVeuCZqYCkInZ2x3Y3pcJe8vdkEFWBCPEqVe5vm+t8n+qumBHro1c+hzfcpnMi0GBAvv7TqqqudzgrhuQsTig8Sk5m0bHYFkfzsDjFMtxVqZjS7XwD4Dgm9AvlXmrLXSx4MQ6G68LcHCMw/Tu0049UHdIKq7BrDP7Wq4M8iYpvYafwvB+QgvpuL5wbCtJPssdY4AQ7nSb4ewaM8Z5OeOoCx4oIHHyITIznSDh4Cm75N1kdyqvLESmDoZ42javE89GmqzrglUwmuG0JoB9msHEhZJroD229lKnV9yDaujb2oMiRdqk98qyMvHDuCG2eZeQlPQVr3GSq8CNt0Lanrd2cX1B9+1Fe/7rifpcr8Mt8DMankHCH7xe/5QbqeWsQGcY1w/oftAR6wu7VmsjP+TcQm2mbMpCe/4L02za7MIIZ2CSMk9vph3qSoPeLVRlciHO10xfdycWHD5gCYhbLyA8iXcMwd6zupJY+GhhpiXgFokH8cljhGpMNf2/3+H6pJBWcsx3Q7bRDBMW15E5ahs8zJE45PAP2vKzS6R/0ut0kUp9RWOXjgMLQebaCjVDspEC7Dfm3pL0PTHHLP2cOQO07V2b5w6rKeBOZpHjbG99NTApk8Ez22KF1ULPeks5bfxEfISfuqm49usfL8tv97QTkUvzz+mXseXgtDf7XZpDM+UYWFJjb2CGU09/CpWGdv1FZtl2OgywU/caYEmdFMOYa5pdVhJwQLbPc5ueH1ipv8vYZftBR/homavoL3Ymw+gqdX695LLNEbP9xVRiaINLGbqQMmdYECLWk2BVldSMIqWrd+gcP/WP73UrBu+gQ9zvH28eZflGWwVZIubMJDquwa4ya3OV4uUl1+8Q3lQwIYejxAjr3exDqiGKghwtkYnqsvGZAiVvPGpdGkNyYqT7Km4Zj4
 gUvKCGVl
 AjIBAO5aW3hdk9syLadUhxsN4FcjXO+TG3uEs3E2aAXTv29BZHwGWNhdLVlOcMKaigR+dZ6M8nwCslaiPT4bRUfKmPilyFZsFYviQqqZLzKf+7KLkldNISP+NH58i9R66t2CKuw3uQkwz2xcq1VVXAdBn88niQpdKDhIoX0vh5L0YCq2kRs7IPt0COyLuc8SleXz1AKnXl/fjo3cD0CTp5ufJqHGgRRHEdJjSiEJub0oDIMu/VDrIvhb3qIOhmqiPjUVY+xgRYnb5kcFf086RRVOnSbRZlSutfDf24j1jV7OYeZkzEuwc+j04/LaB+3cnTaL9BwemtOExdiJhjplzJ1WZ2gYM9unCyUPoEfgmKK0E8i09URtBeWcZsyuvb2yqMQJgdoM5ZSu2uevDwg40f50UUYa78MeU1XDPXOyh3suVFFxA2/kP5/93Cznija8UwNnhxRQ/tegWGmeQ8uZU8bhIBpZsvziAwzEwUBeHGCxougDWUGT9nqStkO37vVAZRn3HO7fV+poNBVw9rRlqsakl0qGKHPJJSn8ZJM5raW6Irb5qdeHsvDuPEx4DBSAFD92G05UWXQIiAC57WCnpvNnrgxG7czXClySh0tfvAlhrQS8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 17:53, Usama Arif wrote:
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
>>      mm/huge_memory: always add THPs to the deferred split list
>>          When disabling the shrinker and then re-enabling it, any anon THPs
>>      allocated in the meantime.
>>          That also means that we cannot disable the shrinker as default during
>>      boot, because we would miss some THPs later when enabling it.
>>          So always add them to the deferred split list, and only skip the
>>      scanning if the shrinker is disabled.
>>          This is effectively what we do on all systems out there already, unless
>>      they disable the shrinker.
>>          Signed-off-by: David Hildenbrand <david@redhat.com>
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index aa3ed7a86435b..3ee857c1d3754 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4052,9 +4052,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>>          if (folio_order(folio) <= 1)
>>                  return;
>>   
>> -       if (!partially_mapped && !split_underused_thp)
>> -               return;
>> -
>>          /*
>>           * Exclude swapcache: originally to avoid a corrupt deferred split
>>           * queue. Nowadays that is fully prevented by memcg1_swapout();
>> @@ -4175,6 +4172,8 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>                  bool underused = false;
>>   
>>                  if (!folio_test_partially_mapped(folio)) {
>> +                       if (!split_underused_thp)
>> +                               goto next;
>>                          underused = thp_underused(folio);
>>                          if (!underused)
>>                                  goto next;
>>
>>
> 
> 
> Thanks for sending the diff! Now I know what you meant lol.
> 
> In the case of when shrinker is disabled, this could make the deferred split scan for partially mapped folios
> very ineffective?

I hope you realize that that's the default on each and every system out 
there that ships this feature :)

And don't ask me how many people even know about disabling the shrinker 
or would do it, when the default setting is mostly not splitting many 
THPs ever.

> 
> I am making up numbers, but lets there are 128 THPs in the system, only 2 of them are partially mapped
> and sc->nr_to_scan is 32.
> 
> In the current code, with shrinker disabled, only the 2 partially mapped THPs will be on the deferred list, so
> we will reclaim them in the first go.
> 
> With your patch, the worst case scenario is that the partially mapped THPs are at the end of the deferred_list
> and we would need 4 calls for the shrinker to split them.

Probably at some point we would want split lists as well, not sure how 
feasible that is.

-- 
Cheers

David / dhildenb


