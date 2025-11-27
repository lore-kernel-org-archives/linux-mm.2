Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3EE2D116F3
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5D36B0022; Thu, 27 Nov 2025 05:03:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078976B0023; Thu, 27 Nov 2025 05:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09476B0024; Thu, 27 Nov 2025 05:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA04E6B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:03:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B73EBC133
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:03:11 +0000 (UTC)
X-FDA: 84155948982.30.1556092
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf05.hostedemail.com (Postfix) with ESMTP id 201F810000C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:03:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764237789; a=rsa-sha256;
	cv=none;
	b=sb14Xo/Gr/ifPXxu+ikwyLChf+5lvEhFsOcRXuPcKypGRrRhNPXbxvQs1OI48Pz7BzsBm6
	rUbMojKjj2xMnVB9QshoamrD8sT/jJAhGtWTJ8UQiCwKRtqqCcT2zY4bhzQsbvowtHWBjE
	C+KUPPLTCPh+9hx9fWCCZkCtVKgb7YQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764237789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KtDNCE5AQ4QF+cE+bb/Hjvi5EUZPFx0SZa9PEhTyJ0Q=;
	b=DchfO/t67Xgm0BpmhJO3V48terqbNnL8i9/GVztfbV2J3MkXwyQX+vr5TkRap5PcWGlOQI
	FhMAHChKUUsQAuI8SpBs//HsJ/smA46y+xTYHouuaLQMcvxBzLG2GD98Gwh3XN53gHd5aH
	RSmZpuOmb+lAojJ1J/TM/YbCrXe3CUc=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 27 Nov 2025 19:03:05 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	youngjun.park@lge.com
Subject: [PATCH v2 1/2] mm/swapfile: fix list iteration when next node is removed during discard
Date: Thu, 27 Nov 2025 19:03:02 +0900
Message-Id: <20251127100303.783198-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251127100303.783198-1-youngjun.park@lge.com>
References: <20251127100303.783198-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 201F810000C
X-Stat-Signature: me6zwinobejg51dby38e3ebi3s8c4hgc
X-Rspam-User: 
X-HE-Tag: 1764237787-900673
X-HE-Meta: U2FsdGVkX1+aHTmmphNW3otJMbvaqruXNZ9TF8xwK0moOBDBXK/dwuX9m8DpO8rgp3WpJCCEd6fkZ/bw+58wdHJVJC+Eg/VOPyD/8bz8rkpiP0kbN4+rIxDBd1rCuLDEDuBGQDgRjHGWKn58Xb6fJZK0gTAt8WpRhiJLSC0IChBzdFRq8IMEckB2rdXRcXzyLV5GFkCCppMvHoRx99roHadH4Wn708EuIESr0KaIrlex2g+B3dcCSLVTefcJS6GeIvIWi1+S/M5CuFNSD5BqcJv335E8ZnIDtPPBY2y5CwepOdVWUMBeB2adP2rvYJedw1YyPdatgHf8oAk/QL6rF3KSYDEsONcInIiksDkG53r7eTIfb2FTyhRjG5WJPKLv21IVB3npaI2GVRvrJ9hsUzeG3PA6On2TA0EMVGaWSBQW/l4+bPrFnadYuRHrqJT0vdTgr02ymsBkrGNLQpu5YKqwp2mWDTJU87qmuwItXwSS7q1XqRtjwnk9mCI5quJToDoSxaKRAYaDHnXZ1SNCmmsFzBE9nGkfXgTtxp4k+Yt3DOx78wiG/x719s6lZVFKzHt4Gqt4YLHzH3Sqn3NwPywx11Bkb0GOZhJqNeorwgGqiciz2xZcX2QXJ8dgE2Pittej+XGzQLMgrLjb3Pm4SpnfY6+ZoyOmyj00fLCQ6XzOH241yJ3WA3WiU7MSRizMFL/S4E2DnJx1hFgVuN4SuqoLs+2OSybfG61wdd4shprvQrqxUmJHnmreMkJFIjicN/LeEwOx31+b+eFN7E4QJsCweY5tPrMmluAenYNQKTTgZO67WFhAEbZzdM3CFWwV8yscT+cc9uzmoxkOwlg3o/X3SBeAKvBF4OaArPfzXbKXQBzvyFDA3xyEigpbMjFeCQjvpMLUnR3kQHtpCfacsj1Pme+tHqylvdyvaZ4AmT4Ch+VhEryZ9wZxsEXBrF4frW5XUv12caePEzbOxMW
 mQ8hkTx1
 ImlW3GLcK+SzkZaeNUdZV9YrOi59da4p1obfZW306FbpCt4cI9HNO3BM5aFvlHgmKuZE+Wzqap0AufRUNH7zdpPByWEgDf5Se3mC7cMsdA+QzAjqQRl9pf8c7Q1qUJQxIsdoNSQnC+lFt4rlHbDk40K8c2QKxQJQA1IEi4UfBPuiMtmBcCZdqaH1fFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the next node is removed from the plist (e.g. by swapoff),
plist_del() makes the node point to itself, causing the iteration to
loop on the same entry indefinitely.

Add a plist_node_empty() check to detect this case and restart
iteration, allowing swap_sync_discard() to continue processing
remaining swap devices that still have pending discard entries.

Additionally, switch from swap_avail_lock/swap_avail_head to
swap_lock/swap_active_head so that iteration is only affected by
swapoff operations rather than frequent availability changes,
reducing exceptional condition checks and lock contention.

Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
Suggested-by: Kairui Song <kasong@tencent.com>
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d12332423a06..8116f36e440b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1387,9 +1387,10 @@ static bool swap_sync_discard(void)
 	bool ret = false;
 	struct swap_info_struct *si, *next;
 
-	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
-		spin_unlock(&swap_avail_lock);
+	spin_lock(&swap_lock);
+start_over:
+	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
+		spin_unlock(&swap_lock);
 		if (get_swap_device_info(si)) {
 			if (si->flags & SWP_PAGE_DISCARD)
 				ret = swap_do_scheduled_discard(si);
@@ -1397,9 +1398,12 @@ static bool swap_sync_discard(void)
 		}
 		if (ret)
 			return true;
-		spin_lock(&swap_avail_lock);
+
+		spin_lock(&swap_lock);
+		if (plist_node_empty(&next->list))
+			goto start_over;
 	}
-	spin_unlock(&swap_avail_lock);
+	spin_unlock(&swap_lock);
 
 	return false;
 }
-- 
2.34.1


