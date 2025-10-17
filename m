Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE63CCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 06:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E318E0021; Fri, 17 Oct 2025 02:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E378E0002; Fri, 17 Oct 2025 02:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B7E8E0021; Fri, 17 Oct 2025 02:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 388868E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 02:33:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D6C7487820
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:33:05 +0000 (UTC)
X-FDA: 84006638730.08.FECDA70
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3E1F1160008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:33:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=y2DGVXXj
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760682784; a=rsa-sha256;
	cv=none;
	b=71RgEZz5ea/L4A2CHoKPKu5BUqdsyqcbFgeC35BwO6/BYvvgCTqTCVOfGYf4QzF8wOH14o
	LlLJcn5A0swGIfc7/T1MyfJcUKpwtCjqO6iGxJFe35OH46SOpVyqT/kxSX4U4QPR16bqfB
	fbryP9NkeQOcC6OS3bN/nEkzjq3e10o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=y2DGVXXj;
	spf=none (imf08.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760682784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2HbwcCwjmYp1QGR0urHVDj2pfFgr7Dpd/IflvweDe8=;
	b=ivIvWXbQgfhdvfgrRNLygj/6mWud9taSsE5zqH7Ae/DbQJ9/XpdpI+9ItUhOZYMo4i+k8s
	Jk+NV9DACMwwKtEULGNae/ba7V6xJY6h3VizPXIG3bquSwigOKLi69nIOwdRJU5Envsjzt
	VWMqNXOExqwiQOiJ32LB4hxNH6w6ZnY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O2HbwcCwjmYp1QGR0urHVDj2pfFgr7Dpd/IflvweDe8=; b=y2DGVXXj0gpAtl2JNiI0w2GeuJ
	D1MzfQ+neLIkx+kckzYv7LwBjazQ62k+27hf5aNq+BlsUF+U8aHjBXt6zOJGu16zjHVGqRTPkdEEu
	J7J3oxXPx7EUhsK032alUNCWg15Qwx/73jcXzZKg4A2vh3+b/+BmM8Y3/WaSGtClcHbbAxKZA9QVl
	N57R4yFKtN2xfak8y/VpsW4KtDleeQUBzzw46/Ow2fEHJvKvIJcgYTwSC2sdwQmrBfbBON84WYu8H
	FlJ6we5VWled1vCHgyMpFauWhKmZ5KagoBR1wg8YoN9Rniv8Wvqk6XIhefKXgcDZdNJQsjMes4+VQ
	1s6pAB/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9e1L-00000006nlK-0idR;
	Fri, 17 Oct 2025 06:32:59 +0000
Date: Thu, 16 Oct 2025 23:32:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 8/9] vfio/pci: Enable peer-to-peer DMA transactions by
 default
Message-ID: <aPHjG2PS5DVgcG93@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: smzm6meuxmh4zjp63muu9mn7tkoiu1x3
X-Rspamd-Queue-Id: 3E1F1160008
X-Rspamd-Server: rspam09
X-HE-Tag: 1760682784-278202
X-HE-Meta: U2FsdGVkX1+fHOp894fo6oW9dx7/6huPwmV52bVX6uKGcXKDpXPOI5/Me7C8fc/mHdiVZl3s3wPVIxZw9XUtl9JSRUYebZCSsorAdpK8QMRLVRezhrvKCRfKQeGf00i9+MEfjx45cc5QuJNZPTHE0SbglWf6sZIy5hhExvFzEPw0UernKTJNW9SWgMqpD78IqNd8oK8ucQjxRE0NEzHrk9hySG5BdUWTrALCuW3sdS6U//v3hNdWNvy3ocOEFUsieWlIQS+yi5PhlY3VAmwjTxuPFU9KsOMSj8TpyTIOMQFzd4TWbio2i21fciTByO3gQTaz2UcouSAhebzK3yjcJS3LSl1/Wr4xTmBAcj8KqG+kczgUQ+BiBA+X5LL2s4jZ8EEAuajMtTu9rRAEBGCJlDjCoXIJrGc/GjLHmnRUbiUS7cA5rqrZClKHH4u9dgiJgQk3t1Esq09xHaQwFn43uF6PMiFB7LBZqHKkh+bsLAg3YIP2ZX7BSdtERMXreKNxfuHnHvQAeOWhIPOPptm34HXCw5FpSjPrl5+gw7Xiq7QFyexTZsVuPNaOx3x9pOJlILveJXpXtux9dwc/wVjmiSku+GyBbK6yze38uhMzEv5EPI8ru4E7xqNP0itsYEBT5GrKwnSr0KGNh/s5hRx7XOKgeYOyNmjDkYVyqPmCof2THMfwITUA+1LcYwmcdM5EfnCfU0pqJAxb4cmGboz0kVhWvBxZD/q0t5TBXJbn8FWrXdXptHqO5F42JLQRUe0UvYQEU4KnwGsF4LDggP+sz85VXDGFLrH2B2ynkmT/0phkZMXZiRglyUtTiPI5c6JBePnjcUDIqYsqhL4uJTMD9CzSg0N+aljnryuQE267RU/PudvLcI7lnC3Si5p6wYLYqP9JGiLEfCDsdoyeoymmtBBDDIi65H4smY+kHtCKDlyD7dsBLAfGqoajEuIEkOWHmMGLGZoKlCfMQrS5wSF
 jwLsPRfQ
 Ev2HjaxvFQOjFh2VGpFVcQfvBiDyP49lpAQydki8FdUQdZp4FODTRpTlJ0NeDcUabt3Yz7nNIMTHHsukhfnEzQF2Q+tBLDQgUJaJnZvqqDolwhVEfOAWBLSKP/v8N1kbmTs8eY+z7fq8o4rdh8kUz8Ag3WrgeEub50bFK958IwOGg+Jo6lSOvG452/pLJarfR4DD3ciF6zkIOJfrKHoCEbKafgLhIe1LxLFVorSZfjJHlkYVr71I64XH+sM59LJvgbLyDZvSFyH2GiRMVwaTLgMK8nAZu9p1ZUILQK/d3Q/vD9KNOVBYFCVsQ2rZJWbAFDI7rm/04bWZUmfSDMKqftdxOsGoRfXzHCVr9zH/JpmalcVJmluEZgRoJn6PJx0lCRXSprD9GwOZmM3DLp0M6k4Ei4orDn4/wwOY3xm/aXm39QcIwTTKaLf6UCKaJsz/aBB/IL+pp0O06sDw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 06:26:10PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Make sure that all VFIO PCI devices have peer-to-peer capabilities
> enables, so we would be able to export their MMIO memory through DMABUF,

How do you know that they are safe to use with P2P?


