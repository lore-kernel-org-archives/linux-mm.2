Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0545FC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76E76B0093; Tue, 21 Jul 2026 08:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27576B0095; Tue, 21 Jul 2026 08:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16616B0096; Tue, 21 Jul 2026 08:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E54D6B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:01:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F5BB120121
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:01:08 +0000 (UTC)
X-FDA: 85012643016.01.BF004D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 40DED40010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:01:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bgWWDECm;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784635266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XIKQnZ9opHJEwvD0dLMnBqSTBDPCPOWWPyJ5Trj2VM=;
	b=x/X+XEh1kXbl/ykGF9oyjPiSvfWRzH3Lv/tHh75zveOB4up2c3Pk7Aooi1kDimhW+8+WzD
	0Uq3+GFDS5ktc20UGbbPqypgXqTV/ZeEIJQ9evLzmsH/BpnXL4+ZCq6Wm4G2eV4ZGQskNY
	4kE4FoAoH4R+lAngefss16iFnGR5uW8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bgWWDECm;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784635266;
	b=xGUJeqUN3NEJxyeXj4HpJLtdF07dB9TA5Z3B+pW0E/hhUv3iWYKKJ250YElSCTuvti3R+5
	QhZB3JYbeKOlaytquteoud/OmEbNPFuG5yv3ImSuvQnJFa2T5A3mCX1et3pQfa1ws4niJh
	pJ2NK6sx03YRPT9P/pyrl/i/NpdTApA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C0A243C39;
	Tue, 21 Jul 2026 12:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D848D1F00A3A;
	Tue, 21 Jul 2026 12:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784635265;
	bh=5XIKQnZ9opHJEwvD0dLMnBqSTBDPCPOWWPyJ5Trj2VM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bgWWDECmRNILlRghGfTo7PFAwy3rtWmPtf0AQfcSd4kE3u/9Agf5gZw1CuOmb6GjH
	 JoJ8HUGlqiko8ii2JVoiptpIzGvaj4MZnNZ4Xp/6ZtmOxln54UHl/SqxzVhCiAsKXA
	 CmU0+Vw4ucvBmsQiZn8DUCeI8BCa0kB9tSuVPR6V3xLaqyJPdQHuUSMt/XoDpFxoGf
	 Zx3SwxyuIPPEhhnrhWt/HcvrF1cYUJxQFhVD8FFM5VKCn2SB/mvo4ztkkUnogQ3wiD
	 2ihDsexCWYf00RwWyMuyBd8AQzR4bsSMIFCUJrLAK47RxUg49jBRp0SfLtp5rLHr8Y
	 2XHjiLOChAUKw==
Date: Tue, 21 Jul 2026 13:00:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Vishal Moola <vishal.moola@gmail.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Kiryl Shutsemau <kas@kernel.org>, iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: allocate split page tables as kernel page
 tables
Message-ID: <al9b5uE-ep9ADtLt@lucifer>
References: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
 <al5-fDRStgU6gjk6@fedora>
 <al5_Le9QlD4zlt25@fedora>
 <al8hE_ded6qyWiDv@lucifer>
 <al8_xx_99BjAUn5A@fedora>
 <al9BpTu2ma8GpiPW@lucifer>
 <al9KzIhKXa3PCMqa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al9KzIhKXa3PCMqa@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 40DED40010
X-Rspamd-Server: rspam01
X-Stat-Signature: yrbuwjtoytd6yrzmguoi4rqcg6t9qwhb
X-HE-Tag: 1784635266-848988
X-HE-Meta: U2FsdGVkX19Io4BOyv0JEddsyi1jG8zqYX4cabJ+rCjFRJwAswkJNGz5SfFuRvDU4YVjcYzdZ4BsQPcvuUPF9j0ZC+qkcmPziELonQl14p6eODaMj443D8zqrYn7DPTjstbs8csJ2YgaIg2Ly5z1pDaZC8Af0jj12+QvU/jrp1Iwo5k9Ygx1vpHeGcZpPaTCDVBsu58RZZNdAJ6Ju0CmzybNveAnwd12LlovGYE8A+PbbrYPLayucJWSzvzlOKGht+Xp14IA0fWOqDgdnA+MfakYnwz/Pdwdm6o6si7G5dYmvJd/gmEJ3EXWuCxj4elwyFh6wtPYVdERWuNjh9UORBYEay9FJtM//F9YOZoo0+2PoQZB6etb2ti65U7H+X4pmAI9nkENl3BtNyg8Uuxjch6/ukHVOtc4F7SFELh//v7aP+63fTM+cmg8lipqW4HpCRG34LvxAYMLhSOM4bpMwM2ZLLgcyCgQZArY2C35GLEV32xGN+XyKxRl7FTJkfQswffdJYpdf9qTrp/2yjikva1wxpl57pdEFEXnYP0uVBulWoH+JhXDPM5nF72z4KEzTArhEsnUAhNt/0ZJMNW7K3NfAS2nnBVUfkvzNbUzRXivlufogG9U3SuJOIa498dhaiNMuNKj9q2KNx6PfwGzHkSvgzmDMMBITxgcGQO+S2cxHj1DTaQ/DfBj1sCa1Y7AG/9LmPK7IaLnS2wsdCSkZ9JPWKYTkbWngyTVbTCbCN9P3lNO1N2P5FnW5Wa4wJUAQGRxrYKPo2E8V7+YW2D49chIcPv6EDuCS/LSSL0pJivDr6yWcg7aiv+J0P5OyHAAqvlnieNYXdQRXzyKGyudkES+YKwY5xv36pnRGcCtyg/36LkZzKxTKSVmRTNBI66Q6PCHcH27Up2rGtr93CfTE5HaEqDZqqScvDW6ZSjC1JppM9MrPJC50c+MeuwvLY/c7RmAUduZRMluqKQilOj
 eBwKnYux
 lWtapIqBooTyhHvbw1RoWKlpHU4oDmM1JVjDj2bzgr1Hf/dyOn2jpzFPttgBN9x7LHjcMpnLGi3PTmpKxyblE5iYi0MI9sUXvyoNWheDrYpNlDmHAy8awhGxjB2O4TLJwXd0C/Uc2Ox1Qp+8qRLLqGExzr9fMcKVQRUWB7cQ13kTRGyh1ESJJnn5dEwC7u33sgz2AOa6n0xAxJ6kV5IPeQ0htpHx8fB90pxrF+fn2ktWathBpBwC6wB4S4VaoZVRVDEtt/vROAHpdwMDfIFRFZ1mvFRC2Xfit2m8vWrsE0ezkWuBRsxtAvQ7oYQBLyy7/RghKo45AizEnHA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 01:32:44PM +0300, Mike Rapoport wrote:
> On Tue, Jul 21, 2026 at 10:58:50AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Jul 21, 2026 at 02:45:43AM -0700, Vishal Moola wrote:
> > > >
> > > > Well some kernel page tables are still allocated without ctor (early allocated
> > > > direct map for isntance), and if you did pagetable_dtor_free() it
> > > > unconditionally calls pagetable_dtor().
>
> TBH, I cannot think of a scenario when page tables allocated at boot would
> be collapsed. But surely, checking the page type is safer just in case.

Yeah nor can to be honest, anything that could be made large in the direct map
would already be large right?

But it's 'just in case' somebody did something dumb :) Later can maybe make it a
WARN_ON(). But just to fix the proximate issue for now.

>
> > > > The ptlock_free() and __folio_clear_pgtable() there would be harmelss (no locks
> > > > assigned for kernel page table, and if PG_table never set clearing it is a noop)
> > > > but the lruvec_stat_sub_folio() would cause an unbalanced decrement of
> > > > nr_page_table_pages.
> > >
> > > Gotcha, thanks for the explanation :)
> >
> > No worries, this is subtle stuff with lots of weird gotchas and stuff we need to
> > improve... I seem to have fallen down an unexpected rabbit hole with these fixes
> > :)
> >
> > >
> > > > It sucks, but until everything is updated to call the ctor we have to do it this
> > > > way :>)
> > >
> > > Yeah that makes sense. Although I'd rather see the condition as:
> > > if(PageTable(ptdesc_page(...)))
> > >
> > > We really shouldn't be calling ptdesc_folio() anywhere anymore.
> >
> > I think better for a follow up since the code already uses ptdesc all over the
> > place (fundamental to the approach really, keeping a list of page tables etc.)
> > and this is a fix that needs backporting.
>
> I agree with Vishal that it's better to use page type rather than folio
> type. And it's the same for backporting ;-)

Ah sorry misunderstood, you mean straight up PageTable(ptdesc_page()), I thought
Vishal was saying we shouldn't be directly referencing ptdesc's at all (which
would be the rework).

I guess definitionally page tables are never folios. I lazily went with what I
saw elsewhere, my bad :)

Will respin!


>
> > Cheers, Lorenzo
>
> --
> Sincerely yours,
> Mike.

Cheers, Lorenzo

