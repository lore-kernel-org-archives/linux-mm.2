Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4348CF8859
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335856B002E; Thu, 20 Nov 2025 08:42:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6576B002F; Thu, 20 Nov 2025 08:42:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D57B6B008A; Thu, 20 Nov 2025 08:42:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0738C6B002E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:42:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0ADF160127
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:42:32 +0000 (UTC)
X-FDA: 84131100144.27.26F2C17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id F30A418001B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:42:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K3rtIRyF;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763646151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IhtvXZ8QlZS5KN18xFYL8OwmH7E6r9W5PH7l3gXBaCs=;
	b=KHJHYTNa2qTWi5H+BUHSz9XQXBZPXy9+Td4yRHFPPE1Q1JIep6htS59He76D9gYT7oPGee
	1BfmzYC/hcp74vH4Iri+uXCS3yyXrQemO4c+jLE+RU50wRpf4Rm56Dt81hn1NwPT7FzN6v
	QKlDj6lkZQmCr8jICS/XQHgWDuemqXk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763646151; a=rsa-sha256;
	cv=none;
	b=0Cgz/ry89lSN3LgH2IE518qvBkWhNm2rPWs7MQwEUrqu1KT+QWk9kcxtuZSih10LEKbtaZ
	hVD4qTx0CCi7jTRyHeO/KZNuS8yJ8AFiB/VCu/z3fnLTg/jLLzG8q1PXF/xxTnS7tWCI65
	SowjWZ4atvCPnSaGis6F72rOQi/WKKo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K3rtIRyF;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 706D26011F;
	Thu, 20 Nov 2025 13:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14026C4CEF1;
	Thu, 20 Nov 2025 13:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763646150;
	bh=Ht1OIK/aZGwiLrXboc7wimNOH1Dr30vWNH61iqtkHFo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K3rtIRyFY5JuIVHZJScwFQEdOsxo4+WVC17Jgy5iyfDYh51Dnc6qWfB3+Z2p0x2Pc
	 oEnBSdvoeVKyaVlrSk7FgwNjKZJfl0hWn22itFLBFE3yxZtm9nByrhhrTWWNxQvEOt
	 mKRJMafCuiiEAjaqje8pVbI1aDOegIRC8QX0SuvzxPnIMiiqkZfG+6wm0a5INqxHBL
	 K4oZe/c0DFh8etEw85g+lIsF76/TcryeoTLtsTJj5pNC4ASwD1ZQq0GHrRqadVTOvo
	 qHWkjtoFAla14tWGK4jVgwFFpHBaiFES25MkgV49IvxHoPSBVxWWcEn7EMGebVbcdu
	 po6wOXnw9m4IQ==
Message-ID: <e06666bf-6d19-4ed7-a870-012dff1fe077@kernel.org>
Date: Thu, 20 Nov 2025 14:42:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 39/44] mm: use min() instead of min_t()
To: David Laight <david.laight.linux@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120125505.7ec8dfc6@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F30A418001B
X-Stat-Signature: xpuar7sqd9ocy5rue141r8u39yejp68e
X-Rspam-User: 
X-HE-Tag: 1763646150-830366
X-HE-Meta: U2FsdGVkX1+9TehF5sJgBg9c2ev6PanpWEiKkAjtr7rx01NcMKzXnIXGkGHCxlmsvYJc9Qe5Fqrbso+o7qLHMC9pD7ZTdh9eQb4fexrwtiDySpxBoszxNk4X+4YQFKp1XyCmO9jWk8kX14m/AWNf2u/hpMGlV5N61TKEresXkzrDCf7XRSgT7rr0/zLm58xbS1tg6TZOAXHRqTZ9Swh96Oi1/803umJR2P/z/uXhYQQdds6NRCWEftJZj6ZwaEbEyp7RroSTyjaMGVQPSgRBUFdiLhCMFV8fjNd1jCU+mPxJgylg4ZlyixPp9GqjFSElyJhzCH5cgctiUnOL8XqjNJM2tMqZmD12L7kjFwDwFBFsqhMysykfxp5LWj/EP4Khwu5UZeofHCHWnuPAKlmCKVODSofJcJkPyeUMBeiHyDO+Aj0UhaT3Z9iTgVNtqendi7SvStlp7mBSOjpHNtpVh72uvwBtbWMS/fst+kNXysaaiBtPYaj/W4jCEZB/t/U6SNVw1J2IWGiGfQEf2s7KUxusSrzetHLtShwlgdSaljQ6rTUHfE+yGDNoPTdO/z0wly0LLiispFRLTMAx+cXVdAMw/sMhLfX9V/fi5JW3AZJjqU6gWJKaEGGDVg0op//KV/JtsMuzhDeZYTKuFjBvHzXz9hNgym1Fdzxkiv9PM5t1VHtcACgEtATBhOVPF7HjrltnMEjl5U++o4sXL0bYyq+DzzHnlbkrX2yst2ecjTtV49ZZRAiZRyikKP2ZCHhPQ4jAB4P5Fs61Toyleanr7gB/zFFfEWNYLJYwgSkwFYpOPXgq3VbqSgViLVtyGwgy7j3fg7ObWxXEY2LQivmIBmqdxOF8FNlFc1IETLUFaEhOCNxk6/tBT1s2WJx4oxgyigUvWzZ2AYPfhX9seNjeghh5n4XYSNAhMqL/5go+4ypvi33QWYdr7gVJWU0Suq586rmccQWX5+vcu0js8zy
 P8YyciBY
 TqQQmArQ3di1GmLW8pqkkDkHPcxEYa+cP9ZblEVOZXWg/tJcXAQdllEQpyUUamVXwULmmTp0sFKw3CUkYStjHxtdBRzQfTa0y6kW56F6SIqNFJzujoI3JSC2n9fiq0NZy3dwuTQWMox0EFinjP2o2cchnCmOW1IdAc3+SUizqgXezLex6+vb0Wrh4MK7NLOzWnI/AKovaAuQLNnmRa6huUAbpXXboKaMJZtd6SUo7K2GXrctpJjeFlW0J+BLlz1YqZMlnyffLHUhJVwDuu8fUGcXW4ZV6V9vBD81UjycQoz2yEzmVh8AqxHdV0A4IZBwIkeIk6e9gsIW4VQigGtzwLzpggLYV2Dz4tz7GS8JT0ZBaE9Bm/ALcwjQJmYY8WCZ72HDuX3928ykXoauf/9RWsKo3Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>>>
>>> Signed-off-by: David Laight <david.laight.linux@gmail.com>
>>> ---
>>>   mm/gup.c      | 4 ++--
>>>   mm/memblock.c | 2 +-
>>>   mm/memory.c   | 2 +-
>>>   mm/percpu.c   | 2 +-
>>>   mm/truncate.c | 3 +--
>>>   mm/vmscan.c   | 2 +-
>>>   6 files changed, 7 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index a8ba5112e4d0..55435b90dcc3 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -237,8 +237,8 @@ static inline struct folio *gup_folio_range_next(struct page *start,
>>>   	unsigned int nr = 1;
>>>
>>>   	if (folio_test_large(folio))
>>> -		nr = min_t(unsigned int, npages - i,
>>> -			   folio_nr_pages(folio) - folio_page_idx(folio, next));
>>> +		nr = min(npages - i,
>>> +			 folio_nr_pages(folio) - folio_page_idx(folio, next));
>>
>> There's no cases where any of these would discard significant bits. But we
>> ultimately cast to unisnged int anyway (nr) so not sure this achieves anything.
> 
> The (implicit) cast to unsigned int is irrelevant - that happens after the min().
> The issue is that 'npages' is 'unsigned long' so can (in theory) be larger than 4G.
> Ok that would be a 16TB buffer, but someone must have decided that npages might
> not fit in 32 bits otherwise they wouldn't have used 'unsigned long'.

See commit fa17bcd5f65e ("mm: make folio page count functions return 
unsigned") why that function used to return "long" instead of "unsigned 
int" and how we changed it to "unsigned long".

Until that function actually returns something that large might take a 
while, so no need to worry about that right now.



-- 
Cheers

David

