Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 095D2CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 17:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600EF8E000A; Fri,  5 Sep 2025 13:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8498E0001; Fri,  5 Sep 2025 13:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE3D8E000A; Fri,  5 Sep 2025 13:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7FA8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:26:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7324119A0D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:26:17 +0000 (UTC)
X-FDA: 83855875194.07.B96E593
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id D069D180016
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:26:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZXBZFCnw;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757093175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ooESiIT2PTrPysB+HjiZ1lBM810ZvxTg7+P+/fx8htE=;
	b=mC1nSChXmsTF86iKK1AZcw0atEpiVAwh+xi85UtG0KMcdSNfL/OeP401PmwBqPTeHpkggx
	5268fhGmKpVQd88IUOZsJioqWftFN+b7qzPonyo4oiXpL6IUs+77l1K/OJlhsWykcztklE
	3oe8wGIh/BIRE9D5e6hF9I8ihh4RrZs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZXBZFCnw;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757093175; a=rsa-sha256;
	cv=none;
	b=LZaa/j4rFwH1BnBZ7W0so/2KRGul+cBawLpv/IzxFOe+z6UgIfF0JtiwKcYjbXy7MO2HZO
	rLQ8tKnD3dj8OEsz9zloVi2kcBSPzVcf0KW41KH0FJrVXtew9Iq6DlOC1EphbzmSqLdP2K
	/GG5Sp00iEQd5Hb73CNQXYFF60RRDlY=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45a1b065d59so14347045e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 10:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757093174; x=1757697974; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ooESiIT2PTrPysB+HjiZ1lBM810ZvxTg7+P+/fx8htE=;
        b=ZXBZFCnwva8VWAFDQLwrw+03PSeDbWRJap/cUpuG8IWz6WyFJhNr8moIlEPYnajs+i
         EUPzLQx9juj2g7HIrLyTRWTI+j8ZYtN/x7OtQmyemKFbJnDyPqQLZbR/O1S0KRKUFeM0
         bA9V9hmSJnk/1rz19TzbSTttdosz6oFOc8TzBoW/XyH1ZBeXRNJHlCL/eBPBaW2uvzKn
         Xuu4Tb3e9mk79FnVl/91Pihi/IhssbdA16JHJYY772T/fl1FjHk/PiynOst9QaxVOCkx
         w7yNKquc3gKN3BpKlz+8uuEXhHv/pqV6sOptuHISjrh3/uQ1Y5nAEIwi+IXPxwKttUEj
         PTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757093174; x=1757697974;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ooESiIT2PTrPysB+HjiZ1lBM810ZvxTg7+P+/fx8htE=;
        b=HSsRPsOhyX1xg7kxi5hg/1WWrpuNjf/6ALFi4rTqgiNTxVdl/gOxxySWTx022nl1YX
         4Zy9zj5bagst0p4vclTrsKCVSdcvqX2mFM2XqIvJMF+Lpl+vvRRfP4PFekNDT+ac8jkL
         nxiI1HtOE82COWLme8F7JtXEacOMdAuVzQ80582NvBSb6kFKAlVhAppwSuLnO+O34W2e
         8ZB6vHH0MHxSPgalUGkYvhGzq2+a3uGGyaahCWhynZEd4nGE13xI68N1RMZ7JO/NWgHj
         R+8XnyzgkZinlBCUwc1jbmXDvFuD1tUXS7CoG4w0Mx2dvGP1gxtUimJIuT1KsO0hPqbP
         wxeA==
X-Gm-Message-State: AOJu0Yw+xlsJ+viHWsW6M2X3hPmYjxxaQhRD5B3LDty44bd2XaHJkgn9
	j0rfNKxlvKy/dOEVhfnkwlfOGT17odhrT6uBsPAPcfhieccLSNHschTu
X-Gm-Gg: ASbGncuCFo6845PEc4ku7cnRKwUBVcaYTqQP2bYLGoDzTx1Sya+c2YAcLTh0JQYHaD4
	W8pgdMknz4ZhdZhCylL40FBdk+EIJubYIxc3vb1mkmO7KlyB4wXZS39J8FitkghqxejOOsLahU9
	49ShiyCg7nEOvdQBA2bIBd2yyLRjzjdGOMW4X/q1PVcKgEMmVtK4tqMJVj6NUaKZl08Wg6tNnbl
	5tfNG/E8z3mTHQy3BvA96nU8izPAAkg7RglQc9zEHvr/70oK47eSGXI3UB7zPBnwGx6vJ0PN8TH
	jSBmBj/wxzAGZYj7vwaq+48H/dJ7fZcxp3rETpTS+Gt1H6yI6yFhoZ1oH+PpUXZcqx15n08qes0
	EJXITx447MMoSShatvKLDjVfKRiZfQFMgQj81cKRPg1M9PWgeZ2wfc1i67ktn/BQ7TZL8N8Tf1u
	wMW7HOGE602m3l4mJJ
X-Google-Smtp-Source: AGHT+IGuXOAtZGlrnCDZRD4Elkxv1y7QaZdSaYKheUgsosykLW5TYqK3L/+DcanNmkvR/66rN5X24Q==
X-Received: by 2002:a05:600c:4e8e:b0:45c:b601:660a with SMTP id 5b1f17b1804b1-45cb6016789mr85243605e9.23.1757093174153;
        Fri, 05 Sep 2025 10:26:14 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fbb3cdsm15949824f8f.51.2025.09.05.10.26.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 10:26:13 -0700 (PDT)
Message-ID: <27460707-3d93-4ff2-bc99-da96d26758e9@gmail.com>
Date: Fri, 5 Sep 2025 18:26:10 +0100
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
 <686943a6-7043-41b0-bd4c-2bfc4463d49b@gmail.com>
 <e41c8d5d-5685-49f4-a5f5-87513674a03b@redhat.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <e41c8d5d-5685-49f4-a5f5-87513674a03b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D069D180016
X-Stat-Signature: awk8xmfrp3nbb5cj431wffh9ze5yuinq
X-Rspam-User: 
X-HE-Tag: 1757093175-730050
X-HE-Meta: U2FsdGVkX1/CM9Rh4IatSXI9UGkqpCtJZPDGTnPNWIKz2R04ZCLFTfbVlqcJgsXfrOfWob1nbod+G0FLYNmw3J8WJxqBDEix++q5jfwBLZ0t1IdA55JO8dldPRGIH0OTssKAJTzw77+iLtfoyNpJMEvWETe1bucET+2etxkSLKaBbhRKpX0vIMvd9VCodkq2yt+ouDrQEWFypBVY+RX266b4VMHHpEN4zlLHc7JunVjhWsLc59bo23LDes+ZDnp0Nssw4IFcoHSL7izux//3aoDHir0mNMgG5hcvwd1BheMqBU9Z+fhlk1MIqa3GyrSg4iEuoSeiYvOBnhy2xDwgt8t/U/OzxvXylyl41HLn7vW1JW1MgXGL/F6kF0sp6JbImLg9NCOGINL1bfkUKkyrVsi9NWaOrHMOnSA1nek7c4BwaoWvdiCYN6ljKRedUv6dXIlwB0+is957FpH5j+740f6D5HWRhp6bUua0u61IBCjOnXRzU3q6/lBONjPBtObS5JgISJCIZ1vhpdd8tgKqbpI1GzAepsku/TpAkCKl/HLLtKl8nPP0vJfq85Ecc4/eQ9nH74dCIINZveYs8zDtGlvyXPZ+MUpqItcQ/qv2htvD+Hc3O7b9MqXBrmgMXMPd/VuiavRp/TY96GVPHlSiaeJG+QQRusL0nO/OvfrDeak2laXlE22EIwSZwzB6+dZo1T7o74g/YzfOmI40pSYmRzAT4kbomSvFUzU4p3QyLwXZjlsY89Sl0Q5q9nVg3aqembtSUI2BMEx0vNkJwN+nWjY7oAND5zu52iw1xpC7Sb05tyThi3AYz/GKJjt1CzePDp9GL3zp+pNB395J1CLuRr2155omKbKNbTwYRSejD4fR+ZgcPktO2Rbcai5VjGR/hki4H5DaMfR1g1osiZLW+I0Si1L/iWfIwancDzq+c0dA6vkJoPLNwLbOiVX+0Fhte1MWp+ow+xFUcKMym4C
 y61xxYDL
 5sbR+wWPMLvRekfW2BykW4lUzM9LAoRLvLszIxT8Zfo/WVoBBWOD2YWZ2SNeKvaZ7/P/fYKnA1/CUOInMKMqUxNVCxUSbV/6WVws1/gB23Wxt+tbJsHUwnJju8LqDmVYm+Zh28rNnVEe1TtW7njek/2nsfaT//czBEddz2hQGa0aMIzJGNeMJN3epfK1fWP2zbNSAFC+lEOMpBVGtpFRqUn3ttyD4k090bjOnnR2WbGydrU1/1YeC6zkSPvrXjOXUpauWeMpGYtd6sBT2ytFdTF6yqueS34f134myu0VsoxI/bMRGsWKgnpAkPxR6fwUwZ+oqiVivRHbYjHfA+miCKC2tz5FpA0b7qv3sWhJQtBuz7b+Ko0QxCuYnBu8LWC6p01KW7umx7JT41Ho9/ZucA8Gy/8v8/AoqCVQRwsQzr/zY8XP73F/qqQb706r3fEgZoaEQQZUaxenWN/N3Bjf7NvP+B0oPH4+2WYeSZ+aPgHZOZ6TdA65nAIg8+KdxDuV2k/ZK3ahSsfS78R55e8OAWLXZ9RlmbqX3derNSIX5HC/+YQ7nmlgqSZ7c11F2G/LsgDlzvoXNeyd6Jw0+bzdpMiiQfzXLHTSj8RGquJlP9t6n/mNV00lEYItB7U0bYbpxAVN+Q1NDO7WFVxewh0WsjxS8Yyx9r6Coi7WH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 17:55, David Hildenbrand wrote:
> On 05.09.25 18:47, Usama Arif wrote:
>>
>>
>> On 05/09/2025 16:58, David Hildenbrand wrote:
>>> On 05.09.25 17:53, Usama Arif wrote:
>>>>
>>>>
>>>> On 05/09/2025 16:28, David Hildenbrand wrote:
>>>>> On 05.09.25 17:16, Usama Arif wrote:
>>>>>>
>>>>>>
>>>>>> On 05/09/2025 16:04, David Hildenbrand wrote:
>>>>>>> On 05.09.25 17:01, Usama Arif wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 05/09/2025 15:58, David Hildenbrand wrote:
>>>>>>>>> On 05.09.25 16:53, Usama Arif wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 05/09/2025 15:46, David Hildenbrand wrote:
>>>>>>>>>>> [...]
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> The reason I did this is for the case if you change max_ptes_none after the THP is added
>>>>>>>>>>>> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
>>>>>>>>>>>> so that its considered for splitting.
>>>>>>>>>>>
>>>>>>>>>>> Yeah, I was assuming that was the reason why the shrinker is enabled as default.
>>>>>>>>>>>
>>>>>>>>>>> But in any sane system, the admin would enable the shrinker early. If not, we can look into handling it differently.
>>>>>>>>>>
>>>>>>>>>> Yes, I do this as well, i.e. have a low value from the start.
>>>>>>>>>>
>>>>>>>>>> Does it make sense to disable shrinker if max_ptes_none is 511? It wont shrink
>>>>>>>>>> the usecase you are describing below, but we wont encounter the increased CPU usage.>
>>>>>>>>>
>>>>>>>>> I don't really see why we should do that.
>>>>>>>>>
>>>>>>>>> If the shrinker is a problem than the shrinker should be disabled. But if it is enabled, we should be shrinking as documented.
>>>>>>>>>
>>>>>>>>> Without more magic around our THP toggles (we want less) :)
>>>>>>>>>
>>>>>>>>> Shrinking happens when we are under memory pressure, so I am not really sure how relevant the scanning bit is, and if it is relevant enought to change the shrinker default.
>>>>>>>>>
>>>>>>>>
>>>>>>>> yes agreed, I also dont have numbers to back up my worry, its all theoretical :)
>>>>>>>
>>>>>>> BTW, I was also wondering if we should just always add all THP to the deferred split list, and make the split toggle just affect whether we process them or not (scan or not).
>>>>>>>
>>>>>>> I mean, as a default we add all of them to the list already right now, even though nothing would ever get reclaimed as default.
>>>>>>>
>>>>>>> What's your take?
>>>>>>>
>>>>>>
>>>>>> hmm I probably didnt understand what you meant to say here:
>>>>>> we already add all of them to the list in __do_huge_pmd_anonymous_page and collapse_huge_page and
>>>>>> shrink_underused sets/clears split_underused_thp in deferred_split_folio decides whether we process or not.
>>>>>
>>>>> This is what I mean:
>>>>>
>>>>> commit 3952b6f6b671ca7d69fd1783b1abf4806f90d436 (HEAD -> max_ptes_none)
>>>>> Author: David Hildenbrand <david@redhat.com>
>>>>> Date:   Fri Sep 5 17:22:01 2025 +0200
>>>>>
>>>>>       mm/huge_memory: always add THPs to the deferred split list
>>>>>           When disabling the shrinker and then re-enabling it, any anon THPs
>>>>>       allocated in the meantime.
>>>>>           That also means that we cannot disable the shrinker as default during
>>>>>       boot, because we would miss some THPs later when enabling it.
>>>>>           So always add them to the deferred split list, and only skip the
>>>>>       scanning if the shrinker is disabled.
>>>>>           This is effectively what we do on all systems out there already, unless
>>>>>       they disable the shrinker.
>>>>>           Signed-off-by: David Hildenbrand <david@redhat.com>
>>>>>
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index aa3ed7a86435b..3ee857c1d3754 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -4052,9 +4052,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>>>>>           if (folio_order(folio) <= 1)
>>>>>                   return;
>>>>>    -       if (!partially_mapped && !split_underused_thp)
>>>>> -               return;
>>>>> -
>>>>>           /*
>>>>>            * Exclude swapcache: originally to avoid a corrupt deferred split
>>>>>            * queue. Nowadays that is fully prevented by memcg1_swapout();
>>>>> @@ -4175,6 +4172,8 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>>>                   bool underused = false;
>>>>>                     if (!folio_test_partially_mapped(folio)) {
>>>>> +                       if (!split_underused_thp)
>>>>> +                               goto next;
>>>>>                           underused = thp_underused(folio);
>>>>>                           if (!underused)
>>>>>                                   goto next;
>>>>>
>>>>>
>>>>
>>>>
>>>> Thanks for sending the diff! Now I know what you meant lol.
>>>>
>>>> In the case of when shrinker is disabled, this could make the deferred split scan for partially mapped folios
>>>> very ineffective?
>>>
>>> I hope you realize that that's the default on each and every system out there that ships this feature :)
>>>
>>
>> Yes, I made it default :)
>>
>> I am assuming people either keep shrinker enabled (which is an extremely large majority as its default), or disable shrinker
>> and they dont flip flop between the 2 settings.
>> There are 2 scenarios for the above patch:
>>
>> - shrinker is enabled (default): the above patch wont make a difference.
>> - shrinker is disabled: the above patch makes splitting partially mapped folios inefficient.
>>
>> I didnt talk about the shrinker enabled case as it was a no-op and just talked about the shrinker disabled
>> case.
> 
> 
> Yeah, and I am saying that all you raised as a concern would be a problem already today in all default setups (-> 99.999999%). :)
> 
> Probably we should not just disable the shrinker during boot, and once enabled, it would only split THPs created afterwards.
> 

I probably didnt understand this again lol. Sorry its friday evening :)

split_underused_thp is true at boot time [1]. You are saying we should not disable shrinker during boot, but it is already not
disabled during boot, right?


If someone goes with system default, which is THP shrinker enabled (from boot and runtime), the above patch is a no-op, right?


> With this patch it would also split ones created previously.
> 

yes, if someone changes from shrinker being disabled to shrinker being enabled before memory pressure.

[1] https://elixir.bootlin.com/linux/v6.16.4/source/mm/huge_memory.c#L76

