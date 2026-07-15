Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A50C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 20:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3EF86B0088; Wed, 15 Jul 2026 16:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFC46B008A; Wed, 15 Jul 2026 16:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9057C6B008C; Wed, 15 Jul 2026 16:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 531916B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:36:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C626CA024A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 20:36:24 +0000 (UTC)
X-FDA: 84992168688.08.878031C
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 18DF64000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 20:36:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NDaqQ0cu;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784147783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mo3OtT6Wk9vIr43G06ljgu1nSIzxYDl9BQZisg9bu58=;
	b=8IrbfOrSgz4NyiMgR69XHC5yqpR2IZ1w4O6OiURJPTeNTkBI9b783zSpfvaJ/YoeR6sLjv
	dhaVnWdVQ+Qybd+s488kjE1L1mZvcP/HCVkdHirwg5lSZ664SUiuK3lc9XmQ1zE+CFnBpz
	G1MMEzZqHoQxMoA2dMyoXW9DnBNIffc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784147783;
	b=FTMWv6XpFZHTzObHVU7rpPKvMlPdNxSR86ABxyzXOD2boxr5A92fzINOrO2mvSiTDhJDsW
	sRweXHIMGK7Ryq0HT+TkMHbRYFEB2fBClzPYFreipd3fpywJbVHZM4F1j1nxoOXnGhULM7
	cCWn+0ycDykyJ4wo6iIwD8Yt/5m25F8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NDaqQ0cu;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 15 Jul 2026 13:35:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784147777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mo3OtT6Wk9vIr43G06ljgu1nSIzxYDl9BQZisg9bu58=;
	b=NDaqQ0cuaRwXU76Il3raLdJi4qiC6OqzUb2UO3fPbucggNWoFdggpf+GH3YtwgJcGTPRTI
	BpKLlswF8rIWD8MGIPIcUNKdvglsG1hUA12eeO6JfKinOcbtnnj4FkEYx3A/SWTPjnGtkS
	LEjaZ19YzZDSwi5TlJJCdPW3N76X13U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosry@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <alfuD8BVdvswr4ch@linux.dev>
References: <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
 <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
 <alawYov0c7a0Q6_l@linux.dev>
 <alchYX43oV9KybWx@yjaykim-PowerEdge-T330>
 <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
 <CACePvbVQxvZKa1y4b=mAgdT_uUO=nk4uvuSob3xvW9MZ6OEONg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVQxvZKa1y4b=mAgdT_uUO=nk4uvuSob3xvW9MZ6OEONg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18DF64000F
X-Stat-Signature: kphrbe9grbxyqzdf4ky3et8gbsd4eda6
X-HE-Tag: 1784147780-799959
X-HE-Meta: U2FsdGVkX185rI+ykJJ+cx8b3SGe7lJiE5+qHGTwAB+Th00cqa4w4a1MsWmFabyrXDwi/pDNt4C5QXdd8iRF0D/jcBCjkeGgpEh/W7OWj2Sg4+2nzooTtQ2/u80ll0EPOHlpOX1e4SlwvsQBVftniPn53qwrAUYPJhrG7ht54L+cTyX+AH9uZ9NYThm7x7B4B081hoyqMCy8gouBXVOB8014KHXggbCogHxL8km2mB8yP+ZPQz2dZKX6pA479N7Ety+/LFSy8Z6yITyujOMsCCoq5UgPkgTCOwUmqKCy4ephJWkih+9iovhVmi2Zr1aa5lyObOD/hPOB3axWhXJz8srJR970YPBRwuLceJ4/wRPrNx4+ohmCtTaI0iUK0cOVLT0Y2f5wlyKxWhM2bIwhQUGS6LlbhOtuGOA9QxSzjeQne02J0lFztWiII8O4t2pIaoig3nNthgSTbPxmuZXdciVJgmV/CPr1c3tv8HtNqkCS3ktT0MDlsY5qBom3k9DtRKgF46F8LFyS4xaCAoe+rUSL7gxNm1Ng+60do+tuWvOV34DN1BURucikiPux2y845+J83zUbDk58bhN3whTQbIpY+xrVhQWl0CQdkNL5IMhcv7LlRBRxqnZ4CKM/mtW8bPsYu2vbzeOWyPaq6e7S/F9etprKnhNunJV5o3Ysm6shDPksikxWSDV12/F6MxY/I7QwB64XbHBJbxqCRwNRm3Iagv6BORyIEwPy++a9NbT0mIqZ+mjg6wjNh09JDqED45yxHuhaV6X3BK7nEBalgM7XYohNKHF7w8d9hJjipN3cdoUXqWoCckFI4giUsV5pqvDM/UZv/4OhAbdUUX4e2juI1i1m/tJ6o/AVrIpF0uB0tk0vKFQ6MYfMW3RdUKvdGnYbmxbjZRmPUNj8DvE0V8kBjPgw0nbTAfxYKfVz29ViVHsaHOOgBGALeZbn5FHVv6BRXXaiYbA9wrzudmQ
 aEqIdws4
 xAiHzIs1ln47W6nAkiAvLfwNVMbbdzLEJB7gpm4nZciB9Nyk8AEoUNyrxHN/jmVRLa1o5N8K/SqRSnrnmDkRSFE2nuSTqeGkIhvzWlqC7sUmy+5aeyz5D7DRDvC5uy/1ZboK+cEbo9EHQhj7JB3bWVDioUZ+rMLmhB6qrnT+oDRW7umoa5s0yWKvkJDcO24aYJl+vuCXLWkB9cK/uEnR4wP0DGmJnrMYtD1DJ5JcMweqTsRsSLEcs4PATBwv5LASFyiajMQ0+4/XbdI62vIomoR07RiDdUcy2sb55GpLHIqztBGIIBRuBeMsX1Xjlq5Qzh1NGD0eUFUhW8E8k/nSwH+E3ovRp4mGormZ+4Lz6C56ZlkU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 10:30:26AM -0700, Chris Li wrote:
> On Wed, Jul 15, 2026 at 9:27 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Tue, Jul 14, 2026 at 10:58 PM Youngjun Park <youngjun.park@lge.com> wrote:
> > >
> > > On Tue, Jul 14, 2026 at 03:25:40PM -0700, Shakeel Butt wrote:
> > > > On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> > > > [...]
> > > > > >
> > > > > > Yosry, what is needed to enable zswap as a swap tier? What will be the minimum
> > > > > > requirements for that?
> > > > >
> > > > > From zswap's perspective, we just need to skip zswap is zswap as a
> > > > > tier is disallowed. Could just be a check in zswap_store() similar to
> > > > > the check if zswap is enabled. I am assuming that if a swap tier is
> > > > > disabled, nothing happens to the existing swapped out pages in this
> > > > > tier, but new pages do not get swapped out to it. This is the same
> > > > > behavior that happens if zswap is disabled at runtime.
> > > > >
> > > > > From the tiering perspective, we need to accept "zswap" as a possible
> > > > > tier, or maybe creating it as a tier by default if zswap is configured
> > > > > would be better to avoid handling the case where the user doesn't
> > > > > create a tier for zswap.
> > > >
> > > > Default tier if zswap is configured makes sense. Should zswap be treated as
> > > > having 32767 (or maybe 32768) as priority as it sits infront of all swap
> > > > devices today? Also whichever swap tier has priority range containing 32767,
> > > > will have zswap in it.
> > >
> > > Maybe we can handle zswap as an internally reserved tier which is always
> > > preferred over swap devices.
> > >
> > > I do not think there is a strong use case for grouping zswap together with a
> > > swap device that happens to use the highest priority. Also, using a visible
> > > priority value for zswap may have a small side effect that one priority value
> > > effectively becomes unavailable to users.
> > >
> > > That said, if zswap is represented as a tier, I agree that it should be the
> > > top tier. The exact priority value or whether it is internally reserved should
> > > be adjustable when we implement it.
> >
> > Agreed.
> >
> > [..]
> > > I agree this is reasonable. I can treat the demotion/writeback interaction as
> > > future work and follow up separately.
> > >
> > > > Youngjun, what do you think? Is this reasonable amount of additional work or do
> > > > you envision some complexity here?
> > >
> > > I sent a note with some thoughts about making zswap a tier. Since Chris also
> > > raised concerns around this area, I think it would be better to discuss it a
> > > bit more and evaluate the details carefully.
> > >
> > > At this point, there does not seem to be an immediate use case that requires
> > > zswap tiering in this series. So my preference is to keep this as future work
> > > for now, and follow up with an RFC after verifying that introducing zswap as a
> > > tier on top of this patchset does not cause problems.
> >
> > My main concern is locking ourselves into an implementation without
> > zswap as a tier. One of the appeals of swap tiering to me, from the
> > zswap side, is eventually unifying zswap writeback as part of a more
> > general swap demotion, and unifying zswap controls with more general
> > swap tier controls.
> 
> There is nothing locked. The major complexity will come when
> zswap/vswap/Xswap/ghostswap become independent swap devices for swap
> tiers. We are not there yet. But if you want a bool for zswap in swap
> tiers world, we can make it happen trivially.

Yes please let's do this. Can you also please comment on Youngjun's response at
https://lore.kernel.org/all/alcebHobUCUyO70k@yjaykim-PowerEdge-T330/ as well?

