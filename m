Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B04C98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 12:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED436B0088; Sat, 26 Sep 2026 08:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9770B6B008A; Sat, 26 Sep 2026 08:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F406B008C; Sat, 26 Sep 2026 08:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C45F6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:13:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0EEFC0872
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:13:20 +0000 (UTC)
X-FDA: 85255803360.08.5D5BD3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 188114000D
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:13:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dqVt/WH/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sumit.garg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790424799;
	b=4WluYfqcfNsm8gAwWkGLoLjOOcaAMPTuV9bH0Tvos699jlJyN8zvt7t5yJ9/Q3vVbl1+IC
	9oZwUZhUSnq1d9e84TEQ9gjmWR/ZHhq3GsCoH+khn8xckxZN+WJAlQ7eZpjaSX2ctGYtx3
	ATL8QpRkIGLRYt6s4YsjJTFEFCAr25c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dqVt/WH/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sumit.garg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790424799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iBLZkIxA8ap1qqaUdvl37Rh8tiElL4QP7IPYChkI5I=;
	b=nWfnT3Pvxl4qtmj5rF2STdE0grDBTuV2OKu0pSOuVoFnuaih/tVMHfb1TGcuFffSoU2kn1
	NcHrSkkHP/JZua9V389awwb7hAHGhDfeRssEQCbCuqZYuRC90aNfxJDKaRypUjMG+RBMmY
	HMVErYg5AQpWoCWenEEg364iXFAjYXs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F2F1A43EA1;
	Sat, 26 Sep 2026 12:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308001F000FF;
	Sat, 26 Sep 2026 12:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790424797;
	bh=1iBLZkIxA8ap1qqaUdvl37Rh8tiElL4QP7IPYChkI5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dqVt/WH/30yxap89q3hdsyv/l61o3KLu/CiWmh2GBWsGOMCAyDd4oeItuV0KhN+p0
	 8X1zpWVayYa47zet2Ur/sfY1kFJQbab8BoOoxfXHV/YQI1RJpJcGzgkU0qRjc535uU
	 dggfLeW1RAGQ6iAvuoLIhb9T4V0FhhXIBy9i/I8pCdGeLVYzIySIXLMOZwMi3YRe/f
	 zKl3WL7aj0w8pTnJ2Nyfs5DX0DqPx3wVLkn3TmGkc+E39Db2pmRZ/OB9D3wxZRvvWf
	 SDM2RCWwifBB//vbUuDdgvoBbZaeCV/2vJDbDTyZiZ4mMxvo0MoVSBtV+WGkAlY0zm
	 09Lh/Q+rpzwkA==
Date: Sat, 26 Sep 2026 17:43:08 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Will Deacon <will@kernel.org>, brendan.jackman@linux.dev
Cc: Vincent Donnefort <vdonnefort@google.com>, catalin.marinas@arm.com,
	rppt@kernel.org, akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, robh@kernel.org, mark.rutland@arm.com,
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org,
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <are21BjeS1O3RYE3@sumit-xelite>
Mail-Followup-To: Will Deacon <will@kernel.org>, brendan.jackman@linux.dev,
	Vincent Donnefort <vdonnefort@google.com>, catalin.marinas@arm.com,
	rppt@kernel.org, akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, robh@kernel.org, mark.rutland@arm.com,
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org,
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260921110050.3977591-1-vdonnefort@google.com>
 <arIYtjmSKCs14SqO@sumit-xelite>
 <arKW_91EeKA-w96m@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <arKW_91EeKA-w96m@willie-the-truck>
X-Rspamd-Server: rspam06
X-Stat-Signature: 6i3t38rpqo568cmgs7kiu6i7fsz7ksth
X-Rspam-User: 
X-Rspamd-Queue-Id: 188114000D
X-HE-Tag: 1790424798-264899
X-HE-Meta: U2FsdGVkX1+PiSd7rrkF4YhxuBi1DFjYqKn4Ua0hh8SWEa/cA2+irhGyyvV04i3UfHbKmb7uwZ8sovSInMuU2ouxBeE7pRMjSgAH5SGkd6/WRNv5M9u8go4LkQFtgiRMJGxQ9DzAW7S8TVbG4FvjYzYPOU0rbdzDoxexy45svINLHiqv9JGqXcOiCTbIFI9pNn363obUz8Q3Qv1Eijbj0CBH3CWy6t+DTgPoaOgb9oPQ2m/jptwdCopr42D6VUAr2nr126qq4hPqBKbeDeI5UiFuzoqxQeLsOiypsLYzA2F3DX7PQ4EoQWO3VZEwLPcVQlDBr7fJZldLuikJApAlQVe8j8IQ/zes/XspK+uo4Jm20lcQJ72J2FrbYf92e+GNLfF4b/x4zAtGNStQyOMM1bUmIbIaUomYCiVZrTOIOyocw6RDAwJO+wYE91ghEDP2uEiXVQOXsZmjOcNZG5dMrwn4MtPWoUSJn0nNcUK7BjsgqmJ1ODIVR6vd9a8wdXsEmjWrRYlYpNF3ht//IB5FXtw2/NNSafaxnjLit1/99mZYKuGKFRt1T0tJNp7YixD5T2MXLmT+xWaEN+S+uuW/iou2f0Xf6FXSYoCA0tHLT374NUz38GNMib+KkJAMRANk9S3genBFgg/BIouFRsQEBEXRrcQsD47Xk+RSbzecRHmXmfk5vBAZC/2C9JI7Re5V+yJxmytQPa6oSsGvLDRgsd6SjxCn0IeTmP7IUm9UK0yb4MBnmrKjdfX+LCIAmW3qGelUNu385SKDQbw7q9mRN2e6UGwvbgw+zssEqR2hteUyePJeR3WHV/MBet1xF7GWVX0n+x0M+cjwwrkQ9KI3WARuTz3SM1XhZGbKBqzrSCQrJjXBvlTV3cTF8vWSXqGgfk3L5t+Dvq5S9hYm/+2TXI3bgfyOaAcw0/byQNX/WdXz5Pi14CkpsA668pOjZGty/lNto5SXT6FEXx9mQXV
 iZyXs6CI
 G6+1+wb6hwe6tHpw3pSUFRd9d72J0qCLCz5A0q0nuO8uEPTbL5GVHwRstZAWxVpEyGyxOMvvg9yZbtMWeyhP1D0lLfUfjDTJpALi+s3aDDQVBWrwqFitQGbrSluCIddVdrilBW1nmMKYeYe9cc3UJawYH+djsGKOKj/cXYvgoDnglRLt21AwfmRYQRM8worDn/CJxbjWS0jxsxx4KI0CipCbMKydN2iPxUdWVCG11TWFqRx0d7N0Tv3f4NYtiNg0zK+DSbZCdSNwocgPk1FiRrUq+BrAL3Do3EAQ6BPhXyya6F3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding Brendan to this thread.

Will,

Looks like you dropped me from your reply.

On Tue, 22 Sep 2026 at 15:55:59 +0100, Will Deacon wrote:
>On Tue, Sep 22, 2026 at 11:27:10AM +0530, Sumit Garg wrote:
>> On Mon, 21 Sep 2026 at 12:00:42 +0100, Vincent Donnefort wrote:
>> > This series is a follow-up to the discussion that has started here [1].
>> >
>> > When memory is lent to the Secure world via FF-A, CPU speculative
>> > accesses from NS to the lent pages can still occur as long as it retains
>> > a cacheable mapping to it.
>> >
>> > Ideally, lent memory would be "no-map" but that would mean giving up
>> > MiBs of useful memory, so let's try to do better with the help of a CMA
>> > pool.
>> >
>> > On arm64, modifying the direct map at runtime is generally restricted
>> > because the linear map defaults to block mapping and splitting blocks at
>> > runtime may trigger fatal page fault, unless the CPU implements BBML3
>> > or the entire direct map was mapped at page granularity from boot.
>> > Forcing last-level mappings system-wide incurs a severe penalty we want
>> > to avoid. Instead, this series introduces targeted last-level mappings
>> > for designated memory regions, along with the "arm,ffa-lend-pool" CMA
>> > driver to manage unmapping and remapping on lend/reclaim transitions:
>> >
>> > 1. memblock:
>> >   - Introduce MEMBLOCK_PTEMAP to force PTE mappings only for a specific region.
>> >
>> > 2. set_memory infrastructure:
>> >   - Introduce can_set_direct_map_range() to check if a specific address
>> >     range is mapped with last-level entries and can be modified safely.
>> >   - Introduce __set_direct_map_*() variants that bypass redundant checks
>> >     when the caller has already validated the range.
>> >
>> > 3. "arm,ffa-lend-pool" driver
>> >   - Introduce the "arm,ffa-lend-pool" CMA reserved-memory driver, which
>> >     unmaps pages prior to lending (ffa_prepare_lend()) and restores them
>> >     when reclaimed (ffa_lend_reclaimed()).
>> >
>> > 4. Optee support
>> >   - Hook OP-TEE dynamic protected memory pools to "arm,ffa-lend-pool" for
>> >     both SMC (via DT memory-region phandle) and FF-A (via
>> >     ffa_lend_pool_attach()) transports.
>>
>>
>> Thanks for your proposal in trying to solve this hard problem of
>> unmapping pages from kernel linear map. I remember discussing this
>> problem last year at LPC too.
>>
>> Have you had a chance to look at a more generic MM proposal around this
>> issue here [1]?
>>
>> One of the major concern for me with your proposal is tying the
>> protected memory allocation to fixed sized platform specific pool size
>> based on DT. Then the cost of granular mappings/unmapping if the
>> platforms choose to enlarge these pools.
>>
>> As you maybe aware one of the major use-cases here for protected DMAbufs
>> is the secure media pipeline use-case which is memory intensive
>> workload. IMO, the solution proposed at [1] seems to address it although
>> people have flagged rough edges there but should be addressable.
>>
>> Can you try a port of [1] for arm64 since the author did all the work
>> with x86 as reference?
>>
>> [1] https://lore.kernel.org/all/20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com/
>
>I spoke to Brendan at LPC (?) last year but this doesn't really work
>for arm64 because it relies on being able to unmap arbitrary parts of
>the linear map, which isn't generally possible unless you force pte-level
>mappings for everything, which is prohibitive for perf/power.

As per the cover letter it's about allocating pages that are not present
in the direct map. This essentially fits the protected DMABufs use-case
where we don't want any kernel mapping to exist at any time. Bufers
allocated from protected DMABufs are only meant to be accessed by the
TEE implementation or HW accelerators like in the secure media pipeline.

>
>Vincent's series tackles that by using a pool so that only that part of
>memory requires the pte-level mappings in the linear map. That's the
>whole point of it, so I don't think it makes sense to drop it in favour
>of Brendan's approach (which doesn't work).
>

For protected DMABufs, we even don't require any pte-level mappings in
linear map. The whole idea of mapping and unmapping is just a bottleneck
for performance sensitive secure media pipeline use-cases. That's why if
we can support __GFP_UNMAPPED with the memory allocator on arm64 would
be the best fit for this use-case.

Now the question is why arm64 can't support __GFP_UNMAPPED similar to
how Brendan is doing it for x86?

-Sumit

