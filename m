Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F194CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 02:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21CD46B0088; Wed, 17 Jun 2026 22:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CDB76B008A; Wed, 17 Jun 2026 22:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095DD6B008C; Wed, 17 Jun 2026 22:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D07716B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:23:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D6D81C1FDA
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:23:59 +0000 (UTC)
X-FDA: 84891438198.16.6ED6028
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 94737140003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:23:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="O3UfvT/1";
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781749437;
	b=1XbcBp++BYGlOdDYjNGqyX9CoewKn5PJJLFbJ7qbwO9Xzr75hWvxnWLU8L9PfU0ELXCyIE
	P4IbdiMJDgDEQQzH6nH/yyCBO0krns45DNsPYP6sXmWqgGR/SOJHXi08JfRXPwA+viQZY2
	JQBC84i/LS4xQVIbziTuFJxkibWL1Ek=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="O3UfvT/1";
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781749437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PfUm8af/m5Y+JvEu5zk0BWRI+9j/PXO2lmh/Wz0+tsw=;
	b=Pam8jivspIkuhZ7OvEju3L3zEbpC4o34W9HPibKvBwAEXAonI6O18dUSf0WNmGQNvB+20q
	Y45kXrvzObQrXyH5nSLJsE/m1JO0ehKhXXfqODDrLSBUMMqkPP7x+SWuoc1AJaqU9Yrfzm
	/oWQras0niKjj0bFrUr7Z3X2Na/HORc=
Message-ID: <45fcc57a-ec8d-46d6-9c28-065d001c081f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781749433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PfUm8af/m5Y+JvEu5zk0BWRI+9j/PXO2lmh/Wz0+tsw=;
	b=O3UfvT/1MKiXtNvGidZMkfJ5JuNdkyR8S+zPPWv9pS9CANHCtAc95ka7/DKnM/iGfcbWVb
	Ftrei5j/5KT11Bnfcu/K0q/mftP6aEgB40P687LESlZvdqrqD6vOCwMqayeuc19JuU2S7s
	mOQKdiH/a8oeTVe0QRkhZDezTFs9iMU=
Date: Thu, 18 Jun 2026 10:22:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
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
 Alexei Starovoitov <ast@kernel.org>, "Harry Yoo (Oracle)"
 <harry@kernel.org>, Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
 <2399b3ad-4eac-4a14-94c3-27e9f07972a1@kernel.org>
 <CAJuCfpG48TmvaiaRvnL-NXKU6nn55D3bks2DgzAc0URsZhAxqA@mail.gmail.com>
 <DJBHRVM65A11.1OL2M9MXN56H@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <DJBHRVM65A11.1OL2M9MXN56H@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 94737140003
X-Stat-Signature: t8h316cx6yzp8shzopubjx3zi4rwxyou
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781749435-929165
X-HE-Meta: U2FsdGVkX1/p4bdsUmBgsiL/h7G66YmJlN02wsfzx5cBEQbkqtGqc22m669fzCXMEidvZmP8/2VpUUBEyuywl4z0XWYMFGUa04czCe3Myh/TWtjCx7Y3HSIpC1bF9e1qTjAESvqwfBkmujDgGPG2mGJgKmY8bBJS3UIP1wapW4/us77wN6oVPpp3I0p+Ig2aniUvzNV89C6YT5NqaZ75yFpENxHFw0K3pLnTOKcgs+FTK9M3vCPIWbfs+oD64v7lNhyjGsaSGwmVYv6GqvsuZyP3g6WAYCevltdYojYYCve3T13Q4Fz8x46TOw2z+mTAvXAhAgZ1Lyvxn+xSW+brT6lh34l9R8JSTQPTzcGWABv1V3zTlxrXaDChkSKZTRQJ6R/eGFA+aK+VcfJAS+K/ZnVchtmSDiGLphBdNPIyOo8xyqNFp7NzioXY7OqfRE+IOJdh8qZniYByZmt0BoyTDPxB2ZdZc5f46/SGY5X9X8q2rV5hiLkzu6fwHev9KEh03Ue0U8KhOI+iLSoigFDY4MUdwyUXGEwCdXfOeRR6dBTpEJB50g/C/euV6VzpEonzs+hFmZqGMyhvEx7CNhGlpHRYjaiD9FowNsCDqlEe26AkKBkPdtfyMkGTyrpsJvSST/DS/QljRQIFJt9HwUtRID05gT1bcFF/UKRr5hvHhxEkO3lozsMPWw5v9hv6/1s1bsegnQHUq0SBw7YCcbPuaCBG2hk/+f+Jt+Ms8lQH6RGhQ0VUI2WcdZ6nEzdRd5VYOdjXXmU41t1hMKkT7IGJaOgXsEJtAT0U6mfq4c5eLs+G+dmkCBwhKMRWKONCLjwHnNF+4o29KzqFmZuWmZfcf/82tL9ta6sL0U2i6Cm9WBjGrMGo/Ftx5cikSn0WnOPnh83vL7kseTylt5Kx23wYd7F4Z3peZ145hzcpgrzZYWQvxwq+SNdOuGJFCS/doy1x+ZqtcwwU18U5F8QzMMg
 uzvlmCid
 LzN4YYYd0bdGUuuupAeez8jt19sSVTiq/UX00iozQxO/jVnrP97jtrE5zlKpGj1BwUkHHjuQ6AwR3o+bnHIPyWMnpPSOvC8p2dz8zJj/TzhWYAL86he2/3JwKNZPKATuJx4+PWTapQpsHruwu1DwYayf6xKQl+sGInd9rV6HG2ql6wg3zGX4WmWUq6T8Pvmn5q9biupGnsDs2WAWS55Jb1DprfnYSp/sKX0ca3c0rl8xOLEKFEZDuR8kVkI5Z3v0UvxcoLcVG3ug0Gx/Kz70NWQR0pHybMgSKltkhozrrEARocD7tCagf6Fj5pCqbTxTOaYdzSC7KOPPsUUe297Sa+fZwh5n0uXFfaqiinIc7YZu3/8n1qcabMwgYrsqF3nSxMkPTRHwpteE65Gvf6Lt4UrEw3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/6/18 01:14, Brendan Jackman wrote:
> On Wed Jun 17, 2026 at 4:49 PM UTC, Suren Baghdasaryan wrote:
>> On Wed, Jun 17, 2026 at 9:39 AM Vlastimil Babka (SUSE)
>> <vbabka@kernel.org> wrote:
>>> +Cc Alexei
>>>
>>> On 6/17/26 17:29, Brendan Jackman wrote:
>>>> Currently the core allocator code is controlled by ALLOC_NOLOCK, but the
>>> It's not, it's ALLOC_TRYLOCK! Thanks for proving that we need to rename it
>>> to ALLOC_NOLOCK:
>>>
>>> https://lore.kernel.org/all/DJ9QPTO2WXNB.10E88ZHWRDHB0@gmail.com/
>>>
>>> So you just won the job to do the rename :) I think it should be done before
>>> this patch, so that the new usages and other _trylock names introduced here
>>> can be done as _nolock outright.
> Ack. I'll aim to send that tomorrow once Sashiko has caught up.
>
>>>> main entry point function is significantly different from the normal
>>>> __alloc_frozen_pages_nolock(), this is tiring when reading the code.
>>>>
>>>> Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
>>>> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is only
>>>> exposed to mm/) and then turn the nolock variant into a thin wrapper
>>>> that just sets that flag (as well as handling NUMA_NO_NODE, similar to
>>>> how some of the wrappers in gfp.h do).
>>>>
>>>> Rationale that this doesn't change anything:
>>>>
>>>> 1. Simple bits: A bunch of the nolock-specific handling is just moved to
>>>>     the new alloc_order_allowed(), alloc_trylock_allowed() and
>>>>     gfp_trylock.
>>>>
>>>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>>>>     previously in the nolock variant:
>>>>
>>>>     a. Application of gfp_allowed_mask; this only affects early boot, and
>>>>        only flags that affect the slowpath get changed here.
>>>>
>>>>     b. Application of current_gfp_context() - also only affects the
>>>>        slowpath
>>>>
>>>> 3. The slowpath itself: this is now just explicitly skipped under
>>>>     !ALLOC_TRYLOCK.
>>> I'll have to ponder it more closely.
>>>
>>>> Ulterior motive: adding an alloc_flags arg to the allocator's
>>>> mm-internal entrypoint can later be used to do more allocation
>>>> customisation without needing to create new GFP flags.
>>> Ack.
>> I think this change might also help us in removing __GFP_NO_CODETAG
> Nice, this actually looks trivial? I can probably just tack it onto the
> v2 for this patch/series.
>
>> introduced in [1] and being the only user of __GFP_NO_OBJ_EXT once
>> Vlastimil's patchset removing other __GFP_NO_OBJ_EXT users lands.
>> CC'ing Hao as he is brainstorming ways to remove __GFP_NO_CODETAG, and
>> this might be the answer.


Hi Brendan, Suren,

Thanks for CC'ing me, Suren. This is indeed a viable approach

and I believe it brings us one step closer to removing

__GFP_NO_CODETAG entirely.


Brendan, I'd actually put together a rough local implementation

earlier with mostly the same core idea as yours, and this change

would indeed be minimal based on your patch.

Thanks a lot for being interested in tacking this into your v2 patch series.


Thanks

Best Regards

Hao


>>> Besides the need to ponder unintended effects, mostly LGTM. Just not a fan
>>> of the hardcoded '0' passed at various places. In the slab variant of this
>>> (the thread I've linked above) I went with SLAB_ALLOC_DEFAULT, so you can do
>>> e.g. ALLOC_DEFAULT here?
> Yup ALLOC_DEFAULT sounds fine to me.
>
> Thanks for the reviews as always.

