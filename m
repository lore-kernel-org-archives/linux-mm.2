Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E34CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 20:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0588E000B; Tue, 23 Sep 2025 16:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBDDD8E0001; Tue, 23 Sep 2025 16:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE508E000B; Tue, 23 Sep 2025 16:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACA058E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:07:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59D5F13B56D
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 20:07:35 +0000 (UTC)
X-FDA: 83921600070.27.9161700
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1A2F420008
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 20:07:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eSkkdlWk;
	spf=pass (imf03.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758658053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TkF/1TIVCdQ8I35UWInq/5XGtjT7LO6t3DfocUuGzJk=;
	b=su11W3FA/cBMd79q520jH2SUtTMtUc/GHg0iCedzjNfIi1Urn91wLJOLQuv7v/YbSs4Gsn
	IEjMAJxNM0PY1XuhmIgZpMMXhjOib2LMWchnrZf5KZ6yGAMerm3ozzoGc4J7o55MEJ8DWd
	mthyVgAX9rhSLRRgZuCoVznATpgsyW0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eSkkdlWk;
	spf=pass (imf03.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758658053; a=rsa-sha256;
	cv=none;
	b=R98h69MJfGwlTGTGfy41UCPgFNYqo9mbEXkqNY0fk5gvl+trnFHhZblVH0NwNKdX/UsXJP
	SdYuTlnub0V5gQKG+8SW3x+cgIYbRRvVX60xTgd+PtG95npQFhyoa7W3Aq2HezGB0WkKl1
	+c21OfF1t2QMsjptIJEdvAGPcQ9TG/k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758658052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TkF/1TIVCdQ8I35UWInq/5XGtjT7LO6t3DfocUuGzJk=;
	b=eSkkdlWkyYXjDiTckd6G4oUFlq2WNOk6av46d1FF9cVhPzOJPqcVY4o5KJlhIqwJ0yC5b4
	ckyyIjy8o48qchQT9hiVfAvqLVOFDBTortU4+Df6/PnsCbFx5K8cDAnpbDGUuDqKzshx3S
	uaX/z9Pvsh3jk0NV7MQ2afT5Ae3OjEw=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-HTayLWOyPh6X0DGsdPq5-g-1; Tue, 23 Sep 2025 16:07:29 -0400
X-MC-Unique: HTayLWOyPh6X0DGsdPq5-g-1
X-Mimecast-MFC-AGG-ID: HTayLWOyPh6X0DGsdPq5-g_1758658048
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-889252db9feso108974839f.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758658048; x=1759262848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TkF/1TIVCdQ8I35UWInq/5XGtjT7LO6t3DfocUuGzJk=;
        b=tsjJnTNWvIVUk1qHHJOsBIYhOT+rrtNbvNi8K/th6bAa9sbwZQctTGkZdbjdLVWqzg
         nwxBJH1AttbwnEcjPYiKQAwRYrFGxO3SH/qcj/rlL7yB6CoRlF11l1LcGqUL7uw1CXSt
         ylaET9kQ33II9Xl2KbcxUNKrXSV+x9TG+vHFfAj9j8O822oCxETjnjIgtWt2uzDrE8uF
         p6lMI64vC220OBJ7IL5stlHERLJZmo8nSjgX9zxPefQrLQjqEf7xzhbz9oTiSiScNupY
         RK1qE3IQHwbPZMpbWoqw14Q2VXlXSGkqY0xwivGcOfLISGO4rp0JP4Mozxi6OIme1G9R
         IkTA==
X-Forwarded-Encrypted: i=1; AJvYcCVkpgvyBy0PMq/5CRrSw59jpQPw9lC2jcAaUm5kyH8TlzZlMe4MX2GAM/SKWtUMDpJBwbaEdlCA5A==@kvack.org
X-Gm-Message-State: AOJu0YyhjtD6xGUsDCmkXpPCks++P5PuBBExihapc31SoJNixicny1MI
	yyVNjNLrh7q2rzgZdbRvby+QrP9DmefyV2Z5npWwz4gJ0WJFVxkIDRt4ZayNpo68ds7OU2cMPtd
	rbSHnAcnrI088/j5j4lnMoCq74kviZ0mN9bDmTiUyPUc2Cy14zS0i
X-Gm-Gg: ASbGncsDWD7AQ1YghUnj3vN/MMWscxuKjmT38cuY+jrjIDxRjfBIClhRan+IIabCuZU
	fu4lSFnNEwS0TTw8Srqas/X/L20x1xyWXOQNMOwQV6vRmH+crsGPldR38J08thRIx/W1QeKEfVJ
	hK5Xd8gaxZP5ounFyxw4knfPfJ4NfNMAwII4LLpQPrNNuRenaCYaCDZMCbmsfhMXyr1jbumISUZ
	Palctz8ix2nDpMFpHYlWIofpbQpNoo47Q1JphL+tPI7+idu6PFB6CpyiqY7yGzWkKmiy2z2cB7z
	pmF2K3dPZUViXd/sEcl6ClplEEyjLKPuxjVOs89T3aA=
X-Received: by 2002:a05:6e02:b27:b0:423:fd07:d3fe with SMTP id e9e14a558f8ab-42581e0924amr21638665ab.2.1758658048126;
        Tue, 23 Sep 2025 13:07:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmMxIqHNMDHwq6jPuldjwSxK84807XGPUliuEF5qCvF8SuPWmF0LqQLkrDELCWNHqAt6pi1g==
X-Received: by 2002:a05:6e02:b27:b0:423:fd07:d3fe with SMTP id e9e14a558f8ab-42581e0924amr21638385ab.2.1758658047638;
        Tue, 23 Sep 2025 13:07:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-425813f3053sm15141865ab.21.2025.09.23.13.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 13:07:26 -0700 (PDT)
Date: Tue, 23 Sep 2025 14:07:23 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250923140723.14c63741.alex.williamson@redhat.com>
In-Reply-To: <20250923171228.GL10800@unreal>
References: <cover.1757589589.git.leon@kernel.org>
	<1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
	<20250922150032.3e3da410.alex.williamson@redhat.com>
	<20250923171228.GL10800@unreal>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BhAV34jPHnjLPA-vbK_yexgmfK6GgGPyissMglK2_pA_1758658048
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1A2F420008
X-Stat-Signature: fka8raaw866g3mard6c48bpyqfp3ng1i
X-HE-Tag: 1758658052-35470
X-HE-Meta: U2FsdGVkX1/cNKEP/zcRTi/vTjoIFd9+W2Xo02QZ6rT0wBwGJ6a3HkSCIcqsFXcF2Fc1LqxOC9DjAA516Xx7dPSPzlXIuDfz5XTDrUwzX0oOqeRzBDYV5t6w5XHBO9a04UrpFqPDV1O8QvU3xXOhJZBwwlLe2EhbpnAYVFR2Wz5fjVDjppPmnSXw47I018Fiss91Oex2e23n6fkke1SfTbzKsm09AbiQsAzrERahz4+SQFpFyhi2APhfFZkVV6zP1x26MmzzlTSVwi/s8WLXj19vzwU94JBN8a0EZcWWq2AkUNSPu22SVB2as9SCP60USXMeTLt63mscy+uXujvLPRqt+x7Td5RGQLkASyQQzBMfSwX/H2ZgvOLXWuSNoBRNLWgAEcnq8R3QvZiC8vkXwP2ebqBPjjzuhqxAamBkl80k729QQYGGSIypLQKJ+MgCYK12sCN+8T1GmDH+Sz1+2tHLUtsMqbyccdii6z8RTbCHwAhNAR8s5hguIQ+mK/QG7qeSdnV4Ofori214MZghvaWV0wiGockeSsca+ob9+H7rKyw1wPD9mtVCXYvP8jJ9q7Hq0Ga0H1Ek+1/g6VI4fBseco52AcIaMY6DCvSF+II+b7thHTFS5Wz6rQRAicjG02DBaWu1XhlmtKLEBGR/8/N9nPgJT8KodOlhc2SGONRMVQuqFk0XU5NB5rRVZED8uSjl4MJZBFI++poom7FkKlv2kMmSiazbZrRlUuWfOGM7t/iVtCL7jRhK0OsnC/vq/6DB0GVBAxX/YiBrpV/ojunTbOq7JPDqqXuYOFhsZibaHgh2qiriW7kLBICexGcxhJAACcruzOGfbxgCj4wkv92MfAbk/u3WJMjDwaFTwKfiMCyrOo7onyrCe9IHMxMeiWLruC0zTDUHIU9OjOQF6PRYD7xYKXQmga0qwbi8mkQltzseHLPRxF6iDWJ9TIb7LKlWE8h2F8slsWbPhbP
 6oDranOL
 thE9UH7mK+4BtM1kocj5oAKEE4nKlwHY0+plUdJazRmA9kLTrn7+6wMoz/r2AiQw1lm+eZXIgja8pv2bEWmiaQIQcbMa8Z9uGsbjAMjvLyrFGqKdhPGIYdtTz4dGVAbS0yuYC7uiJVN/4SbmtxrTt5sdEWr2OVsbmPGCQ7pUTz2bGSfMd2kSOHMLVPHMuKQR6xmN6hoheTgllK+vPsseHHIS8mtc5rTpzgBfZyLJ6UWqbkrZCvvl2rL4+4ZK71dMXMbuAq0bHZQrCCvwgLiYqKzEO9BHSMeynbG2PyArJ0/RqdMS+Ay/dSvaaYwb7pEL6vYvkAjm1SanIQgHuJSWb+BfUmTDLgmTbA9oHaOEeL1ysWtRC5PBJP5dPsYCMueO0PMxribo4UDQUqR8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sep 2025 20:12:28 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Mon, Sep 22, 2025 at 03:00:32PM -0600, Alex Williamson wrote:
> > On Thu, 11 Sep 2025 14:33:07 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Refactor the PCI P2PDMA subsystem to separate the core peer-to-peer DMA
> > > functionality from the optional memory allocation layer. This creates a
> > > two-tier architecture:
> > > 
> > > The core layer provides P2P mapping functionality for physical addresses
> > > based on PCI device MMIO BARs and integrates with the DMA API for
> > > mapping operations. This layer is required for all P2PDMA users.
> > > 
> > > The optional upper layer provides memory allocation capabilities
> > > including gen_pool allocator, struct page support, and sysfs interface
> > > for user space access.
> > > 
> > > This separation allows subsystems like VFIO to use only the core P2P
> > > mapping functionality without the overhead of memory allocation features
> > > they don't need. The core functionality is now available through the
> > > new pci_p2pdma_enable() function that returns a p2pdma_provider
> > > structure.
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  drivers/pci/p2pdma.c       | 129 +++++++++++++++++++++++++++----------
> > >  include/linux/pci-p2pdma.h |   5 ++
> > >  2 files changed, 100 insertions(+), 34 deletions(-)  
> 
> <...>
> 
> > > -static int pci_p2pdma_setup(struct pci_dev *pdev)
> > > +/**
> > > + * pcim_p2pdma_enable - Enable peer-to-peer DMA support for a PCI device
> > > + * @pdev: The PCI device to enable P2PDMA for
> > > + * @bar: BAR index to get provider
> > > + *
> > > + * This function initializes the peer-to-peer DMA infrastructure for a PCI
> > > + * device. It allocates and sets up the necessary data structures to support
> > > + * P2PDMA operations, including mapping type tracking.
> > > + */
> > > +struct p2pdma_provider *pcim_p2pdma_enable(struct pci_dev *pdev, int bar)
> > >  {
> > > -	int error = -ENOMEM;
> > >  	struct pci_p2pdma *p2p;
> > > +	int i, ret;
> > > +
> > > +	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
> > > +	if (p2p)
> > > +		/* PCI device was "rebound" to the driver */
> > > +		return &p2p->mem[bar];
> > >    
> > 
> > This seems like two separate functions rolled into one, an 'initialize
> > providers' and a 'get provider for BAR'.  The comment above even makes
> > it sound like only a driver re-probing a device would encounter this
> > branch, but the use case later in vfio-pci shows it to be the common
> > case to iterate BARs for a device.
> > 
> > But then later in patch 8/ and again in 10/ why exactly do we cache
> > the provider on the vfio_pci_core_device rather than ask for it on
> > demand from the p2pdma?  
> 
> In addition to what Jason said about locking. The whole p2pdma.c is
> written with assumption that "pdev->p2pdma" pointer is assigned only
> once during PCI device lifetime. For example, see how sysfs files
> are exposed and accessed in p2pdma.c.

Except as Jason identifies in the other thread, the p2pdma is a devm
object, so it's assigned once during the lifetime of the driver, not
the device.  It seems that to get the sysfs attributes exposed, a
driver would need to call pci_p2pdma_add_resource() to setup a pool,
but that pool setup is only done if pci_p2pdma_add_resource() itself
calls pcim_p2pdma_enable():

        p2pdma = rcu_dereference_protected(pdev->p2pdma, 1);
        if (!p2pdma) {
                mem = pcim_p2pdma_enable(pdev, bar);
                if (IS_ERR(mem))
                        return PTR_ERR(mem);

                error = pci_p2pdma_setup_pool(pdev);
		...
        } else
                mem = &p2pdma->mem[bar];

Therefore as proposed here a device bound to vfio-pci would never have
these sysfs attributes.

> Once you initialize p2pdma, it is much easier to initialize all BARs at
> the same time.

I didn't phrase my question above well.  We can setup all the providers
on the p2pdma at once, that's fine.  My comment is related to the
awkward API we're creating and what seems to be gratuitously caching
the providers on the vfio_pci_core_device when it seems much more
logical to get the provider for a specific dmabuf and cache it on the
vfio_pci_dma_buf object in the device feature ioctl.  We could also
validate the provider at that point rather than the ad-hoc, parallel
checks for MMIO BARs.  Thanks,

Alex


