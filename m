Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3D0C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EEA66B00A4; Mon,  4 Aug 2025 08:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F046B00A5; Mon,  4 Aug 2025 08:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5196B00A6; Mon,  4 Aug 2025 08:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3CE6B00A4
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:43:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E3E614024B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:31 +0000 (UTC)
X-FDA: 83739041022.24.CB4E7E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1193314000B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mACwCJwn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/3vSq9381IaXbqW9OZrKrqA9rxmKdWI6yV8YceURS0=;
	b=AcQx7sQVw6fl2D8MHLW1BYLWa0uCTckWYyxHUN7pdY+CM9/NUN7cdagvp1fRgpWW29/3bp
	qpIHZlFRTbxdLXfDI812Zo6PkgPJYsDYDbTilwXtdO2iF/fuuEXfsdCU7Zsdpnfouxv6NN
	WNSQPVnEm6Dnu11QuSdO0BJa1LyNi2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311410; a=rsa-sha256;
	cv=none;
	b=hEydTMJzY+zVBGY0/8gv/T0F78HfJw9mTaFjBPsTiqWFwZGOlDE4155Y4M80GIa4kD0Gqd
	wkISW4wLASKjvjJnGgT1IScN9RxNavk8nInnq0r6iIBGK7Wo8XN00x2fEnknTuO3rsxTqQ
	csFHUH6VyEf7X4g+KPyjdHvphppTA58=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mACwCJwn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28A9644938;
	Mon,  4 Aug 2025 12:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96668C4CEF8;
	Mon,  4 Aug 2025 12:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311409;
	bh=B6ggJVOQfTYMCOE/nJsgZM614saTj7Qtn55LwfqKBMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mACwCJwnciJCEbZnCrkOPhfxhxsK8nNGbFRTcuF/UprHjNhigkEBz4Qjo6q3nOYnE
	 NNEuUiRwpxiJJ+5+lJPFbBh1pz1NHdaolrAAyyFd/BDEth7WPdBMjVzrlmdIaxA3Qb
	 2RsWBm5LtpycB6Eoe6pJbVmXbTVoQjyF0BJrKzZPE5F7UARnqwUUZNfC3023xQAdCk
	 GMv+SVJ7lY8MSINtMTSQNgemwlQgadSRLsUt+7E2s6eroO/rhcn1uAVTTMaXvcyAt7
	 AFjFAFTQV2Ju8uDUJFNXpQWgxbDaQrFpkFb9ltCXITe4mMxj1t62jvARy38KRhJWAk
	 x4Lll22SY+E5Q==
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
Subject: [PATCH v1 01/16] dma-mapping: introduce new DMA attribute to indicate MMIO memory
Date: Mon,  4 Aug 2025 15:42:35 +0300
Message-ID: <f749c597980592ecc7aeb5ecca974c8dfb76f834.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5s43bgzqr6a3zk9ceqkeun8qf3rtd37y
X-Rspamd-Queue-Id: 1193314000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754311409-992716
X-HE-Meta: U2FsdGVkX1/HzSzhnnR5/yVm0AecfSkImqRQddPMibZx0VR4JafWtUzEFlE+Y3AlsFyUgWV8NfnkKTi71C9Tn/nY2b9HbE0Pbu0K6ajv8BxWOA00RW3vWwLEgDIRUWXDbDgn94YGur6kJLQRasOwePwc1hNUdpuqXb2l3g9Pibgxvff9Y7wZ2eOLSgEsN/nmK2XQhKnwOry5y3ZlIFgjBpbfkuXmpN+2u3SFWT9ECbvIhhi9QNTZ3uv/33Dy6u0eJmyHRcnnR1aWIhKq+T9rtV+P7ceYlGTExPGgvpu9ysNTS96OWHm1Qz+lZuAMd3fvMDfDE0vEt4IS8XlkmdkdM7OU3QZLmwYsNSN3MF/VhfxOzfmOtd4KDcvwc8tK+nSCKtqAPOVyMqVAU9NW6NTD0qpQgEtnpo+R7/Uhsc04HFBMmY7pUzYCfPjhg9vc2UjK7g6qJzMlM4Ae6nXAH+QYU/xQrPZWSMxyd6+kjc0aTBcKkgN59MhBWqAeQ4x9FGKiXh08AU8HTALDJvBJb+fL/OnoW47VA8fXGlixo+V0WmcNcsmkuz9sN+rI0KMPNShuB9sak1OYzRGvt7sHBcpmHGCJdjERrLyATPGUiQiZH8OhYJDUrZA3cMEVKbvKZndopTC/Ir3hVW5sDeTGzSFDfvadId0Uzlygfem15o4cSE5ksr0p6uLZPLkOwrmyaVtsh6QIDM4T0b1jAQa4zbxlaIFa3qzemwnuj+ygVXzgfN3DcJj4gQwucr/2WQdAWZO3Aiyf8O/zQXQONwB6wvefbDAX4CpgfDAh4fq8HW8jaCxoqTx2bVHZjfSDKMAZCrKRUPIAfXWI5Nir9mKuvLP7VC4xHrh5u9+4chSykWIzvAGYJCosQqsOlqGgjsAIF+05HiwMc6Kw5X7Mq6QYDquMELlNKVz9d62HzVwgyXZi9Va0E5jzZr3o72Kh+lj/mMbBgW/zY9afBqmAFDWTfbx
 zfT3OYVF
 YQoOGWvWqxhz8jd4rNlsngAD9kyt6TB42uAP5
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/core-api/dma-attributes.rst |  7 +++++++
 include/linux/dma-mapping.h               | 14 ++++++++++++++
 include/trace/events/dma.h                |  3 ++-
 rust/kernel/dma.rs                        |  3 +++
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 1887d92e8e926..91acd2684e506 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -130,3 +130,10 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
+
+DMA_ATTR_MMIO
+-------------
+
+This attribute is especially useful for exporting device memory to other
+devices for DMA without CPU involvement, and avoids unnecessary or
+potentially detrimental CPU cache maintenance calls.
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 55c03e5fe8cb3..afc89835c7457 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -58,6 +58,20 @@
  */
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
+/*
+ * DMA_ATTR_MMIO - Indicates memory-mapped I/O (MMIO) region for DMA mapping
+ *
+ * This attribute is used for MMIO memory regions that are exposed through
+ * the host bridge and are accessible for peer-to-peer (P2P) DMA. Memory
+ * marked with this attribute is not system RAM and may represent device
+ * BAR windows or peer-exposed memory.
+ *
+ * Typical usage is for mapping hardware memory BARs or exporting device
+ * memory to other devices for DMA without involving main system RAM.
+ * The attribute guarantees no CPU cache maintenance calls will be made.
+ */
+#define DMA_ATTR_MMIO		(1UL << 10)
+
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index d8ddc27b6a7c8..ee90d6f1dcf35 100644
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
index 2bc8ab51ec280..61d9eed7a786e 100644
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


