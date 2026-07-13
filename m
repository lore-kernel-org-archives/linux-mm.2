Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982EDC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89BA26B012E; Mon, 13 Jul 2026 13:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7885E6B012F; Mon, 13 Jul 2026 13:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5816B012B; Mon, 13 Jul 2026 13:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6B9A6B012D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:27:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69B9E8C86B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:27:00 +0000 (UTC)
X-FDA: 84984433800.12.C7835A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 575C840008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXUp7Eh2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963618;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OONJmb6CSzdS4GzT8ONclh9195Ki1N3avOmvW4GE648=;
	b=PTjkH0FUOnFdUCxPOBDYiCrDEunMhXQe0YCrLWrvcMDoWkZSj2dsSKfthKaHob5nvaVFrL
	vwOwCg4slEQwuFM5qnkKMU2KfMEVRX8MU103kSTGJNz+4hZkrd85WqsluIbtcwbZvRdzO9
	C9eaieGg2Ke8MSTGEPxfiLUwFwAFWBE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXUp7Eh2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963618;
	b=SPRc9jB4E46K2/WhG0Lrfc4YyuWBQOAR8tUKDcWUMaK8XIAVfxI7aeLVGB0joPRQzu4rPe
	+kAlbxqTAUcOoesmgZXfkI0xIn2Eg2O/2nZV1MN6v3KU+IkXOd3ZbAhoADb6scVm3jAT5E
	CFNl/bJ2Zf/t/iZPrwj3HWVDmYDvLvM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88CEE43B00;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D312C2BCFC;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783963615;
	bh=OS4JIaTeeAb4KSOvL78pQgFPmyNPwbHN2qLt75AcNeU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=SXUp7Eh2WqbTV2o/LHlwFpu+XmADivXhXSYAV+6jhTwpoJWyLZ6vp+r1aE2nAMaOL
	 SmKDhBa6aTNAqZCKr+YKy60np4vzHJ5+ToNypJvdP2rkjsiSXsUwcQ1+2anD1jeeFJ
	 LMJhwH38cX3SYorUdHJNHSy4QRuCQQbceylHTu2Na/C5kbJLr6HOEh2A4lfMMusCMW
	 rmBnxtKpRM0rtf5ENUGrBF1SJ4qSs+LGsXxTw4H/oWbkxX/9gmsr+S3JXaXqhDwBXh
	 Hc5RjSk/gINjb1lmozsHdu/M6TDOG3eUnACFvuTkhIdrBsX1MKYEWw6mlYNw+tZZXI
	 5uwVwN5vNyU1Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E54FC44507;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 14 Jul 2026 01:25:50 +0800
Subject: [PATCH RFC 12/13] mm/swap: drop swap active plist
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-swap-pcp-priq-v1-12-de9b164ed419@tencent.com>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
In-Reply-To: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783963612; l=4414;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=G45gA89umSL+kNs6bHyiaF1kIcN9pJ1ls62NQeOiYC4=;
 b=u/9trm152FgryD98mxUIQo6uu+x7EW9bzV/9nIVIRIh+hgrKj7kmLlR7Hv9I6jJ7gNWDavUCJ
 duRagp71EcEAIb40QpjiSyJQ5sj8Hf12sDBBp+XT3wQO0N93DXKzAqv
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 575C840008
X-Stat-Signature: hg6bepwhatgq7atq4nr8sm3y5cdpegdk
X-HE-Tag: 1783963618-981163
X-HE-Meta: U2FsdGVkX1+3Hi3LPeravmilP5SuoMH/ozYi8YuYqlqhhd8kn7p/m6ZfouCX+GLn6Xr1QBK+b0oKxifj3xJBpLf9C4EK5loS/Suf8nqaxq8cjsdo0fHxljnnwSWol7/rHr8uWpR5bR9b8jr2tT3URC+eVe+P3VBdnGAIVEN3rRBjyfR32NqTbvfWz1xJa+9QoKRpwtP4cX9ctgh4AP8vqQUOdZ0hUxf2Im6XHNBSCh2YZlHx7n6OPDwsqcqEBfTt6IOXuWAYpk/96mqIirEGm4kUVa+L1PPY5oXxAJS0dHQuotBDuz4/TJXizK+fx6mYAwXC/+8WYUltfDu3dfPu5fTWIdkhZCn6PcFPxw4tAe2HOhJ3/1fDWct705UjsfJZ1PnZ94vSU1lHrZQ+rTteWtaUA3cAONWNVU97bZ+DIgn5drR/f0jGBfdZtCUzwyS29TRBfqi7CtkFO7XpW6HGLiyz4nXYOZB0Hzxvy9J2ZvFqmG8DlgbHeeP1x+OABu7jMi/m6YADg78zeYl7V9L4A2x5kPqW2HcI3M6yvtQN+oNd/cymE3EPpR/pLEwzvr+MnaQcFFUwWB4OWHFXOCpPnIFtsXwp2n1aUqZEJC5GZjNB0UpeeTyBOsWc4rcJZJ+W0kuZddd8CeeY7xAliLGCChbW8oUJf54W+G/3PGUglh13ZN7P8ps1YFejb0EVEePQ5F/i0jnTT4U+BI49+08LfvnS0rrtsHI2Bgw1zycgYeAcDJXpBpzYCn3XGeIM3LxwY/uWHk4YAuZGHUWByw7oqjQ9UPTc9xyYFdpwLLEpH6K9FarWETkS0xd1+5sdlGJoaXtMsYzaufzaCKIxvJKdMmkjYR0/VUQTw2Lb7QGFEiD3wkbMXhiG3VHsiOdZrDiWCeBofpeyzg3vk1uMtL2XO+zYEd1NYhl2URqLC6l/lIQj1vwUC0uiLvOkHiWiigG52YQtbnJDmmm6zNjYGV9
 JP8J60aB
 dJ6LXsa/UCEpO9UGvWrJ9NB2bxH73ydy8cCHAOrGl8DVPzxb+Rk7gAeFrCXWuHh3hCKSSodwZolo49c9ws5vHqt7Otto/Cul2HiZF/WFCCIITJJkPuKooakgiLyESwUl1yL+AfOEPcbgKqCdT6UUEsPj8Bc1YpZf9X7tDUzaxbdklsySfaWRXSpqREvjAonGbYBmCOO35pSfO/bV7lh3b6f/+LgGaHCXbHAYDk+OxoztYMt8jhT5ZEijzup8s+uH1CANVbKdUbbYFIBWYH9GcScrhPCeOdEtDQ5rUscG9wODQEskZlp1ZIpykEjYcKwzU3oQ6pR6RwaakHBhbK0M2K2YMM3sg1I18/NdWL5Bv76hMQtIkvt5yfcW4WojBO54G9g8eHVfP+UfSlln2G+IoX+IOjiI5R5RSI/z7o3koCVyDgdJx6tyJpjKKZR406qPnWhgk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The swap_active_head plist tracked all writable swap devices, ordered
by priority.  Now that every consumer that needed priority ordering
has moved to the priority queue, the remaining users only need to
find any writable device.

Remove swap_active_head, the associated plist_node from
swap_info_struct, and migrate the remaining plist operations.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 26 +++++---------------------
 2 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 189c9898641b..04767540972b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -267,7 +267,6 @@ struct swap_info_struct {
 	struct percpu_ref users;	/* indicate and keep swap device valid. */
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
-	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 74a50c39da60..f93863309a5a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -41,7 +41,6 @@
 #include <linux/completion.h>
 #include <linux/suspend.h>
 #include <linux/zswap.h>
-#include <linux/plist.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -90,12 +89,6 @@ bool swap_migration_ad_supported;
 static const char Bad_file[] = "Bad swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
 
-/*
- * all active swap_info_structs
- * protected with swapon_rwsem, and ordered by priority.
- */
-static PLIST_HEAD(swap_active_head);
-
 static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 {
 	lockdep_assert_held(&swapon_rwsem);
@@ -3212,7 +3205,6 @@ static void swap_device_enable(struct swap_info_struct *si)
 	spin_unlock(&swap_queue_update_lock);
 	atomic_long_add(si->pages, &nr_swap_pages);
 	total_swap_pages += si->pages;
-	plist_add(&si->list, &swap_active_head);
 	percpu_up_write(&swapon_rwsem);
 
 	add_to_avail_list(si);
@@ -3244,7 +3236,6 @@ static int swap_device_disable(struct swap_info_struct *si)
 	spin_lock(&swap_queue_update_lock);
 	si->flags &= ~SWP_WRITEOK;
 	spin_unlock(&swap_queue_update_lock);
-	plist_del(&si->list, &swap_active_head);
 	total_swap_pages -= si->pages;
 	atomic_long_sub(si->pages, &nr_swap_pages);
 	del_from_avail_list(si, true);
@@ -3306,9 +3297,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	mapping = victim->f_mapping;
 	percpu_down_read(&swapon_rwsem);
-	plist_for_each_entry(p, &swap_active_head, list) {
-		if (p->flags & SWP_WRITEOK &&
-		    p->swap_file->f_mapping == mapping) {
+	for_each_avail_swap(p) {
+		if (p->swap_file->f_mapping == mapping) {
 			found = 1;
 			break;
 		}
@@ -3579,7 +3569,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 		 */
 	}
 	p->swap_extent_root = RB_ROOT;
-	plist_node_init(&p->list, 0);
 	p->flags = SWP_USED;
 	percpu_up_write(&swapon_rwsem);
 	if (defer) {
@@ -3981,12 +3970,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 
-	/*
-	 * The plist prio is negated because plist ordering is
-	 * low-to-high, while swap ordering is high-to-low
-	 */
 	si->prio = prio;
-	si->list.prio = -si->prio;
 	si->swap_file = swap_file;
 
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
@@ -4096,7 +4080,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static bool __has_usable_swap(void)
 {
-	return !plist_head_empty(&swap_active_head);
+	return READ_ONCE(total_swap_pages) > 0;
 }
 
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
@@ -4120,8 +4104,8 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 		return;
 
 	percpu_down_read(&swapon_rwsem);
-	plist_for_each_entry(si, &swap_active_head, list) {
-		if ((si->flags & SWP_WRITEOK) && si->bdev) {
+	for_each_avail_swap(si) {
+		if (si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
 		}

-- 
2.55.0



