Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58C8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866816B00A4; Tue, 30 Jun 2026 06:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8177B6B00A5; Tue, 30 Jun 2026 06:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D506B00A7; Tue, 30 Jun 2026 06:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 381C96B00A4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:10:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CEF7C2190
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:10:51 +0000 (UTC)
X-FDA: 84936160302.18.C29FF03
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id C94EE160003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:10:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MjDEQzuL;
	spf=pass (imf08.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782814250;
	b=vOGEZhEhH78gtIOyr+3WS7aYZkWXzescniKB3CXypMJ6h3ct7TnSpiBBzjGzw4nS5UNy6S
	X+ObyXQOCcuwxtmjoVfMXsrZSM0jz/ItOExE+OFXnJk7l0ScUdBNh8mGDR8LhYWdpV0wmg
	Qza+i33SvLUjI3fmB9exOr+0914iEpE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782814250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZgOE6uzkRAVSlpL16TwrAGSWNxNVNTEQIKNuqqsnJEs=;
	b=D51y/vGmOTVungzCSiPiNYwrVHS2uc4PwNBVUyGOiKj+zq0eiV7QG3hDrquPgTqnqFmlrn
	EKeSeubOIeg7s7iKco8Px/UTrUihBEg+TxJz7e+C0uJoBQg9kewYa24VLDXNxbWTfF9dx8
	Ungx5Dpj+W3odKL8POg3Nqm//SY8orY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MjDEQzuL;
	spf=pass (imf08.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782814247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZgOE6uzkRAVSlpL16TwrAGSWNxNVNTEQIKNuqqsnJEs=;
	b=MjDEQzuL2489TFE5xc5P5zV6a/EV8ApFdZSn+MaU6Z2jH2X0wsdPvHf74ejlqCqSBgjO+4
	30jITnG50mALgqkptEjvwgg+eK92R4gNXiiQd7ek8P6VAYy2Y9UWq1+AMZPPcrDal3vMyt
	WcMnpGdKtuz1+Sw42Rrwy4MYhc1sCLg=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 10:10:38 +0000
Message-Id: <DJMAWIOIOII3.24TMC6HTPXA7C@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Hao Ge" <hao.ge@linux.dev>, "Brendan Jackman" <jackmanb@google.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Zi Yan" <ziy@nvidia.com>, "Muchun Song" <muchun.song@linux.dev>, "David
 Hildenbrand" <david@kernel.org>, "Oscar Salvador" <osalvador@suse.de>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Matthew Brost"
 <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Byungchul Park" <byungchul@sk.com>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH v3 15/16] mm: replace __GFP_NO_CODETAG with
 ALLOC_NO_CODETAG
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-15-57bef0eadbc2@google.com>
 <b4916118-3537-4e19-8bc8-1d103dd0d225@linux.dev>
In-Reply-To: <b4916118-3537-4e19-8bc8-1d103dd0d225@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sronhiar9ixyw34my8xdq4w9iarj6h8j
X-Rspamd-Queue-Id: C94EE160003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782814249-786686
X-HE-Meta: U2FsdGVkX1/W+jR0pm4ea34jV+HsiIs09G5FU36KisqKkhz4hAc8fYYyXTW3CCtDkR+RVha8/M3ioCRHG1NxeYMqYSQZwJ56ZhDzKzsDfTq1KKll/q1NxPHkD4HfQZyQerCNvCJg+is2leqHGiXDp2ZT86HuyD5uszwFD6w4fqY+hS+C+nVm0ZyXjbt/5IiWG3JRmY0UbO/LSuNi5MNV42gcq4Lc0sMCAO9FMHGd3i3XCw+ToodmfBwE5iBfIksH7JjWQFA0i3OgfqKjCBVnicA14iJWWdICI///T6i/3FvGGdg4UbwXjgLN6zoNHeroamQ4w/Ynl5kT+P7TObxSWDPZPeGCvixyqtQ7DoNVztr4AYLiVET01VQgjgEOWGlnAyMTuv5zM/UXQHlRGBk1Gi5QmBD4ZAeLi/tGbHu0Ys5hT54DBy94Sc/dTqlt/3sAcyVS4jUJr3daOH3HwOyGmKjG1YGE8PxQBi3BQrIEYDx3XAFhOppsaLcCX0Ef3jimqaHVqz38HW8yOIXvmQHI3CP8X5olECGMA2+gpv7JgL/lHyVQWokjazupfeSAEkZT/zddb1xGNpDNFY473zAeKDZvDRrEPyY3gxGZruJvBaNeYhuYj1ACK0+9X+/d57dHeAWjPeLlMNPCBys114VXM8BVnJkFyafBLOC2koqxOT+BxJlSqgohw+pH3eu0l963YJRmERR93HapgrYpVjXYyop4OA92oxblXMw+KAE9gopJxJxVByNecknIC/GtjpwCkkc+ruf6YSsZtdgZPO0BwWh56hQhKIHBJhpx3+xY1X0FAm7cNlHmoMNqJwGP9BCzEwVd+GNbGnzzuNb7QpieQ3Q5YGvqBI8+uoFAck2whjWWzwwnHxq7Exq2rSs3V0ogh2r0dFMW3biDBGPRv9bMTUoPTbkytA8D0mFcreEz5f+Pl36TAn4Rs0n8yg8g17zlT2V3Uk8UGh+OucZg1S+
 UuHsDwmz
 iV+t2Q7BWEqa2KVhoPEw3iml+NuKy4FMOupKYCkgT1AQTmLS8pYUC6sP6pZQ0W0z3af1vABDShpODup4u9ehhXvWPCeYb21h3jBMvcp+SDMunX9xhaE/3e2kWIO6tDRoGdDy70pUYwgUo96Pw6xf+rILdyIR7fehToq7n+7dvA2YdYK6FIPrbfQXsyU6GztEPDNAYo0NmRldj8Y8p53LJbLWMyVblZqlzqfC/N5oiwqDo/xXEIPH14n6YgCj6NQYFtLck0LkjBDpKw+Aor/fxWA6WXHudX7DXaaUBFmu6zRzt+uKLVhG4QYkZJc/65gcjY6FM3HUUFwxRyqFnofsff9/8XsKWlCUj98fwL+8fn6b0x3qY0/c1i6FPZkhtGkI4zhji
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 30, 2026 at 1:55 AM UTC, Hao Ge wrote:
> Hi Brendan
>
>
> On 2026/6/29 21:12, Brendan Jackman wrote:
>> Now that alloc_pages has an entrypoint that allows passing alloc_flags,
>> we can take advantage of this to start removing GFP flags that are only
>> used for mm-internal stuff.
>>
>> This requires also plumbing the alloc_flags into some more of the
>> allocator code, in particular __alloc_pages[_noprof]() gets an
>> alloc_flags arg to go along with its callees, and we now need to pass
>> those flags deeper into the allocator so they can reach the alloc_tag
>> code.
>>
>> No functional change intended.
>>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>   mm/alloc_tag.c       | 22 ++++++----------------
>>   mm/compaction.c      |  4 ++--
>>   mm/internal.h        |  1 -
>>   mm/page_alloc.c      | 42 ++++++++++++++++++++++++------------------
>>   mm/page_alloc.h      | 17 +++++++++++++++--
>>   mm/page_frag_cache.c |  4 ++--
>>   6 files changed, 49 insertions(+), 41 deletions(-)
>>
>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index d9be1cf5187d9..a32a94e759b94 100644
>> --- a/mm/alloc_tag.c
>> +++ b/mm/alloc_tag.c
>> @@ -15,6 +15,8 @@
>>   #include <linux/vmalloc.h>
>>   #include <linux/kmemleak.h>
>>  =20
>> +#include "internal.h"
>
>
> Should we include page_alloc.h here, as we call __alloc_pages later in=20
> this file?

Yeah, there are a few build failures due to me not doing a broad enough
build. From now on I will just wait for allmodconfig instead of trying
to be clever with my build tests, sorry about this.

Also, this suggests that I have not actually re-tested the alloc_tag
code since v3 so I must repeat the test described in my cover letter (I
just manually enable the feature and check the kernel boots) for v4.

>> +
>>   #define ALLOCINFO_FILE_NAME		"allocinfo"
>>   #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag=
))
>>   #define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
>> @@ -783,19 +785,6 @@ struct pfn_pool {
>>  =20
>>   #define PFN_POOL_SIZE			((PAGE_SIZE - offsetof(struct pfn_pool, pfns))=
 / \
>>   					 sizeof(unsigned long))
>> -
>> -/*
>> - * Skip early PFN recording for a page allocation.  Reuses the
>> - * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
>> - * recursion when allocating pages for the early PFN tracking list
>> - * itself.
>> - *
>> - * Codetags of the pages allocated with __GFP_NO_CODETAG should be
>> - * cleared (via clear_page_tag_ref()) before freeing the pages to preve=
nt
>> - * alloc_tag_sub_check() from triggering a warning.
>> - */
>> -#define __GFP_NO_CODETAG		__GFP_NO_OBJ_EXT
>> -
>>   static struct pfn_pool *current_pfn_pool __initdata;
>>  =20
>>   static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>> @@ -806,7 +795,8 @@ static void __init __alloc_tag_add_early_pfn(unsigne=
d long pfn)
>>   	do {
>>   		pool =3D READ_ONCE(current_pfn_pool);
>>   		if (!pool || atomic_read(&pool->count) >=3D PFN_POOL_SIZE) {
>> -			struct page *new_page =3D alloc_page(__GFP_HIGH | __GFP_NO_CODETAG);
>> +			struct page *new_page =3D __alloc_pages(__GFP_HIGH, 0, numa_mem_id()=
,
>> +							      NULL, ALLOC_NO_CODETAG);
>>   			struct pfn_pool *new;
>>  =20
>>   			if (!new_page) {
>> @@ -837,7 +827,7 @@ typedef void alloc_tag_add_func(unsigned long pfn);
>>   static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata=
 =3D
>>   	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
>>  =20
>> -void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>> +void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flag=
s)
>
>
> alloc_tag_add_early_pfn() has three occurrences across the codebase:
>
> 1. Definition in mm/alloc_tag.c:830:
>
> void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags)
>
> 2. Declaration in include/linux/alloc_tag.h:166:
>
> void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>
> 3. Static inline stub in include/linux/alloc_tag.h:170:
>
> static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t=20
> gfp_flags) {}
>
> This patch updates the definition in alloc_tag.c to take unsigned int=20
> alloc_flags,
>
> but the two declarations in alloc_tag.h are left with the old gfp_t=20
> gfp_flags signature
>
> These should be updated to match.

Yeah ditto, sorry about this and thanks for the review.

