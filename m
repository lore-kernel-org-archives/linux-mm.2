Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7411CE9A050
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D296B0089; Thu, 19 Feb 2026 12:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51D66B008C; Thu, 19 Feb 2026 12:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73E36B0092; Thu, 19 Feb 2026 12:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B08F06B0089
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:09:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62D8813B33B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:09:28 +0000 (UTC)
X-FDA: 84461842416.01.DAB10B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3B20A40005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:09:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=INfCcHOX;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771520966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RF6fIe1dWg90W3WP6sBte2ivo4cLjVmpWh8MfuGCUiw=;
	b=G2FXzETACufZj0qbM1W+Gjdp+cotHC76VNJPZiriacY0G+kCpls01ntZ0rEGipUIzwTDGr
	IG31j3+nG/8TF8XT4U+Aw/9Sn97Lf7jmVZlQMQEfc8jDe3v/i6QRyxv0nzhdx57AhJpCNj
	Z10dSeXrhvbVM0VgVFuCIWabt1xYrE4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=INfCcHOX;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771520966; a=rsa-sha256;
	cv=none;
	b=jLL2WR/8NTTKwEj0N+nYA3+UW51bcPMmD5c3Z/y1tsK+ZKefjoPeLMwaxpkXbWnql1+d0V
	1Z+y7KILGa2HqwcjqPmdBDmcByBMNs+zy0q9UP9AOudHn1G1PAcIZRTeYttrxYRUXoTqMC
	0gUe+5dhp4/RB6xaESozbus891r2S0g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8AD740191;
	Thu, 19 Feb 2026 17:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167FAC4AF09;
	Thu, 19 Feb 2026 17:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771520964;
	bh=Arf3GuZbA0oOJjMx3rdQNjKjtljaiU0usN+TEMB1Fd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=INfCcHOXLKjIP42CWl+0QhCwfR4zMWPt9ZoitfO6rHdXwJKn2IDqOp6MGN8Km+oEv
	 nME2rbn+NLfoHCIrDQwiYf+5J4Qx3u3LP+9cSxXO5tEpqMMgnhgpqGavKXyP/kvJK2
	 ziqwkYdqS974bLFhFNEux8yX8aTeFaSP3qJGFzNq5rglCi7FMAe9twuzmiasqVpVBq
	 m8hZYhKLQzKi0k5TNTbJTyx9TStHVPwKzDuSGTuKIKmhccwWLQtysHxxHaOhdDwKlB
	 /nokb6QZddj4oLuFZDkjUbQtLhQoizHMAsJeX/h3MDBBHfKwOQ7HRXdqitmg6C12pS
	 +fcHioaK4aoGA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id E7538F40068;
	Thu, 19 Feb 2026 12:09:22 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 19 Feb 2026 12:09:22 -0500
X-ME-Sender: <xms:wkOXaXx--V2-T7FlsS_hwgwUwXiJ9casTL9wNi0LrXSKMW0C3rsHJg>
    <xme:wkOXaRnnJ-q5PBJmHtQR9TusfyWTxyurBP1HlJR4rVdj8yB2w9Km95Y9lL63NGMJE
    qnY2SkNy_ofHlcSL41VPJxkmvenwHQSteZmegfNjGcSeORBtxOhNuE>
X-ME-Received: <xmr:wkOXaQA5fWLSBZ39skm5xNvu1kmWQGOZl9m8kIE0ZZ-ziY-oldaJi6td1DVI4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdeitdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlshhfqdhptgeslh
    hishhtshdrlhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhi
    nhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthho
    pehmihhnghhosehrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnhekrd
    guvg
X-ME-Proxy: <xmx:wkOXaedatHUzVKUPeXF64mkQ9xo1IqyJZmbzwYXYa1SYeu2yedCnqg>
    <xmx:wkOXaWpb--O9OLq9pxBBLLIfBF5wbPz05A2vUq9qi7Y8XPfxui8kGw>
    <xmx:wkOXaSLYrkfAYoZSX8BZDlNS1ArwAq-hrz4605TnW4Dn86TxS30EwQ>
    <xmx:wkOXaXSobWFyQUocoGiZS43sWVcaYmumN7UTf4ecGB-MqxW5miUMDQ>
    <xmx:wkOXaTLZaYJIpmB_uCilBOJ5Vl9lOAz4yz-srJ8Ganr9JDHK0woDUBhv>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Feb 2026 12:09:21 -0500 (EST)
Date: Thu, 19 Feb 2026 17:09:16 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZdCl8byz51Q1-v6@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B20A40005
X-Rspamd-Server: rspam02
X-Stat-Signature: e4ggdrk6ntp4hhenci9eiauczmk7wnpq
X-HE-Tag: 1771520966-398088
X-HE-Meta: U2FsdGVkX1+7Z6r08wMM3xyV0J3OdqdXxa0bcMPN6waLTJEL8s8LXYt81OZdoWmL3IJKx8OzEe42TpEmD5ZCw0tIkQgMWoqFtXJFVBd0NbYltx4mjBMwv25cJaldvJ54nJ4h+29klxK9bqvIFj9sInmoSzL+H4xt6bDaOKR16tq2jkX79lf8RLhTtNuO9vxLZ/bLYlaOm38RAkU0DwEulE+ppTh0M98r1hNzyns07WzPF3UEI3omdrMlPl38tKj0R2hOL07O1FS13OEqdpGUq/xMskKGdkMgsrCSjRC5KvaztCCtSnu5XoXkmV7H+1t0DmXlCOv3G9iyjdcW/m/twty63f+/d0EBMkCe0lQHxnO1JX7Zw9NaWnTkz6Aik8mZS/4EiY5FD5bCeLTobtbyGrueYMnX0UzrjHjCC9B+nGtcAoz2Znd6bXMOv9VDCKxYASoTnKqPxDtWeo5n90sy8QOhyhSD74qvPmgQtWAtSsiCvyMlIR6di/6KuH0n2FVje3Lz+1Z6jsVJQFYtgTfVhz0y+1f8VCMjLT7mNDl1rg4xR3e22cYlmVgDLf/AUr97ANHYNmT8Qald1KLS3/T8jPgzvPHgM3cKt97gHZHmdA3/r4akuf2ATOzmKtDTCZE5mMhoidNuvVkm+ZDQkTd8KACWX4T6Uc6RuJRpbHayyOTaaKDMlHPCwuIJJ1KL+qVsYSM3hi3NaMxqDPpqX5tf4Sn/USf+x36qaK1mO/0HUtgeEGFqK4FNte9Xv43KuJ12kW8do12m8VESfg3gkcJrIHmwJvcl2kgYEqxdiX98T5sInWN1oOhzitpNxrUC9gHkj5+hKS53xDegk+NzsiIcFE0hIl6kq3VsHxvMV9l5/fCOUxT16pMqOCP7i+vkgyieLWOnWuxmDKGubn6vPzlbqPXp+DwfMxctGr6XHUJlB94bidGIbTsKG1MxELqmikAh9rgRrZm/bQ7ue4nBylM
 NUblKfmY
 qbifcQNLzN/IYT6cvsLrnG34MId931h6UjApmN4uhwvWi/oGtrsDI8gzjF2nDXXTRx0ZUtGmNOMzc2AJ1RSFKM78kb+8q7FwBU7667MgrHG1FLzowSwoo5NhQSfNyqqG8f9V91xWsCxtCnYx7fK3URxXpVwHTr3f2g5dXv0adnjViY7eGa6BlsWgTvDDvPgk64exaeUT91/EXeMn/WsfV9+H+efr5n5iQYJLEqP0x+IQFtqkVVn6qjwQzcAe9cS1frMcss5KzsN3P0tbpyb+jM8VG6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 04:39:34PM +0100, David Hildenbrand (Arm) wrote:
> On 2/19/26 16:08, Kiryl Shutsemau wrote:
> > No, there's no new hardware (that I know of). I want to explore what page size
> > means.
> > 
> > The kernel uses the same value - PAGE_SIZE - for two things:
> > 
> >    - the order-0 buddy allocation size;
> > 
> >    - the granularity of virtual address space mapping;
> > 
> > I think we can benefit from separating these two meanings and allowing
> > order-0 allocations to be larger than the virtual address space covered by a
> > PTE entry.
> > 
> > The main motivation is scalability. Managing memory on multi-terabyte
> > machines in 4k is suboptimal, to say the least.
> > 
> > Potential benefits of the approach (assuming 64k pages):
> > 
> >    - The order-0 page size cuts struct page overhead by a factor of 16. From
> >      ~1.6% of RAM to ~0.1%;
> > 
> >    - TLB wins on machines with TLB coalescing as long as mapping is naturally
> >      aligned;
> > 
> >    - Order-5 allocation is 2M, resulting in less pressure on the zone lock;
> > 
> >    - 1G pages are within possibility for the buddy allocator - order-14
> >      allocation. It can open the road to 1G THPs.
> > 
> >    - As with THP, fewer pages - less pressure on the LRU lock;
> > 
> >    - ...
> > 
> > The trade-off is memory waste (similar to what we have on architectures with
> > native 64k pages today) and complexity, mostly in the core-MM code.
> > 
> > == Design considerations ==
> > 
> > I want to split PAGE_SIZE into two distinct values:
> > 
> >    - PTE_SIZE defines the virtual address space granularity;
> > 
> >    - PG_SIZE defines the size of the order-0 buddy allocation;
> > 
> > PAGE_SIZE is only defined if PTE_SIZE == PG_SIZE. It will flag which code
> > requires conversion, and keep existing code working while conversion is in
> > progress.
> > 
> > The same split happens for other page-related macros: mask, shift,
> > alignment helpers, etc.
> > 
> > PFNs are in PTE_SIZE units.
> > 
> > The buddy allocator and page cache (as well as all I/O) operate in PG_SIZE
> > units.
> > 
> > Userspace mappings are maintained with PTE_SIZE granularity. No ABI changes
> > for userspace. But we might want to communicate PG_SIZE to userspace to
> > get the optimal results for userspace that cares.
> > 
> > PTE_SIZE granularity requires a substantial rework of page fault and VMA
> > handling:
> > 
> >    - A struct page pointer and pgprot_t are not enough to create a PTE entry.
> >      We also need the offset within the page we are creating the PTE for.
> > 
> >    - Since the VMA start can be aligned arbitrarily with respect to the
> >      underlying page, vma->vm_pgoff has to be changed to vma->vm_pteoff,
> >      which is in PTE_SIZE units.
> > 
> >    - The page fault handler needs to handle PTE_SIZE < PG_SIZE, including
> >      misaligned cases;
> > 
> > Page faults into file mappings are relatively simple to handle as we
> > always have the page cache to refer to. So you can map only the part of the
> > page that fits in the page table, similarly to fault-around.
> > 
> > Anonymous and file-CoW faults should also be simple as long as the VMA is
> > aligned to PG_SIZE in both the virtual address space and with respect to
> > vm_pgoff. We might waste some memory on the ends of the VMA, but it is
> > tolerable.
> > 
> > Misaligned anonymous and file-CoW faults are a pain. Specifically, mapping
> > pages across a page table boundary. In the worst case, a page is mapped across
> > a PGD entry boundary and PTEs for the page have to be put in two separate
> > subtrees of page tables.
> > 
> > A naive implementation would map different pages on different sides of a
> > page table boundary and accept the waste of one page per page table crossing.
> > The hope is that misaligned mappings are rare, but this is suboptimal.
> > 
> > mremap(2) is the ultimate stress test for the design.
> > 
> > On x86, page tables are allocated from the buddy allocator and if PG_SIZE
> > is greater than 4 KB, we need a way to pack multiple page tables into a
> > single page. We could use the slab allocator for this, but it would
> > require relocating the page-table metadata out of struct page.
> 
> When discussing per-process page sizes with Ryan and Dev, I mentioned that
> having a larger emulated page size could be interesting for other
> architectures as well.
>
> That is, we would emulate a 64K page size on Intel for user space as well,
> but let the OS work with 4K pages.

Just to clarify, do you want it to be enforced on userspace ABI.
Like, all mappings are 64k aligned?

> We'd only allocate+map large folios into user space + pagecache, but still
> allow for page tables etc. to not waste memory.

Waste of memory for page table is solvable and pretty straight forward.
Most of such cases can be solve mechanically by switching to slab.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

