Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E012C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6FB6B00D4; Mon, 27 Jul 2026 10:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88296B00D5; Mon, 27 Jul 2026 10:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977226B00D6; Mon, 27 Jul 2026 10:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64E406B00D4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:39:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E612C1C0F15
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:39:46 +0000 (UTC)
X-FDA: 85034815572.27.305A3B7
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1632B140008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:39:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FgB3dDJJQaLr57fv+bXod84eoo85mp8fDz7tL2LK4/4=;
	b=HOXW/ucJ1AHhmJ1wsWqVQnqh4XLgxDR6t0R5zOlYIZskb3LdYGCiIsNuDFeIPPI8UBLbIZ
	geIq2Jash5zGeoCbOoEYZc+aXeqpxyC47o/UIDGm8OrHlZN8XkhBfK9v7cTIMF0Xvu28ID
	kevhNRt6vnUZeAoYN2ORLT2wTu1Eaqc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163185;
	b=Rh5J2EwpuEuJ8fDyTfPB4Bv3nNzh6j6isjw+oASC3ORtJNUPMTWRLxk64aofduCqowvMUY
	1rmri47mS9AUoGf3RaF8b4GXSomEIt4xLNcW9tQ/duzYaENe0TFJ226J6PDAuBhGdYdvO1
	7AJURonpDXDPB9wAhCAk7rxGldyrA20=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 71DB83ECAD;
	Mon, 27 Jul 2026 14:39:37 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
Date: Mon, 27 Jul 2026 16:36:10 +0200
Message-ID: <20260727143618.1582318-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260727143618.1582318-1-alex@ghiti.fr>
References: <20260727143618.1582318-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTE7fibksNbJ3BOPnuN4Nsp88JE+K7RxOzk//d8PXn4eGwwzNRopmgacf9wdZP1FVJNsGkZaiN7AN5bOrR7qSakeWc8nuEap5EWa2ZnV5XTxWyo6l/L9KMOjbg3oYCIpjk/wrnCi73w1cvWd/B4bKa+w5zyL4ghzVsNHUZpsMvg+ktmJKOrWWhrP1Slqgoo4TZkH99qCcm5wkVzbpgftjBONSalOFmKbeprIf6As9Id4IofJoPezPZJQV6t2xOW9zx3J0cuO7UavDCX5itas0MEP556/OzTQUUYubf7KpDxIqRiSWdBkwfjTjuH2Xk9m6YG5QjInKDeKMzCAWss1DBZBCFDp2FuOE9r1TFEjqHhJrMDkbWuUDzCRt/lx5wS03tI9SJ7Uz09fc+noHP9O4ONu0YtadWNA8JNCesxyTtz+kRCZCji97pi/dYSfWR+h2Agjt8ayGsSfX2aRd8Yi/bb+khe6ANGK/R21tkBxbm4gVQIuG5UN+W9D+sBPwHwcKRAqescazJ504sWwqDS/x/TX8Ijiu/rcKt4hZA7dHrKikRV4qadZrRkcFi++WGLFD2ySAfPn8kejStxi6YrxNsncfxf5v8KKTbAw7YcN/zHs2FhFvuOloHxQ75mYIz3yPSzcAOA9r18Bk9mrXoDiZ+PmxareTZCmSxkk+VJg78QWJA
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1632B140008
X-Stat-Signature: yjj51r5wf4nrig1awoy736616w6k3y78
X-HE-Tag: 1785163184-768242
X-HE-Meta: U2FsdGVkX1/OgYa1JKNIjvHrITg0E25HEQOqpc6Y1TB6r0nnLxpbO24DKTMQCs2RiokDLpqZnndocrVOzeSjsRuAZZ51cJYNkhflIwSn7yXdXWk7hhgIGe+nEbyEyviwH/OqOtiJj9howV+XAGOvu3ctHCQKHBlT1Vcg4ctQFHCE9IgLdKdKZnTNkx5xgva7+cC7d1kyGDk+ZpebBf1LVBq7HO32zTFDYGFE2AX9RdKy+mx98v7XXokZkqzdjvgx0ZdhVktcjHiCBw2H6TSYIjDk9oF03dhp+QldCmE3xA9CS1OrC2EAgOt44Q1eOMxE+wyJPU6Re67PUwrK/TriKfnLUCC1Nqi19plYJ3N/IT6YPn7t4P92GJsZOwXJ6jzrk2UedeZ3ag3mOL6gkm+yJeh1oCvKdO/gEVkZ5C2jcL4UFcqv+MXjCzFHxgauBrgCC75A+LZE3wGQH/7EQQNUhifc5uKXhrLOwTFwR01YUTH7CJv+Sc+m9py+f7PvQbDQIVEMUkBLlfDVt8Upubu/pkjEAuKqUJoHdGJiVHLISix8SPPA+7IOKWO6ngdnQKn7FaFmtIlKQR8SMgAN0hRAdHUr1AqLkAfMWfgscAxzFZNQ8VQ46iIL7GW+1yOxDr0gvOPWXE6fBMsO/sjqwHrojraN05qjrlvW5uv6g/2JmqC9P6WnUfsyc3N/NGA9Fn3bx2tQbINkiFZGGC8xbMYI+V8hO7ikD6wvx5w8sb2z3AId1BosEngedR3zC1lV6BTH1QNK7oaZH5LJZb/sUyuYBucfohmGE9gzU0TLlqHrXceao7RpAEIGza2CiqxRKPsF2QIqBr2olRsQb98I2ngH1FLzWk6Ndexk7T6mIihp7INSdxHYotu4HNOwIN/KCMaO4qUljWHOZxdr/i6FECM/UInDWm1yaROGEh5vc6yxqRIKRoC6FJer0HzD2WNBrhAAKN/UrknDXVP9QrWO8kG
 gdTbDrDU
 yJLX3Oa/YQsos/Wjf+C80CQRSzx67IfLUYCeSZcNmJIi0qKkA/2Id0g0QkluZi//HxfoEZC7GMXa2/ofwoMGPGBu4zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap writeback decompresses an entry into a fresh swap cache folio and
writes it back. The folio is cold by construction, yet it is left on the
LRU for reclaim to find and free later, wasting a reclaim scan and keeping
cold memory resident longer than necessary.

Allocate the folio off the LRU and drop it as soon as writeback completes:
mark it PG_dropbehind so the swap dropbehind path frees it once writeback
ends. Synchronous-IO devices complete writeback in this context, so there
the folio is dropped inline instead.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/zswap.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 8163e6c5f76c..e37828e02938 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -992,6 +992,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
+	bool sync;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -999,6 +1000,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -EEXIST;
 
+	sync = data_race(si->flags & SWP_SYNCHRONOUS_IO);
+
 	mpol = get_task_policy(current);
 	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 					 NO_INTERLEAVE_INDEX);
@@ -1013,7 +1016,6 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
-	folio_add_lru(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
@@ -1046,12 +1048,17 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
 
-	/* move it to the tail of the inactive list after end_writeback */
-	folio_set_reclaim(folio);
+	if (!sync)
+		folio_set_dropbehind(folio);
 
 	/* start writeback */
 	__swap_writepage(folio, NULL);
 
+	if (sync) {
+		swap_dropbehind_free_one_folio(folio);
+		return 0;
+	}
+
 out:
 	if (ret) {
 		swap_cache_del_folio(folio);
-- 
2.53.0-Meta


