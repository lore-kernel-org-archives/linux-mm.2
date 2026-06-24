Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D3DCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 16:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C906B009B; Wed, 24 Jun 2026 12:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274326B009D; Wed, 24 Jun 2026 12:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163B06B009E; Wed, 24 Jun 2026 12:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E52656B009B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:24:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 697A01203EF
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:24:29 +0000 (UTC)
X-FDA: 84915329058.24.1123A13
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8EEE0C0014
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:24:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qFHnevJg;
	spf=pass (imf10.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782318267;
	b=ptuS1Wpx/Nkb+xTQJ6PlVN5p3JCF3Ld/Hab7cmdcvGi39apXs3NbGbq2dPGVt8qhO43Fhq
	NQBUlhk4SjXOPYtL6T3wwr0KzFeYsWJZPQSqLapEXxN234r78VLnoRDvS4Hmc3GOjfWM9U
	wB5BKy2A0BIao+3w80NfhdJrZkaHUN4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782318267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCSclJsOHXGUR9PPnNQt/KSxQU5CDN7d+xhXrFSXdFQ=;
	b=SNvEnUoB/Lyrgdq8cPrdAEhDZrqheOrCGjp38HZO1vAoNTnnjOCF7+xyrljFuxtCE1mDvT
	zdfUSskUkadJiJKFKYZQsuonBkD9/QL4WQ66U55d7Xlwmit91RHX1+aOh/qRKVO42LENhb
	H3e1GDgVvImGIJ7vEpylN1HKgHowTvg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qFHnevJg;
	spf=pass (imf10.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782318259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oCSclJsOHXGUR9PPnNQt/KSxQU5CDN7d+xhXrFSXdFQ=;
	b=qFHnevJgDyc87ZrZY47VjxEqXA89BZaLQJxeubOA8i6wlCnoxO1zxlqexltOhiSP1mJ1B7
	otStABHF1E7ajWjm02PBOzJDLYTFmB365svZ3sgHi6JJ9ZFyOhdWfqGltg8SQnpX4PCV4w
	VoKCdKXbZAf/1znIe0ErC4bci6VBduY=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 24 Jun 2026 16:24:16 +0000
Message-Id: <DJHF3BKSTZ8M.15Q62P3TSDLVH@linux.dev>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>,
 "Gregory Price" <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>,
 "Matthew Wilcox" <willy@infradead.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v2 03/13] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Suren Baghdasaryan" <surenb@google.com>, "Brendan Jackman"
 <jackmanb@google.com>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-3-31f31367d420@google.com>
 <CAJuCfpE28TqZy2k5-X1ZEdd0HhTuc5i7+0kyxX5nXH4j+5JVfw@mail.gmail.com>
In-Reply-To: <CAJuCfpE28TqZy2k5-X1ZEdd0HhTuc5i7+0kyxX5nXH4j+5JVfw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8EEE0C0014
X-Stat-Signature: gqtxj8mr4ydmg8txuz8hfibd4y1qzjwn
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782318265-189217
X-HE-Meta: U2FsdGVkX191gWpkCNSPedSwfMo0HJEIpRxu9Y0aaz19ZOYTLTPePc7jiYPsqO2BZ6itLYX2L9ZefToEw81PwHmYLd70pR+k/+nn6JImZ2hOi4I/fV9EQ5okSkWoJyFFggQOZxF+TRE/RI4bLEZg0xi4MnJUvYPpFyMrS/uVcbOt9y/qd1/MiDEt3tHIkNQCVnN8r9grgyD8qspB1fK8hK9lDdz7boG1ww7QPP1EfMEqR1EeSJnDNJYVynhCbz5utYwLw2EwsoQkyOLNQYjcRqhKmKUCsCclYUmGDfEcwthcNqPfl8zIKnRyzb8ym44bbYm5LeoIXnK27kVvbhcfSUHXH2ATqj5Yq1xq5r4ekshzibRFQXfDfDzujY5VI++ezMLDQlG0lzZx7R8yV3cmA25jtq2BeYNuqeRK41lMoukIifJ1VEummuwl/v6ig5knnJyYIc/XdS80k0ur8+SIwlEKLJV5cNdO9tTkudEKMgxNF2VtoGtKtpxqHT5fQr1SVQLOUFr546Tv3lPG6dDk8RfthbDT8NOSm66AiCTOUIb+vUxL1nnuZ1LYqQdMtrOZOC9jnF91/4IpXfLa4E/3skmtovH6+kg5P9LKgqG1NbpEUMzMAVBeLhYzhOhTVey7z+OmniaEXY3hDmzskPaHmvtUoha2qu0rqtdwdeoF4HZi7RGD/Ydd7Ef1M6BEkYYIlbMb6I6ycKLFR4vEuefpDKn1DtnK8VyWCqdJNkEJe5lPogQeSD6YJdM+sIaFoLKV6ZQz+s4353+SGbykDHMFUjLWjGmBowB3UM2gJcIY82ZiUy/sxH/RPNKjWkb4lbf3LuRbcatJaqUG/82EzkFKkkpinPhmRcwF2Z1LRLhb2WxooIurcK5o8mXA/XL1WH7z8OJuja8jZ3QEx8tZ6P2XsRMelDKLKZf69karxXpK7rpu1Xh/xoYLi6loGk35ylwnZUjvtVHyx6QOjwhqC2u
 z7ZvmpS0
 E2OZJrRp4DaqvsB5pAy7EDUhTJLbM/OLBR0rthx3OpQQGRBBYQAX6Z+wX3SnlSXdPn5lijc60IsIGaXCLKpNZQqggkCjUt4tdesdLvFfIVfCqe80Y59NZ733m4xfFkx0diM64BOYWf5ZlbUO+rcCQPsImBjYhLDgjEoQqBDIx+r6RmBymRNnFHdsbu4yZnzTwwbRTEYZxfzzmIn7f/1PQu/lkiOD9a80/pBgIvvpoq/Zohb9HQ7kFVPqxS7UwuPrte9Ptj785tbWsNNyUs1y2rc5J+uc4L/Nsi6dklm0Q9Us7WHF9p7ZU9VpgAnLqSDU4TtyGXm/KZMiVWIeEqaZOZJppgxsjPtP4OysZikjjMj4ELlriGhSrX1KN0Dvzs++0xh+H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 24, 2026 at 4:00 PM UTC, Suren Baghdasaryan wrote:
> On Mon, Jun 22, 2026 at 3:02=E2=80=AFAM Brendan Jackman <jackmanb@google.=
com> wrote:
>>
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
>>
>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>>    previously in the nolock variant:
>>
>>    a. Application of gfp_allowed_mask; this only affects early boot, and
>>       only flags that affect the slowpath get changed here.
>>
>>    b. Application of current_gfp_context() - also only affects the
>>       slowpath
>>
>> 3. The slowpath itself: this is now just explicitly skipped under
>>    !ALLOC_TRYLOCK.
>>
>> Ulterior motive: adding an alloc_flags arg to the allocator's
>> mm-internal entrypoint can later be used to do more allocation
>> customisation without needing to create new GFP flags.
>
> Looks like a nice overall cleanup.
>
>>
>> While adding this flag to a bunch of places, create ALLOC_DEFAULT to
>> avoid a mysterious literal 0 in most places. alloc_frozen_pages_noprof()
>> is defined above the alloc flags so just leave that as a slightly messy
>> exception instead of trying to fully reorder mm/internal.h for that one
>> case.
>
> Moving the whole alloc_frozen_pages() block down seems simple enough
> and would avoid special-casing this.

Yeah... when you put it like that, I don't actually know why I was so
intimidated by the prospect of moving a handful of function
declarations!

Anyway in the v3 I'm creating a new mm/page_alloc.h so this will happen
as a side effect of that.

