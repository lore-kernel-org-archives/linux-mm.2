Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A26606CB3F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=oFz0dNxn
Received: by kanga.kvack.org (Postfix)
	id B09BB6B05D9; Tue, 27 Oct 2026 08:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1BB6B06EB; Tue, 27 Oct 2026 08:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E5C6B06FD; Tue, 27 Oct 2026 08:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8101B6B05D9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:29:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F18D1C436F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:29:59 +0000 (UTC)
X-FDA: 85368338118.07.3FC5BA3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id B00C914000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:29:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oFz0dNxn;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793104197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEtKC47I2aW92wCX8ceE3Qq4fHsnf6t3ajY/y/wrOAM=;
	b=hr0q8ivZyvdExMu3nwPww0ZpxJuxNvY6AQBSQRa+ApEsU0GpcjZfqp9Vs2f8oOOQ+56Msa
	GNGdtw6OPmzvd3jPnyX6Vq1B5sr7j7bbeC2adgYespIVt0FVIY6SuK6+RDIvjz9jaUTN/N
	tzkj3Dp4BPhtOQXKuHU+Hwp4yI//mzM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oFz0dNxn;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793104197;
	b=o3Nyyejh8H2fR5E/pzXlTOOh+1HlrdTak9IqvTxjuxb6+k9Hc4e0m82IFOdHORQMBG6DOt
	SySVkMuBof0JfPhTHSam1R4g66Ic5euSQLArEozy0K//zR+LF56UbaukZXc+WwiiB+Gc5l
	wy3sPvlmplaRruft3OQjFYm3MFfQt3Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TEtKC47I2aW92wCX8ceE3Qq4fHsnf6t3ajY/y/wrOAM=; b=oFz0dNxnz56JDogfZNZ3EcKBOe
	p/m3wd/aD1ouGh7D5TT4x8mldu1x54Im/ac1rqMMevZmEidyYtcN+ivOlf2Thn6SpMf5YxmBpAoTQ
	ACQ0QZ5dqhlqIrZJFZjdD32yrkKpxhlXJcDwBYr4es40imisWDbsX65FBBPCyvIXijJMwJJram/IE
	tBMccaHODu2a+6WaIkXlsMgQHpOeXupPOOVG2c+EnHZEn2cTe8Z/8tIneZpBMPZziWd0bkrYlaqgs
	dLt6KjEQnal4f+pZgXQXpUoSzeTKvhdXVCgTa2N2pkLnI3dPR2NYs/RNJlgEklMwTx88Hl7DsRiJc
	aetUoipA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLgJJ-0000000DUxD-3wq1;
	Tue, 27 Oct 2026 12:29:50 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3EE4A300DB9; Tue, 27 Oct 2026 13:29:49 +0100 (CET)
Date: Tue, 27 Oct 2026 13:29:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
Message-ID: <20261027122949.GB2668804@noisy.programming.kicks-ass.net>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <20261027121323.GO2668564@noisy.programming.kicks-ass.net>
 <auCXVv9yXtaS42w8@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auCXVv9yXtaS42w8@thinkstation>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B00C914000D
X-Stat-Signature: 5hkn7ub7br6cb7kdgyzchgg1o54snphx
X-Rspam-User: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793104196-765459
X-HE-Meta: U2FsdGVkX1/Zf9F2RhQ9E3y1KLvH7ujXNGbw7aKBC80EolYmGRycwZf5GWvqGUh8bK2zd3NcgXnHdjQTmsPZVsTzBDDKm1sBgttNq/c3OhRYCvWMcxYdt76IqxQMslq2H/1EbmkUkngvS7YSC8jIOCHII5trx0EOD36THdfzokpIj+mMIK7qs6eCfAHBsx8wVtJUu1U3O13+RNselreNYkJyVJSF1bu+AARQwEnSq2IdOPeFdcPJVZCXdIjCAgkIJ3LSIrVBXRLTFhN2BzHdxAJCn7QaiaSKzLt7v56v6oJZf9vk36N7gDvmdMN5TH48vBTbJvXtVFHbwRYzWHOGBJT8ijSUvCBwISk+fvW+/e4n59O38Q3CVWgLXqc/1ii8S9IeJ4JO1pvwaLlz6V3/TiRp9EVTj4RxlNui/bFI5fQ5EgrgRTioDMcecaRfNpv1Bx1A9Y1Ln8+49Vy66vpKffQrdUFsVprJDe4n6Oa2NYNgDV9Il/VKi9J+y4xjX+eOhgWPnxPR/zlgjmhD+U8xggeeYMHfBR5RywuKOYLtbyLxPYfTOp8+/PvR62rHWp7ySAaoVdivuDmKWt9S2BKE9uENF+zNrRPCsDRqzSJtwFTpnGOQD1/LSS5vEkKN8FnvSJ5qas1sR0kUQncrJov0OpTmxiHGXDnptxxEtxDcNSnZZ8XaB3Tidu/UYT38HsmWcL57f7fkLz0GnA+rM+G2k17KBGWZcX454g00MWvMfV59eP544gedAMX7Oa6B29LnowcvFm38EjzcWZlpP7WUHTq0UqGgOoAPBFT3y4Dw8WUmS1ga/8pGI43YvIs7WAUWbiXWX/oQ10DCTsIZG9uq137hpnDeVDI/GRXWWOULY1r4uKuAylw987YIdYR19cs26LTVg4LImEY7SnskThWZGz8aIhBun15/Wrzaa2ync1q7Z8ct5v1DwXFfVCRMw9hjI2jzqMdRKpPUMQqDEVs
 Lr5HOWKv
 2Su3qmMFq/IAfAuK3PXhmUDWsMcI75bLnKC4Osf4o97f4KMMeXddJcGtSKqPT2WfCEnbEQq2OfOHiXJ+hw7rfEqvO3xKfFwScEoIkIeVS/8H3qsZUbZZSElAA5u3XXTHjczOE0sjWaQ+xBP9jKyXNb8hfUhJgqqep98UR+TURNYeVPgkcjS+S6m2WLFeACUyAEohrsSrYfpGOR4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:22:56PM +0000, Kiryl Shutsemau wrote:
> On Tue, Oct 27, 2026 at 01:13:23PM +0100, Peter Zijlstra wrote:
> > On Tue, Oct 27, 2026 at 12:00:47PM +0000, Kiryl Shutsemau wrote:
> > 
> > > Fair enough. Here's some context.
> > > 
> > > HVO (HugeTLB Vmemmap Optimization) frees most of the memmap of a hugetlb
> > > folio by remapping the struct pages after the first vmemmap page to a
> > > shared page, mapped read-only.
> > > 
> > > Every lockless get of a page reference (e.g. page cache lookup, PFN
> > > scanners) relies on page_ref_add_unless_zero(), which is
> > > atomic_add_unless(&page->_refcount, nr, 0).
> > > 
> > > The page can be freed and reused between finding it and the get; the
> > > zero refcount is what makes the get fail. The race:
> > > 
> > >   lockless get                        other CPU
> > >   c = atomic_read(&page->_refcount)
> > >   c != 0
> > >                                       page freed
> > >                                       page allocated as a hugetlb tail
> > >                                       HVO remaps it read-only
> > >   try_cmpxchg(&page->_refcount, &c, c + nr)
> > >     -> write fault on read-only vmemmap
> > 
> > I missed a little something here; page->_refcount is in the page-frame;
> > how does the page itself being RO affect this?
> 
> Emm. I am not sure I follow the question.
> 
> The memory itself is not touched. HVO remaps the vmemmap, the array of
> struct pages: the part that holds the folio's tail struct pages points
> to the shared page, mapped PAGE_KERNEL_RO. So it is the struct page,
> and its _refcount, that is read-only.
> 
> For a 2M folio with 4K pages, its struct pages take 8 pages of vmemmap;
> the last 7 of them map to that one RO page.

Like I just explain to David on IRC; my brain has a 1:1 relation between
PFN and struct page. It makes no sense for struct page to be RO, ever.

Anyway, let me try and figure out how all this works, this is 'weird'.

