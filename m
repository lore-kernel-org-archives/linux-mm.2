Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7F3C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9694F6B008C; Mon, 28 Jul 2025 04:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940FB6B0093; Mon, 28 Jul 2025 04:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87DBA6B0096; Mon, 28 Jul 2025 04:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2036B008C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:04:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2E3E1401C3
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:04:10 +0000 (UTC)
X-FDA: 83712935460.13.9AF7746
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id E858340012
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:04:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kepHxj6K;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753689849; a=rsa-sha256;
	cv=none;
	b=J00DRhx6X6jjrVMBipbs4FUH7wTFuNtwucnZizRFI/ljGxI7HX3Osz31yT0MFi2L6Bl9mk
	8TFuyA1A+zDfMjoIM5D5IIG6WoEcTr9cNo6wHl2ZBcAHB0EKAKfOaCujk3jlra9vB2RKF1
	5SB3Wd0muHZr2Rwnbp9mZs4O4BMNWJE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kepHxj6K;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753689849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R5JhzFAe2+pi/8yqRFPN+PrUVu7txCrojFI/LNAgGtk=;
	b=q+l9D9hQ73uYP84JuPhBnizolC/uENm6YuO6Uz/S4ZIJVpnkIAYGnBYZTyppyTSg8P5nNa
	2wszePqlQOZH81YH4zjGtJSOU7oLVuVQgShadMb02VrzjCel+4/VkyhzBQeUfgZMK26fx2
	xNrr/0MeHQqVZSMC4TgPoX5QTIWoXj0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753689843; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=R5JhzFAe2+pi/8yqRFPN+PrUVu7txCrojFI/LNAgGtk=;
	b=kepHxj6K2WQ5b1O0Lk+ZXTbEgcjH7EbyQxYr62pv2TqS5uCU/qmJteoI0u3H0JOF/d6UzIcMP4XGTy6z4VvpeFC60qK8DqgpoVH3w0iJff0o67gPiyLAAFgweZ64trQ0XGtMFIGalkAmUbDK6hSKr87xy/oDyQRRETJ4kgRrtL4=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WkFS0FZ_1753689841 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Jul 2025 16:04:01 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com
Cc: patryk@kowalczyk.ws,
	ville.syrjala@linux.intel.com,
	david@redhat.com,
	willy@infradead.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	jani.nikula@linux.intel.com,
	joonas.lahtinen@linux.intel.com,
	rodrigo.vivi@intel.com,
	tursulin@ursulin.net,
	christian.koenig@amd.com,
	ray.huang@amd.com,
	matthew.auld@intel.com,
	matthew.brost@intel.com,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm: shmem: fix the shmem large folio allocation for the i915 driver
Date: Mon, 28 Jul 2025 16:03:53 +0800
Message-ID: <0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E858340012
X-Stat-Signature: mhu1n863cbzdza6czth56xj517ddk1ki
X-Rspam-User: 
X-HE-Tag: 1753689846-430710
X-HE-Meta: U2FsdGVkX1/JiHptBNNj9kLlxmlli7wKmAZouSiKeZfz8F56zI3sWe21bkREgLmdtESxe+r24cVi+PUl7cqx4cFN5Ze47rKMW1WuFoRGV+tzklXv5uE0lK4v+6NRiFiJ00tXF7yG1K3Nx4w34Ya2mwhKYnFC0ltxljZOpM1y4XckaPdVGhQRlmw99ztCal+BKbAdlFTCMHs6d9jBi+eTg/DcKYDmWbT7phQkRh665hb7cZ9ZDxe7ToMwbSHataH/KssizBZ1gm9mvp4YNf9zVC26JSgM+3XvIKottBOAsD0ouMWxRnyvbRA/SW/0FzzcJEN7VbUDWS+3U8v6gkS4qH0J6hJC4BR9bz6dq2+WQIyT+EFJK4o3yOSXhe5JWvOj+uKCCV90tto2RKgD1V2U8+boNVNhsMcE8UFI7NJyFHURKC6Y2fXZn1p2hxF3jSn1Eq8i3/GUGyRJa6HihuBmZzFyXTXIY4ZcgW9l7uOzvUCycOAAfn3V0phLvnohlkdYFgUoX5D5Rh+rY0DtKH7n6BnJn/00fhqNHW/HaNr8XmRV4uP4hTn4WflNaTbt04YHyy++zzbLLGsGO+5Tm6Lsq7EnreDtvx+ePh2/v8PtDraPWFshhDMdO6Xha1STntcWu884kEnoqDIss3pREDDxHeRlFzGk7ROo/nK7yk7cd/qC85bpPayVooezSAP2OwQL37BsKCEKF9B8zF0sOiudPwHpwcW/BiSQEGGdINmBfwlVoYGHfpLka4wwf47fC89uQLsSCXGzSutYeq21/JgoVhh/4vhiHpM7/SboNWevOr/d0uTPZgfw7dxsb57Es/5XwNVGfTriE4hIEaZL6jsF1h6a9W1jlgaweSDcfpfcAdV1J1LCtaF/NiNYgmA8kLnesU64x4bes3lMveNOVF1hal0H85pAq7vN8tdsmik32QlB6PKJ6Ma+scz++KcrKU650zMK9RGwNeaLfBv2JhS
 Zi/6E+6D
 HL3OeAW0MnV1Z798G8Ue/5Un/vC3qX8cfpuuce9YSfjeaGjstrvm1rPIiaLhfXgTX89OiSnQc3Q0hd4KsmGbkCxjAf5aRq/PulQXcnHcruSUH8xFFpnMu84FuPq3iZatF3rRBP/UnxGDwN/zTPJuYemv0DXEVYbEDOQvvmiWHc2aUkmdC/uDMS1l8XegoQdouqzBDwaSiXt4MpMx01gIJl/t4dwj02qcTrSdZ/tK/JHj51CVKAY1HwiDoQAP0nI/IsY/6NO1Fxy5cy27H44ojuO1VJsAAWcPduH3alXmV8DZdlC2Vg+gGhT5H+AckINlxJHv8QCAoSKdVFDVAAR7LwP5mwVWjPQec7Ior7vNtIwRnHHHWaRTd1ysNnZfcA+x7xX3H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"),
we extend the 'huge=' option to allow any sized large folios for tmpfs,
which means tmpfs will allow getting a highest order hint based on the size
of write() and fallocate() paths, and then will try each allowable large order.

However, when the i915 driver allocates shmem memory, it doesn't provide hint
information about the size of the large folio to be allocated, resulting in
the inability to allocate PMD-sized shmem, which in turn affects GPU performance.

To fix this issue, add the 'end' information for shmem_read_folio_gfp()  to help
allocate PMD-sized large folios. Additionally, use the maximum allocation chunk
(via mapping_max_folio_size()) to determine the size of the large folios to
allocate in the i915 driver.

Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 drivers/gpu/drm/drm_gem.c                 | 2 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 7 ++++++-
 drivers/gpu/drm/ttm/ttm_backup.c          | 2 +-
 include/linux/shmem_fs.h                  | 4 ++--
 mm/shmem.c                                | 7 ++++---
 5 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 4bf0a76bb35e..5ed34a9211a4 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -627,7 +627,7 @@ struct page **drm_gem_get_pages(struct drm_gem_object *obj)
 	i = 0;
 	while (i < npages) {
 		long nr;
-		folio = shmem_read_folio_gfp(mapping, i,
+		folio = shmem_read_folio_gfp(mapping, i, 0,
 				mapping_gfp_mask(mapping));
 		if (IS_ERR(folio))
 			goto fail;
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index f263615f6ece..778290f49853 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -69,6 +69,7 @@ int shmem_sg_alloc_table(struct drm_i915_private *i915, struct sg_table *st,
 	struct scatterlist *sg;
 	unsigned long next_pfn = 0;	/* suppress gcc warning */
 	gfp_t noreclaim;
+	size_t chunk;
 	int ret;
 
 	if (overflows_type(size / PAGE_SIZE, page_count))
@@ -94,6 +95,7 @@ int shmem_sg_alloc_table(struct drm_i915_private *i915, struct sg_table *st,
 	mapping_set_unevictable(mapping);
 	noreclaim = mapping_gfp_constraint(mapping, ~__GFP_RECLAIM);
 	noreclaim |= __GFP_NORETRY | __GFP_NOWARN;
+	chunk = mapping_max_folio_size(mapping);
 
 	sg = st->sgl;
 	st->nents = 0;
@@ -105,10 +107,13 @@ int shmem_sg_alloc_table(struct drm_i915_private *i915, struct sg_table *st,
 			0,
 		}, *s = shrink;
 		gfp_t gfp = noreclaim;
+		loff_t bytes = (page_count - i) << PAGE_SHIFT;
+		loff_t pos = i << PAGE_SHIFT;
 
+		bytes = min_t(loff_t, chunk, bytes);
 		do {
 			cond_resched();
-			folio = shmem_read_folio_gfp(mapping, i, gfp);
+			folio = shmem_read_folio_gfp(mapping, i, pos + bytes, gfp);
 			if (!IS_ERR(folio))
 				break;
 
diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_backup.c
index 6f2e58be4f3e..0c90ae338afb 100644
--- a/drivers/gpu/drm/ttm/ttm_backup.c
+++ b/drivers/gpu/drm/ttm/ttm_backup.c
@@ -100,7 +100,7 @@ ttm_backup_backup_page(struct file *backup, struct page *page,
 	struct folio *to_folio;
 	int ret;
 
-	to_folio = shmem_read_folio_gfp(mapping, idx, alloc_gfp);
+	to_folio = shmem_read_folio_gfp(mapping, idx, 0, alloc_gfp);
 	if (IS_ERR(to_folio))
 		return PTR_ERR(to_folio);
 
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 6d0f9c599ff7..203eebad6b38 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -156,12 +156,12 @@ enum sgp_type {
 int shmem_get_folio(struct inode *inode, pgoff_t index, loff_t write_end,
 		struct folio **foliop, enum sgp_type sgp);
 struct folio *shmem_read_folio_gfp(struct address_space *mapping,
-		pgoff_t index, gfp_t gfp);
+		pgoff_t index, loff_t end, gfp_t gfp);
 
 static inline struct folio *shmem_read_folio(struct address_space *mapping,
 		pgoff_t index)
 {
-	return shmem_read_folio_gfp(mapping, index, mapping_gfp_mask(mapping));
+	return shmem_read_folio_gfp(mapping, index, 0, mapping_gfp_mask(mapping));
 }
 
 static inline struct page *shmem_read_mapping_page(
diff --git a/mm/shmem.c b/mm/shmem.c
index e6cdfda08aed..c79f5760cfc9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5960,6 +5960,7 @@ int shmem_zero_setup(struct vm_area_struct *vma)
  * shmem_read_folio_gfp - read into page cache, using specified page allocation flags.
  * @mapping:	the folio's address_space
  * @index:	the folio index
+ * @end:	end of a read if allocating a new folio
  * @gfp:	the page allocator flags to use if allocating
  *
  * This behaves as a tmpfs "read_cache_page_gfp(mapping, index, gfp)",
@@ -5972,14 +5973,14 @@ int shmem_zero_setup(struct vm_area_struct *vma)
  * with the mapping_gfp_mask(), to avoid OOMing the machine unnecessarily.
  */
 struct folio *shmem_read_folio_gfp(struct address_space *mapping,
-		pgoff_t index, gfp_t gfp)
+		pgoff_t index, loff_t end, gfp_t gfp)
 {
 #ifdef CONFIG_SHMEM
 	struct inode *inode = mapping->host;
 	struct folio *folio;
 	int error;
 
-	error = shmem_get_folio_gfp(inode, index, 0, &folio, SGP_CACHE,
+	error = shmem_get_folio_gfp(inode, index, end, &folio, SGP_CACHE,
 				    gfp, NULL, NULL);
 	if (error)
 		return ERR_PTR(error);
@@ -5998,7 +5999,7 @@ EXPORT_SYMBOL_GPL(shmem_read_folio_gfp);
 struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					 pgoff_t index, gfp_t gfp)
 {
-	struct folio *folio = shmem_read_folio_gfp(mapping, index, gfp);
+	struct folio *folio = shmem_read_folio_gfp(mapping, index, 0, gfp);
 	struct page *page;
 
 	if (IS_ERR(folio))
-- 
2.43.5


