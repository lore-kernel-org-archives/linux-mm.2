Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CE8CF58F1
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 20:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268436B00A4; Wed, 19 Nov 2025 15:51:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FD86B00AB; Wed, 19 Nov 2025 15:51:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C386B00B2; Wed, 19 Nov 2025 15:51:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 079FA6B00A4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:51:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7235BA3E9
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:51:04 +0000 (UTC)
X-FDA: 84128551248.12.15A3D07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DCD3BA0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:51:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WD9x9QV1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763585463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKsTKw0lmy0uwxnkx693eVLlNxm2hXnGUo1nzRWlpO4=;
	b=tGFi3Mrw5JvZzEmx5N6mGjlUlepApSeatkhMVVnjI594gTZ3P7QPkyQJ7vwZ0DSKBo7Joa
	Q/XATNfBASKFqBt3PtoNewIZQflBZzW5Q94WEs+STlXXn0JuU2yn9X0ExEUTeCncSot7G0
	rGvR2hwJlIVezDAyxwCiQeOcEVNs8FY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763585463; a=rsa-sha256;
	cv=none;
	b=7B7CnBQML4/SVYhqqxUdx96OIeTziynRF2Th8Fqu5Iav8xEJVBG8iPGIKfkMHkvKfGECL4
	E0RNV5GuVpVzJKfrB4ZM3lNGVmbuqBEseclZ+d7+fSYi0FX9wap+fs+7LnsnNPDcVjKlLQ
	YW6qBWw5AMXOAJTHFrvxzjKVc/sUPKc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WD9x9QV1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98FBB42B3E;
	Wed, 19 Nov 2025 20:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6F6C4CEF5;
	Wed, 19 Nov 2025 20:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763585461;
	bh=DswVG1oTzUiEJ8OCl8YsEigGVa4Bx94nOKhFpt+Wsvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WD9x9QV1DwQwVGIdLkDg9vHfbQWvYyRs6UT8Nax935CI2rJnRDICNwCXS5HIhangI
	 saQZQ2RpBFUMtb4TJEEOL0WHh0wFiFri2b7JG1n0+RK11ZsLc5DGmVGV7l64ClKkgC
	 vRxDQT5EoIvjPLEi3B2XAyJU7WmaDXg8OAMkEXQd0JsmXPrJJv3d6a7i/Z5JdxWmyx
	 zdB6j8b4TGgfCNdk4lt38vyNWR9l3e8PIbJ/I9sUPcdygSMyl55HkgU0LmvIG3CZXG
	 nYSnV5vsWC6s9rmBabRJ/c3v1bKjE10as/k7ibkiwCvxigdkv0cD1MYlZw5r1SLJuf
	 GU4qhKmwKMLZQ==
Date: Wed, 19 Nov 2025 22:50:57 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v8 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251119205057.GO18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-10-fd9aa5df478f@nvidia.com>
 <BN9PR11MB527610F3240E677BE9720C2B8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20251118142849.GG17968@ziepe.ca>
 <BN9PR11MB5276EF47D26AB55B2CD456EE8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20251119194120.GR17968@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119194120.GR17968@ziepe.ca>
X-Stat-Signature: 74qb3pczcwd3gwmne9no9s8cy7x7ejo6
X-Rspam-User: 
X-Rspamd-Queue-Id: DCD3BA0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1763585462-781179
X-HE-Meta: U2FsdGVkX180aIq/XyjZMVmtIJlUCtYTazdZJlQEyEZpomCU1kS8StxPOmMhRVbclnJoYUVzZsgib+HOrj21EkUfavZR3dcwVNCsNxY7whV5aGI9XiJa/ziFRhxk5QgAD8OSR9v9GdzDIqXPIDohRESs9ZnLEFIgFMrQ7wq7yehiPg7T00SYB8M0zrSaMZ1g/fAJCa6SWzEv778XpE3Fzd/1xHqy6HBlnmybLOuCBKkwzYhXsG+jWK/liQgqZ3uZ/N9Cvp6J2L0Sn/JowhSinNM+3Y5DnVZ5DdIxvQ1g4geg3+40OpTitiRsC47yfP+x1pnOUxRFcRKfb3qqdz+T7gytJf0wSeboqdwJGSlIqZqDAJR7D7v52FpmnxdAHYMuUtUwXi/E8DA7/v5CzyFFwC3PlcJ75Wp6HqL4iAVx/bemeWkwGlt3iFH6nKIuJfbHn8lry3M9DmSPxb4KAW12quxkR6TPdoLrar9m8/Kt06IQKXGGf3QoJkx4IAvwMVPvIQeyRNdfjsQ4JYi3ANN4Vm7CkNl/vCrAb7OpPFX3MYJcYmGzy4YPBsmaUNrm4J274Qe2baMPCSn3QC5wAcnf5VbzAiFbg7TAMYXPMvR/W38JF63PYBpOZhu4oE4M5r9SyEItV2CqSY/mzqUFn+m0hrnkY3GsjnTLvM1dhYqO0ZGypWPjusF8S2hYpp5z1Q1cfuOwbteWFxGbK1gKtSZ0O9c81EjS7ZxvP4qHGebRDpG6E/2DV71QqiBGufXZGSG+jLjYztmQfesmjMe8HuaFK4SXNxU2iLvyVuMZKgRVpjqAk7q+Q7tMHnDUWTWbJcRWaa/ORzlJatVQ6k0HUxFks7+2xzHr4mhpkvSInVlcb7oUIMcCwavzADY7mCrLipC+/cXc4nZTn5x7fT3ACDTig2TOEjD/CYNWns1l6HggaXx1pKdirgUJi3GWx88LiyG0KEpb28SFOcH1/qUuHmg
 cdmWMk/7
 wvSBhandeF2AirUUfpk3ZTgJypfeq/27vA2WdwD6k2yNaMipPulMQojZUqDv7vqxY9oq7D2vTpgSKuuXGk+e3qDnwfSLMMzkL5dHTFvI7yh2jSqDy7ynDuKJvmrhkn+zjnmBSOjdlFjlJw6/VKJHwNsB2D8Qq1UGOngfsgTP527LvrhdjODL1t/OVaels2tSWZN3pSpsLeGXyRMAmogXK1D6Bn4s3xWJtDjrP02RnJipzp0tv4xWf1er+Qx1C7cFzeirp++55TGiqv6IV2ziYpbyTs4PcPcSiMsZoB9OGXdzDHV4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:41:20PM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 18, 2025 at 11:56:14PM +0000, Tian, Kevin wrote:
> > > > > +	down_write(&vdev->memory_lock);
> > > > > +	list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm)
> > > > > {
> > > > > +		if (!get_file_active(&priv->dmabuf->file))
> > > > > +			continue;
> > > > > +
> > > > > +		dma_resv_lock(priv->dmabuf->resv, NULL);
> > > > > +		list_del_init(&priv->dmabufs_elm);
> > > > > +		priv->vdev = NULL;
> > > > > +		priv->revoked = true;
> > > > > +		dma_buf_move_notify(priv->dmabuf);
> > > > > +		dma_resv_unlock(priv->dmabuf->resv);
> > > > > +		vfio_device_put_registration(&vdev->vdev);
> > > > > +		fput(priv->dmabuf->file);
> > > >
> > > > dma_buf_put(priv->dmabuf), consistent with other places.
> > > 
> > > Someone else said this, I don't agree, the above got the get via
> > > 
> > > get_file_active() instead of a dma_buf version..
> > > 
> > > So we should pair with get_file_active() vs fput().
> > > 
> > > Christian rejected the idea of adding a dmabuf wrapper for
> > > get_file_active(), oh well.
> > 
> > Okay then vfio_pci_dma_buf_move() should be changed. It uses
> > get_file_active() to pair dma_buf_put().
> 
> Makes sense, Leon can you fix it?

Sure,

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index e7511cad8e06..c67c1ca7e4bf 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -300,7 +300,7 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
                        dma_buf_move_notify(priv->dmabuf);
                        dma_resv_unlock(priv->dmabuf->resv);
                }
-               dma_buf_put(priv->dmabuf);
+               fput(priv->dmabuf->file);
        }
 }



> 
> Thanks,
> Jason 

