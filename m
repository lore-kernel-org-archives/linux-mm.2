Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81603C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE256B00C5; Mon, 13 Jul 2026 12:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785E86B00C6; Mon, 13 Jul 2026 12:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BA36B00C7; Mon, 13 Jul 2026 12:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2966F6B00C5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:19:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFF701401F2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:40:17 +0000 (UTC)
X-FDA: 84984164874.06.118B609
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id C826AC0008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:40:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VpL91rYo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783957216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlkLaHtRYAVpE4WxTmCUGpkNu8tzK1MssH3C9d4Lj50=;
	b=FCI6cLW78PkT+Ut+dvq9tns8t6HJX5gduM8oaSgc1rlPlr8JMwuei7zE1iTXPJnJoQZaXd
	19Ad79DM88ZcWrvHcR2HtoIEGcT/tAuV5kMxy2Pl5Sm7NK+acK2vUDqFaAA8C9X/RRQtyw
	jxYi3ChQNCRRR8hXHSrclQB7qon1B2k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VpL91rYo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783957216;
	b=M9NcXmEALVw5nv7Bf6OnW9Fjqi4OizLvMOUtUjWfkEyuznZgEvsfAO0jyo8Yz/HfCRspbO
	mZwlHUHQz2BM+y+R4ETfG2O9IMnSWJBh9cjrD6yXYl2rO68cRreDRsHgEYsXSJiHOM7Zd4
	8B39epkRcmcMCxPDHNDicK9ZOkoT1lw=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783957211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zlkLaHtRYAVpE4WxTmCUGpkNu8tzK1MssH3C9d4Lj50=;
	b=VpL91rYo+y2+CR011e23Uc5ksnQ1xmwHVNTLJQsVl2f8ubPHy06muUywGP3MBmv+brEROf
	6VBVC24s3DS0AzmDgQXa/wuLOylma8BfZMphJzNJtlzl9RDPya6gy9aJSHUbOGK9y+mMQm
	7swMY0r9LyNXKHeqJelB7hXkbqwa0xA=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2026 15:40:04 +0000
Message-Id: <DJXK1TXBDIVC.18M4LNRSJPFWV@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <derkling@google.com>,
 <reijiw@google.com>, "Yosry Ahmed" <yosry@kernel.org>
Subject: Re: [PATCH v5 05/18] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Zi Yan" <ziy@nvidia.com>, "Brendan Jackman" <jackmanb@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <20260703-alloc-trylock-v5-5-c87b714e19d3@google.com>
 <DJP0KNE4S3WN.209EE744YM0YT@nvidia.com>
In-Reply-To: <DJP0KNE4S3WN.209EE744YM0YT@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C826AC0008
X-Stat-Signature: rg1zewc75b8aecoe9puqz8geknarwiqb
X-Rspam-User: 
X-HE-Tag: 1783957213-715995
X-HE-Meta: U2FsdGVkX18qyd9Q80g37U01J+9QLij/v5eY8rGna/7jQe8h7Iy/QOAgeOjBK5yr9805Rt60OeNxsPn/5vDjH1MBvOBw1uECRhckkQkQZNOZ4Uu4TNNvqXviMkIxIMM88Ji9g4jZK5Pe1q/1RTMqjq/iaqyrzKXuWaMwdD5wFi/ZrgzAWseP/yuVwdaBNsJeJwlh7qm83vae1OrEVz47I31v5KDkKNH7MyaEZSIpBGYWFUqVMUnUaDD4JJtKKua6nXjap/K26pW+aAlV9U5llMF6XFYGg0vXfgIWiqAAnFGBpgNJea8zoly8rieKbQAm0y5SG9X9oQ8mdCDw/JoaMlzGMLtcUGWmZ/HCd3g6cDNX69vuCBvPoEdenL2KkGusZTCRHWsTKIOBQ9Rhpbzfbl1vpai+KX6AIUqCrSp8TL2RYqRSCMCdWWZx52Jj4HWhF1zK5r6a9vB1E0KS0GpBnwx4buBWhFOzpPGzaSGuGbUYJChzZ4oFuvaIgQo22scIero0Sb8J5l59i8If5iT0JpEXV8QZr+6UfQQmRDqU5WfRvnUrqVRZiocQfDYM14uirH3VUfzwfZupY2ciPDJh3dOX3fEQOYkj1FEzTJa7m/+iN7UkVKgTWPeA/gM+IT8bqj1SXJ0XLomgwoVwKWYzY45euz9pdeEDq6XVo3H3LqiqAs9JgqH3fPGLM23DtdGCZH12E1zWzklQ+eZpK12dToqk2j/Iz7mCp8n7a03TbJBO9N8Chij+7cpHyGFMJanJJcvX5hWDTyydg49lDgOb1AdNL/fLxCmuqBfA2Krl+HXkrV4N4Qt9l9KC72eeiytALeZMvMP3sACSSirPg6UK3XQ7KtKSXyr3/gq6tjALVFLw5C08JYbTeB2QvK1iL25UylhFWb36+ISzDQVfTWXvtNfVUjRcQQbK8XdxxnS8bMsTf9mT2IXVri7fj+HlF8sgYY42y4/9xu84NfsKQq/
 L+tf08mk
 iIDuyzf/Tiq1IOrDfFuUe1jiRXEZ5L+FMSj+gj+17ETrfGAyloy6VzC4lrB2gKniwqGyToG0syceNzqddEfq8WCA0KC/lXa0yqNu8b+gEap2DxFgZEWYGnb4FnGeEICYMxD069NhFvefw7GCzFlTGbtdSuT9JCoudyXsXEoLYjXDsy6UqcdJI7HMdtX7mo+rKZ9mT+5ZuIIZnge5RyUTPAVqwa/HAHYmK2weAMApVyihauWj6nafPrx0QkVWcntPKwgKkz91/5xHapBtIHVJeIgr8DnqT/dlktDIf4tqZzOvkq28XqugSbckudUhnyUjHAZdR+tuUVyLRrLr67hisdfxhN7akHYz+jm4Ha/BjMeQs5Aw49YAFS+qEopbtu5s2XlKjXSJeOTqhTyve+yPKHLBmiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 2:42 PM UTC, Zi Yan wrote:
> On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
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
>> For consistency, set ALLOC_WMARK_MIN explicitly in fastpath_alloc_flags
>> for the new ALLOC_NOLOCK path. This was already "done" silently in
>> __alloc_frozen_pages_nolock_noprof(): ALLOC_WMARK_MIN is 0.
>>
>> Rationale that this doesn't change anything:
>>
>> 1. Simple bits: A bunch of the nolock-specific handling is just moved to
>>    the new alloc_order_allowed(), alloc_nolock_allowed() and
>>    gfp_nolock.
>>
>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>>    previously in the nolock variant:
>>
>>    a. Application of gfp_allowed_mask; this only affects early boot,
>>       only flags that affect the slowpath get changed here, and the
>>       nolock allocation path isn't allowed to the GFP_BOOT_MASK flags.
>>
>>    b. Application of current_gfp_context() - also only affects the
>>       slowpath
>>
>> 3. The slowpath itself: this is now just explicitly skipped under
>>    !ALLOC_TRYLOCK.
>
> s/TRYLOCK/NOLOCK

Thanks - Andrew would you mind fixing this up in mm-new?

>>
>> Ulterior motive: adding an alloc_flags arg to the allocator's
>> mm-internal entrypoint can later be used to do more allocation
>> customisation without needing to create new GFP flags.
>>
>> No functional change intended.
>>
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  mm/hugetlb.c    |   3 +-
>>  mm/mempolicy.c  |  10 +--
>>  mm/page_alloc.c | 192 +++++++++++++++++++++++++++++--------------------=
-------
>>  mm/page_alloc.h |   6 +-
>>  mm/slub.c       |   6 +-
>>  5 files changed, 117 insertions(+), 100 deletions(-)
>>
>
> <snip>
>
>> +/*
>> + * This is the 'heart' of the zoned buddy allocator.
>> + */
>> +struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>> +		int preferred_nid, nodemask_t *nodemask, unsigned int alloc_flags)
>> +{
>> +	struct page *page;
>> +	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
>> +	struct alloc_context ac =3D { };
>> +	unsigned int fastpath_alloc_flags =3D alloc_flags;
>> +
>> +	/* Other flags could be supported later if needed. */
>> +	if (WARN_ON(alloc_flags & ~ALLOC_NOLOCK))
>>  		return NULL;
>> =20
>> +	if (!alloc_order_allowed(gfp, order, alloc_flags))
>> +		return NULL;
>> +
>> +	if (alloc_flags & ALLOC_NOLOCK) {
>> +		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
>> +		if (!alloc_nolock_allowed())
>> +			return NULL;
>
> At first look, I wonder why __alloc_frozen_pages_noprof() needs to care
> about alloc_nolock_allowed(). But the patch's idea is to centralize all
> allocation policies, so it makes sense.
>
> Ideally, I would want alloc_frozen_pages_nolock_noprof() to filter as
> much as possible, so that __alloc_frozen_pages_noprof() has minimal/no
> awareness of ALLOC_NOLOCK. But ALLOC_NOLOCK has different preferences
> compared to the default __alloc_frozen_pages_noprof() policy like
> ALLOC_WMARK_MIN vs ALLOC_WMARK_LOW, skip slowpath, and more. Maybe we
> could do something like:
>
> __alloc_frozen_pages_noprof()
> {
>      alloc_fastpath();
>      alloc_slowpath();
> }
>
> alloc_frozen_pages_nolock_noprof()
> {
>     alloc_order_allowed();
>     alloc_nolock_allow();
>     alloc_fastpath();
> }
>
> But it still cannot remove ALLOC_NOLOCK completely from
> __alloc_frozen_pages_noprof(), like the nofragment skip. Anyway, this
> patch is a reasonable cleanup. Thanks.

Yeah, thanks this does look sensible but I think it's a separate
cleanup.

