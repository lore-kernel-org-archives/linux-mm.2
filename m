Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E313C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 14:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2BE6B07D0; Sat, 15 Aug 2026 10:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283616B07D1; Sat, 15 Aug 2026 10:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199CC6B07D2; Sat, 15 Aug 2026 10:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBFC76B07D0
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:43:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D6C6803A6
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:43:36 +0000 (UTC)
X-FDA: 85103772432.27.73B4697
Received: from mta1.migadu.com (out-215.mta1.migadu.com [95.215.58.215])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6DBEC0004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:43:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PjBcCm2v;
	spf=pass (imf28.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786805014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mT+SGaq9qMcfq9PDZDUhAjPXB4BUxffDwX0VGsfRq1s=;
	b=LXHDQNc9lFA03ShbWMe9Piec1gdVewZdWAvibzChsk/MCazWoXOuzHpt973eutpkQX35CQ
	vmH/WaBOvy4N2HOnAMiexTuoyEaViwpcBmBtWNm2wIOfz4oegI1jh/rwLMWJzzzAOIQt1W
	2ReqgFjd8JETQ50VYoerV4BB0Vw/tkw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PjBcCm2v;
	spf=pass (imf28.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786805014;
	b=P5TntdHDase1+geP4dOtCIyj9dZBuR2Lr2FJUNcH6A3o/FiHKHOr77dKXam/511GPjz4d2
	lUUtmZ6plJuHJ8mhrFo0OUnCXrbeW3lLfpVG5KHQILaNIbNZ6GcZNapMTtSLU1v3mKhFAp
	KjkBzqfmAsRYbptD+1wH7rwMt4Zi1k4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4//uIXJEQ+puCtDj34Ag6s3cT0uGXLeBX5VN/A05+2w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786805010; v=1; x=1787409810;
 b=PjBcCm2vYXhQph+sYLh/Wf58HKQOfEadJOeYXQmZbEZLcZMzMNo3CSJGnMRHVV/8w8yciwO1
 NxZd6dRoo503Pu5Wk4N4SKTt+dIpOEMko/wgsPFcED/M5fKN9/oPTf00fJibABLeVx61kF3lJI5
 VFUlwgzDBZAM/oZB4YElfzcY=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 82a6b59325fd5af9;
	Sat, 15 Aug 2026 14:43:19 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 15 Aug 2026 15:43:18 +0100
Message-Id: <DKPLICBIHQMP.2HPKI7JZXSUFV@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy Lutomirski"
 <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Patrick Bellasi" <derkling@google.com>, "Reiji
 Watanabe" <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED
 allocations
From: "Brendan Jackman" <brendan.jackman@linux.dev>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <anzinNUA6ZASDnvA@google.com>
In-Reply-To: <anzinNUA6ZASDnvA@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C6DBEC0004
X-Stat-Signature: szefb6p11fergyz1fbg1emwma84io4sg
X-Rspam-User: 
X-HE-Tag: 1786805012-104679
X-HE-Meta: U2FsdGVkX19lttTFsNqSclbMvqPRFwe4G7etjS+GMehS+rFYlSFkU6M64epFeFo2HWXDAJcVoETBNbULs5YE0BGuXT8hCxwcb4PvFo0bYMVnSI874AUNoMNzYGNQetRc3tY/wlz/p7YTU9xh038cPFd0juZ/2QRDKylzG/4HfrAS6NCgFfUkE+iYB6QVqkFdhRbl5qk7MOXUkbx+TqYYqIbEVQofk7BrZJ/cTwPUQxoCjFW3HpD4q/IpdeVB4uePZs5yXOhRaAa73Li4pyHky3i100eNW39u9DRIdSEWXDAWCJW3r4YPlvoEC+2xg8kb6Uxu5glcmp7j395zDicyodUoUHnBV5kiy8y8/OQqakXxC/tvRAvjCZ+FuxGkbWV2w9T3DJyYUuaJc/qzmKnvZm7XJrE4Htgs/mIg0aPR003KdHi347czBlyeA99s3JpP26wRaakbIiZS9PIb1Oqu+i+OkhgwYdXp+B74s242i7AlGfXJoSyrYDM5zJM5NeN674XR6WIGb5oBvHHv+tilKkEv9nRNqyhIPREhxwfjV2UwMNm8UqzJMFMFmwWeJTf8DIRRt/21M89OWnjs7ThNz+Xez5BKwjrospIGKDiLvnyyo4ZE8w93HqU/flwjMfF7NY5ZTaJ0C8rBvquvYy++qLB3+0THjChJM+U64+u0fQYeMp2ETioPWuCQK+Ud2PmlBdOe9sb8rioBL0Y5evBKD8vugN8F8fgsnGmSC+ZJVizKnQI4pgTVPBwsId+GQJQCAurPmGRFsY22YvJfdJqkgoFcozpB/m1dUQ+umgIP7q5FX+COlQotM1s8w2m96mcygwhUtXys7r/749rjYewKBjPqQKsDar0qnAAAxlDWe0dVZIzYze0fY+/dgBMlJLtEkXbKCLa6EIN/xZstXRaGLsNHFaXLrt6EYBvZk3f401ksST3vCy5vO0062WWvEHSeGcvfmSgphfuvSt2oKBQ
 DR8QtTce
 LrtYv3DjqaPCp1zVIcxw5VE39nrKk0BK/2SyFy9zqG2l2Fj2X943SpVlBZXxMUW88NRfx0gVeivA/ItpK1aKW6Xqm4ImXs6G3cqc1KCAScy60cgnF51dkqiWVGXQViS02IrzXDjgXbZTf7WuwUQ1gjRPimYqpaj+R1PV4clxWTElPEgjpkQCmSREzpokzkelVjMW0XiGhJR9E+IW3bWprH9Gez2nQlFNjm4ll8LDwnTbgPUsUG2S0owOCwryajjy0DALux0xSdGk7GxkkfEk1BkV8QZfq7KGmKNmm5YGcsbm6pFgRGIklvn8ZqGDuUd+rKVodh5s7vvNZm6fdH4205Wt5JAH4ARL9NIP8s56vhbX2P9Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 12, 2026 at 10:26 PM BST, Yosry Ahmed wrote:
> [..]
>>  static __always_inline
>>  struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zo=
ne,
>>  			   unsigned int order, unsigned int alloc_flags,
>> @@ -3433,13 +3580,15 @@ struct page *rmqueue_buddy(struct zone *preferre=
d_zone, struct zone *zone,
>>  			 */
>>  			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
>>  				page =3D __rmqueue_smallest(zone, order, ft_high);
>> -
>> -			if (!page) {
>> -				spin_unlock_irqrestore(&zone->lock, flags);
>> -				return NULL;
>> -			}
>>  		}
>>  		spin_unlock_irqrestore(&zone->lock, flags);
>> +
>> +		/* Try changing direct map, now we've released the zone lock */
>> +		if (!page)
>> +			page =3D __rmqueue_direct_map(zone, order, alloc_flags, freetype);
>
> Is it intentional that this is called outside __rmqueue() and doesn't
> cover pcplists refills through rmqueue_bulk()?
>
> IIUC, we will never change a pageblock to unmapped to refill the
> pcplists, so the unmapped pcplists can get filled in two ways:
> (a) When unmapped pages are freed.
> (b) When a pageblock is converted here (in rmqueue_buddy()), if the
>     allocation only consumes part of it, the new allocation might move
>     the rest into the pcplist through rmqueue_bulk().
>
> Does this mean that unmapped pcplists are less effective in serving
> allocations? There is a tradeoff here because converting a pageblock to
> unmapped is expensive, so maybe this is the right choice to make, I am
> just wondering if this was intentional and/or if we tried it a different
> way.

Yeah I think this is all aligned with how I envisaged this working. I
have been assuming that changing pageblocks only happens:

1. When botting / changing between different kinds of workload.

2. When the system is quite distressed by memory pressure.

I think in both cases, proactively flipping a block just to refill
pcplists is unhelpful?

> Actuall, THPs are not covered by scenario (b) above if the pageblock
> size is the same as THP size, as the converted THPs are always consumed
> by the allocation, so the THP pcplist will only be filled when THPs are
> freed.
>
> I wonder if this would cause a problem for THP-heavy workloads (e.g.
> guest_memfd using THP, or any THP usage with ASI).

And again it doesn't feel right to proactively flip a block just to
create a pcplist. The cost of a pcplist miss is basically a bit of
cacheline contention while the cost of flipping a block is pretty high,
it seems well worth risking the former to avoid the latter.

> The other thing (that I probably mentioned elsewhere) is that kcompactd
> does not produce unmapped pageblocks, so it seems like THP allocations
> will mostly hit this code path and convert a pageblock to unmapped.

Yeah, I think making kcompactd produce unmapped blocks is a nice
standalone optimisation series and it can probably wait until someone
has a workload they can share the performance improvements from.

> Actually, if we do bulk conversion to unmapped (e.g. in kcompactd) we
> could batch the TLB shootdowns as well, but that should probably be done
> separately.

Oh, that's a good point though, coz that would also interact nicely with
pcplists. In theory we could allocate several contiguous pageblocks,
flip them with a single amortised flush, and then use that to refill
pcplists. But yeah this still feels like far future optimisations if and
when we actually knew it helped.

>> +		if (!page)
>> +			return NULL;
>> +
>>  	} while (check_new_pages(page, order));
>> =20
>>  	/*


