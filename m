Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 665DBC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 829466B00A0; Fri, 21 Aug 2026 05:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA4D6B00A1; Fri, 21 Aug 2026 05:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718FD6B00A2; Fri, 21 Aug 2026 05:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46B296B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:37:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C17B2403E7
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:37:28 +0000 (UTC)
X-FDA: 85124773776.12.B3730EC
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf20.hostedemail.com (Postfix) with ESMTP id C6D571C0006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:37:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787305047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jy82W4MviPGTYlbBQowSOgEMfhERVRjQ8h+9NnlN5rU=;
	b=OjA3wnRr11GDPlPgLRMQIUTCEBFBSKp2pnrLxuFBM1mFo4Cv7iv7/DbFGPXk/tMMVV7uh1
	FJ8Si906l/AQJiDq+YuVDu5X5JaKfsOTZLViBCOJYRNKKiiL7k1O2knuiyxH34/uJQL4tS
	Me3zsoxnvGB4QNd65WygihJGVaUejd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787305047;
	b=GWBbf2T9VcT/VxNOWfWiqJkXWLm+RHKQ2pOvWG1fZWr7axPW9OjvBfyeTRCBpYAsmnbOtP
	3yI7ea9OqWNvR1uM2Vr8xmn6khHhmaRDVIEwAZTWasbEr2nQkOYtF5oIWimROvHHbNrZHL
	D3pK9s2sMYxEOzPM50wJB6DtjmWCMPA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id D343B3E9A8;
	Fri, 21 Aug 2026 09:37:19 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 1/3] mm/swap: move LRU insertion out of the swap cache allocator
Date: Fri, 21 Aug 2026 11:35:54 +0200
Message-ID: <20260821093606.2231216-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821093606.2231216-1-alex@ghiti.fr>
References: <20260821093606.2231216-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTFmLzM5cVn7KwV26XiEXDg0lmGXQqe9RKtmcKqceNazziX/ykdTTsu+79nTd5hqnnSHBvisMOEF55FvLsS4cU+6O9gemYVEeK+sTkyv+0Zg286I3Fud0mhNuonjr0FXCfS0yiU/JwONCv+yho/BTusEFPfOXc1pQj6LofODHj6L7CBHD0f195pq4gbW5WXvn/nkNms9c4uhSrqmpZDkMMORcqSTn89v3vgo8dA/Ipt11EGRmmBSl2kNTvNALpvNrOVfQfc4xMIE5QY1Ct3anCGZz9gB9EIWnJDoZb3qeqN9JP6KSZ5CSJr4P7MdW+Tj0x5Irh55YHxCEKdmAOEuiuHgsyldsaaKbQv2w3luqJLoX+9XG6DwwB5IZyz8fFCxL0ulkmpRBAcg/8z0Oc2C7Ftg3WDnFuuTB/7y5eDjbypwdr3CffUIxNvigNi4UgeWwQVCWj6SlLNPlAbuTQ/tQzO7e3apjYJXkPKWbjv15J1hGSWmYvRESANPnn3sbNLY4wzc3Tc6VJ6K95QEXoYP5BfwmG8Uw6UKwwEwdZhXPsaRFBB8738+V7VOmN3kqpL6ghjxDCe5xMuuCNPJUmdTpjPljUT8kBEfwKOupUJ2qz8IyOIQj5Ohzalc7EsFa1wNU3tABN9UOGp+cByBRWB+xB55gDqJtwA/vT87Eja2u3RJtw
X-Rspam-User: 
X-Stat-Signature: d95ij64csctyjuno44qe9iopz6ufjiyg
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C6D571C0006
X-HE-Tag: 1787305046-816588
X-HE-Meta: U2FsdGVkX1/E6RbzgQwLRym4ZzrlD8QeGvJvK7IpPjp0X8jz19NAIjXgE4FiAU7zMTzAdQGAJEfvT4GgyEJVIk2QnmX9SPs7qkPRR+pNJvFCpnnFh6FBcWWjsEmhP+bW56kIshlZhyWxxNdD5zc4XFQMoERyVfpn4t0TsTDsoZezNUakC3P/uM1TyZQK3EPz8RL+AK1uz8hvEx4JFzOgJvN/HFPEReaBPmTM4xxjCJQfFw1ciZURn154I3QH/LQVq+be5+UwiTnI/U7M0sarU3yoX9JCWn7yU8CkdFWM+eLVDR57R7E0gLZ1+r71T8WpiGOhR3Swyk7dxwvcG0oCWJeECYjWuZYUV2qypAMSK4qb2zfHF8VldvyvkY77YwfRpc3BOC3FEUFm/EtuaqY4w/BfMbNqnZAJG/srqc41qIxJK25XsY0mlZtDGkN2lULf/NXmGk7QFG7wJgi128Plq9oV7VEQfobX/PAfwq6iQVnoHjOYRwqqnSU01hNUpAo+Lp+0gdrkoa8MaZAQrRVz8nIPvlNH/tE2VVY3+PxlpwQ/SUd41Fj9N4ZHZxmP/vvdcRaUUL7lRHNGJBbbhcC3nDrVcJigcF8onxHZ5IUzofhXngB0H1BR3Lyyoj/s8SOiyo7kfMvCn9YW9Ep3+CQ5vWphzE7lY+lqihhR2PkO2AcnGcZn1lodppabEd94SgTnXfa0HMpPgtSDKZ/WLAz1C/MFqJL81I/bQ4ONTFXCq09aer5fh0xNjCutsDDO9prPWQPHxtlUkokl4xZRHYpgd4HoyF4PeV2YivlmUN4QHnwzBB/W/C6Tcx5r/DPwK69PtkNl5alkjfnwO2CKNDJVsdSMcQAtU8ySSZM7iYgx0LRqDWbtZNroF8jHKEmPuEtdTD42VrcxxVe+M91qmfHBahbLe4czx+V5A+X4/DaRjevF1mW20u9JO3/DK6Pvogy4rca1wHJGULV4VdFLN/a
 zFwa8U3N
 8Lb1eKibyJ9ZncjAkSpuRqngGvSmt6qtkcqkt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The swap cache allocator adds the new folio to the LRU itself, which
forces every caller to live with that ordering.  The next patch needs to
evaluate the refault of a swapped-in folio *before* it becomes visible to
reclaim, because folio_add_lru() consumes PG_workingset/PG_active when it
picks the LRU list (and, under MGLRU, the generation).

So defer the LRU addition to the callers of __swap_cache_alloc_folio(),
no functional change intended.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap.h       |  6 +++---
 mm/swap_state.c | 20 ++++++++++++--------
 mm/zswap.c      |  5 +++--
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 77d2d14eda42..fc44daae1de1 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -304,9 +304,9 @@ bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
-struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
-				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx);
+struct folio *__swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
+				       unsigned long orders, struct vm_fault *vmf,
+				       struct mempolicy *mpol, pgoff_t ilx);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 9c3a5cf99778..90638a8d7232 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -483,13 +483,11 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 
-	/* Caller will initiate read into locked new_folio */
-	folio_add_lru(folio);
 	return folio;
 }
 
 /**
- * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
+ * __swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
  * @targ_entry: swap entry indicating the target slot
  * @gfp: memory allocation flags
  * @orders: allocation orders, must be non zero
@@ -501,13 +499,17 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
  * @targ_entry must have a non-zero swap count (swapped out).
  *
+ * The returned folio is locked and is NOT on the LRU. The caller must either
+ * add it to the LRU with folio_add_lru() so page reclaim can find it, or free
+ * it directly once done; a folio left off the LRU is unreclaimable and leaks.
+ *
  * Context: Caller must protect the swap device with reference count or locks.
  * Return: Returns the folio if allocation succeeded and folio is in the swap
  * cache. Returns error code if failed due to race, OOM or invalid arguments.
  */
-struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
-				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx)
+struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
+				       unsigned long orders, struct vm_fault *vmf,
+				       struct mempolicy *mpol, pgoff_t ilx)
 {
 	int order, err;
 	struct folio *ret;
@@ -643,12 +645,13 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
+	folio_add_lru(folio);
 	swap_read_folio(folio, plug);
 	if (readahead) {
 		folio_set_readahead(folio);
@@ -683,12 +686,13 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
+	folio_add_lru(folio);
 	swap_read_folio(folio, NULL);
 	return folio;
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..8163e6c5f76c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1000,8 +1000,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
-	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-				       NO_INTERLEAVE_INDEX);
+	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
+					 NO_INTERLEAVE_INDEX);
 	put_swap_device(si);
 
 	/*
@@ -1013,6 +1013,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
+	folio_add_lru(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
-- 
2.53.0-Meta


