Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09DE9C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155AB6B0088; Thu, 30 Jul 2026 09:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106CA6B008A; Thu, 30 Jul 2026 09:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F37836B00A7; Thu, 30 Jul 2026 09:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D43DA6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DD621A0176
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:46:36 +0000 (UTC)
X-FDA: 85045567992.12.F3A5AEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id AAE4E40015
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:46:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IU7Txz0J;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785419194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDmoqto9hZ+R6oCKFme2ZMcDe07xcXehKAFCTx8AmQA=;
	b=XEdxySEgvSSiI2aNjuV+4ysNYs2G8xomxBG3NUpa1jYeB8sEZXVuy16pdlFWkmVGkaNWq7
	r7O65E40Ql3s/eBMDHPk1EeX1W8czB3pjBmdu2veIWUs7mwC+57h8FRDcXQqP0AnRmJfqE
	shSTQNOlxLysUTVHL7bt8Z4S8Pf15C8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785419194;
	b=bNm07vqHoqA2WOdPgmO9d3qiFFXR/OOqPm6dtjVCdnpDm1yuQDSAd7moqIoGj0aO2bq/Oz
	02UQZQ/p8m21w6ERvYvKNZmRIxm4PAYOPev4vQi8G77W4s1rjYmil6U2SoqE8iIzFpJ7H8
	LFGRR+PHrvLMhDgLTSFrlhmIgujcXPM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IU7Txz0J;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A82D60A6C;
	Thu, 30 Jul 2026 13:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7980B1F000E9;
	Thu, 30 Jul 2026 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785419193;
	bh=mDmoqto9hZ+R6oCKFme2ZMcDe07xcXehKAFCTx8AmQA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IU7Txz0JcPxOLnm3glJfmYbJ8SsmDwmUx8AuylBVY4irxxS4MzMcqASsFQHBSEm3N
	 59c1GZzQBYg4e/SybYP13ptOwEtcQsKrMF60s3+Iv+Z063Eez7b5rnLuX9iPhYFMoZ
	 GMeMTaq6NB/Iu0q/BXO/0H/UZt5PKKvjnKLWnhZ5ShQ9QX93/2+OY5dbO4kgmXqKy+
	 jC+RwXPJoNXzv7L1f0Oh1Wl4d9geWbhkDd9wpW6eFgX7/9EXlKf8dkoLh74hfd6Vwt
	 XsmrUsj9j7rNW4150F+UTXHuiIEgX2c688OM4HPhRQ3bgZ7Sgvu9q3Nbde2HVNfYGb
	 m84DmMQ9VLxYA==
Message-ID: <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org>
Date: Thu, 30 Jul 2026 15:46:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org>
 <amoWjOnPayHVQU9v@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amoWjOnPayHVQU9v@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AAE4E40015
X-Stat-Signature: 1rycaa7cwbq7wod1z96w1tg5bm96863z
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785419194-743713
X-HE-Meta: U2FsdGVkX19v26bg2jR3KKuMt0uaxgXVygN8mhDVDc3R8OOj8jZuN5FtFP6Q0qCXtH5ESk+oYgtolRtGgkMfU1OC1fdt95TYV66V/ACpTEelleCDr3AMuBFBYY3oR7S9YJa8M8fl3vxLauSmDU9Odi+jcpKvkpyvaYZNfAP2tJrH3qJMWdzq/nwUS3Z77HCFxS7D+TCNO/oDhzoI12ONHa4Hx/RMXzY4zUnL56K2JCko4BClyy/1TB4AM1f3cIs/oFWTLXA5B+PlTjK+R0J1Z4uQThJgBhzTvOhoo7f48yE5jBEisAheXfl7TCwugWM+xhVb96LAN/DIEJ2d0v4NkE7+2ePn599M8qtjweshj+ItTr2bKXH9MJ1ySAu/rK/Kbd37u7afl4f1DzB+pCUlrbhLLZH+QZsOArfz/RiyuKHCG3iRF8zXbHB/WdhpPQBY/TlyTafkGQdzDhXYhYVijuq0RiD1ZEXzzLoTL9oagGkUcXEMRZnlf8jNxpjHc9RAaYWBPcvQuCTnUldcA/JjJIfD8hfdNvc0lZQ0etS/La7693hCy/Uaj2hWiZ1ELB4+QSpN0eDhs3wjYTQElBBwmSnjJn1OA/qYSzCOJ72ylcoRfKeCD33o+IhZuAG2XZwoH3e5dhdon3u9oPwrpMCVauHtlfsI+01V9CqhUyK5pm59IlvpG61eYmkQDGOWaycWhRfUe81JKiHd7bnPDl0hsudF6SdfrvBEjIeOWhmumJFpmq9aL97XJPk1VcpCNNI8ZYvpR+oW9MJtytKQ1oIADBuFyxFmNFv/j7/NGQh2Dv7wovzU6QM+uVoQj9cIdX0vrhNdz06GYpg/c/XJptIIt1weYKkZ/CcpNYzm5xBW/gTOGgEY/LR8qyFBVMsLPaCz8Jyac75BPbWnoysERx2uDqghNkGBy5mQTKO6O4GkaM9dB60kK667uSwe+o/oC35u6yMpaOSf8oMf789dXGr
 UpncWHd8
 /v49nS7c/16gKPfarOLWtCYlGNVA7LJ5qOcG6ojeV3x+xuCMHy2AutHqEXbEqyo6/7ZQ9sRXwHoa0JJC9dtXW4BKooHyJaDzLD8VMv/0PvYU3MZho/d8N3q/mSwl47CYyZA3MDJEPG1y0KFwJHq8w29tK0MgXgZP3ZOHjqcg8OvHypD54XAGFH3RPFf6eVQfi0q5aOt4o/qa3qlnXum6E71wsXwmvJWalGxt17nTr0i2nwxhvE0Dq43lZgRxUiQo7zbfypXoq2fkWJbizNtQQbnwKCbL3cTncP7nXW/7KxKayoYsnQ56rZyfIzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 17:04, Johannes Weiner wrote:
> On Wed, Jul 29, 2026 at 02:38:53PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/8/26 19:52, Joanne Koong wrote:
>>> On Wed, Jul 8, 2026 at 12:56 AM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> Thanks for the link to the slides! Was there a conclusion from the
>>> LSF/MM discussion about the future path forward for deferred splitting
>>> or is that still being determined?
>>
>> Sorry for the late reply. Unfortunately, it wasn't clear yet if we could
>> reporpuse the LRU, whereby we would just naturally benefit from the LRU cache
>> (soon) and only manage pages on a single list.
>>
>> The concern was that we might end up scanning many items on the LRU to detect
>> splitting candidates.
>>
>> I am not 100% sure if that is a real problem.
>>
>> As raised during the last THP cabal, my gut feeling is that Johannes might have
>> an idea on how to improve things here.
> 
> I've been trying to reconstruct all the details we talked about at
> LSFMM ;)
> 
> Going over this again, I still have to conclude using the anon LRU for
> splitting is not a good idea. Let me try to lay it out:

Heh, and I am not convinced that maintaining or extending the deferred shrinking
code is future proof.

> 
> (1) The anon LRU isn't scanned at all when there is no swap. This is
>     fixable, but requires some re-architecting of the vmscan stack.

Yes, that should be fixable.

> 
> (2) With a mix of basepages and THPs, there could indeed be a lot of
>     basepages ahead of underused THPs. That means swapping before
>     getting to space that is much cheaper to reclaim.
> 
>     The current setup isn't perfect in that regard, as the shrinker
>     runs simultaneously as the LRU. But it's making guaranteed forward
>     progress through the THPs, even as the first LRU pages are scanned.

The shrinker would obviously remain and scan the list for candidates. We might
want to remember how man / if any such entries we have on the list.

I'd imagine that reclaim can handle that as well.

> 
> (3) The anon LRU has folio lifetime, but the splitqueue is one-shot:
>     we scan each THP once, and then it's either split and dropped, or
>     found full and dropped. That THP never needs to be revisited. The
>     queue actually empties as the workload establishes itself.
> 
>     The anon LRU ~ splitqueue argument is only true around startup.
> 
>     If we used the anon LRU, we'd need per-page state to avoid repeat
>     underused checks. And we need external state to not scan the anon
>     LRU at all if there are no new THPs (and no swap). And if that's
>     just a counter for "new, not yet scanned THPs", a single fault
>     will cause you to walk the entire anon LRU before you get to it.

Remembering "not yet scanned" through a pageflag (for large folios) is indeed
very easy.

I don't quite understand the "a single fault", can you elaborate?

> 
> (4) The anon LRU is driven based on the cost of swap and observed
>     refaults. These metrics are inherently bad modulators for scanning
>     underused THP space.
> 
>     Using the anon LRU for splits means that if anon scanning slows
>     down and we lean more on the file cache, we'd also slow down the
>     search for unused THP space. This is undesirable. File cache is
>     still more valuable than uninitialized anonymous memory:
> 
>                     | anon | file | uTHP |
>     ----------------+--------------------+
>     cost to reclaim |    1 |    0 |    0 |
>     ----------------+--------------------+
>     cost to refault |    1 |    1 |    0 |
> 
>     We're thinking anon LRU because those splittable, potentially
>     underused THPs happen to be anon. But anon user data that needs to
>     be swapped out is an inherently different class of reclaim targets
>     than the uninitialized space *between* such anon user data.
> 
>     We really want uTHP -> clean cache -> swap reclaim ordering.
> 
>     Classic LRU takes this even further. Because of how the page cache
>     grows endlessly compared to heap memory, classic will scan *only*
>     the file LRU until those pages start refaulting. Using the anon
>     LRU would get us a clean cache -> swap / uTHP ordering.

I am not sure I follow. I say that we keep the deferred shrinker, but
instead of maintaining our own ugly mess of a list, we scan the anon folio
list.

So the LRU algorithm will just mostly be kept as is.

> 
> So I think reusing the anon LRU is flawed. It's fundamentally
> different needles in fundamentally different haystacks.
> 
> If we can agree on that, then the lock contention problem has a
> different scope as well: it's a simple optimization issue, not a
> fundamental data structure arrangement issue.

I don't agree yet :) But maybe I am missing something important.

Note that the "simple optimization issue" is not so simple once you
realize what kind of a pain the batched LRU already creates us when it
comes to predicting the number of expected folio references.

It's a pain I don't want to extend to other areas.

> 
> If I understand you correctly, the concern is that people will enable
> all manner of mTHP orders, and 99% of the anon faults, including all
> the order-3, order-4 pagelets, will go through the list_lru lock on
> fault, with no batching.

Yes. See Barry's LRU cache change I linked as reply to Usama who is looking for
example at a system that mostly just uses order-2 anon folios.

> 
> I do think that's valid, but how concrete is that right now? Is anyone
> actually doing that? 

Yes, thus Barry's patch :)

> I would have some concerns purely from a
> servability POV: the page allocator, watermarking, compaction etc. are
> still a bottle neck for high rates of lower orders, as we've been
> noticing with the page cache and the optimistic vmalloc higher orders.
> 
> The concrete proposal I've seen from several places was much simpler:
> I have ARM 64k basepages and I want 2M THPs.

That one is easy, I don't have a problem with that.

> 
> But in that case, the splitqueue looks no different than on x86 today.
> 
> My take is that we should add mTHPs to the split queue as-is. Deal
> with the locking/batching concern when real usecases say we should.

And that's where I disagree when it comes to small folios. Batching what we know
from LRU cache is a pain we are not going to replicate elsewhere.

-- 
Cheers,

David

