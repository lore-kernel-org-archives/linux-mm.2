Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB07CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 18:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC968E0005; Tue, 23 Sep 2025 14:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB38E8E0001; Tue, 23 Sep 2025 14:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC9908E0005; Tue, 23 Sep 2025 14:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8348E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:09:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C776160572
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:09:42 +0000 (UTC)
X-FDA: 83921303004.20.677850A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id E46F320013
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:09:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wu3+Idr1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758650980; a=rsa-sha256;
	cv=none;
	b=BIr721FPneSg/siUG0yJkB7gy4p9jtdULha7apA2bVT7/avow8E5u0hZcFxXrySQdaeIeQ
	OiAgsYX53QAWRgX7VFC0F14qAAKmaALdDvUPBFYYwCocCDrY1SkvsBsA6DdVKQjLn4PALG
	V1rTFMt3GAnqmzBeddAsq94P2B3tlvk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wu3+Idr1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758650980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQIcre9d/GLURHCzSftYDLgKY/Tx/WICcqQ2djA+XCg=;
	b=Lo44elDQdvOOBNzBQt0yhxWPwFw1O2ryEzqH+xy4rPdtU5myDlY/9M632DD9swQv93bsnX
	ZCh+T+j3lXFP0nNyxdGinMtyeuKqDBMt7x1T6iiR17xBMychQKdo+BRWJPOpvwytZlaT3v
	HWd1tz0sYA5eVpQ/Y6lcWF50l3tVbr8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758650979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mQIcre9d/GLURHCzSftYDLgKY/Tx/WICcqQ2djA+XCg=;
	b=Wu3+Idr1vgL45fO3YQWIOOMDHVJsR4H6CYGAhb0Kdp23K6JVmXyszsv9AfqcMhW8pKHX28
	xMDYRfyaOIJSEeR2ryJCm8+2cKdyPGQdKkNYCQkQXGKWBf4Ll89ORGtHBQDg2CHF8fS9Xt
	brAIwhdqX/rDu7Xd/xNHo+ytfx94tn4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-eFUFaD5dPKODRWqurl8lMA-1; Tue, 23 Sep 2025 14:09:35 -0400
X-MC-Unique: eFUFaD5dPKODRWqurl8lMA-1
X-Mimecast-MFC-AGG-ID: eFUFaD5dPKODRWqurl8lMA_1758650975
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8935214d60bso138027139f.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758650975; x=1759255775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mQIcre9d/GLURHCzSftYDLgKY/Tx/WICcqQ2djA+XCg=;
        b=IB9vupX+CUDDgUsuBcmxQXkO/WMC3G7+M26RlYLlYxPUMbJcx2mRHxxXjBN2RGVO1K
         637HHk28TfHLcflyHWN5jO8d6lMs6jndPEsNpcEBOnpPBgYPIlxeg7cOq2gPzSHgUQHN
         HhXAu2pq/iKqqt5Wxj7oY0BGWBfDXhDcx8k/5jsZ6dYJ/uuY2YGH2wm2PQkqaAlbDanO
         bGkeVDbOX3eGchFAwMyfPasV/jUqiqmDB74Nf3SbKLq1YrRMINwidb+YIHktJWw9KC2k
         2UIhsKAGmRwggZOsIBLVQuIz59ycVTlSfuS4QmpHgOjEKn3C7zbtx0iPHMIWovvABZ6r
         XjkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUACzum3KEQBxPs3z5SvsZnkabAAEybMef5nb649duLvl17t/aHBeEfYQlF9buj77yqgua4gRN96A==@kvack.org
X-Gm-Message-State: AOJu0YxLl1M8SR8L95zNtOHTaJyhElSJJ1DQbUAvuFZes0Y9ykWKUAw1
	hvTb0p4XeA3Va1Mqg97i8vW0eI1hIofxAZ2/zZtimWhkAZSOeRAARTF6B7f3vYFENfxDBDQUbJJ
	KwhEuIOO1HyzMTVpTgZt21GGmDBU2b33/DHp1UMvCgIZ97CPD2F3K
X-Gm-Gg: ASbGncuVkigqV96lKW3GP6TTuBX0G+Ty/cw1DUdSMdYL9ylhu08m+ORRZVufeeQxg4o
	fl7+bnS16FSM0viy0kchIUbpHYuWccd5OfVe9Jaw94rbkyPZCrED4FEl0HjnQR+6/Bd2XVxQ5Bo
	TE6KqtYPlyy1rkIDK19mw2DtC2QW8dg98mcj1tLrV4Svm/nGxkF0LMargirttvgY6uGIe6sZaPE
	186Q3MeFT4WcN1VqVd1g2mSK+4LaC2lwi8DSBrAOxK330eRMQn322dQoBIVb6axIJpH1/fgna/f
	uPvtbRGfDFF7+xis08NLmcu8ou4TkEVdEi/rn0t4yys=
X-Received: by 2002:a05:6e02:1528:b0:412:5782:c7c1 with SMTP id e9e14a558f8ab-42581ea129fmr20080595ab.5.1758650975107;
        Tue, 23 Sep 2025 11:09:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFq8NLMhZ8QXjx/u5jq96UNETG/D0tlVJnMFlvqXnog3t1PaipQH1rILjZIuw/YRGMbPtKiFQ==
X-Received: by 2002:a05:6e02:1528:b0:412:5782:c7c1 with SMTP id e9e14a558f8ab-42581ea129fmr20080265ab.5.1758650974546;
        Tue, 23 Sep 2025 11:09:34 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-54f69c6262esm5209728173.79.2025.09.23.11.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 11:09:33 -0700 (PDT)
Date: Tue, 23 Sep 2025 12:09:32 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, dri-devel@lists.freedesktop.org,
 iommu@lists.linux.dev, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
 <joro@8bytes.org>, kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>, Marek Szyprowski
 <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Sumit
 Semwal <sumit.semwal@linaro.org>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250923120932.47df57b2.alex.williamson@redhat.com>
In-Reply-To: <20250923174333.GE2608121@nvidia.com>
References: <cover.1757589589.git.leon@kernel.org>
	<1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
	<20250922150032.3e3da410.alex.williamson@redhat.com>
	<20250923150414.GA2608121@nvidia.com>
	<20250923113041.38bee711.alex.williamson@redhat.com>
	<20250923174333.GE2608121@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ouuiznzGrBv5wlFjj9xjfuqA5BIWJ3bLvcWNpNz6xyE_1758650975
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E46F320013
X-Stat-Signature: 9uq1br3pcq6ne6g7sm3jakb87q9988gk
X-Rspam-User: 
X-HE-Tag: 1758650979-594516
X-HE-Meta: U2FsdGVkX19PZg02yN7QG6qv6bvvZwY+63FO5tTLwLJbtLTv0zhmDL9nRzyqXP1iqLrsMvAB3fW5VPBWNmpXjjymP7SuKcsGZVo6u6125FvQGpbTRpEL4XRzfsH+iiHuP4GXlEVKDEhbvnd9FFBRs+it8k7GBYs+l0ju+/GUQEabK3LQ0l3dIq6GdEzTBMc4ryJZV8JgeX5G3cGVqekpI4Q6cGPv5S66nXtjnSQcLbKfSDgXrec1oirRBfr15FAAQUliG7I2TjQvmriV//tBLRYQL+mdFFPvxpC8Lb8Z/LI7n+HbBdiqINhvi4jLTfZYOLpBEOmq59cwA9otSqGIs/dNOi47w3i1olvwCW5F8N7C4lgGSsPf41EEde+mP1GuyECzJslIuS8ZHeTmpUd1NH3r773N8I9gfsoKL2MJ8WFg+ceXQaAWJK+HY85/Omd9qo+1NWIRJAebD1CBUYL8jUy5d4NxmkTqBlOmbBdzSY6q7wx0YCbJJRzdo9DipWDU5PPbFiIE23j+5DgJI+tvyTUwyc6am2oribNX3mwMMW8WyJDd5aN8sUMElqvlIyKX6nEN0EQTHnDBm8QHIUR8YOUnLQVGUeYUlQGqxS+GlHcKi6Vh/KJ1Xg0NeAExcSoEEnc1AoosU6NaT+kgTxkUxM4wn91uUhdmXumNYFPc9t/vbXR510NNroPu8AzkCAQVpRZgyZMZU7UJiyujGBG119pK8kU3FpgujgVb5+LfymzDSpe+iQnQmSVrzOBRuWg5SX3TgIfjHFpgt2fvbWKaj35GRf+RuG0cXTyoEJK6YjHi6NiTSX2v/XkeT/OeJJY8Pcrat2hLpOejOv/d4Vt047Ot9pUnVgic9OSP747kGxiLiBDHGz2/M96oOUnPfTJI7NrM5KSnlAAvdFJgmZ0QGa40LbQVBnJTz7oriTBZWAUdETpwTXUUC62rpKsiMNI+zXZr4HFyggaECaGHVo7
 E1Xrgd0t
 CCrJ2JC0nUcxgWsi0wRF8+vmN9cYTee02hpKwzmTvm6+nKJBlmGHIm38ufr9ga/VYMPHN6IPKyBR5lcgtgwQh27ZjIijN3UBQ8Gny4LSAsn5Reh6OBXGq1wTDyPNTZVzsi0ScHT11KFu8X40setzYCXsQ3tnfmuvGIWSca6KX0PK0UwHI82Y7+hZGllgxEO7/nxo+NWei2ahfO+Hab6ioADJzjlFpmXFrtGvHMRyXN6K5v+4L0wqs4LJxSZSFK/pm2Yytq4zTt6a5EFhK3LnB1G8TF2IJmk7i749+ScFj3itPg0NnD3FUsx33EHnxKXinn1N18Y6PVAV19T11CNtaYo7n83OivYLlndf4xBse0RhMCfbIvc0coAghVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sep 2025 14:43:33 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Sep 23, 2025 at 11:30:41AM -0600, Alex Williamson wrote:
> > On Tue, 23 Sep 2025 12:04:14 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Sep 22, 2025 at 03:00:32PM -0600, Alex Williamson wrote:  
> > > > But then later in patch 8/ and again in 10/ why exactly do we cache
> > > > the provider on the vfio_pci_core_device rather than ask for it on
> > > > demand from the p2pdma?    
> > > 
> > > It makes the most sense if the P2P is activated once during probe(),
> > > it is just a cheap memory allocation, so no reason not to.
> > > 
> > > If you try to do it on-demand then it will require more locking.  
> > 
> > I'm only wondering about splitting to an "initialize/setup" function
> > where providers for each BAR are setup, and a "get provider" interface,
> > which doesn't really seem to be a hot path anyway.  Batching could
> > still be done to setup all BAR providers at once.  
> 
> I agree it is a weird interface, but it is close to the existing weird
> interface :\

Seems like it would help if we just positioned it as a "get provider
for BAR" function that happens to initialize all the providers on the
first call, rather than an "enable" function with some strange BAR
argument and provider return.  pcim_p2pdma_provider(pdev, bar)?

It would at least make sense to me then to store the provider on the
vfio_pci_dma_buf object at the time of the get feature call rather than
vfio_pci_core_init_dev() though.  That would eliminate patch 08/ and
the inline #ifdefs.

> > However, the setup isn't really once per probe(), even in the case of a
> > new driver probing we re-use the previously setup providers.    
> 
> It uses devm to call pci_p2pdma_release() which NULL's pdev->p2pdma.

Ah, right.  So the /* PCI device was "rebound" to the driver */ comment
is further misleading, a new probe would do a new setup.  Thanks,

Alex


