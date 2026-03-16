Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C70B2F53D89
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1AC6B0356; Mon, 16 Mar 2026 15:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380856B0358; Mon, 16 Mar 2026 15:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295BE6B0359; Mon, 16 Mar 2026 15:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1706D6B0356
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:07:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEA3F160497
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:32 +0000 (UTC)
X-FDA: 84552859944.30.51C355C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id EE0224000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qShwIFNF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=laBjRZNGf11k23Jxquau6MMAriBquGkpYRQKz8iWRAM=;
	b=W0zPlF7W5fCG38y8ZO1+NroJctE4yhioD9PxJ8JGjZc0Rb+H4hGA9ZG4WP9CSjQYViJNcL
	oTmC9VXu6DHwz1sakDCgNqliop9pe+2U2N0o4CUSF+xjeiE9tsZIULz4TvjJq39JR9oVyf
	77XqHfMgyOyuuawpuYEJmwTvyGrq/Xs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qShwIFNF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773688051; a=rsa-sha256;
	cv=none;
	b=1dkZzVh4WjUAMKBYapgC91aD/PivGYoERXz2nhZnqPFZsQMWpTgjW4Bq+uXQFrozXzZlG+
	N3Nu7WhDqvzhnKgqDQANgmOC2kR9UnS5p4ZL/1M/74sp53Rz/B483uTmT9/v61sBLzs00J
	wGKzAK5pD538w6hmP3WeGlbLv09LO8A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 187FD4370E;
	Mon, 16 Mar 2026 19:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BF4C19421;
	Mon, 16 Mar 2026 19:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773688050;
	bh=aXwCdr26DGL4+NaZEE3PT+YDkt3E2yVN7za/ReeSxow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qShwIFNFGuszc3wiBhUM/dXxzghLUfqSxNk6dSgejFCa16sP7mJ0YnF6nuboDJQ0I
	 V1hdbvS1Cw4Q8UMNmIyZewdSbxL6PjFsKqY3LNx7tSYGdDqKW1taN6l2fo9mdtgC8y
	 iHvFgLqcBiNy7tYnGM7quwPT+cd6RXOSvqXFQIO3R0aHDLowDG6fgtIPenYBLlYyQi
	 8npPn1RHBtah/rBZsE9wx+ixSFiZXVoxr3c+0eLM5qx/BZ1L86QMlxbXrzlzw+5VLo
	 owZUj8Y7VbcTo2sOQlqSsHYt9BPLxuC7yd10mWvitREI5onnc8psViY7rBblB38Pad
	 i7l8YW5XaRDUA==
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
Subject: [PATCH v3 6/8] iommu/dma: add support for DMA_ATTR_REQUIRE_COHERENT attribute
Date: Mon, 16 Mar 2026 21:06:50 +0200
Message-ID: <20260316-dma-debug-overlap-v3-6-1dde90a7f08b@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EE0224000A
X-Stat-Signature: tsjpdbdzfai6j51ca51odwzxp5xmqcnf
X-Rspam-User: 
X-HE-Tag: 1773688050-197930
X-HE-Meta: U2FsdGVkX18hX4P2ULAz4xvm5OGggkiC3wTJ6snzZDIuTZXCGdNrg9niEhs7VHJgl1b6WQmEIsMZIihXTIFKN0sIB+wTadBYH6EcsYNu3iTa6XsNr66JqQ4y7fNoK9fnV37f7MZqp0NrlL1zSVQap7C9sHGTgl+sU9HqpRY/eI7e+4Ero1iZ+nkVzp/UW3E+x4Z0VBRQZHJSRjfcIdr6E4JM0wltYuFEm6hyULNV128o8KrQyQkD6XnDeAtNaMLBeWaSdBDo4AWUXpk2kQlO28lVXYNwoRWFMdCOLm8MfgvSNoaK+BFOmuVX0tU9f8Cqq9roWaSkOotheFopj7V5BjYsJeegAn3QmUUUA9WtCorn8f/WEq2tOoIhomRo5OmAHH+GUXYUElW6NCZWklJwFJCIaFOnyUlIC3jJo4xfrtnRYc/ipMKw9KN7qZb1Gc9k7A6UmhzY9Q5j3bEcZhI1JIHiQMlxoqc0AiwnGC89FosiYe/9JL8i0q8w/5XsUaKqr88HnfprTQFQPM7x4+WNyw7O7fKfQcIdFXo8O5zNuHm6/nqFlyl3bYMoDIzl9m6/UpbBpBYg4cPc/XvrewNe3LnzDOkmTFU6ZPBtOjKl8c1HxFN64yMEabHDLZM+oRIiwKsB8kgDkMnw9rIwcTra0YlDAyKD65NRtVnKiccERPwVaxqCUpNjF0GTPUMBQaYNXtoA2e096N9yP44atKWielgL133HTVw6i+dVlvWevzIbqDOeEmr7xVqqLvxZc7lSdbRXTlyI4Z0Hv+/szXVsnddXqNvo2LbCOsBN758QYiZ1VrWaJpxMAEHMMmGWdnHpUzJmExMmNnhnmVUgOt1XeRbogeXSvSqzkDNf4KQhyIj+rinJ9MTGcpkeMqYXR8Pi9JTRncDVZc3twD9cmD2zxzJjjxE9oEEUdajgOQygRbJbFqKSMQzGzr8xv6UKfthKiI95O5BZXEFcXNmiHvB
 3GndZNa+
 CvxuRkU1X0ytUfXHg43D/i/kvJmWiYydMTyoe9CtHoCbvSfMS4ztqe8dcyWTcpr2bhBOUK1E6anBY1FpeL9Z5aJ0M5GifItdv7np1kRaS3BUExhdwXfD301cVS5qICNoHlOdjzRltKISbCzbs9b/ORs5O3reaZJH0Om1+mh0Jvmq/ugg1a5xrzWE77jd1iYQtDtcYSDffurCUKUtsLgBPTaYyS9FmzyDEsP25lJvqajDABEm8M1Tdqfl56c9yQh/hVzmt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Add support for the DMA_ATTR_REQUIRE_COHERENT attribute to the exported
functions. This attribute indicates that the SWIOTLB path must not be
used and that no sync operations should be performed.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 5dac64be61bb2..94d5141696424 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1211,7 +1211,7 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 	 */
 	if (dev_use_swiotlb(dev, size, dir) &&
 	    iova_unaligned(iovad, phys, size)) {
-		if (attrs & DMA_ATTR_MMIO)
+		if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
 			return DMA_MAPPING_ERROR;
 
 		phys = iommu_dma_map_swiotlb(dev, phys, size, dir, attrs);
@@ -1223,7 +1223,8 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 		arch_sync_dma_for_device(phys, size, dir);
 
 	iova = __iommu_dma_map(dev, phys, size, prot, dma_mask);
-	if (iova == DMA_MAPPING_ERROR && !(attrs & DMA_ATTR_MMIO))
+	if (iova == DMA_MAPPING_ERROR &&
+	    !(attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT)))
 		swiotlb_tbl_unmap_single(dev, phys, size, dir, attrs);
 	return iova;
 }
@@ -1233,7 +1234,7 @@ void iommu_dma_unmap_phys(struct device *dev, dma_addr_t dma_handle,
 {
 	phys_addr_t phys;
 
-	if (attrs & DMA_ATTR_MMIO) {
+	if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT)) {
 		__iommu_dma_unmap(dev, dma_handle, size);
 		return;
 	}
@@ -1945,9 +1946,21 @@ int dma_iova_link(struct device *dev, struct dma_iova_state *state,
 	if (WARN_ON_ONCE(iova_start_pad && offset > 0))
 		return -EIO;
 
+	/*
+	 * DMA_IOVA_USE_SWIOTLB is set on state after some entry
+	 * took SWIOTLB path, which we were supposed to prevent
+	 * for DMA_ATTR_REQUIRE_COHERENT attribute.
+	 */
+	if (WARN_ON_ONCE((state->__size & DMA_IOVA_USE_SWIOTLB) &&
+			 (attrs & DMA_ATTR_REQUIRE_COHERENT)))
+		return -EOPNOTSUPP;
+
+	if (!dev_is_dma_coherent(dev) && (attrs & DMA_ATTR_REQUIRE_COHERENT))
+		return -EOPNOTSUPP;
+
 	if (dev_use_swiotlb(dev, size, dir) &&
 	    iova_unaligned(iovad, phys, size)) {
-		if (attrs & DMA_ATTR_MMIO)
+		if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
 			return -EPERM;
 
 		return iommu_dma_iova_link_swiotlb(dev, state, phys, offset,

-- 
2.53.0


