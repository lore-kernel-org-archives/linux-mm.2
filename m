Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A43C87FD1
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5A36B00AF; Mon,  4 Aug 2025 08:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD656B00B0; Mon,  4 Aug 2025 08:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99CA96B00B1; Mon,  4 Aug 2025 08:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8777D6B00AF
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:43:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 594771402A8
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:57 +0000 (UTC)
X-FDA: 83739042114.03.138E322
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf04.hostedemail.com (Postfix) with ESMTP id CE22040003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ihw3Mu90;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311435; a=rsa-sha256;
	cv=none;
	b=snzxMQJ+zOjGIIeC3Js8/+N0xqdKI4fE58BFWGPDsolskK3vi0FFmfe6x0TOoHftWIZOV5
	exZ0S8pVZzqCGaYs8F21DLCX1jaeGoEo6isbvBOcBvXy04vUyRhupM6G74uDerogokaaUL
	dM7WAFRiac+yCKFY1WmPu9qKgbIX0iU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ihw3Mu90;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HioLDHG809Vrmu++exqw36yATpmFSDSvFtTDDJtgR8=;
	b=VqnakMHn5SBIsG31cY05fBsWexnojeTAJLgz34+gsjy9ub7jBYqq+uUVAd0cHt21Q6uJQn
	GqB4n7seAiCE4CRJ+qnrRypJNQiQW8d9qrJv9d6hqAyfKiLzQTB9RHmJH8WLPGJJ3GGUro
	755SagE2cPzwBN1VwX1N97AAj2ffT2Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 52057A55826;
	Mon,  4 Aug 2025 12:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EBCC4CEF0;
	Mon,  4 Aug 2025 12:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311435;
	bh=j/IXC/mk0CucPDkDZSOLBQ/UHxOlDcVl+SoZNP0e+X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihw3Mu90j8p2iuP5oqZQ0qRYRAR/2eX9T50SB8VLM/IpeY+W5wW61GhW3av4wc29C
	 5rQPXs1M+s6jjy1+nIw6SWxZuIavX26CaEl38gSuxVMHKz9Ozga++BdX/JbT+AreaD
	 thi1puaSRP5nUcta2FCkabbmnkHrUDPmtBsN8oUFKF0vUAnM1ZHd3jM+br9WjySLQ8
	 NTL3Vo53fSv59+EK2VgBP0cZFK4osZ7IM6oRQqchl8AnWygksQAVNXy453HYzPo2QW
	 I3SOs53kRy1kdIAph2yeNZ5VK6beeqdsIxQeMAXinFMWTJElchVQzM+2upe9a5Me8M
	 xXtsI8WERuQcg==
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
Subject: [PATCH v1 09/16] dma-mapping: handle MMIO flow in dma_map|unmap_page
Date: Mon,  4 Aug 2025 15:42:43 +0300
Message-ID: <152745932ce4200e4baaedcc59ef45c230e47896.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE22040003
X-Stat-Signature: hm9gc9uees93dy5swo5cizoz4nukp5zu
X-Rspam-User: 
X-HE-Tag: 1754311435-698754
X-HE-Meta: U2FsdGVkX1+Xo5k/C+0TB7qun4egXS17mTPL4ATVDouHW2UD/hXlqI0JDBxqOw59+qs649LOWr8C3MBP/cyJYT1tDhnp+0U2pvOc/MQs6dUMQ6qcPvHU9x3wW2bQftomuhZGKVgzO5FW02z60NMXyOBT0ZrHvl/cr1D0Zidat6hMZSkVS7s6JUjW+BT9wciVLt3Ij/ZQ67js/ROVSwRAm2TYMtVVWgG8fQZdpQrGkUdsmAtK8kLLzDSg3ygsx7o1CNo01PBhYp++69+aB/K2rQgRGVilZE9NpWwnPn+WjIvZjGq8CCcVeSCTJQPIXmlSGml/JJdWCfiKVtJRJiHJCd2uVmhs4KLr5YQ5hz9naNuR7BB55PObFfwl4azMqTBC0aEbfwErZi92eGXCi3YsBih3vNoQylO08Qn9b2tMEUyJeux5l+boJhHlH91UN0iX2BlqceS/BamZcmowHFbBgiBw14tXg1VLV0TEFVmJxbGoWB0/XBRAt5nKNHc8iWXM1bz912CdQtCioYW1ca9pT1+7WYlSM5Eoed/6+Lkz9uiG1j5N6uqtFqEDCA31T1lqMi20urQT9YjFP6aMzA5Pkrv6o5tDL+snlrLPJZvPWu4vVIeyVATycl3h5VffyhTGOc0X8LI/pM5VDo7TGoRVYjmy6d4vvhDvLhPy22xydcFSt+P91v3XaHW/33GjGuZJ2jUxxhTtV4UNoljgED1CT34blRQyvD5DRcSIaKr5lcvCqOXFLWy6lThRl8tcELdIsYABj3JENXTbwOPbAw/U92xkiqJoZpxlfChzstpu0HYWDdYxi5IKn0Nk5CWlqHISxtsjom9MzSzhAqg29Nk+38XAAtuZOrIr3y3uTH7jgzRBRerk3JLVyuI/h63Ppf4io+VOhiDDIfOB0a5WmqIWnibbfebWsBZ5B7Mcn6xUOxvR0pgAqR9sjNMgpu5lAUrAh3wq3x0AQEuIqAtHUxq
 Oc1EeIcL
 8K7+K3pNFJ+ks4z06OHD/KkzasDTdLqcQfDxH0kSf6mwSWQ0Mij3uICOb3KmU5x7sEwRydvkFEov+QEA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Extend base DMA page API to handle MMIO flow.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 kernel/dma/mapping.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 709405d46b2b4..f5f051737e556 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -158,6 +158,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	phys_addr_t phys = page_to_phys(page) + offset;
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
 	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
@@ -166,12 +167,23 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
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
+		 * All platforms which implement .map_page() don't support
+		 * non-struct page backed addresses.
+		 */
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
+	}
+
 	kmsan_handle_dma(phys, size, dir);
 	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
 	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
@@ -184,14 +196,18 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
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
2.50.1


