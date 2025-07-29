Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5F7C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 10:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6416B009D; Tue, 29 Jul 2025 06:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785FD6B009E; Tue, 29 Jul 2025 06:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674BD6B00A0; Tue, 29 Jul 2025 06:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5891A6B009D
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:41:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D940C1139DA
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:41:11 +0000 (UTC)
X-FDA: 83716959942.25.ED2FFD9
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf06.hostedemail.com (Postfix) with ESMTP id E1DB9180005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:41:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753785670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CReHigB9yRTHOWRtMRa+2QSWDMGkl513VuGe7ZS6baw=;
	b=o1h4+JZlfd75doFe5lXWm3muMSsjWTwAyOc5IagIBdi8CsBlU0z3ZZGFSAAhTiy9LzbuC9
	HqocARb2PzNz5xsHXwPstoxcekpsTSUjJa12tbAXvDI/mxrGXDDBuRxbdPwj/qzDKIpVh6
	7A133NY6APx09B7rYieiDkKqk96P4fc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753785670; a=rsa-sha256;
	cv=none;
	b=q7IFFfuiWrHQW90fBiBGNzcbYdtXSchqflQzhshTN7rnEG931ntGU5jIY9/sWhNdwMUGQe
	7eaBNO8iB7qt4IDYAARaHMvSS2A0GVb+r5h0Dq6D28xJUsaHO1iegl6hQ2MWEQSgrFi42K
	+AB4N3BFTVEtnlvoCl7yH7TOdze+Psc=
Received: by verein.lst.de (Postfix, from userid 2407)
	id DDC6668AFE; Tue, 29 Jul 2025 12:41:00 +0200 (CEST)
Date: Tue, 29 Jul 2025 12:41:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/10] PCI/P2PDMA: Introduce p2pdma_provider structure
 for cleaner abstraction
Message-ID: <20250729104100.GA29053@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com> <20250724075145.GB30590@lst.de> <20250724075533.GR402218@unreal> <20250724075922.GD30590@lst.de> <20250727185158.GE7551@nvidia.com> <20250729075209.GA23823@lst.de> <20250729085336.GG402218@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729085336.GG402218@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: E1DB9180005
X-Rspamd-Server: rspam06
X-Stat-Signature: 6gzk98zhaozo3crrih164i6fefa4qejb
X-HE-Tag: 1753785666-698636
X-HE-Meta: U2FsdGVkX180sQelNBdGAhXMPn3LiEVssO6hzKzpWqsFIvrdXGHAbd24Ah0Ncwfdnu6Sl/bhEqevoU/bn63LdMF1f5GbAWxPoxSLABWpIvgxzz4tJTdbqoEoX5pqeXIARChjLnTzt58M64cDOzzvNVfEO37DT8uZO1YRtKsD+cEtHXWTqRDCuFJbaXvp5E5o1DtaQNWsRyJweMLeknjaRO+a48qawl3OplTWO6h3yKtkbSOZqIulLjDcBrDyWX8GoYoi4djaA42CPumB0c39DQuM8P3VWnEQFLTdLXtLm0UMWP0TP5j3eCGABSDEagoI1p84LS++d+D0BfJRXHSaUi3MYTEtM5l1keDQ51QNRjZ9Hpn+0j6LBDjcq9xKBzSwUE6QAckFJk9OR7pKnbbc5nw7w2uSFnuxKjD2r0suDSsj2WL1j39rZJ1S9S+ZFKeWZ6rp0XsgwRdoFjG9rFtxV8AXTQqITHB/R7gVXoxgZqHLXCZPiPzUJQQ6WCZsjqTo2pvC3VSYXllS4L00I0VwZaFggcN1NWgm5GOmqVVz2Rsu3RpKMbcoJzpT8P9i4ktIe42Fa4iBO4PXQlVVlZDukWdgu1/SojHHCNk8+gwpTn650Ial+j91TW28p8yZMZg+1RpMibvY/tXvtD4uKsQO9Lok0Q5/M2h1ApR9IuYoYlKm0m6pgRTYI2BC2uSWVq9PJq5Xh2BZMtUY1LKG0eBXZIZhff62qswHEBFrJJj2fnlpWEm2fhIzlVWvEFd2qIYeaInzEnd9ocPRxg2EpbsnefkkdpZso3sgyQx+AZmvCAOJUkhqnD9AcSfYnfaO/uWSos6eaw3yRWyWfPI949yk8S2TdTcLSxmKqSyJjrSpQGuZ6Cs/3XfaiFYWRcLMKuSHK4AEOwakj/l8Z8ltxXAg3NYAL9wnMmdK1bbSnJCYwuXa/76HeaitDaHTXrblNkd4FaoYcinqB3WxQJ7sXZS
 H8S9j6Mp
 q78A+vDh9tST1YLE9VXrRBvsrLI+KeywiFBJ1JfTkUcnC8dlpP+myEv6fCZRowV3z6nKYOqj+ASHlHotsnSC3zCd9cZ6eYZ0o9Y5r2xJ2tu/IdHa7s0RYvFqDS6vN1N1sExjFcv99bOtzqo4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 11:53:36AM +0300, Leon Romanovsky wrote:
> > Because the struct page is the only thing that:
> > 
> >  a) dma-mapping works on
> >  b) is the only place we can discover the routing information, but also
> >     more importantly ensure that the underlying page is still present
> >     and the device is not hot unplugged, or in a very theoretical worst
> >     case replaced by something else.
> 
> It is correct in general case, but here we are talking about MMIO
> memory, which is "connected" to device X and routing information is
> stable.

MMIO is literally the only thing we support to P2P to/from as that is
how PCIe P2P is defined.  And not, it's not stable - devices can be
unplugged, and BARs can be reenumerated.


