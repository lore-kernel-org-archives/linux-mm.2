Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D5AD0D17C
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 23:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F7A6B0092; Wed,  7 Jan 2026 18:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CCD66B0093; Wed,  7 Jan 2026 18:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A43E6B0095; Wed,  7 Jan 2026 18:08:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17DE66B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:08:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F9705837D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 23:08:46 +0000 (UTC)
X-FDA: 84306709452.23.371FEC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B8B4440007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 23:08:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qijEDvAX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767827324; a=rsa-sha256;
	cv=none;
	b=s0BUDctHZJcHAXovsfpEuZp5CFvV0kSZa7QMlxpwFakg9B6byvGXMDPyG9aNN+2h4lQx06
	/fuQXheO349xxzpuUl3OJft1j82Q6ku8J4MmzIbfqZ5gg8zlBR9sB7u0E0RqsYN7Jwk/FO
	x1my4xP5N3m31LCFNZ3dY1gHWqgU9gg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qijEDvAX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767827324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3XSPLGUx+aK/0Nlg0Qexb9xDqMw4oTr9esfmSDsbx8=;
	b=zMdi3sqf7hRhjgcwRnE8CTTjFoGnq0SQiGpLQ9lETQKerkzOxv6n1ZkaJVnvdWbQ6qLG+e
	F1dhijySDSyxlrXBKkF/uAT2PfUQGYewsdvmfVlXcffrmDEsDxHJ18z4HOYUH2V8fdih6q
	TnqMZOtJ80OWSJ4NZVrCrfKzQPWgQN0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 81E42416B4;
	Wed,  7 Jan 2026 23:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAA8C19421;
	Wed,  7 Jan 2026 23:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767827323;
	bh=YCncmwLpuFDd321NxUtaZfeqnlyxrNQELRI0R3y9CQ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qijEDvAXe8cjtvsNzyVD3d46f3BoJfAvJ3fM4RT5xX84aE9W+c+bqD1mRsmm1iOmn
	 /t5LfuX8HaZpx5lvNCzT+zhOUJggsm5+tbQ2kkqWH6rtiuRaaACYB3+lM4Sav/UtDq
	 DbKay1mpfP6GpuhNMS30I/XifPhU2SOOysMQNcpSgv/w+JUR34xbY3jtLD3kBqia2l
	 ilOb7obGcT4WOegp4HqUjlYHyK63lFwihl1/KMGGiyFMNBj0CrCwgK2BpKLalkwKF7
	 zjXTSRKLBOch5BPwJHjNF9aY0769FzHwqk9hxAm2Z5aukce3jgG/4wnqksuo3IHxcm
	 TXAduN0mR9MRQ==
Message-ID: <2ace6fc2-6891-4d6c-98de-c027da03d516@kernel.org>
Date: Thu, 8 Jan 2026 00:08:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
To: Kiryl Shutsemau <kas@kernel.org>, Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
References: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
 <CDAEC896-E3EB-4EAB-9F0F-70BC448B3B9A@linux.dev>
 <4f82b8ef-77de-422b-a9a5-691c4eca24a3@kernel.org>
 <glu3noshgeh7ktwwqofk7xcwkvhek2x3hrbdmyyo56gmctdx3t@adsfih557p7g>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <glu3noshgeh7ktwwqofk7xcwkvhek2x3hrbdmyyo56gmctdx3t@adsfih557p7g>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B8B4440007
X-Rspamd-Server: rspam10
X-Stat-Signature: gqe6jcug3ndut5mmskw17qjq5wifhj8q
X-HE-Tag: 1767827324-105606
X-HE-Meta: U2FsdGVkX1+Iqq6HEQX9PRg6uw5ls0PImI1FLZYyvgfAlztn4SG5FjgVIA+NJ6k11dHmn2TgvCOTzJjNT3XCaT0J01f1vhTkJ/noQpsQ9kpUcgJpZkAjicur6DhGpL5TIPQo0gArhuLGXugdG+vlV2FqgOgU5xShRnQdPWawKf1vnlP+OdD3lt6A++6ojCaU2pRbMnIYoHOQwvHl4Rjd8vElgBnMG9reQAiwcQzQE40upVyDRV0Huw1c+JQnjU2Wwqfn1URZ0p6anTLJF2hNONpgNrVQr1mSajZG8VVwMj7RB4AmJPDAXC0mGIFEGMVhnZnL+hMZJpRdSX2mlW0QIN1V3MRLc2MX7kozXfQEZcl+KtB8DruX6ZpoySuodJ1xs5pDt/UXz/O/4KItPqrt5Xd2r4CGtkQky6xqt9geX+C0e8VMyMLlgBA6hBD97m45Q4/PghSBRCTNBU1yt1as+Ebad63/oMtpesOk4cbo9pAx5xxzHhyfFHQlswen3nS6MHlmb4UEc6YyX9pZDMIFg0i5H1mnrZlyUQHGsnYiYD4P/9YQbhMynyTtZWBsFGJBQbJDQi9TPos/Prfz4v3m08QF04cDqbKHl8YTNsaPrZbCIDK+q7hNbrKunV5o0ULutU6jA4uvyDZ28JA9akQyU6QX0YN2YqHM2qo0br9y/FPa6Ihvx85bxWtCCOIrdfo2eLOcOhbNeDZ8gO01fJaF6Fhw37XBypk+2sCmInK0SxI21D2sbqVrISm2LGrYcgx2nAip/8kFb3DTkLhDg6GcQR+Mwpqwuu/FKLE3NiCodfhIXt6L7Ff5qjRPsGxffSEi5H67A16LobKPUBycf4KMwb9i5vj8tu5hxn/lErmJiNLP4ktpDCw8+DgDGeRf8qVlUqicxObdOp/nH5T6tn4Au1SwpRCaD74Gk+J2cxETHMqR1HHGeTHYBLjRv+o31Nz16AD1b3LYHzjY2Iuuc45
 9oW2JpWC
 DOLTbm6Y1LmO8ebMFJ//8ZNWGd4F7IEeIB3gPMEJv5RqqHIVAp0dvmvLQwVPbHh9LPuVAEAhe+a4MPyWYldCOeXQccmtFp+qYYlnV0Tw24MB/ZNuSNOstHONNjf61t5mEvTx/TvlW/A2TeLgmi/qYJ5d0WVGn3tku93PjPXCt5f2Gr7JeLXOrOhxlZZFt8v5bZQzWZ5xrHN5ynE7QTEePhzUE2vftLkEkKFALBL1g8M9ov0cvnIziibaQnF7HGRSY/oJm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> "Then we make page->compound_head point to the dynamically allocated memdesc
>> rather than the first page. Then we can transition to the above layout. "
> 

Sorry for the late reply, it's been a bit crazy over here.

> I am not sure I understand how it is going to work.
> 

I don't recall all the details that Willy shared over the last years 
while working on folios, but I will try to answer as best as I can from 
the top of my head. (there are plenty of resources on the list, on the 
web, in his presentations etc.).

> 32-byte layout indicates that flags will stay in the statically
> allocated part, but most (all?) flags are in the head page and we would
> need a way to redirect from tail to head in the statically allocated
> pages.

When working with folios we will never go through the head page flags. 
That's why Willy has incrementally converted most folio code that worked 
on pages to work on folios.

For example, PageUptodate() does a

	folio_test_uptodate(page_folio(page));

The flags in the 32-byte layout will be used by some non-folio things 
for which we won't allocate memdescs (just yet) (e.g., free pages in the 
buddy and other things that does not require a lot of metadata). Some of 
these flags will be moved into the memdesc pointer in the future as the 
conversion proceeeds.

> 
>> The "memdesc" could be a pointer to a "struct folio" that is allocated from
>> the slab.
>>
>> So in the new memdesc world, all pages part of a folio will point at the
>> allocated "struct folio", not the head page where "struct folio" currently
>> overlays "struct page".
>>
>> That would mean that the proposal in this patch set will have to be reverted
>> again.
>>
>>
>> At LPC, Willy said that he wants to have something out there in the first
>> half of 2026.
> 
> Okay, seems ambitious to me.

When the program was called "2025" I considered it very ambitious :) Now 
I consider it ambitious. I think Willy already shared early versions of 
the "struct slab" split and the "struct ptdesc" split recently on the list.

> 
> Last time I asked, we had no idea how much performance would additional
> indirection cost us. Do we have a clue?

I raised that in the past, and I think the answer I got was that

(a) We always had these indirection cost when going from tail page to
     head page / folio.
(b) We must convert the code to do as little page_folio() as possible.
     That's why we saw so much code conversion to stop working on pages
     and only work on folios.

There are certainly cases where we cannot currently avoid the 
indirection, like when we traverse a page table and go

	pfn -> page -> folio

and cannot simply go

	pfn -> folio

On the bright side, we'll lose the head-page checks and can simply 
dereference the pointer.

I don't know whether Willy has more information yet, but I would assume 
that in most cases this will be similar to the performance summary in 
your cover letter: "... has shown either no change or only a slight 
improvement within the noise.", just that it will be "only a slight 
degradation within the noise". :)

We'll learn I guess, in particular which other page -> folio conversions 
cannot be optimized out by caching the folio.


For quite some time there will be a magical config option that will 
switch between both layouts. I'd assume that things will get more 
complicated if we suddenly have a "compound_head/folio" pointer and a 
"compound_info" pointer at the same time.

But it's really Willy who has the concept in mind as he is very likely 
right now busy writing some of that code.

I'm just the messenger.

:)

[I would hope that Willy could share his thoughts]

-- 
Cheers

David

