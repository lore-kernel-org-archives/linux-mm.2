Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56BF0C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 11:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2336B068C; Fri, 14 Aug 2026 07:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16AF46B068D; Fri, 14 Aug 2026 07:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0799B6B068E; Fri, 14 Aug 2026 07:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CFA566B068C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:23:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74C56C041B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:23:05 +0000 (UTC)
X-FDA: 85099638330.21.91CEA3F
Received: from mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 68649120005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:23:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K0D51rqp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.44 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786706583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtQggKNcI0Eo0yIs/H/WCBODzvmQh9HJyiGq6xeZKR8=;
	b=roBWbsFQA8CH3PEIQJ6jnKfqcktzCpsKa0VhprVG7mDPwcuX3DJrMbtjO3cN1/IZtoe+fH
	1uVaaSGgvH2V/6RgCf7uRh5qGKklTh6bUtoyxp6nTZPj+0wzZM99kkXoAdCA/m36U+BcAq
	7pvRQtf2PVgGuhUKm9GsgcS7fb6uA3M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K0D51rqp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.44 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786706583;
	b=SC6lu9hCAXKAv0KA7Bd/+u/1ljaMAeYMZvWFRHh/d75lfFAYeNvZGIcER5NBqZx15g5BIU
	b5Yj/8ImwSystP/qDxSXm8+3+GF7JZV2R1xzvmuhD6yD2tUPbqU9PqdfUeLlmTUg2pG5GJ
	XBtqMoviF6AUT0Lp5myDVf5jjb2N/8Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DviyH3BtVAYDhX5SLXkzdx0JgQCnoJdEeju32uvP3Y4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786706582; v=1; x=1787311382;
 b=K0D51rqp455cXsxukZsP8zt+dFhP7OlD0BdU95+eCiElu/yXmBK+Ix9HbdKUUfusTiNHrQio
 wKXq2VlzeSGCXAQ7+FdFkyHHryeDOkXEaO5l8HImo+IAc2d0+wyQuUEU7ylylrJ09alb3tEmWPL
 +UFD0+Mrz013Pmi9g/TjZRzk=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id e64bb87d811e3f35;
	Fri, 14 Aug 2026 11:22:52 +0000
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Aug 2026 12:22:46 +0100
Message-Id: <DKOMM9BKEYZ7.3IYH2D57L3NSE@linux.dev>
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
Subject: Re: [PATCH v3 16/26] mm: add definitions for allocating unmapped
 pages
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-16-6f5729aa9832@google.com>
 <anJB2jaBWwE1mSWN@google.com>
In-Reply-To: <anJB2jaBWwE1mSWN@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 68649120005
X-Rspamd-Server: rspam07
X-Stat-Signature: q58yxxk713uk5darizsctm9sx4wbyg13
X-HE-Tag: 1786706583-24195
X-HE-Meta: U2FsdGVkX19rRxmBbUA4TwlkQMiSv1TDYNffWGnwJIVOYSsBaTrYswnfmMGR4N+FRM1dADt6wkSwZkR9ZxHkBN2/wvw3OQ4BkxVCI9utHfAjtxq510aoDueisMH5UFHPgOQhhu2kDHMODtkgu+UfYmZVt9YoS5YoECFMI4ZiOK+eF2RmYK9ovETG+DfH//XAzq7lY3MZPVi2p/9l8lRxXahriBs2jUBo7fEiUZ6gfI0oyeKAleEtNdNVoqqXKvjclapanpAIyBGPG5m2+QCFxZW6Pbsn0E4qvx8bAy32keTfj3iFv8r8NcA5QfEjt2lJQPP+FVYwihp3zgPHSj+AAlETYFHMLYHG4rTB1AqHTxVyhOBmRDYKoeLti9haUN/6Ta4xaLJAE1+MHbjPjRoVvA5TM914l+2BWuWJlNze4i6T3SaPFmm8yPxwnfuhDRxJxpelvk0A6dK0oiBMB2awvenlu1zX/LJQ0sxVTduu+xZel7/oiat1TmNpQeegxz48swP9FYvI0dexN+uioFNv+VYEfi4fA4oG6t8iEg9MUeT1LjDxuxUhAoFWszjE3r2BWm1dYZlbq667dOF9aM4msnwEKM3uhxeawna5GV6xjcx0qUxtcA3ONeI7dAlsb3BDvq17XFeNLG2kwnRhc6c/LRPytWKnAQd3iIcn/R9K8dot1l1DIHykTx8Iv8szzJuLZ2PQgv9JAHL3SxJdDTQxgkJMpBBF2JfG6mQFfC2KyZ/2wrEVNhS2SsN8dXRGksLme0JH8JkbwZg2lWktz2EWzcZ7soNzkqGqaaEK4nfuKTn6MqAkAz+uMvcSl83UUF+xwu2ThitM1ugERX8F2xAty5/CmN0AvvfjTWEL9Sp0vbJ9pMJCiiXz9dwOK44zAZ1MxsBA6xpHmhr2DGPK5lGayJTFxvcFpuIXy/hYPq0GiiFH7nSmamnJU3+CIchd5L+/HKNcHf5KkVaAII7oYbA
 wElLliXV
 k9rwqKbmeN8hM8AkK9YnriiDXXVB+0bgBnebELRJB+7I49jAVqosJZ9pvmRihJ3pj06fu63YiYvjftOYGqqI+Uvc4avS2/ibWYfgQxSww37wD2pU/jx62fmsLTn9SL3GxdhjohTssmSPHPfJ28gMKqTccP3hG5Fl8LdKLxc+MagMEZAwcwZDdfExEruxyjFkn5KKoMlfb1Ktgq2pTKwqmJ5cS6JuimmG1L6dANwfbnmTw2A4rUQEtjRScVWXz6E7fxATO5+pj80f/Xv9vce1fD4awe49/rO8kKZS2y8dL0cJxAGzzbzusoemIE//L9P68m1Co93VVpXhkcng4rW/d6Cti2YWbCcmTs9OfThQw/nQYWUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 4, 2026 at 8:53 PM BST, Yosry Ahmed wrote:
> On Sun, Jul 26, 2026 at 10:22:49PM +0000, Brendan Jackman wrote:
>> Create ALLOC_UNMAPPED, which requests pages that are not present in the
>> direct map. Since this feature has a cost (e.g. more freelists), it's
>> behind a kconfig. Unlike other conditionally-defined alloc flags, it
>> doesn't fall back to being 0. This prevents building code that uses
>> ALLOC_UNMAPPED but doesn't depend on the necessary kconfig, since that
>> would lead to invisible security issues.
>>=20
>> Create a freetype flag to record that pages on the freelists with this
>> flag are unmapped. This is currently only needed for MIGRATE_UNMOVABLE
>> pages, so the freetype encoding remains trivial.
>>=20
>> Also create the corresponding pageblock flag to record the same thing.
>>=20
>> To keep patches from being too overwhelming, the actual implementation
>> is added separately, this is just types, Kconfig boilerplate, etc.
>>=20
>> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  include/linux/freetype.h | 70 ++++++++++++++++++++++++++++++++++++++++-=
-------
>>  mm/Kconfig               |  3 +++
>>  mm/page_alloc.h          | 18 +++++++++++++
>>  3 files changed, 80 insertions(+), 11 deletions(-)
>>=20
>> diff --git a/include/linux/freetype.h b/include/linux/freetype.h
>> index 3b0d44023b6a1..37e88dcccdecc 100644
>> --- a/include/linux/freetype.h
>> +++ b/include/linux/freetype.h
>> @@ -2,6 +2,7 @@
>>  #ifndef _LINUX_FREETYPE_H
>>  #define _LINUX_FREETYPE_H
>> =20
>> +#include <linux/log2.h>
>>  #include <linux/types.h>
>>  #include <linux/mmdebug.h>
>> =20
>> @@ -64,20 +65,47 @@ static inline bool migratetype_is_mergeable(int mt)
>>  	return mt < MIGRATE_PCPTYPES;
>>  }
>> =20
>> +enum {
>> +	/* Defined unconditionally as a hack to avoid a zero-width bitfield. *=
/
>> +	FREETYPE_UNMAPPED_BIT,
>> +	NUM_FREETYPE_FLAGS,
>> +};
>> +
>>  /*
>>   * A freetype is the identifier for a page freelist. This consists of a
>>   * migratetype, and other bits which encode orthogonal properties of me=
mory.
>>   */
>>  typedef struct {
>> -	int migratetype;
>> +	unsigned int migratetype : order_base_2(MIGRATE_TYPES);
>> +	unsigned int flags : NUM_FREETYPE_FLAGS;
>>  } freetype_t;
>> =20
>> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
>> +#define FREETYPE_UNMAPPED			BIT(FREETYPE_UNMAPPED_BIT)
>> +#define NUM_UNMAPPED_FREETYPES			1
>> +#else
>> +#define FREETYPE_UNMAPPED			0
>> +#define NUM_UNMAPPED_FREETYPES			0
>> +#endif
>> +
>> +#define FREETYPE_FLAGS_MASK FREETYPE_UNMAPPED
>> +
>>  /*
>>   * Return a dense linear index for freetypes that have lists in the fre=
e area.
>>   * Return -1 for other freetypes.
>>   */
>>  static inline int freetype_idx(freetype_t freetype)
>>  {
>> +	/* For FREETYPE_UNMAPPED, only MIGRATE_UNMOVABLE has an index. */
>> +	if (freetype.flags & FREETYPE_UNMAPPED) {
>> +		VM_WARN_ON_ONCE(freetype.flags & ~FREETYPE_UNMAPPED);
>
> If we move this to the beginning of the function we can drop the
> VM_WARN_ON_ONCE() below, right?

This one says "assert no flags are set that are incompatible with
FREETYPE_UNMAPPED", the one below says "assert no completely invalid
freetype flags are set". Right now those are the same thing so we
_could_ combine them, but just happenstance.

>> +		if (freetype.migratetype !=3D MIGRATE_UNMOVABLE)
>> +			return -1;
>> +		return MIGRATE_TYPES;
>> +	}
>> +	/* No other flags are supported. */
>> +	VM_WARN_ON_ONCE(freetype.flags);
>> +
>>  	return freetype.migratetype;
>>  }
>> =20
>> @@ -85,33 +113,53 @@ static inline freetype_t freetype_from_idx(unsigned=
 int idx)
>>  {
>>  	freetype_t freetype;
>> =20
>> -	freetype.migratetype =3D idx;
>
> Do we need a comment here? Something like this maybe:
>
> 	/*
> 	 * There is one freetype per migratetype, as well as one extra
> 	 * free type for unmovable unmapped pages.
> 	 */
>
>> +	if (idx =3D=3D MIGRATE_TYPES) {

Well we have basically that exact comment on the definition of
NR_FREETYPE_IDXS. Do you think we should move it here?

>
>> +		freetype.flags =3D FREETYPE_UNMAPPED;
>> +		freetype.migratetype =3D MIGRATE_UNMOVABLE;
>> +	} else {
>> +		VM_WARN_ON_ONCE(idx < 0 || idx > MIGRATE_TYPES);
>> +		freetype.flags =3D 0;
>> +		freetype.migratetype =3D idx;
>> +	}
>>  	return freetype;
>>  }
> [..]
>> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
>> index 9928aa9012588..fac8e5304bb03 100644
>> --- a/mm/page_alloc.h
>> +++ b/mm/page_alloc.h
>> @@ -56,6 +56,24 @@
>>   * alloc_tag_sub_check().
>>   */
>>  #define ALLOC_NO_CODETAG       0x1000
>> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
>> +/*
>> + * Allocate pages that aren't present in the direct map. If the caller =
changes
>> + * direct map presence, it must be restored to the previous state befor=
e freeing
>> + * the page. (This is true regardless of ALLOC_UNMAPPED).
>> + *
>> + * This uses the mermap (when __GFP_ZERO), so it's only valid to alloca=
te with
>> + * this flag where that's valid, namely from process context after the =
mermap
>> + * has been initialised for that process. This also means that the allo=
cator
>> + * leaves behind stale TLB entries in the mermap region. The caller is
>> + * responsible for ensuring they are flushed as needed.
>
> I think this is no longer true as the allocator does not use the mermap
> with __GFP_ZERO anymore?

Oops, yep thanks.

>> + *
>> + * This is currently incompatible with __GFP_MOVABLE and __GFP_RECLAIMA=
BLE, but
>> + * only because of allocator implementation details, if a usecase arise=
s this
>> + * restriction could be dropped.
>
> It would help to explain why it's incompatible with __GFP_MOVABLE and
> __GFP_RECLAIMABLE, here or in the changelog. I assume mainly because we
> only have one freetype for unmapped unmovable, but there are also some
> more interesting details like compaction needing to support copying
> unmapped pages (e.g. via the mermap)?

Yeah the latter is the reason I had in mind (also not just copying them
when they're unmapped but also being aware of when it needs to "promote"
a compaction to generate an entire block).=20

And yeah it makes sense to have that in a comment. This is a kinda "API
comment" so spiritually it doesn't really belong here but I'd probably
put it here anyway in parans just coz that's where it will actually be
seen...

