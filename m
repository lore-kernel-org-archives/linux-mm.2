Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 997E7CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 16:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD32B8E0014; Tue, 30 Sep 2025 12:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB418E0002; Tue, 30 Sep 2025 12:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0BC8E0014; Tue, 30 Sep 2025 12:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B92F08E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 12:08:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 862B911AD0F
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:08:09 +0000 (UTC)
X-FDA: 83946398298.23.AF75953
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4309712000F
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:08:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RqtXzCFa;
	spf=pass (imf29.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759248487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSk9NtZOWjVSHAXaMNsatYeAsaJr+OLKF/ipGZAl/7o=;
	b=2LAN9Xf+2JV+xoi4RG81Ld049Uc+ICQOLUCc5k5Edrc1WbL+GB088nxj4yQ9Xx6vhhn9px
	taxjTYmNK/fd5/wyiotgMIk0JAsPVVLWG6gfREwW9ol6Lo3mpactu7sHM9qvGsD2Z3l1T4
	L1g37JxnuYW5gRKbT4u6Y5eAN/id0aY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RqtXzCFa;
	spf=pass (imf29.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759248487; a=rsa-sha256;
	cv=none;
	b=xyPGc6nzprjXb6bYmv8a9d/mMLlDmFJ1iPygX9KjDowMylfQsrAltqnNIzpKr3ujp2sPbJ
	8BZ4C4C3qWpVbISpR8xj/+9sZvUF1H3VmzYR+15Ooz3z2VAfc10HeVmi2EBjDKfqonLzpS
	Vtsb8sfOJaGOuWbMIABMVQz75tLZy6U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759248486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wSk9NtZOWjVSHAXaMNsatYeAsaJr+OLKF/ipGZAl/7o=;
	b=RqtXzCFa3UfxGXDZd86MIu+MmfbbOVkYqm64Fu+tdl2Elr1FNlYyyMlB3vgetmPAaSgbjL
	uQiC4qsU2cz9+O9mLOarcjYVHW/hBkIEbnxWq5qrYCKfqFCjopyHUP+8v9FSjbDJrzO2e4
	ZDBgUEviJo2i2vEbqBFDk6FgH+Edemo=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-GxQ5ebFHM0eJX3jhlYmaiQ-1; Tue, 30 Sep 2025 12:08:04 -0400
X-MC-Unique: GxQ5ebFHM0eJX3jhlYmaiQ-1
X-Mimecast-MFC-AGG-ID: GxQ5ebFHM0eJX3jhlYmaiQ_1759248484
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7a227390799so2104710a34.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759248484; x=1759853284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wSk9NtZOWjVSHAXaMNsatYeAsaJr+OLKF/ipGZAl/7o=;
        b=TBTDrXpbjaTKa9VtrTYNZbpXajocdIW1uaM8j40Yrfry0uTK53k+lXfLfgrg+Og9DS
         4ayLDh/az0KGNXEOOy2d5l4gJ31jlmJJraS3BRmjfY4gHZ4/68x9aeCiim1Ik112jLLM
         jBJw3KfT3omcJmuQNFLOXomhUxr+vbEizLjt53aAbDhwrhrXx3VsmwfPfVU4HymG/rYM
         VgWFYgNkg1u7MpDxo181h7Jlb4PHsFbY3r9u0GSnXa6Zz8WpsXKiKb69/NZsKGNkw6Og
         L7FRmBht22iqFmoYv4qoEexMJXui48oa1flaGucJMKQf6dYuLPvIOC5JHp4/T3L+ql3L
         ZzWA==
X-Forwarded-Encrypted: i=1; AJvYcCUnAqVKW65BBQCm8Gk2PSxSTYoo6OwtFkiZvi/+CEoB2xZRTsDyj3LXLnH2BmQSVdXave0u2bvfJQ==@kvack.org
X-Gm-Message-State: AOJu0YwHaBLsmiM3gRwJZdwd4dSkbWGYeWS8gZ8zje++ZDEKqAhgAYAc
	VgR576ONOb+oQ4L/BGfO50iwpzfIeOuCuT3R7UCl9L9Rdh809b9mFNwKAoKMMW1n9p6XF4M8rMc
	S43Yw1k2OF8pp2ta3aKe/J05ZqgZ3C6NN9FpxPSUxMDEcjpDoAv14
X-Gm-Gg: ASbGncvtpd/ls5pJZm6JmX+ISt5+OIb5Z3J+3o6h14waXSq8dLAYS2I8aJwrTbcY6VT
	f0aVApi+3SgkFQ3HEv11/zIO9dGHruddLXNa2WPDOp2MTw2ayIZjtaHw+P787qakJn3cAmU/JY/
	C4r60jnD0AApPzKNqQ8qfILVUiVF6ve8KISJvHTLCNbCSCsTFMhsNmftpijIkxqOkO3qkLRdO0M
	gKj/2YAR/YTm7aq+ZNc+lc+WCOazNnfPdr8IWXPZ4iP1axd+95FJey7qVNRQJkHE2f9VbXwMSpf
	eut3V6sLs8C4HmB1vbk2r71d5NClkFpU0+BSRqxmxrkY1mQL
X-Received: by 2002:a05:6820:5082:b0:621:2845:6daa with SMTP id 006d021491bc7-64bb6545f8bmr113868eaf.0.1759248483629;
        Tue, 30 Sep 2025 09:08:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJseUyrGoKfdwzuhrG64O9kfcQryt5nehwMqyr+Cc6sT4mD/DyY2Du1MoSsHbbw6RCv1mcDg==
X-Received: by 2002:a05:6820:5082:b0:621:2845:6daa with SMTP id 006d021491bc7-64bb6545f8bmr113843eaf.0.1759248483252;
        Tue, 30 Sep 2025 09:08:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7b4c0e92da9sm1836631a34.26.2025.09.30.09.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 09:08:02 -0700 (PDT)
Date: Tue, 30 Sep 2025 10:07:58 -0600
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
Subject: Re: [PATCH v4 07/10] vfio/pci: Add dma-buf export config for MMIO
 regions
Message-ID: <20250930100758.1605d5a5.alex.williamson@redhat.com>
In-Reply-To: <20250930075748.GF324804@unreal>
References: <cover.1759070796.git.leon@kernel.org>
	<b1b44823f93fd9e7fa73dc165141d716cb74fa90.1759070796.git.leon@kernel.org>
	<20250929151740.21f001e3.alex.williamson@redhat.com>
	<20250930075748.GF324804@unreal>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VCG4Zuv-5HJjiTgKfbTsIKXtLCwdPggZmgsQnyr1OSE_1759248484
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4309712000F
X-Rspamd-Server: rspam05
X-Stat-Signature: rss6j6hxazthpa78pneinhyo16ue9ct7
X-Rspam-User: 
X-HE-Tag: 1759248487-124990
X-HE-Meta: U2FsdGVkX1+wPcN3Mai3SjTZ/LwCe2J9FhYA9JFXzpXIsIqOZm/U+y6b9Jccpo2EeZZO7tVQJaeEseWRpV3omHY4hMNrWHjNN0k4Ft+nGXxSbbc28tdTc2vCBebGpT+lL9J9CJYwfej5hEemxuIa6D43NXcTP3DuUxUzzXcj32+W3pk15J4BeixcDIA1VccMK1WcpmlSgMv/G9IouNV4bn029Zja/qfmy9GL+GP19uk04xngZI2v3Gv1OzWBW2wvZ2uscqtKNmQUHxN3pza6qQkZVnLCEuNIMWb6LStXs1PsU0vOa2KrgtaDzb5kx3jLubBotYAeSSaosZmXXXGeGkemduEYKuntneLwtys4A7nRH1mfzVeTychG+R5xGar+M3iiiFQYgS0Bvr11EBWgUTEAXwyhEW+81fLC7cI7BjN16htRKfoUW7eNZKTFwa7hunNUgQNnaP9/xHbX2hPwRAsBFmbAHt9wtCsdphlWQvkK+2EB1XAM3vRbdfp3mTcnlI/Z7hzwxhzP9joLW8Vxca4dnXNVdbwgxewgeb+w+0pSNP1AalrT96AJHrur2NUyr0s+WpXeoYGqBuuTrJs7zBvpb+Op/ibLRDIbmWdG99N2EulXy/e1yvYuUMoATRUfH6ZcBRfvpw0HHVtdWfcjdbF5LBOXmMxYybrLkuvRNHvpUMWkrrAdMkfjFNZJS3EUpvm8A1edmj0bF2x9QXhoIhqDOfSr4cREXOzynizW1uFddCFipoaNxFQ8TEzbbcXUi6O1cKh51y4F9HbBfjKSfNxTK0IXhWWcTC84pKqFYswTE2/duLLXe+RLA32skwgKbJC67jpXXdyVUn2aDvbcrBV1T4OzplSWKzdOGNNHWbvnJD3UP7czAfnQSufH29gUiH3Lpp9Xy/QbDpVNHmoe/0Lf1qsWAyT+8E/dZcNEZs/pS4641Y2TROJ1PgklFmstNDnCKM24Ri6ESAivMLS
 Dajbk1nm
 Sd+okuTbx/+nge8LHIAAEfEMYEL1wRhZR01TX5yWWWI8pvDCUCU9n10HgGJ7z0EAYpD3gVmAYj2eo1bNqASXeowQ1eudF3oi1O6q5Xy2gLyPXlSr1044gG5O3RsUXS9YcxFF3mBjUWISxfpwTDcAM7fGQ+iURR6uA+49iSeXp6VBZo75SGR3rJ+i2pjQzqVF7DHZWzDYO1l8A53rsyWJoLsfWoj7Xtx4PJwfQc7QsioSkw4xVp1NaNN/wMHvNmcSZjDi1jZrapIewh8dCrzsAyrNskO+Ht73JShy/PGKtG360L2yKtvNE2FODdJn7zB5muA3FBU70wEKErtJq18L225HUIyE6saTiLdKt242S379kIwQ765s8bZDvFqqFAQIn4M49D1I1deurbj+m3MXkMfMgWW99re5+wBsmJAPSsZE3c+3BuLjDlWDi3bJfdEavRSO4hdAtO7jZNtvx+Lgriji4Y2cKZklI4C3XGbSQt47s/uA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Sep 2025 10:57:48 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Mon, Sep 29, 2025 at 03:17:40PM -0600, Alex Williamson wrote:
> > On Sun, 28 Sep 2025 17:50:17 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Add new kernel config which indicates support for dma-buf export
> > > of MMIO regions, which implementation is provided in next patches.
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  drivers/vfio/pci/Kconfig | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > > 
> > > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > > index 2b0172f54665..55ae888bf26a 100644
> > > --- a/drivers/vfio/pci/Kconfig
> > > +++ b/drivers/vfio/pci/Kconfig
> > > @@ -55,6 +55,26 @@ config VFIO_PCI_ZDEV_KVM
> > >  
> > >  	  To enable s390x KVM vfio-pci extensions, say Y.
> > >  
> > > +config VFIO_PCI_DMABUF
> > > +	bool "VFIO PCI extensions for DMA-BUF"
> > > +	depends on VFIO_PCI_CORE
> > > +	depends on PCI_P2PDMA && DMA_SHARED_BUFFER
> > > +	default y
> > > +	help
> > > +	  Enable support for VFIO PCI extensions that allow exporting
> > > +	  device MMIO regions as DMA-BUFs for peer devices to access via
> > > +	  peer-to-peer (P2P) DMA.
> > > +
> > > +	  This feature enables a VFIO-managed PCI device to export a portion
> > > +	  of its MMIO BAR as a DMA-BUF file descriptor, which can be passed
> > > +	  to other userspace drivers or kernel subsystems capable of
> > > +	  initiating DMA to that region.
> > > +
> > > +	  Say Y here if you want to enable VFIO DMABUF-based MMIO export
> > > +	  support for peer-to-peer DMA use cases.
> > > +
> > > +	  If unsure, say N.
> > > +
> > >  source "drivers/vfio/pci/mlx5/Kconfig"
> > >  
> > >  source "drivers/vfio/pci/hisilicon/Kconfig"  
> > 
> > This is only necessary if we think there's a need to build a kernel with
> > P2PDMA and VFIO_PCI, but not VFIO_PCI_DMABUF.  Does that need really
> > exist?  
> 
> It is used to filter build of vfio_pci_dmabuf.c - drivers/vfio/pci/Makefile:
> vfio-pci-core-$(CONFIG_VFIO_PCI_DMABUF) += vfio_pci_dmabuf.o

Maybe my question of whether it needs to exist at all is too broad.
Does it need to be a user visible Kconfig option?  Where do we see the
need to preclude this feature from vfio-pci if the dependencies are
enabled?

> > I also find it unusual to create the Kconfig before adding the
> > supporting code.  Maybe this could be popped to the end or rolled into
> > the last patch if we decided to keep it.  Thanks,  
> 
> It is leftover from previous version, I can squash it, but first we need
> to decide what to do with pcim_p2pdma_init() call, if it needs to be
> guarded or not.

As in the other thread, I think it would be cleaner in an IS_ENABLED
branch.  I'm tempted to suggest we filter out EOPNOTSUPP to allow it to
be unconditional, but I understand your point with the list_head
initialization.  Thanks,

Alex


