Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D75D1125873
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB19F6B008C; Wed, 11 Mar 2026 15:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A574B6B0092; Wed, 11 Mar 2026 15:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97EF46B0093; Wed, 11 Mar 2026 15:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 83DA46B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:09:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2739A8B74B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:11 +0000 (UTC)
X-FDA: 84534720102.07.A9658D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 765961A000B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uX7fuLiv;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773256149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cB1LxWmkTc8xCEWbAEX+8PvZuQXX72oRQBxz5D3Iy0=;
	b=QHzmn5hHXa1jYJnBn1Uf2KUAmcizBKCLUYFRUz8AzRF+CVljAjRdLxXwqMdyDmtjPmn2D4
	rJmIyUEJK5gAVU8LaQX21rbYaaaV4sdXGvvGCpaFW1rnKFKxuuFoy9U9r4/xUdGHB0fdJu
	5M0zw449FEcpTnFNtGsR0Kn2a1YInw4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uX7fuLiv;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773256149; a=rsa-sha256;
	cv=none;
	b=PjcKqj45RHh8DSH4XNO0Q3Z6Sk8FT8oiVmkPDBeSF5AlBkfeGmtxrlaRl1oq3b3CZp+0iL
	nH3sUf7gQ33E4snq8G0NY+G8dLtuYNrgOm2GhsVXCM/BZ6O8zBw8aWW+nGs2PUv3fJzsUq
	GLc9oCdQq6h+TdWl7ItKhdEQ5XqKOgQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DEE456183A;
	Wed, 11 Mar 2026 19:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEB6C4CEF7;
	Wed, 11 Mar 2026 19:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773256148;
	bh=Caib8MH0BZPS5GoBVp5443hRjoVeLP/iROeH38ZKBek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uX7fuLiv2dqrXYExHFjcHx7N9C8rKXe9c03Xu0WIBHJmwCB9rHlFRYKVS82RDSyi4
	 SbhA5HmIgdVVR4KsVb4/1mFJ6KqvncGYuwNwZSda5Zjon4pY9/tgioJs2Xm+pql3oh
	 LWyIiOyY0mGkP9F1jPPS2RsqY9jiS9KoqgyrB3rH9emmpAG8tV5IR6xKxuWhUftFkI
	 fZ3veNg46sNPb7csrLsgu0bdyxFY4IjnGZY9iHwkH2f2DipheEWOq90pkMcFloOXvW
	 Q8awvutvZGHd2RgO5mAfioeREd771cZIuR58KwK+upvv/yITUKz0VacsDBuOe3Sr4T
	 IsZWX4Mz5m9Mw==
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
Subject: [PATCH v2 4/8] dma-mapping: Introduce DMA require coherency attribute
Date: Wed, 11 Mar 2026 21:08:47 +0200
Message-ID: <20260311-dma-debug-overlap-v2-4-e00bc2ca346d@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 765961A000B
X-Stat-Signature: 55hyx8axxrw7s3c71tgqozi3w8rueseq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773256149-129849
X-HE-Meta: U2FsdGVkX19oIUYZh8ZUnqdRhOG256EHCT+5E+MnnyhJ01fIELzSYJe9DDZ2yAv6gY69KCWrd7bt63BS+drp2nED36vwmc0E6NfEBE3NwtlvAXxe/85JTrKrQ7voWMrrnU6YuGWBco3XOiAEPy7FAhD1GLKgY6I0daqzcAhh0+LgKxrr0o78SlAgeg5i7D/8s5o1Q+/o7ddkDrpJKcMlDi3vDyvlopdS6FzDCCFIKWVDjHiC28lcgoqabCX2c+C3ZeUdBer607AI0mt10URlf53tGK2NquH52b344UFwf6xxzp17gwh38ojRqyMb5d388te5TaOCSwLBkH/t/EpYGmgfOIm2kgtUvlgHZLoKsk0HO2qZlbqjroGgSrGeOQ50y0eG0Eu84M2bmbk0S2ViOolw79TcYDXeufZzXSYMnRfmg0W+r5UWvJS5GZLg2b7fE00xaFmUCEQXyuXW13Ara9NlkxDE7NMDL8xOYOT11F2j3gMRgYFnZN3bmvsLdgTo6QrUG99Eg95h6ld1xjOw7MDa5HXaGLPJ53X0yqMJ3gTdv30KVw49PjbOKO6xAeyh4Y3SKL3w/oqLYAVsr6iDNGXSdt8Y1L3+F4MjliyWdAU//aze9G4TcZHvslG43okJ5JnNjqZfqc8CPsWGZZajnoxcq9tS6CZsuBNQOmyxRJrEV92dt225r7DlHupMe3kj5MWqUgj4jqG6xj8tqXq1FjqI5H91xSlMZTifJO1eDumUtOq9pDpLmayru6GndcyuUtWsVQOZH+E95gPtEpmSOPkQwP43dqdsdbWYHKn0A8FRKEwXb/CQpmvcHez9w9s/KnWol29Ky+U0UTBUeJGvy4mInilwM/KUYkw816dimBTG8rJtWupDa5/qp6kmSJazF5xIJKBMfUaHkvQRUCMe9z4hU1HDOd2gw2r3YlaaDm+23HdXo1SmbliWoy6lhgnpTuM28L7Q5EKGNulfiy6
 0r8WGBYg
 1cYEOcZpiejXY4ZQGH1nQ86P/xTtTkzWrWktpdptydqu0TGuug2ZpAIekp/HVMG8818mi2LZBpoBYYh4bK0J4xjTRim0L1Qey6C3wcQ4ZvgPzwn93+a0+Y1nom8rse3Goxt2W9IqbpQ1hOKw0VMQgF77VJzj6+GLD8ufH5VhdxniX6q7eHaCNbu5gL5uHtqQgdrHaksvddSr7tNRxI2Bc2DAQRf1rYrnsxkWre4XgHySDczw=
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
 Documentation/core-api/dma-attributes.rst | 12 ++++++++++++
 include/linux/dma-mapping.h               |  7 +++++++
 include/trace/events/dma.h                |  3 ++-
 kernel/dma/debug.c                        |  3 ++-
 kernel/dma/mapping.c                      |  6 ++++++
 5 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 48cfe86cc06d7..69d094f144c70 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -163,3 +163,15 @@ data corruption.
 
 All mappings that share a cache line must set this attribute to suppress DMA
 debug warnings about overlapping mappings.
+
+DMA_ATTR_REQUIRE_COHERENT
+-------------------------
+
+The mapping buffers which carry this attribute require DMA coherent system. This means
+that they can't take SWIOTLB path, can perform CPU cache overlap and doesn't perform
+cache flushing.
+
+If the mapping has this attribute then it is prevented from running on systems
+where these cache artifacts can cause corruption, and as such doesn't need
+cache overlapping debugging code (same behavior as for
+DMA_ATTR_DEBUGGING_IGNORE_CACHELINES).
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


