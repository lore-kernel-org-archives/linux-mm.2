Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12CBDCA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 16:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9EA8E000B; Fri,  5 Sep 2025 12:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6914F8E0001; Fri,  5 Sep 2025 12:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7558E000B; Fri,  5 Sep 2025 12:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 492918E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:47:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB9C31A02C1
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:47:20 +0000 (UTC)
X-FDA: 83855777040.22.49E6CBA
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id B472010000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:47:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="X/12Y3Oy";
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757090838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gRrdweLgJOS6vEQgU0/6/0qTHPBWxDHqLnPQbnJbTIU=;
	b=aiRMh7aorA8KmC8P8C6KYMk68EW9XNQ6ywW9fBG+T+AxPA8oIpeW59KPdLpcYgRBsyqo6R
	ZWuK6eILM0xZ2uwO+V0gfSgTjbuWONGCwV1I4jXYRA1bCoiHxiWwwd4RqZ7UMVBsaNDULC
	2/s7mvpjSRXIA9Sq4CX2D3gVzZGvr7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757090838; a=rsa-sha256;
	cv=none;
	b=qpsX+u1TaOSjitnjFGod6+91Uh/9bwfkm+EtrLaDvV1UBi2lE87FGE9qHHF/wfj44LNB3+
	iWTh+NFn+BqJPZgnhtLAwW8VeTaJPRRPAov/WXVBCYO7ihIMbqdXxFVvyE0mAOE3Fi7+GD
	hx6CMyGIzAjrctYRuVIDYyRM5dtWaEk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="X/12Y3Oy";
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45cb5492350so15723355e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 09:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757090837; x=1757695637; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gRrdweLgJOS6vEQgU0/6/0qTHPBWxDHqLnPQbnJbTIU=;
        b=X/12Y3Oyv30ixA62HMcbKnca3bXlKDXbqJjiP7KfHMg/tHCWix3TpVeW349PZmawoy
         unlEsedBfPOA0PirmAT/a4Xpoz39Jc/td+dSxyoIRCEzeDujKCfOsLgjhnGAeiOpGEYp
         h9DXVGhWreT9b3j4NMBqcYnTgiJrew5236DuvokS7mmluXU/qZXC287uesUjN8aoCEHV
         rp/pM+hiDrC75DHnAihZ2+418lmhAkUgRLlUNNcxVmuztk2IhGlE/+mfRNlfiKW3Lf0P
         BeLIF5lmpRc+O8r/5iZyPy0WYwXl7pKo/G5lbHVhw+Sc0TsjjGsiAkAr93OYtCvH9aCN
         sqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757090837; x=1757695637;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gRrdweLgJOS6vEQgU0/6/0qTHPBWxDHqLnPQbnJbTIU=;
        b=rlQLEvQ8QE8hQTtrgFkckoElrjY50AlPVUJ9PlCUg0apznXlea/4r1wEhsLIEBuYzU
         7kULk5vtyKkP188eCDKEHutiRf2nwyCNMzuZNIFizGKh+rPyat/0h4C22ZTkzt4JnoAM
         z8e57IiSRH/HRzYHmXkQPh0YWB7fWxmN3MKqreiegsc7lNNK0qEAvRWxdvtzk2oWBZrU
         9AczG+IWLlGGvHAwNRTcp8J5R4tCiCaq6sCK4itvNJSGXVSUBZZojvJxE5zsx8XjkWcE
         HtPtkD1Ba7QeuQBjm537wX5YrntiJyfHnVgrzXQrtSvcTauD9tEhysux5bmLNlVlvy74
         0XmA==
X-Gm-Message-State: AOJu0YxHHORoyAFfc5tZzajM2r7O7/DaZmzXIE+bdLDzhcNJRiKuXUvv
	oDHDeXMw1scaSU+aNF/zg1dxnqwvbapiUF0kxvjCMKhzVHgjPdVh8ThxbVVcf05fdmQ=
X-Gm-Gg: ASbGnctEiIog9Il+ATFMT63WODvImPUmEmsU+7A6Sh2JlifmEkVPCBwG03mtYUO9n6n
	xRCBKih8be9QYOAF4OSYlovs4ayFC1DK82nrDKrYlh+GkcAoGVMjKgsofhnojOBpoCg/NMwp35+
	/0w+2PdCemMqXRKD04Z5wULAN7rnWs7BxQZpLC+cLigoqBpZUJoOlzeeH8ndP8NMWah+TSlJKdM
	kxFggofyuk4F2KCmzgBfLVqCVW2Ajc8TklN4Yl3R3oidIzGHi0hEM151CwpQ2ncwIBUfSLtxUSu
	Yxv8sgY4O+5ADNwvGDKUL44xes58uplyAzvweZnBohti5mB+RxolibMUCgS5PPc2Yk2yuE4Prf8
	QDAUn6DwTu5ziAHk24VrqYspNZQrc8S8yDyOUrA7SH61cD/5Thnris+qg1hsipTjxUDJS7oGiSz
	FwuiFRRQ==
X-Google-Smtp-Source: AGHT+IEx8F86Izc5zxqbrnq8C/dmorHzseUBfJEoURTnPa//1n1TwYj5OtK6ZAouLmKwItByNHp0BQ==
X-Received: by 2002:a05:600c:1d18:b0:45d:d522:5b2c with SMTP id 5b1f17b1804b1-45dd5432112mr35730335e9.34.1757090837003;
        Fri, 05 Sep 2025 09:47:17 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d7ac825b88sm19067298f8f.7.2025.09.05.09.47.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 09:47:16 -0700 (PDT)
Message-ID: <686943a6-7043-41b0-bd4c-2bfc4463d49b@gmail.com>
Date: Fri, 5 Sep 2025 17:47:13 +0100
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
 <d48af6f4-2ded-40f5-849d-7aa991727a59@gmail.com>
 <701d2994-5b9a-4657-a616-586652f42df5@redhat.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <701d2994-5b9a-4657-a616-586652f42df5@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B472010000D
X-Stat-Signature: jbscbh6cx9jd6jryyjcp977zgttx6nmf
X-Rspam-User: 
X-HE-Tag: 1757090838-115509
X-HE-Meta: U2FsdGVkX18SRKKlE7BTlN4xyLuBhE+Txtv6vB1xJetl1k7jpYpEjxkJAxP8SfxGB4PVu4UmyAQzpDI0P4hl8hSiPcmb5Mw2u09kBdruADD0IOVpvj9D8x4T6xdVVR/bWlWFWL/ifsIDxuS6KIBr76CwSDI/Mnmwk85ax5CYzuU6MzPBOM4PcbPdNeGkFF6lT+oSM1pFx1OKs2m+/yY2neeh9xN6HBs5CqTVHhW+ew1enWqj0I0BZ1LjCNCQsPmCdnq8GayAp0MMyybDrki2hG/Omzi8ZR1+CBtl8zEV2eito7cBFwLR3XCVOlQhJRI/WWJTEZjaltYu+FyIWcc+7mWMruXRVw9Tv6FTijYcxVAn4szbJmC7/1noS22em5vC++uDukBLfYL6rnTT9SmLJjZoJmM8jJ0BsnQvLvIqi/v/EPN1NC+ZjUB87g9mQz7by9MXWL5ttpiJOJzOYUpbGitseFWVMi5lu7ae4v5QiYjWJrdV+tUndHgMW1whhTIhoE3Hsl7Fl2H4syTelxu8ryJJfDRB2nTtz/dA5nVleZV4ODKYHsVumk+rmLQi2V9zx3SlGhgcEvUV+yZ5NIlmWobTIcpz91zNJ6sCvK+eVY/AbwOjt7M/DNZKi5SGhukngXO0g1xYDg/tIH4scFuXZ3sM3DIqaCY+ZucM3fIB4bwsG/QC0VEMfFLJGIF0sSML2XG/1/M0RK10yjUicMVbv7TUc9RfRSDSaESWhcJdn13Yauc2LvnOaBrys6tAQOUUl+3gIwk2Dx3ihv17x9+cIpxTbd1he26hz524t95So4Y5f6jSGHb3azAkU7uEhYQDrBf0QC3k8uOs0Jljxmn0VbPN/QRjplscOfZ/dPgIzaLYPZuamdS9Wv700WtmtSiz+Ho9kNoXKit4h0YL5I4rEXncp0hl2HfBBmsqliL7xVazCXiv7CLyrsZUUz0Xlj4O3jw9dqRp6rjUbkFpYnC
 tNux0h6p
 4Id3DQ25E10o5Wv4KfjGFub8wsz62Udp5cBlRlViCqJLG7MQOL3lnXUlpEqpqzcfC3MxTDrCb2pQl9fPTyzqwL7W/0FzEmKQciS3EDDcdcKyLuR+Nyy5yqKmrB/CwB24SwTT+7vudDdQsFwV3VGzIo5pOs9AoSZtvsC1QCxPLZDY0+h8KP2FrS29ZcBPUaYI7Gg2a0S2dFJp4Hz8clPUZUkVQpdxKr37ipj6onBJoUEn64CnqrFT4770g2nJS7sw3ELk2ih8nhFUkgtxH1UlqCk0T0Jq7LzpwYAhFiawrXHNA1Oy9MzXd6gB0fYuDCJcpS3Kd5LhDn9atbkPuzW/7RAteQS10hvQlY/nn2uhGWgjw+4d8Nm6aCDeMuz6VSwroUI8KM5yfwZg/bxoZcjaNC5oX7J59ip06T26UHbTCELqk60cHpIin09u+5yWD15nPHhg44RDwycdvZDfXNDqgDzHz2zUsoZUA1t6Nrpei0xCPr1Z5QdD72Z6Sh2ZuNuMfa/kKbqYZzaBqTQieeZTMXJFgJsPT7rI8HEU8+TW5TCh/Ej5CGH4+r90YKRaNX1WBgZ84gZxZIVFqGLo5J7XxYZlkPqfztbNGUckz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 16:58, David Hildenbrand wrote:
> On 05.09.25 17:53, Usama Arif wrote:
>>
>>
>> On 05/09/2025 16:28, David Hildenbrand wrote:
>>> On 05.09.25 17:16, Usama Arif wrote:
>>>>
>>>>
>>>> On 05/09/2025 16:04, David Hildenbrand wrote:
>>>>> On 05.09.25 17:01, Usama Arif wrote:
>>>>>>
>>>>>>
>>>>>> On 05/09/2025 15:58, David Hildenbrand wrote:
>>>>>>> On 05.09.25 16:53, Usama Arif wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 05/09/2025 15:46, David Hildenbrand wrote:
>>>>>>>>> [...]
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> The reason I did this is for the case if you change max_ptes_none after the THP is added
>>>>>>>>>> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
>>>>>>>>>> so that its considered for splitting.
>>>>>>>>>
>>>>>>>>> Yeah, I was assuming that was the reason why the shrinker is enabled as default.
>>>>>>>>>
>>>>>>>>> But in any sane system, the admin would enable the shrinker early. If not, we can look into handling it differently.
>>>>>>>>
>>>>>>>> Yes, I do this as well, i.e. have a low value from the start.
>>>>>>>>
>>>>>>>> Does it make sense to disable shrinker if max_ptes_none is 511? It wont shrink
>>>>>>>> the usecase you are describing below, but we wont encounter the increased CPU usage.>
>>>>>>>
>>>>>>> I don't really see why we should do that.
>>>>>>>
>>>>>>> If the shrinker is a problem than the shrinker should be disabled. But if it is enabled, we should be shrinking as documented.
>>>>>>>
>>>>>>> Without more magic around our THP toggles (we want less) :)
>>>>>>>
>>>>>>> Shrinking happens when we are under memory pressure, so I am not really sure how relevant the scanning bit is, and if it is relevant enought to change the shrinker default.
>>>>>>>
>>>>>>
>>>>>> yes agreed, I also dont have numbers to back up my worry, its all theoretical :)
>>>>>
>>>>> BTW, I was also wondering if we should just always add all THP to the deferred split list, and make the split toggle just affect whether we process them or not (scan or not).
>>>>>
>>>>> I mean, as a default we add all of them to the list already right now, even though nothing would ever get reclaimed as default.
>>>>>
>>>>> What's your take?
>>>>>
>>>>
>>>> hmm I probably didnt understand what you meant to say here:
>>>> we already add all of them to the list in __do_huge_pmd_anonymous_page and collapse_huge_page and
>>>> shrink_underused sets/clears split_underused_thp in deferred_split_folio decides whether we process or not.
>>>
>>> This is what I mean:
>>>
>>> commit 3952b6f6b671ca7d69fd1783b1abf4806f90d436 (HEAD -> max_ptes_none)
>>> Author: David Hildenbrand <david@redhat.com>
>>> Date:   Fri Sep 5 17:22:01 2025 +0200
>>>
>>>      mm/huge_memory: always add THPs to the deferred split list
>>>          When disabling the shrinker and then re-enabling it, any anon THPs
>>>      allocated in the meantime.
>>>          That also means that we cannot disable the shrinker as default during
>>>      boot, because we would miss some THPs later when enabling it.
>>>          So always add them to the deferred split list, and only skip the
>>>      scanning if the shrinker is disabled.
>>>          This is effectively what we do on all systems out there already, unless
>>>      they disable the shrinker.
>>>          Signed-off-by: David Hildenbrand <david@redhat.com>
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index aa3ed7a86435b..3ee857c1d3754 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4052,9 +4052,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>>>          if (folio_order(folio) <= 1)
>>>                  return;
>>>   -       if (!partially_mapped && !split_underused_thp)
>>> -               return;
>>> -
>>>          /*
>>>           * Exclude swapcache: originally to avoid a corrupt deferred split
>>>           * queue. Nowadays that is fully prevented by memcg1_swapout();
>>> @@ -4175,6 +4172,8 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>                  bool underused = false;
>>>                    if (!folio_test_partially_mapped(folio)) {
>>> +                       if (!split_underused_thp)
>>> +                               goto next;
>>>                          underused = thp_underused(folio);
>>>                          if (!underused)
>>>                                  goto next;
>>>
>>>
>>
>>
>> Thanks for sending the diff! Now I know what you meant lol.
>>
>> In the case of when shrinker is disabled, this could make the deferred split scan for partially mapped folios
>> very ineffective?
> 
> I hope you realize that that's the default on each and every system out there that ships this feature :)
> 

Yes, I made it default :)

I am assuming people either keep shrinker enabled (which is an extremely large majority as its default), or disable shrinker
and they dont flip flop between the 2 settings.
There are 2 scenarios for the above patch:

- shrinker is enabled (default): the above patch wont make a difference.
- shrinker is disabled: the above patch makes splitting partially mapped folios inefficient.

I didnt talk about the shrinker enabled case as it was a no-op and just talked about the shrinker disabled
case.

> And don't ask me how many people even know about disabling the shrinker or would do it, when the default setting is mostly not splitting many THPs ever.
> 
>>
>> I am making up numbers, but lets there are 128 THPs in the system, only 2 of them are partially mapped
>> and sc->nr_to_scan is 32.
>>
>> In the current code, with shrinker disabled, only the 2 partially mapped THPs will be on the deferred list, so
>> we will reclaim them in the first go.
>>
>> With your patch, the worst case scenario is that the partially mapped THPs are at the end of the deferred_list
>> and we would need 4 calls for the shrinker to split them.
> 
> Probably at some point we would want split lists as well, not sure how feasible that is.
> 


