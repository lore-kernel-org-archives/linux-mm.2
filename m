Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4E0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DE366B00A6; Tue, 30 Jun 2026 11:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08DD36B0109; Tue, 30 Jun 2026 11:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9AB26B010C; Tue, 30 Jun 2026 11:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACC166B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:34:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C5891C3626
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:34:36 +0000 (UTC)
X-FDA: 84936976152.18.606E33E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 42F94A0004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:34:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TZNEjJGA;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782833674;
	b=CSrmpvuhp1P1h58pnaUHUaEQEgSR9fU07y4rDj2NR6J8LBdfO/pEF8AYbi9fuwS+ycs0np
	mRdcCo2V6FA1jOpDTS7mtAol24jdAvXDeAyPNzmBdqYJ2nMNWTkFTn1G/UtHcs/K4gSr77
	arA3M1rCEjUbnJgNUut/fCfimq1cMdg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782833674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OwS9P56nhbGkdFBYuAOEJp8Fgyu1if7n6nRSIyXvyMQ=;
	b=QfgngMnFyDBMIVcTL9R5xMLdGwbiZ+Dnw4txGOw2EeK9YD4gDXNnVuLTt1AGT6fCkNMkZ4
	rx1UPz7Edm7Quwy/9Y/nAAHagTrIQADr0nh1i+HseuJ6/HT757foED0eJCvOUIzUnRe6Uk
	uQC/311/DvH4G5R9Wm/l7zd9X4Y3sp8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TZNEjJGA;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF138601EB;
	Tue, 30 Jun 2026 15:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02ED11F000E9;
	Tue, 30 Jun 2026 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782833673;
	bh=OwS9P56nhbGkdFBYuAOEJp8Fgyu1if7n6nRSIyXvyMQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TZNEjJGAsPcpJLEFlebROpZU+apG4a30zL8j62i9jmYlYeJaAl3aWQlvpiB3/57iO
	 ETxjxR7Asn7ctiYJmN7/Od2ZN8KbQuJV65iFF706CP4OPQwPKwsepz718dXhwRucp0
	 2NBc8GhrByQt6Pp3eWpYyTBSMXTehwOXuHfeWNrgmTbu9Rz6AIdFpqW2SJ8y3Zdeq2
	 Tfms2tNuA836plyw/CpaFm58mHdf37Ng875h5vszKnGzd6risB6Js6BElWOrHHd2nf
	 mniys/F0WnJZdP04Pt0WHwDSkiFnC++6NSa4dgJ12c0+2aGaO8VxNqXoFYDh2RiaRM
	 D+RSM8fsIYWSg==
Message-ID: <11a6d404-dc87-442a-9f2c-9cf34cae4869@kernel.org>
Date: Tue, 30 Jun 2026 17:34:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/16] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
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
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-5-57bef0eadbc2@google.com>
 <397859cb-b127-4cc6-9c71-044afc99bf0c@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <397859cb-b127-4cc6-9c71-044afc99bf0c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 42F94A0004
X-Stat-Signature: yndasi93byhzciaf3hb71kndephafc8k
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782833674-106905
X-HE-Meta: U2FsdGVkX1+yvquLVkbdBwWDA+wOTXJ8tHqzK5JBsn1NccjqIL7xOAUSBcYA5jU1m53eLWeb6QJM/yihyCxLBQOuCPO9sX/xv0EGtpBBUrRRmD1068+IeNhH5Z6X7LjT8aiOopkTL0SUSdHDFukO1Vh1vtWNqtm665omD1aNYtQWxCIdW7W2rW+4gDe12BFpFH3fTeYrd1OGxLytHCSEK8gPKWMMgXek49tl0d3cm7NfVV6cq5OLHzKYVrjYqxQMMgxHHD9z+7noDChJRtGpe71ByM5fngJtwoCDWnisfyVW8lzuTpgErzVr0INSxdhQKYqxuqPNs7ahvumCB3WYPsMNTukqSofPdBxTOyBu+/CBoEnRBsIKwCwC8S2DMQBU3fJmg6PBh6LCCHkg9cjBZK9eCBjZjyZv9bQvyaMbB0sME7ygV36aKkQXzcghVpY5kJJiyi2iQ8hwfkxa8Zg0sAdlvFV+f6EBg3ASX+UGrKRIETHsW6i+dIrpALcDHafWGiH9MN4h//I69uGoo8K/Hg5WYvG4tVeyli9Ects03SstU6OHK/2p8pcOVlmvTkEzPaa9bCPqwsppPI/hGhcwJ8NbGdTlC/z/9vYEGytc6w1EWPhQlymsL65FpKbKRwUBMaRUFkyflD23MIcQtrKQKj7ISMIWtWvIqDKQjpE+JbdafveYArfRmUYBoL6lPkD0O1hkcqTrhs2s5yq5qqlbgv8Hqn5CeKk7DZ9+vB2fWyMsiQ+T0MC0BCBJuDnB0TBubCsoxLHpCZQR0iq9onmZFZlhQF7W0xi3TqcbYDq+xwskSH+4lZRN30JaiHDggYwDTHA/wxcTz9pMsa7PB2jAwE7TsqvlUS0Qb1+1lD9tpwOAEVdxNu3y7HjT1GNF3yEJ4hAO17Mho9uIteoNtWn0+JNu9MUv0h0j1t8YSaUwzwzkVNuuBgUJfOVgSAXherspY7v+rWwlaFb9dTlEW4D
 6tkBkdo7
 g4RvGxWX/r2XkZJYemmzxvf9QxVu8qEK1KMYK746arwhMNatvkgcfesvL/c9qQbTV8Ydfayl5zFRCr3wzEiYLKqMm6bIUjFmgbfkMlJ2w+fuUSCK5kJX/0sZO643l2ehy2PFMmuGKS/6ZZJln8K6MsdjulKqwutcoGarwUwfk/JBVlKXbr1ZJQQQCJuwhMx94c033J7olpvr0QTMm4yNZCrRx0+smd5iLEW9ifzkejH0Anp5beLkD/CAeqB/Wb6cwHlAHFr0XN1XLfZc7kw2trXBfwiq7BVa1n2GAsbJyp4ab8nRfUjHjmPm1WfYI0N0wZ61JNxlJAxcIUigAhF6PQy6C/urmyUv+IR0AZrsTJ1Pb5JcbQ/hnnPYmdaoDKl6tvmCr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 15:36, Harry Yoo wrote:
> 
> 
> On 6/29/26 10:11 PM, Brendan Jackman wrote:
>> Currently the core allocator code is controlled by ALLOC_NOLOCK, but the
>> main entry point function is significantly different from the normal
>> __alloc_frozen_pages_nolock(), this is tiring when reading the code.
>> 
>> Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
>> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is only
>> exposed to mm/) and then turn the nolock variant into a thin wrapper
>> that just sets that flag (as well as handling NUMA_NO_NODE, similar to
>> how some of the wrappers in gfp.h do).
>> 
>> Rationale that this doesn't change anything:
>>
>> 1. Simple bits: A bunch of the nolock-specific handling is just moved to
>>    the new alloc_order_allowed(), alloc_trylock_allowed() and
>>    gfp_trylock.
> 
> Right.
> 
>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>>    previously in the nolock variant:
>> 
>>    a. Application of gfp_allowed_mask; this only affects early boot, and
>>       only flags that affect the slowpath get changed here.
> 
> gfp_allowed_mask clears __GFP_RECLAIM, and that means now allocations
> with GFP_KERNEL during early boot would see
> gfpflags_allow_spinning() = false.

Is it a problem though? non-nolock allocations were affected before (the
masking existed for those already) and will be affected now the same, and
_nolock() allocations don't pass __GFP_RECLAIM in the first place, so the
masking can't affect them?

> The helper is not used in in the page allocator, but used in
> memcg/stackdepot/page_owner.
> 
>>    b. Application of current_gfp_context() - also only affects the
>>       slowpath
> 
> PF_MEMALLOC_PIN affects the fast path, but ALLOC_NOLOCK users
> won't be affected.

And it wouldn't be wrong if they were? It only clears __GFP_MOVABLE?

> What about alloc_flags_nofragment/nonblocking()?

ALLOC_NOFRAGMENT due to e.g. defrag_mode could be a problem indeed, if
there's no slowpath. Make ALLOC_NOLOCK override it?

nonblocking() is probably fine?

> 

