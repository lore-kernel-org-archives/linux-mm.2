Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44C5BCF34AC
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 19:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2BCD6B0026; Wed, 19 Nov 2025 14:36:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DC046B00BB; Wed, 19 Nov 2025 14:36:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CB0B6B00A2; Wed, 19 Nov 2025 14:36:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73CD86B00BB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:36:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EB8FC05E5
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:36:42 +0000 (UTC)
X-FDA: 84128363844.29.D479181
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5878F10000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:36:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=jdK8Gkva;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763581000; a=rsa-sha256;
	cv=none;
	b=TaLWiDp6RDurIzQO5i16SEa+92vPesWoEP3HHMMtDKyzcT3Xa2kxV9stfTqlbwFUZXUGZv
	ztNFR3NjNshRJnCcfKrZ8zcvbJslne+fGU8W4ineb1B7r4GpeHtXICwDjRX3ZKPJhF4vqd
	gHEPO/sWm0sCiMK2Ireuhq1pjkqdMKg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=jdK8Gkva;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763581000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sztelLlBrONBmM282viGyh6kz65i94yYxCWrYWozdqM=;
	b=iIn7lRaeK+owTRyXTx5KheOhcEEU3IXFu64eICy8D9ecJmX2SYylQFOCCmL+d9n8PK78m4
	PXGmwyB+ZqiTBAwMc+Hl8lYpSKwP+mpQjrqZoFpig2rPoN6jeZPoxiTBsiDzSRYSIFR2vj
	1N8yM0uQGZ4ighl8w0D6jvIdJ/oYIe4=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ee05b2b1beso783351cf.2
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763580999; x=1764185799; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sztelLlBrONBmM282viGyh6kz65i94yYxCWrYWozdqM=;
        b=jdK8GkvaAbn41zZr6hUr0fgaOKKPyFQbzeBAm4bqEWz7J3tlokl9ZFE4P0+Nlcr2LS
         RXOUApEgDssw0K5h3w1KxUqOjtmgoxQL03poLAQSXyIl4DDYHLrwCZXKgoV5LgpfTu4z
         oRdHcoS4YZ0HiUHBDGMisPMd+4+JmPdOrVsZ2oCLM/mOxIUsAkNYB57mZfud+vv3IPtF
         SQd78SrHyFnbiHJQaxFVfqFNteVI8NxMuvxgSWanhxlguU3S4cQoBxpjpqA6rCVj4q/i
         wGeRwkq2oxHn2bwfkvajDhPH0rvRZE2+jYIxZbEGEnyZFX2EJjfc9LA7mSRNuxc6j+Kq
         679g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763580999; x=1764185799;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sztelLlBrONBmM282viGyh6kz65i94yYxCWrYWozdqM=;
        b=jsS3h/xKFG93E6KrKcRecnCJ19l0xUZy1+nvzi8EsMagtLocWkZ6Il0tI6yW52gWaf
         Q/EY5/icnPAJDk3At0xrMzwBZqb1bgwA708Fw8GIljSObv/HJn83odUUsWMxtWHKQV3b
         124lbNoYjPtNa1MfJWQgAWgq8cl8a9O1MRjs5ZVsjX3O9aT2IJbaWhomgL/bHKX7rW8j
         QlOa1zsFMJ7eIqAHaELPUJsud8rgz1EBttZ3bMhU+ybdrbpZ+nocns2w8fG4AmqNzLV1
         4I1K15TvcppQgDn6kuIvBQsFDw6jDuqPh5LBNGFmPqEGyZYLxcumsZZHrTnvufA+JITG
         dKuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXawyZyFXlWoc0O1FDs7RNB9hfG6QOCJK8KBXYsGILj5pmPUi9/xSXVLBj5F1tIHbgtQU8i2KK1Lw==@kvack.org
X-Gm-Message-State: AOJu0YxVL6rEUG3015IIlkD1QzjDi8tEE5Tyg0JqAB1O6qJmbdWOz8B0
	wv2D9g+sXeZ+V3i4MVVpz0+tlW6yvxGX5LNKefeTA1cX3E0zUAjPT/rIWJ4s0A4mKPk=
X-Gm-Gg: ASbGncvJYWPuaokCnM/OgQGjVvKr251fWEEMVxAXIa/lgvlH54OXldEAHY9+JtzBsoo
	DXpLaFJnG/w32IIEUgLFqg8+xD8iWpQzjNJlwZhurLSv6gCcNjTLpOJWzUDRP52n2BDA7GdVEXR
	6bEoDw1b72datJSrksfnoVVAEMa07+qPFB1zMamrLmTnNSZRPdjej3e0XwpBVzbo8oInmK0wytF
	pB0T+Xk1i/mbpn6puF9IYMG4iPmG2uZDxGZ1oBfGdQS63s3DJ91gasVeAikheKxxP5uHybmiMfe
	moBShK7ffAvNsHdCkDEeHNPaLL2npCuev4/q6QQ0gN8kyymRgxgA8gNTGrvEGXhBDqygJltg3Ko
	n6uzD8wiJauOGbnx8lHEuWy8n1EeVvyuA9bZoG9D+FddKZJE2kskp+sSQkiQ8NzSqnZ8x3N4TV3
	NTAclhMfS4h6oY4ltmK00tL6ApadWeUlqqKaTOuwsvYs71XoGXFRQ6b74l
X-Google-Smtp-Source: AGHT+IEogkhlTHFcyAE9/u1UuBQV+X3tukog/nHIoHavB/ndnYOWZGPWrkYoYNh/EOln2cA+Kp4KoA==
X-Received: by 2002:a05:622a:310:b0:4ee:1d84:3068 with SMTP id d75a77b69052e-4ee4971a985mr8236121cf.76.1763580999342;
        Wed, 19 Nov 2025 11:36:39 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee48d64503sm3117901cf.13.2025.11.19.11.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 11:36:38 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLnyo-00000000bYz-0lQx;
	Wed, 19 Nov 2025 15:36:38 -0400
Date: Wed, 19 Nov 2025 15:36:38 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251119193638.GQ17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119134245.GD18335@unreal>
 <6714dc49-6b5c-4d58-9a43-95bb95873a97@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6714dc49-6b5c-4d58-9a43-95bb95873a97@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5878F10000E
X-Stat-Signature: djyd91qxemtashmhwmgjra4gs8nzy3zn
X-HE-Tag: 1763581000-1241
X-HE-Meta: U2FsdGVkX181D1V3CPpVHa6OFnSZWkgYp++gXFMDWDYlrxPnA88w348uiUtpF/ufSTBHS4pGVLpau6AuoU5DIFyf0VkQ/Qv7rPGbmWimcw2pC6f8Id1ckLP6L47C/7YFUGfKPEn1FS2zrifRiwMVxPx+hI/MzgCNJHfME2cb6sidhzQYvyIWiHggu+T5XV6a/WohiqY906IzhD3Ei07Umi4uPOxSgsYwjrCHjA4lN1e/nVN0eckCLHdq8nHiNKiAvz5wyZM7P1tFCt8iXLWAGFdd0rNlsEKHpsGBODlh1bNeIgAj2Lmiktp1hgJDzg/LsbybcU4BR8nUItwrFkVh4nqd4t91G8ydbKiEJGanjoZ02XaBSskRSW+/ItwgznoU91pyJ/uubPgn+s6YvIHVHldDaKrQUyF8tU3VfZGyORhlQiGgtb45WTBXOVyIU0WtAPCfiCeTLJb1Z/DMGNxhoaO7N2r117/MsHDaC1quhyATyOc+N5xc+KAWIjtn86jMt11T2oHAvdw1KEa7zNqCv2qHZFcxabL5oBSdrcMasSmhRFZr7G38fyJozmOh7cce/pFFz9aK3oj3LSpeEZcMo7evWkoqTLhfJPiR1u6GZyrH2ivgNGzzAqZ/T9LDMuRo7dBSEbPQ5vovqLEIpAz9cXLWf7Wbkk+ErwLqSLoP3ddUi6pOw0CyyWnwqQtWZtgDcTW/0+yOKYQB74f0cBQjqRe1I+sWmSZ0okk+FQ20V9YtIfsMKMRlcs53eyNmExQK8NRFGSp59/AnBj9DNvXzX7XfUPY3H3Ekh/LfFqef4G0LTs3ENXHWUVqcUy3+LMoSvmxB2Po+M2E23TgnCo51SItb1ZE72FzLItF3JJpd9UCJWc560EJaWd0bmCFT2ZpwklraKS+phTLg00FjxHRWzN7SwtudJmKXYMUj7EQO1wyfQh77ssVMd02kdglJbvp7s0BLKx48ZjnwiQwCYMC
 4Y3ul192
 LS9uARbgZeGnO9oOYOZDRaMcM6CCAtJe5Qit3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:11:01PM +0100, Christian König wrote:

> I miss interpreted the call to pci_p2pdma_map_type() here in that
> now the DMA-buf code decides if transactions go over the root
> complex or not.

Oh, that's not it at all. I think you get it, but just to be really
clear:

This code is taking a physical address from the exporter and
determining how it MUST route inside the fabric. There is only one
single choice with no optionality.

The exporter already decided if it will go over the host bridge by
providing an address that must use a host bridge path.

> But the exporter can call pci_p2pdma_map_type() even before calling
> this function, so that looks fine to me.

Yes, the exporter needs to decide where the data is placed before it
tries to map it into the SGT.

Jason

