Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D419CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B971E8E0020; Tue, 19 Aug 2025 13:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46F68E0005; Tue, 19 Aug 2025 13:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A356A8E0020; Tue, 19 Aug 2025 13:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88D9C8E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:37:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C70A137331
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:37:31 +0000 (UTC)
X-FDA: 83794213902.27.E1B9D24
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf12.hostedemail.com (Postfix) with ESMTP id 966864000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:37:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kgbi4w2Q;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZJR9LA3kgzyZhuFGCo8URPbUfbHRYhrLJioDHKhIRA=;
	b=RjECOH3DNjgTeRBRG5fbuZmxY2ja8997ynVpZiu0yU9dx+pKfT3tZE0l42IKXszTcRSF8F
	fRWvy45oaLoiLtCxt37zfP3vuWtK+G6aMAAiSYEj5eHL4u2V8/4i5v4kGCRVbvy0subNgJ
	OTULXMRC3lV5DA2wy9P0KNOokrWuLiQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625049; a=rsa-sha256;
	cv=none;
	b=4o2QoQL4DgnGWfHPFimVyW0tqaHTGMQAIy5JN9+d4CBCdqJpPfID3u50f/YjAB52EaS8p6
	ZqLKxpWY1z4wn1oe56QxqzjOXhHCOdi4As92Oq4nv2wkas5tGhHNiEPkw2A7167z8jrIa7
	y6QbCGP6YdLI73tEZH8fhwsmTLsGi24=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kgbi4w2Q;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 85E345C6338;
	Tue, 19 Aug 2025 17:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24115C4CEF4;
	Tue, 19 Aug 2025 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625048;
	bh=EWgy5B4A+Akm79sn7jh5YTuSXsOOCp8mk7trqVaPDEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgbi4w2Q8/qLfemYkqYCTlJubr4ZTtFUa79DQsgoMOtMnK9XVQtew1W9zkl8AXPTg
	 5ouT8pZzyp7JtqBQN0iNERXAu/MVItkWE26bNq7tt2PQ51Vb3N7FOZu1tV27k+WDxS
	 rDNXY9cVEdCtmprq96Y70alxWNTWqmdzaHB5D3PY10GcJh034Yri4T9esFwQ2SYYGH
	 50WIZ3BWvYJhFJMsduRI2K8tz2LgY4zFEmijzvGKJlrZ1fVmLXd1pygDhMYan/xzfr
	 ol/8IHtSLtS1VL0XNmH5RkFrbie3BoNUHMXdpMX5FRAvuLWuKe1gYX4KTtkiPKAqnI
	 c3Ipp+NxzvqvA==
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
Subject: [PATCH v4 01/16] dma-mapping: introduce new DMA attribute to indicate MMIO memory
Date: Tue, 19 Aug 2025 20:36:45 +0300
Message-ID: <08e044a00a872932e106f7e27449a8eab2690dbc.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 966864000B
X-Stat-Signature: mn5iy3xfguadox89bkzos5ojhrfmqhck
X-Rspam-User: 
X-HE-Tag: 1755625049-404867
X-HE-Meta: U2FsdGVkX1+5CH2QTbO+ccXaRNVAtCHw9RHRDLE0uHoBfl9nPqogdonWI5RMQTN/1TpHJToEeml1rZaOfzssqFMvRTwsyDq/t1dQetgBeHXeHkRiW0rcZy0FQontqSy/8+n4oVsz2slRpBjrH2jxtbcIC+vOlRpTYyboAk/jrnAAmw0+nc1xH4DiA7M1CvQF30AZIHzDi4UV+ojSVSqh7ZMBAKUvhxSemADqQp1ldFXFVGcUc2jC1RFgV2N4F+VNMs6hh77sRSNqkenp8Rd9/HJn72Bdo10XUndUZWABMpkXmvNX2w06PFlxEXysf3QaQ/fzKukuzKKmOOSt+9+hkeI9HD1f6IHSR5bXbqdW2GFrCXc09/0TaLd9cKq0eUipd0IABfcrCrvT+dM8ufJmQolXlEVRboJaAtppsUz30nCGmkEpyBi2bxZindBlhtLi8QVuZEmo5LtbVVeP9hFEzu8bDzOolGM+FswuCUjNVIfTNmEkhaW07JavKTNgWFNSu6R0sNZkWN5vkkYZ6ZoXc+xZI+mhdClkPMJs4oQU1jupjmUBrvADZ2gWb9nGhLkvnEQtAwQ/oAQsO3a33n2o+WVfwJkB0NIeyR2Wm6gyHFvQTtaqubiL0YNN/C1RklBaPYQurzqbkngglo2VxnIrB43p/YHGinHsUc/WjsIvEGEOEHA+N2p8vqmq5Oh8X3SCwk0hejzFfE3ggLU6XwWsp2N0nhEzypfqYoBf3odgNcWXWjPYyaag0nCNZbx5Cz8OZx3sAnUIK7o0cYs5/dbxOgRl8tPftdLxgRC1NfbSopXdKi2QeDta28EzlMdaxvYdxmaGokQYrZcj22YPet8PQQHr2/n6G9u+8xW+3YZHPTCFkpzD4abYRkYuUut0T5j5Z6/ocKRr1ldJ4IotrU3l9k6hfx3+63VWe+Hod39K1NASK1e6Tzg1tyFV8wV7UT4IR4hFMzZrE7pWT135LZA
 8cGpEsp0
 jQ7T2/x0LpramYZ7m08QrfuCkFEGDrDLA41HeodUT9jfnCYixYKMg67wdWZiya2H6FzIShw9tthwIdX7UQhGsyUxh1hij9qfxek/M+kXPGqbnUUQr/RQc1/Q+Jeoo4bwTTrExe1DUy74ggzihh5xqjR5tPHBYKZHK1j+aT3PqHlVB3MKPyvxSGlo06m5Lva9F/5C+zcinHBACIA67yNiEtGY8qe54iBG61JVEOnWxo8KY4cg7o6nod0bJQVvR5wdoueoSQKY5tlPtTV8=
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
without need to call to special function and perform branching by
the callers.

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


