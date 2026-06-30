Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14F89C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 17:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E4C6B00CB; Tue, 30 Jun 2026 13:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21D36B00CF; Tue, 30 Jun 2026 13:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38DA6B00D1; Tue, 30 Jun 2026 13:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF03C6B00CB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:04:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 404A6A05E1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:04:31 +0000 (UTC)
X-FDA: 84937202742.20.69A5459
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 55D7040007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:04:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qIUeLrAU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782839069;
	b=Erapyz5G65Deldp82hFSOL/Igday1wTcAEIIQ2qxoREjBp0OK+6LtAjO5hmO20XXZQyVct
	cBcXpUJ9qMqGol6HiJtRLmXH5jO6WtcRR9yyI9mqe5ZsFEfwMpL+frqBfcIAI4Prpfl7TI
	dwjzJTHUsHdeduf551uPb2IQ02S/+xo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782839069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/CsbYV4XDviXFW81lgbhLDB47StBOrhGmsnhiBiiro=;
	b=ju3fY+TK9e2WAU9lZ0pnn+YMkOv3C6n7DGHa1zQ4lWpKL5wSmURR0ivag2Hk5p97VZJblL
	UD1brAjhtkldWUfMvQHv2cRJC7dmqh7avM23AfWixYv4d97upCKmD6/wIuPkiJu7IBy1NM
	YgW56a0BRnSsj4nLEPJ14odku+pIWYo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qIUeLrAU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782839067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G/CsbYV4XDviXFW81lgbhLDB47StBOrhGmsnhiBiiro=;
	b=qIUeLrAUS8xPYvH8/wmNw9ubJF/bC6wfh5Yz9at3wXaV/ZuZvRPIshyNxD8wu7TqRSa3rT
	rvJh5wtFqMw0/sNSjkLYMl0al8s75VU857iAX6TkFB5XIiC6pAWxVzA6x5W3L2mg216yNP
	nMH92Rx11cETlXGkXmlp2r1oqn9Yax4=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 17:04:21 +0000
Message-Id: <DJMJPA37E3V0.39XKKI63O2ETU@linux.dev>
To: "Harry Yoo" <harry@kernel.org>, "Brendan Jackman" <jackmanb@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar Salvador"
 <osalvador@suse.de>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
Cc: "Gregory Price" <gourry@gourry.net>, "Alexei Starovoitov"
 <ast@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Hao Ge"
 <hao.ge@linux.dev>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v3 05/16] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-5-57bef0eadbc2@google.com>
 <397859cb-b127-4cc6-9c71-044afc99bf0c@kernel.org>
In-Reply-To: <397859cb-b127-4cc6-9c71-044afc99bf0c@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55D7040007
X-Stat-Signature: iudpaq7zdgnfchjs4ap6tzi5q1xaf5mj
X-HE-Tag: 1782839069-109364
X-HE-Meta: U2FsdGVkX181br7V2wVhwz3TSVDk6dfDwFVtDpxLYGAqfmF+9Jsl9zmdmvtkpRWwIKeQdgb3p13URqOdfNWXuNMawUCk8ER7NykLDyg7GrXxTrkWY72xly6iSh0BlpORMpgLJgOO2eo5BzSb17WQMf1xU7iHmO4HRso4h0YdRZeyYXmMmZtKKU05pFoIA3btSBShZj4YHvxvqHfnMAwJ/KcUGUBM2UDMhbv/UQPDybKlv95L80Rtcaen9bOI6lNbZ3RKDMFNyvV+rMhbIhP/1HkLL9EzF6TYpEs6SRbXSka7SjUp6L7rQzkpFgVJai9lrdcU068hvXj/JuvT9RiIqFzA4eye6kJP4oTp6Qh4psmTosO+5Shv9qOGZuLzchKbaQJvObKK65xEDJtPKDdQdM6kk6QblqZ5VpITBR3VSFSpAseyLxryR7dt97olC3ByK+DNY2x5q9zv2dd0qv3qiXvDQZJiWJ9CxjKSF6M+7s0tBiHxc/kh9umB8rzLB+oyqcspEbFJtgzAARjetndNBH46QO6uHI1zHeOe4WAPYfH1fGgzSpOroE8T+3nDsFsBj8CRvBcZUcA2mPx+DCt7SrHYyt2iYuy5lywe+JWtTM0C4fIXnUiAG8CPUTPhvjPF1CUPKNvzqdjK5RpeacK0fz1Z2K+x3ofTBzAj6TcmysUmncHGStpX2sQ5h5/k1lwB8eCuO4XNmJ7b8j/HYxuezLSii7vd5I+TdZ6h0ES/tGA5LqDihy0JJOiIUY4ykLlySpEtuCeDJ8J+Yk+plTzPmVrE0X1UHmAv1qmvKxgUNDMVE3b8qaDPzK/d+5fD0cPDmtL0HBl8zYg6mRHHYbhunstZMmY9886c6oRWMPd1buykrEaFHPqlU3eHiJ6sPqlhgc6x+AWhz2PiLv34k/i3Y9FLKc8g4PGrSl/cqG4UbhbU+e16u4e2DfFva2QsOc/ZFT5Lam05YK93XUjDXE4
 ZHETa0Z0
 j97S/Eez61+wvM9AZiQTMXdgNC/Z9nKoixDg1lDUfJAlXWpXA6mwZzF4+baznH1jD/ZHQJlFDDm7g7/3rgOik+iSxW0tA68H3X3B/o3lTczP1jdY0cC8lgf1LdS2lJrzikvU78DG7cY2lSEuAuw3FJPgQY4L+cT52sJ6Vut69oIMgIe9D5VzgAQ/i4VmcToh6ezqAVSAI1fXpWxDyznczAyb4rw5oSh01gmttvk9dOHDpbsjnEB3OmOPH54YYBM7RJVUQOyTrpeAUdD5wKJRa7xKqCCNhGk4JufCY4jv7jPk54kRS4a6SpF//Q5Ua2hbhLIDU50yVf42i05RJ6fVf5mFW9AV9fW3lcR6lPG69xFKsOxDYQybrKu1n4rRJJUZwngG3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 30, 2026 at 1:36 PM UTC, Harry Yoo wrote:
>> Ulterior motive: adding an alloc_flags arg to the allocator's
>> mm-internal entrypoint can later be used to do more allocation
>> customisation without needing to create new GFP flags.
>>=20
>> While adding this flag to a bunch of places, create ALLOC_DEFAULT to
>> avoid a mysterious literal 0 in most places.
>>
>> alloc_frozen_pages_noprof() is defined above the alloc flags
>
> The function is defined below the alloc flags, no?

Yep this paragraph is stale since I created mm/page_alloc.h, will remove
it.

>> so just leave that as a slightly messy
>> exception instead of trying to fully reorder mm/internal.h for that one
>> case.
>>=20
>> No functional change intended.
>>=20
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  mm/hugetlb.c    |   3 +-
>>  mm/mempolicy.c  |  10 ++--
>>  mm/page_alloc.c | 178 +++++++++++++++++++++++++++++--------------------=
-------
>>  mm/page_alloc.h |   6 +-
>>  mm/slub.c       |   6 +-
>>  5 files changed, 108 insertions(+), 95 deletions(-)
>>=20
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index a3ba63c7f9199..8d409d075e3e9 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5271,24 +5271,98 @@ void free_pages_bulk(struct page **page_array, u=
nsigned long nr_pages)
>>  	}
>>  }
>> =20
>> +static inline bool alloc_trylock_allowed(void)
>> +{
>> +	/*
>> +	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
>> +	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the curren=
t
>> +	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() wil=
l
>> +	 * mark the task as the owner of another rt_spin_lock which will
>> +	 * confuse PI logic, so return immediately if called from hard IRQ or
>> +	 * NMI.
>> +	 *
>> +	 * Note, irqs_disabled() case is ok. This function can be called
>> +	 * from raw_spin_lock_irqsave region.
>> +	 */
>> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
>> +		return false;
>> +
>> +	/* On UP, spin_trylock() always succeeds even when it is locked */
>> +	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
>> +		return false;
>
> Except for deferred_pages_enabled(), it's not specific to the page
> allocator. SLUB has
>
> 	/*
> 	 * See the comment for the same check in
> 	 * alloc_frozen_pages_nolock_noprof()
> 	 */
>
> ... and repeats the same thing as above.
>
> Perhaps let's factor it out into a helper
> rather than trying not to forget to update the other place?

Hm, not sure about this. I think I would say it's a "coincidence" that
these two bits of code look the same? Like, page_alloc.c uses
spin_trylock() so you can't do alloc_pages_nolock() from IRQ on
PREEMPT_RT. slub.c ALSO uses spin_trylock(), so you ALSO can't use
kmalloc_nolock() in those scenarios. But those are two different facts
that just happen to be isomorphic? Putting them into a shared helper
would kinda imply that these are part of a single system with inherently
coupled constraints.

I dunno I'm being a bit of a ponderous philosopher there, I don't have
particularly strong feelings. But I'd lean towards leaving this out of
the patchset since the potential deduplication isn't really related to
the other cleanups anyway.

