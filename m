Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EE78E9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0D56B0005; Thu, 19 Feb 2026 10:09:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B885D6B0089; Thu, 19 Feb 2026 10:09:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87C06B008A; Thu, 19 Feb 2026 10:09:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 956556B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:09:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BEC11A05FF
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:09:02 +0000 (UTC)
X-FDA: 84461538924.28.A85EC36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4ED5D40014
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:09:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UZToT2dX;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771513740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JMjO3w7+ohaw3vlLPZ9S+JDhlCKjjWZOolt7zytTf8A=;
	b=cB2fy+EOuoX2uSpXLUBrkijyKp5v3x48dd4o3uX7ty0vkOgvDUnwxk0f8iizfi4b9Pdy1r
	w1XVqBdl3tKLBdevtY463W7UQEWoVDXhjP7ikr3Kap22ToWIjqhmLSLr8nDQpPYefDKtPw
	9L65ZnkSW12br60M+woz9YJOuxQBJoU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UZToT2dX;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771513740; a=rsa-sha256;
	cv=none;
	b=79ULl3SZ7XHPaTCclkqdLal4j2O7ZUJ073KwOoc4sBz4bc2Xpv6H8qSQDyZ5MWA7obvZNv
	uTL8c9uTTjY+bgZFuv5fvmdmXXvInt2eJyzL8bdp8ZrsV81Bv6yjPSAJz7AUdCM8fsLJbC
	t3MrXlcUHR+ji0IBq9i0aRCqZjL62qo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B20D61863;
	Thu, 19 Feb 2026 15:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84312C4AF0B;
	Thu, 19 Feb 2026 15:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771513739;
	bh=jEKB04A36ncPZtI2zVMpyvfVas5qp3cQm0Pp88Nil9E=;
	h=Date:From:To:Cc:Subject:From;
	b=UZToT2dX9+TwWLEuBj8vJEOt1P+Cdfd9sjLqmwnGIXRjc8MDUjASnlvXqh4CncZes
	 MpvJvUfG7p4Zh4pLDiLEll18CsOjhPqBJQhpzwOw/z87wiynbKNILLlgwV3ODK1xZa
	 DQDbLdQN7+XdLHXPhOZr+wr9NuH2IB8AvshlnLrf6eHsz2hRAs+5RDnorASgYGuThx
	 gStq+oDDaMRfDHJmCOz6ose4USBTm0Zn7Z+5lak+w8KujnetCPTEQq5n6sBoRjMWa/
	 WlhidobtTUT4R3Lnt2BOaad4M17lDbmhrF0DNs2fbO+HbAhjKHsMryrmfS3M3hz+/7
	 03XCRDWkFV3+w==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8646EF40069;
	Thu, 19 Feb 2026 10:08:57 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 19 Feb 2026 10:08:57 -0500
X-ME-Sender: <xms:iSeXaevbY6AeN_va-QfGk2ZHx20NPo4zySs8wW0Fa0YmLSN7XY9Azw>
    <xme:iSeXaVxptyU152yJ7VUDUclQOpUkwmCov7TGNbCPSA94_oon7FxClmOaSqHn7XstW
    0uEJPdOA0IAnRmw4D3VpAa7LwVC8x42kqWVoHOyyCcsqmwRcQGgUw>
X-ME-Received: <xmr:iSeXaYfhY92KWI5UBzjhfooO35HJyK4A4aoRj4JwohPHcxxzFmQ0wdfPFOnafQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdehkeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkgggtugesthdtredttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epgeeutdevveehveefjedtieeiudfhvdeitedugeeihfejvddvgeeukeevteehfefhnecu
    ffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhs
    ohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrh
    hnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeefvddp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhsfhdqphgtsehlihhsthhsrdhlih
    hnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmhes
    khhvrggtkhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpth
    htohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigsehlihhn
    uhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhmpd
    hrtghpthhtohepsghpsegrlhhivghnkedruggv
X-ME-Proxy: <xmx:iSeXaWJmx3N6q1TBE58h6nsyis4eF_GIUAUPvpQKGkxzZ3u8UVogZg>
    <xmx:iSeXacnAy2360qSBQI3s6Tw3p4yUo9sIM1aWpOKuSQif-HKlYZJw9g>
    <xmx:iSeXaZVbEQaDCiH5vDqjDmJjVp8v2qWwNzxCDk-_wEGTQBKAIzRqCw>
    <xmx:iSeXaWvyfNvc49IbB51wUVQazsYOz0N8YRkIgdtyCb0jqIysXtoznQ>
    <xmx:iSeXaV1BFJkDstaFEgJoPPx6RTmCrA-F8aO-qWDj8r8zIwD-FpKVYC4d>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Feb 2026 10:08:55 -0500 (EST)
Date: Thu, 19 Feb 2026 15:08:51 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZcmlIF4bmG0twkp@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4ED5D40014
X-Stat-Signature: 1bzo9hm9999xyf3g9adzrix899brk99a
X-HE-Tag: 1771513740-992946
X-HE-Meta: U2FsdGVkX19jecHepk/NM/ROZeVPkeC/FF+r4GO0fsWHejmp+xoDLrG8LYD1SA/A1j4mtRNMocLWFKDe1OElZ0til3iXUqCsUUSZvgco+nmMc3uY6FN9nZpoVIA/WaBKrheE8hPSPjtWSU9sVBVPX+mOoTqx/fnjz9EZd1zB3mfjwEaGN/VR4MYCmR5eR//9Kuy2W5Z5UHbM1koYqeT6jPagffx4YZ2KJHZRoi+Bs8VuGsT3EqaRF/iZsq+BSPP4WdDCNHOwpqveL4LS7eMIcKPr6BoDZ9iA5S8dnIvhNAIF2TFWf1i0Vt9Onex0cUdUknqxV/kVvWasJ3unEsK7IFfrGIHbqC3ikyfaryN1zKdZTeesoQXWS/0xiPuMBrmF2AynUuMFd4CRm1r2nS2iT5w0C0g//lMmKJtpVye8AspRudDMPzj5kx9kG9sG2HgHfjfiizwRTfppHJR0j+UkeZfnCmknDXhxeYB7rjr1sYp/iIPo8UgAVuJTfAtoafPmWW2bLBtEzp1PVA6ALVn4/YtVZak/mXZweqnEgke/D3lkjQC+wFeEt2sMArs6ZgvMdaPo4k2bPbWa9ISlXlY0CPMB85tXZE3Y/17mWWWPSJ35rgyBJcX7Tpfaq6nlNkjpj6SflBx0ix7iLdbS0Z/n+xrq4lkaGjxVfOPAHmNL2J2dj8w2sXUGuLM6fIvvZA5FL4Ps5B2llNV4E/9XeBbZNfduvqnXFbtakGGbmn0eYcbW1Lpq1t4ulELGJp5Wgyrac+cVE473yhdjJZPHFmXGIwzBU9+/c7PNK2/5Bd8zA1AS0inT0pnk5GTn+B050AjbNjEUeCjbTD+C7mpLCukrHIB4ZJgKIjDhDhl4i8B2oFcp4NOV8Sxns57z0JQorlEwqrXzRC3m2GXGaYzPnBUxMqj05jyX6d5coxMKqYEvGYcr71GAanvK45EobzrAreDvbfWtXC0cQ6aVhA/MSv4
 tQkPwR8f
 Xoiada9JZm2rxoQ+MTbCntyli/JyEp/gL2i3glk4Zt0f1g/BHGtxgMKVePLDKVXx/Ax8fQFSCDrBKEblgv95Kp9ComDhyGxfrg2fP03Sky5q4AmsCtmrBtQfDNvCAO1oMGE2bvt88nlQorY12WA8A4e2OhB8nawNPAJFwXjz7c0I8TH6xQBdZRwPSFTIKknxvxRhr64vU/Ns42OE5TVZge9lTJdseHYQg94o6dVtOHWO2h3SZ6Hz4RqG1tr2W252rTdX4+RE38n5IbNuiNWF+vPG6x+u1Y4uwf1ol7EkHvYuR3cQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No, there's no new hardware (that I know of). I want to explore what page size
means.

The kernel uses the same value - PAGE_SIZE - for two things:

  - the order-0 buddy allocation size;

  - the granularity of virtual address space mapping;

I think we can benefit from separating these two meanings and allowing
order-0 allocations to be larger than the virtual address space covered by a
PTE entry.

The main motivation is scalability. Managing memory on multi-terabyte
machines in 4k is suboptimal, to say the least.

Potential benefits of the approach (assuming 64k pages):

  - The order-0 page size cuts struct page overhead by a factor of 16. From
    ~1.6% of RAM to ~0.1%;

  - TLB wins on machines with TLB coalescing as long as mapping is naturally
    aligned;

  - Order-5 allocation is 2M, resulting in less pressure on the zone lock;

  - 1G pages are within possibility for the buddy allocator - order-14
    allocation. It can open the road to 1G THPs.

  - As with THP, fewer pages - less pressure on the LRU lock;

  - ...

The trade-off is memory waste (similar to what we have on architectures with
native 64k pages today) and complexity, mostly in the core-MM code.

== Design considerations ==

I want to split PAGE_SIZE into two distinct values:

  - PTE_SIZE defines the virtual address space granularity;

  - PG_SIZE defines the size of the order-0 buddy allocation;

PAGE_SIZE is only defined if PTE_SIZE == PG_SIZE. It will flag which code
requires conversion, and keep existing code working while conversion is in
progress.

The same split happens for other page-related macros: mask, shift,
alignment helpers, etc.

PFNs are in PTE_SIZE units.

The buddy allocator and page cache (as well as all I/O) operate in PG_SIZE
units.

Userspace mappings are maintained with PTE_SIZE granularity. No ABI changes
for userspace. But we might want to communicate PG_SIZE to userspace to
get the optimal results for userspace that cares.

PTE_SIZE granularity requires a substantial rework of page fault and VMA
handling:

  - A struct page pointer and pgprot_t are not enough to create a PTE entry.
    We also need the offset within the page we are creating the PTE for.

  - Since the VMA start can be aligned arbitrarily with respect to the
    underlying page, vma->vm_pgoff has to be changed to vma->vm_pteoff,
    which is in PTE_SIZE units.

  - The page fault handler needs to handle PTE_SIZE < PG_SIZE, including
    misaligned cases;

Page faults into file mappings are relatively simple to handle as we
always have the page cache to refer to. So you can map only the part of the
page that fits in the page table, similarly to fault-around.

Anonymous and file-CoW faults should also be simple as long as the VMA is
aligned to PG_SIZE in both the virtual address space and with respect to
vm_pgoff. We might waste some memory on the ends of the VMA, but it is
tolerable.

Misaligned anonymous and file-CoW faults are a pain. Specifically, mapping
pages across a page table boundary. In the worst case, a page is mapped across
a PGD entry boundary and PTEs for the page have to be put in two separate
subtrees of page tables.

A naive implementation would map different pages on different sides of a
page table boundary and accept the waste of one page per page table crossing.
The hope is that misaligned mappings are rare, but this is suboptimal.

mremap(2) is the ultimate stress test for the design.

On x86, page tables are allocated from the buddy allocator and if PG_SIZE
is greater than 4 KB, we need a way to pack multiple page tables into a
single page. We could use the slab allocator for this, but it would
require relocating the page-table metadata out of struct page.

Things I have not thought much about yet:

  - Accounting for wasted memory;

  - rmap;

  - mapcount;

  - A lot of arch-specific code;

  - <insert my blind spot here>;

== Status ==

I have a POC implementation on top of v6.17:

git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git pte_size

It is WIP and full of hacks I am trying to make sense of now.

It compiles with my minimalistic kernel config and can boot to a shell with
both 16k and 64k base page sizes. The shell doesn't crash immediately, but
sometimes I wonder why :P

The patchset is large:

 378 files changed, 3348 insertions(+), 3102 deletions(-)

and it is far from being complete.

== Goals ==

I want to get feedback for the overall design and possible ways to
upstream.

My plan is to submit an RFC-quality patchset before the summit.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

