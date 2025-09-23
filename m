Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1EE4CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7B38E0006; Tue, 23 Sep 2025 13:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8468E0001; Tue, 23 Sep 2025 13:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97158E0006; Tue, 23 Sep 2025 13:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 919918E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:12:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F454119D01
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:12:37 +0000 (UTC)
X-FDA: 83921159154.27.52735DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A601B1C001B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:12:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=flQS1hBB;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758647555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uZJw/4tkp5rP8JSNt4ZN9Z3u/IrIS2aK/hO55v4R10=;
	b=VCbFU+v8PNX7xfhRAkT6oszlQk+Xu42K7nGrMgVO56M+bf12z3dS34nxaxixvKgkHYwRlk
	UXct0Ws1c23I+HZWKUPhY0/9AK0V+UBZ/AcJwu2r2e7AqunugDXoaHkMcZLCTHFBzVvgJv
	OVV5bFUzMxkgTjIrJncPfcthh0FNHTQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758647555; a=rsa-sha256;
	cv=none;
	b=NlBtC6tav069hzR3+fPg0d6ghyfbXKP8HCvyYq5lPT0PhV2W/uyHfFw8ehDf343EeixFmL
	ZbWynCuX82Tc4UvOOya6d+hxdy+q9pB2cfFcEYxGPsn1Hjr1tQd7repbHobL0JoMnFLmiF
	YuMLjRBRJtZukxA2dJMPJS/yp4uk3eg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=flQS1hBB;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A728460052;
	Tue, 23 Sep 2025 17:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7895C4CEF5;
	Tue, 23 Sep 2025 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758647554;
	bh=gmK1CGGOGWIE5mxCSSz01jl9806+Hkknw/PF7Rft5eg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=flQS1hBBI4YVkOhHIOLPDHNMtlCkyfUNIFD9Y3j56A129eJQ7ulgbOQABWCzap9Hj
	 rl/VZtmwxWaxs1PMRUvTjPUNwlEZn88V/RLG5Kuc+XdNGA5TeIjqOIi+B4X9/FCt4c
	 Qx+OujTVF/ZwyQKONCRLVjz52uX0o7GV547cRdBjsiAgj+ycng1QAEkqJ6m+YLzWAq
	 DCNZoSbiGk6YER29JJC0HRMAOqBwNSUqMZUTv1sjBpzIQQgtNOUDKZTBiXF4eLwe8A
	 xvmArCpm9L4VMxDuuM+3Hd13ks3PqY62OM41EKtcVNBQBVyEfRahPW/H/CtiWATpbl
	 ddW7gMC2jEh9A==
Date: Tue, 23 Sep 2025 20:12:28 +0300
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
Message-ID: <20250923171228.GL10800@unreal>
References: <cover.1757589589.git.leon@kernel.org>
 <1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
 <20250922150032.3e3da410.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922150032.3e3da410.alex.williamson@redhat.com>
X-Stat-Signature: ux5ycp5b6xxuubz4hn3r91jutesydfca
X-Rspamd-Queue-Id: A601B1C001B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758647555-913175
X-HE-Meta: U2FsdGVkX19AbVCtOAi2nOP3mhpM/ORDv1clJg0o7kLADHqWOGSKrCyx1ogn/DgprhRHae1XyQQ0zeQOaBHrRl25YPmx9RqcVd/v32r2RQNXaYaHPF/NqKvRi+OmcA4SZi3BoFEYJtLY8RZePRQVQsoaYDQL5PLJKBEVvMr/yWx47OK3jtpB9VznhhOre9vzh/8658JdwnTrXNrTxr62ErfuQvVZxGBod50XKom4E9tzq+3NjUYx8Tm6FfvbTHT/8Lxx7wXyQC/G6EU8dMcREvzPZvAZhcE43/QRDM0xZTzkiOLpbadMGGBfDRD84it/xgNERKwDxc5XGpYESes2gkDsjU9D+6eh8d+0oZxZtTFHRQjjj3kU7mH61/g59JXilvSF1zXys3hZ6g6Bc18ZNzKgXoxX6sbqbVVqYq1uy5R33L/bMRWi4cNJFYDMuQ9pWTiJihAKfithsWvLSoSOPpGn337JXIsS3U2rA9aEjFP+ciLo4shEGDcxlKRSCoYmTVqTvIYHuFdYbc9FHnIlVzfT2H2gpahCLsEVDdWEdUkkQT038j1lu9cv13/M9haqTR2h1DObYRitmpgt2fLeM0DdifIEtF0euOTdoEEM1CsXlIOeDUgwLefLEUfL5IiNcBZgZ1h8IpvLQu8qq8V7LJtblMGHvh9vZNmHfVg3thRN82GhafigNE/mihtMirgGeuh2135yl44ZsWzZ089OdKOeDXoNwn+mtB32TpySCaS4KY0BgWERC9v1Goq7bNMUkv0c58jv3S8JN+uEnZSxMuVbzPLT1d4+HGv75XPWAbWkNAswpYoqmyQGR11FBoMiee9jWCE1gNabmqXgBGprte60t4yl/otjvW7BFQM2Fl4u22o1qKofDBZlFmKLMlFUX4Q5rmZf63wbWQLYHAaJLIQs/3sSHXirrnkSQjGLTyiei/SIY16qi0d/zFwIzFSITXdnUikJ0dnZOPEWmsS
 IOIqGVmH
 ut9eVCXCb1Acofo1XrWgIGjIXjLtyIviWZkz+tlCl4npscfdy3hbEvlbh33kgH4PkJRXzPXJ3AY/BBJjcE3VfvC2kCprdZjZgGhZHcPSBicHNcfhd9jmF3rqV2wNTK6WebwcH9NGd+9Rca7jMUlAYGbVVrqD/3H4LHq5Mt0+NG2mygIa9XW1FGkuMxi723qFLJpKxaGQT1ECAfBqo4okDmM08ScWunZu5tP83mD3oeHcxfJtfM/YWSogJPsA6/NyG6ismqrs3odugtQklA79OlrheoCoNUardJijsTFgSCBTggTw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 03:00:32PM -0600, Alex Williamson wrote:
> On Thu, 11 Sep 2025 14:33:07 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Refactor the PCI P2PDMA subsystem to separate the core peer-to-peer DMA
> > functionality from the optional memory allocation layer. This creates a
> > two-tier architecture:
> > 
> > The core layer provides P2P mapping functionality for physical addresses
> > based on PCI device MMIO BARs and integrates with the DMA API for
> > mapping operations. This layer is required for all P2PDMA users.
> > 
> > The optional upper layer provides memory allocation capabilities
> > including gen_pool allocator, struct page support, and sysfs interface
> > for user space access.
> > 
> > This separation allows subsystems like VFIO to use only the core P2P
> > mapping functionality without the overhead of memory allocation features
> > they don't need. The core functionality is now available through the
> > new pci_p2pdma_enable() function that returns a p2pdma_provider
> > structure.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/pci/p2pdma.c       | 129 +++++++++++++++++++++++++++----------
> >  include/linux/pci-p2pdma.h |   5 ++
> >  2 files changed, 100 insertions(+), 34 deletions(-)

<...>

> > -static int pci_p2pdma_setup(struct pci_dev *pdev)
> > +/**
> > + * pcim_p2pdma_enable - Enable peer-to-peer DMA support for a PCI device
> > + * @pdev: The PCI device to enable P2PDMA for
> > + * @bar: BAR index to get provider
> > + *
> > + * This function initializes the peer-to-peer DMA infrastructure for a PCI
> > + * device. It allocates and sets up the necessary data structures to support
> > + * P2PDMA operations, including mapping type tracking.
> > + */
> > +struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar)
> >  {
> > -	int error = -ENOMEM;
> >  	struct pci_p2pdma *p2p;
> > +	int i, ret;
> > +
> > +	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
> > +	if (p2p)
> > +		/* PCI device was "rebound" to the driver */
> > +		return &p2p->mem[bar];
> >  
> 
> This seems like two separate functions rolled into one, an 'initialize
> providers' and a 'get provider for BAR'.  The comment above even makes
> it sound like only a driver re-probing a device would encounter this
> branch, but the use case later in vfio-pci shows it to be the common
> case to iterate BARs for a device.
> 
> But then later in patch 8/ and again in 10/ why exactly do we cache
> the provider on the vfio_pci_core_device rather than ask for it on
> demand from the p2pdma?

In addition to what Jason said about locking. The whole p2pdma.c is
written with assumption that "pdev->p2pdma" pointer is assigned only
once during PCI device lifetime. For example, see how sysfs files
are exposed and accessed in p2pdma.c.

Once you initialize p2pdma, it is much easier to initialize all BARs at
the same time.

Thanks

