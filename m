Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3909C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4946B0549; Thu, 13 Aug 2026 12:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7937D6B054B; Thu, 13 Aug 2026 12:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2736B054C; Thu, 13 Aug 2026 12:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7596B0549
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:40:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 465CF8020A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:40:22 +0000 (UTC)
X-FDA: 85096809084.18.485B3A3
Received: from mta0.migadu.com (out-124.mta0.migadu.com [91.218.175.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 121A24000E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:40:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tFCtmhFX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.124 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786639220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Uo4LpETSiHC1FwrwGEvIA0tqKarnN6awvcmjU8fKiw=;
	b=ntzAzjILBW/1Mz73orZcfNG4XHaFMvqs0Hq5KKBVsZD3uQ+BSC/5W2ulcDZYWgwCq7QgtF
	wouFcD/8KCUwbhvUxaSihwDkD/E2zveXyCkWEMLMT6WuALUatGuJ8bAmiUJnFsQ5XhLGJb
	g7vTaL8KefnZYWQjB/Mpy+AZ/bNxHG0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tFCtmhFX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.124 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786639220;
	b=lwvxjAgIWjwLoXkw8mHmiznFIsHOGq/G2wTr7nMO3NXXz8EV2U8pkWV5FrwCy7GjXfMF6I
	LeZ+qDm50y1nmwdJsfMP28xNZM86HNwjmnFQvuoCxgnsgBH71RqaDvqsEbCAG39cd1MzMe
	CH+z5LcraxaU17RnOMCANcRbsAiE7ls=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2xHRkVg+2QruCbn/49OFRRcW/C+6DJzcQqzEfAggLy0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786639218; v=1; x=1787244018;
 b=tFCtmhFXOIyUSImdJsntpW6QEZIEYdhdFhrWGeHE17FQZUj4nJhhYdtHGbHulYC1X00hkrSj
 hu81o0Hi7gy3LX5FNlqRtKSvkQDka5JGcbIc4xWpQEZtF1LACNl0v2sDZ4rf2KiyOUtgE6ArsTO
 cDXfytxvpzsjkzVGdNqMkjPs=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id a52373bc50ec12e6;
	Thu, 13 Aug 2026 16:40:08 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Aug 2026 17:40:03 +0100
Message-Id: <DKNYQN0U2DLT.3P5ROPG5HUF5Y@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Patrick
 Bellasi" <derkling@google.com>, "Reiji Watanabe" <reijiw@google.com>, "Sean
 Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 10/26] mm: Add more flags for __apply_to_page_range()
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-10-6f5729aa9832@google.com>
 <anEnO7KbDQg4k5nf@google.com>
In-Reply-To: <anEnO7KbDQg4k5nf@google.com>
X-Rspam-User: 
X-Stat-Signature: 5fkwwfwrt6poh5ezs6nfjwoy4bad1ayx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 121A24000E
X-HE-Tag: 1786639219-762224
X-HE-Meta: U2FsdGVkX19uWxVijaN2F0EEbbnsQpZF4dGcHD/bqno3gZiKxtD2jirD7GANmqXL3LkR0R4Li4Klv5JYh2pr11Z4r5BUdN80OXvM4pVypXW4BFl24mNw4KSaWKmsFhz+YrsbhU6X5mmAekuXp1EkbOaiVyz+7mvJaP9n7MA9HeEkmKddu6HQ2YqJYoI0G6E8c3OV0hQhViWG4LZeX4C6/VixZY0u1731kdDw20oc1KNkOrLX4KYTPFEJMmoKbDRY/Vdfsi9a5QSSujXV0zLG0E5h3/f2RT3ATS3phIGA6WZVdAvh0InVIfx+yKMmIdToT3ms65BqNRJa26XOC5WWy4YFg8WFnMR3pTFayQHlVrHMnSyt9TieXWYhKXWprElPdsn+3svOTyL6qZEEVE1z72Dms7UtObQmAbjG87Ynj7uCq2G/By105c9WTpmIiWlTeuNrT4cYvL4ytxtqJgmoOa9xGz/pA3rT+01KNkYkXjj8Fowr8V8gzWKhN5+8XarIVSZQ28iQG6frJFFFCgONR3x6uVAD0IQl0xyMHPaZzLZ3iQe5Yy9XoyjEPVl++eaPe5iluvDPaRsCBS5GiJ2Dx4th7p86L3FcKHvmsumMFgv/u2ASImrNISmBOpi5LMXNwalQWlLhX0kL8trQgNWcq9rcZvnvrOOhWXTGygJRnmPLIAHpKSTupty8r1gZ0tZBmZS3r71JhPp95grtxFmoZsXoeZuFotR0ZBJhLmJ9wxbBF8YbOcKdeTWKHRNuJIeAXp5yoGpyo3e1drY/HozuaWbDE8ZY5bidPFgUPvsk/oaHDerJx8UIOxSuJ8LSUq19AO3QoiKqqGYm40LRaoo5Xa9CDw9epvg7FtxiFMUwkmUwJxgIGIrsD6XQK9zptaozgKnZMsWpfvnqT02uJvESzD4GG7wkL99TUeAfgoO5jl3jsX13130XIDibhmw4QMw66Ba/hWrDA9wnouPj0a4
 FO52JCsB
 Q5cph4Q2S2FP9SPHy9udZRq4ixM5y7FAOuo0Uhb2TVFGXs6fc0COWE3mzr9kNwaoT7YF9dIjqM6BHmRheZ+6ZnPFRVqw9kSG4jgRsQj208cSHKOkKhEowImvNZWZaGt0c4sXVjHMGw7y7SFRV8nceadPorCLIdIJhPFvkCbSegQ5hWeh9RwvD3+Q5G4yC56vieJzkmH/JsVqluSaHv3uA5KKYKewAI8nQHL2FoVgcisnhzD95BPSLgBnGp6LjakScHM7Tf1tGRbQ5o2jh+/1FyoKTjaLBQ6xn5tEUQdAxYpySnXXbcJ0edHP5i51B/PQsVv8XAHBqenFkny9RzvnIvyd8cDIkKuVeLfACbGvzjQkXXm3eTpEY2ixcWU/1tk2kKIiU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 4, 2026 at 1:08 AM BST, Yosry Ahmed wrote:
> On Sun, Jul 26, 2026 at 10:22:43PM +0000, Brendan Jackman wrote:
>> Add two flags to make this API more generic:
>>=20
>> 1. Separate "create" into two levels - one to allow creating new
>>    mappings without allocating pagetables, and one for the current
>>    behaviour that allows both of these.
>>=20
>> 2. Create a new flag to report that the caller has taken care of
>>    synchronization and no locks are required.
>>=20
>> Both of these will serve to allow calling this API from restricted
>> contexts where allocation and pagetable locking are not possible.
>>=20
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  mm/internal.h | 26 +++++++++++++++++++++++++-
>>  mm/memory.c   | 59 ++++++++++++++++++++++++++++++++++------------------=
-------
>>  2 files changed, 59 insertions(+), 26 deletions(-)
>>=20
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 395331a12d62d..5a237d9c5fa96 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1662,9 +1662,33 @@ static inline bool can_spin_trylock(void)
>> =20
>>  /*
>>   * Create a mapping if it doesn't exist. (Otherwise, skip regions with =
no
>> - * existing mapping, and return an error for regions with no leaf paget=
able).
>> + * existing mapping). This doesn't allow allocating, most users will wa=
nt
>> + * PGRANGE_ALLOC.
>> + *
>> + * Do not test this bit directly as it is implied by PGRANGE_ALLOC, use
>> + * pgrange_create() instead.
>>   */
>>  #define PGRANGE_CREATE		(1 << 0)
>> +/*
>> + * Allocate a pagetable if one is missing. (Otherwise, return an error =
for
>> + * regions with no leaf pagetable). Also implies PGRANGE_CREATE.
>> + *
>> + * Note that __apply_to_page_range() assumes that pagetables for the ar=
ea are
>> + * already initialised down to PMD level, so this only affects PTEs in =
practice.
>> + */
>> +#define PGRANGE_ALLOC		(1 << 1)
>> +/*
>> + * Do not take any locks. This means the caller has taken care of
>> + * synchronisation. This is incompatible with PGRANGE_ALLOC and also wi=
th
>> + * mm=3D&init_mm.
>> + */
>> +#define PGRANGE_NOLOCK		(1 << 2)
>
> I assume this is used by the mermap as locking is not required because
> the mappings are per-CPU and migration is disabled while the mermap is
> used?

Exactly.

> Also, why is this incompatible with init_mm? It actually seems like
> apply_to_pte_range() is always lockless for init_mm (uses
> pte_offset_kernel()), probably callers are also synchronizing in their
> own way (e.g. exclusive access to a vmap area?).

Hm. My initial reaction was that there was code like this somewhere:

if (mm =3D=3D &init_mm)
  spin_lock(&pgd_lock);

But I can't find it in these paths and neither can Fable. So yeah I
think this bit about init_mm can just be dropped.

