Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A216C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392106B0128; Mon, 13 Jul 2026 13:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C666B012F; Mon, 13 Jul 2026 13:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16EDF6B0128; Mon, 13 Jul 2026 13:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0B1B6B0124
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:27:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5174EA0104
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:27:00 +0000 (UTC)
X-FDA: 84984433800.07.F9DDD71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4CFE814000F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IrqC8bJZ;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963618;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhoNl5rM5k2cnlFX7BOC1yZAGiHc601g+EjbNXjNheI=;
	b=64hWSS2KfXyJOvn81VhO/30ze9ibUM+ombMJPS7kZkGNUbHHmtS9OAm2mHa+qvBY4TPMDy
	Y3ehtJCHv/VFUxKvda/dadfOQr5iA25/hQMpsLtbtQhx8Q1ySTqdmgYDg5Z+p9pUT6B4oB
	JgLCiebZgOUSkI+RjSn12vDsgiwisGs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IrqC8bJZ;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963618;
	b=VjMtsP9l1yxHPyj++i0J+PLbIK51U4VXN5cb47RHqRwQUru2w3OLjrNMZd+4W52SL1ei7v
	ZPfTZnAtzbUC5+VnbAtKw30SK+M8aMAT/waHJtwN0YN3UCrrOxltTb+VKTvAmmj34bXpa5
	5Lc/u8x62o8afXx7p8iuDukDKqz3rGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D97F43ACF;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 102C0C2BCFD;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783963615;
	bh=WzxC+eElxIID/vTACljQfff57E8zSB0pagmJWpqAdKY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IrqC8bJZyhiBZZHXB43YKzLB9RVOMlim/hvAlCr4JSSvDvHi0YOozXzLLKGIgJmhD
	 kbRMlUqN9AYCOnQtL1/xjKZqzIXdHoJEUqHZ7U5oD5RPV3FdVO8qZ9HSHLtCr6uPDT
	 ue2wCF6NclGRKM4NOYT6NELyUbUfgxpr4aj9+RmWFc6okav99HCjPO2QoGoS6pRiCB
	 o9f0ex6y0evYhapvHoDl3NmJrz7H/9o2ZZpaY8wiMv6laa5N1LTCwqludVOFXyrK5+
	 vYxMonSu67pFawa9A5KbWb5Ao8liQMK7uCFTSmdtintDKKhKLRcDfaf9RCyfSgljI2
	 0LyOr4RqmkvDg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A28C44507;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 14 Jul 2026 01:25:45 +0800
Subject: [PATCH RFC 07/13] mm/swap: consolidate swap inuse accounting
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-swap-pcp-priq-v1-7-de9b164ed419@tencent.com>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
In-Reply-To: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783963612; l=4815;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=d4HZUEwBV+hR00Jn7TMM7WH5lEZpnnAHEskQhntWz50=;
 b=Xgg1N8VIGPOVqFWmXlu8FGYB244KXlcsSsKDCRT4hPv9QwaQC5+4gvFSSHymiO2do27GrNivF
 B8+6XJcy+jBAbzYC9aYU4aQAJpIFSv5rz3CzSCwUJCnSpUd3z+iyGw2
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4CFE814000F
X-Stat-Signature: rweknuf3cm55ujah8uh8bemchgm55uce
X-HE-Tag: 1783963618-900662
X-HE-Meta: U2FsdGVkX1+LFrkRr0XoQBzsjPt/ouW+7RQmLo87XmeIKHT9G7cZA2ieTH2bankdPnLXiGjQWlMLudPAdPsisUDpb9H/JoQcX/vzloONWhjPi23c5qn0LwEQLpaa3xZL6Ikpw3F4JgUVlrrpaksUfcnRmz6dbRKYgxQqb35RV7ZObWaTnH6mQaJlEoiIPejhcWuSkZXBOZqGuR8sL6aU7KVe/QFviUNFOUkmQTBbtnyMUWOjc61Nr3bz4/9uDfMJMYRU9dSyt6aFkywOHhiGcBNsSo+aBiyT4CncoePAvIZCuKu7M/Xddyz45/28AP35fvMW2OrgRg/p3GJT/zKuNo2ynxEmX7C0ENK78X/rT3KjMLDAN5tMy9teWyyC47jlLE73Czqavo4dPImMZc3Xgl5XsrbGXkLh971sDSIMVcl9kzz9JHinJ2AOjZLfDlfK8pcap0x0/h+GnX62WYtX4ob3NiVTqTLp2eQ+C5HL+ILPMNxjZuRliyVaZECL+CzPJBcFjmH7HRR1HzvkUJgY7n2jprp8ZJYMl9//IO63dKHolV6we/8JRArAE6hPCs3Ox7DBZpIXxu+aXj/G89gdHmyJQZmITMrn0I1s+aiEDMl5bAL4dBCHTQNvGOCm7BjCtd4hPw4arHctWQi3tTu1IV98BlU+Up4h6wBHVy/7ybnOhfvBNzamLyeyx6R6RY+VDCboMseRQybsfSMZF0jYDEn5x7bh9jvCd5+77I08cSzdovhcv4SNw+yShebUG//wzIkWiKys9JABE057zFQ+/H0P1e5uJdbQez3yNKIXucDm04kbwvYH6stbCH6UIgGGl73uVlOxxou9x8i6czVh2aMehZ762RIsvgHVE5j1hSyafymd8PwdAi3GvwdEa38SbzpE7rrXv41lngavuUayD4Ocxx2KZiEATy4cRmW0Md+APLvuLY04qqy+dngFwXDHw0ZwAmLNPKwa4B8YOuH
 2LHD3URG
 TCPoiFNRrdd/gJPelMftXFTLByEKGrYviSn2o+CX8Ptbv+DMICyc4LL6DyJXA0XiR0VrnguFdbdke/pIzPcV9FJRx8wLjFIGZ+JSHa3t59c33AYFp/jaN3NpCZN3RL40fZF8HmiVVV7s23pSDefTmqv/O2q7XFbJvp7zl9ThnRWl6lq1+EKYnNEHUxsY/Fl28wLK0Tfhfj2b47uJjo4W3Nyip8THDQSZleYsNpnUCp8DZLQFnpNtjSQDBXtqe6k4kgxQHkd+C0n0FjN/qy+EC0M8wXvqWsSbviPdPXnq64+CyD3lhNMhQ1QTYidWPVaOx0TmIt+HKSuKR3lrUk0pxgQW2O9DNuWvTVoK9KrCmkzfh/oIVWA1bsUwCyjbD2D6q6Zpyqw9J8up7L3oj1fDcdCDVEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Inline the swap_usage_add/sub helpers into their only callers and
rename the callers to better reflect what they actually do: track
per-device inuse page counts.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 64 +++++++++++++++++++++++++----------------------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8b073569d1d9..df9855401a2e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -49,8 +49,8 @@
 #include "internal.h"
 #include "swap.h"
 
-static void swap_range_alloc(struct swap_info_struct *si,
-			     unsigned int nr_entries);
+static void swap_device_inuse_add(struct swap_info_struct *si,
+				  unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
@@ -984,7 +984,7 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 	if (cluster_is_empty(ci))
 		ci->order = order;
 	ci->count += nr_pages;
-	swap_range_alloc(si, nr_pages);
+	swap_device_inuse_add(si, nr_pages);
 
 	return true;
 }
@@ -1286,53 +1286,36 @@ static void add_to_avail_list(struct swap_info_struct *si)
 }
 
 /*
- * swap_usage_add / swap_usage_sub of each slot are serialized by ci->lock
- * within each cluster, so the total contribution to the global counter should
- * always be positive and cannot exceed the total number of usable slots.
+ * swap_device_inuse_add / swap_device_inuse_sub are called within cluster
+ * update critical sections and serialized by ci->lock within each cluster,
+ * so the total contribution to the global counter should always be positive
+ * and cannot exceed the total number of usable slots.
  */
-static bool swap_usage_add(struct swap_info_struct *si, unsigned int nr_entries)
+static void swap_device_inuse_add(struct swap_info_struct *si,
+				  unsigned int nr_entries)
 {
-	long val = atomic_long_add_return_relaxed(nr_entries, &si->inuse_pages);
+	long inuse_pages;
 
 	/*
 	 * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
 	 * remove it from the plist.
 	 */
-	if (unlikely(val == si->pages)) {
-		del_from_avail_list(si, false);
-		return true;
-	}
-
-	return false;
-}
-
-static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
-{
-	long val = atomic_long_sub_return_relaxed(nr_entries, &si->inuse_pages);
-
-	/*
-	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
-	 * add it to the plist.
-	 */
-	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
-		add_to_avail_list(si);
-}
-
-static void swap_range_alloc(struct swap_info_struct *si,
-			     unsigned int nr_entries)
-{
-	if (swap_usage_add(si, nr_entries)) {
+	inuse_pages = atomic_long_add_return_relaxed(nr_entries, &si->inuse_pages);
+	if (unlikely(inuse_pages == si->pages)) {
 		if (vm_swap_full())
 			schedule_work(&si->reclaim_work);
+		del_from_avail_list(si, false);
 	}
+
 	atomic_long_sub(nr_entries, &nr_swap_pages);
 }
 
-static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
-			    unsigned int nr_entries)
+static void swap_device_inuse_sub(struct swap_info_struct *si, unsigned long offset,
+				  unsigned int nr_entries)
 {
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
+	long inuse_pages;
 	unsigned int i;
 
 	for (i = 0; i < nr_entries; i++)
@@ -1356,7 +1339,14 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	 */
 	smp_wmb();
 	atomic_long_add(nr_entries, &nr_swap_pages);
-	swap_usage_sub(si, nr_entries);
+
+	/*
+	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
+	 * add it back to the plist.
+	 */
+	inuse_pages = atomic_long_sub_return_relaxed(nr_entries, &si->inuse_pages);
+	if (unlikely(inuse_pages & SWAP_USAGE_OFFLIST_BIT))
+		add_to_avail_list(si);
 }
 
 static bool get_swap_device_info(struct swap_info_struct *si)
@@ -1969,7 +1959,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	if (batch_id)
 		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
 
-	swap_range_free(si, ci_head + ci_start, nr_pages);
+	swap_device_inuse_sub(si, ci_head + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
 
 	if (!ci->count)
@@ -2821,7 +2811,7 @@ static int try_to_unuse(unsigned int type)
 success:
 	/*
 	 * Make sure that further cleanups after try_to_unuse() returns happen
-	 * after swap_range_free() reduces si->inuse_pages to 0.
+	 * after swap_device_inuse_sub() reduces si->inuse_pages to 0.
 	 */
 	smp_mb();
 	return 0;

-- 
2.55.0



