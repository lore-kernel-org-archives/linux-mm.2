Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4F75C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 20:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE42D6B008A; Mon, 20 Jul 2026 16:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB2A6B0092; Mon, 20 Jul 2026 16:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0236B009D; Mon, 20 Jul 2026 16:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 761D36B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:04:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0172E402B8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:04:03 +0000 (UTC)
X-FDA: 85010231208.17.1933105
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 346DC1C0011
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:04:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FKn78+I5;
	spf=pass (imf21.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784577842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0B7Ue8sunnZ4lhynaJhVBIqW08g9nfoJaXMan4+HMrw=;
	b=Nou13aWl54TdmKBeLL2RxzfndG+FnnAdyUb74aNOAGocBa/QVzRGtK7qJs+9BXoR3Z7VA5
	0e5dcs1610w2y4HgqkyNBW7MU3rrzB3MDh0WJto5Ve2DYKXEkqlu2GThphPnTAbti6yuCJ
	LdBC/m28vN0WCVvyMYJOXHlfESLHmQ4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FKn78+I5;
	spf=pass (imf21.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784577842;
	b=c/fzDn8S6ca0eA94dJBzc45/9SU1/w4qxX8kvDggXZbV0ImXwin85fZ4iVBWLOtQJr4bUn
	4otPaKKNSa2c2bqz9BXcZdm9Wgi1ZUYZrnb1UJ+4DuMUhe2XC5rZa919ELceySrH3GDltI
	U7oF+GSU9Fjw0Y78Hw630y4S+8POF/w=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84861fc51f5so4822699b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784577841; x=1785182641; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0B7Ue8sunnZ4lhynaJhVBIqW08g9nfoJaXMan4+HMrw=;
        b=FKn78+I5LE13spyZDftdQhBPYFt/qmdi60GWDebHoouQKqO+XfAmh9vnLcRjyyhTuE
         ct6BSliealTpjxc2oj5hyNsumkaxgVOrR7Q2+2JGkZ6nvo5ZW5xOUe+eN9Jccname9Vd
         I9clRYrTxZmydjMse4LIYpy/AAaHCyWUcxuJSWExwwGRAaOkG2CBE2p7RkCmse8LmAtI
         IkoIWPYXbdsVUciTEd/EJ3gO/64zwpmkCH2aV4+0TbOtXuIwBhCcUyNShZbbEFwtoNQB
         kJUzEzO6FXCoQJpWu4H/m7Isatoa0be46gqjae6sTtLN/yl3XcHW+UKfEK+7N5U9IPZq
         7xlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784577841; x=1785182641;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0B7Ue8sunnZ4lhynaJhVBIqW08g9nfoJaXMan4+HMrw=;
        b=Mazu+LAiusj530s5B4j3pJGK600s+3SiwIvukNb3vIbeKeWQv7liUMsbMadLMhfkmb
         IPpcVgT6C2wzoKcs3s4SQb8hmWW69xPRQDWj+5DwL3DeLHupY3u2M2VNjWEOKQTo6/FG
         HPsUlumMjZ1G/qGH9oN+QmGHi6KNyFaKYCIHlgI3tGQnlJEK+IdDSpnvT/LeL0hhtaPn
         um0vrdsE9ZgWN6nVrs9wtcOrl/xsD9jScLnUP/3gIwnYcLhJ4FcP3O20WG3snK/kSk30
         dR1BSWUevPEEYSxF3hyOt/u7x/aXfeb0hdx2Kvny3THd4iMttvNr5ds4aDW88hCixr+x
         kqhg==
X-Forwarded-Encrypted: i=1; AHgh+Rra6eV4cyk32O6uT1UshZjhggNILjNPtPAsnITgvMpjKVRADX09S9AcbLilOrbggwb1bnmKIkb+xQ==@kvack.org
X-Gm-Message-State: AOJu0YxBvK/75heL2tmDPIBSwnCbbH+RPcEDZF2XnxUz6z9IDu4H2f6z
	Xe+uVEi5vt6dnPAINP5CX8nhS/Y1N9/M1LB2saX8/aHQjGctBIDOtaOU
X-Gm-Gg: AfdE7cm+xwQANnU6LN+K0M3oCyNeIzJaQckyat0IQG2JaPVFMCG2dfU1oKc46fHeB3N
	XGhrai/MptHEWNWact7ESFhyHSAdzmIr9wuUJhPNXgiAic8VkNOpF2GAQPqiaXMle8i5gm3HgQG
	0hmWuip1DDV/rJXMf+efV9UrCbnfUQN7eZT/CWMMYCtCOz1oQOFP2k4jUeZYRQeaOwYbQrLH86M
	pKCj6PXlDW1Tz+UjAE7kiADdcq4JGKjJtFgIve0dRZ6qP1vUtq4XxHHnrxMaoqZv3zhQFF6cgu+
	ZUPje24Bk8ibq/7FuT5eTLscvgQ7k/ABN1cQKWk7NmSxDd7wipmCDxf0KCHxDBDMcujoIjzzz6R
	SwDWhG+J3Tbr8+Y/iyN+ihm9lxs82dWR/XY+l+OI6GtqfHuqQ4LQnWKkMR8r8/6X55wx6nnimMS
	hhtfxkur3e58YciIjaYCNMfCyTUK6mQV316w==
X-Received: by 2002:a05:6a00:92aa:b0:848:3dae:66e2 with SMTP id d2e1a72fcca58-84c2933dfc2mr15708445b3a.26.1784577840929;
        Mon, 20 Jul 2026 13:04:00 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af9af7esm5860115b3a.52.2026.07.20.13.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 13:04:00 -0700 (PDT)
Date: Mon, 20 Jul 2026 13:03:57 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Kiryl Shutsemau <kas@kernel.org>,
	iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: allocate split page tables as kernel page
 tables
Message-ID: <al5_Le9QlD4zlt25@fedora>
References: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
 <al5-fDRStgU6gjk6@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al5-fDRStgU6gjk6@fedora>
X-Rspamd-Queue-Id: 346DC1C0011
X-Rspam-User: 
X-Stat-Signature: zunn41rfiecyoa7h6ydx5emoczdenf3g
X-Rspamd-Server: rspam04
X-HE-Tag: 1784577842-46117
X-HE-Meta: U2FsdGVkX18WlXyrhYrqBqO/ylz/24P41RuzS0khnA73I2jGnfCtbZoYnmuSA5gM/ka7NAgqsjMJxtI/d2neVvz6+VMduzx1bzkd2EPs9BvLtgxHm/Ej0gPjmNLRJRl3RcShRXz+bdVyBjhvHJG7dKnPmu70PYWnA9kmAxpsdS7ZrAp2UskyfT/dPfQjeynkl4s1FvLF2gdtrPIcR0qY+TMcdhL39vVoE7bE4D1t3w6sVFd77xR9GDL60BzsY5Vt/0J5cLpO7OZ9xdPeUXZd4SXv9UOLmlri3ruBbsKFKjb6CR2loZtM+IG9bSOtGkWrFSmDQ0nBNFoSboH7zbJkKH3XphEPaJGo1AeAA/c7uD9IeHt9UXAuJ2R85/EbJvDuPHM0nyKxrtEDp9p+0vFvEl5L6Vl/+xkIF5tKfKOHHgc0s7AMTwokfUWGDD0HiYOM3t1myTwd8upvY+FaGezxTe80UtHEo/l+/WBOuFpN0atlOtDN8g2UlkcHh7bmrdyrU/or2ROEBIuQAygnQSXs2npj3M/uXbuEqB8rLzkc3CVDA8CRHfLloQw4uPVAGXmLtvTWGUAp0DpjNd74nAD9AaNdKMjqlwgjIBEAfY/SnmHWLff7+K0jaWXRXf39jLmoi/zgixivwuvKuvzpDMi/392SfCWeUQGbsBKOVit5dYywGqVnID/y2+dnejbHtOr8vPMLOeO1YR0k9GpDDEr9nKUcL6fRYPFxjfZSUdIfYAL6TVzCJ//S8HDQzCvT0ReblvXuzDXvEbKFAeHG4JFH54c1qunZqebYvhcYUQfuSueV4fJX3lG+1v6ZVL+04UcVwYbooR9UFnRai4NB/w2pPhv6mvBOKYrw5OFUZb/TLobM6wRXW+9D5slyZQOaTfrmDEImUU8X55wJQjz1eyNCjBpy+UhwdRw6EA5wQAO8rSBcGOxh//joxe4FccMkzSIvrHPEXPjYfxbF1rhI9Ql
 XnMb5Q+o
 aG17J/p/MUFg1whzfbhic/JQaHUjNTv+B3L9KdstQHE9pyZuqXvgSHY3UWTDiQ93xbf7t63OvDv6ORynv2l1Y+z7J2T0hsZFlNgYRxz9p5S/+k0OaA1SAUdqPeL6E5fQdcVQFpFOv1rS3zub//eV1tYrjRAtW8UXuyWIkbneP6fkZAs9STvJ11Fb34+P/9YNz09Pf98swIL9t8/qwLKt06/1s+tISELxR1LsdtpcpyHgGdGUK287rvCcncsQ7LrRXrXgSlInJDp/qMAAWJ9EkopbD+icBh3XMdxfzdB2NXtI+I9zIiEwhzWhvRwna6WUQSg08gP+4G1z5VSWQ/+rSFil4rGudU9UIB6ZCVaLpN9glJD5+JBTUi7g5Q9uHQEyh9/GuqdeNOMyleiHZyYa5/zJ1+TSEzeTzAfxBPWqtQyjaNWNlPkGTngiA8P4em7k2yo2aDBWUGeQq9yjDCtEwy43dXV+HfV91kGbNbcvlFW1HlmbcFSIQ1ldaF6o5njOIt0zCoPJDzSZpSX7Hsy66z8vbAqgDgpljL7HV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 01:01:00PM -0700, Vishal Moola wrote:
> On Mon, Jul 20, 2026 at 10:27:29AM +0100, Lorenzo Stoakes (ARM) wrote:
> > When splitting a large page in CPA in __split_large_page() we allocate a
> > PTE directly without going through the standard page table allocation
> > routines such as pte_alloc_one_kernel().
> > 
> > This means the page table constructor is never called nor is the page table
> > marked as a kernel page table.
> > 
> > The former results in the folio associated with the page table not being
> > marked as a page table (__pagetable_ctor() is never called thus neither is
> > __folio_set_pgtable()) nor are statistics updated to reflect
> > it (lruvec_stat_add_folio() is never called).
> > 
> > The latter issue of failing to mark the page table as a kernel page
> > table (ptdesc_set_kernel() is never called) is far more problematic.
> > 
> > Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
> > tables") kernel page table freeing has been batched and since the
> > subsequent commit e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries
> > for kernel address space") IOTLB cache entries for kernel page tables have
> > been invalidated upon being freed.
> > 
> > Since split page tables are freed without this invalidation, the IOTLB can
> > contain stale entries for them.
> > 
> > Resolve the issue by using the ordinary PTE allocation API at split time.
> > 
> > This results in these kernel page tables invoking a page table constructor,
> > and thus requires a page table destructor.
> > 
> > Since we cannot assume one is always present (early allocated direct map
> > page tables are not marked as such), we conditionally call
> > pagetable_dtor_free() if the PG_table folio flag for the ptdesc is set,
> > otherwise we free the page table via pagetable_free().
> > 
> > Regardless of which path is taken page tables marked as kernel page tables,
> > which now includes split page tables, take the correct route through
> > pagetable_free_kernel().
> > 
> > There is a user-visible side effect in that split page tables will appear
> > in nr_page_table_pages in /proc/vmstat (as do other kernel page tables
> > allocated after early boot), however this is a positive change.
> > 
> > This issue started being markedly problematic after commit
> > 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables") so
> > choose this as the Fixes target.
> > 
> > Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  arch/x86/mm/pat/set_memory.c | 21 ++++++++++++---------
> >  1 file changed, 12 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index 301fb9e77d91..a67ca33b9dd1 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -439,7 +439,11 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
> >  
> >  	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> >  		list_del(&ptdesc->pt_list);
> > -		pagetable_free(ptdesc);
> > +
> > +		if (folio_test_pgtable(ptdesc_folio(ptdesc)))
> > +			pagetable_dtor_free(ptdesc);
> > +		else
> > +			pagetable_free(ptdesc);
> 
> Lets not introduce more folio-ptdesc crossovers, we're trying to get
> rid of them :)
> 
> I believe pagetable_dtor_free() should do what you're looking for on its
> own anyway.

Actually, looking at it closer, maybe not because of the conditional
portion? But that makes me think it might be better to just replace the
ptdesc_clear_kernel() with pagetable_dtor() in the free function...

