Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C1BBCA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349DC6B008A; Thu,  1 Oct 2026 08:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA456B008C; Thu,  1 Oct 2026 08:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2114F6B0092; Thu,  1 Oct 2026 08:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E96C46B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:34:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 737381A034F
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:34:18 +0000 (UTC)
X-FDA: 85274000196.15.562F278
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B1A85140002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:34:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=if4SvAJ1;
	spf=pass (imf23.hostedemail.com: domain of sumit.garg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790858056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzSvFLGXXhDhvscc/9MFlHIrUkWd1NO5NFV4BtnVy4A=;
	b=0CNEAnSGfU3J1U3YzbwbNilZPhaxdExty4xu3n6CoV24YXN/whpXEySuAACnhRs8zz9WRZ
	meZ8Ip9lDYLISzzYWN3I6/n0CxkZ7xvqqeVX+5nIQsddQjRd7vhv4qkDNSiprBltzTDsoH
	+yKKkt0y5DDuiVtbkkHbQ7sfAWk6N4w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790858056;
	b=Ws5JsDYQTMz4m8BfFAyHU/8tZqmlQmO1SWO50NDkDGb9NDvRnLcXO2Z/HogmpqdLNL5JJ0
	2+xyMrXzlvtkvgalISDU7BANjLQogFUiD+/beIpfj2xvn5vPsxDk8JkC0Zl3Y/KuXvjZU8
	AwdLKUcr3mWvTaPQLQk3xUKpZEbv++A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=if4SvAJ1;
	spf=pass (imf23.hostedemail.com: domain of sumit.garg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3DEA401C2;
	Thu,  1 Oct 2026 12:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FD81F00898;
	Thu,  1 Oct 2026 12:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790858055;
	bh=PzSvFLGXXhDhvscc/9MFlHIrUkWd1NO5NFV4BtnVy4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=if4SvAJ18eHheJNDIHcxsy7TV/obUhX+e28ofec1ugv6Qzf1xWPauEKNX2d5q4tTp
	 lqIuMR+qdhIvYgLNPo+Xu71RRG2jvwkgCBw9d0spl9LBDZYsQtwcfML4ZVgiSM96eu
	 NziDpTlnYQuD6PZdYxCPJL8kHi9knoo5gRcjO9s2i9wA9xfxVdbp6Yvnr/0AAd0qde
	 D8UclBqsHY5y39KB5plqsT63o4jWH8xj6VEW4Hu89PvcGeID+lsA7y6rvKVYZ9Xbb6
	 3yejC5BjkVY3QrY5fE+q8ahCPjh/bI+RcEG2FarJLbEFB9YnZ35RB5mMH9dP/3yAwJ
	 NiIHnfgpTOdfw==
Date: Thu, 1 Oct 2026 18:04:06 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: brendan.jackman@linux.dev, Vincent Donnefort <vdonnefort@google.com>,
	catalin.marinas@arm.com, rppt@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, ardb@kernel.org, thierry.reding@kernel.org,
	david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <ar5TPvANFUoosxGW@sumit-xelite>
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
 <are21BjeS1O3RYE3@sumit-xelite>
 <aruh86rd5FMv2i9G@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aruh86rd5FMv2i9G@willie-the-truck>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B1A85140002
X-Stat-Signature: dqjd8d39gnbnyf9ama6tm7w37fyxwhx8
X-Rspam-User: 
X-HE-Tag: 1790858056-283283
X-HE-Meta: U2FsdGVkX18bLTw5r7l/GR8nW+9b2spMoLaREiiHQgAKEobHFszZ7X5qykJR6+M+N5ll6ds2YOdXLirdgjQVHAXyyXRBQgnSwyFTfoJtLJm0UXF+khZyxOSMXP1kDQ8papXRfsRNl+rKhuUp/OqwziN12/hja7O8UyQRQeJN4F6AjtBTWv5hdz4haSdbx79aqlAl0SsXn/Ybw/F05Ys0CixlXXGmlYk773kNjnv9W/5JDy5GfjxGovijc1+fuyyFR+2/oQBFY8k09fNfR7irkmob4cF1t9VXReopFJmRaOHANFy0rq5/9YSSzCQhtSm1Zv6C+uKE0Byw+YuR/UR+t1D4lPS+QSjcF3x4SNPlNjpfJl1loILmgClpxU9DXFgKxw0z3ES8iFLWONhggKNv43mNpJJuDA4nowdYkXS+imXHqRx1XdmykanJQeq5B9e7OmM9zI+dokkULm0Lhq9oq5lDs1W+73PfaV8i2oVzVyYI4Y0aGpIHjKx87j0k4Gay8qrGQqdie4UPvonRiLXE9z1y3oozbFbaSheFmSfF5Ikm0WJGQS9+EG4kNJt96RO0o5g4ywlphrcmvdjWEgC5aUOsx1vby4ug9M5CT+3ijtDYdbHpChZJRcT1qd0vjvxi0XJkcHX3i9ddl/lGZyMKhbf1QoJLR9YlwyftN7Bt2YZkZxP+iiYDIVP4BGrq3K0SByvt54qPvIettlpoqcZ1F3xg8xXMO5DsVBevFSY41ukmupAMSYbQicQOifjFlitkeh8GG5U2T4a+UNE2wCrLJQfbzKYQjSYUoYNe0uuruqLDGhtYKb4vdUHY0+JvKLNAEXo699YThfpRx1BIstdOcV5p0UEQ5D3DghviHEH8bqDybV2MkP3zYDJlTOCeeSulOUBg7A4dho9QRzXMN8xHAMetg8hws7JlsubPqNl0Qmpmj8pcnLAQtZkcIcTAamQ1ZRs6PekOah8fzedWkwx
 zS0YsS3S
 eMUA+4Dgnjos71f9IoemzaJgZ87lee8qzK1lXkQ3pkgYmIVTu1ywoWy0y0m88S/050soWP2D/GCpsIphdgtK+UT91OqN2XBLS7WDuH3VWHxpuR0nMvF03VNBYbRCbAz/Vw+fE3P5U5+zWg1+j9o+1KAw+dPThAGteFMrdBWj7TQsboT3TryuYYz0RKe7tv/JNNXuU4ccKswKL1+burivXFOPcgANpcHFuaeScGRZMWOJMZZX76jF1MWNb0lcpaZ1pfOBd+wFy+hvarGkOMfBxiOvMoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 at 12:33:07 +0100, Will Deacon wrote:
>On Sat, Sep 26, 2026 at 05:43:08PM +0530, Sumit Garg wrote:
>> Looks like you dropped me from your reply.
>
>Huh, that's weird. If I hit reply-all ('g') in mutt, it moves the entire
>CC list to To: and drops you. I suspect the same thing happened to Thierry
>when he replied here:
>
>https://lore.kernel.org/all/arJcN60nagFKXj2Q@orome/
>
>I can't figure out why that's happening :/
>I manually tried to fix the To: and Cc: lines in this message.

Thanks.

>
>> On Tue, 22 Sep 2026 at 15:55:59 +0100, Will Deacon wrote:
>> > I spoke to Brendan at LPC (?) last year but this doesn't really work
>> > for arm64 because it relies on being able to unmap arbitrary parts of
>> > the linear map, which isn't generally possible unless you force pte-level
>> > mappings for everything, which is prohibitive for perf/power.
>>
>> As per the cover letter it's about allocating pages that are not present
>> in the direct map. This essentially fits the protected DMABufs use-case
>> where we don't want any kernel mapping to exist at any time. Bufers
>> allocated from protected DMABufs are only meant to be accessed by the
>> TEE implementation or HW accelerators like in the secure media pipeline.
>
>That sounds like it should probably build on top of this series, then.

The main problem I see with this series is it tries to move from the generic
CMA allocator to a reserved FF-A CMA pool which again comes from the
DT. We already support reserved pool allocations via "no-map" which are
discovered dynamically from OP-TEE.

If we can rather support a generic CMA like allocator for arm64 which
can support unmapped allocations then I am all for it. These platform
specific reserved pools isn't a scalable solution.

>You could allocate the DMABufs from a CMA region that has no linear alias.

Allocation from generic CMA pool is already the case here:

tee_shm_alloc_dma_mem() ->
   dma_alloc_pages()

Do you mean it's just fine to unmap buffers allocated from generic CMA
region since it doesn't have any linear alias?

>
>> > Vincent's series tackles that by using a pool so that only that part of
>> > memory requires the pte-level mappings in the linear map. That's the
>> > whole point of it, so I don't think it makes sense to drop it in favour
>> > of Brendan's approach (which doesn't work).
>> >
>>
>> For protected DMABufs, we even don't require any pte-level mappings in
>> linear map. The whole idea of mapping and unmapping is just a bottleneck
>> for performance sensitive secure media pipeline use-cases. That's why if
>> we can support __GFP_UNMAPPED with the memory allocator on arm64 would
>> be the best fit for this use-case.
>
>The point is that you will require pte-level mappings for the linear map
>if you want to unmap from it at runtime on arm64. If you don't, then you
>can end up needing to split a block mapping (e.g. pmd-level) when you
>decide to unmap only part of it and there isn't a safe way to do that on
>arm64 without transiently unmapping the entire block, which can lead to
>fatal translation faults during that window.

I agree with you here, what I am rather trying to find if on arm64 there
is any possibilty to have a generic allocator for unmapped pages. That's
the use-case here as well as what Brendan't patch-set was trying to address.

>
>> Now the question is why arm64 can't support __GFP_UNMAPPED similar to
>> how Brendan is doing it for x86?
>
>Because arm64 != x86? Presumably x86 doesn't have the strict
>break-before-make requirements we have on arm64.
>

Sure, sounds like you are eluding to that the generic MM flag
__GFP_UNMAPPED being proposed can't be supported on arm64, right?

-Sumit

