Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83593F53D89
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7F06B0352; Mon, 16 Mar 2026 15:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96696B0354; Mon, 16 Mar 2026 15:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99206B0355; Mon, 16 Mar 2026 15:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C67366B0352
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:07:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 648CE58E3B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:23 +0000 (UTC)
X-FDA: 84552859566.10.50E1C9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id ABD98140019
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=roSy1tgF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MK+s8n/GXpR664/oI0jDhHKwOiZFweXjpVBjmPf+upU=;
	b=ip4kwK7Q6diPMVMBRYmIqBh3YiGr8/5fZZA6e8jqtUmFEzLiMEcI+Z/b6EHnsDD6aID+5N
	EDb3pF5FFDJOmfMvsNlMQTiIgydrh7ekGcVDQyxsIy4Bb5gDHAsMCMYXaTEQQTy37LhuA5
	0AEbQNlc+Hg08ybxxqcavUoYnkzFv/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773688041; a=rsa-sha256;
	cv=none;
	b=ynVxkz+9mHHV1/7PUg/+mdDfEUzenDNN22QRhj+uWh3XN8ZVj/6ud66KI33a8QCKNJ5WSv
	0fyDc78dcfzJMuUiBbEA21Zns9P5oYxh13Mv5FBzCXttdoexVcj3M0LhfJ8233g4Shtwzo
	26Z75WqH7Z0JaNykN8XeIiYGmKh3l+Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=roSy1tgF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27FC06013E;
	Mon, 16 Mar 2026 19:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C27C2BC9E;
	Mon, 16 Mar 2026 19:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773688040;
	bh=76gJ8zRLQ2z9cpyLADgS8FI7m4LyL7iZ3qybe4s2hx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roSy1tgF1BK5GTonHvvuBaItSOG6jXvYZv3W1Gfs9mXXGN7ExZYrQqTEKyt6XI0j5
	 TmT+zflhlqF6YD11LHc/BpbZ1b2PDKk/mAZVW32pV4AS39Zryv7UDBVcUsTDuNA5MY
	 HH+cEcm+XD1pXOoWv2vsYXziQO/qdfwvx2IK5jiXrTWF/YtpsPjEYIb0WtkhvDSjEy
	 AZPGXcqtr+eICGbyYxOFTTTBGDxWj60I5P3ISA7kNUApZIWKxoJO4135CxZnUnecDL
	 qJentQxiJkFXIuEpu+pejYL+/ugXKcQIJxFtQ/yzTGpic3wcXt6tx86awg8a33ITLP
	 UrO+w0OVPriBQ==
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
Subject: [PATCH v3 4/8] dma-mapping: Introduce DMA require coherency attribute
Date: Mon, 16 Mar 2026 21:06:48 +0200
Message-ID: <20260316-dma-debug-overlap-v3-4-1dde90a7f08b@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ABD98140019
X-Stat-Signature: qqrz6ycdyjiqu7dpfm14acp1f6mcxksz
X-Rspam-User: 
X-HE-Tag: 1773688041-63314
X-HE-Meta: U2FsdGVkX192UeQl+jH32XvntfaD0XuZlZCcKsQu0o3Hh4D+JFfbvXPB+KznJ0H8F4DXVEa5A9LTS+UNbNb8qFSnUkb1pTmpMJye/btvjSDC7jrTsWyX2LGsUUzxxfpzL6h9Q3frpiTaNcADQwtztXTwCI1fk5W5kBqkwckKcLI7kZLMyPspJ2hsN2vtoEO2eKsOuFVBCec0bK7KWIev+ANG6gUxlNstQlgiP0EaolH9ga+QUfgs8T01wuLlQK1sIbvoLd+QVEjbPfOnXzNt6s0h/jXEDoHIPDzAhvoRWLTk9fc2hZocGlBDZngJFG5VTISJsNmX5gmQZtp//xYCMeUCaaUONU1tAAIfF6a6XS35fJ6WH96IIVcj2xzG1EpgQQlD8U0unYQo8sesSwiyWDF8TWzoT4kslIUlBs83RObeh22rr1neYGB9d50y89oIdD+EMi+wrLCgecPt1MSSzbes2zWVIeLBtf1bhh2YrxOejzsAwcChUoEgM2tHWTcFwR9v81x7jktjYbqDBENGUVgMU1Rs+dQUigDjWnyPPRp0eWfk/Sd0WfSz4qY+rYUDFVOCBeU43oYkX7XLMUHxTh7b2IBAgU9VvBbtLrsMDKaOrmeO3cZxTqceIhk7Xj8Tv0cT1+pj+Lk7+uaQlg6LSF6MLOKj38PikQujrko8h+bQaxqssGbPkBkZc9lzDdnZsk0G5bC6TxEU8MaBfW/D/urTMY0yMJOaoH49SJq8Xf2Mua1K6unPNHim9GAt8cbJjChVl5pdCy7IR17v6m2+v+eEmiES7E1SNCVu5+a5xfZARJpXKjB/lY4/OxCDSaFiOJ2RJPBojQKK1QxSF9SEzrYICv8B3yWMGukO4E5jYMYeM6EMhaFztJAKoN8jIsE46bQJFFTQKd1wIWetcNBzMnDXW4SDe7FhtlmwjbNF4TUB6uwgp9w0b7+bO0Pie0dx+C5ZFp37HhCxqYPPYYm
 3KyxVQoE
 +hCfg6UL1TkPlnX65PCddIEJn/e9/X4UGyRGrFN8tb8jeYjeoRS/gUWNNHHGz6orB1ucyNaL0wpYJPWQTg0iUfwqDgzfEOPMKy8dCeHvzPBfuje7bShjzyNc2qpRd9cPmjbWVu8Ft678yRI6gyExdjUVHVu0znonnWNTo6fshBqGFG0yw81hI6fY/O0M19XD4LCnXAKZAcaHOuOxs7LRuuHlcLs7Bns2C7Srd3Ijq949Zl/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

The mapping buffers which carry this attribute require DMA coherent system.
This means that they can't take SWIOTLB path, can perform CPU cache overlap
and doesn't perform cache flushing.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/core-api/dma-attributes.rst | 16 ++++++++++++++++
 include/linux/dma-mapping.h               |  7 +++++++
 include/trace/events/dma.h                |  3 ++-
 kernel/dma/debug.c                        |  3 ++-
 kernel/dma/mapping.c                      |  6 ++++++
 5 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 48cfe86cc06d7..441bdc9d08318 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -163,3 +163,19 @@ data corruption.
 
 All mappings that share a cache line must set this attribute to suppress DMA
 debug warnings about overlapping mappings.
+
+DMA_ATTR_REQUIRE_COHERENT
+-------------------------
+
+DMA mapping requests with the DMA_ATTR_REQUIRE_COHERENT fail on any
+system where SWIOTLB or cache management is required. This should only
+be used to support uAPI designs that require continuous HW DMA
+coherence with userspace processes, for example RDMA and DRM. At a
+minimum the memory being mapped must be userspace memory from
+pin_user_pages() or similar.
+
+Drivers should consider using dma_mmap_pages() instead of this
+interface when building their uAPIs, when possible.
+
+It must never be used in an in-kernel driver that only works with
+kernal memory.
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index da44394b3a1a7..482b919f040f7 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -86,6 +86,13 @@
  */
 #define DMA_ATTR_DEBUGGING_IGNORE_CACHELINES	(1UL << 11)
 
+/*
+ * DMA_ATTR_REQUIRE_COHERENT: Indicates that DMA coherency is required.
+ * All mappings that carry this attribute can't work with SWIOTLB and cache
+ * flushing.
+ */
+#define DMA_ATTR_REQUIRE_COHERENT	(1UL << 12)
+
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index 8c64bc0721fe4..63597b0044247 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -33,7 +33,8 @@ TRACE_DEFINE_ENUM(DMA_NONE);
 		{ DMA_ATTR_NO_WARN, "NO_WARN" }, \
 		{ DMA_ATTR_PRIVILEGED, "PRIVILEGED" }, \
 		{ DMA_ATTR_MMIO, "MMIO" }, \
-		{ DMA_ATTR_DEBUGGING_IGNORE_CACHELINES, "CACHELINES_OVERLAP" })
+		{ DMA_ATTR_DEBUGGING_IGNORE_CACHELINES, "CACHELINES_OVERLAP" }, \
+		{ DMA_ATTR_REQUIRE_COHERENT, "REQUIRE_COHERENT" })
 
 DECLARE_EVENT_CLASS(dma_map,
 	TP_PROTO(struct device *dev, phys_addr_t phys_addr, dma_addr_t dma_addr,
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 83e1cfe05f08d..0677918f06a80 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -601,7 +601,8 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 	unsigned long flags;
 	int rc;
 
-	entry->is_cache_clean = attrs & DMA_ATTR_DEBUGGING_IGNORE_CACHELINES;
+	entry->is_cache_clean = attrs & (DMA_ATTR_DEBUGGING_IGNORE_CACHELINES |
+					 DMA_ATTR_REQUIRE_COHERENT);
 
 	bucket = get_hash_bucket(entry, &flags);
 	hash_bucket_add(bucket, entry);
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 3928a509c44c2..6d3dd0bd3a886 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -164,6 +164,9 @@ dma_addr_t dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 	if (WARN_ON_ONCE(!dev->dma_mask))
 		return DMA_MAPPING_ERROR;
 
+	if (!dev_is_dma_coherent(dev) && (attrs & DMA_ATTR_REQUIRE_COHERENT))
+		return DMA_MAPPING_ERROR;
+
 	if (dma_map_direct(dev, ops) ||
 	    (!is_mmio && arch_dma_map_phys_direct(dev, phys + size)))
 		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
@@ -235,6 +238,9 @@ static int __dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 
 	BUG_ON(!valid_dma_direction(dir));
 
+	if (!dev_is_dma_coherent(dev) && (attrs & DMA_ATTR_REQUIRE_COHERENT))
+		return -EOPNOTSUPP;
+
 	if (WARN_ON_ONCE(!dev->dma_mask))
 		return 0;
 

-- 
2.53.0


