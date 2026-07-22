Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C5FC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 04:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21FA6B00D4; Wed, 22 Jul 2026 00:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9F46B00D5; Wed, 22 Jul 2026 00:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9E06B00D6; Wed, 22 Jul 2026 00:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 588006B00D4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:42:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C301780385
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:42:32 +0000 (UTC)
X-FDA: 85015166544.22.C45B6D4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9BDB6A0006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:42:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="A+//2Hnr";
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784695350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUkOz8FYOEDUgGX+CslCF+loeViL30IBrcU7GQGWtrk=;
	b=PcciMgNOnheiAZY+Nf2D1VMySEp+8ujdf3ySatV5g82pocIWp18geIFmvBC2S16kGmrG81
	RI6vUu9Ukaj0xM1bET0y1l712jtTRr1olYo7U/8zvpSE5fxFFXYDw0Qmn6UmoH857xjyUK
	Sx4Ji0AJTQF4zWuqCI2EK99f46hjC2E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784695350;
	b=ruAox0Y/vT6X2THAcEXFu2ck2yz84rpuVcSfXLDEB27DwNTUlUNcdgFRwzgTskNbCKoU0X
	AHY0J/Wcb6jCCyf4VZ9BhxnYolvXOEfEzdh0zebl1THaDnR9hB8G6a2HRosu0fSRKdzfEG
	ZoItf1IWbwfWea3odwEYTnpxQBOJZSc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="A+//2Hnr";
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784695351; x=1816231351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8r1Uq1zdtpAGJu8GavaMBdCBQ8DhrDpmk6GT3M4wn6s=;
  b=A+//2HnrC2m/RfOdkm4d7GgcjiHIWD3EOFh1Ie+9ejd3pvJWU9MRdZmp
   gSJEAUUjbVkW9VfCe41slQZwJ63HucQ86xUCIwsx2PzZXA2ZTLxn5wKih
   G9bRfji7bpzlwTlkHCfq8by87uNLz3wpJs3LZoCdA+q0rW6Hhhr0m+gNF
   1qfsbuuB746nF0Gkxaf2jRdF/DIn7wTbI/YlL/pAJ2lyivQtgSYdyWrUi
   6oYbFZuash5Ww5DX7a2EjJEqRvHrSox/+Nwtpi2n6+akgk/Gt7bPFRaxW
   Cq5L1Ya9ufvxBHZO8pTc9IGcNq7zpCxRnIl5p0j9VtyT8IAFIIIek0bLu
   w==;
X-CSE-ConnectionGUID: e9A4dViMQQmBOaEGQzFzzQ==
X-CSE-MsgGUID: 3HvH0iN2SbCjjOLVS/klUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="102865813"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="102865813"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 21:42:27 -0700
X-CSE-ConnectionGUID: ttMGdGQCR4qWX40DU9YdWg==
X-CSE-MsgGUID: 4McOWbVNSJOBmCVv1kMXLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="254063563"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 21:42:27 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Dave Airlie <airlied@redhat.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 3/3] drm/ttm: allocate pool pages as compound (__GFP_COMP)
Date: Tue, 21 Jul 2026 21:42:20 -0700
Message-Id: <20260722044220.1110278-3-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260722044220.1110278-1-matthew.brost@intel.com>
References: <20260722044220.1110278-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9BDB6A0006
X-Stat-Signature: n1u97es1m9dxt6gqchnr53akpg3xebme
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784695350-436692
X-HE-Meta: U2FsdGVkX1/iw1rIsvSuoIS7dAHjYUod/h9VGfQE2495jAoYhiecHC14TGGnIdP1okE/uqNtsSSZ05TUjUsIGLnqsROEkQBSprRtXoMSjh9/M9FICU1Q5EWkais0auiVrxZBOP93HqJOLCT9sODDHKFoEi5okqX5PcdNHrRZ98dYfmG/dnQNgP5mP+vDY2d3cLCMS1lDryedMdI6ab+f92Vk5IdsN9O7cwHkmRiWFDN7KdOgnvqA27MPUaM7271rXQ+2Yp5VPzXuk+CvriSVxbg8xfC0YXkjLeTGQS/jxU+dsFqN2PWn594KnY2ppofrpGFFDw/FkZJMKTSM4u1ZWUmEhzmcGwntY8IVpjOdVMmHfy3Xlj8iptqixQZQvanGG3h8dzeyhBITtl/FtSfR9OuQFKYQUMml5LzOYyfQk+BN5G6gbUvusMjgDCHpZNaTc4jQ5qYl+luou4ey1zBEqiVvBid0/i+tLDK3m4xOEbkyYu5foRbWtYJWv08TqkwpgCsCPLMZ39eZN2SY1h/WjVjyZN/5MYH7YNTJsB39iOQycVjG58enkIqwg/XeQMqS42gFo1+69dtDOawvG5V4sshFB+Tcj8o2uO1J9VW55ew8jYwC2anYzpNytUr030lQERxFS93XLFCRzVb3e64Om/ij9tyKlaIkVSliCZ/fje7pr+BtQxhfvAVJb1LchRmUrhuUcUY8ER50pCmbfilY8vgp450qjJliaDiKHTe1/FmELUiFt8SuwDfgPJ8YEgAiJsfv7tu/H37vI8sxMeddYvUHXM9FeNolc3uoATSwYUJu7V5FCWzWiWHFTdHyU9OhCBuA1rfYj6FcASd7QdxB2HmAL1ucPIAEwkrh6REwCmtBuHGgvobxdyrnLhI7qgm45403YYLmrZYiRL12C2qIe4g2wTIQrfxR2mkdcbDcm5z9i7IUzCn8zh8NdJ6iZYM31fZAmTutOVWG38qGtKq
 slBQuaT2
 s8pICVCKdrbGJPGzWqsYmN3UDK3G0X4ir/MhN9qV0wurZKOqnMSWO75M3FYjJev9kfjrmjljFHu6O691sgyNsL5si9rgmUJd10sZ54LV6s0e6lVxtnYwSDzq6/BlMrVrSWBHHpUmMp3x7d4qg/DgkCDeMhH+dheloZ6S3O4l6zFbkMo/OBe75KhG4KpsLLgXWlkOFSlNcoLAH7GRnHBQERLWgJcMplJXaE5GyGa7ByE322NwUVVMd+2oVYzH7oDMS1eTm24IhYHlhOZjBfscmj9EjYTyegj8E48NCCRAHKu+RKskjgZxxJN9JlEoNCxjDAmp4VAAGiNhnmJHHsXNglZhOAS7XowXFcl5wNvabQR1AkmpCVcuDLJJoMmG1uf99EAuhhlZt62BroPilB4DvgW09aa2X/+zFrqH55eZE5/RYbcmE7DGX1cyAcl/uemkfJX2kFUAB+dfoSN9s88yFnbO7Ys0T4CfunVxqQ0XQxYtEcUXBJC5XxnFyu42jBEA0aerS8KHhs4FYqP6rV5Onzrsy0RBsKKDUARt2RVtacglYNDB6ef9secwGkXoAkzZS/mQv8KH6/soWYE+Zyf9NSZhwf+zdSOD8JMtFsk0q5PQLAEU6dUFoX7CeB0GTTysNAKGuUPh0SgLur1ORyUWaKwtfW193Ak8Y6v5UhFEIKZLRBnNbkJVZHfqruTd+xG6uS6dh8QjnZKjRveRJ6A0TDJ24aPpUbaAwkcJJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically ttm_pool_alloc_page() deliberately avoided __GFP_COMP for
higher-order allocations and instead stashed the allocation order in
page->private. The stated reason was that mapping a TTM page into a
userspace process and having that process call put_page() on it would be
illegal on a compound page, because the stray reference would fold into
the compound head and could free the whole block behind TTM's back.

That hazard no longer applies to the non-DMA path. TTM faults its pages
into userspace via VM_PFNMAP (see ttm_bo_vm_fault_reserved() /
vmf_insert_pfn_prot()), so the core mm never takes a struct page
reference on them and GUP rejects the range; a stray userspace put_page()
cannot reach these pages at all.

Convert the !ttm_pool_uses_dma_alloc() path to allocate compound pages
with __GFP_COMP and recover the order via folio_order() instead of
page->private:

  - ttm_pool_alloc_page(): add __GFP_COMP, drop the page->private write.
  - ttm_pool_page_order() / ttm_pool_unmap_and_free(): read the order
    from folio_order() for the non-DMA case.
  - ttm_pool_split_for_swap(): for compound folios, split via the new
    folio_split_driver_managed() helper rather than split_page(), which
    rejects compound pages. Each resulting order-0 folio is then freed
    individually as it is backed up.
  - Drop the now-dead page->private = 0 clears on the purge and
    full-backup free paths.

The DMA path is intentionally left unchanged: dma_alloc_attrs() does not
produce compound pages, so it keeps split_page() and the page->private
order stash.

folio_split_driver_managed() lives in the THP split machinery
(mm/huge_memory.c), which only builds when CONFIG_TRANSPARENT_HUGEPAGE
is enabled. Drivers that drive the TTM shrinker and therefore reach the
split path must select TRANSPARENT_HUGEPAGE.

Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Assisted-by: GitHub-Copilot:claude-opus-4.8
---
 drivers/gpu/drm/ttm/tests/ttm_pool_test.c | 23 +++++++++---
 drivers/gpu/drm/ttm/ttm_backup.c          |  8 ++--
 drivers/gpu/drm/ttm/ttm_pool.c            | 46 +++++++++++++++--------
 3 files changed, 53 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/ttm/tests/ttm_pool_test.c b/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
index be75c8abf388..771ed257778c 100644
--- a/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
+++ b/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
@@ -169,7 +169,14 @@ static void ttm_pool_alloc_basic(struct kunit *test)
 			KUNIT_ASSERT_NOT_NULL(test, (void *)fst_page->private);
 			KUNIT_ASSERT_NOT_NULL(test, (void *)last_page->private);
 		} else {
-			KUNIT_ASSERT_EQ(test, fst_page->private, params->order);
+			/*
+			 * The non-DMA path allocates compound pages, so the
+			 * order is recovered from the folio rather than from
+			 * page->private.
+			 */
+			KUNIT_ASSERT_EQ(test,
+					folio_order(page_folio(fst_page)),
+					params->order);
 		}
 	} else {
 		if (ttm_pool_uses_dma_alloc(pool)) {
@@ -177,13 +184,19 @@ static void ttm_pool_alloc_basic(struct kunit *test)
 			KUNIT_ASSERT_NULL(test, (void *)last_page->private);
 		} else {
 			/*
-			 * We expect to alloc one big block, followed by
-			 * order 0 blocks
+			 * We expect to alloc one or more max-order compound
+			 * blocks. page_folio() on any subpage resolves to the
+			 * compound head, so both the first and last pages
+			 * report the max block order.
 			 */
-			KUNIT_ASSERT_EQ(test, fst_page->private,
+			KUNIT_ASSERT_EQ(test,
+					folio_order(page_folio(fst_page)),
+					min_t(unsigned int, MAX_PAGE_ORDER,
+					      params->order));
+			KUNIT_ASSERT_EQ(test,
+					folio_order(page_folio(last_page)),
 					min_t(unsigned int, MAX_PAGE_ORDER,
 					      params->order));
-			KUNIT_ASSERT_EQ(test, last_page->private, 0);
 		}
 	}
 
diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_backup.c
index 3c067aadc52d..9194747a1dff 100644
--- a/drivers/gpu/drm/ttm/ttm_backup.c
+++ b/drivers/gpu/drm/ttm/ttm_backup.c
@@ -72,9 +72,11 @@ int ttm_backup_copy_page(struct file *backup, struct page *dst,
  * ttm_backup_backup_folio() - Backup a folio
  * @backup: The struct backup pointer to use.
  * @folio: The folio to back up.
- * @order: The allocation order of @folio.  Since TTM allocates higher-order
- *         pages without __GFP_COMP, folio_nr_pages(@folio) would always
- *         return 1; the caller must pass the true order explicitly.
+ * @order: The allocation order of @folio, passed explicitly. For the DMA
+ *         path TTM allocates higher-order pages without __GFP_COMP, so
+ *         folio_order(@folio) would return 0 rather than the true order;
+ *         the caller therefore passes the order explicitly. (The non-DMA
+ *         path allocates compound pages, for which the two agree.)
  * @writeback: Whether to perform immediate writeback of the folio's pages.
  * This may have performance implications.
  * @idx: A unique integer for the first page of the folio and each struct backup.
diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index 1bf37023fed6..364cc7ec7469 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -168,9 +168,11 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
 	struct page *p;
 	void *vaddr;
 
-	/* Don't set the __GFP_COMP flag for higher order allocations.
-	 * Mapping pages directly into an userspace process and calling
-	 * put_page() on a TTM allocated page is illegal.
+	/*
+	 * For higher-order allocations be a good citizen: don't dip into
+	 * memory reserves, don't retry hard, don't warn on failure and stay
+	 * on the local node. The non-DMA path additionally sets __GFP_COMP
+	 * below; the DMA path allocates via dma_alloc_attrs().
 	 */
 	if (order)
 		gfp_flags |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN |
@@ -189,11 +191,9 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
 	}
 
 	if (!ttm_pool_uses_dma_alloc(pool)) {
-		p = alloc_pages_node(pool->nid, gfp_flags, order);
-		if (p) {
-			p->private = order;
+		p = alloc_pages_node(pool->nid, gfp_flags | __GFP_COMP, order);
+		if (p)
 			mod_lruvec_page_state(p, NR_GPU_ACTIVE, 1 << order);
-		}
 		return p;
 	}
 
@@ -482,7 +482,7 @@ static unsigned int ttm_pool_page_order(struct ttm_pool *pool, struct page *p)
 		return dma->vaddr & ~PAGE_MASK;
 	}
 
-	return p->private;
+	return folio_order(page_folio(p));
 }
 
 /*
@@ -493,15 +493,31 @@ static unsigned int ttm_pool_page_order(struct ttm_pool *pool, struct page *p)
 static void ttm_pool_split_for_swap(struct ttm_pool *pool, struct page *p)
 {
 	unsigned int order = ttm_pool_page_order(pool, p);
-	pgoff_t nr;
 
 	if (!order)
 		return;
 
-	split_page(p, order);
-	nr = 1UL << order;
-	while (nr--)
-		(p++)->private = 0;
+	if (ttm_pool_uses_dma_alloc(pool)) {
+		pgoff_t nr;
+
+		/*
+		 * DMA-alloc pages are not compound; split the plain
+		 * higher-order allocation and clear the per-page private
+		 * (which held the order for the non-compound case).
+		 */
+		split_page(p, order);
+		nr = 1UL << order;
+		while (nr--)
+			(p++)->private = 0;
+		return;
+	}
+
+	/*
+	 * The non-DMA path allocates compound folios (__GFP_COMP). Split the
+	 * driver-owned, off-LRU, unmapped folio into order-0 folios so each
+	 * page can be freed as soon as it has been backed up.
+	 */
+	folio_split_driver_managed(page_folio(p), 0);
 }
 
 /**
@@ -548,7 +564,7 @@ static pgoff_t ttm_pool_unmap_and_free(struct ttm_pool *pool, struct page *page,
 
 		pt = ttm_pool_select_type(pool, caching, order);
 	} else {
-		order = page->private;
+		order = folio_order(page_folio(page));
 		nr = (1UL << order);
 	}
 
@@ -1124,7 +1140,6 @@ long ttm_pool_backup(struct ttm_pool *pool, struct ttm_tt *tt,
 					       num_pages);
 			if (flags->purge) {
 				shrunken += num_pages;
-				page->private = 0;
 				__free_pages_gpu_account(page, order, false);
 				memset(tt->pages + i, 0,
 				       num_pages * sizeof(*tt->pages));
@@ -1214,7 +1229,6 @@ long ttm_pool_backup(struct ttm_pool *pool, struct ttm_tt *tt,
 		}
 
 		/* Fully backed up: free at native order. */
-		page->private = 0;
 		__free_pages_gpu_account(page, order, false);
 	}
 
-- 
2.34.1


