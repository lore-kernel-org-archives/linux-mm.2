Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73306CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C896A8E0018; Tue,  9 Sep 2025 09:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A8E8E000F; Tue,  9 Sep 2025 09:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00988E0018; Tue,  9 Sep 2025 09:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD928E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:28:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66D5A11A1E4
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:55 +0000 (UTC)
X-FDA: 83869792230.16.EF2987F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id EB2E780015
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mpt2hgsJ;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP4fy7+D7H5hdZTwc3EviaXgpCbdOnzec/g9AJ9Vncs=;
	b=mZVGKMCu1Q/Ky3gO9BCNsQNGHxk2Pl/LpYfMiMxqG/yEwngDTi2rn0tvkAQ5hZ8JSSjcG3
	shkqSssYjX8irJuvvUyLFLjkWjN28DFUzlQ7+FDph3Pamv6BqCIQweSw3xh9yU7ox4igHR
	te4V7IK9KBDNh7e38kO60dMLjIkmln8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424534; a=rsa-sha256;
	cv=none;
	b=Arjk4KntLTdqb7M8vAdFjS2buHwUduoSZzJtggHQ3Qr6A5BJEftArXBRXmjQECKBIbraiQ
	MkXicyuVCAsCaoYhXBK7NJ7eQBYQrbSDgvxL5WtlYkw2JPLLGuFLvch2XhHhOfj205+rY0
	iKZOjPAa1k+VdkW3PJxZODUi/ab9aYY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mpt2hgsJ;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 616B6601AB;
	Tue,  9 Sep 2025 13:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849B1C4CEFB;
	Tue,  9 Sep 2025 13:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424533;
	bh=7uEF0lKa6/2PTd5roUeWZMSJr/PVEy6yTszu34DH254=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mpt2hgsJQLyoPhqjQriUYwGxGpWOvhlRgZACUtJZjHzMze/5G5TKeJL+AIhpyHxHM
	 vtE7nDo43ohKMBF9jSzvLXexcmcqvZC/y3uNm14s8yMrtQUg4js6SK/BCrc9vovOvy
	 m+/ZwBtY3Q1G+3xu+k84+QsJ/t1V9cxoPLxU52E20FJDPGZnEBXHN59+tO8YeP9uQZ
	 6cc03DpD9wq/4u9y1z6U4q62L+IvJgAhPZxl9KlxwRXT+EJ6mm07Qgk8GBpvwvcFFE
	 HITZ7A5WwXv0OciZ4Op8uJ/UR8Zev+4BsP82OybASTk3DMWQh9knb+FPHYLwK64zVG
	 XT3P1zTpAz7tA==
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
Subject: [PATCH v6 10/16] xen: swiotlb: Open code map_resource callback
Date: Tue,  9 Sep 2025 16:27:38 +0300
Message-ID: <e9c66a92e818f416875441b6711963f9782dbbeb.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB2E780015
X-Stat-Signature: kcu8arqsowdmnbyjxkxtjgdj3ppzf17s
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757424533-691193
X-HE-Meta: U2FsdGVkX192bZGt8MRwLpg9/fC/hB7fuvTHOZt7Oabl4JV5ne3cDjEXtiWJIjqZw29twg11cNPw81CJX43NEEu11qf7DiKdaxlOTSkujZ2drvYsU3dvVECrRg1/ZtdlFJ+vQ/8QFDYqxl+peAuAVPMnAFEgDPMve+bE/jYWFkLCdnCQUEOXTdITFDntnH1uNGKXiaEpKqNnnPyz/mE0+CKED6GdwWCtp7/N/OzoIrZuFOYK9sLcb6WXX15aeqOibIVVACxMuOhztVTF2qCjZ5TXR0SKeBQ6U48YyEwaf9pI65pn2BlhGg7R16aQUDNO9zn91ghwfQI/f/0ieOZWMrDtRoYA7F/De5v6ELhpHMpl4j7YTfEFaxjbmEM1edoBUfpO0ZHsfmx9qbyd5mxcSb6TnJ2SghveG48VDfOjBXTNN5KZLHF0dZq3UnPJfxwMexZxtwgQzk6kI49s2hMSsUYiVUT8X6VWWDwV4tXqmcmdEXVlbZGnVvn6NYzKb0KAacDQl8iU+dhwvRFWxFBhpGsBbozuTQdXC+WqYkXgJEmZiYmJJuhnARuhQIKVT/zAZMCj7w/azlztI+TtuUnmuIPIPaC3lm/1YtX2thfg5GUxiKLuT2GVg0gaSKsZWx1TFLImouHQLIj6eYwkG6AUVoO5fvOkVtAoy4IbhsJ9jSnooXE1cr8E0PIpPqLQ6VJL5It4VqDIEpTa2SbNNd6sxSiDhDS/nAWZ3oDOUI0o81eItqQReYXdSZR/l7Y4gt0spMskN0l++LMcKtWUQC/NoMpJhAVD5Du4fNzRAFHKXNKJdYWFcSHGxd0GbHCiVobF1dQjNi5s1QxUcEf1HdBSpeXGNwXnhRz5mpup43WAsBUtOKz2OT33OzATQrV9SVMD7T3WdzA1RqFv0Q11e/Nf00ztp8ZszJD3o6FL6VtvEsX4WbKJTw4Ib6VAHZ/ARDhTSqAwPKq8XOSj5QnjI+x
 RXdCrgPh
 rlMTUglK+VGCiFajaLEFkHepdd8s+SDJ1F2Dv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

General dma_direct_map_resource() is going to be removed
in next patch, so simply open-code it in xen driver.

Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/xen/swiotlb-xen.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index da1a7d3d377cf..dd7747a2de879 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -392,6 +392,25 @@ xen_swiotlb_sync_sg_for_device(struct device *dev, struct scatterlist *sgl,
 	}
 }
 
+static dma_addr_t xen_swiotlb_direct_map_resource(struct device *dev,
+						  phys_addr_t paddr,
+						  size_t size,
+						  enum dma_data_direction dir,
+						  unsigned long attrs)
+{
+	dma_addr_t dma_addr = paddr;
+
+	if (unlikely(!dma_capable(dev, dma_addr, size, false))) {
+		dev_err_once(dev,
+			     "DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
+			     &dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
+		WARN_ON_ONCE(1);
+		return DMA_MAPPING_ERROR;
+	}
+
+	return dma_addr;
+}
+
 /*
  * Return whether the given device DMA address mask can be supported
  * properly.  For example, if your device can only drive the low 24-bits
@@ -426,5 +445,5 @@ const struct dma_map_ops xen_swiotlb_dma_ops = {
 	.alloc_pages_op = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
 	.max_mapping_size = swiotlb_max_mapping_size,
-	.map_resource = dma_direct_map_resource,
+	.map_resource = xen_swiotlb_direct_map_resource,
 };
-- 
2.51.0


