Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417FECA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD50D9001BA; Thu, 14 Aug 2025 13:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1094900172; Thu, 14 Aug 2025 13:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2609001BA; Thu, 14 Aug 2025 13:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92163900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:54:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 619BBC0747
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:23 +0000 (UTC)
X-FDA: 83776112406.03.63F8F69
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB8EA40008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S9amqurf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194061; a=rsa-sha256;
	cv=none;
	b=NJV54m37LHc8G98nPcLrHtJaCqHWM9wb3205RWVcFSh5qNcGDBa9kG5MlqGpb66F18OmW3
	SZ2Ai3dWc1seiqrfPN3P5Zb4pTQm5dcLDeYkEb3B3wzg2UbAjhdSM577/8NTm9HvpCVkyM
	aCCVgJOBmiRIKrV9RxiBDcpS1uG7lG4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S9amqurf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZJR9LA3kgzyZhuFGCo8URPbUfbHRYhrLJioDHKhIRA=;
	b=yyWGCIbaQxpqvbcySOL40xX/eBWCDI+1ClUIebCv6fpVqNBrvcYrmk7rlQN3WxaQYRSyZI
	IrLLHVaVky5ySEYoqDJLlvGRm/S07nxDfu0A2weLcNKVJDVeeQ6ogd2HTolC8fDjL1RZUT
	z6w5ZXHUZ09JbRaTfJ3wLWBS/tHznXo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 880095C71A2;
	Thu, 14 Aug 2025 17:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84294C4CEED;
	Thu, 14 Aug 2025 17:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194060;
	bh=EWgy5B4A+Akm79sn7jh5YTuSXsOOCp8mk7trqVaPDEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9amqurfNETOVtezAkVa6MnsxIu6FYiLmixRtkhT7UqHmokRjufKZ1zA6i9tqvLQ2
	 VpJ4757fo5s+Q2B9uKr7wl6GFTqBZChNrcR91YPaDGQm3vc25I4sL8CzGbTzuJPVlN
	 hPNWCQXPSv+pe++9AF//cQKOMXHlxjzvfpawShOZexyhB811vMblb4Iob91DHn4JMc
	 0Ps4ndMm0C4ZpnAnz+lLs8UrfAyun9stmeMVvNUeWnOeLJkhGWt7hBLyD/hpHedHFz
	 VRCIt+hbiKhk4E6OvRy5w370VlsotUtqhkL6SY1GJHWGdRmKrFcs1UCUfCS6wKxQd/
	 DwNNNAdWNBcLA==
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
Subject: [PATCH v3 01/16] dma-mapping: introduce new DMA attribute to indicate MMIO memory
Date: Thu, 14 Aug 2025 20:53:52 +0300
Message-ID: <08e044a00a872932e106f7e27449a8eab2690dbc.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB8EA40008
X-Stat-Signature: 3j5ftmima8hbggrptco9nq8iwws4gyxs
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755194061-747871
X-HE-Meta: U2FsdGVkX18rz9B4envTgoilTonBCE5JKxB+xbR1mR1q1EVTdnfYlmaaKOYikl+pFoL5+bHUDomkhf6eVVHR6hPIUVJkRuCA/BMRMG70bpqZkiIXNbWexiMjs+ImLZJekj1OK8HxAAwIL93d0eTBIafpTzTCJwgAo/axrps713+JIO7XpC5pGOZCZeBuwWBg6ZA0ECGKfIAbr/W+LQpz3zUaEo9PJTnZ9Y5X6UAd6FGQ9qbMU3Kxge7IE20F0uk/L3KNlcomp3QYdDcelGmYKqbOUuOx/lsd7TJneaAcwzBbRsmnjsz/C9vbWv24NOTnuPhtFb/uj0XkKqvLBi+rn410Epm1EMfQpruDoqb2u40WB52USLQOzNixRDrq1IITIC6jnBpMMr0qFXU0Z6XKcHwkeu8PYrNgqGQ/EgNLMwmlMOSqFiajkZrXBdAP72Cf4+UJvtdvuwg1b4oCi5oTJU4EFoDObTb+gqymz3TxUbhdSh3vV8+d7oonGUIc5X72Yi0uX58d9uqVrDUkX3DXyW2thTrsLLF95pDeeYd5pplOSnvw9+mNHnTt+n4rOqxrDz54R4B8jXnDjXQ6/x3650EPgR08AdlK2+8NlFvKQI+biTcZPvZdzSMG7926fQ7vCFacszNSniCl//mVq7DUq6LIH9CCEqtrRMH3kl2w8od/++CJKlWY7FEQsvcJ+68RkObzq39kG429gW0Qeswv/TArN1zMG4vmOumlMcRc1SaZjWRjdLzomhqO/yhd0xMjQ5FbCRaGfMlXKZK8+0fR0wzKmGkjQqfuzAt9Mf4UkoJbWmgg+iAuVH8Flj2vi91pGcJ1xAe1gy1or5IRkHQOcNLrDrCi7muITniu75fZnLMBps2bxLu+SvULxwLxCQ2Rpoa7/sSB/EY2DIiHmLrmD0SgDpX5IyKtdZ15v34U5zVRJnKLsXT7vxfPMiAaTNhO3gEnZWDeW8b0OdYf3Rh
 /b7NeD4U
 UeDWmPXw8br4EyHFHX0dL80+/5WzHtgyZrpLsiUiWWSw/kiconNfOaAl4J35xYPy2Pig+YpNQrlvpDOHi369ex3pKyN8dgKdYFtnnFT/mTN4S9O6lGhz4dugGn9AIMY7i0HAxwIB3l3UXCNyIixQ9IjerALrNFKqGHnZA33WzfqCTu6JPMhZLUrkENbd+yIvWR4LOSfaxt+vs2GyJ2RLz00KV2MlPPHNd9nItYVvK93e/uSYhXgtiJB0x5D06PLp1ZhjgCxwwyVTpnWFrbyhavnvNvbkQnOXgxsZOJauUDbDJDP0avrk3dFqwhw==
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


