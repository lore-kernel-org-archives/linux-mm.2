Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F0AC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894836B00CC; Mon,  4 Aug 2025 11:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C276B00CD; Mon,  4 Aug 2025 11:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8E36B00CE; Mon,  4 Aug 2025 11:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2B16B00CC
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:26:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E70DFC0707
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:26:26 +0000 (UTC)
X-FDA: 83739451572.29.77BDA95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 59F78C0012
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:26:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G8aHgZEn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754321185; a=rsa-sha256;
	cv=none;
	b=i4fn60+pAJgD+TmVahlsDc79PYZF/0kJo//sAm7MACA86uBH57tWNS5OpvFyywueSQhPT/
	SlCCTfJrExoTXmKGNBrPE8J3uiSefri1MmtrzjpwXYCkQChzfuXOlaLnezKHGzWqaGfRIz
	hdRbG9xWjySEewBLX4aVShK4iE3W7SU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G8aHgZEn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754321185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tMI7qu2AITMl/8GQTNLvasEXT9Nk4AYei6S4SrnZRNg=;
	b=qDTxYso1r7l6Fc6TY2umm16RVTCT8MisD9/nmgtbUGG93KpiGVeMXBB1Hn6UNOTHamPPFu
	FZ+7wNUHhquqkj6dDG1KKTadBvHsvvVj8tVhZM4ZhJfbsep3EF0Pv/Piq08nwcIZgJoz5+
	by93WnCNNA3hkB4yP//5S9R56ClbEqM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 148C1434BE;
	Mon,  4 Aug 2025 15:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28538C4CEE7;
	Mon,  4 Aug 2025 15:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754321183;
	bh=A7QWfqthNAE1vRjDCcZdbOxk67HAqqSO9Vh3esAKykw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G8aHgZEnu5iXvCP7Bs5tuWefE4ftgA8h8Cjl85Cwm5By9LieCOsjVqy3AdZGS2J2M
	 gWpzl+6EFBw/RcBqC5KpnG1ipGUhJpU+Zji4nx/hTyt4NrdEsiC2Yz2U1Wkzd/Ib2a
	 QqAw4VBqd0cclEUaixH0rs/7nLDQeEd4unvRQYUSQURTz7+jVwS/zV9otrzj3jp79N
	 yUvnvgyE3xRQ4zHvh0Mw/ECgF8Le7V8q2qdcMJT+F/84f2NxFe4MykBa4PKbCdIa1S
	 PCz7RUMVTUjwcVuJgGK+jMXUeWg1UaBDlwSS3wIOPEFwlaX7GvD5jEG30YanErScjg
	 iRFzDP1lYO0Lg==
Date: Mon, 4 Aug 2025 18:26:18 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
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
Subject: Re: [PATCH v1 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250804152618.GU402218@unreal>
References: <cover.1754311439.git.leon@kernel.org>
 <5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59F78C0012
X-Stat-Signature: mh7pi13kgh71i64w96othgocz4x8p3he
X-Rspam-User: 
X-HE-Tag: 1754321185-896193
X-HE-Meta: U2FsdGVkX18N8j6fE32BF522h/SD4cZkRQVpmXI2f6qg1V1Bm2IjlpbuN1qHnIHkO2t5WogfVRe64E54lC3wC4DTdxwT8PQzywdoj3JskUlWV31t9ZINf610ceTVE/3FBsFhrD5ngUVofB8QwPMRsx1BUYjNKsK09s9TYHKoRvwnrBiWnj3vUN3eLRlSgzPk9+WgeMk0SY6Af7VO7Q2/dj2SNdBVQz9ej5ex64FUypEKgLWmAXXUgL84USRh+tjofVBT4/t0vYLllWAX6Yv47pjhqm7i4rj8eO12KY1wkBkf+cwiBGCvwaHVUYEaNIB9E6S3rtdvHjIvQDSOBDipktL9KGf2zF5vBH21mZBu8Owei7Q8oLU0YyLOiH01e0cW7ivOStWn1N0dnPHwOWr8arbpdOy6i/m/6gGaBl5UOCNsWeCHWvSDun2p+QI7Uzm0q2JIX6t0ZhrJMhLBMhss/EmsZLMMOadyxzs5n/Oj7h1Ge3FdsfWXyCwnrkPP29a3pwmWSFWl0DVRG7Z8sJaVsWtdQZkRKoYpz+wZOqW8eqsQLhswKmzQXMcL4P52cq2+LDApVikdx/jiXtjdhcNqSe6FvC4yra5AatnmOyMtL8HUpRChVixBKYfrAkjK5IDE/2gWtJDutpSlvQcPjD/Yf6KfdegCUzj6lRX3EuaH1L6FQcpt2Ce9uco564gcnf85WYkgUB0w/TWNOmge+Z5QKp2EmEfbzFD8gnVgcrLCPH6ezlxWmniX5M36udRiW+CxV/tJeaPngsTYzvGpxhqfrkb8Q5r9TyUxQ/128MceMKOiRgJJ0GskibOfA35Sq1j7xm8lSv3lq20X7E/vCUKG/HXffVAThzxqNkQjl7hNIufN6qlc8Fjvo7gA6oWKuhzLxkAnoiGT3Q/Gek24+13V4RDEBia5h1hd2GsnlbRf+3NNZtK/jgL+5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 04:00:45PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Add support for exporting PCI device MMIO regions through dma-buf,
> enabling safe sharing of non-struct page memory with controlled
> lifetime management. This allows RDMA and other subsystems to import
> dma-buf FDs and build them into memory regions for PCI P2P operations.
> 
> The implementation provides a revocable attachment mechanism using
> dma-buf move operations. MMIO regions are normally pinned as BARs
> don't change physical addresses, but access is revoked when the VFIO
> device is closed or a PCI reset is issued. This ensures kernel
> self-defense against potentially hostile userspace.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/Kconfig           |  20 ++
>  drivers/vfio/pci/Makefile          |   2 +
>  drivers/vfio/pci/vfio_pci_config.c |  22 +-
>  drivers/vfio/pci/vfio_pci_core.c   |  25 +-
>  drivers/vfio/pci/vfio_pci_dmabuf.c | 390 +++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
>  include/linux/dma-buf.h            |   1 +
>  include/linux/vfio_pci_core.h      |   3 +
>  include/uapi/linux/vfio.h          |  25 ++
>  9 files changed, 506 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

<...>

> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index d58e329ac0e71..f14b413aae48d 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -483,6 +483,7 @@ struct dma_buf_attach_ops {
>   * @dev: device attached to the buffer.
>   * @node: list of dma_buf_attachment, protected by dma_resv lock of the dmabuf.
>   * @peer2peer: true if the importer can handle peer resources without pages.
> + * #state: DMA structure to provide support for physical addresses DMA interface

This is rebase error, there is no need in this hunk.

Thanks

