Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71918CA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 03:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71EAA6B0006; Sat, 30 Aug 2025 23:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6656B0007; Sat, 30 Aug 2025 23:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4AB6B000D; Sat, 30 Aug 2025 23:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 499F96B0006
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 23:35:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3E381A031E
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 03:35:25 +0000 (UTC)
X-FDA: 83835637410.19.EDFE388
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id F2542100007
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 03:35:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EZ+DieN0;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756611324;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aq3m3ApNhL8UCamTDtsMpXEPSvDyCOk2PZ+5CsWWYas=;
	b=w4igetmomS4QaPGoO7hG7UEqwDR+rQot/1epc5L0kyRM9TslZxxEpgE6cjohSl+68gTrBW
	EbqmKy7a4C3s2neP+IS96djnB2OdoF0M4lH73r5DE0GjRasjXVBmjtNt/SkEXzHtmtyZQO
	Y7RyW+0Rd48x64C67/rZiivXzOE3kP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756611324; a=rsa-sha256;
	cv=none;
	b=xHPNqjKvZnl7ztf0lTAPdKwqVKy67aVYVZV7jumE0G4z/cpReiB6ZMhFHtQpsgbLBV9YD0
	jNNAV2WA84uBq/IUi3H454LHn62J7e9wmUILsMoZi9ZHRkVlys4cGODjKD0vqVnwLQZApl
	dJvvYvnhMxd8PmBL/oqMir5Zd1jY5Xs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EZ+DieN0;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3cf991e8c82so1487042f8f.3
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 20:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756611322; x=1757216122; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aq3m3ApNhL8UCamTDtsMpXEPSvDyCOk2PZ+5CsWWYas=;
        b=EZ+DieN0rWgIgEZ1FPDxGgRd6fAGFHvFkauW4Ch612rS8cWF8wJ5fCIvU45Zc3s3JL
         jVCUnBkQKTD2jN3M4ttPQZl93bBAlweuIguZ9HA7YUu6wSEwvNM66aYTWWoNySEmGxlZ
         S5sX9R47aRv4NJ1qKYgi2Ws5gqUGRLB8Ddh2acA0RZxFso2KSEVRYLtTzsGOQ6F9BGyA
         kbg3Uk4EWxhtLgxXeHG+znEqrowEWZN8I8F4hXoaRsL6pVQ1f6dVjpT7BUkMxh65/vZT
         cyjwn3vxri9MknW5xVEN2yh9+zNKsV9x3S0WLtiIzauBnprQbhOVNkrYWmDmtoJo0Kuk
         jpWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756611322; x=1757216122;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aq3m3ApNhL8UCamTDtsMpXEPSvDyCOk2PZ+5CsWWYas=;
        b=huk3qcOmYp23jDwlX5Noq7w1t0xGZBa1VKIhqubukw7gyis77+34bbJANqLy0N5QEb
         j4nssxvrsOGf3KtDbK9/gQNtkj+XcnKpN/gBue9rx5MJYzUF+96+tjoLksCiuHlYM1hM
         /GEb/ih1wJVa4IxV50YhyA714anvGvMNfqbpUdorpj4r95oJCg6GqqA9TRDdi0P/3LGd
         NEVQlEqsw6FycAPYe1UUz1P+lRq1LaAlcYC4BU9i0fRBODaIu4tgPg/DgDZMzA++QEVJ
         +7SpxYnmW3afJX07dEnGlMgU2Z+GUhfuzNn0EmJfZmZeyjVTtcz6crEYa0l9eFVtAuVt
         x4Xw==
X-Forwarded-Encrypted: i=1; AJvYcCWqyvfGEaeiAPS/hzfSjHSemss1s2C0Io9vlt4PuPzYAUCa4k8D8R3wORwaihU4/ntqYb3tDQvOfw==@kvack.org
X-Gm-Message-State: AOJu0YynOEN7uD+bvYaxCWY+MnmJm2E1WLthj9jOdVHaRhE0Z8bPtli2
	PyvJKenJfji2UGpjFrSATHGpxoRJ3apkCi4avyMJjOHQfNEOMStyCW8q
X-Gm-Gg: ASbGncuHA4UHzQ5YwdMuLBqrHlIF0XLxzDqlzpDGqbigHjTXZKg4u6EzpjKxVtkUdMC
	wMo7kHnTr4SfYNQtVr+wur7NJPKGSqfn7KsHUMEhJuptOuZhlbxmvEIb/FH6fO6DX8N3GWGiyWb
	glOrNzKDgaBzSR61FLBqu/hyatPgMZVw+SRGuBVLh+VJwqfveTmMLji7iKfmcWyEqjZv7t1WMac
	72tZQkVZj9QIvGj/2urtpM9+wAx7bISW0ifGbzzB4oSwppwY2aCJ7IqaUgHqhvJArHga0NdreDA
	0dXyw1lSPuzi9TrPTWgWfT0GnqyoGh7sXH6GSrPHsoGnNydxFLXKcJekm1SMskl70wzOuo3GaQK
	bx3VpLTZ0aNIpExSKATVY1WRy5HsRSUJtmDVB
X-Google-Smtp-Source: AGHT+IHLW/8pH624orcQ/yUuYgXtNcMmSkv4r9KWd2LeGemAhYnOyVvRLnY+STJPeS4L/M3bTkV2qQ==
X-Received: by 2002:a5d:64e9:0:b0:3cb:46fc:8ea8 with SMTP id ffacd0b85a97d-3d1dc5a23a7mr2077352f8f.3.1756611322239;
        Sat, 30 Aug 2025 20:35:22 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b87b38fcfsm19382745e9.0.2025.08.30.20.35.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Aug 2025 20:35:21 -0700 (PDT)
Date: Sun, 31 Aug 2025 03:35:21 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/page_alloc: find_large_buddy() from start_pfn aligned
 order
Message-ID: <20250831033521.7khxjqsbtiwzi2ws@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250828091618.7869-1-richard.weiyang@gmail.com>
 <489045AD-70D6-4167-843D-50A8DD19870B@nvidia.com>
 <20250830012505.v4qoihdqi22na3v2@master>
 <837DD3CD-DEB8-4255-9E38-6006D652B02E@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <837DD3CD-DEB8-4255-9E38-6006D652B02E@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2542100007
X-Stat-Signature: aaus3hp8z4u97ua7axgznx7hfnug119k
X-HE-Tag: 1756611323-340853
X-HE-Meta: U2FsdGVkX188k446IUzoKmPC5d/HsSAOeeyPqzzPnRH2jfyzxy1Z+xS3GyjVanoCQA0qsEhGO6onS627RVWx8Yg82A5wNPE73QOXJ0jnDpkjzSs0+qzh2wkBHwDzkYcc4EPtEsbaJom6lnYnzqmRoIB7ILewh3gt4oBPjPkapvTddL07foCb6J5zuC7qIZI/K8ugC9aZ7XPiKQHMU4a0qCOiWnqR/7Ei93Cibf5dX8DKcLsYnASLA7i+rrapnhlYghletRQSapfsSNfxUrJArHN7is6mAdSJRltvi74ydWMxYvNr016+aB1HIiz+wKdGzBrV1siNcJnDrL2FwUOMAGhZefsx6lle8S3HE5xcFrbCEXcU4vpZtAvaQT/46xd7xNN5khUHfdTRoDPXgbO3XCFKkIUbdV93ex3OcRfINdCWSFaD9u3liYcwOmUAiZK85zB/qlYrP6grH9DFf5OgOpHJT1KOx12zYBraFpWr92LcpUf5NS6lXCs5+q6p2uutjqySqo5dYvb62HzT4cQpFv2CLo1ry9wrOXH/s3B/dOTdDzl3K2geuyAnzidm8i1+WFQq/mApiPyAyhabYWW77N8vLmyJTLd4LEBvJMnLCPCDmvK+QUJ4DMohWQYN/RBVEZ62foynBprmzocCf4vv7rmS7dUDM8Obg502SA4VSm3IVdw0l45w+0vQ0PrnccfjQqEZQKnXUs3tOl6qBhva+KOH41sf95Te/23ge+6yXCPGnD/PfRaOJKLyhMOMgipGCdmscWFof0NUIZDDBElN9+zvAJ8DAyVJQ25vNH1+GevWMnloxd13P08qvxOzvNjgiYAvqP5BmQ5Z9KAoYPpt5zCne4zGzhCyqBlht7snpVkLvyhnHisQBrnRTiPkhuqK2mFESI9rUFgtQ4jVnKEPMc4rqUw0+Uq4wrlXpyNERE//wLhjLeszx5TgQzKTLsKHfh2kTjXR4HIgf7qFYDC
 ML40VNhJ
 cBAJoZqi30x0m49FeCrzsdWw3MEBENkRIY+4i6L6uDIz/GwqMEC2vDNX+5Q4ngz/m74oVCB05RyzWmqJL2RkZPWKCaSK2odhjo+uhcZUvktj4QjGg/iAqEWhpgM4VNR7+YigM56KSmHLZcS91jKDre6UeAGJCWwHzgGVodenFOAd4ctvKOHaV4FhwKLtqL3F9wqiJIF32O3LPIeSKfpSkmQR4HEUm7dDGHIDFyEYZ1YAp+yG3S62P3qFmkkExjxo8hYoYIMuvhjVIzV/XsHCyy7kTyN1bXIQNTEQgn+YeoIxlqyMicjxAtdQU5mLYWkhZEqwKWKJN2ruUHpX6WzDjo2eCsVd5W9a+S5htC8Z++iLbcJAMGZ59JEXBWNSpWyZmOFQUwwjxTDMSen4V770tcLDturmmCuAejZZkU6hnudDcoFu781RfMfVysj0Rz9N6hbZ84zG8il+5hlOcUtwYlG2449Jxfes99Q8foNT8WfRBHWFhuOY26qpn1COB4Z+0czF5gIfZXNZRvFSSUPKHPHxmq7B7t9VqInIxLxgQd02PSAmK5GmdqoShM60twAAmn6SZV5de4nWvSd9wt7ZekKxSKOCsmIT5qrjW8dMvh50isMQ/CYAQaAdZwpjPlqvd492O61E1pjmVw8XvRNO3AT3hTMDb88PDj8Pm9G7FsEUVcNFxzWTQlmJoYZpqfxhTGm8J8u5+rXFtwwlspXAeglBB1ugJ2hv3T31Ww/FOwn8P/fQpHSzXIzkRZJ49+j4I4HDeruJhF82QysLWja5FtncPVjZEhypIhb3ab8xjyBJtfywJu6wv4hm8/kJTWpqUmiOWp1/NVRHo/SE8nzbyfzyivgIt3UYWJNpbUkF+ECgzRFxQSghmzsV4wP6j/JgU5wwa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 09:28:24PM -0400, Zi Yan wrote:
>On 29 Aug 2025, at 21:25, Wei Yang wrote:
>
>> On Thu, Aug 28, 2025 at 11:02:33PM -0400, Zi Yan wrote:
>>> On 28 Aug 2025, at 5:16, Wei Yang wrote:
>>>
>>>> We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large
>>>> buddy. While if the order is less than start_pfn aligned order, we would
>>>> get the same pfn and do the same check again.
>>>>
>>>> Iterate from start_pfn aligned order to reduce duplicated work.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>
>>>> ---
>>>> I build this and run, but not sure how fully test this.
>>>> ---
>>>>  mm/page_alloc.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index 27ea4c7acd15..7f2dfd30106f 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -2033,7 +2033,7 @@ static int move_freepages_block(struct zone *zone, struct page *page,
>>>>  /* Look for a buddy that straddles start_pfn */
>>>>  static unsigned long find_large_buddy(unsigned long start_pfn)
>>>>  {
>>>> -	int order = 0;
>>>> +	int order = start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
>>>>  	struct page *page;
>>>>  	unsigned long pfn = start_pfn;
>>>
>>
>> Hi, Zi Yan
>>
>> Thanks for the review.
>>
>>> I think it is right, but the code is very subtle and hard to understand
>>> after the change. It is better to add comment to explain it.
>>
>> One thing I want to point out is in __move_freepages_block_isolate(),
>> find_large_buddy() is always given a pageblock aligned start_pfn. This means
>> if start_pfn is not a free page, it would always try 10 times until give up.
>
>find_large_buddy() is used to deal with free pages, so start_pfn is likely
>to be a free page.
>

I am not that familiar with the background, my question here.

I see the call flow is:

alloc_contig_pages_noprof()
    __alloc_contig_pages(pfn, )          <-- start_pfn
        start_isolate_page_range()
            isolate_single_pageblock()
	        set_migratetype_isolate()
		    pageblock_isolate_and_move_free_pages()
		        find_large_buddy()

If my understanding is correct, the start_pfn comes from
__alloc_contig_pages(), which is get from zone's pfn iteration.

I don't see it filter non-free page. So the possibility of free/non-free is
equal to me.

Maybe I missed something?

[...]

>> How about: (not good at commento)
>>
>> 	/*
>> 	 * We start find large buddy from start_pfn order, since a
>
>It is unclear what start_pfn order means.
>
>> 	 * !PageBuddy() means all lower order page is !PageBuddy().
>> 	 */
>
>Here you assume start_pfn is not PageBuddy() already, but it
>can be an order-0 PageBuddy(). That is why my comment explicitly
>excluded the case to begin with.
>
>How about?
>
>If start_pfn is not an order-0 PageBuddy, next PageBuddy containing start_pfn
>has minimal order of __ffs(start_pfn) + 1. Start checking the order with
>__ffs(start_pfn). If start_pfn is order-0, the starting order does not matter.
>

Thanks, will use this one.

>>
>>>
>>> Feel free to reword the above.
>>>
>>> With the added comment, feel free to add Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>
>>>
>>> BTW, I also notice that when start_pfn is an order-0 PageBuddy, the
>>> "if (pfn + (1 << buddy_order(page)) > start_pfn)" check below would be true
>>> even if there is no buddy straddles start_pfn, although "return pfn"
>>> gives the same results as "return start_pfn" (no straddle). The original
>>> code before the addition of find_large_buddy() (commit fd919a85cd55 ("mm:
>>> page_isolation: prepare for hygienic freelists")) checks start_pfn == pfn
>>> before the straddle check, so the correct code should check start_pfn == pfn
>>> and return early. But since current code is functionally equivalent.
>>> Maybe adding a comment about it would be sufficient. Something like:
>>
>> The comment above this function says "a buddy that straddles start_pfn", this
>> looks good to me. An order-0 page that start from start_pfn also means
>> straddle start_pfn.
>>
>> This may differ from original logic, but seems not wrong.
>
>Straddle means a buddy page has start_pfn in the middle and the caller

Ok, maybe the word "straddle" literally means it. If so, it really confuse.

>in __move_freepages_block_isolate() needs to split the buddy page.

Do you mean if start_pfn is the head of a large buddy page, we don't split it
in __move_freepages_block_isolate()?

Per my understanding, if this pageblock is a part of a large buddy, no matter
it is at the beginning or end, we should split it.

Just want to confirm the behavior with you in case I misunderstand.

-- 
Wei Yang
Help you, Help me

