Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D80E9C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B993F6B00A2; Tue, 21 Jul 2026 05:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70FE6B00A3; Tue, 21 Jul 2026 05:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A896B6B00A4; Tue, 21 Jul 2026 05:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78AFF6B00A2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:59:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00430A0463
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:59:11 +0000 (UTC)
X-FDA: 85012335744.04.274DBE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6A59D4000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:59:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OljTjIb0;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784627950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSuHLrLwfaNy42BpXjgZBG/shiso5SfO21bFlZH+k3A=;
	b=rNo8xlb+JcNlP5nYg8rz2nW2wTy2n0di+9mc+3e04lVtHd8eWqQFW9FBNl0nsg6x/ItSNu
	bkGUxaeeimPASWweNJ7266RKiV8ExJVDo/M5q9G/xanr8zHChsIYYsrt0INqAAtwBF/2pE
	hmfQvHXYD8HQt8NrXshadQjzt80r30c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784627950;
	b=rYnXwOTNBtuTjDSMaAqVo0DIkFNuj8aJOqQLW0oWi3CdswhdaQT2b//S2mtIoW2qTZh3yz
	HQ1DPMvZzxf0NHFOLKM/Fw92C96iWOrx6pqtH4apsi+SFnUvJjyLd+lxhuYFZfXBL4TS6L
	9Re4YtMgbdN++ErVpT7xIE7Nvr2afjk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OljTjIb0;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF16260A98;
	Tue, 21 Jul 2026 09:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4B91F00A3A;
	Tue, 21 Jul 2026 09:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784627949;
	bh=rSuHLrLwfaNy42BpXjgZBG/shiso5SfO21bFlZH+k3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OljTjIb02H2+0UEkEM9Gelvjk5FK6OJ8NNM0loQc5M+e31RKsrtxXdE2cF37uZSMT
	 4V8Dal1LoqhDOheR3/hNkgCw0p/Pkp/fTFMc0gaARJcHE5OJGEjfM7eXIh9YVQhYeM
	 kmhAQ1Ont7DrN1V2+3kJ0NU6sVMP23kJq/CWS2aY5hnNEq+Lc4bl1Qdf3/bxS2txf3
	 pymV/GS6A00p9YzRw5e0rOf6aDo2tiIBg5l+mQFGyMrTBkfE1ZxjvrPGPmn7znVKyU
	 GbhMz6GnxGMJqTOl35SQQLdqauKv1SV137Pky4KbbrHErEQLuCGspCs9QOUZh6dFwJ
	 BkyZkMFiBUnew==
Date: Tue, 21 Jul 2026 10:58:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vishal Moola <vishal.moola@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Kiryl Shutsemau <kas@kernel.org>, iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: allocate split page tables as kernel page
 tables
Message-ID: <al9BpTu2ma8GpiPW@lucifer>
References: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
 <al5-fDRStgU6gjk6@fedora>
 <al5_Le9QlD4zlt25@fedora>
 <al8hE_ded6qyWiDv@lucifer>
 <al8_xx_99BjAUn5A@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al8_xx_99BjAUn5A@fedora>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6A59D4000A
X-Stat-Signature: q7coiputzkzo48wnbynhxeje6mmtdoof
X-Rspam-User: 
X-HE-Tag: 1784627950-486516
X-HE-Meta: U2FsdGVkX19y1PfmIXQpwwdSy+PYjEkzcR/4oQQBldx4MGxx/uhMRqCfD5gE6ks/Of+I7Cwbbx8VxsoBLY8Wcc5gutK1sn4MnIhCF7cdT90tLdrBh+iGjH8HutN+byZs3AVoJRTtl2H6ve0oRf9aIIQaxyzNlzSN4my+QSyZmcZpRbGisuMC6tpI/tR9Pz9EvuJG2lJceciX0CrMTLsZIOkHUxS7pWIlq4QgI0NLV66ja5x6Mw3VW2uI5UoSKZh00+LCg/4zJN6hYPSZGVrXYbVTVbLt+AnqyLf7Atq6E0k5EBMuYcd5aM3N+eio26jCbMDo2ksug0p8pwAXMq8jmfFLa+k8rH7xIbACIf7fQgbGQdC6/kjD0NRWjsAWGw3LDg0cF2r1WGr4x1V9aHR9ULgZa9UNdIkown0HR1apM7QiZnUpiZnYjbhG/uEhoyXq9YnCQThENsku32D6ZGvDGTtVuKEYfT13J8XzjRaRtqxhZrklXWEVmryV7wnQhQWGOsV/ooUiLnI5tpE3iZGd4ZPoO5w9lODgqw0mT6vUazZaF4KNzxyIh8wQr6GXIY7VaSPiV0eCjj5U4z+AqwWM+6CXcgXeAEUwkaT/diIYUM0HG9ZiCqXBvRfqZaXRGLyZe+FOdNu1WZFL/lXmJiWAJn9ZNp8XeNcfjWBkM5TbftflxkBneSuhFKxJv8FmrAgwdeW6ijXmVSOXvnM49U2X2AflqADUuimYOPLkeYqPTA9cyK1SGDfBFGXRbloDyTgzVn9J48RQDl4dKE/xGj/6onOrkWxSZ+1YZYzXf62oWRwS/GslVgnQW1dK+MLXcC2u87qWFk4kWTFJyebxzQSTqdfFM+sS8BneXzqxBsXxB4P/vFAGetNcNbjgaYxVXB/pjUMJFiJP9v9aVHEuKQbEi+/wXO8Qntm/kLsYDR+kWZRUZ417crAcj9dgate77ua3Tcf+XYc0wC5dVv9l+Kz
 3ILrBmW2
 Dqwll92zYA0e28SngNGXszD2jIzcNwT4RhbWnS9ZNP+AtIrqOou+N+jg3A8rGVbZUjlzSXvVj0pItIgulT6DvCnSfmKQHZXxujSn9SjhahWrNBHLEyOCVB1nOgLDczqsYMi5q65Hi7xf5Ho8QxCiR9M1mFUFrPC2XpKrPaQayyHpu0ts0xQLw8MxHGwTmPeJwLik48d3c4OIPh1CSGUsPnixmB7R/KpCoJ3qXGRcH/uZWFk36rmtqljFMRd2olNi7Qw1cTSi31kSOvVSHjdTINNBFn79TfJ7FUE7cW1t7sX1puIbqMxqRtuU4GjuxFCBMQU8RJ8I+7SBtOCWkms9tnq3pALvHT7U4fewT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 02:45:43AM -0700, Vishal Moola wrote:
> On Tue, Jul 21, 2026 at 08:43:51AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Jul 20, 2026 at 01:03:57PM -0700, Vishal Moola wrote:
> > > On Mon, Jul 20, 2026 at 01:01:00PM -0700, Vishal Moola wrote:
> > > > On Mon, Jul 20, 2026 at 10:27:29AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > > When splitting a large page in CPA in __split_large_page() we allocate a
> > > > > PTE directly without going through the standard page table allocation
> > > > > routines such as pte_alloc_one_kernel().
> > > > >
> > > > > This means the page table constructor is never called nor is the page table
> > > > > marked as a kernel page table.
> > > > >
> > > > > The former results in the folio associated with the page table not being
> > > > > marked as a page table (__pagetable_ctor() is never called thus neither is
> > > > > __folio_set_pgtable()) nor are statistics updated to reflect
> > > > > it (lruvec_stat_add_folio() is never called).
> > > > >
> > > > > The latter issue of failing to mark the page table as a kernel page
> > > > > table (ptdesc_set_kernel() is never called) is far more problematic.
> > > > >
> > > > > Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
> > > > > tables") kernel page table freeing has been batched and since the
> > > > > subsequent commit e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries
> > > > > for kernel address space") IOTLB cache entries for kernel page tables have
> > > > > been invalidated upon being freed.
> > > > >
> > > > > Since split page tables are freed without this invalidation, the IOTLB can
> > > > > contain stale entries for them.
> > > > >
> > > > > Resolve the issue by using the ordinary PTE allocation API at split time.
> > > > >
> > > > > This results in these kernel page tables invoking a page table constructor,
> > > > > and thus requires a page table destructor.
> > > > >
> > > > > Since we cannot assume one is always present (early allocated direct map
> > > > > page tables are not marked as such), we conditionally call
> > > > > pagetable_dtor_free() if the PG_table folio flag for the ptdesc is set,
> > > > > otherwise we free the page table via pagetable_free().
> > > > >
> > > > > Regardless of which path is taken page tables marked as kernel page tables,
> > > > > which now includes split page tables, take the correct route through
> > > > > pagetable_free_kernel().
> > > > >
> > > > > There is a user-visible side effect in that split page tables will appear
> > > > > in nr_page_table_pages in /proc/vmstat (as do other kernel page tables
> > > > > allocated after early boot), however this is a positive change.
> > > > >
> > > > > This issue started being markedly problematic after commit
> > > > > 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables") so
> > > > > choose this as the Fixes target.
> > > > >
> > > > > Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > > > ---
> > > > >  arch/x86/mm/pat/set_memory.c | 21 ++++++++++++---------
> > > > >  1 file changed, 12 insertions(+), 9 deletions(-)
> > > > >
> > > > > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > > > > index 301fb9e77d91..a67ca33b9dd1 100644
> > > > > --- a/arch/x86/mm/pat/set_memory.c
> > > > > +++ b/arch/x86/mm/pat/set_memory.c
> > > > > @@ -439,7 +439,11 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
> > > > >
> > > > >  	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> > > > >  		list_del(&ptdesc->pt_list);
> > > > > -		pagetable_free(ptdesc);
> > > > > +
> > > > > +		if (folio_test_pgtable(ptdesc_folio(ptdesc)))
> > > > > +			pagetable_dtor_free(ptdesc);
> > > > > +		else
> > > > > +			pagetable_free(ptdesc);
> > > >
> > > > Lets not introduce more folio-ptdesc crossovers, we're trying to get
> > > > rid of them :)
> > > >
> > > > I believe pagetable_dtor_free() should do what you're looking for on its
> > > > own anyway.
> > >
> > > Actually, looking at it closer, maybe not because of the conditional
> > > portion? But that makes me think it might be better to just replace the
> > > ptdesc_clear_kernel() with pagetable_dtor() in the free function...
> >
> > Well some kernel page tables are still allocated without ctor (early allocated
> > direct map for isntance), and if you did pagetable_dtor_free() it
> > unconditionally calls pagetable_dtor().
> >
> > The ptlock_free() and __folio_clear_pgtable() there would be harmelss (no locks
> > assigned for kernel page table, and if PG_table never set clearing it is a noop)
> > but the lruvec_stat_sub_folio() would cause an unbalanced decrement of
> > nr_page_table_pages.
>
> Gotcha, thanks for the explanation :)

No worries, this is subtle stuff with lots of weird gotchas and stuff we need to
improve... I seem to have fallen down an unexpected rabbit hole with these fixes
:)

>
> > It sucks, but until everything is updated to call the ctor we have to do it this
> > way :>)
>
> Yeah that makes sense. Although I'd rather see the condition as:
> if(PageTable(ptdesc_page(...)))
>
> We really shouldn't be calling ptdesc_folio() anywhere anymore.

I think better for a follow up since the code already uses ptdesc all over the
place (fundamental to the approach really, keeping a list of page tables etc.)
and this is a fix that needs backporting.

The follow up be something that you could look at if you have time? :>)

Cheers, Lorenzo

