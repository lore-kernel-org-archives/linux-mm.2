Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E9BACCFA07
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906AD8E000F; Wed,  5 Nov 2025 03:17:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6E98E0002; Wed,  5 Nov 2025 03:17:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD708E000F; Wed,  5 Nov 2025 03:17:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 694628E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:17:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2367E5793F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:17:10 +0000 (UTC)
X-FDA: 84075848220.10.478E701
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 920AB140009
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:17:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zb+T55Yc;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762330628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q76SVDt/cKnBAZdHGIeqpxZzSLgMKK1sMEWdOaZ6xWY=;
	b=e8NtVBL6/Qj/4ETg863MB9leb7uv9ySGbh8UcYYiqgl5QFMyn/0qyCaH76aUTW+299Ci2a
	DrgHR5Gh7Be/eTz+OII6DFcgFgJMMYY8OrZ3ep+9asQrCUd35X2dvIBf2/THcbqUfh6ZRF
	pzC7vSC9kWHnwdxvpAfcBWfrxPVrqEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762330628; a=rsa-sha256;
	cv=none;
	b=jZHzCzF9VOD7nVR9JpPSuZ12041laR8yDPamKbtvc120GIB/Xh12KiwTZhnAXGCiyLoa61
	nTz9gVO5Zzf21RPCXpCRJvzBOtPemnV5l39w+4vPk5eNV0Zx90XeLn6fEIqDxXQcFkQpSk
	NLe5Xxb1hzukr7kFSM+sDsyEFXClk6c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zb+T55Yc;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F6C0601FF;
	Wed,  5 Nov 2025 08:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA46C4CEF8;
	Wed,  5 Nov 2025 08:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762330627;
	bh=I+PyMO8FO2EK1xxh53hnQc6PLSI72+wbeSBrnWGdMZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zb+T55YcpTdB9AIBqOV3Tfmamiogsb9dfH66G5UFmsvyAaTjQwCqltsPnhHyyZY73
	 nOFOU6WP1ft/xSqaEt/fxOYY34rSlR2Z7kZJZ2rbDDGT2htW8PuKNT7WyTlieODQ2k
	 plYxGV3055zKvlQOpqNywGZpdXSL7V90rwPlEqkcB+Fr5kSmTRutn309z5RZ99K/Ju
	 Qy5ihI41f0ozi/Asgk4c77bI9TE2m7zGEd4Zm7hcmxOJ2Ac8BiG00O/RgTJT/OiOJ6
	 8jlwnQigCl72ejo1WwJNNSX9r2OE+z6ujbXlOVM0BZHNjqTh2DxRuz7XYwq0B/+2mq
	 08Aom7/pRG6lw==
Date: Wed, 5 Nov 2025 10:17:04 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251105081704.GB16832@unreal>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <aQpRz74RurfhZK15@Asurada-Nvidia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQpRz74RurfhZK15@Asurada-Nvidia>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 920AB140009
X-Stat-Signature: q6m664cc5kn4n3rkyj58mc3qc7ypucjw
X-Rspam-User: 
X-HE-Tag: 1762330628-67079
X-HE-Meta: U2FsdGVkX19AcdQ7PNqW0cLc0ro8AI4Kj7cVcku7m4VCwaef7QecEH3tYHCtbjFNJ22XN1ChqA7heU/vIaztbKqwk7jXRq5/iv1JES6NJFNbu8VFxn0qRdfPmH+Q7kgzTMBR09/BOPb7v7j+zTtabOIBmgDPHBGI3VqXyq/9GR2xcuhZ/2ChwBBvYYvJ+HZho89ZhgX0MImRPQVB63X1N2fMeL70guN3TDktUKvkpjjuWuVGPZEjp7ZIn/VkGlxAESuktPalktyqTq+O+ShqEQZpNi8UknzgerWYZCyRrfeycHdsOUVtD14BAtItayhap2ATzW1CtKJRQxeyfTH0FFBVdavuwDkjC4oaBPFFqF0GJF39Z5SrQCG653iLIyNRiGySCk8iPVVyNSsGFO7B5O03Yz/v+XvxNW1UiO7h1Bsbm39Db7IXNSSTbJF70GkY1BD8/Z+SXdWTuI3piw/87uJ+oFv4VyeZ/EoJ5HyYPJpYREAP3hIL7Qgp62Bhv00DrOMpd4HGygxeQllsGUWf8mLpP/y3ZrDdJWy8EJYck4QqoFwQNUnraPM6LvoWP04px0MBbE5UWCOv2i6MnHLY6dPvOHa5PSD1gsfD9JhC/KuLHTq+8hKKsAMwU2BMJavWXXBzFkbYoaVqYgMiWgPkY21S0oUG37mOO9Q/Rrq4UhQCLmJBGzzoNMqwZcpbbwYZK6SiE9osQjtaFycDA8KAJKpJK/bb99utuqVan72qOUdOEWnqNeF/Pe0SB5jm3Nlx6sP5BNHTH88+NZ8NF6fNkyHCvHiy8BNrWYZzI+eCxDBXfS632z6BV6M3s3gq6VF60O2u36z0gKobxu6do4htrk8QnbrbEG669tSWVOwczQtJLbnPmp1ykPV9cbyUXKjS4LGYWnHooRZ613QobmBrvRrJE/12BjEUwvNO2y0+FgQD/70TY2CJQdWVRM810HgRxF/0KxDmsAnzhSt3Kl4
 ST5R4yo3
 1n446TZVX/XnpUYnrJAJ8PnTYULHmGY7ZN+ZVL4QhD9kSb0AxwaFfedpVGwLPhmWWWVIKkzt6lHIj5wq12o1WbY8LNWbGzQYKJqA9GKdy13+Dlwv4gptkWUJav/7O5W5CbfX1GXQDSGtpaNYiut6Ym+nnemBtaIiI74eydvV5B0RIAyVnRKtNGn47ZdLA4cTqfnRYzkziDsjYngzmZqm1CBZCaE7/xLeWABY+qUU9RH1Wh527Mf8YuBP2qV33SFkX5Jb14oYvg/NF3JrrxPeIv0R1AtJihxKggB1FiDTB1O7OJ4o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 11:19:43AM -0800, Nicolin Chen wrote:
> On Sun, Nov 02, 2025 at 10:00:48AM +0200, Leon Romanovsky wrote:
> > Changelog:
> > v6:
> >  * Fixed wrong error check from pcim_p2pdma_init().
> >  * Documented pcim_p2pdma_provider() function.
> >  * Improved commit messages.
> >  * Added VFIO DMA-BUF selftest.
> >  * Added __counted_by(nr_ranges) annotation to struct vfio_device_feature_dma_buf.
> >  * Fixed error unwind when dma_buf_fd() fails.
> >  * Document latest changes to p2pmem.
> >  * Removed EXPORT_SYMBOL_GPL from pci_p2pdma_map_type.
> >  * Moved DMA mapping logic to DMA-BUF.
> >  * Removed types patch to avoid dependencies between subsystems.
> >  * Moved vfio_pci_dma_buf_move() in err_undo block.
> >  * Added nvgrace patch.
> 
> I have verified this v6 using Jason's iommufd dmabuf branch:
> https://github.com/jgunthorpe/linux/commits/iommufd_dmabuf/
> 
> by drafting a QEMU patch on top of Shameer's vSMMU v5 series:
> https://github.com/nicolinc/qemu/commits/wip/iommufd_dmabuf/
> 
> with that, I see GPU BAR memory be correctly fetched in the QEMU:
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 0", offset: 0x0, size: 0x1000000
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 2", offset: 0x0, size: 0x44f00000
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 4", offset: 0x0, size: 0x17a0000000
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>

Thanks a lot.

