Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB76CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 16:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEEF18E0005; Tue, 30 Sep 2025 12:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F318E0002; Tue, 30 Sep 2025 12:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67188E0005; Tue, 30 Sep 2025 12:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 905D58E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 12:01:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3259611AD52
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:01:22 +0000 (UTC)
X-FDA: 83946381204.01.A4AD04A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8427614001A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:01:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Rwg0TymT;
	spf=pass (imf23.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759248079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOYVDlXcgikSCUwOdxOfSsjt8Nh4FIwdpCdV/JBPVPE=;
	b=NR2A5oQrJJ/5014yK4Agl/HZAtrOYE2AygIIHZ1IMMEF5Dn5dHIcKQce/7ERLxJUqjmGn+
	uR9R2GTcsmkgpG3csAxqy5y36A30HxZzVNlt1m7gpwIWmTut2S/9sQh4oCv64AWbz2baPk
	d5YvGcsjvZLsqklwCL+T05DOxflKXXg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759248079; a=rsa-sha256;
	cv=none;
	b=heSqfl5Gs7cW5LAyFO3eB76dFzUQN0b7/RJxWoM6Iz9e7t4+yz1kjooV6bCnZ712EFvQf/
	7jHp2mz7okGHME1gyCrMKDXNHzbOmBHjoPUCdgJJokullQQqqYqwebt+UpPavXftyoGCP7
	1noHOyTsFru1VTNqcIhK3Z2UyBs0rJQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Rwg0TymT;
	spf=pass (imf23.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759248078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HOYVDlXcgikSCUwOdxOfSsjt8Nh4FIwdpCdV/JBPVPE=;
	b=Rwg0TymTof2GChCfuZLJYnFJ5RK2ZAdw4yisax3/tLWEyG3H/OEqAgt4rU8OYzy4bplGgl
	JyxSL+dJ2qK7nNDg8vk7K0bkbVzUyv6MAdG1Lb1okeuTxXU0WfmTn/Q8AwH6Xw17gDP442
	clCJV8veraieu2+hxfzWPOrRASmkCSA=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-Yt4osyk6P_a08sCrl_2hTA-1; Tue, 30 Sep 2025 12:01:16 -0400
X-MC-Unique: Yt4osyk6P_a08sCrl_2hTA-1
X-Mimecast-MFC-AGG-ID: Yt4osyk6P_a08sCrl_2hTA_1759248075
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-42571642af9so17420215ab.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759248075; x=1759852875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HOYVDlXcgikSCUwOdxOfSsjt8Nh4FIwdpCdV/JBPVPE=;
        b=hTU3PCUFimGyYHacyVfIplM63HZ1MEvHcCF7dO46dDJhdkb0mUNDMUt/V97R+ZGmPZ
         SjEkK+sCkUWwCKA6iQPu/ynFurJM/LKNpXrjKU2L5tgG/SfO8Ahg+/rq/BVohO0J6mNX
         QLk8SyvTV8e/zIrb2SjW764NZlzgNRy33w1dzwomwGP4MKe3e25guB4Up00eX707m4ig
         BytElAP0feLrKQwn5NbAZUe72e9oeNevTUTjHo+gUg3MzX/x/EENAudl1JXklttEm9P9
         UiRF3ZE9OOGe7GCz8yNet2YSQinN0ewN5I3Wi4iNc3TmMkflhaGALqQ/WDBAMrg1Qfel
         rihw==
X-Forwarded-Encrypted: i=1; AJvYcCWZlRWiqcPkc5eOTt/jfgInq/FmxgXaVu1urGgFS5r/1nvtDPAWdkd5VcC6IFjrO47iQAneWLPf3A==@kvack.org
X-Gm-Message-State: AOJu0YwW845aLCJeby6m1+w/asZsuzhBzI9YZAqy8VpRlP0xFRdWF4g9
	UPvQdO5A2XWQKw32fmEkVQDJPzP9GHk/XZpswzHvbE6MTQ14sVH7MflruTmNskHpZXKN89RG3al
	Fr9cfbX0OgAfWbKHmujJmgCZ/AOhRMzTSHNMNKmWNctBIexGqxN4H
X-Gm-Gg: ASbGncvAPqPBGyOTRC6/n3I4gTeCCufUIG/tcOLFz4pdAkflZiWBbbjMS7ye/9RjRCu
	YLspf0877dYO5GCjM+/rHixcHiDhUdOnZ0cwfAGrNDc39PQ0lY5HzriCT9ocs7Z0hOiSr2OetW1
	GFL9e9dCm98kDGbxBq1LEHolv3895i0j52NFkvuYFRcP4+19UouTmzgwSbWwLVRyZ5TCgZ9xl7Q
	gv6dvNAoIL22ly3MLXzN/hEqzHlPD2FE9vRjMmBIhvaMSREdJQ6CNYxiDDhrAJjeT1ulMDdUVw4
	k/BC0ccfK5wKm4QdimaPXI7Bp9vRFzUw4kenZb4s0OAGqZn5
X-Received: by 2002:a05:6e02:164b:b0:42b:1763:5796 with SMTP id e9e14a558f8ab-42d81635257mr2672755ab.7.1759248075073;
        Tue, 30 Sep 2025 09:01:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFa3YWCojRcq8FvhA8oy0OghueS9jHVQ9BVoBDjYigh74bKjlyhu7iHP48jxbQj2TC5kTDAzg==
X-Received: by 2002:a05:6e02:164b:b0:42b:1763:5796 with SMTP id e9e14a558f8ab-42d81635257mr2672385ab.7.1759248074259;
        Tue, 30 Sep 2025 09:01:14 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-425bfba6242sm68758215ab.27.2025.09.30.09.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 09:01:13 -0700 (PDT)
Date: Tue, 30 Sep 2025 10:01:10 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>, Marek Szyprowski
 <m.szyprowski@samsung.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Robin Murphy <robin.murphy@arm.com>, Sumit Semwal
 <sumit.semwal@linaro.org>, Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 08/10] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <20250930100110.6ec5b8a1.alex.williamson@redhat.com>
In-Reply-To: <20250930073053.GE324804@unreal>
References: <cover.1759070796.git.leon@kernel.org>
	<ac8c6ccd792e79f9424217d4bca23edd249916ca.1759070796.git.leon@kernel.org>
	<20250929151745.439be1ec.alex.williamson@redhat.com>
	<20250930073053.GE324804@unreal>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ch3Bc_jtIEY3KSG2yK0kRbptD-szdAZt15wiWUJN7h4_1759248075
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8427614001A
X-Stat-Signature: w7a77hr3e6889iwm3qg8cy8p8z5b73ks
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759248079-519760
X-HE-Meta: U2FsdGVkX1/+TFPc2dsIPkcK1GSK4Bv2o4UdoBWL5kWi/OgOB3P+qg1c4oQDagcEYITNHWxQdu+TpIRILlKaZ8ux5eqqn9zJysTmmzxXwYpnHpU/vNAgu9YSPKYb5wENOBfyv642j4TTHCATKzY6j+ujE8bkaZJGdbS8kNFLJRflRKkGuVC6UHvg0E+567+CuU+BbQOYd7pX9Zu2aZladxbbjBoMjhVs84X1BFNfwowW9vAM3ByLl6Eo426ktCPgb79f7kEvaQnjHNK3+mDPpRHI8jI7DyTi1Ixrhafj17jmMrUDGOy9+Wqg7L0Q2BtK/bzdgecgGkpPPXAeDVdPB3Fs1JI/K6djA2mvZNDpTRfMweN90nZQ3p5wFi6dJ+E5nPaFskuyXVph/hLaX/hk9ZGwMg5KnYp+vBGUmHhZBIA2WquVn2e6dsn3RBMqXumbdCJ5prFyXqJy7rDkfYTsO6cuHf3sYeJihm3UQwmfElkngD3+006X820HQ+qFkN5stYJey6/p7yekpBLoRXg4x5FdPHlYX0HWXqLFpdiWu1hlxwSXAFklfZ2rtCgUJ1V6biPFT/i7S8/wofDgI5oAsoHfraFrFcDkOFWBMZvJqPScGFNgHNDHzO+scKhHGud/uI1wj0PKOQNJ+8XXbtQdlaF/gIWxnCRzN4NZ8v78ceVu3w5e45L6hUD3dXEi9rF66I/yL3npvsEWB6KMchXlR/QbFW6OKud+WBOwqDn2DIr+I/USS1KXAI1maV+yYlteeVXqk5ivNNcsIYwW8mMUMMufMXSAm7hY3VEAtbD3IjpDPkxBN1Jc/M0PHslDazov964ge8UOMs0z5C5+Wp+ZZ/W+7V9lop2foY711Bolmy/vmf05Xb6ZQTNoG5m5Rt3KDHY8at/yc3QUL+9qummZxZ29qbwmCB7U4dnZG1dTWJWTEm04Ren5FpRhGgkKNxFFz4Zh3KKlzDytJjbeazs
 Z6b77Ezt
 7dP2sIQ1S+/fGFPY9o8L33tRmWjyZ+80HdrJZmxZpceaXDwnAAAJncADfz316VRLsv1pvmTJwPAdT21MX+Iof024/vHLWzl7dw5YPP5ay0LwWtOzkdlz0JDQFSeruj4rR5iR70hd7LiAPI3udoB16GZZpTBDg8YdlbGuz7PxuhgCiOD+C2VExPjJw3Y3vvfafN2kv4jsTugRDB+7jCiyzCKuULhrWZdZd/NF3wrdTpD6dY+mraBTL609APgFHLvi7iG80F72qyUFXEseRBu1pCs4I570eA+U2z/YB52Im8twYojT3Pf5PGYi5nYwjX3tRcAICTXUQbRRvt601giT+fVi3NBhEYXfs629EPrQJeRElNmTBIp9K+wkl0mE/luYBFhAXwK6a6pVV2ig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Sep 2025 10:30:53 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Mon, Sep 29, 2025 at 03:17:45PM -0600, Alex Williamson wrote:
> > On Sun, 28 Sep 2025 17:50:18 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Make sure that all VFIO PCI devices have peer-to-peer capabilities
> > > enables, so we would be able to export their MMIO memory through DMABUF,
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_core.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > > 
> > > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > > index 7dcf5439dedc..608af135308e 100644
> > > --- a/drivers/vfio/pci/vfio_pci_core.c
> > > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > > @@ -28,6 +28,9 @@
> > >  #include <linux/nospec.h>
> > >  #include <linux/sched/mm.h>
> > >  #include <linux/iommufd.h>
> > > +#ifdef CONFIG_VFIO_PCI_DMABUF
> > > +#include <linux/pci-p2pdma.h>
> > > +#endif
> > >  #if IS_ENABLED(CONFIG_EEH)
> > >  #include <asm/eeh.h>
> > >  #endif
> > > @@ -2085,6 +2088,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
> > >  {
> > >  	struct vfio_pci_core_device *vdev =
> > >  		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> > > +	int __maybe_unused ret;
> > >  
> > >  	vdev->pdev = to_pci_dev(core_vdev->dev);
> > >  	vdev->irq_type = VFIO_PCI_NUM_IRQS;
> > > @@ -2094,6 +2098,11 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
> > >  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> > >  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> > >  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> > > +#ifdef CONFIG_VFIO_PCI_DMABUF
> > > +	ret = pcim_p2pdma_init(vdev->pdev);
> > > +	if (ret)
> > > +		return ret;
> > > +#endif
> > >  	init_rwsem(&vdev->memory_lock);
> > >  	xa_init(&vdev->ctx);
> > >    
> > 
> > What breaks if we don't test the return value and remove all the
> > #ifdefs?  The feature call should fail if we don't have a provider but
> > that seems more robust than failing to register the device.  Thanks,  
> 
> pcim_p2pdma_init() fails if memory allocation fails, which is worth to check.
> Such failure will most likely cause to non-working vfio-pci module anyway,
> as failure in pcim_p2pdma_init() will trigger OOM. It is better to fail early
> and help for the system to recover from OOM, instead of delaying to the
> next failure while trying to load vfio-pci.
> 
> CONFIG_VFIO_PCI_DMABUF is mostly for next line "INIT_LIST_HEAD(&vdev->dmabufs);"
> from the following patch. Because that pcim_p2pdma_init() and dmabufs list are
> coupled, I put CONFIG_VFIO_PCI_DMABUF on both of them.

Maybe it would remove my hang-up on the #ifdefs if we were to
unconditionally include the header and move everything below that into
a 'if (IS_ENABLED(CONFIG_VFIO_PCI_DMA)) {}' block.  I think that would
be statically evaluated by the compiler so we can still conditionalize
the list_head in the vfio_pci_core_device struct via #ifdef, though I'm
not super concerned about that since I'm expecting this will eventually
be necessary for p2p DMA with IOMMUFD.

That's also my basis for questioning why we think this needs a user
visible kconfig option.  I don't see a lot of value in enabling
P2PDMA, DMABUF, and VFIO_PCI, but not VFIO_PCI_DMABUF.  Thanks,

Alex


