Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F160CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB2E6B0098; Sat,  3 Oct 2026 17:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C875D6B0099; Sat,  3 Oct 2026 17:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74F76B009B; Sat,  3 Oct 2026 17:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDF46B0098
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:22:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EBF7A80A1F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:56 +0000 (UTC)
X-FDA: 85282589952.23.827BDEB
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf28.hostedemail.com (Postfix) with ESMTP id B5D48C0004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UCuZTPau;
	spf=pass (imf28.hostedemail.com: domain of 3K3LBagYKCHIbhYppeWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3K3LBagYKCHIbhYppeWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SY0kX5E5k9ttNap7++f8IUtP1Blx1E4PDdvSP0AaEHo=;
	b=lU/wQHpy/lE6ykLrLrN4LZrbtWwlhB6lHzeVrWFOe9RuEPRkOUxDh/AjDAOvJPxppPYQJR
	da2+qqTQfVNz8kJN0IqK58c5wF4S8dLrzTzf9aZrTUbKXYomBqtyGLlfTWhiJRRcK7EmMw
	TtgPtlffnV+Y0XinKzUZNV1pL48Pvn0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062573;
	b=NlgzlmuNR1ZEV1sUIcORUATw7ykXAGOG3LMUw9MzrcwmFUq1eAlT2d+9kwWajYEwt92v6J
	5cl38yCthPsQ1Eqdy78l952BYPpyKM48GHJmhKZEudKJx5RvPl7E8we7UnzN83PKcgYBM6
	OOtxU+g5fI7vVqWV6RA2ji8iLZ9xA2M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UCuZTPau;
	spf=pass (imf28.hostedemail.com: domain of 3K3LBagYKCHIbhYppeWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3K3LBagYKCHIbhYppeWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c2d93b92937so70752066b.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062572; x=1791667372; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SY0kX5E5k9ttNap7++f8IUtP1Blx1E4PDdvSP0AaEHo=;
        b=UCuZTPauKFM1SmwzXrrUqGV3XV6q4pN4JT3zA40FECDkKGYLcNIXA1HjhlXVAcG4nh
         HgdmvjTP+2xk3/0+9OBGsm0wISty4adgSHoexABeIclkl2QdX/xEoEAiF1NLfdmau1+z
         cpaVKWJ9M1D7x1nOwO4iPWXbkvwIeagWXBDZjY6sEVvQxdZ2lB8zjhQwdOImc4g+Fdkk
         Xf7HVQePSz+KZU32F7bsejOCpxSyHElaMyT1XTEu5k4CeGK7uOR3wGThcHw1m5kCDtiT
         AteVu94/Y1ln6X0Ea4dBQ1Axdjw9QPxZ/AeKr+lpH+CNIMNCvB7XP/jaq/cqfWiD39+y
         6G+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062572; x=1791667372;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SY0kX5E5k9ttNap7++f8IUtP1Blx1E4PDdvSP0AaEHo=;
        b=zoLPL6+wvATxBdBPth6Wd8HhdJfMILjIdsmWPLx7qHke1Bhf3r8k2YAVxhtbm572v9
         6qAi5uWF9FYHQnT4r1CQxLJjpljRIPCMqgXapt8nPgjEH15cMtPwxhM5qS0BA7m9oLPw
         sEmrakVpJSi2hA5QEGsenbmOiE7E5YFym8X4+2ZDHxFbPzcr8mnZWPwyNA6LzPHb1pXH
         SemOgJJO7zrRkbNKqFwzbDEZlnN6PgQABxTy1XHoHeBV3rqwxBxjcf3i+Ouhk/tZPMEh
         +MvwVrW1vbcScdbsbQZOOj3BlIKmzywyQs2etff/SQJqx0WJMO/KtJO2MugPseItEtSu
         m+7A==
X-Forwarded-Encrypted: i=1; AKwUvBxhRcLMUbgI9iLkCt6uK3xF+zAkSIxWaS7QuDWJjtxNsUl1OSQQsGLkfyqCa+bLV7Nix1h53pt9GQ==@kvack.org
X-Gm-Message-State: AFuF++mGj1L3btcV96Zs3bjMmgjkrtU3pg053ZX0kgdP+k6sZpy0/sfL
	sbnNpkADucs4lfKBmRXjwQhjmz1Bck1o96tXOz+t1iJhcyyg5rhZwzG1VUckTpDJBusIciSWeBX
	cASE0tw==
X-Received: from ejuv4.prod.google.com ([2002:a17:906:4e84:b0:c2e:48f9:c245])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:72cf:b0:c2d:cbc9:3529
 with SMTP id a640c23a62f3a-c2e4af393e2mr567629866b.20.1791062571621; Sat, 03
 Oct 2026 14:22:51 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:23 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-5-lrizzo@google.com>
Subject: [RFC: DMA_PMD 04/22] iommu/dma: add DMA_PMD pool block allocation
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B5D48C0004
X-Stat-Signature: ea7ppcbou3ndyu4rfsdui918k4gs93dx
X-Rspam-User: 
X-HE-Tag: 1791062573-885397
X-HE-Meta: U2FsdGVkX19mR/CAoiUvBt+MqNE6KhtFZuIIPMQEVBL6f0nH7iBk6oTR0FkficNl/RyYw2Kk22DdWTSVA0N8jmTGhPK0veumd8jsjFNLxKZOB/tP/UHhcGHXw0AQGd9NjupleuUu2wDMWD5wiDdfYTSm3rTcdzrYwQjaW2bSwCfDD2L6lH8ROJumYEsr54r2kDD3gqyiFA1WH5SRVQwxt1ECVqR4s37bvP7nwPlmFNsUvu9jfmlLRvVH3dHyoG4U4Asvq55qR993OxXPiDSolMTZ4vToJXEP3kZaZCui1SkG72SxcLXKopt6wzv+k4Flx/DiAi7NmgX7/lDbfyTDOzM12/pe6/jSs5LuPw2t7JHeuBMCvdlgw2qU7Bi0OyC+Rbc3AxhBTrnjkkqTADfjvT5N56SmdEAOFyQ1GBS+jBmrYKTmF2mIggrWX5JkPdnKZFXACAbY5qNjBGP8NpvxKZYHrRy15K4ELMTgSk4SODpH7+7FtlNCrEriK0yPV+Ur5JacYtLdakyx3DA2Hufjqe5ZpFMyPD0TH917xPvcsGyEh7k9pfQBkqzetRNGMeuZPpYsqOvt/dbWu7KSi4c5NhiX3ia945c84vsN4WaRN+SR51F2q1qI9sVd/Smk6zEoIE7ohDfvRHAhgF5RUvd20qJlMYnEBMlgCLnoy5E28M8lMfuQmsykyTNO4Yz/KJ38orX4MEZuCLcPazdUKSs0jVQF0Dn5qMz48veX1EvGL6M3EqX/BErTvKWvdME4bYnXftjmdOTXXJuLojbnMA5koJWS1Q/6FNPXI/x+gM7J8VJWNfQYoctRYj2x7/jYuQRPIRFyS1r+0WSkJr15LKTpyRhXC0NINHIcFkD3XL7Mw+jvm64nQH4JjLQHhORAwbRM1D46Zn09RnJCRm6VZCVLOBwXQX7MHXk/Re6EQgA+CaVnc16CrtoiVbxy/VFLloFkO6pq6Qr5XNjd6NDtrt0
 S0DCqEpE
 hUwuOzKJnf9WBQJmNyNM30jxi3LMFiq4/Zs5ItNQ7oP9AhF3vx3UICccIT1SeEwBLz82XWEBimFjaH0tsCGEbMBxRKb6p5tXYglNRzDUJ47WyzAFc/cFPOQcNqHzuLkxdd4xMSUmQ1mxwUApD43axw857Vg73qAqFUyWoGa+yfZbaqkuA2Ivv3FJhJ7RpL19Y5peWvABVmCe7ASn5AstvEFHh6hkJSQecnlknY+pg6AbkGGXs0AODcWrCYem8NVsjagDFHzEPRH1FqUOGNw1jGCs3fFceaafEpISM4hfY0zh9biBDvMFWwpiSmJcnXObBFzZBYLcMaQGyMbFn3gA3ywcKY0mVJFIyaP4kfLI8KVn7NfHtueM/Tqe5o+pz3h+pDOSyRhKR4DnXYJKx6cDSoJ65UYSs7yVa/a/TvW0wsoFmY1euw0n8wx8Brbi7B6ejMYOXDBfyT/d9Z2tRpESMi29cHlFyo2rBlq8PErI+Gvjo/jAVyLwd0Snc2lPN78IgjkID96rTEswWFaA+o+TgNTCOM8YfRolotb0+c0zoCHsP/dLYhwIcQMyYXqTq0LrwrTl1NfCkr4+BgbA+dmy380kTyLG6WTHcCyN2Sqixr0JhdwobJJUIlpN1BrapYrp18PWhmrgQ93HuqP7PaHp33l0DUY5ALSoaxxal
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add dma_pmd_add_page(), dma_pmd_pool_alloc_bulk_node() (with single-page
inline wrappers dma_pmd_pool_alloc_node() and dma_pmd_pool_alloc()), and
dma_pmd_pool_has_free() to carve PMD_SIZE physical blocks into subpages
of a pool's order with split_page_compound() and hand them out to callers.

A parked subpage is kept frozen (refcount 0) and published with
page_ref_unfreeze() when it is handed out, mirroring the way the page
allocator shapes a page before publishing it, so a stray put_page() on a
parked subpage trips a refcount check instead of freeing it twice.
GFP flags asking for a placement a pool cannot choose - __GFP_THISNODE,
__GFP_DMA, __GFP_DMA32 - are ignored, as documented at
dma_pmd_pool_alloc_bulk_node(); __GFP_ZERO is honoured by zeroing at
dispense.

Also add a KUnit test case (test_pool_alloc_and_recycle) exercising pool
allocation, recycling via __free_page(), and deferred teardown with
in-flight blocks.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/dma-pmd-kunit.c |  41 ++++-
 drivers/iommu/dma-pmd-pool.c  | 279 ++++++++++++++++++++++++++++++++++
 include/linux/dma-pmd.h       |  40 +++++
 3 files changed, 359 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-pmd-kunit.c b/drivers/iommu/dma-pmd-kunit.c
index f80527eaf2e84..24978a5123f54 100644
--- a/drivers/iommu/dma-pmd-kunit.c
+++ b/drivers/iommu/dma-pmd-kunit.c
@@ -70,6 +70,7 @@ static void test_meta_pooled_toggle(struct kunit *test)
 	base_pfn = ALIGN_DOWN(pfn, 1UL << PMD_ORDER);
 	/* The buddy allocator returns naturally aligned blocks. */
 	KUNIT_EXPECT_EQ(test, pfn, base_pfn);
+	KUNIT_ASSERT_TRUE(test, dma_pmd_meta_ensure_pfn(pfn, true));
 	m = dma_pmd_meta_of_pfn(pfn);
 
 	KUNIT_EXPECT_FALSE(test, dma_is_pmd_page(pfn));
@@ -85,10 +86,48 @@ static void test_meta_pooled_toggle(struct kunit *test)
 	__free_pages(page, PMD_ORDER);
 }
 
+static void test_pool_alloc_and_recycle(struct kunit *test)
+{
+	struct dma_pmd_pool *pool;
+	struct page *p1, *p2;
+	unsigned int order;
+
+	KUNIT_EXPECT_NULL(test, dma_pmd_pool_destroy(NULL));
+
+	for (order = 0; order <= PMD_ORDER + 1; order++) {
+		pool = dma_pmd_pool_create(order, 2);
+		if (order > PMD_ORDER) {
+			KUNIT_EXPECT_NULL(test, pool);
+			continue;
+		}
+		KUNIT_ASSERT_NOT_NULL(test, pool);
+		KUNIT_EXPECT_FALSE(test, dma_pmd_pool_has_free(pool));
+
+		p1 = dma_pmd_pool_alloc(pool, GFP_KERNEL | __GFP_ZERO);
+		if (!p1)
+			dma_pmd_pool_destroy(pool);
+		KUNIT_ASSERT_NOT_NULL(test, p1);
+		KUNIT_EXPECT_TRUE(test, dma_is_pmd_page(page_to_pfn(p1)));
+		KUNIT_EXPECT_EQ(test, dma_pmd_pool_has_free(pool), order < PMD_ORDER);
+
+		/* Freeing p1 returns it to the pool; next allocation reuses index 0. */
+		__free_pages(p1, order);
+		KUNIT_EXPECT_TRUE(test, dma_pmd_pool_has_free(pool));
+		p2 = dma_pmd_pool_alloc(pool, GFP_KERNEL);
+		KUNIT_EXPECT_PTR_EQ(test, p1, p2);
+
+		/* Destroy with p2 still in flight; freeing p2 releases the 2M page. */
+		dma_pmd_pool_destroy(pool);
+		if (p2)
+			__free_pages(p2, order);
+	}
+}
+
 static struct kunit_case dma_pmd_meta_test_cases[] = {
 	KUNIT_CASE(test_meta_init_and_roundtrip),
 	KUNIT_CASE(test_meta_invalid_phys),
 	KUNIT_CASE(test_meta_pooled_toggle),
+	KUNIT_CASE(test_pool_alloc_and_recycle),
 	{}
 };
 
@@ -98,5 +137,5 @@ static struct kunit_suite dma_pmd_meta_test_suite = {
 };
 
 kunit_test_suite(dma_pmd_meta_test_suite);
-MODULE_DESCRIPTION("KUnit tests for struct dma_pmd_meta table");
+MODULE_DESCRIPTION("KUnit tests for struct dma_pmd_meta table and DMA_PMD pool");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/iommu/dma-pmd-pool.c b/drivers/iommu/dma-pmd-pool.c
index 5020265d52cd5..e6e5ba7c65f27 100644
--- a/drivers/iommu/dma-pmd-pool.c
+++ b/drivers/iommu/dma-pmd-pool.c
@@ -259,6 +259,285 @@ struct dma_pmd_pool *dma_pmd_pool_destroy(struct dma_pmd_pool *pool)
 }
 EXPORT_SYMBOL(dma_pmd_pool_destroy);
 
+/**
+ * dma_pmd_add_page - Allocate, split, and register a new PMD page
+ * @pool: Owning pool
+ * @gfp: GFP allocation flags
+ * @nid: Target NUMA node (or NUMA_NO_NODE for local node)
+ *
+ * Cost: Slow path (pool miss); allocates PMD page from buddy on @nid,
+ *       splits into compound blocks, and sets the PMD page's membership bit.
+ * Locking: Lockless with respect to @pool->lock (caller inserts into list).
+ * Frequency: Rare after warmup (only when the pool holds no PMD page with a
+ *            free block).
+ *
+ * Return: Pointer to new dma_pmd_meta with all usable blocks free, or NULL
+ *         on failure.
+ */
+static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
+					     gfp_t gfp, int nid)
+{
+	/*
+	 * Require full GFP_KERNEL (not just gfpflags_allow_blocking()):
+	 * dma_pmd_meta_ensure_pfn() and dma_pmd_page_prepare() use GFP_KERNEL.
+	 */
+	bool can_block = (gfp & GFP_KERNEL) == GFP_KERNEL;
+	unsigned int nr = DMA_PMD_BLOCKS(pool->order);
+	struct dma_pmd_meta *meta;
+	gfp_t alloc_gfp, base_gfp;
+	struct page *page;
+
+	/*
+	 * A high-order allocation is expensive when it fails, and under fragmentation
+	 * it fails on every pool miss. For GFP_ATOMIC, back off briefly.
+	 */
+	if (!can_block && time_before(jiffies, READ_ONCE(pool->next_alloc_attempt)))
+		return NULL;
+
+	/*
+	 * The following flags are discarded:
+	 *
+	 * __GFP_MOVABLE would let the PMD page come from ZONE_MOVABLE or a CMA
+	 * pageblock. A pooled PMD page is pinned for the life of the pool and
+	 * has no movable_operations, so memory hot-remove and CMA allocation
+	 * would fail on it forever.
+	 *
+	 * __GFP_HIGHMEM goes because pooled blocks are handed out as
+	 * directly addressable DMA buffers, and __GFP_COMP because the PMD page
+	 * is shaped into compound pieces by hand. What is left is also free
+	 * of everything slab treats as a bug in GFP_SLAB_BUG_MASK, so the
+	 * metadata allocation below can use it as it stands.
+	 * __GFP_ZERO is handled per-block in dma_pmd_pool_alloc_bulk_node().
+	 */
+	base_gfp = gfp & ~(__GFP_COMP | __GFP_HIGHMEM | __GFP_MOVABLE | __GFP_ZERO);
+
+	/*
+	 * A caller that can block gets __GFP_RETRY_MAYFAIL so the allocation
+	 * is allowed to compact for an order-9 page, which is the difference
+	 * between a pool that is populated before traffic starts and one that
+	 * never populates at all on a fragmented machine. It still fails
+	 * rather than triggering the OOM killer: this is an optimisation, and
+	 * every caller has a working fallback.
+	 */
+	alloc_gfp = base_gfp | __GFP_NOWARN;
+	alloc_gfp |= can_block ? __GFP_RETRY_MAYFAIL : __GFP_NORETRY;
+
+	page = alloc_pages_node(nid, alloc_gfp, PMD_ORDER);
+	if (!page) {
+		/* Retry backoff; could be made shorter or tunable in future. */
+		if (!can_block)
+			WRITE_ONCE(pool->next_alloc_attempt,
+				   jiffies + DIV_ROUND_UP(HZ, 100));
+		return NULL;
+	}
+
+	/*
+	 * Ensure the metadata chunk for this PFN is populated. Fails if the PFN
+	 * is past the reservation, or if it belongs to hotplugged memory and the
+	 * caller cannot block to populate its metadata page.
+	 */
+	if (unlikely(!dma_pmd_meta_ensure_pfn(page_to_pfn(page), can_block))) {
+		__free_pages(page, PMD_ORDER);
+		return NULL;
+	}
+
+	/* Fails with -EBUSY if a concurrent PFN walker holds a speculative ref. */
+	if (split_page_compound(page, PMD_ORDER, pool->order)) {
+		__free_pages(page, PMD_ORDER);
+		return NULL;
+	}
+
+	meta = dma_pmd_meta_of_pfn(page_to_pfn(page));
+	memset(meta, 0, sizeof(*meta));
+	meta->pool = pool;
+	spin_lock_init(&meta->map_lock);
+
+	bitmap_set(meta->dirty_bitmap, 0, nr);
+	meta->nr_dirty = nr;
+
+	kref_get(&pool->refcount);
+
+	/*
+	 * Publish last. Once the bit is set, __free_pages_prepare() on any CPU
+	 * will route this PMD page's blocks back into the pool, so every @meta
+	 * field a reader consults has to be in place first.
+	 *
+	 * No explicit barrier: a block cannot reach any reader until this
+	 * function returns and the caller publishes the PMD page under
+	 * @pool->lock, whose release orders both stores against every consumer.
+	 */
+	WRITE_ONCE(meta->pooled, true);
+
+	return meta;
+}
+
+static unsigned int dma_pmd_scan_bitmap(struct dma_pmd_pool *pool,
+					unsigned long *bitmap, u16 *countp,
+					unsigned long base_pfn, unsigned int nr,
+					unsigned long want, struct page **out,
+					bool unfreeze)
+{
+	unsigned int idx, got = 0, used = 0;
+
+	if (!*countp || !want)
+		return 0;
+
+	for_each_set_bit(idx, bitmap, nr) {
+		struct page *block = pfn_to_page(base_pfn + (idx << pool->order));
+
+		__clear_bit(idx, bitmap);
+		used++;
+		if (unlikely(folio_contain_hwpoisoned_page(page_folio(block)))) {
+			pr_err_once("dma_pmd: poisoned block at pfn %lu, leaking it to keep pool %p intact\n",
+				    page_to_pfn(block), pool);
+		} else {
+			if (unfreeze)
+				page_ref_unfreeze(block, 1);
+			out[got++] = block;
+		}
+
+		if (used == *countp || got == want)
+			break;
+	}
+	*countp -= used;
+	pool->block_alloc_cnt += used;
+	return got;
+}
+
+/* Extract up to @want available blocks from @meta under @pool->lock. */
+static unsigned long dma_pmd_take_blocks(struct dma_pmd_pool *pool,
+					 struct dma_pmd_meta *meta,
+					 unsigned long want,
+					 struct page **out, bool zero)
+{
+	unsigned long base_pfn = dma_pmd_meta_to_pfn(meta);
+	unsigned int avail_before = dma_pmd_meta_avail(meta);
+	unsigned int nr = DMA_PMD_BLOCKS(pool->order);
+	unsigned int got = 0, used;
+
+	if (zero) {
+		got += dma_pmd_scan_bitmap(pool, meta->free_bitmap, &meta->nr_free,
+					   base_pfn, nr, want, out, true);
+		got += dma_pmd_scan_bitmap(pool, meta->dirty_bitmap, &meta->nr_dirty,
+					   base_pfn, nr, want - got, out + got, false);
+	} else {
+		got += dma_pmd_scan_bitmap(pool, meta->dirty_bitmap, &meta->nr_dirty,
+					   base_pfn, nr, want, out, false);
+		got += dma_pmd_scan_bitmap(pool, meta->free_bitmap, &meta->nr_free,
+					   base_pfn, nr, want - got, out + got, true);
+	}
+	used = avail_before - dma_pmd_meta_avail(meta);
+	if (!dma_pmd_meta_avail(meta) || WARN_ON_ONCE(!used)) {
+		meta->nr_free = 0;
+		meta->nr_dirty = 0;
+		list_move(&meta->list, &pool->full);
+	}
+
+	return got;
+}
+
+/**
+ * dma_pmd_pool_alloc_bulk_node - Allocate up to @nr_pages blocks from @pool
+ * @pool: Pool to allocate from
+ * @gfp: GFP flags used if a new PMD page must be allocated from buddy
+ * @nid: Target NUMA node if a new PMD page is allocated (or NUMA_NO_NODE)
+ * @nr_pages: Number of blocks requested
+ * @page_array: Output array of at least @nr_pages entries
+ *
+ * Cost: Fast path is O(nr_pages) bitmap scan from @pool->partial or @pool->idle
+ *       under a single lock acquisition. Slow path (both empty) calls
+ *       dma_pmd_add_page().
+ * Locking: Acquires @pool->lock (irqsave) for the bitmap scan. Drops lock
+ *          during slow-path PMD buddy allocation and per-block initialization.
+ * Frequency: High (called per RX buffer refill or per SKB TX page frag refill).
+ *
+ * A pool hands out a block of a PMD page it already owns, on the node that
+ * PMD page came from, so it cannot satisfy a hard placement constraint:
+ * requests with __GFP_THISNODE, __GFP_DMA or __GFP_DMA32 are declined, as is
+ * __GFP_ACCOUNT (pooled blocks are shared across callers and cannot be charged
+ * to a single memcg), so the caller falls back to the page allocator. Flags
+ * that only widen what is acceptable, such as __GFP_HIGHMEM, are ignored
+ * harmlessly.
+ *
+ * Return: Number of blocks placed in @page_array (0 on failure).
+ */
+unsigned long dma_pmd_pool_alloc_bulk_node(struct dma_pmd_pool *pool, gfp_t gfp,
+					   int nid, unsigned long nr_pages,
+					   struct page **page_array)
+{
+	unsigned long allocated = 0, flags, i;
+	bool zero;
+
+	if (unlikely(!pool || pool->destroyed || !nr_pages ||
+		     (gfp & (__GFP_DMA | __GFP_DMA32 | __GFP_THISNODE |
+			     __GFP_ACCOUNT))))
+		return 0;
+
+	zero = want_init_on_alloc(gfp);
+
+	spin_lock_irqsave(&pool->lock, flags);
+	while (allocated < nr_pages) {
+		struct dma_pmd_meta *meta;
+
+		/* Partially used pages first, idle ones next. */
+		meta = list_first_entry_or_null(&pool->partial, struct dma_pmd_meta, list);
+		if (!meta && !list_empty(&pool->idle)) {
+			meta = list_first_entry(&pool->idle, struct dma_pmd_meta, list);
+			list_move(&meta->list, &pool->partial);
+			pool->num_idle_pages--;
+		}
+		if (!meta) {
+			/* Fallback to a new allocation */
+			spin_unlock_irqrestore(&pool->lock, flags);
+			meta = dma_pmd_add_page(pool, gfp, nid);
+			if (!meta)
+				goto out_prep;
+			spin_lock_irqsave(&pool->lock, flags);
+			pool->pmd_alloc_cnt++;
+			list_add(&meta->list, &pool->partial);
+		}
+
+		allocated += dma_pmd_take_blocks(pool, meta,
+						 nr_pages - allocated,
+						 &page_array[allocated], zero);
+	}
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+out_prep:
+	for (i = 0; i < allocated; i++) {
+		if (!page_count(page_array[i])) {
+			page_ref_unfreeze(page_array[i], 1);
+			if (zero)
+				memset(page_address(page_array[i]), 0, PAGE_SIZE << pool->order);
+		}
+	}
+	return allocated;
+}
+EXPORT_SYMBOL(dma_pmd_pool_alloc_bulk_node);
+
+/**
+ * dma_pmd_pool_has_free - Can @pool hand out a block without a new PMD page?
+ * @pool: Pool to query
+ *
+ * Cost: O(1) lockless list check.
+ * Locking: None. The answer is advisory and can be stale the moment it is
+ *          returned.
+ * Frequency: High; intended for per-buffer decisions on the RX path.
+ *
+ * For callers choosing between an existing non-pooled buffer and a pooled
+ * replacement. Answering "no" when the pool is empty keeps them from trading a
+ * perfectly reusable page for a failed allocation and another singly-mapped
+ * page, which is strictly worse than leaving it alone.
+ *
+ * Return: true if a PMD page with a free block is present.
+ */
+bool dma_pmd_pool_has_free(struct dma_pmd_pool *pool)
+{
+	return pool && !READ_ONCE(pool->destroyed) &&
+	       (!list_empty_careful(&pool->partial) || !list_empty_careful(&pool->idle));
+}
+EXPORT_SYMBOL(dma_pmd_pool_has_free);
+
 /**
  * __dma_pmd_free_page - Recycle a freed block back into its DMA_PMD pool
  * @page: Block being freed
diff --git a/include/linux/dma-pmd.h b/include/linux/dma-pmd.h
index 236be50b7349f..085d9a730c278 100644
--- a/include/linux/dma-pmd.h
+++ b/include/linux/dma-pmd.h
@@ -5,6 +5,7 @@
 
 #include <linux/types.h>
 #include <linux/mm.h>
+#include <linux/numa.h>
 #include <linux/rcupdate.h>
 
 struct device;
@@ -77,6 +78,22 @@ static inline bool dma_pmd_free_page(struct page *page)
  */
 struct dma_pmd_pool *dma_pmd_pool_create(unsigned int order, unsigned int max_idle_pages);
 struct dma_pmd_pool *dma_pmd_pool_destroy(struct dma_pmd_pool *pool);
+unsigned long dma_pmd_pool_alloc_bulk_node(struct dma_pmd_pool *pool, gfp_t gfp,
+					   int nid, unsigned long nr_pages,
+					   struct page **page_array);
+static inline struct page *dma_pmd_pool_alloc_node(struct dma_pmd_pool *pool,
+						   gfp_t gfp, int nid)
+{
+	struct page *page = NULL;
+
+	dma_pmd_pool_alloc_bulk_node(pool, gfp, nid, 1, &page);
+	return page;
+}
+static inline struct page *dma_pmd_pool_alloc(struct dma_pmd_pool *pool, gfp_t gfp)
+{
+	return dma_pmd_pool_alloc_node(pool, gfp, NUMA_NO_NODE);
+}
+bool dma_pmd_pool_has_free(struct dma_pmd_pool *pool);
 
 #else /* !CONFIG_DMA_PMD */
 
@@ -101,5 +118,28 @@ static inline struct dma_pmd_pool *dma_pmd_pool_destroy(struct dma_pmd_pool *poo
 	return NULL;
 }
 
+static inline unsigned long
+dma_pmd_pool_alloc_bulk_node(struct dma_pmd_pool *pool, gfp_t gfp, int nid,
+			     unsigned long nr_pages, struct page **page_array)
+{
+	return 0;
+}
+
+static inline struct page *
+dma_pmd_pool_alloc_node(struct dma_pmd_pool *pool, gfp_t gfp, int nid)
+{
+	return NULL;
+}
+
+static inline struct page *dma_pmd_pool_alloc(struct dma_pmd_pool *pool, gfp_t gfp)
+{
+	return NULL;
+}
+
+static inline bool dma_pmd_pool_has_free(struct dma_pmd_pool *pool)
+{
+	return false;
+}
+
 #endif /* CONFIG_DMA_PMD */
 #endif /* _LINUX_DMA_PMD_H */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


