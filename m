Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBBE8C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 10:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1496B00A1; Tue, 21 Jul 2026 06:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B7F6B00A3; Tue, 21 Jul 2026 06:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC5C6B00A4; Tue, 21 Jul 2026 06:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CB536B00A1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:32:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF7A41C03C3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:32:57 +0000 (UTC)
X-FDA: 85012420794.28.94FC8F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F8A6C0002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:32:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhA9VFRm;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784629976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mspC1fdG+pvm63GGOQ7/xTAnO2WjExN52IoSROfvj/Q=;
	b=HOvHvFIKqyPfJRCSYfMn722gU/jCqovo0x+Wa/qL34NWMrmFiP4WEqXeqN5FUJjLfxSv+3
	NSfpD38RtbkIfvvWC7vJzeqR9IJw9ovRODsz7lV3pzPlcZ8AynxDzy3KodwyTp5MP8H1Wr
	1kX7VHekPDZFryE1EpWXSUI3/s/cuC4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhA9VFRm;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784629976;
	b=NmUsgLQwDee4EOisgyiipdg11Pl7VOzWdbDa0hfeVwkbvi7LMRZpnNlg345Egyx8Zoi07H
	qpxHX83nRcXAMBoUJohhm7ClGcFOQkMr7fMMVgHX/XuljtYuzoHvqi8LDSH+wO7o0TEQR/
	UQ1RZohH/ErUjwE74psjxxtDapShDAk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A991360A95;
	Tue, 21 Jul 2026 10:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E511F000E9;
	Tue, 21 Jul 2026 10:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784629975;
	bh=mspC1fdG+pvm63GGOQ7/xTAnO2WjExN52IoSROfvj/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IhA9VFRm5IdbLL+pEstMzqMhkdBytj5LItEqDpa1Yq1SgODLuKNcDGyr3S7LyFhg0
	 I1tjMsit9yiuPWJquHM5hmxH7ZW89EasFRtXDDEXDQ24GNhR3Tj0h64K5WgpOUKs2E
	 ppTD3mLmWLCXMDQGXrBZ7kDNJBh7R+J60fex/Ps6JTXB0wMWRD6AemPEvh0E89nT47
	 g3B2vlw0SdP7IkE3EWCOE7Zny3Z8k6NCjiJ4P5/Hh7SjRTOf9NYb/t0OuL0MR+V3R+
	 Sg/8rD57YwRLfQENAOAd3xO1iXPQ44H1qLKink+8bEAqZJgYoEpsFZwEPKdPoTtlf7
	 Q28eR8c7qDh1g==
Date: Tue, 21 Jul 2026 13:32:44 +0300
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
Message-ID: <al9KzIhKXa3PCMqa@kernel.org>
References: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
 <al5-fDRStgU6gjk6@fedora>
 <al5_Le9QlD4zlt25@fedora>
 <al8hE_ded6qyWiDv@lucifer>
 <al8_xx_99BjAUn5A@fedora>
 <al9BpTu2ma8GpiPW@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al9BpTu2ma8GpiPW@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F8A6C0002
X-Stat-Signature: 35imdst3jodk5y1wud6edjh1r5a3gaqu
X-HE-Tag: 1784629976-854297
X-HE-Meta: U2FsdGVkX183t0WQZ9k6v+2YlAD8wNmnT9lDn+t/ZRuzSKxuxws4gopAl8rhueySrVWqaZuS8BsQbhwKyxgjquz07f6VExqcP/TbRVopro8x/35bJv1ViEp+bQ7CcV03snLIEWDvUMe+1bJTOtYN5iMTqRX2aJHUMJZJBCTSjdLXi/TXottJ9bprFrlKPRx99kWqN0Vcu/07veQLnW61v04ZEKefiZ6gOkKvtC9a7dbXBKtPBbtxAwaIahHE1X6TJwOgVXRNF3rozWj/AjsKOYmV/3OrXXGG3DZr7rjMLNDvkSCPJ8Fx23w4ELpmQI74HE0xx14BEO9YWV46NxKdWwUkd3IhIepBozSsVyou48HEZnWRJxgDkqX0C4J90iW1lAjU29brkGP4/N+W+JyDbv4vQgRxjSi9jvTtSsq/T37td92d+cko2lxgxRqUXeKD+7JZ6hGfV2qvF3NS26XInHnZLh9SzvkE702p6ZLTzGXp3swgzI+CUGh67KXyt60Dq4+66jY9dZeOwm0lt6nkL1dEtct/yo5dleRvjqEASmX9lz1rXsANzhyaG5bvrR4WGTSkCB4q4KNpmfxMT4i+zLBaMgTj7gHQaVPvPF17KO+KexbuprFw4Xzm//mRvdzwQidTnXRWqCuuJx5OIfti+PG+zVG05yoDKhGNkSZXqGIR58S7Rp9mRNkNj6Y6eCGAE+wF+H4MIYt/KWGVH/LeO5aeo4saPzJK/PNv48Y6aqE5IMgfxpBEht404jmlB2e2CuxDXKKO3E+RsHVsgzmB+tB2/vxhU5afJiKjE6V+BV6RK55113xxFYdbMGkZWVMaECrp/5Yxa8f+njpsA7jjwXfnC3LDGSPlrIsNbsn9SjiexeChgi1wbDvmOlSl4m8iQNAkGQltrhpRvqEEmxOh1emxqKcCQpgDsauTcrO8JLe9tO5VKI4pK4YUNGYof8hLsQfQjuq9KbyJwas1aTm
 peNNhpKy
 stMoA5E5K2QyIMGzXtbFIyRSRSB1d0s2xsqchR23CmOUsQ1OsbmMK47eQu95JBUW+tCbfYBnEfPl4yroKDlRwAm25ZdzciqqVRSJnPIpF94P3XJ4f9/W6l6Nb8Hsvb4SM7vCYcISdLMzblsm5+NEWFOtrdeK95JNJW4K+VOCppjZ+RWRFwZMcTt7rK3/IJfQwYdzfgnt+NzCuy+0j2op6o6aKGLgOuCBtr/2jgfadVEViUlK7aLBM6slFpAbfT8LgCjdVpm6Gg9aMRAzB/uoThzg5zHdE7CG4IYxQXjZaKAWlymwRZkdmV2tmIYWQzC8TcMo9JAoEYJ/IL4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:58:50AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Jul 21, 2026 at 02:45:43AM -0700, Vishal Moola wrote:
> > >
> > > Well some kernel page tables are still allocated without ctor (early allocated
> > > direct map for isntance), and if you did pagetable_dtor_free() it
> > > unconditionally calls pagetable_dtor().

TBH, I cannot think of a scenario when page tables allocated at boot would
be collapsed. But surely, checking the page type is safer just in case.

> > > The ptlock_free() and __folio_clear_pgtable() there would be harmelss (no locks
> > > assigned for kernel page table, and if PG_table never set clearing it is a noop)
> > > but the lruvec_stat_sub_folio() would cause an unbalanced decrement of
> > > nr_page_table_pages.
> >
> > Gotcha, thanks for the explanation :)
> 
> No worries, this is subtle stuff with lots of weird gotchas and stuff we need to
> improve... I seem to have fallen down an unexpected rabbit hole with these fixes
> :)
> 
> >
> > > It sucks, but until everything is updated to call the ctor we have to do it this
> > > way :>)
> >
> > Yeah that makes sense. Although I'd rather see the condition as:
> > if(PageTable(ptdesc_page(...)))
> >
> > We really shouldn't be calling ptdesc_folio() anywhere anymore.
> 
> I think better for a follow up since the code already uses ptdesc all over the
> place (fundamental to the approach really, keeping a list of page tables etc.)
> and this is a fix that needs backporting.

I agree with Vishal that it's better to use page type rather than folio
type. And it's the same for backporting ;-) 
 
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

