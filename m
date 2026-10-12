Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FEA2CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3A36B0088; Mon, 12 Oct 2026 09:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42F86B008A; Mon, 12 Oct 2026 09:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B2F6B008C; Mon, 12 Oct 2026 09:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97FF16B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:16:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8552080D8B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:16:24 +0000 (UTC)
X-FDA: 85314023088.22.80F8405
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E4F3A80007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:16:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QmH38l1e;
	spf=pass (imf30.hostedemail.com: domain of sumit.garg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791810982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6MtMH1ZS7/LqdONAPmFEgAIkbcber8e91yV+8NWqx4=;
	b=n3gWPrhWuhce+u/Ko9/4Mx42+Nk5hYAJI86pYpMLuwMIhoJDDIG/Zlo83I6LqRk3AsD1pE
	TV6aoYqtr5LirYONF+JV4hHK85W6h0SDPb4FCCOcZjKIF3cQp1sOM0DsouXeX1X47Vilm4
	IZ7StnOuicpVer7hB7bbjPmZmgLHHP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791810982;
	b=XexFm0UFRjoj3JH1mONpbLZaoxsxqFcx/3ZeRtFZg3gSctKVjRvIKEzG8hTXG5CdwGJZK7
	xRqsXpUK7UGXSCH7INpADx/mcx0/Kov4+bXET4bWDW15ByvfSkruolC1Io7PEu443YKOTp
	D4yv+/6vQcx/5NKlBlnbJCyGdVJ/IJk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QmH38l1e;
	spf=pass (imf30.hostedemail.com: domain of sumit.garg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8770C60AB0;
	Mon, 12 Oct 2026 13:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B841F0089B;
	Mon, 12 Oct 2026 13:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810981;
	bh=C6MtMH1ZS7/LqdONAPmFEgAIkbcber8e91yV+8NWqx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QmH38l1eV9DBt1+KQ53uym1LwwTyqmzwyRg5m0pDoIA+Xrz+rbRz0g8YFzsm4MF9N
	 XbwOJQCf3U6kkC/HsagR/7Att8ry12jX99u5FxJnmKyyg2De3Tkck93okliih2fgwn
	 dKfqhPMmplROMRTaYG1e0dC3PJcsdvVN9k9lNzvX9ISOhZhmTY+v8muLWGx+uiKw3v
	 8Fu6FPeoeWRFW3U0dU1ioLThmk/JDD84XAngLZKerCOHjEkki9HAtJ8MKRz7tbIHYL
	 dB33D1+wT1lCYN3KK/vZLGZ+PXSESGjx3A6aSNlzctXGWmYxWqvkA7E7FhHnJVDzel
	 vdHcVqx3qBODQ==
Date: Mon, 12 Oct 2026 18:46:12 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Will Deacon <will@kernel.org>, brendan.jackman@linux.dev,
	catalin.marinas@arm.com, rppt@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, ardb@kernel.org, thierry.reding@kernel.org,
	david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, sumit.garg@kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <aszdnInyJxLhSQRp@sumit-xelite>
References: <20260921110050.3977591-1-vdonnefort@google.com>
 <arIYtjmSKCs14SqO@sumit-xelite>
 <arKW_91EeKA-w96m@willie-the-truck>
 <are21BjeS1O3RYE3@sumit-xelite>
 <aruh86rd5FMv2i9G@willie-the-truck>
 <ar5TPvANFUoosxGW@sumit-xelite>
 <asOAYODGZa-7EIV1@google.com>
 <asOD31rTX6dNfD1o@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <asOD31rTX6dNfD1o@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E4F3A80007
X-Rspam-User: 
X-Stat-Signature: aycjb3mdd1dffrtw6yeqzecpce3wrcqd
X-HE-Tag: 1791810982-907238
X-HE-Meta: U2FsdGVkX1/ULyZpy2NnNZxmr1GGaWieDdV4xToUOhshcYqrnk6EFwYjEsqulEsaq4qwOCgu0sVJcJ7PMPl9WffXpLG+BCkkD9wCEVVa5+dz5Gg94J76bsW3SvbzWxPvYIHKOAV4SaI42hlS5/R06RKXa9xC7RWNewZVVo9XzZ2zQEnL8W8Dq8WDM72Iilq8s3g6JREIMH1HdDok1SGrSF8pXvUw8lAKf55XJZfskQXu0puIcy7jvlGPw0dTDuTS9VLExWeWbAOGWPHTIoIzehsghBmHaj3lhQXP6xRL5ucJi2XQ9kJkVzh6EbTVMn6k59luf9kh+01ZGaHtiHmgFfzx79jXkuCAPWxm/iVXVL+stnUH+RRWUjhq5NDhWmB8lkcRHYY6QGtw6vMdd1eqyKi+JAlTFq1Db18gzx2E9iAkZ0zyo9ykKVoYVXkEDJIBy8jmbJMFVwWyM5mrTX+nS1Jwh9ErPOwkzdN6TI9DNLkgNaKe6tpMyi4MRf4asz6v1RQB8TQwP/Ph6BEH80h9dONAidQiTqRtpP1jFZYPlf6TLCUQ0KQo7wFSra6aLvddiBx4mFRDOMsGvFR0S9wmLlQ02RYZQrQgbvWU16yhS37dtp9DqDg4PWWvAGnGsoylGkdF6sqIUnzTK/TbHqAEgTZHjLt0ix8hAv27ep40NYZoXNS0/A1nY3Cr6TrwBmNgn3focfgdPeLMRI9RykW7q597ta7UB5238RKkBsFLMS1JLc/4mUA43AGQYLRty3T0EePqfmF2w8ep551ImHjLBZlOCbfasx985G3Ca1vzQmu+C4UMVmD7tJJpRex0ZxGZWIzWZTVOe36WGZg0GrYQFmRYAZV5mDaKPy4LPC58eLoNVVjKcVV8ApVQiSFJ91xexEUzmsax06eccVJprNfLc22m0d8NBAi1pcU/nSxxnmdfU90FbMOhHmL1lZV/RBNGsu6u1kXAA5QZ0DbiL1y
 InPvdkXi
 17W42CvYkmVQgpYYjSvtALVxHAkLRXZ7ihVqhwWZNEENAeUT210biZUFUXsGd3NIEYKfWHsB7Df3ZuaN1P/ZUxPrgRGaMBJVyxrtx4/vwMrsy+ImzUisxXct2LdsEEAqPD4v6DB972COMl0Dz5mSuKmXvqvDYLA0mTqKmu/bRgNpsOaWWg5KQSmrCYrHY9AN6aXX+q+pxH1ntAWMdqUFvQajPEeypprbW0e+EYgszBj0j4WjIZMcULrB1ts6kGSzaLeKYgY6GzqHeHwnosZNw+/gOKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 05 Oct 2026 at 12:02:55 +0100, Vincent Donnefort wrote:
>Sorry, not sure why Sumit's email was dropped...

The problem was with my mutt config, it should be fixed now.

>
>On Mon, Oct 05, 2026 at 11:48:00AM +0100, Vincent Donnefort wrote:
>> On Thu, Oct 01, 2026 at 06:04:06PM +0530, Sumit Garg wrote:
>> > On Tue, 29 Sep 2026 at 12:33:07 +0100, Will Deacon wrote:
>> > > On Sat, Sep 26, 2026 at 05:43:08PM +0530, Sumit Garg wrote:
>> > > > Looks like you dropped me from your reply.
>> > >
>> > > Huh, that's weird. If I hit reply-all ('g') in mutt, it moves the entire
>> > > CC list to To: and drops you. I suspect the same thing happened to Thierry
>> > > when he replied here:
>> > >
>> > > https://lore.kernel.org/all/arJcN60nagFKXj2Q@orome/
>> > >
>> > > I can't figure out why that's happening :/
>> > > I manually tried to fix the To: and Cc: lines in this message.
>> >
>> > Thanks.
>> >
>> > >
>> > > > On Tue, 22 Sep 2026 at 15:55:59 +0100, Will Deacon wrote:
>> > > > > I spoke to Brendan at LPC (?) last year but this doesn't really work
>> > > > > for arm64 because it relies on being able to unmap arbitrary parts of
>> > > > > the linear map, which isn't generally possible unless you force pte-level
>> > > > > mappings for everything, which is prohibitive for perf/power.
>> > > >
>> > > > As per the cover letter it's about allocating pages that are not present
>> > > > in the direct map. This essentially fits the protected DMABufs use-case
>> > > > where we don't want any kernel mapping to exist at any time. Bufers
>> > > > allocated from protected DMABufs are only meant to be accessed by the
>> > > > TEE implementation or HW accelerators like in the secure media pipeline.
>> > >
>> > > That sounds like it should probably build on top of this series, then.
>> >
>> > The main problem I see with this series is it tries to move from the generic
>> > CMA allocator to a reserved FF-A CMA pool which again comes from the
>> > DT. We already support reserved pool allocations via "no-map" which are
>> > discovered dynamically from OP-TEE.
>>
>> I can't think of a way around a DT declaration. We need to know what region is
>> PTE-level before the direct map is installed and of_reserved_mem is very handy
>> for that purpose. And as this PTE-level mapping is costly we certainly only want
>> to enable it for platforms that absolutely need it.
>>

I am rather thinking of a way to turn the default CMA allocator to be
PTE-level mapped. Since the overall idea for this dynamic protected
buffers was to reuse memory efficiently, otherwise the reserved buffer
approach is already there to use as "no-map" via DT.

If we can have "cma_unmap" cmdline option alongside "cma" then it can
turn the existing default CMA allocator to support unmapping buffers.
Not requiring a DT change at all, although we can have the DT property
for the default pool too if platforms want to opt for.

>> >
>> > If we can rather support a generic CMA like allocator for arm64 which
>> > can support unmapped allocations then I am all for it. These platform
>> > specific reserved pools isn't a scalable solution.
>>
>> What do you mean by generic CMA allocator here? An extension to
>> shared-dma-pool? Or having the CMA automatically doing the unmap/map on
>> cma_alloc() cma_release()?
>>
>> Right now I have created an API for the unmapping/remapping part. It adds a
>> burden on the caller, but the alternative solution is introducing post-alloc
>> pre-dealloc callbacks in the CMA, which looked a bit overkilled to me when
>> the users of that "ffa-pool" are only optee and the nvidia video dma-buf heap.
>>

I am not too worried about where the actual implementation lives but
looks like CMA driver to be the better place. I think use-cases like
guest_memfd proposed as a user for __GFP_UNMAPPED on arm64 will also be
looking for this feature.

-Sumit

>>
>> >
>> > > You could allocate the DMABufs from a CMA region that has no linear alias.
>> >
>> > Allocation from generic CMA pool is already the case here:
>> >
>> > tee_shm_alloc_dma_mem() ->
>> >   dma_alloc_pages()
>> >
>> > Do you mean it's just fine to unmap buffers allocated from generic CMA
>> > region since it doesn't have any linear alias?
>> >
>> > >
>> > > > > Vincent's series tackles that by using a pool so that only that part of
>> > > > > memory requires the pte-level mappings in the linear map. That's the
>> > > > > whole point of it, so I don't think it makes sense to drop it in favour
>> > > > > of Brendan's approach (which doesn't work).
>> > > > >
>> > > >
>> > > > For protected DMABufs, we even don't require any pte-level mappings in
>> > > > linear map. The whole idea of mapping and unmapping is just a bottleneck
>> > > > for performance sensitive secure media pipeline use-cases. That's why if
>> > > > we can support __GFP_UNMAPPED with the memory allocator on arm64 would
>> > > > be the best fit for this use-case.
>> > >
>> > > The point is that you will require pte-level mappings for the linear map
>> > > if you want to unmap from it at runtime on arm64. If you don't, then you
>> > > can end up needing to split a block mapping (e.g. pmd-level) when you
>> > > decide to unmap only part of it and there isn't a safe way to do that on
>> > > arm64 without transiently unmapping the entire block, which can lead to
>> > > fatal translation faults during that window.
>> >
>> > I agree with you here, what I am rather trying to find if on arm64 there
>> > is any possibilty to have a generic allocator for unmapped pages. That's
>> > the use-case here as well as what Brendan't patch-set was trying to address.
>> >
>> > >
>> > > > Now the question is why arm64 can't support __GFP_UNMAPPED similar to
>> > > > how Brendan is doing it for x86?
>> > >
>> > > Because arm64 != x86? Presumably x86 doesn't have the strict
>> > > break-before-make requirements we have on arm64.
>> > >
>> >
>> > Sure, sounds like you are eluding to that the generic MM flag
>> > __GFP_UNMAPPED being proposed can't be supported on arm64, right?
>> >
>> > -Sumit
>
>-- 
>Vincent

