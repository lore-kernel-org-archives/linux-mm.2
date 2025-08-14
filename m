Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2366CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F44900154; Thu, 14 Aug 2025 08:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F768900023; Thu, 14 Aug 2025 08:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D97900154; Thu, 14 Aug 2025 08:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F67D900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:35:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25AA5117C2E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:35:15 +0000 (UTC)
X-FDA: 83775308190.28.E9EB83C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 50B3340019
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:35:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N2g2BIJ8;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755174913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B3LuiEZXTU5HOjRdk69N6t/53G6b/PJMIeTc2G5XpW8=;
	b=5PqIgofXYeuJL6q+JaqJmDAim1amWzW6XuIHnOnmZXQcxjl56l51Or/h4XVUSbwxQvnJPT
	Ue41yM0DflUX/kG/a4TJ8Llw7yAMz+g9xsQjAMQAzkm10p6YvHV31KHf+EtzKbrtaGXsz6
	3Ab8EE42o42y8IUNnK9WSYcODkg3opA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N2g2BIJ8;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755174913; a=rsa-sha256;
	cv=none;
	b=a7/WyiBXlMKxUnyeSn6Mxu85UzTK1jNVxE4vlnsFSwIatGsM0KS2n/njy2uoNECPmGeaA9
	Jt2oaFM9JywO2wdIP+yMtHhy6SSy+UBUHqBsGWBIEb+MEulG+tRRU4fRchLO2FMe0UhquU
	/fNf01WKz0IPbMNKbOgo+5uMezh1Arg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2039F40C46;
	Thu, 14 Aug 2025 12:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3623FC4CEED;
	Thu, 14 Aug 2025 12:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755174912;
	bh=5hXrpmcmtYiZJx4oU8qkI207P6Gx3hYundw5EKylrIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N2g2BIJ8YPB3KdUqlIQ+3sf88XYTAU5YzXsxCIMkq+b9inEW2vgp9A4ivccGvjwfF
	 AV/wNRHN7Rl4BZfB83b4YqKem1VH+FiuolX5SiQ0hmKku6kJ9fzYlnSHRYR/hZfo4A
	 t7RgKyvSz54/20bp9OQxBJ3FdHTZ28zI3/O5nihwLrWH4XxMFsh7ImLJrid7kdNvXc
	 dxHzSoTZ0eAkBFydpLdrAEROqaFVHC+xn4DDTCz/hN4fLyFBvzVlWYglA0CvtcModo
	 8sk1zeTQvWBfTVENe6sc6PZjsbCDpigaPftEIsijKrs4a0DqSYC9HgT0MWUqY4ie5R
	 dAHYa4zIponFg==
Date: Thu, 14 Aug 2025 15:35:06 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v1 08/16] kmsan: convert kmsan_handle_dma to use physical
 addresses
Message-ID: <20250814123506.GD310013@unreal>
References: <cover.1754292567.git.leon@kernel.org>
 <5b40377b621e49ff4107fa10646c828ccc94e53e.1754292567.git.leon@kernel.org>
 <20250807122115.GH184255@nvidia.com>
 <20250813150718.GB310013@unreal>
 <20250814121316.GC699432@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814121316.GC699432@nvidia.com>
X-Rspamd-Queue-Id: 50B3340019
X-Rspam-User: 
X-Stat-Signature: eax374x1bgdgiufd6oea65zthg48x6bm
X-Rspamd-Server: rspam09
X-HE-Tag: 1755174913-429506
X-HE-Meta: U2FsdGVkX198/Y4N/S8iMkb0Qp9q8cfzTfJjhzlt5l2mUIzips1+W4QsxEwO0xD2b3Dh/0qbrod8CSbzDD1GSFXj6xsluY7Rn8uimuqYNLoQoJgoMm+LsNG7uj2kX2HSOM+pt3WfkLbutQylN3ZZbIbsWQW9MHEMc8zxrZX6KcuQ1+QiVPrVQpbl7BVCSZvH7UakOGBUV1mTlWKHQgpwU+RbMQlMl5yzGu1iMf/HSw9BIMoZFg0Of90JyMMocvI2paEzewrlhz4EyifzncyXFDSPoxsH30Ypx2ylE1O2JF6H5PB7M+82G1m/PzrBhM3y+izWdH67G8d8QDUWMakMhv0uQK3qB/758tltnZhn6pzRBayuBN86RkXvU2r9qfLfV/6t+W0vNQMhayCuRo6X3xBNUBbMO0E2O6PIcpHtwWjDMDK0MbsInFLkQbfN5G4sWl9HltZ8K44sGel9NPQT6yOQ4GpDtPe9dKawVxPSfsVo9J73iSeVkNXSagm2eSmOCZSQ+5Ok9QaVfUvKpyHinYdFsA3J6SMFbA9xsFP7CZ/96LmdF4cTxnIIZxe/DHONXtGd5jCEgajlUHF9pOiUXg5vNYipWJHZQZvBI+FZQpCzF1vXIOAA/kMGX+NNJ5IiRgytwl48EFDTYJZFWYkM3P5cbe21ATOT3LGnqf++qsWX5aYISr07L8idxmip+4JSgzNYDqPFhCujm3/QvqJodmcMVOJ+Lehhd1xKPDIMbxniRtDav406nPBMWf7OIAFsgm+HMd+2HhlvFGNcSnfrz4izcuQSh7h5mBjSEo2krrGxMclX3q9Y6qcfZAlUvLudKKcoexHbF0210MhpF08Bs6MvHiH+LIRcK05CI6uvqmoJnJUCwEFfticXux9U3B82pK3rIzgWtaj2U6n9onZK1xi3DQpqXL4bgNUkRxiHFwxbcwM7u/8KmcBQDsVV88mhkTs8dZAHyGXuqfAjpG5
 8HDLWnUU
 6pBDF71W4tgaW3ovFmqdc9ih8KXtQHtwx1fUyLWOrasdJy7KlORojPaonsQZbu5U+bT+A4yoaqG0gKE70UUOAanq2hScYQIAf6o0DzT+MPAF5P73R12Yx9OElz5pOf09e/w28rLrRDGUGeN3h7ELcebpWh/SX+GLkQfZpjzX+6QIH5k6/xdKKZ81ecmwUrKqpaKlOtzs/vGCUyWBsKSHNvP+qlcFjjlz3twSVYYm5mtZ7nw0bE9T2UPqnAH3mdHs5qtU9GJLAgzQldo0VQySKIFd7gqnaGUSnDb68/I37PzaGdpPQFFIrpNAgn+GMfcRbQaMjOB7aItqy8ik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 09:13:16AM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 13, 2025 at 06:07:18PM +0300, Leon Romanovsky wrote:
> > > >  /* Helper function to handle DMA data transfers. */
> > > > -void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
> > > > +void kmsan_handle_dma(phys_addr_t phys, size_t size,
> > > >  		      enum dma_data_direction dir)
> > > >  {
> > > >  	u64 page_offset, to_go, addr;
> > > > +	struct page *page;
> > > > +	void *kaddr;
> > > >  
> > > > -	if (PageHighMem(page))
> > > > +	if (!pfn_valid(PHYS_PFN(phys)))
> > > >  		return;
> > > 
> > > Not needed, the caller must pass in a phys that is kmap
> > > compatible. Maybe just leave a comment. FWIW today this is also not
> > > checking for P2P or DEVICE non-kmap struct pages either, so it should
> > > be fine without checks.
> > 
> > It is not true as we will call to kmsan_handle_dma() unconditionally in
> > dma_map_phys(). The reason to it is that kmsan_handle_dma() is guarded
> > with debug kconfig options and cost of pfn_valid() can be accommodated
> > in that case. It gives more clean DMA code.
> 
> Then check attrs here, not pfn_valid.

attrs are not available in kmsan_handle_dma(). I can add it if you prefer.

> 
> > So let's keep this patch as is.
> 
> Still need to fix the remarks you clipped, do not check PageHighMem
> just call kmap_local_pfn(). All thie PageHighMem stuff is new to this
> patch and should not be here, it is the wrong way to use highmem.

Sure, thanks

> 
> Jason
> 

