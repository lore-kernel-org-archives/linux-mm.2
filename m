Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4B4ECD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F78A6B0288; Fri,  8 May 2026 16:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A5A6B0289; Fri,  8 May 2026 16:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4711D6B028A; Fri,  8 May 2026 16:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 221506B0288
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:20:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D923A1602B9
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:20:50 +0000 (UTC)
X-FDA: 84745371060.07.19D7292
Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5849F20011
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:20:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=o36snXT4;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf03.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.209 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778271649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29KI1/j+JXdLBNJzbc0TXvIFwLMcWJt6tJQuQMLll40=;
	b=dOF4OjkeF36Rr8xj7/lGCTfbbNhg/SLdJc2qDbyHjTXHUnlF+kEUWJRtuuygLYL5NMnI8q
	MwRVPeHpk38AKkbgBKOogaek+gwrA3ONQrXiciKJj09P50+TJa2EKwriRrwMo8Z/AVFKBJ
	LyUC9kh55aBM1wRaBKjBKpQ8wNi05gQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778271649; a=rsa-sha256;
	cv=none;
	b=KfMYulRZMAoiy9m69+T7EK7T7yqOsEYPa+tbIZzSeXTGc5maeXrmo98ExlOmAvUwsPEPBl
	H0tOQ/L1Jtj42bJnOh1Zfbdr4v/w+Ov9kyWwRu938W22h4i1HIu/7hEyW4f+OOyAMfrpsA
	FJfosFPz1u6whlYKEhfn0cR9k/pSUwg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=o36snXT4;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf03.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.209 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778271645; bh=29KI1/j+JXdLBNJzbc0TXvIFwLMcWJt6tJQuQMLll40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o36snXT4uUPxxiSeCajaLzd00StdwDaXhRZKGmJkzycdoBucQN0YpUhH86lI8Dk9D
	 0P4zMJEmN7rg1eBVAGQf/eRYgVCPZTZxERUba7iabrOvBuYdC8H7lbVtRmS0uXZ2Yu
	 MoBLG3n34AW0dP8CK2pT0XHzw0O9uYMadRcNg6p4=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 52124024; Sat, 09 May 2026 04:20:33 +0800
X-QQ-mid: xmsmtpt1778271642t5u9irdiv
Message-ID: <tencent_0CCC08D68D8D053417D633B1A2CA3C878706@qq.com>
X-QQ-XMAILINFO: OAzfp65MIvpERzYT1k3ro0wixZxiJcL77I+UCCx7gAIkkO/isQbR5rcycSQ58A
	 lM/4VEiqT1B75yxeE0/F08hxii/mHvWHARVhTLdadMdbz/AXjuCePyI5oOBOecipuLdvKWGQqR0Y
	 uGKU6YhfFfPesimHLW0fYB0MyNBhFVirEgLBz3AbjEyH3Qu3hyw7ZGqadbsgrCgxIIf0G1JTBgJQ
	 QC0BolnFeSoobUn4TlOvszp0kGYwUBwz4CbqPbmKB8qmThDHpYXtPpZ79bYDzEgz/zfVYN4/3F5P
	 GceU1wq+27Jc3Q+qMXi5mE5ghsXpO9Lc+UGVjYDwOwPTgoc6XPI+wvdERQKx9754Sy3+hX2czNF4
	 7xwUnsJNYgkisXP5KR5pc1SsWhDfS+1iGi2Qa+hg9b1+/PRZU5VVCC95nidVNneEQKcYPoCtcnK+
	 hK3ZXQHSJQJ2BoeWsPHUSzeSFQpAxuEPI9rm1GN5xrkIF71DP1/2SU1XOBJndW6xtmO1nZtBwcUI
	 nUulVxL08Xk5GvVrFTL51kn0LRhkjnNCRG8sJy5Tqas1m4Xjj1dqkgwcc+eXUmGYQch2jYLfACp/
	 ugjLTyoSgwTj2mZxiUYWRWAOsCC8xM+XNVERQy3HWR2m84Uw9zUzX2pJHntR6iSp569OnYY2vG4X
	 8FcMYREcE+1BSAfavOA2/R3S/5nFalVzoBwqJceMiIj3miPxbcMoPoeTtTj9dFj9z+bK4HMcgITe
	 +q6ubAJueWLZcrXEAp9+h2WDrQl7T71BI9oiYtOsrQ4F4KFPQ9SbFYrCDow6AV9ilPmjdJB06sJ9
	 1SBbMJBH4hUxb7Vi9bVD7+WTDOgy02L+s4Gow/FUrufXRsDYouYasZhw4UilxEgVxAlJ6Lr5op7/
	 FgUaCYazB9Guf6gAibFPqbZNwwVsIyt0nSdIz0NlLKVoSkk7+6ba3SRYBQWGU0E6kCp258PqNwwN
	 obPLFTxcf+8zed+A6wGNqHuy1z4N+RoDuW1rHa4W0W9FL7LEBTu7CEcEN/kJz/6wOqoYrfh24aog
	 UvOvahj/Y5Y6aZO+Or
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baoquan He <bhe@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC PATCH 5/5] mm: swap: allow zswap-backed large folio swapin
Date: Fri,  8 May 2026 20:20:33 +0000
X-OQ-MSGID: <20260508202033.1834876-5-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5849F20011
X-Rspamd-Server: rspam04
X-Stat-Signature: shna854x3e7cc6p5fedjsptdgq4h7ene
X-HE-Tag: 1778271647-399848
X-HE-Meta: U2FsdGVkX1+bHoaDzggzGbrK3yQsoOxKz6/VkenmeaIign9Kq5zmnt4cJIAxj00BY+r81fpwZuFg/toUGxSdFBjd0zo5uAYY/SDFuTige+/Rb627Xf8ZfBxqxw/HcoNLxNI5wFOa7GI3Ek9gVaeSoBiXwT6QkqWyGsMq6LjHTjmkH6u8mAflzEdqSs7rXq1OaZYBeen1vBDOrX0Na9O0uf0UogsXt+8MhjSpICp8RQzy3nWEqM6JyhhVIO5rsvqzanlU5YaDuHJdWo7sAII/wQRwKTNTgJW59aplh2/hmRdBpJ4zzgTslLCTMONRaweP8wqgBfyuCWougbti3+U+lyEeEmgy7K5sOzfVsEDxP3d3PBIVCddwrjEDQ2wC6RyGgaAYL7nWVSlG68AjJGmG5wLm1mInWqP/60XLiW9DEFFnqsnG7CULFIhbQNi3EERZsXxaNhf8jq7kMKwZgNGOOjiyLnfS1BglW5PZt/XXLbTziY1Gw2jsSk64DVj+bjMwA9W8CpcVmdIOhgn/MxP5zlF39zG9ecPbIwzUoO6AH8SZH8ouukhSwviNyIh+syVve2lI7aJrx0q/fy1ZNeIs3CQ3RClTZGRNhZLBIg6k8sUJlmf6Z5cG73GrbrraU1HVWcGEq9fI4XEhD7KcC9DA3CZWHLZtQ59G/92hR3FZkQ/1qJEnwP8lwG5tczFYZA/bBFp5YKybzht2F667s4O1tRoAJztxBgF2HVpCCbopWnrWJ8Oyrg04zO3CTZzm8Kcc6h6ov50T8hDLmfbwXVAF0y7mtMYALZUVjr4aCbD0RIJJZvr9mB/0GYsFC6j0BQ1+OBs53OvzgcKZO94jMq6CdNSMoEvfoRUWhriQz+WyNWA50ounPR6IjMBPUtRWZJbGhMybpMmm1s7J+SAmtCUL3DlioAbDz6vnj77lI2YFPBC1/Le6RFP+d2xdOsOTSzEaFCnfaLjihE3a30lahZJ
 tnxM97pF
 YoC0GoMapc8b/kNYLe8pPFQZfC/J+zgRu0fpRMjAYkHP4a6Y52IDwQvT5eXvf2eXeEJDUba26dXUMiTOlb6RW89gk33DvhJBmIrjtpyXz63jyd9Zv+RDXd6EQy+tFDleZKgATydDjnmEGvYpaX8IokJW/fwJJgrcW09STYe/SVbK1INI3w/PwTrdTr2tfFrMFWQpwdTE4oCpF4ub13VLHGnQvjVGkOq1egdivteKipnz/g58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_swap_folio() has been falling back to order-0 in the anonymous
synchronous swapin path whenever zswap was ever enabled, because a large
folio range could contain a mixture of zswap and non-zswap entries and
zswap_load() could not handle large folios.

zswap_load() can now load a range that is fully present in zswap, and
zswap_entry_batch() can identify mixed zswap ranges. Use that check
alongside the existing zeromap and swapcache checks when selecting a large
folio for anonymous swapin, and recheck before inserting a large folio into
the swap cache while holding the swap cluster lock.

With mixed zswap ranges rejected and the insertion-race fallback in place,
remove the blanket zswap_never_enabled() fallback from the anonymous swapin
path so all-zswap and all-disk anonymous ranges can use mTHP swapin. Shmem
keeps its existing zswap fallback and is outside this RFC.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/memory.c     | 21 ++++++---------------
 mm/swap_state.c | 23 +++++++++++++++--------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 84e3b77b8293..0be249108de1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -78,6 +78,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+#include <linux/zswap.h>
 
 #include <trace/events/kmem.h>
 
@@ -4635,13 +4636,11 @@ static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
 	if (swap_pte_batch(ptep, nr_pages, pte) != nr_pages)
 		return false;
 
-	/*
-	 * swap_read_folio() can't handle the case a large folio is hybridly
-	 * from different backends. And they are likely corner cases. Similar
-	 * things might be added once zswap support large folios.
-	 */
+	/* swap_read_folio() can't handle hybrid backend large folios. */
 	if (unlikely(swap_zeromap_batch(entry, nr_pages, NULL) != nr_pages))
 		return false;
+	if (unlikely(zswap_entry_batch(entry, nr_pages, NULL) != nr_pages))
+		return false;
 	if (unlikely(non_swapcache_batch(entry, nr_pages) != nr_pages))
 		return false;
 
@@ -4690,14 +4689,6 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	if (unlikely(userfaultfd_armed(vma)))
 		goto fallback;
 
-	/*
-	 * A large swapped out folio could be partially or fully in zswap. We
-	 * lack handling for such cases, so fallback to swapping in order-0
-	 * folio.
-	 */
-	if (!zswap_never_enabled())
-		goto fallback;
-
 	entry = softleaf_from_pte(vmf->orig_pte);
 	/*
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
@@ -4772,8 +4763,8 @@ static struct folio *swapin_synchronous_folio(swp_entry_t entry,
 	order = folio_order(folio);
 
 	/*
-	 * folio is charged, so swapin can only fail due to raced swapin and
-	 * return NULL.
+	 * folio is charged, so NULL means the large folio could not be
+	 * inserted and needs order-0 fallback.
 	 */
 	swapcache = swapin_folio(entry, folio);
 	if (swapcache == folio)
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 1415a5c54a43..4e58fad5e5f0 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <linux/huge_mm.h>
 #include <linux/shmem_fs.h>
+#include <linux/zswap.h>
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
@@ -207,6 +208,11 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 		if (swp_tb_is_shadow(old_tb))
 			shadow = swp_tb_to_shadow(old_tb);
 	} while (++ci_off < ci_end);
+	if (unlikely(folio_test_large(folio) &&
+		     zswap_entry_batch(entry, nr_pages, NULL) != nr_pages)) {
+		err = -EAGAIN;
+		goto failed;
+	}
 	__swap_cache_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
 	if (shadowp)
@@ -460,7 +466,8 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
  *
  * Context: Caller must protect the swap device with reference count or locks.
  * Return: Returns the folio being added on success. Returns the existing folio
- * if @entry is already cached. Returns NULL if raced with swapin or swapoff.
+ * if @entry is already cached. Returns NULL if raced with swapin or swapoff,
+ * or if a large folio fails a backend recheck before insertion.
  */
 static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 						  struct folio *folio,
@@ -483,10 +490,10 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 
 		/*
 		 * Large order allocation needs special handling on
-		 * race: if a smaller folio exists in cache, swapin needs
-		 * to fallback to order 0, and doing a swap cache lookup
-		 * might return a folio that is irrelevant to the faulting
-		 * entry because @entry is aligned down. Just return NULL.
+		 * race or backend recheck failure: swapin needs to fall back
+		 * to order 0, and doing a swap cache lookup might return a
+		 * folio that is irrelevant to the faulting entry because
+		 * @entry is aligned down. Just return NULL.
 		 */
 		if (ret != -EEXIST || folio_test_large(folio))
 			goto failed;
@@ -567,9 +574,9 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
  * with the folio size.
  *
  * Return: returns pointer to @folio on success. If folio is a large folio
- * and this raced with another swapin, NULL will be returned to allow fallback
- * to order 0. Else, if another folio was already added to the swap cache,
- * return that swap cache folio instead.
+ * and it raced with another swapin or failed a backend recheck, NULL will be
+ * returned to allow fallback to order 0. Else, if another folio was already
+ * added to the swap cache, return that swap cache folio instead.
  */
 struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
 {
-- 
2.34.1


