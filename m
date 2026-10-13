Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16AD1CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121866B008A; Tue, 13 Oct 2026 05:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084F46B0092; Tue, 13 Oct 2026 05:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F2B6B0096; Tue, 13 Oct 2026 05:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C17776B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:56:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F3221A0402
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:56:41 +0000 (UTC)
X-FDA: 85317148602.09.F43A8F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BC903180002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:56:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FL6bAAK1;
	spf=pass (imf06.hostedemail.com: domain of sumit.garg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791885399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7fj9Vp+tJj7vJqMJATzo0vyG2yGkhzhjEgsT39DDVI=;
	b=xhu7Tv3TUXrtoeFGkXrTuliT4Q7NnfjSk8U3UZ8K6XvIEuDM6HQr8WAVvlHjOYsl9o0/ne
	zFqHM5BRufL7CRGxroVpn/6/08VH2gl3/ErK/8l950/AEmSqArc/ArGsUv2eMrTJU7WH5J
	soPgDPIkf97IH+WqemRvs8qP2wSf0F0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FL6bAAK1;
	spf=pass (imf06.hostedemail.com: domain of sumit.garg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791885399;
	b=s2kzL8b/B91lHVfKmJAEpegVbaf+9x0qyyfabE8+BC2nwmja0KBY2fIl9jv3a6tEQnI/99
	QZJRhfu7NEf32N9aK1ib3u/jMk6WUMOJH5Q3ltGSbBnc+dDNttL2OPXb5fltba1P41YoGn
	rTWdsM6binwwubP2k9l1jEQp6Smo4ms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 433E1600D1;
	Tue, 13 Oct 2026 09:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55F31F000FF;
	Tue, 13 Oct 2026 09:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791885399;
	bh=Q7fj9Vp+tJj7vJqMJATzo0vyG2yGkhzhjEgsT39DDVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FL6bAAK1wmdEJY0kUnZUcDtzMSWohJp9SOCaOF43QWDUhT0/iL+EQrzkosR+1+gbK
	 n3CYnRul7jUIP5IfLrkv+P8pOPh2mpHNS0Uk7wGHOYoV0XS1R0aERG9phPvMAFz/m5
	 QcZdYbCJMmhUbrAflNX57QafmAdlmP34KxetYLnLS9rdkS7h4MXNYvwBtSTDHXg93c
	 LXsP/R+zgGNL6f6XUxUQk4JWLfXvGkhLVMFwJUUaIpFMyzcLic/mA0L8NUYvPS8sHb
	 2QPEtRlQjY4pusEYwNfnlZ8LI5GQyhY4CKycn3vvy+P2KTQn0xXPvmjqDkcMg8QP74
	 qEjGgM633sPKg==
Date: Tue, 13 Oct 2026 15:26:30 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Sumit Garg <sumit.garg@kernel.org>, Will Deacon <will@kernel.org>,
	brendan.jackman@linux.dev, catalin.marinas@arm.com, rppt@kernel.org,
	akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, robh@kernel.org, mark.rutland@arm.com,
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org,
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <as4ATqhp0bPI03PA@sumit-xelite>
References: <20260921110050.3977591-1-vdonnefort@google.com>
 <arIYtjmSKCs14SqO@sumit-xelite>
 <arKW_91EeKA-w96m@willie-the-truck>
 <are21BjeS1O3RYE3@sumit-xelite>
 <aruh86rd5FMv2i9G@willie-the-truck>
 <ar5TPvANFUoosxGW@sumit-xelite>
 <asOAYODGZa-7EIV1@google.com>
 <asOD31rTX6dNfD1o@google.com>
 <aszdnInyJxLhSQRp@sumit-xelite>
 <as3798SFCfKFirag@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <as3798SFCfKFirag@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC903180002
X-Rspam-User: 
X-Stat-Signature: 4busnxcd3juc7ydjr1gtpifrycnoaeob
X-HE-Tag: 1791885399-806002
X-HE-Meta: U2FsdGVkX19RVkNdJfIJVyZeAdStcLS4EtTRsy9ux3YhI/n7mOO2indlbYFc3s6kVEu4z09UKP3HSzM2slVpgQ6cDpeecksGbAf/RNU77e8wMH+oH5xgJdIaIQcTkJtfbpXPLIBa0QF9WpyB0G9q9Srj4PzYBc4B+BKEuJURLDNN3Q08BOx8e/i1JyQvI/I1SgjiW3why0mWMzroXWbWPRLo5qWGJzfhtyO6E3ExzCpYwnUdwcHfmHmMuuvFCf4Dz7jjYgYxKbl4FKG8Frs2KKafmhUMwcNa5cAmMnKDADkqMfwzSsAdnnxj82qWvoH3SbeATSKnzoEgiT3DeD7r/A3xSkU+hVhUFmKEhRKSMF2ieY/mTJ3uLyyyG4yCXuFkK6sa038b/XInaNnxDBgoZtL1XAIzXYVW8CNn95nr6uve6lju5U7zzhZJT94zZzoXTB0RExX7e6VHhVigyVr4RKrumpYDKiEAXwNXz2hpn/vfM+p7uUZCAywkam79vp3mG1ByijQ2jyIcrtTwi7E5r5NDPbmBSfDmYUN//09Jkmb4INDDz57MDFaVuS8Qht+jL39xaa1uNCfFSu5NFHCNu21PpP7QKJgE0YPMhTqmHvYpxjYd+QEkyxLDFRl4kc46Q7Y2YCE9DCHyR9wRx11Ijc3WJZbGRIb75iANm1fPNmARhlvBeCD0CFQgEjnDf9WFCSt30oQRH6Qxka2AwwCrFLrY1QdMtT6wbdKKohfSa0J1wZfIvRLUAskvAWkII3fIda3smz3x5EexoROcE6xy/P9bsVKnYeIrPxaVFFwrwte6PdEIm0uY0uYuviX/5mYop1hB/g4I4OUvIC/XFD7jCD7MdL4fv1ZgjqdrJ5VMGbI81TzCGelhCimljFDsr9EoONMNtOAsvCBGqLzSDNwODck8pUWN/E0UBvGyjebbK2YKYwtFAY+R6+1ys+428jbmJMmo49PJR6pewI2Lkd8
 FeaMRGcy
 pOLl/qK9Fv3fpbvXhtkLzHW8n1lGhXO/qWyxtWerX2D3OUnjWJkAqOerhN2HwFbBWptBpH2Mn3Tt0zYTv9ZKE7gZTsnu1NaTC7MJSsTYgmkbYJ30f8k5QKAZKR4Kf0AWzM1y00UnO14W0vqHqhhV8QzqdNjq/6hM3Sr4EPTeENT/KrSAzIZZa47jKGArNc4J7lQnD+cmucno+wtNcA4DV6JQF+wIfgMdanOzgzQ0sNp1MBzfMag608yfHkM08Blc90qZ1a1SSKvpOJXDdVOt1mKq6pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 at 10:37:59 +0100, Vincent Donnefort wrote:
>On Mon, Oct 12, 2026 at 06:46:12PM +0530, Sumit Garg wrote:
>> On Mon, 05 Oct 2026 at 12:02:55 +0100, Vincent Donnefort wrote:
>> > Sorry, not sure why Sumit's email was dropped...
>>
>> The problem was with my mutt config, it should be fixed now.
>>
>> >
>> > On Mon, Oct 05, 2026 at 11:48:00AM +0100, Vincent Donnefort wrote:
>> > > On Thu, Oct 01, 2026 at 06:04:06PM +0530, Sumit Garg wrote:
>> > > > On Tue, 29 Sep 2026 at 12:33:07 +0100, Will Deacon wrote:
>> > > > > On Sat, Sep 26, 2026 at 05:43:08PM +0530, Sumit Garg wrote:
>> > > > > > Looks like you dropped me from your reply.
>> > > > >
>> > > > > Huh, that's weird. If I hit reply-all ('g') in mutt, it moves the entire
>> > > > > CC list to To: and drops you. I suspect the same thing happened to Thierry
>> > > > > when he replied here:
>> > > > >
>> > > > > https://lore.kernel.org/all/arJcN60nagFKXj2Q@orome/
>> > > > >
>> > > > > I can't figure out why that's happening :/
>> > > > > I manually tried to fix the To: and Cc: lines in this message.
>> > > >
>> > > > Thanks.
>> > > >
>> > > > >
>> > > > > > On Tue, 22 Sep 2026 at 15:55:59 +0100, Will Deacon wrote:
>> > > > > > > I spoke to Brendan at LPC (?) last year but this doesn't really work
>> > > > > > > for arm64 because it relies on being able to unmap arbitrary parts of
>> > > > > > > the linear map, which isn't generally possible unless you force pte-level
>> > > > > > > mappings for everything, which is prohibitive for perf/power.
>> > > > > >
>> > > > > > As per the cover letter it's about allocating pages that are not present
>> > > > > > in the direct map. This essentially fits the protected DMABufs use-case
>> > > > > > where we don't want any kernel mapping to exist at any time. Bufers
>> > > > > > allocated from protected DMABufs are only meant to be accessed by the
>> > > > > > TEE implementation or HW accelerators like in the secure media pipeline.
>> > > > >
>> > > > > That sounds like it should probably build on top of this series, then.
>> > > >
>> > > > The main problem I see with this series is it tries to move from the generic
>> > > > CMA allocator to a reserved FF-A CMA pool which again comes from the
>> > > > DT. We already support reserved pool allocations via "no-map" which are
>> > > > discovered dynamically from OP-TEE.
>> > >
>> > > I can't think of a way around a DT declaration. We need to know what region is
>> > > PTE-level before the direct map is installed and of_reserved_mem is very handy
>> > > for that purpose. And as this PTE-level mapping is costly we certainly only want
>> > > to enable it for platforms that absolutely need it.
>> > >
>>
>> I am rather thinking of a way to turn the default CMA allocator to be
>> PTE-level mapped. Since the overall idea for this dynamic protected
>> buffers was to reuse memory efficiently, otherwise the reserved buffer
>> approach is already there to use as "no-map" via DT.
>
>When the default CMA allocator is setup, it is already too late
>(dma_contiguous_reserve() is called after map_mem()). I am not sure this can be
>reordered easily due to the dependency on dma_limits_init().

Yeah I saw that constraint too, let's leave it for future extension
then although having this reordering dependency fixed will be ideal.

>
>So the only case it would work would be when a reserved memory has set
>"linux,cma-default".
>

Let's rather just turn DT based default CMA pool to support PTE-level
mapping and keep it configurable via Kconfig or cmdline or DT.

-Sumit

>>
>> If we can have "cma_unmap" cmdline option alongside "cma" then it can
>> turn the existing default CMA allocator to support unmapping buffers.
>> Not requiring a DT change at all, although we can have the DT property
>> for the default pool too if platforms want to opt for.
>>
>> > > >
>> > > > If we can rather support a generic CMA like allocator for arm64 which
>> > > > can support unmapped allocations then I am all for it. These platform
>> > > > specific reserved pools isn't a scalable solution.
>> > >
>> > > What do you mean by generic CMA allocator here? An extension to
>> > > shared-dma-pool? Or having the CMA automatically doing the unmap/map on
>> > > cma_alloc() cma_release()?
>> > >
>> > > Right now I have created an API for the unmapping/remapping part. It adds a
>> > > burden on the caller, but the alternative solution is introducing post-alloc
>> > > pre-dealloc callbacks in the CMA, which looked a bit overkilled to me when
>> > > the users of that "ffa-pool" are only optee and the nvidia video dma-buf heap.
>> > >
>>
>> I am not too worried about where the actual implementation lives but
>> looks like CMA driver to be the better place. I think use-cases like
>> guest_memfd proposed as a user for __GFP_UNMAPPED on arm64 will also be
>> looking for this feature.
>>
>> -Sumit
>>
>> > >
>> > > >
>> > > > > You could allocate the DMABufs from a CMA region that has no linear alias.
>> > > >
>> > > > Allocation from generic CMA pool is already the case here:
>> > > >
>> > > > tee_shm_alloc_dma_mem() ->
>> > > >   dma_alloc_pages()
>> > > >
>> > > > Do you mean it's just fine to unmap buffers allocated from generic CMA
>> > > > region since it doesn't have any linear alias?
>> > > >
>> > > > >
>> > > > > > > Vincent's series tackles that by using a pool so that only that part of
>> > > > > > > memory requires the pte-level mappings in the linear map. That's the
>> > > > > > > whole point of it, so I don't think it makes sense to drop it in favour
>> > > > > > > of Brendan's approach (which doesn't work).
>> > > > > > >
>> > > > > >
>> > > > > > For protected DMABufs, we even don't require any pte-level mappings in
>> > > > > > linear map. The whole idea of mapping and unmapping is just a bottleneck
>> > > > > > for performance sensitive secure media pipeline use-cases. That's why if
>> > > > > > we can support __GFP_UNMAPPED with the memory allocator on arm64 would
>> > > > > > be the best fit for this use-case.
>> > > > >
>> > > > > The point is that you will require pte-level mappings for the linear map
>> > > > > if you want to unmap from it at runtime on arm64. If you don't, then you
>> > > > > can end up needing to split a block mapping (e.g. pmd-level) when you
>> > > > > decide to unmap only part of it and there isn't a safe way to do that on
>> > > > > arm64 without transiently unmapping the entire block, which can lead to
>> > > > > fatal translation faults during that window.
>> > > >
>> > > > I agree with you here, what I am rather trying to find if on arm64 there
>> > > > is any possibilty to have a generic allocator for unmapped pages. That's
>> > > > the use-case here as well as what Brendan't patch-set was trying to address.
>> > > >
>> > > > >
>> > > > > > Now the question is why arm64 can't support __GFP_UNMAPPED similar to
>> > > > > > how Brendan is doing it for x86?
>> > > > >
>> > > > > Because arm64 != x86? Presumably x86 doesn't have the strict
>> > > > > break-before-make requirements we have on arm64.
>> > > > >
>> > > >
>> > > > Sure, sounds like you are eluding to that the generic MM flag
>> > > > __GFP_UNMAPPED being proposed can't be supported on arm64, right?
>> > > >
>> > > > -Sumit
>> >
>> > --
>> > Vincent
>

