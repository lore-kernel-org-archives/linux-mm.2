Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7517CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 21:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227F46B0012; Tue,  2 Sep 2025 17:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8996B0022; Tue,  2 Sep 2025 17:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EFB26B0023; Tue,  2 Sep 2025 17:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F28086B0012
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:59:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94AE9119CE7
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:59:44 +0000 (UTC)
X-FDA: 83845677888.26.6FE304A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BC7D3180011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:59:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t/Eu3Rve";
	spf=pass (imf24.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756850382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxLWaOMzyFn1TCsduloGVD+a0ZYJgwe6TduwxzO1EKw=;
	b=cDFEMhYxp3p4lqxNjzn56MJavluE/7IpUO3Mk4Hi4xMJqvWSxbK3hjtksDF37O9K57N6RY
	yw9tjPRWswuuxHg+Ti0W108FYuBzgykQPbC72rnuCbK4pc4IcKvffYoZDqSKNd/FaZSXR8
	IIAujLCssNe0MbTPzlnBT6FQ605Syd8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t/Eu3Rve";
	spf=pass (imf24.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756850382; a=rsa-sha256;
	cv=none;
	b=l88AP3chHILkhz55MAKyivmTrvhekSyckETTkB9cdR6fxHfDfXi39h6b6ICqoEOWKNOfhL
	0V/PlO2B7ja0nRXF30v8pNu4ywTGWjkhpDO6+kxMZHqmavYnM8lMj45yiGulDJpShRioyy
	FfR3HuZAwZ1yppQ2AdTyo426eYBACHg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 55E3F405D0;
	Tue,  2 Sep 2025 21:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15CEC4CEED;
	Tue,  2 Sep 2025 21:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756850381;
	bh=zUOixGI5e23gDVx/zmq/5QWAYGpvZZ1gzj0irhRA2AU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t/Eu3RveeWFJ7QPQZS0HMJnJ18RJisbVk4Pk4B2mkUogsXCsDnOh5nmkT6QJ4KkpV
	 WAD5v3cszsJls2vJneW0RL/RKpho+ZzAZhFpATDVsn7wwLvJDFu6zSx6RUEKSctSsY
	 MYZrvd5dFbrPEZmkILy8ZxDbNlA6Ej38GRHuRquE0I86IxDtV1kdU0Sm1EDnwtGqEF
	 c1keYzFalxZPfGjORlUbEIAtFrtMdhOixv+lPDaKzXO5a+aOyNEdMKgtKZcG+wqmef
	 IRgJjgP6zlr77O2RCDhrfy6xxK73ZGX0o3JyM4rB09vZuyTewz4+/r6JUDL31Kg2Mp
	 O1zPH9rjxq5Aw==
Date: Tue, 2 Sep 2025 15:59:37 -0600
From: Keith Busch <kbusch@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 14/16] block-dma: migrate to dma_map_phys instead of
 map_page
Message-ID: <aLdoyWevrQMQUGyz@kbusch-mbp>
References: <cover.1755624249.git.leon@kernel.org>
 <CGME20250819173845eucas1p221cd6842839f5e7130f131cd341df566@eucas1p2.samsung.com>
 <22b824931bc8ba090979ab902e4c1c2ec8327b65.1755624249.git.leon@kernel.org>
 <2d8e67b2-4ab2-4c1f-9ef3-470810f99d07@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d8e67b2-4ab2-4c1f-9ef3-470810f99d07@samsung.com>
X-Stat-Signature: ogwudkxx9366co8hk46w48k8qfxebzzw
X-Rspam-User: 
X-Rspamd-Queue-Id: BC7D3180011
X-Rspamd-Server: rspam05
X-HE-Tag: 1756850382-69752
X-HE-Meta: U2FsdGVkX1/IcpORFa0cKCxqrICmoMGuSaMBBl7167K9W7TWLszQZ+wzT7Epd/DakGAQVayWjbQBf1ODVnBcxKHy/sR/e629e3kqsrI5fO/tBEucFrSKQpZFkN+vnPQYsQIXnPy3NGFuIQrD0P6Kz1Em0/pAng9xWVgZAvRm7H5iNoxLW3kXihe1GTEJuKTwnc8FVNHXrHW9TGzjLRtteWdT5OtXudmReYhktE9uLXBX3lvj6ASjygMHYdPbDyzZxzFv76ZKBOvqsmfwzFc/ISoqvNd39/AO4zdljvPBlKl5rTP5w8y1bgzxZHLtkF3T9RccCme+w2h4YimeAuQIhjm12y50+hxQEljZ0VmdWBRjmTdE70iMxQuuqBydRRS6VaWiHZtE3M1wp3/UU7KuOrHWZ+OQQpZ6V4XHSgKQVihJn0Vkq46XIZ40AjSH0PsA0/zqOLKegf8UZ9lY+24xDqlfFkQKuVzkTzVo17giK02wz9MiWmopNKTvVmUhKc/aoOWGvXfEcG/UXYqjo3dwk8HRL3GRYhGLVn0zv4jipeQiWLRCsTUTIQRm6Kcrn6ZaFuCe4wtWGZwMOs7rugtzhhuTYwpzp9u6Nmjy8nhJ2rBwac0U7KDoJ8iQZB6F4wjdweFVpViqVzOhmRrWT8dqpbAOwGfl3voMK7n2+pYB8nHCVNPqiCAqlUDUl+LYE+kqGW0VkERT7IWCffpmWrTxbM2v+AlN6X60pWm8QKBHVcU4a4YV9JwFvrO1e7YLI5H/zoKiXMGwsKsov+LmccBmxxTtYrf+B0vBm9HTmX7olATYBiHtfD2uInwdz6DL7MtSGJUMtp4zZusjyYnrfHSAW80K9O3VsyXNelxExlthHnPXAuDsf42LTsAasvOOBkzUlhip5ZFvVkMAknqY0q+cjF1S8OKkX+Um7O3FKWQWFJOXZFvRyKytguWQNPdwpql0Sp+HTW2xEzpT9CO23Rf
 hbo81tJ/
 peuZb7rWZSbGlz6hjYv7PHJJP/W4SJs5zFzKkbinmB2X1PqfJf5GOLYb7FfZim1RN2Dj7FDLDz01cLDeuNcionydxO3Wh2O+NC6lBFm5fRWRFNvssI5FTzz/mZUNBPP9pJYDtxU69pEVz+0q8XqVetruyEA+EtgK/KvONisXcvnyPHWqZsTfjnVkPEOKzOIBN1H/simJOsUq1V2H1N74yCLa/oraJ//ZwGfCWKN5aQPWxt7ZG63tE6aPvCBjisWARRoMQpwGS3npj0kL14xSG8A/4BR21bAtQP1j0O1kCdLLv4d06j1xCqKOEAiePXRNYHpMIzQIQb0WPdMUXjNRQLM/x1C4lCjbTpI7Om8wz5k+ZCh+E+k3Bfqhw8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 10:49:48PM +0200, Marek Szyprowski wrote:
> On 19.08.2025 19:36, Leon Romanovsky wrote:
> > @@ -87,8 +87,8 @@ static bool blk_dma_map_bus(struct blk_dma_iter *iter, struct phys_vec *vec)
> >   static bool blk_dma_map_direct(struct request *req, struct device *dma_dev,
> >   		struct blk_dma_iter *iter, struct phys_vec *vec)
> >   {
> > -	iter->addr = dma_map_page(dma_dev, phys_to_page(vec->paddr),
> > -			offset_in_page(vec->paddr), vec->len, rq_dma_dir(req));
> > +	iter->addr = dma_map_phys(dma_dev, vec->paddr, vec->len,
> > +			rq_dma_dir(req), 0);
> >   	if (dma_mapping_error(dma_dev, iter->addr)) {
> >   		iter->status = BLK_STS_RESOURCE;
> >   		return false;
> 
> I wonder where is the corresponding dma_unmap_page() call and its change 
> to dma_unmap_phys()...

You can't do that in the generic layer, so it's up to the caller. The
dma addrs that blk_dma_iter yield are used in a caller specific
structure. For example, for NVMe, it goes into an NVMe PRP. The generic
layer doesn't know what that is, so the driver has to provide the
unmapping.

