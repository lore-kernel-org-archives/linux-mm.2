Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A82DE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8127D6B0005; Thu, 19 Feb 2026 10:55:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FCFC6B0089; Thu, 19 Feb 2026 10:55:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716AE6B008A; Thu, 19 Feb 2026 10:55:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE3D6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:55:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA3B613B212
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:55:08 +0000 (UTC)
X-FDA: 84461655096.27.C77CC08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EE201140003
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:55:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X3IdJ8Cw;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771516507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38H8kn7YolEcj9OZqc599PMZp2e0srjODj/+Zxkz40A=;
	b=7PAKcm/Os79+TsrNVmRiaevCzFc/jmL5j/FWq7gRVEWtfnNtSK6bXbTWOgRC1zqBfxpYR3
	r7clDiH0qPSRh/gFoxAhHhvDN0LRPkWHetMKOHS9giDns/XtA+0Ij7wBVMQERicxHlZkUb
	QSkgMuCYkway4ZiSUWIm5dzG5IDZvnk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771516507; a=rsa-sha256;
	cv=none;
	b=dItfIEZ9IgHc5L0p1h9gYmnBdbqZlTTok+UmJb3ma5PskLTiSq0kKnOImr+OydXg2kjoIg
	WFgCGI+kr6aHw0pNcMXujaxG5IrhF/uBpNCOn7eXD1gbOdT3AFMZIh3mSgnr0sFeZ5P57s
	Xpz1qHswRnZ5zQBvRbhs+1SDsDnEhjk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X3IdJ8Cw;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14AA24444B;
	Thu, 19 Feb 2026 15:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741D0C4CEF7;
	Thu, 19 Feb 2026 15:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771516505;
	bh=ysZ1rB9WGPsuOPfKK6gFWncDtc3U3ibMHdLln5hfXoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X3IdJ8Cw66psR9s/NmRe1pMEAL1r09n4GarPOaSzxPbZfSMac6fP45TRPTUmzF6Uh
	 K/ZaiiodIZcBRag93ZmGJJPDJQQc1YJ/nFeYS9zdj338TlyHmxq6M5zb6Roc5s/5mZ
	 5seUqRBRa5AfxqgQvnryOyb2Nng52ydkukpMsGtvsRc9CRN9Zy6QvayPcDE2oDwOHJ
	 15dIC9+oISy/6NbVgnerkUHOJ2e7vlkenP4gXm5oMwuYxOX/K8MB8wt4Xo7XXzDmlL
	 9V2BbUYlEizOs1yENyEqHbn2tETKgykDYnwkowEOEdvqTeJOqT+lYALZw+LzQRcGDr
	 0lKSCi85HPAKg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7CECFF4006A;
	Thu, 19 Feb 2026 10:55:04 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 19 Feb 2026 10:55:04 -0500
X-ME-Sender: <xms:WDKXadOdQGa1ekSklkGIutqRhTlBBF1ytuIt10bTs27QOciWboj4sQ>
    <xme:WDKXaSRpzKxBGNi8Zvrzdb_fZvRHAs4zt755ZPKb5vQXTfd2VRWIul4avtXeLRJEs
    L_fzpzWFW0XMDJac_-y2MX7VZDPbspn_BvBj0Q-YLgc9ZNRL63mdQ>
X-ME-Received: <xmr:WDKXaa95gntqLloFRDyC3j3YB4i78RGzKUSwWy21-4d2dT9qlVMNLNVKdhieJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdehleegucetufdoteggodetrf
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
X-ME-Proxy: <xmx:WDKXaWofYjhDVHn9k-3j4JJGnKWY5cRw3oHSotbQcNNRAMcuk2Wo8g>
    <xmx:WDKXaTG5Sak19lHrT8EfEQ3JL-Y0k67BRs7lxnO0o90qwrAN59VsFw>
    <xmx:WDKXad2PwbcfdYJjW-wi-TEGhoy0L4_jCMurl1NTnTNZAC3mHXvEgQ>
    <xmx:WDKXaRPl23QcIv9kNuxVsphhB248fASxJ9nk1AqyDZW323G2Fb9hcw>
    <xmx:WDKXaeWCZJe49u9IUl46Zbu-5z5-ldqLizkzpHyMMjdeMXmnTU8oVw5G>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Feb 2026 10:55:01 -0500 (EST)
Date: Thu, 19 Feb 2026 15:54:56 +0000
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
Message-ID: <aZcxWsWO7AxQW6JC@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
X-Rspamd-Queue-Id: EE201140003
X-Stat-Signature: jzaumxa3nc7m1hei59wxs1cgpjq91667
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771516506-337374
X-HE-Meta: U2FsdGVkX18Z0tZlrlNJj6eftaCnsDB/+klDjWPd0rxsxofgrSXKQZkudWcsBR9g/aw34+Njuajgs1z9yyZbbhpSmP4NwJJENB+h3mGP31CDy2qtuN+rfwuusUewjBig2xLdeq9GL3bw/Fu5YdIDK3ehqQqjEOqNFVN7gAdalNCS32Qv18XswsSYMp2+eiU8hQva+wzRNghtGl53QvWRPjwwIZ+z+WQj+GCetZqJe3MAON+ZGHuUws5iOALe8yuDg9+yI08LKouYot/SgAkqzf+QXpnBXrnHgZdQN2BCd3nPQFRERInsDEIauXY71/wJmjpMkyD0+fcEYfYFC/HTNuKo8gXU3ozgqAn948Q2YiiYJwrQyqMGf+D07GBi6fNIbTGCJlsLLDTHMEq/HekEIHPqYaqHlHmLnVvVVYYba4B8wftIU50pFvwz0g2Ro6lVC+NfcmqDHq1uMLeWoODBfCVx7Tt0NVm1lj4v0YdiTHTn5UBKBXxZgB7s1dQ8n0isreyLsaN5XJLyOZ/kFD+AlX57iY2eZh/Q2uly9B1uGO2orRCWu0Y4O5hYlyN/hmjf5oH/danHcjg8jSFVGJyrmNkR1WxTW1HC9IIMRShVamHImGPTPUSgoTjn4XgJVUOuL3yuoHDXoQm59/RrESIjoDJSIm7ueOBpcm78HZQ7ZsEm8EqDzYUPBAD1RqW/TetnWhkPwoDgNneeWi+TCTP7NLaX3VtH+U2+myHGOKeGZBjxIiP1VcIEGhCUJrdDPhEI2VOIOfa5EOCBtTjHxI+az/3/WdkigwyyWaamRJSb8mpJuAPiA36LqYyZbfdbddziwMlreSjFkjTD8ZNTIQ4mpnIL9k0Y8YlyrC0p3BKIidgj6CV4jIJSEbYakonmJtyTHiazOMycs/Wdh8YGhKqrdSOsuaTDcaNtVBH/EcHSf6O9WoKS3UzBQA==
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
> 
> We'd only allocate+map large folios into user space + pagecache, but still
> allow for page tables etc. to not waste memory.
> 
> So "most" of your allocations in the system would actually be at least 64k,
> reducing zone lock contention etc.

I am not convinced emulation would help zone lock contention. I expect
contention to be higher if page allocator would see a mix of 4k and 64k
requests. It sounds like constant split/merge under the lock.

> It doesn't solve all the problems you wanted to tackle on your list (e.g.,
> "struct page" overhead, which will be sorted out by memdescs).

I don't think we can serve 1G pages out of buddy allocator with 4k
order-0. And without it, I don't see how to get to a viable 1G THPs.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

