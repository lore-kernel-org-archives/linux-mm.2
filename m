Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8329CCF857D
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 10:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22A06B00A8; Thu, 20 Nov 2025 05:03:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9A56B00AF; Thu, 20 Nov 2025 05:03:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D365E6B00B1; Thu, 20 Nov 2025 05:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C55FD6B00A8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:03:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B67612FF89
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:03:20 +0000 (UTC)
X-FDA: 84130547760.21.441BB2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A0E5CA000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:03:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+hY+OMB;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763632998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3I23WtFi7hlt9EM3CKuk71SiWM7XDJPcRu54jITG+eY=;
	b=2LJLMp5kYfaUb/w/jTdgFAFKO7VLDWfzJ6OCdzLkVlUaUoCQlKFEOlt3UvDrwJ3iaLDAQE
	V/HV5+GFePt3gk2Sz/qjR8s7pGTX6Lyiu+8H3cp/2MzQaIHQPYX7ZiiLvl7ZCe/xjpL6fl
	ZNI0f5mE2EVdi36dXMFD+IYHfNzaL1A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763632998; a=rsa-sha256;
	cv=none;
	b=PmlbojVC6RdCy4G579sqtlH4VNgh8Jwkc++vYmI795BKnTEvU2yPS3VV0Y9XesPCiT6vcx
	pXkzBNvGuYSj572YLo0uXLqorEMB7Gk1/2WBvEz+R8fg9oN15yulKsPVRef0tz1sfJ3n75
	GoTY+hvgJWlf6M66Jb7plONFvib4OOw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+hY+OMB;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 61EB3409C4;
	Thu, 20 Nov 2025 10:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB98C4CEF1;
	Thu, 20 Nov 2025 10:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763632997;
	bh=nN18XypDEK4Xp2Uwyzn2CyI2CYU2LLHnqRbvcxN/MOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G+hY+OMBFwxjvW/rHz3D9U5weCHQooOgK8MHfyA01kVMMV+A3AkZ438UHthcqeE9M
	 /W8sa0sQXGzt/hW+GZKYO9qCVhuYOSwzWyvXmoHLLLXKCC71ccQychOWgBEc9/N4WR
	 B4hzYRwhJYWOy/XMG9Ee6J/fv3T7TqpQvxDZRmSFypghKchjL3PUHlMTtC4LoafHEg
	 8gc9esBn2NM5CJ6c+XmHXAeq018QsYls0PqZAWftuB8E+D1BJ3lzNPMBBHus01EitA
	 yHaQJeOXigJlJYANOS70kHWQFawRWzvBrKbuTNC8S71WbHRGEk1IfIpBp5grsDiqGo
	 BP3n3eU4f4VgA==
Date: Thu, 20 Nov 2025 12:03:12 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
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
	linux-hardening@vger.kernel.org, Nicolin Chen <nicolinc@nvidia.com>,
	Alex Mastro <amastro@fb.com>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v9 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <20251120100312.GV18335@unreal>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-6-d7f71607f371@nvidia.com>
 <57b8876f-1399-4e4d-a44b-1177787aa17d@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57b8876f-1399-4e4d-a44b-1177787aa17d@amd.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A0E5CA000E
X-Stat-Signature: jrc48uya5j9xh4yugrdksisfz8761umo
X-Rspam-User: 
X-HE-Tag: 1763632998-2913
X-HE-Meta: U2FsdGVkX19BRpw9FgrMM/Nm/blB3pVMPtz0Wsu0Xj16vUamXMMwByRV1Gh8idWgLr2JmU2ZiKpWMw7BiyPLKXgCMwh5PTOBQbB4OeLwRND6mPlsqwZukzoSKzI9xbEkx58tukC4HL4cCsCsxBdNLQ37zte4H2exrxEvS9iCSBh9yXojpTZbO1ZFgVMU3fXlVi0GQ43Ip/yASSImpNKeQX+IflBJFNaNR0E1y2JLaEbWRqiY5GnJpXKIu1qJzTwkDURBMrjbmYyHu0Gh9NgQ70QHY3gXA39QCJZqEncegHGZXxS1wSl/K0dHOqQeYbNuDRnQsxtCClqa+b8ybvSPK1WUPGgEp+AKtpEkB+4hUE5/7GV7u1u3nZzBagk7HskQquB/Bu5snps9+BLI2zYMlCP50dZU03sEZ0zQdYOaqGQBm3SZZ52Dc56ti4rvOFHDQuMSJd/gZYLuQQfc5TjFRJdDv/+Xp7297tigx2SqKUSTVeR2gKzBzOZUzTJGrxhcg40xOAJ6PTB/t7b6KpLbSAqTxL4sEOdvQuX53yqEapFtu/dg9zfScgz38sG71AcOOxE4IWlJKbYSzp1bnPk8Cdjv567Nsv+oplmk+Dj46FkMSkDQ5k44qw8RrvTmjol6m+0pH6hByP1Qk1FncPlO6+0yhtl9NPx6TkAXhwb6PZsmIvR8T4GYBSLjhZ9GLXqQvgBUix5QlHoYiFjWpjtZq7feAh2u1GGHlxWeJjsSw7lTDq3bPUOYH2UMLfzFJTkzw0L4rMLrRXZDunB+4u2VQUruLjurPKqg5Tx4SFJTwy9ctRCQVqkVpT4LRpGZ6QhHZAB+BRzv96RHfydWKDV1RX5KEHLUu/n1fwFHEKJN6uQcVxebfqNgID4rSA9dcMPhec7WKCIV73lQ5zs2vlv4H81PKIXcXzLld47ro4rHON9WWkvYNjNoFHQ/00W7Z6wt1e13VUPgRezIQjt2kOB
 LpyG8cC4
 2wzK7Sj8e2mB7PAoMsMJivIp7xtQB7xL1BOdIctEhFXIaJ95oFSbpu77Gje46Gi5xS9tmVylKJ97gAJzxUtvqzRHMi3NwPwfoWcv4s763LyCTDaBtvQneBHTo1r00q7w9ACvDB0Itus9GQlBuuXamXDZvCSmSJEqjNSuBv6BrH95VML8A+0g5C6uTpZWpk5/t6GvGvl4XonU+rIsXyV4ljC/jPLxGNEvuMO89+OFLNzdZ14DR4ML22IAIQzcKJ9vBUTTxP4oDNjDTvLlVbJI1RNRinjN7RuLNhpLHseB+MJK1GRY6M788Wyw09stjhiL/HOaiZtpbd0ugwXHMxe7B4RJfGYlqNZTv7PjXmRQ9okYeE9zfWyjEQ8dQp2EmAKK+EztCiLnmsmP4V0c6BbLpY2zMwMD5matAWEKo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:33:36AM +0100, Christian König wrote:
> On 11/20/25 10:28, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Add dma_buf_phys_vec_to_sgt() and dma_buf_free_sgt() helpers to convert
> > an array of MMIO physical address ranges into scatter-gather tables with
> > proper DMA mapping.

<...>

> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Tested-by: Alex Mastro <amastro@fb.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Could be that this will backfire at some point, but I think we will never know without trying.
> 
> Acked-by: Christian König <christian.koenig@amd.com>

Thanks a lot.

