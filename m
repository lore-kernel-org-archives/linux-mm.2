Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06051CD1297
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 20:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3B68E0003; Mon, 10 Nov 2025 15:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384AD8E0002; Mon, 10 Nov 2025 15:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2734A8E0003; Mon, 10 Nov 2025 15:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1350A8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:28:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBB781A02A2
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:28:52 +0000 (UTC)
X-FDA: 84095836104.20.98DD5B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A9271C000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:28:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VDR5NR5O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762806531; a=rsa-sha256;
	cv=none;
	b=BUxCnh1HATT3lICTHgjigSTsyBE/y6lfr5qTNax530wtWWjPueauScvcC2SUfwn2T8wGeg
	GdZxUXwWjgYUztbzKJJwFCJynyZswP6wVvlox1a/djlG6kT6apS/oZvgORnRayXawSlLJb
	0VoTremMIB5fgHbLq0mRI7wXhyVUJN8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VDR5NR5O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762806531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agKy1YVMQF27gT6Xg2TDsmrnxcPQp0xDSQux6w1wXtQ=;
	b=QNntuSMAjmK24+UKMfmhdxOif6tJ+9jpUU6jGKEnL1vk5WU+BOG2Zr0jQrjZNUz527PfHO
	b3ykUZmeXREuLV+zqEhj9lGu0Hf9apqcyY9reIvAinfxOf8dKQfY5yGLvdSeo56PxADwdY
	pcSR+Y/7lgA4wdBqUnnrmslLqSZktyg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DCC594349A;
	Mon, 10 Nov 2025 20:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA4BC4CEF5;
	Mon, 10 Nov 2025 20:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762806529;
	bh=2+oC81xV69bAibilHvu376ufSMAg5fmIkqZozg3DinU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VDR5NR5O4p008RBxKau1oQ/sdWlbk31f0gH7CibVBxI2O26euYYItPd8xW5SsGwIf
	 BfyOjN/ef0UL06UM/C3cMVem79iIrZmXWSv4wZWSr2v3hzmZyhdVYJRiHc/Nu+yUF8
	 9iJeGQkgVYsrKA6/OXuRxy7pcx+XJQss+JBluppHjEB+L9jVPGPmZJuPlciZKxqZf+
	 xzXvLVrHLoFaUWXdO8cGN0TSE8B1fAo4BssyPzeiffuWrvNmUc8/Mgm/FjLgoQgQmp
	 E2+9VRHkM50gbCUNPShVcuzSzC5GNOuXLH1k7FYvnVqO5UUwveUcH1RL6Qm3MYu/Hn
	 zaEFUM0yu5v3w==
Date: Mon, 10 Nov 2025 22:28:44 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex@shazbot.org>
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
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v7 11/11] vfio/nvgrace: Support get_dmabuf_phys
Message-ID: <20251110202844.GL15456@unreal>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251106-dmabuf-vfio-v7-11-2503bf390699@nvidia.com>
 <20251110130534.4d4b17ad.alex@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110130534.4d4b17ad.alex@shazbot.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A9271C000A
X-Stat-Signature: yy3fwostux37c35uze554xrj8jwtutdb
X-Rspam-User: 
X-HE-Tag: 1762806530-313824
X-HE-Meta: U2FsdGVkX19ZeKawtmLfmR0rMQ4U0BxXcwoq1lMszpzjtEwmIUOiAPREHHmqj7Eo09euxJhOd7oYAvkdIYqpMNkSrb0Fqj52iXeJoCafeaHd2cl8KLgmVHvruGybEkOpdf8BNZOBuXi7/qUY9GymMfaFxy42XEy+PLnwFGmGeK9ypJZkQeugF75xl8g6a5l6jt/nweZzFNAI1OlePol4avmdTLZnwwlcaPisPl+oY57h+xVI178h24aNsKn6CeOokYtRgdjWD/KqSncK6tFjkmr32V8OZJ9Fi3AHf2l0cTRFG4e8qong1Mr6ILHOoeJbtWjDEDVPZA8n6qsp4Kh8qL6pWeCNcj9xOMmRKr+2fm3hgI66Mtdzh9dLFD/6tX8oCn/jE0rQWOrr+iy8QAsCGxSPVPDKLOFydQsPcKN5FfTeznq3sg3aI4BUSvZzozuRDA6E/2jvPugX4JP4p0BnLGnHo6IANxBde8X/CfibqBjfZnw8hID80fvIAyEoaLW+7RpZ/N5vMJJYVuKPplnkD0j/kTfrqdpdlgLvfxcsUTp+SQLAVeb9ENX4d1ljUZjsTugXLLc8X7ZGBLjrgEuXlh1p4P5560k84i8o4qGlcUaUgwKxz4JTSgV8vJU4QG0udqmBLI9rcgZrSHKx6eFayI3iUJGDBwfCO37vcFZ9lQ4IL1BZ2HadvDtXWQRY7nTFXgPyNfNq3qixjvc4K+B//vK7tpKAHraXnzM4g8vGkLUSzhBGVeguvmmlyfEphitqK2jEJiWKrAhXs/d7QRFG+XfloD3w7GjDvsZSBqHb8OeC7PKrxZX35Y0uP5IpblZqFgEwiHSlYCIeTGWultItYYDjGvUjkrGekTr8Jl0A9DXxJIZWgTekKawx2YfOjFI4/pvQyQM95ahEFhG2JsuLLIGBPWW0O0bqur76iIbd9fZ8Pm/dQQUwUF26YMCoIA5ipn9nJGj+UAzcVVelcen
 879awCdw
 ou59H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 01:05:34PM -0700, Alex Williamson wrote:
> On Thu,  6 Nov 2025 16:16:56 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Call vfio_pci_core_fill_phys_vec() with the proper physical ranges for the
> > synthetic BAR 2 and BAR 4 regions. Otherwise use the normal flow based on
> > the PCI bar.
> > 
> > This demonstrates a DMABUF that follows the region info report to only
> > allow mapping parts of the region that are mmapable. Since the BAR is
> > power of two sized and the "CXL" region is just page aligned the there can
> > be a padding region at the end that is not mmaped or passed into the
> > DMABUF.
> > 
> > The "CXL" ranges that are remapped into BAR 2 and BAR 4 areas are not PCI
> > MMIO, they actually run over the CXL-like coherent interconnect and for
> > the purposes of DMA behave identically to DRAM. We don't try to model this
> > distinction between true PCI BAR memory that takes a real PCI path and the
> > "CXL" memory that takes a different path in the p2p framework for now.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Tested-by: Alex Mastro <amastro@fb.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/nvgrace-gpu/main.c | 56 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 56 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> > index e346392b72f6..7d7ab2c84018 100644
> > --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> > +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/vfio_pci_core.h>
> >  #include <linux/delay.h>
> >  #include <linux/jiffies.h>
> > +#include <linux/pci-p2pdma.h>
> >  
> >  /*
> >   * The device memory usable to the workloads running in the VM is cached
> > @@ -683,6 +684,54 @@ nvgrace_gpu_write(struct vfio_device *core_vdev,
> >  	return vfio_pci_core_write(core_vdev, buf, count, ppos);
> >  }
> >  
> > +static int nvgrace_get_dmabuf_phys(struct vfio_pci_core_device *core_vdev,
> > +				   struct p2pdma_provider **provider,
> > +				   unsigned int region_index,
> > +				   struct dma_buf_phys_vec *phys_vec,
> > +				   struct vfio_region_dma_range *dma_ranges,
> > +				   size_t nr_ranges)
> > +{
> > +	struct nvgrace_gpu_pci_core_device *nvdev = container_of(
> > +		core_vdev, struct nvgrace_gpu_pci_core_device, core_device);
> > +	struct pci_dev *pdev = core_vdev->pdev;
> > +
> > +	if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
> > +		/*
> > +		 * The P2P properties of the non-BAR memory is the same as the
> > +		 * BAR memory, so just use the provider for index 0. Someday
> > +		 * when CXL gets P2P support we could create CXLish providers
> > +		 * for the non-BAR memory.
> > +		 */
> > +		*provider = pcim_p2pdma_provider(pdev, 0);
> > +		if (!*provider)
> > +			return -EINVAL;
> > +		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
> > +						   nr_ranges,
> > +						   nvdev->resmem.memphys,
> > +						   nvdev->resmem.memlength);
> > +	} else if (region_index == USEMEM_REGION_INDEX) {
> > +		/*
> > +		 * This is actually cachable memory and isn't treated as P2P in
> > +		 * the chip. For now we have no way to push cachable memory
> > +		 * through everything and the Grace HW doesn't care what caching
> > +		 * attribute is programmed into the SMMU. So use BAR 0.
> > +		 */
> > +		*provider = pcim_p2pdma_provider(pdev, 0);
> > +		if (!*provider)
> > +			return -EINVAL;
> > +		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
> > +						   nr_ranges,
> > +						   nvdev->usemem.memphys,
> > +						   nvdev->usemem.memlength);
> > +	}
> > +	return vfio_pci_core_get_dmabuf_phys(core_vdev, provider, region_index,
> > +					     phys_vec, dma_ranges, nr_ranges);
> > +}
> 
> 
> Unless my eyes deceive, we could reduce the redundancy a bit:
> 
> 	struct mem_region *mem_region = NULL;
> 
> 	if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
> 		/*
> 		 * The P2P properties of the non-BAR memory is the same as the
> 		 * BAR memory, so just use the provider for index 0. Someday
> 		 * when CXL gets P2P support we could create CXLish providers
> 		 * for the non-BAR memory.
> 		 */
> 		mem_region = &nvdev->resmem;
> 	} else if (region_index == USEMEM_REGION_INDEX) {
> 		/*
> 		 * This is actually cachable memory and isn't treated as P2P in
> 		 * the chip. For now we have no way to push cachable memory
> 		 * through everything and the Grace HW doesn't care what caching
> 		 * attribute is programmed into the SMMU. So use BAR 0.
> 		 */
> 		mem_region = &nvdev->usemem;
> 	}
> 
> 	if (mem_region) {
> 		*provider = pcim_p2pdma_provider(pdev, 0);
> 		if (!*provider)
> 			return -EINVAL;
> 		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
> 						   nr_ranges,
> 						   mem_region->memphys,
> 						   mem_region->memlength);
> 	}
> 
> 	return vfio_pci_core_get_dmabuf_phys(core_vdev, provider, region_index,
> 					     phys_vec, dma_ranges, nr_ranges);

Yes, this will work too.

Thanks

> 		
> Thanks,
> Alex

