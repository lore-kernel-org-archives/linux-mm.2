Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7412CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AEAF8E0014; Tue,  2 Sep 2025 10:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DF68E0007; Tue,  2 Sep 2025 10:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125278E0014; Tue,  2 Sep 2025 10:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F30BC8E0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:49:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3DA31601E7
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:16 +0000 (UTC)
X-FDA: 83844593112.20.A31E689
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E507240003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qNA0rpdI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywULpGaIgw2EWnFsajimLiQWkrdwpqvM3asq0pAoqyU=;
	b=cD58QvEeguEHiWs7/pdiCHrXSUqdnY1owyC/iOOeuYaQjDp6ZobiFwsJo9RGgyFbswwPmM
	CbX0Zr0PtReO1lQmtPNeQrX8WZldUQfhw7jwIY0pZEpA8RgVCjcSAiX6nolB3+GPV9xSxu
	mYpjcVLzGGlO0QIimQLYLAOeOcvzdWw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qNA0rpdI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824555; a=rsa-sha256;
	cv=none;
	b=172Mx+wexN9AN9x85sBmLVdTybyRO5K/7xgsGPlCaUx6VdaDBxedAWwrc8917j3YR1b+rX
	y09ZFvwt09l67E9VCcUblLOBkA2bH27q1a/PS52zINM9rZJ+b4U14MjZZQswaN3mTcX8FN
	df7JZjZwsVq02m6m3hBSX3HxmRnA7uw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0AD744942;
	Tue,  2 Sep 2025 14:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3AAC4CEED;
	Tue,  2 Sep 2025 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824553;
	bh=bQCJOhk6/urs9rnk28jsW9huZ5BmqRf4rlNcWoQochY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNA0rpdIfDKcKY8jylpr6rIPXKRrMZ2SSvxdExkc4iYFUg9CGiS5XwAxPyEf8F+qA
	 AFogSmagV9JyRlbdhVx9tx/4ZYBW3H5JGbQk2Cby5UXJj532uQQp72RE6MsPyvuxDQ
	 uroJ+7G99RhoyzZEntv72aqyl+sgfCBGI21ScktmjfktL21+44tukkP/L5aZVh3NC5
	 iE3uMu+rgCByY9sAMLkloAREC/O3bNxIEONVHjqR+3zFFnDdxFyQ+sUuX5VXRZOo1X
	 3naF/+0zGlWHD0/zMTwdb3f5RNa+dkqF/arrZ1VZMVnkpGQYpnYYxl5o8UVINu+IDv
	 zbchkle3zvSEQ==
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
Subject: [PATCH v5 01/16] dma-mapping: introduce new DMA attribute to indicate MMIO memory
Date: Tue,  2 Sep 2025 17:48:38 +0300
Message-ID: <9cce2a2bf181edacb33151388caa47725f780907.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E507240003
X-Stat-Signature: 6n7g8sk13xfz8q6qxpxpe1wfkrj1xzhe
X-Rspam-User: 
X-HE-Tag: 1756824554-664698
X-HE-Meta: U2FsdGVkX19e18gE7K+O+jdd2z956+i8tGBFFWGysE90gjtgL9MULIf4YUolrKwO+ZOtTyyD2TgAzDwEvVD+LMVJIlQ7RdbpougVCOd5dMsUoxV6UN05pBgtpBE9I8InLpsCWxkCXC52u7pwnUZfDCkPelEilBP9Za8j1Ci6PLD8PyqW73fVrUZN4XCViVKoFO42CEHKhkpNXYRcm7dqu6kgBnXnHAg9iaZFDQ91TxMvwOn2rYPVvljJXeF+BnWw0Z6Bo0JIGLqbLpZZJdFoRKxsF6EFIIGbvsRj47oR6j3jk989HgqMRaSanX8ZelVkxw3+r1R2m8SUM115N/RHDwgOczayLN6p7ooCFW/EZtLbhaz1NXxAAnPiRHGdNSazIz/1FwlchvNHXFE55kGa6awaYwFLTu/5+AOE1vWTwAxHrgvqSIeHXrzW6LLYZ/pWPgo3Bg5E+HHaznEKs4IL1Jb6nhgwGS0waY8d5AOtxN9HNPx6/Z4owr8arl1WUDV1RvMBqlp1CEsyDgEYAEWjz4p6T0WTiUUCVEulAq4mshJYBXI+J/duy3+Ze4l+i9SjTatNa3NFq70wkfu8lySJLsLJdb/+CBocVEgxCIQA6ChwD/CjAj1XzWxenTGLeRc7U8y/aLWhRO0LmQOO+IhILiuMNH6aIP5PhcdMx6t8j9oGmJTSTbrvopsSW9sWQiOS+jaIOR1bHbyp3qIgiZ1WvebE9NNd8bSHFIwedUU4fXsMeF/I92zlLzNyt/2gKPVIaXjFOFIHbFr4moP30PxV6IN9Dg8LVnqzQeAaO4UIxSCsvdSNNFp4XePiKM01Dl33Ky3J22N+9JfyfDLx2CB9M9SB8AbkzdbW6hIvFGR4M00dlP3MDWYW0FJ0hut/Dj9JKO93p8oueHXfDyrlILLhXcG7SIAIE0M4ClYzcdpkYBS8PDhWuTPQxJOx/uCYnHPmIkJzJ89hKzjJ+ahPuSI
 7j9JOyI7
 lxp3OBAyelOFwSRySXn4EfEm6AXR+UuDEsJdpPnWoAyhpx52Ci3gdhNo0/QPnyQ7n+IDKL5X6s4zmPy4wz7xRs88tlanKr23fJ3OVWVygiMtJA0ymWoalFNRLypwHhD3o9PXj/EsdHkIdTmjuhbp9HZqQyg6PqYmVgSE0YcgiLfmJeDJJ0mnuY5TD3M282etApxy1eJ9PAZDO/PAVKck/N2XmikdPBcWSpLV4P+P+AxGmKkDjlpSfkbEtcdhBdqzkQdg6aigR0r9fhMYZKaZv0n+jgAQPWmZhEjlaZ6GGB6QDZl2knpFGQ6C+Xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

This patch introduces the DMA_ATTR_MMIO attribute to mark DMA buffers
that reside in memory-mapped I/O (MMIO) regions, such as device BARs
exposed through the host bridge, which are accessible for peer-to-peer
(P2P) DMA.

This attribute is especially useful for exporting device memory to other
devices for DMA without CPU involvement, and avoids unnecessary or
potentially detrimental CPU cache maintenance calls.

DMA_ATTR_MMIO is supposed to provide dma_map_resource() functionality
without need to call to special function and perform branching when
processing generic containers like bio_vec by the callers.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/core-api/dma-attributes.rst | 18 ++++++++++++++++++
 include/linux/dma-mapping.h               | 20 ++++++++++++++++++++
 include/trace/events/dma.h                |  3 ++-
 rust/kernel/dma.rs                        |  3 +++
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 1887d92e8e92..0bdc2be65e57 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -130,3 +130,21 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
+
+DMA_ATTR_MMIO
+-------------
+
+This attribute indicates the physical address is not normal system
+memory. It may not be used with kmap*()/phys_to_virt()/phys_to_page()
+functions, it may not be cacheable, and access using CPU load/store
+instructions may not be allowed.
+
+Usually this will be used to describe MMIO addresses, or other non-cacheable
+register addresses. When DMA mapping this sort of address we call
+the operation Peer to Peer as a one device is DMA'ing to another device.
+For PCI devices the p2pdma APIs must be used to determine if
+DMA_ATTR_MMIO is appropriate.
+
+For architectures that require cache flushing for DMA coherence
+DMA_ATTR_MMIO will not perform any cache flushing. The address
+provided must never be mapped cacheable into the CPU.
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 55c03e5fe8cb..4254fd9bdf5d 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -58,6 +58,26 @@
  */
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
+/*
+ * DMA_ATTR_MMIO - Indicates memory-mapped I/O (MMIO) region for DMA mapping
+ *
+ * This attribute indicates the physical address is not normal system
+ * memory. It may not be used with kmap*()/phys_to_virt()/phys_to_page()
+ * functions, it may not be cacheable, and access using CPU load/store
+ * instructions may not be allowed.
+ *
+ * Usually this will be used to describe MMIO addresses, or other non-cacheable
+ * register addresses. When DMA mapping this sort of address we call
+ * the operation Peer to Peer as a one device is DMA'ing to another device.
+ * For PCI devices the p2pdma APIs must be used to determine if DMA_ATTR_MMIO
+ * is appropriate.
+ *
+ * For architectures that require cache flushing for DMA coherence
+ * DMA_ATTR_MMIO will not perform any cache flushing. The address
+ * provided must never be mapped cacheable into the CPU.
+ */
+#define DMA_ATTR_MMIO		(1UL << 10)
+
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index d8ddc27b6a7c..ee90d6f1dcf3 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -31,7 +31,8 @@ TRACE_DEFINE_ENUM(DMA_NONE);
 		{ DMA_ATTR_FORCE_CONTIGUOUS, "FORCE_CONTIGUOUS" }, \
 		{ DMA_ATTR_ALLOC_SINGLE_PAGES, "ALLOC_SINGLE_PAGES" }, \
 		{ DMA_ATTR_NO_WARN, "NO_WARN" }, \
-		{ DMA_ATTR_PRIVILEGED, "PRIVILEGED" })
+		{ DMA_ATTR_PRIVILEGED, "PRIVILEGED" }, \
+		{ DMA_ATTR_MMIO, "MMIO" })
 
 DECLARE_EVENT_CLASS(dma_map,
 	TP_PROTO(struct device *dev, phys_addr_t phys_addr, dma_addr_t dma_addr,
diff --git a/rust/kernel/dma.rs b/rust/kernel/dma.rs
index 2bc8ab51ec28..61d9eed7a786 100644
--- a/rust/kernel/dma.rs
+++ b/rust/kernel/dma.rs
@@ -242,6 +242,9 @@ pub mod attrs {
     /// Indicates that the buffer is fully accessible at an elevated privilege level (and
     /// ideally inaccessible or at least read-only at lesser-privileged levels).
     pub const DMA_ATTR_PRIVILEGED: Attrs = Attrs(bindings::DMA_ATTR_PRIVILEGED);
+
+    /// Indicates that the buffer is MMIO memory.
+    pub const DMA_ATTR_MMIO: Attrs = Attrs(bindings::DMA_ATTR_MMIO);
 }
 
 /// An abstraction of the `dma_alloc_coherent` API.
-- 
2.50.1


