Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BA0C55ABC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 12:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B456B0088; Fri, 20 Feb 2026 07:10:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1746B0089; Fri, 20 Feb 2026 07:10:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F5B6B008A; Fri, 20 Feb 2026 07:10:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26FD56B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 07:10:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF8A51A0148
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:10:54 +0000 (UTC)
X-FDA: 84464718828.20.560F82D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 220051C000D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:10:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NZrAb9YX;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771589452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=diBJa2PYeckVGNkOjpReeL/GMe1HxhkUGj4Qs3envAU=;
	b=gxpIesKTvi3fxJ65GHpp00TmeXolrSiQpf0Jw4g2jEs3E76wZjrkL0hFzYZWCeJB2WU7yd
	HC8+SiKCiN89bQLjcjF3OQ8PRJwUrzjiNHXif5T2+35UfMhs/IFB2cyb3VXjDsuMsEVDuK
	pjGWkuljrWeE1KBrLZt4Hh9a1/Tjfd0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NZrAb9YX;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771589452; a=rsa-sha256;
	cv=none;
	b=yjkibLx8FyzV6+i0O9XA0rZcO+5QfkbL5uox7gFC61cc/VC05ZEcpMZ7To6kIfblnukwLm
	KLtaEtCvW5ccUc7I8TYLfYoY9xJabfra3enu1DL4ditUcpGE9tt/bd72smVGSNP+ehS4/w
	kHUdL6v53e5jYHdQwQcI1NViXk08g8w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DBA5544547;
	Fri, 20 Feb 2026 12:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63E0C116C6;
	Fri, 20 Feb 2026 12:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771589450;
	bh=CkuMvJSvk6Bm3IKgxxcihreO2cDBuepEy+Dn/PXjewM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NZrAb9YXiTa5a3dkoDI2JcAKRafqDqYVTcfhKHK+9W2w9WUObL4bCtnNg5CZgupNm
	 2wZeg82UdHp5PeaUq94b1mvwNtF9OjJlIBvSgsPXmTxDyzF8WrdpTihmmTWbyK2pO4
	 DBv8TidrpW29F1ziJ4SMKiRWPls1UKbDeMVVLWRUP3YDAbzBHSP44Yurs+G7w/SKnn
	 5Af3LRaiHx6Fg+J9GW5C27HVMj/pNzkkPMA5gHh3LgsL8bc5a2f82I16zynaXkwe9t
	 wzPLqj7Wwg8yzRjUjr0remSGyM9AjoKPmW+mda0cRCGKXEt/dvAl0sAbwXGSdMPMBY
	 hmxsM+CDOuMJQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 92595F40068;
	Fri, 20 Feb 2026 07:10:48 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 20 Feb 2026 07:10:48 -0500
X-ME-Sender: <xms:SE-YaaKvwf9CGVCxtNhezSZfi82zEzRctZ674jfOQYmchilmaaZ5_g>
    <xme:SE-Yad2hnuMSu3ULWKqfb4sEO0XKxpyr8QodDTkg_QpWpB-WxDGoHANyEQi_K3pKo
    31GnJSO2w9KjEx9jUA5Z1EnQQU4VBuDZV0MAFhtJ9eOL8JJJSpoSQE>
X-ME-Received: <xmr:SE-YaeUW7wfcMXYqSadLUdMlMCVL1eQVXXBxDErxetyesxPI11IaUEw2P6eqmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdekgedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeutdelvddtvedthfefffejjedvieelleektdfgfeelveejfeehheeuffeuhedt
    veenucffohhmrghinheprghnughrohhiugdrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspe
    epkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthho
    peegvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepkhgrlhgvshhhshhinhhghh
    esghhoohhglhgvrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhsfhdqphgtsehlihhsthhsrdhlihhnuhigqdhfohhunhgurghtih
    honhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgt
    phhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvg
    hrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepthhglhigsehlihhnuh
    htrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:SE-YafpLfM1JFQNAbcmwZu8dg924zrFrVDabqqcjces-ajlMq7wVdg>
    <xmx:SE-YafY6zes04E4Xfuaj3ebU22pzBQ6Ig5WD_brCDJPIgUjuyiv52g>
    <xmx:SE-YaTDAUe1Lf4YHrI5VKomVYCT2S1kEutAZmCdX37ScoJZq9FXkzg>
    <xmx:SE-YaaGLSgZ0iYnX_u-AFGPfOTZNpRvZgIHoD9OPWAa_emLnfDA18Q>
    <xmx:SE-YafwneVGX1_o04DJnCBlRa0FPoTeTr6x1J8ktazYAexB0PTTjLLo2>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Feb 2026 07:10:46 -0500 (EST)
Date: Fri, 20 Feb 2026 12:10:41 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>, android-mm <android-mm@google.com>, 
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>, Mateusz =?utf-8?Q?Ma=C4=87kowski?= <mmac@google.com>, 
	Steven Moreland <smoreland@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZhOnSVao9yFJML7@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <CAC_TJvdUoBmZNj68Yghmwhr4W0930s+p7UkAtSj5x5XoGAHhwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC_TJvdUoBmZNj68Yghmwhr4W0930s+p7UkAtSj5x5XoGAHhwg@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 220051C000D
X-Stat-Signature: ntfjthrbxo4fjtg47tcmhoy9boc7jtfk
X-Rspam-User: 
X-HE-Tag: 1771589451-890285
X-HE-Meta: U2FsdGVkX18pcTnDqrYgIFUA1v6JvhL1So1czS/KLrlkLOcbswrygarckqrA0uQp9yAxG0LKjPF0EiSfRpQLK0/koct1RmEQvyyocl233vsgom6RMterOw4CwnCDlxCv3AX/bW0cUzYt576fAXaffpc3RGKg6ngSTRmqqUkwN2vXByuCVe07AOogrmsJ8V3gkPPR+CNIZicIG+mBddOVf2NfAgR6Vcz1GDtKQBzROgbvh7ZvgGyMCuJ7pytd1oOCYYxkdSLCgyvICn8VWFNapX0pOyLD9erg/hTh8U5H8BzuTDOOR2mLxpQSov8YNnOzsmOMcpDx7o921OVjhOVk0exvAf9pV7JJPvCqgM8KTauIaa0ffIuU9aPI8GoeWNvJwOmNrQV+Az1mWzleCZ7354w9h5zbwQkhHFnZH/6yNJ/8xILwkGS3HblvNUe5HbuMdMx6SdBRH2NEqvgz9PmXdeSOYzIQLoXihoYtavtw2CHVdCF4xVCTRjo7rRpHQjI+NYIGDY30Oof1LgbpqdOn9hE0UyJKcI1q0GCrfNh8ww8UO0AzN8OuoGNxbgVa3QRp1q+z246lXaFjEF6aLHC4AJvVN+NOEy6RBT3k8GCUDwd9eP6yznEZ6cw655fKrvnYHjEOesacV9cqhb95BiFcab+2VO2k35wsd/LGynKb8r4Nqjh0AvIWEXuB4kYapNKQ2NfDpvr32mXjv68x27r9wQOYDsVhFxmFAb86i+2/ODyQtNEqmJxmVtgbFQ+XL7uqkS8pOElsteqkw6XH2veOMQaCwqWiuznogCE9CznyjTWvkTVR/TDhdyNIr2Uv1NcbhvffWmrqBQD0HEMg6zNRj32Wu5l5s3myk/W0IPUcdEXiCKKqqUdRMv/P1dso6KdU4d2xKnR2jaEug9umqdYlNrdqJDVzN/1s/VNt+Dp9tmPv3v/Sw6qb+ZMe1GYRwZBIyPH0ki0EJYC1J/2Iy9p
 KFFc7Xtm
 0eNKfKq/Ov7eq2GHi1KND4PK+ajHxDuNP3COvULv6mm6R24qgAxPcsgO5WRscfoLlWvZjaKtG3tZGJkQRuGhiKw6kxSjyjM5BTInoAXnV9vXfKWwPkS6iJZR2ccKNpAJ9oR3Tot5B9HsXRJFs5cSuq7v6csUjUYc1KqCU4abQYMJoufsIsdVAAan8pcHt5kFwOBbfwXGfOpIGTCVQTVGxaVMn6ccwGwFcMZaKBMsNkx/b37ICsPTtVbtI5gU6EhfbkpT5pPG1X/VjnDswxJBj4/MxN8whPAebG2W2wo3YIYFdvf9nL+NP9V4wYEPQUdbi6JdUeivvhD76rP1/Vp1o5kk0tGebTl6qndkQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:24:37PM -0800, Kalesh Singh wrote:
> On Thu, Feb 19, 2026 at 7:39 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 2/19/26 16:08, Kiryl Shutsemau wrote:
> > > No, there's no new hardware (that I know of). I want to explore what page size
> > > means.
> > >
> > > The kernel uses the same value - PAGE_SIZE - for two things:
> > >
> > >    - the order-0 buddy allocation size;
> > >
> > >    - the granularity of virtual address space mapping;
> > >
> > > I think we can benefit from separating these two meanings and allowing
> > > order-0 allocations to be larger than the virtual address space covered by a
> > > PTE entry.
> > >
> > > The main motivation is scalability. Managing memory on multi-terabyte
> > > machines in 4k is suboptimal, to say the least.
> > >
> > > Potential benefits of the approach (assuming 64k pages):
> > >
> > >    - The order-0 page size cuts struct page overhead by a factor of 16. From
> > >      ~1.6% of RAM to ~0.1%;
> > >
> > >    - TLB wins on machines with TLB coalescing as long as mapping is naturally
> > >      aligned;
> > >
> > >    - Order-5 allocation is 2M, resulting in less pressure on the zone lock;
> > >
> > >    - 1G pages are within possibility for the buddy allocator - order-14
> > >      allocation. It can open the road to 1G THPs.
> > >
> > >    - As with THP, fewer pages - less pressure on the LRU lock;
> > >
> > >    - ...
> > >
> > > The trade-off is memory waste (similar to what we have on architectures with
> > > native 64k pages today) and complexity, mostly in the core-MM code.
> > >
> > > == Design considerations ==
> > >
> > > I want to split PAGE_SIZE into two distinct values:
> > >
> > >    - PTE_SIZE defines the virtual address space granularity;
> > >
> > >    - PG_SIZE defines the size of the order-0 buddy allocation;
> > >
> > > PAGE_SIZE is only defined if PTE_SIZE == PG_SIZE. It will flag which code
> > > requires conversion, and keep existing code working while conversion is in
> > > progress.
> > >
> > > The same split happens for other page-related macros: mask, shift,
> > > alignment helpers, etc.
> > >
> > > PFNs are in PTE_SIZE units.
> > >
> > > The buddy allocator and page cache (as well as all I/O) operate in PG_SIZE
> > > units.
> > >
> > > Userspace mappings are maintained with PTE_SIZE granularity. No ABI changes
> > > for userspace. But we might want to communicate PG_SIZE to userspace to
> > > get the optimal results for userspace that cares.
> > >
> > > PTE_SIZE granularity requires a substantial rework of page fault and VMA
> > > handling:
> > >
> > >    - A struct page pointer and pgprot_t are not enough to create a PTE entry.
> > >      We also need the offset within the page we are creating the PTE for.
> > >
> > >    - Since the VMA start can be aligned arbitrarily with respect to the
> > >      underlying page, vma->vm_pgoff has to be changed to vma->vm_pteoff,
> > >      which is in PTE_SIZE units.
> > >
> > >    - The page fault handler needs to handle PTE_SIZE < PG_SIZE, including
> > >      misaligned cases;
> > >
> > > Page faults into file mappings are relatively simple to handle as we
> > > always have the page cache to refer to. So you can map only the part of the
> > > page that fits in the page table, similarly to fault-around.
> > >
> > > Anonymous and file-CoW faults should also be simple as long as the VMA is
> > > aligned to PG_SIZE in both the virtual address space and with respect to
> > > vm_pgoff. We might waste some memory on the ends of the VMA, but it is
> > > tolerable.
> > >
> > > Misaligned anonymous and file-CoW faults are a pain. Specifically, mapping
> > > pages across a page table boundary. In the worst case, a page is mapped across
> > > a PGD entry boundary and PTEs for the page have to be put in two separate
> > > subtrees of page tables.
> > >
> > > A naive implementation would map different pages on different sides of a
> > > page table boundary and accept the waste of one page per page table crossing.
> > > The hope is that misaligned mappings are rare, but this is suboptimal.
> > >
> > > mremap(2) is the ultimate stress test for the design.
> > >
> > > On x86, page tables are allocated from the buddy allocator and if PG_SIZE
> > > is greater than 4 KB, we need a way to pack multiple page tables into a
> > > single page. We could use the slab allocator for this, but it would
> > > require relocating the page-table metadata out of struct page.
> >
> > When discussing per-process page sizes with Ryan and Dev, I mentioned
> > that having a larger emulated page size could be interesting for other
> > architectures as well.
> >
> > That is, we would emulate a 64K page size on Intel for user space as
> > well, but let the OS work with 4K pages.
> >
> > We'd only allocate+map large folios into user space + pagecache, but
> > still allow for page tables etc. to not waste memory.
> >
> > So "most" of your allocations in the system would actually be at least
> > 64k, reducing zone lock contention etc.
> >
> >
> > It doesn't solve all the problems you wanted to tackle on your list
> > (e.g., "struct page" overhead, which will be sorted out by memdescs).
> 
> Hi Kiryl,
> 
> I'd be interested to discuss this at LSFMM.
> 
> On Android, we have a separate but related use case: we emulate the
> userspace page size on x86, primarily to enable app developers to
> conduct compatibility testing of their apps for 16KB Android devices.
> [1]
> 
> It mainly works by enforcing a larger granularity on the VMAs to
> emulate a userspace page size, somewhat similar to what David
> mentioned, while the underlying kernel still operates on a 4KB
> granularity. [2]
> 
> IIUC the current design would not enfore the larger granularity /
> alignment for VMAs to avoid breaking ABI. However, I'd be interest to
> discuss whether it can be extended to cover this usecase as well.

I don't want to break ABI, but might add a knob (maybe personality(2) ?)
for enforcement to see what breaks.

In general, I would prefer to advertise a new value to userspace that
would mean preferred virtual address space granularity.

> 
> [1]  https://developer.android.com/guide/practices/page-sizes#16kb-emulator
> [2] https://source.android.com/docs/core/architecture/16kb-page-size/getting-started-cf-x86-64-pgagnostic
> 
> Thanks,
> Kalesh
> 
> 
> 
> 
> >
> > --
> > Cheers,
> >
> > David
> >

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

