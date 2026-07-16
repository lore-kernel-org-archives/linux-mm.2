Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D57C44501
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37D606B0088; Wed, 15 Jul 2026 22:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3560B6B008A; Wed, 15 Jul 2026 22:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225916B008C; Wed, 15 Jul 2026 22:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCF956B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:02:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 686DF1A03A0
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:02:43 +0000 (UTC)
X-FDA: 84992991006.15.C64E37E
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id EE4BE1A0002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:02:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784167361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NKrxc2qShEtKQ/q8p5I5i0ACIp64tOCXWFNOpGJxc6M=;
	b=Aj3kjdV7Hvz5/jJ5XYnUFKuYdz2bhQ7QrSVowaJfkBygoGYXqzBbaRp53drJydwV9R43LD
	n64tjG1w+I3huQ8u4ijUlovzsn7rsDK4bPDTANMEETWZCfrwhp2P9OX1sPa9fyE9Gty5mx
	N1ssfPMXCif7pDzBRfJfrfgjlD77GDY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784167361;
	b=mlh9hIw1jIvBvyNDrXJX3GynRRU5N6mhBFyW+/Vy1SXFbnDJDXShSDjMgRmbcEF04+FhgA
	n49+FQTHX3HM90FVCX3PDZT+nrOv0UqZ4StcoIDm1BnZkwFCDK4oXLo9BnuYKSMaU3rL7R
	pimts7IaQi2fa6kLZ4K2bAUPtR1zCLU=
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.51 with ESMTP; 16 Jul 2026 11:02:36 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 16 Jul 2026 11:02:36 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 16 Jul 2026 11:02:36 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	joshua.hahnjy@gmail.com, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <alg7vOsSVI8CQC3D@yjaykim-PowerEdge-T330>
References: <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
 <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
 <alawYov0c7a0Q6_l@linux.dev>
 <alchYX43oV9KybWx@yjaykim-PowerEdge-T330>
 <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
 <CACePvbVQxvZKa1y4b=mAgdT_uUO=nk4uvuSob3xvW9MZ6OEONg@mail.gmail.com>
 <alfuD8BVdvswr4ch@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alfuD8BVdvswr4ch@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE4BE1A0002
X-Stat-Signature: y3ngbyba7drfdfksa9b7b8uy5dmkq6df
X-HE-Tag: 1784167360-951375
X-HE-Meta: U2FsdGVkX1+ynd2fC1/4+VTUD8chzH+to9X+EQ0q32cqP4lIfaMc5vgkA6IDrmXtuqlNkyHpWg/rA2ZmnDwDCZ9EhKOVVOIU43yEx/NKEI1QW6PbqOXDM67jdREUulk8haijYkuLSnJt5fxkvMR8nxA1OS53+o6HhogGaSEsxPslR6o6I2gTf71ndHNqAiCNKG19doj//YVOERlsORR7RPTC5mhACjCiCfokvmctBARvzSzR7QiGcOK4u+jNVhuqH/amP8e0afzOwR0NRHXaHi2BMG7ZsuBGnz8Yuj8JFFfdvEU1UFVBRzv/YtWqWQxbRnflLPh67TN69Gwo4oW8MoqKJKbfw5LvmlZZuTLO0t+peLAE2O6u08JwfJ0yiN/is0D6u+exWnkxfWvmyVYjLw41gUeTpRYyX0rtatCmL35ahKEDAabCaCAketxwu2+fWBBcnbjsI639fL1innUf5wujyCt3LDAgKQFHlIKLS/7YqSA+P52RdS2ZpLoQY7rsx/kQj2Z3D8Mprla9nGach2neRxSsYpSWFgmz5tS8CXRitajJQzhcZQd2lRk+hcM/+774hTiJBOC6A/rn+4RLtVcWwhU4O+SvtzcJEkaSqI87qrG710/cQmDOlzqYB1hAeBQ3a8xWl7eSXzYbDsqfyJyDgQrF3PxTfPthNw9ISfAuzTaYVJju8sO0zoANyHUjJr0fZ3MkEI94fz5Bihru3fpV16H6GkaxZFtnrXythTLWm5YJGlJdyiAwov7i966GQ9HTf7C6ssDTyUEvBLM6CYWqFnejIuSlEpSlo6k6uXNtv2x5w9yXU5FKH5uPkxlIUpIEd/FWOlBJT427BKgPlWCWdRgroiQEEzfwiQ8k71BnwXIWvNocq7J+Tudk7aL6lQoRBKfClfkI1arPOJoszjEFN1WHc/m83q6yEnkRoV40cUwUEneaBHWL6zOlWlr8oqRKmfIPb3f9MhnKsRb
 6F5UEXWC
 31XahyshCHLb/dH1Nr5f69PLtuW0a+giP+aJOoZCSiF29Eg3WfwkpVnQ+ZuYzBZFRKBIwwOjqM7P+dHsDvCkQRreQv79e1DyLybjasF3duOiq9L8KCj3Pw/gJQJqs/b3klc8Mel+jSv7YYFRcWek69DRIe9v4HDQeV4m3fYl032gRqYqJdGuiEExbA07WiT/CiO6vLnpiG1VRxI0JBkrEqe88Q8vplfnjyokfKSsLkQPjVTYeLH3rWliqLAQdnsAbaqFOGj15dPDDKUPQHC1nUUviwDSQSFoT+vnpOYoFl7M4B/876+gkbYF/63JEFK1ZvR9bcyEFA+C5coM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 01:35:56PM -0700, Shakeel Butt wrote:
> On Wed, Jul 15, 2026 at 10:30:26AM -0700, Chris Li wrote:
> > On Wed, Jul 15, 2026 at 9:27 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > >
> > > On Tue, Jul 14, 2026 at 10:58 PM Youngjun Park <youngjun.park@lge.com> wrote:
> > > >
> > > > On Tue, Jul 14, 2026 at 03:25:40PM -0700, Shakeel Butt wrote:
> > > > > On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> > > > > [...]
> > > > > > >
> > > > > > > Yosry, what is needed to enable zswap as a swap tier? What will be the minimum
> > > > > > > requirements for that?
> > > > > >
> > > > > > From zswap's perspective, we just need to skip zswap is zswap as a
> > > > > > tier is disallowed. Could just be a check in zswap_store() similar to
> > > > > > the check if zswap is enabled. I am assuming that if a swap tier is
> > > > > > disabled, nothing happens to the existing swapped out pages in this
> > > > > > tier, but new pages do not get swapped out to it. This is the same
> > > > > > behavior that happens if zswap is disabled at runtime.
> > > > > >
> > > > > > From the tiering perspective, we need to accept "zswap" as a possible
> > > > > > tier, or maybe creating it as a tier by default if zswap is configured
> > > > > > would be better to avoid handling the case where the user doesn't
> > > > > > create a tier for zswap.
> > > > >
> > > > > Default tier if zswap is configured makes sense. Should zswap be treated as
> > > > > having 32767 (or maybe 32768) as priority as it sits infront of all swap
> > > > > devices today? Also whichever swap tier has priority range containing 32767,
> > > > > will have zswap in it.
> > > >
> > > > Maybe we can handle zswap as an internally reserved tier which is always
> > > > preferred over swap devices.
> > > >
> > > > I do not think there is a strong use case for grouping zswap together with a
> > > > swap device that happens to use the highest priority. Also, using a visible
> > > > priority value for zswap may have a small side effect that one priority value
> > > > effectively becomes unavailable to users.
> > > >
> > > > That said, if zswap is represented as a tier, I agree that it should be the
> > > > top tier. The exact priority value or whether it is internally reserved should
> > > > be adjustable when we implement it.
> > >
> > > Agreed.
> > >
> > > [..]
> > > > I agree this is reasonable. I can treat the demotion/writeback interaction as
> > > > future work and follow up separately.
> > > >
> > > > > Youngjun, what do you think? Is this reasonable amount of additional work or do
> > > > > you envision some complexity here?
> > > >
> > > > I sent a note with some thoughts about making zswap a tier. Since Chris also
> > > > raised concerns around this area, I think it would be better to discuss it a
> > > > bit more and evaluate the details carefully.
> > > >
> > > > At this point, there does not seem to be an immediate use case that requires
> > > > zswap tiering in this series. So my preference is to keep this as future work
> > > > for now, and follow up with an RFC after verifying that introducing zswap as a
> > > > tier on top of this patchset does not cause problems.
> > >
> > > My main concern is locking ourselves into an implementation without
> > > zswap as a tier. One of the appeals of swap tiering to me, from the
> > > zswap side, is eventually unifying zswap writeback as part of a more
> > > general swap demotion, and unifying zswap controls with more general
> > > swap tier controls.
> > 
> > There is nothing locked. The major complexity will come when
> > zswap/vswap/Xswap/ghostswap become independent swap devices for swap
> > tiers. We are not there yet. But if you want a bool for zswap in swap
> > tiers world, we can make it happen trivially.
> 
> Yes please let's do this. Can you also please comment on Youngjun's response at
> https://lore.kernel.org/all/alcebHobUCUyO70k@yjaykim-PowerEdge-T330/ as well?

Hi Shakeel, Chris, and Yosry,

Thanks for the review and replies. It seems we have reached a consensus.

In the next patch series, I will update the swap.tiers.max interface to
allow controlling zswap with 0 or max.

Internally, I will handle it as a not perfect tier. 
Anyway since the user-visible interface is designed with future zswap tiering in mind, 
this approach naturally accommodates future zswap tier integration, while remaining easy to drop 
to make it as a tier if it proves unpromising (remaining this interface only controls zswap on/off).

As a follow-up, we can continue discussing the tiering of zswap, vswap,
Xswap, and ghostswap. If we proceed, making zswap an actual logical tier
entity and organizing its relationship with other interfaces (i.e., complete
tiering) will be deferred to a future patchset.

I will keep you updated if further discussion is needed during implementation.
Please let me know if you have any other feedback!

Thanks,
Youngjun


