Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96093C624D8
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 10:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CED86B0088; Sun, 22 Feb 2026 05:28:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CB16B0089; Sun, 22 Feb 2026 05:28:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85E746B008A; Sun, 22 Feb 2026 05:28:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70CBB6B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 05:28:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB1A7BA285
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 10:28:13 +0000 (UTC)
X-FDA: 84471717666.02.ED292A6
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id F15CA1C000B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 10:28:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EIcnW5tp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771756092; a=rsa-sha256;
	cv=none;
	b=mE9WVQjoj/Wooafa0qNSukwxNc1arz4Zr2QBgwuUc4MH0YJ/vDvO36Zs40h5iybrC/7+k0
	7dtz5odeasne8TxJ4vTRItTQwK5OIBMv6lJ8MChoGgi1b9LRjpkg9TVj5+smdO81nG9BSF
	tFQ3urLo2ClGwEIRHtQQ46bpo5wz0gU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EIcnW5tp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771756092;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIJVg8p09TsSnpCQkBfV95Pq4UjSUpbDjODUZI/KWZk=;
	b=2+U6RxMZbWgaRdaZ/lc0cugUhvovx/Umx3GqT1QU1X6pW+tuCsok6TrvYjhSoRm49+0uCG
	AZSQIRlNtSPLAIHTjFa4B2uUfIenYIRuPCqoJrozz41DPOsanKZatEkMrNVEU8bo+puirY
	D/lpQdLAYLv/PON1znGBIN2y4lhoDIc=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-65a1970b912so7314945a12.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 02:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771756090; x=1772360890; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BIJVg8p09TsSnpCQkBfV95Pq4UjSUpbDjODUZI/KWZk=;
        b=EIcnW5tp04vKcD5LhmA8t7c2TXPCgDuZ9zp2thGe5V7Z93t4c+qS2BRfzZqdBBrdIW
         f+JSNOw7FIhUke6qz3xat5clO3vpfRC9CDlfM7x/gtpkibDfaAvTJ+EjaqT3Jnn4hSl7
         6CiqnY+JH25G+cCAyrigpxbFVFJH3opr8ibjyxwvkt92u2BEL3syUqxnnpvSxifqf+vj
         S1USCOWCc3RAS16CqegM+lYvk/7ZVwePHV5xxwYb0EupwR7YlMariP+0zhYBMfb+B6QR
         NE2m1QPszoMFwZ1031gDA8jYZL+B5UX0RcLpEOdjS4SmQCL9/8avtWv6cXuHOreUnJup
         qlfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771756090; x=1772360890;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BIJVg8p09TsSnpCQkBfV95Pq4UjSUpbDjODUZI/KWZk=;
        b=QWAW5zVtFhIJclX0VV7GjfPfwIbK+Ey26j8hdgMm24Q+D4uJX6yO+Yr/GNRh8wD4GA
         bKt7jRourYJho16zc3lDtvD4G2sMs+qtmj0LHN0c3HxTXPDk7cKYClrTIp6EZzUDaBDe
         WCkV1tM1vGSit0qj0jbV57A2MTgTIhEzAb/zL1qoYLwuh5zDBgcipOYZ27mSsZFp8sbD
         uetvo9ELtw0PEcRrME1XtIVCQxkygwdQoESVYRC5zBY3R1bEYGHd9oN9s9eCY2Wo+iM/
         MfGlXQWnZwIF7X69olnvO3tlZ9M5VzEUI25tP8B1rxvTx/oikefsRhAlqxIgwdHhMloD
         tSYg==
X-Forwarded-Encrypted: i=1; AJvYcCVrFjivVeWx1eHSCrrBJfX+98uzBz34FttRVYBxD66m8AttiBy9MyIWQE0E9yw35O+RIs/Qd/gxTw==@kvack.org
X-Gm-Message-State: AOJu0YybcY8g5U1CaEnj502nnUmd5wvIBsl9UYwb3sI0xxlHbCkWqmk3
	lb0VifONFA7aeK+p74srfplRvNZEViLxSA1uiyiAWphzSdg6nt3vnobT
X-Gm-Gg: AZuq6aJPkbCuTyAaP9B2ca7Ud0KxCcEmijiI4qtX1cq6vxzXgoggfhQuYgk5+hYujNL
	jMCO90hgz70OK0F9vLTDjcuJ9tStP4JhG+h1sO75+GZXqzoziE9YiJcmjnfVoGIc1iocY3JxIEG
	SmpunWShnT3S/nExB32gtVKMkImCEbD8tEq4sf6nnAHsYxbFQIBVfjEP5CrF6DtYpwrLePiXL5d
	2bgLlaV+ZiRjXOkujpcwfRGJYPKts3oxJCoyPjJlblVAYIWQ2Fk+pOtX0nUEK/Gk8AIGddINzQN
	GTjoWqVTCF72tJ7WuIaiMXxa8snhw/rKoBAV1GO73djyTVhHEZ1ZAD7vWvNRTLL22KSxkVm41nu
	PDO0GEvvcMH15BXeVyB5ONuanAqRKpLauX2A1PM1mPM3oaFDxx2a1cPw9xmzyScLBQf+QNPHV63
	0CHwvVFcZt03zBMZUAg1+UtRacjQ6Qm3R/
X-Received: by 2002:a17:907:7f9e:b0:b88:5a61:5461 with SMTP id a640c23a62f3a-b905415bc63mr678686966b.2.1771756089789;
        Sun, 22 Feb 2026 02:28:09 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084ecc8f4sm197912166b.61.2026.02.22.02.28.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Feb 2026 02:28:09 -0800 (PST)
Date: Sun, 22 Feb 2026 10:28:08 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Linux MM <linux-mm@kvack.org>
Subject: Re: A potential refcount issue during __folio_split
Message-ID: <20260222102808.bxyjc767ebugmooc@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260222010425.gbsjzhrew3pg4qrw@master>
 <20260222010708.uohpmddmzaa4i4ic@master>
 <6346656B-7518-4A55-8DEF-C2E975714C8B@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6346656B-7518-4A55-8DEF-C2E975714C8B@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 4cwd3rccajkd975h8b8ecm599s9r4woc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F15CA1C000B
X-HE-Tag: 1771756091-332591
X-HE-Meta: U2FsdGVkX1+CjPOfMxW6o3Q8G+I/WlwHRIIMedsfQcJsyfXco2pKdPSDNP2yA5Ne4cnW4VqUp89b+nQR3W6ONdJS1uuobQxQHawMn6/Gc2KNMYGZ3JExIe8a+PvjdCyLWA/Lq6Lae5Z8dx/SiK9kjrHwGDGi6rsQyl3gkSx17bDJIqFM1V5acm/00Ex3FXERkus6C5MAbln0BbZTI5eb8N+Tfhs62gfr/rOU7/nWfSPp+IR3AU9k6Jttu57ygvzLWIhqZ+7wZEqKTS5kY3k+wZvzGw02NkHct+4/KgTnLYjK3LBaqrMH1Gq7PuDi8S8wenbpurL6qzCleBOPC/F8BY+dozelRzHmO3vgDVWuPQQTi3meD0BsJ90AlLJHpn9VPghUpYRlVHd+Pty2KpRjxxW4oR6BVKDZ0GpRCMWUKIeLOqn+T8ou/wCYusHpMel88xH8c8t7rNzU5mE6BVqM/94LDp13ONGn5vV+/qgPEDhSXxOOh2fYh33Q3XD/Vpu4lCQWFvr+HiE1KLXlud/BE4dSh1KRHjlVJnmzBml1F1XkaB++Eah+J3Bm+nneQ5tR7DfPGD7HX7rnNpracnRjlPHlH76iqBWMx/cMmR8hl3rj2VEidw37vRM8FEMXRaq7mh2GTNCdHXVQgrk2lb1e18vK6MgGkk3hxt3UbT1wy8eYYnTkN23VG45Q/k3XQo+fqXO1E3EM3ufXQGrVqB0AnWDg6IJ8r+xcli3fkhLxG7pFCeOco+Nsu2OlvlZTGKWHa/H+T0zlRLxObyuGwydiILSRkQ35tgOAJ0t4TRI7mJSiY/q/MnQ2yOd6/iDkOlFoZ/ImQa2Co1cyJ2MWMlI9gkfck90LQ04/XFnLneBNCK8+204NBtRrRWhiCqe0u9drQdGlp+pYwOXIX2gfULc9Vu2sReHt4gKXXNKQATnIMjuynaUzceT5iQi9s06qQJc/OXISyEd0DFuvh9wXGjy
 5cFITWAg
 2FbSaKqv0qmXzmiXtI5X71Q4VqKWWm5dizw5WMG4Jqnf27FUsBFsQo0TbuFTeyFDNBqSg448lCQcIxV/BmAh+vOx4jzkm9Xp44ytz2SC1U7LmO1SjpDhfYrr5USzGf7kyVzNfkjAgoA9gVUA0u+BD1mi8/TOEKFKC1rXBVe5q6vvVTxmQXa/Ljgsbo1Qf6Bo+JOMKg8ca/uA577o9cJCVRK8hpKGJxBDE+0E4K83BC5nvQeXHXQfXAioEd+qthshKqNB5tD4C4HOevI65Q+x977gSW1n9QDiYwaG3QishwL36ttD8+1shdKFAgULxaB2UyEDlAASRgcp7Id1e+d4hwj4WCPQFI5o8DSXDW6cSpjKP1SsetwaxMr2bQuh8VP+B8Rwi1frmiSFmHeS8UJJp/T1+xepJW2XJyjqYVAwjbsGyr4R/aYsDVxx5RIxULi5kBS/g2z7YbbdjMTa4UI7JBs+Pf6DVcxtqspUhSFQt0oOmj6x9NybFBDABZTjxBM+bVXMe81arO6+fqYhOpimoqQ0T1lxJ02N/MvEmM5agsRa0DqqQFuv5ZtKWX0+FwZYWApW57Dfy43GgQoTJ0QQgMip5GuxuRaJinqlSe2SHz3j5BDjq4MOsj+deVa+hmA2ux3aixKv3AXSnlQBxHSRBDJ5ZuAzuaL9pLvrqsVkEMhiSigd+BOqa7smZSGD0XHy7jPm2oUxHuPHntaziQ7+7H24eR+9pXjFdnpY3Ct4eiimeBsz4P99uzLQvwQZxmkwDkC67wWhyJ5AXbrA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 10:00:44PM -0500, Zi Yan wrote:
>+linux-mm list, since the topic is interesting and worth having a record in the list.
>
>On 21 Feb 2026, at 20:07, Wei Yang wrote:
>
>> On Sun, Feb 22, 2026 at 01:04:25AM +0000, Wei Yang wrote:
>>> Hi, David & Zi Yan
>>>
>>> With some tests, I may find one refcount issue during __folio_split(), when
>>>
>>>  * folio is isolated and @list is provided
>>>  * @lock_at is not the large folio's head page
>>>
>>> The tricky thing is after __folio_freeze_and_split_unmapped() and
>>> remap_page(), we would release one refcount for each after-split folio except
>>> @lock_at after-split folio.
>>>
>>> But when @list is provided, we would grab extra refcount in
>>> __folio_freeze_and_split_unmapped() for each tail after-split folio by
>>> lru_add_split_folio(), except head after-split folio.
>>>
>>> If @lock_at is the large folio's head page, it is fine. If not, the
>>> after-split folio's refcount is not well maintained.
>>>
>>> Take anonymous large folio mapped in one process for example, the refcount
>>> change during uniformly __folio_split() to order-0 would look like this:
>>>
>>> after lru_add_split_folio()  after remap     after unlock if @lockat == head
>>>   f0: 1                      1 + 1 = 2       2
>>>   f1: 1 + 1 = 2              2 + 1 = 3       3 - 1 = 2
>>>   f2: 1 + 1 = 2              2 + 1 = 3       3 - 1 = 2
>>>   f3: 1 + 1 = 2              2 + 1 = 3       3 - 1 = 2
>>>
>>>                                              after unlock if @lockat == head + 1
>>>                                              2 - 1 = 1
>>>                                              3
>>>                                              3 - 1 = 2
>>>                                              3 - 1 = 2
>>>
>>> This shows the refcount of f0/f1 is not correct, if @lockat != head page.
>
>after lru_add_split_folio(), refcount for head should be 0, since it is frozen,
>each of the rest subpages should be refcount == 1. Then, head is unfreezed
>and its refcount goes to 1. remap adds 1 to all subpages refcount.
>after the unlock loop, every subpage get -1 refcount except lock_at.
>
>
>>>
>>> The good news is there is no use case in kernel now. Then I am not sure this
>>> worth a fix. Would like to ask for your opinion first. Hope I don't miss
>>> something important.
>>>
>>> Since there is no real case in kernel, I adjust the current debugfs
>>> interface(/sys/kernel/debug/split_huge_pages) to trigger it. Below is the diff
>>> for the change. This change could pass the selftests/split_huge_page_test to
>>> make sure the code change itself is correct.
>>>
>>> Then change the lockat to folio_page(folio, 1) could trigger the issue, when
>>> trying to split a THP through the debugfs from userspace.
>>>
>>
>> Sorry, the diff is lost:
>>
>> From c6d4c3d81e16f5f4b509cff884540bec0f91e6c3 Mon Sep 17 00:00:00 2001
>> From: Wei Yang <richard.weiyang@gmail.com>
>> Date: Thu, 19 Feb 2026 08:44:49 +0800
>> Subject: [PATCH] [T]mm/huge_memory: test split with isolation
>>
>> ---
>>  mm/huge_memory.c | 31 +++++++++++++++++++++----------
>>  1 file changed, 21 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index ed0375ea22d1..65354c5edfef 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4621,9 +4621,11 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
>>  	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
>>  		struct vm_area_struct *vma = vma_lookup(mm, addr);
>>  		struct folio_walk fw;
>> -		struct folio *folio;
>> +		struct folio *folio, *folio2;
>> +		struct page *lockat;
>>  		struct address_space *mapping;
>>  		unsigned int target_order = new_order;
>> +		LIST_HEAD(split_folios);
>>
>>  		if (!vma)
>>  			break;
>> @@ -4660,32 +4662,41 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
>>  		    folio_expected_ref_count(folio) != folio_ref_count(folio))
>>  			goto next;
>>
>> -		if (!folio_trylock(folio))
>> +		if (!folio_isolate_lru(folio))
>>  			goto next;
>> -		folio_get(folio);
>> -		folio_walk_end(&fw, vma);
>>
>>  		if (!folio_test_anon(folio) && folio->mapping != mapping)
>> -			goto unlock;
>> +			goto putback;
>> +
>> +		folio_lock(folio);
>> +		folio_walk_end(&fw, vma);
>> +		lockat = folio_page(folio, 0);
>>
>>  		if (in_folio_offset < 0 ||
>>  		    in_folio_offset >= folio_nr_pages(folio)) {
>> -			if (!split_folio_to_order(folio, target_order))
>> +			lockat = folio_page(folio, 0);
>> +			if (!split_huge_page_to_list_to_order(lockat, &split_folios, target_order))
>>  				split++;
>>  		} else {
>>  			struct page *split_at = folio_page(folio,
>>  							   in_folio_offset);
>> -			if (!folio_split(folio, target_order, split_at, NULL))
>> +			if (!folio_split(folio, target_order, split_at, &split_folios))
>>  				split++;
>>  		}
>>
>> -unlock:
>> +		list_add_tail(&folio->lru, &split_folios);
>> +		folio_unlock(page_folio(lockat));
>>
>> -		folio_unlock(folio);
>> -		folio_put(folio);
>> +		list_for_each_entry_safe(folio, folio2, &split_folios, lru) {
>> +			list_del(&folio->lru);
>> +			folio_putback_lru(folio);
>> +		}
>>
>>  		cond_resched();
>>  		continue;
>> +
>> +putback:
>> +		folio_putback_lru(folio);
>
>        ^^^^^^^^^^ cannot always put folio here.
>

You mean I should put page_folio(lockat)?

This is the error patch. After isolation, if folio mapping
changes, it release the folio. So the folio is not split yet.

For other case, it handles differently. See below.

>>  next:
>>  		folio_walk_end(&fw, vma);
>>  		cond_resched();
>> -- 
>
>Your code change is wrong. Because when you are using split_huge_page_to_list_to_order(),
>the code pattern should be:
>
>get_page(lock_at);
>lock_page(lock_at);
>split_huge_page_to_list_to_order(lock_at);
>unlock_page(lock_at);
>put_page(lock_at);
>
>So the extra refcount in lock_at will be decreased by put_page(lock_at);
>

Yes, generally it is. But we seem not forbid provide a list to put after-split
folio.

And I found there is another requirement, if we want to put after-folio on
specified list, we have to isolate folio first.

I took sometime to realize it.

>But your code change does not do put_page(lock_at) but always does folio_putback_lru(folio),
>where folio is the original head.
>

I put "folio" to @split_folios after split. And then do folio_putback_lru()
for each of them.

If split successful, @split_folios contains all after-split folios, including
@lock_at.

If split fails, @split_folios contains the original folio, including @lock_at
by some kind.

Maybe I misunderstand your point. Would you mind be more specific?

>BTW, in the folio world, I do not think it is possible to perform the aforementioned
>split_huge_page_to_list_to_order() pattern any more, since you always work on folio,
>the head. Unless there is a need of getting hold of a tail after-split folio after
>a folio split, the pattern would be:
>
>tail_page = folio_page(folio, N);
>
>folio_get(folio);
>folio_lock(folio);
>folio_split(folio, ..., /* new parameter: lock_at = */ tail_page, ...);
>tail_folio = page_folio(tail_page);
>folio_unlock(tail_folio);
>folio_put(tail_folio);
>

Yes, in the folio world, we probably won't lockat a middle page.

Another thing I found is in commit e9b61f19858a ("thp: reintroduce
split_huge_page()"), the comment of split_huge_page_to_list() says "@page
can point to any subpage of huge page to split", but the refcount mechanism
seems settle down then. So I am afraid actually @page has to be head since
then.

-- 
Wei Yang
Help you, Help me

