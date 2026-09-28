Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EFEECA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95AAF6B0096; Mon, 28 Sep 2026 15:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931EA6B0098; Mon, 28 Sep 2026 15:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821BA6B0099; Mon, 28 Sep 2026 15:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64A836B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:20:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF3D780275
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:20:38 +0000 (UTC)
X-FDA: 85264137756.07.32A6FE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 15C611C0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:20:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BireEPth;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790623237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=15CIyTRmucB2GrR4O2YDe6u1pK+BsgKR1Vb4778JOqY=;
	b=zr3U8SYmk/AB6v4r9RsK9AdsFDFUG1F/s365c7jWfm/8rIvzx28nOBZQ+8YKh0nMYyhxLd
	LVnDNxrPGQEWqI8VhYyr29Hz1vUSZKYkNisyJAjW0TV8YdhocDEZY/+6zZgZJsYhJw3v27
	JhAEQwHcfYlagoDLN7q4iwXiwyTdq1Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790623237;
	b=62RXPEREY4D3C5be1b9jaQbDHjMJo7QXF6b/xcgxMy7JNUIixMDVT1n+lhMuelqcN1Z8B3
	5KLTDYEy1H3E/MS2WK/pJC8hP8TO+I33yGgyAXtQgeBuRh5Rkkf7FpZDTN+xkal6Sn8xMO
	9B4sSe8TUgiBpZir3BJnUTZU69Ouv6A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BireEPth;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97246600D1;
	Mon, 28 Sep 2026 19:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21401F00893;
	Mon, 28 Sep 2026 19:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790623236;
	bh=15CIyTRmucB2GrR4O2YDe6u1pK+BsgKR1Vb4778JOqY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BireEPthn05kHaJ1zzizQ0LxOH1zI7swfCE/0ZVIddVVxfFL6BDfPUiBmaaVw2naT
	 6yxKADSKZ3qVc2zgWfQK44lDDSRDMx9nlUfqMhy4Y7UVWp2zdEVoc/i1Mhd/N//CBL
	 Zrw5n9+cgmZgUpgAe9UN+fnEc4HeagifXcYqFZF4vzzmURl8zgR8lv1bts/USEtTin
	 CIO5AaE8v1+1K9BD8dz/WJyiJ8EMgxou9PVDXZOjij8I7HZ1fQihUe+NGLudRzCR1d
	 ouOcS6QomP8mXXH1ifVdN26JPYgNcl1ctqWLPhM3fFjWjnV7BAOQUZcoRvSWmyRTMV
	 zXAEe4G/z4zCQ==
Message-ID: <790584e4-e000-45c4-921d-e55f173466dc@kernel.org>
Date: Mon, 28 Sep 2026 21:20:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 ljs@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, baohua@kernel.org,
 alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
 <20260920162014.4479-1-lance.yang@linux.dev>
 <e22eb6f7-7eb4-4f50-af2b-13a2e3952cac@kernel.org>
 <CAJnrk1Zk_4awd5OfbvsCLts1YPsB6JjjOF2hiSmg-wAp+_KUDw@mail.gmail.com>
 <00d07f4a-f679-486f-9413-6917b5213854@kernel.org>
 <CAJnrk1bD+4tndrOWuSENvEb7ody47HL2aNv2n+RzUqDE8mpkrQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJnrk1bD+4tndrOWuSENvEb7ody47HL2aNv2n+RzUqDE8mpkrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 15C611C0004
X-Stat-Signature: dcp6zmos6ezwiq1j6e44icfe8o8xyhst
X-Rspam-User: 
X-HE-Tag: 1790623236-172090
X-HE-Meta: U2FsdGVkX19kquo5NdxSBmqVFKDRRfnK8fno1N3d9GNry0lnaloichOzbgTO0K1UIh7D0A5IoD4WUI9edoOKn8pAmbFetMTAwmtHXhkveh4P7Zyja13Ey9DbLWyblE+3A3ZWvjcoC+o88QuUxe0VdR8T1U5HKpPcrg4E+y1TikwYFQ+uyNlZsI01gSuWbUYcfPbs2kyTZ+yQIkpty1pFfyOLOKzgAWfjffiVb3sJtLxRwi/On7Bc+RkIgG0PxMW9Hbrrl7FRr9zGK7hESRBMjldrtPF01HkboZIRfGzgtBc5kn+VXRrzohUpDXYLeweRX4Mts+KmZ84H7wFbuhutjqRO4uZvM/C9DsBheHAp7CY3CRi4bCNDEGx3kLU9CWGKZABluafleYVkXznWRFJTbuaNzR+DSeo7ECfZn02EzOQyT2SU7iyjs0/4MRj3woNGBAeDXsP9y2/IWl6juErTYJGdKdrlqVpviqV/vNTHjpdU21P6NUry6v4SJUckzoY1svthjcwb94zyP3hRMqsNXc1xj3lhU2O373wgfEl7cF5dwXk71JBYDX00lePBU/zbUreO1iVl7qiHPm8swHT/BGRNMbe7lq+xJL22JxoE7wKntVfkLQcKiTBgicoDcc7P3Y4FH2+78CseiaPTTID8EnPUgkwb3wTWf/y6Zug+keD5JbzCCpLGPQ7kpjszI1sDMVB9Awbq6NKNyRTOgsWyWoYrQvAezPsbtwtHL0gXFFyDi9SoBOOngUlPS5DgGq+q+MX+m3H8TCvq3wjLfL+URatu7nuLpXh3X2UIyjzB4kHBotN7rwaF64NdFVzd4FZvB90DYoaYSzvGPGS+ScW/ZX2pABhzWvos+JWBT8m2zxVvjg9VsXauNf0hEyPW9kLmzefoA9RvLCXXNdKjBLsjtOgbSC8ue0HVI8ZX134BQPuuAwPlIVq0Uz6ZjJUNuvHoozQ4jB1LArJ/bQ6Ph+y
 xlEUJlDb
 f0yP32tnAmgQ77BbXkDMTYqNSeElmIhpUNLbD8wW5j8pMbCUqM4FizX757FaUCXb0AutoJJ+V2yEtzGaFQ9trc4YOtEje6uDA4i10ZC8CyIYDqw562kjP8txHNSIl3sgs5+ZB0Wl2ijaGyVWOTh/vZt6UFHHgmiZmLYN9MjpRSV3ski+sOo+4jvFGNuWlSNyUN4qJzuA54BtdT/NUfHeTfZMt6yBMVJRPo8X0OjMqA3Kd9JG7JA/kMJpGj00CZ9psZ3q5LHzBg9hNVeAOmpkuV7cjLTbZIpIM8ekSEwYdE4BOSG4IhGe4q4mh4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/26 01:47, Joanne Koong wrote:
> On Wed, Sep 23, 2026 at 2:44 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 9/23/26 02:44, Joanne Koong wrote:
>>> On Mon, Sep 21, 2026 at 3:12 AM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> Ah, apologies for misinterpreting your comment.
>>>
>>>
>>> With scaling, I don't see a way of avoiding having to queue every
>>> anonymous folio of order >=2 to the deferred split list at fault time
>>> in the non-default max_ptes_none case, since any folio can now
>>> potentially qualify as underused.
>>
>> Exactly.
>>
>> I was primarily arguing that I don't want this overhead for the majority of
>> Linux installations out there that ship with
>>
>> $ cat /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
>> 511
>>
>> IOW: we add them (PMD THP folios today!) to the deferred list for
>> uuderused-scanning but never actually scan them because of:
>>
>>         if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>>                 return false;
> 
> Ah, I missed this nuance in your v1 reply - I thought it was objecting
> to the queueing overhead for the non-default max_ptes_none case as
> well. Patch 2 in this series does what you mentioned above and it
> automatically applies to PMD THPs too. I'll add your Suggested-by: tag
> to this in v3.

I though Johannes suggested that :)

>> Right, I raised that. Johannes thinks it could be fixed with batching. I was
>> concerned that it would become rather ugly. We'd have to see how that could look.
> 
> I ran Barry's microbenchmark to get a sense of the contention (more of
> the details are in my previous reply to Barry [1]). With max_ptes_none
> set to 0 so that everything gets queued, and toggling shrink_underused
> 0 vs 1 with patch 3 applied, I saw roughly a 15.8% and 11.5%
> performance hit on runtime at 16k and 32k, but only 1.1% at 64k and
> noisy above that.
> 
> I didn't see the cost being from contention on the deferred list's
> lock though. Perf showed that it was coming from
> folio_lruvec_lock_irqsave, and I think that's from the free path where
> in folios_put_refs(), __page_cache_release() keeps the lruvec locked
> across the whole batch, and folio_unqueue_deferred_split() gets called
> from inside that loop with that lruvec lock held. I don't think
> batching the enqueues would help in that case, since the cost is
> coming from the unqueue side and on a path that's already batched. I
> think maybe we could move the unqueue out where the lruvec lock
> doesn't need to be held while the unqueueing happens, but I need to
> look more into that.

That's an interesting insight. If contention is less of a problem right now with
that reproducer, even better!

I prefer us not doing unnecessary work (adding folios to the deferred split
queue) when we won't really split them. (if it's contention or some other
overhead doesn't really matter)


>>>
>>> Does that make scaling acceptable to you and Barry? If so, I'd prefer
>>> that as well because if/when intermediary values are supported for
>>> mTHP collapse, that support would have to be proportional, and it'd be
>>> easier to reconcile the two with split also scaled. If not, then what
>>> would be the suggestion for where to take v3?
>> My opinion is (open for discussion :) ) that scaling is likely the better
>> approach. With the following notes:
>>
>> (1) If we want to enable mTHP collapse with scaling as well, this needs very
>> good documentation and also another thought on how to work around the problem of
>> creep (e.g., refusing to collapse if creep would be possible according to the
>> max_ptes_non setting and warning).
> 
> Agreed. And if/when collapse gains proportional support later on,
> having split already scaled means one value governing both instead of
> two.
> 
>>
>> (2) Systems where the underused shrinker is effectively inactive should not add
>> folios to the deferred list. Including PMD THPs, which we unconditionally add today.
> 
> Agreed.
> 
>>
>> (3) If we want to exclude certain small folio sizes from the underused shrinker
>> (e.g., order-2? order-3?) it might be better to just hard-code that in the
>> kernel instead of giving the admin a choice it cannot possibly make easily.
> 
> Based off the benchmark results in [1] and [2], I think the cutoff
> needs to be at 64k where we exclude anything under that. On 4k base
> pages, this is order 4, but on 64k base pages, order 4 would mean 1M,
> which I think would be overly conservative. I think it makes more
> sense to express it as an absolute threshold value instead of by
> order. I'll try to find an arm64 machine to double-check this on.

If we don't add folios to deferred split queue if current underused shrinker
config wouldn't ever split them, I think there is no overhead for Android in any
case (so Barry wouldn't have to worry, at least for now).

So the magic number we chose only applies if the underused shrinker is enabled
and could eventually split them.

There, I think what should drive our decision is not the current runtime
overhead, but instead how realistic it is that we would actually reclaim
"enough" memory on average from these folios.

IOW, if the whole effort of scanning these small things is really worth it.

For an order-2 folio I'd assume "unlikely". Maybe we could collect some data
from some real workloads?

But I guess Meta is mostly focusing on 2M and doesn't really have data for any
other folio size how effective the underused scanner is for them.

> 
> For v3, I'll go back to the scaling approach. I'll be traveling next
> week and then will be at LPC after that, so my timeline is to submit
> v3 after I come back from LPC.
Cool, we can continue the discussion at LPC! :)

Yeah, best to wait until after the next merge window.

-- 
Cheers,

David

