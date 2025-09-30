Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 537DCCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 16:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23AC8E0019; Tue, 30 Sep 2025 12:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB128E0002; Tue, 30 Sep 2025 12:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11A78E0019; Tue, 30 Sep 2025 12:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC898E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 12:52:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 307BC1A079B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:52:56 +0000 (UTC)
X-FDA: 83946511152.15.23FB1EA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D196016000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:52:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="G02T/CxW";
	spf=pass (imf08.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759251174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JryoONnZtvrch8iWe5kQa/bp3US7CnLH1VFoC2oPQRw=;
	b=cwvhezlb6j5meHAPrpYwl7UJVoiUmvSHtbEO/9p5YjVfNIXH1aqtTAJIiEtYKxxJ7md95S
	pjWT/+hXUAS70pczLsb9dZRiVboJbvKUeRMc3fJUqLOs8eMN9+nDgW+Dl8hW9pAH/tmekG
	H8YWplkw7NypGSdpmtNx4f8QEGuCSG0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759251174; a=rsa-sha256;
	cv=none;
	b=w9W0hi/XMx1TcDy46RVISTu2xKTo2UbWlf2/oKG+lDDz7TJwB+qboTH3JbRJQAMK+JqMYk
	0tRju+U3rpaQAcl2OBCuyB8xW9WsiuT0MRT95IQPlMO5mVfcKV/7Xv2Z8nM2CMBmL9HvvF
	bi22PM6K2UTkZoPbHk2lules9uGYd2c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="G02T/CxW";
	spf=pass (imf08.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759251173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JryoONnZtvrch8iWe5kQa/bp3US7CnLH1VFoC2oPQRw=;
	b=G02T/CxWdFzdWNfhlIFwdrUzUnNBxZAHRXbim9H6o7KQF5KMS4DNUuK0/q0tS1t4VDHqf1
	GOfXb5jTCrqx4i4h3f5VwHtoD6hlai8QA77ya8Sck7zGbs4bYIpeUgCs+aMFoPl2guGAKD
	IxWFGeHTQKPEyMC6jJaM17C6FhYIod4=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-B_rajAaDNZq8qI0B6VWGJw-1; Tue, 30 Sep 2025 12:52:51 -0400
X-MC-Unique: B_rajAaDNZq8qI0B6VWGJw-1
X-Mimecast-MFC-AGG-ID: B_rajAaDNZq8qI0B6VWGJw_1759251171
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7aba0808204so1557668a34.3
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759251171; x=1759855971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JryoONnZtvrch8iWe5kQa/bp3US7CnLH1VFoC2oPQRw=;
        b=u+IRm4j12VWsxZiZ1h6B8unNnBYlaYc46jvQS+yqyGzT/9QbY8/cflQZxG1Wtntbmk
         kGe1hR7RRjO0jTwhdEWcyBhlDRI8miPM/dnM5uUF0OEGER4UhZ7Vewc4nuBZYSlzd4Sy
         q5JmtG3d69OGzcZDHDz4aCImowvOGcceoAu1lMZsXMgIqgWGGRouOjsSL+9YLTKTHlMh
         YyPTTLvP14ll0SZyXrVZ3DKrTqUS91FUAQ/Xsv/9TI6bOHVl6HntktH5kiqQUgcdmUm2
         qQ5ygAle1Jbm5O8YXVuRa6/KOzhNCP72bIDJuagzm/J2tpfxpESphns5bs+HxDQbywmT
         7DcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHyh5Bsfj5pblnfv9wsCwOW8gnbWae2kq5vBIjFAfMBZEZHa2WJjwI0zRKrGdbrJg8NzgLJ852OA==@kvack.org
X-Gm-Message-State: AOJu0Yws+lUP2rV1d47QKYvkzPQGwM1/LYZ2kHxua3s4iPHVHqhSbxDq
	PEMZfxve2jKkm7IeversRoUhR0YkTdda6XR4IIggCMavYbgdV6f+teVuGgwbLnXrKjokpR733sO
	xdOnrxDITQlalsE4WYuP4vkUoUAFEvmylKF+eh1m1yKy77Aa/vMfS
X-Gm-Gg: ASbGnctJMYVh5IImdbTwHvYqKeL+Fl7K1u0oVImxbowqwWfZzVeqKwN53ST17on/JTW
	H/DqUGC2TBNot04P/6KggYAhObzqEbGdiuJ9tk5h0Q9hqyP5F+0KJlHFi7YqB79R41XndfEYD5x
	sFTV4VtQtaaZKVv7IiAH5c9KcP0jrJbq5ej5bgNKJdQ3iTyYgvAHAzd2idA2OCyH4N0fyJF7tn6
	PgfTAJGE1ptn+vDFYHbBlR+U9pDw4qz3cg61BqmDDjOnQOTRvQvf/3NMUu3+ORyxJV2Oh0/TvEt
	+t0W1yhRWkHCVwIw6JzhY1rLZuYSu0u92ARkaHQ3UcGyo3nd
X-Received: by 2002:a05:6808:f86:b0:438:33fd:317c with SMTP id 5614622812f47-43fa41bd61fmr82484b6e.3.1759251171064;
        Tue, 30 Sep 2025 09:52:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEwZ3/lKZz7Fdu2TvHNlTbKRk5qveSl6rvSejYaxAMAP02EZ6HQb/uugFp+9XcOcN4obhcZxg==
X-Received: by 2002:a05:6808:f86:b0:438:33fd:317c with SMTP id 5614622812f47-43fa41bd61fmr82463b6e.3.1759251170626;
        Tue, 30 Sep 2025 09:52:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-43f51238c63sm2746753b6e.22.2025.09.30.09.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 09:52:49 -0700 (PDT)
Date: Tue, 30 Sep 2025 10:52:47 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Shameer Kolothum <skolothumtho@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, "dri-devel@lists.freedesktop.org"
 <dri-devel@lists.freedesktop.org>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
 <joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-pci@vger.kernel.org"
 <linux-pci@vger.kernel.org>, Logan Gunthorpe <logang@deltatee.com>, Marek
 Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250930105247.1935b553.alex.williamson@redhat.com>
In-Reply-To: <20250930143408.GI2942991@nvidia.com>
References: <cover.1759070796.git.leon@kernel.org>
	<53f3ea1947919a5e657b4f83e74ca53aa45814d4.1759070796.git.leon@kernel.org>
	<20250929151749.2007b192.alex.williamson@redhat.com>
	<20250930090048.GG324804@unreal>
	<CH3PR12MB754801DC65227CC39A3CB1F3AB1AA@CH3PR12MB7548.namprd12.prod.outlook.com>
	<20250930143408.GI2942991@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zU8Q8TMwkaQiM-s0hXnViFPdL1mjm62-2H8gncSt33A_1759251171
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D196016000C
X-Stat-Signature: b1yx5d7nfju9h5bs3w4jhds9j3qrdxby
X-Rspam-User: 
X-HE-Tag: 1759251173-586781
X-HE-Meta: U2FsdGVkX1/p0Xl7Sd25DwCHQpEcf1yflHUx3bnXnQ92ra4+IyHmZ3QY4UarONVyJ19oAIcCVJMxhWetOMwIHWjCRj0G8IhyWpX/FGqOd1Gy+fpn/SnuCIHr/YUPwdZypfPxQfMEx3zp/S33QfTNq99ZJk0cb8sLh4E3Pdu+U0h/DoTc+obEI9DZsUzf0tSz755T2JE9BO7A1rH4yIFP6DhZMNwMEssGP2hnOmdWtqrw8KwvG0iXa9ngn+Y8VXkXhROUYR77oIFuyrfczWzXXgfD+UrN8LutFoIrLQdwAB7wDDjLbzBWdpTgOxcAJBpMDhJxA6v8zVHOT2hgy/92u6oqdkx8nCNOsma2FZ+8KIHq4txMLHYnpV5MKcSUED13S1s7iECPWZweV8YEaxF4tHqMHEE0AYMKYGVLpI8p2PXy83NlbJVTgY0jAqAbbUazQ6fqrBglMVAH+dOumwh4ShMDXqrZKx6UUrf60j9ZbtWUXGkVS/ALZqfbeLU8lBd9VgfcS46nzgfN3hTo3+GSDUKCPz4arvLw8Ju/oIM3HsvgIh4030TGD7U1qGLOtziH677PqJMPepvEMZZgJx72D4I5cU3u6P2ZCaZyP4MS83tGIrAl40ClGq1MykD5unrOlndIqg2eM/rpxG63sOBypmsIPcis79ABIsaT1IH5geMPzEOtPpYfZY8r3tQx9C/nN7mXJeEgE1bJc7wPlbjaSvdTuLTBplPgK/jD1ZOVVfsp6se+H9BAyTgRCdbbyClMhQPMhNMCnJzudK+wIDyxprlHIo8HsoD/4VWWqLLqbiD7ZoIpohZ3Bt6gUCZ7AT7AK+u6mtoEfqwJaKs+nZr1gbFewdUKW90pcACxOOjpQVXCwmhGfq+Sw1H2TEoGVArdlXaLpYuRxd4of33SgENcTwnyn0dYzbkassietckT2orSAgT7J6MU66rgFtjlJRDv1/WD4XLrWC5Ic3urfL1
 t0oPoxzR
 N1cBu59zklXMePkfIUcJy7xVHnQyT+/DrU3QmTFHyScIkclxFJJBG1GoTmW6RMAOA6LYhiddvkTgIbh+GoTyau7dAHjXNXFr+SlpA3/jGdlaj3Z4ELMsVd2exniXqKL3Msemsoz7Km/+Z3KrMs2JX2/9QmvNch6FYTffdD4tDWcfH0yp/EAlTF336UPhxKvu80Kvn2EG2DONgRFKFk+jzGrdiQlpNMjyn5AOIIaI5lWocMKfq3FIXd3JwdS/yq8AkLJ/tdoIpptxGOJWeEkNgHLzkWgHhGshv1o0b5UNqNITwjOdWjD4EXbFFwv68FlZHbkaGAwzrzvKZMfS7Xj+dgiPf9w0ZBDrJkP+hQ7g851b0kBy1ereO5kWe9wN0QcRDCngrJOLG0dPwkoGeVMyrzorh+CJpLVQsxC5VVt/ddtQCBYAEkYuRhxZPXt/IMIp+o63/UsJBwWPSDiOLKMhZlPoj/qYPjdGI2fibdbwFvyWckBcmUYzLvVfUWUAeiWXLzPxl8oxNPEgyhQUB1s36AqjxJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Sep 2025 11:34:08 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Sep 30, 2025 at 12:50:47PM +0000, Shameer Kolothum wrote:
> 
> > This is where hisi_acc reports a different BAR size as it tries to hide
> > the migration control region from Guest access.  
> 
> I think for now we should disable DMABUF for any PCI driver that
> implements a VFIO_DEVICE_GET_REGION_INFO
> 
> For a while I've wanted to further reduce the use of the ioctl
> multiplexer, so maybe this series:
> 
> https://github.com/jgunthorpe/linux/commits/vfio_get_region_info_op/
> 
> And then the dmabuf code can check if the ops are set to the generic
> or not and disable itself automatically.
> 
> Otherwise perhaps route the dmabuf through an op and deliberately omit
> it (with a comment!) from hisi, virtio, nvgrace.
> 
> We need to route it through an op anyhow as those three drivers will
> probably eventually want to implement their own version.

Can't we basically achieve the same by testing the ioctl is
vfio_pci_core_ioctl?  Your proposal would have better granularity, but
we'd probably want an ops callback that we can use without a userspace
buffer to get the advertised region size if we ever want to support a
device that both modifies the size of the region relative to the BAR
and supports p2p.  Thanks,

Alex


