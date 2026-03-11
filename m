Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D89112586B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C226B0093; Wed, 11 Mar 2026 15:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726D76B0095; Wed, 11 Mar 2026 15:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670DF6B0096; Wed, 11 Mar 2026 15:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 565B96B0093
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:09:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 261E01B798E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:19 +0000 (UTC)
X-FDA: 84534720438.01.FE09676
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4F922160006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hfT6VO/H";
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773256157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=laBjRZNGf11k23Jxquau6MMAriBquGkpYRQKz8iWRAM=;
	b=xcCiGe1UpcypDMrAptUPLVyrx+w/o8q5nphi08WE4imGM0RDnZvFLSiVYkh6zdwHoMt7Bt
	0Pktke91UsDZvqD6ZizaOoDZEOjroIHF//nDwT7cL7RUMqJOL5OeamvqgNZ54D3GcYr3yS
	xqaSbOnAMK7LVUEw/eiQUi8SZ2Kwmec=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773256157; a=rsa-sha256;
	cv=none;
	b=0el+qdRKI9jAGyrYcN9h8RjOMGDKOPhUhOiesYBjd9zW1cIiuL+jy38KAdoiMGKFF2YT5q
	DW/kVErn5DMFaiAFcWgLgEYNlZ4AH5gbYePr6pcyLzuLJFz5BT1KM22NmW2zwokZdtWyl1
	/PNIBPA/ryu7AzdUHf3euhbwrGUrYXw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hfT6VO/H";
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B19540182;
	Wed, 11 Mar 2026 19:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB91C4CEF7;
	Wed, 11 Mar 2026 19:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773256156;
	bh=aXwCdr26DGL4+NaZEE3PT+YDkt3E2yVN7za/ReeSxow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfT6VO/H2ei6g2r3v5zyGv7rxwT6gZVYEAZ3q/JxZD65/o54Se7wSvuPVHXwVG3KV
	 lGDu5gO5rDUufjp8q+LowrU3Ke5y5jS1Y0bexFfXEB3tzQzQyOOftdHqt+R8iv65vI
	 r7wvN46gsOkly1ZVrVr/Sl/g1XDPv9kDCCPnM7WliJ2076XljXXXFEhaxHnyVTNvjr
	 gfEXB4mq7aNOf4+zV1wf2x9Jz+Ri4AjvTPzWFPes3dJEnWw/e595Owg7+LvCwGscfZ
	 iT0Mis1SQnjow6HB3HyeJr9hbn/JtUUGlGfFied+XD1ozj+5qSP1XAToPA53V0fZrm
	 dZB0p85e4RYfg==
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
Subject: [PATCH v2 6/8] iommu/dma: add support for DMA_ATTR_REQUIRE_COHERENT attribute
Date: Wed, 11 Mar 2026 21:08:49 +0200
Message-ID: <20260311-dma-debug-overlap-v2-6-e00bc2ca346d@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F922160006
X-Stat-Signature: bhy788npmrjicz8tddbu1mqidbssqmfo
X-Rspam-User: 
X-HE-Tag: 1773256157-479728
X-HE-Meta: U2FsdGVkX1+xqmtLfZs98kILFXrrumauBVmxO/4t95RW4Fx7s24nestvm7ZHXfUpyudlObbMZ5/z+Dkm8EV+3gyYXJ3n2xKIbkbli4pA5XliPuK3IA7HY95lFVTyqhZ5Ry2Pi/ol7yr8R2hD/mVM9a+1A94Fbpjlc+SIiCeAzLFf0Uw6RL4P+6KgR7Sc1ss+whie5G+cKjJCvrTuocm2kKoI4I5QxXksFDVCUWm4s+iSXjkAIl6K5Sjjmz4951wPdZvvdlb7aC4IrYNBoWbqv0Og8bRfoLfPvPllt++Dib2BD+F/ijSrbVXV80MAyw/aiQJ1xO43g13iGnOEO8musBhIVRfRZpf8jy/c9s1KQHRpylhMPfmb+u5d5SS7s1i6XUU1mQn6JsYEs6HmDuUhJpgR3JsnDUdRVSoSTK2T9YlGpJy5d18LEwaLfRfTFfabiQ6WumlQ1QhCsmnimViXGjzGjTSwixKTDBIh2MXqtX9w8dg12lct7qCTz0fApRqTjlzr7kieE2TVDztWOvIwx8IP5q6rtDPz13PdHorOofm1B6l195blAKm67949QGNJjX2gOurpOc5MhJQp3NDaZl9IYDndzPdey5KqduyAWAC7wZILEr8TN7a5qDzKCHMgiDGe+xAnKWNIIbSlC3y/XDcPzIn7Q0VghZmC2J7B0Wk0tWZOYnzC14E+3b8WkfH7lhH5UqgsYbVbBRLFzLdaPD28Ez0rARUMS+a+JtHguZZhxsswhMQPhpi3sxt87hDLytItOXQovnvwljbv97g/wDWxaSZmMjHglIBETYhwH1vQ/oRhMy6h8XBggzTIib7svpijMp+f23LGOH3ynl6U32exWSeYtV6R1zMqYbJywsDcGVBWAt3LSAF1aWVT+2e7Jwj8XwnKwWMMbIVxUhzb87bzhqeM0ovoTZsCHt1SuKV/VgEHAFEZ+sLG2FJj4/7l2TgIcq5Zwkd2R9S7Ozs
 McsI1P97
 IaumXXh7/tNsj6KZ3HQ1KDUfcCfnP0R6czEfcTVRrNUXNDq1u+1nfd8DbPyvsoBYDCagMsaQ1fgQRAb9ywfjoBpHL5pINGJ93c+JFZWaaMf9Vi/2aJ/oY10Tb4MD+9PH4ecd8XnKDosAOTUoooJqnAxPeRQD8CzNMtprmPp8yYFN1eYoVpwB1HHdffR+ZwiigvvmDcOKLympxh+RGZg8iUmGV7xjtCsJ0Oyx0xgp7CYqECcJTTTVKaK8hABZ1imLv37IN
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


