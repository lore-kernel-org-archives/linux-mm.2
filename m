Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D654606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eJr3DKqJ
Received: by kanga.kvack.org (Postfix)
	id 67DB06B05B5; Wed,  4 Nov 2026 04:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608CE6B05BC; Wed,  4 Nov 2026 04:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0BD6B05C2; Wed,  4 Nov 2026 04:24:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA646B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:24:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB06512064F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:24:31 +0000 (UTC)
X-FDA: 85396901142.02.FAC52CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 27DBB20003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:24:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eJr3DKqJ;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784270;
	b=DggLPbVyX5dwiDkAg7y0gR+Snc1ewabri/iECrKNP4rGEEAW692v/Envw61ddC051xA/oP
	PyRrhgk57HPYJETuSdZRWWsr4CQma+p5McVqj7ik3IxN+zVxCtriEchxO2mO80QxuEsyO9
	VImeyRi9eRXLsAypR4ENRxSXTT0MSJM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eJr3DKqJ;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W74eU1IM1bdOgq49kFD3NW38F3uMSzpXAuObYdVLCfc=;
	b=u08T7S0mg63+avLeU0RXCFaFAfOk+j+C2TtcsLg99obqbLG4hWzSZp1rHf9Plu9ZiYdCoJ
	RWO0rbhuBM3ZOo2AMv5aAgKc8GebK+157aNTaDECJlJcXc2iH1Wz3e0uB9XwKKtkvFxy8S
	ZCOxYhrbHsWYhKI3qvbmU2iHFG/iCeo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A6A9400E9;
	Wed,  4 Nov 2026 09:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD8E1F000C1;
	Wed,  4 Nov 2026 09:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784269;
	bh=W74eU1IM1bdOgq49kFD3NW38F3uMSzpXAuObYdVLCfc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eJr3DKqJrhbx0YqNDJ+clNMUgF9C7b7x0qUdDIjRgH304POz6YAL7D78pq8eqAWlo
	 iZPki2kDG+5d4hzx5sZl1maQOlB0nxP0PkSmvdqzTqkmUeHc68nGe8292JfeCDVAJJ
	 JMjTqwz7c9/Pf4/PlsoSdaMMHhUMlRpULrQl+JJSYmboYzksDb7Y8In67oNx0MA8Eb
	 GCVlNuak48odSzQWQzwBhb9g+lBOYZBfY4ICDRNQOOJzdNRah3IOvFT9pTpMsJrzt1
	 /SxzYBjwILsoTLhs9c2Dipv4iM8prSpaovL4GzdWfSedhqK58PkocGbEEZ3qZkQ3+v
	 TSNm1wZrl8OfA==
Message-ID: <15b9dc96-d3eb-4ce7-8db0-589c2798ed41@kernel.org>
Date: Wed, 4 Nov 2026 10:24:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory: use pmdp_get_lockless() for the pmd read in
 do_fault_around()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <20261103014749.96764-1-hui.zhu@linux.dev>
 <aumfvNWiemmuyooP@gremlin> <61f8a583-5ea5-4fcc-bf30-ea9cafe94d65@kernel.org>
 <auoXIdTpLO60mkEw@gremlin> <c0e648e2-aa1f-40f3-84f4-c4ca4123de9f@kernel.org>
 <aupAdlzeOtc0qSsQ@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aupAdlzeOtc0qSsQ@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27DBB20003
X-Stat-Signature: 6nne539hbkp94pyopjkiuniqbjumqbxj
X-Rspam-User: 
X-HE-Tag: 1793784271-363653
X-HE-Meta: U2FsdGVkX19cYFeVOsRnwJqeQgVmyjI8J39AEmI3BSPwgD8fCXmawVeczs92aip0MAbmu76S0U+7/bRP7Idr9a83g8sd9e3J5h+zb22kj1pYkX0Onr917f4Ax0xwh2o843o8Vip4TzAFFjOYLKMvfXSF6h/eWNLDcDo3YInWsUM/u86z9gG41MnsG8VkR7UZbmSDc6NU83Kfmcg4PAaRkk9z7itUw/LfNbJDnQKkJZCjqiHz4HS0psDoLAPRZp80KrjHyYsHGlsCmroFzjV/kZ+TOjTQbuw3BHL5yOJQ5yC/2EdheSH4Y08ExURf0YgO+gYetNCmNF+dQ5chTk9If28XVVp/Sif6FE+ZHHSmKtjv7j5WeS/6aHVpuq9vorPNdMm7E+nlCyxSfk11JGOSwWOlHZ+I8aD1Xnyt9sRQSMQsZvB8+72FxxTpfk4YO3hKlLhK+13k6BQacO28zZjHtxB2d6yQ/bw/hzOAU+P5C4AQHca8vi9h1xfFxlzl7VRXNllTonDf0koirPXfmBqhp1VfmAdfCY7nau2uv651JjLvF+gklOqO4qJubFnNXPyN/+1XLZGxvTPrcrlwUbduujsyT89aexF58rvMPIatay5GT/gCh38/3SYLwrdc9lcF2EnYXWifuQIPAFT0J6u70w4lRhvyklrepHB03Nntsn0hBQK8HRAin5hpUs3aa0Jb435cPHWL7k4ZxA8xvW2bafY87yMka7w6JAaVDdUg+Kvw9ZgATUis/AAdyuYtQjVCu7Ldxokkd4qjx92Z72tJXiI53W9vJ4KoqzyXq//cxsvgiQdJXvwauWlT5Wq+WLuGlDAOcXYTLItttXTKGnM0jdC23Nwto/kF9sYWS31o0itN6O2dYm+pdZS/CFpchNxS8ePPnJXkQnu9lS43Y12oqEbbrrYyU+fFD6HOL2S0aW8gcwSE17y7VTJ+M/L/wjld5VtBH0KhLuCm4cCgnPT
 wZXKmDg+
 f37vo5fsuxS0ufoOWz8iAUhzrlkQy4GeOE4p+zdpKp6fmkyBAd4HKSyuaWaCeVukC6gt9iRHVv416xiweTYr9gm64/9oUOOgZUS6x02rr+MHZECX72KICRUne6S9g9Cclzv57PcvOTrG3QhtIxi+blQfUdwHZ/uJtzEIl1Tp0PTklZoTdeUML1bXI+QlcJ8IygckZoycK5t/Ag+N3G+D2Xi+0+RDmjhpmuCG9hpJwdeK9ldD+1QqQHO9S0cTC5yRlu+h+4iwKoBLl9MA3S4kW1CthF7RwrEBSqYZJwWkjiqG7XMde02qhy64eCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 21:27, Lorenzo Stoakes (ARM) wrote:
> On Tue, Nov 03, 2026 at 08:51:38PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/3/26 19:24, Lorenzo Stoakes (ARM) wrote:
>>> It turns out we're as wildly inconsistent on pmdp_get_lockless() as we are on
>>> pmdp_get(), so TL;DR my main concern is moot so:
>>
>> Yeah, I know that we use it in some core places already properly, like in
>> GUP-fast, __handle_mm_fault() or our complicated __pte_offset_map().
> 
> Yup, but also inconsistently, basically mostly interchangeably with
> pmdp_get(). Rarely is this value actually used.
> 
>>> * But it turns out it's all a giant mess (of course)... for
>>>   CONFIG_GUP_GET_PXX_LOW_HIGH arches you really actually need to also do:
>>>
>>> pmdp_get_lockless_start();
>>> pmd = pmdp_get_lockless(...);
>>> pmdp_get_lockless_end();
>>>
>>> And that's because, as Hugh points out in commit 146b42e07494 ("mm/pgtable: add
>>> PAE safety to __pte_offset_map()")), you need IRQs disabled for these arches for
>>> it to be safe.
>>
>> Yes, there is this pmdp_get_lockless_start() magic ....
> 
> One of those things that, the more you look into it, the more stuff you find...
> 
>> It's really a mess. I wonder if we can remove that somehow completely ...
>>
>> arch/mips/Kconfig:      select GUP_GET_PXX_LOW_HIGH if CPU_MIPS32 &&
>> PHYS_ADDR_T_64BIT
>> arch/sh/Kconfig:        select GUP_GET_PXX_LOW_HIGH if X2TLB
>> arch/x86/Kconfig:       select GUP_GET_PXX_LOW_HIGH             if X86_PAE
> 
> Yeah that'd be ideal.
> 
> But actually could we not just simplify and allow these arches to be a little
> bit slower (who cares for museum pieces)?
> 
> The only user of the start/end magic is __pte_offset_map(). And it does:
> 
> 	irqflags = pmdp_get_lockless_start();
> 	pmdval = pmdp_get_lockless(pmd);
> 	pmdp_get_lockless_end(irqflags);
> 
> So that could just get folded into pmdp_get_lockless() for these arches.
> 
> That would mean the places that don't require IRQs to be disabled (optimstic
> checks) would now be needlessly enabling/disabling, but hey - use a system that
> doesn't live in a museum :)

It would be interesting to know the performance impact. IOW, whether this is
just a slight slowdown or whether it makes these installations unusable.

It looks like an interesting thing.

> 
> That way we could safely convert every non-PMD lock holding caller to
> pmdp_get_lockless() without needing another pmdp_get*() variant + fix confusion
> about whether the start/end magic is required.
> 
> And this would work even in places where the IRQs are already disabled as it's
> fine with nesting.
> 
> So you'd just update thusly:
> 
> static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
> {
> 	pmd_t pmd;
> +	unsigned long flags;
> 
> +	local_irq_save(flags);
> 	do {
> 		pmd.pmd_low = pmdp->pmd_low;
> 		smp_rmb();
> 		pmd.pmd_high = pmdp->pmd_high;
> 		smp_rmb();
> 	} while (unlikely(pmd.pmd_low != pmdp->pmd_low));
> -
> +	local_irq_restore(flags);
> 	return pmd;
> }
> 
> ...
> 
> pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
> {
> -	unsigned long irqflags;
> 	pmd_t pmdval;
> 
> 	rcu_read_lock();
> -	irqflags = pmdp_get_lockless_start();
> 	pmdval = pmdp_get_lockless(pmd);
> -	pmdp_get_lockless_end(irqflags);
> 
> 	...
> }
> 
> What do you think?

Sounds reasonable. I guess we should be able to disable IRQs on all callsites.


I am quite surprised that x86 shouldn't have an instruction to read/write PTEs
atomically.

I think if we require MMX we could just do atomic read+write, and let x86
implement pmdp_get_lockless() / pmdp_get() itself. But MMX seems to be a bit
younger than PAE. Apparently there is a hacky way to read through CMPXCHG8B.

Doesn't sound like a good use of our time ... but removing that handling
entirely would be very nice.

Simplifying is nice as well.

-- 
Cheers,

David

