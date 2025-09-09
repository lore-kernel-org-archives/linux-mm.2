Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A09E3CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8AD78E001A; Tue,  9 Sep 2025 09:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35288E000F; Tue,  9 Sep 2025 09:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B448E001A; Tue,  9 Sep 2025 09:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD3308E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:29:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82B901DEA96
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:29:04 +0000 (UTC)
X-FDA: 83869792608.22.BF92600
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0DF4100014
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:29:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yn9O7EXt;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wq5tVW5DvJDE81W0cJJf75vfvzKk8m83klZ2MPhgbjo=;
	b=AZt9nWAYHMEJI/P2THiHMXAXJMvPSwJVGQwMzhqBcivO5pvaHPbj8Vth9+zVQ22h0JqdHl
	P2N2DimhTcuef6eyPSMW3vaZ7E4v3ZAKM/llug+trjtjCvWH2SoMkXBcQ0dJPTyZS3l7WP
	loyoi7zpqpCQ93FRVWy3G8b17V9oQtg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yn9O7EXt;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424542; a=rsa-sha256;
	cv=none;
	b=LQ4GV6Kpn5PV6RwH1S6AaVrla8YSxFIlJFpKUeesk4aEvVsMT5aArHalEY7B1QJhRlsg35
	8odXV2ZR2XWfoe04Jz2HL2crp4l7Hgn/PJadtGwBFVrr/R/jhl7LrAPFdlN+niZjV7tpqA
	ancN1CTaktOIgl+3Wy6c1qmA7Tk9REo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C5B360230;
	Tue,  9 Sep 2025 13:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA0AC4CEFB;
	Tue,  9 Sep 2025 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424542;
	bh=OcM9fkdXGiKETEVH8cBKggBd8afyqoLB0RolB6LyNkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yn9O7EXt2i8TlTaF6Sd1iT2ojuajj2KIE2jrl5UhotsRQnaPwquEa2I6cD/7jlt78
	 XzUOKFVinPt3koMpplOVHfrrycPx1YW4URaCTEj9GV17QqK1Icqmm24uElNn4aNE6g
	 dyEXXglk755dAMizt1Low/9xHQbk9wGW/sAxTH/ig1Nx27Rmc511QRKeXmuB4uajDS
	 ry3EbwT8QF9bfs0VlcNQJBaOrGGd32GVtmtPUIlyAl6AFO5fHanUGGe7YyTbMEnZUk
	 af3JTensL0djx/ZctZdYrUUhgTz59dgEpyExsvDCG5MthdUQLFpoXIVWvYnKwiOkhb
	 czV9UQ2BdYnEw==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v6 09/16] dma-mapping: implement DMA_ATTR_MMIO for dma_(un)map_page_attrs()
Date: Tue,  9 Sep 2025 16:27:37 +0300
Message-ID: <3660e2c78ea409d6c483a215858fb3af52cd0ed3.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E0DF4100014
X-Stat-Signature: ocumnpgsp97xnjwojxhpwgikyjhguhyx
X-HE-Tag: 1757424542-52401
X-HE-Meta: U2FsdGVkX1/9ktEyS3MKb2k7iRe+YDJTBSdoscuxb9FwqYdmSDEcHklb3sBfzv05vIHQURGL1JMmb2vGuJT363cEQprr9TG+A5WWnowzuNg+83MrgwxgNgvmJ6SbOosdfco8m7fGTtwgYtf4p5Le/enOZWWnxH7LUTQNBpWDXgsyUgkdkOdrdein4oeUhm4GUsOapV9mAA+GQtlPYrBMkDfeMdpz0JOegYrWl39bpfbyv4FSnInUQQPlUlkSBixEt3IoskpUGbkNMbIC44BuXvXL10ZlXHM1sB2TgTM52FL6e+2J1J/5uFICUaxY5lIdb3JlMVNHzajRgUey3ONROYTsDx+i33AasZU/lQgT+E80Is73K47ezEldzZy4pvu7FRNeiqTGUCytbkGiFqlF7kZiloc6xnS27iVP92ioxp94LgH/3ifm8C8BUC4A+xaudLiVvSPQts4J6pO2mVoiomeYTFv9U9ucfabxKHP0wzUmi0m8hBG7JhW6Z2mMTo8KTt6Ve3x/IWmcdqIwGEXLIyHGsyPeZ9N406IjWM2BkxrRFz29b0kstaFW4GrKgzF8qdI9FeRLPaP+om4w86m6DUK+abSNdbhqVBgY/V/Ph3MsjwXY5v9BJZSt+OPqq/ApV8Xr//iDjDTsZfSOKdDqf7LEBL8pHQAbT+1qIky785tTsn4DQAafNSrX3YpjaFLKHPArb8lFamcYe777+GPnsaUeUepQi35ypUI7RL0H7MTEjc3117yTEoqMyacvX58p7izp2pZXn4+7s+RptKdIc75bxN0doHpAzRQbYGn+bf67xhV1FKkGaov70PxuaFyiV0wnJv/+dPld8nRNG1FhmLCf2owoxTpj6jLkuZbgeTiJBPLBHfxW8pDNcbQyVNQFkB50R6Og4ra1OffPr8eENvfR5akwDl/Q+iXFhAhqxNhlRQnUTYzXglLptWlEwfDKw2TeRwOpBozfhTwXlN5
 UKwaGx3N
 gt1r9b46RMACjL9DiFKil/eNr+8yuCM2C98hYcfYfBemu1cz5r8tYIxyRfsry6RKIDB5Yl9uYQo82kppLFe252FZHVWK8wXyw0aM7FFrMINojgIVeYf+Sy6Pw04UQnsb0TaUFrI++WidVyiuE4S7KO1aPYE8iLnVTuUire1LPbfOmWbobgJf9C9N19UfQgjb3wK1sl+e/CLWGvKqphVTP64ekLvidY1hyDYejY8tc2lCOgromvmt2guijxkHoyLBgfsXLjrI4rBmAE4/c21qnMtGcZqdsb3xnfWYJ5+FEMLLCjN+xKbC+EAl7dA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Make dma_map_page_attrs() and dma_map_page_attrs() respect
DMA_ATTR_MMIO.

DMA_ATR_MMIO makes the functions behave the same as
dma_(un)map_resource():
 - No swiotlb is possible
 - Legacy dma_ops arches use ops->map_resource()
 - No kmsan
 - No arch_dma_map_phys_direct()

The prior patches have made the internal functions called here
support DMA_ATTR_MMIO.

This is also preparation for turning dma_map_resource() into an inline
calling dma_map_phys(DMA_ATTR_MMIO) to consolidate the flows.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 kernel/dma/mapping.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index e47bcf7cc43d7..95eab531e2273 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -158,6 +158,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	phys_addr_t phys = page_to_phys(page) + offset;
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
 	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
@@ -166,14 +167,25 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		return DMA_MAPPING_ERROR;
 
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_map_phys_direct(dev, phys + size))
+	    (!is_mmio && arch_dma_map_phys_direct(dev, phys + size)))
 		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
-	else
+	else if (is_mmio) {
+		if (!ops->map_resource)
+			return DMA_MAPPING_ERROR;
+
+		addr = ops->map_resource(dev, phys, size, dir, attrs);
+	} else {
+		/*
+		 * The dma_ops API contract for ops->map_page() requires
+		 * kmappable memory, while ops->map_resource() does not.
+		 */
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
+	}
 
-	kmsan_handle_dma(phys, size, dir);
+	if (!is_mmio)
+		kmsan_handle_dma(phys, size, dir);
 	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
 	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
 
@@ -185,14 +197,18 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_unmap_phys_direct(dev, addr + size))
+	    (!is_mmio && arch_dma_unmap_phys_direct(dev, addr + size)))
 		dma_direct_unmap_phys(dev, addr, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		iommu_dma_unmap_phys(dev, addr, size, dir, attrs);
-	else
+	else if (is_mmio) {
+		if (ops->unmap_resource)
+			ops->unmap_resource(dev, addr, size, dir, attrs);
+	} else
 		ops->unmap_page(dev, addr, size, dir, attrs);
 	trace_dma_unmap_phys(dev, addr, size, dir, attrs);
 	debug_dma_unmap_phys(dev, addr, size, dir);
-- 
2.51.0


