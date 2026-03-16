Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E7EF53D8B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C99396B035A; Mon, 16 Mar 2026 15:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C812C6B035C; Mon, 16 Mar 2026 15:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A416B035D; Mon, 16 Mar 2026 15:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A91B96B035A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:07:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82B12B97B0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:42 +0000 (UTC)
X-FDA: 84552860364.12.EEC826A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BB48F8000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GCGCn64m;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UafEZ6igwxAwqfrSBWBNYof3ZEC7kWBAMoSN0QyaFN8=;
	b=Eg8K+cv5khBYx7j8RxLOivn2bvDQfAAAuk48Iu3xGXYBf8hCZ+qqOP4kJ5hIXRnxyYGQyk
	fIwcXd3w0L0n5CVSDMJpqlj5bNpY5KTRv0YT6hHDY91bzFQ0T7/9REyGgcSJdnMAaAAgP4
	rrpQlBkdWwdlqm1E13vOZ/g3GDoT5is=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773688060; a=rsa-sha256;
	cv=none;
	b=4MI2MFLzWFyED+mLed+Rv3nyqhiOxK9dRKI4dVqVO7WSEynfhCw5jjoDewya7+4BeUQTeb
	RbsKi42+cuKd/7iK42PpJKPJjDCApnm5s0nt7bf18AUGlnwunR/2FB1Tl6o43iyWsOIrXK
	fSnwDuxWkuZrmN6hx80T5PpU/NJc4jM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GCGCn64m;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF3B743FFB;
	Mon, 16 Mar 2026 19:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17F4C2BC87;
	Mon, 16 Mar 2026 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773688059;
	bh=8pwuaCiDUSCBcuJ0n9V3xnzMZmgOorpLbuob290/9q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCGCn64m17HUEqXK/h5IorRImzMcDPJU0tCmJDbB3L4vZKoJ0IPFeBCRy+wsuVOsq
	 QdLTqB+gMICogw/16bSnE5fKFrNacTDn0dgvpd9diHLoKz+MPcFcA3Moa3f7VJeLjJ
	 1ej0Ud0wWhcmuYammtYQZHu2U6ujMP2SzDcIO/KtqJUu3zi2ahSbrZoMmCZZRQkJ0r
	 G8Hmu6p0/RxKO0n5ZlwCOD7NB007g+yepdwOdggQWqPLaCSyWzx36KVZ7tV6Qx3o/c
	 VUo3XtlNgXCcmPathZVid/O+mA8txRCpS7WCOQ9I3ZLhHxZyH7AYAGU+Kep7Jz77mP
	 /gXA1Yq4XBbOA==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 5/8] dma-direct: prevent SWIOTLB path when DMA_ATTR_REQUIRE_COHERENT is set
Date: Mon, 16 Mar 2026 21:06:49 +0200
Message-ID: <20260316-dma-debug-overlap-v3-5-1dde90a7f08b@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB48F8000E
X-Stat-Signature: n7po8o7t814i9sqw19ieecjnzbsnj9i7
X-HE-Tag: 1773688060-136873
X-HE-Meta: U2FsdGVkX199qtOFk3XRZPwFAq2jD4zl/8ZZ/k05krBXPznTVP5cEYeePcmpsHYHF9y/6OvsBBqCZ3AqBvquNLODLJ1+S/5bseaUu0PtOLM5ONf6n1+h55xwk1T+5lXUpEsWUdzPNWlEJ4lN8RqcTHwzAHypm9qS3YbzB/U+jmce2mxK+RyWsygHPeQDl+4F+0pL9ZEUEaefjYgYTuYH8Bel5pBreZCodx3iPsYXMkr2XS8UK1TXPMToHYL1b1hz/aVqp2yjT7P/IuumfhC1fRNczdSu9nIwR5E5cL5KpQFJOPkmPS61+MCH4HuOoMmKEWdXjA8fsRdv633ectTcxmVVgs08gJEZLOU8CE9G+e6Uf9IgjsQmLmO9GvvzLrQwd3RX6qmrykCfQT4mU3tiKpWKDIRZB9LCjl8KG4Nx6QcbYZ6TGsskLVyuRWrpj4aOsJ/LrvzAkH4pdvu5m4xKABchjQaQY0s28y9gwUbdBmwKZBUHQCx2tSMPxCEFd+TFwrF/7XeflUjPBmxqvZE8FRxdTXmN6aKBS/Rm3NQ7Dr7EFM/KF1OZkFL4o0E0cWvUkyzRcl6EdAKCVtlWYK0aH0j8s3y2JXc8BeoReP0ovMS/yJ5Fek/TEK/DaVnH0BjMqpajrjWCeYpUHrieASbmMBZb9EMj/OCXxzoiUKqsihr+bJSIdXI1U/nEdx7BHEeyaDk6qH1R3yGiYbccUIcASVnRfeZC9VPn/q1w1a7jtoKy2N2E3D44J+kMlGKTjIJdUtvHGANxLzlALNUR+Ll4KVsYkoSfUeu/PAfaXy6PRrxrug67rKJ9ylQSYRQmRNdK/99cKCA4fhsMP99QHqt43nBBXgV44y0pyapI9Hu4nZXLIcuWEld5BShs5AZ+V88nMYK3dxkWRq3XR2zdwhmUvHlZevOMQhAEOwKjwrQtKhhck/yeFs7P/GZbQLlYqu+sxXYhZCpXeSColl232hR
 6kNKtLgz
 RVwjA2NczQjhsUMbOUs1vifkakm2NmFio1Hp5N2AIBD6SqR94DVjn+aKJClYFlZ/ElyuTW3m4t8eP1ZUqSSy3uFl+AOeO6eo5WN8hvApWmiijuvt21iZ90JfLUOUp94x7R1e0Npl96plQdnHmTC9Iay+aq4GbfL0bU3dzl/uAVQVnEXxarp23TJRnfqicibdA9rQExyutXLIdmEogHu/WTRSsEM3pVG2Q8jYK4VBzgYro4Lhzh3xtexcUVBrxVpD8Vk79
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

DMA_ATTR_REQUIRE_COHERENT indicates that SWIOTLB must not be used.
Ensure the SWIOTLB path is declined whenever the DMA direct path is
selected.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 kernel/dma/direct.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
index e89f175e9c2d0..6184ff303f080 100644
--- a/kernel/dma/direct.h
+++ b/kernel/dma/direct.h
@@ -84,7 +84,7 @@ static inline dma_addr_t dma_direct_map_phys(struct device *dev,
 	dma_addr_t dma_addr;
 
 	if (is_swiotlb_force_bounce(dev)) {
-		if (attrs & DMA_ATTR_MMIO)
+		if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
 			return DMA_MAPPING_ERROR;
 
 		return swiotlb_map(dev, phys, size, dir, attrs);
@@ -98,7 +98,8 @@ static inline dma_addr_t dma_direct_map_phys(struct device *dev,
 		dma_addr = phys_to_dma(dev, phys);
 		if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
 		    dma_kmalloc_needs_bounce(dev, size, dir)) {
-			if (is_swiotlb_active(dev))
+			if (is_swiotlb_active(dev) &&
+			    !(attrs & DMA_ATTR_REQUIRE_COHERENT))
 				return swiotlb_map(dev, phys, size, dir, attrs);
 
 			goto err_overflow;
@@ -123,7 +124,7 @@ static inline void dma_direct_unmap_phys(struct device *dev, dma_addr_t addr,
 {
 	phys_addr_t phys;
 
-	if (attrs & DMA_ATTR_MMIO)
+	if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
 		/* nothing to do: uncached and no swiotlb */
 		return;
 

-- 
2.53.0


