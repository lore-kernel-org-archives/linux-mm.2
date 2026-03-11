Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B7C112586B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951226B008A; Wed, 11 Mar 2026 15:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB376B008C; Wed, 11 Mar 2026 15:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE116B0092; Wed, 11 Mar 2026 15:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF216B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:09:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE9DE1403C4
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:07 +0000 (UTC)
X-FDA: 84534719934.05.F25A9D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2304C1A0002
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bq6HPes1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773256146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+ccPS/VTqwZb2fRk3JH5nwoE9mNOEK8ewcsND+CNgc=;
	b=RVgXzsAh5/OpKEYm/+JSSCEu8k87YaXoR+C3vbZmqLsPsGioBv51AkT3FqGWTS2VdkwHKf
	95Npg+3qcan2ALvVq/83aCblC5Kk6hC75uoURtVashKjlamZ6mGkmxoASctUlOtyZWQOxF
	ZnqJW1C0cvcYoLjE6M5eB6R130K1lhc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773256146; a=rsa-sha256;
	cv=none;
	b=L6IqUoZMPmlmbBff6UXaQimWsQGvEJQum2xGyd+M++Ab0rsPN8QRi2lYEMgLkCG5FIsWNO
	4qH1Bf5Qs8HFGtHEyKB+eFesHbJraVXeFwNBf8pSrL9NpXRNNql5IIf302niCFsvd/qWjw
	kkPcvD8MaHH+xZ32VnkCX/16luGanrw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bq6HPes1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C2DE40AD8;
	Wed, 11 Mar 2026 19:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748B8C4CEF7;
	Wed, 11 Mar 2026 19:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773256145;
	bh=M+wL0ybsphtwzmN54IoSxHDbpmj04d4gwnhHVj/1g/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bq6HPes1GCOpxb+476WWxenSgikmhptaTzm7G7VrOIhF19PrU6EP/jCrt0DRzVs25
	 rzff1g5gPQv2CmJYWz12JIQrto6jkTuJlviAhCCwhitUjZYB4viFnTElRDZzAmOcyn
	 0x2F9IE6jw9qWIKCAzjAwWTG/5DW+gZce23SzSWxrccQTA41bPjU8b6SGjhHEOpT+4
	 wqk0yrxRLUEmbplSHSSBsA5u5t2M0q/t09z1NzzETRa2LzzIIA5VjkY/RStLd2q+zj
	 MWlm4GrYD4/BATmaVtrTawWypMziYPLi3u5dQeNTQ0RYxSIoXIv+zHr2XlqFKQZRDU
	 hw49rGkodBjdQ==
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
Subject: [PATCH v2 3/8] dma-mapping: Clarify valid conditions for CPU cache line overlap
Date: Wed, 11 Mar 2026 21:08:46 +0200
Message-ID: <20260311-dma-debug-overlap-v2-3-e00bc2ca346d@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2304C1A0002
X-Stat-Signature: xa75ojzxdouhr8zjfwg5qg4pzikgzech
X-Rspam-User: 
X-HE-Tag: 1773256145-614480
X-HE-Meta: U2FsdGVkX1+mf8tLc9lkFhuff+cpKdhBLb/B76a47zgiP7Qixiag2pMjKl+SkmXRIzS/r0vxvkvXwaL82JLxjMC4V7JTvTVlOcdG+xz0EgvBKQgyLGbdFki+CMov40tLYg5TDCj6wy/eSNIZW4+2bbNp5PbrvUuJaVFBSKI65LRpV+CGxwpaD6FObduG+nq56xmsHSUS4zdjtEZLe4qjbGwFERNbjpxEYRWeabGQh8Mn36UOGVx2Zq2yrLiNFXV031kY2h+I6ke3nNBiJFi8b9JoUHY1HY5KC8QHaCwl3fTeWgck7pOec4FxJXDH3hp+46Zp5J9b9gboB54Mp9VzpI+i5ng7VCFUryU5izg72lDNoTGbMSVZlki2n0OKaSzApn+BkSYPYQ5aMs7LXIaGHdqJaSpHsyBF80sI+UIUn6sxWyc8ZNWQBFdqGIMLwjJPFCjNjJJTVk0/3Dq5NzLWM8VO28MXebF/HqhSf7i7Hreic+n8oI55CVKSgmnOpUJUrKhgOiVSqUjJDEjqnKsx9YbmReAYlC05sTzzp5PDTYpHFQeNXg8pBYIP+rmjcP+R9y2J19ddDJ00TAaJDH/t4EFwW8xrviFNncDBWvoSSIr+sTA7mZTnpmMi2jvVi7/tKaENA8rNbi00WQOZz9fdHNtzc/LhKtyV4wmX0ZoGdFd+2HUYU1UL2q/aWnm0nZtNlI2OF+VVPDNTCsIlursH3iPwFHY5VlZ/vCATJHJKITglMEUVRjG92gLCyGInR+As/iE6BRponWIZECSe5UDg/R+DezUI23zi6G1usS1J2E9CjN4qHM4b2RvEpsyqM9zF0QsuuZEywP2mOJVL7YFdKd5ifFo5kLSe+Cktbhl7HyPrLMLvdRmaswRN+Pn2R/Pb0mhvArtfBpw7HbsBIkLm9If1Ap9QtQmhVl4q40y7eTQfxkflUTFwHHiXNwOxAAR0jg3YuhJjqDVCEmVQNbv
 YXC3w0UO
 r46qaXawqV9ibDs0k1xDG4yF6I9NBmUwuCmObg/sZ/8atPDv+Com9lAEZcbaUZ/LYxg3QCmB3Q1envuX4dbI5CoFWCHToKfT+B4woUZamHRJCczVzfOIzn67AwZsCwMJJ3lKd2yVZINZLkXqL5Zc0gqpgzHfEsf77OF3QaiOqsSKaER55UDbpBmeK9gB+Gk8ARaJnDSut8T0Qg/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Rename the DMA_ATTR_CPU_CACHE_CLEAN attribute to better reflect that it
is debugging aid to inform DMA core code that CPU cache line overlaps are
allowed, and refine the documentation describing its use.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/core-api/dma-attributes.rst | 22 ++++++++++++++--------
 drivers/virtio/virtio_ring.c              | 10 +++++-----
 include/linux/dma-mapping.h               |  8 ++++----
 include/trace/events/dma.h                |  2 +-
 kernel/dma/debug.c                        |  2 +-
 5 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 1d7bfad73b1c7..48cfe86cc06d7 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -149,11 +149,17 @@ For architectures that require cache flushing for DMA coherence
 DMA_ATTR_MMIO will not perform any cache flushing. The address
 provided must never be mapped cacheable into the CPU.
 
-DMA_ATTR_CPU_CACHE_CLEAN
-------------------------
-
-This attribute indicates the CPU will not dirty any cacheline overlapping this
-DMA_FROM_DEVICE/DMA_BIDIRECTIONAL buffer while it is mapped. This allows
-multiple small buffers to safely share a cacheline without risk of data
-corruption, suppressing DMA debug warnings about overlapping mappings.
-All mappings sharing a cacheline should have this attribute.
+DMA_ATTR_DEBUGGING_IGNORE_CACHELINES
+------------------------------------
+
+This attribute indicates that CPU cache lines may overlap for buffers mapped
+with DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
+
+Such overlap may occur when callers map multiple small buffers that reside
+within the same cache line. In this case, callers must guarantee that the CPU
+will not dirty these cache lines after the mappings are established. When this
+condition is met, multiple buffers can safely share a cache line without risking
+data corruption.
+
+All mappings that share a cache line must set this attribute to suppress DMA
+debug warnings about overlapping mappings.
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 335692d41617a..fbca7ce1c6bf0 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2912,10 +2912,10 @@ EXPORT_SYMBOL_GPL(virtqueue_add_inbuf);
  * @data: the token identifying the buffer.
  * @gfp: how to do memory allocations (if necessary).
  *
- * Same as virtqueue_add_inbuf but passes DMA_ATTR_CPU_CACHE_CLEAN to indicate
- * that the CPU will not dirty any cacheline overlapping this buffer while it
- * is available, and to suppress overlapping cacheline warnings in DMA debug
- * builds.
+ * Same as virtqueue_add_inbuf but passes DMA_ATTR_DEBUGGING_IGNORE_CACHELINES
+ * to indicate that the CPU will not dirty any cacheline overlapping this buffer
+ * while it is available, and to suppress overlapping cacheline warnings in DMA
+ * debug builds.
  *
  * Caller must ensure we don't call this with other virtqueue operations
  * at the same time (except where noted).
@@ -2928,7 +2928,7 @@ int virtqueue_add_inbuf_cache_clean(struct virtqueue *vq,
 				    gfp_t gfp)
 {
 	return virtqueue_add(vq, &sg, num, 0, 1, data, NULL, false, gfp,
-			     DMA_ATTR_CPU_CACHE_CLEAN);
+			     DMA_ATTR_DEBUGGING_IGNORE_CACHELINES);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_inbuf_cache_clean);
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 29973baa05816..da44394b3a1a7 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -80,11 +80,11 @@
 #define DMA_ATTR_MMIO		(1UL << 10)
 
 /*
- * DMA_ATTR_CPU_CACHE_CLEAN: Indicates the CPU will not dirty any cacheline
- * overlapping this buffer while it is mapped for DMA. All mappings sharing
- * a cacheline must have this attribute for this to be considered safe.
+ * DMA_ATTR_DEBUGGING_IGNORE_CACHELINES: Indicates the CPU cache line can be
+ * overlapped. All mappings sharing a cacheline must have this attribute for
+ * this to be considered safe.
  */
-#define DMA_ATTR_CPU_CACHE_CLEAN	(1UL << 11)
+#define DMA_ATTR_DEBUGGING_IGNORE_CACHELINES	(1UL << 11)
 
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index 69cb3805ee81c..8c64bc0721fe4 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -33,7 +33,7 @@ TRACE_DEFINE_ENUM(DMA_NONE);
 		{ DMA_ATTR_NO_WARN, "NO_WARN" }, \
 		{ DMA_ATTR_PRIVILEGED, "PRIVILEGED" }, \
 		{ DMA_ATTR_MMIO, "MMIO" }, \
-		{ DMA_ATTR_CPU_CACHE_CLEAN, "CACHE_CLEAN" })
+		{ DMA_ATTR_DEBUGGING_IGNORE_CACHELINES, "CACHELINES_OVERLAP" })
 
 DECLARE_EVENT_CLASS(dma_map,
 	TP_PROTO(struct device *dev, phys_addr_t phys_addr, dma_addr_t dma_addr,
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index be207be749968..83e1cfe05f08d 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -601,7 +601,7 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 	unsigned long flags;
 	int rc;
 
-	entry->is_cache_clean = !!(attrs & DMA_ATTR_CPU_CACHE_CLEAN);
+	entry->is_cache_clean = attrs & DMA_ATTR_DEBUGGING_IGNORE_CACHELINES;
 
 	bucket = get_hash_bucket(entry, &flags);
 	hash_bucket_add(bucket, entry);

-- 
2.53.0


