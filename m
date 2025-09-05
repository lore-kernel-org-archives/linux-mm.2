Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70110CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 16:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61558E0016; Fri,  5 Sep 2025 12:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38CE8E0001; Fri,  5 Sep 2025 12:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27DC8E0016; Fri,  5 Sep 2025 12:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BFED8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:55:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F90E160309
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:55:56 +0000 (UTC)
X-FDA: 83855798712.21.924E4F1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id B59844000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:55:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VnlggmN6;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757091353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jkfo6WSn/B2ygQxk1iQ5Vj38hQeZps62XsZ/7+Z0BZc=;
	b=OSH0gxEhuL40s/4+Ao4DwB9Z1AyGKA6L3UXiCwYIrRLOCHQV9m1OA/GO6+qOXu2pGjBQ3E
	IBptUcXADn0rD4Dcaod9ZFtmahlRlLZVtV0TQYA9GCMY55e7jnRGxTPNWMejXjWPT012e2
	wgcwIw51G7GA0sQuY6vjbMJGKJx/LRI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VnlggmN6;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757091353; a=rsa-sha256;
	cv=none;
	b=JpqsRS1seqXN0MUYJoOo5wbpmUuy/oS9ZhtTGFkuTrE0eZz7vsgr5EqKeAVvXYdroTkEIu
	fv+xVbvfd3idyHeHgW8TTBVLc9AxVrinLwyhlxajG/i2OKB7LrE5XVZEWY2hUdLSmiood5
	I1QjTMsti57yQ0TCKOdUprMBU7VoMqI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757091353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jkfo6WSn/B2ygQxk1iQ5Vj38hQeZps62XsZ/7+Z0BZc=;
	b=VnlggmN6BnTxw+NdXpsrDbppqAsdgnOiJEJyp645JmU5pW7XEvIDF/+L9ryMx4Eliz6dhw
	DCxMhtsvGtgKIVH2hNF9YlAA/PHVw2+E83yIzCqDvLSDarGujg5xRV5tLzwDiU7cF3LSy+
	dKNrDJGi8yza/o0dqOF8mPsQ6lV6QNA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-bAGHM_isN-i0JacGuzmo1A-1; Fri, 05 Sep 2025 12:55:51 -0400
X-MC-Unique: bAGHM_isN-i0JacGuzmo1A-1
X-Mimecast-MFC-AGG-ID: bAGHM_isN-i0JacGuzmo1A_1757091351
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e26b5e3f41so752701f8f.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 09:55:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757091350; x=1757696150;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jkfo6WSn/B2ygQxk1iQ5Vj38hQeZps62XsZ/7+Z0BZc=;
        b=bl74p7dmvSpWDlp4Fl3Lblu3uyQKqvwKXRz6F9RqtvNyYQIueU39mqLg4y+8CCGstt
         I9GcZUepiwAom5KzJfgqYpd/1NGe0i+3eld2gBlKx2u8z2ZVGCIqi0z1cSvVTG5yhT54
         y2zsErnzfiOgtv094n+rzlh/hjNhwjIUO3wES6rzGnlABwY7uWrtqxI+/IZQgF8+hvof
         BpyIycFULzGqN0K69dHp34ZWuVPrwTw9S6bZGXWXNlaEyY1nW3FIYhZVNEYdjJiSqioU
         ReoWH7WdwJblgnfmCnGywUm0LeUnDjP5XEvw3auIibvwohazhSlm7pbmd9+6+T9sQwi1
         yyzA==
X-Gm-Message-State: AOJu0YxdvcREMxuRaB/GJcccltNCO2sw74ANncmCOw3686+wBgptyThm
	OGdRyuEz9O9hh/hjHjHWzBd40RRC85RL4RtglxEAR97cDM63AfNk1p0OvBvvToKWYiLvmFWVK2g
	6urrXaV7IRjJVYc0iTvsZSwnpfPSHd0AHsAnksXSUpnOEe796jnjS
X-Gm-Gg: ASbGnctMigz+PvV5trxKqa2eMiR+PbT4B8iqQ9usUVzsK1A2S660Nm7t6noSaAM7Qub
	S/hPd35s42zN8BnWOIAKQmTH1S48/WuPg1m4aUbAkyA7aIYwSb9I5DQwnkDp1+I5G0DPk0abRy8
	WAKfUKE59YbqSfnZeD9PBzDQNPVqc/Fy3wBeWqZbUjz/NpD/Q7ZwEKkmP2wplfzxOFndGf8rqgp
	LKHsU6AWS4lQvm9okQDT8WZvmggHl7cpp5CNSL/Y85e+b/q0mhngjwJ1KUyjbufrgFgRTNEp93c
	P3eOu+JKDtIgINb/393CUQukx9MAbiRwo+PquFyLa3u1axRlVsMb2UqiOuaHADs2Tte7dUu9/Q5
	NbGgSikqrVfKThcbdaJkGmtoevVln9klrEMbxk/DxBUB3geBx8aIOhtey
X-Received: by 2002:a05:6000:402b:b0:3db:c7aa:2c19 with SMTP id ffacd0b85a97d-3dbc7aa2dfbmr10316493f8f.26.1757091350512;
        Fri, 05 Sep 2025 09:55:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhtIqtnxjkCVAPnrfA7KjaXw4ejvKO/sGeogZLv7rY2OklsxFVc59NUh6r7U4dsI+ZPEONvQ==
X-Received: by 2002:a05:6000:402b:b0:3db:c7aa:2c19 with SMTP id ffacd0b85a97d-3dbc7aa2dfbmr10316475f8f.26.1757091350045;
        Fri, 05 Sep 2025 09:55:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45ddd47b6easm3134475e9.18.2025.09.05.09.55.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 09:55:49 -0700 (PDT)
Message-ID: <e41c8d5d-5685-49f4-a5f5-87513674a03b@redhat.com>
Date: Fri, 5 Sep 2025 18:55:48 +0200
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <686943a6-7043-41b0-bd4c-2bfc4463d49b@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UDU3F9gy8dgjZM8DVyC2r4yF1qgOGc-ATqwhr68U25o_1757091351
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B59844000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fc76wiy8oynk6u5mr7coc1gkmefwmfwh
X-HE-Tag: 1757091353-917152
X-HE-Meta: U2FsdGVkX1/F9D7uqun0Kq3e0J0pj01Be8rjlxcCbtCkvWFVb2jQq0g7c5tp2/NB9Tb6twIQdV4IC0UoNn6xq72mffYQslVxDuF9pAEwvhA0GLuS49MD2CcW5QMWoVYvR+6a2Kgey7uJ3LROT3V40vcuGBaOPTPS22C+N+7evB1srCy87hQP/LdpiYTnD7G7OdRlo6JbAAxa3oiohwvuIT3RXfX5QE9sN/O5+QvGIq7gJWDx5eygjIs+aW++y8ACPd/DruaXS+hm2lbbEGKPWzOUj6EZCCMpD4i/pbQqr/OZryrQ1Li15KxGS8sO2534aJjNM6zFmjsBoMBsOELXUN0X+qCPA6voJqlRyJuSnaj29hupiXLh+TNyyuwrT1ZRO4AUw0O1MBau7/9cZbYVWEWPhtC1zshGgtfcB5LchXsY+hT81Zi6Mwb40MTWNK7ChkM2CmHH7tMsZtm4vmT3pPL8M4BJsrWquhXz4dAvLmoLd2oCEXqUKcBQhcnjSsSKl0HTdC9fvpgnBJCf4q+5HYWhaH1cqc7Xzk4TllHWdPFtmBsvS7ZIToOKvnILeGScwUVcZUTYu91CX/68VCFY7CP+ZEiHvhNtUNE7V4eUxxEL8iJTh6OPv04lPVQOH4DxC6rhx+MK2TD6YTmmZ3KcWm27FxT9BrpxXomdn7yJpUvrePYFYthhh2axbzGeBVEqnAMGNoTEhP5ikPbXnBwKtpkDXiFIYzywHG9BDm77eDro9lJI8wQKitMdP8Ikq9BAjQbptr1Mrrt72VOq1a3YmevZHidTue9OtGEBVUu7cPqsRbzynOHN31u2V4eSIamChAP9YsYBqjnDeS4BWZ039QrvSwQxeYwxtjy2T9n0ZmEg8PDFbxG+GgB4TPKU52cinqD1bCEcsiXuee33hLiAmLQEoi2mo4qt2eGN4Q8YBoC5Yc+aLfqmO74UGBp0VuRFu1UVj4+UzFhVYAGVHIB
 yDnpYwBC
 VOrdOoPMCFMqSi9Y8hj3DaTH62v1Vw46DZ+6UJeBOC4QKZp3owClFDnkSybKxjcOolsi9zi3aW+6sE3trrzaViFEOIsOix3z+mn2AYDzAlIcvKoFfi+LiVlBgBCT63c+MmZo+GsSmXexF/MBTL4nfC2jxUzOcz30gh463ygg8zMa78ZC0TN+uXl+CntECPE78KGHQ1KNBOz5i4dGVcyA21MFJoOKL0+1OC678QqKSaHhyXPnLHMqPvllEBYuRRRUc4Rt1BP1VL41Czn+dLNqgivD6dnp0kQjqWo39lWkkPMEq0j8cvpUxXju/uYauY4qARij8ADXuMfozi5Sn9KFjuwcEAQSV4qTkDz0Wywb/jV1ft79AGEAyje+n0smQz+6SUXFBq6+K9ZZvY9RqgcvvkgIHU1/A0WtqDrWXWDxffFmaGc47EbWVpXTVuPWmUUfCzMZ1a2q9zR8ZY2g6s57wdLjsfHzz18nxXLNkzRNRF54pVHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 18:47, Usama Arif wrote:
> 
> 
> On 05/09/2025 16:58, David Hildenbrand wrote:
>> On 05.09.25 17:53, Usama Arif wrote:
>>>
>>>
>>> On 05/09/2025 16:28, David Hildenbrand wrote:
>>>> On 05.09.25 17:16, Usama Arif wrote:
>>>>>
>>>>>
>>>>> On 05/09/2025 16:04, David Hildenbrand wrote:
>>>>>> On 05.09.25 17:01, Usama Arif wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 05/09/2025 15:58, David Hildenbrand wrote:
>>>>>>>> On 05.09.25 16:53, Usama Arif wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 05/09/2025 15:46, David Hildenbrand wrote:
>>>>>>>>>> [...]
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> The reason I did this is for the case if you change max_ptes_none after the THP is added
>>>>>>>>>>> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
>>>>>>>>>>> so that its considered for splitting.
>>>>>>>>>>
>>>>>>>>>> Yeah, I was assuming that was the reason why the shrinker is enabled as default.
>>>>>>>>>>
>>>>>>>>>> But in any sane system, the admin would enable the shrinker early. If not, we can look into handling it differently.
>>>>>>>>>
>>>>>>>>> Yes, I do this as well, i.e. have a low value from the start.
>>>>>>>>>
>>>>>>>>> Does it make sense to disable shrinker if max_ptes_none is 511? It wont shrink
>>>>>>>>> the usecase you are describing below, but we wont encounter the increased CPU usage.>
>>>>>>>>
>>>>>>>> I don't really see why we should do that.
>>>>>>>>
>>>>>>>> If the shrinker is a problem than the shrinker should be disabled. But if it is enabled, we should be shrinking as documented.
>>>>>>>>
>>>>>>>> Without more magic around our THP toggles (we want less) :)
>>>>>>>>
>>>>>>>> Shrinking happens when we are under memory pressure, so I am not really sure how relevant the scanning bit is, and if it is relevant enought to change the shrinker default.
>>>>>>>>
>>>>>>>
>>>>>>> yes agreed, I also dont have numbers to back up my worry, its all theoretical :)
>>>>>>
>>>>>> BTW, I was also wondering if we should just always add all THP to the deferred split list, and make the split toggle just affect whether we process them or not (scan or not).
>>>>>>
>>>>>> I mean, as a default we add all of them to the list already right now, even though nothing would ever get reclaimed as default.
>>>>>>
>>>>>> What's your take?
>>>>>>
>>>>>
>>>>> hmm I probably didnt understand what you meant to say here:
>>>>> we already add all of them to the list in __do_huge_pmd_anonymous_page and collapse_huge_page and
>>>>> shrink_underused sets/clears split_underused_thp in deferred_split_folio decides whether we process or not.
>>>>
>>>> This is what I mean:
>>>>
>>>> commit 3952b6f6b671ca7d69fd1783b1abf4806f90d436 (HEAD -> max_ptes_none)
>>>> Author: David Hildenbrand <david@redhat.com>
>>>> Date:   Fri Sep 5 17:22:01 2025 +0200
>>>>
>>>>       mm/huge_memory: always add THPs to the deferred split list
>>>>           When disabling the shrinker and then re-enabling it, any anon THPs
>>>>       allocated in the meantime.
>>>>           That also means that we cannot disable the shrinker as default during
>>>>       boot, because we would miss some THPs later when enabling it.
>>>>           So always add them to the deferred split list, and only skip the
>>>>       scanning if the shrinker is disabled.
>>>>           This is effectively what we do on all systems out there already, unless
>>>>       they disable the shrinker.
>>>>           Signed-off-by: David Hildenbrand <david@redhat.com>
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index aa3ed7a86435b..3ee857c1d3754 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -4052,9 +4052,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>>>>           if (folio_order(folio) <= 1)
>>>>                   return;
>>>>    -       if (!partially_mapped && !split_underused_thp)
>>>> -               return;
>>>> -
>>>>           /*
>>>>            * Exclude swapcache: originally to avoid a corrupt deferred split
>>>>            * queue. Nowadays that is fully prevented by memcg1_swapout();
>>>> @@ -4175,6 +4172,8 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>>                   bool underused = false;
>>>>                     if (!folio_test_partially_mapped(folio)) {
>>>> +                       if (!split_underused_thp)
>>>> +                               goto next;
>>>>                           underused = thp_underused(folio);
>>>>                           if (!underused)
>>>>                                   goto next;
>>>>
>>>>
>>>
>>>
>>> Thanks for sending the diff! Now I know what you meant lol.
>>>
>>> In the case of when shrinker is disabled, this could make the deferred split scan for partially mapped folios
>>> very ineffective?
>>
>> I hope you realize that that's the default on each and every system out there that ships this feature :)
>>
> 
> Yes, I made it default :)
> 
> I am assuming people either keep shrinker enabled (which is an extremely large majority as its default), or disable shrinker
> and they dont flip flop between the 2 settings.
> There are 2 scenarios for the above patch:
> 
> - shrinker is enabled (default): the above patch wont make a difference.
> - shrinker is disabled: the above patch makes splitting partially mapped folios inefficient.
> 
> I didnt talk about the shrinker enabled case as it was a no-op and just talked about the shrinker disabled
> case.


Yeah, and I am saying that all you raised as a concern would be a 
problem already today in all default setups (-> 99.999999%). :)

Probably we should not just disable the shrinker during boot, and once 
enabled, it would only split THPs created afterwards.

With this patch it would also split ones created previously.

-- 
Cheers

David / dhildenb


