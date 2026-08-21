Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61318C5DF92
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B58E6B00A7; Fri, 21 Aug 2026 06:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F6E6B00AA; Fri, 21 Aug 2026 06:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CC86B00AB; Fri, 21 Aug 2026 06:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3366B00A7
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:26:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 913B21A03FF
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:40 +0000 (UTC)
X-FDA: 85124897760.25.998D1B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0F7361C0009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ielwHHfe;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787307999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUPbWhkO9uqnpeFMVIsJBlpt8zN0k3f8YPV9jGEypkU=;
	b=Y75DGCcPKAR9spL9YT2MwyTtqsK6z6uEf2AOe5OVCkbrggCuB9NtPEMA9DztYjbZ2h+yIT
	dZ38ho7j1mTkNerbV20ZuWQrdqttk+6UX/RLRH6uVafn6+kelKTlxZqm79OSMrXBwhYP38
	Wg4wbNX6h454rPvQzTqU7FsjTcdj+gM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ielwHHfe;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787307999;
	b=fk0H9TT0E/yJdJDGBZmoGpZQm5ynpJPHpOZgWdmOIAw/6jvbpFd2ZiS374oZ9OqlAoYE2a
	ZlG+sPRQGKKO5viSV9yptehvGEbwyTup2bIf5Zx8h4Isa7p8ilZ6Y046jsFqF7yL9NZ6ac
	KOQHZxuAUpvfR2DplHOA8+EoE4cwbEA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0D4F6136E;
	Fri, 21 Aug 2026 10:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A2B1F00A3A;
	Fri, 21 Aug 2026 10:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787307998;
	bh=DUPbWhkO9uqnpeFMVIsJBlpt8zN0k3f8YPV9jGEypkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ielwHHfesCgnNzots4rpLldqZiC88Hm8FP2b2C/4oMMSgPDfDTgfH2gjNE0Ii18zO
	 lLNNSfD0C5FObB2dU+gKoa+DrgFLYnRJOA7kCygQeBw0rr9nBnQOkQqrQJoJ/N8Gl+
	 hhFEkgRcxVUSfLbyr6uaiXv3+PGa/vVZly6xlnW5G1OHLybXzeuTPMmFVxxHCZTYEO
	 GjsYecacC08cdmzbdAHnkQXRIwmVziWgZQPAS1a+Ddw/SZsP5V9rZ661O76OcEc1gb
	 XCfUP4/Y01cqNsITdHx6okr4MIiBDwQvxRxeeLg+59W9QqAD4q1PAFs8txYCv0AkRc
	 29SoD1XBg71HQ==
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
Subject: [PATCH 5/6] mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
Date: Fri, 21 Aug 2026 18:25:37 +0800
Message-Id: <20260821102538.22642-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260821102538.22642-1-baohua@kernel.org>
References: <20260821102538.22642-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0F7361C0009
X-Stat-Signature: gnk5zundymqdbytaj9jbnsk4betxwnud
X-Rspam-User: 
X-HE-Tag: 1787307998-747620
X-HE-Meta: U2FsdGVkX18mOGWi6R1IswfRsjzN/u2JUyklWSIivw334s/hVPhE/AOn0lBTxjJ7kmQdV+g2xXHE1wI3F1vvDQK6I8MPtFccIRWdbum6uAiX6PU7XjRaaoObtJh7pX27w7qIiKm7zNK1JchT7fNPb0e0cwFPVq6/3A45TPNkTbfroZdo8QQ5i1rjboWOtD/xn+Z2iBqx9yty2zQvetjK60As5UAAOsV2ClOnC71osuk/ckvyvb2Wa8/oFVbQm3QYQfuEI3Yh0fHI+HSMTuMWidXAntnj5W6gdPeHfyHe3WD4BDvtST5UkbteG6NvQOHfTjh5ZVSR3xvXFrUnLiCAV+4kgzgy2AyxG+TKDSKkEmm/uqSkggQ1i/u9IikNzwc5RkOpeAaLSjUwmX5kCsHS6/nTHIWHLuPi7OVV+OSXA/UyTd0RmPVUwcjdIG1SkvVHuYwGM5lx9lrrIqswHbDv8nczKOglyMTjzCyoA5lerGhB1ob7evCe0cukvvEd3HQ9Y0+aD40aMCBG/8yVDk5QnxSMtU+GY3OcnigIy7acLKV99Fx2Q6EvnOtA9RhQDUCJkQx0NGAil0qCWuQFiTFfHaEuA+DHJcWWISDbPMd8kZrADsE2KI5E6ghjmj3FIn/Msquh5+wpToo/0tWQMay4O+/UwuC28AlC7YHLOzKKPUy93xRPikf1mR6YfyYZb+jHJIsGPTBHMD9LrHpUhcx+mHBlE9cUS58sMTmQOQnFVtkOPuYuPTWytb0z5NKNI/vk/XKBmSyF8AS58MV8Q2mIUPXzTux/U2d1amIbWSch3yvPEnPaLzunIC9/PsFIZJfPsVC85TeFVPz0LE6vOR+feLkRD8ULwVvO48qkHi5uT9Kkhiyv2k96/T81B6yt8niRkPLaMXIghLBZapUebsBEMwgTdW8gugbZOYKtqkgaYRrHRiAr4YDvQ7bdk8XI948kQpiOG/IM+8988VTFvqs
 5CYiMDAb
 MfGhOUWmJxnnDCDB6ovuMxN0rwBTlIoCX36J5oGghKk7FsE1hnqib9R+tvXxx5mcQIPVazxc3jA29H75FPYvgWr7c0l/txRyqShsJgbzfgCVZvzaKIpfPgAVVyGOpYUJ+hI53chtIXmFdr77YcOMaAHEP8T1R/OGI7Hq4PIgbQO/R3RwCdo2zKed+YjMuGqxWQxR/yc/cUJl+gz9jeQpgUUL7Oj3P1pU7ODHzAD6Ge0LcJ2d+AXS9NbsJ9nDUCW8sEQG4nTfqhmqtms/eUIvYK+N3eexv4qna8aZcKWC5Dk4+gGjyzKwYLRj6Tw==
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
---
 mm/vmscan.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7bd01875fade..2fd82b2ca4d1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -191,8 +191,20 @@ struct scan_control {
 			prefetchw(&prev->_field);			\
 		}							\
 	} while (0)
+#define prefetchw_next_lru_folio(_folio, _base, _field)			\
+	do {								\
+		if ((_folio)->lru.next != _base) {			\
+			struct folio *next;				\
+									\
+			next = list_entry((_folio)->lru.next,		\
+					struct folio, lru);		\
+			prefetchw(&next->_field);			\
+		}							\
+	} while (0)
+
 #else
 #define prefetchw_prev_lru_folio(_folio, _base, _field) do { } while (0)
+#define prefetchw_next_lru_folio(_folio, _base, _field) do { } while (0)
 #endif
 
 /*
@@ -3932,9 +3944,10 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
 		unsigned long protected[MAX_NR_TIERS] = {}, delta = 0;
+		struct list_head *pos = head->next;
 
-		while (!list_empty(head)) {
-			struct folio *folio = lru_to_folio(head);
+		while (pos != head) {
+			struct folio *folio = list_entry(pos, struct folio, lru);
 			long nr_pages = folio_nr_pages(folio);
 			int refs = folio_lru_refs(folio);
 			bool workingset = folio_test_workingset(folio);
@@ -3945,6 +3958,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
+			prefetchw_next_lru_folio(folio, head, flags);
+			pos = pos->next;
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			if (gen_increased) {
 				delta += nr_pages;
-- 
2.34.1


