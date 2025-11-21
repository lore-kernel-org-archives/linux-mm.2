Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD86CFA747
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 08:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5508F6B00A4; Fri, 21 Nov 2025 03:24:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525BC6B00A5; Fri, 21 Nov 2025 03:24:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4647E6B00A6; Fri, 21 Nov 2025 03:24:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3558E6B00A4
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 03:24:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 445A91A04A2
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:24:24 +0000 (UTC)
X-FDA: 84133927248.12.37B2B1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 706BC4000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:24:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=deqqUwZd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763713462; a=rsa-sha256;
	cv=none;
	b=hijcK71vUK+32za3tPDndq36ckxezAda3cD9CPdHDJ96DM3o6T/8w7Lz/VYl8+mybBqGoB
	3yhLx6pU7luP+zDnKyVyh9WD3t3S4nmfk71yRO1DQIFdtqOiPt1PzzHvYDKMtobQH6tS/F
	MZh4oMqPFBibd0+CoAndvWkzbqPYC98=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=deqqUwZd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763713462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6odRYoVvC43S8BYKr6dC5ZBDb3z+PCom4Tp+Qd78Q5o=;
	b=0dU3pVpqTYS8qXsfEAGBbL6Wk6R0z3ZbhptI+igtp2vpKTVfYU/gWHStraBxJ0kaJ6g9aL
	QdcDvGdzwZDEmJlnCx+itDALUSBHKHoE9VtbX3ySqSbADTJUQcGzN9WTx6fQdLmBgDWEob
	Ao/ye760j0Dtlfu+aT70FxufACwqBqk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C1CB43F78;
	Fri, 21 Nov 2025 08:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6434C116D0;
	Fri, 21 Nov 2025 08:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763713461;
	bh=r3iepQmIuL44wttg1FVL5hu3fjV2x+1BvBfuMfW5rDw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=deqqUwZdo4qrzs+eFKEe58bB+MT11bEJSEOK0dfHAlBZnzcri2JrQdRU27PyC2fc5
	 W1afd92FJEC7KtpPjXQQJmEDpp8oCUXxPXqpTMNYaiJ9ybFaVerfE6RkO0ocjjFhm2
	 MFRdQoIhdyYRDeVs9Z4ZMSztl47aMEzVeYO2FbaE/UPBO2fb5RSdTJZYKQrzMBU0wb
	 u5ktjYYcNXuuJq+by6wYzrOq9WkKbgqVCib66wpEJR6lViut3C8Gd7y177agjhpL3V
	 5fcWrkD/hAGt7dfWtvvKQ5EsH6+S+2zVmADloCMqbYwAO3QxA0KFkX8cGChiX6/SBr
	 fKGYhc2+ktUPA==
Message-ID: <9910c06a-f613-4c1a-b30b-ad8ad2d75c08@kernel.org>
Date: Fri, 21 Nov 2025 09:24:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 39/44] mm: use min() instead of min_t()
To: David Laight <david.laight.linux@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Christoph Lameter
 <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Tejun Heo <tj@kernel.org>,
 Yuanchu Xie <yuanchu@google.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
 <20251119224140.8616-40-david.laight.linux@gmail.com>
 <0c264126-b7ff-4509-93a6-582d928769ea@lucifer.local>
 <20251120125505.7ec8dfc6@pumpkin>
 <e06666bf-6d19-4ed7-a870-012dff1fe077@kernel.org>
 <20251120154405.7bcf9a6e@pumpkin>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120154405.7bcf9a6e@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 706BC4000E
X-Stat-Signature: zrcpyrcw9sckfjb483jdhtcm9py7wgig
X-HE-Tag: 1763713462-623224
X-HE-Meta: U2FsdGVkX1+hZCQFw+dF2vtLPFawvBQFgCT8qy66apqbw532MyG0qmuqvsMF1439utPVT3w/6flSM2wuBRnhOsZLcgupuvOGjqDwobUSwD9lnJHyn0IZr0pJFRM5CprCO51MkBTO75gzhRvSz1FNY/fnJMvnDU3uRuJjRj6lFMuE4Kp2k6V4SQsxowL6U4RfkPClp4E/qB4FoYATk3dn16ToJNmmeFgs6pkvIkPTE2Ta/8KlIpT6Z7XsL+y4PiuX3fYNHHRTvyGVVGTVHupMqyJWfSxMuPrFF62+JwzyaE5OSGIX+h+4h16uxpmwN6p7trZznVQtWHDOLHPLiMDKWd4/8NBMzc6KaeYjxkNup0wtYl3C1MvvpJlOO1HqvEU/jpmFkrSCgd72EYKeXnEbXG7L1SSy3LHvb7/CJhaAnyOaCRwuG8qX+KKU5b5pxH6L75eWAgC7CUSvipxqP6JGgg5DUu2Du8qLjj6hecok2M1jvuPXS3cmk2Zvp+caR3WnrFtGG2a6zKzXMxOyyO6SIQ5WCn7hvxoX4CkI8icqJ2/fPdlYjs1diI1AXj/MIciP6Gg287+QMba32r2TcbUx+xflMjKET8HPcs2A6vLBNp8lXEJrcEU2+6zbHxh7eJkqIz11pBcSAGx8cHNBxZjKn6kca+0ZH6xByR8/k9qK8XftdS/cHsTZJgQELFfcgAPAxANi+HQAhYZt+r2kL+yq5ReeGsRUhpnE2QhceeLAnHSoX2pgdjh3NZ6E1jjCfubKvUoZ/+0EikZQN2ox76U4SFEqKQa591pKg3fAY9K6whZfvGG6mg32jDBMhnFyI6fV9dQ9i6KJboqy6cpxTC5ouray7w0GLq4gHLcqGK+jN7hfmPzr3iyYEA0MSmyTI8+hAqLcKWx+AiMUVV08s0uggj07z+nNaDLjnbCfS4ML5PuTUnViOV+ek9K3HhAGHXpi63Tyab1b3o1ctVxpiIp
 6edrC70G
 RgjLh95GvWX3LMS/ElOajZqhfbnjEGsKCDZIM2oPiw0oC4Mybhc3kL1SqDimx0/jm5oxVoyKm/gdQJM3HH132dpb2so2+DfmeEN8m5dgiAKUZIkok1Wf/CfulGocMsRUmn8J/iPW9tauqz/r1XyvONtgN4Q8zJ/si/+S4+/qYf1qBT1yyPnknfiECMwFD/5OiYIIqyp1zHra0yIpnOR/RsapCRgjeWVXsc5eL8xdQMM9CTnfG4exvfKyYuLN0cKVIgo+6MKWeXvs3QQ/ZIxk3TemaN/ty8l4R1f7Zb+6bp9TpEGoqYSieAlbKFHJamMakps7ihept8iMmz9OrNHsV05leF+VcSyVi5XyZzxjVRJiZM8YfSOisJE2V7OLlPrqkSjgwOKkMmB8iBH3s+EuJzxWiyRLv2wHjxl6U4g4w6KoSzSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 16:44, David Laight wrote:
> On Thu, 20 Nov 2025 14:42:24 +0100
> "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> 
>>>>   
>>>>>
>>>>> Signed-off-by: David Laight <david.laight.linux@gmail.com>
>>>>> ---
>>>>>    mm/gup.c      | 4 ++--
>>>>>    mm/memblock.c | 2 +-
>>>>>    mm/memory.c   | 2 +-
>>>>>    mm/percpu.c   | 2 +-
>>>>>    mm/truncate.c | 3 +--
>>>>>    mm/vmscan.c   | 2 +-
>>>>>    6 files changed, 7 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/mm/gup.c b/mm/gup.c
>>>>> index a8ba5112e4d0..55435b90dcc3 100644
>>>>> --- a/mm/gup.c
>>>>> +++ b/mm/gup.c
>>>>> @@ -237,8 +237,8 @@ static inline struct folio *gup_folio_range_next(struct page *start,
>>>>>    	unsigned int nr = 1;
>>>>>
>>>>>    	if (folio_test_large(folio))
>>>>> -		nr = min_t(unsigned int, npages - i,
>>>>> -			   folio_nr_pages(folio) - folio_page_idx(folio, next));
>>>>> +		nr = min(npages - i,
>>>>> +			 folio_nr_pages(folio) - folio_page_idx(folio, next));
>>>>
>>>> There's no cases where any of these would discard significant bits. But we
>>>> ultimately cast to unisnged int anyway (nr) so not sure this achieves anything.
>>>
>>> The (implicit) cast to unsigned int is irrelevant - that happens after the min().
>>> The issue is that 'npages' is 'unsigned long' so can (in theory) be larger than 4G.
>>> Ok that would be a 16TB buffer, but someone must have decided that npages might
>>> not fit in 32 bits otherwise they wouldn't have used 'unsigned long'.
>>
>> See commit fa17bcd5f65e ("mm: make folio page count functions return
>> unsigned") why that function used to return "long" instead of "unsigned
>> int" and how we changed it to "unsigned long".
>>
>> Until that function actually returns something that large might take a
>> while, so no need to worry about that right now.
> 
> Except that it gives a false positive on a compile-time test that finds a
> few real bugs.
> 
> I've been (slowly) fixing 'allmodconfig' and found 'goodies' like:
> 	min_t(u32, MAX_UINT, expr)
> and
> 	min_t(u8, expr, 255)
> 

:)

> Pretty much all the min_t(unsigned xxx) that compile when changed to min()
> are safe changes and might fix an obscure bug.
> Probably 99% make no difference.
> 
> So I'd like to get rid of the ones that make no difference.

No objection from my side if using min() is the preferred way now and 
introduces no observable changes.

-- 
Cheers

David

