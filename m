Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF32F327A6
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 05:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5036B0095; Tue, 21 Apr 2026 01:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D657E6B0096; Tue, 21 Apr 2026 01:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7676B0098; Tue, 21 Apr 2026 01:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7C9D6B0095
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 01:53:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 680F95C93E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:53:37 +0000 (UTC)
X-FDA: 84681496074.05.F244A89
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf25.hostedemail.com (Postfix) with ESMTP id 446B7A000D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:53:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf25.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776750815; a=rsa-sha256;
	cv=none;
	b=qzU5rd4MYBCFkU+UCNlQM457oGkcc1kPty6cecUaw/rWuq/QA0mKkubKeV3NBvjYCRfjOJ
	r+vkmvwRx29tpSWv4QOu6TO1xtEQDM1NFisXIllbBY2St57p/WKuNKYKfaT0qnnQ6hocRe
	1pj6GQAhdcvERA3lzBEBYWKLcjG/IB8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf25.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776750815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vaTmLH0EKjC4RLRZ70IxIfpGJ/At2d+qMV302aIvJFI=;
	b=q/ucfiFrDHYYaCSn6RloTz0Xi8mkT93crvOCgkL+ZoaHCCn4Jl93tFV0B0adJmqtDyg9FQ
	WxQeawm+kF/N8N6OJ3+etxt6J6NkpWFgLy6lVarFx1eJDAMmt/mwZIjjiJ+UHgHKgI9G1n
	1X7db43A4C0n5XvFbjkOQgc5nzlP1+I=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 21 Apr 2026 14:53:33 +0900
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
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v6 4/4] mm: swap: filter swap allocation by memcg tier mask
Date: Tue, 21 Apr 2026 14:53:23 +0900
Message-Id: <20260421055323.940344-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260421055323.940344-1-youngjun.park@lge.com>
References: <20260421055323.940344-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 446B7A000D
X-Rspamd-Server: rspam12
X-Stat-Signature: rnfi4qufnr4rnzfg6so76x1w8tkpjrtc
X-Rspam-User: 
X-HE-Tag: 1776750814-29336
X-HE-Meta: U2FsdGVkX193QdpSC0bPDA26Mf07r6jy+SlQf8zv1qOwFNfgmKzHnkA+GHG41q8FeiOMJpMK8rjuNDqlXLjpvy7KJ1uhiXlYi7p2RPafZ2NcrxkFWDHXpkqKVp8VgBGbpnlYiMxlkRyZL7t+azFRY6gwnlCQMoImPDuVBvncGPrJTudn/qfxBnjCG3livvc5Lt3V++KIYEY4OJOqRf2XdyS5UjfbbhXO9WQyOiEJ0mia238teRbWaRWG6XRK57JBgvsNUscon48S2zsvZsRG4Hxbg5pNqXK7jyANAi64oQUgrhUzmh0B3xafMOwfrJPb5R2vZl1hfocBgNICKGVXLwpj8wiuZr0rLHHbSksJHcgMFi2QUbQ9O32IBYd9b/nVGuI04hot4Ex156GuG1Lev1eyQCuPh17EdJ92l96orIFrjHQHFwaRNOWtBw1OfTX+0+qVL990lTOARxMsWlsqIuA6jdClmaEwd6RdI19SwdniiqE1bhPYpMSChJqCezsd7hFQ7Jnc8H4wFXV1ZvOMJpdrdda1IQu43pEeBjjisB3e3q1vxCJh8FgvADFc1BArvVJABoCOPxuWvsUTNnTVoPiVowyCEoF4+isuAgpYKVdV6HvF/lpOJO65dwG4Ayj/kAJSVTib/ic+liAQXclX9CT22vZv6qhW+4kYCXees9WIZxQmKCV4k1+7VGcBSNvbNdMSOFIAW6s0gwadrLo//1sFwW6hz+fWmmx6oArYxt8nmHgyzQqtdQyd/5JoNIpcINtV7dWmqO4tcec7jaA14EDz0+i87EvIwrZmXNjDGpoZJMVZI90+3K9GVjfXv2DZniZvfNlWaNyLct0NisbuD9FV0WgRwTTeuriowk36dLw8ZlvhRmd9fnp8TfMHQJyD1+k73Xj0Ue+yGbTTxYyuhhdV54iOzKDhy0KJSYhb9y55ADOWhDK2fBXm9fKtoP38ziVYZZY+OS7jXGY/Gzl
 24lR7TSL
 xclDJ/5fQmhc4RwDjYTmk1+IG0d0FrXeUHckOcADo3mtyQbTXQLfe5SKHhxpS+CA9BGzA5CJut77RcRl9F6PpTv4naeXAZbkYL4/IDsZk1MrV1bb/ely3+2UGmlJ0Id5hXnXeaQr88AX66SMDYfwA+qlckj3L8r+9V28G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apply memcg tier effective mask during swap slot allocation to
enforce per-cgroup swap tier restrictions.

In the fast path, check the percpu cached swap_info's tier_mask
against the folio's effective mask. If it does not match, fall
through to the slow path. In the slow path, skip swap devices
whose tier_mask is not covered by the folio's effective mask.

This works correctly when there is only one non-rotational
device in the system and no devices share the same priority.
However, there are known limitations:

 - When non-rotational devices are distributed across multiple
   tiers, and different memcgs are configured to use those
   distinct tiers, they may constantly overwrite the shared
   percpu swap cache. This cache thrashing leads to frequent
   fast path misses.

 - Combined with the above issue, if same-priority devices exist
   among them, a percpu cache miss (overwritten by another memcg)
   forces the allocator to round-robin to the next device
   prematurely, even if the current cluster is not fully
   exhausted.

These edge cases do not affect the primary use case of
directing swap traffic per cgroup. Further optimization is
planned for future work.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d5abc831cde7..8734e5d26b08 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1352,15 +1352,22 @@ static bool swap_alloc_fast(struct folio *folio)
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	unsigned int offset;
+	int mask = folio_tier_effective_mask(folio);
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
 	 * so checking it's liveness by get_swap_device_info is enough.
 	 */
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
+	if (!si || !swap_tiers_mask_test(si->tier_mask, mask) ||
+		!get_swap_device_info(si))
+		return false;
+
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
+	if (!offset) {
+		put_swap_device(si);
 		return false;
+	}
 
 	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
@@ -1379,10 +1386,14 @@ static bool swap_alloc_fast(struct folio *folio)
 static void swap_alloc_slow(struct folio *folio)
 {
 	struct swap_info_struct *si, *next;
+	int mask = folio_tier_effective_mask(folio);
 
 	spin_lock(&swap_avail_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
+		if (!swap_tiers_mask_test(si->tier_mask, mask))
+			continue;
+
 		/* Rotate the device and switch to a new cluster */
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
-- 
2.34.1


