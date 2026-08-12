Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A8E2C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7691F6B0116; Wed, 12 Aug 2026 08:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3166B0118; Wed, 12 Aug 2026 08:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FC06B0119; Wed, 12 Aug 2026 08:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 461E56B0116
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB95D80351
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:46 +0000 (UTC)
X-FDA: 85092521052.23.614971D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2ADDC1C000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CSCdLo2l;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emxjHhjwy8XERbEMKSGImjrtQvsEUGjXFQEU42dLbqE=;
	b=JeboKRMCXuI7O29sQt4ugrlD+A4xfYzgs87sbFCMIVlyIO/V0GYyrhH0oDnudxKkLU+sl7
	u3/q5GVO4FeLPuovmPR197By3WBFNAWqNJmjpieH6Q672LfuXeAWtzpAzDWeodDGeRWw58
	O6QmAxr1WTlHwgzf7G2jU83qi5Xh96I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537125;
	b=uYmIGiKNXZwQ9qhb47IBzydYad1NajaGz6gvE1COIoKWB4OKci9qVlWo9Mkm3HlQ6ArsSb
	bySRkEqh5gYA1xemEdvAkmtVx8nySZy5AjXPPbvrzRhV2GI86l6kEuwi8Zgj17LIYi9mqW
	io8pfhdxJl1noTfLCBVDr7vLyZpBJoo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CSCdLo2l;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7113F4016C;
	Wed, 12 Aug 2026 12:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4DB1F00A3D;
	Wed, 12 Aug 2026 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537124;
	bh=emxjHhjwy8XERbEMKSGImjrtQvsEUGjXFQEU42dLbqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSCdLo2lMszB+gAPNugQg54MeL7QysW31P6OWjRQq9cOcOyMtBbRENzoISFusdZC7
	 yDbqUl23M4nN3rsQXMg1HlY1eOjDdTYed9qr3wScscQGuILuFPQCKxPxqXMP9qS97/
	 iTgfwTji37orfI88Ay+z0i7yO8mIvkzIomW5YymLrAoBoFrSI3aGuc2oz78TQNLOEl
	 ceKJWs5rwxF/f6hYcsc6oWXnt/tqZa0taIiPfxKUvQEdfasL5hBWCKBs0cqgiCQWAW
	 LdNa0w/m0X6lIDnkn7pxyWmwxbxon3NBjm6FMAybMzYbawnfwnL3Ij/B/mXIAx5aFb
	 5I1i6WbT/ICQw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v4 10/16] mm/mglru: batch move folios to the second-oldest gen's LRU
Date: Wed, 12 Aug 2026 20:16:52 +0800
Message-Id: <20260812121658.69965-11-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fh638n5o9sqnmsfrciq4b5tom4btajuu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2ADDC1C000E
X-HE-Tag: 1786537125-658201
X-HE-Meta: U2FsdGVkX1+sBCeySmeyqYgNhcgI9Xe1kC4I2jKVcMD17PK5ax6FRoazcOLGYlq09Kz9AUYw+cibn/6lKG03ZNtHakpOQeZkBZHIpnGXPBX0sZ4syps6kg8gelyZzm3MrDfJzus+kb7Fl3C5jqIXn5mYQAJnDmlOYvPwGlkd1wLw8nhsG+l/WrBs8Uo4oUpJIQk+KYfHSw5Q2kQANa2vCCueyQ3cHy4uLy6fE5Sq/57q+kCXJek4mOcA0pMn2rR0lFv7zl8kkG/bi1PSpxl9OF/LT1BPnQyU43ydns6QP90h22xoGNB+6RzfFjXV/DLpALxJMqTqto+vKWVDSEX3IPrQyZYuH3iuYc88Wg2xbBRdOy6TuJCgRPKd4EL8s2gheXjEtjNKJd77HAbL2f3sNwYzu+wUhvqaYXwKSuO/3Wv5htKHSt0tH1XQMYqdEYnpgDr+CZRLHKIlnzFzKLJLyDm2+nc9WeWp3+xwlVQAqWYI50OnT7kxFgkWJkU99lRdblsI3fJXAKYkRZvhKniOCqHfVS9GNu/ggpODrTPyBknPBbX+e+c1Z1wNctvukKeOIH8VtYKUiy4Y08eLJnLxkFJjUjGD9GzGGthv8qZnqyset9E1GJpjpKFiYJluYTPd93B2qCnNkC+PsBe3Dycp3rMKJK3Mdd+IGnTtelZ9ATxylEBXiSBlgCms5H3dAq2PkSVJsKnRehX9fKrn40KbiEk7Djjbws6hN6EyEnys6KwUaUOBCuhrrjKI2xWocS9zJOaffQ2dCwu6lw6hwqg0laQXSfjNSMIJsCQFo6/Qml6CJ7V93jWQ5Y6/ipU4s6D4l3Ft1ZOYwTj/DNyTgdT3g7zxGP8hqt+gQzkA2TR+arC5qiF5LBLuD7A72ct2gjT1/k+FkT/QAc56HqU+8daKzMHHORngRCsKr4vh8CV/SB9WJ2ltwA/kHfO8p0H80TPOVL02txePV8ecEZAUa8H
 +RbG60Mp
 iEsDS+Vy5i2l4Fmc2mI6Ve1Upz/0JwHnMkAGE4G5W1RdoWRkbYQA4cmSde/BMvA955S6KZHE1FxIWwDdGgU0tZxzJ42kKRFz5IRftAQ3qEgLyJi4NwdZldcbXoOuXPOtgbttbmNWQCZcr/kTQupp4YvVJ5riT4O+cnzHxydD+e/GJhWE0EuqrlS7Eg1kWV2aBNvkyHa1E3W1V6Xfb6hfOdsB49/el3nXWa4ZN9oWb2jShGo76ttY3bVXM006+Y2AyhleRwUrE74kvoJoaE03t5ZnvEMvB5ZBy/ranXp/8T8zTHZEWh40qEo1E7WkBsfXuqquU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Detect folios that need to move from the oldest generation to
the second-oldest generation, and batch-move them together.
This can significantly reduce the sys time of inc_min_seq(),
especially when the other type is significantly behind the
preferred type.

Assisted-by: gemini:gemini-3.6-flash
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 17357b16d1a7..b6c17ece3b3f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3922,6 +3922,19 @@ static void clear_mm_walk(void)
 		kfree(walk);
 }
 
+static inline void flush_lru_batch(struct list_head *head, struct list_head **batch_end,
+				   struct list_head *dst)
+{
+	LIST_HEAD(movable);
+
+	if (!*batch_end)
+		return;
+
+	list_cut_position(&movable, head, *batch_end);
+	list_splice_tail_init(&movable, dst);
+	*batch_end = NULL;
+}
+
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
@@ -3941,9 +3954,11 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		struct list_head *target_list = &lrugen->folios[target_gen][type][zone];
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
 		unsigned long protected[MAX_NR_TIERS] = {}, delta = 0;
 		struct list_head *pos = head->next;
+		struct list_head *batch_end = NULL;
 
 		while (pos != head) {
 			struct folio *folio = list_entry(pos, struct folio, lru);
@@ -3962,7 +3977,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			if (gen_increased) {
 				delta += nr_pages;
-				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+				batch_end = &folio->lru;
+
 				/* don't count the workingset being lazily promoted */
 				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 					int tier = lru_tier_from_refs(refs, workingset);
@@ -3970,11 +3986,14 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 					protected[tier] += nr_pages;
 				}
 			} else {
+				flush_lru_batch(head, &batch_end, target_list);
 				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 			}
 			if (!--remaining)
 				break;
 		}
+		flush_lru_batch(head, &batch_end, target_list);
+
 		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
 			   lrugen->nr_pages[old_gen][type][zone] - delta);
 		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
-- 
2.34.1


