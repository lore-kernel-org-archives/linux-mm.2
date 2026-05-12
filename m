Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF1ACD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 20:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39CC56B0005; Tue, 12 May 2026 16:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327606B008A; Tue, 12 May 2026 16:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C72D6B008C; Tue, 12 May 2026 16:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 077B36B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:04:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CF81120599
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:04:00 +0000 (UTC)
X-FDA: 84759843840.17.4A9E9CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9EA4C40003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:03:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KIjIl6aj;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778616238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8r3VryuY8b0dxbVkz+yT/XGrHoy7LOsK0t/7nzncac=;
	b=dg+z1VW1K+SQ2VQF7K2M1lBQk9nG2KKnBCherPd+rEwlq6E3SpxeQ2OWXoD4rLLYA2jezr
	tZqkcRhVW3FGojingQ8EEMIdWyYTdmAimewQ7LCvTQHCBYCuQMbxaeXnvesoeF6trX+JNh
	6+wLKZnypvooFaXrGfr1sj2Y6wihZ6w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KIjIl6aj;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778616238; a=rsa-sha256;
	cv=none;
	b=y+QHaVtvA737Z7gUlTahaDi9vs9N7gCouivRu1TPtw+xvFrKL8DW0NeUY/AxlguzeO82wA
	KFYf+WnOLgmRWpLW2RpT5myJV35tGm4dIw5ARXNUtIRfZsxGvskz+pU+wJ+8E3LS4poFgh
	dkEldbEg2+Z297UVkmdxegOaxQ+7ZG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45E4F43C71;
	Tue, 12 May 2026 20:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DC1C2BCC7;
	Tue, 12 May 2026 20:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778616237;
	bh=9/k+ifoFJCSYgHDLHTPvrEH83i7caXwmllATzwMZCGk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KIjIl6ajl6Il1Ptse3PkNF9XpGJXTQrmQvDPgaQe9vG3W42EMOoLKhK6wKqMofeNd
	 NOtKGXFooWolpacmD0F1RL0hXEilE0Ng0pO12E0bWYVfJgOpntpuU5v259SUySMC5M
	 EDR+a1L8zzS4BdwxxKr6iKNLCnTepOUjoBh196ahEI0L6439NtCNgYTjFR0DSaR7Lx
	 ospQ/0xxuZCJVW3NgMNryKT65N+VoMvT6/SdMiOMQuij30uUKJTaSuuRbT4nh3P++j
	 8b6kd8mYGKBKWY1TlS/3FZ0z3/6J+87OLQ3Mo+YWA9yrhJrMAiQjNDS93BVwHGcgt7
	 veU/NhWWzrRCw==
Message-ID: <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
Date: Tue, 12 May 2026 22:03:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uh5yn1o8fu5p5ni1psercopesgcq481b
X-Rspamd-Queue-Id: 9EA4C40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778616238-444338
X-HE-Meta: U2FsdGVkX19s88uoiGkg/71sgStc1mHJQo1knEQlF8PlBfTaf97rxQnnBQqDk9+i2b7V6xOLaEipfdYC8aBpUyZ7M0IKYuetwBF7Hsxql78u/lfET0aXqOthsfjii82fzKASJvJVr6qRy7OVrc+45w4JvEEtocjDJmxrwoimLDT+WhhtFqG3hMAi92+ITpbYvbRaxIEosBh2S7TGMNVIUC6D+raMAGaf6ZiktB/R8qh6jISq6rJ9/EQ67zy4g8AKwfodjgfAK3JlDjUH0x3+DwtSQJWqiEIONrjTb6CdT88IlKU9jin5cLu70AN4Pdob5FTr6sT2PlFbwxM5tXVIk+B784yLwJsmzPqBJuMqo9B0koI05GEBjocCwwYM3gpzVDmhgHkylLN3km14qZIWA0On6fKv14gxSypPECMpDbJKmSIGFmHeWAIfs87Z3ab/FhNL/MWcziTZMRAXijxfVtX0vielAkxRfJtt6qxPeCrPUyApCa0NwdIbcm/p412ztI4ngCXZrph0X/n4/GqV8GapFrVuGDEsy+pB4VWr2/PPFuDFFh6JRWAY0IQaPnphMQ9BA0gwlzJJfq0DYaG9EvubCPVANR92cvstidOVs4lAcm8jTbyZyu9prZG+KHSHVQObloDdJ7SAtq9IL9mgJ7usjSjOXfoiAIr5mnh4mo5pTY9V0Msvd3TM3Fre7KaWiMLnlphRZFHO7cijtaYefRDFrOFHPq9guYptfH/p1kd264Usn1VRTh11goCBpZTiyZxbG4qAUqEqLJWZ+jK3c9HXcxdb9vFZQxG0KCkTKBtv8y+k2NZJNBrLj7P961jZXFjXRhRi0Il8lKPEiX3bwy5sJc0NGks+2pcSv6ywNnmNFCjp2RM0nEIGDp2nZo2onvn6+UUuR6XT9EP21rT7e8ZZm7tzNUBxtj9DboTNa7MtbZqrTHWsBmnYkDvRcQG2ZoaBJA9qySYRF+yBQO+
 CToQ9BRe
 MGA8DHrwCvOqLFWvVM5YCA+94TpiJ9ToNcy8eWnN2YF8C8xeYJilUEI0+UyIn41oH6RpFu42cTiZ39s+I/8OMYmYcf+aSeDGrn9R2yn1a26jCOQZ71BMn6WowEXyTfotlBKJXNz1by0hw6e7LXLQ8FgZkHcyEUFWmeObXsrbMQYokhXmg8ON5YnoZpNUjWfX+6Bpre9RxpYTF0Hr8IdgBxxnTMdYGABNd8HvOZkJTc4CI1RT3KQsfl22MkFKHsQqD4yn3yG8sv0e33TdLThWA84N/fHEskVQdA270IPMLIrQJ9E/H9X/3sOM2vRcHRdMXrzuavMVOD7pKLIE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 13:31, Thomas Hellström wrote:
> Hi David,
> 
> Thanks for having a look.
> 
> On Tue, 2026-05-12 at 13:07 +0200, David Hildenbrand (Arm) wrote:
>>
>>>  
>>> +/**
>>> + * undo_compound_page() - Reverse the effect of
>>> prep_compound_page().
>>> + * @page: The head page of a compound page to demote.
>>> + *
>>> + * Returns the pages to non-compound state as if
>>> prep_compound_page()
>>> + * had never been called.  split_page() must NOT have been called
>>> on
>>> + * the compound page; tail refcounts must be 0.  The caller must
>>> ensure
>>> + * no other users hold references to the compound page.
>>> + */
>>> +void undo_compound_page(struct page *page)
>>> +{
>>> +	unsigned int i, nr = 1U << compound_order(page);
>>> +
>>> +	page[1].flags.f &= ~PAGE_FLAGS_SECOND;
>>> +	for (i = 1; i < nr; i++) {
>>> +		page[i].mapping = NULL;
>>> +		clear_compound_head(&page[i]);
>>> +	}
>>> +	ClearPageHead(page);
>>> +}
>>> +
>>>  static inline void set_buddy_order(struct page *page, unsigned int
>>> order)
>>>  {
>>>  	set_page_private(page, order);
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 3b5dc21b323c..45e80a74f77c 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -937,6 +937,111 @@ int shmem_add_to_page_cache(struct folio
>>> *folio,
>>>  	return 0;
>>>  }
>>>  
>>> +/**
>>> + * shmem_insert_folio() - Insert an isolated folio into a shmem
>>> file.
>>> + * @file: The shmem file created with shmem_file_setup().
>>> + * @folio: The folio to insert. Must be isolated (not on LRU),
>>> unlocked,
>>> + *         have exactly one reference (the caller's), have no
>>> page-table
>>> + *         mappings, and have folio->mapping == NULL.
>>> + * @order: The allocation order of @folio.  If @order > 0 and
>>> @folio is
>>> + *         not already a large (compound) folio, it will be
>>> promoted to a
>>> + *         compound folio of this order inside this function. 
>>> This requires
>>> + *         the standard post-alloc state: head refcount == 1, tail
>>> + *         refcounts == 0 (i.e. split_page() must NOT have been
>>> called).
>>> + *         On failure the promotion is reversed and the folio is
>>> returned
>>> + *         to its original non-compound state.
>>> + * @index: Page-cache index at which to insert. Must be aligned to
>>> + *         (1 << @order) and within the file's size.
>>> + * @writeback: If true, attempt immediate writeback to swap after
>>> insertion.
>>> + *             Best-effort; failure is silently ignored.
>>> + * @folio_gfp: The GFP flags to use for memory-cgroup charging.
>>> + *
>>> + * The folio is inserted zero-copy into the shmem page cache and
>>> placed on
>>> + * the anon LRU, where it participates in normal kernel reclaim
>>> (written to
>>> + * swap under memory pressure).  Any previous content at @index is
>>> discarded.
>>> + * On success the caller should release their reference with
>>> folio_put() and
>>> + * track the (@file, @index) pair for later recovery via
>>> shmem_read_folio()
>>> + * and release via shmem_truncate_range().
>>> + *
>>> + * Return: 0 on success.  On failure the folio is returned to its
>>> original
>>> + * state and the caller retains ownership.
>>> + */
>>> +int shmem_insert_folio(struct file *file, struct folio *folio,
>>> unsigned int order,
>>> +		       pgoff_t index, bool writeback, gfp_t
>>> folio_gfp)
>>> +{
>>> +	struct address_space *mapping = file->f_mapping;
>>> +	struct inode *inode = mapping->host;
>>> +	bool promoted;
>>> +	long nr_pages;
>>> +	int ret;
>>> +
>>> +	promoted = order > 0 && !folio_test_large(folio);
>>> +	if (promoted)
>>> +		prep_compound_page(&folio->page, order);
>>> +	nr_pages = folio_nr_pages(folio);
>>> +
>>> +	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>>> +	VM_BUG_ON_FOLIO(folio_mapped(folio), folio);
>>> +	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
>>> +	VM_BUG_ON_FOLIO(folio->mapping, folio);
>>> +	VM_BUG_ON(index != round_down(index, nr_pages));
>>
>> No new VM_BUG_ON_FOLIO etc.
> 
> OK, can eliminate those. Is VM_WARN_ON_FOLIO() preferred,
> or any other type of assert?

VM_WARN_ON_FOLIO() is usually what you want, or VM_WARN_ON_ONCE().

> 
>>
>> But in general, pushing in random allocated pages into shmem,
>> converting them to
>> folios is not something I particularly enjoy seeing.
>>
> 
> OK, let me understand the concern. The pages are allocated as multi-
> page folios using alloc_pages(gfp, order), but typically not promoted
> to compound pages, until inserted here. Is it that promotion that is of
> concern or inserting pages of unknown origin into shmem? Anything we
> can do to alleviate that concern?

It's all rather questionable.

A couple of points:

a) The pages are allocated to be unmovable, but adding them to shmem effectively
   turns them movable. Now you interfere with the page allocator logic of
   placing movable and unmovable pages a reasonable way into
   pageblocks that group allocations of similar types.

b) A driver is not supposed to decide which folio size will be allocated for
   shmem. I am not even sure if there is a fencing on
   CONFIG_TRANSPARENT_HUGEPAGE somewhere when ending up with large folios. order
   > PMD_ORDER is currently essentially unsupported, and I suspect your code
   would  even allow for that (looking at ttm_pool_alloc_find_order).

   We also have some problems with the pagecache not actually supporting all
   MAX_PAGE_ORDER orders (see MAX_PAGECACHE_ORDER).

   You are bypassing shmem logic to decide on that completely.

   While these things might not actually cause harm for you today (although I
   suspect some of them might in shmem swapout code), we don't want drivers to
   make our life harder by doing completely unexpected things.

c) You pass folio + order, which is just the red flag that you are doing
   something extremely dodgy.

   You just cast something that is not a folio, and was not allocated to be a
   folio to a folio through page_folio(page). That will stop working completely
   in the future once we decouple struct page from struct folio.

   If it's not a folio with a proper set order, you should be passing page +
   order.

d) We are once more open-coding creation of a folio, by hand-crafting it
   ourselves.

   We have folio_alloc() and friends for a reason. Where we, for example, do a
   page_rmappable_folio().

   I am pretty sure that you are missing a call to page_rmappable_folio(),
   resulting in the large folios not getting folio_set_large_rmappable() set.

e) undo_compound_page(). No words.



*maybe* it would be a little less bad if you would just allocate a compound page
in your driver and use page_rmappable_folio() in there.

That wouldn't change a) or b), though.


> 
> Given the problem statement in the cover-letter, would there be a
> better direction to take here? We could, for example, bypass shmem and
> insert the folios directly into the swap-cache, (although there is an
> issue with the swap-cache when the number of swap_entries are close to
> being depleted).

Good question.
We'd have to keep swapoff and all of that working. For example, in
try_to_unuse(), we special-case shmem_unuse() to handle non-anonymous pages.

But then, the whole swapcache operates on folios ... so I am not sure if there
is a lot to be won by re-implementing what shmem already does?

-- 
Cheers,

David

