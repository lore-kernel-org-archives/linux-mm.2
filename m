Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CBFF8D766
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D20E56B00A1; Thu, 16 Apr 2026 14:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3636B00A3; Thu, 16 Apr 2026 14:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4716B00A5; Thu, 16 Apr 2026 14:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 613096B00A4
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:34:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F5265B859
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:47 +0000 (UTC)
X-FDA: 84665270214.04.7AF72CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id ED56BA0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rvyo6VMc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776364485;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcG0t33I47BueqMrhLsNrL7q85jRmiiwdrFBqB4pHK4=;
	b=Yz9BJEiUrAH47mLiZAqF0bfcFb+sARY6uVtoK7KFsPlNzEyiJAf7uOSXxswd3J+L7NN49m
	Tv7+3SKSwfZ/aUhsbHrM8rp8EYua1w6h62qC45l147BWI0DzMkAczpXKoYkOlyLW1N+HlP
	Fio+EnLaFv7pPkw6iNVPh3EiH+809cI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rvyo6VMc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776364485; a=rsa-sha256;
	cv=none;
	b=PGilbTIb6YT3nx+260hsCTXgYlqSdMoKSZOhJpXM1b5DfNwBRj4N2cwVZ6juRclkqZbJFc
	PARAD6k0sCASFxL9HF+Xl1sOVwq6zNd8zgRv54ykADaeoNnugoG26QpVD5/BqELaRQULlN
	k4zb3PbrqJOfDMdr0F7GiYgl7mfXApc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5184A4459C;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D213C2BCB0;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776364483;
	bh=tBiTiAmowFWBj69qdUg8eWQosB+vIOBxwoJdnWn8cw4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rvyo6VMcLynWQVhZIqhF4UUHIv77LK+6plR8/GFBfcRFE1OY4l4NIF05aQ2h7bKQu
	 hw6h3WXSZtXSlG95N1WyQlqZbhOJe+hY+PODvcCwM0sTcMIO1SS3VsN2JQhNx57dnl
	 nI8kkUWgjpB1idrNMHjrzR2gCsSknor6hyVL099c/5y9v91SMRC2pGHtV/c2LSCcb3
	 tLa55UeR3We7kOQixitOe7xXsuh5ZXjJeHgZfpk/yMCWpLlN7e3D2b65sT5D4wzIbc
	 DA7WAcI4HdaCOc6Peb03pgeihO4zhz6QeV/KsrTsy9Y5Q4X4zpU7xV4f0oEqRzDE84
	 EuZhQWP94wpqw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7D7F8D767;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 17 Apr 2026 02:34:32 +0800
Subject: [PATCH v2 02/11] mm, swap: move common swap cache operations into
 standalone helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260417-swap-table-p4-v2-2-17f5d1015428@tencent.com>
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
In-Reply-To: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
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
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776364480; l=7606;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HpVIdXRr1EUECVgWZuJLDmJFOLfQVogQc6+DzLywiyw=;
 b=SwEVpOX11TdO0kzHMxfkZdsPnOyUE63uNUTZLtlSzzfSMRc/+13I/N8uDLQE+PY4+IaquBzxq
 A/ajo4XISw9DmVY/efzeO7IAHtQVi7zP6CHNlbdFweICKGMwEibj/LO
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED56BA0005
X-Stat-Signature: 5zwwaqu35j4fytnf9fphwm6fiuo6zsqy
X-Rspam-User: 
X-HE-Tag: 1776364484-644486
X-HE-Meta: U2FsdGVkX1/pECv3b1tmJe3cmFdNFzL7sAiPg7JsXgGcYrpf6zY5TLEmt0bsiKmCuFxXlzLMUuo0RPEVXQgxDECQYbbF8+4wyeHTWn/LoMyX4LSVaBUKEJZz8GbpxF7dOE4rdI1/lFRUpY1laCoun0ViLc+zg9A4yYylxvwr9/mbA8vQp1aWPms7tqrQFjrVoJhJWX+F8BNk2TMm7iNAxAC2ZZscfDWzRgE2iqXuh3MkWVdUozYDccxKmMbY/wwenAMSQAIhpjvm4+fqX/HsLGnQszM+LuSOSvzaRd4FOxZ4YkC2bNh7JgE2MZMGLKT5e8tLBwzr8vbbmYLNyjuvM3qBMWm6fMmfNvmMgxELR7bSXd59F87+k24Cxo4BQzrMNkAA+ECBz7xC6DkZhrkBJYFwSetjDfepHZ5oAb0aBI1gmv6Id8tsgx/sDHQUQ7WoAfdT5hamjhW3B3Fg0L+S3SfMV3WFURP1DQUQOulP4N3NdOCuWwKGTp5AZ0tXe+JBWLOGWq2rR5TyYaY6kxo9gpA6Xwri3uh3qbBRUC32mbXNbHt1sIS21aX6g+L9kvTExUvboGkN/Uc6FjxAvVCCfSRii10gAtvWfj2FlXr32ZdbtwWbaHnhpc+8fCHPqc1tPB4dkY+ERaja+AZDKO9hf9PYHy6Qgn1XtkpjUN5dgf91py1K1SvIzBpKDO0xrj5ZJAp1o2GkQI9cywI62Sq7SkBTEKtJYrxLwjZiPV27hE9390vR4qkr7tqEH5aTkA+hWJHho64rqK+Q0LFzQq7Qz4thh7jEhHWWXyznMtwPoiYovSFJuKy/ES//sh9GoPsAV+8aKmW4vebyhaMYHofW7yIMgxMK70OH9wrV/pBSY1WsScw32e+yNyxkr8e3h0w+x3rQwtvJ5mAmD+KGrVneeRVKSzB6qhJlUyqE/YbFxTpnmef5xRaBWQm9ci0s+Z4tSa66JpAEo8saw1UVo53
 +N7EU1MP
 TqFcx4H8ptPr7r7gH85rb3PMUadTyJ0kU+KRyy7PgQ7eFRg0l59zgGwioUKxh+NksP2YI13/nkkhtodP0qY/WA4QSAdBexuWBmtdzNrjt5tTkFGcD71r3h8xxRdwDmq/39hb1wHTAm1XbvOIwXJMw0IkvczMk8dllEm8INWj9XlNZ3sd2Cp+QAecJVkjWnHNj+ikvuc3FcIwg1ppjgLUVwHM3A1cOxdgFP5fdyoHuh3hmpsUR98swG6Ps6fEVTA3I10PgBhJN+UVuAwmjjIuSqeheh5vt2MQtbOsbXCWFLTdyts5BVCS6ehrdkpPdidyLvgq5hU5P4b3bNoFGV++h0LdWO75zfkuI8aTRqbCiEbHQl1BM3TCHeKlTGg==
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 141 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 95 insertions(+), 46 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index eb4304aa00b7..3ef86db8220a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -137,8 +137,42 @@ void *swap_cache_get_shadow(swp_entry_t entry)
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
+ */
+static int __swap_cache_add_check(struct swap_cluster_info *ci,
+				  unsigned int ci_off, unsigned int nr,
+				  void **shadow)
+{
+	unsigned int ci_end = ci_off + nr;
+	unsigned long old_tb;
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
@@ -159,7 +193,28 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
 	folio_ref_add(folio, nr_pages);
 	folio_set_swapcache(folio);
 	folio->swap = entry;
+}
 
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
+
+	__swap_cache_do_add_folio(ci, folio, entry);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 }
@@ -168,9 +223,11 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
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
@@ -179,60 +236,31 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
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
@@ -259,14 +287,12 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
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
@@ -279,6 +305,29 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
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
2.53.0



