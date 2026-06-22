Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 514EACDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC7C6B0088; Mon, 22 Jun 2026 04:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DFC6B008A; Mon, 22 Jun 2026 04:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C5A6B008C; Mon, 22 Jun 2026 04:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3E186B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:24:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C8431C56CF
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:24:24 +0000 (UTC)
X-FDA: 84906861648.28.E60E61D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 78D334000E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:24:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7hvvYOR;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782116662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K03wRREZQjsGSIHtZ/1XuSXDAXjxS5jJGV/J2n+GdkI=;
	b=vsgG92Euc91sMkchtJN82hhw0fxXX8jwx66d1Zqj2jpgtyRCNniB2wPt1fLwZ3MDTSXPrb
	O2S0HqWme8bns0CrnoxhvfPKG8FU1HxVXOCytx4n/lEk+zw1iifDEJh0BbBNQOPvAWy3bE
	JSBVbHCvv1dzNj2MhBY6NAe0QPixU+o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782116662;
	b=pGdl9H7WySKUZMxawcWKMr3AzVvn26ag2fCntLBX0FZxMEbRvYE10gapHJ/AHDp2i0lJrh
	gTgXPE51Q/BkK3osI/Laywurv1YmCo4Bs37J2PjWnU24ygk6WLTQjcRpMp4SUrTYVUPJz5
	gDog0XDHiTrfWmVGjYGAxieAcy0RfM4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7hvvYOR;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FF2D6001A;
	Mon, 22 Jun 2026 08:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56C51F000E9;
	Mon, 22 Jun 2026 08:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782116661;
	bh=K03wRREZQjsGSIHtZ/1XuSXDAXjxS5jJGV/J2n+GdkI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=F7hvvYORj4k2euoqp2D1z0s27TwsBudJ+2Gr2sFpSGaDGuXm0vggOr7lYHZnExCYO
	 zAZuGHkrJl6C75/KlY8UHQJiq53JF30tBNYlZGxT5ff46fh+jNOkcYXVIemNWAUKuS
	 pVs6e2kcFxlofW7J5TUOUhAHFHUPXddE1kko4wei5S0y76sxzRIedMH3iFOLe/tCIq
	 1H5EQAVjByIYGIcrKR4s1YtFKAuTM2tC0t8nTrHPWuKYpfI0Iwn/PLlBmXNxDuMnJO
	 GvYj3h40xR1AJ4adI8vj4j9fz/T1lSJeztFBKfMy0H3ExgrFtQ8l3M/QQqH6j93ZQp
	 3JeT5gG25zCAQ==
Message-ID: <0eeb0dd3-92e8-4841-b250-e77540da0693@kernel.org>
Date: Mon, 22 Jun 2026 10:24:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
Content-Language: en-US
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
 <ajS96fWbG4dzP3u3@casper.infradead.org>
 <DJCVLX0WK118.3V7CXOTLISFOQ@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DJCVLX0WK118.3V7CXOTLISFOQ@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qsfk7zametp8s9q38fftsgydtdhisp1n
X-Rspamd-Queue-Id: 78D334000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782116662-262894
X-HE-Meta: U2FsdGVkX1/G48/CPJTJD+Qzmran13n66wk8LevjEisQtMM/7bkzGytSRREpQbZQkC/nTk8p4h+VIoSgE34RqRn64uJDtjWivJG3mB3DoNALp0Q47cD4v1fgnYzTCyLZUX2DpE34SqTiCgAICzQDvhWha+3bzFw/AgW9m5pj5lhpOWnGWWTeIF1VEoNsaajlT8Z8+J56DUG8Qt2MkLIXF0vQPO9R/bDAqrwvhBv+xeAGO1No0Qca0Y4HSkBljRTZ37hAcx9YSfG4RGHSiOMy+ySq4C/turJ9SnFOaszich8d39HKhInuOGk8dkE6wW0AoLi7YpvmtRZxSKCZlSGcVrOxrdDt6zDAdBU2jjSolrWTPt+nMXojQyq25LhyEEgMohlDt2bW0lAtqNN+Y/p4/kNBREcxpFfxQJdOJHdYKfTCPq0dnpLLxvDkxjFar862+D0GJB0WR1lM5Z+RJ24i2uI6sj4rk2EeOUnRVZ6JOtr4oaQsppP2H25KcMWMwXoKQgWPToeIiBos9+YdlESIhJs0WJZc6JoTIk+DYhDZdAwdz7jRkpKkXNjPueLnmb2z6Faw4Qm0St/IYqBzA+Xx0e6sGCLwv5DmQccVAErske9w586t7YPXW463Oz/MA8AtOHY6qxaEGTFx32i1D/uVsZvBH96qZshDvVjUiCA0eEPqklfBG4/jHwgYT6uEKd7zqdSTiVMimeoCRl91GPobBE5HjaKP1HqbSGfByNjnXH22EQ1ADLknhdhSSPmN8G4mN1hcBxkYaK4M1ERS2jtKp7A/tRwwdxCow2Vm9poUp3KBgYwqH7ccwkmI8QDrbOfhTHgs9Al5TpncRpu83ZcBx9sODN6veCC9890QmVPME7yjVhiUORgapRGuExtjO1VJ4i40gNoyiQ9XasksIXnPDu+HAmhtvyRamRRc6u+uC+H1cHBPBdNdUOafHh5OE0jnf7qUcU+tl4Q2HdkWRuo
 6aTTSCbR
 JuTbduh9vnarlZy+YfFMmpkDPTGydx2bk+DG2A8Acb1NIeiqYGR/eEdd8gbW7GBjjaf4DNrd9FzpfAQs6iRqAnhunETE1P3rL2tSFzJz7SXmPx7AYuWAgL5rGgnXjB/IRiRGfylr65fiBe1dTp8d9yHoDJt41GXcFa1wlisDERrqdNoyAkyBEoNHTqnHC0aQitiu9S2TAn8f4JfSR7cARA+04zdf3aO/C1YXg8XZeMEsZ453wrplgqLgeejNsuiHTixOedMgBfWGxyRiyru1dwMlwgfuS5z+/QLAccnUje/FVpfgObTJXJF1eAJD1PYfZbu0JNea0a0j5sXFhIQPC1KnwVpN8o7zOfxOFXXXpRS3Gkq1ZpSRoP0hv2yS0HhaKGkjf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 10:17, Brendan Jackman wrote:
> On Fri Jun 19, 2026 at 3:56 AM UTC, Matthew Wilcox wrote:
>>> +/*
>>> + * This is the 'heart' of the zoned buddy allocator.
>>> + */
>>> +struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>>> +		int preferred_nid, nodemask_t *nodemask, unsigned int alloc_flags)
>>> +{
>>> +	struct page *page;
>>> +	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
>>> +	struct alloc_context ac = { };
>>> +
>>> +	/* Other flags could be supported later if needed. */
>>> +	if (WARN_ON(alloc_flags & ~ALLOC_TRYLOCK))
>>>  		return NULL;
>>>  
>>> +	if (!alloc_order_allowed(gfp, order, alloc_flags))
>>> +		return NULL;
>>> +
>>> +	if (alloc_flags & ALLOC_TRYLOCK) {
>>> +		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
>>
>> So the only GFP flag the user is allowed to specify is __GFP_ACCOUNT?
>> That seems bogus; other flags would be reasonable including all the ones
>> in gfp_trylock, as well as GFP_HIGHMEM, GFP_DMA, GFP_MOVABLE, GFP_HARDWALL.

We could start phasing out GFP_HIGHMEM and GFP_DMA somewhere :)

> Definitely makes sense for the ones in gfp_trylock.
> 
> For the others, I'm not sure - this "nolock" functionality is a bit
> weird and sketchy, I suspect the reason for the WARN here is "let's make
> sure we have a proper think before we allow it to grow usecases that are

Yeah you were just keeping the same allowed flags that
alloc_frozen_pages_nolock_noprof() currently does.

> meaningfully different from the other ones". I think I like that
> conservatism here, I would lean towards keeping it? Not a passionately
> held opinion though.

Yeah if we expand it, I'd do it separately and in response to use cases
appearing.
We want _nolock to be used only where really necessary, as its success is
very limited, not to be (ab)used as a cheap way out of a wrongly designed
driver or something. ("oh I need to allocate something here and can't spin,
so let's just use this, solved").

