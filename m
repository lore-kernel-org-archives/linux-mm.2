Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08FF7CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 15:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BDF66B0088; Sun, 17 May 2026 11:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848046B008C; Sun, 17 May 2026 11:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C14A6B0092; Sun, 17 May 2026 11:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD286B0088
	for <linux-mm@kvack.org>; Sun, 17 May 2026 11:39:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C953120628
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:52 +0000 (UTC)
X-FDA: 84777322224.19.0C80207
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0BFC7120002
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b0csTYMp;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779032390;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0XJikRIFbkHnsD/vzY1POaW7vD8v3d5Nc6aDihdzJs=;
	b=aRDJnh/UNkTZlfpExCt4T0pGy5gPLWI9HCTdTQOGeSShUxC9U9W6lsaEVe74w5cziAt0kp
	NEgJy/9Xx36rAIPWJ/MLp99rqxALvig7q/oHkd7U5Ivf/s5TTD7FOLB6z5fak128HSTsZS
	guNfMUxcIvVfZs9r8c8RKN7pl7GNREg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b0csTYMp;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779032390; a=rsa-sha256;
	cv=none;
	b=NMiN31dJ6MB6Io/DGDZJumiH9F//c5uaEQXI14Gr8w0QuxGVFygRL/bzetyQasedgRUyR1
	eyxp3zBHHfnX6KQuDZtKP+FNeumdnT7VjiXS2ZXSMYJGz1cUzvn7RBwE8Leup5cujFvzWi
	8lB+YSsWqr6epsdR4JYP8J+oE56xXZ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0603445BF;
	Sun, 17 May 2026 15:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7C71C2BCFB;
	Sun, 17 May 2026 15:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779032388;
	bh=zcCsIEOwHCa/qUJIv1+S/n2+L3ydr1bUKi5zSmcBhlg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=b0csTYMp/vx0BBpaqdbHL6WkUZFV3Lr0hcq5zpucQkoCjh+IA3xVokMyK0uTb6h6M
	 RkqNKeJF1jtPMUVh2wTIDuAYUSu51PhWjZhQQcwWmlDF1J/Fhdg0lc11PwsEjHxAZv
	 JbGkxKWBtiT10K1CUQRBfnqLpx1SWGfYVX529luLVjVlSL4tNOr34V19OmGJ/y/CRm
	 kVNDbphAd+ozhmqbtYdlgkz/AooRuEVVE3yjAQOsiWdrrc034/BFNTfdklEgGdyvPy
	 OMHsWHpSqGRqPrm6Qr2Z464SK0k3tvs2EvYxHvUD/ku03GhhyDC6pjzhuKmmC6pVWD
	 ey3Q0P5LOaM6g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADB5CD4F4A;
	Sun, 17 May 2026 15:39:48 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 17 May 2026 23:39:41 +0800
Subject: [PATCH v5 02/12] mm, swap: move common swap cache operations into
 standalone helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260517-swap-table-p4-v5-2-88ae43e064c7@tencent.com>
References: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
In-Reply-To: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779032385; l=7803;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=6zAFqCFLxPNS+wqMUa/zuMJhekX/MwcjKTbI53cDZ/0=;
 b=5d+qPQoSPI1l0sACYZ/x+MKf6EzLYr8ukWQ8JrEd9L4XW7+ArJZMK/3suF+Rvw8yNwZC2TZAF
 stBQm70i5rODpdXka4GRLE34gPTWm+f6J0Vrt0wsMyEjMAl1P83/ydA
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0BFC7120002
X-Stat-Signature: 83i6eq8ud3ta15y1paa77ex8fwnnidm7
X-HE-Tag: 1779032389-420715
X-HE-Meta: U2FsdGVkX184AFECFSMmKAyQPdKMAsdnxI5pJpNrgI01BP6wmFZrqx80rFchS0p+hUu33gsdkXrLUclDuGWi34rVSB7BJZQDYS3WcltCq4O4F61ND9TAmap0/iAzB8U523SxXaISyeVBj2Luf//XNHcFQG13JcLaUBhqailPByUZQyI0HWLs+vT5wchARftzh4u9DAFjDW5E6onY9rN1LYUHyaiQqqnwZT5YiM3eqwIqTxXkRmEBu7393pDH0T0oQj3i+5pMZ8RoTIT2fX4JquI8aV4tQEOctH3VNvRzdhi+pVVJGa8iGcvnYa/nuw4VNOG/KsseF2qIlNseyn2sl8l5uxGzxYDqy7vKXGlSbw2Pdrm+MRAiqJSYLBFBOLwNpAoUfnKt7RWL8oewWV5Fzrq5lG7X1of2P1GmCH/Wc6QjkYHX2gqzKLossNBD9YwSa5Ir5+CfnGNS+HFjO1DRMsyWaRkSodh6e/c/N4WnIK/X1JdsyAfaF4+6ho/dy+bzv68Zg2YVJ3E6NrIdubfGFuaNiSsuoNhBkqZELLkACkvFrGsBbvp3AiTZ6V0vpXf1XZWuLJihKgEyX2xXL8iq5SM+oAQUAE5FU4uU8fSEVHzsoK7VVviCpKTPrUA3mL7GoBP/5h6ypaUazBoHFdjR3U+KS4cTnk24SpIzFg8ifTKtJ70VoALF3pERLCo+lS+ETAqPqiBKL18TetAihTtaij1bbgERpFrTDQWCdu4wyLqqdfHLfSEGlBvLCzRAGuOZmfN4273t3MrFoiOQ3Zo5RlWHA/3fRyZDM6yrdknFaWYmjfpcUx6VdxhR7cAMNp71Mpk+ChtrOtKght+CQnN3mO1UturaI78QKYvMQHipLFhtQu+dil+DnFVNGagwlehcUIrnbENAEm98LplgomHyxfvqfULWoUSzZ1X7bSzc0qNudOKv42QQmJ3nXK+47vfj5vBuxa8zCaK3V9rFwda
 g//qbet7
 AykKg9QnKWg5LcKmHACTtEIcBrI2rf8s70EgzMNU9GQBF3+wlnhth1hpD0s4duBr97xUjsPxnUvIaBNSoBj4jv0XauFk/tRfn1qAA1bMv2P1L1QK/zLk8r/RQAZCMcvcP4MRmEDsGw2l70yun1DKGWGqnASdgY+ted/hdGqCLueTociD7ppoxoqehbxXuQjOyzPsNbuP96Y2rswoQdDyw057wPYEpkYZgE+A8AI6yMlX9KrXGxQvBrEneWsdF8Lvr24fxsM2JLgU4RiD0pQxwYO79d9IWWheFz/uLGTyDrpkPxrb/e9f+fuc8PwGtXFmzkRxrSCm70KhLVlQ9R9GUzDdJrA/MSWZzmfp4N8FcjrL2fU70sZzcKQ4iFlY9j/5zd35FXAIwaVs411A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Move a few swap cache checking, adding, and deletion operations
into standalone helpers to be used later. And while at it, add
proper kernel doc.

No feature or behavior change.

Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 146 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 100 insertions(+), 46 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 3bba82f6dc79..89fa19ec13f6 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -137,8 +137,47 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-void __swap_cache_add_folio(struct swap_cluster_info *ci,
-			    struct folio *folio, swp_entry_t entry)
+/**
+ * __swap_cache_add_check - Check if a range is suitable for adding a folio.
+ * @ci: The locked swap cluster.
+ * @ci_off: Range start offset.
+ * @nr: Number of slots to check.
+ * @shadow: Returns the shadow value if one exists in the range.
+ *
+ * Check if all slots covered by given range have a swap count >= 1.
+ * Retrieves the shadow if there is one.
+ *
+ * Context: Caller must lock the cluster.
+ * Return: 0 if success, error code if failed.
+ */
+static int __swap_cache_add_check(struct swap_cluster_info *ci,
+				  unsigned int ci_off, unsigned int nr,
+				  void **shadow)
+{
+	unsigned int ci_end = ci_off + nr;
+	unsigned long old_tb;
+
+	lockdep_assert_held(&ci->lock);
+	if (WARN_ON_ONCE(ci_off >= SWAPFILE_CLUSTER))
+		return -EINVAL;
+
+	if (unlikely(!ci->table))
+		return -ENOENT;
+	do {
+		old_tb = __swap_table_get(ci, ci_off);
+		if (unlikely(swp_tb_is_folio(old_tb)))
+			return -EEXIST;
+		if (unlikely(!__swp_tb_get_count(old_tb)))
+			return -ENOENT;
+		if (swp_tb_is_shadow(old_tb))
+			*shadow = swp_tb_to_shadow(old_tb);
+	} while (++ci_off < ci_end);
+
+	return 0;
+}
+
+static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
+				      struct folio *folio, swp_entry_t entry)
 {
 	unsigned int ci_off = swp_cluster_offset(entry), ci_end;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -159,7 +198,28 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
 	folio_ref_add(folio, nr_pages);
 	folio_set_swapcache(folio);
 	folio->swap = entry;
+}
+
+/**
+ * __swap_cache_add_folio - Add a folio to the swap cache and update stats.
+ * @ci: The locked swap cluster.
+ * @folio: The folio to be added.
+ * @entry: The swap entry corresponding to the folio.
+ *
+ * Unconditionally add a folio to the swap cache. The caller must ensure
+ * all slots are usable and have no conflicts. This assigns entry to
+ * @folio->swap, increases folio refcount by the number of pages, and
+ * updates swap cache stats.
+ *
+ * Context: Caller must ensure the folio is locked and lock the cluster
+ * that holds the entries.
+ */
+void __swap_cache_add_folio(struct swap_cluster_info *ci,
+			    struct folio *folio, swp_entry_t entry)
+{
+	unsigned long nr_pages = folio_nr_pages(folio);
 
+	__swap_cache_do_add_folio(ci, folio, entry);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 }
@@ -168,9 +228,11 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
  * swap_cache_add_folio - Add a folio into the swap cache.
  * @folio: The folio to be added.
  * @entry: The swap entry corresponding to the folio.
- * @gfp: gfp_mask for XArray node allocation.
  * @shadowp: If a shadow is found, return the shadow.
  *
+ * Add a folio into the swap cache. Will return error if any slot is no
+ * longer a valid swapped out slot or already occupied by another folio.
+ *
  * Context: Caller must ensure @entry is valid and protect the swap device
  * with reference count or locks.
  */
@@ -179,60 +241,31 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 {
 	int err;
 	void *shadow = NULL;
-	unsigned long old_tb;
+	unsigned int ci_off;
 	struct swap_info_struct *si;
 	struct swap_cluster_info *ci;
-	unsigned int ci_start, ci_off, ci_end;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	si = __swap_entry_to_info(entry);
-	ci_start = swp_cluster_offset(entry);
-	ci_end = ci_start + nr_pages;
-	ci_off = ci_start;
 	ci = swap_cluster_lock(si, swp_offset(entry));
-	if (unlikely(!ci->table)) {
-		err = -ENOENT;
-		goto failed;
+	ci_off = swp_cluster_offset(entry);
+	err = __swap_cache_add_check(ci, ci_off, nr_pages, &shadow);
+	if (err) {
+		swap_cluster_unlock(ci);
+		return err;
 	}
-	do {
-		old_tb = __swap_table_get(ci, ci_off);
-		if (unlikely(swp_tb_is_folio(old_tb))) {
-			err = -EEXIST;
-			goto failed;
-		}
-		if (unlikely(!__swp_tb_get_count(old_tb))) {
-			err = -ENOENT;
-			goto failed;
-		}
-		if (swp_tb_is_shadow(old_tb))
-			shadow = swp_tb_to_shadow(old_tb);
-	} while (++ci_off < ci_end);
+
 	__swap_cache_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
 	if (shadowp)
 		*shadowp = shadow;
-	return 0;
 
-failed:
-	swap_cluster_unlock(ci);
-	return err;
+	return 0;
 }
 
-/**
- * __swap_cache_del_folio - Removes a folio from the swap cache.
- * @ci: The locked swap cluster.
- * @folio: The folio.
- * @entry: The first swap entry that the folio corresponds to.
- * @shadow: shadow value to be filled in the swap cache.
- *
- * Removes a folio from the swap cache and fills a shadow in place.
- * This won't put the folio's refcount. The caller has to do that.
- *
- * Context: Caller must ensure the folio is locked and in the swap cache
- * using the index of @entry, and lock the cluster that holds the entries.
- */
-void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
-			    swp_entry_t entry, void *shadow)
+static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
+				      struct folio *folio,
+				      swp_entry_t entry, void *shadow)
 {
 	int count;
 	unsigned long old_tb;
@@ -259,14 +292,12 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 			folio_swapped = true;
 		else
 			need_free = true;
-		/* If shadow is NULL, we sets an empty shadow. */
+		/* If shadow is NULL, we set an empty shadow. */
 		__swap_table_set(ci, ci_off, shadow_to_swp_tb(shadow, count));
 	} while (++ci_off < ci_end);
 
 	folio->swap.val = 0;
 	folio_clear_swapcache(folio);
-	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
-	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
 
 	if (!folio_swapped) {
 		__swap_cluster_free_entries(si, ci, ci_start, nr_pages);
@@ -279,6 +310,29 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	}
 }
 
+/**
+ * __swap_cache_del_folio - Removes a folio from the swap cache.
+ * @ci: The locked swap cluster.
+ * @folio: The folio.
+ * @entry: The first swap entry that the folio corresponds to.
+ * @shadow: shadow value to be filled in the swap cache.
+ *
+ * Removes a folio from the swap cache and fills a shadow in place.
+ * This won't put the folio's refcount. The caller has to do that.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache
+ * using the index of @entry, and lock the cluster that holds the entries.
+ */
+void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
+			    swp_entry_t entry, void *shadow)
+{
+	unsigned long nr_pages = folio_nr_pages(folio);
+
+	__swap_cache_do_del_folio(ci, folio, entry, shadow);
+	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
+}
+
 /**
  * swap_cache_del_folio - Removes a folio from the swap cache.
  * @folio: The folio.

-- 
2.54.0



