Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6611FEEF317
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 08:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846476B0088; Thu,  5 Mar 2026 03:09:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8172B6B0089; Thu,  5 Mar 2026 03:09:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723286B008A; Thu,  5 Mar 2026 03:09:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0046B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:09:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFBEE5B796
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:09:28 +0000 (UTC)
X-FDA: 84511284816.19.FB96DDC
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf12.hostedemail.com (Postfix) with ESMTP id 791E74000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:09:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772698167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QiPCcg9n/wfoC+TO7n1mXUctRMg1CgTepXBayIIfz8Y=;
	b=E63VvHjmeV2/6L1XxnZsy4o0d+atGqNZlozinDQHvSOpLp/C7wyc2OIjxKRNtV8Q5P1qbG
	uL5wJfaMkIy4XeWxF3tpd28h0HlmT2JAxCEL/nZGlYyABiNPex2vtxynPhtdzvkDyCk+Vi
	9u+3Gmfe3/V8285EErP6y3ORvWl33O0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772698167; a=rsa-sha256;
	cv=none;
	b=tYYzWpmVoGRbfw7tYMBKXEUHdhsfQvs/rL6HGQcJsAqHq7Dn4M0DLiRk6F4kK6kBWMJi3/
	xUwLjLfwQ4zldbDu4MraWiXgdi01xnZuGCPcvW1/odvaBnvn9vkiBaciJwOvRM7LF3bmH4
	7RxrFtygXO+jx7DeQHwSWMK7se+ZAt4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 5 Mar 2026 17:09:23 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 5 Mar 2026 17:09:22 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baohua@kernel.org
Subject: Re: [PATCH 0/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aak6MhtSxqPaTBkr@yjaykim-PowerEdge-T330>
References: <20260302104016.163542-1-bhe@redhat.com>
 <aaWiBaeSCILBCzqd@yjaykim-PowerEdge-T330>
 <aakSI_0O0G6arjZO@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aakSI_0O0G6arjZO@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 791E74000B
X-Stat-Signature: kg7trgmxmdqkxw61s1npsua9q3joo8o8
X-Rspam-User: 
X-HE-Tag: 1772698166-101117
X-HE-Meta: U2FsdGVkX1+dmTO9pVHNgu+PCfMa9NTPaiH9uUov13uMJ5IR1kuFx/PxuiqiN1kWdtqAEpzh4JqZwO9lVa/7RWvi0yhiwFr3R3lHldbVKxpVj4DzEA871uP008EIIk2MbdUWUjI/xasokbloK6nmZQd9WCLbMY2Z667PTT7dzYq9JA5IwSpnYZ6LOnGYUr2yKgZNmDHBl8bEVAW//7g3OiMaqI3jZ1UQZUwJuM8TquxHoRhCxM8Jbs9y0gDEqiMZ/j8bS6+opbPCywzlBjyeG2yNF8/b7LKQX/avmnn3upCT5L+q0ghe9mpw//A+yFYdPaCiFckyKlH4Sn2idlccTQddeHBK/ZuGC7S2jcSF3i7/sBE/Ud/ZdKD5nnu6wXDrYirr6ujc6IaNv4zRyrpN4CikMBp5v1NGrOhPmaJ6i7s2hkpcFI32Tghld8hed094OW0cqa6tyFm1k9VBwZr6r0EHohLZoMsuhdKiG3fv2Herz38yh518yzuYW/A/EONNxvi48ji/4rvThdHNqBWPJGA64D8F+qPNulQtpvSMvRHR9oz0U5mTKHEzc3T+oK4+azyHlaYNBGMcPEeDziJZWnugf5ddcwvgAuMHFTNcvOd5gaEhITSSk4Eye/aasOeQ1+B6FeTYMunKkl/1QOcmEbFzXTu82ll+357pAw/0bZscOZdf0LJBQ/9HQWzBLnroa2XVF/R3KEs1oXgm9ebJ/Sr43byX8hjQnoxHWTlsYb/zHepUvRFz1Kl8OH8XQLA203diwzDLMMDK6mXYLWti68hqxpJjTpOd/30wOVT7vw1/4u8cnwUbTYs9G2jpnyWEhHSmoPyjdEnUTXwrGeTRi2iGjnhW50NhDzI5teyVy0D1n64leW/NGm5odELeMBPlmOLNQn85UsEcZMXE54Uyo/SWSFvHqKvd+KnVgPRzhtoe/fVmjoOasoI9KOVRLI+8sKV+fSywPKMpbYVyri4
 3iLHNzyF
 LWBFaYMfszk425wiOxPbIJsgP8URvwRSAdeKq2j4rq7mt6b/9y2m/Hr4I2F+LiAyFTZaxBMk/cMgtu9SQEQSZtCX4id69fjVGhAckZPxFwpVR3fNx3aWu0j3bg6+MXdmIXDPNU9D5cp6kdPmZPiVXUpu5/dZQdnZvkocKnlKwwOHQkSY7h7YdfNed3xkUC+uYD57y+Gxero+w/Jaj4ogARBz9eu9zkONhPM0X1VTfiuCXwxqIsrQhJecb3DTEpep25MXj9XReMh1pU9ECyNyY8y1Cka7FRiVO7Af2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 01:18:27PM +0800, Baoquan He wrote:
> On 03/02/26 at 11:43pm, YoungJun Park wrote:
> > On Mon, Mar 02, 2026 at 06:40:13PM +0800, Baoquan He wrote:
> > > This can simplify the code logic and benefit any new type of swap device
> > > added later.
> > > 
> > > And also do renaming in this patchset:
> > > -------
> > >    file renaming:
> > >    ---
> > >    mm/page_io.c to mm/swap_io.c
> > > 
> > >    function renaming:
> > >    ---
> > >    swap_writepage_* to swap_write_folio_* in file mm/swap_io.c 
> > > 
> > > 
> > > Baoquan He (3):
> > >   mm/swap: rename mm/page_io.c to mm/swap_io.c
> > >   mm/swap: use swap_ops to register swap device's methods
> > >   mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
> > > 
> > >  MAINTAINERS                 |   2 +-
> > >  include/linux/swap.h        |  13 +++++
> > >  mm/Makefile                 |   2 +-
> > >  mm/swap.h                   |   3 +-
> > >  mm/{page_io.c => swap_io.c} | 104 +++++++++++++++++++++---------------
> > >  mm/swapfile.c               |   2 +
> > >  mm/zswap.c                  |   3 +-
> > >  7 files changed, 80 insertions(+), 49 deletions(-)
> > >  rename mm/{page_io.c => swap_io.c} (91%)
> > > 
> > > -- 
> > > 2.52.0
> > 
> > Hi Baoquan,
> > 
> > Thank you for the swap_ops infrastructure patch. This is very
> > relevant to our flash swap work, and I believe it could
> > significantly help with our future contributions if the framework
> > is extended further.
> > 
> > As I understand it, the current patch serves as a foundation for
> > future infrastructure. However, from our perspective, the swap ops
> > are currently configured statically, and we would need a way to
> > apply or register custom ops for our use case.
> 
> Thanks a lot for your input about the future potential use cases of
> swap_ops, they are very valuable.
> Yes, this patchset is posted as a infrastructure of swap_ops and a
> thread where we collect any potential extention or use case. The
> change is made based on the current kernel.

I understand. I brought up suggestions 1 and 2 because they are necessary
from the perspective of immediate application. :D

> > 
> > I have a few suggestions (mixed with questions) regarding
> > extensibility.
> > 
> > 1) Could the ops be replaced at activation time, similar to how
> >    SWP_FS_OPS works — i.e., giving block device drivers an
> >    opportunity to override the ops when the swap device is
> >    activated?
> > 
> >    This would allow block devices to handle swap read/write
> >    through swap_ops rather than doing it in submit_bio, which
> >    feels more generalized and leaves room for future extension.
> > 
> >    This direction would be the best fit for our use case.
> >    However, considering ongoing swap work that may involve
> >    managing multiple swap devices, I wonder whether binding ops
> >    to a single block device would still be appropriate in that
> >    scenario.
> 
> I think it's doable and make swap_ops more flexible and versatile to
> support different swap back ends.
> 
> As for binding ops to a swap devices conflicting with managing multiple
> swap devices, I may not get your point very clearly. Could you give a
> concrete use case to demonstrate?

To clarify my point about binding ops: I was focusing on the initialization
timing. Taking SWP_FS_OPS as an example, setup_swap_extents calls
swap_activate and finally SWP_FS_OPS is set by filesystem.

Similarly, I am suggesting a mechanism that gives the block device (or
another entity) an opportunity to register its specific swap_ops during the
swapon phase by calling some kind of swap_active callback.
(And it may be not the block device as well?)

> > 
> > 2) Would it be possible to defer swap device activation via a
> >    lazy registration interface, so that the ops can be registered
> >    before the device is fully activated?
> > 
> >    This would open the door for entities other than block
> >    devices — such as kernel modules or other forms — to act as
> >    swap backends. (Of course, block devices could also benefit
> >    from this path.)
> 
> Yes, I think it's doable. I will make change and send a draft to you for 
> evaluation. By the way, do you have actual use case in which deferring
> swap activation is needed for justification?

Regarding the use case for deferred activation: This becomes necessary if
we don't use the activation-time binding mentioned in #1.

If we rely on dynamic registration, there is a time window between swapon
and the actual registration of the ops. During this window, the swap device
should not perform I/O since the ops aren't set yet. A lazy registration or
deferred activation mechanism would handle this safety gap.

> > 
> > 3) Alternatively, are there any plans for a static binding
> >    mechanism, or any other extensibility approach you have in
> >    mind?

> How the swap back end was chosen. We can make it a swap mount option.
> We make the swapfile header look like a file system super block. The
> different swapfile header contains different back end types and
> options.

I found your comment about ops binding on LSF/MM/BPF suggestion. sorry for missing.
Okay, I see. While I personally prefer the direction similar to SWP_FS_OPS infrastructure(or #2), 
the mount option or header approach is also a valid path!

> > As an additional thought, if this ops framework could eventually
> > be extended to cover cluster allocation as well, it might enable
> > a model where base swap functionality is provided by the core,
> > while each vendor can freely plug in their own additional use
> > cases on top — making the swap device truly extensible.
> 
> Yes, this is planned task as I have mentioned in the LSF/MM topic mail.

It is great to hear that custom cluster allocation is planned. this would allow 
vendors to implement optimizations specific to
their swap I look forward to that and will provide comments if we have
concrete use cases.

Thanks a lot for your work
Youngjun Park

