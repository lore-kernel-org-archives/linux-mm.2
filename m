Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74612CD343A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 00:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E8086B0093; Mon,  4 May 2026 20:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A236B0095; Mon,  4 May 2026 20:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060C76B0096; Mon,  4 May 2026 20:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9CB66B0093
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:27:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 922E140341
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:27:48 +0000 (UTC)
X-FDA: 84731478216.12.82D3610
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf27.hostedemail.com (Postfix) with ESMTP id CEEE640003
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:27:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b8iEpyBC;
	spf=pass (imf27.hostedemail.com: domain of 3gTn5aQgKCDAeWTMiMVMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3gTn5aQgKCDAeWTMiMVMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777940866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zufAZqrs7wE5NdNZHdqCW4lBwECX6d0FSow8KZpRsP8=;
	b=3uSq6J8y+mhNfdq2jgFJkp+LnX/dyJEKo4xoFdim2/1iSkQrBDckOsoxLpARdGDMEpgaU5
	l9fyHatp4NqyLr2mjdFo1zq0H+gEPChWhG5o78aBye+f1yHtapujw4EaY0wqkwtUFvcNjC
	Dhkf9Tan4wpJOg7MCjCwJ0odrI878DA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b8iEpyBC;
	spf=pass (imf27.hostedemail.com: domain of 3gTn5aQgKCDAeWTMiMVMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3gTn5aQgKCDAeWTMiMVMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777940866; a=rsa-sha256;
	cv=none;
	b=CJCyPzEl2J7t3Q664zj1T9SNkZFpImogHu1HY/2JDz+ylRMWTeuRwebv+JZytVkQxE/NPP
	2EtWvkShU3i+MbZTlEFSq2rNEmnjgOvNnEgetoanzmYdbJcg+MAD8NidvjoU7sI397ofbe
	Lg/lE69w+S3DR0bg9JrV/8oi7UmvsoM=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82d40278103so2750591b3a.2
        for <linux-mm@kvack.org>; Mon, 04 May 2026 17:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777940866; x=1778545666; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zufAZqrs7wE5NdNZHdqCW4lBwECX6d0FSow8KZpRsP8=;
        b=b8iEpyBCg1aif4O9Nqh8gw9EiiOZFpWdzcXcimBsDeJd3zpX/r5KDGnZvFM+jOwn5u
         jN23MYoUPSbxfRYcllp8Wfi7hB9x1FrT47291kK0eMteg2lUOhjkS3anvmq8HSxZP66+
         P6TIC+9eNogPSyBAFu1f0A3/7G0eveaaY0MeIdF/JyJwocFndsR6ZoeVZwzONd2jyJAR
         j1k8k2b1GsKsXb6h03rION587BdmOmXQ/M5Y+7KraMFN7yukkGhq1fIsjHyMXX12RLf7
         N/CUKge5ZPLhRGJwR/fYmcIvMDLUz+iR6vEigLE++ukM7XQ58fsl5WXKBRHJgiTkViun
         O9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777940866; x=1778545666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zufAZqrs7wE5NdNZHdqCW4lBwECX6d0FSow8KZpRsP8=;
        b=jYC6g/VxrIOQPpVg1pLOGgnAgkHO/28ijfUx5L0EjDHcwnBdpLm+aB4A8WocbiNVRp
         0TqE5Br9FqUoYF8tQJ6D13XLEJpc4TzwAsvgKvKPOWlnepWGo+j+2mEitdteB4KoLiCU
         MbzsQPlDGqzey4+1iyW9tGJoEDQaQaSNod4NXcOpyyStJg411cKuz4OX/R0SL9fmXiPH
         6iqowA7mk78Zl2O8fzgjgtXLwChEbCjDF6yToJ3Ix/ZC0q62ZqRtE1i/GjMB6CLQf3d8
         wqj2VzE8TADTjVyjoxpaCYCwcoMHOoETo8JFFqn85c1jVcdiW2IBDcyI+ZdM8UJsD1EX
         80Eg==
X-Forwarded-Encrypted: i=1; AFNElJ9FNe3NpWPRwQsjHkeYI4SY5xZDFvPPkIrYFPBam+eUZNy/IkCPA0rJt3LTbaliy0e9q1lc9PtodA==@kvack.org
X-Gm-Message-State: AOJu0Ywze18Ny+Q18ADpy0FwGJosuIQ+JaePPoEdY5gzVtlkhFInHRnz
	GLZCxlbMFYweXNuvMIRHGHEUy6Z7YtKBTCF248o7ZTfDwPmn1ssx2GiKyUtPeyUsk8bgDp6L/zf
	68+uMob7rQbiJsw==
X-Received: from pfbmb14.prod.google.com ([2002:a05:6a00:760e:b0:838:5125:b5e4])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3003:b0:835:42cf:1f7a with SMTP id d2e1a72fcca58-83921ef6cf1mr905533b3a.6.1777940865363;
 Mon, 04 May 2026 17:27:45 -0700 (PDT)
Date: Tue,  5 May 2026 00:27:37 +0000
In-Reply-To: <20260505002737.2213734-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260505002737.2213734-1-skhawaja@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260505002737.2213734-5-skhawaja@google.com>
Subject: [RFC PATCH 4/4] dma-mapping: Add API to preserve/restore DMA allocation
From: Samiullah Khawaja <skhawaja@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CEEE640003
X-Rspam-User: 
X-Stat-Signature: w5f4c1xpjwc13a9dbt8crg6p53xagcq4
X-HE-Tag: 1777940866-575318
X-HE-Meta: U2FsdGVkX18GE8ZCldWkEFKD/HbwLniSw2yQJyBzY+ewPrzlvImaE475O8d6oYfcWdVpV915erBfGB7Osgt/dQ1m6YoBZymDVQWMVxMnFTv7WGYM3R3Hp+zfJdKgrW5jeJgER3KNqAAf/Mnz4e38irZqsiWb6Vqb7JSSeo9HuLtw6UlOes2TQAmDd35eysnvbBKWvryGIZt3qBm0pWHiWhAZdNBEWRCvZDkeAP41bQjtgMWTyD/ikI22QP4v5loQ0e/ybTCCyrfuMREbkAE4GOg8ZxsXwq4rMHeyTMFeJ1doLyZEx8rLtVClDZdc0q8yLbwxWE8gokX6DUg9ZomXOKVajB4PBBraTP2jnK0STf6WG8byRBRp0oBkRMywk7/Gg+8gb3g+OllDEEtaylD02fwIVf83AvearmplARgnacPasYdBevNQLfgd04FAFmsSpptdVxWcVWAl0D/gdYa56QIgU30yWHwGxymX7eC2sGc5WR5cKDwQA2ffxJqbEf7bbSL+9nY05XEzNVvxQcPcjU/ZIUl6i+wo0rYYi9IB2SOMP+MMaGTAEMHPMqOZOI7ZWMgtHDk1SVxnbKnlu71uru2Ua5DaWcTnlXKFGHu/f83JXarLAnYXp2PSmgqTEomcPJCnJQPamMPwCpAUZzdoFLEop1L2NQRg3qiIy/822826DelQsfkwBuPkkk69/Jlk+2z38shg2NZ2TMCbQ4NTpk5JMECYWwQ1VoPpwgB0TNUNxD4VXOvWtfe/MR6CQCVhTqeqi1KYLcIjW35HMfWsgLqEf+fFM0/gRl3nroSme4xuz3ZsQm08riUB+3HsSkpNQQL8C+nGO51LtSRwd3VPujn0OSArnUQqLiynEHzhDGx1muovnl1+3KtfvqwOx1O4xPlpR/1/ts+YAEL30os9GzrtLBwwDeZXyUxeesovAxfXznJXKljlNkY03TnRFzofD8QpiVM1Lsd2BfZZ2W9
 NgKhGMtF
 HcskWY+qtNLC/xmcZ6IF58FwwAqDB/YvlLNx9fO1ATngIYC2Hf/31rBFxT5vjXsk3k1iB64dxYboycEndIUSQ4bIHvI8GW/V6m+mZdhWyaPQOC5H3s8A9WxeG2Z1P4KzPpRRJMU7b6tpMLhDWw/vyFm7yMNuJI4CzQXnpX6IBXH9CIxKs503tWnrUIUSaiIhZgYCEr0A+MIye8lzC+HHRWfJ5h6PgNIi93z0JYlajZ85RU1fWsTGnPO5lB8reN+zmgTkFJhAr8mGEmh2Mmw8XKLHdXwP/FOYX9TkRzvwpEXqNjgvfZcZyWnxR8V+tulYc55S5Ky9F47endTNti3qIy8DTE/EoPgoYNmaRNj9OryCiTarsy9MFaK33bsKXEPj1y7LDirKBP30wHdmv/TOnso7gREklEasJfm5IDLPYpfQB1kGeQCjDLLBxdHA7jPemDxJr/oNV9AUuG8zK+0GtQnbeSpkbvyQHIlbKqbLGLPxBUgrCImAldLeVTYWaqWEHwgFAc4FTyj1jRVIcN92IsyTK3Xgnnbp1qyjzvR8B1preOKoMrChcDDUbyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new DMA APIs that allow preserving/restoring DMA allocations across
live update.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/dma-mapping.h | 50 +++++++++++++++++++++++++++++++++++
 kernel/dma/mapping.c        | 52 +++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index db8ab24a54f4..3756fc15467b 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -210,6 +210,15 @@ void *dma_vmap_noncontiguous(struct device *dev, size_t size,
 void dma_vunmap_noncontiguous(struct device *dev, void *vaddr);
 int dma_mmap_noncontiguous(struct device *dev, struct vm_area_struct *vma,
 		size_t size, struct sg_table *sgt);
+#ifdef CONFIG_DMA_LIVEUPDATE
+int dma_preserve_allocation_attrs(struct device *dev, void *cpu_addr,
+				  size_t size, dma_addr_t dma_handle,
+				  unsigned long attrs, u64 *state);
+void dma_unpreserve_allocation(struct device *dev, u64 state);
+void *dma_restore_allocation_attrs(struct device *dev, size_t size,
+				   dma_addr_t *dma_handle, gfp_t gfp,
+				   unsigned long attrs, u64 state);
+#endif
 #else /* CONFIG_HAS_DMA */
 static inline dma_addr_t dma_map_page_attrs(struct device *dev,
 		struct page *page, size_t offset, size_t size,
@@ -496,6 +505,26 @@ static inline bool dma_need_unmap(struct device *dev)
 }
 #endif /* !CONFIG_HAS_DMA || !CONFIG_DMA_NEED_SYNC */
 
+#if !defined(CONFIG_DMA_LIVEUPDATE) || !defined(CONFIG_HAS_DMA)
+static inline int dma_preserve_allocation_attrs(struct device *dev, void *cpu_addr,
+						size_t size, dma_addr_t dma_handle,
+						unsigned long attrs, u64 *state)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void dma_unpreserve_allocation(struct device *dev, u64 state)
+{
+}
+
+static inline void *dma_restore_allocation_attrs(struct device *dev, size_t size,
+						 dma_addr_t *dma_handle, gfp_t gfp,
+						 unsigned long attrs, u64 state)
+{
+	return NULL;
+}
+#endif
+
 struct page *dma_alloc_pages(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp);
 void dma_free_pages(struct device *dev, size_t size, struct page *page,
@@ -618,6 +647,27 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 			(gfp & __GFP_NOWARN) ? DMA_ATTR_NO_WARN : 0);
 }
 
+static inline int dma_preserve_coherent_allocation(struct device *dev, void *cpu_addr,
+						   size_t size, dma_addr_t dma_handle, u64 *state)
+{
+	return dma_preserve_allocation_attrs(dev, cpu_addr, size,
+					     dma_handle, 0, state);
+}
+
+static inline void dma_unpreserve_coherent_allocation(struct device *dev, u64 state)
+{
+	dma_unpreserve_allocation(dev, state);
+}
+
+static inline void *dma_restore_coherent_allocation(struct device *dev, size_t size,
+						    dma_addr_t *dma_handle,
+						    gfp_t gfp, u64 state)
+{
+	return dma_restore_allocation_attrs(dev, size, dma_handle, gfp,
+					    (gfp & __GFP_NOWARN) ? DMA_ATTR_NO_WARN : 0,
+					    state);
+}
+
 static inline void dma_free_coherent(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_handle)
 {
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 23ed8eb9233e..c315b74a0884 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -12,6 +12,8 @@
 #include <linux/gfp.h>
 #include <linux/iommu-dma.h>
 #include <linux/kmsan.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/dma_alloc.h>
 #include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -628,6 +630,56 @@ u64 dma_get_required_mask(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(dma_get_required_mask);
 
+#ifdef CONFIG_DMA_LIVEUPDATE
+int dma_preserve_allocation_attrs(struct device *dev, void *cpu_addr,
+				  size_t size, dma_addr_t dma_handle,
+				  unsigned long attrs, u64 *state)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+#ifdef CONFIG_DMA_DECLARE_COHERENT
+	return -EOPNOTSUPP;
+#endif
+
+	if (dma_alloc_direct(dev, ops))
+		return dma_direct_preserve_allocation(dev, cpu_addr, size,
+						      dma_handle, attrs,
+						      state);
+
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL(dma_preserve_allocation_attrs);
+
+void dma_unpreserve_allocation(struct device *dev, u64 state)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (dma_alloc_direct(dev, ops))
+		dma_direct_unpreserve_allocation(dev, state);
+}
+EXPORT_SYMBOL(dma_unpreserve_allocation);
+
+void *dma_restore_allocation_attrs(struct device *dev, size_t size,
+				   dma_addr_t *dma_handle, gfp_t gfp,
+				   unsigned long attrs, u64 state)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	WARN_ON_ONCE(!dev->coherent_dma_mask);
+
+#ifdef CONFIG_DMA_DECLARE_COHERENT
+	return NULL;
+#endif
+
+	if (dma_alloc_direct(dev, ops))
+		return dma_direct_restore_allocation(dev, size, dma_handle,
+						     gfp, attrs, state);
+
+	return NULL;
+}
+EXPORT_SYMBOL(dma_restore_allocation_attrs);
+#endif
+
 void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t flag, unsigned long attrs)
 {
-- 
2.54.0.545.g6539524ca2-goog


