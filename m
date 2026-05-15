Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F06CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983F86B008A; Fri, 15 May 2026 05:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9065C6B00A0; Fri, 15 May 2026 05:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE446B009F; Fri, 15 May 2026 05:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 683216B008A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:54:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 035ACA0435
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:24 +0000 (UTC)
X-FDA: 84769194090.29.88A0533
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 19ED61C0007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EvwtH/jr";
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838863;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0XJikRIFbkHnsD/vzY1POaW7vD8v3d5Nc6aDihdzJs=;
	b=D/nI6XzbRtlGYkXPcNMPO7aVcSJQF+nQOCsAKYuNRL58CmagoLUHSRpJrUnIiUYkZlZyIv
	A9ShTmN9nMuNStP6pCkgpu4pxvsaI1wK5GHuIDnbVJ/Slm1leWVAb+3tsEQD0qN4FtaZZ2
	54YhEffx7v4QMLZuiReb+tGuHyVujM4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EvwtH/jr";
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838863; a=rsa-sha256;
	cv=none;
	b=cZ13qqug/+6MIO+dVpJl8QAbOdITC0BR/fJmQrZjY5q+mTNKPoacuAdJ0UdNFzZLB5pGig
	ExI1BWYKUzshD2q3K0DOt0K4cQSiLyJRBcU7ylYIJ748axHR4cp/RrrVBO12OI1cnsxru8
	dxLIzfM5X+uo7gLjlllX9vcvrf9qYYM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DFA66132E;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA893C2BCF6;
	Fri, 15 May 2026 09:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778838862;
	bh=zcCsIEOwHCa/qUJIv1+S/n2+L3ydr1bUKi5zSmcBhlg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EvwtH/jrauvDFbeDtpTF+faB1yXt8pgA+5DUMBbQ3rs6jtwqewgkAjsn3ej5uN94W
	 yEzo7Nbo83Uz3+qnoePb7Oku4TlVqW/HHEj+A1o2RKFjraJoAa0GmJ8+7Gs16lHyV3
	 YocbkR74s96i35Mhz0Hv2ZdIESPYjGidOs8+6tWA4lx1wHXn6AFPP++7F+FAQ+xjPg
	 qGFMD5N1nPPxKcoQ0RS4akkfxKmb4hQjml501TC6W+I0B/xXrNmCeQKitkATeRjlnW
	 3hlE3ml4Bk8ksu7fl9ToyaLpqL5EDNSOEYkJmYhXQNtVZkXXZgAE89Nm2GIFK95cuz
	 sHzss7v1DRbyw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD00CCD4F25;
	Fri, 15 May 2026 09:54:21 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 15 May 2026 17:54:15 +0800
Subject: [PATCH v4 02/12] mm, swap: move common swap cache operations into
 standalone helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-swap-table-p4-v4-2-f1b49e845a8d@tencent.com>
References: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
In-Reply-To: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
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
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778838859; l=7803;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=6zAFqCFLxPNS+wqMUa/zuMJhekX/MwcjKTbI53cDZ/0=;
 b=k4pEJ5A8Q3SZbhGTUVu9VSmjrRG6kXAgKOKywgNPVX9JuQPkK9D5R+odap10S5DwTvToslVsV
 U+H0wl0+tb6De/l/OwLvAXgckavVwU4J/xtrpfbmV3SHleqq5L4m+nt
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19ED61C0007
X-Stat-Signature: rjeu9ddqhgmpk1tpdapbmpozp8fzxqw4
X-HE-Tag: 1778838862-5794
X-HE-Meta: U2FsdGVkX19YAlf4LQwtdiJ25c8FjzWoKobpxXJmaVx59AmdDn1gGsYXkuksddGuSyseODAArp6bcxebBtGcHNnlJcWizbeo+OTt/yDm/35Kx1P+skSac+jnVbOgyIaAB7eTP5EXKIBnDhz2KlFliMk8b6zPT/R8IHcPtNSxuk2DBW7V19/CV1A2SJjFusC3tnaz3O0ozZFduccN191KiV8WmzqE7DPabtRBvQb3doZun6VJo/IG/SPnTehX5JdMOLcLesIc8dzMvam3Oyw6i7zI/SyYBPgX/TfV0j9iMqFWeA5xLE5KmENi9e3bydzPAZ2pyfgKHB/M0wHDBmyAs8ArRDz8FAaoU/Eq3nzlyReD1+ir/uYPBeNpFdtNyQQc/Y1biMvbbRZ/Qjqzc2qkMxh8kLlRImjad/yoUr7lNLoODNlEjuFfI3k0O9ynlbWOA/acELSP9oTS+xvEkIz6MxTjASBTTbixia/6Jt+7YxuxYS6lGE43P6yE8THLYSJJiRrBbXkZ/Iyf3pz13BQ3U7yqOg91ojPUEuKxRhMxhsrJ8iUeCSaIpGW61PsY9pd2udl5UkZ1oLWbPtZUglssHsTYg1bkTCBTxtpBUT5+zughNB2Kf3uxn9XXmws1heDRjEjnseX3fOk3h9U9EgFAnywjNrEdLZ30xB/Muc9smzCv7twnoqyaUKAa82apxJpHnI/ODNbddWx6EuuvbRAxoYMAML47NSYkPfS6EmJ/MZJWk4xdVCqOlvsHJ/cAfWfCrnZ5BX6fB3fxcOtS6wNxewRv9tFh7k/4ykT5Nh7Dsi0Pm5XunWchLockaSwSAPnUnXV7Tb+a8bu8TnLpnYN48M0Ye/0mPnZzYuVlaYw4b2b06h2UBv/VPxWW7oR9xUQk+BGGsPOL3nV8yyzspaYz0PwN/HjC/8R1WLGMzACdbUxKqPmf1026ZL9L7ydAmSEDHn5QbJU04PL/LWIYNLc
 iGmzWN/y
 frAwEYeCUfbLjAYkaUcsuMfIDob0Uj/KxP5oS7eRPTqzejqHEO/U17hW+HSrbU0zOSyYaLqRhtS/0P18FJKZ2F+cdOAxR6fPmnEZdLMr+k1zGVYtH4/j/p8ipzLrnc8GO0xeTaQu4FUEHKjeces5kE14f1FBtO8fwqKSQR6jWpm9v4I4905PXcwmKCoL5Ed4qj+h2d0FXGDoxT/T5q+nEnMurcj85WpumG449M5au/RuA3ld4NJ8mZuwSfWELB2mnPtv2GHXnWk+MO3/i/V8jqEX/TcXymVz3I8J+glGGj4o/jMwRK9M90DoyiH0K+MIN1cLuUQwcTAhdeov7LRPmQ6Yz8SNH69G88VxIupixpF2zCh1tW2FGJHNfq1PfG6H+096Nz2+KkhqcpGE=
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



