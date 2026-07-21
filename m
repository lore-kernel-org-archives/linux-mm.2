Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B59C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2916B0092; Tue, 21 Jul 2026 09:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073E26B0093; Tue, 21 Jul 2026 09:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD8B6B0095; Tue, 21 Jul 2026 09:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC2A16B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:51:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C46CCC0185
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:51:45 +0000 (UTC)
X-FDA: 85012921770.24.2D80772
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id CD05D1C0002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:51:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J7RZ/w8/";
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784641904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pvhzps5Tk8jvX4BviS4O6j3wBvkJmKKyvjZkkLOc2rg=;
	b=YDVLTFW5KneK5LsyoPLJz0iMeVVoY1aJpmtWRkcbjEHbbZYO1ekGdfL/7TwaAKieeBrtTX
	SCusryBnrNDhOWJ5iWm85sJNlNtDb+MFR1Iac7h5kG8OYc5dp2TFQpuxkBNkCdGqJGVQmq
	DwTJLUrLqoSxAvwheKN954kP8EoS6AY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J7RZ/w8/";
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784641904;
	b=WKixjU/P7cynyNg3OSG7C/GFkzLtc2sEQSxCNVRFllXYyh9fIkhkJfNi0yGNL6CjV9ui6i
	0lrBsHmHF0fXyyEOg7pMkOLgqLlO0gPT4NAdpmBm0w4x2hfnD/97cAI2yFxcGC/J3X3yng
	Rs3BtdgPfY0xTZ/Hz+Vpx61mRaVk8UM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1534943D48;
	Tue, 21 Jul 2026 13:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EAB1F00A3A;
	Tue, 21 Jul 2026 13:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784641903;
	bh=Pvhzps5Tk8jvX4BviS4O6j3wBvkJmKKyvjZkkLOc2rg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J7RZ/w8/5rFQ34nRZAhG0S3I7LkEUZgHnw7sx0w8dS/sJSmTbr4aizN0U3uNYgOQV
	 sk+G4vyEeLOSsf2PIJloJu7kGJqS/3E25KrpYk5r+YOSIqyCJRmfTxs1OIq1mkzONo
	 KabEJby3rR7jR5UX7RV8WVOEg0aPKQ0y4E3iB/HrcTmRmWsBssUnUjs1ayS052H4PV
	 HFk8hIxhrkAdtOnQVeC4Kxh/mqNLkxxMOmsOgWOnvy9S+FrDdo2gBNPhRP2M1PnHRu
	 NB+5r5JGvSlUOB6/drzEldF0d6B6O0jmOkNvmnDQJr2QgNJT+hpFzKtRtqlfAw2pBn
	 HTyEC6KvboqRQ==
Date: Tue, 21 Jul 2026 16:51:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Vishal Moola <vishal.moola@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Kiryl Shutsemau <kas@kernel.org>,
	iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: allocate split page tables as kernel page
 tables
Message-ID: <al95Y5aXof0ISEkI@kernel.org>
References: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
 <al5-fDRStgU6gjk6@fedora>
 <al5_Le9QlD4zlt25@fedora>
 <al8hE_ded6qyWiDv@lucifer>
 <al8_xx_99BjAUn5A@fedora>
 <al9BpTu2ma8GpiPW@lucifer>
 <al9KzIhKXa3PCMqa@kernel.org>
 <al9b5uE-ep9ADtLt@lucifer>
 <al9hMyqpjd4l0Fql@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al9hMyqpjd4l0Fql@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD05D1C0002
X-Stat-Signature: 3khogst73xhwgdhaj4k8izp6ss7i8as3
X-HE-Tag: 1784641903-852714
X-HE-Meta: U2FsdGVkX19ZxZGysFRb/xk1bjxrIsggEVINpWQUCIz7i/gHUoaUGxZvNpP2u7xHDf+QdhSnPXjywat2ciWMvzhoZnxv8gFMaHUQN5D6bInrRDr47mtSXvu9muU5W6RiLxIwrHkofv49DGlDz7oiGs07cCmajVRHo2lO68HnxDsux3TySqX3Pt+jNvh3APQ6e2Plxnz6zaifE3SR/e6pcP/M28p+MJDbcgFFntqEjiZhcZzUE8b9OyQgZ0ntOUfckY9fxs2PL7JosPYUT+xpayefy0srvCTFEQLShkYfAI9pPase4d+MaDjuQtPglHxEgQ/zmQ5WsBsDhurL2ZyGp7v6X2JcMQB6BkiPG0i0UtT2XR597saLNdcuAT99OCjbUUp6v6Dpz4EhRQY9oKm1vV+Yu5Imy3ymW2jQkyrkhZHZXNth0QJTwTh9pOhSZHtAR0Ha+pu6OJuKxOapDM3PZdm/eR/L81Lun9zZmWYoX4sIAqVg7sSGbI+Hq9txJDBYCiRwM/bhtLpEol7UzXhJB9znoS8Yyxph0cKQGK1h1PJy5QbEakqyB0NB91f0aoLxW8wzF9pcostfNYOHw8U5KlBseiqrLqEgRMOloKzQN742DDk63AAobIps73XS82LTqCZP0I7A9/UWAfnSGHQiX65+r8VF25O3fTkDLvDq6jDbx8zd/m8wm0xGPPJbSIPU0WMTKD4kEB2IPmND32t/PWbR+wviIFdywC9QlREcvQKSA/++YAE0JPgtIU9ZR0mmiih7ejbQh60j/bN5opZSL1377jUH3JPOmaujhiTzmrMMIGiowNRxspdCMWB5KmQBm3vTlvGOzXWqiZv+ZbMWlYeQPGt6hUWkJjZnDl1JSemfh+bqS7YiPdU2pZY5aD0wofMhXwhv7fHmlld5ewDxbrkCHuUUUJYm64LUjTi2YFdG9fQckPBJs+lMLJRwb/BWv3VPo+gReGHsdSp8MT5
 hW92jWDo
 yDu381nof+HOQRWXO3txaECQNI2xHK6RRSHrIcAcCqpJ7VRpfTpwSdWOeP/Haga3NOmnSwwBD7hhxxUuj5GRaWzMFPSwcNcFX63nTrDw8nFsC0zB75mSTLUzrG3UVQllgYVTda5vflQwmtmwAnJXTy2mvhul9ObBcLZYXbu5+W4+ewYct7Z8bznw8Og+Bmfesj5JEgT1rNMivQTEE1izToT//wfU7lWewkyw+p61jaw9iWnXTHgXgieFDo0AArP2cSfpnt5GGuGTi5BX5c2OPBFdFRkjxb0sQSkaDfjEwh6CeFET85tLQ6Bczg9pOITuJ6+Voxkw/1A1pFkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 01:09:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Jul 21, 2026 at 01:00:53PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Jul 21, 2026 at 01:32:44PM +0300, Mike Rapoport wrote:
> > > On Tue, Jul 21, 2026 at 10:58:50AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > On Tue, Jul 21, 2026 at 02:45:43AM -0700, Vishal Moola wrote:
> > > > > >
> > > > > > Well some kernel page tables are still allocated without ctor (early allocated
> > > > > > direct map for isntance), and if you did pagetable_dtor_free() it
> > > > > > unconditionally calls pagetable_dtor().
> > >
> > > TBH, I cannot think of a scenario when page tables allocated at boot would
> > > be collapsed. But surely, checking the page type is safer just in case.
> >
> > Yeah nor can to be honest, anything that could be made large in the direct map
> > would already be large right?
> >
> > But it's 'just in case' somebody did something dumb :) Later can maybe make it a
> > WARN_ON(). But just to fix the proximate issue for now.
> >
> > >
> > > > > > The ptlock_free() and __folio_clear_pgtable() there would be harmelss (no locks
> > > > > > assigned for kernel page table, and if PG_table never set clearing it is a noop)
> > > > > > but the lruvec_stat_sub_folio() would cause an unbalanced decrement of
> > > > > > nr_page_table_pages.
> > > > >
> > > > > Gotcha, thanks for the explanation :)
> > > >
> > > > No worries, this is subtle stuff with lots of weird gotchas and stuff we need to
> > > > improve... I seem to have fallen down an unexpected rabbit hole with these fixes
> > > > :)
> > > >
> > > > >
> > > > > > It sucks, but until everything is updated to call the ctor we have to do it this
> > > > > > way :>)
> > > > >
> > > > > Yeah that makes sense. Although I'd rather see the condition as:
> > > > > if(PageTable(ptdesc_page(...)))
> > > > >
> > > > > We really shouldn't be calling ptdesc_folio() anywhere anymore.
> > > >
> > > > I think better for a follow up since the code already uses ptdesc all over the
> > > > place (fundamental to the approach really, keeping a list of page tables etc.)
> > > > and this is a fix that needs backporting.
> > >
> > > I agree with Vishal that it's better to use page type rather than folio
> > > type. And it's the same for backporting ;-)
> >
> > Ah sorry misunderstood, you mean straight up PageTable(ptdesc_page()), I thought
> > Vishal was saying we shouldn't be directly referencing ptdesc's at all (which
> > would be the rework).
> >
> > I guess definitionally page tables are never folios. I lazily went with what I
> > saw elsewhere, my bad :)
> 
> Ah yeah I remember now, i saw __pagetable_ctor() dealt with folios:
> 
> static inline void __pagetable_ctor(struct ptdesc *ptdesc)
> {
> 	struct folio *folio = ptdesc_folio(ptdesc);
> 
> 	__folio_set_pgtable(folio);
> 	lruvec_stat_add_folio(folio, NR_PAGETABLE);
> }
> 
> 
> And was like 'huh?' (surely definitionally they're _not_ folios) but went with
> that on that basis.

I wonder why setting the type is even in ctor rather than in allocation.
 
> Another place to clean up I guess? (that one _definitely_ is a follow up though
> ;)

Yep :)
 
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

