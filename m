Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 345B0CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED13800A7; Mon, 27 Oct 2025 19:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D478009B; Mon, 27 Oct 2025 19:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C25800A7; Mon, 27 Oct 2025 19:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 647528009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:13:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20B941A0294
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:13:38 +0000 (UTC)
X-FDA: 84045448116.28.DD1DA94
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 27444140002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:13:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MZIUvfEM;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761606816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVb3sBQg3S7kfhJuRLHfxPiQ08+Bc1FaH34bvysQgyo=;
	b=0kePtfD7jw/5+qZiUnVXXWZLL1c9NfMzEzKdfE0zzOe3jaKr+vWEFzksnygz67d9NxS2fd
	Dle7rCYm9mv93eVDD5bjVjhz/tXUZz+M32xyynWDsposkzyz4yaJOi3OK/cn8Q1QUB/TM8
	up0XWXsWl/aA51KwMEauPj3F0WIm/hE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MZIUvfEM;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761606816; a=rsa-sha256;
	cv=none;
	b=p+8FFSa9M1+RBNOfWpcDgoGcFH2FbNZOgbgJjqjqwk6zo9aAzB8VD1VuhaypEjJT27mlH3
	fDUY0/PwTwyPn0WCK0khUBRG7+q7HvbjEcwNDm72SqqisU2YEus+Xdku0xCdn3AG2mjKDd
	OsVn9daeYUSfl0kpQfauRBxAaN0u8Fc=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-592ee9a16adso8968273e87.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761606814; x=1762211614; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cVb3sBQg3S7kfhJuRLHfxPiQ08+Bc1FaH34bvysQgyo=;
        b=MZIUvfEMpx5MIaswGk6Q+asnWsIKJVV5Y3YhqLFZeYJBUqe8yC4O3fJf3gzjFNq4dp
         a80kldbcraGXOc9fYR/CWym1PXwjdW+qB8P+uw7U9iCF1XQA2b1HbZqwsRmsaX/sIDDO
         RnTo9ltX5wUiyyDTZugHY3vAqOvQ7OsPovd6omRAjGuOAPX0iov921i6mod4KAgT4hW3
         x+k0ecpWdlIhjMfXhKU7W/Rv+I12FhOA3xhmPOdr+zXj2q7vyMMQSRhK2KQh7aA7PbYp
         t3J5JLjBfCxAp8f/a7bgdsshWXs3Qosj0ExGOPgdwmcAU0AvLg63GzhMLZiQ1Eed6Llh
         cU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761606814; x=1762211614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVb3sBQg3S7kfhJuRLHfxPiQ08+Bc1FaH34bvysQgyo=;
        b=Iv+rqygjuEto7WDxhwxvV9szmjqDhVo6EFlB8QmlzQzYwe+0GE6uZ2xlszc6XIbVg4
         OyKqc1wgupV5UzK4hkZ8oXTG03yDv4W5bNOlk3PKKSqZ8bTKcgzo0u1wGnAFd3Kw9Z0f
         N/963GnT9YE4TEwR7eNItK5rgi/S1C+wzQOqPvL0y3eRYBC7HqUfIaQNI0Z+Npcstbgz
         0Nk2Pti9wXKqx19nD6iFpMtQnGiwz5vpZYDnclkLeL7qEZ2GJ48fPtxIoQ0CqKWMZoP2
         AYVIhWdJtjdjLFag/3l1ka9LTBHJBsXhIsbLTCZqUNyavN2rrIoDidDVfYU68hXKb5bY
         H4UA==
X-Forwarded-Encrypted: i=1; AJvYcCXWw0lXJPIul+sPdON0F8TKJSYagE5r0sRZPgobWmcmDSDDoAJ3Vlp1R/clw2hiuxoFCmMUCtRCkQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0ohWJ5mNDjuiJXHCnoNvtkA+GKjwTHJ3sZOxIBu53kVBiA8fC
	+ZKfwtT5irhG7hz0jQGRzckc9o/Pb1uOzxCUR7K6Xc4wpZYxQ7yMaoEL1lBHs4m25v7ko4qfZyU
	eH+rEWj6EX/VYIoOaQ/2tMnFT80sA+NJ1JJrjdkdG
X-Gm-Gg: ASbGncvcCqXXCXYRHooHlM2Hw3zNAMBjwrCB6r7ffX+SJKMWJKapImEQiHbrg4Iqaj5
	yOkPg1eVDvVOjjYAjctao9nJ/6w4+3eJySNDXvYXf80W7f71SAeOW0YNw91mv9Y3OnB1PMtUn1K
	kM9IVwCbSij3tFC7j3Y7cYz68IY9OyE0OO2D7o4UuZd2YEWyhXwDkxW2DVbsLqaddIf9tZk4nFj
	YeLKpRP+9GrA01JpR6AvFPiHhZ8qPo8lGILnzH97Tb47jToToDHqd1ajAZhcXTrjGKpvCg=
X-Google-Smtp-Source: AGHT+IGl3ca765JSYQeeeNWnOc4ez61Rh9cYHuTu2Z8wbfu4++aeMX3ejm6+mpCGbnxLweY96XJw4Qd/Jsw/gJioL2Q=
X-Received: by 2002:a05:6512:39ce:b0:585:c51e:e99d with SMTP id
 2adb3069b0e04-5930e98f2bbmr555951e87.3.1761606813913; Mon, 27 Oct 2025
 16:13:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1760368250.git.leon@kernel.org> <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
In-Reply-To: <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Oct 2025 16:13:05 -0700
X-Gm-Features: AWmQ_blG76O58dB2_ktM5H7ZDlww5WUOcPernLo2oZm94nuYAfy2S9NihsUA1rg
Message-ID: <CALzav=cj_g8ndvbWdm=dukW+37cDh04k1n7ssFrDG+dN3D+cbw@mail.gmail.com>
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO regions
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, 
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: r9tw36wqijfy9zb11chehqcaaommb7wz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27444140002
X-HE-Tag: 1761606815-103776
X-HE-Meta: U2FsdGVkX1+4pXW8CpOXeC+WoscU2RpCncSpRwSjab8kUWukya3p+V2/Ne/Xxc4lxh4R6RjkGABPJLyIAk7HuCL7c+CXjFOyUcFnjS/Z4Zdne6yi6Ac+j0NQPsXGMgh2BTqi/xwd9dm/Y0NN7/uzWmzWBdWPuiGZjiSCBtKdFAkc949FDq3XDm4T0rhz5sWeSq0UbQ7WlpnBj8lNeF4AloGhu+vEAgs32TmFN9qBJWvNtlvFinvOj6vF3OT+YzadntwIBgj+7okaqwniUTao4jzKQiAvKwJeH3or7zKbma1iIhupIPux05HEYnForacfkQvc95wcnhVl/oBLFd55FF6tOqeQXCeKe28Ak1XNotJpfEmjRZnh6IJJfFOWh6lFjdpwARrtMCya9tLZLYNxckdUcrASCIwo4Hcnvu31v0+80mHSKfyAZTqslntvglTZnJj8Tn8qbZknRVg4IiAhczW0H44kA6jm9RGwSBAEYD5LawMIouF9YYwGoS6NC8KhYLwt/CkTdoR+iVZH9l7B/UnPnk5FRbumCfnGHEpIt1iLOVIVdOal3j/cKJOrxFIMJHT15GzuzEfpnn1iie2GhD72eLeWXMDxoxowKJGF1f5Ht5+izOoA4p9D5ejsJ+dY7yL1bZffNJ9z5jduFDKYiHyu1CVKuMSYRWo50myKwCGB90WWZMtMyk7bB8zjI+JUwAp7FaG/rVG/DAtF8u/GVrS8SbJtaUfDpFDili0CHBDeifhJSHX+sUPHL8/+vrhLBq8iOJ1JUJot7CbSsHwLn+D9+72AlEbbvs/wNt88BR1TVYOX0EYBrXCSaSPXUmk8e3A9f6h+hSblhHn3cBwF3hVPI4g01xaVBDUSpBlgSC/MvX/mXhCPfNY2X5KBjpFyl+2/Yxy0q5G/9bpFRXhcnd1w5BAUVT7TQb9qHydUTp/js1mIL42F7ouUq1hsMcceCBD3/UN4eMi1XcjeEcP
 wIkM1APn
 Pn3ZN0g/kvaHJ8lkVWlZ3CuiHYDhbRFL3ub/hFBHGX7sYr66N8ZEnMkJIVgS+tCETYswBU69EXViIVqonsoQ/aQnTUpQx48R9cORP6qMJ0hXD4N5yjKZcTILv6diA9+LKDE6IJu+pQmFxuzZO8tZCV959vJal59bmGJIisuAdeaJG67dFLNThBFiCBWgq2/IlpiSx3Q5PJpigPmBDdHWrKJmJpaO36oAxPg08oRtiQfMG44rp8MBCg1cOdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 8:44=E2=80=AFAM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Add support for exporting PCI device MMIO regions through dma-buf,
> enabling safe sharing of non-struct page memory with controlled
> lifetime management. This allows RDMA and other subsystems to import
> dma-buf FDs and build them into memory regions for PCI P2P operations.

> +/**
> + * Upon VFIO_DEVICE_FEATURE_GET create a dma_buf fd for the
> + * regions selected.
> + *
> + * open_flags are the typical flags passed to open(2), eg O_RDWR, O_CLOE=
XEC,
> + * etc. offset/length specify a slice of the region to create the dmabuf=
 from.
> + * nr_ranges is the total number of (P2P DMA) ranges that comprise the d=
mabuf.
> + *
> + * Return: The fd number on success, -1 and errno is set on failure.
> + */
> +#define VFIO_DEVICE_FEATURE_DMA_BUF 11
> +
> +struct vfio_region_dma_range {
> +       __u64 offset;
> +       __u64 length;
> +};
> +
> +struct vfio_device_feature_dma_buf {
> +       __u32   region_index;
> +       __u32   open_flags;
> +       __u32   flags;
> +       __u32   nr_ranges;
> +       struct vfio_region_dma_range dma_ranges[];
> +};

This uAPI would be a good candidate for a VFIO selftest. You can test
that it returns an error when it's supposed to, and a valid fd when
it's supposed to. And once the iommufd importer side is ready, we can
extend the test and verify that the fd can be mapped into iommufd.

It will probably be challenging to meaningfully exercise device P2P
through a selftest, I haven't thought about how to extend the driver
framework for that yet... But you can at least test that all the
ioctls behave like they should.

