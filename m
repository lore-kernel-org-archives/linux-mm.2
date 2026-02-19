Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C17DE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B3E6B0005; Thu, 19 Feb 2026 10:50:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09216B0089; Thu, 19 Feb 2026 10:50:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0D26B008A; Thu, 19 Feb 2026 10:50:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AADBE6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:50:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6787F8BFC7
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:50:32 +0000 (UTC)
X-FDA: 84461643504.25.EE2184C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3809620007
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:50:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jj3lq44w;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771516230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlHmU4B2vcp75jRwCE7sI7663fpm3He4LXtd1saJ08U=;
	b=bW3VjDnnRwG7VRJpf2fjVXO9magZUNGrri2vYpabx+4QAXOm9megCNColKnOcvsgMOIT+l
	ooHQRoc5qj14aPcJfWpqgIKB9zGU3SNsp2SxPpzdwDhjSsfT0EUw76J0bzk1cQ+v/U17S/
	Ow43Tzkw27fPRtp5dj73wLLDnF/I7W4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jj3lq44w;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771516230; a=rsa-sha256;
	cv=none;
	b=8ltQV+Bc/1SIJ+JKxryxT+xFZmmzLHWOv8xvnCl429oPu2GZPE1W+jOvOjoG6+KuvjC/46
	dA281AuQEmZw2aSIiG00cm5AJOh8wr4YLx5aTRKG9anfbaFKja0j1FbflXNDE4c5Q1gHKd
	kQ5grhc7LawrR+o67U50EzZtFTGEYvg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4228A443F7;
	Thu, 19 Feb 2026 15:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696B4C116D0;
	Thu, 19 Feb 2026 15:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771516229;
	bh=QRaXAPNVSdqHh1S3a+TpsEg/J3A6konYPEMlsHm79V4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jj3lq44w77ij0vQOGgZsk2x0dwmZe8FvOowQalSx383dfUq1MssLmoThYH+HMS3JM
	 3/9pPoiRD9VNP63KlWNK6MixaiMPZz0+j1+jVglhbLPbj3ZWdpU6dmzjUbPZgkBZp0
	 ZPwRY6iwdG16THTJKl7RVUl2Va7QwcM5B+GmIgMGlonMsDmNVnGAgD7J+IndqCElpY
	 weuOA64smPdIfWNAiyIzSy6gTgUfco9LImsR0jicW0oFkcll9B3VOP2S9FIH7bhefj
	 /sKtX/w1bGHlUe8kJ9D6l1Qku1pxFP9O4MpvjoDKXX/KraUTou83YOSUXvQ8H4x3/r
	 eRXzrbm5DOj3A==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5CA2BF4006A;
	Thu, 19 Feb 2026 10:50:27 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 19 Feb 2026 10:50:27 -0500
X-ME-Sender: <xms:QzGXaWoNFkE21mGHY3SFfISij9fjxnEw4I3MAsdt8qC2lDfnc7qz_Q>
    <xme:QzGXaRFzuLPte-FxmtWl2wNmS1AkZMPMp_it-JZbkPSAZ3rOhV02DySSPohHaJhDf
    Pz-iUZRPfX_xDe4ECdN2CBoDf23KaA8gGjfd2jnMKjib5X0JrQc-qE>
X-ME-Received: <xmr:QzGXaSePdBnCHzpDZ2LIgNV10psgTbWp6PyLAjjP4OMNj3xMZNgEQFDfDI8GcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdehleefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehpfhgrlhgtrghtohesshhushgvrdguvgdprhgtphhtthhopehlshhfqdhptgeslh
    hishhtshdrlhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhi
    nhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeht
    ghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthhopehmihhnghhosehrvgguhh
    grthdrtghomh
X-ME-Proxy: <xmx:QzGXacYZhxZNTustyBh9epcor6qaoDwcbZFXmPzfr0dZGzSoSRuu9A>
    <xmx:QzGXaWJCGcPKKDEH4taA0cP2h8pI6AU6riic0EygcsrYmCiyX2JR_Q>
    <xmx:QzGXabhGPUiPVawOVO_Fd3K5B_NuFaihr09iZkGMPSyAphnEpMQTkg>
    <xmx:QzGXaSthImY_qZn8AAT1MYPuOqFynVobaQlKNa1-NGjR8lQes0uttQ>
    <xmx:QzGXafGDXt90Ifq8UbF4BW3mLhVKZZ2p6EMM6GXIG3hJZAG1ZdolxVeR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Feb 2026 10:50:25 -0500 (EST)
Date: Thu, 19 Feb 2026 15:50:19 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZcuvbTTXn1MD5KK@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <l5lnb7fvqk2fndlvejibcrxru7i5xwdchl2hcnlk6dzttdfkyc@vtuqkied3mtt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <l5lnb7fvqk2fndlvejibcrxru7i5xwdchl2hcnlk6dzttdfkyc@vtuqkied3mtt>
X-Stat-Signature: rbpkkoj5a1yub3yktdm6edrexm4ejcba
X-Rspam-User: 
X-Rspamd-Queue-Id: 3809620007
X-Rspamd-Server: rspam01
X-HE-Tag: 1771516230-583748
X-HE-Meta: U2FsdGVkX1+nc0dNQLrkAc58i+jitrt9SaOe5EHAVxSAsRanM+3JRSbIFQPT9o2BP31XBrOTKBoGAWpWuZ407jfW80ir0IzHFBqDOKRJpL5uNqMqzmkbpJSSpcl6swET3QBrzKj1iIdRKmmfGGYvr5WTShDdLmvDxHy1dOuTWt8xofpUiew/mbLnJVmCZ+uOQNnT9MhGRdy5EJcwNrcQKl/ngS9pZItbUZ+BMohk8i6w6BiE8M1af4NbOf6yM4HO8QOQFDRzG+bbAqtQPPBkiTNLjUim0Tzm4xnOVz28UYXz1P1E2wd5U6gwHRsOGQoyeDLun6OlEK1gCujPLaNLNMiQ9D/fqoYdMTYCnjbCt07OlD/U7d4wnGz1QGq8OLa6V8LTrEacFVQzb159oyMr5yvpa2IcRSkr82VIqCOGdljcXsxDu4jIZuvptTge7T2tpURFmoHPpM3zmllxyrycqHukqJPOxt0zeFUM6TkZVE+TwxtrVLRu2EhHCx5aUlSPXg/e3hwS+W4BgvGjf8VWfcvDp6Vm0sAPYWHvjSH64XiEsMTk9SQRCA9n6gCY++1HTd1AJOcLovayLbxz19+fRX/+hM8hfbbxF8ze4LczOY06+mR9DCpGZ2LPZwLYylUQFNTzPUcW8rCa/dA0eu2lRyrsMy0+L7rXh2EhYsOT01BfaUjEpw0ua7MWLw6a7BoPCLejwEUshEfoB8i716ptswn/09/LYrA7ROau4sBfMSadPxyTVI3zg+wqSKag2WxhmxfBmrdKGl9vsLGOQZklXwBqjzYqPnkP0aL2fYO5MFwOAJeGC1XSIs8xXZghmlh2G3HUjFy/Ydv7hTdakwtUNs12ELxceg61Z3F0epdqwyMfC6WPls9WsSqfId8BbFTW7O1bTTq7xjTMI8yZh+QhPgAQmjwhuOp8N2Vm3WennZCQC7ViAYv7q3iLUl5ZhiBrbkxBviLP0UNcbfWZbGE
 ktqOsSxT
 7K2MHCgnIDU5O75WzhlImHUWoW1a5p9sXMV2GNKPFwQnbY0FGt88FIy+KKSlsZdSX8S6pBIcjJicoL1fnjEYuDD39gyvRv92EcR26LAlQTge5mEB5x+V5EqnZ+5bX38ErzYXL/ljYIszGmYmFXq1yh5fU6ZoFLEC2FWPFy10cSJiSXuoAVdcADaLcCvkm6nPEmb5FscUF6Vsk6g3brnTXvLJimlx8ONJ1kHB/J9+rIBM5D4cP4BJ5GRR+982VG05SAMyAeExMdr7gM+ovFKw4BX67nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:33:47PM +0000, Pedro Falcato wrote:
> On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
> > No, there's no new hardware (that I know of). I want to explore what page size
> > means.
> > 
> > The kernel uses the same value - PAGE_SIZE - for two things:
> > 
> >   - the order-0 buddy allocation size;
> > 
> >   - the granularity of virtual address space mapping;
> > 
> > I think we can benefit from separating these two meanings and allowing
> > order-0 allocations to be larger than the virtual address space covered by a
> > PTE entry.
> >
> 
> Doesn't this idea make less sense these days, with mTHP? Simply by toggling one
> of the entries in /sys/kernel/mm/transparent_hugepage.

mTHP is still best effort. This is way you don't need to care about
fragmentation, you will get your 64k page as long as you have free
memory.

> > The main motivation is scalability. Managing memory on multi-terabyte
> > machines in 4k is suboptimal, to say the least.
> > 
> > Potential benefits of the approach (assuming 64k pages):
> > 
> >   - The order-0 page size cuts struct page overhead by a factor of 16. From
> >     ~1.6% of RAM to ~0.1%;
> > 
> >   - TLB wins on machines with TLB coalescing as long as mapping is naturally
> >     aligned;
> > 
> >   - Order-5 allocation is 2M, resulting in less pressure on the zone lock;
> > 
> >   - 1G pages are within possibility for the buddy allocator - order-14
> >     allocation. It can open the road to 1G THPs.
> > 
> >   - As with THP, fewer pages - less pressure on the LRU lock;
> 
> We could perhaps add a way to enforce a min_order globally on the page cache,
> as a way to address it.

Raising min_order is not free. I puts more pressure on page allocator.

> There are some points there which aren't addressed by mTHP work in any way
> (1G THPs for one), others which are being addressed separately (memdesc work
> trying to cut down on struct page overhead).
> 
> (I also don't understand your point about order-5 allocation, AFAIK pcp will
> cache up to COSTLY_ORDER (3) and PMD order, but I'm probably not seeing the
> full picture)

With higher base page size, page allocator doesn't need to do as much
work to merge/split buddy pages. So serving the same 2M as order-5 is
cheaper than order-9.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

