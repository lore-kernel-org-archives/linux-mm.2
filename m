Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1326BCAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 08:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18ABD8E0003; Sun, 28 Sep 2025 04:15:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1625D8E0001; Sun, 28 Sep 2025 04:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0EC8E0003; Sun, 28 Sep 2025 04:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E61F18E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 04:15:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84C91BC3E6
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 08:15:20 +0000 (UTC)
X-FDA: 83937949200.12.07AB2AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id CD7A7C0002
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 08:15:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KMtmLekY;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759047319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxEgGzJalYLYRxam3UhasqEjzLOp6l9WnegrxeAbWKg=;
	b=H9z9ZGsAtNwdy5q1D89psXewaWc5EEC+qhUAzQD5+7gL5HGCardmhoNZMLnOLKrQNJLD6u
	hnEAs6BgO7SzRmcrXkBVYkzM9ASYLto6axPqItuqY4OoMiGFsVhW63h/oL2NqrF4DlKoIr
	slEEIXfS3ce+2d00Y1sY+FbhVbg9svA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KMtmLekY;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759047319; a=rsa-sha256;
	cv=none;
	b=s9U0YVx+NRuuj5x53qgdbiCrcbeu2mOEM3TpKRkrsO/xy67ioqgKUDChAzZnksF8Y5SyFT
	SvOvM9ghWB7NWz9bY8dmpsQpLkmxWGC24C7r0ng33ZAsTD3FBcUGPaS5RsVMp0fKb2Dz9W
	5Js2aUN91w47OmJxJUveGNO/ok4Q5uQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CFB043587;
	Sun, 28 Sep 2025 08:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846E1C4CEF0;
	Sun, 28 Sep 2025 08:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759047317;
	bh=de9qzleZA+R2N/Kmiw9QQMnYG50hXtyYa8gfYsMACWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KMtmLekYVZUE7aRFSU9mkhSkk4d2ntkHA9S03kyf74bsqgqfKRQVhafqnCSWyOedv
	 j3ALK52bH8Ib0Qcjq73RywxOiTyDmFQWvZrSLzgQu7h6BfCe96um8PU6yXa3j1+99V
	 FGKhJMG48c569FGlH//UPB1ED5dl4Ifq6JGVIKZvrAca3dREYBHHST1Q5so4+z4eaY
	 ccYycjRt92s6L0ewEIaOyQRQPsYgpAgUNUX7hHBLNc2rys8+IT/z1BVurmh2ZP0TbU
	 V0pJks/SLiWWs/cl5dVESCI2dRN+y9HXnOHfSrklek/YOtBiMhW81kGRirOKn9C5ba
	 xbPCNcierbgCQ==
Date: Sun, 28 Sep 2025 11:15:12 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250928081512.GD12165@unreal>
References: <20250922150032.3e3da410.alex.williamson@redhat.com>
 <20250923150414.GA2608121@nvidia.com>
 <20250923113041.38bee711.alex.williamson@redhat.com>
 <20250923174333.GE2608121@nvidia.com>
 <20250923120932.47df57b2.alex.williamson@redhat.com>
 <20250925070314.GA12165@unreal>
 <20250925115308.GT2617119@nvidia.com>
 <20250925163131.22a2c09b.alex.williamson@redhat.com>
 <20250925230236.GB2617119@nvidia.com>
 <20250926081350.16bb66c8.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926081350.16bb66c8.alex.williamson@redhat.com>
X-Rspamd-Queue-Id: CD7A7C0002
X-Rspamd-Server: rspam05
X-Stat-Signature: 53zbnkmkeapqgab5fcxjsib1ptnwmeu5
X-Rspam-User: 
X-HE-Tag: 1759047318-709779
X-HE-Meta: U2FsdGVkX18MfOIrFVJ+XQ/R+bOE+1+rLl0DWTuJFglOC6OJy41raIPG9QQrp1yZ0ilWkdN34g7eU8wrcjYkvyYvq5XlrVIaAeUS4iL3MbilSB90wRhZPHG4AGW/e50572TNKYhzRf6ZPj28Vusk2kWirtpjQ+a5EL3ryyPlmofRXAj8DeocfZ/sWfnIpWEQx7mqjqi5GIKxyPPtpI0QLxIG6qa+9okcggCoFzUX+tR05L2bhaXlmHMHwqtQ7oLOMZIb1cDNWe4c+0lIYmlEskKM0KOc3BU4lEXX1MK9OBftfJ1wJ0estJAcRvAxJcnQ9SnuH2fL7ofR8VV3mgGCjT6A7pjtgqB0m6rAaaY886vP9l0lJAq47mq8epkBO0ok7LKJRl7M4dioX82x6w6hwG9/03UBT6gYuVxHHnuGZ4z63g0rY6f+WJ4pvRz7lwrrVYj/Xa3e2JEuQLexmaAn1YYFkK89dAunBtF4XgPC3TC1jrJGFYw0/j02mIEIkkLu/hA2x52dJFpzN3LVA6C24ziShoDSneR7SJdt3RIpgLa2cbYaW/bwYR8xrH8SIPn3UEDnE8csQnrAOVc5/f/uv22NdzlHM/GpRQUjJU+j0EPWPHRhoBjFF5GhA8KTQmfYVgkGl666QkNVUD7IE54y6zdTfgRpZmo12oZmKui/GzWITsPgaaKAx4DfITF4Ru5Im86lbvvmVJrHF/jh3vdy4sNqzE8Y2aiKVLyxfVPZMCM6uErrGMhmL6Ab7r75lVpMd/o7k9A5FuXCumi1cY8QDXZA/XsZ/r6HMvcJ8j4FFtTcZxeWNDeSK9jzno5NXYIWZWFZfkMoPH+D191NQ7x5lB2xKPjas9hbOZ6nQqOR4i3yd3a+qmGGGgyt7GwLynjwAmaJAE1EP74/+UTpjn4kSwc1SxLRlkuW7MP59izZLlzWP3PbexL6Cbej+j9Bb+98a1bU/V2BAGoGINEnuZB
 lsKJ3bnA
 ofKgSp2SwtQLqD3FYoV44Pioqy12gTf7Sfu3kKFdE8sN78qiy8IL24HP/qJ/ypoiYSk3tMtcJbNzNOVu/qclpu2XjmzuhQiox6EFaVT0bBKNYRAvzwTPv6oEGkMtHLdewBiNbwJzgbiTUjX6HSoN2CUFRcN/+5wL7SvShV/WjBQG6npv6pPlCSzOcse6KL5XPm5uqYi6IZ5A/Dz3yvDk+Rt5ExZkmRU8wdasR8KbRGVzdfUZmFjIihShQ5nyfQoDxp8ORs04J0jcwRnQMEkxjoiezDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 08:13:50AM -0600, Alex Williamson wrote:
> On Thu, 25 Sep 2025 20:02:36 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Sep 25, 2025 at 04:31:31PM -0600, Alex Williamson wrote:
> > > On Thu, 25 Sep 2025 08:53:08 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > On Thu, Sep 25, 2025 at 10:03:14AM +0300, Leon Romanovsky wrote:
> > > >   
> > > > > > It would at least make sense to me then to store the provider on the
> > > > > > vfio_pci_dma_buf object at the time of the get feature call rather than
> > > > > > vfio_pci_core_init_dev() though.  That would eliminate patch 08/ and
> > > > > > the inline #ifdefs.    
> > > > > 
> > > > > I'll change it now. If "enable" function goes to be "get" function, we
> > > > > won't need to store anything in vfio_pci_dma_buf too. At the end, we
> > > > > have exactly two lines "provider = priv->vdev->provider[priv->bar];",
> > > > > which can easily be changed to be "provider = pcim_p2pdma_provider(priv->vdev->pdev, priv->bar)"    
> > > > 
> > > > Not without some kind of locking change. I'd keep the
> > > > priv->vdev->provider[priv->bar] because setup during probe doesn't
> > > > need special locking.  
> > > 
> > > Why do we need to store the provider on the vfio_pci_core_device at
> > > probe though, we can get it later via pcim_p2pdma_provider().   
> > 
> > Because you'd need some new locking to prevent races.
> 
> The race is avoided if we simply call pcim_p2pdma_provider() during
> probe.  We don't need to save the returned provider.  That's where it
> seems like pulling the setup out to a separate function would eliminate
> this annoying BAR# arg.
>  
> > Besides, the model here should be to call the function once during
> > probe and get back the allocated provider. The fact internally it is
> > kind of nutzo still shouldn't leak out as a property of the ABI.
> > 
> > I would like to remove this weird behavior where it caches things
> > inside the struct device. That's not normal for an API to do that, it
> > is only done for the genalloc path that this doesn't use.
> 
> My goal in caching the provider on the vfio p2pdma object was to avoid
> caching it on the vfio_pci_core_device, but now we're storing it on the
> struct device, the vfio_pci_core_device, AND the vfio p2pdma object.
> Given the current state that it's stored on the struct device, I think
> we only need a setup call during probe (that could be stubbed out
> rather than #ifdef'd), then cache the provider on the vfio p2pdma
> object when a dmabuf is configured.  Thanks,

I can do it.

Thanks

> 
> Alex
> 

