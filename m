Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B606BC88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 18:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB916B0088; Wed, 16 Sep 2026 14:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3C76B008C; Wed, 16 Sep 2026 14:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CAA86B0093; Wed, 16 Sep 2026 14:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE796B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:34:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72DCB407E1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:34:42 +0000 (UTC)
X-FDA: 85220476404.03.B748B83
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2A3A81C0006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:34:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789583680;
	b=0dtVOlp81uJmtEOxoDxA9q1FBWA4BMbwK0iwXnep0frAC1k8SqCBEzdx0SwIwGmMyhbJHV
	xuyknX1jpWKX4Wy6AE+EWh7v58Q9lWx6QcLCtqCnCFMdbLVsaexLh4OusJjCHNztaaZ0Bv
	c+94G16RylFYXlIW1HlCpDlyXokS8cI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789583680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mDu+I8ZQNrJOrZW50lylvCYc5vXsbZjr9CEmyRt8TXQ=;
	b=woS0baKychLL9BTNAfT/csdwOKXZT2SBw4IGjJ3azp/ManVCIjzwJOXyz++VXbTQAHeMDU
	02coWY3wSTbrSvakKwgtkcUrBOP4bDzXH3tMWEKNt9gWuiBiL75rMoam0QcAhhFu0VYzUg
	2smr2bMMVW69reKKAl3MTQlSYL3O0kU=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 17 Sep 2026 03:34:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	joshua.hahnjy@gmail.com,
	taejoon.song@lge.com,
	her0gyugyu@gmail.com,
	lianux.mm@gmail.com
Subject: [RFC PATCH v11 2/4] mm: swap: allocate swap slots from swap tiers
Date: Thu, 17 Sep 2026 03:34:35 +0900
Message-Id: <20260916183437.2946306-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260916183437.2946306-1-youngjun.park@lge.com>
References: <20260916183437.2946306-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A3A81C0006
X-Stat-Signature: fyurbffykhxix3z374sfuwxqyph1p46k
X-HE-Tag: 1789583679-916096
X-HE-Meta: U2FsdGVkX1/ac6s+CPiapaQJqB19D755yvijkxQ9lZZ6sFKCLdLUSLxS6VL+q6ooUw+SCFFykNFjBDatRuejdCFHHGK0xpRmt5/uKICx45LlpNaUvKudHyngWMRkWMobC8DyOa5tp3Jrvshp0Q+pRspEqg057ALOFiViqJA/xj7/C+Ir6285ECXnWriTTXqnhstqNYQlCnJitqraBjV1irSSWoKKCaGzMuDF2FX2hlogLwkNcD7A3TNNzJaDO3xzguxKBRf0isNZpDrv/S4LEB0z+alkUWoaWJkzD+n5eO3SyluSJLdteRTv2ieOjUb4ZYU/xpRH5gy/2KLq3RhLwjZUjiay2DrSV+WCJiKyLPSIyWl9YnHt10OjYggta39C1Itiyf7hfkBAA7A1/mYHGz4NPMpnk13Da3VXEN5H4wzxNn5q42QyvDMxlPm+6iSO3d1YjD2nqqG18pyntETidXpE+oSYs7a479DZg3lpfv75HcCQp8TnAFYMkJIuPFTVld6X9PZnWpitBRJpwYu2TIqkKKgXoemhmfZgconTjOq4SDiHDgtnz9bK/OIbF6fdxDtrTirngvuE9zfeBtPcuz9p5/c9NCFfzl1c7sjmoci0SbrUGDcfTHXqli8S/YmKYHidyQRIJB7nsYWakTfoTZzEGwNtwJLTmPeMKzxPJqcHe2i3nVvLiwvwqi3yPEgpGhKXz0IUJA5uW+pUu/b7QY32CGhxFU31hy1h2dQ96q26gY3eNVDqSDwLFmDGiiqUsAi2H9V+BkoQ/gD19sQVk5u2pyrw4Ws9P1WbqvyJvJmy3lOIGmQjFEIDgUoWyLNP9ehNhiwaC/jpDXu1pyC2LyFYNZum0Su4AfQeL0l1v3gSTwsqqscJlsMaGBQBVtejIGvYv1BJHp961Rz/hK89jJ4nQF2ltJpca9VqoauU8rIZpcEZTA6Z8/MqLetcMa3Ho/vliHVtw1TPbqTenss
 EkqXgCib
 WXzclLR9wF33tD6Z1DsRGFTVV80tep8BLP4Z69heYNpEsKoXHUZl5r+OmWT7v+IvLDKYoXsc79vUE7rrIeEhcm9LfHsKaLbg6KUNdmDz04mYMK6Thj0MfWmxXeAJWcIvUZrGHKJYJD0K+r43Bf7b/oFquHTZJYnBXpsM88PXwk8/iCxwK6NrAn5p+FlRoG+vlG4r/Ic0kLL12OfHcwQou/93DgIEJpJJpPdojPncZtggannfbEaJfE1XzlShHZ0nAiOqoU886/8CYbl0/X1KHFjolrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The slow allocation path walks swap_avail_head, one plist of every
available swap device, ordered by priority.

Give each tier its own list of available devices instead. The slow path
now walks the tiers in order, and walks each tier's plist as before.
__folio_throttle_swaprate() walks them the same way.

swap_avail_lock still protects these lists. The tier list changes under
it too, so the walk can go on after it drops the lock, as long as its
tier is still there.

This is the groundwork for the per-priority allocation queue series from
Kairui and Lian [1]. That series can move onto the per-tier device lists
one tier at a time.

[1] https://lore.kernel.org/linux-mm/20260829-swap-pcp-priq-v2-0-68d3d925578c@gmail.com/

Assisted-by: Claude:claude-opus-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/swap.h |  2 +-
 mm/swap.h            |  1 +
 mm/swap_tier.c       | 17 +++++++++-
 mm/swap_tier.h       |  3 ++
 mm/swapfile.c        | 78 ++++++++++++++++++++++++--------------------
 5 files changed, 64 insertions(+), 37 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 22ccb4b5801e..df69c2dd434a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -268,7 +268,7 @@ struct swap_info_struct {
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
-	struct plist_node avail_list;   /* entry in swap_avail_head */
+	struct plist_node avail_list;   /* entry in its tier's avail list */
 	const struct swap_ops *ops;
 };
 
diff --git a/mm/swap.h b/mm/swap.h
index 4de6b9b0f261..916c0ad128f7 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -37,6 +37,7 @@ struct swap_io_ctx;
 #endif
 
 extern spinlock_t swap_lock;
+extern spinlock_t swap_avail_lock;
 extern struct swap_info_struct *swap_info[];
 
 /*
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
index 8ed1427cee09..286f319fb125 100644
--- a/mm/swap_tier.c
+++ b/mm/swap_tier.c
@@ -65,6 +65,7 @@ void swap_tiers_init(void)
 
 	for_each_tier(tier, idx) {
 		plist_head_init(&tier->active_head);
+		plist_head_init(&tier->avail_head);
 		INIT_LIST_HEAD(&tier->list);
 		swap_tier_inactivate(tier);
 	}
@@ -92,11 +93,14 @@ void swap_tiers_assign_dev(struct swap_info_struct *swp)
 
 	lockdep_assert_held(&swap_lock);
 
+	/* The allocator walks the tiers under swap_avail_lock. */
+	spin_lock(&swap_avail_lock);
 	tier = swap_tier_lookup(swp->prio);
 	if (!tier) {
 		tier = swap_tier_prepare(swp->prio);
 		swap_tier_activate(tier);
 	}
+	spin_unlock(&swap_avail_lock);
 
 	plist_add(&swp->list, &tier->active_head);
 }
@@ -109,6 +113,17 @@ void swap_tiers_remove_dev(struct swap_info_struct *swp)
 
 	tier = swap_tier_lookup(swp->prio);
 	plist_del(&swp->list, &tier->active_head);
-	if (plist_head_empty(&tier->active_head))
+	if (plist_head_empty(&tier->active_head)) {
+		spin_lock(&swap_avail_lock);
 		swap_tier_inactivate(tier);
+		spin_unlock(&swap_avail_lock);
+	}
+}
+
+/* The avail list of the tier @swp belongs to. */
+struct plist_head *swap_tiers_avail_head(struct swap_info_struct *swp)
+{
+	lockdep_assert_held(&swap_avail_lock);
+
+	return &swap_tier_lookup(swp->prio)->avail_head;
 }
diff --git a/mm/swap_tier.h b/mm/swap_tier.h
index 3dce716d23f6..c4347c28d8f1 100644
--- a/mm/swap_tier.h
+++ b/mm/swap_tier.h
@@ -14,11 +14,13 @@ struct swap_info_struct;
  *
  * @prio: priority of the swap devices in the tier.
  * @active_head: swap devices in the tier.
+ * @avail_head: available swap devices in the tier.
  * @list: linkage into swap_tier_active_list or swap_tier_inactive_list.
  */
 struct swap_tier {
 	short prio;
 	struct plist_head active_head;
+	struct plist_head avail_head;
 	struct list_head list;
 };
 
@@ -33,5 +35,6 @@ void swap_tiers_init(void);
 /* Tier assignment */
 void swap_tiers_assign_dev(struct swap_info_struct *swp);
 void swap_tiers_remove_dev(struct swap_info_struct *swp);
+struct plist_head *swap_tiers_avail_head(struct swap_info_struct *swp);
 
 #endif /* _SWAP_TIER_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8201ae779833..e9d142c0655b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -85,8 +85,8 @@ static const char Bad_file[] = "Bad swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
 
 /*
- * all available (active, not full) swap_info_structs
- * protected with swap_avail_lock, ordered by priority.
+ * all available (active, not full) swap_info_structs are on the
+ * avail list of their swap tier, protected with swap_avail_lock.
  * This is used by folio_alloc_swap() instead of the active lists of
  * the swap tiers because those include all swap_info_structs,
  * but folio_alloc_swap() doesn't need to look at full ones.
@@ -96,8 +96,7 @@ static const char Bad_offset[] = "Bad swap offset entry ";
  * is held and the locking order requires swap_lock to be taken
  * before any swap_info_struct->lock.
  */
-static PLIST_HEAD(swap_avail_head);
-static DEFINE_SPINLOCK(swap_avail_lock);
+DEFINE_SPINLOCK(swap_avail_lock);
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
@@ -1226,7 +1225,7 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 			goto skip;
 	}
 
-	plist_del(&si->avail_list, &swap_avail_head);
+	plist_del(&si->avail_list, swap_tiers_avail_head(si));
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -1267,7 +1266,7 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 			goto skip;
 	}
 
-	plist_add(&si->avail_list, &swap_avail_head);
+	plist_add(&si->avail_list, swap_tiers_avail_head(si));
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -1398,35 +1397,40 @@ static bool swap_alloc_fast(struct folio *folio)
 static void swap_alloc_slow(struct folio *folio)
 {
 	struct swap_info_struct *si, *next;
+	struct swap_tier *tier;
+	short prio;
 
 	spin_lock(&swap_avail_lock);
 start_over:
-	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
-		/* Rotate the device and switch to a new cluster */
-		plist_requeue(&si->avail_list, &swap_avail_head);
-		spin_unlock(&swap_avail_lock);
-		if (get_swap_device_info(si)) {
-			cluster_alloc_swap_entry(si, folio);
-			put_swap_device(si);
-			if (folio_test_swapcache(folio))
-				return;
-			if (folio_test_large(folio))
-				return;
-		}
+	for_each_active_tier(tier) {
+		prio = tier->prio;
+		plist_for_each_entry_safe(si, next, &tier->avail_head, avail_list) {
+			/* Rotate the device and switch to a new cluster */
+			plist_requeue(&si->avail_list, &tier->avail_head);
+			spin_unlock(&swap_avail_lock);
+			if (get_swap_device_info(si)) {
+				cluster_alloc_swap_entry(si, folio);
+				put_swap_device(si);
+				if (folio_test_swapcache(folio))
+					return;
+				if (folio_test_large(folio))
+					return;
+			}
 
-		spin_lock(&swap_avail_lock);
-		/*
-		 * if we got here, it's likely that si was almost full before,
-		 * multiple callers probably all tried to get a page from the
-		 * same si and it filled up before we could get one; or, the si
-		 * filled up between us dropping swap_avail_lock.
-		 * Since we dropped the swap_avail_lock, the swap_avail_list
-		 * may have been modified; so if next is still in the
-		 * swap_avail_head list then try it, otherwise start over if we
-		 * have not gotten any slots.
-		 */
-		if (plist_node_empty(&next->avail_list))
-			goto start_over;
+			spin_lock(&swap_avail_lock);
+			/*
+			 * if we got here, it's likely that si was almost full before,
+			 * multiple callers probably all tried to get a page from the
+			 * same si and it filled up before we could get one; or, the si
+			 * filled up between us dropping swap_avail_lock.
+			 * Since we dropped the swap_avail_lock, the swap_avail_list
+			 * may have been modified; so if next is still in the
+			 * tier's avail list and the tier is still there then try it,
+			 * otherwise start over if we have not gotten any slots.
+			 */
+			if (plist_node_empty(&next->avail_list) || tier->prio != prio)
+				goto start_over;
+		}
 	}
 	spin_unlock(&swap_avail_lock);
 }
@@ -4013,6 +4017,7 @@ static bool __has_usable_swap(void)
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
 	struct swap_info_struct *si;
+	struct swap_tier *tier;
 
 	if (!(gfp & __GFP_IO))
 		return;
@@ -4031,12 +4036,15 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 		return;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry(si, &swap_avail_head, avail_list) {
-		if (si->bdev) {
-			blkcg_schedule_throttle(si->bdev->bd_disk, true);
-			break;
+	for_each_active_tier(tier) {
+		plist_for_each_entry(si, &tier->avail_head, avail_list) {
+			if (si->bdev) {
+				blkcg_schedule_throttle(si->bdev->bd_disk, true);
+				goto out;
+			}
 		}
 	}
+out:
 	spin_unlock(&swap_avail_lock);
 }
 #endif
-- 
2.48.1


