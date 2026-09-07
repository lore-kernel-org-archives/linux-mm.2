Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA26C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 01:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4952D6B009D; Sun,  6 Sep 2026 21:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C7C6B009E; Sun,  6 Sep 2026 21:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382FF6B009F; Sun,  6 Sep 2026 21:46:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A85A6B009D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:46:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74CE5120634
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:46:01 +0000 (UTC)
X-FDA: 85185275322.29.035E4D3
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 58BCE100009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:45:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788745559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+G4MDmkdkKL/iE5/OlJHxou/7auZ2MdOrrTTdDQaGtg=;
	b=0xOJjVEKyCvEo18G6Q96KJjsL4z2oJ/FxitZeM3vS/AYPmgmVuC5goh0USBcBreo34QPb+
	h/9BBdiEYu07uXik9i4tDQaVlPzFMGLt1CWVV21QcVyuE00tgJuQRqwC2hkl3MZ/6yr7Yh
	oLmsOOiyDUDIZdvD8x9+E72n8ZY0ss4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788745559;
	b=5OGdTJbfSVSyRlSU60Ybt/Xsr5zFOYtt5/tBSala8H1WxfmZ+4AfyEoRKyXoGrwjfA0sx3
	mQnASx5nUx92GC+aIhQ+fkZjnlWBshGSyZjpaHTlxoguIN9OPFctq9ti33g+vZK4GTMOb3
	afO4ojFcIcgZ3MhwKeKnFDZNL1CtBi0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
	by 156.147.23.52 with ESMTP; 7 Sep 2026 10:45:53 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.126 with ESMTP; 7 Sep 2026 10:45:53 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 7 Sep 2026 10:45:53 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jihan LIN <linjh22s@gmail.com>, Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, linux-hardening@vger.kernel.org
Subject: Re: [RESEND RFC PATCH v2 00/13] mm/swap: introduce per-priority
 allocation queues
Message-ID: <ap4XUQtdLIITU5Dt@yjaykim-PowerEdge-T330>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
 <appvhlPleahTRklV@yjaykim-PowerEdge-T330>
 <20260904100900.21517-1-lianux.mm@gmail.com>
 <CAMgjq7Bh0hdVoRcS4xMRL0YG-zmjh-TxyF9xXCmP2MRarAyksQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7Bh0hdVoRcS4xMRL0YG-zmjh-TxyF9xXCmP2MRarAyksQ@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58BCE100009
X-Stat-Signature: qmidbswp4k73neu7xrbbwbt4bmnpf5s5
X-Rspam-User: 
X-HE-Tag: 1788745557-577039
X-HE-Meta: U2FsdGVkX1+3ESOIpmPqaNxfMiZVvaeZoj1xRH2lqRYHey8iofNRXei2uV7s5qWmMkgfP9yKWJxssKdv+3c9Njf2xBxoKwiDbkS4HRnIi7e0Jyz+eKFPQtxZYsXfXvCLmFPgqQLzivxdubGnKW3xSLaHTbgaWF2ZiehMNLW1jww8qHT3t3MReAyOoYSOmWeukoqC36eS7nqbfGcz7kvquw9cZQ7Zv/nbw4TY1qcPT59iRpRG+YBMZnDQLX262DtPcDjuUOY31DVjxM1EqmHoLVnkK2YohiKfzqTh3TheGerHAYo3GfehwylOsWs7BOkYae314dsaMRoDfZwF9G/9INkUizhqArHLPb2ciVr1JJgAi6TrSatyErh6LrurkoKu9ihHD7E3KEcJfn4ILLVsD7QG8E/4wbtZh4lJbs2psy6L5sH8T9sQVG5jKR8KHgFAiZzf2wPA9ZALxm6v8EiOgLLtIdrR76eT/CqWNKyb6Peg+9uiACUd6oSz4Q3mmOYvH65hBo+P6cSrX3lw5QbokiaZDbzuNSO1gWqcfZOqWOY9qcRvVhfEA1QLrZODA1sLWCLXMgQ2QxuaZmy6oiPBV3f9I1mlB8ZsjWU5p46wHxb1hRvxVG4WnGjZJ54coiIuSicl8uou3pmWkDNrivMnhwMrjiY1abufsNZAEca/gBEOUeWQhFyae8i5Nk0CNaLNXcT7q7MDkuhVwGAuL0/CinTMDQhVlSdOStupD3o/fHKSuhcffvYnURHCTWpy4WiLHtmwr0zTArDOMgQveHet6aR+d7534Tp8WZnEjoejINPxHNNiHyxL0AbjVMe71tbc2sXdcZ+areRllTaXjts3qWBFqpLoFg0HP4MSFKyKU7CNuJ+ndDH/ofBbG0bHv21zT+hYM0FkAPzEoXnxxYkFG0miw9JMZKjn61gWVDSTL/f1IC273/hFMfA4JJTSdiMvtLlaJt1kMGMWpMqzNXs
 nzocYltc
 kz6fdhkNNt+5bB42mftsi2rrvccfZ9vPZl0CpT/fKMzirdHL5AYnQa08I3IiCWlYhaG+Fv0hgOrH7cbbwVL/0I0K2nIZvHQTT+UUSiPgQD8HcRlh1zzwWzADpBr4rdQynA8hk6k79mCojk45W5xQyHu5pTvsyye9KpsNdto1k+utNQU8oml2UfkmfPkvr6TwcxAffznyarZ9RZE/6fHcpKPoZ60Qmm+b+BdHyRL7KMFVuRynawrerz0+TOSdV64sBA1+9vzmYiOOEVb+tisjkUJxx3AIE1Tv+JQmVncdbomBoJ6FFSTaY/h8DU0lXWfeWa72pmpv3UONaOBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 09:02:00PM +0800, Kairui Song wrote:
> On Fri, Sep 4, 2026 at 6:12 PM Lian Wang (ProcessMission)
> <lianux.mm@gmail.com> wrote:
> >
> > On Fri, 4 Sep 2026 16:13:10 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > > Since tiers come up further down, I'd like to raise a point about the
> > > patch subject line too. As Kairui mentioned in RFC v1 that we would
> > > stay aligned with tiers, would it make sense to frame this RFC as a
> > > per-tier allocation policy (or something along those lines)? Kairui,
> > > what's your opinion?
> >
> > Thanks for the thoughtful feedback and for taking an initial pass over
> > the series.
> >
> > I agree that this queue could naturally become an in-tier allocation
> > policy. For this RFC, I would prefer to keep it separate and scoped to
> > the existing priority semantics while the tier and virtual-swap
> > directions are still being settled. We can revisit the subject and
> > naming once that boundary is clearer.
> 
> Hi All!
> 
> We can start with adpating the default priority if tiering still needs
> more time to land, Not changing the user interface means less risk.
> It's also fine to implement tiering first, there are some other
> blocking issues for tier though.
> 
> With tiering I think we will still need rotation of devices in the
> same priorities / tier. Once tier is ready, we can further extend the
> rotation in the same tier; that's something to discuss.
> 
> >
> > I will also sync with Kairui when he has time. He has several things in
> > flight, but his view on the ownership and framing would be valuable.
> >
> > > Devices assigned to the same tier already share the same priority, so
> 
> Hmm, the current posted tier is a band of priorities. Do you mean that
> when tiering is enabled, devices in the same tier, despite of having
> different priority, will be used equally? And is priority ineffective
> then?

Hello Kairui

Right. My thought is to remove the priority semantics within a tier.

Once devices are grouped into the same tier, allocation within that tier
should be handled by a tier-specific allocation policy.

If users want the traditional priority-based behavior, I think they should
assign devices to different tiers and manage them that way.

For swap devices assigned to the same tier, we can still leave the behavior
flexible through the interfac(they may be treated equally, or priority may
still be considered). However, there should be a default allocation policy.

> > > I don't think the allocation policy needs more than one option for
> > > that case (I can't think of a use case that would need it).
> > >
> > > 1. For legacy swap with no tier configured, define it as a single
> > >    priority treated as one tier.
> > > 2. When priorities match, allocation naturally falls to a single
> > >    policy (not a queue). the concrete policy here is this
> > >    queue-based scheme.
> > > 3. When tiers are enabled, devices previously assigned under legacy
> > >    swap are reassigned to tiers at runtime.
> > >    (This means different swap device on same tier handled like same priority device)
> >
> > These are useful design points. I would like to study the concrete v11
> > before deciding between runtime, boot-time, or compile-time tier
> > assignment. It seems safer not to bind this queue RFC to a permanent
> > tier interface while those semantics and the virtual-swap backend model
> > are still under discussion.
> >
> > > I think this feature will also be needed on the virtualized swap side,
> > > which makes me wonder whether this patch should go back into the swap
> > > tier series instead. Kairui, Lian, what do you think? (Or separately?)
> 
> I'm fine as long as there won't be a regression. I remember V10 of
> tier didn't touch this yet so the regression is limited to tier
> enabled case, so no existing case will experience any issue, that is
> fine. Causing a performance regression for existing usecases is
> usually a bad idea.

Yeah right. will consider regession case.

Thanks

