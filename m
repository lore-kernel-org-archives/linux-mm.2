Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA86CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 08:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56FBB6B0005; Wed, 10 Jun 2026 04:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5207F6B0088; Wed, 10 Jun 2026 04:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436446B008A; Wed, 10 Jun 2026 04:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 340E06B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:30:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC68440909
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:30:41 +0000 (UTC)
X-FDA: 84863331882.10.5C61F25
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 01C22180009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:30:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V5VqP0g0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781080240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UyYAKG2WDoLAbE1LWkheGa6RjXvXcPLoe7XXaMCnGK8=;
	b=v5D/+Y0Yo/wpXVsn2mCEoh7UAvISWo9W3BZCpuU4WsBB7CEThcnlkQAnXUVdy2VtsqgE2i
	pURkbZ54RHDpkc6bBfqdDwk3X9TEsMYMx04l+NfjyuonIf91t4lGCaaueDoCcnsJVdXhSA
	4twMB43mVYYJmz7PJXpWChnCVuvbL/8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V5VqP0g0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781080240;
	b=3+H77Z/d8kcL5W8/ylMwhQZkwxSyhIN8qJ0pqLqP4f5pSdYEwGV9aQqf8lxDwIcYr+aN/I
	KY5gZUf+GHkBtRvpBeR/4wmhsznmp0I0iYVqOiE/6sy63CcYd8K6ged5pS5MZZaP/edQP9
	BX5eGd07tQ7YNfIFZcDfXEgu9tPsqA4=
Message-ID: <104171fa-6a1c-43b0-a6c4-f71f54129d88@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781080237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UyYAKG2WDoLAbE1LWkheGa6RjXvXcPLoe7XXaMCnGK8=;
	b=V5VqP0g0/2QVtPLYQCSiV719xuD7bOb3CpvhN+0IMKIh/j5Y/g3qYhAVH2bW/olN69GYBR
	EJuAtb1QASKglqFL4XeS/eWvX0P+oCQWoqP2kbIJVGWzUcxp7YJYLzyTuWA//bCOuiJwNU
	3qIkjmrDd9VEF33VtktPcvQCTv2VPks=
Date: Wed, 10 Jun 2026 16:29:53 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 00/15] mm/slab: introduce alloc_flags and
 slab_alloc_context
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Usama Arif <usama.arif@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260609133534.3548059-1-usama.arif@linux.dev>
 <fe1bd73b-d956-442f-8c4f-f5f62587346e@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <fe1bd73b-d956-442f-8c4f-f5f62587346e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 01C22180009
X-Rspam-User: 
X-Stat-Signature: 5odqb91z691rmahuis5z3xwksebdmabz
X-Rspamd-Server: rspam09
X-HE-Tag: 1781080239-74694
X-HE-Meta: U2FsdGVkX1+KS8lHtTCWsHNa6dqSmd8A/3FMrmNXr+TAb+cMmhQx4hF/pgf4zzjf5D9A9aZ8sg1Ynp8U/YFlYEmy+QBkB72Mj4YBRxie6ks+CY+Q3cBO9rRLa4D/GlJCl5wD01Lt0caplH1QIF1JeC36k0jYOHmGOcLKtT6kgOkpACVMhDz/DaWSJynXiDdQBNLLN0JG/ln+8FiEi5RThrSQxTHgSIc/UgsMICgGOsK8x0A30eu8uHlh0jFE7fBjzJaASHj3WerRM/MtdZq+ZRnH1tPT6dM5ndXnpw1W2Kq2rWMTWegLqLK+8WkyvdoAx8+8/H46vSZmkFIO4Yom0Tjf/RxxMYcDIN/9vXmqKqS/nI/cz+KBjLcvAEoT/OCsp6Qk5lDIRZMlBVewlcMeME+2+e/apFALRjnCVscapZJJ/2GM0Oe9nO1VfhjQbvnCg4MIf6wlLcRmfN8nepZAWvr5VEcGO8J+YWs3yQZmkEJ5DSzCgqNJgwtR/kCjoZr1EKdgKH/GAA41gaVGiwUNr1izbXR/xSq5G+8Hc/EAjfzawMh94l3hz+6W1xmqJb/hGXCCgWbiPSfCr/noTviurWfKV2UIAQT0SnrHYvSuVqjMu6VY54JI+VGlL0KN4u9BMXc2Z6212kLoUfFLfZKtSZyEzqlLT3Qb8JNPYUY3cJnccIOjeAABFnq//gCS0XFmIl9ElnK+DBThxO2A9Sck/A0gk3YIt5RpK3UlHEPWH8Ut2NIpjbVuQ7I9UZn8G2qY9LMcoaO54Ih55ZSM8vRxBLeMkonexeMN0y9crEO7MG/lJWnbbTkeg91ZnGUZmoYX2zbPRe/ZTRHR+M2G7nVRwe3/SaHudu00AmmtkFLJQr+ylUtlUJ3RL3Lue4nhSJia4nrUkgqxlHLQdnxZQbn6v5IOybN3YvWUpnLI7401lZGJMXW6+KdiQNbNEpMabm/KZBD0BmAodoJiJl2pmlG
 ywUSNEAy
 ls5ssSBJWll0AmGLoeOyVI0VxcpCUlKTMnEbk7QwNYjJVhRmIY/qaoNSVnMyKSgG4nTYp19j+pwePNJ5GuomLMJoEKEDOYQPUXQNCo+E4e48jdmhaASIVuhw5q/bNsmXgQLw7EePIo6RvS9bvLsLOTB7SGB5rWLJtC0WaenQUaVH9xmD6nK+oxA1aNte4usHw4gjhNseudiFvNY67p4wI3Xki2xmLAd9tWUY2+0FEMU/cTQYC+HjXX2UmyAwyUGZvXl1lXxlXGfZjFrbJOD/tfBMcFbb8Xg2q+7dEh2NLCbBkW09x7/Wy2MTRHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil and Usama

On 2026/6/9 22:28, Vlastimil Babka (SUSE) wrote:
> On 6/9/26 15:35, Usama Arif wrote:
>> On Tue, 09 Jun 2026 11:17:45 +0200 "Vlastimil Babka (SUSE)"<vbabka@kernel.org>  wrote:
>>
>>> This series is based on slab/for-next. If all goes well, it would
>>> hopefully go to slab/for-next soon after the 7.2 merge window, so any
>>> other work can be based on it to avoid conflicts, as it touches a lot
>>> parts of slab.
>>>
>>> Git:https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/slab_alloc_flags
>>>
>>> The slab implementation currently relies on gfp flags to convey
>>> some context information internally:
>>>
>>> - The absence of both __GFP_RECLAIM flags is interpreted as "cannot spin
>>>    on locks", and intended to be used by kmalloc_nolock(). But false
>>>    positives are possible e.g. during early boot where gfp_allowed_mask
>>>    clears __GFP_RECLAIM from all allocations. This leads to unnecessary
>>>    allocation failures and workarounds such as fd3634312a04 ("debugobject:
>>>    Make it work with deferred page initialization - again").
>>>
>>> - __GFP_NO_OBJ_EXT exists and takes up valuable bit in the gfp flags
>>>    space, only to prevent recursive kmalloc() allocations for obj_ext
>>>    arrays and sheaves.
>>>
>> Hello Valstimil!
>>
>> I think memory allocation profiling uses __GFP_NO_OBJ_EXT, and I dont see
>> it being removed in the series (hopefully I didnt miss it).
>>
>> Adding Hao Ge in CC who did this in the commit:
>> mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list


Thanks for the CC. I'm now aware of this.


> Thanks for the heads up. I missed it because my series is based on
> slab/for-next and that commit is in mm-unstable. My patch 15 actually
> modifies the TODO comment that is meanwhile resolved by Hao Ge's patch.
>
> Which means my patch 15/15 can't be used as-is, and at worst I will drop it.
> But I'd encourage Hao Ge with Suren to find some way to avoid the gfp flag
> usage too, because it's now quite a niche use case (preventing false
> positive CONFIG_MEM_ALLOC_PROFILING_DEBUG warnings, IIUC?) to take a
> valuable gfp flag bit, IMHO.


I previously used __GFP_NO_OBJ_EXT because it serves the same purpose as 
in slab.

We use it here to prevent recursion within the page allocator.

I hadn't anticipated that __GFP_NO_OBJ_EXT would be removed so soon.

I agree with you. Since slab no longer uses it, retaining this GFP flag 
solely for debug is indeed costly.

I've also been thinking about possible solutions today. Since we are 
working in the page allocation path,

we need to take various race conditions into consideration.

For instance, what if an interrupt is triggered inside page_alloc, which 
then invokes page_alloc again?

I'm not sure if such a scenario exists in practice, but I believe we 
still need to account for it.

I would highly appreciate it if anyone could share their ideas.

I've made a note of this.

Would it make sense to hold off on merging patch 15/15 for now?

We can always include it in a later cycle once we have a proper 
replacement for the

memory allocation profilingside. Thanks Best Regards Hao

>>> The page allocator uses its internal alloc_flags to convey various
>>> context information, including ALLOC_TRYLOCK (meaning "cannot spin").
>>> This series copies that concept for the slab allocator, with its own
>>> slab-specific internal flags:
>>>
>>> - SLAB_ALLOC_DEFAULT - no extra flags (the value is 0), but explicit
>>> - SLAB_ALLOC_TRYLOCK - do not spin on locks (used by kmalloc_nolock())
>>> - SLAB_ALLOC_NEW_SLAB - replacing existing 'bool new_slab' parameter
>>> 			for allocating obj_ext arrays
>>> - SLAB_ALLOC_NO_RECURSE - replacing usage of __GFP_NO_OBJ_EXT
>>>
>>> To reduce the amount of parameters in various internal functions, we
>>> additionally introduce slab_alloc_context (also inspired by page
>>> allocator's alloc_context) for passing a number of existing arguments
>>> and the new alloc_flags:
>>>
>>> /* Structure holding extra parameters for slab allocations */
>>> struct slab_alloc_context {
>>> 	unsigned long caller_addr;
>>> 	unsigned long orig_size;
>>> 	unsigned int alloc_flags;
>>> 	struct list_lru *lru;
>>> };
>>>
>>> This also replaces the existing struct partial_context.
>>>
>>> The last necessary piece is kmalloc_flags() which can take the
>>> alloc_flags in addition to gfp flags and is intended for the recursive
>>> allocations of sheaves and obj_ext arrays, so that both
>>> SLAB_ALLOC_TRYLOCK and SLAB_ALLOC_NO_RECURSE can be communicated.
>>> Internally it decides between kmalloc_nolock() and normal kmalloc()
>>> depending SLAB_ALLOC_TRYLOCK.
>>>
>>> The rest of the series is gradually expanding the usage of both
>>> alloc_flags and slab_alloc_context as necessary, with bits of
>>> refactoring. Then, __GFP_NO_OBJ_EXT is removed completely.
>>>
>>> Note that some usage of gfpflags_allow_spinning() relying on absence of
>>> __GFP_RECLAIM remains outside of slab (and page allocator) in memcg,
>>> page_owner and stackdepot code. These can thus yield false-positive
>>> decisions that spinning is not allowed, but should not result in
>>> important allocations failing anymore.
>>>
>>> Signed-off-by: Vlastimil Babka (SUSE)<vbabka@kernel.org>
>>> ---
>>> Vlastimil Babka (SUSE) (15):
>>>        mm/slab: always zero only requested size on alloc
>>>        mm/slab: stop inlining __slab_alloc_node()
>>>        mm/slab: introduce slab_alloc_context
>>>        mm/slab: introduce alloc_flags and SLAB_ALLOC_TRYLOCK
>>>        mm/slab: add alloc_flags to slab_alloc_context
>>>        mm/slab: replace struct partial_context with slab_alloc_context
>>>        mm/slab: pass alloc_flags to new slab allocation
>>>        mm/slab: pass alloc_flags through slab_post_alloc_hook() chain
>>>        mm/slab: replace slab_alloc_node() parameters with slab_alloc_context
>>>        mm/slab: allow kmem_cache_alloc_bulk() with any gfp flags
>>>        mm/slab: pass slab_alloc_context to __do_kmalloc_node()
>>>        mm/slab: introduce kmalloc_flags()
>>>        mm/slab: remove __GFP_NO_OBJ_EXT usage from alloc_slab_obj_exts()
>>>        mm/slab: replace __GFP_NO_OBJ_EXT with SLAB_ALLOC_NO_RECURSE for sheaves
>>>        mm: remove the __GFP_NO_OBJ_EXT flag
>>>
>>>   include/linux/gfp_types.h       |   7 -
>>>   include/linux/slab.h            |  14 +-
>>>   include/trace/events/mmflags.h  |  10 +-
>>>   lib/alloc_tag.c                 |   2 +-
>>>   mm/kfence/core.c                |   6 +-
>>>   mm/memcontrol.c                 |   5 +-
>>>   mm/slab.h                       |  16 +-
>>>   mm/slub.c                       | 423 ++++++++++++++++++++++++----------------
>>>   tools/include/linux/gfp_types.h |   7 -
>>>   9 files changed, 288 insertions(+), 202 deletions(-)
>>> ---
>>> base-commit: 500b2c9755301742bdbb61249511ac11a4665dae
>>> change-id: 20260601-slab_alloc_flags-25c782b0c57c
>>>
>>> Best regards,
>>> --
>>> Vlastimil Babka (SUSE)<vbabka@kernel.org>

