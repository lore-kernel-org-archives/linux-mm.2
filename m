Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAAFC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9081F6B008A; Tue, 21 Jul 2026 08:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0416B008C; Tue, 21 Jul 2026 08:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81EB06B0092; Tue, 21 Jul 2026 08:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9EF6B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:09:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E43E0120110
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:09:48 +0000 (UTC)
X-FDA: 85012664856.03.850A251
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 65619C0003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:09:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FCBchnQk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784635787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+aU74TjwGAKlM1ykbFleIgZ0kqOSlolWT3M16XgHiR4=;
	b=aknsIj0f/ppI5u4pRQQGCXgxBCe0b8MDCC7A57Ziv6AvOdoYOvkP+pePLOZdI6BF0eas2w
	EUzAYHG28rOSITlFRcBgKgE24GXpm4MHNiNRdLrqS14f3umdOkO1LgT+QHHTTb96BO0GKp
	fAp5JSqBy9kXZ7MofpSdUwM4TF7CU2Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FCBchnQk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784635787;
	b=fJ5esYA8jpH0maUG9UZuYOGlZ26TiC5hqBbqWzD0ByaXxWjCDZMuGkHdvYeTmIrFT9z3tA
	WezjiCXoHZOLBqwP5Rqmt5NPm84Oo+Uojabh6S39dXUbeL5t29yeZBnyn/Eato6s8IN3hq
	xCQ60dhLB3vQAhb0UKut7/Qd0pC2tCQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC418600C8;
	Tue, 21 Jul 2026 12:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328B31F000E9;
	Tue, 21 Jul 2026 12:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784635786;
	bh=+aU74TjwGAKlM1ykbFleIgZ0kqOSlolWT3M16XgHiR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FCBchnQktpU1hJI6VVEm3hDfoYdq9iEkrTct/AwFrdSPMeIM2JM9lcfnYGZvRazXy
	 a8/zEgTWzzu21EtZuE/yXLKIsr8+xmCSw8VQto9H55e/F7BOkcmdPrGKpFlnLdU6re
	 P5k4ZG9I+odTrG5rVGkxSNyesNhUmgrLt1GhgnhPRojWuMUoJrqjXdLb7V3XMqg5AD
	 TVSfO+pgPO/2Q2pQFDfTf/qYvPC89XKyTy1TvbKgp8UuJBe1ZqU0Pds2kZC0rvCNPJ
	 uFFsxHyaTsWjBb2HyzjjQXmE1nd7xxIcOhjwTfRrF7994SGksKawr0zsLyM2nHMz5D
	 hsUSrDxoKoW0g==
Date: Tue, 21 Jul 2026 13:09:27 +0100
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
Message-ID: <al9hMyqpjd4l0Fql@lucifer>
References: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
 <al5-fDRStgU6gjk6@fedora>
 <al5_Le9QlD4zlt25@fedora>
 <al8hE_ded6qyWiDv@lucifer>
 <al8_xx_99BjAUn5A@fedora>
 <al9BpTu2ma8GpiPW@lucifer>
 <al9KzIhKXa3PCMqa@kernel.org>
 <al9b5uE-ep9ADtLt@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al9b5uE-ep9ADtLt@lucifer>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 65619C0003
X-Rspam-User: 
X-Stat-Signature: a945a9ui4rmu9x6atugfqt86ugcbxdbr
X-HE-Tag: 1784635787-997389
X-HE-Meta: U2FsdGVkX18fq6sETvuP4CeTLdu+fb6NDoVPxjjw8PdT59ql9JJrOHgdOtqLwgLO0qeJsLRHuZ8OsqPYlK0MCLHtEBcwXrd1Coc0NHdli6mAbBx4w4dcjxOyMBCzFtq617FMO+VF0R6ums4Me+3K0GoZDYwSWa4pr7WcCHRbU0rACj2Pm9r+4+idz3464A4LDwlia9coTDYfAn0lGdaohMiCMr1qCIfDf2fkT2u2ERa6/Rl9JUQLS/PELg1Mz/nEgU7pPfupJPOOMMXSnaf09knWyY3zBmfjCXEoyMB6H2ylTZ+U9QZFP5PqNxlV0eZc8+jTPBQ1c4Vrp4KvUCA1IVu2rMraMIr/cD4MAaEUoHXe1PzRZLLd28oggeEwH/e5aWfJSbcf9gIrKJ76Eklm4l//dCit4t8J8mPJ2TMBQRD1BbWb/O6IaI0Es3cJvUyccq/+swyD+IsBXouykfXo/94800xG0FjbEigqJUfQl9+uxJJnjEYq7ffhpJa5RqVPU0kWLzVDrDzrAa8V2JdbwhfSf5rUVaUViwVyr57u9tVd7Ma1YmkheI0F/8quOusPaAe34gHGjjXNRcY21YC0W+EmsBrpFGa8LQ3k7n65fKrNdCA5lsOPtxPDZO7y/G0jSvbjN7z6bEHpznEkqExqjqxZoMDaweMEywdbhoepcxyD6kzsZUY29Dr5yU8KFUaVg5u8qpp7bDXfwEC0qBsa6YrY0vlS3UimSdBthaxSFFNqbUIsWCe4mdA6NBpiURL8aMn9i6zvhEmSq2bRB0D+xvYjojSe3YJzQFJQEHquXmEXM/9WnLGkdpcaOW2twqMstL/wtUjqpdNJaxvZ3+dcAF5rJZ619Cjsqqe8g99eaafLoNJ4KqPHuPXOnkSci9fMemM/8Ens1IKYG6a3rFJ6pTHcaelPfoXXFu6nYaqroIa/+oOmVgW5AxMQ6pU3Zf5cqZEEBhmGNnM7O9MQmIq
 NA6Ew209
 yjV3O+8izmUtd+fZkdkC45fKiq8rmUevKGbGZKxyaGL+dHrWO847YJ63GX9/oUCOFJ9LeYuuU6ypoEtOgfo7uncwPiV48+ptI5b04Rj2Owq0NhWBtJ0rieqEs+4+OXxVl1f/OuBdj9P5HC3dumPjGVtr2c+vKAuI4WOfe2Zst/UzlPYdIsjltzHDYB2pd9LxZNNetX6JIdipsdOYbRLTTDovmTE1fnCho9dehAWayXKPwGFxyaJ9RyEra3JwZtYU3fJgPTBP5OztYqxM8enZNzMAb2Cq9Y2SrawomYAYH9Hkmog2U5pDyEAX1futcQ/mano7gwU6VDOu0k3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 01:00:53PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Jul 21, 2026 at 01:32:44PM +0300, Mike Rapoport wrote:
> > On Tue, Jul 21, 2026 at 10:58:50AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Tue, Jul 21, 2026 at 02:45:43AM -0700, Vishal Moola wrote:
> > > > >
> > > > > Well some kernel page tables are still allocated without ctor (early allocated
> > > > > direct map for isntance), and if you did pagetable_dtor_free() it
> > > > > unconditionally calls pagetable_dtor().
> >
> > TBH, I cannot think of a scenario when page tables allocated at boot would
> > be collapsed. But surely, checking the page type is safer just in case.
>
> Yeah nor can to be honest, anything that could be made large in the direct map
> would already be large right?
>
> But it's 'just in case' somebody did something dumb :) Later can maybe make it a
> WARN_ON(). But just to fix the proximate issue for now.
>
> >
> > > > > The ptlock_free() and __folio_clear_pgtable() there would be harmelss (no locks
> > > > > assigned for kernel page table, and if PG_table never set clearing it is a noop)
> > > > > but the lruvec_stat_sub_folio() would cause an unbalanced decrement of
> > > > > nr_page_table_pages.
> > > >
> > > > Gotcha, thanks for the explanation :)
> > >
> > > No worries, this is subtle stuff with lots of weird gotchas and stuff we need to
> > > improve... I seem to have fallen down an unexpected rabbit hole with these fixes
> > > :)
> > >
> > > >
> > > > > It sucks, but until everything is updated to call the ctor we have to do it this
> > > > > way :>)
> > > >
> > > > Yeah that makes sense. Although I'd rather see the condition as:
> > > > if(PageTable(ptdesc_page(...)))
> > > >
> > > > We really shouldn't be calling ptdesc_folio() anywhere anymore.
> > >
> > > I think better for a follow up since the code already uses ptdesc all over the
> > > place (fundamental to the approach really, keeping a list of page tables etc.)
> > > and this is a fix that needs backporting.
> >
> > I agree with Vishal that it's better to use page type rather than folio
> > type. And it's the same for backporting ;-)
>
> Ah sorry misunderstood, you mean straight up PageTable(ptdesc_page()), I thought
> Vishal was saying we shouldn't be directly referencing ptdesc's at all (which
> would be the rework).
>
> I guess definitionally page tables are never folios. I lazily went with what I
> saw elsewhere, my bad :)

Ah yeah I remember now, i saw __pagetable_ctor() dealt with folios:

static inline void __pagetable_ctor(struct ptdesc *ptdesc)
{
	struct folio *folio = ptdesc_folio(ptdesc);

	__folio_set_pgtable(folio);
	lruvec_stat_add_folio(folio, NR_PAGETABLE);
}


And was like 'huh?' (surely definitionally they're _not_ folios) but went with
that on that basis.

Another place to clean up I guess? (that one _definitely_ is a follow up though
;)

>
> Will respin!
>
>
> >
> > > Cheers, Lorenzo
> >
> > --
> > Sincerely yours,
> > Mike.
>
> Cheers, Lorenzo

Cheers, Lorenzo

