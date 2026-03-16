Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE65CF53D8B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6094B6B0354; Mon, 16 Mar 2026 15:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E78E6B0356; Mon, 16 Mar 2026 15:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF336B0357; Mon, 16 Mar 2026 15:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC4C6B0354
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:07:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C7E2C1D5C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:28 +0000 (UTC)
X-FDA: 84552859776.02.2E8AC31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5BF324000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=piNXWAT4;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+ccPS/VTqwZb2fRk3JH5nwoE9mNOEK8ewcsND+CNgc=;
	b=e3753m3u/r308gFGQRoM6aiZ84Oxbo0GfxzRzcAhSdW8bujuWpVUibODKx9VXPg5C3ild7
	YBClbMs+6s/Zbtw87xsOk/hU8ynuLad85/OMB7XwRlzwlP1Rk6pc2h0QXz/4B1rbK49a45
	sIichWUQlb0+LfUw3IDhoiqrifrz5i0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=piNXWAT4;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773688046; a=rsa-sha256;
	cv=none;
	b=OJh8vGBjMfJBS6xxmV1+Z9XNVQ2TqiTiUmmeL2wql/BEUKVXxSx1ug7uELkXjNFXXJfp4Y
	fy8XTlaHx8EeCc2h+StiemnMOiEk5S6LTbKZMTlVVjvAVZtvB1ojykQTnv7f3VKMg3nahl
	G+F5AQBneFbVDSXuVx+ze9riE2uTJ5I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD47260097;
	Mon, 16 Mar 2026 19:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FB5C19421;
	Mon, 16 Mar 2026 19:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773688045;
	bh=M+wL0ybsphtwzmN54IoSxHDbpmj04d4gwnhHVj/1g/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piNXWAT4bj5lHmsG6nZ0L9AfMzMyIu7j2YPi2hOtfCWMUcwEijjdxEepFlWw7a6fq
	 WVLBOPlhICTEuRhZYSVM0D5V3rQ0oUf9AcB04xuR+8KAmo2jHx35vNPo8wRdM9hGSj
	 N4y54lJWEpOjKWXIYdeYeURJx8IlG8n28lYz7s65YBXe4IbWpiBAI555h08euJPfha
	 rVCCP9FsjuH2LmZ/DWXZtj4tZGwBH/oh3HZrRLc0HEFANm62GBtJi3cReOqJFmMDuF
	 Ib/ySREM9Emz+Uly5rjb/07TARzrR0FuutOU8ynwypkMADPP1BFqB3INoz56VB3UlB
	 rONpqoDT/xo2A==
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
Subject: [PATCH v3 3/8] dma-mapping: Clarify valid conditions for CPU cache line overlap
Date: Mon, 16 Mar 2026 21:06:47 +0200
Message-ID: <20260316-dma-debug-overlap-v3-3-1dde90a7f08b@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f4jxiyyict4udwdxkpo3dswahrg9pkzk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BF324000B
X-HE-Tag: 1773688046-655926
X-HE-Meta: U2FsdGVkX18+3twNvS8ggF032Kfm5ORIS1WbIdB0y2CHiAocIkLQjt16DDlhihkJubitWRvVu1PQ5RoWKDwV0rhD0mpJZFRa+uev4kvk4btJsgP2q1sZTtTRdcce+rIwZ0gp0FUbkwXk+wcUTVIrT1AIXmGvmSnTt0y0nk2VqOrm0rSdHWhb+FsB/wV8btUxn6pnVpfDzgl+MKG/07Djs9GcQieA1gwQnIyE6DBr1x9BEoDJpLXrrnZZijf47hpBCi36rUUKJEu+3aZD3nFz0eY0MSyjj6XG2UsEQ8UcfKRmx6K/qaGPD26sFH9IwNQrHPXvGB28qtQClvm2dwR0Obmom6fqPfceX7nrdtltDrbNkXZyYUYj8zd51r9jA13BQg/SAQsQrGhxCJuEyr9aATZbZnJD332d4oXZprnK8obmlPiotDBWKXfeikFbrdAj+BP40jQcVSTJK2sJGr5hLO/SbJw90pgp5ixDRMoQbBd6fVxRw82i1yKqWFSQLIa0Rb9mz9qzoag8w552U0V000S/9R7Msyzg+J8ZSDsUS7QS9cp2eNlCq0wVnhaQl/IYa/CD6IFxqq5LpbHqhPT+KL2lk28CL//lVjCjbEK9zpXEeHoA0444cUAcEkMoa85Ez11R582juuHtkO2uxmrLEys/EgJoZ8Ol+u2NmwoL82x1gvmXjTviiUZoEu0kj/9BZbPGWca2HamGSmx8bGtbVuLTC+uGuE6x0S6yvXp0WhjYu9lx5qIGwvotWH8nRxiEnzxsIxOsq5nVt7RebqutPxcB1fk9dgOaDCrSs24HM7tGo56g2TIp8pp8D5tJ36o8QrorHgzemgUgF5x1zi4QIXJZyQBFfPfKxrgr5SYo/Fds3cIW0DYB+1EhFgOD5NH8sZQJ8attV0ipuNGUUpv8j9iGwxr4tDqRxMv9iS8/N15IBWOMpjKaTaJKng+TFbVnGXpIEqP9tsrbaenLMkv
 7qtWdw++
 j6n69g++bSwHOvz4UsNaKf5otLWmGLu8ewttTZGezDDatH+s1bOYlZoMF3RLE4R94gGJmuZhMYK5MQtviN1XlimwXux0wgc5PzkK222wq3kUC5Xu6Kwe/92loZtYyc9DKrbOByQFctu20+SdZd/T6DKMQqgN0h4/ZLNn+umE5w+m/Z7/FYwgjm3bfysZMS1y0yLg05zfTsqJJ12g=
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


