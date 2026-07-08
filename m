Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D81C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAF7D6B0095; Wed,  8 Jul 2026 19:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87476B0096; Wed,  8 Jul 2026 19:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F7C6B0098; Wed,  8 Jul 2026 19:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A050C6B0095
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:49:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 111981C3314
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:02 +0000 (UTC)
X-FDA: 84967252524.12.312A702
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf24.hostedemail.com (Postfix) with ESMTP id 57F73180004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cUJH9X4l;
	spf=pass (imf24.hostedemail.com: domain of 36-FOaggKCEQyqng2gpgmuumrk.iusrot03-ssq1giq.uxm@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=36-FOaggKCEQyqng2gpgmuumrk.iusrot03-ssq1giq.uxm@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKjGm5vgqAcCxqxTVhSOTHzJTWIKM6FvnNwlshe3+A8=;
	b=h5lQo0SRTups+KZCIIsexU2k0bTAyMNqhvjFap/LL+ODJij5crLoDsNuKCPMDbf3z/ZmZS
	4ivYluY/kC4dr4Ol9Dn5XAy5acY4QVczGPf8HCnjuHkxFhlo9kiIAfb4LLl4WFeL3WSRa5
	UeftUjOEotg0nWVw3qWBaixryeF0g1Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cUJH9X4l;
	spf=pass (imf24.hostedemail.com: domain of 36-FOaggKCEQyqng2gpgmuumrk.iusrot03-ssq1giq.uxm@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=36-FOaggKCEQyqng2gpgmuumrk.iusrot03-ssq1giq.uxm@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783554540;
	b=CgbrriiXU2yNQKvlcauX9Ds9vMNiPs4pzmRNfxh+wRcOnFrgif2pFVM4P5zzb5IqhFTq3A
	4q53nFZzCuyWWaS7gKG8fkNDAh7a/Z+yXgPDKgsEKAFWYmxZOKvJuAO8OC3KiyxeNmv55q
	+cNcFL1I4LDqLa33rzXH8eQAlxBieGI=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-848544a8496so490086b3a.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554539; x=1784159339; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jKjGm5vgqAcCxqxTVhSOTHzJTWIKM6FvnNwlshe3+A8=;
        b=cUJH9X4lOeeJ7CGFqfJvst8wr/fCeSZvxEm/R2MDzS6Tdi0n5imHdTQqHgu1uWj6be
         jiSL/+wWbqbu8JhTlhIGR4FG4IXLR756F8ef4JvH/K2C5+Y+g/kxZnp8yB82Ooaz3Ep9
         O/EwzyPBl4484rrW+bcUSm+VsOx0zFaT3n3lYFJyP7uPJ7MvEIB3Z5HezNwSYGoD1rrH
         5gweP91vWq3ajuTIfx/LvBnBe6Q/Mhs94b1FW2zRFxQWhYstHiZjI383tUovMnXmL3kk
         7sNyiODv9g7SPeuCwbrwW+E9C3/MX6K4eTJ7PPHtG32UCjczQHFKbbIDLSl4QpHvi5lm
         ZZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554539; x=1784159339;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jKjGm5vgqAcCxqxTVhSOTHzJTWIKM6FvnNwlshe3+A8=;
        b=b0hsdKF9Hx3eGdiEn0Xh042hLXk/WkkOqQ8Vc1KmVCC6Aqq6gloK21fElMzwRWz3EA
         3EG4T+Li6RtFLCsA61BtdXN82aqXakpxA9uMICQuejXvVG7QMpfqx2ZAY3vtGpEXdkl9
         sgniMEVwHtvSShlH/2MGz2WhYbhl0JnMT2fYsKJGpB8X63JF8mvE6g+hMtdF2uexWfzp
         Tq9oJr7V1N9OuIaav7DiSh4N6491lKLSHGA0u7yZ8TIH7SxkEiXD+QB2Wu01/oIcNTA7
         Vh5DJK8ptS+UfZGXGbh4LVn71I+acbtc3B8TrgdTwpc3ftNigNxZKaTD0u7KS/WKNiTW
         H+jA==
X-Forwarded-Encrypted: i=1; AHgh+RrzoSU1AQLqHeO6fzSr+3DHnW8DdCPLi9veDT6ezezjRVFRAC0iAWMIzsQdbKl0GjbMX1iz5sGhZg==@kvack.org
X-Gm-Message-State: AOJu0YyK5vFpJfjy/8JbLOevJlikQlRipYTfHNT4AT0hOoxmR8yO9Rss
	Pr7BJAxQ02hKiuUBEsVRb9wrt0MXPHrPVOtKBwmqvKMY5kndgan1MLb5WRyvQRl+KQAneDDqeNy
	Tph2yu8uaaPMcTw==
X-Received: from pfx25.prod.google.com ([2002:a05:6a00:a459:b0:847:878f:44f0])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4191:b0:845:d274:c021 with SMTP id d2e1a72fcca58-84843682779mr4464782b3a.58.1783554539065;
 Wed, 08 Jul 2026 16:48:59 -0700 (PDT)
Date: Wed,  8 Jul 2026 23:48:49 +0000
In-Reply-To: <20260708234854.4044652-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260708234854.4044652-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708234854.4044652-6-skhawaja@google.com>
Subject: [RFC PATCH v2 05/10] dma-direct: Add API to preserve/restore allocations
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
X-Stat-Signature: gtgnimehhprbx6eifba9kdqctraaa5go
X-Rspamd-Queue-Id: 57F73180004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783554540-258266
X-HE-Meta: U2FsdGVkX1+AOMxTiLqtyDKoT1q1uuTpAOQRhjX2d2cPRcdyQS3pKiv4w2UNgZw64eHHg8FAExA9bAR4vXG60sqO0AEvGenu1BgOGj6SMwPwCfiuHRwigEO41bZTlo+Wo3UvayCj5oDpvY+uomYfiWQWSF12vAf7ncLuah5QUc3t5lqCF14FFceqQVv42kEiXi9sLQSuC8B0GmvAe3RoPSWxdbKnazgNN862gptQa2V9bqZT+IonwI7KRWxf/lEXlqsE1HeSU2b145B8DQkxnwS4wODsPOQVrKPJCZYx57bUsc0zInDyVZueNxRayqJkqq6ZFzbm+PccW4q7+JTODY3z3phCR5j3pFfyxK5/TuMUV5DtG5oT8y4G3AJK7vOTgEIvRFZumBPye+I94ZpVSzuaARkJDgHRveHHoYCPiXzIP3F3ViCHMBDFobTcxhzptrz8btmhjhcZty+m+kZbpAa5QEQwOEmr6LKCJtKpxJKnRHjghM/vdAX0x2jqIsrsCEH+ObP1E0d+NJ/Y7FIQ7jILqiBxiQM3gD5S40s0qwBW/F3aecgEDLFx7M9djUTpx4RNgD9CACYI0AZtiqIkBypmgSXU+vHvVLUqA9rjlNHV0XClDY0L8+lEVkiA0dZZLim6J15kkg0zkoyh2xujlZX5QUUfRk+GF03iUiPvnw6ThcFEcO7Zlkb+8xEXgwD31VSiarmfjanllOf+VJuyFELLkW3KVXvpkSRKbRTnrqTLq/L0QRPYlft+ng7iJX8x8qy/hN+SCxZhHx0971DPVSfY8Nhdqguh0OmWvmDZbzIfwGueS/qftbA8bj9dmaCBWPXYl9+1jgj5f8vnj8hIuNB9lJSsLhiasoGkRxvFD9hkHC9UGoZSHX/DvNG5e0/oI9E/2mcWtTnjzxvAKxfandeCNzupSIz58AiEAgI17vkzTDQ6b/c89alF51iBN1SccZO+NwSksUuzTxE4o6l
 8PdZP0Pa
 rveRiT2gYUODX4224/2tDbugcVdNgdrxB7j0vL23UmG/BkF6iuLluAhkH5jXVmtVPaqPdxZUH9Ualp8mKShmr8Qb1GAsAK0F4NTad3wxfUK3kZ44wyUqnW6XVcVj92Yaf75zhBwCc5BYnnXsjj0ngejJyV/9xc5+FXy5q8sTHQ2s5wRyYrTEFWqyw62OyBQ3HSWAy0bui5ku/uSJAPZBXgHTCsFgDnC5czS58uUmG3VsDF6AX00URfumYgODP75x6rEnHTmcFin8XpXIv1PmnUMLmXSl7qNeyaJRyJF5tetIgIDxWNmv7X1jMeXFvBhw85+2QQGpT/FZEZVbTpV/LlGIKBvs6mA1tXedhN2UM3mM0Tm8LdBoc9e5dRNooxbtHJgaOpPmX3wuSWAPuEJ997Zvd/mlAbbyOONM1q6j+Lrvk0DBFfnrou9hcQ+51DnEz+Ad+f7q+oEuuI9OWComtujE59N6/P1GHKdcyiSVeas8bDobGUC6UOM3m535G566XbhteT5sxPHbM96cW4g4nYWBGjpXbguXKU0ueqLd9CtvZo0UIi6/6KZ+FRs0vpdhLpHN7CtrKeXxvWgoDUtMztB7kKXC/lP1r4DXM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an API to preserve/restore the DMA direct allocation for liveupdate.
The underlying memory is preserved/restored using KHO. During restore
the memory is setup based on the device configuration, gfp flags and
allocation attributes. Once restored, the driver can use the usual
dma_free* API to deallocate the restored DMA allocation.

This API will be used to add support in dma_alloc* APIs to
preserve/restore the DMA allocations.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/dma-direct.h |  29 ++++++
 kernel/dma/Kconfig         |   4 +
 kernel/dma/direct.c        | 189 +++++++++++++++++++++++++++++++++++++
 3 files changed, 222 insertions(+)

diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index c249912456f9..0efe2bc1a815 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -141,6 +141,35 @@ static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size,
 u64 dma_direct_get_required_mask(struct device *dev);
 void *dma_direct_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
+
+#ifdef CONFIG_DMA_LIVEUPDATE
+int dma_direct_preserve_allocation(struct device *dev, void *cpu_addr,
+				   size_t size, dma_addr_t dma_handle,
+				   unsigned long attrs, u64 *state);
+void dma_direct_unpreserve_allocation(struct device *dev, u64 state);
+void *dma_direct_restore_allocation(struct device *dev, size_t size,
+				    dma_addr_t *dma_handle, gfp_t gfp,
+				    unsigned long attrs, u64 state);
+#else
+static inline int dma_direct_preserve_allocation(struct device *dev, void *cpu_addr,
+						 size_t size, dma_addr_t dma_handle,
+						 unsigned long attrs, u64 *state)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void dma_direct_unpreserve_allocation(struct device *dev, u64 state)
+{
+}
+
+static inline void *dma_direct_restore_allocation(struct device *dev, size_t size,
+						  dma_addr_t *dma_handle, gfp_t gfp,
+						  unsigned long attrs, u64 state)
+{
+	return NULL;
+}
+#endif
+
 void dma_direct_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs);
 struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
index bfef21b4a9ae..d93958931303 100644
--- a/kernel/dma/Kconfig
+++ b/kernel/dma/Kconfig
@@ -265,3 +265,7 @@ config DMA_MAP_BENCHMARK
 	  performance of dma_(un)map_page.
 
 	  See tools/testing/selftests/dma/dma_map_benchmark.c
+
+config DMA_LIVEUPDATE
+	bool "Enable preservation of DMA direct allocations"
+	depends on LIVEUPDATE
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index ec887f443741..117ebae8a81f 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -6,6 +6,8 @@
  */
 #include <linux/memblock.h> /* for max_pfn */
 #include <linux/export.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/dma_alloc.h>
 #include <linux/mm.h>
 #include <linux/dma-map-ops.h>
 #include <linux/scatterlist.h>
@@ -307,6 +309,193 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	return NULL;
 }
 
+#ifdef CONFIG_DMA_LIVEUPDATE
+int dma_direct_preserve_allocation(struct device *dev, void *cpu_addr,
+				   size_t size, dma_addr_t dma_handle,
+				   unsigned long attrs, u64 *state)
+{
+	struct dma_alloc_ser *ser;
+	int ret;
+
+	if (!kho_is_enabled())
+		return -EOPNOTSUPP;
+
+	size = PAGE_ALIGN(size);
+	if (dma_is_from_cma(dma_to_phys(dev, dma_handle), size))
+		return -EOPNOTSUPP;
+
+	if (is_swiotlb_for_alloc(dev))
+		return -EOPNOTSUPP;
+
+	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
+	    !force_dma_unencrypted(dev))
+		return -EOPNOTSUPP;
+
+	if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_ALLOC) &&
+	    !dev_is_dma_coherent(dev))
+		return -EOPNOTSUPP;
+
+	if (IS_ENABLED(CONFIG_DMA_GLOBAL_POOL) &&
+	    !dev_is_dma_coherent(dev))
+		return -EOPNOTSUPP;
+
+	if (IS_ENABLED(CONFIG_DMA_COHERENT_POOL) &&
+	    dma_is_from_pool(cpu_addr, size))
+		return -EOPNOTSUPP;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	ser->page_phys = dma_to_phys(dev, dma_handle);
+	ser->force_decrypted = force_dma_unencrypted(dev);
+	ser->size = size;
+	ser->attrs = (attrs & ~DMA_ATTR_NO_WARN);
+
+	ret = kho_preserve_pages(phys_to_page(ser->page_phys),
+				 1 << get_order(size));
+	if (ret) {
+		kho_unpreserve_free(ser);
+		return ret;
+	}
+
+	*state = virt_to_phys(ser);
+	return 0;
+}
+
+void dma_direct_unpreserve_allocation(struct device *dev, u64 state)
+{
+	struct dma_alloc_ser *ser;
+
+	if (!kho_is_enabled())
+		return;
+
+	ser = phys_to_virt(state);
+	kho_unpreserve_pages(phys_to_page(ser->page_phys),
+			     1 << get_order(ser->size));
+	kho_unpreserve_free(ser);
+}
+
+void *dma_direct_restore_allocation(struct device *dev, size_t size,
+				    dma_addr_t *dma_handle, gfp_t gfp,
+				    unsigned long attrs, u64 state)
+{
+	bool remap = false, set_uncached = false;
+	struct dma_alloc_ser *ser = NULL;
+	struct page *page;
+	void *cpu_addr = NULL;
+	int i;
+
+	if (!kho_is_enabled())
+		return NULL;
+
+	ser = phys_to_virt(state);
+	page = phys_to_page(ser->page_phys);
+
+	size = PAGE_ALIGN(size);
+	if (size != ser->size)
+		return NULL;
+
+	WARN_ON_ONCE((attrs & ~DMA_ATTR_NO_WARN) != ser->attrs);
+
+	/*
+	 * Cannot free the restored pages on error here as these might be in use
+	 * by a device with direct allocation in the previous kernel.
+	 */
+	if (is_swiotlb_for_alloc(dev))
+		goto err;
+
+	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
+	    !force_dma_unencrypted(dev))
+		goto err;
+
+	if (!dev_is_dma_coherent(dev)) {
+		if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_ALLOC))
+			goto err;
+
+		if (IS_ENABLED(CONFIG_DMA_GLOBAL_POOL))
+			goto err;
+
+		set_uncached = IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED);
+		remap = IS_ENABLED(CONFIG_DMA_DIRECT_REMAP);
+		if (!set_uncached && !remap)
+			goto err;
+	}
+
+	if (PageHighMem(page)) {
+		remap = true;
+		set_uncached = false;
+	}
+
+	/*
+	 * Remapping will be blocking so return error. The preserved memory
+	 * might be already decrypted in the previous kernel, but the decryption
+	 * call is not guaranteed to be non-blocking so return error always if
+	 * decryption is required.
+	 */
+	if ((remap || force_dma_unencrypted(dev)) &&
+	    dma_direct_use_pool(dev, gfp))
+		goto err;
+
+	/*
+	 * Encryption scheme changed between two kernels and this might cause
+	 * issues if device/driver is not handling it properly.
+	 */
+	WARN_ON_ONCE(ser->force_decrypted != force_dma_unencrypted(dev));
+
+	/*
+	 * arch_dma_prep_coherent() should make sure that any cache lines from
+	 * the previous kernel, if the device was coherent previously or cached
+	 * mapping in this kernel during init are not problematic for
+	 * non-coherent allocations.
+	 */
+	if (remap) {
+		pgprot_t prot = dma_pgprot(dev, PAGE_KERNEL, attrs);
+
+		if (force_dma_unencrypted(dev))
+			prot = pgprot_decrypted(prot);
+
+		arch_dma_prep_coherent(page, size);
+
+		cpu_addr = dma_common_contiguous_remap(page, size, prot,
+						       __builtin_return_address(0));
+		if (!cpu_addr)
+			goto err;
+	} else {
+		cpu_addr = page_address(page);
+		if (dma_set_decrypted(dev, cpu_addr, size)) {
+			cpu_addr = NULL;
+			goto err;
+		}
+	}
+
+	if (set_uncached) {
+		arch_dma_prep_coherent(page, size);
+		cpu_addr = arch_dma_set_uncached(cpu_addr, size);
+		if (IS_ERR(cpu_addr)) {
+			cpu_addr = NULL;
+			goto err;
+		}
+	}
+
+	*dma_handle = phys_to_dma_direct(dev, ser->page_phys);
+
+err:
+	WARN_ON(!kho_restore_pages(ser->page_phys,
+				   1 << get_order(ser->size)));
+	kho_restore_free(ser);
+
+	/*
+	 * DMA direct API expects high-order allocations, so set refcount of
+	 * tail pages to zero.
+	 */
+	for (i = (1 << get_order(size)) - 1; i > 0; --i)
+		set_page_count(page + i, 0);
+
+	return cpu_addr;
+}
+#endif
+
 void dma_direct_free(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_addr, unsigned long attrs)
 {
-- 
2.55.0.795.g602f6c329a-goog


