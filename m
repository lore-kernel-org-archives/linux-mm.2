Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F9CCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76676B008A; Fri, 19 Jun 2026 04:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26AD6B008C; Fri, 19 Jun 2026 04:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE416B0092; Fri, 19 Jun 2026 04:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB9E6B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:17:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED22C1A034F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:17:39 +0000 (UTC)
X-FDA: 84895958238.19.6EF450B
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0F4781A0006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:17:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xTYox5oI;
	spf=pass (imf19.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781857058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sklxb2aHOWZNcgEmSllXh3Te/ix6CK2RSGXrEub8f1Q=;
	b=JDhjZKUsiGrY8fAbvAXpgHfYOsy51pQdgRHzeVmRHJ70VtO2sORn5ECs8EkNLkvb9jWMcT
	Tlu4WzsBbkKPWccyQfOdCrmorDkhNKBVZS8vJ/j5MvOK3tNuG1828AuLGDCcj9cTjIup0M
	IdMXNVsX8gR2eB1EL50pbIq9xjC3OAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781857058;
	b=rYM5hNvLLvXo2QGYtOvPJWgvQnZKFuvqGrNbz2yUG8NuAZjBin93KpHCYWHSMjcSbc7gUt
	buo4xxy/5yEehZNWdbGLypQY3Vj9Smdpcl5oKK+8/tmjYWeyjgKRca0R1CXeL8h6PYoIAY
	f7sW7ZYmz8yGnXrBgHDjyZtbaGjEWWI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xTYox5oI;
	spf=pass (imf19.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781857055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sklxb2aHOWZNcgEmSllXh3Te/ix6CK2RSGXrEub8f1Q=;
	b=xTYox5oIZ9OU/n4UV73SeNpDSsHY7KiCF+E1xZo3z7i3YVfbAz6ckDDjPeDFdH0dAW82Kz
	wujsHdeHDNF5dJVwP9YoWXI1vYXfiDxA8VUIzN1LjNxrr6SmgbINnCHTVf3oZi8uRK4/RR
	fFGsTeft6twr6SY6oNdxsw+GREz/BG0=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Jun 2026 08:17:31 +0000
Message-Id: <DJCVLX0WK118.3V7CXOTLISFOQ@linux.dev>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar Salvador"
 <osalvador@suse.de>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>,
 "Gregory Price" <gourry@gourry.net>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Matthew Wilcox" <willy@infradead.org>, "Brendan Jackman"
 <jackmanb@google.com>
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
 <ajS96fWbG4dzP3u3@casper.infradead.org>
In-Reply-To: <ajS96fWbG4dzP3u3@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F4781A0006
X-Rspam-User: 
X-Stat-Signature: 619nqziw7wrnseruumg5knetjohj6b3i
X-HE-Tag: 1781857057-671993
X-HE-Meta: U2FsdGVkX18Vvo+OQs+ujvQL/q1yY5ublyPRjKUXu1Qj0BIXwEH+gZ86bDIUqLdyCL+XnMvwFxifGfuKeCiHBrv8WIHofYKQeqyQit2kLuvBVgqO0azswpvvc93Arq0xg/NNFJVSpp6igc1YVSloPHXnQz+/Bi6wc9H96bgffzo5prL3ovcgp48g0ophWkv3jp2jQFg4MFbU5F936eEzqZboN2k7gvjvAhck9agcBZS/2Y6qyVaJCBTTC+KFY9OHCQD8Q7s4Lz7KnKRUMy3amOlTeZ0V3EK2ZaXxnMPyx2UzyRjO/hWsvkBKdG/DdEDgkAFFd+/UhC5bKmhPgRed9u0EqHGB0Db3gwbsZ0nueIeDEMBkQjcVW1C0WrGoShIrV9El8ekJc0ZU87XeTLregJp30p5f5ELwzqy9Fta+PHPPVA+sVPO3kdtjUbQtkEr5N4G7Kyy0fqNgwjobg4qYgiqtONhtCLN2xZHYigDnjId+LY7jVbe0AG/A0DWyVEgRcV+BKVJPCY1JFlIUBnnln3sth6o3r33PaCLCT+I6cDzio8K9xZDnuyiw5r8vg4LI7XWoW72PRHZdJILSE57G/rwc43hLdCVvyyMOsBpmO11kkY/EXcKQG5c/lF9yq6fD/dtHDWOZJlpJFgykA8WW6nCWNIjsBJ75YtfMIiUtwoFdBpLZzJnvckO1WzpVBMB2r82vm6qj9jn+PNCl+K3wQ5qLL4oRc3tOYD1OtJwzcsiBJnzEF7JA2W65AKscgdugR72JRMupcBQ0xYpuWvCJu9OkKKEpP6BOmgRTB7Hee7siKs6akAaXzeyHeAtZVsbLug9wKLoxnlztJLOLU4tZxuPvPp5duwWT8+rkhB/TB05tfvDu1Pz1H7rxS5Hzvu0DG0XV/D6R8Ir5zdLFI2le/VyX4IEAkpz6INFHWjWEvj+XiUk18oVC5xos2HO5xUu6T0MBuhgf9T5wgpKhRRr
 4eglSOkZ
 5xrmU4wrD+NrqdXW83XWdA//4fVtq2zpy1QsigQsc78Q8rQbwKEZ9x+BDfjfOtfhZjpYiNnTDT8VkkQC4T82SGv7+/+OTatKvdNE2K49kA1xN2MNBWrYDCD1vjx6IGApuUpYiP35Y3vgxGAoTYqr5oIA8clIGhH3RkV1+NxXzeMp+W8h6X+t/YuPppJlmGSOAusm4/qK16/DTrIWnTvSYLPkvy3HJSjEZDjFGZJxHzqJqTrRlPWJ6z1ocZHPMQ9VB4015owZmO9wdb/7Km5jD+ue0sctixx1aRxseR6Up4duOUrh4LJV90lSuSsWfXlwqO7xbq0BBdTarn8IHnT7r/3fopy4Km7TNShsGLS4kEYAAjK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 19, 2026 at 3:56 AM UTC, Matthew Wilcox wrote:
> On Wed, Jun 17, 2026 at 03:29:42PM +0000, Brendan Jackman wrote:
>> +++ b/mm/page_alloc.c
>> @@ -5253,24 +5253,98 @@ void free_pages_bulk(struct page **page_array, u=
nsigned long nr_pages)
>>  	}
>>  }
>> =20
>> -/*
>> - * This is the 'heart' of the zoned buddy allocator.
>> - */
>> -struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>> -		int preferred_nid, nodemask_t *nodemask)
>> +static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
>> +				       unsigned int alloc_flags)
>>  {
>> -	struct page *page;
>> -	unsigned int alloc_flags =3D ALLOC_WMARK_LOW;
>> -	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
>> -	struct alloc_context ac =3D { };
>> +
>
> Spurious blank line?

Yep, thanks.

>> +	if (alloc_flags & ALLOC_TRYLOCK)
>> +		return pcp_allowed_order(order);
> [...]
>> +/*
>> + * GFP flags to set for ALLOC_TRYLOCK i.e. alloc_pages_nolock().
>> + *
>> + * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allow=
ed.
>> + * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
>> + * is not safe in arbitrary context.
>> + *
>> + * These two are the conditions for gfpflags_allow_spinning() being tru=
e.
>> + *
>> + * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a rea=
son
>> + * to warn. Also warn would trigger printk() which is unsafe from
>> + * various contexts. We cannot use printk_deferred_enter() to mitigate,
>> + * since the running context is unknown.
>> + *
>> + * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() belo=
w
>> + * is safe in any context. Also zeroing the page is mandatory for
>> + * BPF use cases.
>
> It may be mandatory for BPF, but it seems wasteful for other uses.

True, don't see why we shouldn't push this out to the caller, I can do
it as part of this series.

>> + * Though __GFP_NOMEMALLOC is not checked in the code path below,
>> + * specify it here to highlight that alloc_pages_nolock()
>> + * doesn't want to deplete reserves.
>> + */
>> +static const gfp_t gfp_trylock =3D __GFP_NOWARN | __GFP_ZERO | __GFP_NO=
MEMALLOC |
>> +				__GFP_COMP;

> I rather dislike this being turned into a file-scope variable, even a
> non-varying variable.  Can't it remain inside a function?

Um, we could put it into a function like `void add_gfp_trylock(gfp_t *gfp)`=
=20
but that doesn't really reduce the scope in any meaninful way, right?=20

We could also squash it into what's currently called
`alloc_trylock_allowed` but then it's a bit of a mush function, would it
be called `do_trlock_stuff`?

Putting it directly into __alloc_frozen_pages_noprof() would make that
function too big IMO, and its real estate would be dominated by trylock
stuff.

It's definitely understandable to find the large variable scope yucky
but IMO the real fix for that would be to break up page_alloc.c, which
I don't really want to do in this series.=20

>> +/*
>> + * This is the 'heart' of the zoned buddy allocator.
>> + */
>> +struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>> +		int preferred_nid, nodemask_t *nodemask, unsigned int alloc_flags)
>> +{
>> +	struct page *page;
>> +	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
>> +	struct alloc_context ac =3D { };
>> +
>> +	/* Other flags could be supported later if needed. */
>> +	if (WARN_ON(alloc_flags & ~ALLOC_TRYLOCK))
>>  		return NULL;
>> =20
>> +	if (!alloc_order_allowed(gfp, order, alloc_flags))
>> +		return NULL;
>> +
>> +	if (alloc_flags & ALLOC_TRYLOCK) {
>> +		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
>
> So the only GFP flag the user is allowed to specify is __GFP_ACCOUNT?
> That seems bogus; other flags would be reasonable including all the ones
> in gfp_trylock, as well as GFP_HIGHMEM, GFP_DMA, GFP_MOVABLE, GFP_HARDWAL=
L.

Definitely makes sense for the ones in gfp_trylock.

For the others, I'm not sure - this "nolock" functionality is a bit
weird and sketchy, I suspect the reason for the WARN here is "let's make
sure we have a proper think before we allow it to grow usecases that are
meaningfully different from the other ones". I think I like that
conservatism here, I would lean towards keeping it? Not a passionately
held opinion though.

