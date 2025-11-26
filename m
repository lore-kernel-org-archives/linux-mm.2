Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B1DD10F45
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 13:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490936B0008; Wed, 26 Nov 2025 08:12:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468996B000D; Wed, 26 Nov 2025 08:12:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E2C6B000E; Wed, 26 Nov 2025 08:12:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23A886B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:12:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4CB559B50
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:12:53 +0000 (UTC)
X-FDA: 84152798226.06.A77EB96
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id D3EED20005
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:12:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=L5BwZ9k7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of praan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764162771; a=rsa-sha256;
	cv=none;
	b=iPwhy6okGbgBU8Kfwj/ump2LI6MEEMg9HPlCQmjAkrNX3CpKLRYo3XfVFB/5G0HbRUMAy4
	VNDsfZhN/DzxIHBoE2BnFmBQB9H3Qn9uC+IKrXCEuM4jgudH+8AvSYSaKXAZeyndv27FcI
	1eis7wdNpAVROAeiVBzKgK3+80XC4Go=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=L5BwZ9k7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of praan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764162771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7j/p6bUr5Xuh7DTD99aQLTt37H/gN4j/r6C1+HVuuw=;
	b=SV+BLuquK+iLz/tRLcn5YD687uPUMAr6vMPGIqaajrwGvDgcsNyO0sVTYw3zbKBGBupuYX
	TkhuWSLvp0bT2hHp1QXA8XsY0/tWaDOkBJOcecOz91d3KQehp46SiF+xvLpLwFG/9wmSgQ
	8K4jUbI/XsgvY1icjh2L8fP+FA0dims=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-295c64cb951so203065ad.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764162771; x=1764767571; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v7j/p6bUr5Xuh7DTD99aQLTt37H/gN4j/r6C1+HVuuw=;
        b=L5BwZ9k7KNOYdZLBYenghbIW+EGhZZj20+eZRqYbAGTjiAn/Lz35kAQkU/bTZZiqjj
         um0nEOIatdLt+E5Riai/FyLwDxy3Qcb7OY1gMPhUR06iaVyEg60EQGezoKQhNS49bm+K
         krY/LvlRelL8yxwjBiDWJqDm0wEaR9Th9+X4As2bkLn6U5QlMhmoGQQyQKiuK0siGpBX
         l+MC0XuPcTdYz2D4Ny4dJ11DpDIu4y8cIXUxehsFSZFYGckpiMyUeGp+CJ8FY5kh5Ebo
         Taz23X7tUJj/nEpXpPfDmT5eWPDuAHB9oZMBqilcgXHoAuqo12aIOKD15eWcLonOM+bo
         sDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764162771; x=1764767571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7j/p6bUr5Xuh7DTD99aQLTt37H/gN4j/r6C1+HVuuw=;
        b=uprUXV6putRoe+wsVcIC8y1RQWxFTo4/cXyNvcTkPVY15oNeD8Qv3+Btg3TKqCu3d+
         /LaOPZrHREeawS9NHgsWcFZqZkSTrL0ylks4Tf9Vf1+8RvZ7/ufH3QP5Hetic6uLbh2j
         OyGaWaZXZ9OLLE6EA0dy/XC8myY9uRb6rxm2ZcmOZYkgdVfZgRzMiJTiVG/XB2e8274v
         N6gB5V1MJBWmxO2wJjkzPGodpN/53O1LuF5zxSJfQjrveO9G3YN3d7lnYd3KcztPljyJ
         +SWbEklZB/nEtcEaMIMNLmImcELHVOUrO8lJhDns1IM7oy0nQ+wplBH7aNkc/5naWbQb
         kwTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUwIW/RXF4Xh59kplcBYOpDNRR0na8nJApAG+qRQn046UMKY8uj+KJI0aoMGvK9STT2hnzf64UFw==@kvack.org
X-Gm-Message-State: AOJu0Yyy8NykRnJzRF4liSIss1h0Pp7u97GQBAeVRuql0SUvZy/f3zXD
	qxTTm+0vKHDu1Wso7ZDxULUhxPnjrmQTg6nX6qsL1if5m1+0+YUjzmAPB2a5cr9/uA==
X-Gm-Gg: ASbGncuOEcgWcZtPLAZSblzPE/frZq1fXzyX98ms71uV0rqeo6w7ziLChV7QWvmRQyE
	xor+zfaJZEKQFH0Ty1lFLb5feI/egQWXRaj91FWG3fYLFTPC5hzQz26rRFSl1KtKKOkBjP0PymT
	TSEhi8ij0uBFpwRiqAzEQ/rStR4v8ERH/jij43otCYtP55ACaP187mKqIMI0X0DJBs9SXbqwrUO
	cI7Fm3WFRTeeravB72Uu7sjXTFez2N0MHkXEibQZ3FfyPI01M+BxDddH15F4ehix7bl5SsnkGJe
	j2GpWNPmf7qQWoAwP9pHb7+EMAft12PCSGQ2bA/H5TBIbrSFFg5Clgf6Bm8d19mj3klil15i4uW
	oYTj1PiQrQwa79twdNBz01XBFc+dfdEHVkgqP6wZ7YFDtmGPpSbN3C+gcoqLAyrTrE2VDlsNYGh
	XuWuN46W512ElVu4Dz+L8nMtcmRbcTlpcprOJVi+Qjt7wCxQdS
X-Google-Smtp-Source: AGHT+IHJIOBgKlL+CS0ZpKtYX5Djx07PEo4PrDI8k+TVBWbcqpi0p7MakMMReKQUlItaKRJKERuBaA==
X-Received: by 2002:a17:902:cf07:b0:26d:72f8:8cfa with SMTP id d9443c01a7336-29bba9e8a00mr1709325ad.13.1764162769984;
        Wed, 26 Nov 2025 05:12:49 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b105e4csm194769895ad.2.2025.11.26.05.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 05:12:49 -0800 (PST)
Date: Wed, 26 Nov 2025 13:12:40 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Alex Mastro <amastro@fb.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
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
	linux-hardening@vger.kernel.org, Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v9 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <aSb8yH6fSlwk1oZZ@google.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-6-d7f71607f371@nvidia.com>
 <aSZHO6otK0Heh+Qj@devgpu015.cco6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSZHO6otK0Heh+Qj@devgpu015.cco6.facebook.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D3EED20005
X-Stat-Signature: tsopqymhf5kjqdpbw7qzwx3n8e6aeztg
X-Rspam-User: 
X-HE-Tag: 1764162771-344839
X-HE-Meta: U2FsdGVkX19NpYxd/R5/G6cU6Gi1hEUY9OCLlq/zW/quSbinpc9qAx15N2yO2YPa9E8sleuJHntuaYVVSD8Ex1kOSk7im6pEysuRUjVIrkwkXoBBIZqnRLMPeSBzkbq/CiwsRrCXm6Gl9e9uLnJVJAXZgPlKAiLwKDkrfdYIypFerxAg7Yki00n81SkfztqWIVtSS9ALndR6E+y/5hH5RYK8n71XiBrvrpXw5MytXPJqBtl9r+m3ve+RnEbRzG6Res08w59oNdTRfgFXQI4Lf9nFOyARl3++uI4aHu5VoVpmx+DqPSXR9MsytSpeuDFEuBkhHHLW8/6ZzvXH8N/vu8OQ3pIGrOxg/CDDWnbBlHphf5fIGmrQ+84cukSXzZ0c26Zl3/XAGaGgKnwzVNzL3q9zjWHGuuOacl35wYJ95H9cneN4KzWf1d9wISqHkZJbFyz6F/3VtAgLkkqHZq2400b22+buxM9mTCYC/tSaYk+m5c1qKdYWbvvOIvZOO5HZzhDSW0nRJgsIMF8KwsPjYiidNptIo8EHzBBnmk9ENEU9nB3Cv56zlsoXuF92fLFZVZhPcqeSxIs08b/LYiXwE2BkWmMSb/ebY2LaRdhurw6+8L4WOzJb4dWU9KZI/qvW7v8Ei5+VVQ8I7TzDykPqXEyPP0OOizktxTPkLvE6YcUC5V4XeppoPUbUZqC3I+8FCTFE7SPyDplBvpGKAB6qqv43pwU3hah8wOp81bVCSwViRsf8Ku06/C+YFF8qrl7xcvvyyqWXSy5/iViwJbMA4rz5yYlQRvsiUaZ/aNoVESSW2FL8ph0zuqKvUzUOGhzdUryoOgjyGBZznHxuIN+o3Kn7LCL3San2v+9BSfxZ3FRJbgLNfmGg8iifkBrtctlCQ3WNIcPUSqsd+YMZn4AQ0obXd5og8JNxKG9nThpNZlBGB0ocAjlSiWKPI1CjN9enjSRMiWqF/1y14Lpdemh
 pRRDZhZT
 iQR3PWzfj6nH0FJ1RJXXJbRoIshYoWx9MdXHw8lc7+w5PsNlwOCLovT7Bi/LaOdulihdPWu/AQRND+qBvZsB/zPRYQgx8JYaM2jdzH+I15AhpHdDJgJRFCBfGSfP8MWENod9rgufRSXPe7d1aaJ4mqDoA1hbOMg8JaVBZMrbkzIhWMoFc6ntkKuZKLc80FLZBVPHW8jw8GsRyb/UXTvkUbYD8msP82mUhO2YBd4KG2DFzjVmlgthT7h63A7gW9Uqb7BnwEVTEqU+8Tnmhka5iQvYBLHdG258Nb3pTdhwJHKvKJXOAJEqHsaHzC3pKHMMIq1lAPr26zUk7JUg4XCPLjDHO9cvP+OnKiUH5wTKy441G5j3MT3hpWxZ5Gza6RUcgbNmmEA4Ai4trv7XP3eRhRSkc1CymmmM9WT2m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 04:18:03PM -0800, Alex Mastro wrote:
> On Thu, Nov 20, 2025 at 11:28:25AM +0200, Leon Romanovsky wrote:
> > +static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
> > +					 dma_addr_t addr)
> > +{
> > +	unsigned int len, nents;
> > +	int i;
> > +
> > +	nents = DIV_ROUND_UP(length, UINT_MAX);
> > +	for (i = 0; i < nents; i++) {
> > +		len = min_t(size_t, length, UINT_MAX);
> > +		length -= len;
> > +		/*
> > +		 * DMABUF abuses scatterlist to create a scatterlist
> > +		 * that does not have any CPU list, only the DMA list.
> > +		 * Always set the page related values to NULL to ensure
> > +		 * importers can't use it. The phys_addr based DMA API
> > +		 * does not require the CPU list for mapping or unmapping.
> > +		 */
> > +		sg_set_page(sgl, NULL, 0, 0);
> > +		sg_dma_address(sgl) = addr + i * UINT_MAX;
> 
> (i * UINT_MAX) happens in 32-bit before being promoted to dma_addr_t for
> addition with addr. Overflows for i >=2 when length >= 8 GiB. Needs a cast:
> 
> 		sg_dma_address(sgl) = addr + (dma_addr_t)i * UINT_MAX;
> 
> Discovered this while debugging why dma-buf import was failing for
> an 8 GiB dma-buf using my earlier toy program [1]. It was surfaced by
> ib_umem_find_best_pgsz() returning 0 due to malformed scatterlist, which bubbles
> up as an EINVAL.
>

Thanks a lot for testing & reporting this!

However, I believe the casting approach is a little fragile (and
potentially prone to issues depending on how dma_addr_t is sized on
different platforms). Thus, approaching this with accumulation seems
better as it avoids the multiplication logic entirely, maybe something
like the following (untested) diff ?

--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -252,14 +252,14 @@ static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
 	nents = DIV_ROUND_UP(length, UINT_MAX);
 	for (i = 0; i < nents; i++) {
 		len = min_t(size_t, length, UINT_MAX);
-		length -= len;
 		/*
 		 * DMABUF abuses scatterlist to create a scatterlist
 		 * that does not have any CPU list, only the DMA list.
 		 * Always set the page related values to NULL to ensure
 		 * importers can't use it. The phys_addr based DMA API
 		 * does not require the CPU list for mapping or unmapping.
 		 */
 		sg_set_page(sgl, NULL, 0, 0);
-		sg_dma_address(sgl) = addr + i * UINT_MAX;
+		sg_dma_address(sgl) = addr;
 		sg_dma_len(sgl) = len;
+
+		addr += len;
+		length -= len;
 		sgl = sg_next(sgl);
 	}

Thanks,
Praan

