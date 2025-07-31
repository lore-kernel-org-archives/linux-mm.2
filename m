Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B45C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 06:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057566B007B; Thu, 31 Jul 2025 02:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008436B0088; Thu, 31 Jul 2025 02:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60856B008A; Thu, 31 Jul 2025 02:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D66056B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:01:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79BEB5A19C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:01:25 +0000 (UTC)
X-FDA: 83723512530.24.C013C1D
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id D198DC0006
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:01:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DKKF3Cek;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753941683; a=rsa-sha256;
	cv=none;
	b=IjGwpdBeVirZYoMuh25m7OG1AecbeUS1YuzmL5Bxwqrfn2LAtO3zel8R77JoQMgNWQZagt
	hGDmyyf90PB0pKQEspulLLPbhKPRmkp3HLvY6EFnRiJ564KfLWSLPqw92mdGaJHt3tU3sE
	ALwK3W6lrzh5dEenzrruyX6vZkehO/4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DKKF3Cek;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753941683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IGpAwwv6EOU3J+szo0L/6K6hjZMUC6+znFU4vGOXvqs=;
	b=hqBKBWlrJg1sAcBBdHR6IZIL9S8Y34MLWTIpKwGo3w1e3YpbXAPCTku+6+qpxVicKn4eri
	tv77PWPl1K2PmmSEY0t2SV5gB5S4ao82YjAGTSmBvAUel1GWahIGEl81qQMztvaIPWrqXG
	AHL38DSnClhjxeB+Do4O+81Zs7BMrxQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D3EB15C5A6E;
	Thu, 31 Jul 2025 06:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ED7C4CEEF;
	Thu, 31 Jul 2025 06:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753941682;
	bh=I82Ku1sBUzvQwy4NqAe/XyR//viXY99kTa/2l5/jmhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DKKF3Cekf++SZHUOWA04jjlZuOEM8jGgJfAc0aVSPmvXHb//UmelF3TSqVbMPTbIj
	 MP6ZY5kK/EHxFqzZkhJ00XfylribvAhaYrLfaOpKcfokV5B/m/YCRirZ6t18pB4ZsQ
	 bsaI+/poV49jhLpK/ZRr0Q26G8cpUoxT/F6a+V9gIC9BqoNiSkyVuYGzpHG8jsb4gD
	 kIHsaNE1F48jrFXtV51opjZqdV2cVTpPGIvzjcT2MgCfaAhoBQdDME7Z3UNkBRnB9F
	 9X1Zop5ceYd7F2qaq0bvgxU4gZ8+qznN5tM1C/ZQL7YhzeOUqryCvMmIs0/hr+BEoT
	 BFZZ8xU/xu5mA==
Date: Thu, 31 Jul 2025 09:01:17 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, iommu@lists.linux.dev,
	virtualization@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] dma-mapping: migrate to physical address-based API
Message-ID: <20250731060117.GR402218@unreal>
References: <CGME20250625131920eucas1p271b196cde042bd39ac08fb12beff5baf@eucas1p2.samsung.com>
 <cover.1750854543.git.leon@kernel.org>
 <35df6f2a-0010-41fe-b490-f52693fe4778@samsung.com>
 <20250627170213.GL17401@unreal>
 <20250630133839.GA26981@lst.de>
 <69b177dc-c149-40d3-bbde-3f6bad0efd0e@samsung.com>
 <f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
 <20250730134026.GQ402218@unreal>
 <20250730142818.GL26511@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730142818.GL26511@ziepe.ca>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D198DC0006
X-Stat-Signature: gpwxtidffrk5fikrnz76m6on3uwk1hst
X-Rspam-User: 
X-HE-Tag: 1753941683-815726
X-HE-Meta: U2FsdGVkX1+P79a44+DvYc6XnBo0iTjTh3MhYFF8TjSh1VcoEo/59gcA+GhLQlmmFEvmvwHXmhO33OCPfrA/w2w40YSCqEZqGlwnLM7Iu4rChsh2MZQ6V738VUIBP/hb042qU02phZIT2zhEpC52iLT5fZCJUxCHUD84HJr+9VN7GafE65eYEK0nZd0Kqg1StLuvU+iRy1TqgJTDQ9PR6eJJ2WnlvR3kiuvJ9Ze4iaROecHT62LVjppe+DEAXpFFnVV6vuwfAE0ADB+i34QnF2RygzT2afvFl3CIWqeS33hE6BKlKwfnrTTyVzR0R3Eti1I0DwFNvkwfZ5beBdXyuWxQ3ZTBg1XMffFqLtxJJD+Ccidm0fC7bBTNr7L7KzXEE9pCXXdQwpN4r0wHRishab6NeMecvlVwVlqYkeMCBK7CXFVLOF8Tf1mJrlGVf2/ZqdHOE9XhWCs88fa1I/sHYbgaCNcF7EZNsuvrh6DpYF/USvSY7M6sDzBCSkA4l5Y9BU3jlVzQ9ODbe6prSPH3u98pvlR94pObeKxAAfLk/qbzNBfA1EW1F0ixpZOxcZYcLlmrjfjJvnFul72a3T2xwKtzQUpvoCKZijabstmuasYZxedv94yT3X643BEhEgMt1nySO0efD71H7PYGOPCp20vboFHWj8ma9ZcfPFVA0xvcfvl0RyY0mRS9qCzoh5b/1am9f8ng/TVvRdpnZe5vXAiygKU6asCNF4FIQC5QD4K+oo5Zg1mRATcgu2vCjdjVKZ4ov10tnO/zB1OLfrwI3/mJjVx9QHGeQ6oAsivtEUKW3Cw5hweD2rASjLOZJcRLjz2wwcKQCNjSosvQEsokN7meQ3TNuEtjSjxk20TRwiD01Ka2584zL/d5snUHM4ovNpn306y1JQhCvgXDFiF6HEp7/KyCv8O4tIypEezDfKpGnm2CSIYzrLobtDnnAbZ3FjU2JkF1A+5Cbf/tmeZ
 SEGlJwVA
 OT//3mIPbDw6qqa0mQvKvNSIha2H6TxUF+i7JyYWPx+PCee7Wq4EuiHgf59YnwGuH5u0cIMJXf0ebAv3fJVy+lzP9DHpJDSbA59TzWJDtKsSTvhkR15owjiltj55zayO4215zbJrKWtnPto4MHaehMxCbQpTsW4pp5GBoTAiroTIPYtcnUir2WR1ABxm4LBFIpaHQLwMn8ROozRiXsPBWWh0fC7ZOCo3MH+kFoxmS7cFfcAPtyTYsvEjcTxtFA+EXir4i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 11:28:18AM -0300, Jason Gunthorpe wrote:
> On Wed, Jul 30, 2025 at 04:40:26PM +0300, Leon Romanovsky wrote:

<...>

> > The most reasonable way to prevent DMA_ATTR_SKIP_CPU_SYNC leakage is to
> > introduce new DMA attribute (let's call it DMA_ATTR_MMIO for now) and
> > pass it to both dma_map_phys() and dma_iova_link(). This flag will
> > indicate that p2p type is PCI_P2PDMA_MAP_THRU_HOST_BRIDGE and call to
> > right callbacks which will set IOMMU_MMIO flag and skip CPU sync,
> 
> So the idea is if the memory is non-cachable, no-KVA you'd call
> dma_iova_link(phys_addr, DMA_ATTR_MMIO) and dma_map_phys(phys_addr,
> DMA_ATTR_MMIO) ?

Yes

> 
> And then internally the dma_ops and dma_iommu would use the existing
> map_page/map_resource variations based on the flag, thus ensuring that
> MMIO is never kmap'd or cache flushed?
> 
> dma_map_resource is really then just
> dma_map_phys(phys_addr, DMA_ATTR_MMIO)?
> 
> I like this, I think it well addresses the concerns.

Yes, I had this idea and implementation before. :(

> 
> Jason
> 

