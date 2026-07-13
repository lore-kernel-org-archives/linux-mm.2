Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE5FDC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCC96B012C; Mon, 13 Jul 2026 13:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69F3C6B012A; Mon, 13 Jul 2026 13:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4566F6B0131; Mon, 13 Jul 2026 13:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C24BE6B012A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:27:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53EFE4012B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:27:00 +0000 (UTC)
X-FDA: 84984433800.10.C1F38F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5BF1840006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XLoET2gF;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963618;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=406kThKl8y5/rTm/w7tdLo1Al6TNkSoQu1TGuw4jTUY=;
	b=KbZlAMAnHTbFbtaAyEEGGZ8nQ8Sbh4is8XCd2gZMMeUIlVqwki1HpYCLY6ggbk72t2fOIO
	ddE2kCDQpfAxY/RxJjpPynAQXkBnDei0E397KUMmz1pCfMJjlkn4hCAtQCiRct1BqZmKcZ
	Pp0iNtofUPQ/3bKnFY0eb9s4lIJFncM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XLoET2gF;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963618;
	b=Ju9cy53OjpjYRi3Lwth0iVccmeG417nffOw0RsrWvWnCwf0ApFo/d/opKoE8iajwZm8TFd
	x0FWg8q9u0/7+64ZbU9KH81asEPFbkgrO+6mOUIAJ4H9yO2KQ/fE+3BM9NYGlO9zQECPNZ
	zZ1Hz3lL9CBzjZoHN2yiTS/FDtAu+14=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6601743AF3;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4AAA7C2BCC7;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783963615;
	bh=jSttoTQ+5tq94iBCfbqmVA02B8ZLP5x+PrcpR0wM01s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XLoET2gF85tjKX7YS8zMgutusg5Tg3yf2pYufWrKXtRxX5gCFqfQWxeDdwhJaDT4M
	 YoZg9u14HM2cSNYWONUgrJbdmVnGfXl+PbsZOgeR0yGKFk02aexs8MEsCSzWYZaCtc
	 6TNZbsSCXarA6WwCo9NUMDCysAhAacy8rmKxgPo5yKQej3e0Ygn4hOWy9OClm+4mcE
	 n2LrYvv1h4z+Z0W5ZiwDKlHI0GJMaabCAWjmjMDZRBXRIoizG6TcL0T6HXcu3dXvIa
	 7HLCWpQsvVUEy9r8h6ps9rJXPDyA2NkEmzUVAcYIAQLq3zNe2xfXw3+qgWrpW77ACq
	 3bto8zGygTw0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396D9C44509;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 14 Jul 2026 01:25:48 +0800
Subject: [PATCH RFC 10/13] mm/swap: remove available list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-swap-pcp-priq-v1-10-de9b164ed419@tencent.com>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
In-Reply-To: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783963612; l=4228;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=56bxVOA8Kh8NG90pe0lrBG+qdvyKutM/P/TW2AoLLAg=;
 b=AB+E/zHQ9XaayHuwu1wLH65kfRaAKI0gjPf/1wBZpP4AycdYJe/1cG5AuMpFV+B3fK04NNpMc
 RIcqDcMfR3+CO/ZovoZXzpo7n87PKqoKoD6nEjhKAqBJhXBHvr5Dwvp
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5BF1840006
X-Stat-Signature: mk813q4xat5xr763gzaqy9bmx8t9g4dc
X-HE-Tag: 1783963618-15300
X-HE-Meta: U2FsdGVkX181gtWFuOrqZFaj1hZ7SK9xOiNzPKAQX4esWHnmk/kLozQm/sdCu7DX/t81ZMt19wbUq3Zw58vN5kw6EVgqA6dF6ufPIuHYjDASsylWYskiOw43scjU2WzRzBZLWKZKfrTzys83j+ffwnQvbMGH+uRl00oFzFIsjPWJamFlYtMgOpwp3JcURGwexEJBfHiUAWpZB7PT/KJDlBVuSaF+w+ZCz5aowQHNtoHDX0LJvBVimEhOEOV9EvxFDMJreAczddz7VPONs87zjwasiOCB9aRK02p6OaUn80eoHMRNQsnMMpp3CIIBvnSzzIaFggcLlIN0lYlwAxTHdRjXGNI0MGozWcLq1W6LEAbLgLCNgrOZjRFtVmehr6PvTww5oio5wqXtyDs4UeDCm95r+S+ylQojklyUHNV0K8xPlT3PK46PbzFJhFMN+dwxsRyBQzREMLHiS4lDRA5cv2ppRhqajaR5lOuMH5OBhUX2L3OTdc77yQcOqSz+5Kapjj1p22sMaMCdWZJxcSznu7jHOYNLOGE9URNd0RRkyJfBrUioVm7OJW4r87+7fVWddbrEtvy7RuMYgRUHPLOFJHa5xWINGauWdjcXMI+dXz9+3X/uDMZFAal88B6LjkJ8OFEJ1PHDK73WcTrx1lkohwsHoa9ECitD9c8o3lWgZqtx0BZoNb/p0QINbeZTfE4Q7Fk+4KKx1EPPbgM0Mw6uBv+GqnHgaIqxlkZfAPkhdxXIfiSDbr104VHZNNeou6mzTvbk/qIvO3Knd4rryxXXETr7gwrXwFCTXqXqdZenEBRhSCR0W2OadAdk+c7cmD65SRA31WnUe5FGP6j+Rthvh7MGHRQb3+yUsiNs8C6CY5v5dq76kRhzexa8nYfg/Xo11rma/tDhWEJkNFwPCQRgG3OTpOqlIrkN4TxcpaJ4MWfTsZm9Wnt0A/7JwB9mf/02YrWiiLEl9zQ1JMIcI1+
 HO6gyZAo
 9PLjT+WoIaZVvqmhJJ+a0UPCb9576Q5go5lC2SI/1Swzl2xlrhyhOPqoZSJztFGhe29oaXJZiPznBCagkNFCfmfExQVZA5ZyowdEN+HIDuleuo52zKObwCctIj7KUc2j6omLYPhzMa2/v1fUNwQwb9Zj4tDYj4P+yylmGLS4Mio0Pnk628DmUGCApr0KCcoM6hcHfWDQYKlEqGspk6Ii26Fk01T1NHUr8AHdGN640sYe4DELnSZiwKF/i4hBwi3XPFIn0bi/RU07RkPWGwHGy57Y2zCiemWkBrDzgrjMgG7Q+vuyd/lv8jvvny6GgZ2DfTS+PFEPsWyU3txC4aC+NDvbFGcCK9dGJnXa/6/tqfS2bejOtyG9KTKGQ6vI7AIaRPCwrPPQhvbQnATBPfefa5c8suQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Pure cleanup, no functional change.

After the priority queue replaced the allocator's device selection,
swap_avail_head and swap_avail_lock are useless now.  Remove them.

__folio_throttle_swaprate() now iterates swap_active_head under
swapon_rwsem instead, the SWP_WRITEOK filtering makes it equivalent to
before.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 30 ++++--------------------------
 2 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6733a8979aa2..189c9898641b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -293,7 +293,6 @@ struct swap_info_struct {
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
-	struct plist_node avail_list;   /* entry in swap_avail_head */
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f6dd85968928..01240c4c9db3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -96,21 +96,6 @@ static const char Bad_offset[] = "Bad swap offset entry ";
  */
 static PLIST_HEAD(swap_active_head);
 
-/*
- * all available (active, not full) swap_info_structs
- * protected with swap_avail_lock, ordered by priority.
- * This is used by folio_alloc_swap() instead of swap_active_head
- * because swap_active_head includes all swap_info_structs,
- * but folio_alloc_swap() doesn't need to look at full ones.
- * This uses its own lock instead of swapon_rwsem because when a
- * swap_info_struct changes between not-full/full, it needs to
- * add/remove itself to/from this list, but the swap_info_struct->lock
- * is held and the locking order requires swapon_rwsem to be taken
- * before any swap_info_struct->lock.
- */
-static PLIST_HEAD(swap_avail_head);
-static DEFINE_SPINLOCK(swap_avail_lock);
-
 static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 {
 	lockdep_assert_held(&swapon_rwsem);
@@ -1547,7 +1532,6 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 {
 	unsigned long pages;
 
-	spin_lock(&swap_avail_lock);
 	spin_lock(&swap_queue_update_lock);
 
 	/*
@@ -1567,10 +1551,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 	}
 
 	swap_queue_mask(si);
-	plist_del(&si->avail_list, &swap_avail_head);
 skip:
 	spin_unlock(&swap_queue_update_lock);
-	spin_unlock(&swap_avail_lock);
 }
 
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
@@ -1579,7 +1561,6 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	long val;
 	unsigned long pages;
 
-	spin_lock(&swap_avail_lock);
 	spin_lock(&swap_queue_update_lock);
 
 	/*
@@ -1610,7 +1591,6 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	}
 
 	swap_queue_unmask(si);
-	plist_add(&si->avail_list, &swap_avail_head);
 skip:
 	spin_unlock(&swap_queue_update_lock);
 }
@@ -3622,7 +3602,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 	}
 	p->swap_extent_root = RB_ROOT;
 	plist_node_init(&p->list, 0);
-	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
 	percpu_up_write(&swapon_rwsem);
 	if (defer) {
@@ -4030,7 +4009,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	 */
 	si->prio = prio;
 	si->list.prio = -si->prio;
-	si->avail_list.prio = -si->prio;
 	si->swap_file = swap_file;
 
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
@@ -4163,14 +4141,14 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 	if (current->throttle_disk)
 		return;
 
-	spin_lock(&swap_avail_lock);
-	plist_for_each_entry(si, &swap_avail_head, avail_list) {
-		if (si->bdev) {
+	percpu_down_read(&swapon_rwsem);
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if ((si->flags & SWP_WRITEOK) && si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
 		}
 	}
-	spin_unlock(&swap_avail_lock);
+	percpu_up_read(&swapon_rwsem);
 }
 #endif
 

-- 
2.55.0



