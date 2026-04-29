Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D890AFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D32F6B0088; Wed, 29 Apr 2026 08:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083C76B008C; Wed, 29 Apr 2026 08:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDBC16B0092; Wed, 29 Apr 2026 08:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC4E16B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:31:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62F9D401EA
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:31:19 +0000 (UTC)
X-FDA: 84711528678.08.E396A83
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6F0E640003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:31:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VQlCzalW;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777465877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vrJRN4H7DA8knCNzoNtMFJ66bO9JZkjLzP1Byam1AA=;
	b=XXbluEVGVhQ5Lex1JmN2DSFTCwnpGB/f1jpm9IfAScjZ24sLOhxSlJ8z2L1jlbaJoMBnr3
	YCaGICMJ1/c7LVFnOOhHQG8M1PUHTt8bIrm1QXoZkVGp1SR81333+rBkynVV7xf2VFmIfd
	FBtfpJM5kYOioDbmCypvXcfQ8gtqEHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777465877; a=rsa-sha256;
	cv=none;
	b=cpPT+5FAg0w2Kg+JaHTffJH/XzuIZprDzTPLQeoYrQLX2o5QeUEQfgaoaVI5MrkjaB/ZDx
	UtNrqU9o2nd+EKdB1iw4JBZXDp9niqVEy25fvB8AHb9Mo+U4TvhZIJHFcNrlT79NPVNjMo
	koTF13bGMbCBV0ew0Bt0+R3VWNmmswk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VQlCzalW;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C006E2A68;
	Wed, 29 Apr 2026 05:31:10 -0700 (PDT)
Received: from [10.57.90.96] (unknown [10.57.90.96])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B54663F836;
	Wed, 29 Apr 2026 05:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777465876; bh=2pIojbJQg9tB5OJkbigs/SXblp/raktpEhuhy3g94i4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VQlCzalWyEWttNiubbfJ002pfiwZMF9cJ/bo1THuZmxTORIUhLTEjcl6kqRyB6sJx
	 /4X6ML+SqxEJXwPD9h+y5al2/h2cdiLa4P0uQFXmsj8Hd22PEKtnFk3XYSnj+6ws4k
	 EGG+QZeaCZ/hV2vHCXXnbjyVpxLb0eq+oGafyXbw=
Message-ID: <9834200a-492c-4705-a2b2-e76cc0ba5392@arm.com>
Date: Wed, 29 Apr 2026 13:31:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/3] mm: Free contiguous order-0 pages efficiently
Content-Language: en-GB
To: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 david.hildenbrand@arm.com
References: <20260401101634.2868165-1-usama.anjum@arm.com>
 <20260429103326.GA1743@cmpxchg.org>
 <20260429050430.d86f01dbe731edc9fa932add@linux-foundation.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260429050430.d86f01dbe731edc9fa932add@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F0E640003
X-Stat-Signature: upremtay8egb9s4hwr6jsm19x7onqbsp
X-Rspam-User: 
X-HE-Tag: 1777465877-893014
X-HE-Meta: U2FsdGVkX1/6oEkdfOiiq4d9nQc7HbFdhxfYWeKK5bF8yfsDxD/v+OrTEpJ1kA9ZL6C7P3rOAQ/Uh7j1kvRUdWu/d7/tpY4lcUWG/9Z0KkJ2DU6qFrkDr9GoaJ7uyiz5DoMZMW0WkOQJw2aChv3ppjT4uFO64Eat28kD5pK3qU1449znoVCaOURJY4qPmxTt744MlnQKBqeMb3tcz/yF+czoP9/JU+3TOaWFs7lXHCqa/D9odzv6xJXm4V0Oko6qzV1er/GAr1t//wNjmzgEtiPg3R2TvjeUBxNPLK2d7qezjomWaOcaoi8raeCNKGlszbgl6lf47o9WWiQ0Rwn+fAFZCO9Op9PdJllgZulGnmZdRkFJKFC0o0naz7gZQGO3OOkvyZPt8CXPFnfxS32EpfhW4/Vf3KlTk+w4egCUSNl5K3yl6xQbalgZZwhntaYwGo5VXI3ircZnlA6jJzf/pa/fV7tMf5cYgzDQoN+gTfHvskl5KUgXbMR51VxGtcSWJIxsU8apBA3gpQLRE9nEPcxCFD98Ieg+FlblN57iZ8eBUYMXOp9GX28PkAbJq5JBVGQkYVdrfcx95gZyJfPPjB3rIad9XpsrOoflBiWGlDIBKMPHchv8mBFAQ12hAz8+56qd47VLvBep1Gsmhp522pjNzJ1AMBuXvxFPD1kaM/9rI7IOKwbau29YrleXbhFUaZcgoM2GRIdKsKhu2utPnXZFRmw8mAhQu/TEorHuiv6CW+mwgesC1I4ZDcsyG070DSj9Fs0GL+KtOdLJ0jSST3AiKeR8+tqySID/4yIloIw5DhzmqlS6upiJRl/PSr2ivKW4yGkQACtV719qUnsJ5R1t2oOYk8KF+HGqA8f+sZ0h+PufATRNLC5GO/UdOveGxIwIDOHFbpQrS2GP38r44lOORiH3aTh+NYmJ2VJv5M8wn5m63QFPs84PowQzIsvvWP1GQWei0nlz0+Mfhav
 T6eFO5Nf
 42Pp2OreAfr2uH+ZJ0smGMCbDc033JzkMpvpxZyKAI9daY2uA7VcZo3h0j9aAKnRva+Our9GCWRMZPrYKFWWEEyUE9J9YjNZ26cXoJRnjFbprJ4NixMLL4pE2jMC3NRAM4Gxah8G3NKPxVweCKvCbjsU4dT0W4Ehj8+bokRLLtIxTIzk7V/ScKU8j0VQLyJBGSBHDRo7CFxel/Pd95SIR2h4Q4jHySHZFcl2s1y70uLLkflm5crm9g1R5HAXjyfIkLQbl/9mDOtM1Usgp1OzsIeV4VsLM6F5lNbaz9YRhaa/4IYInCKdi8liiARlpa+K+kkh7lMLLYkOog8r65ClQBxQLo9RwFIW44owRb415mMCPoeM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/04/2026 13:04, Andrew Morton wrote:
> On Wed, 29 Apr 2026 06:33:26 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
>> On Wed, Apr 01, 2026 at 11:16:18AM +0100, Muhammad Usama Anjum wrote:
>>> Hi All,
>>>
>>> A recent change to vmalloc caused some performance benchmark regressions (see
>>> [1]). I'm attempting to fix that (and at the same time significantly improve
>>> beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.
>>
>> I think we should revert the original patch.
>>
>> The premise is that we can save some allocator calls by requesting
>> higher orders and splitting them up into singles. This is a frivolous
>> and short-sighted use of a very coveted and expensive resource.

I'm not sure it's that simple. First off, vmalloc has preferred to allocate high
order pages for quite a while, it's just that the patch you're referring to
makes it try even harder. So reverting the patch doesn't completely revert the
behaviour, it just reduces it.

Performance benefits because those high order pages are mapped appropriately in
the page table - i.e. 1G PUD, 2M PMD, (or 64K CONTPTE on arm64). So it's not
solely about the number of cycles spent in the allocator; the HW is used more
efficiently. vmalloc only splits to order-0 for the benefit of the caller,
because there are some places that assume they can access each returned struct page.

And all the order-0 pages of the original high order page are freed at the same
time, so it's not like we are destroying the contiguous resource; it remains
intact for the next user (well, ignoring that some will be freed to the pcpu
list - this series solves that wrinkle). I've heard it argued that this approach
is actually _better_ for conserving contiguous blocks because it's keeping the
lifetime of all the constituent pages bound together and reducing fragmentation.
I've never seen any data though...

>>
>> The buddy allocator tries hard to retain contiguity *if it isn't
>> needed by the caller*. This patch actively works around that.
>>>> The cost of recreating those higher orders elsewhere is shouldered by
>> whoever actually needs the contiguity down the line. And that process
>> is orders of magnitudes more expensive than we save here:
>>
>> We're saving cycles per page in the vmalloc path, and later spend tens
>> of thousands of cycles per page to recreate the contiguity. Scanning
>> PFN ranges, folio locks, rmap walks, TLB flushes, page copies.
>>
>> That's a terrible trade-off.
> 
> That's persuasive.
> 
> afaict much/all of this series remains useful after a06157804399
> ("mm/vmalloc: request large order pages from buddy allocator") is
> reverted?

Yes; although the motivation for the investigation was observed micro-benchmark
regressions due to a06157804399 ("mm/vmalloc: request large order pages from
buddy allocator"), this series is still beneficial even without that patch since
vmalloc will still allocate high order pages in many situations and so it's
still beneficial to free them efficiently when the time comes.

> 
> What I'm not understanding is how significant all of this is.  Sure,
> making many-page vmallocs faster is both beneficial and harmful.  And we
> have super-focused microbenchmarks which demonstrate both effects.  But
> how often does the kernel actually *do* this stuff in real-world (or
> even real-world corner-case) situations?

Afraid I don't have clear data on that. My intuition is that it's a real-world
corner case. But significant enough to justify all the previous effort to map by
hugepage where possile...

Thanks,
Ryan


