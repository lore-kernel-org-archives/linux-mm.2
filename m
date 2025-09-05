Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BD40CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D65EE8E0005; Fri,  5 Sep 2025 11:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFC18E0001; Fri,  5 Sep 2025 11:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE8B8E0005; Fri,  5 Sep 2025 11:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9C088E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:16:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5874885554
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:16:48 +0000 (UTC)
X-FDA: 83855548896.19.713D009
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 594CD14000F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:16:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EdV7sl5b;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757085406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvCw8PnRQjfPw9zGQmXROzWFubi2ex8kOW8DpaiaGw8=;
	b=k3HK0hYvCBZIRBPeJet4YT6D4qLdD6V6dzmaBvWO8w6CCbLuZivSilXNcLP3UsZFfuy8Zx
	CsB/vZ0EMJcLAfSmkQYd9TGHIhyg80hnpiEAoQA1cf1f8ALBfn8WOvDkoCWeNN4tDTAFXZ
	cK0R1cx9bEkyAPIutrU7wSGax66h7eM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757085406; a=rsa-sha256;
	cv=none;
	b=yVcV87L2x0+vETHkDKbEIXngLYzBaeLCBxvjk2ushi5/sErC3D5o8ls5HI2vKt9p5QiGET
	i9hdQ/l40a/pfjGHsVwsOShhDnO/FfsGSXg4/9fEiw4MRP+Gn/kd4PZQieoT5pGZVRr1aZ
	7G1ygdt+V2fNYjzXAwypz/6yCCsMqAM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EdV7sl5b;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3da9ad0c1f4so1545527f8f.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 08:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757085405; x=1757690205; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gvCw8PnRQjfPw9zGQmXROzWFubi2ex8kOW8DpaiaGw8=;
        b=EdV7sl5bL7al8mBuztD6RMNfCoZHFKNX0Q9UsIGOc2uzZxMtnAMRefOyZ6pMJOFeL3
         4FfrcCBAfPR2B0SytM+6LD3JmZZAMegj9+Fdg49jLIV5v/0V1PwrrvewfyeL7TusQxX1
         tYZi4KZK+yB7HHOxpzJNZ63B4H3iwQbH56qqNsT97xzBN/z8gCDifvkNRM1DCUImK/ZG
         MpMOQ8WBk165zonae9+0piWY09hWutdbV4amYglNMYW0il0vo0B1YCz9a6rOA5R2ur6t
         K1dOs+gN9EawPkOOHyuCITsOyldMpsJkPdABp5HSkbRXj/K921HXPPwGYh3wPLhZ9QQg
         7U3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757085405; x=1757690205;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvCw8PnRQjfPw9zGQmXROzWFubi2ex8kOW8DpaiaGw8=;
        b=bMhqYK26g52wsihhLOMvAI+Z6A42Vjy4iE+LJsLMuBOhPsRUXKT3aqJrqXhfVeeWDa
         VI8MkkL8WyyluJW1wHofBQ+/yKFBDrHRblgBRuG7w2HuWWwMF8aT9li+9qBbkwAZlIY9
         R1by0ONkobciZ0EOg03A8UWDR3kLbtBYSmmfpetseXtq44Az6r1L3r2vkXKk1cBsHgeI
         WO/FOKItDSU4ctDDWHVo/PiRIHmkVFH9SMudTl6JLStnzWa1J1V8MkSlcpdbbZRUg1//
         j1smks8uLRnsUyy/9og6vVm/8T2qyNJmpkM9ilVUXKc5F8JKHC3cAcfPkJ/fpCuYvmvY
         kzTQ==
X-Gm-Message-State: AOJu0Yy8LHXjeCRw9OdpoGQwS6r6AajfRIlf8tXZKxxlOFhR73zzrRsQ
	Qa0kK6i/D05/iGWvvIWoTPWiUiAOyDq82MBJALBzbMbxJsYYSuJOnWWo
X-Gm-Gg: ASbGncsoFEXoDlD2kmiGjNF/i4CrYtrZ3Qm2vBXfPUEjvJ1dpVF4UcT5aOCCtiEgGtc
	fBBJD/yOfJfN4TRzckhSJxXLnDHEgDHGwyVitFVBYoN/nN9UyE4RxzMdDYm9GwYf3wtAhsfrDJD
	Qzu5X2vSBJwNf9SX/QN4719aQgxN+cf5bFHbRK33PBPoFlcy6OBm9dAr4nI3rqJxoKlVKw+Ayez
	GNLtUDPND78+TAk2TN9WB7rtDH/lgTcL2hvN8XnEgFmV1papaySxC2WoUoJ9xJW3/V/m+LE10BC
	hOIGXkpwrPP097V2vlQMGW1GNbkFHaotopmm5GryFyP512qnmwKR0f5sL6hu4IflwsLqbEEFpjF
	0ZFG1fadKzcZ/pvqQV+sSgZ2nVFjYR/V7qRF8CXWFv+f1jxakXsV04vseLOAUsTHnTrxCgDs=
X-Google-Smtp-Source: AGHT+IEmTCo8jb52P6pCTfWLGNS8fx95yjvAkgZdmH56UsyDr4ZNMlk9nJW2Jy0VkRXvCY7nIV2nsw==
X-Received: by 2002:a05:6000:1449:b0:3da:37de:a3c6 with SMTP id ffacd0b85a97d-3da37dea762mr10479951f8f.59.1757085404642;
        Fri, 05 Sep 2025 08:16:44 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d9f3c36a78sm16205165f8f.48.2025.09.05.08.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 08:16:44 -0700 (PDT)
Message-ID: <3c857cdb-01d0-4884-85c1-dfae46d8e4a0@gmail.com>
Date: Fri, 5 Sep 2025 16:16:41 +0100
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
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <3737e6e5-9569-464c-8cd0-1ec9888be04b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 594CD14000F
X-Stat-Signature: jhunhfr3dc715pa3ftmp6rmijrsy8q3e
X-HE-Tag: 1757085406-583135
X-HE-Meta: U2FsdGVkX1+GKC9WDdjWjHH3om186RTLrE4jCVSmTP9UgnL9hNOsGuwDfwLT8HmulqutPGuOl55GbsJuc9dBp2N1Dav6Xz1BHIyoFi/YnaJubg47JUPX0KtXoXU+saqBd9Tk4prg2U2cwY+sothP1QGQ8As782SZSPLQ+as1kcs7/tjzhlFziN3i5i1hXlN730WMTv4RPHA9oors7lOE/1JesehGkQc8Mi5kgRLE1pFe5QWro7OM5SWgmOP3htxcSIHCEtbBgA/XXoVUQLZwKnEDfxuB0G4pRjT+6yd575AC/JxHtp4X59HJc/yMR/zLP5bb1XXw9Bkp6mmpAgG+ZLSRN63WGthkTW8w08GvCH90tiHe2rUjm2D/R2znx+nvWGvKi/L4hQGL8pkM6g5P0bBBt914paVxHYen6O3HdZ2I9Msvd75sLPEF+cnt0bErinmcyOyeaCAQHCf6HcgqMux9BrF0ZBS+wttAKlPmamLSmkfokXQtUHcuhgxD7cDQ28nwLWUKUlIOWTJXgeVcoau/p1bq/ATO9Tm9S3gRqVnCkC972aC7aQ8GRDar/cWrzt2kOK6mu03d3AhWkPn5QoBpVaSyejNX72eiUPLXWaD/6eqEjg3TLcWffeVvhZcW4vqkdwnt2XVdsLmaeQX1xXEAMvlTcSyBKa6m0Zy16yHx1GasQfeVup1FAszbSp5b4FRYpiRoB9tg8YyH18FBLl7aRZiGsEk0ndUV0mstdKfEnxd8yE+4ajXo531HtS8pt7HATRGw9PXExrOw7J4Afxm8pmFCnnLY5YGtuOY4ru3xTOQFV9KLFMNVROCsoeBzMtiy3OCnewPMAJ9jPqWunyZTIQeEWplLZxzh3AZRyseN3kpVj27ybz+DbVxml2nuN9JfzEafDOCJSwpJIIx5OlFy/YuNSkUJeeY8QqCmAX+OGL8nRQQCG6VERVx7ZdZ18QImAlXqjWXsaMOgUD0
 qdC7jjAa
 EX9646voAuzunMDDPxhvrO/OJ+MYEvCw0r0RdCRIdJr2meLdLH/rVMEnsx2MHn5ZxUzHnK6CKKWnVDmcvUCe7w6Vt1TLvB+5R65dwXaGuN415mE4rwq+GLuIQhgNSqBI/lQ4hdx+MRVWMCQaaUWufEmEpX7l6c75ec92Bl8XrYvh6/wOJvrRMO5HdQ7m6BVGwQpE2fUCU2hsTGq0ZTmmCT2JqIwUTipXGd1LTATArTxV1RkgWTRzVk7bZc90lchPerKDNByK/VVeWBDVQeTWembIvT99N8ZSJvJRYYVvML3jtAlgyOPGRojPz9Xznkts+Ye9FD7qtd0cpkKyI+g3qchAJJL9oilyC/ww0hsxWXBul8IJ/F9cJqc91aKjPgxCgzLhrlOH4VG/wDSYrkOcHSANnKyxs5SmWqSr74Yazl/EiGBDLvlV938G2N8p1utLojnAO+OCE6ulXfuJ9YzmUXEYMlu/dMuc9weeH1rc4jNoGRY43C57XWbgLGzDgLZh1V48KPAW2wuA1cdkVum6rCARua0owdJ5ia2d3Ss4TUFnxNR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 16:04, David Hildenbrand wrote:
> On 05.09.25 17:01, Usama Arif wrote:
>>
>>
>> On 05/09/2025 15:58, David Hildenbrand wrote:
>>> On 05.09.25 16:53, Usama Arif wrote:
>>>>
>>>>
>>>> On 05/09/2025 15:46, David Hildenbrand wrote:
>>>>> [...]
>>>>>
>>>>>>
>>>>>> The reason I did this is for the case if you change max_ptes_none after the THP is added
>>>>>> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
>>>>>> so that its considered for splitting.
>>>>>
>>>>> Yeah, I was assuming that was the reason why the shrinker is enabled as default.
>>>>>
>>>>> But in any sane system, the admin would enable the shrinker early. If not, we can look into handling it differently.
>>>>
>>>> Yes, I do this as well, i.e. have a low value from the start.
>>>>
>>>> Does it make sense to disable shrinker if max_ptes_none is 511? It wont shrink
>>>> the usecase you are describing below, but we wont encounter the increased CPU usage.>
>>>
>>> I don't really see why we should do that.
>>>
>>> If the shrinker is a problem than the shrinker should be disabled. But if it is enabled, we should be shrinking as documented.
>>>
>>> Without more magic around our THP toggles (we want less) :)
>>>
>>> Shrinking happens when we are under memory pressure, so I am not really sure how relevant the scanning bit is, and if it is relevant enought to change the shrinker default.
>>>
>>
>> yes agreed, I also dont have numbers to back up my worry, its all theoretical :)
> 
> BTW, I was also wondering if we should just always add all THP to the deferred split list, and make the split toggle just affect whether we process them or not (scan or not).
> 
> I mean, as a default we add all of them to the list already right now, even though nothing would ever get reclaimed as default.
> 
> What's your take?
> 

hmm I probably didnt understand what you meant to say here:
we already add all of them to the list in __do_huge_pmd_anonymous_page and collapse_huge_page and
shrink_underused sets/clears split_underused_thp in deferred_split_folio decides whether we process or not.

In deferred_split_folio, if split_underused_thp is false, we dont add them to the list (unless partially_mapped).

Unless you are referring to non pmd mapped THPs?



