Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D70CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 08:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D16E6B0093; Sat,  3 Oct 2026 04:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B906B0095; Sat,  3 Oct 2026 04:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023766B0096; Sat,  3 Oct 2026 04:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFBA56B0093
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 04:04:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3314A1608D9
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:04:36 +0000 (UTC)
X-FDA: 85280578152.16.7360B59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 75338180003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:04:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JGioztog;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791014674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZ1ACE1iiEOWgp7+NtU6aPFkdBsKv+iKHALcIjSYOOI=;
	b=DkUuIJZyrROHqf1BfrOPWC74fBN9AauzN1b/6Whw8+K8a95TVmQTdShbvFW1CsLY3Wh8m1
	jaSulLwbHvKw/rNFxNFKM+M5eeng8D0XnSIbcUcYyUlYXHi7SNr2bpyobLXLVTyZ/NzqBl
	r8Lw5djAWfr8BM4a/DYPiVn3pPfHjGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791014674;
	b=lwPxI6HojgDo9yXO+gFFiiSHX5otKn/aic3acR/L4WpzQnxtmaxcn/VQZ5b2wLSJYoQm4R
	PwGvZfcmV8rNz2cN3eQFU30+JEbAmQEWUFxg5zjSFgWze58chb3VpNPutXkjqCy6m4iVlz
	1m5hcvqRebRLBZzCjWauX3fmEcnE8ZE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JGioztog;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A38943E63;
	Sat,  3 Oct 2026 08:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415811F0089B;
	Sat,  3 Oct 2026 08:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791014673;
	bh=XZ1ACE1iiEOWgp7+NtU6aPFkdBsKv+iKHALcIjSYOOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JGioztogeXvRuQANr3O6EblEFmnhMq/cfk4R+zBZ7mmMqJ6WjV1S4LSyRx8zonfuM
	 SX5NOZeWDwA4ynSw9lYh8DzyDSjzPZQpXKMIc3SRtAdLKbJWtbDAewwCJ1BwzGSAt5
	 k/wbSzi3cQuIf9ofHrBzAkLoScfp1WAdQE1bsEMnaed/4uPubDR6QrgYqJ5PnW+7SF
	 RprAMopotlmIiH8/INHpzGgZsgseVHmlKBoJ17PUHqPrmN9dw2yYu6fnElZJm3drDT
	 YpPk794DCCKAs0T9wXridN3r72p/L93oso82oTxJpleKZbCwTZC0llZK3aS4y0Xy+S
	 8eLwU5at7RJXw==
Date: Sat, 3 Oct 2026 10:04:28 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Wandun <chenwandun1@gmail.com>
Cc: robh@kernel.org, saravanak@kernel.org, m.szyprowski@samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH v3 0/5] of: reserved_mem: several fixes about reserved
 memory
Message-ID: <asC3DBvtlcO5AVsz@kernel.org>
References: <20260920092852.614973-1-chenwandun1@gmail.com>
 <arJA6fOMetzoBhDH@kernel.org>
 <060fb694-ba1d-40e7-8a18-f32d5a4039ab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <060fb694-ba1d-40e7-8a18-f32d5a4039ab@gmail.com>
X-Rspam-User: 
X-Stat-Signature: n46omhej5u8a514no7ozpq6yobbsoybk
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 75338180003
X-HE-Tag: 1791014674-131310
X-HE-Meta: U2FsdGVkX19HA2Kxp9eICcQJQEo3Fyj+CSzx4V7TI7vwki+8DHYEHrrC5RVADv+rTdm7mi5JOP5Mcd/CwYAcZZU3gVZ8mjruwtXwOU4143VW8zifUngDArcknZ8PWsggEITIopqSM7LsdOqeO4uTHpTL6Y0CDnN2SebGCCof+PGeVeY9odLLObKdCbNJP/V167evD35u6UVoHxFZ4tmOFq+ydeVyCtHuMzL8bDxZ8zNzBCGiB4uh/eeZ4zqnRcIyRNihpTfPM5l0MsKMMp83JjiSqhX2F3QFkybQiVA0BKgo/jVU9ZbrX5xhpAYsoFUC+hK7OUP8ivIeZidwAf4l1Kw6RSM4cViZYcXIc+1BBRzmAlfHKdRyNIz5BMk2TrOhaP5TYtREp10DoKCwKthrEjnJLSwB5lVBDc6KDXqCefZl5NT+w/52f8ycg5XP+qPsHxV2VsAT3zdlXv9UhKnx4vWwTuYPOX0CFQ4k5SaWoxN5TNBpTUivR8t+amyv14enRfAhmtVFrz+j6aiX60bFScA2CG/kDpUSBcPlALmO2VlU34Fhh+PjOVwo2Y0KWwiYiJZLFcTlZWRs5z5aYDPSw2kdBIQ+ZuBne2tpv5jKE6g4edh8QmIBWxtX+Joc3CFzqKIVKvekfdsDHiwm2+Q8ldny06mefyPtLK/JVU8Rqeze1ontuYobRrcjMIupsGgA7tdlYsRAIcjrL4S5ZH8+foiEqtV8HoJOlTxAT7vSBxHpnBiGXBm3bd29O86qqB+93LFHAuNeUrUUnLweDNQ+juR1fO+mHTi5kJMCL6oYhM1t55Ss9S+7PMIAni+vzENveewLMy/s2oF9kPJtygaxrIS1D6sta89dpeEMTAY5yrfPPyFjJV0uDbG0kYjjyPLRhoedgUtlgwikJX9j++p9V9auLE6VxFpXDvcJA8E5WUO0CjdZ2whHXuM+OKgHzs7Spadxv/VqbHToQWEX6D2
 IiRN0fqa
 wJ86da16x/mbRcHoL4RBciqyJ0RfaDWBJDIeAa4QHGLM4WxrAAr75Fvq0V96VZM54K4YDkabcUxQrVG/l5H1yprN5HPP480PI6e+9FaH2IoKXxPFcn14VNIbNgfo8sg4XfxI23qQR1GNw4GMQ0qSFENozLtAqh2VoVqqWSjI3O9tNgdez8qW2DsI9CEzgKjb1OaNztEYQu18duT2xQkLaH2LuPMxVqvIzbKM8FvjuW1+tMtRaN0aMbFKa1G6FGxHbxv4KO4hr4R/3tfE6ZX7nywjHJzFMnlDkUnanZ5Z+OvaZFtLwobzL9dcxE0czXBEL4Es8mfm9lDSa+GVoM/Z+KaxxxqqokfvwIqv8D3F0QEY/iwL1v7h/Uwccwx8mSJTcT0W9TxiLbrKczyoH15swzOfvHQ2ieS/FNS08R1KAIT1+p+M0XcvINTLwlvwZJ1Cbekk8fSWueuHt8i8fKTKuZsb+LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 05:24:32PM +0800, Wandun wrote:
> 
> 
> On 9/22/26 16:48, Mike Rapoport wrote:
> > On Sun, Sep 20, 2026 at 05:28:47PM +0800, Wandun Chen wrote:
> >> From: Wandun Chen <chenwandun@lixiang.com>
> >>
> >> This series fixes several error-handling issues in the reserved-memory
> >> initialization paths.
> >>
> >> The first two patches fix cleanup of no-map regions after driver
> >> initialization failure.
> >>
> >> Static reserved-memory nodes are reserved during the early DT scan but
> >> initialized later. The third patch tags regions whose early reservation
> >> succeeded, so the late scan can skip the nodes whose early reservation
> >> failed.
> >>
> >> The last two patches reject overlapping static regions. Without
> >> these checks, overlapping nodes can be initialized over the same
> >> physical memory, result in data corrupt.
> >>
> >> Sashiko reported these issues in [1] [2] [3].
> >>
> >> [1] https://sashiko.dev/#/message/20260814090305.4C8741F00A3D%40smtp.kernel.org
> >> [2] https://sashiko.dev/#/message/20260814084718.29C341F000E9%40smtp.kernel.org
> >> [3] https://sashiko.dev/#/message/20260806100605.2C2C01F000E9%40smtp.kernel.org
> >>
> >> v2 --> v3:
> >> 1. Rework the mechanism that checks in the late scan whether the early
> >>    reservation succeeded (patches 3-5, suggested by Marek, thanks).
> >>
> >>    Patch 3 adds a new memblock flag MEMBLOCK_RSRV_RMEM, which is set when
> >>    the early reservation of a static region succeeds and checked in the
> >>    late scan.
> > 
> > Can we keep this local to of_reserved_mem please?
> 
> Probably not. I do not see a way to keep this entirely local to
> of_reserved_mem while handling the issue robustly.
> 
> I previously implemented an approach in of_reserved_mem that records
> static reserved-memory nodes whose early reservation failed in a local
> array [1]. However, the early scan runs before paging_init(), so the array
> cannot be dynamically expanded. If the number of failed nodes exceeds
> the array size, some failures cannot be recorded and the issue remains,
> and that is why Marek said "partial solution", although in practice
> having that many failed nodes is unlikely.

Even before paging_init() there is memblock_alloc().

> To handle this robustly, the late scan needs a way to determine whether
> the corresponding early reservation actually succeeded. Current approach
> uses memblock to retain that state.

I can't say I like the idea of keeping this state in memblock.
This add flags and code to memblock to deal with corner cases of bad
firmware that reports weird memory layouts, and once there is a flag in
the common infrastructure, people tend to abuse it.
 
> 
> [1] https://lore.kernel.org/lkml/20260818092420.2859026-1-chenwandun1@gmail.com/
> 
> 
> Best regards,
> Wandun
> 
> >  
> >>    Patches 4 and 5 are reworked to reject regions that overlap or are
> >>    contained by an existing reservation. The code makes a little different
> >>    from what was acked in v2, so the Acked-by tags for these patches are not
> >>    carried over.
> >>
> >> 2. Reorder the patches: the two cleanup fixes in v2 now come first.
> >>    In v3, the first patch now introduces the 'dynamic' distinction in
> >>    fdt_init_reserved_mem_node(), which the following patche 3 build on,
> >>    so the series reads more fluently.
> >>
> >> v1 --> v2:
> >> 1. Rework failed-node tracking in patch 1: do not track zero-sized nodes,
> >>    and keep a reserved_mem slot when tracking overflows.
> >> 2. Reject static reserved regions overlapping existing no-map regions.
> >> 3. Keep MEMBLOCK_NOMAP flag for static no-map regions when init failure.
> >>
> >>
> >> Wandun Chen (5):
> >>   of: reserved_mem: release dynamically allocated no-map region on init
> >>     failure
> >>   of: reserved_mem: retain static no-map memory on init failure
> >>   of: reserved_mem: skip init for regions whose early reservation failed
> >>   of: reserved_mem: reject static regions overlapping no-map memory
> >>   of: reserved_mem: reject static mapped regions overlapping existing
> >>     reservations
> >>
> >>  drivers/of/of_reserved_mem.c | 86 +++++++++++++++++++++++++-------
> >>  include/linux/memblock.h     |  7 +++
> >>  mm/memblock.c                | 95 ++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 170 insertions(+), 18 deletions(-)
> >>
> >> -- 
> >> 2.43.0
> >>
> > 
> 

-- 
Sincerely yours,
Mike.

