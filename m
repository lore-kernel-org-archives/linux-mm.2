Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E588C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FE8B6B00A6; Wed,  1 Jul 2026 04:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5156B00A8; Wed,  1 Jul 2026 04:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ECFA6B00AC; Wed,  1 Jul 2026 04:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA85A6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:41:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66FDE1A0278
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:41:18 +0000 (UTC)
X-FDA: 84939563436.03.AC3F241
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id 72A5016000C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:41:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DmU9SIka;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782895276;
	b=Ca82c9KVc5p8HXjSfNcjj/DzG+YurmJH/+HZ7HEhbJgjseqZ71PygkIiwIruEzD+mfOhOq
	V+H6tuZopMCXupVKXyiPkBhjJxxlNV5eaZQuAcDA17C4cT8nU2w9WOJWiOMSZwJplHbw1k
	C6jck/B9Mhck7XDNfu2kMG+3v2YoV48=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782895276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGrFD8S8lQ+BASYixy8RN9uVW/2UQNoP/HAty0kmd4I=;
	b=birgLkKeY+sj4HGHHYJ2/jttQSKiiY4TSmPaM1opyPrgu12/QwL5aN4+B7UlSX8OcY+J23
	lfI93hSTcJ2V9N/IN6xq+3+yR9rUeROrqZ8egIwJ2Fpje5OfIyl+t5GfwqEaNeSw8nuVDW
	+ygrKevAiLt4eb9So+Is7wdRi9YEE4g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DmU9SIka;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782895273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pGrFD8S8lQ+BASYixy8RN9uVW/2UQNoP/HAty0kmd4I=;
	b=DmU9SIkabHFsQPD8XxzUshbsAT7wCxhtvnPHcgxRiNYlAjgVDK+AILgqoS4CwAOOWXLgCu
	ZU2oOAPTr0qa96GDozfDP/t3fIQDl79mExZWgZWMEoz6iwZCBQ1UeHdevZl7fb5RVIN14N
	Xool8UPLEtm+blogWqnWnSN/fnm/dYU=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 01 Jul 2026 08:40:50 +0000
Message-Id: <DJN3MAVWO7YV.2FIHJGQO8I6US@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Harry Yoo" <harry@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Brendan Jackman" <jackmanb@google.com>,
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
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-5-57bef0eadbc2@google.com>
 <397859cb-b127-4cc6-9c71-044afc99bf0c@kernel.org>
 <DJMJPA37E3V0.39XKKI63O2ETU@linux.dev>
 <791b1aee-8667-4721-ad93-2a1b8fd2aef1@kernel.org>
In-Reply-To: <791b1aee-8667-4721-ad93-2a1b8fd2aef1@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 72A5016000C
X-Stat-Signature: p9d91cfhoxa7ek34ghbibuhhkqf1opzy
X-HE-Tag: 1782895276-699536
X-HE-Meta: U2FsdGVkX19RKXPOtDk4g/PHg2dLD23iqwzwLdrGkrJ381tx6DDCZikkAPGPWT42znSs8yVzPrRiH3dN3zDMR9/U07NEbR57gRsds3OMj++bnVcx11AY15iS4epQH/oiYes+m6CO5M4icbVKE0foLHGiCb4EIXBfrNLfjzT740Oz/ibr+pJtf+WL3UgE7C1Oz3kuYqV+U4vj0x9INiLGM94FHEO2B0uGFdxBeyfNTQHiuxiXSLB+6d0XgCa3HT1oRDd1BVDG3SPjYSFb59DmvoZ5mN5w9mNITD7tj+caNfeZEYluxUA9VXI64vx1tSmOQqJufo/RQ/CPNRnZKt75iYrV8TaoWxYBmfKvcVwVfiWLxp0muA4NWSX9k/8Lyvs5OoFCtdNtebsllmTk1hyd7HWK5xvdSeChR63ojdIUzrsCazjFwiNn3LuzBQBM0v4lswzt1qZDU9om49IEzERp6XTrSnp2xV6tbfvqrXF037pZPH+l7eoem+wZZUkzvbC0h7hc2NE5lVq0KkuGGm8yFCTAjcv73X24S3p9ZcCJJ/wmxFZgs6GUoKqI3gX4qXCOQ72O1vZWAJopoPk4/jF8NFU7Xoe+NVOIXdk7xFdpoclEvoBIau+echFlxwnAWf0Vs6a3hugZFV5Qm8KlPx2InR4DxzcInyeerzIAb8fP8TqYFL9muC6spO00yZ2kU/jjFK8PGWjUI9f1rRJlbGC+xQdbZmCR3Wv5flNwzR5oEkXooYWWYjabmd1goKauAb8YH/GJzdGb5602gT2efr1haCKicPtEuAZU6wTCgD1GNmXbn7bk/aPvTq6b9RgVxliyndsQGt5ggAC9sK6n/RyS0DyM5KMk91JKhXSYa4tl8xd7JiN2MH2NdjPTy9QoCyzRdty4hSluWbbU2aPeHqDAWYGRMlQQOWnUg0oPnHLJg3OB5k77AZ2vdY5yhXIqszYuGBM7kfN47hqC3/8XjVc
 vNmlZHXf
 eGGjADEpZj/PA8Dj2OC9G7PdaNMlGGJ6WsWCLQBitAVtACqn7/3xBdBe+RhX1wI17Nek+vCojQkCKETg5SLFr4Ybq230Ea+oHcbEXEpxOwt9UcMSg4F0YB4k8hWIrkjT49+OLh7lCDxXoAURcx9N3aKrx0HXLfm7dAp/6K+v0z2JQ1hTcpfVpdvCsO0Wfez9uP26Jg5TwEpwARPMUA4+cbDbxteEuwwvSFMWWxmuSWjaF6ofHiRi/nTZ4rXluiwLN6aM5rr0BbQDDo1+v8TuI27jEl/wGbzVgF2jS8XOdupU12+xhJUyBNoL04k8e2GhwoweoRWKzySMkOBHuBPl7hyX0BIqVDQdx8rK04g2AktmVla0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 1, 2026 at 2:21 AM UTC, Harry Yoo wrote:
>
>
> On 7/1/26 2:04 AM, Brendan Jackman wrote:
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index a3ba63c7f9199..8d409d075e3e9 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -5271,24 +5271,98 @@ void free_pages_bulk(struct page **page_array,=
 unsigned long nr_pages)
>>>>  	}
>>>>  }
>>>> =20
>>>> +static inline bool alloc_trylock_allowed(void)
>>>> +{
>>>> +	/*
>>>> +	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
>>>> +	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the curr=
ent
>>>> +	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() w=
ill
>>>> +	 * mark the task as the owner of another rt_spin_lock which will
>>>> +	 * confuse PI logic, so return immediately if called from hard IRQ o=
r
>>>> +	 * NMI.
>>>> +	 *
>>>> +	 * Note, irqs_disabled() case is ok. This function can be called
>>>> +	 * from raw_spin_lock_irqsave region.
>>>> +	 */
>>>> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
>>>> +		return false;
>>>> +
>>>> +	/* On UP, spin_trylock() always succeeds even when it is locked */
>>>> +	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
>>>> +		return false;
>>>
>>> Except for deferred_pages_enabled(), it's not specific to the page
>>> allocator. SLUB has
>>>
>>> 	/*
>>> 	 * See the comment for the same check in
>>> 	 * alloc_frozen_pages_nolock_noprof()
>>> 	 */
>>>
>>> ... and repeats the same thing as above.
>>>
>>> Perhaps let's factor it out into a helper
>>> rather than trying not to forget to update the other place?
>>=20
>> Hm, not sure about this. I think I would say it's a "coincidence" that
>> these two bits of code look the same? Like, page_alloc.c uses
>> spin_trylock() so you can't do alloc_pages_nolock() from IRQ on
>> PREEMPT_RT. slub.c ALSO uses spin_trylock(), so you ALSO can't use
>> kmalloc_nolock() in those scenarios. But those are two different facts
>> that just happen to be isomorphic? Putting them into a shared helper
>> would kinda imply that these are part of a single system with inherently
>> coupled constraints.
>
> But as long as they use spinlocks and can be called in unknown contexts,
> they are supposed to have the same constraint?
>
> And actually, the only reason free_pages_nolock() or kfree_nolock()
> don't have these checks is just because we don't allow kmalloc() ->
> kfree_nolock() or alloc_pages() -> free_pages_nolock(). Once we allow
> them, we'll need to repeat this again.
>
> I think it doesn't even belong page/slab allocators,
> probably should be spin_trylock_allowed()?

You are right. I was imagining a function called alloc_nolock_allowed()
but actually now I see the name spin_trylock_allowed() I realise it's
not about the allocators (which both just happen to use spin_trylock())
at all, it makes perfect sense.

>> But I'd lean towards leaving this out of> the patchset since the
> potential deduplication isn't really related to
>> the other cleanups anyway.
>
> Ack.

Patchset is getting pretty big already but most stuff is already acked
and also most of the patches are trivial so maybe I'll tack it on after
all...

