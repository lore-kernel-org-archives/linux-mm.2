Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C0C3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 02:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19B096B00A9; Tue, 30 Jun 2026 22:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B996B00AB; Tue, 30 Jun 2026 22:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B886B00AC; Tue, 30 Jun 2026 22:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC6966B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:21:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31452C0F47
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:21:31 +0000 (UTC)
X-FDA: 84938606382.30.4A7CA1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 861D312000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:21:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hS4zIjG1;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782872489;
	b=n4EiE3VnggyVq+nqxu4Wia/lWNTsUW87yng8KvKDRfMJoVJoBG9tlVwZagNqyKpiIxa0Wd
	BezkOiogKG61Su31/MysX9OKHRFvyV7NZDN9I9pQ//0Cwc2pR39KkjGCmhujWZioNaF1vs
	AsB0t2Ov4qdQ8xEDyOZgdfO9GW3n7TY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782872489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVfVUy7IfXqZtOhE1UFWWdUajt97pUy56ocHqvqgDOo=;
	b=ek2v6Na8SmDxKxm5gELQckqcxnDKloI+po7FEqUB8/pAAA9+IsIKC4EUn+gprGWX9AZVhk
	Kgv43C5fw//jwk6UZSNhdp1j9KHnYgdmMOguk5Mf4HTNY1SejmjGOMZSP0pbgsiZcNCSaw
	K/JhGOrX/hiUvd3qYBtfnsBX3dBlrdI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hS4zIjG1;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 074396001D;
	Wed,  1 Jul 2026 02:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439E71F000E9;
	Wed,  1 Jul 2026 02:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782872488;
	bh=zVfVUy7IfXqZtOhE1UFWWdUajt97pUy56ocHqvqgDOo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hS4zIjG1iKnyvbC1j55hqujYovzRU7RrTYvCHSGCq2EhprH3x5VvLMPx7/cP5K6kE
	 DQpMolhpTWoHpkkFtOfjW0+teIem5DqywhOWROmOQcbzczRwKONTSi5XCkEp2g9xhM
	 DxftY/gA2fib91mCi5eSRElaByTYiZuSHs1TPiDKU/GxvaZPhMcbTrzyq6ghFhM8sm
	 Pc7HiVGimFGtEQ7vur6v9h9f1XC9ySZ2braLjDI8Sxx4ADIinH8PZdmgq1a3+LQqbR
	 +6UqvdqsMrw2GdZKTV/BTi2vkeuZmyaOvt8Kbjg1ChAeMAL1TRKatQAOCxMLAi8qu3
	 4Wzm7Nbb8g8ag==
Message-ID: <791b1aee-8667-4721-ad93-2a1b8fd2aef1@kernel.org>
Date: Wed, 1 Jul 2026 11:21:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/16] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-5-57bef0eadbc2@google.com>
 <397859cb-b127-4cc6-9c71-044afc99bf0c@kernel.org>
 <DJMJPA37E3V0.39XKKI63O2ETU@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <DJMJPA37E3V0.39XKKI63O2ETU@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: w4eddibcoiwzcok8upnqanipm79s49fb
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 861D312000A
X-HE-Tag: 1782872489-572168
X-HE-Meta: U2FsdGVkX19Ft1w12NXIIpcWc5cNS6+o4lK5iYVNo4ECYw5kP5DNBPNXSL3ee1zi6ilokF1DvCA68fcZokYuAbos63SpEnkMyIku+pYviHMcfGWZPSgPpRvIDcCmM2fB1CuxZVTUXPrFKklvzq9yksmAZM0D0GlE/vnwzpSik2lss1t4qsPlYX+nFhDmBdAwrAVJn2Pui9pCmmLjPH3t74TRpzsTalefPX9ZvhVyiihCpSpgtfhQnMRbRr4SrQnu4R51AK00w5TGlauqFlr7iE+cVTjPOwtkVXCMEBYx9pFVWT2622AI6QRSMnm930TXfwn2MPVJUAl8z8J2rAgzK9776CMh+5zMTKu0WMDQHbIMbmTkZB+CJTNNhlp+jIt9E09qKhj0MAO73yJj/7Tuk1L91nNXUOKoxqnjB/RvdqTC+zElxwV8WBfnNOLSckLcUptCWlF3YDS+2QXVy0iREOTKcQr83wVDMCxed3DO++FpikivntdXHCSKl9vcvQp0xX16i95xZ9azwDyBkl2i52ZxlKNTfsHc+k+b+9I07yyeu57VUhqfhP0q45bNAN4wMV+lJqkC/YenQ0Eni9s6gfH2VoR0U93mQ/FqxUf8ZuyGIqFxYGz5fkv8AFDSFpLtBth74Xy6T3xB04XwAtM40q71iRKroTjOmXq8HVo2vRb9zOXSpl1nQujHxEl8UknJ9ZCrN003exiGOcG2ElGN9E2wbYco+tvzJFhZLIDZNyTbxt6gMFZ12Y6OiC9kBveh48VwRvLQYfUDQeuIrhfBBQwpEj0iUJyfCa33PPDUGVMZw0Nw6TafBSkUUaCik3Nq1rKYWpIChg/RzqAvSkA3CB5dIScxuKYXR8dhdJCOESm8XPGjQ+1X6JCaqJuN8Gv/40QjUfBowNfe4b6/FF3OK7uOBrGQsMjMfsVkIgwthuL7mhNYDynbBDJgBtMUmk86amBjBg5a/YE+9gp4IWZ
 M4FnSiQw
 fFbjfc0pnMZVt8KNZ1PKsu/YXX6DrMpe54RrZd2WWRbDZxl4C0OuCRj75SQyPu2Q1pt9RzSMRJrjC0/wFbyl7OIxF096L3MblDPKAZpIlwCp0323vm8IGc22M+Rx9rhxxNPFZeyGK9EORsX4fgbjzbT/gV1Z5VYq+VE/FkHF/MqNTzgPH7iU2aS/iW+7vGUEQRMByUB4O1PEoTZbQWEuVVcBUgIrMtYWfM17SaEsbF7NrQT8OCLE5FJ7d/ojuW2XF61wQc9BrWVgn8OISx3mm1Iue5Vklr3TiYBqmG/9c3IiRcVYxwcUpgwVQcX4wvKcoqU3n+ctEXXDpxWtHQZCUvBMSsTqWkPl/tN2FS+NXsIaU6Yx9/kZXXvkkjcxSmjY06Qaw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/1/26 2:04 AM, Brendan Jackman wrote:
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index a3ba63c7f9199..8d409d075e3e9 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -5271,24 +5271,98 @@ void free_pages_bulk(struct page **page_array=
, unsigned long nr_pages)
>>>  	}
>>>  }
>>> =20
>>> +static inline bool alloc_trylock_allowed(void)
>>> +{
>>> +	/*
>>> +	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
>>> +	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the cur=
rent
>>> +	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() =
will
>>> +	 * mark the task as the owner of another rt_spin_lock which will
>>> +	 * confuse PI logic, so return immediately if called from hard IRQ =
or
>>> +	 * NMI.
>>> +	 *
>>> +	 * Note, irqs_disabled() case is ok. This function can be called
>>> +	 * from raw_spin_lock_irqsave region.
>>> +	 */
>>> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
>>> +		return false;
>>> +
>>> +	/* On UP, spin_trylock() always succeeds even when it is locked */
>>> +	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
>>> +		return false;
>>
>> Except for deferred_pages_enabled(), it's not specific to the page
>> allocator. SLUB has
>>
>> 	/*
>> 	 * See the comment for the same check in
>> 	 * alloc_frozen_pages_nolock_noprof()
>> 	 */
>>
>> ... and repeats the same thing as above.
>>
>> Perhaps let's factor it out into a helper
>> rather than trying not to forget to update the other place?
>=20
> Hm, not sure about this. I think I would say it's a "coincidence" that
> these two bits of code look the same? Like, page_alloc.c uses
> spin_trylock() so you can't do alloc_pages_nolock() from IRQ on
> PREEMPT_RT. slub.c ALSO uses spin_trylock(), so you ALSO can't use
> kmalloc_nolock() in those scenarios. But those are two different facts
> that just happen to be isomorphic? Putting them into a shared helper
> would kinda imply that these are part of a single system with inherentl=
y
> coupled constraints.

But as long as they use spinlocks and can be called in unknown contexts,
they are supposed to have the same constraint?

And actually, the only reason free_pages_nolock() or kfree_nolock()
don't have these checks is just because we don't allow kmalloc() ->
kfree_nolock() or alloc_pages() -> free_pages_nolock(). Once we allow
them, we'll need to repeat this again.

I think it doesn't even belong page/slab allocators,
probably should be spin_trylock_allowed()?

> But I'd lean towards leaving this out of> the patchset since the
potential deduplication isn't really related to
> the other cleanups anyway.

Ack.

--=20
Cheers,
Harry / Hyeonggon


