Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B0AAC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3026B010A; Wed, 12 Aug 2026 08:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA106B0116; Wed, 12 Aug 2026 08:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0766B0117; Wed, 12 Aug 2026 08:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8216B010A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A642512033B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:42 +0000 (UTC)
X-FDA: 85092520884.17.48F08EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 16A2E4000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JkxTYDQC;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/HS6jeoNkCyji18aZKv6rudVAWLmw8SzAirPydXjGI=;
	b=uFvbnT6Ui6IBA07wv4/Nzj3abQSa8++/KDketr1ZHVeB/4cS7SnD9eGQEkug2eOuix8Wvb
	xsKwyVD2y85I1Ys9l0G2xHba2tZ+I31F8lCg7FQ6RaBCTVxH8as+cz8s+bL6PAX6yj2HPO
	K7yulQWbZ8MmQUaIL20D98XmGoeVVW8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537121;
	b=VtBgh3NcwIzFW2Xv4lkoCFQ2rX7Yx0HzUzuYmEQKW6KjGRJAsxbBerT8kGTE2tVf+ko3LT
	w8zzPNSoS5AqVQWV8YzUvChHjhSc5B75h71LNOQApp75HCHG1mUhc8OJmgOTUFeHq4iF9d
	/CRZLLiwnhN2+xA8GJyN1YOu5iP088o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JkxTYDQC;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66A6B40F14;
	Wed, 12 Aug 2026 12:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29271F000E9;
	Wed, 12 Aug 2026 12:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537120;
	bh=c/HS6jeoNkCyji18aZKv6rudVAWLmw8SzAirPydXjGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JkxTYDQCLOuxfjIVK740eZCL70XL0BrkAWHVF8LXo5EPShGtbz6Wlsgzcn9T8kzjh
	 8Zka2Q3iylt2GAX9xst0IU8Y/Rcx5fCLyE+KF005pPWfFdu8KtlUCNPFACO4dfA3DX
	 ElrwzhHLbC5iGlbsLcI4M8ojeYUzgn1Vc5w34z/tsQWKkpFUYbovv04YXLaUvBEN66
	 Nj3g34foMtUhtdisxEiU1aZD/VD73VXAj3c/YuOiYcaIWYZgBWnIgeWkUnRuO6WcIn
	 OMhxsX0gcoe/ZdgTA83FBiTH7O0XFRvPoa9WEpVx1EUbGFNZYcUNeCCVQK4RbqJaPy
	 ethfRhdyn/pcw==
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
Subject: [RFC PATCH v4 09/16] mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
Date: Wed, 12 Aug 2026 20:16:51 +0800
Message-Id: <20260812121658.69965-10-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xrxqhygi45f3tuur6fiu4z8jdp76am9w
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 16A2E4000C
X-HE-Tag: 1786537120-855675
X-HE-Meta: U2FsdGVkX1/341zxhpGsqel+MRl2MpcIrIrgWVSNNWAJbY6Ogw6sjQjJ+yhFPf2UcI33/euJ+wB66PirCRruwZzoMKp8PBQtN3agbxUxYeOaRoAn4xqJtyrMYNHlHo7QS8Stmi2Y+0O9RJVHn1btmAkhla2ArXeHWmiFmD4bfd4UUX4vIJbPt8i8rDldgYRjvDx5R71eCbCJrEe6z/SCPAOpZSmHwMIxXUiE/gJwxHm1gxdyfZDasNltJEMAnPbYLthYnnBGsSHhAdHU5e6ZA3g28fS5lri+1P++MUU67kUCt3mnFLj2Mhoo7F/dUDBouV9FhL7mV4kUYBqw/jtNET/Ft2JLi3ZVL2di/HBkezuNfar0OpDmZYPl2/ir4OmZxpsc9P5WG3RKj2pGT7vj6UaEWJ40CcD5DMiJA/Ca5ORax41fD/EGsVucOx6d5ttJ3/C1fFVpjyWt1PozNr59KbraZrFF6r96uEav0b1LCa2xNedvXU341334zOOIEbFF8zIer/tsQZeeRKwKYUlCQZujfCM3CPoZRve9F/a0QpRQdOuZZ8WCZ/7tFHPGu4ZGqmFOugcipLhh3B5cdvuYgOt3+85Y7udSZVAPFrv0JWPjrWnziLIsPKfRaJEx3NcARdDig5UqkiUoaKiI5GGor7fZODweMEJbf8vnMKmqtSu093PZYZs0c3pNRBaUa9bxombuVkJR/l9J0n6qKJyNCxdosepuxZQtJCISZ7g0b+nY/oe0yzlPlaYQchjFbkccJCZgNVpkOxW01jjqiEvWPNuHothg3HOtgXujcMtCVnFQdHiMV/9V/nzvpFBJDgOaQNRU9U+sfY7yQyMPr0c77E+oMlXdO6tvhFXMYnktD2cAeH5u14j1F+erX0ww6ScHzdjmn305Mh5EMMrshwzbe+/UOME6FAl+xFZnZYVN0ZLCPxL+t5xh9e6tZPxvMdaWv+oCuP2KjlNEB+fq1RJ
 J+kERyiT
 46/5dyizofe8pXtu9gX0jIq5QR9rPADtDtanpq1912A30HUH5CY5T/wIINM6yOpWL1eOTAIfIOCuAKNKbfEw0lrife4D1YEQRJFpFK5FWf50bArA6XWVakJfGjzm8U1Vx8NiuHDAZw0/ew8YQIQo/9ZNHExVoZ9kJ0NOjIGaG7BegAnnPhIwyeKfCKvf0nFv9RxgIJzpLTgGEkz8cIIkYpOZdrI9TatmI2maCg3k23v7IVPutNuBRW78q8X3vBUWaTq93xWQ9SnfmbUrHA0CT8e7vqJjhIZ/+x40+Jr6bMGHIlNYCv15acGuzGw==
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
index 27623d3bad95..17357b16d1a7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -190,8 +190,20 @@ struct scan_control {
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
@@ -3931,9 +3943,10 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
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
@@ -3944,6 +3957,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
+			prefetchw_next_lru_folio(folio, head, flags);
+			pos = pos->next;
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			if (gen_increased) {
 				delta += nr_pages;
-- 
2.34.1


