Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F449C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47ABE6B00C2; Fri, 31 Jul 2026 04:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4033F6B00C3; Fri, 31 Jul 2026 04:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1DD6B00C4; Fri, 31 Jul 2026 04:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E92586B00C2
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:39:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89B62A0348
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:11 +0000 (UTC)
X-FDA: 85048422102.10.A2D7726
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id F04B120007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:39:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vesdli7t;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785487150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGS47ujxTvtlq11ZCiBl4aLoPuUh0trV8PXbmmGJxG0=;
	b=m/jzZQYpQmIhXnBJz70BG6H4Wu8CNEjbNqw2pC040qaI2buPyS6fneQpnkXOtc/nBfogT9
	8ZaT6YljLi2WIyCscS7mwaYlptXw3wtFY06eledm/G+/N9EpTr3sAdF5FwXp0MNRX5NdzJ
	hQS36z/24rcI9hBoduo4Q3kOH5WcFGw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vesdli7t;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785487150;
	b=g4jhLV9RMRA8T2cTAH87U7fW4kFYYNwGcZo4CHmqbbmk+f/kEU3jS/yqhndkolBr3XYRHM
	Js03ifTo3/cl8Al3OKIVnuOzHTKbOXOjI2klap26rL0qVrk8uyT8iDg54fy4hLHq0uz/ZC
	HrhDg3UKhYtAZZnep5fv2B058+gTiPY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3008743C01;
	Fri, 31 Jul 2026 08:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A763C1F000E9;
	Fri, 31 Jul 2026 08:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785487149;
	bh=eGS47ujxTvtlq11ZCiBl4aLoPuUh0trV8PXbmmGJxG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vesdli7txUOZi8YTM10BgeOKsRiQZoXphJj+BNdln3V6vmaSIL625HyEuf7jV+/X9
	 FQWWXB2la+2QgphgyByXKbHDJLR9Fp9z5oB4Jdu2/xNmFGtFXsP4VKALXo5AEsV/U+
	 Ww7jaHzQg9vj7Oz4VOFtwm9/kzfETkxnuqZsKaHSlknJsD/K+u2ULirYN2DW3ew1bs
	 YRgcbdMpugr3k/TH05t/1fZcL3ekneYjW/DoqV225cjyRatdqafO5hKl4jNNq8lwow
	 TSb6PQzHJf6qC2Vj533l7IRPkffo02gyh2DsRIKp+lLEcqPMMSWJs76Le1LXkLXbn/
	 YY1dgcyZxN1dw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	weixugc@google.com,
	yuanchu@google.com,
	chenridong@xiaomi.com,
	zhangbo56@xiaomi.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v3 2/6] mm: mglru: let scan_folios() scan both reclaimable generations
Date: Fri, 31 Jul 2026 16:38:39 +0800
Message-Id: <20260731083843.37811-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260731083843.37811-1-baohua@kernel.org>
References: <20260731083843.37811-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F04B120007
X-Rspamd-Server: rspam01
X-Stat-Signature: irbnupdo4owdyky4tasg6bz7rzehgfc9
X-HE-Tag: 1785487149-634252
X-HE-Meta: U2FsdGVkX19nL+6lihniAEMxaNzpHSLyUol7Gt3R/O7KzVKeMHD7JfX5wFYR961yURAqVUGMsgJ6c7gGRxePjfB98CXK1MPi2s1hgJcbNAblD3tJ/A8Z9njoxSDqVlEZki6i85OwvmMenEsovlFyyYCD+26lwB0WgFcdd3ExqXgnO66iXCOdRXtdirqBoufuI7skN1HJFhQv3AFfP6Tm95LUVQaME/OIxhQMqzm5mlWVjQ/osd8i3Ioy4sGYOaGPRMpWkMonavk8CcmrgLBWPitPl3KtTNe6qacNlP5uScuUBqnVDygoD+e5zV1Ay+ws0t1Hs6rUZfb9GauHr+JTRlzqpvpv+FQgO/erLBtk+0s89kkvN+EylD1T5DJuydIWTd5RJSMnjlchPUFwjfrtUdYUkouIdgVFPmCUjjFvgEv4uWqQtQBceG9dsrDIsbGKg+Jmptt30vdAi2pX6Hqeo4hbvCjSXZd9TXaDqpSBmt6ptiI/wWrsVWyYr7KhSCnPPJ/a+3XWzSmRpKbxkmIfA+4vUjYqgwyv3kz0hcW1x3u2oXy76wvsSexzFOQcOvWMVj2umoNOXlEaGB2deWkqqx4tsqRcWXUyIyReobsWMBFvml1oONdAXRib3RVqXK+kSiycI+fmveBloUQeIwIO24sGxYAG3Ee4iCKUHJvg9pihE2CT0QOnTrzgYZYOWHGmXfuFJnVDGBE+yHVz53zZZEgOWkEnhBh002c5iYLefdk6c4fEZSJExXr0sRYNGx9Zzc2xhp5tgNZuarKa6WA2q/XrsSKLALL/rREBBUrc43s5Jvh8nSRf8NsVNe+J9HjTUODW5ZGuhWfT5bLXwIi3pYEsN5Qjo8ahnrrD2A5Zr1RNsN6Rizm7b7mUIWFYfsrWDI8ms9sOlDDV4ekaxfCe42kwGr0XWoPpVrX2XzeqsgBTj25WclaXxquIHJhsDAErNfYtNMuogEk4TuLSzza
 34kBnX1G
 Layuvc4yZrOmW0OJwRRyh6B4YtpGHrLFkZxYxeLQeOu1VyH4y2BNc5wJ9Snmd4rMoUFdWbw5JbU1z3X3gfE4bJ2IZfzMkG3cFdxEwUUUo4hiS3ALK70+zv8OPqBbU4mO7mUiSOHL2GvZPSrX0+2Qdf+SiprggS+skrErCQCeV0icWz+swuwBe3Yzm19kxWsMwjex7s/cuc04+DaxXbJvQ+XX1fgKf8Gg9CxkicAl+aFqr99fWaDr/AwuGHoH2CZraoM3iuZfDP827nrdxHy8RowDp2EIbNIfUq2W52XbDb4hwxSTWzcTz9DiRmPUNXxLlRv3KSsFddT8FfXXBhyuZ5HDHXn6ru386o4GyY6NCKMa6PNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we have four generations, and scan_folios() exhausts the oldest
one while the second-oldest still contains reclaimable folios, the
current implementation doesn't move on to scan the second-oldest
generation. Instead, it returns, leaving that generation with no
chance to be scanned at the current sc->priority.

This doesn't seem right. Rather than breaking out and starting a
larger next iteration, let's let scan_folios() continue scanning the
second-oldest generation directly.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ce027c271e9b..31947fa60f18 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4718,6 +4718,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int skipped = 0;
 	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	unsigned long min_seq = lrugen->min_seq[type];
 
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
@@ -4725,8 +4726,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
 		return 0;
 
-	gen = lru_gen_from_seq(lrugen->min_seq[type]);
-
+next_gen:
+	gen = lru_gen_from_seq(min_seq);
 	for (i = MAX_NR_ZONES; i > 0; i--) {
 		LIST_HEAD(moved);
 		int skipped_zone = 0;
@@ -4768,6 +4769,14 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			break;
 	}
 
+	/*
+	 * This generation is exhausted across all zones, but the scan
+	 * target has not been reached yet. Continue with the next
+	 * reclaimable generation.
+	 */
+	if (i == 0 && ++min_seq + MIN_NR_GENS <= lrugen->max_seq)
+		goto next_gen;
+
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, isolated);
 	mod_lruvec_state(lruvec, PGREFILL, sorted);
-- 
2.34.1


