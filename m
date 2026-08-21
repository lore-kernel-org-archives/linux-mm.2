Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 932C7C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972976B00AA; Fri, 21 Aug 2026 06:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948766B00AB; Fri, 21 Aug 2026 06:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887686B00AC; Fri, 21 Aug 2026 06:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6759F6B00AA
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:26:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E95D31A03F2
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:44 +0000 (UTC)
X-FDA: 85124897928.30.70EF03B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 441BF1C0004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BhsHa0kk;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787308003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ak2P0tLlmHEpiFHwLAXYiUkDNHqN3CdnzgG9lD0dGyU=;
	b=0NpNj1heMW0HJT914uoNyEGH41yoWLYxH6q6FQR9J34XiCrT/nNo2gg7hF2VRwUOjFGb3b
	0tIdA3z1DVwv2e/+ZpJlyH1jBlnx3mU7EawN98papYzGVI4hUVPHoUCPy8+0kxeO5J2QsN
	PaEC0UO2M5SE3bOFlLcCDyl/CKJmqSU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787308003;
	b=bRczAthOmN1+jveh8VZrgfw5j7S6j7sP3LbCni9raenkt3ozj8Z5zzUTcXmJaTDFRc309x
	nWicVIBZ3PWvuiXs6RR1lvABuhUyd0H3niA0lWOLHp4MCGGtqHTkVuidjnQGWJz8toEBWF
	6JWkLzycngbDgWzhq1f2Q5gQMkjObbA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BhsHa0kk;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F1A043C48;
	Fri, 21 Aug 2026 10:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB87D1F00A3F;
	Fri, 21 Aug 2026 10:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787308002;
	bh=Ak2P0tLlmHEpiFHwLAXYiUkDNHqN3CdnzgG9lD0dGyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BhsHa0kkx6JhUcbZ5bXcyCYJwYlDmAZBdMVPOphK+IvpqwJKqNth/1zrxSvSXY7WS
	 sXWiSoqqLIFc6B2dNm0DDSBMqsafiYoTq679FQJ0N8LzF9RzV+OAunClgn/F5+ryvi
	 uqQy3iq6dJSedc7qBtrLVBxvYMcRVWjUrsIDWIvdXyw9wsygmMRMnPryHjR8rgc4U6
	 HNfnskuaKTqX1a1zhNJnSAubv5xlWJQ4EN4QZt/WbPhI1GIiZca6NbEL0u0lNAq3nx
	 3zpt1RGo6AnzavaQWZJe62Wv0/MOx35Pqz1VkxfgpZlynxhgoBxjO+WqHrRPPPott4
	 paYhCxu1upNuA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
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
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH 6/6] mm/mglru: batch move folios to the second-oldest gen's LRU
Date: Fri, 21 Aug 2026 18:25:38 +0800
Message-Id: <20260821102538.22642-7-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260821102538.22642-1-baohua@kernel.org>
References: <20260821102538.22642-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: g6ckbtq66cf15jks1c7noxbpm6n5y145
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 441BF1C0004
X-HE-Tag: 1787308003-392410
X-HE-Meta: U2FsdGVkX19k6G9ZipDbzgt0ln/JL7q7n70O84tszn1eYwpoWfvg7P1BjlOqaQWPm7UKy/0FbkJ5TfBHZohYs41YteqZDBIM4t6Ny351vVz4NEH9na6vz3SZA+Mxtf73g3WdrfaBbTwV9O6o82GAnE9Ct7daljSOxE1aR/fMCTyeBAXMXSDNdLqMc5+JOIeSOtzRwUbYqJ2fzQzmLICdOo1lwJsE+sIUrMOPuD967I+0GkNHhro5K0fRQtY19wGpUsXKLfi8P7py8tGkfJG4lzEVO6gH199k02P7IVTsOCG82AheNAmFn6r/EiIof8aO0IFZ/4R3/Wr0daLlJMOM4UTsb7APdGr/ebX+ikAdKFjCzAzQq6jn7sWpVthpwCGwtUbdvzYoFHPjzLMPlsg/9OUg0W1dCFUbAaLwuZ9KCO9zwKddRJ3acG+3epFKHBGkVWgUhiOzpsqAG2X5Hm+3wT0O06o6d3jaRSZP6k7I9O3y4uxefG5RcasEUJphPffNgEi+FgPtYX/rc8N7/F7kb6WJ92Q495ubsGRtiwN5/iWse/eHPWeDMiY1+vh27Hsg308VeVO9UWGwtzpQC9PvpRAn1s1xOZo7XjKQb7E6qJI0XnT8/woqZyaMulUOyXf7yI2htiDUizvFxgL02tzItGLYtml9doc0hsq1L2oRJTGd68IABi0N5bfU4cVgFYmy6kTXS9Hr0pS3S9Tymk2MfqE8F96OfVnfN3fyAhWcSseLZGAuoIi6qWO3JpJOBQnjstrg3mKkso1k4mjOvMTmYVG1odw0FIVqXEaqVHXs5YTOX3xA9hOAsFEJbIcB6RrkdtCe1/kh7slIlq/IQP//Bf2E6sGbFFY8+HXViUyIO20obzMTrFZOqNxsKBXugXDKA82nItfddyqOv+kWEJNMR0AxqbU6B9iM2iykk8cr3b/8I+MpgF6NJC/trqFUt0rcKL249+qXh0+T8VwrTA7
 h1nPegjw
 aYhlbglngA9pLgo5t3FNGD8G/7IkUV6X9MMc9xrpFH3wqcujhGeJyN1WQHHWun3ty1hJgw6gsRxSMTf8DBFJbBsmqcmnl4efYV+nBaXt/QW2/H/vRPXPBwU9i990wAJDYI1tXtW8NiEsFuMXqWPHbZHDXMoX0VPsZEYiQxAcRFTlnncEYt4/fw79oy6jgdMbXrmJY1t7zNMIWLJLuWq03OvxSAfGVBM02FiE5sh8DLEb8KSQS6SeeeA6sjyo1QSdsyF3/RV8F5fFd+L8KaYPxTB44oCkhV/sPddx3s173XDKJUm4kQxio0r+Azg==
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
index 2fd82b2ca4d1..996b48344ed0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3923,6 +3923,19 @@ static void clear_mm_walk(void)
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
@@ -3942,9 +3955,11 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		struct list_head *target_list = &lrugen->folios[target_gen][type][zone];
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
 		unsigned long protected[MAX_NR_TIERS] = {}, delta = 0;
 		struct list_head *pos = head->next;
+		struct list_head *batch_end = NULL;
 
 		while (pos != head) {
 			struct folio *folio = list_entry(pos, struct folio, lru);
@@ -3963,7 +3978,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			if (gen_increased) {
 				delta += nr_pages;
-				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+				batch_end = &folio->lru;
+
 				/* don't count the workingset being lazily promoted */
 				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 					int tier = lru_tier_from_refs(refs, workingset);
@@ -3971,11 +3987,14 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
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


