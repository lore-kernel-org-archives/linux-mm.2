Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7256EC5CFDB
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 12:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652636B0307; Fri, 14 Aug 2026 08:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6298E6B0309; Fri, 14 Aug 2026 08:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5667A6B030A; Fri, 14 Aug 2026 08:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 301896B0307
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:09:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41B3B4043B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:09:52 +0000 (UTC)
X-FDA: 85099756224.04.3CE2E36
Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 11386100003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:09:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ptHTw+YS;
	spf=pass (imf05.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786709390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=76UPMa7baaJ7P+aXXdYGiDzJRHi1+SMVoe264fro9N8=;
	b=ouH6f6rKYBPzU1ozKjyIEcqNgbXfuaoLp1AwKimTP5CX9wAA3nWMRDkD41YPcGuqLiMh/7
	p/ITf1YOGxaJF2dUUzKVhGRgR9x1pPMVBysMzMFjSndXShRITmVchDYCGV8UWjT05pHD/B
	dF7M7h7KvvWAj/C0B9deOhZHKwCyLwk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786709390;
	b=EsVSPHBtoR80kXdReKEJ2ONv8xYBZmUqV1qgrIgm+YP5X4gGFxn8WNyfJyB5vQbn51S6Xo
	1KUQkCfsvCPg6l+ZaYpqrYHvcRed5kSRsXkBkhh4pjo8HSdSFrBTzPYm3BHb8oZOVFZBCm
	X3szC4k1nRodtPH0/nA425uz9OVqlPE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ptHTw+YS;
	spf=pass (imf05.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hjVyQXbDj5Sk0+7EhKmuSQsftrJICNy87t57EcrUebA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786709388; v=1; x=1787314188;
 b=ptHTw+YS+g8wqyK+eLjVm/DgqjvGjtVkC8UvMMSfhy/kNfIuFB+G/yU3n3PwbFflmqLga7xO
 I569fvo9LdpsZqohURqB1EjtaHdatmVbdNar7qVXYs7iI+LRSnrSi3XC7YMq31HRYNQBwJQQm9/
 lZoc1I9+DGMrAfKywjp/xXfI=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 1cf48439c3244aa3;
	Fri, 14 Aug 2026 12:09:38 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Aug 2026 13:09:32 +0100
Message-Id: <DKONM2LHEP8I.1PW06S1B3CDC7@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Wei Xu"
 <weixugc@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, "Lorenzo Stoakes" <ljs@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <x86@kernel.org>, "Sumit Garg"
 <sumit.garg@oss.qualcomm.com>, "Will Deacon" <will@kernel.org>,
 <rientjes@google.com>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Patrick
 Bellasi" <derkling@google.com>, "Reiji Watanabe" <reijiw@google.com>, "Sean
 Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 19/26] mm/page_alloc: rename ALLOC_NON_BLOCK back to
 _HARDER
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-19-6f5729aa9832@google.com>
 <ee8df643-91dc-4a38-a676-486a0d52c919@kernel.org>
 <anJc8Ansf-QWFfFo@google.com>
In-Reply-To: <anJc8Ansf-QWFfFo@google.com>
X-Rspam-User: 
X-Stat-Signature: srn73g35z6w6xwraoo84qh1xmkm9xs6z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 11386100003
X-HE-Tag: 1786709389-798298
X-HE-Meta: U2FsdGVkX1+iIBhvpNYeyriWwVFHSjGR/Tez7tqRJ3YmKcxYvOWmuodRZrAUJwaSSxNazZiWX48kn8iDla4rz8jhf2703w/sZHx/hTeTcTGJv2QEAah1/OkERdBby/zaAhstaHhuM6GVLYFjOH3L/9Qz6aQzQpDiDwBPwxz6at8fHDvUm2AxYjF1z0gzjMAXY15vm5ofAV/eRrx4hceRd0alPehslHLXq7UuFN7CViA3HnZDqfVVyzUYER9xbraQs0QtrSd9ILoj8z6jepe0EG/86m4tzfYP5CT+cNjLGjBU+cX7p83UUGXYKrBa5X8dDNHjG/x+HH87WxFtQCszKvK1yipQyfayq5Toy/TslDF7xAOT08o1mQUoSkveAy1MOsyCnz2bSQX2dFCd4xhRHiEdYMgY4t7t6DqMHN25p9Uc4MY3KnegKutU5Vr7X24fk5JnobJkfC4QHfnQpHeB80hxA8yATdAEPJiSKcOTidjS+Z5O4SyXh2sYxLraBHgKyD+X+fHwEACHnU/TJO672rQJrPpmTFjQi2AO+gPD5XiFjuF/rMfVG61nHrv29JIekRqqu1bLtYnYh2fsMeLAwENvuwy1qFFr8S+rMhBY3OUakWAo1W8+Cn4OwNwFD4IP1ghVnsW3xP5UAKwH8on6YUYGecpofQ7o6y/eweaXgxtAHamEfaMir0HfYJ0br1qWup/9MSxv5G7UcNBwWymuR7o83vF/KXRCbwMQvvU+dgNITvKw2rJPIBu5KSU9ad5ooOkghyHADUFtzncOfFq4t1diKbdn4T1B9bGKUhxYk6ZXqDmyx6OlY0JP41MyR2P4rQj8uQuoL2VkYK+kt4IDettfW4TDVXnyzlHZOILyz+PX4sETaXKNVJazZNYDXKYBRJpVFsdE2/BIfF14NMTF5ZqKGlfKxkdbFP9VUbAT2qk/KPANlwTt0+NFPvQk255grEqboduFAFz+VomsHh8
 7174t2M7
 hYOY61jC5tWLuYe15y5p/TmhosVhdizrOXuAy5CYIbB2H+0h2jUanSGBQyXv1/af6gjlsyl8jTCjUsYD1TLOUqbwL+v+X9ZH+/Oi2zTNOqEW10F3wSSUYTFOx+s4XLUKKxzCSH1VvCOyRVIs4PwK2KwMkElqXlWejYec+FzUEbQqPaT1eZ+JDQiZr0MMM6VD3cno2IYjSIPhmkB+Cg3w7AmpndveDjm8THAjOq3tNcQgKncK67sKtV8p1/KNtadZZBDo3iLapxRVyhsCXS6e0gMfyIl2meTiHJiks+acKfDLN4XAxW+keGcjIMf+vccVW6uHyKELnfGLjJ2603cTKaoY7Slg5IHBdy+vzfkZ0aGbMjs7hNs6TDYgp1gwXkxzi7G0C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 4, 2026 at 10:50 PM BST, Yosry Ahmed wrote:
> On Fri, Jul 31, 2026 at 04:52:59PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 7/27/26 00:22, Brendan Jackman wrote:
>> > Commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
>> > non-blocking allocations accesses reserves") renamed ALLOC_HARDER to
>> > ALLOC_NON_BLOCK because the former is "a vague description".
>> >=20
>> > However, vagueness is accurate here, this is a vague flag. It is not s=
et
>> > for __GFP_NOMEMALLOC. It doesn't really mean "allocate without blockin=
g"
>> > but rather "allow dipping into atomic reserves, _because_ of the need
>> > not to block".
>> >=20
>> > A later commit will need an alloc flag that really means "don't block
>> > here", so go back to the flag's old name and update the commentary
>> > to try and give it a slightly clearer meaning.
>> >=20
>> > Signed-off-by: Brendan Jackman <jackmanb@google.com>

Writing this to get it clear in my head, so I'll also dump it in the
mail in case it helps get us on the same page...=20

What we actually want here is a flag that tells us when we can do a TLB
shootdown. That means (on x86) that IRQs must be on and we mustn't be
holding some random spinlock (most spinlocks would actually be fine but
I think it's simpler to assume we can't hold any).=20

It must never be over-permissive i.e. tell us we can do a TLB flush
when we can't. It's fine to _sometimes_ be over-restrictive i.e. tell us
we can't do a TLB flush when we can, but if it always forbids flushing
while GFP_BOOT_MASK is in effect then we'll fail critical allocations
and crash.

>> I wonder if we need to do this, and instead we could repurpose
>> ALLOC_NON_BLOCK directly. AFAIU it's about removing the side-effect of
>> gfp_allowed_mask in the next patch. But what would happen if we did that
>> using the existing ALLOC_NON_BLOCK (or maybe just renamed to ALLOC_NOBLO=
CK?).
>>
>> - in __zone_watermark_ok(), ALLOC_NON_BLOCK could now be *not* set in
>> situations where previously it was set due to gfp_allowed_mask masking o=
ut
>> __GFP_DIRECT_RECLAIM.=20

Hm, I can't follow this. The first paragraph sounds like you're
proposing that we set ALLOC_NON_BLOCk regardless of gfp_allowed_mask. I
think that would be fine. But then the second paragraph is saying
ALLOC_NON_BLOCK would now be unset in places where it's formerly set,
whereas I think the proposal means it gets set in places it was formerly
unset.

>> But it only has an effect on top of __GFP_HIGH (thus
>> ALLOC_MIN_RESERVE... which seems contradicting the ALLOC_NON_BLOCK
>> description comment btw). Also __GFP_DIRECT_RECLAIM is only masked out b=
y
>> GFP_BOOT_MASK when all memory is free, so it's kinda moot?

... but yes, I do think making the existing ALLOC_NON_BLOCK ignore
gfp_allowed_mask would probably work.

Aside from gfp_allowed_mask the other thing about ALLOC_NON_BLOCK is
that it gets disabled if __GFP_NOMEMALLOC is set. That is fine for the
current usecase, but it's pretty confusing...

>> - in rmqueue_buddy() we allow access to highatomic reserves since
>> 281dd25c1a018. That commit describes GFP_ATOMIC so we could have been
>> checking ALLOC_MIN_RESERVE. But we can also leave this alone because it
>> doesn't actually matter when GFP_BOOT_MASK is set, as above.
>
> IIUC we are trying to find out if the callers either has interrupts
> disabled or is holding a lock, and using __GFP_DIRECT_RECLAIM as an
> indicator. As you mention, it seems like __GFP_DIRECT_RECLAIM is only
> masked during boot, presumably before we can allocate any unmapped
> memory (should always be user memory?).

Exactly.

> So maybe we should just use gfpflags_allow_blocking()?

Oh yeah, it definitely should. This doesn't change any of the plumbing
challenges though since we've lost the GFP flags by the time we get to
__rmqueue_direct_map().

> I also wonder if restricing to callers __GFP_DIRECT_RECLAIM is too
> restrictive,=20

It is overly restrictive, but I dont' know of anything better, and if it
existed I think it would be in gfpflags_allow_blocking().

> we can probably key off __GFP_ATOMIC as I assume any
> callers with IRQs disabled or wiht a lock have to set it.

There's no such thing as __GFP_ATOMIC. (I think there used to be?)

> Maybe we can also use preemptible(), but that creates a dependency on
> CONFIG_PREEMPT_COUNT as far as I can tell.

Yeah. Which...  maybe is fine nowadays? Since commit 7dadeaa6e851
("sched: Further restrict the preemption modes") you can only set
PREEMPT_NONE on alpha/hexagon/m68k. And this restriction only actually
matters on x86 anyway...

