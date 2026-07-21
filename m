Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36FA0C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 07:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2786B007B; Tue, 21 Jul 2026 03:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03CFD6B0092; Tue, 21 Jul 2026 03:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20F46B0093; Tue, 21 Jul 2026 03:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A29016B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:44:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13B14A0A21
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:44:13 +0000 (UTC)
X-FDA: 85011995586.30.6B430B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7ED6520005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:44:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ha9IS53O;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784619851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtFkn/mfMTIuYOWYRQFzEbxdk2PyFOEa96NYZZ89cn8=;
	b=11wzNCcxc60C9RWBPENHeNejf+rh/Lp9UfEL/TkGtLafHaGe8JVi83YrRDR6OJ2nIcwP7W
	M8SpzxPSwq8JB6SveTeOmJU9DgIVqZEWnsSj6gqUoDSglIh81J1YfVD/XQTTQ2ojRp+AF6
	snphJMvkLKJNzzRf7nj74gvL66vTQSs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784619851;
	b=X+KVzEk+Bi8CjO/3ogyOtEdu30+Bm6G36Lg3CDtEshMo1PtqYPxm2NSRD1LTer1mCZbhQn
	wPQzd2Kw+PixYG230ri8Vd4JtBo2SLJ1BjSrhoJFOXQAQP9lDY+5T8/q2ImpK5+53bLzet
	lmiovYzZIWjw1/sQSKex2tKpwmSzkOM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ha9IS53O;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E23D460A95;
	Tue, 21 Jul 2026 07:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83491F000E9;
	Tue, 21 Jul 2026 07:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784619850;
	bh=rtFkn/mfMTIuYOWYRQFzEbxdk2PyFOEa96NYZZ89cn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ha9IS53OCz37rW2lp5eXzb0wUrip7zSDnqnZ989Svkz/RICacEJWMriB4qEXAuEWx
	 FQGmHuwGklOwD7GtieTS+QuDS5HTY52UVqf+5sSVrhelirehT+/EampviUu1taWD08
	 rQiw6RRDliszAEvWi9fNVDEzDFds/TudFWRymwY4WFasELLb5iGZ6Nue8TONB1j+1W
	 T2nBsJC9Ve8POYVJ4/0Mj5n0h6za1r+yTpq0EnIG+68oPpYMSPMcqMFSc5xrCywEud
	 2drX/ljX6usPah/mfJwJ+gjFZQ0YPhctgDCALycA1l32PBnV1J1LaNkstLFExwz0HV
	 HhcAXpT6XspBg==
Date: Tue, 21 Jul 2026 08:43:51 +0100
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
Message-ID: <al8hE_ded6qyWiDv@lucifer>
References: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
 <al5-fDRStgU6gjk6@fedora>
 <al5_Le9QlD4zlt25@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al5_Le9QlD4zlt25@fedora>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7ED6520005
X-Stat-Signature: x6zaxnzfhbz795j1unsy7skke7a1tsr9
X-Rspam-User: 
X-HE-Tag: 1784619851-595996
X-HE-Meta: U2FsdGVkX1+ZI5VQRxpfZDrcZv3zyKZTpheJCtOQ5g8kx+YdMo9pHYaztdp78yFNXDWTaeACs2VmquQwfTOyn9oPLt7Ae1dyxJRgoWEmZRwRvvSCzbTSoRbfe3AAcxSqYGmfOlIQGhSoXMuNKZWpBkACOY7RYM/N4b+yKF8AFraSBArrjj7GLiGM9bPVTIEU9h5DhDm1VtoC3m7NdqwW39Q/4h6tFPATtxbPxb5BLiilQncasM4/20WcEknK7gIEkSMsIJ3enxN1qOEvl2opje993FSe1GY0sgyNhj8JQQFE3Ro/clKEGY5gKjC+6aCqdj4nBcP3eB1ZuPBcW7Hb7/pEjJ3N8v3+1qTKyJdjVzOpxeNQT0GlIF3Zzq370Ie082UnIVraO66bzVmfEb5UcMlVbCk6GS5GK3QaPYQ4wOxiPli3TVpAAdydXZ6qXRnoAj1qFio64bjM+6z+0trwtP9PDoNyR6aVwNEgU893lK73GsBnWQER6i4rP9Xrc7oHlFxxf6O5IS5XM0CipQAbTsHD/VxCIYo28ihXa2Cqs45zOwCUJZTbMC1knf0J6adEX6quB3DjRVJiryRxsgEyJScFHbejoGmadfxYzpqgO1hThDhd8rxuXGAEkrZZyQYtPcGNxkSwyFO+ZgEk1lhRbGynvZUELzlTQJwwYXaI6xRVMvo5Gpa5UO7CgbiV9i4OaTfryZeSoKbZcC/cGqxpq4iC6Tl65rRMB25Jwnumuv0ehxePmBQWIIPqbn2PWkEOdN4w3l5M+l2DUbA1xlebs3le37sQFMCuZAHfoUCsvKa8JIPkOnj1/y3K9HRc9Psn0by37lMLoDo2SEPmp1msKh8Di6ZQ8tfw7rPWoAaQntotGBWQDUH6yoPqpry634bfL6jN5cjTNaRikLVTOV9Ih456Q31bRvt8Oh7cjctAjzpvbQdorLsDAy6DIpBk0X8FYls8IYZxRuyRkTbs4d1
 ftHZSPCa
 S5rWCqhj9gL+OMQQjpVlIrdwkqYP7wzwXGftZhuT283Ri08OdFzF3r7AQkTQsM9V8rJEBlmq+Uicq9UeJU0r9E2KFGUAoOQMG9mAsC0iQQYZwcTlCBYULlbJHLOuQaq/qw+gYFE29uBUCMw41czQeeEJno9TJrI0daM57dgq5YekFyQcQEM9RNww0R0xNHcIPY0YmyqIp4+ko61CM60NXci7XHMLG6Br1dHTRy55dxdCXjE1g/tfCRyEXAuFXRtYTqgXyvBv1zWBJdY65flQrLVUDG/Ei5VQCK5y51lA1iJzLbUzk81OXpknh2Jz4U0qu78OgASkWAlVixWQ5w/gXAOjcW41QKFU4bzqz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 01:03:57PM -0700, Vishal Moola wrote:
> On Mon, Jul 20, 2026 at 01:01:00PM -0700, Vishal Moola wrote:
> > On Mon, Jul 20, 2026 at 10:27:29AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > When splitting a large page in CPA in __split_large_page() we allocate a
> > > PTE directly without going through the standard page table allocation
> > > routines such as pte_alloc_one_kernel().
> > >
> > > This means the page table constructor is never called nor is the page table
> > > marked as a kernel page table.
> > >
> > > The former results in the folio associated with the page table not being
> > > marked as a page table (__pagetable_ctor() is never called thus neither is
> > > __folio_set_pgtable()) nor are statistics updated to reflect
> > > it (lruvec_stat_add_folio() is never called).
> > >
> > > The latter issue of failing to mark the page table as a kernel page
> > > table (ptdesc_set_kernel() is never called) is far more problematic.
> > >
> > > Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
> > > tables") kernel page table freeing has been batched and since the
> > > subsequent commit e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries
> > > for kernel address space") IOTLB cache entries for kernel page tables have
> > > been invalidated upon being freed.
> > >
> > > Since split page tables are freed without this invalidation, the IOTLB can
> > > contain stale entries for them.
> > >
> > > Resolve the issue by using the ordinary PTE allocation API at split time.
> > >
> > > This results in these kernel page tables invoking a page table constructor,
> > > and thus requires a page table destructor.
> > >
> > > Since we cannot assume one is always present (early allocated direct map
> > > page tables are not marked as such), we conditionally call
> > > pagetable_dtor_free() if the PG_table folio flag for the ptdesc is set,
> > > otherwise we free the page table via pagetable_free().
> > >
> > > Regardless of which path is taken page tables marked as kernel page tables,
> > > which now includes split page tables, take the correct route through
> > > pagetable_free_kernel().
> > >
> > > There is a user-visible side effect in that split page tables will appear
> > > in nr_page_table_pages in /proc/vmstat (as do other kernel page tables
> > > allocated after early boot), however this is a positive change.
> > >
> > > This issue started being markedly problematic after commit
> > > 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables") so
> > > choose this as the Fixes target.
> > >
> > > Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > ---
> > >  arch/x86/mm/pat/set_memory.c | 21 ++++++++++++---------
> > >  1 file changed, 12 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > > index 301fb9e77d91..a67ca33b9dd1 100644
> > > --- a/arch/x86/mm/pat/set_memory.c
> > > +++ b/arch/x86/mm/pat/set_memory.c
> > > @@ -439,7 +439,11 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
> > >
> > >  	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> > >  		list_del(&ptdesc->pt_list);
> > > -		pagetable_free(ptdesc);
> > > +
> > > +		if (folio_test_pgtable(ptdesc_folio(ptdesc)))
> > > +			pagetable_dtor_free(ptdesc);
> > > +		else
> > > +			pagetable_free(ptdesc);
> >
> > Lets not introduce more folio-ptdesc crossovers, we're trying to get
> > rid of them :)
> >
> > I believe pagetable_dtor_free() should do what you're looking for on its
> > own anyway.
>
> Actually, looking at it closer, maybe not because of the conditional
> portion? But that makes me think it might be better to just replace the
> ptdesc_clear_kernel() with pagetable_dtor() in the free function...

Well some kernel page tables are still allocated without ctor (early allocated
direct map for isntance), and if you did pagetable_dtor_free() it
unconditionally calls pagetable_dtor().

The ptlock_free() and __folio_clear_pgtable() there would be harmelss (no locks
assigned for kernel page table, and if PG_table never set clearing it is a noop)
but the lruvec_stat_sub_folio() would cause an unbalanced decrement of
nr_page_table_pages.

It sucks, but until everything is updated to call the ctor we have to do it this
way :>)

Cheers, Lorenzo

