Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D771CA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1F86B00A0; Sat,  3 Oct 2026 17:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CE16B00A1; Sat,  3 Oct 2026 17:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B136B00A2; Sat,  3 Oct 2026 17:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D21856B00A0
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C14C1C3B0E
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:04 +0000 (UTC)
X-FDA: 85282590288.02.D3276B6
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf20.hostedemail.com (Postfix) with ESMTP id A8A591C000A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aGSv5J0j;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3NHLBagYKCHskqhyynfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3NHLBagYKCHskqhyynfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxnWfCtIeX20UabhbwcYMIUINCIuBjoP15nZymAWMw0=;
	b=xDOaN08BEKWfpbLlCAS0W4xu/vz+wDR25FWgdNX6j2GNCSpiXA7jGr4SscpihbLr/jj7vQ
	1cdZlNaaeyA8/tW9+shi6TEHNp6OKw/uem6dQSEZGs8bRbpwO3swtaivKRZo+FBIiye5A/
	rB/HmGSTH18DP/nwy9KSjlHF8Q+ugTg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aGSv5J0j;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3NHLBagYKCHskqhyynfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3NHLBagYKCHskqhyynfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062582;
	b=SDSNp2ZHtF/X0b9nPZuXxlfBIlVO3fSfb1B7rDWMjO7sHWn8SHO3g+V4y8pocoyUQDKDXZ
	vvPQg1Vt7zYm0TQqoaBI6WljEXHaAA//1W2pPJnaWoSIRCdEezVn+pQ36fmVf3da77u2XZ
	P3vvExfCEtMIuh97whZVHIiuS3wD0mw=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c2939083cefso89434266b.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062581; x=1791667381; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sxnWfCtIeX20UabhbwcYMIUINCIuBjoP15nZymAWMw0=;
        b=aGSv5J0jMskFDfF0gV/zf1zDY0/fDiU4hpve8tdesiMqV9WDEgbY6ujxnMz2lSX3yj
         rMqOKYBpEtinjLYQjAKtBAbF1cUA14Vu4KlEm+apC35YUI9lXVSiAtvlSuTX/jdKym3E
         G8pI1SUy6blMq39s1slucFtoK1uYQWcUwdHbn+G7M2cl5QJCVjJwa7ZdgU0VP1EVD7iK
         ieUFMHlnOwVARBcEDzm6iGcLtpUyuzNLWNFPqPFTgx4FKWFasE+GqMjylHp/GKqTbp5H
         ptvUkgrIp3BZF6BYb3V9GYW5Vens1BcPGD4UvWRnLHfUvZoeBrwpyZzu1YGAfTahC5uh
         zAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062581; x=1791667381;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sxnWfCtIeX20UabhbwcYMIUINCIuBjoP15nZymAWMw0=;
        b=1AK62kpz+eWiggdPjIePbU20EQaGAlC3eDEmChn+k0e6RqAVswxnbCKHPmgCp6LTa3
         7nuPrR0pwzRfkNP6FRilgAVTaw4T7fILiS3hQUp5lLIoGwBRskng1rIOednFv4Zyxi3q
         qiVcJWYBG1yiN95MW3kZUYuR2DJpQ3WJlPZmm2BCK+XfFPPHi1XSkb/wk6CPHiQgctGg
         3sUMtOeOweb0AyiSi7vImdmI+n/WTLtLMl87tmokLGv5y8PfXReC9vKHWo8cQDClDmIa
         ut8Ewm029lRpjcAcUamLjSjrx+lI0fyk+f8UbuYHGt6tYHAc7o26k7KX62BioX18o1Ps
         RNQA==
X-Forwarded-Encrypted: i=1; AKwUvByvWn2jxPZDOjjoFU61Pp9qsASmunTUZ8XH0h2EHBvcfCtg/NJBGrl7wbe4SIMa63GbQgQIr2QNKA==@kvack.org
X-Gm-Message-State: AFuF++m57fLiWUmqbtmkrspntVu6jSNdosk+acdpDHGWq8XJml0hLA+I
	/qqtFPQbnxu/01qcxDkrx2yeu706enn7QJE36wddck6PJSEqlmftvzp/qd/viPTb+GNjFsQWoe3
	ExRG4kQ==
X-Received: from edgj17-n2.prod.google.com ([2002:a05:6402:a5d1:20b0:6ae:2baf:8e53])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7282:b0:c2d:fc0b:551c
 with SMTP id a640c23a62f3a-c2e4ad7caa6mr536656666b.16.1791062580744; Sat, 03
 Oct 2026 14:23:00 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:30 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-12-lrizzo@google.com>
Subject: [RFC: DMA_PMD 11/22] dma-mapping: Use DMA_PMD arena for dma_alloc_attrs()
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A8A591C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: h1mz9oeni4ja1cne4sg8p9htgnyxmtc8
X-HE-Tag: 1791062582-940733
X-HE-Meta: U2FsdGVkX19lEPVlgr3JPOHraxQXItP2Mk1PvsYzFUzbz4fArypDUhk7HOIu5DVtyNH0blv4a6rmY5L8fRATRRPNKOSyTlfEoZFor0SvJyU9L9McRp96xmNOuFf00X66G3AxvdFOd0heDmW9s/aTXhh69pHDPYi1AGWYLYqRczVYJIX5EZDLJU8zOtvB03mj+6bM4ORXxOmF6EEBab497ZrfbcVGuNp6AzZRpwzgAA4ujOkpZv9XgZ780yuyfxpTplmHP6E8MImkSs2b9QEsSkXRmZtfqw73J9ob6aAwNZoSJh0X6HumKgmM4M0R4QKuFTJ6u/xQ5XnQaXFbFxyNx+lmYb9WreEibp3aSM9pz83GVtJ+Dfu0O9q8P85IrbhGJBmyCxeCKQzUw7sUgAlnPw69vVWBfldf+/RXLg9s9izS1f1aLSsm/DxYMNAFFY9oY0U4CR8supOhjAzGqLXZNMBAd/PmvoBZEqHjeJEPXKgtfDPKepJ7OO/3AB59Cton9IaFwCz3R82weciubyU/uE/o53l084LKQNk9wKRNs28WA0rD5NzySnieUDkT8+kG9deNtDvdhYMrXEGgYjxkqF/oY1wgkQ/vcMAie9g8rfbvnmOuo1eUsR97uiFrz1JbLSrWPN6ZT4Wqv3S/Y5bqQPWShgxlVTj6c7X83ta0AjxkuG7OSbxwRYR2/78MLUl8zFN2L4EI9uQoSi20H3weyht4wQ9f0O8gAXjNnzzr8x3pIKVSWy3dyYMD+PHOgQGcRsGg4x5IwRMXu6dRwnGf4Zmb57PyHC/6i/FXbf+d57FNCMGVKCS7WrMMIce20mLZGgElkuwRuWXxyYeZpi1fAVNiF4Vg2YmQ/zOk+mNZO/XYc26jrn6i8NvZhwtFJk2mqkCv1qCw5yfKwLB6/fmrqEvJ5cshessJJZo7QrINS/F1Kqt1HhygQyf0iLWchMxnHpKFHpUV99KeHLjxZUt
 bX7kTJWn
 vZ4vjveic8dNwt/Usrp58/nWOUv2D5zYEuk4tQlGrxYlRPyLof2alq5/rsjAFOvDDDK6DhBZdllFUanP6RrmMxGL/WqU5y/+cWssC/K+M9QLRkNZKT7Dg7Co1NwF0OrRJkY8L4pW/dKPSH5uAOe5Zgl8v71bhfFammW3yj3hMuJ8o6cMH/i0ZWgI+cBkRMq92P6fPB1SlxuVJClQiHzDhoG6/tJoIAASNko5VTjMxC3UDFkJLHhAZcBI8bIi06kzrSoFvJvsDlZIqn8m1SubxFd54PS6PafUBXiES/7B1XsWyYO+BC/QUsqhjqEk9D/+obuh77UQQ9bReQxrfiYtFagQp6OfYMRVeCT/1scWAVV5sW8OX+alMTlxWeN4ovhsCIvn0DN6OL1xxhTQCoRNeHt3mMbP+g+nfDF4Yb4Z+XulBHgG+72lvQiru+1EJXyeQI4QTOr4GgZzpHqc0SQ81XHKCctyEOpPDfCCpRCYZLsFSIdjWxU5lL+MlMqDjTp/iVGwsTY3g8lr3YOKCmoiLVMIaq1A0V9vy+JzcJ/g4PD3HVwroiRfjIXqlixvxojmZtooguYjKeszdtsC4KzS6jh0z2dMg0V45RxHyWRPYpBv/CVhth71SA5QR9FWwPqm916YmmtZT5mk1RppE7J4sEGjVtVGc7F9q1fBX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wire dma_alloc_attrs() and dma_free_attrs() into the DMA_PMD arena
when dev->dma_pmd_rings is enabled on a device:
  - Add dma_pmd_dma_alloc() and dma_is_pmd_dma() backed by
    dma_pmd_arena.
  - Route GFP_KERNEL dma_alloc_attrs() requests through dma_pmd_dma_alloc()
    when dev->dma_pmd_rings is set, logging latency when
    dev->dma_pmd_debug is enabled.
  - Reclaim sub-allocations back to the arena in dma_free_attrs() via
    dma_pmd_arena_free() while keeping the PMD_SIZE IOMMU mapping active.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/dma-pmd-arena.c | 27 ++++++++++++++++++++++++
 drivers/iommu/dma-pmd-kunit.c | 11 +++++++---
 drivers/iommu/dma-pmd-map.c   | 17 +++++++++++++++
 include/linux/dma-pmd.h       | 29 ++++++++++++++++++++++++++
 kernel/dma/mapping.c          | 39 +++++++++++++++++++++++++++++------
 5 files changed, 114 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/dma-pmd-arena.c b/drivers/iommu/dma-pmd-arena.c
index 578df5be86a86..e1a7d9d6f0f60 100644
--- a/drivers/iommu/dma-pmd-arena.c
+++ b/drivers/iommu/dma-pmd-arena.c
@@ -383,3 +383,30 @@ void *dma_pmd_arena_alloc(struct device *dev, size_t size, dma_addr_t *dma, int
 	return NULL;
 }
 EXPORT_SYMBOL(dma_pmd_arena_alloc);
+
+void *dma_pmd_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma,
+			gfp_t gfp, unsigned long attrs)
+{
+	void *va;
+
+	if (!dev || !dev->iommu_group || !dev_is_dma_coherent(dev))
+		return NULL;
+	/*
+	 * The arena allocates PMD pages, IOMMU page tables, and vmap() areas
+	 * with GFP_KERNEL, and shares PMD pages across allocations on the same
+	 * device. Decline non-GFP_KERNEL requests (including GFP_NOFS/GFP_NOIO
+	 * or scoped memalloc_nofs/noio contexts) and per-allocation modifiers
+	 * such as __GFP_ACCOUNT or __GFP_NORETRY so the caller falls back to
+	 * the standard DMA allocator.
+	 */
+	if ((current_gfp_context(gfp) & ~(__GFP_ZERO | __GFP_NOWARN)) != GFP_KERNEL ||
+	    (attrs & ~DMA_ATTR_NO_WARN))
+		return NULL;
+
+	va = dma_pmd_arena_alloc(dev, size, dma, dev_to_node(dev));
+	if (!va && !(gfp & __GFP_NOWARN) && !(attrs & DMA_ATTR_NO_WARN))
+		dev_warn_ratelimited(dev, "DMA_PMD arena alloc failed (size %zu)\n",
+				     size);
+	return va;
+}
+EXPORT_SYMBOL(dma_pmd_dma_alloc);
diff --git a/drivers/iommu/dma-pmd-kunit.c b/drivers/iommu/dma-pmd-kunit.c
index b91dbcb468879..c2363277e2ecd 100644
--- a/drivers/iommu/dma-pmd-kunit.c
+++ b/drivers/iommu/dma-pmd-kunit.c
@@ -169,11 +169,16 @@ static void test_window_helpers(struct kunit *test)
 static void test_arena_alloc_and_free(struct kunit *test)
 {
 	struct device dev = { .numa_node = NUMA_NO_NODE };
-	void *v1, *v2, *v3, *vl1;
 	dma_addr_t d1, d2, d3, dl1;
+	void *v1, *v2, *v3, *vl1;
 
-	KUNIT_EXPECT_NULL(test,
-			  dma_pmd_arena_alloc(NULL, SZ_4K, &d1, NUMA_NO_NODE));
+	KUNIT_EXPECT_NULL(test, dma_pmd_arena_alloc(NULL, SZ_4K, &d1, NUMA_NO_NODE));
+	KUNIT_EXPECT_NULL(test, dma_pmd_dma_alloc(NULL, SZ_4K, &d1, GFP_KERNEL, 0));
+	KUNIT_EXPECT_NULL(test, dma_pmd_dma_alloc(&dev, SZ_4K, &d1, GFP_KERNEL, 0));
+	KUNIT_EXPECT_NULL(test, dma_pmd_dma_alloc(&dev, SZ_4K, &d1,
+						  GFP_KERNEL | __GFP_ACCOUNT, 0));
+	KUNIT_EXPECT_FALSE(test, dma_pmd_free(&dev, SZ_4K, NULL, 0));
+	KUNIT_EXPECT_FALSE(test, dma_is_pmd_dma(&dev, 0));
 
 	v1 = dma_pmd_arena_alloc(&dev, SZ_64K, &d1, NUMA_NO_NODE);
 	KUNIT_ASSERT_NOT_NULL(test, v1);
diff --git a/drivers/iommu/dma-pmd-map.c b/drivers/iommu/dma-pmd-map.c
index 1147874ac8068..76cb5d01cb1e8 100644
--- a/drivers/iommu/dma-pmd-map.c
+++ b/drivers/iommu/dma-pmd-map.c
@@ -380,6 +380,23 @@ int dma_pmd_window_assign(struct device *dev, struct iommu_domain *domain,
 	return ret;
 }
 
+/**
+ * dma_is_pmd_dma - Test whether @dma lies in @dev's DMA_PMD IOVA window
+ * @dev: Device performing DMA
+ * @dma: DMA address to test
+ */
+bool dma_is_pmd_dma(struct device *dev, dma_addr_t dma)
+{
+	struct dma_pmd_window *win;
+
+	if (!dev || !dev->iommu_group)
+		return false;
+
+	win = dma_pmd_dma_window(iommu_get_dma_domain(dev));
+	return win && dma_pmd_window_owns(win, dma);
+}
+EXPORT_SYMBOL(dma_is_pmd_dma);
+
 /**
  * dma_pmd_dma_map_phys - Derive the IOVA of a pool address, mapping if needed
  * @dev: Device performing DMA
diff --git a/include/linux/dma-pmd.h b/include/linux/dma-pmd.h
index 55c770fe232b0..7b7e9477d44e1 100644
--- a/include/linux/dma-pmd.h
+++ b/include/linux/dma-pmd.h
@@ -96,7 +96,19 @@ static inline struct page *dma_pmd_pool_alloc(struct dma_pmd_pool *pool, gfp_t g
 bool dma_pmd_pool_has_free(struct dma_pmd_pool *pool);
 
 /* Hooks for kernel/dma/mapping.c */
+void *dma_pmd_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma,
+			gfp_t gfp, unsigned long attrs);
 bool dma_pmd_arena_free(struct device *dev, size_t size, void *cpu_addr, dma_addr_t dma);
+bool dma_is_pmd_dma(struct device *dev, dma_addr_t dma);
+
+static inline bool dma_pmd_free(struct device *dev, size_t size,
+				void *cpu_addr, dma_addr_t dma_handle)
+{
+	/* Pairs with smp_store_release() in dma_pmd_meta_init(). */
+	if (likely(!smp_load_acquire(&dma_pmd_meta_array)))
+		return false;
+	return dma_pmd_arena_free(dev, size, cpu_addr, dma_handle);
+}
 
 #else /* !CONFIG_DMA_PMD */
 
@@ -144,11 +156,28 @@ static inline bool dma_pmd_pool_has_free(struct dma_pmd_pool *pool)
 	return false;
 }
 
+static inline void *dma_pmd_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma,
+				      gfp_t gfp, unsigned long attrs)
+{
+	return NULL;
+}
+
 static inline bool dma_pmd_arena_free(struct device *dev, size_t size,
 				      void *cpu_addr, dma_addr_t dma)
 {
 	return false;
 }
 
+static inline bool dma_is_pmd_dma(struct device *dev, dma_addr_t dma)
+{
+	return false;
+}
+
+static inline bool dma_pmd_free(struct device *dev, size_t size,
+				void *cpu_addr, dma_addr_t dma_handle)
+{
+	return false;
+}
+
 #endif /* CONFIG_DMA_PMD */
 #endif /* _LINUX_DMA_PMD_H */
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index bf2651a70b7c2..cc18896017e35 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -10,6 +10,8 @@
 #include <linux/dma-map-ops.h>
 #include <linux/export.h>
 #include <linux/gfp.h>
+#include <linux/ktime.h>
+#include <linux/dma-pmd.h>
 #include <linux/iommu-dma.h>
 #include <linux/kmsan.h>
 #include <linux/of_device.h>
@@ -180,7 +182,8 @@ dma_addr_t dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 	if (!is_mmio)
 		kmsan_handle_dma(phys, size, dir);
 	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
-	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
+	if (IS_ENABLED(CONFIG_DMA_API_DEBUG) && !dma_is_pmd_dma(dev, addr))
+		debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
 
 	return addr;
 }
@@ -223,7 +226,8 @@ void dma_unmap_phys(struct device *dev, dma_addr_t addr, size_t size,
 	else if (ops->unmap_phys)
 		ops->unmap_phys(dev, addr, size, dir, attrs);
 	trace_dma_unmap_phys(dev, addr, size, dir, attrs);
-	debug_dma_unmap_phys(dev, addr, size, dir, attrs);
+	if (IS_ENABLED(CONFIG_DMA_API_DEBUG) && !dma_is_pmd_dma(dev, addr))
+		debug_dma_unmap_phys(dev, addr, size, dir, attrs);
 }
 EXPORT_SYMBOL_GPL(dma_unmap_phys);
 
@@ -633,7 +637,11 @@ EXPORT_SYMBOL_GPL(dma_get_required_mask);
 void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t flag, unsigned long attrs)
 {
+	bool debug = unlikely(READ_ONCE(dev->dma_pmd_debug)) && gfpflags_allow_blocking(flag);
 	const struct dma_map_ops *ops = get_dma_ops(dev);
+	bool can_block = gfpflags_allow_blocking(flag);
+	bool from_arena = false;
+	u64 start_ns = 0;
 	void *cpu_addr;
 
 	WARN_ON_ONCE(!dev->coherent_dma_mask);
@@ -655,10 +663,14 @@ void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	if (force_dma_unencrypted(dev))
 		attrs |= __DMA_ATTR_ALLOC_CC_SHARED;
 
+	if (debug) {
+		start_ns = ktime_get_ns();
+		*dma_handle = 0;
+	}
 	if (dma_alloc_from_dev_coherent(dev, size, dma_handle, &cpu_addr)) {
 		trace_dma_alloc(dev, cpu_addr, *dma_handle, size,
 				DMA_BIDIRECTIONAL, flag, attrs);
-		return cpu_addr;
+		goto out_debug;
 	}
 
 	/* let the implementation decide on the zone to allocate from: */
@@ -667,18 +679,31 @@ void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	if (dma_alloc_direct(dev, ops) || arch_dma_alloc_direct(dev)) {
 		cpu_addr = dma_direct_alloc(dev, size, dma_handle, flag, attrs);
 	} else if (use_dma_iommu(dev)) {
-		cpu_addr = iommu_dma_alloc(dev, size, dma_handle, flag, attrs);
+		if (READ_ONCE(dev->dma_pmd_rings) && can_block) {
+			cpu_addr = dma_pmd_dma_alloc(dev, size, dma_handle, flag, attrs);
+			from_arena = !!cpu_addr;
+		}
+		if (!from_arena)
+			cpu_addr = iommu_dma_alloc(dev, size, dma_handle, flag, attrs);
 	} else if (ops->alloc) {
 		cpu_addr = ops->alloc(dev, size, dma_handle, flag, attrs);
 	} else {
+		cpu_addr = NULL;
 		trace_dma_alloc(dev, NULL, 0, size, DMA_BIDIRECTIONAL, flag,
 				attrs);
-		return NULL;
+		goto out_debug;
 	}
 
 	trace_dma_alloc(dev, cpu_addr, *dma_handle, size, DMA_BIDIRECTIONAL,
 			flag, attrs);
-	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr, attrs);
+	if (!from_arena)
+		debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr, attrs);
+out_debug:
+	if (debug)
+		dev_info(dev,
+			 "dma_alloc_coherent(size=%zu, gfp=%pGg, attrs=%#lx) -> va=%p, dma=%pad, arena=%d in %llu ns\n",
+			 size, &flag, attrs, cpu_addr, dma_handle, from_arena,
+			 ktime_get_ns() - start_ns);
 	return cpu_addr;
 }
 EXPORT_SYMBOL(dma_alloc_attrs);
@@ -703,6 +728,8 @@ void dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 		       attrs);
 	if (!cpu_addr)
 		return;
+	if (use_dma_iommu(dev) && dma_pmd_free(dev, size, cpu_addr, dma_handle))
+		return;
 
 	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle, attrs);
 	if (dma_alloc_direct(dev, ops) || arch_dma_free_direct(dev, dma_handle))
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


