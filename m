Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9EFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500ED6B0098; Wed,  8 Jul 2026 19:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E226B0099; Wed,  8 Jul 2026 19:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 279DF6B009B; Wed,  8 Jul 2026 19:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD6946B0098
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:49:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40B9F8D284
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:03 +0000 (UTC)
X-FDA: 84967252566.16.8A5F7A4
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8A0801C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cmuYGTxk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 37OFOaggKCEUzroh3hqhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=37OFOaggKCEUzroh3hqhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+S3FWpLmbV8ubn+1hh1NL45mx9rPGtnbGgWXMOw/Cc=;
	b=ti27jzku65ztiHFQEKcZUThCZUKSiOAqAx9Cy8ZaK7/2fxZzkx6XuMg0xsgvQUNZruUF1x
	AzpvJ5m/X0qGjUGKoBXJizjJyGtP428og5iEq/PDgFme4jqHzRf/L1g8FEl1T0/mY9lWyR
	ZBRHMl3IIbXLz2DjLjM1tUYN4ul3/ZU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cmuYGTxk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 37OFOaggKCEUzroh3hqhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=37OFOaggKCEUzroh3hqhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783554541;
	b=vrkcimTeyjro8QMnij3ocJfAy37F4FSh0C2nXNGSqPmbI2cEs/zc36TH/IHRXEsavS2ShG
	G9bFL7BNoBw88qZdrPP/IqdwAHpxnJtasiy9lVNYx1XUV+oxdKWF5zrVev6J1dXVvjP+6G
	yjzyJhUsnCkiEMJFiPCBqnW3bM1hiOM=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8478ff5d801so2334846b3a.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554540; x=1784159340; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q+S3FWpLmbV8ubn+1hh1NL45mx9rPGtnbGgWXMOw/Cc=;
        b=cmuYGTxkwKTVYhG3v4UZEgLR+rLpokyqJKZRfDuq9+tTaXmpmx+rKd7QuP+5rjVTgU
         iTc7gi9pD+xn6VjagiuMyRzzhSRQKvvqkBfNl0mlIHIm8nLJ6z/8MCBMrbLMpc1Y7GVu
         KC5Rn6bb2Jtsr7eUuxgoQASJ7Z5zqvR6HGoG0QXPmNjwHGlUarrnqe4Hm0VA1TqbhKJi
         TsDKW04NyYFJJc1Yfa2ROIhfmFSFPHSGVXk66VvH9P0nnu2Ry0w1gVxnIjonwMAeXaCa
         XXGl0tCzQpO6JyfBdD5btV8tlq2Dy/7Ybdu2KW8ulINiRKRj7jg4Vim9h0iWHuaadcKZ
         rvVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554540; x=1784159340;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q+S3FWpLmbV8ubn+1hh1NL45mx9rPGtnbGgWXMOw/Cc=;
        b=n6vQ/fRWLZw6jhmcI1WGJFvIZWjloXLHBKjsktjWDzqe7aKsCzrTkVWlM+XqhIL37d
         dvodhWV7HucBJDtDW0D/QQKrElTIacNHAkSnXJrBDW/iOENOeh4cciGVR8kUrE686aev
         zUpwOiry3UNhqYKybRFWNEmX25VcCBx8pDxliVEVYR1shx7hjiKeY+5tbJ4OHNkpHsgf
         7oFUzPFFFGylzocCAD9Jl+JEiMAZW9lqgAhaNmzXvnLwNiw+Tax4pUxVp+sbAVEfRnKE
         iUK/EtZHqlU5YRhGdGkDxvKDjBIHh29y5bH1gyEZkk+sLbivFVbqxVZEyNHkm1QUJZkC
         mbpg==
X-Forwarded-Encrypted: i=1; AHgh+Rr05KJXikW7DvuPiiLBloSJWhAMl37shB2R2jgElHOe0UlwP6/zs2ie5W1uDtDQAJPTSTP4PjE9iA==@kvack.org
X-Gm-Message-State: AOJu0YwTJkrlLdWDqDzE70J3r8v42bUSKzYRsTRlnvLh776w//JVUiLN
	vduARU9EQeGTXp1SoRmw6Fc8WAi7u/KViIguW8iYhbpz3uEKoBg9qm7EdywCHakLG+9CySU56Ea
	AfVg4pK+PCI1KMg==
X-Received: from pfqp3.prod.google.com ([2002:aa7:9e83:0:b0:847:9570:daf0])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:8f0b:b0:842:708f:39be with SMTP id d2e1a72fcca58-84842fdf097mr4788740b3a.5.1783554540334;
 Wed, 08 Jul 2026 16:49:00 -0700 (PDT)
Date: Wed,  8 Jul 2026 23:48:50 +0000
In-Reply-To: <20260708234854.4044652-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260708234854.4044652-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708234854.4044652-7-skhawaja@google.com>
Subject: [RFC PATCH v2 06/10] dma-mapping: Add API to preserve/restore DMA allocation
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
X-Stat-Signature: xptsw5sm3amzmueoixgtxuz16gcecbc4
X-Rspamd-Queue-Id: 8A0801C0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783554541-588025
X-HE-Meta: U2FsdGVkX1/KT9pwMVxYAo8t3A8QsG/Gp0Fw/hQAJkaB21OTueozgUCLz99Ffi4QbVKCzCNfUrRxQBwomIy77Tlk+uwcyZHcirk1hW3u6iTc/3koImk8VOT2in1RPuPyqG+5Q0kHYvgMtDLQ9TQqEFiPfzEHa5ht4BCRMYQJWaD5gW6PK0HU4j1cS08Jca1uakGpNkjVkH+RB5sfQhdfi2t2bIYhonjen/wQo3rs2xchOXvX+EhOu3pcQ0SSLRw6dnQSrHwp6HBXcYgsMorBvq239Es0YMvg0xgXybWU2a1FYQp88gs2a8oJJDzL2dECn5HRZnWatUcB1v+Y/yl49xDfy6kcvoRKP1b+1sh0L9RcwFrpKIc4fa7ZD0gT1BJA40snzppxcHfACn1NUOrtz9Li43ZEGRyr9sEHsIxHo1314J5lnY7nlYCbcdJ56+pJgidAyza0aa3hEcFxeNY1vgeKxSNdkHKvGHehKjf//z+AMoafbU+uafqc/r8aj1juVjORzfSwi0fFLqcn0Jvxpj5cNMeBkKE26la1yUqFBlJaSaKps+ssms13yVJMS+rasg7StGcm5+KqabBGMJHiWr8M+oKcaJBbYndgFL36/4Kz3dYxK+6YEFRgU4GrfI1jqZc/ZsEa3omsz18d2e1YCUa6o4P7zqCzdl+BkFG/od+SXW2nMcbAAgU3ZuZ76yulFWX8XuI4LYslhSPS5NQWQJdaCu1acO21E+kV8kZdMkdOhbTBNlE2P4Kl++STDgOSmrwmxsCnlTKDaZtb386QkD7IdhqRy+5cpDz5qpbKX5O6XSFPjeJike8XEWjhI0SYgAOMRn7Z5OZkUxgKmf95lIyKFnT7qGbm7tH98/FWVtYMrWu5B+9zS1YI2zcSQ15d2gxGPqVP3GcVXnl3aYCvQDTPHCEn8svcibGSp9RefQT0aESNFrbUT9Za64jxwwDarJbmas2JXq1zYUUbAN0
 6MwR1D0L
 cp28sKrYWNJhsszqSfNaHWq0g9qunWE7p1f62N5vvO2CAfom2haaNX2jn9U7xQcDce0Y5wzoveEfnORrYz2IPEwVQ7o1COMsSxakIki97WHmOXpAoGkDIAuUTuTebvP51vdxrKpMI2jU0eZlw5XmvDNLbvobT36uo2JTTA/t2MIBMYtRe8JF8TvRHGBWh+hoIAU5bXLbLEwkpIA9WS9YeTSURz2O+3Mjta/z1y2sfZDCYtwHbqYayujVHlebfbsRAM56dLo0ySDkf0cW0BuJoyB7HWLZTvWNIxyLApFM0D1Y0BXhEuY84afJT6GuoBk5N1+CGGpkLMCUvZGJQSex8J0ajYpbxFkS8OYAJoo79CIylxftqV5eZL7c+PyWDFWo/Ipz8sxgBX2gbcuaVYakkc0fOyvJYwgWdHu6sPmNoR7+X8k6pgpGA/FZOaNtdJkfNoh6VuN5aD/vlPR0EygqGmsDmvw324VjD81veCecfPErTXmqH+/9LUeFJ57wYN0nymbPahh2ReRzOxh4B0ugBrXWxIZ57VgUeo9ksZBptq43hj+4qD3TbWlqIiSvQS+OrQV2z7/iO4RWrxtm1oZfaqhaUHPvSP0XFu4OV
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
 include/linux/dma-mapping.h | 50 +++++++++++++++++++++++++++++++++++++
 kernel/dma/mapping.c        | 49 ++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

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
index 23ed8eb9233e..3b07bf30722c 100644
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
@@ -628,6 +630,53 @@ u64 dma_get_required_mask(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(dma_get_required_mask);
 
+#ifdef CONFIG_DMA_LIVEUPDATE
+int dma_preserve_allocation_attrs(struct device *dev, void *cpu_addr,
+				  size_t size, dma_addr_t dma_handle,
+				  unsigned long attrs, u64 *state)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (dma_is_from_dev_coherent(dev, cpu_addr))
+		return -EOPNOTSUPP;
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
+	void *cpu_addr = NULL;
+
+	WARN_ON_ONCE(!dev->coherent_dma_mask);
+
+	if (dma_alloc_direct(dev, ops))
+		cpu_addr = dma_direct_restore_allocation(dev, size, dma_handle,
+							 gfp, attrs, state);
+
+	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr, attrs);
+	return cpu_addr;
+}
+EXPORT_SYMBOL(dma_restore_allocation_attrs);
+#endif
+
 void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t flag, unsigned long attrs)
 {
-- 
2.55.0.795.g602f6c329a-goog


