Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 083DBCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 12:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A6B78E000C; Mon, 20 Oct 2025 08:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E908E0008; Mon, 20 Oct 2025 08:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB438E000C; Mon, 20 Oct 2025 08:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 292F38E0008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:27:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A059311764B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:27:17 +0000 (UTC)
X-FDA: 84018417714.16.4F3A83C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3679F16000A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:27:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KQhiungt
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760963236; a=rsa-sha256;
	cv=none;
	b=43rsIpHOg/x9AYwiypgjx8BSOxTT4InitSchjpYieUQO76fdTGPR+gAvdDz4dEwRmAIp5V
	hX8f9UVTTPyWPgNGt22ZXyRWlXIAL7yaB7gD9jUFlZdpCjzEP1kMvoMRow2K3WwjcBzD+j
	bDLS3rsDrAm/xUf28Qu5h0lYGHWTbJ0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KQhiungt;
	dmarc=none;
	spf=none (imf08.hostedemail.com: domain of BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760963236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdaQM4uR5JLsKGA0oS0VASYRTZKdaGisbnRnH43EfLY=;
	b=RCAYtbNoVIgHMSrpCoWJVWJezeg1DTO7Zvafnlcbts1Yi4KCdvR4EGwPadJLQkyQE9uOtG
	RHv2Hor7ZwpKcuwr0M5CdHWgzCLi3vmEPyAywuOU9of2ZMtNEv3NBMtD8w99YpsoYYlTsN
	Vkg2Sm9uX5+3QbuVpfbYTD5NTdXWgpU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jdaQM4uR5JLsKGA0oS0VASYRTZKdaGisbnRnH43EfLY=; b=KQhiungt0DOFTC/2vEdmUu5RdM
	IjizyZW3KhQexecpWhn1JKycVRVYWQTJ9G7l/7owVKfDlpqNGVtDnwK8xwsjX6I64YK5ejanAY0FB
	zzX4HHOKjNYa4wCLEeTShJPyzXTrVdkNr6T+/TruAVmGzKfuVYgSNuwpcWQwRtB1xfAiScls8jaTF
	CtGh0RsnHpRzgHMaS7buG481FDfyI7wa7CD/qzHH4+SgPejuNG/LF4EmwQHr8caZKTi5KEcUFoY9W
	z+5GpLZZYb6wF0dThq4Fmcc6GulKZn6HurCZW1AoO7vNphT4pMFJzXHY8iCTyrAiXmSBWSKpPvYGt
	H76pYSOw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAoyc-0000000DPQg-3mdN;
	Mon, 20 Oct 2025 12:27:02 +0000
Date: Mon, 20 Oct 2025 05:27:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 1/9] PCI/P2PDMA: Separate the mmap() support from the
 core logic
Message-ID: <aPYqliGwJTcZznSX@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
 <aPHibioUFZV8Wnd1@infradead.org>
 <20251017115320.GF3901471@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017115320.GF3901471@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3679F16000A
X-Stat-Signature: 649558ytcurrkxmzfdghow7ns5s1nui5
X-HE-Tag: 1760963234-83664
X-HE-Meta: U2FsdGVkX19l1NE9imf241qfkRpG456cg5m1UTQfd4vtX7zs51Nfq9yxkAZl82RaDGbX7S5BrzKcIf9KNZyLMQz71agIQoZWPm4ljWty56RVf/0O9yQGWMEiqCh8wxu5LECBx9RL86WZ3wns9yicirEZOuT5YJydbaweMlnyAedztBq6rie8AvNgUAOTJfOyj10mPlyVX59iS4p1gZL1G4AhAQtK6nWU6yn8MRMdQRvZolivxgtGVX8ozqo9B66SDXIKgRLUofvT/mZzwCsoHJeY3xOZ4D6KQoGIWp5snx56uL8qtDVb00b654j0BIrR16kL9Csudo16ZwwCFZF1tcXB8b3njiggSAtbqCUM1Vkd1QC+f8T6f/nLJj7/cvVfUaElMbgGlOTbz5snNJ5lHlJFAwQoa2rnE2697mjNmoj40xR5ZYYshNP+hMtgiHWp1uxC2NjrG8ZRyL3CfasMrzeUz1olEqhLwh9/sUdQS8Al3O1RgKQIChNS11zrbxC62TU9S1pqokbYgffCag2iqOx4uzlqxncdJ+/Sz/ZEEXs4Q61lT5lQZ5w3tlLAC9GEmH6zdbfvOsioehgw47vgeeJONsXhc02LXYfVotw80x/0A4WdFYmX/QmCiYL6e05t/JV6xrv1IG/S7GK5ztXmKKkoaBfOFCqJX+bL8e2HWroKs5MNOsz5OX78A7I7rwNJ+L6RnPHcOi9IJEI0ghkyUWc/LVjZHox/QGqk5p5o539xXVMgjeyWNwp7Qq31VX8Zajxy32tCv/Ues04oYCd6xBRM6TJa5MjcYJN5XiAK1jLpYG3nbZc/pY3DqkaAfWD7tC+XNLt3uqRBVb2qy4acDNl7mFSlsQq8r2M1mpKWNW39InEpctwtzVfpDvyMT/C/HegR5SZ9ZZQK8JSpD71bG+5Krutf61FJ8SkcrwRou3upcbI5bnmlfUpvzYPGeuBtC+xP4bb3scl7UMoUfHQ
 YNeLrXRe
 7JomOw25z5/aGzGGESraIr7TbB2uVcYqIQ/PjkIu9gS0g0/43HjAgHIayoX1kTNXhniOstUltD0GE3prvlIYTE2PUmqa1EB9POL/h9FrPAzPh0+kRubxhhAc0x6jVX6xgjdjS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 08:53:20AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 16, 2025 at 11:30:06PM -0700, Christoph Hellwig wrote:
> > On Mon, Oct 13, 2025 at 06:26:03PM +0300, Leon Romanovsky wrote:
> > > The DMA API now has a new flow, and has gained phys_addr_t support, so
> > > it no longer needs struct pages to perform P2P mapping.
> > 
> > That's news to me.  All the pci_p2pdma_map_state machinery is still
> > based on pgmaps and thus pages.
> 
> We had this discussion already three months ago:
> 
> https://lore.kernel.org/all/20250729131502.GJ36037@nvidia.com/
> 
> These couple patches make the core pci_p2pdma_map_state machinery work
> on struct p2pdma_provider, and pgmap is just one way to get a
> p2pdma_provider *
> 
> The struct page paths through pgmap go page->pgmap->mem to get
> p2pdma_provider.
> 
> The non-struct page paths just have a p2pdma_provider * without a
> pgmap. In this series VFIO uses
> 
> +	*provider = pcim_p2pdma_provider(pdev, bar);
> 
> To get the provider for a specific BAR.

And what protects that life time?  I've not seen anyone actually
building the proper lifetime management.  And if someone did the patches
need to clearly point to that.

> I think I've answered this three times now - for DMABUF the DMABUF
> invalidation scheme is used to control the lifetime and no DMA mapping
> outlives the provider, and the provider doesn't outlive the driver.

How?

> Obviously you cannot use the new p2provider mechanism without some
> kind of protection against use after hot unplug, but it doesn't have
> to be struct page based.

And how does this interact with everyone else expecting pgmap based
lifetime management.


