Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AAB3C624D6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5576B0276; Tue,  1 Sep 2026 11:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD416B0277; Tue,  1 Sep 2026 11:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4306B027F; Tue,  1 Sep 2026 11:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7640B6B0276
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:45:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5450160441
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:45:44 +0000 (UTC)
X-FDA: 85165618608.18.73BAD54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2D352C0002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:45:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZTvYdEaL;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788277543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVHtz6Elr1SZh1A7h5PnNFYa2TvXIJLXLTfOMhtO9T0=;
	b=ksAr4wlsuUVGr049r1b4IIZUr5XXatXUbnFh5gwxek0pZYynQwwLZn82lMhQxkaSWD9ZHg
	kpNUwgqmkXRbIuKUMV2mDGm9i+PJ/iObDU8ob1NKQfI2Udj2cKW0ncKP9ZVhm4DdK6h5TK
	tLEf6Ie1BYfkkFSKjY+SQkee7OIVJ0Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788277543;
	b=GF0u/pbFjaWYD3xu4YIQ38DQn7/3DnCkU2BWjDxeYeRZArNX8HW627+004HTH+LgSpkinH
	tQ3DMG0CMd3QN4kF8bdRRk1IO6HcJOVbGqiVEt1r4qRCcKhuhl3XdLLFE9HeJm7O05lF4S
	S052u9hbgoPjpD9k/W7dorXrUbErLrs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZTvYdEaL;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AC84434B4;
	Tue,  1 Sep 2026 15:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951D41F00A3A;
	Tue,  1 Sep 2026 15:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788277542;
	bh=UVHtz6Elr1SZh1A7h5PnNFYa2TvXIJLXLTfOMhtO9T0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZTvYdEaL17Xe57XD8vyZST14VBPRctjf28yyFGBI5rdY8BhdwP/dFY55tWjPYAROH
	 wHw1cZaETEpdGFMWKgfrhKvyrIXd6bJDtcydcX3/fPqK8Kfi5IfzcyNr//cMw16txd
	 HFiCeAX5f/1+Nu/YL3SO5aPns4ylRzukBeENUY24mi7KCFX+k7s14AOxgxiOOtHlum
	 W6G9F88xDUVcAEipO83iD5JtJTIZcqLoGsvrFg6C9MQ0JUePRMRswDgKmoAF/Vk71T
	 gM3PMpQT/NErJ7UkLFICeRZsY2Bjhj6d+sZWTtE2+9Pnuydiw13BrWhOWFQOR8QNap
	 Lu8bcy8/bQcbQ==
Date: Tue, 1 Sep 2026 16:45:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>, 
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne <shorne@gmail.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, 
	Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 01/12] mm/huge_memory: zap deposited page tables after an
 RCU grace period
Message-ID: <apbvoN6ttgHfI_xg@gremlin>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
 <apbOlyF77yDCV4cF@thinkstation>
 <apbcoMTVlL42G5tg@gremlin>
 <20260901142408.GA56830@ziepe.ca>
 <apbiB51hjm-9pRzf@gremlin>
 <apbuO_QveZNAz3ns@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbuO_QveZNAz3ns@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D352C0002
X-Stat-Signature: yz4tx6iy87mfam14uj8o55bzf8z6oz9d
X-HE-Tag: 1788277542-243050
X-HE-Meta: U2FsdGVkX183Ow3eZJxO5Ko55h7A8BwXbqAqI0aSp4qWtEsVwFDLdOsvzTmDxIVYrYFgKonIBODuHsuv6mo8a8aT7RJfT0UTiv/BrIU/mB6AJ7ou7jrU976VxxfrSoO34z9kWRwGj8YE6LiiqOdJQyv19Bz7v+ViiUA0A+8IGstgSUsdNR0m6LJ8Lz7bFvGNoIJdczK8DCDQcxof5DIqhK+EcUVsRALJ8QTLgW+XqO4EOY70cRtuktj+NZFv7ZdaR59W48NLPgQohtpvxpPLztnm7ujfsZtWs0bWu3+ftyrwDfRn6KtfxbYjie1bhmPpk78595nKIrKP5v+K44S3ARPtmcP82JbXEZ8bWdwwcWzWfOfO4HYP162JLlyC/fL+zAF1wawInjdoON2t0ZSW/F6eEPKQ32WGNGoOMjevmBmKRMZ/wQbWE/H08krl99bY7CGRKK8F9/6OVOAdHasA+VPrFJ/VqgOOYDMmprbB0YpxAjzhCj9UdnO8hMpqEBFtLDjXsCqkcm4ubGH1HG6q9ssU6QL3yJ4++ZOzyzu94eMfrQGTkS1/vCoqKAj6GdESMeW/QJ8j+OQcAi6srwO6J2PXsajH4NPDYzomk6sFjqHm3QFcv0MmHVa+er5u9yjJx5bCE2qeYZKhXdY9xrNLEXxqK7E5k03LugDTu/09pKp3+JHpcFdas7U1V9pgonmltbkYFiD3b240DvDIeFTjKLO9vwfIYLtx4z3u63g8+yUSKCbsRP9eNFniF/UpFQ/L95sHSZ9pz8rSB0aQwaLUKeWD1fzUbiPgzulKYTaC6hqT93oCIHzsCKmNAAYyUdfZImx736K3BhLam+tEy0gwq5T2sONagVkJCltcxIQDQ9KCUGPDpe7ED9qJ8iyoUGwOdog7PPI6j8wXG8bjH2iNVY5nuqYNZ0nvU4HVSdJgESx6Ho8lZkT2yQI5SE0ZzynW233RboklFMoUmhGEUoz
 34BAtbnY
 GVEWNXI0ek1FDTPjATsKqaSrtn8yRnlFtuP14evd1+dhMzzaDk447N1zZCKe1MG3aArzBDePRGzvJImXmbFz57HG0RVY+kwpElh3heGFCa95hLVX8V1+VLeFk22Y0iKQJDlESK8M/h/Jni8qrZ0DIlQs/lQqXm+8at8qVzGeyD2KhRV+Gfwe9N+8Z4efkfzv5//Us3T6InPEwu3WH6FfnTJ2NLf55HHoF4HGaUEITUOOWfnbRRQkPgBc1S944NA1QYc1N+uyUyMbAI8QJYMnNZsxjfEfvo+cks2lRQ/opqvEVHtK7MGt+IH8E9aA9kW2RZ7Z8PKO7Z+DL+H3tqYFUrxsXK42mptaA3WHR2pEndfcLc4rARb+X5mz/0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 04:28:48PM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 01, 2026 at 03:41:17PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Sep 01, 2026 at 11:24:08AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Sep 01, 2026 at 03:12:45PM +0100, Lorenzo Stoakes (ARM) wrote:
> > >
> > > > It won't be costly at the time of the calls obviously as its deferred. Maybe
> > > > increase some time spent in softirq but again is 512x that big of a deal?
> > > >
> > > > I'm not sure how you'd both defer the free and somehow utilise mmu_gather here
> > > > either really, certainly not without it becoming extremely messy.
> > >
> > > The less costly version is to thread the page to be freed onto the
> > > mmu_gather through a linked list in the struct page memory. This is
> > > super cheap since it is just a singly linked list operation.
> > >
> > > Then when the mmu_gather is flushed it does a single call_rcu using
> > > the rcu head of the struct page of the head of the list. The callback
> > > clears the entire linked list of pages.
> > >
> > > Since you have to tlb flush anyhow, it makes sense to always use the
> > > mmu_gather. For example the design I ended up with for iommupt
> > > accumulates all the invalidations and all the free-able memory into a
> > > gather then invalidates and frees.
> > >
> > > This allows maximizing the tlbi efficiency too. You can't do call_srcu
> > > until you flush the tlb and if you call once per table then you are
> > > also tlb flushing once per table too.
> > >
> > > So if the kernel really does want to clear out 512 leaf tables the
> > > optimal implementation is one range tlbi for 512 entries followed by
> > > one call_rcu to free the memory. Hence the gather..
> >
> > I think there's some confusion here.
> >
> > This isn't the path in which a page table is being freed, the _deposited_
> > table is zapped, in zap_deposited_table().
> >
> > That is, the page table kept in reserve for THP split, that is not
> > currently mapped.
> >
> > It amounts to a __free_pages() call.
> >
> > The TLB operations are in e.g. zap_huge_pmd() etc. and nobody has
> > complained about inefficiencies there.
> >
> > So, unless I'm missing something here, TLB flushes play no role in this
> > whatsoever.
> >
> > The issue Kiryl raised was that instead of immediately freeing page tables,
> > they are now batched up individually by call_rcu().
> >
> > I personally find it difficult to imagine the numbers here would be
> > problematic or certainly cause anything observable beyond what is
> > observable now.
> >
> > So I'm going to have to say, unless it can be clearly demonstrated this is
> > problematic, I don't think there's any reason to add additional complexity
> > here.
>
> It would be nice to measure munmap() overhead here.
>
> I am worried about hitting DEFAULT_MAX_RCU_BLIMIT and trigger
> rcu_force_quiescent_state() which can be disruptive to the system.
>
> DEFAULT_MAX_RCU_BLIMIT is 10K, so it is ~20G of THP unmapped on x86.
>
> munmap() of 64G worth of THP should be enough to demonstrate the
> problem.

I mean you're going to hit that from RCU freeing page tables already, which
most architectures already do right?

So if RCU saturation is a problem, that problem already exists, but I've
not heard of that being a problem at all?

So you're going to have to demonstrate why this situation is markedly
different from that. And it's the same scale.

Overall I think freeing 64 GiB of mapped memory all at once will inevitably
be a slow operation, freeing them directly will also be a lengthily process.

And also it seems to me that RCU mishandling heavy load to the point of
causing system instability should a bug filed with RCU no?

Also note pte_free_defer() is already used in retract_page_tables() so a large
collapse could also hit this problem?

I'm not sure I'm convinced there's an issue here.

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

