Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2B0CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7F990012C; Thu, 14 Aug 2025 06:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940B7900121; Thu, 14 Aug 2025 06:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794ED90012C; Thu, 14 Aug 2025 06:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DFD7900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08D34117B04
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:01 +0000 (UTC)
X-FDA: 83774952282.12.1970F2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5A500C000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:13:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iJnTdVoA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3bm79vW8TmRkbMs8v1DEAwPfoV8hY4/GHRwYQJsC0o=;
	b=Nudcxs0TeUqiFPE8fVbO+irNb/TDseNe6LLLe1oQ43phCAb5oNsXLrleBE9SQcSPVkXTSI
	e9BUtPSJCnhH6G3I3OHEqOFeeo7uRO5KmkVeOr2/nnlKeVNLK1i4ndtc/+ooKNC/DkfyYw
	ReAltQ3fchl3q+4rinoDFBKaYGP6JUc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iJnTdVoA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166439; a=rsa-sha256;
	cv=none;
	b=WL37dVac9g3TdoXRHnopULr0x0mohN3YmxA0Q2teBf1gRDFIRn0/CebWCynWO4Cp5OVquF
	OOnwUXtRjYwYkyqUSVl5692O1+Yojsv1MZiRmSpt8up6HvD3fo0fNU8rc9PKxNGP85i9yn
	1tRQODwcxU2MyyeNAsDYwku38fyVpmE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6725845594;
	Thu, 14 Aug 2025 10:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CB7C4CEED;
	Thu, 14 Aug 2025 10:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166438;
	bh=20hTY/Bpuo8LaRouoti+FqOb/uYNdZEkCPYgzhSUTHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJnTdVoAAfN+/Xmg0sENmXfmecar7mR18tZJR2Bssi/yKcCFsAqfqd8yIy8d6+7T0
	 4cpGu3Nev5L57PEt//45pHdIh1Lpgnsn3eKqfNvyldstATPdrx9y+2/wvt8O1xOqYx
	 0TARiCfmcQFlgM0m24ah0By4BQ8/wzSRKeUT8fci1OYqIQCC9JFc5UOL7W2TCrSXfR
	 vjl32GDpJ+pmD1jY1ixOBoax/KXXLxrXKqp77CRTekhWEwW+gmg/C8r27lcyIl4yD4
	 CLA6A8gMmOrf5aBfQnCOLLhuuCdEKTsxzAwuGVvNkUYlC0V8TNUlpNK6i0NxDGLSyW
	 EVsttayqq2y3g==
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
Subject: [PATCH v2 01/16] dma-mapping: introduce new DMA attribute to indicate MMIO memory
Date: Thu, 14 Aug 2025 13:13:19 +0300
Message-ID: <f832644c76e13de504ecf03450fd5d125f72f4c6.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A500C000D
X-Stat-Signature: oq68ray7cgorfifwcttxtk6thhwdmbg6
X-Rspam-User: 
X-HE-Tag: 1755166439-862673
X-HE-Meta: U2FsdGVkX19oRvoJZjS6Bz1R1RzEnPsXJx2Jg6UGcmeFgJH6Xd3OaOH/LAS++sVwQD9J7dai2VZ5QigPnNPTw/ita6fhlGjZCNQbV/xIhmM/vqzripcasBQUTlT/pPNZVOFGOg0fMX2c6D6ytl4vWQCOT074yZN1rBvFi3jzS3dEg9NmhiWBhZPjXctU3pLme+k65HNEAIGN0mAlobAeRgtLEYsqNGWmrHZe110Wk4XfUNfGvkiw7fwPqYPwJKacdfLDQqBdfCtOLZgBf2s7i5/L7JJ0XMZ2lUXBAi9TLHMLfuor8p0/hqZ6zq4ktHoybfAdyXOjLyzwbR6vKpY29LWs8ZCkUtB+wCbZvr/gBVATJvagV2dLlnpONfhxpJIPlV4UHQG9KmV8EfaB6Ske7fk3QD7r5MMO06r1oxcs9cFXdHbD4DUc/+0FC1/D/N51bMkJjGCwUahgGPj7kFY6mIuOSHF27AQUsci67fgxx+MGJ5EVEHgjjSbKR7YiJdRKp/CmRZZo0Pw4/Z7wMXcwt22sM/spc4Vq1X3JuLGFTZ0QOLamGmL9t0Xpob+3rXsHqR955egwCBbEp2bEX5/b2GFmVvLsvnZZ79ils80UiN5UYW4xKgfqc7yt62vC2fMZzksEVcEaTO2P0vrSmJJE9uZOB6GIEzNBI3e0NhTUN4zBqrExtrWgl2G5J2eQ2GgsvSQtXh8n8jg4bY5UOyJeDCg7yCUeNkKN5IAIxcw5888KaMbuxH4f8NI7F9Da0UyN40Rg/rf+EkmR+hujADYEsUePOl5Yz3556KABCungRwzNWuQPCLWiBtJ2UeheQL+2ue+9pBCzqhVxEmRMjCaXEYhqlHerput4wlyPuWySecKGZktCsfWkrSptS0dL8pbApgJyMZu2bOEx04ATzUQimUCSa05qStSm7R2UVka0QRXmNb6FrV3XtpdiD6qtFiviw9DAWKl1EAhpRN4WHLq
 k3j9HLQn
 09bRIYTo9WkmGDnewD+rFqEVDrtjbzG9nZFBqlkpVuglls4ZAajKvP68YMFbJKdqfZZQMGGhX7X7YSNkeEIT7kzrg/HqFF3JEudqcpDJ2M9kQTLdgz+2BLkXFANquBdpgK603Frda0CygRZowW5V2cOxwoVdoAr9O2BIMCbmabHM/ByoR6RetiB2LPp0WPiUk9Tsbr63vxJo6Y2PxTxBbSCj9b6DQraNvwzoQfrxQzWg/2AcXfdwuQSG50Ombq94wBdsoLmEzw+1IR3j9Rf9Dddy6JB5qLk14Cleq2XZcVLHDpdpmEJEYvY5ZEA==
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
index 1887d92e8e92..58a1528a9bb9 100644
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
+functions, it may not be cachable, and access using CPU load/store
+instructions may not be allowed.
+
+Usually this will be used to describe MMIO addresses, or other non
+cachable register addresses. When DMA mapping this sort of address we
+call the operation Peer to Peer as a one device is DMA'ing to another
+device. For PCI devices the p2pdma APIs must be used to determine if
+DMA_ATTR_MMIO is appropriate.
+
+For architectures that require cache flushing for DMA coherence
+DMA_ATTR_MMIO will not perform any cache flushing. The address
+provided must never be mapped cachable into the CPU.
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 55c03e5fe8cb..ead5514d389e 100644
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
+ * functions, it may not be cachable, and access using CPU load/store
+ * instructions may not be allowed.
+ *
+ * Usually this will be used to describe MMIO addresses, or other non
+ * cachable register addresses. When DMA mapping this sort of address we
+ * call the operation Peer to Peer as a one device is DMA'ing to another
+ * device. For PCI devices the p2pdma APIs must be used to determine if
+ * DMA_ATTR_MMIO is appropriate.
+ *
+ * For architectures that require cache flushing for DMA coherence
+ * DMA_ATTR_MMIO will not perform any cache flushing. The address
+ * provided must never be mapped cachable into the CPU.
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


