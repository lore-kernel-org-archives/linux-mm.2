Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51B1DEFB7E9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679156B0088; Mon, 23 Feb 2026 21:24:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64FF36B008C; Mon, 23 Feb 2026 21:24:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CD76B0092; Mon, 23 Feb 2026 21:24:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 410816B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:24:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 022041A03F0
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:24:41 +0000 (UTC)
X-FDA: 84477756804.23.0D162DB
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf13.hostedemail.com (Postfix) with ESMTP id A951B20013
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:24:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771899880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vfzLt5SvxdTetCsFJ+hLHnZ5k6zC0j0OfDmwN6xS9o4=;
	b=JF57b+qSKwMj4cwExIJlUIm8LyJ53fHrZPhTInxlkeEJpOWdTK9WucgvnzeoK2xh0/Ambh
	gSggkXKc8hXOGj8MN5s5/XtQdQeXMo5lqFGQQNCTraLgtn9qA3Js5l8Keiv7MhIp1xBS7/
	LLrhMITvIY86YFCg0XaDh/QD1GPvA98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771899880; a=rsa-sha256;
	cv=none;
	b=yaUrYlsi/RK0/+cEeskZdyWpWPh+67l6ZMVxXJfjhvLwfl6/KdE7YWw4HH+oyOYzdp08zc
	Xm5Za7eHC+quRPWq73Qg2dKiPEOgkvUtEmX/8dNWOi0q8kmfzH2M4ICHKMU/tt+Doh7ueI
	2v4rKNNoT70b7VRaY2aNqqdf3CTjQ3k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 24 Feb 2026 11:24:35 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 24 Feb 2026 11:24:35 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Chris Li <chrisl@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	nphamcs@gmail.com, bhe@redhat.com, taejoon.song@lge.com,
	youngjun.park@lge.com
Subject: Re: [LSF/MM/BPF TOPIC] Flash Friendly Swap
Message-ID: <aZ0L48fzXzC9IOfj@yjaykim-PowerEdge-T330>
References: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330>
 <aZiKQwT7KjWDLspH@infradead.org>
 <CACePvbW6uT5OKDg0RWS3ZBGcppBkz+MREDVXdwSat_qM=Nc5CA@mail.gmail.com>
 <aZxUtFaVaJbkAM8Z@infradead.org>
 <CACePvbWkGk5Z+QueOBNCdrr1mzGxQZbRbfeskOrLsmWEvF5ToA@mail.gmail.com>
 <jvbthrkxombekk4bbmdqrwvik2qnd5btafb6q7guimxnioaqom@7kjexmbfuzxx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <jvbthrkxombekk4bbmdqrwvik2qnd5btafb6q7guimxnioaqom@7kjexmbfuzxx>
X-Rspam-User: 
X-Stat-Signature: e94frwbwpmen5fr56hihehjugt6d61xc
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A951B20013
X-HE-Tag: 1771899878-364008
X-HE-Meta: U2FsdGVkX19JSvAWkPL3l9OTe8YP4MYoW9BfzIeHv/boX8+wtwzSU1tqFqwIYLRKtxEDIhN6PJAwXMEZnVb3+cwi2WpdEE54OrZGFi23Cl3ufmdfOpISyfIwOmMg9MDKejkSNHKEqJZQwHZPoik3Zrt2RiRHMfaKl64C9haIb9fnc2ei8hVyxoByx+2ygBhn+MEgitLuKbi5SxkcFQ36ONnQyC+icgcNaM+V6utXoHftIeeG17umx157OPxlybSgfvYWFLxMjs5yTUzwnrkwpfzhzFer0d0DCW+skmhePGDKn3Sbbw1rfmr+R4LGamhGgQ7lptzrUEV1iqeK6QyYaqVJYHGGYEQ3YZ1KepLQslJqJLXbbHnZiDtTrThQGZI2Nb0luuja/seXwoI7BYW7eTEZKwwB7UfqrwlYogdgT0KDdj3i/LjaRKXAfY2pgqsmZQwI0adcvXmXig9XO+Dfc3HkDfETxAXrrrMHQUq3X94v5sxGkdwUUIh8DSCwn/ua9QYKhjrFzX+WcV3Usb1cRPuhRO0fgLDu8bBa9qn7V0IjJUlcbHMnK39bp0ArRLW2pgcIka9+ew4s7lF4Je9kRlwasF+CzFvZOs0IJAYEPKvY1PCHHaACdDE/+6xLT8WK5j0SZH1TqfAUSa5ADCofGu+GAitBvQi5+vvne5RlS4Fd436cG0Okq0TUGuLNaiZB8in7WZpMuoGjQQeeTXwlXRY3ZPlLv+/Qdn5Bp6YIGl8UnQkFqhL8iSeoO1Tfgw7jYttV2HRzT1WdT2d/mL1Q7jjodIWTBD80miz8kJk6OUWHDfAfJ7V0ORRz6pyL7VV6NLIxfF6WFBQCfLYmw1hsm1MdQ79DBfL1oa4yA89fVNvJhC5DZj31cA2MkvF9O7OcPWowys2Z6ZpWPs6y4LzSrP1PUmN9sZe/w4QQxBPv2f1D9ARXHLLvy+abWoaPnZYoMiTxVP+xeZ8wBfL1VvK
 ePUJ+vdS
 L2sBFxK/slmNFwyzkAWhd+gnwOQKVLFXGeQbjKuLjU4YvbwzWImlLNDU8NPYoLMerSZ3fWvOZRNv0ADyAVhph5iks3VDHcXRS8m0acWJ0w+GEQHTUJ7BqO9jnGSE7lLCEZ6O8Y968cowJwF4PW17TJAeMAjoRZw2nCWY+ToAfjP/Bf4fV+DNORrgHj5fCPmEVjxsROkvDngF7e42Cfrr+RTvqZls7Qh+GTIGXT5rgQKJvVX8jX1mEuzNLH7fvk0LMCzJkL7oJJoeqxOVq2ifj7DWCCa7LaH61ijBBrTAS6pSBwtbXqTWZePy6rTnZSgpVg+X2daOOckHfgMmoZ+DQ872WCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 06:53:12PM +0000, Pedro Falcato wrote:
> On Mon, Feb 23, 2026 at 10:15:14AM -0800, Chris Li wrote:
> > On Mon, Feb 23, 2026 at 5:23 AM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > On Fri, Feb 20, 2026 at 03:47:18PM -0800, Chris Li wrote:
> > > > Hi Christoph,
> > > >
> > > > On Fri, Feb 20, 2026 at 8:22 AM Christoph Hellwig <hch@infradead.org> wrote:
> > > > >
> > > > > Honestly, I think always writing sequentially when swapping and
> > > > > reclaiming in lumps (I'd call them "zones" :)) is probably the best
> > > > > idea.  Even for the these days unlikely case of swapping to HDD it
> > > >
> > > > For the flash device with FTL, the location of the data written is
> > > > most likely logical anyway.  The flash devices tend to group the new
> > > > data internally to the same erase block together even when they are
> > > > discontinuous from the block device point of view.
> > >
> > > Yes, but that's not the point..
> > >
> > > > It is easy to write
> > > > out sequentially when the swap device is mostly empty. That is how the
> > > > cluster allocator does currently any way. However, the tricky part is
> > > > what when some random 4K blocks get swapped in, that will create holes
> > > > on both the swap device and internal write out data. Very quickly the
> > > > free cluster on swap devices will get all used up and that you will
> > > > not be able to write out sequentially any more. The FTL layer
> > > > internally wants to GC those holes to create a large empty erase
> > > > block. I do see where to pick up the next write location can have a
> > > > huge impact on the flash internal GC behavior and write amplification
> > > > factor.
> > >
> > > And that is the point.  The FTL will always do a bad job with these work
> > > loads.  You should not do overwrites, and can do much better
> > 
> > I am not sure I understand "You should not do overwrites". Can you
> > help clarify it for me? Let say we always prefer to the write to new
> > clusters while some swap entries has been free. What happen we run out
> > of new cluster to write? Wouldn't we be forced to overwrite the
> > previous free swap location? It seems to me the "overwrite" is
> > un-avoidable if you keep swapping in and out. That is the part I am
> > missing.
> 
> See log-structured fileystems. I suspect that's close to what we want for flash
> storage swap.
> 
> Also, FWIW: the cloud vendors have fake SSDs that while have negligible seek
> latency, have extremely low IOPS values (e.g AWS gp2 can do 100 IOPS on its
> base setting, and scales up to 16K IOPS. gp3 can do 3000 up to 80K on the
> maximum size). I suspect swapping on these is a huge slog, and we would also
> like to write out as much sequentially as we can here (though I hope no one
> is *actually* swapping on these things). Also mechanical drives. Log-structured
> filesystems were originally invented for these too :)

+CC Nhat Pham, He Baoquan, Taejoon 

Hi Pedro,

The motivation is indeed similar to that of log-structured filesystems, and it
employs a similar management mechanism.

That is why I thought a management style similar to filesystems might be
necessary at the swap layer as well (the swap abstraction layer mentioned in
the proposal document).

Previously, the direction for upstreaming our solution was somewhat ambiguous,
so we have been maintaining it privately for several years.

However, recently, I would like to discuss how to proceed with upstreaming in
the context of Baoquan's "swap_ops and pluggable swap backend"
(https://lore.kernel.org/linux-mm/aZiFvzlBJiYBUDre@MiWiFi-R3L-srv/) and
Nhat's "Virtual Swap Space"
(https://lore.kernel.org/linux-mm/20260208215839.87595-1-nphamcs@gmail.com/).

Best regards
Youngjun Park

