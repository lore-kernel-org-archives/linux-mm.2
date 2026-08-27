Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF08DC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5FD6B00A2; Thu, 27 Aug 2026 19:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BCEC6B00A3; Thu, 27 Aug 2026 19:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB396B00A4; Thu, 27 Aug 2026 19:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE816B00A2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:47:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B318D1A0219
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:39 +0000 (UTC)
X-FDA: 85148689038.29.8BAA408
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 17F3540002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=msIgs9KZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787874458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvhE1//hn5gBVVZ/BGXLx4fVEuO6Hu7ZhZmDmlWmdWg=;
	b=EVtw93E7tkxe0AUoIfJfngkYzTSwP1cksp9D33jxd2hKwENtNHTFBXA+hrT9Akz8t/lXW5
	DeBackKU6cZFruHPUiMlGb1Ndl7601zwIlLLLgedjjrIXnqp0UB5L/d3ikC8QyS1CdWbs6
	zEPWd15AR71TGY30btZnvWLo7LP/XUU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=msIgs9KZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787874458;
	b=aUQGoToNhKt/Otd+b+Mxu4g5c+x7/72pHacQ0gT14lcKb6Lrrs3KB54vaQe6HOmiIkjxv8
	frvx4QF9tiHFVqOANimjDnC7l7lvjXwJNKo3/5RhGPzO/Ene80GPGKXHc1iHSJjku4Gpug
	RBFlszm5kUBw7IX9fUpB5NStEZvI/wQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69F3B40D93;
	Thu, 27 Aug 2026 23:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0D71F000E9;
	Thu, 27 Aug 2026 23:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787874457;
	bh=yvhE1//hn5gBVVZ/BGXLx4fVEuO6Hu7ZhZmDmlWmdWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msIgs9KZMVZ+2npfWCXzmLUEkiRpmyAtOsS0AFJ0OwwqPCU2r+7MrirFQ2cERxpsH
	 Pqao3cc4b1bs+wT4OWt7kD/joBx5pcSl7Dt3LzWEpeL9CU7zdeU6qarkcdRyOsL2m2
	 tT9wdg5lsmQ/feBqyFEJa0P0tvJ9oP5LOqjV+GTuwr+lIFo7IN6wDsimfwAofQz4qw
	 rXciMXo/qmNK6NMDlvkaIBB2siFBlctjCrRSE/vYS3ovx6ho+P4c8Mbi8ew/KIUsns
	 swIwVNoJuh6G+XqypKeRwSd8Sk2VnJoP5bPVK6VEXMYiK77ceLCsQ6WX+EZzqOOhps
	 /DNrpEtCgXLXQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	lianux.mm@gmail.com
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
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
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 6/7] mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
Date: Fri, 28 Aug 2026 07:47:03 +0800
Message-Id: <20260827234704.63163-7-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260827234704.63163-1-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 17F3540002
X-Stat-Signature: 6cf98jibu5eocyd6j7u5gc9q4t3druee
X-Rspam-User: 
X-HE-Tag: 1787874457-849158
X-HE-Meta: U2FsdGVkX1/EQ9aMrKIuvjx9M0grHs1egWtubdR1e5V5NQm1OhMKa97JPBo4i/bu3S+SNuq1NAvn6tExJJT79+0I7CcXzfzp1eeJ5MRwpXHl2yHZupHG/y65DVY5enVyvU8+A1mykf9b3QG2/QThuXbBel1Xsy3bSr8u76h3m6yq8gJHP6vPntiv/1+CAvZrpqm8td6v0vLMLJZ3BLhohNZuHaqRW5Cq3nG74zpLzHydzZNCctoCHwKB44zAI+ZNK3L5vG5FDbmCgPFjo5EIkvKXV8dJlNdULWnudrlmBKEONbhHS75ZTGfSB3nKwZgq74Ek+n5fVF5NDR37CTQBf9VJ9fUOUPvdev3TtNny/IhdHMr1zMEeEWe67tLlW/9cum6OKyLfOoJcE2H9yH+H/mb0MrANlk9TFcdEjhCyvzYpEwBshkHkOsu52Wv16V+1QJLAID3qHS/WLnTGrWDJR23szxU0d83k144XuIbPQ2zEyh/HWgmLBV5n5MtodQ0w7QM1ei/W0iAE4wMBXVNPYwiyZLYbgwtIIYOvqdMi85uIvEXJ5BqfguwSyJrTI2/AD+zWs/cUx8ENYF2wq0TPSrcVFc+iQJzY3fQunU5BffiJMt7YQV2LIgohtKxcl64c+hzunJ2xfee3UcM4zq2esa6Tm3a0e1FXB89eJD4TQvqFaBvIr365Ov4SQnkw2Z3/10X65GEE4zmhZj9QqQaDQC4YxcQLmymM3rWa4P16ynkOhtHXN0G1yCJ5DX5QA9w5OkZDCQTIBm9vftfYeLK3lSEu60tgU8t8YNUjh/4WJbXc43mEp+5eHzjtZP68IIG3WUXxXQYZHP0UuRriOSBXMHbK9Fr2BQI0c0Vc6wqcqq1GwRTBQUinGKL8jmH4jFhNfgBheTyuaP5MZyP2K5PGzS47AI9Iwj0jz+Z1gnhbSMANV4ygOvWuLgMzgl7YpidmB13IQVrYdzsPDOxQYyD
 cFahVK96
 csneO1nzZ7io1ObT7Lae7Wiq05G0i3Sk+9AYyGRGG9Zg9E/HEyXAN3f2wSbmPMpmQlewXdfcJY1DlFEjeLGDJc5HR5kk6ZRG6uHFwq8P7XpUBiU3cNNVEpR2HUFQlCQbqv/ynZmSj+uNx+44eDKyEpN1dZXbuJ7QiIum49AOX2gzVmoN2mKj1Ybk2V/XZoZGk7JjH1OVMWisz1lpm9pghewjcPIe3O2qcZG4m13YO6YzT1KnrR9dJmPjVP7QIOVbzNo+iDM6qUlVp51svJGbgHvzbmidlpXPX+Hsr0Y1fHg/W7NREOleJdHBWmPes8NM8zGCzk6EQnU/y5q4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For reclamation, it makes sense to reclaim folios from tail to
head, as folios near the head are relatively hot. However, when
moving folios from the oldest generation to the second-oldest
generation, using the tail-to-head order would effectively cause
a cold/hot inversion.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmscan.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 81f95a968447..17524e96fe64 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -192,11 +192,27 @@ static inline void prefetchw_prev_lru_folio(struct folio *folio,
 		prefetchw(&prev->flags);
 	}
 }
+
+static inline void prefetchw_next_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+	if (folio->lru.next != base) {
+		struct folio *next;
+
+		next = list_entry(folio->lru.next, struct folio, lru);
+		prefetchw(&next->flags);
+	}
+}
 #else
 static inline void prefetchw_prev_lru_folio(struct folio *folio,
 		struct list_head *base)
 {
 }
+
+static inline void prefetchw_next_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+}
 #endif
 
 /*
@@ -3938,10 +3954,11 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
+		struct list_head *pos = head->next;
 		long delta = 0;
 
-		while (!list_empty(head)) {
-			struct folio *folio = lru_to_folio(head);
+		while (pos != head) {
+			struct folio *folio = list_entry(pos, struct folio, lru);
 			long nr_pages = folio_nr_pages(folio);
 			int refs = folio_lru_refs(folio);
 			bool workingset = folio_test_workingset(folio);
@@ -3952,6 +3969,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
+			prefetchw_next_lru_folio(folio, head);
+			pos = pos->next;
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			if (gen_increased) {
 				delta += nr_pages;
-- 
2.34.1


