Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFDE1CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385528E0005; Wed,  5 Nov 2025 03:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336688E0002; Wed,  5 Nov 2025 03:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272E08E0005; Wed,  5 Nov 2025 03:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15C5B8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:16:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0F281399CC
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:16:17 +0000 (UTC)
X-FDA: 84075845994.17.CF33B6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3FF9FA0006
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:16:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Snx30Fxc;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762330576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uwhp/D+sCRbdzg+D5pZL4CHOgCDXY0KRg62w1PlLmDo=;
	b=R8QUTkcYPBJB+4VdojmbeO3+6dtsldPg8PIrjyhjuJI+2GEESrVJ59MkwqPuCWq6ayqNBh
	7G4OjqCDUooR9zSe3orIjEYoo/dRsK0UzzGUTNlOQIK0gu3WfmqvF3IUN9btumX2GKS9+K
	yRJQ2WyJ9c6M2bgnb7jLS37eefc4Af0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762330576; a=rsa-sha256;
	cv=none;
	b=CBfby6XXWyVFyluhZE61xZE2czNNooS5FMfpF4P1xCRbTdDEojKlqG65UxHxVJGsaWiK2B
	VDbGbahrSyY2TKV6aIc5HpWoJ8fN+8SwhmGU2/RelQSICEN1NwK/XaqHvtHyzI1TWEn9M0
	0BHWCSgbnq02HJyeVZuyIf7Q5fHVeyM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Snx30Fxc;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AE31601FF;
	Wed,  5 Nov 2025 08:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6264CC4CEF8;
	Wed,  5 Nov 2025 08:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762330575;
	bh=udr6mKWYM6gsMhi6l+HmrtMsrAYtMveuKFz9q/uMFUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Snx30FxcGRCf73Ui5tRrgwEAD2Zywqm32IJNeGhhqcKAbrPqP6nqCFttnO2dDSOm4
	 3qR6wpowVnsvjN0rwPIcLCShDuoZ5jSJWmC7CGsP6fpxjY9i+SYJqWP6IoqWRVLYgf
	 e4bq4qsJHj5tESPoXkPb0y8ytBDZ651wLfxCDqqJ9jA7XEK+WyuSgYvwy/Vm7Wwx/r
	 zDkGgwhiDkELDGQgAB6nFzEU8HLSdIepIq4qHMlwOlYKVPQ+8SSA7rk1T7llt7a4zh
	 qq/vaQ03kHbDoE7Sm1LenUPP2wbTMl4R8vo6i0BKl/7ynTmFOtTjZ+2cneXSjREyQ0
	 hXQ5dtAYUVrzw==
Date: Wed, 5 Nov 2025 10:16:09 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Alex Mastro <amastro@fb.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251105081609.GA16832@unreal>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <aQkLcAxEn4qmF3c4@devgpu015.cco6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQkLcAxEn4qmF3c4@devgpu015.cco6.facebook.com>
X-Stat-Signature: nstjxu4m8usufga1gjszpqga5wpz4wp7
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FF9FA0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1762330576-454451
X-HE-Meta: U2FsdGVkX19UEOceeWMkpX0aWEu5jVIlDYpqmPlq83sTAjY28r+3r7cb3Ln2o6CvapeSyRHzhg9Hg9F+sHHGKpjmsdfBs5+fqOcbkaN1A4wgA+DEWfIjMRIivjygeid+6f6KAne/UjamIN874FT5wN6uV5euA1YtF3THvRkyLOF9fwBBJMQ6yRcKJHslhXnabaPDZBIM3ykLOGRejbXo1O04EM0FzK9MVTZqlJhslCqr7smw0L49frMcIAinMwYgBMu5kwKV2DMbMa4jMHiD08YKeF3uUoHkNNdvlbGvnxbtWkP6taF4K1V1Hwn6b7t2abclvGL/8jl004YoPY/bOGTH3vDcH8cbl2J3Y3vqdltv2Z+/NoQE9H7GTKc4k5lPlJUzWlbRPb+x0SMJ2TUdI+eEYr7cyKOfLueC4D9aEcklUBEAJ2EpbdPqXS4ViyxW3yB2PTJ54CRl9L2nVHRq9hpLU3+5qxCKRTaiSyWYI79JthnwnNZDFGkqwIEP1lNW7eTRyqMgWO+bIDARmLc7IEAHOB60L+E6YhxWzcC/EZW6Icyrcm2+82o/ru88ZRXgwV67n0VmP71nKAeQ7+9uIwGs7SCNhm/5A9fQlr7/Qj9cV49a/w3fxs5aR2vkA4oug2d/Rim6FKSgNOyZ7xODVgSbPOS7ZM/Ngkoilutx8tJkPT4WWz+rd51THOmQ0Gp4rgC59ANhJQ+/781pleYkYrXeiGh2paosUFKv9XXLNN+f9m5t3PEcKi5vHy3QAHDBuVAouYmWVuf/BdI97qYt3GIOjz+Ecle97tMc2zeooIKcFPUhGJAQItEhQV9NMAtHXF7fTnyKHfYyU9WoGJA7bK7KsuW+J8UOl7z9UUrsSFmd6hWsTN0T4sNbDQjojNj6i4WcnUVtf6G44dGDj/Iehveiiq1pF+vTHhS+keEVBNoOuYwoJKJuMk6Oh4fzxuPBmMoLdq+h+tEdW/D51H3
 +ycn1eaj
 lzQ2TaBKcUnECLLMtq6hHq9UowUir1+lu5BzAQ3phYreBipF1GnLcXhtKx1s67UB1TofAwbXe37LgW1UAIJkYxKAKueeavHXMYyTCSp/bU5ylVx9ByUdI78P+fVrv70z1gbA3AfJ8CbD3dyCHdkZOboxHpa89dp9JFccM0n9kKEcHGKDyk8eAn7DR0ijPirDxUsn4YFPkkeH9clKCBuZJcWSp+B3RK0u2HJeAHWy3B/56wcN2QQX1BXj5RGwWExIr07MIKMr4/cwsLaIexHSOf91dlfQ3t07tKnIgHSz8TBRfDy8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 12:07:12PM -0800, Alex Mastro wrote:
> On Sun, Nov 02, 2025 at 10:00:48AM +0200, Leon Romanovsky wrote:
> > Changelog:
> > v6:
> >  * Fixed wrong error check from pcim_p2pdma_init().
> >  * Documented pcim_p2pdma_provider() function.
> >  * Improved commit messages.
> >  * Added VFIO DMA-BUF selftest.
> >  * Added __counted_by(nr_ranges) annotation to struct vfio_device_feature_dma_buf.
> >  * Fixed error unwind when dma_buf_fd() fails.
> >  * Document latest changes to p2pmem.
> >  * Removed EXPORT_SYMBOL_GPL from pci_p2pdma_map_type.
> >  * Moved DMA mapping logic to DMA-BUF.
> >  * Removed types patch to avoid dependencies between subsystems.
> >  * Moved vfio_pci_dma_buf_move() in err_undo block.
> >  * Added nvgrace patch.
> 
> Thanks Leon. Attaching a toy program which sanity tests the dma-buf export UAPI
> by feeding the allocated dma-buf into an dma-buf importer (libibverbs + CX-7).
>  
> Tested-by: Alex Mastro <amastro@fb.com>

Thanks a lot.

