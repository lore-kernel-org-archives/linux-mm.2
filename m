Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA07CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1A58E0009; Tue,  9 Sep 2025 09:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978818E0001; Tue,  9 Sep 2025 09:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E948E0009; Tue,  9 Sep 2025 09:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79E928E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:28:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 222B0867ED
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:23 +0000 (UTC)
X-FDA: 83869790886.24.7822918
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 54DF940012
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W2fAXIdM;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TaOMXIJ/xNUUto3Ykfack/WiEZfO7Ok8iMVsFthoJCo=;
	b=cJquPve2z3O8NYu5puyA5n+BOiFKxPueBtzyxC9NVPA/2025mByGhn3kGyJBgRpRbLo5Fd
	NsMGHIJxPAPzwM7fWazjmbOVH/KE79k2/M3qR3USgl97EqVlt/SRz+K4Q93d3UhPbaiofJ
	m1JU6CBXa5XHs8L0OcdLGpfYJdGMKwo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W2fAXIdM;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424501; a=rsa-sha256;
	cv=none;
	b=vJanqV4YFlY/ESIQ3HIe4U2Dg8sHODNHg4hxJTEgi2+/SF1OFJyyC+3vdMOiuFwkLpA4c8
	/4Q6nvx6tMz1pKb8ghuCK6EKtasnkoIcF8HHCTN7nnfZPbHPDwkm4CtwwV/zyIuOfFeRgR
	a2sL2URutYCxrS7QI1oWXGAe3nY5C7s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F10844976;
	Tue,  9 Sep 2025 13:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F41DC4CEF4;
	Tue,  9 Sep 2025 13:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424500;
	bh=SsTumAAe1s4B4pTZxHvsqOUAU/t1s79JgZHbKlTSbIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2fAXIdM3SbF0lV91qntmnngT3VSZmIEruQIT17KY+xaUG8amR2RZZ2qhZz8YI6GT
	 FekzkYxHgtVMzFxHyjsHN98zvE/leulRAAGIaKJ8PC6QzVwcF2xi5m2F0HFJvKYy8l
	 Fp4AEq9NoSEAEb9k2dLzs9NnQ08nvQvz9j31xIcxLCfDD6m6CVzyYJZaJ+nKP0lE8k
	 +QKx4LFeqf+pCfO4WlArSVtqPiRTr8fruAPio9DWSrTz4HhW+v2IRIkuIHNvcRkHTc
	 9WMZiIwLJNpcK88/QaudkQf/qeP+li4/epJaKE3ugReQw2XSoGEZiJ2SJQ86a3TcPt
	 t6tYG1hVUoqgw==
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
Subject: [PATCH v6 01/16] dma-mapping: introduce new DMA attribute to indicate MMIO memory
Date: Tue,  9 Sep 2025 16:27:29 +0300
Message-ID: <6f058ec395c5348014860dbc2eed348c17975843.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 54DF940012
X-Stat-Signature: jumi3q7tua9fcxxsm3ff8zmeyo5yyxwd
X-HE-Tag: 1757424501-990735
X-HE-Meta: U2FsdGVkX19r7uQImbAbdwzz/KcKB3u03yOXHq1EY4p2Fhr6gD+EKZTp61MwSc8h4Wr/KZxjpMohJmMVWqF3lhN1wnc1WvofZ8p7eQhyXk9s96dBTLKLilY6xghHdPKJs2Ut0cYt2Q6JCII+AfflHiBPjZ32kUBvIh+juHOIScLohwFQp8NEQo2Q8vs3/DD4ZU/D98iG6H2h4niPXuveWF9ZG1czBJCjGQW6uUMIIbZixJQOPkQYiJ338qBmpB7kBG96kAkx/FGG/mr53lgDjUQxysRjuEvLa5pHCmFP+ie5ZEDLS1eTbtxuOy/zgAREdZqVkThulsBAYgQJkrbq5lUDpcIMZBSf56TDA/BDG95Ehle0EQuzngVIxtecCsOJirJr+b7Tkm7IqdkhPNFirtqlIBKRf/J4hqM6fwK1XPg2ITrydnCMtxoMevPm1VhLsABeet+dKBBqjSIqvVEUrAG4jXkh60IpCbOqrFhFqQe1kwTMqN+Oe+FdbsOoCOxqN+nNPCtQNpJgTRhd7ZbURVrkfIjEr2iiIUgpL2fU0P+UbIGrAZMZ4bZ/Bd/VI/jRB2oWmjF1EP+8x9Eup85Pw9YkcWW4kYzRJEbBMQP2CMymcQwFAhkLNXrH0km3eSL80iQusdSLcVIYPPd8IlVOc4UhawgjeZpHHQQ11kl0Dn2qPn2v2U8AT6myEXbYSnyc5dRo9eOtetIAoJulNob8elp0ubE17Bg40Ar1UUfJWs67PEchRiVirhEu2GahJxsSAvMzUofN1+7CymazyyMIQRNiACUa19OZlyBwg36J49S3CbLrLzeiNl/B9YzljuxjQqvisTWoww3rBhRoApoLMCs9+aJnFXjms+welYQpSGYhItNGCMnH++UTwbKG6gEgKdO2D5/IqabqUl0txzEXQYfxpFBidvT7oREwIm+x3lHdFUiJ/QkaOnYh+zobBwL43JGXATC31CHwQrr3s0f
 K/sIoRVw
 oBk5aJmCeT1+WNPvvfeF4IazPxWw+rHSufwofEgyDMNa7+QrDPEb1KHA8UU9gXrED3j3rcLm+pBiln+h3WeNu9h6/A335JrwV/qnokNqeH/r3dYenjO7tTHCH2PRPinGnLg3HRaZ+o6CRXuHOuUrTa/WilXwG00qVgSzkFKx7UKt5lUcsX0XBeyVhq6aC/kZWBhFmae41rq85OHm7X7jzB/eZgwF1+T6cun+nXiXW6IqZ8JFJ9fBzgMs2LCTA0cxclHCmVq/T8FcDnTw=
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
index 1887d92e8e926..0bdc2be65e575 100644
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
index 55c03e5fe8cb3..4254fd9bdf5dd 100644
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
2.51.0


