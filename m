Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09114CC6B1A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 20:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961B76B0088; Tue, 13 Oct 2026 16:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913236B008A; Tue, 13 Oct 2026 16:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801CD6B008C; Tue, 13 Oct 2026 16:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58E9C6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6A501C2302
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:25:31 +0000 (UTC)
X-FDA: 85318733262.05.4504CA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2ECD21A000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:25:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jm9mMZ6K;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791923130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaZQVI4OBM3dYTDYP0h3QPZiaN1K+djX9uwXeV4f+FY=;
	b=Wredxv0M5gc4sljgD/VC3xMGWvzAyejwWRsAw3DToYpJrMeoBxftTmTkTQfsDx9ERJeoFW
	VSVox/HLXcJLXRm+8C0xkvalMtGrXFc8wTvmRpu20g8c+cnZ5858ol+zwQHRKI2MyD64dQ
	Z11a60UduO6DmN+0vtBILO/CwmB+ws8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791923130;
	b=W2DyFhoXyA+cKRGpnRBQV0SZDWzjtYKJWEunkkVpyR8enOub29ALDchXsHNDR//9AfsYXN
	owtT4v35qWhgEZSGAyPsOnohfxwlo17+Wo9ay+zpGBKMiv1KLCC8xNm9qgSWfwNsH83szh
	BGcFYmGrtrEAowSEMZ56i7zt0StlaPQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jm9mMZ6K;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1185601FD;
	Tue, 13 Oct 2026 20:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0DC1F000FF;
	Tue, 13 Oct 2026 20:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791923129;
	bh=UaZQVI4OBM3dYTDYP0h3QPZiaN1K+djX9uwXeV4f+FY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jm9mMZ6K42gtgoI2FD4ePesOjmwOOAPUms8KWxDz84hZ8REV4FOlBnMJfYYQftxxk
	 lci6/JGRZDKLaEtM/qoyLcZmoWainxeJXbFNzOvoML33EcMgKwCnUQeCZURZ24W/O4
	 YAFKpMV5Rs4H1SJ05sNsGabyYu8aeJOYgvoq+JrcW03sWBth261ekC2Vutn2S8ounP
	 oCO0t90kY3SS8NDQ3Z4xZK21Y9ap6m/l8+VxH/QH7qBxFqCZBWjqsFEZnpFq3jHrOC
	 zLHrOWqQK0KvO+WsMTTPE1e7tZjbGABcmtN87LhpEfjlixV3GKBIVQ+sMOGfNg+nyL
	 TrF7PbIj7GrKg==
Message-ID: <dfbb4bac-0def-4e1b-87a7-91c9cd91349e@kernel.org>
Date: Tue, 13 Oct 2026 22:25:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/13] mm/collapse: open-code collapse_single_pmd() in
 its two callers
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-11-kirill@shutemov.name>
 <b2133cff-ce69-4a45-bf33-c44b774dee7b@kernel.org>
 <ar-nKHZ5hlbsXeFP@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ar-nKHZ5hlbsXeFP@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2ECD21A000C
X-Rspam-User: 
X-Stat-Signature: xxgrt86qokd94oe5ann3fn8qmndajas5
X-HE-Tag: 1791923130-452784
X-HE-Meta: U2FsdGVkX18MkgOXs9eMczWNVTgKOEIl/5Xni5/NoUyPd5hcFhAvGqe3YdpwKRS/Scs+/zgB+5fC8xsDqQ/SbBhKu1XHlUWc73rvKqpncnYKmwSEL0JtVUdU3XBBkZENTZeufl58KiHAzyY7Dcspojvxlm1i90vdPOkjhdy4yxkqe9Y/ePCKd5r2I2T9jHt0MtQKagwYoXRZ1Q9EZAK1AX5kBmN10gT8UY1tcaqH7tJ0iNqKL471c1iTYND6YfvMhA0XZ1GImSQ72TdHnU4xjSTP4mdw5a8Dfl3JxrhEzYeksTSiKovOZXjekJHxqAEEBvPfUtWB2nT8/EN26CDRALcoQCK7l+PPzU3dho1T79H3L6e0Ow2v9FikwT3aTFUiytXcCrL8rKmj8D6BCTchuX/xWE5f/rlDXLHszDkGI3VTpf5PSJKHlI0Ww6Qlg5LrL1LMjAJqvNy0mfjtg23SzASh5dqSgb8gQb4f5beCcXpx7YwQx5CvzVwNimkE8G4oOwre6ho0vqNk7bDxIK09va8MK40BCwmOCZC5oNSD4UKeNrq84/wVRY1GWrOoRY11LFfzxhHA/hpSiFYHAVZGJm3YNHz2PjjI/wQHUYX9ST7f7eAzP5gJUt3lGuPNK9LbiLj6MlNkn6vg2MqITkYPV1EUv5MPcBBzcoa3Lvh08Tn1160etdJlZ0B/jFi5nTyKUbpzXXCATPc4OYd7+LzuStC4GKXbo6oI0B4NwZRzXEHQRyFPCo5L412UK0MDj0xLw5RAFceOwXKv6r9AVM9E8m+GK2ivu9IVgk8w/iqYYRXzrlqkSS6XquS1by4Oopv/vcXS0RtDIHJIefLgjdRYMv6JhryEkd6t64q6Bzmh+t81atEVvKlau+TYcwQ9fAFSiT+k2jwNNGPoOYfpxEFlrp5JkUjo/6q7hm2ebvv8v+vcZK01ExNidezY2uK7VC9bLMRZ6nwqj6GtXdKdDB7
 VuyjnBQ9
 GLxoaaeBMD+Ij342NdoZAYqDY1PufIhhFJAeDvgFlBeqk3rdgFmdkXPh6AC9bmUS/niXiS4UTVGkQRYWDk9ETCs2m2/s40enC+XCurQ/5CnNp/LXqfUikA8SnrVvyn27aH5p0iMfsitgWdoYIEIMxzmwsfeo0Gdmzp9zy8hJpNx8ZUa/K5wBBjmoZLLnXSwAocZBdPJhh0+rcIlhZvCYDgBfmkLIQijSvlbgNGRihSJysa/D3XuZQa8afjswOAP/BrCqHyzMMHqdAd1U7LmGM+bTcbhHC1sKGglxWwL59g36aU1nGooABKSCNXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Finally following up after recovering from last week :)

> 
> Right on both.
> 
> As I mentioned before, virtual address scanning might not be the best
> way to collapse page cache.
> 
> We might want to start from inodes on superblocks that have large folios
> enabled.
> 
> But it is out of scope for the patchset.

Ack.

> 
>> Also, I guess we can convert some of the scanning to use per-vma locks in the
>> future, whereby we would actually want to scan with the per-vma lock held.
> 
> That is the reason the caller owns the lock here.
> 
> On top of this series I have khugepaged scanning under the per-VMA lock:
> the scan asserts whatever lock the caller holds, the caller does
> vma_end_read() before the run, and the run takes the locks it needs
> itself.
> 
> Neither the scan nor the run changed for it.
> 
> With collapse_single_pmd() dropping the lock, it has to know which lock
> the caller took. process_madvise() on another process's mm cannot move
> to the VMA lock: untagged_addr_remote() asserts mmap_lock, so a remote
> MADV_COLLAPSE keeps it while a local one and khugepaged move on.
> 
> The single call would need a flag saying which lock to drop. That is
> the lock_dropped bool again, pointing the other way.
> 
>> I do wonder about one thing: should we really care so much about keeping the
>> mmap lock locked? Meaning, why not provide a single collapse_single_pmd() that
>>
>> * Is always called without the mmap lock (as is)
>> * Always returns with the mmap lock unlocked (change)
> 
> Yes, we should.
> 
> Walking the tables under one hold and giving the lock up only to
> collapse is how khugepaged has worked since ba76149f47d8 ("thp:
> khugepaged").
> 
> The bool is just how that signal got plumbed when MADV_COLLAPSE arrived
> in 50ad2f24b3b4, and it has already cost one bug, 5a62019807da
> ("mm/khugepaged: fix issue with tracking lock").
> 
> This series removes the bool and keeps the behaviour.
> 
>> Sure, we drop+re-acquire the mmap lock a couple of times and lookup the vma, but
>> isn't that actually being nice to the other parts of the system? In the future
>>  it would simply get called with the per-vma lock and would return with it unlocked.
>>
>> In the good old days, looking up VMAs was expensive, but nowadays ... not sure
>> if it still matters?
> 
> The rwsem and the VMA lookup are not the only cost.
> 
> In your version every table is a visit to the mm: unlock,
> khugepaged_mm_lock, back through khugepaged_do_scan(),
> khugepaged_mm_lock again, a trylock and a VMA walk, for a scan that on
> memory already huge is one pmd read.

I removed the inner loop. We could have kept it, but the numbers below suggest
something different I guess.

> 
> I measured your prototype against patch 9 as posted, both on a production
> config, 8G of anonymous memory already collapsed, scan_sleep_millisecs 0,
> pages_to_scan 65536, PMD order only, five runs each, medians:
> 
>                                      as posted    yours
>   khugepaged, nothing to collapse:
>     full passes over 8G in 20s         251,180    55,477
>     khugepaged CPU                        100%      100%
>     cost per refused table               19 ns     88 ns
>   MADV_COLLAPSE, already huge:
>     512M per call, p50                  3.8 us   17.4 us
>     2M per call, p50                    703 ns    703 ns
>   tables walked in full then refused
>     (max_ptes_none 0), passes in 20s       803       836
> 
> On being nice to the rest of the system: the scan is already bounded.
> The read hold ends after pages_to_scan worth of progress. We already
> have properly sized scan batching in place.
> 
>> khugepaged? Not sure if this matters. madvise? I suspect many real users operate
>> on a single PMD only (e.g., tcmalloc, jemalloc). For the other ones, not sure if
>> dropping the lock every PMD is really a problem?
> 
> khugepaged matters. We run it across the fleet, and its scan cost is
> what decides how aggressive we can afford to be with it. I am not
> giving up scan rate to keep one entry point into the engine.

I'm not sure whether the numbers above area really *that* relevant. But I get
your point: scanning must be as cheap as possible.

> 
> For a single PMD there is no difference either way. For a range, today a
> MADV_COLLAPSE over memory that is already huge walks it without letting
> go of the lock at all; in your version it relocks and revalidates for
> every table, and tells madvise_walk_vmas() to look the VMA up again.
> 
>> IOW, how bad would the following simplification be (prototype that needs more
>> work and thought):
>>
> 
> ...
> 
>>
>> Based on that, I'd rather want to see collapse_single_pmd() to just inline the file
>> and anon paths, and see how we can further optimize the locking internally (e.g., perform
>> the pagecache scanning without the mmap lock).
> 
> I see the appeal of the single entry point for the collapse engine. I do.
> 
> But it costs us on both the locking picture and the scan rate. That
> does not work for me.

So this is in mm-unstable and I want at least the first 9 patches to go to
mm-stable rather sooner than later.

As raised in person, I don't like the open-coding here; it just results in weird
API. I wonder whether we can come up with a better interface, while keeping the
locking as per your requirement cheap (scan performance).

While we figure that out, does it make sense to send out revised patch 1..9 to
move them to mm-stable while we figure out the remainder of the new API?


Regarding API, I think we have two possible paths forward:

a) An API based on ranges without a VMA. The internal handling would take care
of VMA lookup, re-validation, and managing the mmap lock.

b) Some better state tracking that abstracts the locking details.


For example, something along the lines of an init/next/finish sequence with
some additional state:

void collapse_init(struct collapse_state *state,
	struct mm_struct *mm, unsigned long start,
	unsigned long end, struct collapse_control *cc);

enum scan_result collapse_next(struct collapse_state *state);

void collapse_finish(struct collapse_walk *state);


Maybe that could give you some idea how we could provide a cleaner API? We have
various options I think that don't require this split in the caller.

Ideally, I'd wish we could get rid of the vma revalidation in the callers entirely.

If it helps, I can play with it to prototype what have in mind.

-- 
Cheers,

David

