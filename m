Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF3B9F327A6
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F86A6B008C; Tue, 21 Apr 2026 02:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1528A6B0089; Tue, 21 Apr 2026 02:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D3B6B0093; Tue, 21 Apr 2026 02:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D19F56B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:16:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C63213C185
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:16:57 +0000 (UTC)
X-FDA: 84681554874.29.A2A42C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5FFB540005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:16:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T3+TKpHf;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776752215; a=rsa-sha256;
	cv=none;
	b=0Ac/8DgsslkhZ+tk1zipCcRI+rZGp1CINHAO9zL/hEfFBUXq572Xidk5TPn+NJ2NP+EgRj
	WX9BvfFsn6aVdm7suDvt68sAl95ZynHlNHiKpmOWnUOTQIwTtNCmCa9xI5afQMtxaejpYb
	hBMor31etIBKSsKTkVu+9MxVt0uEvp0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T3+TKpHf;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776752215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYAo2zDS3/PGwRTmpYMBfSv8Zp0gLDFzcoISOAwk0Rs=;
	b=TrQmRHSlvVoqLkhPYqqjHDrtCsCndz09fouT32lso6VHE5r8Zgczkii4d/9d4CyVBf947E
	OaXFZ5VSIjRGgoN1GhzaOqtmBHHthpnu1a3oeWtbpG0Zmp9rFpD3OO4vGPFlIfyW/r+/EQ
	+ZYwwiS5lbBstYmuj986y0fb/M+5J1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 611F743B48;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 386B5C4AF0E;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776752214;
	bh=R6SopjDHSwYyapYpCTCyeRRNRa8GYVbolWOQ9GyqllU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=T3+TKpHfay1bgn9sjV6FndDpVmvtTtCnVpihO8QE5F1ZyZ1LL9kVxji8bEEmOCX+D
	 iRnSxz0Bvd6opGk4TVXbfmvbvdv6ItBvE096n5ilIFqRcOTKU+0gKYpBZK+dvOYcD5
	 vxjL8gxFINvJBn7RZKYZeyZaYl3szBmFNFytOVnfAKDF4W9SjcejX5F7jMlZPhVMgI
	 100uJ78AGZ9x//zGfe8TBK3NDSdJSJM/zTKKZViaKbuCqcBi9B/2MIF8ohD5CIGhUg
	 yWd3AslIuymISe3hqHL+It81CfyV9+yzjC/qIpJAD9lgcPOUl0DOw8NXH25bHrBcQf
	 FpjRpeairWxLw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24952F327AA;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 21 Apr 2026 14:16:46 +0800
Subject: [PATCH v3 02/12] mm, swap: move common swap cache operations into
 standalone helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260421-swap-table-p4-v3-2-2f23759a76bc@tencent.com>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
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
 Suren Baghdasaryan <surenb@google.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776752211; l=7606;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Xxsj15DVBqltGKyFemwp7PmhTrU7RQZkfsqaAm93t00=;
 b=TZWpTnNStGa74ex3xHVO0+P3/UneFys55enKax8zcVZuLpR4dCooT9Q6tzt2XnQ5vFagH7f1p
 IOdbFgATsrACszEZkgpnJIaadtd7BxDhIX3SVLvA33X5f52F0CAt7b5
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 5FFB540005
X-Stat-Signature: 5ugremxa99h3zgd3d1g1p8hifpskc3i8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776752215-209499
X-HE-Meta: U2FsdGVkX1/YH2/b5SwLazoqMdTQF1zn51rGhjgEQTKjHzn3Xszc9BS20pPGownLoyp0y2i321UG2r5qCsM2ik8378oh7yxijYC58uLhVPzoVDnIESgl1UHcWejtNSXlizzJdYMv0m3wK07g+oNb+RzCjd1DLSwlTeUsb5XHFzR8bFlxk9w9EWgfcUbBN5NBVWId05ufho5iThTVoZcQrcgMiERMGPrQeCIjWIJg61MHHsNIR6ECuHk76nzyj+SZ+seTxip3ai7QPWJs9BueVd5W15bVPf6rpq/2a9ZI41oNBbnO6cWGiSZQlpjzrhsaY/yI4+eLAMWJnzxDzMcgJWky7SifzOzQaOyTxih3Pu/uHVu/UmVAM2EB4JXtHAHQnxXH1vgr47vwz2nnKSP/h3bgpGx0veDD234gnpJNAe3auMoWCy6bQrIhwZDjwjaxdowilr4OJl43tV+KQQ1fKDn/ieNQZBXRsC+d3UA/LP+w+O+Ke09iB5+FzZbQ5OEmhDeUAxPXfDYNDesRE/8S1UTmG0LA52pZqRrkJbdCDnFgq7hl2N/sj3KsK8Pa+JTlXkMmN71dTLJ0ZNjzQIad/263TVNgWOfwEi+aiq75Nj8SleoBLxakaTM4Bj/Woljm2ExREbaJXZJCuWpnTzJvk/WnX3rbCgRyLPxSRmnwx6vQJMO06DEnNbt+ROyBsHGT8SpCoT3A+aAoYGmaELdx7eOflS/TeJd1YGIAQlOu330c/qn9ArLVFZFcGoy8KxmRcEtT46yy7xQ604kn/XP0XHnn4ElnYodYvvnfIe2NfxtLLd63lLMHZbVIJGRRhS4+51PGX2c4tH1YBvcqqS+0raXEBpgfI0ukdT4a6sps/XD7zbh9r5cZ03M8hAq+q2EGXijxsqDi4/XC/cTw1ZQcgzVSiI30ZJXjcl9wac/TKpi4XKWZEbST8i/E/JxknI4LJQIqXTDtnhFowXNGu1Z
 8UtYoKY2
 qsdb8IGI3snQPaGjkglFl5s+C5vqGEpeZ7TObEutCq6j/CfGe5Bq1engbEJ7LsRLMwM+UAUYzulEpbVuIB0j8gM1YB8dds1NxkBnC+XaSYVAtV3KFUG2mgECHUqA+m5zG1pZ+G4LYl5gtsDotWqGHdjHsGYDq7dI2gowd/ZZgQ82rQXAoWWPAONbR08bl8ksyzksBAEZiiJWNOvMY+t7AaqpgH/2hK1d3Tn9ExkOJQbyua+Ax5nSBvQUwfWMSEjFNHLSPKXwxvj7cOGt4mvvx41eVUzar1T8JmgY0BZQYMGQow3ProD1YNFHYiI3VBYldeGLgCYOejj5CCxmj11AYYmyBBbmstBsGJkzbvsCvnUXtvd18zQZGF6b12A==
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
index 204a9499d50c..3da285a891b2 100644
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



