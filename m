Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 393C5CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 06:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8243A8E012F; Thu, 30 Oct 2025 02:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB2E8E0112; Thu, 30 Oct 2025 02:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738238E012F; Thu, 30 Oct 2025 02:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EC7A8E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:48:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07A111403FA
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:48:27 +0000 (UTC)
X-FDA: 84053851854.27.6BAB053
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 44AF9140002
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:48:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jvaq5XNT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761806905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZC8yxVQCa9uPFwuei4xh0eYMCtEO5w5WZqSA9YQlS9M=;
	b=O4VBjpuKsNTinwiPCmVIrDe3T3ThKNIn/ZdWMV/sjMWo4+ka5wkJeTg6HD02E7b0P64Yob
	XSdz/yTtYgYScxcIRx+NfvEVGkrnqy1DsppDOPVopCP7fyAK41NIdISyA9UPk8wJQQS4o3
	+uDCY3cCm8GUvatcpEk8GiOWAeIPoEw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761806905; a=rsa-sha256;
	cv=none;
	b=sqiZGkwN9OUc6OxkEGkZ4ZRFkYK0ieW4flcOAGAuW/lAcUoS43whhU4fCH2sKFWWnGgMZa
	Ftx2oUkHRnina6LB4MzvYaZIzGXu5RXEQQjHmGIwby+73EBDi9ctInpD9v4HQKW5Fpk4M/
	zTEW1fB6gBhgo/fREh07PB4hMtW9yGk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jvaq5XNT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1340543ADE;
	Thu, 30 Oct 2025 06:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26554C4CEF1;
	Thu, 30 Oct 2025 06:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761806903;
	bh=Hh7skkg065ylczpCr0Iv292nYGj50H++UlcoJlqnTFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jvaq5XNTepDILhgg1JjU/RUVDN3aAiAJIkCA81z5TSuHPckkaF3X0SyKZTH4NiHLo
	 x+finAT9AqYTJiYKAczU3VWRnf+rm3VE20OrKWYI/Xxc5hFGsCXFzXGxlRgl84S3cn
	 1erdjEeAotdXzH15cDoYeVH+bTlS6vCEewWmlIP12FHqqmKW1wIhJVbVTWmVOPGJrX
	 RJ5aoNnkrAbFiXF+dpmpZF6tfJYJwn+YpHGgTwxQxqrtPlhVJhYtSdcxvt/ny5ubyp
	 08qX3boYwst6Z/pSklUkGal7BAeNf8rJyf2PuG4I88FPZtBaphc13e3GPPIzUbz0sz
	 yNDwwG6BUC0cA==
Date: Thu, 30 Oct 2025 08:48:18 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251030064818.GA60090@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <CAAywjhRb6Nwmzy+QWFPH9Zkn-xvtvOktNjAZ8HMpM2wmVw2rjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAywjhRb6Nwmzy+QWFPH9Zkn-xvtvOktNjAZ8HMpM2wmVw2rjw@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: 4qgwzz7c7rhm319xpx7wofjz39gqqype
X-Rspam-User: 
X-Rspamd-Queue-Id: 44AF9140002
X-HE-Tag: 1761806905-729053
X-HE-Meta: U2FsdGVkX19j4dgEFcb45LzINCiXFqZi1WwJAFJWbDCN/W1paErVH3f00BUpcDEBXm0DEn/PND4SAFgZUKDkj0fAuro165CN2j+LVRMynEBYOXE8has23KRXQqhn4nD6yZn8jpebpbsEdrK+nFjkOBF7dIT16prpXv7kF6baR5hPG/nbbKzn8fPbQmK36K0J6+prKBgoposItgQNRSHWxCOwtzX6a9FQDUS5ifdefTh6eiPN1kxfPkT5smUxFBlQ8Ftp8PhPX/rAnUj54HUPZIsntK2tcSUqf3wXAfd+mIo+Qqp/JhX2Wxewd+X07wtcGTDVL4lHrJWL+DYUy2nArP1lGpXPnf9pLHoApfPa+G/Gp/tm/SYfTccL8gg/yXrkg/RAQZ8ZDt/qOz1Nus/dyImYg8oxWVA7BVx/9ycAUCztBhrGc9paiHq8kyCB85aaxCg2VMonMQVuV4OcWeiZeLjxJycR4MZHWKX6wBrdWG5BmU+w5NMxXtYn1x3LkQiKMXkRCeklHs+Y/EWiYQEqu2rEZQL7lgZpoRlHA1plOgaFLGNBVwpBHfn3RSSU276Hgb36pO8ecoSpgAe+7ql7ZwkbGqx3najZiG9io/kb90ZOLXLawiceQTz5nSGnuYO68YSEw7wqNIDLpc5URgjB5P0sGZx90lJYYkZSAHWJE+YX/ZagJ7SloEg+X6JlwDOfT9CI4MSa1CML8FImQwdHzlrtZaLY2zJs8m6/5rwo0pGn5nP0BR9FiHGjRpi93GZkuW/Khf5WDtxnIr8VpLCHgKf91Jb6HGRI6+G+URKVtUMVZqRXDrcYu+cworc3j+0m+sc8ele1GETOk59NeWsNqyIW8qwSH8P6ftW82neOUEJTUYjvPNaEjE8C8LmJ7I4+iQXC3eXin603pwetyAKr6SaSZ+0Hr6IC2Egvs2daS+x9p/YU6PFWBrsHsUAVoIL1m4kl4B/khOsr4DFaPd4
 6jZQ2L0O
 hlRgvyvkA1hpljFvYP6dIn8ru8OAgNmBN0aQk68xJLJBpkp9+GFsOlCd379VsTi4LPFooFHoXwvwmzp70Qx+PXzL9eA8vLrN40zRz5GdL5Dy5bT/LMmZ0M3vmZ8sZbeGkAx5IfDlvAsoArXlwFyNe6U7Az31p3qcq+En9IvFJea6eYg17SPiSlANY1c7PG7HD2wIHp/dDu76F/qjAwtBi6do8MEf/DStAnmRR/KoTgTq0f3ydFjeikcwDODR2bbi7+LACXn9Ur/9H5TxObtEAG5TFMyg4Su4FA8gkXYIwRHU1HvD7DQc+ON/tNLxTUwhE0y/s0gPakKedFYWNsiDQYGmSA733q9mp/kis
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 05:25:03PM -0700, Samiullah Khawaja wrote:
> On Mon, Oct 13, 2025 at 8:27 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Add support for exporting PCI device MMIO regions through dma-buf,
> > enabling safe sharing of non-struct page memory with controlled
> > lifetime management. This allows RDMA and other subsystems to import
> > dma-buf FDs and build them into memory regions for PCI P2P operations.
> >
> > The implementation provides a revocable attachment mechanism using
> > dma-buf move operations. MMIO regions are normally pinned as BARs
> > don't change physical addresses, but access is revoked when the VFIO
> > device is closed or a PCI reset is issued. This ensures kernel
> > self-defense against potentially hostile userspace.
> >
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/Kconfig           |   3 +
> >  drivers/vfio/pci/Makefile          |   2 +
> >  drivers/vfio/pci/vfio_pci_config.c |  22 +-
> >  drivers/vfio/pci/vfio_pci_core.c   |  28 ++
> >  drivers/vfio/pci/vfio_pci_dmabuf.c | 446 +++++++++++++++++++++++++++++
> >  drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
> >  include/linux/vfio_pci_core.h      |   1 +
> >  include/uapi/linux/vfio.h          |  25 ++
> >  8 files changed, 546 insertions(+), 4 deletions(-)
> >  create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

<...>

> > +void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
> > +{
> > +       struct vfio_pci_dma_buf *priv;
> > +       struct vfio_pci_dma_buf *tmp;
> > +
> > +       lockdep_assert_held_write(&vdev->memory_lock);
> > +
> > +       list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm) {
> > +               if (!get_file_active(&priv->dmabuf->file))
> > +                       continue;
> > +
> > +               if (priv->revoked != revoked) {
> > +                       dma_resv_lock(priv->dmabuf->resv, NULL);
> > +                       priv->revoked = revoked;
> > +                       dma_buf_move_notify(priv->dmabuf);
> 
> I think this should only be called when revoked is true, otherwise
> this will be calling move_notify on the already revoked dmabuf
> attachments.

This case is protected by "if (priv->revoked)" check both in vfio_pci_dma_buf_map
and vfio_pci_dma_buf_attach. They will prevent DMABUF recreation if revoked is false.

VTW, please trim your replies, it is time consuming to find your reply
among 600 lines of unrelated text.

Thanks

> > +                       dma_resv_unlock(priv->dmabuf->resv);
> > +               }
> > +               dma_buf_put(priv->dmabuf);
> > +       }
> > +}


