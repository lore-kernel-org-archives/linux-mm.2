Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E2BCAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 14:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685278E0008; Fri, 26 Sep 2025 10:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D138E0001; Fri, 26 Sep 2025 10:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572BF8E0008; Fri, 26 Sep 2025 10:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43D908E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:14:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8A25BAED1
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:13:59 +0000 (UTC)
X-FDA: 83931595398.27.89F1582
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95618100009
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:13:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gHVwjqSn;
	spf=pass (imf14.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758896037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYsj9+8I0Zx27jHpluvCkiN1087KEQYq4tnoUW0GI60=;
	b=ruIcEzMIque9Yk+WWUJQUIWizoP5bWClHVyWXkbBrL6BsptYuefZs3rXWg8ZsN3qSZy0K6
	lV72oEUZafxljo2c4Y/IRMw5JKkyDDrPOnS/aEwkr1KZ7bB6RF9qrYHSbTxwrPOZFY01OW
	/8QZL3UX0LsSbeVk5D/g3Udo5Uo53B4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758896037; a=rsa-sha256;
	cv=none;
	b=taJtikXLWrKBorY7HMGn376cD0DndQuUcXNKSOo75eMzHZCfjStivQs8z90NpW7rOGJqD3
	Dy5nQvmMgy4LlYotxtZWj1S/xtp68BKua9C87i7kGM1CHF9kJHEw6kUOOSDalP+v4Klxvv
	wZRVC729b69l+r8A5c20dywD3EgmBnk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gHVwjqSn;
	spf=pass (imf14.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758896037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qYsj9+8I0Zx27jHpluvCkiN1087KEQYq4tnoUW0GI60=;
	b=gHVwjqSnXHb7EcJVuSmAxGBysXD143Lr4ddT0yPGVYq0bulfIVfDe4saImNhK1Ega1SpMe
	adMFy3rw6dWXEC+IWPYR5qfoLDraWP1ocaOKOJRDZn63MqqxOJlKbBcEoftPzPfdhdylqD
	o19bIJvR3L8p3tUan0kn1ll7EXnADBQ=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-an6V6gN-NAitWlcNtKoepA-1; Fri, 26 Sep 2025 10:13:55 -0400
X-MC-Unique: an6V6gN-NAitWlcNtKoepA-1
X-Mimecast-MFC-AGG-ID: an6V6gN-NAitWlcNtKoepA_1758896034
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-4264c256677so5962805ab.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758896034; x=1759500834;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qYsj9+8I0Zx27jHpluvCkiN1087KEQYq4tnoUW0GI60=;
        b=rnHjwnpTfVuScQwj00gsaU/Nn5kPO7P8iBqY94B6xikrmfOxUO4kxrjfj5ziQBHrRo
         cRM05kWsDX2an3OAhoIIn6ojW+lnVBVdBYc+5kjpeDUitPW9eS8eyfiHunOWXMZ8gC6Y
         fKA8x1Gc91s6254e2xX85bWrTsbY67Pt8UNfILOspEcDhU3lxzipMrnRMP6nV2M0P34D
         mtpQa8smu1iqw7fkhbXw5OlITHDCWCQZiFuQlF6cZczP4njiNH8lDUuVCVz6sXf/LR2w
         d1aLftmPdJRHqOMru+Ydhwdzh7dItzTrnPC+mjCAZ3BOecUUA64t2OWFNXTI+uHYf8qo
         n1fw==
X-Forwarded-Encrypted: i=1; AJvYcCU53vQOGSaRHot54FnAPBkmdyrISjldS5mx53PT/RVQJFGdY/93M3m7M+d6DoN5uqa0U5HlS6mfiQ==@kvack.org
X-Gm-Message-State: AOJu0YxIJ67kYoxbG+GymEh2eHJGHI6sGoVHEPSrbjYJs0ETSYsY6y/s
	//N+KAWRtTFNVkzuEHy2tIYu3wedR2aeLk2ZXoJI/cLiaG0nWzJTfA8VzGjtuO73jOwZL+FX0Ao
	AvL6knjYQ1U7B8QyigBjJPgkQqhduHJo+VB3TrUiFc9Sp/UWeCTrf
X-Gm-Gg: ASbGncvjy0nJmnCk76zHaG+2eCl9IFiEZWqNPumaPAOOX/tuITBjSO03t9vMO/p8zo+
	iPsOTHbkS3KS+1O5JJpbhHkBp/ti+QXP18OJzCOA7cKVXaf1S2rxKx5njGhJWGa+yDQGjkvbi2K
	XzVbomsBJZ6YFoVdUIwVeLf3+DI1ZTCWHpC62lXoIupHwJDVKF061FWERzBCxWMnoZUpPdzTdPj
	pmIy4sWhcv90R8EyO4qfq8eGJXxCEvu4wA/YxeeA4A7wNKClLg1iKP/wNypv1VIeO+XUDwbrTa9
	ka69DYaPYHk4RMZd499k1ktJTWvDKyfH1WGTmUxDY7I=
X-Received: by 2002:a05:6e02:1b08:b0:424:6c8e:6187 with SMTP id e9e14a558f8ab-425955e4dfdmr37293865ab.2.1758896034434;
        Fri, 26 Sep 2025 07:13:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHfT8sSg9RrO7oeIo38sP5Lm5q3G5XmCIbUcAskNNx/V0hMD+Gb0yPcLZiy3wfp8DzV0Dz7Q==
X-Received: by 2002:a05:6e02:1b08:b0:424:6c8e:6187 with SMTP id e9e14a558f8ab-425955e4dfdmr37293545ab.2.1758896033974;
        Fri, 26 Sep 2025 07:13:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56a6a5b1ec5sm1833727173.67.2025.09.26.07.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 07:13:52 -0700 (PDT)
Date: Fri, 26 Sep 2025 08:13:50 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Andrew Morton
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
Message-ID: <20250926081350.16bb66c8.alex.williamson@redhat.com>
In-Reply-To: <20250925230236.GB2617119@nvidia.com>
References: <cover.1757589589.git.leon@kernel.org>
	<1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
	<20250922150032.3e3da410.alex.williamson@redhat.com>
	<20250923150414.GA2608121@nvidia.com>
	<20250923113041.38bee711.alex.williamson@redhat.com>
	<20250923174333.GE2608121@nvidia.com>
	<20250923120932.47df57b2.alex.williamson@redhat.com>
	<20250925070314.GA12165@unreal>
	<20250925115308.GT2617119@nvidia.com>
	<20250925163131.22a2c09b.alex.williamson@redhat.com>
	<20250925230236.GB2617119@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zk5PvTmSAM5U5SeJF-sHtSPwTcCZAd-6iiN22mRvqrI_1758896034
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sgiz4ditgn7hw77akk6r988eprec7rp6
X-Rspam-User: 
X-Rspamd-Queue-Id: 95618100009
X-Rspamd-Server: rspam10
X-HE-Tag: 1758896037-397944
X-HE-Meta: U2FsdGVkX1+AXNLozVf8aXX40F02p/EcMp0BF0ZgzdCh5EFlAkJ8vohTIzShtLFTmV4/wJKtvGr3V618UA+xfQ5VbEQwjJldVAE++x1C0VM4m2x+lVqENx5SQKbGS+NtWixo8kIdUabVHHevx1UFzuNYywZqzDbLmHITZicLS/BoA6P/I33KyPmurLjmStiKKYXw7j8ifNeOQn+FQVotomx3WzeeXY4S0GT8XLudC9sNzU545OMj6OaHtEzJDD9BAcA5an5nitFgWSa8YFgDEnaISzWfAL8FlKc15zKa7TLio3G3pnTQRcIQwuMJSa9CrfuNedEITvNSCQ4TFuD+tF/HmbujHPeeh6b3uEXKL3x8g0vQW0gBGFun5xGSTwvjB7Lvi3L8EkOnrDC6N08hIdMGStpMAnKfYhZT0W5+2ZTqfoJjGplGN1NXDst10DZN3zjRaXDT27ZS81V2XHiGxc7dUdxEFQiHtqWdcM180+UMCK9soHfmZRsJEalx2ZbpT2Gy+eQKpeMdKqSX1/3r0thc2By0i+QNbB6d/wrIyE4SNLrq4QdtNaHrGDO/fQzelL+i2DlkvYskX+wOhnXxeskqcA1f1+l7Ne3NEZdtvELefFe98zTwmUItlWhprAqH1svTJYBor/FaDh4mQ9RqEShW8q7+XXq0lx/E0rixZ2ckAWGtqhmfCxhNiwQE7D0T8prfwzPq1ZpTnRTJBoxxJ4zorDPmw51cmy9YWHhhKn0xkuUf6QR6H3KQOqHESSA8CL4SiMhQXAtHThhZXJOJRN0jhIKR3i+305CcvKmgbemB/+aOiTFosF3Rq/H/A5Hu+pbFwavcLqL/Z3RHCZFYtt6oAsvx+sCYso1phVnhN2FyhS1+WljZAJLYuzFBoV+ZovUfquXGJtDbpyPK1RPs/JKVlp9fuNhcYnF7GEro1rexIl0EZeKHvutDVN14NU2MVxY9vv6oARQQO9Ss3uG
 lTjNVvaz
 JcSqvsd7qlCTqdflxkt5lNfK8MK+5LCPHleQc7ElHBi3k6YNEp04AGC7BzRa4bcAMwzXSSM4d/UELfQDpawFtqgGLSK8400eCO1rXv/73DuovyrpBBbJKDlP9z4xSOIPpymZDaHajKIY896qcs9Tq/514bZ3kxlcncQ9bycf3qrxE83+6gmVqHYXSZZ0cz70Q3lkNMNB/XRm9b+WArGKqsB+R7jnmiRZsPYbNV2TnWI0dc5yo9zPDgXiNk3pJUMNpPDBTjbXLQvv0W5OL/d68F1q5syO6lMWLKZ58djvaQEbBQvxDvlHXWwx7VDJgCRey7F1Prd3IY0ko/8uAsyjvvgeBYpOMiSdlkk+wPHc7eLvKpr/obTxzV8EdHCN1E4jG+3Df441bmGq5xQKyANEp0mqEIy6ylNxBOHsft49eEiGAglA2bl5AjVdmnRG16A0gz734KcPC5JwNdZB+90Nj/9RVMzlhJNaY3whfHD2wyULoRkmxOM35/qSdmqZjSrkjqSd2ySPPDEJw9HmJSa31/PChKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Sep 2025 20:02:36 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Sep 25, 2025 at 04:31:31PM -0600, Alex Williamson wrote:
> > On Thu, 25 Sep 2025 08:53:08 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Thu, Sep 25, 2025 at 10:03:14AM +0300, Leon Romanovsky wrote:
> > >   
> > > > > It would at least make sense to me then to store the provider on the
> > > > > vfio_pci_dma_buf object at the time of the get feature call rather than
> > > > > vfio_pci_core_init_dev() though.  That would eliminate patch 08/ and
> > > > > the inline #ifdefs.    
> > > > 
> > > > I'll change it now. If "enable" function goes to be "get" function, we
> > > > won't need to store anything in vfio_pci_dma_buf too. At the end, we
> > > > have exactly two lines "provider = priv->vdev->provider[priv->bar];",
> > > > which can easily be changed to be "provider = pcim_p2pdma_provider(priv->vdev->pdev, priv->bar)"    
> > > 
> > > Not without some kind of locking change. I'd keep the
> > > priv->vdev->provider[priv->bar] because setup during probe doesn't
> > > need special locking.  
> > 
> > Why do we need to store the provider on the vfio_pci_core_device at
> > probe though, we can get it later via pcim_p2pdma_provider().   
> 
> Because you'd need some new locking to prevent races.

The race is avoided if we simply call pcim_p2pdma_provider() during
probe.  We don't need to save the returned provider.  That's where it
seems like pulling the setup out to a separate function would eliminate
this annoying BAR# arg.
 
> Besides, the model here should be to call the function once during
> probe and get back the allocated provider. The fact internally it is
> kind of nutzo still shouldn't leak out as a property of the ABI.
> 
> I would like to remove this weird behavior where it caches things
> inside the struct device. That's not normal for an API to do that, it
> is only done for the genalloc path that this doesn't use.

My goal in caching the provider on the vfio p2pdma object was to avoid
caching it on the vfio_pci_core_device, but now we're storing it on the
struct device, the vfio_pci_core_device, AND the vfio p2pdma object.
Given the current state that it's stored on the struct device, I think
we only need a setup call during probe (that could be stubbed out
rather than #ifdef'd), then cache the provider on the vfio p2pdma
object when a dmabuf is configured.  Thanks,

Alex


