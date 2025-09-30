Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78BFACAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 07:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D338F8E001C; Tue, 30 Sep 2025 03:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE40D8E0002; Tue, 30 Sep 2025 03:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3628E001C; Tue, 30 Sep 2025 03:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA2418E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:31:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F90544472
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:31:01 +0000 (UTC)
X-FDA: 83945095122.26.AA0AACD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B7F2B14000E
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:30:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F87Yad04;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759217459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9yqnF4M+qCDA9000pqzfMg6QdUSOLGidqM7b5HtStE=;
	b=cNslElxJfk+6RlMRHrGB3E7zXR+GwK65byaiP9GHNPkn1AkkzgkONUT6qkkL1/GxMMGurk
	BzqzzNuGEG7DjZISNkua7Zpt01jf4xlCWQowSWNo3xb4vxllHINsfMpVpT1WcDh/paOxXH
	I7QnubUClhrDVf3OXQyPlMq3J+5Y4Vg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F87Yad04;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759217459; a=rsa-sha256;
	cv=none;
	b=LSLDZRib4FIGe5+c78wkkml1iXKUxtYDf7XXSptUkc65bT1iIbTtgwMjdURA9a4q2U2loM
	uM/JELHzPGN4GMnPb+yrMGCV3Xnom+LdZt0oVELDexA1Sw8VSv37io+VKkqVfXa0LHJVyI
	LLYlzdmpSQx1xBgfm1if1XQasO/ry3A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D398A603F3;
	Tue, 30 Sep 2025 07:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71C8C113D0;
	Tue, 30 Sep 2025 07:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759217458;
	bh=JQzf0lGVVh7uBp1GGrgRG3aOLt81vd3Z1vJ+MdzJaUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F87Yad04oYGKqR0yrv700Kdv7cMA7yYANQZWxSzZfBGzhhGL/AY0n38vF/CbS1+uS
	 xoHf7BEDW8mOIaQN7Wk/lwIKl4Yr4ZCcSIRmUMKAIta02I34naQImlmh2K8ES0+J0J
	 37JGfcZ5Fcjrg+XvYNzoB1zs1jcuvaeDiG8rOpUd6KE1U67TY/2JY6hYEFcEF+3s0j
	 KRocY0sJEKrIBIPmUsJmcRcbzwrkU9tKLg/YjlOL+FaI0JgPnlof0Me1fLbHLHzT1r
	 DpZwl2Lrtc0E2Q7+85ZBPdg92JKatMeAQHBu3PCoTknvQScfYkwgCaBKVjyqnL/Fk+
	 VbrIksbpXUNYQ==
Date: Tue, 30 Sep 2025 10:30:53 +0300
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
Subject: Re: [PATCH v4 08/10] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <20250930073053.GE324804@unreal>
References: <cover.1759070796.git.leon@kernel.org>
 <ac8c6ccd792e79f9424217d4bca23edd249916ca.1759070796.git.leon@kernel.org>
 <20250929151745.439be1ec.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929151745.439be1ec.alex.williamson@redhat.com>
X-Stat-Signature: ysf7akfpw79uu5e9yr1jcixrw59p5h9f
X-Rspam-User: 
X-Rspamd-Queue-Id: B7F2B14000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1759217459-736350
X-HE-Meta: U2FsdGVkX18wkiBQpxHY0gj1SuAQt3uQHbBVyIo0Q/qgUN6YbLj8HgslEg+WCdAj88g/2dzfD8qUrQcFEQ4Dotsp/g8qRgANORp13a/yj40vBogwsFFJ9nFolvoWE+ZBhRb9ufZRft0NAE2xHZ5DZXQxSo25Bz3EgeWQ7i+pdD3skx4LCNxYK+MbFjx/SVj+5el/EVmd6pH9eWggstC/ELy0QhLQ38LHg3Om2UXwsj9Cdq9tPKHT+4TCBsKz08HD1YRamMOs7reprUPrkCqgCI9hCXuq38IElhMeKFseuHvQZ42dus98EK3+4HiI1M7ZGlPGnhKT4FHJ5BpL7+2RSsRtLtTBnSFK7h1KhvN6Z3uzkZv0M+ez8l61/WC3g5s6mP2y7xebKJwWaVcX0XhtCMpKV+F3ATwjAJUi4QeCgc9TWOLAV5VJ7S4frQxVWOcMBNmDMli2+Ue5Kz0mG+8WT+a2CNo9/OpWznYzGurxaGRAkBF7W8kTMtjvmXYAh/QcV0wUOefSHCFCp/MFwchTw6wZwHbLys5W3Is6nEfC4SxmGIMUncQk+MoGPItYi374kdB3qtM+b/EQsvmkKODD5QVCAWHUoWVHXQMcE1mw5LiRacdIRM+o1ruiVDnguufofTG4Fb9mGhdg4pikhh6r5M0VCI7ZXGkGADt7BMNEkkHA1VPqv3b/OqzXxGeINGq+47d7vTEUJQvlW+EZrr46kloQ37W67wz9Xx1I5fy4Ke+c2ev23cGsAEJVmakdbFYmWDHuz8wZub0JSMTXUmX7sEBRZDWE2vqgzlubz/cBxjY9GDHanBPGzj1OewUQX8TPGXqW9PnIiY65E6K5L1MNGGZog/BlWfPwUk+4Byk68DNSXjYy6ARwUY0Yk4Fb32Q82+mL4wzL+G0vAW++DZEE/kC4PlgpbUtQWZpn7CJNKaIwwEEr6lJJrKlL+p0xAI8uw7sGlOvfFvCKy5bs9sL
 fD/Mr//n
 fwsbKOgc04t3CmCbxB5hVKPewlOsf7/US1/ptpVm1PVd90OkbrBLzvnTOrhVkLoKi9HwxrlefQKQDO3EV+FVJzIdgtDWsz3kWsdKmWizka+du4kMxO4E7VUSMpDANj2jZD9SCVF/83o54n9uYSiKi5nK3Ql91iAAl02Xr8uZ7+2a4XuYEOnxU/y77wnzwgMDm3XO7Hom0rdKllhsRc7obfTx7lVxgI8eRTQGevvi1aFWmiq4o+VI/NOqaoitKJ/CmESrrACnc4YXqrwyk6uKlGxJ3VjQMtoRKKJs/6NfLwkJvBp0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 03:17:45PM -0600, Alex Williamson wrote:
> On Sun, 28 Sep 2025 17:50:18 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Make sure that all VFIO PCI devices have peer-to-peer capabilities
> > enables, so we would be able to export their MMIO memory through DMABUF,
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 7dcf5439dedc..608af135308e 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -28,6 +28,9 @@
> >  #include <linux/nospec.h>
> >  #include <linux/sched/mm.h>
> >  #include <linux/iommufd.h>
> > +#ifdef CONFIG_VFIO_PCI_DMABUF
> > +#include <linux/pci-p2pdma.h>
> > +#endif
> >  #if IS_ENABLED(CONFIG_EEH)
> >  #include <asm/eeh.h>
> >  #endif
> > @@ -2085,6 +2088,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
> >  {
> >  	struct vfio_pci_core_device *vdev =
> >  		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> > +	int __maybe_unused ret;
> >  
> >  	vdev->pdev = to_pci_dev(core_vdev->dev);
> >  	vdev->irq_type = VFIO_PCI_NUM_IRQS;
> > @@ -2094,6 +2098,11 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
> >  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> >  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> >  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> > +#ifdef CONFIG_VFIO_PCI_DMABUF
> > +	ret = pcim_p2pdma_init(vdev->pdev);
> > +	if (ret)
> > +		return ret;
> > +#endif
> >  	init_rwsem(&vdev->memory_lock);
> >  	xa_init(&vdev->ctx);
> >  
> 
> What breaks if we don't test the return value and remove all the
> #ifdefs?  The feature call should fail if we don't have a provider but
> that seems more robust than failing to register the device.  Thanks,

pcim_p2pdma_init() fails if memory allocation fails, which is worth to check.
Such failure will most likely cause to non-working vfio-pci module anyway,
as failure in pcim_p2pdma_init() will trigger OOM. It is better to fail early
and help for the system to recover from OOM, instead of delaying to the
next failure while trying to load vfio-pci.

CONFIG_VFIO_PCI_DMABUF is mostly for next line "INIT_LIST_HEAD(&vdev->dmabufs);"
from the following patch. Because that pcim_p2pdma_init() and dmabufs list are
coupled, I put CONFIG_VFIO_PCI_DMABUF on both of them.

Thanks

> 
> Alex
> 
> 

