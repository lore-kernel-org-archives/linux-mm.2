Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01595CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694816B00B1; Fri, 22 May 2026 11:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B136B00B3; Fri, 22 May 2026 11:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8C46B00B4; Fri, 22 May 2026 11:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5876B00B1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:02:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C463A0A91
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:02:45 +0000 (UTC)
X-FDA: 84795372690.18.90577FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5CF33A001C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:02:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KrfS+tJB;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2IrT8PydzK9xxtu2jbeHfoX/1GcdXru7uVPffwnQVk=;
	b=rhrXDS609O45NmKj3p4K+w8ri/0//C0RPfivWPs9lfAPE6CgNc4ewAW1JjX/9ZkkY87J4I
	fuzgPhDy1aTU2Iv74ExM1Yhk7xpStW+kadILRzPXrDqcsEY1AV+8MQfPgdkY5V1VssWLaB
	PlwxikYEIW6DsD3ukynfRx3cfpEHmfs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KrfS+tJB;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462163; a=rsa-sha256;
	cv=none;
	b=wpZpeuZAmajLkmb2qZygkqtYT6OQWCCKbK9qddcD7bW7ve/KrGFvx7CiDeXwuCJyOvzCTb
	EedOmNoZ79j1Kl0Bz0ZS1ftTve4IWwcCvmlJf/kUy95/qFXnDvCTJuVPxrTSrlGu/6L7Nd
	cw0gmfEH12BwkWWrfewK8SOUHvw0eOc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57D08404C1;
	Fri, 22 May 2026 15:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1C61F000E9;
	Fri, 22 May 2026 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779462162;
	bh=A2IrT8PydzK9xxtu2jbeHfoX/1GcdXru7uVPffwnQVk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=KrfS+tJBjhwvjCQc5lgSC6UFM6xUBTGfKJwHZGomUl3hmvnG1kj0ilOsmwLMOtvHs
	 WkhRDeIH8FQct/ouklVCLMRrJcS4BKjeoi4U6HGiK3BZ7DhLP+gUuvdgdIKhpD1yeQ
	 pKpFA76LjjW6sjKy3COwgf521ZIPorDv2JVVq+AP9nJYDkyGweg+5VRbvMyV65K+OV
	 aMVCLwYyHtObaRLTb86V3MFbGhyycqmQnZ3xtdjEd0oeePDe/GK6oTq4Io2R0xvTOH
	 DZcT6S+Tdy/0Ntak24i/r+mUMrhP0rIdIsr01sIslAsOIJMLNw/ikjSgkesOrd/DOv
	 rfHbxnVUM2xoA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Muchun Song <muchun.song@linux.dev>,
  Oscar Salvador <osalvador@suse.de>,  David Hildenbrand
 <david@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Jason Miu
 <jasonmiu@google.com>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
In-Reply-To: <ag-a4ru9bMkDMthO@plex> (Pasha Tatashin's message of "Fri, 22 May
	2026 00:48:35 +0000")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-10-pratyush@kernel.org>
	<agHGOxSnP_VraH1M@kernel.org> <2vxzecjhc2s8.fsf@kernel.org>
	<ag-a4ru9bMkDMthO@plex>
Date: Fri, 22 May 2026 17:02:38 +0200
Message-ID: <2vxzse7j7ai9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CF33A001C
X-Stat-Signature: cgdzqx5p54h1w6bc1y1998um579dzib5
X-HE-Tag: 1779462163-755971
X-HE-Meta: U2FsdGVkX19tTIlbqBLHG7TyFzic6UnAknPYRgBMtdR8UXHz3M5J0OZZdGu8vhizw87JRRtLW54fBLnzLLccOE5Y+0Biy96tV9Az1WSSkBldwnF9e+SRpBnAd6kqyNYrooWfKCUQaq8xbu4dA2MbIZyhg0eBIH/N6ZnzDgoN+4jV/4sT/oqnixR0AkN4eNXVnmOrYQyVhbNc2Cdsz71fltfCjyiu5hxZ/9foCRH/W5609gNc8TX/ajIeRhcoJexOAjJTRsRKzj9DMAl0FLE9/s88TEHdW+me6v70aegm8+Y236fCSjaGlStDS89Ohs4Wc6LNjXNS6vR4qniLxntO8wRi3ccjiRAb6fjX4sw4+w0uIs7m03VELkaDF7nJDggmS5t86gGq6JuiMAxR9IlBn9BAgHZwYdPjGVAX9oCd71YKslWuxiYrg6gyMyzkJkyE2yCqKXmOU1DYYkEYUhE14Kw3hdFaRwnJtjwgRn0X7FZWYpIP+ADa7Gj4IJTXhAN5ACyaPliTI6MZRqTZ8xU9IHFu/4RyVDVWLRtdp7gcht05A2u6E5m7ciAxWLgwHfoX3PUjMuUZ33goKMVzxLfzHhgmHHdSGaNtjQPPVgEajuznQMOco02qq5isocLYeojwsJT5IFUpaD+vJpQ2WQ/SfNevDfq+fvlU/uo0r6JxmM5gotEUNBGRxBxKRx5x4TuThjq76sWGxu5eJ5gdHpxAS+MjgQiXsfHcqmMDE2aG/vxXbuDAWIJnKgKSOXwv1bN4zPcaVMWE72gxje2/yjFJUe+QQhlD7iQ7Ypzmp1AUZw8VUK5zPk+qzvsHdCzKmQJ1ReQbufCoZGwXjv+LqhmIlTCvxcjub8tJGuQsREIUMUp0vM7fvtFCzgQNFug5q1EAr1gL1JNra8HkggTrZIs5oSwpjTcRr2Y17XqcAmHoUUemNFZhOLBoSqCzPq5uXX0W8zLlpHiy2WoG7133Bcy
 qU/dKUDY
 LfPFphqrLoAhlHgTdvDZdvPbdvOpPFZXCtUdUCJVF0lqwauO+YaS0trswx2TwPA+02zIzj3C7U8YWA+GJLgybBTUBtjmbWe3LoZPwjPV75nnarj8m5VBfPBhRDcBLT2/8jhvblM3RiHhoIcJ4dPgBd66aMk/WO47cwjx418okRzkpiGpRs1DO9TSey8iLZwXyvJYwOoOJoDLJSqfJBPyK0EpD/0cRv3ay7JxJSe7x8/h28ajHmMGB2GqZCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22 2026, Pasha Tatashin wrote:

> On 05-11 18:46, Pratyush Yadav wrote:
>> On Mon, May 11 2026, Mike Rapoport wrote:
>> 
>> > On Wed, Apr 29, 2026 at 03:39:11PM +0200, Pratyush Yadav wrote:
>> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> >> 
>> >> In the upcoming commits, the KHO will learn how to discover free blocks
>> >> of memory by walking the KHO radix tree. It will then mark those regions
>> >> as scratch to allow memory allocation in case scratch runs low.
>> >> 
>> >> To differentiate the extended scratch areas from the main scratch areas,
>> >> introduce MEMBLOCK_KHO_SCRATCH_EXT. Use it when choosing memblock flags
>> >> for allocations during scratch-only. Teach should_skip_region() to check
>> >> for both flags before deciding if the region should be skipped.
>> >
>> > Why there's a need to differentiate SCRATCH and SCRATCH_EXT?
>> > SCRATCH (I still hate the name) means "memory memblock can safely use for
>
>  +1000
>
> I also strongly dislike this name and mentioned it in another thread
> earlier today.
>
> If we ever decide to s/scratch/something-else/ globally, that should be a
> separate cleanup effort. However, since we are introducing a brand new flag
> here, we can discuss a better name for the _ext portion to avoid overloading
> the "scratch" concept.
>
>> > the allocations". Initially this memory comes from the reservations in the
>> > first kernel, but if the second kernel can find more memory to extend it,
>> > why that additional memory should be treated differently? 
>> 
>> Two reasons:
>> 
>> 1. We mark SCRATCH as MIGRATE_CMA. We don't want to do that for
>>    SCRATCH_EXT since this memory can be used for non-movable
>>    allocations.
>> 
>> 2. Gigantic (1G) huge pages can not be allocated from scratch. They can
>>    be preserved memory and thus should not be allocated from SCRATCH.
>>    See patch 12 that does allocations for gigantic huge pages only from
>>    SCRATCH_EXT.
>> 
>> I will add this in the commit message for the next version.
>> 
>> Naming is hard, so if you have any better names I'm all ears :-)
>
> IMO, this scratch_ext is not "scratch" in the traditional KHO sense at all.
> The traditional KHO scratch is what is passed from kernel to kernel and is
> guaranteed to contain zero preserved memory. This new memory is not passed
> from kernel to kernel and can contain preserved memory at runtime. It's
> essentially just memory that we identify as currently unpreserved and release
> early to the system.
>
> If we want to keep the naming aligned with the existing codebase for now:
> MEMBLOCK_KHO_SCRATCH      -> original scratch
> MEMBLOCK_KHO_UNPRESERVED  -> for the new memory (instead of SCRATCH_EXT)

UNPRESERVED sounds good to me. I will use that for the next revision
unless Mike objects.

>
> Alternatively, if we do want to tackle the global rename of "scratch" later:
> MEMBLOCK_KHO_BOOTSTRAP    -> for the original scratch
> MEMBLOCK_KHO_UNPRESERVED  -> for this new dynamic memory

Or perhaps BOOTMEM? I suppose either of the two are somewhat better than
scratch.

Anyway, can we please do the SCRATCH rename as a separate series? I
would like this series to not get muddled in the naming discussion. I
will use UNPRESERVED for the new concept in v2 though.

>
> What do you think?
>
> Pasha

-- 
Regards,
Pratyush Yadav

