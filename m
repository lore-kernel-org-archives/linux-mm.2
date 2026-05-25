Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A678CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB68C6B0005; Mon, 25 May 2026 11:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46616B0088; Mon, 25 May 2026 11:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F266B008A; Mon, 25 May 2026 11:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABA1F6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:24:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 600814016B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:24:15 +0000 (UTC)
X-FDA: 84806313270.20.9FD1917
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A824F4000E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:24:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dv+TCYCC;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779722653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1Nukes//tK5IIic5W7fXiatpAoFLru1ePDI3tJnewI=;
	b=Edwl+RaZNpcXqRjE4k61O52N0ujUg57PEVEOlGmEBOkNGzWxogIN+i9fr8pEf6epXxU+9X
	DiaSkr/3+2hm2sAUvL1Jh0y7P4uveTEfE6tsUH3S69fP2BqGiQr9CASeY83e11lSm+29wA
	48ig6X6woy8J2aY7AFbIcqraMwuk4gU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dv+TCYCC;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779722653; a=rsa-sha256;
	cv=none;
	b=d1HsZNIIIVw2UoQNDdfa8LRpRCkh0XDBP8NGVQxtzVp6oNCzOjOONJCWebfrMX4jK/WCf9
	Yi0xdf9nSjeD1yt/yNRlM0i9vUlIjNEKEkk7eiEV5ddWQWTl2oAezwI8KkFC0DAXd3ItLz
	1YGAghK8RZ8M6KFrs2SmayWK9yCSjPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5415402B6;
	Mon, 25 May 2026 15:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBEB1F000E9;
	Mon, 25 May 2026 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779722652;
	bh=w1Nukes//tK5IIic5W7fXiatpAoFLru1ePDI3tJnewI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dv+TCYCCKH+uwHpqFa6O1X8AzYC4SenCV6+XXikkYpbiF7jlOzbKbHxaGhh0e1yPY
	 o8oeGtL0FSUXuD/g+ZWMTpgI0zMr0eNFiIlKeHLePGOfduMUdn8Ljd2K0p8gNZxDWN
	 ff1KdaDe/sAGCHLtdYiTmzbMmoxqfcThy4gqzveZD6hEHQQlgZJXhisff3DWEhutux
	 C+Bmj1rirmJhxPa8Un0gCDzPYbWf03l+j/XkK5V6y+T6UGaSoIOkhWMVJY10MuHSkJ
	 Xy4tCQcA9UnwruU4tt0rW/O0G4du+UO6urEVDvZXFsCSvihZVHUy4uEX5bQq6NTNLF
	 gp4tgUom5sTmw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/hugetlb: make bootmem allocation work with KHO
In-Reply-To: <agmS5yZRflzN1M8U@kernel.org> (Mike Rapoport's message of "Sun,
	17 May 2026 13:05:27 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-13-pratyush@kernel.org>
	<agmS5yZRflzN1M8U@kernel.org>
Date: Mon, 25 May 2026 17:24:09 +0200
Message-ID: <2vxzo6i37bs6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: A824F4000E
X-Stat-Signature: nxfsn196gp9msa5f3o4gmqb8ko4cynch
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779722653-555846
X-HE-Meta: U2FsdGVkX18yJ3WWTrExYMn6Lhe4dpOlFj6hz34AmwM1gDnoVeEtIH3mEQu2JmdntzC5bxAfgVTPfFN/mqUa5FvrmV8yiKQvaJUeV1OqM/DesBC9Jp6VxoRHGINpagagOpN6eLtTa/qT7eHbmNBLNAHAff9yl+70XKnewAendlP28bE7sj0O3TNjL/8ktdPS7BJSbAcEudPcei027XPDffEIYcnT7dSpShUmBB/K1rzZB8mkXlmA5xMEbR+7S5QVrgafBT1rLGwmNNmUGG6CugpjgC7VizRE1AaI6FIYSP3IrE5EfTtrjazTmt7QE1DV5UGyg0NQbOtFnES6LCwVWgjqAVfzQOtcVrqaIQ5CgyUJ2Rn5sbZP2xAKCuZWzXRf5PngUhFyhS2s2UynG2F2bhKjk1qVnUbCeyhStwAGnOkOjE5G/R4gjZ2oP+HCbKmBlQBqdUqryk0lL1Rbgl7fWfoe7VneI+L0r/W/2ARPSl/paB+PwYvhJuX0e5oqlgB9MrN4HGiWTJf5B+zJ8xOSRhtrPT20pmXS0fz16z+BomIsf2lf8vKovIDbjJqkBgk/ky/w6tO6jcMFRZUt/Qb93ZxJC45yaNPDyY5lCHQ9EPBxplldPPOX1hQbx7zZO4cxHvNm5AkCUQ5iKN1PV2N0R77xFOqGOH2i288mAd5vQ6dzD0Qyx0xlKE2afLkI0Ki6zpQo8porczp1VxkDyszHQjEKnEdG+8ebjOQ/k1EghX725afIu0UuWaU0sYByyLPEqK8QowJ9c26HosJkINDE4qKw/7dK3inoEdbLEVsCvfDy49j1OK9MQUd5izbs/ilL7OBqw1bsCH9EqM1nxAO24ZVh7qZYLlpeI26FzuPqa0yg8gOA1ZdoRz5yg4ttvAdt49lLrXEE2+swWjoqHGzqGchCG6he6rrCU4OimizqpZ/WvAjJvuNU0zELM6vXjrm4gQw44HdQUCIcfjShVEm
 7Xh1xty+
 7t/0pt0k0icoIUGaWbYztxfg+PaRezvNbX9q9c+AfBknXHnKaIzM9KS3lTZ3DcmlBtX8iJDn0VujqiBrhAbvktHTDHsbbcrNLY4u2f0RUzxwJ56P7IEzcJiqiiUcIetkZvRmoKu2FgA/398I+RfJdD7Z3BN1t5glgJXoMIzFygxz/923Z0G/ynCcLTDlGtW7RBErkpCfhz8GHPe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Sun, May 17 2026, Mike Rapoport wrote:

> Hi Pratyush,
>
> On Wed, Apr 29, 2026 at 03:39:14PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> Gigantic page allocation is somewhat broken currently when KHO is used.
>> 
>> Firstly, they break KHO scratch size accounting. RSRV_KERN is used to
>> track how much memory is reserved for use by the kernel. Since
>> alloc_bootmem() calls the memblock_alloc*() APIs, the hugepages
>> allocated also get marked as RSRV_KERN.
>
> The intended semantics of RSRV_KERN was to distinguish memory reserved
> because it's in use by firmware from the memory reserved or allocated by
> the kernel. It does not have to be directly used by the kernel, some of
> PG_Reserved memory is mapped to user-space and it's not only hugetlb. There
> are zero pages, VDSO and maybe something else, I don't remember.
>
>> Allocations marked RSRV_KERN are used by KHO to calculate how much
>> scratch space it should reserve to make sure the next kernel has enough
>> memory to boot when it is in scratch-only phase. Counting hugepages in
>
> The size of RSRV_KERN allocations is also used in
> memblock_estimated_nr_free_pages() that's currently used by
> set_max_threads() to set several rlimits and by s390 to allocate colored
> zero pages. Excluding hugetlb from that will skew the calculations there.

Oh, I didn't know that. I thought it was only for KHO.

>
>> that blows up scratch size, and can lead to the scratch allocation
>> failing, making KHO unusable. This will show up when huge pages make up
>> more than 50% of the system, which is a fairly common use case.
>> 
>> Secondly, while not supported right now, huge pages are user memory and
>> can be preserved via KHO. The scratch spaces should not have any
>> preserved memory. Allocating hugepages from scratch (on a KHO boot) can
>> lead to them being un-preservable.
>> 
>> Introduce memblock_alloc_nid_user(). This does two things: first, it
>> instructs __memblock_alloc_range_nid() to not use scratch areas to
>> fulfill allocation. If KHO is in scratch-only mode, allocations will
>> only be made from extended scratch areas. Second, it removes RSRV_KERN
>> from the allocation to make sure it doesn't mess up scratch size
>> accounting.
>> 
>> To reduce duplication, introduce __memblock_alloc_range_nid() which does
>> exactly what memblock_alloc_range_nid() used to do, but takes the flags
>> from its caller. Then make memblock_alloc_range_nid() a wrapper to it.
>> This lets memblock_alloc_nid_user() re-use most of the logic without
>> causing churn to update all callers of memblock_alloc_range_nid() and
>> adding yet another argument to it.
>
> That's neat :)
>
> But I'm not too fond of the memblock_alloc_nid_user() as a concept. That
> early at boot everything is still kernel, even though hugetlb pages might
> become user afterwards if they are actually consumed.
> Another thing, is that adding such global API to memblock could be abused
> and suddenly some early code will clear RSRV_KERN for a random pieces of
> memory.
>
> If we'd still need a special memblock function for gigantic pages
> allocation I'd rather make it explicit that it's for hugetlb and keep it in
> mm/internal.h

Sure, that would work I think.

>
> I was thinking about possible alternative solutions and here's what I came
> up with

Thanks for the ideas, much appreciated!

>
> 1. SCRATCH_EXT nicely increases the memory pool available to memblock, but
>    the decision which memory can be used for which allocations becomes more
>    complex. It should make sure that SCRATCH is not used for hugetlb, but
>    OTOH it's preferred for other early allocations. With implicit
>    interaction between choose_memblock_flags() and should_skip_region()
>    this seems to me quite a headache.

Yep, I agree. I can try to refactor some of the logic to make this
easier to understand, but I am not sure how successful I would be.

>    memblock_reserved_clear_kern() should be changed to something else to
>    keep set_max_threads() working. And, IMHO, memblock_alloc_nid_user()
>    should be turned into memblock_alloc_gigantic_hugetlb() and only exposed
>    to MM code. It's even possible that it will duplicate some of
>    memblock_alloc_range_nid) rather than use it because hugetlb is always a
>    special case.

That's fine by me I think. Perhaps we can also hide the complexity of
the allocation strategy here? For example, we won't have to expose the
semantic of SCRATCH_EXT only allocations to the rest of the memblock
allocation machinery.

>
> 2. Split memblock_reserve() part from kho_mem_retrieve() to run before
>    hugetlb allocations. With this we won't need new types and APIs, we can
>    ensure that hugetlb allocations do not use SCRATCH by reserving scratch
>    areas before hugetlb allocations and releasing them afterwards.
>    Obviously this is the slowest option as it will slow down all memblock
>    allocations from the point we memblock_reserve() preserved memory. Still
>    realistically I wouldn't expect large impact on performance because the
>    heaviest part there is reserving of the preserved memory that has to
>    happen anyway. Also, I don't thing that a system that uses a lot of
>    gigantic pages will have a lot of preserved chunks scattered around.

This option would make my life easier (in the short term) because I
think it is the easiest to implement. But I don't think this is good for
KHO long term.

First, I think the memblock_reserve() calls are band-aid and we should
get rid of them entirely. They scale terribly. With even a few gigabytes
of memory they go in the order of seconds. I ran a quick experiment, and
with around 4 GiB of 4k preservations, it takes around 650 ms on my test
machine.

And this isn't a theoretical use case. We are looking to preserve
similar sized memfds on our machines. This would be on top of having a
few terabytes in 1G huge pages. I think we should integrate KHO more
deeply into the memblock -> buddy handover sequence.

Second, while you pay the same cost on doing the memblock_reserve(), the
reservations need to happen much sooner. Right now, the reservations
happen right before memblock_free_all(). With this we would need to move
the reservations to mm_core_init_early() which happens right after
setup_arch(). So every allocation after mm_core_init_early() will take a
hit. While I haven't measured the performance impact with this, I
imagine it won't be trivial.

>
> 3. Move the complexity into hugetlb and make it preserve all the gigantic
>    pages with KHO. This means, though, that we won't be able to increase
>    the number of gigantic pages after the first boot (although decreasing
>    it seems easy) and that we need to let scratch auto scaling understand
>    what were the "normal" memblock allocations and what were the
>    allocations of the gigantic pages.

This is a viable option. There is of course the limitation of not being
able to add more gigantic pages but I suppose most workloads should be
able to live with that. The obvious downside is that you don't have a
fallback if scratch runs out so KHO will be a little less resilient.

The complexity with this comes with correctly preserving all the
gigantic pages. Hugepages can be removed at runtime, so we would need to
plug into the removal mechanism. There's also demotion and other things
that need to be taken care of. The reason we need to track this is
because what if the freed hugepage now contains preserved memory from
something else.

>
> 4. Invert SCRATCH_EXT logic and instead of freeing large chunks around the
>    preserved memory to SCRATCH_EXT, reserve memory surrounding the
>    preserved areas and release scratch_only before hugetlb allocations.
>    We'd still need to somehow prevent hugetlb allocation spilling into
>    scratch and there's a nasty piece of releasing the memory around the
>    preserved chunks. On the bright side, I think it's feasible to defer the
>    release of those regions and free them when we are already
>    multithreaded. This probably the most involved alternative but it also
>    could help with the bottleneck of kho_mem_retrieve() creating too many
>    memblock.reserved regions.

I think we should fix kho_mem_retrieve() by making memblock_free_all()
and deferred_free_pages() aware of KHO. I feel that splitting the
freeing of pages into two phases is going to make the early boot more
complicated than it needs to. And on top of all this we still need to do
the special case thing for hugetlb anyway. So I am not sure if this is a
good idea...

>
> Thoughts?

I personally like option 1 the most (maybe because it is very similar to
my patchset). My point is, if you think the "extended scratch" is fine
as a concept and we only need to clean up the neighbouring stuff like
memblock allocation strategy, then I would like to pursue this since I
think this has the most potential.

I think option 3 is also viable. While I personally am not a huge fan, I
don't have it either. So if you really dislike 1 then I can try to make
3 work.

Option 4 can kind of work, but it just gives me a bad feeling that it
will make early boot memory management more complex and might result in
flaky boot failures.

Option 2 is the worst of the lot I think. It is the easiest to
implement, but I think it just adds to the tech debt that
memblock_reserve() is.

So, in summary, I would like to pursue option 1 and try to make it more
appetizing. But I would like to at least know if you hate the "extended
scratch" (ignore the name) as a concept or only the code it results in.

-- 
Regards,
Pratyush Yadav

